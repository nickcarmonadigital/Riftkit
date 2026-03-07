---
name: Log Aggregation Pipeline
description: Log aggregation with ELK/EFK stack and Loki covering structured logging, correlation IDs, and retention policies
---

# Log Aggregation Pipeline Skill

**Purpose**: Build centralized log aggregation pipelines using ELK, EFK, or Loki stacks with structured logging, distributed trace correlation, retention policies, and alerting.

---

## TRIGGER COMMANDS

```text
"Set up centralized logging"
"Configure ELK stack"
"Implement structured logging"
"Set up Loki for log aggregation"
"Using log_aggregation_pipeline skill: [task]"
```

---

## Stack Comparison

| Feature | ELK (Elasticsearch) | EFK (Fluentd) | Loki + Promtail |
|---------|---------------------|---------------|-----------------|
| Storage | Elasticsearch | Elasticsearch | Object storage (S3) |
| Collector | Logstash / Filebeat | Fluentd / Fluent Bit | Promtail / Alloy |
| Query language | KQL / Lucene | N/A (Kibana) | LogQL |
| Full-text search | Yes (inverted index) | Yes (via ES) | No (grep-like) |
| Resource usage | High (indexing) | Medium | Low |
| Cost at scale | High | Medium | Low |
| Label-based | No (field-based) | No | Yes (like Prometheus) |
| Best for | Full-text search, analytics | Kubernetes-native | Cost-effective, Grafana |

### When to Use What

| Scenario | Recommended |
|----------|-------------|
| Full-text log search needed | ELK |
| Kubernetes-native, existing Grafana | Loki |
| High volume, cost-sensitive | Loki |
| Complex log parsing/enrichment | Fluentd + Elasticsearch |
| Already using Prometheus/Grafana | Loki |
| Compliance requiring full indexing | Elasticsearch |

---

## Structured Logging

### Log Format Standard

```json
{
  "timestamp": "2026-03-06T14:30:00.123Z",
  "level": "INFO",
  "service": "order-service",
  "version": "1.4.2",
  "trace_id": "abc123def456",
  "span_id": "789ghi",
  "request_id": "req-001",
  "message": "Order created successfully",
  "order_id": "ord-5678",
  "customer_id": "cust-1234",
  "amount": 99.99,
  "duration_ms": 45
}
```

### Python (structlog)

```python
import structlog
import uuid

structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer(),
    ],
    wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
)

logger = structlog.get_logger()

# Middleware: bind request context
def logging_middleware(request, call_next):
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
    trace_id = request.headers.get("X-Trace-ID", str(uuid.uuid4()))

    structlog.contextvars.clear_contextvars()
    structlog.contextvars.bind_contextvars(
        request_id=request_id,
        trace_id=trace_id,
        service="order-service",
        path=request.url.path,
        method=request.method,
    )

    logger.info("request_started")
    response = call_next(request)
    logger.info("request_completed", status=response.status_code)
    return response

# Usage - context is automatically included
logger.info("order_created", order_id="ord-5678", amount=99.99)
```

### Node.js (pino)

```javascript
const pino = require("pino");

const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  formatters: {
    level: (label) => ({ level: label }),
  },
  timestamp: pino.stdTimeFunctions.isoTime,
  base: {
    service: "order-service",
    version: process.env.APP_VERSION,
  },
  redact: ["req.headers.authorization", "password", "ssn"],
});

// Express middleware
app.use((req, res, next) => {
  const requestId = req.headers["x-request-id"] || crypto.randomUUID();
  req.log = logger.child({
    request_id: requestId,
    trace_id: req.headers["x-trace-id"],
    path: req.path,
    method: req.method,
  });
  req.log.info("request_started");
  next();
});

// Usage
req.log.info({ order_id: "ord-5678", amount: 99.99 }, "order_created");
```

### Go (zerolog)

```go
package main

import (
    "os"
    "time"
    "github.com/rs/zerolog"
    "github.com/rs/zerolog/log"
)

func init() {
    zerolog.TimeFieldFormat = time.RFC3339Nano
    log.Logger = zerolog.New(os.Stdout).With().
        Timestamp().
        Str("service", "order-service").
        Str("version", os.Getenv("APP_VERSION")).
        Logger()
}

func CreateOrder(orderID string, amount float64) {
    log.Info().
        Str("order_id", orderID).
        Float64("amount", amount).
        Msg("order_created")
}
```

---

## Correlation IDs

### Propagation Architecture

```
Client ──> API Gateway ──> Service A ──> Service B ──> Database
           (generates)     (propagates)  (propagates)
           X-Request-ID    X-Request-ID  X-Request-ID
           X-Trace-ID      X-Trace-ID    X-Trace-ID

All logs from this request chain share the same trace_id,
making it possible to reconstruct the full request flow.
```

### HTTP Header Propagation

```python
import httpx

async def call_downstream(request_context: dict):
    headers = {
        "X-Request-ID": request_context["request_id"],
        "X-Trace-ID": request_context["trace_id"],
        "X-Span-ID": str(uuid.uuid4()),  # New span for this hop
    }
    async with httpx.AsyncClient() as client:
        return await client.get("http://service-b/api/data", headers=headers)
```

---

## ELK Stack

### Filebeat Configuration

```yaml
# filebeat.yml
filebeat.inputs:
  - type: container
    paths:
      - /var/log/containers/*.log
    processors:
      - add_kubernetes_metadata:
          host: ${NODE_NAME}
      - decode_json_fields:
          fields: ["message"]
          target: ""
          overwrite_keys: true
      - drop_fields:
          fields: ["agent", "ecs", "host.name"]

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
  indices:
    - index: "logs-app-%{+yyyy.MM.dd}"
      when.contains:
        kubernetes.namespace: "production"
    - index: "logs-system-%{+yyyy.MM.dd}"
      when.contains:
        kubernetes.namespace: "kube-system"

setup.ilm.enabled: true
setup.ilm.policy_name: "logs-retention"
setup.ilm.rollover_alias: "logs-app"
```

### Index Lifecycle Management (ILM)

```json
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_age": "1d",
            "max_primary_shard_size": "50gb"
          },
          "set_priority": { "priority": 100 }
        }
      },
      "warm": {
        "min_age": "7d",
        "actions": {
          "shrink": { "number_of_shards": 1 },
          "forcemerge": { "max_num_segments": 1 },
          "set_priority": { "priority": 50 }
        }
      },
      "cold": {
        "min_age": "30d",
        "actions": {
          "searchable_snapshot": {
            "snapshot_repository": "logs-s3"
          },
          "set_priority": { "priority": 0 }
        }
      },
      "delete": {
        "min_age": "90d",
        "actions": { "delete": {} }
      }
    }
  }
}
```

### Elasticsearch Index Template

```json
{
  "index_patterns": ["logs-app-*"],
  "template": {
    "settings": {
      "number_of_shards": 3,
      "number_of_replicas": 1,
      "index.lifecycle.name": "logs-retention",
      "index.lifecycle.rollover_alias": "logs-app"
    },
    "mappings": {
      "properties": {
        "timestamp": { "type": "date" },
        "level": { "type": "keyword" },
        "service": { "type": "keyword" },
        "trace_id": { "type": "keyword" },
        "request_id": { "type": "keyword" },
        "message": { "type": "text" },
        "duration_ms": { "type": "float" },
        "status_code": { "type": "integer" }
      }
    }
  }
}
```

---

## Loki + Promtail

### Promtail Configuration

```yaml
# promtail-config.yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push
    batchwait: 1s
    batchsize: 1048576
    timeout: 10s

scrape_configs:
  - job_name: kubernetes-pods
    kubernetes_sd_configs:
      - role: pod
    pipeline_stages:
      - docker: {}
      - json:
          expressions:
            level: level
            service: service
            trace_id: trace_id
            request_id: request_id
            duration_ms: duration_ms
      - labels:
          level:
          service:
      - timestamp:
          source: timestamp
          format: RFC3339Nano
    relabel_configs:
      - source_labels: [__meta_kubernetes_namespace]
        target_label: namespace
      - source_labels: [__meta_kubernetes_pod_name]
        target_label: pod
      - source_labels: [__meta_kubernetes_container_name]
        target_label: container
```

### Loki Configuration

```yaml
# loki-config.yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /loki
  storage:
    s3:
      s3: s3://us-east-1/loki-logs
      bucketnames: loki-logs
      region: us-east-1
  ring:
    kvstore:
      store: memberlist

schema_config:
  configs:
    - from: 2026-01-01
      store: tsdb
      object_store: s3
      schema: v13
      index:
        prefix: loki_index_
        period: 24h

limits_config:
  retention_period: 30d
  max_query_length: 720h
  max_entries_limit_per_query: 10000
  ingestion_rate_mb: 10
  ingestion_burst_size_mb: 20

compactor:
  working_directory: /loki/compactor
  retention_enabled: true
```

### LogQL Queries

```logql
# Find errors in order-service
{service="order-service"} |= "error"

# JSON parsing and filtering
{namespace="production"} | json | level="ERROR" | duration_ms > 1000

# Aggregate error rate
sum(rate({service="order-service"} |= "error" [5m])) by (level)

# Top 10 slowest requests
{service="order-service"} | json | duration_ms > 0
  | line_format "{{.duration_ms}}ms - {{.path}}"
  | sort desc

# Trace all logs for a request
{namespace="production"} |= "trace_id=abc123def456"
```

---

## Retention Policies

### Retention by Environment

| Environment | Hot | Warm | Cold | Delete |
|-------------|-----|------|------|--------|
| Development | 3 days | - | - | 7 days |
| Staging | 7 days | - | - | 30 days |
| Production | 7 days | 30 days | 90 days | 365 days |
| Compliance | 7 days | 30 days | 365 days | 7 years |

### Storage Cost Optimization

| Tier | Storage | Cost | Query Speed |
|------|---------|------|-------------|
| Hot (SSD) | Local NVMe | $$$ | < 100ms |
| Warm (HDD) | Attached HDD | $$ | < 1s |
| Cold (S3) | Object storage | $ | 2-10s |
| Frozen (Glacier) | Archive | ¢ | Minutes-Hours |

---

## Alerting on Logs

### Loki Alert Rules (Grafana)

```yaml
groups:
  - name: log-alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate({namespace="production"} |= "level=ERROR" [5m])) by (service) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate in {{ $labels.service }}"
          description: "Error rate is {{ $value }} errors/sec"

      - alert: ServiceDown
        expr: |
          absent(rate({service="order-service"} [5m]))
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "No logs from order-service for 5 minutes"
```

---

## Logging Best Practices

| Practice | Do | Don't |
|----------|-----|-------|
| Format | JSON structured logging | Unstructured text |
| Level | Use appropriate levels | Log everything at INFO |
| Context | Include trace_id, request_id | Log without context |
| Sensitive data | Redact PII, secrets | Log passwords, tokens |
| Performance | Async logging, sampling | Sync logging on hot path |
| Volume | Log decisions, not data | Log full request/response bodies |

### Log Level Guidelines

| Level | When to Use | Example |
|-------|-------------|---------|
| ERROR | Unexpected failure requiring attention | DB connection failed |
| WARN | Recoverable issue, degraded behavior | Retry succeeded on 2nd attempt |
| INFO | Business events, state changes | Order created, user logged in |
| DEBUG | Diagnostic detail (off in production) | SQL query, cache hit/miss |
| TRACE | Very detailed (never in production) | Function entry/exit |

---

## Cross-References

- `3-build/kafka_event_streaming` - Kafka as log transport layer
- `3-build/service_mesh_patterns` - Mesh access logs (Istio/Linkerd)
- `3-build/kubernetes_operations` - Container log collection

---

## EXIT CHECKLIST

- [ ] Structured JSON logging implemented in all services
- [ ] Correlation IDs (trace_id, request_id) propagated across services
- [ ] Log collector deployed (Filebeat, Promtail, or Fluent Bit)
- [ ] Centralized storage configured (Elasticsearch or Loki)
- [ ] Index lifecycle / retention policies defined per environment
- [ ] Dashboard created for log exploration (Kibana or Grafana)
- [ ] Alert rules configured for error rate and service health
- [ ] Sensitive data redacted (PII, secrets, tokens)
- [ ] Log levels appropriate per environment (no DEBUG in production)
- [ ] Storage tiering configured (hot/warm/cold) for cost optimization
- [ ] Log volume monitored to prevent storage overrun
- [ ] Query performance validated for common investigation patterns

---

*Skill Version: 1.0 | Created: March 2026*
