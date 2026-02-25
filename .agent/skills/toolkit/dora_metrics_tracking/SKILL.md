---
name: DORA Metrics Tracking
description: Four-quadrant DORA metrics collection and reporting covering deployment frequency, lead time, change failure rate, and MTTR with elite/high/medium/low thresholds.
---

# DORA Metrics Tracking Skill

**Purpose**: Establish continuous measurement of the four DORA (DevOps Research and Assessment) metrics to provide an objective, industry-standard measure of software delivery performance. Anchored in Phase 7 maintenance with data collection beginning in Phase 5 deployment pipelines.

## TRIGGER COMMANDS

```text
"DORA metrics report"
"Deployment frequency"
"Change failure rate"
"Lead time for changes"
"MTTR report"
"/dora-report"
```

## When to Use
- Establishing a delivery performance baseline for a project
- Measuring improvement after process or tooling changes
- Preparing engineering health reports for leadership
- Identifying bottlenecks in the delivery pipeline
- Comparing team performance against industry benchmarks

---

## PROCESS

### Step 1: Define the Four Metrics

**1. Deployment Frequency (DF)**
How often the team deploys to production.

| Performance Level | Threshold |
|------------------|-----------|
| Elite | On-demand (multiple times per day) |
| High | Between once per day and once per week |
| Medium | Between once per week and once per month |
| Low | Less than once per month |

**Data Source**: CI/CD pipeline logs, GitHub deployments API, release tags.

**Collection Method:**
```bash
# Count production deployments in the last 30 days
gh api repos/{owner}/{repo}/deployments \
  --jq "[.[] | select(.environment==\"production\" and (.created_at | . >= \"$(date -d '30 days ago' +%Y-%m-%d)\"))] | length"
```

**2. Lead Time for Changes (LT)**
Time from code commit to code running in production.

| Performance Level | Threshold |
|------------------|-----------|
| Elite | Less than one hour |
| High | Between one day and one week |
| Medium | Between one week and one month |
| Low | More than one month |

**Data Source**: Merge timestamp (PR merged_at) to deployment timestamp.

**Collection Method:**
- Record `merged_at` from pull request
- Record `deployed_at` from deployment event
- Lead time = `deployed_at - merged_at`

**3. Change Failure Rate (CFR)**
Percentage of deployments that cause a failure in production.

| Performance Level | Threshold |
|------------------|-----------|
| Elite | 0-5% |
| High | 5-10% |
| Medium | 10-15% |
| Low | 16-30%+ |

**Data Source**: Incident records tagged with deployment, rollback events, hotfix deployments.

**Collection Method:**
- Count deployments that triggered rollback or hotfix within 24 hours
- CFR = (failed deployments / total deployments) x 100

**4. Mean Time to Recovery (MTTR)**
Time from production failure detection to resolution.

| Performance Level | Threshold |
|------------------|-----------|
| Elite | Less than one hour |
| High | Less than one day |
| Medium | Between one day and one week |
| Low | More than one week |

**Data Source**: Incident tracking system (PagerDuty, Opsgenie, GitHub Issues with incident label).

**Collection Method:**
- MTTR = mean(incident_resolved_at - incident_created_at) for the period

### Step 2: Establish Collection Pipeline

Set up automated data collection from existing tools.

**Minimum Viable Collection (Phase 5):**
1. Tag every production deployment with a timestamp
2. Record PR merge-to-deploy time in deployment metadata
3. Label incidents/rollbacks with the triggering deployment
4. Track incident open-to-close duration

**Enhanced Collection (Phase 7):**
1. GitHub Actions workflow that emits deployment events to a metrics store
2. Incident webhook that records MTTR automatically
3. Weekly cron job that aggregates and reports

### Step 3: Generate DORA Report

Produce a periodic (weekly or monthly) report.

```markdown
# DORA Metrics Report -- [Period]

## Summary

| Metric | Value | Level | Trend |
|--------|-------|-------|-------|
| Deployment Frequency | [X]/week | [Elite/High/Medium/Low] | [Up/Down/Stable] |
| Lead Time for Changes | [X] hours | [Elite/High/Medium/Low] | [Up/Down/Stable] |
| Change Failure Rate | [X]% | [Elite/High/Medium/Low] | [Up/Down/Stable] |
| Mean Time to Recovery | [X] hours | [Elite/High/Medium/Low] | [Up/Down/Stable] |

## Overall Performance: [Elite / High / Medium / Low]

## Trend Analysis (Last 4 Periods)

| Period | DF | LT | CFR | MTTR |
|--------|----|----|-----|------|
| [Period 1] | ... | ... | ... | ... |
| [Period 2] | ... | ... | ... | ... |
| [Period 3] | ... | ... | ... | ... |
| [Current] | ... | ... | ... | ... |

## Bottleneck Analysis
- **Longest Phase**: [Build / Review / QA / Deploy]
- **Root Cause**: [Description]
- **Recommended Action**: [Specific improvement]

## Incidents This Period
| Incident | Deployment | Detection Time | Resolution Time | MTTR |
|----------|-----------|----------------|-----------------|------|
| [ID] | [Deploy ID] | [Timestamp] | [Timestamp] | [Duration] |
```

### Step 4: Improvement Targeting

Based on the report, identify the lowest-performing metric and target improvement.

**Improvement Playbook by Metric:**

| Low Metric | Common Root Causes | Improvement Actions |
|-----------|-------------------|-------------------|
| Deployment Frequency | Manual deploy process, long release trains | Automate CI/CD, trunk-based development |
| Lead Time | Long code review cycles, manual QA gates | Auto-merge for low-risk, parallel testing |
| Change Failure Rate | Insufficient testing, no canary process | Expand test coverage, add canary verification |
| MTTR | No runbooks, poor observability, no on-call | Improve alerting, write runbooks, establish on-call |

---

## CHECKLIST

- [ ] All four metrics defined with data sources identified
- [ ] Automated collection pipeline established for deployment frequency
- [ ] Lead time tracking integrated into CI/CD pipeline
- [ ] Change failure rate tracking linked to incident management
- [ ] MTTR tracking linked to incident open/close timestamps
- [ ] Baseline report generated for current period
- [ ] Performance level assessed against DORA thresholds
- [ ] Improvement target selected based on lowest-performing metric
- [ ] Report cadence established (weekly or monthly)
- [ ] Historical trend tracking initialized

---

*Skill Version: 1.0 | Cross-Phase: 5 (collection), 7 (reporting) | Priority: P1*
