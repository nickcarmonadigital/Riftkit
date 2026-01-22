---
name: Schema Documentation Standards
description: Template and guide for creating rigorous data schemas that developers can implement without questions
---

# Schema Documentation Standards Skill

**Purpose**: Create database-ready Schema documents that define data structures, types, and validation rules.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating Schemas, ALWAYS ADD new fields at the end. Mark deprecated fields with `[DEPRECATED]` but NEVER DELETE them - downstream systems may depend on them.

---

## 🎯 TRIGGER COMMANDS

```text
"Create a schema for [database/table]"
"Define the data structure for [system]"
"Document the [entity] table schema"
"Using schema_standards skill: create [schema name]"
```

---

## 📋 SCHEMA HIERARCHY

```text
Level 1: POLICY (Why)
    ↓
Level 2: SCHEMA (What - Data Structure) ← YOU ARE HERE
    ↓
Level 3: DATABASE (Where - Actual Implementation)
```

---

## 📄 MASTER SCHEMA TEMPLATE

```markdown
# [SCHEMA-DEPT-000] [Entity Name] Schema

## [METADATA HEADER]

| Field | Value |
|-------|-------|
| **SSoT Asset ID** | `[SCHEMA-DOMAIN-###]` |
| **Title** | `[Entity Name] Schema` |
| **Version** | `v1.0` |
| **Status** | `Draft` / `In Review` / `LOCKED` |
| **Owner (Role)** | `[Data Architect / COO]` |
| **Last Updated** | `[YYYY-MM-DD]` |
| **Implementation** | `[Notion / Airtable / Supabase / PostgreSQL]` |

---

## TARGET AUDIENCE

- **Primary**: Database Developers, System Architects
- **Secondary**: Operations Teams, AI Agents
- **Implementation**: Should be directly translatable to SQL/NoSQL

---

## 1.0 PURPOSE

**What this governs**: [e.g., "This schema defines the Employee Directory structure"]

**Where it lives**: [e.g., "Supabase `public.employees` table"]

**Related entities**: [e.g., "Linked to Departments, Projects"]

---

## 2.0 ENTITY RELATIONSHIP DIAGRAM

```text
┌─────────────────┐       ┌─────────────────┐
│   DEPARTMENTS   │──────<│    EMPLOYEES    │
│   (1)           │       │   (Many)        │
└─────────────────┘       └────────┬────────┘
                                   │
                                   │< (Many)
                          ┌────────┴────────┐
                          │    PROJECTS     │
                          └─────────────────┘
```

---

## 3.0 FIELD DEFINITIONS

### 3.1 Primary Key (Required)

| Field Name | Data Type | Description | Validation |
|------------|-----------|-------------|------------|
| `id` | `UUID` | Unique identifier | **PRIMARY KEY**, Auto-generated |

### 3.2 Core Data Fields

| Field Name | Data Type | Description | Validation |
|------------|-----------|-------------|------------|
| `name` | `String(255)` | Display name | Required, Not empty |
| `email` | `String(255)` | Email address | Required, Valid email format |
| `department_id` | `UUID` | FK to Departments | **FOREIGN KEY** → `departments.id` |
| `hire_date` | `Date` | Date of hire | Required, Not future date |
| `salary` | `Decimal(10,2)` | Annual salary | Min: 0 |

### 3.3 Governance Fields (Required on ALL schemas)

| Field Name | Data Type | Description | Validation |
|------------|-----------|-------------|------------|
| `owner_id` | `UUID` | Person responsible | FK → `users.id` |
| `status` | `Enum` | Record status | Options: `Draft`, `Active`, `Archived` |
| `created_at` | `Timestamp` | Creation time | Auto-set on insert |
| `updated_at` | `Timestamp` | Last update time | Auto-set on update |

### 3.4 Optional/Extended Fields

| Field Name | Data Type | Description | Validation |
|------------|-----------|-------------|------------|
| `notes` | `Text` | Additional notes | Optional, Max 5000 chars |
| `metadata` | `JSONB` | Flexible attributes | Optional, Valid JSON |

---

## 4.0 ENUM DEFINITIONS

### Status Options

| Value | Description | Allowed Transitions |
|-------|-------------|---------------------|
| `Draft` | Not yet active | → `Active` |
| `Active` | Currently in use | → `Archived` |
| `Archived` | No longer active | → `Active` (reactivate) |

---

## 5.0 INDEXES

| Index Name | Fields | Type | Purpose |
|------------|--------|------|---------|
| `idx_employees_email` | `email` | Unique | Fast lookup by email |
| `idx_employees_dept` | `department_id` | Standard | Filter by department |
| `idx_employees_status` | `status` | Standard | Filter active records |

---

## 6.0 CONSTRAINTS & RULES

| Rule | Description |
|------|-------------|
| **Unique Email** | No two employees can have the same email |
| **Valid Department** | department_id must exist in departments table |
| **No Future Hire Date** | hire_date cannot be in the future |
| **Status Workflow** | Draft → Active → Archived (no skipping) |

---

## 7.0 RELATED DOCUMENTS

| Relationship | Document |
|--------------|----------|
| **Governed By** | `[SOP-GOV-002]` Schema Standardization Protocol |
| **Related Schemas** | `[SCHEMA-HR-002]` Departments Schema |
| **Implemented By** | `database/migrations/001_create_employees.sql` |

---

## 8.0 REVISION HISTORY

| Version | Date | Author | Change Summary |
|---------|------|--------|----------------|
| v1.0 | YYYY-MM-DD | [Role] | Initial schema definition |
| v1.1 | YYYY-MM-DD | [Role] | Added `metadata` field |

---

## [AI METADATA & GOVERNANCE]

| Field | Value |
|-------|-------|
| **System Parent** | [System 0.1 - Governance] |
| **Executor** | Data Architect |
| **Upstream Asset** | `[SOP-GOV-002]` Schema Standardization Protocol |
| **QA Audit Metric** | Database Build Readiness |

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
| `Boolean` | Yes/No flags | `is_active`, `is_verified` |
| `Date` | Date only | `hire_date`, `due_date` |
| `Timestamp` | Date + time | `created_at`, `updated_at` |
| `Enum` | Fixed options | `status`, `priority` |
| `JSONB` | Flexible/nested data | `metadata`, `settings` |
| `Array` | Lists of values | `tags`, `categories` |

---

## 💡 SCHEMA WRITING TIPS

### Required on EVERY Schema:

1. **Primary Key** - Unique identifier (usually UUID)
2. **Owner Field** - Who is responsible for this record
3. **Status Field** - Current state (Draft/Active/Archived)
4. **Timestamps** - created_at, updated_at

### Naming Conventions:

```text
Tables:     snake_case, plural    → employees, project_tasks
Fields:     snake_case            → first_name, created_at
Enums:      PascalCase            → Status, Priority
Indexes:    idx_table_field       → idx_employees_email
```

---

## ✅ SCHEMA COMPLETION CHECKLIST

- [ ] Primary Key defined with correct type
- [ ] All fields have Data Type specified
- [ ] All fields have Description
- [ ] Validation rules documented
- [ ] Governance fields present (owner, status, timestamps)
- [ ] Foreign key relationships documented
- [ ] Enum options listed with allowed transitions
- [ ] Indexes defined for common queries
- [ ] Constraints and business rules documented
- [ ] Related schemas linked
- [ ] Revision history started
