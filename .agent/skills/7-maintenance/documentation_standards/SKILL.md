---
name: Documentation Standards
description: Master template and guide for creating SOPs, Work Instructions, and Schemas
---

# Documentation Standards Skill

**Purpose**: Create standardized, machine-readable documentation that can be delegated to humans or AI agents without ambiguity.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating documents, ALWAYS ADD new content. Mark outdated sections with `[DEPRECATED]` but NEVER DELETE existing content. Revision history must be maintained.

---

## 🎯 TRIGGER COMMANDS

```text
"Create an SOP for [process]"
"Create a Work Instruction for [task]"
"Create a schema for [database/table]"
"Using documentation_standards skill: create [document type]"
```

---

## 📋 DOCUMENT TYPE HIERARCHY

| Document Type | Purpose | Scope | Example |
|---------------|---------|-------|---------|
| **SOP** | End-to-end process | Multiple steps, multiple phases | "How to Onboard a Client" |
| **WI** (Work Instruction) | Click-level detail | Single complex step from an SOP | "How to Export 4K Video" |
| **SCHEMA** | Data structure | Database/list definition | "Employee Directory Schema" |

```text
POLICY (Why)
    ↓
SOP (How - Process)
    ↓
WI (How - Detail)
    ↓
SCHEMA (What - Data)
```

---

# PART 1: SOP STANDARDS

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

---

## 5.0 QUALITY ASSURANCE (Self-Audit)

- [ ] Did you verify the status light was green?
- [ ] Did you receive the success message?
- [ ] [Add process-specific checks]

---

## 6.0 TROUBLESHOOTING

| Problem | Symptoms | Solution |
|---------|----------|----------|
| **Red Light Error** | Status light is red | Restart the server and retry |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[POLICY-XXX-000]` [Policy Name] |
| **Children (WIs)** | `[WI-XXX-001]`, `[WI-XXX-002]` |
| **Related SOPs** | `[SOP-XXX-000]` [Related Process] |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | YYYY-MM-DD | [Role] | Initial release |

```

---

# PART 2: WORK INSTRUCTION STANDARDS

## 📋 WHEN TO CREATE A WI

| Situation | Create WI? |
|-----------|------------|
| SOP step requires 5+ clicks | ✅ YES |
| Step involves complex UI navigation | ✅ YES |
| Step has multiple decision branches | ✅ YES |
| Step is used across multiple SOPs | ✅ YES |
| Simple single-action step | ❌ NO - keep in SOP |

## 📄 MASTER WI TEMPLATE

```markdown
# [WI-DEPT-000] [Action-Oriented Title]

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `[WI-DOMAIN-###]` |
| **Title** | `[Click-level action title]` |
| **Version** | `v1.0` |
| **Status** | `Draft` / `In Review` / `LOCKED` |
| **Parent SOP** | `[SOP-DOMAIN-###]` [Parent SOP Title] |

---

## 1.0 TL;DR

| Item | Description |
|------|-------------|
| **Goal** | [Specific output of this WI] |
| **Trigger** | [Called from Parent SOP Step X.X] |
| **Definition of Done** | [Clear end-state] |

---

## 2.0 THE CLICK-PATH (Step-by-Step)

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Click **[Menu]** > **[Submenu]**. | Submenu appears. |
| **1.2** | Select **[Option]**. | Option is highlighted. |
```

### The One-Action Rule

```text
❌ WRONG: "Click File, then Save As, then enter filename"
✅ RIGHT: 
   1.1 Click **File**.           | File menu opens.
   1.2 Click **Save As**.        | Save dialog opens.
   1.3 Enter filename in **Name**.| Filename appears.
```

---

# PART 3: SCHEMA STANDARDS

## 📄 MASTER SCHEMA TEMPLATE

```markdown
# [SCHEMA-DEPT-000] [Entity Name] Schema

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `[SCHEMA-DOMAIN-###]` |
| **Title** | `[Entity Name] Schema` |
| **Version** | `v1.0` |
| **Implementation** | `[Notion / Airtable / Supabase / PostgreSQL]` |

---

## 1.0 PURPOSE

**What this governs**: [e.g., "This schema defines the Employee Directory structure"]
**Where it lives**: [e.g., "Supabase `public.employees` table"]

---

## 2.0 ENTITY RELATIONSHIP DIAGRAM

```text
┌─────────────────┐       ┌─────────────────┐
│   DEPARTMENTS   │──────<│    EMPLOYEES    │
│   (1)           │       │   (Many)        │
└─────────────────┘       └─────────────────┘
```

---

## 3.0 FIELD DEFINITIONS

| Field Name | Data Type | Description | Validation |
|------------|-----------|-------------|------------|
| `id` | `UUID` | Unique identifier | **PRIMARY KEY** |
| `name` | `String(255)` | Display name | Required, Not empty |
| `created_at` | `Timestamp` | Creation time | Auto-set |
| `updated_at` | `Timestamp` | Last update | Auto-set |

```

---

## 📊 COMMON DATA TYPES

| Type | When to Use | Example |
|------|-------------|---------|
| `UUID` | Primary keys, foreign keys | `id`, `user_id` |
| `String(N)` | Text with max length | `name`, `email` |
| `Text` | Long-form text | `description`, `notes` |
| `Integer` | Whole numbers | `count`, `quantity` |
| `Decimal(P,S)` | Money, precise numbers | `price`, `salary` |
| `Boolean` | Yes/No flags | `is_active` |
| `Date` | Date only | `hire_date` |
| `Timestamp` | Date + time | `created_at` |
| `Enum` | Fixed options | `status`, `priority` |
| `JSONB` | Flexible/nested data | `metadata` |

---

## 📚 DOMAIN CODES

Use these standard domain codes for document naming:

| Code | Domain |
|------|--------|
| `GOV` | Governance |
| `OPS` | Operations |
| `MKTG` | Marketing |
| `SALES` | Sales |
| `DEV` | Development |
| `HR` | Human Resources |
| `FIN` | Finance |
| `CS` | Customer Success |
| `AI` | AI/Automation |

---

## 💡 WRITING TIPS

### DO:
1. **Start actions with verbs** - "Click", "Navigate", "Enter", "Verify"
2. **Bold UI elements** - "Click **Submit**"
3. **Separate Action from Verification** - Different columns
4. **Add Decision Points** - "If X, go to Step Y"
5. **Link Work Instructions** - Complex steps get their own WI

### DON'T:
1. **Don't mix actions** - One action per row
2. **Don't assume knowledge** - Explain acronyms
3. **Don't skip verification** - Every action needs "how to know it worked"
4. **Don't delete content** - Mark as `[DEPRECATED]` instead

---

## ✅ COMPLETION CHECKLIST

### SOP Checklist
- [ ] Metadata header complete
- [ ] TL;DR has Goal, Trigger, Warning, Definition of Done
- [ ] Visual flow diagram included
- [ ] All phases use 3-column table format
- [ ] QA Self-Audit checklist has 3-5 items
- [ ] Troubleshooting covers top 3 issues
- [ ] Revision history started

### WI Checklist
- [ ] Parent SOP linked in metadata
- [ ] One action per table row
- [ ] All UI elements are **Bold**
- [ ] Each action has verification

### Schema Checklist
- [ ] Primary Key defined
- [ ] All fields have Data Type and Description
- [ ] Governance fields present (owner, status, timestamps)
- [ ] Foreign key relationships documented

---

*Skill Version: 2.0 | Merged from: sop_standards + wi_standards + schema_standards | Updated: January 26, 2026*
