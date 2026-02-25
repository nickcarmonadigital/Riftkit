---
name: Go No-Go Gate
description: Formal decision gate evaluating 7 dimensions to produce a GO/NO-GO/CONDITIONAL-GO verdict
---

# Go No-Go Gate Skill

**Purpose**: Provide a rigorous, structured decision gate that evaluates a project across 7 critical dimensions using a scoring rubric. This skill produces a definitive GO, NO-GO, or CONDITIONAL-GO decision with specific conditions, blocking entry to Phase 2 (Design) until the gate is passed. It forces honest evaluation and prevents sunk-cost bias by requiring evidence-based scoring rather than gut feel.

## TRIGGER COMMANDS

```text
"Go or no-go for [project]"
"Should we build this?"
"Phase 1 gate"
```

## When to Use
- After completing Phase 1 brainstorm skills (especially `prd_generator`, `assumption_testing`, `market_sizing`)
- Before committing engineering resources to Phase 2 Design
- When a stakeholder asks "should we proceed?"
- At any major pivot point to re-evaluate project viability

---

## PROCESS

### Step 1: Gather Required Inputs

The gate evaluation requires these Phase 1 artifacts:

| Input | Source Skill | Required |
|-------|-------------|----------|
| PRD | `prd_generator` | Yes |
| Assumption log with RAT results | `assumption_testing` | Yes |
| Market sizing (TAM/SAM/SOM) | `market_sizing` | Yes |
| Competitive analysis | `competitive_analysis` | Yes |
| Stakeholder constraints | `stakeholder_map` (Phase 0) | Yes |
| Risk register | `risk_register` (Phase 0) | Recommended |
| Lean canvas | `lean_canvas` | Recommended |

If required inputs are missing, the gate CANNOT proceed. Return a BLOCKED status listing what is needed.

### Step 2: Score Each Dimension

Rate each dimension on a 1-10 scale using the rubric below:

#### Dimension 1: Market Viability (Weight: 20%)

| Score | Criteria |
|-------|---------|
| 1-3 | No validated market data. TAM unclear. No evidence of demand. |
| 4-6 | Top-down TAM estimated. Some demand signals. No WTP validation. |
| 7-8 | TAM/SAM/SOM calculated with sources. WTP partially validated. |
| 9-10 | Bottom-up and top-down converge. WTP validated. SOM is achievable. |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 2: Technical Feasibility (Weight: 15%)

| Score | Criteria |
|-------|---------|
| 1-3 | Requires unproven technology. Team has no experience in the stack. |
| 4-6 | Feasible but significant unknowns. Proof of concept not done. |
| 7-8 | Core tech validated. Team has relevant experience. Minor unknowns. |
| 9-10 | Proven tech stack. Team has shipped similar systems. No blockers. |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 3: Team Capability (Weight: 10%)

| Score | Criteria |
|-------|---------|
| 1-3 | Critical skill gaps with no hiring plan. Single point of failure. |
| 4-6 | Some gaps identified. Hiring or upskilling in progress. |
| 7-8 | Team covers most required skills. Gaps have mitigation plans. |
| 9-10 | Full coverage. Team has shipped similar products successfully. |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 4: Assumption Validation (Weight: 20%)

| Score | Criteria |
|-------|---------|
| 1-3 | LOFAs untested. No experiments run. Faith-based planning. |
| 4-6 | Some assumptions tested. LOFAs identified but not all validated. |
| 7-8 | All LOFAs tested. Most validated. Invalidated ones have pivots. |
| 9-10 | All critical assumptions validated with data. Clear evidence trail. |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 5: Competitive Differentiation (Weight: 10%)

| Score | Criteria |
|-------|---------|
| 1-3 | No clear differentiator. Entering a crowded market with same approach. |
| 4-6 | Some differentiation claimed but not validated with users. |
| 7-8 | Clear differentiator identified. Users confirm it matters to them. |
| 9-10 | Defensible moat (network effects, data, patents, switching costs). |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 6: Financial Model (Weight: 15%)

| Score | Criteria |
|-------|---------|
| 1-3 | No revenue model. Unit economics unknown. Budget undefined. |
| 4-6 | Revenue model defined. Unit economics estimated but not validated. |
| 7-8 | Unit economics validated. LTV/CAC > 3x. Budget covers 12+ months. |
| 9-10 | Proven unit economics. Clear path to profitability. Funded runway. |

**Score**: ___/10 | **Evidence**: ___

#### Dimension 7: Compliance Risk (Weight: 10%)

| Score | Criteria |
|-------|---------|
| 1-3 | Regulatory requirements unknown. No compliance assessment done. |
| 4-6 | Frameworks identified. Partial posture assessment. Gaps remain. |
| 7-8 | Full compliance context documented. Remediation plan in place. |
| 9-10 | Compliance validated. Audit-ready. No outstanding regulatory risk. |

**Score**: ___/10 | **Evidence**: ___

### Step 3: Calculate Weighted Score

```markdown
## Gate Scorecard

| Dimension | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Market Viability | 20% | ___ | ___ |
| Technical Feasibility | 15% | ___ | ___ |
| Team Capability | 10% | ___ | ___ |
| Assumption Validation | 20% | ___ | ___ |
| Competitive Differentiation | 10% | ___ | ___ |
| Financial Model | 15% | ___ | ___ |
| Compliance Risk | 10% | ___ | ___ |
| **Total** | **100%** | | **___/10** |
```

### Step 4: Render Decision

| Weighted Score | Decision |
|---------------|----------|
| 7.0 - 10.0 | **GO** -- Proceed to Phase 2 |
| 5.0 - 6.9 | **CONDITIONAL-GO** -- Proceed only after meeting listed conditions |
| Below 5.0 | **NO-GO** -- Do not proceed. Pivot, shelve, or re-scope. |

**Additional NO-GO triggers** (regardless of total score):
- Any single dimension scores 2 or below
- All LOFAs remain untested
- Budget does not cover estimated Phase 2-3 timeline

### Step 5: Document Conditions (if CONDITIONAL-GO)

```markdown
## Conditions for Proceeding

| # | Condition | Owner | Deadline | Status |
|---|-----------|-------|----------|--------|
| 1 | Validate pricing assumption via fake door test | PM | 2 weeks | Open |
| 2 | Hire senior backend engineer | Eng Mgr | 4 weeks | Open |
| 3 | Complete GDPR compliance remediation plan | Legal | 1 week | Open |
```

### Step 6: Produce Signed Decision Document

```markdown
# Go/No-Go Decision: [Project Name]
## Date: [DATE] | Decision: GO / CONDITIONAL-GO / NO-GO

### Weighted Score: ___/10
### Decision Rendered By: [Name/Role]

[Scorecard from Step 3]
[Conditions from Step 5, if applicable]
[Dissenting opinions, if any]
```

Save to:

```
.agent/docs/1-brainstorm/go-no-go-decision.md
```

---

## CHECKLIST

- [ ] All required Phase 1 inputs collected
- [ ] All 7 dimensions scored with evidence
- [ ] Weighted total calculated
- [ ] Decision rendered (GO / CONDITIONAL-GO / NO-GO)
- [ ] No single dimension scored 2 or below (or escalated)
- [ ] Conditions listed (if CONDITIONAL-GO) with owners and deadlines
- [ ] Decision document signed and saved
- [ ] Stakeholders notified of decision
- [ ] Phase 2 entry approved or blocked accordingly

---

*Skill Version: 1.0 | Phase: 1-Brainstorm | Priority: P0*
