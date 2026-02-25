---
name: Operational Readiness Gate
description: Phase 6-to-7 transition gate validating all operational artifacts, plus Phase 7-to-0 loop-back generating structured handoff documents.
---

# Operational Readiness Gate Skill

**Purpose**: Serves as the quality gate between deployment (Phase 6) and ongoing maintenance (Phase 7), and between Phase 7 and the next iteration (Phase 0). It validates that all operational prerequisites are met before entering maintenance mode, establishes the Phase 7 operational calendar, and generates structured handoff documents when looping back to Phase 0.

## TRIGGER COMMANDS

```text
"Validate operational readiness"
"Phase 7 kickoff"
"Generate Phase 0 handoff"
"Operational readiness checklist"
"Phase 7 exit review"
```

## When to Use
- Transitioning from Phase 6 (Deploy) to Phase 7 (Maintenance)
- Starting Phase 7 to establish operational cadences
- Ending an iteration and preparing handoff back to Phase 0
- Auditing whether a service is truly "production ready" for long-term operation

---

## PROCESS

### Step 1: Phase 6 Artifact Validation (Entry Gate)

Every item must be validated before Phase 7 begins. This is a hard gate -- no exceptions.

```markdown
## Operational Readiness Assessment — [Service/Project Name]

**Date**: [YYYY-MM-DD]
**Assessor**: [Name]
**Verdict**: [PASS / FAIL — list blockers if FAIL]

### Runbooks & Documentation
- [ ] Deployment runbook exists and was tested in last deploy
- [ ] Rollback runbook exists and was tested (or dry-run verified)
- [ ] Disaster recovery runbook exists with RTO/RPO documented
- [ ] Architecture diagram current (matches deployed state)
- [ ] API documentation matches deployed endpoints

### Monitoring & Alerting
- [ ] Health check endpoints responding (HTTP 200)
- [ ] Uptime monitoring configured (external synthetic checks)
- [ ] Application metrics dashboards live (latency, errors, throughput)
- [ ] Infrastructure metrics dashboards live (CPU, memory, disk, network)
- [ ] Alert rules configured for all critical SLIs
- [ ] Alert routing verified (correct on-call receives pages)
- [ ] Log aggregation operational (structured logs flowing)

### Reliability
- [ ] SLOs defined with targets and measurement method
- [ ] Error budget calculated and tracking initiated
- [ ] Incident response process documented and team trained
- [ ] On-call rotation scheduled for next 4 weeks minimum

### Security
- [ ] Last security scan clean (no critical/high findings)
- [ ] Certificate expiration tracking configured
- [ ] Secret rotation policy documented
- [ ] Access controls reviewed (principle of least privilege)

### Data
- [ ] Backup schedule verified and tested (restore drill completed)
- [ ] Data retention policies configured
- [ ] Database maintenance plan (vacuum, reindex, stats) scheduled
```

### Step 2: Phase 7 Operational Calendar

Once the entry gate passes, establish recurring maintenance cadences:

```markdown
## Phase 7 Operational Calendar

### Weekly
- [ ] Monday: SLO review meeting (30 min)
- [ ] Monday: Dependency vulnerability scan (automated)
- [ ] Friday: On-call handoff

### Monthly
- [ ] 1st week: CVE monitoring and security patch review
- [ ] 2nd week: Capacity trend report and cost review
- [ ] 3rd week: Dependency updates (minor/patch)
- [ ] 4th week: Runbook review and update

### Quarterly
- [ ] Performance baseline refresh
- [ ] Capacity forecast update (6-month and 12-month)
- [ ] Internal penetration test
- [ ] SLO target review (tighten or relax)
- [ ] Tech debt prioritization review
- [ ] Disaster recovery drill

### Annually
- [ ] External penetration test
- [ ] Major dependency upgrades
- [ ] Architecture review
- [ ] Full SLA renegotiation (if applicable)
```

### Step 3: Continuous Phase 7 Health Check

Run monthly to ensure Phase 7 practices are not degrading:

```markdown
## Phase 7 Health Check — [YYYY-MM]

| Practice | Status | Last Executed | Notes |
|----------|--------|---------------|-------|
| SLO review | [Active/Skipped] | [date] | |
| CVE scan | [Active/Skipped] | [date] | |
| Capacity report | [Active/Skipped] | [date] | |
| On-call rotation | [Staffed/Gap] | [date] | |
| Dependency updates | [Current/Behind] | [date] | |
| Backup restore test | [Passed/Overdue] | [date] | |
| Runbook review | [Current/Stale] | [date] | |

**Overall Health**: [GREEN / YELLOW / RED]
```

### Step 4: Phase 7-to-0 Handoff (Exit Gate)

When the team decides to loop back for a new iteration, generate this handoff:

```markdown
## Phase 0 Handoff Document

**Project**: [Name]
**Phase 7 Duration**: [start date] to [end date]
**Prepared By**: [Name]

### Production Learnings
1. [Key operational lesson learned]
2. [Performance insight discovered in production]
3. [User behavior that differed from assumptions]

### Tech Debt Inventory
| Item | Severity | Estimated Effort | Business Impact |
|------|----------|-----------------|-----------------|
| [debt item] | [High/Med/Low] | [S/M/L] | [description] |

### Feature Usage Data
| Feature | Adoption Rate | User Satisfaction | Recommendation |
|---------|--------------|-------------------|----------------|
| [feature] | [X]% | [rating] | [Keep/Improve/Remove] |

### Reliability Report
- **Availability (last 90 days)**: [X]%
- **Incidents (last 90 days)**: [count] (SEV-1: [n], SEV-2: [n])
- **MTTR (mean)**: [X] minutes
- **Error budget consumed**: [X]%

### Recommended Next Iteration Priorities
1. **P0**: [highest priority item with justification]
2. **P1**: [second priority]
3. **P2**: [third priority]

### Open Action Items Carried Forward
| Source | Item | Owner | Original Due |
|--------|------|-------|-------------|
| Post-mortem INC-XXX | [item] | [name] | [date] |

### Infrastructure State
- **Current monthly cost**: $[X]
- **Resource utilization**: [summary]
- **Scaling headroom**: [estimate before next capacity event]
```

---

## CHECKLIST

- [ ] All Phase 6 artifacts validated (entry gate PASSED)
- [ ] Phase 7 operational calendar created and shared with team
- [ ] Recurring calendar invites sent for all cadenced activities
- [ ] Monthly health check template saved and first check scheduled
- [ ] Phase 7 exit criteria defined (what triggers loop back to Phase 0)
- [ ] Handoff document template prepared for eventual Phase 0 return
- [ ] All team members aware of their Phase 7 responsibilities
- [ ] Escalation paths documented for Phase 7 operational issues

---

*Skill Version: 1.0 | Created: February 2026*
