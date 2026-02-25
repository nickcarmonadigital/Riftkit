---
name: SLO/SLA Management
description: Ongoing SLO/SLA tracking, error budget management, burn-rate monitoring, and deployment freeze decisions.
---

# SLO/SLA Management Skill

**Purpose**: Keeps your reliability promises measurable and actionable. This skill provides templates for defining SLOs, calculates error budgets, monitors burn rates, and enforces deployment freezes when budgets are exhausted. It turns reliability from a feeling into a number.

## TRIGGER COMMANDS

```text
"SLO status"
"Error budget remaining"
"Should we deploy or freeze?"
"Define SLOs for [service]"
"Weekly SLO review"
"SLA breach report"
```

## When to Use
- Defining reliability targets for a new or existing service
- Weekly SLO review cadence meetings
- Before deploying to production (error budget check)
- After an incident to assess SLA/SLO impact
- When stakeholders ask "how reliable are we?"

---

## PROCESS

### Step 1: Define SLOs

Use this template for each service:

```markdown
## SLO Definition: [Service Name]

**Owner**: [Team/Person]
**Review Cadence**: Weekly
**Window**: Rolling 30 days

| SLI (Indicator) | Measurement | SLO Target | SLA Commitment |
|-----------------|-------------|------------|----------------|
| Availability | Successful requests / total requests | 99.9% | 99.5% |
| Latency (p50) | Median response time | < 100ms | < 300ms |
| Latency (p99) | 99th percentile response time | < 500ms | < 1000ms |
| Error Rate | 5xx responses / total responses | < 0.1% | < 0.5% |
| Throughput | Requests per second sustained | > 1000 rps | > 500 rps |
```

Key distinction:
- **SLO** (Service Level Objective): Internal target. Set tighter than SLA. This is your engineering goal.
- **SLA** (Service Level Agreement): External contract. Breach = penalties, credits, reputation damage.
- **SLI** (Service Level Indicator): The metric you actually measure.

### Step 2: Calculate Error Budget

```
Error Budget = 1 - SLO Target

Example (99.9% availability SLO, 30-day window):
  Budget = 1 - 0.999 = 0.001 = 0.1%
  Minutes in 30 days = 43,200
  Allowed downtime = 43,200 * 0.001 = 43.2 minutes/month
```

| SLO Target | Monthly Error Budget | Daily Budget |
|------------|---------------------|--------------|
| 99.0% | 432 min (7.2 hrs) | 14.4 min |
| 99.5% | 216 min (3.6 hrs) | 7.2 min |
| 99.9% | 43.2 min | 1.44 min |
| 99.95% | 21.6 min | 0.72 min |
| 99.99% | 4.32 min | 0.14 min |

### Step 3: Monitor Burn Rate

Burn rate indicates how fast you are consuming your error budget.

| Burn Rate | Meaning | Action |
|-----------|---------|--------|
| **< 1.0x** | Consuming slower than budget allows | Normal operations |
| **1.0x** | On pace to exactly exhaust budget | Monitor closely |
| **2.0x** | Will exhaust budget in half the window | Investigate, reduce risk |
| **5.0x** | Will exhaust in ~6 days (30-day window) | Halt non-critical deploys |
| **10.0x** | Will exhaust in ~3 days | Incident-level response |

Alert thresholds (recommended):
- **Page (wake someone up)**: 14.4x burn rate over 1 hour (exhausts 2% of budget in 1 hour)
- **Ticket (next business day)**: 3x burn rate over 6 hours
- **Email (awareness)**: 1.5x burn rate over 24 hours

### Step 4: Deployment Freeze Decision

Before every production deployment, check:

```
IF error_budget_remaining < 25% THEN
    FREEZE non-critical deployments
    ALLOW only:
      - Security patches (CVE critical/high)
      - Incident fixes
      - Reliability improvements
    REQUIRE:
      - VP/Director approval for exceptions
      - Canary deployment mandatory
      - Rollback plan documented

IF error_budget_remaining < 10% THEN
    HARD FREEZE all deployments
    Focus exclusively on reliability work
    Escalate to engineering leadership
```

### Step 5: Weekly SLO Review

Conduct every Monday (or your sprint boundary):

```markdown
## Weekly SLO Review — [Date]

### Service: [Name]
| SLI | Target | Actual (7d) | Budget Used | Burn Rate | Status |
|-----|--------|-------------|-------------|-----------|--------|
| Availability | 99.9% | 99.94% | 18% | 0.6x | OK |
| Latency p99 | 500ms | 480ms | 12% | 0.4x | OK |
| Error Rate | 0.1% | 0.08% | 8% | 0.3x | OK |

### Incidents This Week
- [INC-ID]: [summary], [X minutes] of downtime

### Budget Forecast
- Remaining: [X]% with [Y] days left in window
- Projected end-of-window: [OK / At risk / Will breach]

### Decisions
- [ ] Deploy/Freeze decision: [Deploy OK / Freeze enacted]
- [ ] Action items from incidents: [link]
```

### Step 6: SLA Breach Notification

When an SLA breach occurs or is imminent:

| Timeframe | Action |
|-----------|--------|
| **Breach imminent (< 48 hrs)** | Notify account management, prepare customer communication |
| **Breach occurred** | Trigger SLA credit calculation, send formal notification |
| **Post-breach** | Root cause analysis, corrective action plan, SLO tightening |

---

## CHECKLIST

- [ ] SLOs defined for every production service with SLI, target, and measurement method
- [ ] Error budgets calculated and tracked in monitoring dashboard
- [ ] Burn-rate alerts configured (page, ticket, email thresholds)
- [ ] Deployment freeze policy documented and enforced
- [ ] Weekly SLO review cadence established and attended
- [ ] SLA breach notification workflow tested
- [ ] SLO targets reviewed quarterly (tighten or relax based on data)
- [ ] Dashboard accessible to all engineering team members
- [ ] Historical SLO data retained for trend analysis (minimum 12 months)

---

*Skill Version: 1.0 | Created: February 2026*
