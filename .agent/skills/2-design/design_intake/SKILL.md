---
name: Design Intake
description: Validates Phase 1 artifacts for completeness before design work begins -- the Phase 1 to Phase 2 gate
---

# Design Intake Skill

**Purpose**: Validates that all required Phase 1 outputs exist and meet quality criteria before any Phase 2 design work begins. Acts as the formal Phase 1 to Phase 2 gate, producing a clear APPROVED or BLOCKED status with actionable remediation steps.

## TRIGGER COMMANDS

```text
"Begin design phase"
"Validate design readiness"
"Check if spec is ready for design"
```

## When to Use
- Before starting any Phase 2 design skill
- After completing Phase 1 brainstorm and PRD generation
- When inheriting a project that claims to be "ready for design"
- When a go/no-go gate returned CONDITIONAL-GO with outstanding items

---

## PROCESS

### Step 1: Collect Phase 1 Artifact Inventory

Scan the project for all expected Phase 1 outputs. Check each artifact against this registry:

| Artifact | Expected Location | Required? |
|----------|-------------------|-----------|
| Problem Statement | PRD or client_discovery output | Yes |
| User Stories | `.agent/docs/1-brainstorm/user-stories.md` | Yes |
| Success Criteria | PRD `## Success Criteria` section | Yes |
| Priority Scores | prioritization_frameworks output | Yes |
| Scope Exclusions | PRD `## Out of Scope` section | Yes |
| Competitive Analysis | `.agent/docs/1-brainstorm/competitive-analysis.md` | Recommended |
| Go/No-Go Decision | `.agent/docs/1-brainstorm/go-no-go.md` | Recommended |
| Lean Canvas | `.agent/docs/1-brainstorm/lean-canvas.md` | Optional |
| Market Sizing | `.agent/docs/1-brainstorm/market-sizing.md` | Optional |

### Step 2: Quality Gate Evaluation

For each required artifact, evaluate against minimum quality criteria:

**Problem Statement**: Must name the target user, the pain point, and the measurable impact. Reject vague statements like "improve UX."

**User Stories**: Must follow "As a [persona], I want [action], so that [outcome]" with acceptance criteria. Minimum 3 stories for an MVP scope.

**Success Criteria**: Must be measurable (number, percentage, or boolean). Reject "make it fast" -- require "p95 latency under 200ms."

**Priority Scores**: Each feature must have a priority (MoSCoW, RICE, or WSJF). Unprioritized backlogs are rejected.

**Scope Exclusions**: Must explicitly list what is NOT being built. Absence of exclusions signals unbounded scope.

### Step 3: Produce Readiness Verdict

Generate the Design Readiness Report:

```markdown
# Design Readiness Report
**Date**: YYYY-MM-DD
**Project**: [project name]

## Verdict: APPROVED | BLOCKED

## Artifact Checklist
| Artifact | Status | Notes |
|----------|--------|-------|
| Problem Statement | PASS/FAIL | [detail] |
| User Stories | PASS/FAIL | [detail] |
| ... | ... | ... |

## Blocking Items (if BLOCKED)
1. [Missing artifact] -- Remediation: Run [Phase 1 skill]
2. [Quality failure] -- Remediation: [specific fix]

## Recommendations (non-blocking)
- [optional improvements]

## Approved Design Scope
[Summary of what is cleared for design work]
```

### Step 4: Route to Phase 1 or Phase 2

- **APPROVED**: Proceed to Phase 2 skills (start with ARA or architecture_decision_records).
- **BLOCKED**: List the specific Phase 1 skills that must be re-run. Do not allow Phase 2 work to begin until blockers are resolved.

---

## OUTPUT

**Path**: `.agent/docs/2-design/design-readiness-report.md`

---

## CHECKLIST

- [ ] All required Phase 1 artifacts located
- [ ] Problem statement names user, pain, and measurable impact
- [ ] User stories have acceptance criteria
- [ ] Success criteria are measurable
- [ ] Every feature has a priority score
- [ ] Scope exclusions are explicitly documented
- [ ] Readiness verdict is APPROVED or BLOCKED with remediation
- [ ] Report saved to `.agent/docs/2-design/design-readiness-report.md`
- [ ] If BLOCKED, Phase 1 skill invocations identified

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P0*
