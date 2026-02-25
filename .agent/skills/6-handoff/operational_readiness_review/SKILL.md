---
name: Operational Readiness Review
description: Formal readiness gate verifying all Phase 6 skills are complete with stakeholder sign-off and GA declaration
---

# Operational Readiness Review Skill

**Purpose**: Conduct the final readiness gate before declaring a product operationally ready for general availability. This skill produces a readiness scorecard across all handoff dimensions, collects stakeholder sign-offs, captures DORA baselines, and generates the formal handoff declaration document. This is the terminal gate of Phase 6 -- nothing ships to GA without passing this review.

## TRIGGER COMMANDS

```text
"Run readiness review"
"Stakeholder sign-off checklist"
"GA readiness check"
"Operational readiness for [project]"
"Using operational_readiness_review skill: review [project]"
```

## When to Use

- All other Phase 6 skills are complete or near-complete
- Approaching GA launch date and need a formal go/no-go decision
- Stakeholders need structured evidence that the product is ready for operations
- Transitioning from "project mode" to "operational mode"

---

## PROCESS

### Step 1: Compile the Readiness Scorecard

Aggregate completion status from every Phase 6 skill plus upstream dependencies.

```markdown
# Operational Readiness Scorecard - [Project Name]
**Review Date**: YYYY-MM-DD
**Reviewer**: [Name]
**Overall Status**: NOT READY / CONDITIONAL / READY

## Phase 6 Skill Completion

| # | Skill | Status | Artifacts | Gaps |
|---|-------|--------|-----------|------|
| 1 | Knowledge Audit | Complete | ADRs, config registry, gotchas doc, credential inventory | None |
| 2 | Access Handoff | Complete | Credential register, transfer matrix, emergency procedures | None |
| 3 | Support Enablement | Complete | Decision trees, escalation matrix, training guide | 2 trees pending |
| 4 | User Documentation | Complete | Help center, 15 articles, onboarding tour | Video tutorials pending |
| 5 | Disaster Recovery | Complete | 8 runbooks, status page, on-call rotation | DR drill not yet run |
| 6 | SLA Handoff | In Progress | SLO definitions drafted, error budget policy TBD | ETA: 3 days |
| 7 | Monitoring Handoff | In Progress | Alert ownership 80% mapped, dashboards documented | ETA: 5 days |

## Upstream Dependency Check

| Dependency | Source Phase | Status | Notes |
|-----------|-------------|--------|-------|
| Beta graduation criteria met | Phase 5.75 | PASS | GA Readiness Report signed |
| Load test baseline established | Phase 5.75 | PASS | 142 RPS sustained |
| Security audit clear | Phase 4 | PASS | No critical findings |
| CI/CD pipeline operational | Phase 5 | PASS | Deploys in < 10 min |
| Backup strategy tested | Phase 5.5 | PASS | PITR verified |
```

### Step 2: Evaluate Readiness Dimensions

Score each dimension on a 1-5 scale. All dimensions must score >= 3 for READY status.

| Dimension | Score (1-5) | Evidence | Notes |
|-----------|------------|---------|-------|
| **Documentation** | | Help center live, stranger test passed | |
| **Monitoring** | | All services instrumented, alerts configured | |
| **Support** | | Support team onboarded, decision trees created | |
| **Disaster Recovery** | | Runbooks tested, DR drill conducted | |
| **Access Control** | | All credentials transferred, old access revoked | |
| **SLA/SLO** | | SLOs defined, error budgets calculated | |
| **Performance** | | Load test passed, baselines established | |
| **Security** | | Audit clear, credentials rotated | |
| **Billing** | | Metering accurate, billing flows tested | |
| **Communication** | | GA announcement drafted, status page live | |

**Scoring Guide**:

```text
1 - Not Started: No work done on this dimension
2 - In Progress: Work started but significant gaps remain
3 - Minimum Viable: Core requirements met, some gaps acceptable for GA
4 - Solid: All requirements met, minor improvements identified
5 - Excellent: Exceeds requirements, proactive measures in place
```

### Step 3: Capture DORA Baseline

Record the current DORA metrics as the baseline for GA operational performance.

```markdown
# DORA Metrics Baseline (Pre-GA)

| Metric | Current Value | Industry Benchmark | Classification |
|--------|--------------|-------------------|----------------|
| **Deployment Frequency** | 3x/week | Daily = Elite | Medium |
| **Lead Time for Changes** | 2 days | < 1 day = Elite | Medium |
| **Mean Time to Recovery** | 45 minutes | < 1 hour = Elite | High |
| **Change Failure Rate** | 8% | < 15% = Elite | Elite |

**Overall DORA Classification**: High
**Target for 90 days post-GA**: Maintain High, improve deployment frequency to daily
```

### Step 4: Collect Stakeholder Sign-Offs

Each stakeholder must formally approve readiness for their area.

```markdown
# Stakeholder Sign-Off Matrix

| Stakeholder | Area of Responsibility | Decision | Date | Conditions |
|------------|----------------------|----------|------|-----------|
| Engineering Lead | Technical readiness, monitoring, DR | | | |
| Product Manager | Feature completeness, user documentation | | | |
| Support Lead | Support team readiness, knowledge base | | | |
| Security Lead | Security posture, access controls | | | |
| Finance/Billing | Billing infrastructure, metering accuracy | | | |
| Legal/Compliance | ToS, privacy policy, regulatory compliance | | | |
| Executive Sponsor | Overall go/no-go | | | |

## Sign-Off Options
- **APPROVE**: Ready for GA
- **APPROVE WITH CONDITIONS**: Ready if [specific conditions] are met by [date]
- **BLOCK**: Not ready -- [specific blockers] must be resolved

## Rules
- All stakeholders must respond (no silent approvals)
- Any single BLOCK prevents GA launch
- APPROVE WITH CONDITIONS requires follow-up verification by the blocking stakeholder
- Sign-offs are valid for 14 days (re-review if launch is delayed)
```

### Step 5: Generate the Handoff Declaration Document

The formal document that marks the transition from project to operations.

```markdown
# Handoff Declaration - [Project Name]

**Date**: YYYY-MM-DD
**From**: [Development Team / Project Team]
**To**: [Operations Team / Client / Maintaining Team]

## Declaration

We hereby declare that [Project Name] has completed all Phase 6
handoff requirements and is operationally ready for general availability.

## Readiness Summary
- Scorecard: X/10 dimensions at score >= 3
- DORA baseline: [Classification]
- Stakeholder sign-offs: X/Y approved (Z conditional)
- Open conditions: [List any conditional approvals]

## Artifacts Delivered
| Artifact | Location |
|----------|----------|
| Architecture Decision Records | /docs/adrs/ |
| Configuration Registry | /docs/config-registry.md |
| Credential Register | [Secure location] |
| Disaster Recovery Runbooks | /docs/runbooks/ |
| Support Playbook | /docs/support/ |
| User Documentation | [Help center URL] |
| SLA/SLO Documentation | /docs/sla/ |
| Monitoring Dashboard Guide | /docs/monitoring/ |
| Alert Ownership Map | /docs/alerts/ |
| On-Call Rotation | [PagerDuty/OpsGenie URL] |

## GA Communication Plan
| Date | Action | Owner | Channel |
|------|--------|-------|---------|
| T-7 | Internal announcement | PM | Company all-hands |
| T-3 | Beta user pre-announcement | PM | Email |
| T-0 | Public GA announcement | Marketing | Blog, email, social |
| T+1 | Press/media outreach | Marketing | PR channels |
| T+7 | First GA retrospective | Eng Lead | Team meeting |

## Signatures

_________________________    Date: __________
[Engineering Lead Name]

_________________________    Date: __________
[Product Manager Name]

_________________________    Date: __________
[Executive Sponsor Name]
```

---

## CHECKLIST

- [ ] Readiness scorecard compiled from all Phase 6 skill outputs
- [ ] All 10 readiness dimensions scored >= 3 (or exceptions documented)
- [ ] Upstream dependency check confirms Phase 4, 5, 5.5, and 5.75 gates passed
- [ ] DORA metrics baseline captured
- [ ] All required stakeholders have submitted sign-off decisions
- [ ] No unresolved BLOCK decisions remain
- [ ] Conditional approvals have owners, deadlines, and verification plans
- [ ] Handoff declaration document produced and signed
- [ ] All artifacts delivered and accessible to receiving team
- [ ] GA communication plan finalized with dates and owners
- [ ] Post-GA retrospective scheduled within 7 days of launch

---

*Skill Version: 1.0 | Created: February 2026*
