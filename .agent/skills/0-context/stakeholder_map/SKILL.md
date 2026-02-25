---
name: Stakeholder Map
description: Identify and document all project stakeholders, decision-makers, and business constraints
---

# Stakeholder Map Skill

**Purpose**: Identify every party with decision-making authority, funding control, operational responsibility, or end-user representation. Produce a structured Stakeholder and Constraints Fact Sheet that prevents surprises later by making power dynamics, budgets, deadlines, and political constraints explicit from the start.

## TRIGGER COMMANDS

```text
"Who owns this project"
"Map the stakeholders"
"What are the business constraints"
```

## When to Use
- Starting any new project or engagement (Greenfield or inherited)
- Joining a project where you do not yet know who makes decisions
- Before Phase 1 to ensure business constraints are captured
- When decisions are getting blocked and you need to understand approval chains

---

## PROCESS

### Step 1: Identify Stakeholder Categories

Interview or research to fill each category:

| Category | Questions to Answer |
|----------|-------------------|
| **Decision Makers** | Who approves scope, budget, and timeline? Who can kill the project? |
| **Funders** | Who controls the budget? What is the approved budget? |
| **Operators** | Who will maintain this in production? Who gets paged? |
| **End Users** | Who are the primary users? Are there secondary user groups? |
| **Regulators** | Are there compliance officers, legal, or external auditors? |
| **Dependencies** | Which other teams or systems does this project depend on? |

### Step 2: Build the Stakeholder Matrix

For each identified stakeholder, capture:

```markdown
## Stakeholder Matrix

| Name | Role | Category | Contact | Decision Scope | Influence | Availability |
|------|------|----------|---------|---------------|-----------|-------------|
| Jane Doe | VP Product | Decision Maker | jane@co.com | Feature priority, scope | High | Weekly sync |
| John Smith | Eng Manager | Operator | john@co.com | Technical decisions | High | Daily |
| Legal Team | Compliance | Regulator | legal@co.com | Data handling, ToS | Medium | On request |
| Finance | Budget Owner | Funder | finance@co.com | Budget approval | High | Monthly review |
```

### Step 3: Document Business Constraints

Capture hard constraints that will shape every downstream decision:

```markdown
## Business Constraints

### Budget
- Total approved budget: $___
- Burn rate: $___/month
- Budget review cadence: ___

### Timeline
- Hard deadline: ___ (e.g., conference launch, regulatory date)
- Milestone dates: ___
- Buffer built in: Yes/No

### Compliance Obligations
- Applicable frameworks: ___ (GDPR, HIPAA, SOC2, etc.)
- Audit dates: ___
- Data residency requirements: ___

### Political Constraints
- Must-use technologies: ___ (e.g., "must use Azure, not AWS")
- Organizational politics: ___ (e.g., "cannot change the billing system")
- Prior commitments: ___ (e.g., "CEO promised feature X to client Y")
```

### Step 4: Map the Approval Chain

Document who must approve what, so decisions do not stall:

```markdown
## Approval Chain

| Decision Type | Approver | Backup | SLA |
|--------------|----------|--------|-----|
| Feature scope change | VP Product | CPO | 48 hours |
| Budget increase | Finance | CFO | 1 week |
| Production deploy | Eng Manager | Tech Lead | Same day |
| Data schema change | Eng Manager + Legal | -- | 3 days |
| Third-party vendor | Procurement | VP Eng | 1 week |
```

### Step 5: Produce the Fact Sheet

Combine Steps 2-4 into a single `stakeholder-map.md` file stored at:

```
.agent/docs/0-context/stakeholder-map.md
```

This document becomes a required input for `compliance_context`, `risk_register`, and Phase 1 skills.

---

## OUTPUT TEMPLATE

```markdown
# Stakeholder & Constraints Fact Sheet
## Generated: [DATE]

### Stakeholder Matrix
[Table from Step 2]

### Business Constraints
[Sections from Step 3]

### Approval Chain
[Table from Step 4]

### Key Risks from Stakeholder Analysis
- [Risk 1: e.g., "Single point of failure -- only one person knows the billing system"]
- [Risk 2: e.g., "Hard deadline with no buffer"]
- [Risk 3: e.g., "Compliance audit in 60 days, no current documentation"]
```

---

## CHECKLIST

- [ ] All six stakeholder categories investigated
- [ ] Stakeholder matrix completed with names, roles, and decision scope
- [ ] Budget constraints documented with amounts and review cadence
- [ ] Timeline constraints documented with hard deadlines
- [ ] Compliance obligations identified (or "none" explicitly stated)
- [ ] Political constraints captured
- [ ] Approval chain documented for each decision type
- [ ] Fact sheet saved to `.agent/docs/0-context/stakeholder-map.md`
- [ ] Key risks from stakeholder analysis listed

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
