---
name: Observability Architecture Design
description: Designs the three pillars of observability (logs, metrics, traces) with tool selection, cost modeling, and a unified telemetry architecture decision record
---

# Observability Architecture Design Skill

**Purpose**: Produces a complete Observability Architecture Decision Record covering logging, metrics, and tracing strategies with concrete tool selections, cost projections, and integration patterns. This skill ensures telemetry is designed as a first-class concern before implementation begins -- not bolted on after production incidents reveal blind spots.

## TRIGGER COMMANDS

```text
"Design observability for [system]"
"Plan logging and monitoring architecture"
"Choose observability stack"
"How should we instrument [service]?"
```

## When to Use
- After ARA (Atomic Reverse Architecture) defines the system decomposition
- Before implementation begins (Phase 3) so instrumentation is built-in, not retrofitted
- When migrating from ad-hoc logging to structured observability
- When evaluating commercial vs open-source observability tooling
- Before cost_architecture skill to feed telemetry cost estimates

---

## PROCESS

### Step 1: Assess Observability Requirements

Gather inputs that shape the observability strategy:

```markdown
## Observability Requirements Assessment

**System**: [name]
**Architecture Style**: [monolith | modular monolith | microservices | serverless | hybrid]
**Service Count**: [N] services / [N] expected within 12 months
**Environment Count**: [dev | staging | production | ...]
**Traffic Profile**: [steady | spiky | batch | event-driven]
**Compliance**: [SOC2 | HIPAA | PCI-DSS | GDPR | none]
**Existing Tooling**: [list current tools or "greenfield"]
**Team Size**: [N] engineers on-call
**Budget Constraint**: [$X/month or "optimize for cost" | "optimize for capability"]
```

### Step 2: Design Logging Strategy

#### 2a. Structured vs Unstructured

**Default: Structured JSON logging.** Unstructured plaintext logs are only acceptable for local development output.

```json
{
  "timestamp": "2025-03-15T14:23:01.456Z",
  "level": "error",
  "service": "order-service",
  "version": "1.4.2",
  "trace_id": "a1b2c3d4e5f6",
  "span_id": "f6e5d4c3b2a1",
  "correlation_id": "usr_req_abc123",
  "message": "Payment processing failed",
  "error": {
    "type": "PaymentGatewayTimeout",
    "message": "Gateway response exceeded 5000ms",
    "stack": "..."
  },
  "context": {
    "user_id": "REDACTED",
    "order_id": "ord_789",
    "amount_cents": 4999
  }
}
```

#### 2b. Log Levels

Define what each level means for your system -- remove ambiguity:

| Level | When to Use | Alert? | Example |
|-------|-------------|--------|---------|
| `FATAL` | Process cannot continue, requires restart | Page on-call | Database connection pool exhausted |
| `ERROR` | Operation failed, requires investigation | Ticket / alert | Payment charge failed after retries |
| `WARN` | Degraded but functional, may become error | Monitor trend | Cache miss rate above 30% |
| `INFO` | Normal business events worth recording | No | Order placed, user logged in |
| `DEBUG` | Diagnostic detail for troubleshooting | No (dev/staging only) | SQL query parameters, cache hit/miss |

**Rule**: Production should run at `INFO` level. `DEBUG` is enabled per-service via runtime config, never globally.

#### 2c. Correlation IDs

Every inbound request MUST receive a correlation ID that propagates through all downstream calls:

```
External Request --> API Gateway (generates correlation_id if absent)
  --> Service A (propagates via X-Correlation-ID header)
    --> Service B (propagates via X-Correlation-ID header)
    --> Message Queue (propagates via message metadata)
      --> Worker (reads from message metadata)
```

**Implementation**: Use middleware/interceptor at the API gateway layer. If the inbound request already carries `X-Correlation-ID` or `X-Request-ID`, preserve it. Otherwise, generate a UUID v4.

#### 2d. PII Redaction

Define a PII redaction strategy BEFORE writing any log statements:

| Data Type | Redaction Strategy | Example |
|-----------|--------------------|---------|
| Email | Hash or mask | `n***@example.com` or SHA-256 |
| Phone | Last 4 digits | `***-***-1234` |
| SSN/Tax ID | Never log | `REDACTED` |
| IP Address | Depends on compliance | Full (non-GDPR) or masked |
| Auth tokens | Never log | `REDACTED` |
| Credit card | Never log | `REDACTED` |
| User names | Context-dependent | Full or first initial |

**Implementation**: Use a log sanitizer that runs BEFORE log serialization. Do not rely on developers to remember redaction per log call.

#### 2e. Log Retention

| Environment | Retention | Storage Tier |
|-------------|-----------|--------------|
| Production | 30-90 days hot, 1 year cold | Object storage (S3/GCS) |
| Staging | 14 days | Hot only |
| Development | 3 days | Local / ephemeral |
| Audit logs | 7 years (compliance) | Immutable cold storage |

### Step 3: Design Metrics Strategy

#### 3a. Choose a Metrics Framework

Select one primary framework based on system type:

| Framework | Best For | Core Metrics |
|-----------|----------|-------------|
| **RED** (Rate, Errors, Duration) | Request-driven services (APIs, web) | Request rate, error rate, response time |
| **USE** (Utilization, Saturation, Errors) | Resource-oriented systems (infra, DBs) | CPU/mem utilization, queue depth, error count |
| **Four Golden Signals** (Latency, Traffic, Errors, Saturation) | Google SRE hybrid | Combines RED + USE perspectives |

**Recommendation**: Use RED for application services, USE for infrastructure, Four Golden Signals for the overall dashboard.

#### 3b. Standard Application Metrics

Every service MUST expose these baseline metrics:

```markdown
## Request Metrics (RED)
- `http_requests_total` (counter) -- labels: method, path, status_code
- `http_request_duration_seconds` (histogram) -- labels: method, path
- `http_request_errors_total` (counter) -- labels: method, path, error_type

## Runtime Metrics
- `process_cpu_seconds_total` (counter)
- `process_resident_memory_bytes` (gauge)
- `process_open_fds` (gauge)

## Dependency Metrics
- `dependency_request_duration_seconds` (histogram) -- labels: dependency, operation
- `dependency_errors_total` (counter) -- labels: dependency, error_type
- `connection_pool_active` (gauge) -- labels: pool_name
- `connection_pool_idle` (gauge) -- labels: pool_name
```

#### 3c. Custom Business Metrics

Define metrics that map directly to business outcomes:

```markdown
## Business Metrics (examples)
- `orders_placed_total` (counter) -- labels: plan_type, source
- `revenue_cents_total` (counter) -- labels: currency, product
- `user_signups_total` (counter) -- labels: source, plan
- `ai_inference_duration_seconds` (histogram) -- labels: model, operation
- `queue_depth` (gauge) -- labels: queue_name
- `cache_hit_ratio` (gauge) -- labels: cache_name
```

**Rule**: Every business KPI mentioned in the PRD should have a corresponding metric.

#### 3d. Metric Aggregation Windows

| Window | Use Case | Storage Cost |
|--------|----------|-------------|
| 15s raw | Real-time dashboards, alerting | High |
| 1m downsampled | Standard dashboards | Medium |
| 5m downsampled | Trend analysis | Low |
| 1h rollups | Capacity planning (90+ days) | Minimal |

### Step 4: Design Tracing Strategy

#### 4a. Trace Propagation Standard

**Default: W3C TraceContext** (`traceparent` / `tracestate` headers). Use B3 only if integrating with legacy Zipkin infrastructure.

```
traceparent: 00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01
             ^version  ^trace-id                    ^parent-id         ^flags
```

#### 4b. Span Naming Convention

| Communication | Pattern | Example |
|---------------|---------|---------|
| HTTP inbound | `HTTP {METHOD} {route}` | `HTTP GET /api/orders/:id` |
| HTTP outbound | `{service} HTTP {METHOD} {route}` | `payment-svc HTTP POST /charge` |
| Database | `{db_type} {operation} {table}` | `postgres SELECT orders` |
| Queue publish | `{queue} publish` | `order-events publish` |
| Queue consume | `{queue} consume` | `order-events consume` |
| gRPC | `{package}.{service}/{method}` | `payments.ChargeService/Charge` |

#### 4c. Sampling Strategy

| Environment | Strategy | Rate | Rationale |
|-------------|----------|------|-----------|
| Development | Sample all | 100% | Full visibility |
| Staging | Sample all | 100% | Full visibility |
| Production (< 1K rps) | Sample all | 100% | Affordable at this volume |
| Production (1K-10K rps) | Head-based probabilistic | 10-25% | Cost control |
| Production (> 10K rps) | Tail-based adaptive | 1-5% + all errors | Keep all interesting traces |

**Rule**: Always capture 100% of error traces and traces exceeding the p99 latency threshold, regardless of sampling rate.

#### 4d. Trace-to-Log Correlation

Inject `trace_id` and `span_id` into every log entry (shown in Step 2a). This allows querying: "Show me all logs for trace `a1b2c3d4e5f6`."

### Step 5: Select Observability Tooling

Evaluate and select tools for each pillar:

```markdown
## Tool Selection Matrix

| Pillar | Open-Source Option | Commercial Option | Selection | Justification |
|--------|--------------------|-------------------|-----------|---------------|
| **Logs** | Grafana Loki | Datadog Logs / Splunk | [choice] | [why] |
| **Metrics** | Prometheus + Grafana | Datadog Metrics / New Relic | [choice] | [why] |
| **Traces** | Grafana Tempo / Jaeger | Datadog APM / Honeycomb | [choice] | [why] |
| **Collector** | OpenTelemetry Collector | Datadog Agent | [choice] | [why] |
| **Dashboards** | Grafana | Datadog / New Relic | [choice] | [why] |
| **Alerting** | Grafana Alerting / Alertmanager | PagerDuty / OpsGenie | [choice] | [why] |

## Common Stack Patterns

### Pattern A: Full Open-Source (Grafana Stack)
OpenTelemetry SDK --> OTel Collector --> Loki (logs) + Prometheus (metrics) + Tempo (traces)
Dashboards: Grafana | Alerting: Alertmanager + PagerDuty
Cost: Infrastructure only (~$200-800/mo for moderate traffic)

### Pattern B: Full Commercial (Datadog)
Datadog SDK/Agent --> Datadog (logs + metrics + traces + dashboards + alerting)
Cost: Per-host pricing (~$23-33/host/mo + log volume)

### Pattern C: Hybrid
OpenTelemetry SDK --> OTel Collector --> Datadog (or any backend)
Benefit: Vendor-portable instrumentation, swap backends without code changes
```

**Recommendation**: Always use OpenTelemetry SDKs for instrumentation regardless of backend choice. This avoids vendor lock-in at the code level.

### Step 6: Model Telemetry Costs

Estimate monthly costs before committing to a stack:

```markdown
## Cost Model

### Log Volume Estimate
- Services: [N]
- Avg log lines per request: [X]
- Requests per day: [X]
- Avg log line size: [X] bytes
- **Daily log volume**: [X] GB/day
- **Monthly log volume**: [X] GB/month
- **Storage cost** (hot 30d + cold 11mo): $[X]/month

### Metric Volume Estimate
- Unique time series: [N] (services x metrics x label cardinality)
- Scrape interval: 15s
- **Monthly data points**: [X]
- **Storage cost**: $[X]/month

### Trace Volume Estimate
- Traces per day: [X] (requests x sampling rate)
- Avg spans per trace: [X]
- Avg span size: [X] bytes
- **Monthly trace volume**: [X] GB/month
- **Storage cost**: $[X]/month

### Total Monthly Cost
| Component | Cost |
|-----------|------|
| Log ingestion + storage | $[X] |
| Metric storage + queries | $[X] |
| Trace ingestion + storage | $[X] |
| Infrastructure (collector, storage nodes) | $[X] |
| Commercial licensing (if applicable) | $[X] |
| **Total** | **$[X]/month** |
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/observability-architecture-adr.md`

The output document should follow this structure:
1. Observability Requirements Assessment (from Step 1)
2. Logging Strategy (from Step 2)
3. Metrics Strategy (from Step 3)
4. Tracing Strategy (from Step 4)
5. Tool Selection with justification (from Step 5)
6. Cost Model (from Step 6)
7. Implementation Roadmap: which services to instrument first, rollout order

---

## CHECKLIST

- [ ] Requirements assessment completed (architecture style, service count, compliance, budget)
- [ ] Logging strategy defined: structured JSON, log levels documented, correlation IDs planned
- [ ] PII redaction strategy defined with per-data-type rules
- [ ] Log retention policy set per environment and compliance tier
- [ ] Metrics framework chosen (RED/USE/Golden Signals) with justification
- [ ] Standard application metrics defined (request, runtime, dependency)
- [ ] Custom business metrics mapped to PRD KPIs
- [ ] Tracing propagation standard selected (W3C TraceContext recommended)
- [ ] Span naming conventions documented
- [ ] Sampling strategy defined per environment with error-trace override
- [ ] Trace-to-log correlation confirmed (trace_id in log entries)
- [ ] Tool selection matrix completed with cost comparison
- [ ] OpenTelemetry SDKs chosen for instrumentation layer (vendor portability)
- [ ] Monthly telemetry cost model estimated (logs + metrics + traces)
- [ ] Implementation rollout order defined (critical path services first)
- [ ] Downstream phase linkage: Phase 3 (instrumentation), Phase 6 (dashboards), Phase 7 (SLO monitoring)

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
