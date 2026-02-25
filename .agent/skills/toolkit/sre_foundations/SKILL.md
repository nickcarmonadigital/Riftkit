---
name: SRE Foundations
description: Comprehensive SRE practice framework covering SLO definition, error budgets, toil audits, blameless postmortems, on-call rotation, and the operational excellence cycle.
---

# SRE Foundations Skill

**Purpose**: Establish Site Reliability Engineering practices that bridge development and operations. Provides templates and processes for SLO definition, error budget management, toil reduction, blameless postmortems, and on-call design. Anchored in Phase 7 maintenance with SLO design beginning in Phase 2.

## TRIGGER COMMANDS

```text
"Set up SRE practices"
"Toil audit"
"On-call rotation design"
"Define SLOs for [service]"
"Error budget review"
"Blameless postmortem for [incident]"
```

## When to Use
- Defining service-level objectives during Phase 2 design
- Establishing on-call rotations before Phase 6 handoff
- Running toil audits to identify automation opportunities
- Conducting postmortems after production incidents
- Managing error budgets to balance reliability and velocity

---

## PROCESS

### Step 1: SLO Definition

Define Service Level Objectives that measure what users care about.

**SLO Template:**

```markdown
## SLO: [Service Name] -- [SLI Name]

**Service Level Indicator (SLI)**:
- Definition: [What is being measured]
- Formula: [Calculation, e.g., successful requests / total requests]
- Measurement: [Tool and method, e.g., Prometheus counter ratio]

**Service Level Objective (SLO)**:
- Target: [e.g., 99.9% availability over 30-day rolling window]
- Window: [30-day rolling / calendar month / quarter]
- Burn rate alert thresholds:
  - 14.4x burn rate over 1 hour -> Page (2% budget consumed in 1h)
  - 6x burn rate over 6 hours -> Page (6% budget consumed in 6h)
  - 1x burn rate over 3 days -> Ticket (10% budget consumed in 3d)
```

**Common SLI Categories:**

| Category | SLI | Typical SLO |
|----------|-----|-------------|
| Availability | Successful requests / total requests | 99.9% (43.8 min/month downtime budget) |
| Latency | Requests < threshold / total requests | 95% of requests < 200ms, 99% < 1s |
| Correctness | Correct responses / total responses | 99.99% |
| Freshness | Data updated within threshold / total records | 99% of records < 1 minute stale |
| Throughput | Requests served without throttling | 99.5% |

### Step 2: Error Budget Management

Calculate and track error budgets to balance reliability with feature velocity.

**Error Budget Calculation:**
- SLO = 99.9% availability
- Error budget = 100% - 99.9% = 0.1%
- Monthly budget = 0.1% x 43,200 minutes = 43.2 minutes of downtime

**Error Budget Policy:**

| Budget Remaining | Action |
|-----------------|--------|
| > 50% | Normal development velocity, features prioritized |
| 25-50% | Caution: reduce risky changes, increase testing |
| 10-25% | Slow down: reliability work prioritized over features |
| < 10% | Freeze: only reliability fixes and critical security patches |
| Exhausted (0%) | Full freeze until budget replenishes in next window |

### Step 3: Toil Audit

Identify and measure operational toil for automation targeting.

**Toil Definition**: Manual, repetitive, automatable, tactical, without enduring value, and scales linearly with service growth.

**Toil Audit Template:**

| Task | Frequency | Duration | Automatable? | Toil Score | Owner |
|------|-----------|----------|-------------|-----------|-------|
| [Manual deploy step] | Daily | 15 min | Yes | High | [Name] |
| [Certificate renewal] | Quarterly | 2 hr | Yes | Medium | [Name] |
| [Log investigation] | On-demand | 30 min | Partial | Medium | [Name] |

**Toil Score**: Frequency x Duration x (1 if fully automatable, 0.5 if partial)

**Toil Budget**: SRE teams should spend no more than 50% of time on toil. Track toil percentage monthly and target reduction quarter over quarter.

### Step 4: Blameless Postmortem

Conduct postmortems after every significant incident.

**Postmortem Template:**

```markdown
# Postmortem: [Incident Title]

**Date**: [YYYY-MM-DD]
**Duration**: [Start time] to [End time] ([Total duration])
**Severity**: [P0/P1/P2]
**Author**: [Name]
**Status**: [Draft / Reviewed / Action Items Complete]

## Summary
[2-3 sentence description of what happened and the user impact]

## Timeline (all times UTC)
| Time | Event |
|------|-------|
| HH:MM | [First symptom detected] |
| HH:MM | [Alert fired] |
| HH:MM | [On-call engaged] |
| HH:MM | [Root cause identified] |
| HH:MM | [Mitigation applied] |
| HH:MM | [Service restored] |

## Root Cause
[Description of the underlying cause, not the trigger]

## Contributing Factors
- [Factor 1: e.g., missing monitoring for X]
- [Factor 2: e.g., runbook did not cover scenario Y]

## What Went Well
- [Thing that worked as expected]

## What Went Poorly
- [Thing that could be improved]

## Action Items
| Action | Type | Owner | Priority | Deadline | Status |
|--------|------|-------|----------|----------|--------|
| [Action] | Prevent/Detect/Mitigate | [Name] | P0/P1/P2 | [Date] | Open |

## Lessons Learned
[Key takeaways for the team]
```

**Blameless Culture Rules:**
1. Focus on systems and processes, never individuals
2. Assume everyone acted with best intent and available information
3. "How did the system allow this?" not "Who caused this?"
4. Action items improve systems, not punish people

### Step 5: On-Call Rotation Design

Design sustainable on-call rotations.

**Rotation Parameters:**
- Minimum 4 people in rotation (for sustainable 1-in-4 schedule)
- Primary + secondary on-call for coverage
- Handoff at consistent time (e.g., 10am local Tuesday)
- Maximum shift length: 7 days
- Compensatory time off after heavy on-call weeks

**Escalation Chain:**
1. Automated alert fires (PagerDuty/OpsGenie)
2. Primary on-call has 5 minutes to acknowledge
3. If unacknowledged, escalate to secondary on-call
4. If unacknowledged, escalate to engineering manager
5. For P0: parallel notification to incident commander

**On-Call Readiness Checklist:**
- [ ] Runbooks exist for top 10 alert types
- [ ] VPN and production access verified
- [ ] Escalation contacts current
- [ ] On-call phone/laptop charged and accessible
- [ ] Monitoring dashboards bookmarked

### Step 6: Operational Excellence Cycle

Continuous improvement loop for reliability.

```text
Measure --> Analyze --> Improve --> Measure
   |           |           |          |
 SLO/SLI   Error Budget  Toil      DORA
 tracking   review       reduction  metrics
```

**Monthly Operations Review Agenda:**
1. SLO compliance review (all services)
2. Error budget status and trend
3. Incident review (postmortem action item status)
4. Toil audit update (toil percentage trend)
5. DORA metrics review (see dora_metrics_tracking skill)
6. Improvement proposals for next month

---

## CHECKLIST

- [ ] SLOs defined for all critical services with SLIs and targets
- [ ] Error budget policy documented and communicated to team
- [ ] Burn-rate alerting configured for each SLO
- [ ] Toil audit completed with automation targets identified
- [ ] Blameless postmortem template adopted by team
- [ ] On-call rotation established with minimum 4 people
- [ ] Escalation chain configured in alerting tool
- [ ] Runbooks created for top 10 alert types
- [ ] Monthly operations review scheduled
- [ ] DORA metrics collection feeding into review

---

*Skill Version: 1.0 | Cross-Phase: 2 (SLO design), 6-7 (operations) | Priority: P1*
