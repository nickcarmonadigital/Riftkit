---
name: Observability Maturity Model
description: Four-level observability maturity framework mapping implementation guidance from basic logging (L1) to autonomous detection (L4) across phases 2-7.
---

# Observability Maturity Model Skill

**Purpose**: Define and assess observability maturity across four levels, providing concrete implementation guidance for each level. Maps each project phase to a target maturity level so observability grows in lockstep with the product rather than being bolted on after incidents.

## TRIGGER COMMANDS

```text
"Assess observability maturity"
"What should we monitor?"
"Observability roadmap"
"Current observability level"
"Upgrade monitoring to level [N]"
```

## When to Use
- Designing monitoring strategy during Phase 2 architecture decisions
- Implementing logging, metrics, and tracing during Phase 3 build
- Establishing SLOs and alerting during Phase 5 ship
- Diagnosing alert fatigue or observability gaps in Phase 7 maintenance
- Preparing for SRE practices or on-call rotations

---

## PROCESS

### Step 1: Assess Current Maturity Level

Evaluate the project against the four-level model to determine current state.

**Level 1 -- Reactive (Minimum Viable Observability)**

| Capability | Implementation | Phase Target |
|-----------|----------------|-------------|
| Structured logging | JSON logs with correlation IDs | Phase 3 |
| Error tracking | Sentry/Bugsnag with source maps | Phase 3 |
| Health endpoints | `/health` and `/ready` probes | Phase 3 |
| Basic uptime monitoring | External ping (UptimeRobot, Pingdom) | Phase 5 |
| Log aggregation | Centralized log storage (CloudWatch, Loki) | Phase 5 |

**Diagnostic Questions:**
- Can you determine if the service is up or down right now?
- Can you find logs for a specific request?
- Do errors surface automatically or require manual log searching?

**Level 2 -- Proactive (Operational Visibility)**

| Capability | Implementation | Phase Target |
|-----------|----------------|-------------|
| Distributed tracing | OpenTelemetry with Jaeger/Tempo | Phase 3-5 |
| Metrics collection | Prometheus/Datadog with RED metrics | Phase 5 |
| Dashboards | Grafana/Datadog dashboards per service | Phase 5 |
| Alerting | PagerDuty/OpsGenie with severity routing | Phase 5-6 |
| Log correlation | Trace ID propagation across services | Phase 3 |

**Diagnostic Questions:**
- Can you trace a request across all services it touches?
- Do you have dashboards showing request rate, error rate, and duration (RED)?
- Are alerts routed to the right team with appropriate severity?

**Level 3 -- Predictive (SLO-Driven Operations)**

| Capability | Implementation | Phase Target |
|-----------|----------------|-------------|
| SLO definitions | Availability, latency, correctness SLOs | Phase 5.75-6 |
| Error budgets | Budget tracking with burn-rate alerts | Phase 6-7 |
| Anomaly detection | Statistical baseline deviation alerts | Phase 7 |
| Capacity planning | Trend-based resource projection | Phase 7 |
| Synthetic monitoring | Canary requests simulating user journeys | Phase 6 |

**Diagnostic Questions:**
- Do you have defined SLOs with error budgets?
- Can you predict capacity issues before they cause outages?
- Do alerts fire on user-impact, not just system symptoms?

**Level 4 -- Autonomous (Self-Healing Operations)**

| Capability | Implementation | Phase Target |
|-----------|----------------|-------------|
| ML-based anomaly detection | Adaptive baselines (Datadog Watchdog) | Phase 7+ |
| Auto-remediation | Runbook automation (PagerDuty/Rundeck) | Phase 7+ |
| Chaos-informed alerting | Alerts validated by chaos experiments | Phase 7+ |
| Cost-aware observability | Sampling and retention optimization | Phase 7+ |
| Observability-as-code | Terraform/Pulumi for dashboards and alerts | Phase 7+ |

### Step 2: Map Phase to Target Level

| Project Phase | Target Level | Rationale |
|--------------|-------------|-----------|
| Phase 2 -- Design | L2 design decisions | Architecture must support tracing/metrics |
| Phase 3 -- Build | L1 implemented, L2 instrumented | Ship with structured logs and trace propagation |
| Phase 4 -- Secure | L1 verified | Security scans include logging blind spots |
| Phase 5 -- Ship | L2 operational | Dashboards and alerts live before GA traffic |
| Phase 5.5 -- Alpha | L2 with alpha-specific telemetry | Enhanced instrumentation for early feedback |
| Phase 5.75 -- Beta | L3 SLO definitions | Error budgets established from beta baseline |
| Phase 6 -- Handoff | L3 operational | SLOs, error budgets, synthetic monitoring |
| Phase 7 -- Maintenance | L3 mature, L4 aspirational | Full predictive operations |

### Step 3: Implementation Roadmap

For each gap between current and target level, produce an implementation card.

**Implementation Card Template:**

```markdown
## [Capability Name]
- **Current**: [Not implemented / Partial / Implemented]
- **Target Level**: L[N]
- **Phase**: [Target phase]
- **Implementation**:
  1. [Step 1]
  2. [Step 2]
- **Tools**: [Recommended tools]
- **Verification**: [How to confirm it works]
- **Estimated Effort**: [S/M/L]
```

### Step 4: Observability Review Checklist

Run at each phase gate to verify observability targets are met.

**L1 Verification:**
- [ ] `curl /health` returns 200 with dependency status
- [ ] Error triggers alert within 5 minutes
- [ ] Request logs include correlation ID, timestamp, status, duration
- [ ] Logs are searchable in centralized system

**L2 Verification:**
- [ ] End-to-end trace visible for cross-service request
- [ ] RED metrics dashboard shows rate, errors, duration per endpoint
- [ ] Alert fires and routes to correct on-call within SLA
- [ ] Dashboard loads in under 5 seconds with 24h data

**L3 Verification:**
- [ ] SLO document exists with availability, latency, correctness targets
- [ ] Error budget dashboard shows remaining budget and burn rate
- [ ] Anomaly alert fires on synthetic traffic deviation
- [ ] Capacity projection exists for 3-month and 6-month horizons

---

## CHECKLIST

- [ ] Current maturity level assessed with diagnostic questions
- [ ] Target level identified based on current project phase
- [ ] Gap analysis completed between current and target
- [ ] Implementation roadmap cards created for each gap
- [ ] Phase gate observability criteria defined
- [ ] Tooling decisions documented (OpenTelemetry, Prometheus, Grafana, etc.)
- [ ] Team trained on dashboard usage and alert response
- [ ] Observability budget estimated (storage, tooling costs)

---

*Skill Version: 1.0 | Cross-Phase: 2, 3, 4, 5, 5.5, 5.75, 6, 7 | Priority: P0*
