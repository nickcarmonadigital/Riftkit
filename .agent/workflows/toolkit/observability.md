---
description: Design monitoring, logging, and tracing strategy
---

# /observability Workflow

> Use when ensuring the system is observable in production

## Step 1: Metrics Strategy (The "What")

**Signal vs Noise.**

1. **Define Golden Signals (latency, traffic, errors, saturation)**.
2. **RED Method**:
    - **R**ate (Requests per second)
    - **E**rrors (Failed requests)
    - **D**uration (Latency distribution)

## Step 2: Logging Strategy (The "Why")

**Logs are for humans.**

1. **Structure**: JSON or Text?
2. **Context**: TraceIDs must be propagated.
3. **Levels**:
    - `ERROR`: Wake up someone.
    - `WARN`: Check tomorrow.
    - `INFO`: Business events.
    - `DEBUG`: Dev only.

## Step 3: Tracing (The "Where")

1. **Distributed Tracing**: Implementation plan (OpenTelemetry).
2. **Span Strategy**: What critical paths need detailed spans?

## Step 4: Alerting (The "When")

1. **Paging Policy**: Who gets woken up?
2. **Thresholds**: Static vs Anomaly Detection.

---

## Exit Checklist

- [ ] Golden signals defined
- [ ] Log levels standardized
- [ ] Tracing library selected
- [ ] Alerting channels configured
