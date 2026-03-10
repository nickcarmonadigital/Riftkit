---
description: Performance optimization workflow — data-driven process to baseline, profile, optimize, and verify application performance improvements with load testing and SLO tracking.
---

# /performance-optimization Workflow

> Use when performance needs improvement (slow responses, high resource usage, scaling concerns). Always baseline first — never optimize without measuring.

## When to Use

- [ ] Response times exceeding SLOs
- [ ] Resource utilization approaching capacity limits
- [ ] User complaints about slowness
- [ ] Pre-launch performance validation
- [ ] Post-scaling performance regression

---

## Step 1: Baseline — Capture Current Metrics

Establish measurable performance baselines before changing anything.

```bash
view_file .agent/skills/4-secure/performance_testing/SKILL.md
```

- [ ] Key user flows identified (login, dashboard load, search, CRUD operations)
- [ ] Response time measured per flow (p50, p95, p99)
- [ ] Throughput measured (requests/second at current load)
- [ ] Resource usage captured (CPU, memory, DB connections, disk I/O)
- [ ] Baseline document created with timestamps and methodology
- [ ] Performance budget defined (target metrics for each flow)

**Gate**: Do NOT proceed without documented baselines. You cannot prove improvement without them.

---

## Step 2: Profile — Identify Where Time is Spent

Instrument the application to find actual bottlenecks.

```bash
view_file .agent/skills/3-build/database_optimization/SKILL.md
view_file .agent/skills/3-build/observability/SKILL.md
```

- [ ] Database query analysis run (slow query log, EXPLAIN ANALYZE)
- [ ] N+1 queries identified
- [ ] Application profiling run (CPU flame graph, memory allocation)
- [ ] Network waterfall analyzed (frontend asset loading)
- [ ] Distributed tracing reviewed (service-to-service latency)
- [ ] Top 5 bottlenecks ranked by user impact

---

## Step 3: Identify Bottlenecks — Capacity Analysis

Map bottlenecks to capacity limits and scaling constraints.

```bash
view_file .agent/skills/7-maintenance/capacity_planning_and_performance/SKILL.md
```

- [ ] Bottleneck type classified (CPU-bound, I/O-bound, memory-bound, network-bound)
- [ ] Current capacity vs. projected growth analyzed
- [ ] Scaling strategy identified per bottleneck (vertical, horizontal, caching)
- [ ] Cost-benefit analysis for each optimization opportunity
- [ ] Optimization plan ordered by: highest impact, lowest effort first

---

## Step 4: Optimize — Apply Targeted Fixes

Fix the identified bottlenecks. One change at a time, measure after each.

```bash
view_file .agent/skills/3-build/database_optimization/SKILL.md
view_file .agent/skills/3-build/refactoring/SKILL.md
view_file .agent/skills/3-build/content_hash_cache/SKILL.md
```

- [ ] Database: indexes added for slow queries
- [ ] Database: N+1 queries fixed with eager loading or batching
- [ ] Caching: hot data cached (Redis, in-memory, CDN)
- [ ] Code: algorithmic improvements applied (O(n^2) -> O(n log n))
- [ ] Frontend: bundle size reduced, lazy loading added
- [ ] Each optimization measured individually against baseline

**Rule**: One optimization at a time. Measure after each. If no improvement, revert.

---

## Step 5: Load Test — Validate Under Stress

Verify improvements hold under realistic and peak load.

```bash
view_file .agent/skills/5.75-beta/load_testing/SKILL.md
```

- [ ] Load test scenarios match real user patterns
- [ ] Before/after comparison with identical test parameters
- [ ] Normal load test: sustained traffic at expected levels
- [ ] Peak load test: 2-3x normal traffic
- [ ] Stress test: find the breaking point
- [ ] Results documented: throughput, latency, error rate, resource usage

**Gate**: Performance must meet defined budget from Step 1. If not, return to Step 4.

---

## Step 6: Deploy — Canary with Metric Comparison

Roll out with real-time performance comparison.

```bash
view_file .agent/skills/5-ship/canary_verification/SKILL.md
```

- [ ] Canary deployed with 5% traffic
- [ ] Canary metrics compared to baseline (latency, error rate, resource usage)
- [ ] No performance regression in canary vs. control
- [ ] Gradual traffic increase (5% -> 25% -> 50% -> 100%)
- [ ] Rollback if any metric degrades beyond threshold

---

## Step 7: Monitor — SLO and Error Budget Impact

Verify sustained improvement in production.

```bash
view_file .agent/skills/7-maintenance/slo_sla_management/SKILL.md
```

- [ ] SLO compliance verified post-deployment (availability, latency)
- [ ] Error budget consumption rate stable or improved
- [ ] Performance dashboards updated with new baselines
- [ ] Alerting thresholds adjusted for new performance levels
- [ ] 7-day stability period confirmed
- [ ] Final before/after report shared with team

---

## Exit Checklist — Performance Optimized

- [ ] Baseline metrics documented (before)
- [ ] Optimized metrics documented (after)
- [ ] Improvement quantified (% improvement per metric)
- [ ] Load test results validate improvement under stress
- [ ] Production metrics confirm sustained improvement
- [ ] SLOs met or exceeded
- [ ] Performance dashboards and alerts updated

*Workflow Version: 1.0 | Created: March 2026*
