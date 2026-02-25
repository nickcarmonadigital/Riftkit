---
name: Beta Graduation Criteria
description: Measurable exit gates and GA readiness assessment for transitioning from beta to general availability
---

# Beta Graduation Criteria Skill

**Purpose**: Define and evaluate measurable exit gates that determine whether a product is ready to graduate from beta to general availability. This skill aggregates outputs from all other beta skills into a single GA readiness decision, preventing premature launches that damage trust and delayed launches that burn runway.

## TRIGGER COMMANDS

```text
"Define beta exit criteria"
"Beta graduation checklist"
"GA readiness assessment"
"Are we ready for GA?"
"Using beta_graduation_criteria skill: evaluate [project]"
```

## When to Use

- Setting up a beta program and need to define what "done" looks like
- Approaching the end of beta and need a go/no-go decision
- Stakeholders are pressuring for GA launch and you need objective criteria
- Reviewing beta metrics to determine readiness

---

## PROCESS

### Step 1: Define Graduation Metrics

Establish measurable thresholds before beta begins. Do not define these retroactively.

| Category | Metric | Threshold | Source |
|----------|--------|-----------|--------|
| **Stability** | Error rate (5xx responses) | < 0.1% of requests | Error tracking (Sentry) |
| **Stability** | Crash-free session rate | >= 99.5% | Error tracking |
| **Performance** | p95 API latency | < 500ms | Load testing / APM |
| **Performance** | p99 API latency | < 2000ms | Load testing / APM |
| **Bugs** | Open P0 bugs | 0 | Issue tracker |
| **Bugs** | Open P1 bugs | <= 3 | Issue tracker |
| **Bugs** | P0 feedback resolution rate | >= 95% | Feedback system |
| **Adoption** | 7-day retention | >= 40% | Product analytics |
| **Adoption** | Activation rate | >= 60% | Product analytics |
| **Adoption** | Minimum beta users | >= 50 users from >= 5 orgs | Beta cohort data |
| **Billing** | Metering accuracy | 100% reconciled | Usage metering |
| **Security** | Open critical vulnerabilities | 0 | Security audit |

> Adjust thresholds to your product context. A developer tool may tolerate higher latency; a payments product demands lower error rates.

### Step 2: Build the Readiness Scorecard

Create a living document that aggregates all metrics. Update it weekly during beta.

```markdown
# GA Readiness Scorecard - [Project Name]
**Last Updated**: YYYY-MM-DD
**Overall Status**: NOT READY / CONDITIONAL / READY

## Metric Status

| # | Metric | Target | Current | Status |
|---|--------|--------|---------|--------|
| 1 | Error rate | < 0.1% | 0.08% | PASS |
| 2 | Crash-free sessions | >= 99.5% | 99.7% | PASS |
| 3 | p95 latency | < 500ms | 620ms | FAIL |
| 4 | Open P0 bugs | 0 | 0 | PASS |
| 5 | Open P1 bugs | <= 3 | 5 | FAIL |
| 6 | 7-day retention | >= 40% | 43% | PASS |
| 7 | Activation rate | >= 60% | 55% | FAIL |
| 8 | Min beta users | >= 50 / 5 orgs | 72 / 8 orgs | PASS |
| 9 | Metering accuracy | 100% | 100% | PASS |
| 10 | Critical vulns | 0 | 0 | PASS |

## Decision
- PASS count: 7/10
- FAIL count: 3/10
- Blocking FAILs: #3 (performance), #5 (bugs), #7 (adoption)
- Recommendation: NOT READY - address blocking items, re-evaluate in 1 week
```

### Step 3: Run the Graduation Review

Conduct a formal review meeting when metrics approach thresholds.

**Review Agenda**:

1. **Scorecard walkthrough** -- present each metric with trend data (improving, stable, declining)
2. **Blocking item review** -- for each FAIL, present a remediation plan with timeline
3. **Risk assessment** -- identify risks that metrics do not capture (e.g., upcoming infrastructure changes, key personnel leaving)
4. **Stakeholder input** -- product, engineering, support, and sales each present readiness from their perspective
5. **Go/No-Go decision** -- unanimous consent required for GO; any stakeholder can block

**Decision Framework**:

| Condition | Decision |
|-----------|----------|
| All metrics PASS | GO -- proceed to `beta_to_ga_migration` |
| 1-2 non-critical metrics FAIL with remediation plan | CONDITIONAL GO -- set a hard deadline for remaining items |
| Any critical metric FAIL (stability, security, billing) | NO GO -- remediate and schedule re-review |
| Trend data shows decline | NO GO -- investigate root cause before proceeding |

### Step 4: Produce the GA Readiness Report

Generate a formal artifact that serves as the gate document.

```markdown
# GA Readiness Report

**Project**: [Name]
**Date**: YYYY-MM-DD
**Decision**: GO / CONDITIONAL GO / NO GO
**Next Review Date**: YYYY-MM-DD (if not GO)

## Executive Summary
[2-3 sentences summarizing readiness status]

## Scorecard Summary
- Metrics passing: X/Y
- Metrics failing: Z/Y
- Trend: Improving / Stable / Declining

## Blocking Items
| Item | Owner | Remediation Plan | ETA |
|------|-------|-----------------|-----|
| p95 latency > 500ms | Backend team | Optimize N+1 queries in /api/reports | Feb 28 |

## Risk Register
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Beta user churn at GA pricing | Medium | High | Grandfather beta pricing for 90 days |

## Stakeholder Sign-Off
| Role | Name | Decision | Date |
|------|------|----------|------|
| Engineering Lead | | | |
| Product Manager | | | |
| Support Lead | | | |
| Sales/GTM Lead | | | |

## Appendix
- Link to full scorecard history
- Link to beta feedback summary
- Link to load test results
- Link to security audit report
```

---

## CHECKLIST

- [ ] Graduation metrics defined with specific numeric thresholds
- [ ] Thresholds agreed upon by all stakeholders before beta begins
- [ ] Readiness scorecard created and updated weekly
- [ ] Data sources identified for each metric (no manual guesswork)
- [ ] Formal graduation review conducted with all stakeholders
- [ ] Go/No-Go decision documented with rationale
- [ ] GA Readiness Report produced and signed off
- [ ] Blocking items have owners and remediation timelines
- [ ] Conditional GO items have a hard deadline for completion
- [ ] Report handed to `beta_to_ga_migration` skill for execution

---

*Skill Version: 1.0 | Created: February 2026*
