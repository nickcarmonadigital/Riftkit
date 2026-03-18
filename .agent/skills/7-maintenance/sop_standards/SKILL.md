---
name: SOP Writing Standards
description: Master template and guide for creating machine-readable, delegation-ready Standard Operating Procedures
---

# SOP Writing Standards Skill

**Purpose**: Create standardized, machine-readable SOPs that can be delegated to humans or AI agents without ambiguity.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating SOPs, ALWAYS ADD new content. Mark outdated sections with `[DEPRECATED]` but NEVER DELETE existing content. Revision history must be maintained.

---

## 🎯 TRIGGER COMMANDS

```text
"Create an SOP for [process]"
"Write a standard operating procedure"
"Document this workflow as an SOP"
"Using sop_standards skill: create [SOP name]"
```

---

## 📋 SOP vs WI vs SCHEMA

| Document Type | Purpose | Scope | Example |
|---------------|---------|-------|---------|
| **SOP** | End-to-end process | Multiple steps, multiple phases | "How to Onboard a Client" |
| **WI** (Work Instruction) | Click-level detail | Single complex step from an SOP | "How to Export 4K Video" |
| **SCHEMA** | Data structure | Database/list definition | "Employee Directory Schema" |

---

## 📄 MASTER SOP TEMPLATE

```markdown
# [SOP-DEPT-000] [Action-Oriented Title]

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `[SOP-DOMAIN-###]` |
| **Title** | `[Descriptive action-oriented title]` |
| **Version** | `v1.0` |
| **Status** | `Draft` / `In Review` / `LOCKED` |
| **Owner (Role)** | `[e.g., COO, CRO, IP Architect]` |
| **Last Updated** | `[YYYY-MM-DD]` |
| **Estimated Time** | `[X-Y minutes]` |

---

## TARGET AUDIENCE

- **Primary**: [Who executes this?]
- **Secondary**: [Who might reference this?]
- **AI Agents**: [Yes/No - Can AI execute this?]

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | [One sentence: What is the specific output?] |
| **Trigger** | [When do I do this? e.g., "Upon receipt of Ticket #..."] |
| **Critical Warning** | [The one thing that ruins the process if missed] |
| **Definition of Done** | [The specific end-state that signals completion] |

---

## 2.0 PROCESS FLOW (Visual)

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   TRIGGER   │ ──▶│   PHASE 1   │ ──▶│   PHASE 2   │ ──▶│    DONE     │
│  [Event]    │    │  [Prepare]  │    │  [Execute]  │    │  [Verify]   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

---

## 3.0 PREREQUISITES (Pre-Flight Check)

| Requirement | Details |
|-------------|---------|
| **Tools** | [Link to Login] |
| **Permissions** | [e.g., Admin Access] |
| **Inputs Needed** | [e.g., Client ID, Order Date] |
| **Dependencies** | [Other SOPs that must be completed first] |

---

## 4.0 THE PROCEDURE (Step-by-Step)

### Phase 1: [Preparation / Setup]

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Log into **[Tool]** and navigate to **[Page]**. | You see the "Dashboard" screen. |
| **1.2** | **DECISION POINT:** Check the status light. | |
| | • If **Green**: Go to Step 1.3. | |
| | • If **Red**: STOP. Go to Troubleshooting. | **Check:** Status must be Green. |
| **1.3** | Click **[Button Name]**. | A popup window appears. |

### Phase 2: [Execution]

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **2.1** | Input the **[Data Field]**. | Field accepts the data. |
| **2.2** | Click **Submit**. | **Check:** "Success" message appears. |

---

## 5.0 QUALITY ASSURANCE (Self-Audit)

Complete this checklist before marking the SOP execution as done:

- [ ] Did you verify the status light was green?
- [ ] Did you receive the success message?
- [ ] [Add process-specific checks]

---

## 6.0 TROUBLESHOOTING

| Problem | Symptoms | Solution |
|---------|----------|----------|
| **Red Light Error** | Status light is red | Restart the server and retry |
| **Error 404** | Page not found | Refresh the page or check URL |
| **[Common Issue 3]** | [Symptoms] | [Solution] |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[POLICY-XXX-000]` [Policy Name] |
| **Children (WIs)** | `[WI-XXX-001]`, `[WI-XXX-002]` |
| **Related SOPs** | `[SOP-XXX-000]` [Related Process] |
| **Schemas** | `[SCHEMA-XXX-000]` [Data Structure] |

---

## 8.0 REVISION HISTORY

> **APPEND-ONLY**: Add new entries at the end. Never delete revision history.

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | YYYY-MM-DD | [Role] | Initial release |
| v1.1 | YYYY-MM-DD | [Role] | [What changed] |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | [System 0.0 - 5.0] |
| **Executor** | [Role Name] |
| **Upstream Asset** | [Link to Parent Policy] |
| **QA Audit Metric** | [Metric Name] |
| **AI Executable** | Yes / No / Partial |

```

---

## 💡 SOP WRITING TIPS

### DO:

1. **Start actions with verbs** - "Click", "Navigate", "Enter", "Verify"
2. **Bold UI elements** - "Click **Submit**", "Enter in **Name** field"
3. **Separate Action from Verification** - Different columns, not same cell
4. **Add Decision Points** - "If X, go to Step Y. If Z, go to Troubleshooting"
5. **Link Work Instructions** - Complex steps get their own WI document

### DON'T:

1. **Don't mix actions** - One action per row
2. **Don't assume knowledge** - Explain acronyms
3. **Don't skip verification** - Every action needs a "how to know it worked"
4. **Don't delete content** - Mark as `[DEPRECATED]` instead

---

## ✅ SOP COMPLETION CHECKLIST

Before marking an SOP as LOCKED:

- [ ] Metadata header is complete (ID, Version, Owner, Date)
- [ ] TL;DR has Goal, Trigger, Warning, and Definition of Done
- [ ] Visual flow diagram included
- [ ] All phases use 3-column table format
- [ ] Actions are separated from Verifications
- [ ] QA Self-Audit checklist has 3-5 items
- [ ] Troubleshooting covers top 3 issues
- [ ] Related Documents section links Parent/Children
- [ ] Revision History has at least v1.0 entry
- [ ] AI Metadata section is complete
- [ ] Submitted for review and approved
- [ ] Status changed to LOCKED

---

## 📚 DOMAIN CODES

Use these standard domain codes for SOP naming:

| Code | Domain | Example |
|------|--------|---------|
| `GOV` | Governance | SOP-GOV-001 |
| `OPS` | Operations | SOP-OPS-001 |
| `MKTG` | Marketing | SOP-MKTG-001 |
| `SALES` | Sales | SOP-SALES-001 |
| `DEV` | Development | SOP-DEV-001 |
| `HR` | Human Resources | SOP-HR-001 |
| `FIN` | Finance | SOP-FIN-001 |
| `CS` | Customer Success | SOP-CS-001 |
| `AI` | AI/Automation | SOP-AI-001 |


## Related Skills
- [`documentation_standards`](../documentation_standards/SKILL.md)


## Related Skills
- [`wi_standards`](../wi_standards/SKILL.md)
