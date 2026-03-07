---
name: opentelemetry_implementation
description: OpenTelemetry SDK setup for distributed tracing, metrics, and log correlation across Node.js, Python, and Go services
---

# OpenTelemetry Implementation Skill

**Purpose**: Instrument applications with OpenTelemetry for vendor-neutral distributed tracing, metrics collection, and log correlation. Get full visibility into request flows across microservices without locking into any single observability backend.

> [!IMPORTANT]
> **Vendor-Neutral Observability**: OTel is the CNCF standard. Instrument once, export to any backend (Jaeger, Datadog, Grafana, etc.).

## TRIGGER COMMANDS

```text
"Add OpenTelemetry to [service]"
"Setup distributed tracing"
"Implement OTel metrics for [project]"
"Configure trace propagation"
"Setup OpenTelemetry Collector"
"Using opentelemetry_implementation skill: instrument [component]"
```

## When to Use

- Adding distributed tracing to a microservices architecture
- Replacing vendor-specific SDKs (Datadog agent, New Relic) with OTel
- Correlating logs with trace context across services
- Setting up metrics pipelines with Prometheus-compatible instruments
- Configuring the OpenTelemetry Collector for production
- Debugging cross-service latency or error propagation

---

## PART 1: ARCHITECTURE OVERVIEW

```
Application (SDK)          Collector              Backends
┌──────────────┐      ┌──────────────────┐    ┌────────────┐
│ Traces       │─────>│ Receivers        │───>│ Jaeger     │
│ Metrics      │─────>│ Processors       │───>│ Prometheus │
│ Logs         │─────>│ Exporters        │───>│ Loki       │
└──────────────┘      └──────────────────┘    │ Datadog    │
   OTLP (gRPC/HTTP)     Batching, Sampling     │ Tempo      │
                                               └────────────┘
```

### Key Concepts

| Concept | What It Does |
|---------|-------------|
| **Span** | Single unit of work (e.g., HTTP request, DB query) |
| **Trace** | Tree of spans representing a full request flow |
| **Context Propagation** | Passing trace IDs across service boundaries (W3C TraceContext) |
| **Metric Instrument** | Counter, Histogram, Gauge, UpDownCounter |
| **Resource** | Metadata about the service (name, version, environment) |
| **Exporter** | Sends telemetry to a backend (OTLP, Jaeger, Prometheus) |

---

## PART 2: NODE.JS / NESTJS SETUP

### Auto-Instrumentation (Recommended Starting Point)

```bash
npm install @opentelemetry/sdk-node \
  @opentelemetry/auto-instrumentations-node \
  @opentelemetry/exporter-trace-otlp-grpc \
  @opentelemetry/exporter-metrics-otlp-grpc \
  @opentelemetry/sdk-metrics
```

```typescript
// tracing.ts — MUST be imported before anything else
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';
import { OTLPTraceExporter } from '@opentelemetry/exporter-trace-otlp-grpc';
import { OTLPMetricExporter } from '@opentelemetry/exporter-metrics-otlp-grpc';
import { PeriodicExportingMetricReader } from '@opentelemetry/sdk-metrics';
import { Resource } from '@opentelemetry/resources';
import { ATTR_SERVICE_NAME, ATTR_SERVICE_VERSION } from '@opentelemetry/semantic-conventions';

const sdk = new NodeSDK({
  resource: new Resource({
    [ATTR_SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || 'my-service',
    [ATTR_SERVICE_VERSION]: process.env.npm_package_version || '0.0.0',
    'deployment.environment': process.env.NODE_ENV || 'development',
  }),

  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317',
  }),

  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317',
    }),
    exportIntervalMillis: 15000,
  }),

  instrumentations: [
    getNodeAutoInstrumentations({
      // Disable noisy fs instrumentation
      '@opentelemetry/instrumentation-fs': { enabled: false },
      '@opentelemetry/instrumentation-http': {
        ignoreIncomingPaths: ['/health', '/metrics', '/ready'],
      },
    }),
  ],
});

sdk.start();

// Graceful shutdown
process.on('SIGTERM', () => sdk.shutdown());
```

```typescript
// main.ts — Import tracing FIRST
import './tracing';  // <-- Must be first import
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(3000);
}
bootstrap();
```

### Manual Span Creation

```typescript
import { trace, SpanStatusCode, context } from '@opentelemetry/api';

const tracer = trace.getTracer('order-service');

@Injectable()
export class OrderService {
  async createOrder(userId: string, dto: CreateOrderDto) {
    return tracer.startActiveSpan('order.create', async (span) => {
      try {
        span.setAttribute('user.id', userId);
        span.setAttribute('order.item_count', dto.items.length);

        const order = await this.prisma.order.create({ data: { ... } });

        span.setAttribute('order.id', order.id);
        span.setAttribute('order.total_cents', order.total);
        span.setStatus({ code: SpanStatusCode.OK });

        return order;
      } catch (error) {
        span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
        span.recordException(error);
        throw error;
      } finally {
        span.end();
      }
    });
  }

  async processPayment(orderId: string, amount: number) {
    // Nested span — automatically becomes child of active span
    return tracer.startActiveSpan('order.process_payment', async (span) => {
      span.setAttribute('payment.amount_cents', amount);
      span.setAttribute('payment.currency', 'USD');

      try {
        const result = await this.paymentGateway.charge(orderId, amount);
        span.setAttribute('payment.transaction_id', result.id);
        span.setStatus({ code: SpanStatusCode.OK });
        return result;
      } catch (error) {
        span.setStatus({ code: SpanStatusCode.ERROR, message: error.message });
        span.recordException(error);
        throw error;
      } finally {
        span.end();
      }
    });
  }
}
```

### Custom Metrics in Node.js

```typescript
import { metrics } from '@opentelemetry/api';

const meter = metrics.getMeter('order-service');

// Counter — monotonically increasing (total orders, total errors)
const ordersCreated = meter.createCounter('orders.created', {
  description: 'Total number of orders created',
  unit: '1',
});

// Histogram — distribution of values (latency, payment amounts)
const paymentDuration = meter.createHistogram('payment.duration', {
  description: 'Payment processing duration',
  unit: 'ms',
});

// UpDownCounter — can increase or decrease (active connections, queue depth)
const activeJobs = meter.createUpDownCounter('jobs.active', {
  description: 'Number of active background jobs',
});

// Gauge (via observable) — point-in-time value (memory usage, pool size)
meter.createObservableGauge('db.pool.size', {
  description: 'Database connection pool size',
}).addCallback((result) => {
  result.observe(pool.totalCount, { 'db.system': 'postgresql' });
});

// Usage in service
ordersCreated.add(1, { 'order.type': 'standard', 'order.channel': 'web' });
paymentDuration.record(durationMs, { 'payment.provider': 'stripe' });
activeJobs.add(1);   // job started
activeJobs.add(-1);  // job completed
```

---

## PART 3: PYTHON / DJANGO SETUP

### Auto-Instrumentation

```bash
pip install opentelemetry-distro opentelemetry-exporter-otlp
opentelemetry-bootstrap -a install  # Auto-detect and install instrumentations
```

```python
# otel_setup.py
from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.resources import Resource, SERVICE_NAME, SERVICE_VERSION
from opentelemetry.instrumentation.django import DjangoInstrumentor
from opentelemetry.instrumentation.psycopg2 import Psycopg2Instrumentor
from opentelemetry.instrumentation.requests import RequestsInstrumentor
import os

def configure_otel():
    resource = Resource.create({
        SERVICE_NAME: os.getenv("OTEL_SERVICE_NAME", "django-service"),
        SERVICE_VERSION: os.getenv("APP_VERSION", "0.0.0"),
        "deployment.environment": os.getenv("DJANGO_ENV", "development"),
    })

    # Traces
    trace_provider = TracerProvider(resource=resource)
    trace_provider.add_span_processor(
        BatchSpanProcessor(OTLPSpanExporter(
            endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317"),
            insecure=True,
        ))
    )
    trace.set_tracer_provider(trace_provider)

    # Metrics
    metric_reader = PeriodicExportingMetricReader(
        OTLPMetricExporter(
            endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317"),
            insecure=True,
        ),
        export_interval_millis=15000,
    )
    metrics.set_meter_provider(MeterProvider(resource=resource, metric_readers=[metric_reader]))

    # Auto-instrument
    DjangoInstrumentor().instrument()
    Psycopg2Instrumentor().instrument()
    RequestsInstrumentor().instrument()
```

```python
# wsgi.py or manage.py — Call configure_otel() before Django starts
from otel_setup import configure_otel
configure_otel()

import django
django.setup()
```

### Manual Spans in Python

```python
from opentelemetry import trace

tracer = trace.get_tracer("order-service")

class OrderService:
    def create_order(self, user_id: str, items: list):
        with tracer.start_as_current_span("order.create") as span:
            span.set_attribute("user.id", user_id)
            span.set_attribute("order.item_count", len(items))

            order = Order.objects.create(user_id=user_id, items=items)

            span.set_attribute("order.id", str(order.id))
            span.set_status(trace.StatusCode.OK)
            return order
```

---

## PART 4: GO SETUP

```bash
go get go.opentelemetry.io/otel \
  go.opentelemetry.io/otel/sdk/trace \
  go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc \
  go.opentelemetry.io/otel/sdk/metric \
  go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp
```

```go
// otel.go
package main

import (
    "context"
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
    sdktrace "go.opentelemetry.io/otel/sdk/trace"
    "go.opentelemetry.io/otel/sdk/resource"
    semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
)

func initTracer(ctx context.Context) (*sdktrace.TracerProvider, error) {
    exporter, err := otlptracegrpc.New(ctx,
        otlptracegrpc.WithEndpoint("localhost:4317"),
        otlptracegrpc.WithInsecure(),
    )
    if err != nil {
        return nil, err
    }

    tp := sdktrace.NewTracerProvider(
        sdktrace.WithBatcher(exporter),
        sdktrace.WithResource(resource.NewWithAttributes(
            semconv.SchemaURL,
            semconv.ServiceNameKey.String("go-service"),
            semconv.ServiceVersionKey.String("1.0.0"),
        )),
    )

    otel.SetTracerProvider(tp)
    return tp, nil
}
```

```go
// Using spans in Go
package order

import (
    "context"
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/attribute"
    "go.opentelemetry.io/otel/codes"
)

var tracer = otel.Tracer("order-service")

func CreateOrder(ctx context.Context, userID string, items []Item) (*Order, error) {
    ctx, span := tracer.Start(ctx, "order.create")
    defer span.End()

    span.SetAttributes(
        attribute.String("user.id", userID),
        attribute.Int("order.item_count", len(items)),
    )

    order, err := db.Insert(ctx, userID, items)
    if err != nil {
        span.SetStatus(codes.Error, err.Error())
        span.RecordError(err)
        return nil, err
    }

    span.SetAttributes(attribute.String("order.id", order.ID))
    span.SetStatus(codes.Ok, "")
    return order, nil
}
```

### HTTP Handler with Auto-Instrumentation

```go
import "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"

mux := http.NewServeMux()
mux.HandleFunc("/api/orders", handleOrders)

// Wrap the entire mux for automatic span creation
handler := otelhttp.NewHandler(mux, "server")
http.ListenAndServe(":8080", handler)
```

---

## PART 5: TRACE CONTEXT PROPAGATION

### W3C TraceContext (Default)

Every outgoing HTTP request includes:
```
traceparent: 00-<trace-id>-<span-id>-<trace-flags>
tracestate: vendor=value
```

### Cross-Service Propagation

```typescript
// Node.js — Propagation is automatic with auto-instrumentation
// For manual HTTP calls, inject context:
import { context, propagation } from '@opentelemetry/api';

async function callDownstream(url: string, data: any) {
  const headers: Record<string, string> = {};
  propagation.inject(context.active(), headers);

  return fetch(url, {
    method: 'POST',
    headers: { ...headers, 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
}
```

```python
# Python — automatic with RequestsInstrumentor
# For manual propagation:
from opentelemetry import propagate, context

headers = {}
propagate.inject(headers)
requests.get("http://downstream/api", headers=headers)
```

### Message Queue Propagation (Kafka, RabbitMQ)

```typescript
// Producer — inject trace context into message headers
const headers: Record<string, string> = {};
propagation.inject(context.active(), headers);
await producer.send({
  topic: 'orders',
  messages: [{ value: JSON.stringify(order), headers }],
});

// Consumer — extract trace context from message headers
const extractedContext = propagation.extract(ROOT_CONTEXT, message.headers);
context.with(extractedContext, () => {
  tracer.startActiveSpan('order.process', (span) => {
    // This span is now a child of the producer's span
    processOrder(message);
    span.end();
  });
});
```

---

## PART 6: LOG CORRELATION

### Inject Trace Context into Logs

```typescript
// Pino + OpenTelemetry
import { trace } from '@opentelemetry/api';

const pinoLogger = pino({
  mixin() {
    const span = trace.getActiveSpan();
    if (span) {
      const ctx = span.spanContext();
      return {
        trace_id: ctx.traceId,
        span_id: ctx.spanId,
        trace_flags: ctx.traceFlags,
      };
    }
    return {};
  },
});

// Every log line now includes trace_id and span_id:
// {"level":30,"trace_id":"abc123...","span_id":"def456...","msg":"Order created"}
```

```python
# Python — inject trace context into structlog
import structlog
from opentelemetry import trace

def add_trace_context(logger, method_name, event_dict):
    span = trace.get_current_span()
    if span.is_recording():
        ctx = span.get_span_context()
        event_dict["trace_id"] = format(ctx.trace_id, "032x")
        event_dict["span_id"] = format(ctx.span_id, "016x")
    return event_dict

structlog.configure(processors=[add_trace_context, structlog.dev.ConsoleRenderer()])
```

---

## PART 7: OPENTELEMETRY COLLECTOR

### Configuration

```yaml
# otel-collector-config.yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 5s
    send_batch_size: 1024
    send_batch_max_size: 2048

  memory_limiter:
    check_interval: 1s
    limit_mib: 512
    spike_limit_mib: 128

  resource:
    attributes:
      - key: environment
        value: production
        action: upsert

  # Drop health check spans to reduce noise
  filter:
    spans:
      exclude:
        match_type: strict
        attributes:
          - key: http.target
            value: /health
          - key: http.target
            value: /ready

  # Tail-based sampling — keep errors and slow requests, sample rest
  tail_sampling:
    decision_wait: 10s
    policies:
      - name: errors
        type: status_code
        status_code: { status_codes: [ERROR] }
      - name: slow-requests
        type: latency
        latency: { threshold_ms: 1000 }
      - name: default-sample
        type: probabilistic
        probabilistic: { sampling_percentage: 10 }

exporters:
  otlp/tempo:
    endpoint: tempo:4317
    tls:
      insecure: true

  prometheus:
    endpoint: 0.0.0.0:8889
    resource_to_telemetry_conversion:
      enabled: true

  loki:
    endpoint: http://loki:3100/loki/api/v1/push

  # Optional: Datadog
  # datadog:
  #   api:
  #     key: ${DD_API_KEY}

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, filter, tail_sampling, batch]
      exporters: [otlp/tempo]
    metrics:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [prometheus]
    logs:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [loki]
```

### Docker Compose

```yaml
services:
  otel-collector:
    image: otel/opentelemetry-collector-contrib:latest
    command: ["--config=/etc/otel-collector-config.yaml"]
    volumes:
      - ./otel-collector-config.yaml:/etc/otel-collector-config.yaml
    ports:
      - "4317:4317"    # OTLP gRPC
      - "4318:4318"    # OTLP HTTP
      - "8889:8889"    # Prometheus metrics
    depends_on:
      - tempo
      - loki

  tempo:
    image: grafana/tempo:latest
    command: ["-config.file=/etc/tempo.yaml"]
    volumes:
      - ./tempo.yaml:/etc/tempo.yaml

  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

---

## PART 8: SAMPLING STRATEGIES

### Head-Based Sampling (SDK-side)

```typescript
import { TraceIdRatioBasedSampler, ParentBasedSampler, AlwaysOnSampler } from '@opentelemetry/sdk-trace-base';

// Always sample everything (dev/staging)
const devSampler = new AlwaysOnSampler();

// Sample 10% of traces (production, high traffic)
const prodSampler = new ParentBasedSampler({
  root: new TraceIdRatioBasedSampler(0.1),
});

// ParentBased ensures child spans follow parent's decision
// If parent was sampled, all children are sampled too

const provider = new NodeTracerProvider({
  sampler: process.env.NODE_ENV === 'production' ? prodSampler : devSampler,
});
```

### Tail-Based Sampling (Collector-side)

Preferred for production: collect all spans, then decide what to keep based on full trace data.

```
Head-Based: Decide at span creation (fast, but misses errors)
Tail-Based: Decide after trace completes (slower, but keeps all errors)
```

Tail sampling policies (in Collector config above) ensure:
- All error traces are kept (100%)
- All slow traces (>1s) are kept (100%)
- Healthy fast traces are sampled at 10%

---

## PART 9: PERFORMANCE CONSIDERATIONS

### Batching and Async Export

```
ALWAYS:
- Use BatchSpanProcessor (not SimpleSpanProcessor) in production
- Set appropriate batch sizes (1024 default is good)
- Set export timeout to prevent blocking (30s default)
- Use gRPC exporter over HTTP (less overhead)

NEVER:
- Use SimpleSpanProcessor in production (blocks on every span)
- Create spans in hot loops without sampling
- Add large attributes (>1KB) to spans
- Forget to call span.end() (memory leak)
```

### Resource Limits

```typescript
const sdk = new NodeSDK({
  spanLimits: {
    attributeCountLimit: 128,       // Max attributes per span
    attributeValueLengthLimit: 1024, // Max attribute value length
    eventCountLimit: 128,           // Max events per span
    linkCountLimit: 128,            // Max links per span
  },
});
```

### Environment Variables (Standard OTel Config)

```bash
# These work across all languages — no code changes needed
OTEL_SERVICE_NAME=my-service
OTEL_EXPORTER_OTLP_ENDPOINT=http://collector:4317
OTEL_TRACES_SAMPLER=parentbased_traceidratio
OTEL_TRACES_SAMPLER_ARG=0.1
OTEL_EXPORTER_OTLP_PROTOCOL=grpc
OTEL_LOG_LEVEL=info
```

---

## Exit Checklist

- [ ] OTel SDK initialized before application code (tracing.ts imported first)
- [ ] Resource attributes set: service.name, service.version, deployment.environment
- [ ] Auto-instrumentation enabled for HTTP, database, and messaging libraries
- [ ] Health/readiness endpoints excluded from tracing
- [ ] Custom spans added for business-critical operations with relevant attributes
- [ ] W3C TraceContext propagation working across service boundaries
- [ ] Trace context injected into log output (trace_id, span_id)
- [ ] Metric instruments created: Counters for events, Histograms for durations, Gauges for state
- [ ] OpenTelemetry Collector deployed with batch processor and memory limiter
- [ ] Sampling strategy configured (AlwaysOn for dev, ParentBased ratio for prod)
- [ ] Tail-based sampling in Collector keeps all errors and slow traces
- [ ] Exporters configured for chosen backends (Tempo/Jaeger, Prometheus, Loki)
- [ ] Graceful shutdown calls sdk.shutdown() on SIGTERM
- [ ] No sensitive data in span attributes (passwords, tokens, PII)
- [ ] Batch sizes and export timeouts tuned for expected throughput
