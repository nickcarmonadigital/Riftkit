---
name: PRD Generator
description: Synthesize all Phase 1 outputs into a comprehensive Product Requirements Document
---

# PRD Generator Skill

**Purpose**: Synthesize all Phase 1 skill outputs -- client discovery, user research, competitive analysis, prioritization frameworks, product metrics, user story standards, assumption testing, lean canvas, and market sizing -- into a comprehensive Product Requirements Document (PRD). This skill includes an integrity check that flags sections resting on untested assumptions. The PRD is the primary Phase 1 output artifact and the input to `go_no_go_gate`.

## TRIGGER COMMANDS

```text
"Generate PRD for [product]"
"Create product requirements document"
"Synthesize Phase 1"
```

## When to Use
- After completing the majority of Phase 1 brainstorm skills
- When you need a single document that captures the full product definition
- Before entering the `go_no_go_gate` to evaluate whether to proceed to Phase 2
- When stakeholders need a formal product specification for review

---

## PROCESS

### Step 1: Collect Phase 1 Artifacts

Verify that required inputs exist. Mark each as available or missing:

```markdown
## Phase 1 Artifact Inventory

| Skill | Artifact | Status | Location |
|-------|----------|--------|----------|
| client_discovery | Discovery notes | Required | .agent/docs/1-brainstorm/ |
| user_research | User personas, journey maps | Required | .agent/docs/1-brainstorm/ |
| competitive_analysis | Competitive landscape | Required | .agent/docs/1-brainstorm/ |
| prioritization_frameworks | Prioritized feature list | Required | .agent/docs/1-brainstorm/ |
| product_metrics | Success metrics / KPIs | Required | .agent/docs/1-brainstorm/ |
| user_story_standards | User stories | Required | .agent/docs/1-brainstorm/ |
| assumption_testing | Assumption log + RAT results | Recommended | .agent/docs/1-brainstorm/ |
| lean_canvas | Business model canvas | Recommended | .agent/docs/1-brainstorm/ |
| market_sizing | TAM/SAM/SOM | Recommended | .agent/docs/1-brainstorm/ |
```

If required artifacts are missing, flag them and either produce them first or note the gap.

### Step 2: Generate PRD Using Template

Fill in each section by pulling from the corresponding Phase 1 artifact:

```markdown
# Product Requirements Document: [Product Name]
## Version: 1.0 | Date: [DATE] | Author: [Name/AI]

---

## 1. Executive Summary
[2-3 paragraphs: What is it, who is it for, why now. Pull from lean_canvas and client_discovery.]

## 2. Problem Statement
[From client_discovery and user_research. State the problem, who has it, current workarounds, and cost of inaction.]

## 3. Target Users
[From user_research. Include personas with demographics, goals, pain points, and technical proficiency.]

### Primary Persona: [Name]
- **Role**: ___
- **Goal**: ___
- **Pain Point**: ___
- **Current Workaround**: ___

### Secondary Persona: [Name]
...

## 4. Market Context
[From competitive_analysis and market_sizing.]
- TAM: $___ | SAM: $___ | SOM: $___
- Key competitors and differentiation
- Market timing rationale

## 5. Product Vision and Strategy
[From lean_canvas. UVP, unfair advantage, channels, revenue model.]

## 6. Feature Requirements

### 6a. Prioritized Feature List
[From prioritization_frameworks. Include priority tier and effort estimate.]

| Priority | Feature | User Story | Effort | Assumption Validated? |
|----------|---------|-----------|--------|----------------------|
| P0 | [Feature] | As a [user]... | [S/M/L] | Yes / No / Untested |

### 6b. Detailed User Stories
[From user_story_standards. Include acceptance criteria for P0 and P1 features.]

## 7. Success Metrics
[From product_metrics.]

| Metric | Target | Measurement Method | Frequency |
|--------|--------|-------------------|-----------|
| [KPI 1] | ___ | ___ | ___ |

## 8. Non-Functional Requirements
[Placeholder for Phase 2 nfr_specification. Note known constraints.]
- Performance: ___
- Security: ___
- Accessibility: ___

## 9. Assumptions and Risks
[From assumption_testing. List all assumptions with validation status.]

| Assumption | Status | Evidence |
|-----------|--------|---------|
| [A1] | Validated | [RAT result] |
| [A2] | Untested | [Flagged for review] |

## 10. Scope and Exclusions
- **In Scope (MVP)**: ___
- **Out of Scope (v1.0)**: ___
- **Future Consideration**: ___

## 11. Open Questions
[Unresolved items that need stakeholder input before Phase 2.]

## 12. Appendix
[Links to all Phase 1 artifact documents.]
```

### Step 3: Run Integrity Check

Scan the PRD for sections that depend on untested assumptions:

```markdown
## PRD Integrity Check

| Section | Depends On Assumption | Assumption Status | Flag |
|---------|----------------------|-------------------|------|
| Feature: AI Reports | A1: Users want AI reports | Validated | OK |
| Pricing: $49/mo | A3: SMBs will pay $49 | Untested | WARNING |
| Self-serve onboarding | A5: Users self-onboard | Invalidated | BLOCKED |
```

**Rules**:
- Sections depending on VALIDATED assumptions: proceed normally
- Sections depending on UNTESTED assumptions: flag with WARNING in the PRD
- Sections depending on INVALIDATED assumptions: flag as BLOCKED, do not include in MVP scope

### Step 4: Review and Finalize

Before saving, verify:
- [ ] Every section is filled (no "[TBD]" left in P0/P1 features)
- [ ] Integrity check has no BLOCKED items in MVP scope
- [ ] Stakeholder constraints from Phase 0 are reflected
- [ ] Success metrics are measurable and have concrete targets
- [ ] Scope exclusions are explicitly listed

### Step 5: Produce the PRD

Save the final document to:

```
.agent/docs/1-brainstorm/prd.md
```

This document is the primary input to `go_no_go_gate`.

---

## CHECKLIST

- [ ] All required Phase 1 artifacts collected and inventoried
- [ ] Missing artifacts flagged (or produced)
- [ ] PRD template filled in completely for all 12 sections
- [ ] Integrity check run -- no BLOCKED assumptions in MVP scope
- [ ] WARNING assumptions flagged visibly in the document
- [ ] Success metrics are concrete and measurable
- [ ] Scope and exclusions clearly defined
- [ ] Open questions listed for stakeholder resolution
- [ ] PRD saved to `.agent/docs/1-brainstorm/prd.md`
- [ ] Document ready for `go_no_go_gate` evaluation

---

*Skill Version: 1.0 | Phase: 1-Brainstorm | Priority: P1*
