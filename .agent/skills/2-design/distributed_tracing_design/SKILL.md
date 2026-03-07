---
name: Distributed Tracing Design
description: Designs end-to-end distributed tracing with context propagation, span conventions, sampling strategies, and performance budget enforcement
---

# Distributed Tracing Design Skill

**Purpose**: Produces a comprehensive Distributed Tracing Design Document that specifies how trace context propagates across services, queues, and async boundaries. This skill goes deeper than the tracing section in observability_architecture_design -- it handles the implementation-level decisions needed to make distributed tracing work correctly across a heterogeneous system.

## TRIGGER COMMANDS

```text
"Design distributed tracing for [system]"
"Plan trace propagation across services"
"How should we trace requests through [architecture]?"
"Set up cross-service correlation"
```

## When to Use
- After observability_architecture_design selects the tracing stack
- When the system has 3+ services communicating over network boundaries
- When debugging cross-service issues is slow due to missing correlation
- Before implementing any tracing SDK integration in Phase 3
- When migrating from single-service tracing to distributed tracing

---

## PROCESS

### Step 1: Map Service Communication Topology

Document every communication path that traces must follow:

```markdown
## Service Communication Map

### Synchronous (Request-Response)
| Source | Target | Protocol | Auth | Notes |
|--------|--------|----------|------|-------|
| API Gateway | User Service | HTTP/REST | JWT | Route: /api/users/* |
| API Gateway | Order Service | HTTP/REST | JWT | Route: /api/orders/* |
| Order Service | Payment Service | gRPC | mTLS | ChargeService/Charge |
| Order Service | Inventory Service | HTTP/REST | API Key | Internal only |

### Asynchronous (Event-Driven)
| Publisher | Queue/Topic | Consumer(s) | Protocol | Notes |
|-----------|-------------|-------------|----------|-------|
| Order Service | order-events | Notification Service | AMQP/RabbitMQ | Fanout |
| Order Service | order-events | Analytics Service | Kafka | Consumer group |
| Payment Service | payment-results | Order Service | AMQP/RabbitMQ | Direct |

### Scheduled/Batch
| Job | Trigger | Services Called | Notes |
|-----|---------|-----------------|-------|
| Daily Report | Cron 02:00 UTC | Analytics, Export | No parent trace |
| Retry Queue | Every 5 min | Payment Service | Links to original trace |
```

### Step 2: Select Trace Context Propagation Standard

#### W3C TraceContext (Recommended Default)

```
HTTP Headers:
  traceparent: 00-{trace-id}-{parent-id}-{trace-flags}
  tracestate: vendor1=value1,vendor2=value2

Example:
  traceparent: 00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01
  tracestate: rojo=00f067aa0ba902b7,congo=t61rcWkgMzE
```

**Fields**:
- `trace-id`: 32 hex chars (16 bytes), globally unique per trace
- `parent-id`: 16 hex chars (8 bytes), unique per span
- `trace-flags`: `01` = sampled, `00` = not sampled

#### B3 (Legacy/Zipkin Compatibility Only)

```
HTTP Headers (multi-header format):
  X-B3-TraceId: {trace-id}
  X-B3-SpanId: {span-id}
  X-B3-ParentSpanId: {parent-span-id}
  X-B3-Sampled: 1

HTTP Headers (single-header format):
  b3: {trace-id}-{span-id}-{sampling-state}-{parent-span-id}
```

**Decision Criteria**:

| Factor | W3C TraceContext | B3 |
|--------|-----------------|-----|
| Industry standard | Yes (W3C spec) | De facto (Zipkin era) |
| OTel native support | First-class | Supported via propagator |
| Multi-vendor `tracestate` | Yes | No |
| Existing Zipkin infra | Requires bridge | Native |

**Selection**: Use W3C TraceContext unless integrating with legacy Zipkin that cannot be upgraded. If both are needed, configure dual propagation in the OpenTelemetry SDK.

### Step 3: Define Propagation for Each Transport

Trace context does not magically cross service boundaries. Each transport requires explicit propagation.

#### 3a. HTTP / REST

```
Propagation: HTTP headers (automatic with OTel HTTP instrumentation)
Headers: traceparent, tracestate
Implementation: OTel SDK auto-instrumentation handles this for most frameworks
Manual override: Only needed for custom HTTP clients not covered by auto-instrumentation
```

#### 3b. gRPC

```
Propagation: gRPC metadata (automatic with OTel gRPC instrumentation)
Metadata keys: traceparent, tracestate
Implementation: OTel gRPC interceptors (client + server)
Note: Binary propagation format available for efficiency but text format is interoperable
```

#### 3c. Message Queues (RabbitMQ, Kafka, SQS)

```
Propagation: Message headers/attributes (REQUIRES explicit instrumentation)
- RabbitMQ: AMQP message headers
- Kafka: Kafka record headers
- SQS: Message attributes (max 10, trace context counts as 1-2)

Critical: Create a PRODUCER span when publishing and a CONSUMER span when consuming.
Link them using span links (not parent-child) for fan-out patterns.

Example (Kafka):
  Producer span: "order-events publish" (kind: PRODUCER)
  Consumer span: "order-events consume" (kind: CONSUMER, linked to producer span)
```

#### 3d. Scheduled Jobs / Cron

```
Propagation: No inbound context -- create a new root span
Span: "{job-name} execute" (kind: INTERNAL)
Attribute: job.schedule = "0 2 * * *"
Attribute: job.run_id = "{unique-run-id}"

If the job retries a previous operation, use span LINKS to connect to the original trace
rather than making it a child span (the original trace may be completed/expired).
```

#### 3e. WebSockets / Server-Sent Events

```
Propagation: Inject trace context during connection handshake (HTTP upgrade headers)
Subsequent messages: Include trace_id in message payload or frame header
New span per logical operation: "ws.{event_type}" (e.g., "ws.chat_message")
```

### Step 4: Define Span Naming and Attribution

#### 4a. Span Naming Convention

Span names MUST be low-cardinality (not contain IDs, query strings, or request bodies).

| Communication Type | Span Name Pattern | Good Example | Bad Example |
|-------------------|-------------------|--------------|-------------|
| HTTP server | `HTTP {METHOD} {route_template}` | `HTTP GET /api/orders/:id` | `HTTP GET /api/orders/abc123` |
| HTTP client | `{target_service} {METHOD} {route}` | `payment-svc POST /charge` | `POST https://pay.example.com/charge?amt=50` |
| Database | `{db_system} {operation} {table}` | `postgres SELECT orders` | `postgres SELECT * FROM orders WHERE id='abc'` |
| Cache | `{cache_system} {operation}` | `redis GET` | `redis GET user:abc123:profile` |
| Queue produce | `{queue_name} publish` | `order-events publish` | `publish message to order-events with payload {...}` |
| Queue consume | `{queue_name} consume` | `order-events consume` | - |
| gRPC | `{package}.{Service}/{Method}` | `payment.v1.PaymentService/Charge` | - |
| Internal function | `{module}.{function}` | `OrderProcessor.validate` | Only for significant operations (> 1ms) |

#### 4b. Required Span Attributes

Every span MUST include these semantic attributes (following OpenTelemetry Semantic Conventions):

```markdown
## All Spans
- service.name: Name of the service producing the span
- service.version: Deployed version (git SHA or semver)
- deployment.environment: production | staging | development

## HTTP Spans
- http.request.method: GET, POST, etc.
- url.path: /api/orders/:id (template, not actual)
- http.response.status_code: 200, 404, 500
- server.address: Target hostname (client spans)

## Database Spans
- db.system: postgresql, mysql, redis, mongodb
- db.operation.name: SELECT, INSERT, UPDATE, DELETE
- db.collection.name: Table or collection name
- db.namespace: Database/schema name

## Messaging Spans
- messaging.system: rabbitmq, kafka, sqs
- messaging.destination.name: Queue or topic name
- messaging.operation.type: publish, receive, process

## Error Spans
- error.type: Exception class name
- exception.message: Error message (PII-redacted)
- exception.stacktrace: Stack trace (truncated to 4KB)
```

#### 4c. Span Status Rules

| Condition | Span Status | Record Exception? |
|-----------|-------------|-------------------|
| HTTP 2xx | `UNSET` | No |
| HTTP 4xx (client error) | `UNSET` | No (not a server fault) |
| HTTP 5xx (server error) | `ERROR` | Yes |
| Unhandled exception | `ERROR` | Yes |
| Handled/expected error (e.g., "user not found") | `UNSET` | No |
| Timeout | `ERROR` | Yes |

### Step 5: Design Sampling Strategy

#### 5a. Head-Based Sampling

Decision made at trace creation, before any processing:

```markdown
## Head-Based Sampling Configuration

| Environment | Sample Rate | Config |
|-------------|-------------|--------|
| Development | 100% | AlwaysOn sampler |
| Staging | 100% | AlwaysOn sampler |
| Production (< 1K rps) | 100% | AlwaysOn sampler |
| Production (1K-10K rps) | 10% | TraceIdRatio(0.10) |
| Production (> 10K rps) | 1% | TraceIdRatio(0.01) |

Pros: Simple, low overhead, deterministic
Cons: May miss rare errors, no retroactive decisions
```

#### 5b. Tail-Based Sampling

Decision made AFTER the trace completes (requires collector-level buffering):

```markdown
## Tail-Based Sampling Rules (OTel Collector)

1. Always keep: status_code >= 500
2. Always keep: duration > p99_threshold (e.g., > 2000ms)
3. Always keep: contains span attribute "priority=high"
4. Probabilistic: keep 5% of remaining traces
5. Rate limit: max 100 traces/second to backend

Pros: Keeps all interesting traces, smart filtering
Cons: Requires collector buffering (memory), adds latency to trace export
```

#### 5c. Recommended Hybrid Approach

```
Service SDK (head-based): Sample at 100% -- send all spans to collector
OTel Collector (tail-based): Apply smart filtering before export to backend

This gives tail-based benefits without SDK-level complexity.
Memory budget for collector: ~500MB per 10K spans/second buffered for 30s
```

### Step 6: Measure Performance Impact

Distributed tracing MUST stay within a performance budget:

```markdown
## Performance Impact Budget

| Component | Budget | Measurement Method |
|-----------|--------|--------------------|
| Span creation overhead | < 1 microsecond per span | Microbenchmark |
| Context propagation (inject/extract) | < 5 microseconds per boundary | Microbenchmark |
| Total request latency overhead | < 2% of p99 latency | A/B load test |
| Memory per active span | ~300 bytes | SDK documentation |
| Export batch size | 512 spans per batch | OTel SDK config |
| Export interval | 5 seconds | OTel SDK config |
| Collector CPU overhead | < 0.5 CPU cores per 10K spans/sec | Load test |

## Validation Plan
1. Run load test WITHOUT tracing --> record p50, p95, p99
2. Run load test WITH tracing at 100% sampling --> record p50, p95, p99
3. Delta must be < 2% at p99
4. If exceeded: reduce auto-instrumented libraries, increase export batch interval
```

### Step 7: Design Trace Storage and Retention

```markdown
## Trace Retention Policy

| Trace Type | Retention (Hot) | Retention (Cold) | Rationale |
|------------|-----------------|------------------|-----------|
| Error traces | 30 days | 90 days | Post-incident analysis |
| Slow traces (> p99) | 14 days | 60 days | Performance debugging |
| Normal traces | 7 days | None | Cost optimization |
| Audit-relevant traces | 30 days | 1 year | Compliance |

## Storage Sizing Estimate
- Avg spans per trace: [X]
- Avg span size: ~500 bytes (with attributes)
- Traces per day (after sampling): [X]
- Daily storage: [X] GB
- Monthly storage (hot): [X] GB x $[X]/GB = $[X]
- Monthly storage (cold): [X] GB x $[X]/GB = $[X]
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/distributed-tracing-design.md`

The output document should follow this structure:
1. Service Communication Topology (from Step 1)
2. Propagation Standard Selection (from Step 2)
3. Transport-Specific Propagation Rules (from Step 3)
4. Span Naming and Attribution Conventions (from Step 4)
5. Sampling Strategy (from Step 5)
6. Performance Impact Budget and Validation Plan (from Step 6)
7. Storage and Retention Policy (from Step 7)
8. Implementation Checklist: per-service instrumentation order

---

## CHECKLIST

- [ ] Service communication map covers all sync, async, and batch paths
- [ ] Trace propagation standard selected (W3C TraceContext recommended)
- [ ] Propagation method defined for each transport (HTTP, gRPC, queues, WebSocket, cron)
- [ ] Message queue tracing uses span links (not parent-child) for fan-out
- [ ] Span naming convention documented with good/bad examples
- [ ] Span names are low-cardinality (no IDs, no query params)
- [ ] Required span attributes defined per communication type (OTel semantic conventions)
- [ ] Span status rules documented (4xx = UNSET, 5xx = ERROR)
- [ ] Sampling strategy defined per environment
- [ ] Error traces and slow traces are always captured (100%) regardless of sampling rate
- [ ] Tail-based sampling rules defined at collector level
- [ ] Performance impact budget set (< 2% p99 latency overhead)
- [ ] Validation plan: A/B load test with and without tracing
- [ ] Trace retention policy defined per trace type (error, slow, normal, audit)
- [ ] Storage cost estimated (hot + cold tiers)
- [ ] Trace-to-log correlation confirmed (trace_id/span_id in structured logs)
- [ ] Downstream phase linkage: Phase 3 (SDK integration), Phase 4 (tracing validation tests), Phase 7 (trace-based SLO monitoring)

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
