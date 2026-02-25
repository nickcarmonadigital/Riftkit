---
name: SLA Handoff
description: Define and communicate GA service level agreements with SLO definitions, error budget policies, and change freeze procedures
---

# SLA Handoff Skill

**Purpose**: Transition from beta service levels to production-grade SLA commitments for general availability. This skill defines SLOs per service tier, establishes error budget policies, documents change freeze procedures for high-traffic periods, and produces the SLA communication document for customers. GA SLAs are contractual obligations -- getting them wrong creates legal and financial exposure.

## TRIGGER COMMANDS

```text
"Define GA SLAs"
"SLA handoff document"
"Error budget policy"
"Service level commitments for [project]"
"Using sla_handoff skill: define SLAs for [project]"
```

## When to Use

- Transitioning from beta SLAs (see `beta_sla_definition`) to production SLAs
- Defining service tier commitments for different customer plans
- Establishing error budget policies to balance reliability and velocity
- Preparing SLA documentation for enterprise customers or contracts

---

## PROCESS

### Step 1: Define SLOs Per Service Tier

Different customer tiers get different commitments. Base these on load test data and beta operational history.

```markdown
# SLO Definitions by Service Tier

## Availability SLOs

| Tier | Monthly Uptime | Allowed Downtime | Measurement |
|------|---------------|-----------------|-------------|
| Enterprise | 99.95% | 21.9 minutes/month | Synthetic checks every 30s |
| Pro | 99.9% | 43.8 minutes/month | Synthetic checks every 60s |
| Free | 99.5% | 3.6 hours/month | Best effort monitoring |

## Latency SLOs

| Tier | p50 | p95 | p99 | Measurement |
|------|-----|-----|-----|-------------|
| Enterprise | < 100ms | < 300ms | < 1000ms | APM per-request tracing |
| Pro | < 200ms | < 500ms | < 2000ms | APM sampling (10%) |
| Free | < 500ms | < 1500ms | < 5000ms | Aggregate metrics |

## Throughput SLOs

| Tier | Rate Limit | Burst Limit |
|------|-----------|-------------|
| Enterprise | 1000 RPM | 100 RPS burst |
| Pro | 300 RPM | 30 RPS burst |
| Free | 60 RPM | 10 RPS burst |

## Data Durability SLO

| Commitment | Target | Implementation |
|-----------|--------|---------------|
| Committed write durability | 99.999% | Synchronous replication + daily backups |
| Backup RPO (Recovery Point Objective) | 1 hour | PITR enabled |
| Backup RTO (Recovery Time Objective) | 4 hours | Tested quarterly |
```

### Step 2: Establish Error Budget Policy

Error budgets balance reliability with development velocity. When the budget is exhausted, feature work pauses.

```markdown
# Error Budget Policy

## Calculation

Monthly error budget = (1 - SLO) * total minutes

Example (Enterprise, 99.95% SLO):
  Budget = 0.05% * 43,200 minutes = 21.6 minutes

## Budget States

| Budget Remaining | State | Actions |
|-----------------|-------|---------|
| > 50% | GREEN | Normal development and deployment pace |
| 25-50% | YELLOW | Reduce deployment frequency, prioritize reliability work |
| 10-25% | ORANGE | Deployment freeze for non-critical changes, incident review |
| < 10% | RED | Full deployment freeze, all hands on reliability |
| 0% (exhausted) | CRITICAL | No deployments until budget resets, formal incident review |

## Budget Burn Rate Alerts

| Alert | Condition | Action |
|-------|-----------|--------|
| Fast burn | > 5% budget consumed in 1 hour | Page on-call, investigate immediately |
| Slow burn | > 50% budget consumed with > 50% month remaining | Slack alert to engineering lead |
| Budget warning | 25% budget remaining | Email to engineering team |
| Budget critical | 10% budget remaining | Page engineering manager |

## Error Budget Exceptions

The following do NOT consume error budget:
- Scheduled maintenance within announced windows
- Third-party provider outages (documented in post-incident review)
- Force majeure events

The following DO consume error budget:
- Unplanned outages (regardless of cause)
- Degraded performance exceeding SLO thresholds
- Failed deployments that impact users
```

### Step 3: Define Change Freeze Policies

Protect reliability during high-traffic or high-risk periods.

| Freeze Type | When | Duration | What Is Frozen | Exceptions |
|------------|------|----------|---------------|-----------|
| **Holiday freeze** | Major holidays, Black Friday | 3-7 days | All non-critical deployments | Security patches, SEV1 fixes |
| **Traffic spike freeze** | Planned marketing events | 24h before to 24h after | Feature deployments | Bug fixes only |
| **Error budget freeze** | Budget < 10% | Until budget resets or incident resolved | All deployments | Reliability improvements only |
| **Pre-GA freeze** | 48 hours before GA launch | 48 hours | Everything except launch checklist | Launch-blocking fixes only |

**Freeze Announcement Template**:

```text
Subject: [Change Freeze] [Type] - [Start Date] to [End Date]

Team,

A change freeze is in effect from [start] to [end] due to [reason].

During this period:
- NO feature deployments
- NO database migrations
- NO infrastructure changes

Exceptions (requires Engineering Manager approval):
- Security patches for active CVEs
- Fixes for SEV1/SEV2 incidents
- Reliability improvements related to error budget

To request an exception, contact [Name] with justification.

-- [Engineering Lead]
```

### Step 4: Produce the Customer-Facing SLA Document

This is the document customers see. Keep it clear and non-technical.

```markdown
# [Product Name] Service Level Agreement

**Effective Date**: YYYY-MM-DD
**Version**: 1.0

## Service Availability

| Plan | Monthly Uptime Commitment |
|------|--------------------------|
| Enterprise | 99.95% |
| Pro | 99.9% |
| Free | Best effort (no SLA) |

Uptime is measured as the percentage of time the core API endpoints
return successful responses, excluding scheduled maintenance windows.

## Scheduled Maintenance

- **Window**: Tuesdays 2:00-4:00 AM UTC
- **Notice**: 72 hours for planned maintenance
- **Emergency maintenance**: 1 hour notice, communicated via status page

## Support Response Times

| Plan | SEV1 (Critical) | SEV2 (Major) | SEV3 (Minor) |
|------|-----------------|-------------|-------------|
| Enterprise | 1 hour, 24/7 | 4 hours, business hours | 1 business day |
| Pro | 4 hours, business hours | 1 business day | 2 business days |
| Free | Community forum only | Community forum only | Community forum only |

## SLA Credits

If we fail to meet the uptime commitment in a calendar month,
affected Enterprise and Pro customers are eligible for service credits:

| Monthly Uptime | Credit (% of monthly fee) |
|---------------|--------------------------|
| 99.0% - 99.9% | 10% |
| 95.0% - 99.0% | 25% |
| < 95.0% | 50% |

Credits must be requested within 30 days of the incident.
Credits do not exceed 50% of the monthly fee.

## Exclusions

This SLA does not apply to:
- Features labeled as "Beta" or "Preview"
- Free plan users
- Outages caused by user misconfiguration
- Force majeure events
- Scheduled maintenance within announced windows
```

### Step 5: Internal Escalation Triggers

Define when the team must act based on SLA risk.

| Trigger | Condition | Action | Owner |
|---------|-----------|--------|-------|
| SLA breach imminent | Error budget < 10% for any tier | Deploy freeze + incident review | Engineering Manager |
| SLA breach occurred | Monthly uptime below commitment | Post-incident review within 48h | Engineering Lead |
| SLA credit exposure | Customer eligible for credit > $1000 | Notify Finance + Executive | Support Lead |
| Trend deterioration | 3 consecutive weeks with increased downtime | Reliability sprint planning | Engineering Lead |

---

## CHECKLIST

- [ ] SLOs defined for each service tier (availability, latency, throughput, durability)
- [ ] SLOs grounded in measured data from load testing and beta operations
- [ ] Error budget policy established with clear states and escalation triggers
- [ ] Error budget burn rate alerts configured in monitoring system
- [ ] Change freeze policies defined for holidays, traffic spikes, and budget exhaustion
- [ ] Customer-facing SLA document produced and reviewed by legal
- [ ] SLA credit structure defined with clear calculation and claim process
- [ ] Internal escalation triggers defined for SLA breach risk
- [ ] SLA document integrated into customer contracts and pricing page
- [ ] Monitoring dashboards created for real-time SLO tracking
- [ ] SLA metrics feed into `operational_readiness_review` scorecard

---

*Skill Version: 1.0 | Created: February 2026*
