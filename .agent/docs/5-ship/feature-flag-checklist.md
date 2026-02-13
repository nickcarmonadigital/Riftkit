# Feature Flag Checklist

**Purpose**: Manage feature flags throughout their lifecycle -- from creation to rollout to cleanup. Prevents stale flags and ensures safe releases.

---

## Project Information

| Field | Value |
|-------|-------|
| **Project Name** | |
| **Date** | |
| **Author** | |
| **Flag Management Tool** | |

---

## Flag Inventory

> Track every flag in your system. Stale flags are tech debt -- review this monthly.

| Flag Name | Type | Status | Created | Owner | Description |
|-----------|------|--------|---------|-------|-------------|
| | ☐ Release ☐ Experiment ☐ Ops ☐ Permission | ☐ Active ☐ Rolled Out ☐ Stale | | | |
| | ☐ Release ☐ Experiment ☐ Ops ☐ Permission | ☐ Active ☐ Rolled Out ☐ Stale | | | |
| | ☐ Release ☐ Experiment ☐ Ops ☐ Permission | ☐ Active ☐ Rolled Out ☐ Stale | | | |
| | ☐ Release ☐ Experiment ☐ Ops ☐ Permission | ☐ Active ☐ Rolled Out ☐ Stale | | | |
| | ☐ Release ☐ Experiment ☐ Ops ☐ Permission | ☐ Active ☐ Rolled Out ☐ Stale | | | |

> **Flag types**:
> - **Release**: Toggle new features on/off for safe deployment
> - **Experiment**: A/B tests comparing variants
> - **Ops**: Kill switches for performance (e.g., disable heavy queries)
> - **Permission**: User-level access control (e.g., beta testers)

---

## Rollout Plan

> For each feature flag, define how you will gradually roll it out.

### Flag: _______________

| Stage | % of Users | Duration | Success Criteria | Rollback Trigger |
|-------|-----------|----------|-----------------|-----------------|
| 1. Internal only | 0% (team only) | 2-3 days | No errors in logs | Any crash or data corruption |
| 2. Canary | 5% | 3-5 days | Error rate < 0.1% | Error rate > 1% |
| 3. Early adopters | 25% | 1 week | Metrics stable | Metrics drop > 10% |
| 4. Broad rollout | 50% | 1 week | No support tickets | Support spike > 2x |
| 5. Full release | 100% | Permanent | All metrics green | N/A |

**Rollback procedure**:
- [ ] Turn flag OFF (instant rollback)
- [ ] Notify on-call team
- [ ] Document what went wrong
- [ ] Create incident ticket

---

## A/B Test Plan

> Use this when a flag is running an experiment to compare two or more variants.

| Field | Value |
|-------|-------|
| **Flag Name** | |
| **Hypothesis** | If we [change], then [metric] will [improve/decrease] by [amount] |
| **Primary Metric** | |
| **Secondary Metrics** | |

| Variant | Description | % Traffic | Target |
|---------|------------|-----------|--------|
| Control (A) | Current behavior | 50% | Baseline |
| Variant (B) | | 50% | |

| Field | Value |
|-------|-------|
| **Minimum Sample Size** | |
| **Expected Duration** | |
| **Statistical Significance Target** | 95% |
| **Start Date** | |
| **End Date** | |
| **Winner** | ☐ Control ☐ Variant ☐ Inconclusive |

---

## Flag Cleanup Schedule

> Flags that have been fully rolled out MUST be removed from code. Set a cleanup deadline within 2 weeks of full rollout.

| Flag Name | Full Rollout Date | Cleanup Deadline | Cleanup Status | PR Link |
|-----------|------------------|-----------------|----------------|---------|
| | | | ☐ Pending ☐ In Progress ☐ Done | |
| | | | ☐ Pending ☐ In Progress ☐ Done | |
| | | | ☐ Pending ☐ In Progress ☐ Done | |
| | | | ☐ Pending ☐ In Progress ☐ Done | |

---

## Pre-Launch Checklist

- [ ] Flag created in management tool
- [ ] Default value set to OFF
- [ ] Fallback behavior tested (flag off)
- [ ] Rollout plan documented above
- [ ] Rollback procedure tested
- [ ] Monitoring/alerts configured for flag-related metrics
- [ ] Team notified of rollout schedule
- [ ] Cleanup deadline set

---

## Notes

```
[Edge cases, flags with dependencies on other flags, user segment definitions]
```
