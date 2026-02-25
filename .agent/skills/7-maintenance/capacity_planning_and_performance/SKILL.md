---
name: Capacity Planning and Performance
description: Performance baseline establishment, monthly trend tracking, capacity forecasting, rightsizing, and cloud cost monitoring.
---

# Capacity Planning and Performance Skill

**Purpose**: Establishes performance baselines, tracks resource trends monthly, and forecasts capacity needs 6-12 months ahead. This skill prevents both over-provisioning (wasting money) and under-provisioning (causing outages) by making resource consumption visible, predictable, and actionable.

## TRIGGER COMMANDS

```text
"Capacity trends for [service]"
"Performance baselines"
"Forecast resource requirements"
"Rightsizing review"
"Cloud cost anomaly check"
```

## When to Use
- Establishing performance baselines for a new or existing service
- Monthly capacity review cadence
- Before a major launch or traffic event (Black Friday, marketing campaign)
- When cloud costs spike unexpectedly
- Planning infrastructure budget for next quarter

---

## PROCESS

### Step 1: Establish Performance Baselines

Capture baselines for every production service:

```markdown
## Performance Baseline: [Service Name]

**Captured**: [YYYY-MM-DD]
**Traffic Profile**: [Normal / Peak / Off-peak]
**Measurement Window**: 7-day rolling average

### Latency
| Percentile | Value | Threshold (Alert) |
|------------|-------|-------------------|
| p50 | [X] ms | [2x baseline] |
| p95 | [X] ms | [2x baseline] |
| p99 | [X] ms | [2x baseline] |

### Resource Utilization
| Resource | Current | Alert at 70% | Critical at 85% |
|----------|---------|---------------|-----------------|
| CPU (avg) | [X]% | [threshold] | [threshold] |
| Memory (avg) | [X]% | [threshold] | [threshold] |
| Disk I/O | [X] IOPS | [threshold] | [threshold] |
| Disk Space | [X]% used | 70% | 85% |
| DB Connections | [X] / [max] | 70% of pool | 85% of pool |
| Network I/O | [X] Mbps | [threshold] | [threshold] |

### Application Metrics
| Metric | Value | Alert Threshold |
|--------|-------|-----------------|
| Requests/sec | [X] | +/- 30% deviation |
| Error rate | [X]% | > 1% |
| Queue depth | [X] | > 100 |
| Cache hit rate | [X]% | < 80% |
| DB query p95 | [X] ms | > 100ms |
```

### Step 2: Monthly Trend Tracking

Run on the first week of every month. Flag any metric with >20% deviation from baseline.

```markdown
## Monthly Capacity Report — [YYYY-MM]

### Trend Summary (vs. Previous Month)
| Service | Metric | Last Month | This Month | Change | Flag |
|---------|--------|------------|------------|--------|------|
| API | RPS | 850 | 1020 | +20% | WATCH |
| API | p99 latency | 420ms | 390ms | -7% | OK |
| API | CPU avg | 45% | 52% | +16% | OK |
| DB | Connections | 120/200 | 155/200 | +29% | ALERT |
| DB | Disk used | 68% | 74% | +9% | WATCH |
| Cache | Hit rate | 92% | 88% | -4% | WATCH |

### Anomalies Detected
- [Describe any spikes, dips, or pattern changes]

### Actions Required
- [ ] [Action item with owner and deadline]
```

Deviation alert thresholds:
- **OK**: < 15% change -- no action needed
- **WATCH**: 15-25% change -- investigate cause, continue monitoring
- **ALERT**: > 25% change -- immediate investigation, may need scaling

### Step 3: Capacity Forecasting

Project resource needs based on growth trends:

```markdown
## Capacity Forecast: [Service Name]

**Growth Rate**: [X]% month-over-month (calculated from last 3 months)

### 6-Month Projection
| Resource | Current | +3 Months | +6 Months | Action Needed |
|----------|---------|-----------|-----------|---------------|
| CPU cores | 8 | 10 | 13 | Scale at month 4 |
| Memory GB | 32 | 38 | 48 | Upgrade at month 5 |
| Disk TB | 1.2 | 1.5 | 1.9 | Expand at month 3 |
| DB connections | 155/200 | 190/200 | 230/200 | Pool increase NOW |
| API rate limit | 80% used | 95% used | EXCEEDED | Request increase |

### 12-Month Projection
| Resource | +12 Months | Estimated Cost Delta |
|----------|------------|---------------------|
| Compute | [projection] | +$[X]/month |
| Storage | [projection] | +$[X]/month |
| Database | [projection] | +$[X]/month |
| Network | [projection] | +$[X]/month |
```

### Step 4: Rightsizing Recommendations

Identify over-provisioned and under-provisioned resources:

| Category | Indicator | Recommendation |
|----------|-----------|----------------|
| **Over-provisioned** | CPU avg < 20% for 30 days | Downsize instance type |
| **Over-provisioned** | Memory avg < 30% for 30 days | Reduce memory allocation |
| **Over-provisioned** | Reserved capacity > 2x peak usage | Release excess reservations |
| **Under-provisioned** | CPU avg > 70% for 7 days | Scale up or scale out |
| **Under-provisioned** | Memory avg > 80% | Increase allocation before OOM |
| **Under-provisioned** | Disk > 75% used | Expand volume, add retention policy |

### Step 5: Cloud Cost Monitoring

```markdown
## Monthly Cost Review — [YYYY-MM]

| Category | Budget | Actual | Variance | Notes |
|----------|--------|--------|----------|-------|
| Compute | $[X] | $[X] | [+/- %] | |
| Storage | $[X] | $[X] | [+/- %] | |
| Database | $[X] | $[X] | [+/- %] | |
| Network/CDN | $[X] | $[X] | [+/- %] | |
| AI/ML | $[X] | $[X] | [+/- %] | |
| **Total** | **$[X]** | **$[X]** | **[+/- %]** | |

### Anomalies
- [Any unexpected cost spikes with root cause]

### Optimization Opportunities
- [ ] [Savings opportunity with estimated $ impact]
```

Cost alert thresholds:
- **Daily spend > 130% of daily average**: Slack notification
- **Weekly spend > 120% of weekly budget**: Email to team lead
- **Monthly forecast > 110% of budget**: Escalate to manager

---

## CHECKLIST

- [ ] Performance baselines documented for every production service
- [ ] Monthly trend report generated and reviewed
- [ ] 20% deviation alerts configured in monitoring
- [ ] 6-month and 12-month capacity forecasts updated quarterly
- [ ] Rightsizing review completed (no resources idle > 30 days)
- [ ] Cloud cost budget alerts configured (daily, weekly, monthly)
- [ ] Cost anomaly investigation completed for any variance > 20%
- [ ] Pre-event capacity review done before major traffic events
- [ ] Forecast-driven infrastructure tickets filed 2+ months ahead

---

*Skill Version: 1.0 | Created: February 2026*
