---
name: Phase Exit Summary
description: Synthesize all Phase 0 artifacts into a formal Phase 0 to Phase 1 handoff brief
---

# Phase Exit Summary Skill

**Purpose**: Read all Phase 0 artifacts and produce a "Phase 0 Exit Brief" -- the formal handoff document from context gathering to brainstorming. This brief provides a system health score, top technical risks, business constraints, team velocity baseline, recommended Phase 1 actions, and a record of which Phase 0 skills were completed versus skipped. It is the gate artifact for entering Phase 1.

## TRIGGER COMMANDS

```text
"Complete Phase 0"
"Phase 0 exit summary"
"Prepare Phase 1 handoff"
```

## When to Use
- All required Phase 0 skills for your archetype have been completed
- You are ready to transition from context gathering to brainstorming
- A stakeholder asks for a summary of what was learned during Phase 0

---

## PROCESS

### Step 1: Gather All Phase 0 Artifacts

Collect outputs from every Phase 0 skill that was executed:

```markdown
## Phase 0 Artifacts Inventory

| Skill | Artifact | Location | Status |
|-------|----------|----------|--------|
| dev_environment_setup | Setup timer | .setup-timer.tmp | Complete |
| stakeholder_map | Fact sheet | .agent/docs/0-context/stakeholder-map.md | Complete |
| compliance_context | Compliance doc | .agent/docs/0-context/compliance-context.md | Complete |
| risk_register | Risk register | .agent/docs/0-context/risk-register.md | Complete |
| codebase_health_audit | Health report | .agent/docs/0-context/health-audit.md | Complete |
| supply_chain_audit | SBOM + report | .agent/docs/0-context/supply-chain-audit.md | Skipped |
```

### Step 2: Calculate System Health Score

Aggregate metrics from completed audits into a single score:

| Dimension | Weight | Score (1-10) | Weighted |
|-----------|--------|-------------|----------|
| Code Quality (test coverage, lint score) | 20% | ___ | ___ |
| Security (CVE count, auth coverage) | 25% | ___ | ___ |
| Infrastructure (monitoring, CI/CD) | 15% | ___ | ___ |
| Compliance (posture scores) | 15% | ___ | ___ |
| Documentation (coverage, accuracy) | 10% | ___ | ___ |
| Dependency Health (freshness, CVEs) | 15% | ___ | ___ |
| **Overall System Health** | 100% | | **___/10** |

### Step 3: Summarize Top 3 Technical Risks

Pull directly from the `risk_register` output. For each:

```markdown
### Risk 1: [Title] (Score: X - SEVERITY)
- **Impact if ignored**: [What happens if this is not addressed]
- **Recommended action**: [Specific next step]
- **Phase 1 implication**: [How this affects brainstorming/planning]
```

### Step 4: Summarize Business Constraints

Pull from `stakeholder_map`:

```markdown
## Business Constraints Summary
- **Budget**: $X remaining, $Y/month burn rate
- **Hard Deadline**: [Date and reason]
- **Compliance Deadlines**: [Audit dates, certification deadlines]
- **Technology Constraints**: [Mandated tools or platforms]
- **Staffing**: [Team size, key gaps]
```

### Step 5: Establish Velocity Baseline

If available, capture DORA metrics or equivalent:

```markdown
## Team Velocity Baseline
- **Deployment Frequency**: ___ per week/month
- **Lead Time for Changes**: ___ hours/days
- **Change Failure Rate**: ___%
- **Mean Time to Recovery**: ___ hours
- **Sprint Velocity** (if Agile): ___ points/sprint
```

If DORA metrics are not available, note "Baseline not established -- recommend instrumenting in Phase 3."

### Step 6: Recommend Phase 1 Actions

Based on everything discovered, provide prioritized recommendations:

```markdown
## Recommended Phase 1 Actions

### Must Do (Before Feature Work)
1. [Action] -- because [risk/constraint]
2. [Action] -- because [risk/constraint]

### Should Do (During Phase 1)
1. [Action] -- because [finding]

### Consider (If Time Allows)
1. [Action] -- because [opportunity]
```

### Step 7: Record Skills Completed vs. Skipped

```markdown
## Phase 0 Completion Record

| Skill | Status | Rationale (if skipped) |
|-------|--------|----------------------|
| dev_environment_setup | Completed | -- |
| stakeholder_map | Completed | -- |
| compliance_context | Completed | -- |
| supply_chain_audit | Skipped | No production deployment yet |
| risk_register | Completed | -- |
```

### Step 8: Produce the Exit Brief

Combine Steps 1-7 into a single document and save to:

```
.agent/docs/0-context/phase-0-exit-brief.md
```

---

## OUTPUT: PHASE 0 EXIT BRIEF TEMPLATE

```markdown
# Phase 0 Exit Brief
## Project: [Name] | Date: [DATE] | Archetype: [Greenfield/Inherit/Archaeological/Operational]

### System Health Score: X/10

### Top 3 Technical Risks
[From Step 3]

### Business Constraints
[From Step 4]

### Velocity Baseline
[From Step 5]

### Recommended Phase 1 Actions
[From Step 6]

### Phase 0 Skills: X/Y Completed
[From Step 7]

### Phase 1 Entry: APPROVED / BLOCKED
[If BLOCKED, list what must be resolved first]
```

---

## CHECKLIST

- [ ] All Phase 0 artifacts collected and inventoried
- [ ] System health score calculated from available metrics
- [ ] Top 3 technical risks summarized with recommended actions
- [ ] Business constraints summarized from stakeholder map
- [ ] Velocity baseline captured (or noted as unavailable)
- [ ] Phase 1 actions recommended and prioritized
- [ ] Skills completed vs. skipped documented with rationale
- [ ] Phase 1 entry decision rendered (APPROVED or BLOCKED)
- [ ] Exit brief saved to `.agent/docs/0-context/phase-0-exit-brief.md`

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
