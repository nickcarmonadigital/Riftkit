---
name: multi-stack-observability
description: Observability patterns for Django, Go, and Swift — structured logging, metrics, tracing, health checks, and cross-stack consistency beyond NestJS
---

# Multi-Stack Observability

**Purpose**: Extend observability coverage to non-NestJS stacks. The core `observability` skill covers NestJS/Pino/prom-client. This skill provides equivalent patterns for Django/Python, Go, and Swift/iOS so every stack in your org has structured logs, metrics, traces, and health checks.

> [!IMPORTANT]
> **Stack Parity Rule**: If your NestJS services have structured logging and metrics, your Django/Go/Swift services must too. Blind spots in one stack become production incidents.

## TRIGGER COMMANDS

```text
"Add logging to Django project"
"Setup observability for Go service"
"Implement metrics in Python"
"Add tracing to Go microservice"
"Swift app crash reporting"
"Using multi-stack-observability skill: instrument [component]"
```

## When to Use

- Instrumenting a Django/Python backend with structured logging and metrics
- Adding OpenTelemetry tracing to Go services
- Setting up Swift/iOS performance monitoring and crash reporting
- Ensuring consistent correlation IDs and metric naming across polyglot stacks
- Building Grafana dashboards that aggregate data from multiple backends

---

## PART 1: DJANGO / PYTHON

### 1.1 Structured Logging with structlog

```bash
pip install structlog
```

```python
# config/logging.py
import structlog
import logging

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.StackInfoRenderer(),
        structlog.dev.set_exc_info,
        structlog.processors.TimeStamper(fmt="iso"),
        # JSON in production, pretty in dev
        structlog.dev.ConsoleRenderer()
        if DEBUG
        else structlog.processors.JSONRenderer(),
    ],
    wrapper_class=structlog.make_filtering_bound_logger(
        logging.INFO if not DEBUG else logging.DEBUG
    ),
    context_class=dict,
    logger_factory=structlog.PrintLoggerFactory(),
    cache_logger_on_first_use=True,
)
```

```python
# Usage in views/services
import structlog

logger = structlog.get_logger(__name__)

def create_order(request, data):
    logger.info("order.creating", user_id=request.user.id, item_count=len(data["items"]))

    order = Order.objects.create(**data)

    logger.info("order.created", order_id=order.id, total=str(order.total))
    return order
```

### 1.2 Correlation ID Middleware

```python
# middleware/correlation.py
import uuid
from contextvars import ContextVar
import structlog

correlation_id_var: ContextVar[str] = ContextVar("correlation_id", default="")

class CorrelationIdMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        cid = request.headers.get("X-Request-ID", str(uuid.uuid4()))
        correlation_id_var.set(cid)

        # Bind to structlog context for all downstream logging
        structlog.contextvars.clear_contextvars()
        structlog.contextvars.bind_contextvars(correlation_id=cid)

        response = self.get_response(request)
        response["X-Request-ID"] = cid
        return response
```

```python
# settings.py
MIDDLEWARE = [
    "middleware.correlation.CorrelationIdMiddleware",
    # ... other middleware
]
```

### 1.3 Prometheus Metrics with django-prometheus

```bash
pip install django-prometheus
```

```python
# settings.py
INSTALLED_APPS = [
    "django_prometheus",
    # ...
]

MIDDLEWARE = [
    "django_prometheus.middleware.PrometheusBeforeMiddleware",
    # ... your middleware ...
    "django_prometheus.middleware.PrometheusAfterMiddleware",
]
```

```python
# urls.py
urlpatterns = [
    path("", include("django_prometheus.urls")),  # exposes /metrics
    # ...
]
```

```python
# Custom business metrics
from prometheus_client import Counter, Histogram

orders_created = Counter(
    "orders_created_total",
    "Total orders created",
    ["status"],
)

payment_duration_seconds = Histogram(
    "payment_duration_seconds",
    "Time to process payment",
    buckets=[0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0],
)

def create_order(request, data):
    order = Order.objects.create(**data)
    orders_created.labels(status="created").inc()
    return order

def process_payment(order_id):
    with payment_duration_seconds.time():
        gateway.charge(order_id)
```

### 1.4 OpenTelemetry Auto-Instrumentation

```bash
pip install opentelemetry-distro opentelemetry-exporter-otlp
opentelemetry-bootstrap -a install  # auto-detects Django, psycopg2, redis, celery
```

```python
# settings.py or manage.py entrypoint
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.django import DjangoInstrumentor
from opentelemetry.instrumentation.psycopg2 import Psycopg2Instrumentor

provider = TracerProvider()
provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter()))
trace.set_tracer_provider(provider)

DjangoInstrumentor().instrument()
Psycopg2Instrumentor().instrument()
```

### 1.5 Health Check

```bash
pip install django-health-check
```

```python
# settings.py
INSTALLED_APPS = [
    "health_check",
    "health_check.db",
    "health_check.cache",
    "health_check.storage",
]

# urls.py
urlpatterns = [
    path("health/", include("health_check.urls")),
]
```

### 1.6 Sentry Integration

```bash
pip install sentry-sdk
```

```python
# settings.py
import sentry_sdk

sentry_sdk.init(
    dsn=os.environ["SENTRY_DSN"],
    traces_sample_rate=0.1,  # 10% of requests traced
    profiles_sample_rate=0.1,
    environment=os.environ.get("DJANGO_ENV", "development"),
    send_default_pii=False,  # never send PII
)
```

---

## PART 2: GO

### 2.1 Structured Logging with slog (Go 1.21+)

```go
// pkg/logger/logger.go
package logger

import (
    "context"
    "log/slog"
    "os"
)

func New(env string) *slog.Logger {
    var handler slog.Handler
    if env == "production" {
        handler = slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
            Level: slog.LevelInfo,
        })
    } else {
        handler = slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
            Level:     slog.LevelDebug,
            AddSource: true,
        })
    }
    return slog.New(handler)
}
```

```go
// Usage in handlers/services
func (s *OrderService) CreateOrder(ctx context.Context, req CreateOrderReq) (*Order, error) {
    slog.InfoContext(ctx, "order.creating",
        slog.String("user_id", req.UserID),
        slog.Int("item_count", len(req.Items)),
    )

    order, err := s.repo.Insert(ctx, req)
    if err != nil {
        slog.ErrorContext(ctx, "order.create_failed",
            slog.String("user_id", req.UserID),
            slog.String("error", err.Error()),
        )
        return nil, err
    }

    slog.InfoContext(ctx, "order.created",
        slog.String("order_id", order.ID),
        slog.Float64("total", order.Total),
    )
    return order, nil
}
```

### 2.2 Correlation ID Middleware

```go
// pkg/middleware/correlation.go
package middleware

import (
    "context"
    "net/http"

    "github.com/google/uuid"
)

type ctxKey string

const CorrelationIDKey ctxKey = "correlation_id"

func CorrelationID(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        cid := r.Header.Get("X-Request-ID")
        if cid == "" {
            cid = uuid.New().String()
        }

        ctx := context.WithValue(r.Context(), CorrelationIDKey, cid)
        w.Header().Set("X-Request-ID", cid)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

func GetCorrelationID(ctx context.Context) string {
    if cid, ok := ctx.Value(CorrelationIDKey).(string); ok {
        return cid
    }
    return "unknown"
}
```

```go
// Wire into router (works with net/http, chi, gin, echo)
mux := http.NewServeMux()
handler := middleware.CorrelationID(mux)
http.ListenAndServe(":8080", handler)
```

### 2.3 Prometheus Metrics

```go
// pkg/metrics/metrics.go
package metrics

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
    "github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
    HTTPRequestsTotal = promauto.NewCounterVec(prometheus.CounterOpts{
        Name: "http_requests_total",
        Help: "Total HTTP requests",
    }, []string{"method", "path", "status"})

    HTTPRequestDuration = promauto.NewHistogramVec(prometheus.HistogramOpts{
        Name:    "http_request_duration_seconds",
        Help:    "HTTP request duration in seconds",
        Buckets: []float64{0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10},
    }, []string{"method", "path"})

    OrdersCreated = promauto.NewCounterVec(prometheus.CounterOpts{
        Name: "orders_created_total",
        Help: "Total orders created",
    }, []string{"status"})
)
```

```go
// Metrics middleware
func MetricsMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        timer := prometheus.NewTimer(HTTPRequestDuration.WithLabelValues(r.Method, r.URL.Path))
        rw := &responseWriter{ResponseWriter: w, statusCode: 200}

        next.ServeHTTP(rw, r)

        timer.ObserveDuration()
        HTTPRequestsTotal.WithLabelValues(
            r.Method, r.URL.Path, fmt.Sprintf("%d", rw.statusCode),
        ).Inc()
    })
}

type responseWriter struct {
    http.ResponseWriter
    statusCode int
}

func (rw *responseWriter) WriteHeader(code int) {
    rw.statusCode = code
    rw.ResponseWriter.WriteHeader(code)
}
```

```go
// Expose /metrics endpoint
mux.Handle("/metrics", promhttp.Handler())
```

### 2.4 OpenTelemetry for Go

```go
// pkg/tracing/tracing.go
package tracing

import (
    "context"

    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc"
    "go.opentelemetry.io/otel/sdk/resource"
    sdktrace "go.opentelemetry.io/otel/sdk/trace"
    semconv "go.opentelemetry.io/otel/semconv/v1.24.0"
)

func InitTracer(ctx context.Context, serviceName string) (func(), error) {
    exporter, err := otlptracegrpc.New(ctx)
    if err != nil {
        return nil, err
    }

    tp := sdktrace.NewTracerProvider(
        sdktrace.WithBatcher(exporter),
        sdktrace.WithResource(resource.NewWithAttributes(
            semconv.SchemaURL,
            semconv.ServiceNameKey.String(serviceName),
        )),
    )
    otel.SetTracerProvider(tp)

    return func() { tp.Shutdown(ctx) }, nil
}
```

```go
// HTTP middleware for trace propagation
import "go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"

handler := otelhttp.NewHandler(mux, "server")
http.ListenAndServe(":8080", handler)
```

```go
// gRPC interceptor
import "go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"

server := grpc.NewServer(
    grpc.StatsHandler(otelgrpc.NewServerHandler()),
)
```

### 2.5 Health Check Endpoint

```go
// handlers/health.go
func HealthHandler(db *sql.DB) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        checks := map[string]string{}
        status := http.StatusOK

        // Database check
        if err := db.PingContext(r.Context()); err != nil {
            checks["database"] = "unhealthy: " + err.Error()
            status = http.StatusServiceUnavailable
        } else {
            checks["database"] = "healthy"
        }

        w.Header().Set("Content-Type", "application/json")
        w.WriteHeader(status)
        json.NewEncoder(w).Encode(map[string]any{
            "status": func() string {
                if status == 200 {
                    return "healthy"
                }
                return "unhealthy"
            }(),
            "checks": checks,
        })
    }
}
```

### 2.6 Graceful Shutdown with Drain

```go
func main() {
    srv := &http.Server{Addr: ":8080", Handler: handler}

    go func() { srv.ListenAndServe() }()

    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit

    slog.Info("server.shutting_down")
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    srv.Shutdown(ctx) // drains in-flight requests
    slog.Info("server.stopped")
}
```

---

## PART 3: SWIFT / iOS

### 3.1 Structured Logging with os.Logger

```swift
// Logging/AppLogger.swift
import OSLog

enum AppLogger {
    static let network = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network")
    static let auth    = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "auth")
    static let orders  = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "orders")
    static let general = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "general")
}

// Usage
func createOrder(_ order: OrderRequest) async throws -> Order {
    AppLogger.orders.info("order.creating: userId=\(order.userId, privacy: .public)")

    let result = try await api.postOrder(order)

    AppLogger.orders.info("order.created: orderId=\(result.id, privacy: .public)")
    return result
}

// Sensitive data stays private (redacted in logs unless debugging)
func login(email: String, password: String) {
    AppLogger.auth.info("auth.login_attempt: email=\(email, privacy: .private)")
}
```

### 3.2 MetricKit for Performance Metrics

```swift
// Metrics/MetricKitManager.swift
import MetricKit

class MetricKitManager: NSObject, MXMetricManagerSubscriber {
    static let shared = MetricKitManager()

    func start() {
        MXMetricManager.shared.add(self)
    }

    func didReceive(_ payloads: [MXMetricPayload]) {
        for payload in payloads {
            // App launch time
            if let launch = payload.applicationLaunchMetrics {
                AppLogger.general.info("metrics.launch: resume_time=\(launch.histogrammedResumeTime)")
            }

            // Network transfer
            if let network = payload.networkTransferMetrics {
                AppLogger.network.info("metrics.network: cell_upload=\(network.cumulativeCellularUpload)")
            }

            // Send to your backend for aggregation
            sendToBackend(payload.jsonRepresentation())
        }
    }

    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            if let crashes = payload.crashDiagnostics {
                for crash in crashes {
                    AppLogger.general.error("diagnostic.crash: \(crash.applicationVersion, privacy: .public)")
                    sendCrashToBackend(crash)
                }
            }
        }
    }
}
```

### 3.3 os_signpost for Tracing

```swift
// Tracing/SignpostTracer.swift
import OSLog

enum SignpostTracer {
    private static let poi = OSSignposter(subsystem: Bundle.main.bundleIdentifier!, category: .pointsOfInterest)

    static func trace<T>(_ name: StaticString, _ work: () async throws -> T) async rethrows -> T {
        let state = poi.beginInterval(name)
        defer { poi.endInterval(name, state) }
        return try await work()
    }
}

// Usage — shows up in Instruments timeline
let order = try await SignpostTracer.trace("CreateOrder") {
    try await api.postOrder(request)
}
```

### 3.4 URLSession Metrics

```swift
// Network/NetworkMetricsDelegate.swift
class NetworkMetricsDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask,
                    didFinishCollecting metrics: URLSessionTaskMetrics) {
        for m in metrics.transactionMetrics {
            let dns = m.domainLookupEndDate?.timeIntervalSince(m.domainLookupStartDate ?? Date()) ?? 0
            let connect = m.connectEndDate?.timeIntervalSince(m.connectStartDate ?? Date()) ?? 0
            let ttfb = m.responseStartDate?.timeIntervalSince(m.requestStartDate ?? Date()) ?? 0

            AppLogger.network.info(
                "network.timing: url=\(m.request.url?.path ?? "unknown", privacy: .public) " +
                "dns=\(dns)s connect=\(connect)s ttfb=\(ttfb)s"
            )
        }
    }
}
```

### 3.5 Crash Reporting with Structured Metadata

```swift
// Diagnostics/CrashContext.swift
import OSLog

enum CrashContext {
    private static let store = UserDefaults(suiteName: "crash_context")!

    /// Call before risky operations to leave breadcrumbs
    static func set(key: String, value: String) {
        store.set(value, forKey: key)
    }

    /// Attach to crash reports on next launch
    static func lastSessionContext() -> [String: String] {
        var ctx: [String: String] = [:]
        for key in ["last_screen", "last_api_call", "user_id", "app_state"] {
            if let val = store.string(forKey: key) {
                ctx[key] = val
            }
        }
        return ctx
    }
}

// Usage
CrashContext.set(key: "last_screen", value: "OrderDetail")
CrashContext.set(key: "last_api_call", value: "POST /api/orders")
```

---

## PART 4: CROSS-STACK PATTERNS

### 4.1 Correlation ID Format

Use UUID v4 across all stacks. Same header name everywhere.

```
Header:    X-Request-ID
Format:    UUID v4 (e.g., 550e8400-e29b-41d4-a716-446655440000)
Generate:  If not present in incoming request
Propagate: Pass to all downstream service calls
Log:       Include in every structured log entry
Return:    Set on response headers
```

### 4.2 Metric Naming Conventions

Consistent naming so Grafana dashboards work across stacks.

```
Format:     snake_case
Unit suffix: _seconds, _bytes, _total (counters)
Prefixes:   http_, db_, queue_, business_

Examples (same name regardless of stack):
  http_requests_total{method, path, status}
  http_request_duration_seconds{method, path}
  orders_created_total{status}
  payment_duration_seconds
  db_query_duration_seconds{operation}
  active_connections
```

### 4.3 Log Level Standards

| Level | When | All Stacks |
|-------|------|------------|
| **ERROR** | System is broken, needs investigation | Exceptions, failed dependencies, data corruption |
| **WARN** | Degraded but surviving | Retries, fallbacks, timeouts, validation failures |
| **INFO** | Business lifecycle events | Created, updated, deleted, login, logout |
| **DEBUG** | Developer troubleshooting | Request payloads, SQL queries, cache hits/misses |

### 4.4 Stack-Agnostic Grafana Dashboard

```json
{
  "title": "Service Overview (All Stacks)",
  "panels": [
    {
      "title": "Request Rate by Service",
      "type": "timeseries",
      "targets": [
        { "expr": "sum(rate(http_requests_total[5m])) by (job)" }
      ]
    },
    {
      "title": "Error Rate by Service",
      "type": "timeseries",
      "targets": [
        {
          "expr": "sum(rate(http_requests_total{status=~\"5..\"}[5m])) by (job) / sum(rate(http_requests_total[5m])) by (job) * 100"
        }
      ]
    },
    {
      "title": "P95 Latency by Service",
      "type": "timeseries",
      "targets": [
        {
          "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, job))"
        }
      ]
    },
    {
      "title": "Business: Orders Created",
      "type": "stat",
      "targets": [
        { "expr": "sum(increase(orders_created_total[1h]))" }
      ]
    }
  ]
}
```

### 4.5 Stack-Agnostic Alert Rules

```yaml
# alerts.yml — works for any backend exposing standard metrics
groups:
  - name: cross-stack
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m])) by (job)
          / sum(rate(http_requests_total[5m])) by (job) > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.job }}: error rate above 1%"

      - alert: HighLatency
        expr: |
          histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, job)) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.job }}: P95 latency above 2s"

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.job }}: service is down"
```

---

## Exit Checklist

- [ ] Structured JSON logging configured (structlog / slog / os.Logger)
- [ ] Log levels used consistently across stacks (ERROR > WARN > INFO > DEBUG)
- [ ] PII never logged in plaintext (use privacy: .private in Swift, redact in structlog)
- [ ] Correlation IDs propagated via X-Request-ID header
- [ ] Correlation ID bound to log context (contextvars / context.Value / os.Logger category)
- [ ] Prometheus metrics exposed at /metrics (Django + Go)
- [ ] Metric names follow snake_case with unit suffixes
- [ ] Same metric names used across stacks for dashboard compatibility
- [ ] OpenTelemetry traces configured (Django auto-instrumentation / Go otelhttp)
- [ ] Health check endpoint returns JSON with dependency status
- [ ] Sentry or equivalent crash reporting configured
- [ ] Swift: MetricKit subscriber registered for performance payloads
- [ ] Grafana dashboard queries work across all services (same metric names)
- [ ] Alert rules are stack-agnostic (error_rate, latency, upness)
