---
name: Database Migrations
description: Protocols for evolving database schemas safely without losing user data or causing downtime
---

# Database Migrations Skill

**Purpose**: Manage database schema changes as versioned artifacts. Ensure the database can move forward (Up) and backward (Down) in time reliably.

> [!WARNING]
> **Data Gravity**: Code is easy to change. Data is heavy and hard to move. Treat migrations with 10x more caution than code changes.

---

## 🎯 TRIGGER COMMANDS

```text
"Add column to [table]"
"Create migration for [feature]"
"Update schema for [entity]"
"Using db_migrations skill: change [schema]"
```

---

## 📜 THE MIGRATION FILE

Every change must be a separate file with a unique timestamp/ID.

**File Name Pattern**: `YYYYMMDDHHMMSS_action_target.sql`
Example: `20240120103000_add_phone_to_users.sql`

### Standard Structure

A robust migration includes both **Up** (Apply) and **Down** (Revert) logic.

```sql
-- UP
ALTER TABLE users ADD COLUMN phone_number TEXT;
CREATE INDEX idx_users_phone ON users(phone_number);

-- DOWN
DROP INDEX idx_users_phone;
ALTER TABLE users DROP COLUMN phone_number;
```

---

## 🛡️ SAFTEY RULES (The "Zero Downtime" Protocol)

1. **Never Rename Columns**: This breaks running code.
    * *Safe Way*: Add new column -> Sync data -> Deprecate old -> Remove old (4 steps).
2. **Add Defaults Carefully**: Adding a `NOT NULL` column with a default value locks the table on huge datasets.
3. **create Index Concurrently**: Don't lock the table to build an index.
4. **Transaction Wrapped**: Migrations should run inside a transaction. If one part fails, everything rolls back.

---

## 🔄 WORKFLOW

1. **Draft**: Write the SQL/Prisma change.
2. **Test Local**: Run it on your machine.
3. **Inspect**: Check the SQL it generated.
4. **Apply Staging**: Run against a copy of prod data.
5. **Apply Prod**: Run during low traffic or via CI/CD.

---

## ✅ IMPLEMENTATION CHECKLIST

* [ ] **Idempotency**: Can this run twice without failing? (Use `IF NOT EXISTS`)
* [ ] **Down Script**: Is the revert logic tested?
* [ ] **Data Integrity**: Does this destroy any existing data?
* [ ] **Performance**: Will this lock the table for minutes/hours?
* [ ] **Backup**: Is a snapshot taken before applying?

---

## 🛠️ RECOMMENDED TOOLS

* **Node/TS**: Prisma Migrate, TypeORM
* **SQL**: Flyway, Liquibase
* **Supabase**: Supabase CLI (`supabase migration new`)
