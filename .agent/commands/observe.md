---
description: Review observability setup including logging, metrics, tracing, health checks, alerting, and SLO status.
---

# Observe Command

Audits and reports on the observability posture of the current system.

## Instructions

1. **Logging Review**
   - Check structured logging is configured (JSON format preferred)
   - Verify log levels used appropriately (no sensitive data in logs)
   - Check log aggregation is configured (destination, retention)
   - Verify request ID / correlation ID propagation
   - Flag console.log / print statements that bypass structured logging

2. **Metrics Check**
   - Verify application metrics are instrumented (request rate, latency, errors)
   - Check RED metrics: Rate, Errors, Duration for each service
   - Check USE metrics for infrastructure: Utilization, Saturation, Errors
   - Verify custom business metrics are defined where appropriate
   - Check metrics export endpoint (/metrics or equivalent)

3. **Distributed Tracing**
   - Verify trace context propagation across service boundaries
   - Check span instrumentation on critical paths (DB queries, external calls)
   - Verify trace sampling configuration
   - Check trace export to backend (Jaeger, Zipkin, OTLP)

4. **Health Checks**
   - Verify /health or /healthz endpoint exists and returns correct format
   - Check readiness vs. liveness probe separation
   - Verify dependency health checks (database, cache, external services)
   - Check health endpoint is NOT behind authentication

5. **Alerting Review**
   - Check alert rules are defined for critical failures
   - Verify alert routing and notification channels
   - Check for alert fatigue (too many low-signal alerts)
   - Verify escalation policies exist

6. **SLO/SLA Status** (if `--check-slos`)
   - List defined SLOs with current burn rate
   - Check error budget remaining
   - Flag SLOs at risk of breaching
   - Review SLA commitments against actual performance

## Output

```
OBSERVABILITY: [GOOD/NEEDS WORK/POOR]

Logging:     [OK/X issues]    structured: [yes/no], aggregation: [configured/missing]
Metrics:     [OK/X issues]    RED: [yes/partial/no], export: [configured/missing]
Tracing:     [OK/X issues]    propagation: [yes/no], sampling: [X%]
Health:      [OK/X issues]    liveness: [yes/no], readiness: [yes/no]
Alerting:    [OK/X issues]    rules: [X defined], channels: [X configured]
SLOs:        [OK/X at risk]   (or: not checked, use --check-slos)

Top Issues:
1. [severity] [description] - [file:line or config location]
2. ...

Recommendations:
- [actionable improvement suggestion]
```

## Arguments

$ARGUMENTS can be:
- (none) - Review all observability areas
- `--check-slos` - Include SLO/SLA burn rate analysis
- `--focus logging` - Only review logging
- `--focus metrics` - Only review metrics instrumentation
- `--focus tracing` - Only review distributed tracing
- `--focus health` - Only review health checks
- `--focus alerting` - Only review alerting setup

## Example Usage

```
/observe
/observe --check-slos
/observe --focus health
/observe --focus metrics
```

## Agent

This command invokes the `sre-agent` located at:
`.agent/agents/sre-agent.md`

## Mapped Skills

- `observability` - Observability architecture and instrumentation
- `health_checks` - Health endpoint design and validation
- `slo_sla_management` - SLO definition and burn rate tracking
- `error_tracking` - Error capture and classification
- `multi_stack_observability` - Cross-service observability

## Related Commands

- `/deploy` - Check observability after deployments
- `/incident` - Use observability data during incidents
- `/verify` - Pre-deploy verification checks
