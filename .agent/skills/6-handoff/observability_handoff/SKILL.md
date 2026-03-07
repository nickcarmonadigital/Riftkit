---
name: Observability Handoff
description: Dashboard inventory transfer, alert rule documentation, on-call rotation setup, SLO status handoff, and runbook creation
---

# Observability Handoff Skill

**Purpose**: Transfer complete ownership of observability infrastructure -- dashboards, alerts, on-call rotations, runbooks, and SLO/error budget status -- to the receiving team or maintainer. A successful observability handoff ensures the new owner can monitor system health, respond to incidents, tune alerts, and manage error budgets without relying on the original team's tribal knowledge.

## TRIGGER COMMANDS

```text
"Observability handoff"
"Transfer dashboards"
"Alert ownership transfer"
"On-call handoff"
"SLO status handoff"
```

## When to Use
- Transitioning a service to a new team or maintainer
- Completing a project and handing monitoring to operations
- Onboarding a new on-call engineer to a service
- Transferring SLO/error budget ownership after a reorg
- Documenting observability setup before team departure

### Cross-References
- **monitoring_handoff** -- lower-level monitoring infrastructure transfer
- **sla_handoff** -- contractual SLA commitment transfer
- **slo_sla_management** -- ongoing SLO/SLA management practices

---

## PROCESS

### Step 1: Dashboard Inventory and Ownership Transfer

Catalog every dashboard associated with the service and transfer ownership.

**Dashboard inventory template:**

| Dashboard | Platform | URL | Purpose | Owner (Current) | Owner (New) | Last Updated |
|-----------|----------|-----|---------|-----------------|-------------|--------------|
| Service Overview | Grafana | /d/svc-overview | Request rate, latency, errors | @alice | @bob | 2026-02-15 |
| Infrastructure | Datadog | /dash/infra-123 | CPU, memory, disk, network | @alice | @bob | 2026-01-20 |
| Business Metrics | Grafana | /d/biz-metrics | Revenue, signups, conversions | @alice | @carol | 2026-03-01 |
| Database Health | Grafana | /d/db-health | Query latency, connections, replication | @alice | @bob | 2026-02-28 |
| Deployment Tracker | Datadog | /dash/deploys | Deploy frequency, rollback rate | @alice | @bob | 2026-02-10 |

**Transfer actions:**

```markdown
## Dashboard Transfer Checklist
- [ ] Export all dashboard JSON definitions to version control
- [ ] Transfer dashboard ownership in Grafana/Datadog UI
- [ ] Verify new owner has edit permissions
- [ ] Update dashboard contact/team annotations
- [ ] Remove departing team members from dashboard notification channels
- [ ] Document any dashboard variables or template parameters
- [ ] Note dashboards that depend on specific data sources or queries
```

**Grafana dashboard export:**

```bash
# Export all dashboards for a folder
for uid in $(curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
  "$GRAFANA_URL/api/search?folderIds=0" | jq -r '.[].uid'); do
  curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
    "$GRAFANA_URL/api/dashboards/uid/$uid" > "dashboards/${uid}.json"
done
```

### Step 2: Alert Rule Documentation and Tuning Guidance

Document every alert, its intent, thresholds, and tuning history.

**Alert documentation template:**

```markdown
## Alert: High Error Rate (5xx)
- **Severity**: P1 (page)
- **Condition**: error_rate > 1% for 5 minutes
- **Data source**: Prometheus metric `http_requests_total{status=~"5.."}`
- **Why this threshold**: Baselined at 0.2% normal. 1% = 5x normal, confirmed impact.
- **Tuning history**:
  - 2026-01-15: Raised from 0.5% to 1% (too many false positives from health checks)
  - 2026-02-20: Added exclusion for /healthz endpoint
- **Response**: See Runbook #3 (High Error Rate)
- **Known false positives**: Spike during daily batch job (02:00-02:15 UTC)
- **Suppression window**: None active

## Alert: High Latency (p99)
- **Severity**: P2 (notify)
- **Condition**: p99_latency > 2s for 10 minutes
- **Data source**: Prometheus histogram `http_request_duration_seconds`
- **Why this threshold**: SLO target is p99 < 1.5s. 2s alert gives buffer before SLO breach.
- **Tuning history**:
  - 2026-02-01: Changed window from 5m to 10m (transient spikes are acceptable)
- **Response**: See Runbook #5 (Latency Degradation)
- **Known false positives**: Cache cold-start after deployment (first 2-3 minutes)
```

**Alert inventory table:**

| Alert Name | Severity | Condition | Runbook | Last Fired | False Positive Rate |
|------------|----------|-----------|---------|------------|---------------------|
| High Error Rate | P1 | error_rate > 1% for 5m | #3 | 2026-02-28 | Low (~1/month) |
| High Latency p99 | P2 | p99 > 2s for 10m | #5 | 2026-03-01 | Medium (post-deploy) |
| Disk Usage | P2 | disk_used > 85% | #7 | 2026-02-15 | Low |
| Pod Restart Loop | P1 | restarts > 3 in 15m | #2 | 2026-02-20 | None |
| Certificate Expiry | P2 | days_to_expiry < 14 | #9 | 2026-02-01 | None |
| Error Budget Burn | P1 | burn_rate > 10x for 1h | #1 | 2026-03-02 | Low |

### Step 3: On-Call Rotation Setup and Escalation Paths

```markdown
## On-Call Rotation

### Primary Rotation
- **Schedule**: Weekly, Monday 09:00 UTC to Monday 09:00 UTC
- **Platform**: PagerDuty / Opsgenie
- **Team members**: @bob, @carol, @dave, @eve (4-week cycle)
- **Handoff**: Monday standup -- outgoing briefs incoming on active issues

### Escalation Path
| Level | Who | Response Time | When |
|-------|-----|---------------|------|
| L1 | On-call primary | 15 minutes | All P1/P2 alerts |
| L2 | On-call secondary | 30 minutes | P1 not ack'd in 15m |
| L3 | Engineering manager | 1 hour | P1 not resolved in 1h |
| L4 | VP Engineering | 2 hours | Customer-facing outage > 1h |

### On-Call Expectations
- Acknowledge P1 alerts within 15 minutes
- Acknowledge P2 alerts within 30 minutes
- P3/P4 alerts are worked during business hours
- Update incident channel every 30 minutes during active P1
- Write incident report within 48 hours of P1 resolution

### On-Call Tooling Access
- [ ] PagerDuty/Opsgenie account with correct escalation policy
- [ ] VPN access for production systems
- [ ] SSH/kubectl access to production clusters
- [ ] Database read-only access for debugging
- [ ] Log aggregator access (Datadog, Loki, CloudWatch)
- [ ] Feature flag system access (LaunchDarkly, etc.)
```

### Step 4: Runbook for Common Alert Scenarios

```markdown
## Runbook #1: Error Budget Burn Rate Alert

### Context
This alert fires when the 1-hour error budget burn rate exceeds 10x,
meaning the service will exhaust its monthly error budget within ~3 days
at the current rate.

### Triage Steps
1. Check the error rate dashboard: [link]
2. Identify error type:
   - 5xx from application? Check application logs.
   - 5xx from infrastructure? Check pod health, node status.
   - Timeout errors? Check downstream dependencies.
3. Check recent deployments: `kubectl rollout history deployment/myapp`
4. Check dependency health: [dependency dashboard link]

### Common Causes and Fixes
| Cause | Symptoms | Fix |
|-------|----------|-----|
| Bad deployment | Errors started at deploy time | `kubectl rollout undo deployment/myapp` |
| Database overload | Slow queries, connection pool exhaustion | Scale read replicas, kill long queries |
| Downstream outage | Timeout errors to specific service | Enable circuit breaker, check dependency status |
| Memory leak | OOMKilled pods, increasing memory | Restart pods, investigate heap dumps |
| Traffic spike | All metrics elevated proportionally | Scale horizontally, enable rate limiting |

### Escalation
If not resolved within 30 minutes, escalate to L2.
If customer-facing impact confirmed, declare incident in #incidents channel.
```

### Step 5: SLO/Error Budget Current Status Handoff

```markdown
## SLO Status as of [handoff date]

### Active SLOs
| SLO | Target | Current (30d) | Error Budget Remaining | Status |
|-----|--------|---------------|----------------------|--------|
| Availability | 99.9% | 99.95% | 72% (32min remaining) | GREEN |
| Latency (p99) | < 1.5s | 1.1s | 85% | GREEN |
| Throughput | > 1000 rps | 1450 rps | N/A | GREEN |
| Data freshness | < 5min | 2.3min | 90% | GREEN |

### Error Budget Policy
- **GREEN (>50% remaining)**: Normal development velocity, deploy freely
- **YELLOW (25-50% remaining)**: Reduce risky deployments, prioritize reliability work
- **RED (<25% remaining)**: Freeze non-critical deploys, all hands on reliability

### Error Budget Burn History (Last 90 Days)
- 2026-01-15: 8% burn from database migration (45min elevated errors)
- 2026-02-02: 3% burn from certificate rotation issue (15min)
- 2026-02-28: 12% burn from cloud provider incident (1h partial outage)

### SLO Review Cadence
- Monthly: Review SLO metrics in team standup (first Monday)
- Quarterly: Formal SLO review with stakeholders, adjust targets if needed
- Annually: Full SLO framework reassessment
```

### Step 6: Observability Cost Attribution and Budget

```markdown
## Observability Cost Summary

### Monthly Costs
| Service | Provider | Monthly Cost | Purpose |
|---------|----------|-------------|---------|
| Metrics ingestion | Datadog | $X,XXX | Custom metrics, APM traces |
| Log storage | Datadog | $X,XXX | Application + infrastructure logs |
| Uptime monitoring | Datadog | $XXX | Synthetic checks |
| Alerting | PagerDuty | $XXX | On-call rotation, incident mgmt |
| Dashboard hosting | Grafana Cloud | $XXX | Team dashboards |
| **Total** | | **$X,XXX** | |

### Cost Optimization Notes
- Custom metrics are the largest cost driver. Review unused metrics quarterly.
- Log sampling is set to 50% for debug-level logs. Do not increase without budget approval.
- Trace sampling is set to 10% for high-volume endpoints.
- Archive logs older than 30 days to cold storage (currently S3 Glacier).

### Budget Owner
- Current: @alice (transferring to @bob)
- Budget approval threshold: Changes > $500/month require manager approval
```

### Step 7: Known Noisy Alerts and Suppression Rules

```markdown
## Known Noisy Alerts

| Alert | Noise Pattern | Current Mitigation | Recommended Fix |
|-------|--------------|--------------------|-----------------|
| High CPU | Spikes to 95% during daily ETL (03:00-03:30 UTC) | Maintenance window suppression | Tune threshold to 95% sustained 10m |
| Disk Usage | /tmp fills during log rotation | Auto-clears within 5 minutes | Add tmpwatch cron job |
| Health Check Failures | Flaps during rolling deploys | 3-minute grace period after deploy | Increase readiness probe timeout |
| Connection Pool | Brief spikes on cold-start | Currently ignored manually | Add warm-up period to alert condition |

### Active Suppression Rules
| Rule | Scope | Window | Reason | Expires |
|------|-------|--------|--------|---------|
| ETL maintenance | CPU, memory alerts | Daily 03:00-03:30 UTC | Known ETL spike | Permanent |
| Deploy grace | All P2 alerts | 3 min post-deploy | Rolling update noise | Permanent |
```

---

## CHECKLIST

- [ ] Dashboard inventory completed with URLs, purposes, and new owners assigned
- [ ] Dashboard JSON definitions exported to version control
- [ ] Dashboard ownership transferred in monitoring platform UI
- [ ] Every alert rule documented with threshold rationale and tuning history
- [ ] Alert-to-runbook mapping complete (every P1/P2 alert has a runbook)
- [ ] On-call rotation created with correct schedule and team members
- [ ] Escalation path documented and configured in PagerDuty/Opsgenie
- [ ] New on-call members have all required tooling access
- [ ] Runbooks written for top 5 most common alert scenarios
- [ ] SLO current status documented with error budget remaining
- [ ] Error budget policy documented (green/yellow/red actions)
- [ ] SLO review cadence established (monthly/quarterly)
- [ ] Observability cost breakdown documented with budget owner transferred
- [ ] Noisy alerts documented with known patterns and recommended fixes
- [ ] Suppression rules documented with expiration dates
- [ ] New owner has walked through each dashboard and alert in a live session

*Skill Version: 1.0 | Created: March 2026*
