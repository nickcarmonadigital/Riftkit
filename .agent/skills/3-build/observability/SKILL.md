---
name: Observability Implementation
description: Protocol for implementing the "Golden Signals" (Logs, Metrics, Traces) to ensure production visibility
---

# Observability Skill

**Purpose**: "Turn on the lights" in the codebase. Ensure that when things break, we know **What**, **Where**, and **Why** without guessing.

> [!IMPORTANT]
> **Zero-Blindness Policy**: No critical feature goes to production without logging and error tracking.

---

## 🎯 TRIGGER COMMANDS

```text
"Add logging to [feature]"
"Setup observability for [project]"
" Implement metrics for [service]"
"Using observability skill: instrument [component]"
```

---

## 📊 THE GOLDEN SIGNALS (RED Method)

Every service must track these three metrics:

1. **RATE** (Traffic): How many requests are we handling?
2. **ERRORS**: How many requests are failing?
3. **DURATION**: How long do requests take?

---

## 📝 LOGGING STANDARDS

### Levels

| Level | When to use | Example |
|-------|-------------|---------|
| `ERROR` | System is broken, human intervention needed | DB connection failed, Payment gateway down |
| `WARN` | Something odd happened, but system survived | 404 on critical asset, API rate limit nearing |
| `INFO` | Standard lifecycle events (Happy Path) | User logged in, Order placed, Server started |
| `DEBUG` | Verbose data for developer troubleshooting | Payload contents, Full stack traces |

### Structured Logging (JSON)

**❌ BAD (Text)**:
`"User 123 failed to login: Password incorrect"`

**✅ GOOD (Structured)**:

```json
{
  "level": "warn",
  "event": "auth.login_failed",
  "user_id": "123",
  "reason": "invalid_credentials",
  "ip": "10.0.0.1",
  "timestamp": "2024-01-01T12:00:00Z"
}
```

---

## 🔭 TRACING & CONTEXT

### Correlation IDs

Every request entering the system MUST be assigned a `request_id`. This ID must be passed to all downstream services and logged in every message.

**Flow**:

1. Client sends request
2. Edge (Load Balancer) generates `req-123-abc`
3. API Service receives `req-123-abc` -> logs it
4. DB Service receives `req-123-abc` -> logs it

### Context Propagation

Start of span:

```typescript
const traceId = generateId();
logger.withContext({ traceId }).info("Request started");
```

---

## 🚦 ALERTING THRESHOLDS

Don't alert on everything. Alert on **User Pain**.

| Metric | Threshold | Severity | Response |
|--------|-----------|----------|----------|
| **Error Rate** | > 1% of requests | P1 (Critical) | Wake up on-call |
| **P99 Latency** | > 2000ms | P2 (Warning) | Investigate next day |
| **Disk Usage** | > 85% | P2 (Warning) | Cleanup routine |
| **CPU Saturation** | > 90% for 5m | P3 (Info) | Check scaling |

---

## ✅ IMPLEMENTATION CHECKLIST

- [ ] **Logger Setup**: Structured logger (Winston/Pino) installed
- [ ] **Error Handling**: Global Error Handler catches unhandled exceptions
- [ ] **Context**: Correlation IDs attached to every request
- [ ] **Sanitization**: PII (Passwords, Keys) is scrubbed from logs
- [ ] **Transport**: Logs are shipped to separate storage (not just console.log)
- [ ] **Health Check**: `/health` endpoint exists and checks DB connection

---

## 🛠️ RECOMMENDED STACK

- **Node.js**: Pino, OpenTelemetry
- **Python**: Structlog, OpenTelemetry
- **Infrastructure**: Grafana/Prometheus (Self-hosted) or Datadog/Sentry (Managed)
