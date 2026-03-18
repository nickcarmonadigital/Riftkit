---
name: Delivery Metrics
description: DORA metrics instrumentation capturing deployment frequency, lead time, MTTR, and change failure rate with tier classification.
---

# Delivery Metrics Skill

**Purpose**: Instruments the framework to capture and report DORA (DevOps Research and Assessment) metrics: deployment frequency, lead time for changes, mean time to recovery, and change failure rate. Stores data in `.agent/metrics/dora.json` and provides reporting with Elite/High/Medium/Low tier classification so teams can objectively measure their delivery performance.

## TRIGGER COMMANDS

```text
"DORA metrics"
"Deployment frequency report"
"Lead time analysis"
"What's our MTTR?"
"Change failure rate"
"Metrics report for [period]"
```

## When to Use
- Sprint retrospectives to ground discussions in data
- Engineering leadership reporting
- Identifying bottlenecks in the delivery pipeline
- Tracking improvement over time after process changes
- Justifying investment in CI/CD, testing, or automation

---

## PROCESS

### Step 1: Data Collection Setup

Configure data sources for each DORA metric:

```markdown
## Metrics Data Sources

| Metric | Data Source | Collection Method |
|--------|-----------|-------------------|
| Deployment Frequency | Git tags matching `v*` or `release-*` | `git tag --sort=-creatordate` |
| Lead Time for Changes | First commit on branch to production deploy | `git log` branch creation to merge + deploy timestamp |
| MTTR | Incident start timestamp to resolution timestamp | Incident tracker (PagerDuty, Opsgenie, manual log) |
| Change Failure Rate | Hotfix/rollback deploys / total deploys | Git tags with `hotfix-*` or rollback events |
```

Storage at `.agent/metrics/dora.json`:
```json
{
  "version": "1.0",
  "project": "[project name]",
  "collection_period": {
    "start": "YYYY-MM-DD",
    "end": "YYYY-MM-DD"
  },
  "deployments": [
    {
      "id": "deploy-001",
      "timestamp": "ISO-8601",
      "tag": "v1.2.3",
      "is_hotfix": false,
      "is_rollback": false,
      "lead_time_hours": 48
    }
  ],
  "incidents": [
    {
      "id": "INC-001",
      "started": "ISO-8601",
      "resolved": "ISO-8601",
      "mttr_minutes": 45,
      "caused_by_deploy": "deploy-001"
    }
  ]
}
```

### Step 2: DORA Metric Calculations

**Deployment Frequency**: Count of production deployments per time period.
```
DF = count(deployments) / days_in_period
```

**Lead Time for Changes**: Time from first commit to production deployment.
```
LT = median(deploy.timestamp - branch.first_commit) across all deploys
```

**Mean Time to Recovery**: Average time from incident detection to resolution.
```
MTTR = mean(incident.resolved - incident.started) across all incidents
```

**Change Failure Rate**: Percentage of deployments causing incidents.
```
CFR = count(hotfixes + rollbacks) / count(total_deployments) * 100
```

### Step 3: Tier Classification

Classify each metric using DORA research benchmarks:

| Metric | Elite | High | Medium | Low |
|--------|-------|------|--------|-----|
| **Deployment Frequency** | On-demand (multiple/day) | Weekly to monthly | Monthly to 6-monthly | > 6 months |
| **Lead Time** | < 1 hour | 1 day to 1 week | 1 week to 1 month | > 1 month |
| **MTTR** | < 1 hour | < 1 day | < 1 week | > 1 week |
| **Change Failure Rate** | 0-5% | 5-10% | 10-15% | > 15% |

**Overall tier**: Use the lowest individual metric tier (weakest link).

### Step 4: Generate Metrics Report

```markdown
## DORA Metrics Report — [Period]

**Project**: [name]
**Period**: [start] to [end]
**Overall Tier**: [Elite / High / Medium / Low]

### Metrics Summary
| Metric | Value | Tier | Trend |
|--------|-------|------|-------|
| Deployment Frequency | [X] deploys/week | [tier] | [up/down/stable] |
| Lead Time for Changes | [X] hours (median) | [tier] | [up/down/stable] |
| Mean Time to Recovery | [X] minutes (mean) | [tier] | [up/down/stable] |
| Change Failure Rate | [X]% | [tier] | [up/down/stable] |

### Deployment History
| Week | Deploys | Hotfixes | Rollbacks | CFR |
|------|---------|----------|-----------|-----|
| W1 | [n] | [n] | [n] | [%] |
| W2 | [n] | [n] | [n] | [%] |

### Incidents This Period
| ID | Duration | MTTR | Caused By |
|----|----------|------|-----------|
| [id] | [duration] | [minutes] | [deploy/infra/external] |

### Recommendations
- [Specific recommendation to improve the weakest metric]
- [Second recommendation if applicable]

### Comparison (vs. Previous Period)
| Metric | Previous | Current | Delta |
|--------|----------|---------|-------|
| DF | [val] | [val] | [+/- %] |
| LT | [val] | [val] | [+/- %] |
| MTTR | [val] | [val] | [+/- %] |
| CFR | [val] | [val] | [+/- %] |
```

### Step 5: Actionable Improvement Playbook

Based on which metric is weakest:

| Weakest Metric | Root Causes to Investigate | Improvement Actions |
|---------------|---------------------------|---------------------|
| **Deployment Frequency** | Manual deploy process, long QA cycle, fear of deploys | Automate CI/CD, reduce batch size, implement feature flags |
| **Lead Time** | Long code review queues, manual testing, approval bottlenecks | Pair programming, automated tests, async reviews |
| **MTTR** | No runbooks, poor observability, unclear escalation | Write runbooks, improve alerts, practice incident response |
| **Change Failure Rate** | Insufficient testing, no canary deploys, poor code review | Increase test coverage, canary/blue-green deploys, enforce review |

---

## CHECKLIST

- [ ] Data sources configured for all four DORA metrics
- [ ] `.agent/metrics/dora.json` created and populated
- [ ] Deployment events tracked (including hotfixes and rollbacks)
- [ ] Incident timestamps captured (start and resolution)
- [ ] Tier classification computed using DORA benchmarks
- [ ] Metrics report generated for current period
- [ ] Trend comparison available (current vs. previous period)
- [ ] Improvement actions identified for weakest metric
- [ ] Report shared with engineering team (sprint retro or monthly review)

---

*Skill Version: 1.0 | Created: February 2026*


## Related Skills
- [`dora_metrics_tracking`](../dora_metrics_tracking/SKILL.md)
