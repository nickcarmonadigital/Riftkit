# [SOP-GOV-002] Schema Standardization Protocol

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `SOP-GOV-002` |
| **Title** | Schema Standardization Protocol |
| **Version** | `v2.0` (Gold Standard - Enhanced) |
| **Status** | `LOCKED` |
| **Owner (Role)** | COO |
| **Last Updated** | 2026-01-19 |
| **Estimated Time** | 5-10 min to read |

> [!CAUTION]
> **APPEND-ONLY**: When updating this document, ADD new content at the end. Mark outdated info as `[DEPRECATED]` but never delete.

---

## TARGET AUDIENCE

- **Primary**: System Architects, Database Developers
- **Secondary**: Operations Teams, COO
- **AI Agents**: Yes - Can generate schemas following this protocol

---

## 1.0 TL;DR (The One-Minute Summary)

| Item | Description |
|------|-------------|
| **Goal** | Define the mandatory structure for all "Schema" documents (Assets starting with `[SCHEMA-]`) |
| **Trigger** | When creating a new database, Airtable base, or structured list |
| **Critical Warning** | A Schema must define *Data Types* (String, Select, Date), not just field names. Without types, automation breaks. |
| **Definition of Done** | A finalized markdown file defining the mandatory columns/fields for a specific system |

---

## 2.0 PROCESS FLOW

```text
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   IDENTIFY      │ ──▶│   DEFINE        │ ──▶│   VALIDATE      │
│   Data Need     │    │   Fields/Types  │    │   & Lock        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

---

## 3.0 THE SCHEMA HIERARCHY

A Schema is a **Level 2 Asset** (Architecture) that governs **Level 3 Assets** (Databases/Lists).

```text
Level 1: POLICY (Why)
    ↓
Level 2: SCHEMA (What - Data Structure) ← This Protocol Governs
    ↓
Level 3: DATABASE (Where - Implementation)
```

**Examples:**

- `[SCHEMA-GOV-001]` defines the columns for the *Master Index*
- `[SCHEMA-TRN-001]` defines the columns for the *Training Catalog*
- `[SCHEMA-HR-001]` defines the columns for the *Employee Directory*

---

## 4.0 THE "GOLD STANDARD" SCHEMA FORMAT

All Schema documents must include:

### 4.1 The Purpose Statement

| Requirement | Description |
|-------------|-------------|
| **What** | Explain *what* system this schema governs |
| **Where** | Explain *where* the data lives (Notion, Supabase, Airtable) |
| **Relationships** | List related schemas/entities |

### 4.2 The Field Definition Table

Must include these specific columns:

| Column | Required | Description |
|--------|----------|-------------|
| **Field Name** | ✅ | The user-facing name |
| **Data Type** | ✅ | String, Number, Single-Select, Date, URL, Person |
| **Description** | ✅ | What goes in here? |
| **Validation/Options** | ✅ | "Must be unique," "Options: Draft, Active, Archived" |

---

## 5.0 THE VALIDATION RULES

| Rule | Requirement | Rationale |
|------|-------------|-----------|
| **Primary Key** | Every schema MUST identify a "Primary Key" (Unique ID) | Enables linking and automation |
| **Owner** | Every record must have an "Owner" field | Accountability |
| **Status** | Every record must have a "Status" field | Lifecycle tracking |
| **Timestamps** | created_at, updated_at fields | Audit trail |

---

## 6.0 QUALITY ASSURANCE

- [ ] Primary Key identified and marked
- [ ] All fields have Data Types specified (not just names)
- [ ] Owner field present
- [ ] Status field present with defined options
- [ ] Validation rules documented
- [ ] Purpose statement is clear

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Parent** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **Work Instruction** | `[WI-GOV-003]` How to Write a Schema Document |
| **Skill** | `.agent/skills/schema_standards/SKILL.md` |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | 2025-12-13 | COO | Initial release |
| v2.0 | 2026-01-19 | AI Agent | Enhanced with append-only rule, visual flow, related docs, revision history |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | System 0.1 (Governance) |
| **Executor** | COO / System Architects |
| **Upstream Asset** | `[SOP-GOV-001]` Master SOP Standardization Protocol |
| **QA Audit Metric** | Schema Validation Score |
| **AI Executable** | Yes - AI can generate schemas following this protocol |
