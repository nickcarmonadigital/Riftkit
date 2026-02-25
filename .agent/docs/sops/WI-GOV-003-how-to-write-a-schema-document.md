# [WI-GOV-003] How to Write a Schema Document

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `WI-GOV-003` |
| **Title** | How to Write a Schema Document |
| **Version** | `v2.0` (Enhanced Tabular Standard) |
| **Status** | `LOCKED` |
| **Owner (Role)** | COO |
| **Last Updated** | 2026-01-19 |
| **Estimated Time** | 15-25 minutes |
| **Parent SOP** | `[SOP-GOV-002]` Schema Standardization Protocol |

> [!CAUTION]
> **APPEND-ONLY**: When updating this document, ADD new content at the end. Mark outdated info as `[DEPRECATED]` but never delete.

---

## TARGET AUDIENCE

- **Primary**: Operations Architects, Database Developers
- **Secondary**: AI Agents creating schemas
- **Skill Level**: Intermediate (must understand basic data types: Text vs Number vs Select)

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | Translate a loose "list idea" into a rigorous Data Schema that can be built in a database (Notion/Airtable/SQL) |
| **Trigger** | When you need to organize a large dataset (e.g., "I need a list of all employees") |
| **Critical Warning** | Define your **Primary Key** first. Without a unique ID, you cannot connect data. |
| **Definition of Done** | A `[SCHEMA-XXX-000]` document that a developer could use to build a database table without asking questions |

---

## 2.0 PROCESS FLOW

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   SETUP     │ ──▶│   DEFINE    │ ──▶│   OPTIONS   │ ──▶│  FINALIZE   │
│   File      │    │   Fields    │    │  & Logic    │    │  & Lock     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

---

## 3.0 PREREQUISITES

| Requirement | Details |
|-------------|---------|
| **Knowledge** | Understanding of basic data types (Text vs. Number vs. Select) |
| **Scope** | Knowing exactly what data needs to be tracked |
| **Template** | Use `.agent/skills/schema_standards/SKILL.md` template |

---

## 4.0 THE PROCEDURE (Step-by-Step)

### Phase 1: Setup

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **1.1** | Create a new file named `[SCHEMA-{DOMAIN}-{NUMBER}] {Title}.md`. | File created. |
| **1.2** | Add the **Metadata Header** from the template. | Status is `Draft`. |
| **1.3** | Write the **1.0 Purpose** section. | |
| | • Define the "Container" (e.g., "This governs the Employee Directory"). | Purpose is clear. |
| **1.4** | Add **TARGET AUDIENCE** section. | Audience defined. |

### Phase 2: Defining the Fields

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **2.1** | Create a Table with headers: **Field Name**, **Data Type**, **Description**, **Validation**. | Table structure exists. |
| **2.2** | **CRITICAL:** Define the **Primary Key** (Row 1). | |
| | • Name: `id` or `asset_id` or `employee_id`. | |
| | • Type: `UUID` or `String (Unique)`. | **Check:** Is it marked "PRIMARY KEY"? |
| **2.3** | Define the **Core Data** fields. | |
| | • e.g., Title, Name, Date, Email. | Fields listed. |
| **2.4** | Define the **Governance** fields (REQUIRED on all schemas): | |
| | • **owner_id** (Person/UUID) | |
| | • **status** (Enum/Single-Select) | |
| | • **created_at** (Timestamp) | |
| | • **updated_at** (Timestamp) | **Check:** All 4 governance fields are present. |

### Phase 3: Defining Options (The Logic)

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **3.1** | For `Enum`/`Single-Select` fields, list the **Options** in the Validation column. | |
| | • *Example:* "Options: Draft, Active, Archived". | Options are mutually exclusive. |
| **3.2** | For `Foreign Key` fields, list the **Linked Table**. | |
| | • *Example:* "FK → `departments.id`". | Logic connects to other schemas. |
| **3.3** | Add an **Entity Relationship Diagram** (ASCII). | |
| | • Show how this entity relates to others. | Visual is clear. |

### Phase 4: Finalization

| Step | Action (Instruction) | Expected Result / Check |
|------|---------------------|------------------------|
| **4.1** | Add **Indexes** section for common queries. | Indexes documented. |
| **4.2** | Add **Constraints & Rules** section. | Business rules listed. |
| **4.3** | Add **Related Documents** section. | Parent SOP and related schemas linked. |
| **4.4** | Add **Revision History** with v1.0 entry. | History started. |
| **4.5** | Submit to **COO** for Review. | Logic check passed. |
| **4.6** | Save to SSoT and change status to **LOCKED**. | File Locked. |

---

## 5.0 QUALITY ASSURANCE

- [ ] Is there a Primary Key defined?
- [ ] Are all Data Types specific (not just "Text" - use String(255), Integer, etc.)?
- [ ] Are Enum/Select Options defined with all allowed values?
- [ ] Are the 4 Governance fields present (owner, status, created_at, updated_at)?
- [ ] Are Foreign Key relationships documented?
- [ ] Is there an Entity Relationship Diagram?
- [ ] Is Revision History started?

---

## 6.0 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **Don't know which data type to use** | See Common Data Types table in `schema_standards` skill |
| **Too many fields** | Split into multiple schemas with relationships |
| **Can't decide on Primary Key** | Use UUID - it's always unique and works everywhere |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[SOP-GOV-002]` Schema Standardization Protocol |
| **Related WI** | `[WI-GOV-001]` How to Write a Gold Standard SOP |
| **Related WI** | `[WI-GOV-002]` How to Write a Work Instruction |
| **Skill** | `.agent/skills/schema_standards/SKILL.md` |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | 2025-12-13 | COO | Initial release |
| v2.0 | 2026-01-19 | AI Agent | Enhanced with append-only rule, process flow, target audience, fixed table formatting, governance fields requirement, ERD section, related docs |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | System 0.1 (Governance) |
| **Executor** | Operations Architect |
| **Upstream Asset** | `[SOP-GOV-002]` Schema Standardization Protocol |
| **QA Audit Metric** | Database Build Readiness |
| **AI Executable** | Yes - AI can create schemas following this guide |
