---
name: Phase Gate Contracts
description: Machine-checkable entry and exit criteria for all 10 phase transitions, transforming disconnected tools into a governed lifecycle.
---

# Phase Gate Contracts Skill

**Purpose**: Define and enforce formal entry and exit criteria for every phase transition in the development lifecycle. Each gate specifies required artifacts, quality bars, and approval requirements so that no phase begins without verified readiness from the prior phase. This is the central governance mechanism for the entire framework.

## TRIGGER COMMANDS

```text
"/gate-check [from-phase] [to-phase]"
"Phase transition readiness"
"Can we move to Phase [N]?"
"What's blocking phase exit?"
"Gate status for [phase]"
```

## When to Use
- Completing a phase and preparing to transition to the next
- Auditing whether a project skipped important steps
- Configuring phase gates for a new project (adjusting rigor by team scale)
- Reviewing why a phase transition was blocked
- Generating a compliance-ready audit trail of phase transitions

---

## PROCESS

### Step 1: Identify the Gate

Determine which phase transition is being evaluated. The framework defines 10 gates:

| Gate | Transition | Document Reference |
|------|-----------|-------------------|
| G0-1 | Context -> Brainstorm | `.agent/docs/phase-gates.md#g0-1` |
| G1-2 | Brainstorm -> Design | `.agent/docs/phase-gates.md#g1-2` |
| G2-3 | Design -> Build | `.agent/docs/phase-gates.md#g2-3` |
| G3-4 | Build -> Secure | `.agent/docs/phase-gates.md#g3-4` |
| G4-5 | Secure -> Ship | `.agent/docs/phase-gates.md#g4-5` |
| G5-55 | Ship -> Alpha | `.agent/docs/phase-gates.md#g5-55` |
| G55-575 | Alpha -> Beta | `.agent/docs/phase-gates.md#g55-575` |
| G575-6 | Beta -> Handoff | `.agent/docs/phase-gates.md#g575-6` |
| G6-7 | Handoff -> Maintenance | `.agent/docs/phase-gates.md#g6-7` |
| G7-loop | Maintenance -> Maintenance (periodic) | `.agent/docs/phase-gates.md#g7-loop` |

### Step 2: Run Gate Check

For the identified gate, evaluate each criterion as PASS, FAIL, or WAIVED.

**Gate Check Report Template:**

```markdown
# Gate Check: G[X]-[Y]
## [Phase X Name] -> [Phase Y Name]
## Date: [YYYY-MM-DD]
## Project: [Name]

### Entry Criteria for Phase [Y]

| # | Criterion | Status | Evidence | Notes |
|---|-----------|--------|----------|-------|
| 1 | [Criterion] | PASS/FAIL/WAIVED | [Link/file] | [Reason if WAIVED] |

### Quality Bars

| Metric | Required | Actual | Status |
|--------|----------|--------|--------|
| [Metric] | [Threshold] | [Value] | PASS/FAIL |

### Approvals

| Role | Required | Approved By | Date |
|------|----------|-------------|------|
| [Role] | Yes/No (by team scale) | [Name] | [Date] |

### Decision: APPROVED / BLOCKED / CONDITIONAL

**Conditions (if CONDITIONAL):**
- [ ] [Condition that must be met within N days]

**Blocking Items (if BLOCKED):**
- [Item]: [What's missing and who owns resolution]
```

### Step 3: Handle Gate Outcomes

**APPROVED**: Phase transition proceeds. Gate check report is archived as audit evidence.

**CONDITIONAL**: Phase transition proceeds with time-boxed conditions. Conditions must be resolved within the specified period or the transition reverts.

**BLOCKED**: Phase transition does not proceed. Blocking items are assigned owners and deadlines. Re-check is scheduled.

**WAIVED**: Individual criteria can be waived with documented rationale. Waivers must be approved by the governance role appropriate to team scale (see governance_framework skill).

### Step 4: Archive Gate Decision

Store gate decisions for audit trail:
- `.agent/docs/gate-decisions/G[X]-[Y]-[YYYY-MM-DD].md`
- Include all evidence links, approval records, and conditions
- Reference in project-state.json (see project_state_persistence skill)

---

## GATE DEFINITIONS REFERENCE

The complete gate definitions with entry/exit criteria for all 10 transitions are maintained in the infrastructure document at `.agent/docs/phase-gates.md`. That document is the authoritative source; this skill provides the process for evaluating and enforcing those gates.

**Key Principles:**
1. Gates are adjustable by team scale (Solo/SMB/Enterprise)
2. Every gate has both artifact requirements and quality bars
3. WAIVED criteria require documented rationale
4. Gate decisions are immutable audit records once archived
5. Conditional approvals have expiration dates

---

## CHECKLIST

- [ ] Target gate identified (G[X]-[Y])
- [ ] All entry criteria evaluated with evidence
- [ ] Quality bars measured against actuals
- [ ] Approval roles identified for team scale
- [ ] Gate decision documented (APPROVED/BLOCKED/CONDITIONAL)
- [ ] Blocking items assigned owners and deadlines (if BLOCKED)
- [ ] Conditions time-boxed with re-check date (if CONDITIONAL)
- [ ] Waivers documented with rationale (if any criteria WAIVED)
- [ ] Gate decision archived in gate-decisions directory
- [ ] Project state updated with gate transition

---

*Skill Version: 1.0 | Cross-Phase: All (infrastructure) | Priority: P0*
