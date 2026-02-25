---
name: db_migrations
description: Safe database schema evolution with Prisma Migrate — zero-downtime strategies, rollbacks, and data migrations
---

# Database Migrations Skill

**Purpose**: Manage database schema changes as versioned artifacts. The database is the hardest part of your system to change — treat migrations with 10x more caution than code changes.

> [!WARNING]
> **Data Gravity**: Code is easy to revert. Data is heavy and hard to move. A bad migration can lose user data permanently.

## 🎯 TRIGGER COMMANDS

```text
"Add column to [table]"
"Create migration for [feature]"
"Update schema for [entity]"
"Run Prisma migration"
"How do I do zero-downtime migration?"
"Rollback the last migration"
"Using db_migrations skill: change [schema]"
```

## When to Use

- Adding, removing, or modifying database columns/tables
- Running Prisma migrate in development or production
- Performing data migrations (backfilling, transforms)
- Planning zero-downtime schema changes
- Rolling back a failed migration
- Seeding data for development or testing

---

## PART 1: PRISMA MIGRATE COMMANDS

### The Commands

| Command | When to Use | What It Does |
|---------|------------|--------------|
| `prisma migrate dev` | Development only | Creates migration SQL, applies it, regenerates client |
| `prisma migrate deploy` | Production / CI | Applies pending migrations (no new ones created) |
| `prisma migrate resolve` | Fix stuck state | Marks migration as applied or rolled back |
| `prisma migrate diff` | Review changes | Shows SQL diff between states |
| `prisma migrate reset` | Development only | Drops DB, re-applies all migrations, re-seeds |
| `prisma db push` | Prototyping only | Pushes schema changes without creating migration file |
| `prisma generate` | After schema changes | Regenerates the Prisma client TypeScript types |

### Development Workflow

```bash
# 1. Edit schema.prisma
# 2. Create and apply migration
npx prisma migrate dev --name add_phone_to_users

# This creates:
# prisma/migrations/20260213120000_add_phone_to_users/migration.sql

# 3. Review the generated SQL
cat prisma/migrations/20260213120000_add_phone_to_users/migration.sql

# 4. Commit the migration file with your code changes
git add prisma/migrations prisma/schema.prisma
git commit -m "feat(users): add phone number field"
```

### Production Deployment

```bash
# In CI/CD pipeline or production deploy script
npx prisma migrate deploy

# This ONLY applies pending migrations
# It does NOT create new ones
# It does NOT reset the database
# It is safe for production
```

### push vs migrate

```
prisma db push:
├── NO migration file created
├── NO migration history tracked
├── Can be destructive (drops columns silently)
├── Good for: Rapid prototyping, experiments
└── NEVER use in production

prisma migrate dev:
├── Creates versioned migration SQL file
├── Tracks migration history in _prisma_migrations table
├── Warns about destructive changes
├── Good for: All real development
└── Required for production deployments
```

---

## PART 2: MIGRATION FILE ANATOMY

### Generated Migration

```sql
-- prisma/migrations/20260213120000_add_phone_to_users/migration.sql

-- CreateTable (for new tables)
CREATE TABLE "projects" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "user_id" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "projects_pkey" PRIMARY KEY ("id")
);

-- AddColumn (for new fields)
ALTER TABLE "users" ADD COLUMN "phone" TEXT;

-- CreateIndex
CREATE INDEX "projects_user_id_idx" ON "projects"("user_id");

-- AddForeignKey
ALTER TABLE "projects" ADD CONSTRAINT "projects_user_id_fkey"
    FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
```

### Migration History Table

Prisma tracks applied migrations in `_prisma_migrations`:

```sql
SELECT id, migration_name, started_at, finished_at, applied_steps_count
FROM _prisma_migrations
ORDER BY started_at DESC;
```

---

## PART 3: COMMON MIGRATION PATTERNS

### Pattern 1: Add Nullable Column (Safe)

```prisma
// schema.prisma
model User {
  id    String  @id @default(uuid())
  email String  @unique
  phone String?  // Nullable — no default needed, no data backfill needed
}
```

```bash
npx prisma migrate dev --name add_phone_to_users
```

This is **always safe** — existing rows get `NULL` for the new column.

### Pattern 2: Add Required Column with Default

```prisma
model User {
  id     String @id @default(uuid())
  email  String @unique
  role   String @default("user")  // New required field with default
}
```

**Safe for small tables** (<100K rows). For large tables, PostgreSQL may lock the table while adding the column.

### Pattern 3: Rename Column (DANGEROUS)

**Never rename directly** — it breaks running code during deployment.

```
Safe rename process (4 deployments):

Deploy 1: Add new column
  ALTER TABLE users ADD COLUMN full_name TEXT;
  UPDATE users SET full_name = name;  -- Backfill

Deploy 2: Write to BOTH columns
  Application writes to both `name` and `full_name`

Deploy 3: Read from new column
  Application reads from `full_name`, stops writing `name`

Deploy 4: Drop old column
  ALTER TABLE users DROP COLUMN name;
```

### Pattern 4: Add NOT NULL Column to Existing Table

```
Step 1: Add as nullable
  ALTER TABLE users ADD COLUMN tenant_id UUID;

Step 2: Backfill data
  UPDATE users SET tenant_id = 'default-tenant-id' WHERE tenant_id IS NULL;

Step 3: Add NOT NULL constraint
  ALTER TABLE users ALTER COLUMN tenant_id SET NOT NULL;

Step 4: Add foreign key (if needed)
  ALTER TABLE users ADD CONSTRAINT users_tenant_fk
    FOREIGN KEY (tenant_id) REFERENCES tenants(id);
```

### Pattern 5: Create Index Without Locking

```sql
-- BAD: Locks the table during index creation
CREATE INDEX idx_users_email ON users(email);

-- GOOD: Non-blocking index creation
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);

-- Note: CONCURRENTLY can't run inside a transaction
-- For Prisma, add to a custom migration:
```

```prisma
// In schema.prisma, add the index
model User {
  email String
  @@index([email])
}
```

```bash
# Create migration but DON'T apply yet
npx prisma migrate dev --name add_email_index --create-only

# Edit the generated SQL file manually
# Change: CREATE INDEX "User_email_idx" ON "User"("email");
# To:     CREATE INDEX CONCURRENTLY "User_email_idx" ON "User"("email");
```

### Pattern 6: Drop Column (Safe Process)

```
Step 1: Remove all code references to the column
Step 2: Deploy code changes (column still exists but unused)
Step 3: Create migration to drop the column
Step 4: Deploy migration

NEVER drop a column while code still references it.
```

### Pattern 7: Change Column Type

```sql
-- Safe: String to Text (wider type)
ALTER TABLE users ALTER COLUMN bio TYPE TEXT;

-- DANGEROUS: Text to VARCHAR(100) — may truncate data
-- Check data first:
SELECT MAX(LENGTH(bio)) FROM users;
-- If max > 100, you'll lose data!

-- Safe approach for narrowing:
-- 1. Add new column with desired type
-- 2. Backfill with validation
-- 3. Swap columns
```

---

## PART 4: DATA MIGRATIONS

### When Prisma Migrate Isn't Enough

Prisma generates DDL (schema changes) but not DML (data changes). For data backfills, use custom SQL.

### Inline Data Migration

```sql
-- In the migration SQL file, after schema change:
ALTER TABLE users ADD COLUMN display_name TEXT;

-- Backfill: generate display_name from first_name + last_name
UPDATE users SET display_name = CONCAT(first_name, ' ', last_name)
WHERE display_name IS NULL;
```

### Separate Data Migration Script

For complex data transforms, create a standalone script:

```typescript
// prisma/data-migrations/backfill-display-names.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const batchSize = 1000;
  let processed = 0;

  // Process in batches to avoid memory issues on large tables
  while (true) {
    const users = await prisma.user.findMany({
      where: { displayName: null },
      take: batchSize,
      select: { id: true, firstName: true, lastName: true },
    });

    if (users.length === 0) break;

    await prisma.$transaction(
      users.map((user) =>
        prisma.user.update({
          where: { id: user.id },
          data: { displayName: `${user.firstName} ${user.lastName}`.trim() },
        }),
      ),
    );

    processed += users.length;
    console.log(`Processed ${processed} users`);
  }

  console.log(`Done. Total processed: ${processed}`);
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
```

```bash
# Run after the schema migration is applied
npx ts-node prisma/data-migrations/backfill-display-names.ts
```

---

## PART 5: ZERO-DOWNTIME STRATEGIES

### Expand-and-Contract Pattern

The safest way to make breaking schema changes:

```
Phase 1: EXPAND — Add the new structure alongside the old
  ├── Add new column/table
  ├── Deploy code that writes to BOTH old and new
  └── Backfill historical data into new structure

Phase 2: MIGRATE — Switch reads to the new structure
  ├── Deploy code that reads from new structure
  ├── Old structure is still populated but unused for reads
  └── Monitor for issues (easy rollback — just read from old)

Phase 3: CONTRACT — Remove the old structure
  ├── Deploy code that stops writing to old structure
  ├── Drop old column/table in migration
  └── This is the point of no return
```

### Example: Rename `name` to `full_name`

```
Week 1 Deploy: EXPAND
  schema: add full_name column (nullable)
  code:   write to both name AND full_name
  script: backfill full_name from name

Week 2 Deploy: MIGRATE
  code:   read from full_name, still write to both

Week 3 Deploy: CONTRACT
  code:   only use full_name
  schema: drop name column
```

### Deployment Order Matters

```
SAFE: Deploy code first, then migrate
  1. Deploy code that handles BOTH old and new schema ✅
  2. Run migration to change schema
  3. Code already handles new schema — no errors

UNSAFE: Migrate first, then deploy code
  1. Run migration to change schema ❌
  2. Running code doesn't know about new schema — ERRORS
  3. Deploy new code (too late, users already saw errors)
```

---

## PART 6: ROLLBACK PROCEDURES

### Prisma Doesn't Have Built-in Rollbacks

Unlike some ORMs, Prisma Migrate doesn't generate down migrations. You have options:

### Option 1: Manual Rollback SQL

```sql
-- Keep a rollback file alongside each migration
-- prisma/migrations/20260213120000_add_phone/rollback.sql

ALTER TABLE "users" DROP COLUMN IF EXISTS "phone";
```

### Option 2: Revert with a New Migration

```bash
# Undo the schema change in schema.prisma (remove the column)
# Then create a new migration
npx prisma migrate dev --name rollback_remove_phone
```

### Option 3: Mark as Rolled Back

```bash
# If a migration was partially applied and is stuck
npx prisma migrate resolve --rolled-back 20260213120000_add_phone
```

### Option 4: Database Snapshot (Safest)

```bash
# Before any production migration:

# 1. Take a snapshot
pg_dump -Fc mydb > pre-migration-backup.dump

# 2. Run migration
npx prisma migrate deploy

# 3. If something goes wrong:
pg_restore -d mydb pre-migration-backup.dump
```

### Rollback Decision Tree

```
Migration failed?
├── Only DDL changes (add column, add index)?
│   └── Create a new migration to undo it
├── Data was modified (UPDATE, DELETE)?
│   └── Restore from backup (data can't be un-modified)
├── Migration partially applied?
│   └── Use `prisma migrate resolve --rolled-back`
└── Production is down?
    └── Restore from backup immediately, investigate later
```

---

## PART 7: SEEDING

### Prisma Seed Configuration

```json
// package.json
{
  "prisma": {
    "seed": "ts-node prisma/seed.ts"
  }
}
```

```typescript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Upsert to make seeding idempotent (safe to run multiple times)
  const admin = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      name: 'Admin User',
      role: 'ADMIN',
    },
  });

  const testUser = await prisma.user.upsert({
    where: { email: 'user@example.com' },
    update: {},
    create: {
      email: 'user@example.com',
      name: 'Test User',
      role: 'USER',
    },
  });

  // Create related data
  await prisma.project.createMany({
    data: [
      { name: 'Demo Project', userId: testUser.id },
      { name: 'Admin Project', userId: admin.id },
    ],
    skipDuplicates: true,
  });

  console.log('Seed complete:', { admin: admin.id, testUser: testUser.id });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
```

```bash
# Run seed
npx prisma db seed

# Seed runs automatically with:
npx prisma migrate dev    # After each migration
npx prisma migrate reset  # After database reset
```

---

## PART 8: MIGRATION TESTING

### Test Migrations Before Production

```typescript
// test/migrations.test.ts
describe('Migrations', () => {
  it('should apply all migrations without error', async () => {
    // Use a test database
    const result = execSync('DATABASE_URL=postgresql://test:test@localhost:5432/migration_test npx prisma migrate deploy', {
      encoding: 'utf-8',
    });

    expect(result).not.toContain('Error');
  });

  it('should seed without error', async () => {
    const result = execSync('DATABASE_URL=postgresql://test:test@localhost:5432/migration_test npx prisma db seed', {
      encoding: 'utf-8',
    });

    expect(result).not.toContain('Error');
  });
});
```

### CI Pipeline for Migrations

```yaml
# .github/workflows/migration-check.yml
- name: Test migrations
  run: |
    npx prisma migrate deploy
    npx prisma db seed
  env:
    DATABASE_URL: postgresql://test:test@localhost:5432/test_db
```

---

## PART 9: COMMON MIGRATION PATTERNS TABLE

| # | Pattern | Risk | Approach |
|---|---------|------|----------|
| 1 | Add nullable column | Low | Direct migration |
| 2 | Add required column with default | Low-Medium | Direct migration (watch table size) |
| 3 | Add required column without default | Medium | Add nullable → backfill → set NOT NULL |
| 4 | Drop column | Medium | Remove code first → deploy → drop column |
| 5 | Rename column | High | Expand-and-contract (3 deploys) |
| 6 | Change column type (widen) | Low | Direct migration |
| 7 | Change column type (narrow) | High | Validate data first, then migrate |
| 8 | Add index | Low-Medium | Use CONCURRENTLY for large tables |
| 9 | Drop table | High | Ensure no code references → backup → drop |
| 10 | Split table | High | Expand-and-contract, data migration |

---

## PART 10: TROUBLESHOOTING

### Common Issues

| Issue | Cause | Fix |
|-------|-------|-----|
| `Migration failed to apply` | SQL error in migration | Fix SQL, use `migrate resolve` |
| `Drift detected` | Schema changed outside Prisma | Run `prisma migrate dev` to reconcile |
| `Migration already applied` | Running dev on fresh DB with existing migrations | Use `prisma migrate deploy` instead |
| `Shadow database error` | Can't create temp DB for diff | Grant CREATE DATABASE permission |
| `Prisma client out of date` | Forgot to regenerate after schema change | Run `npx prisma generate` |
| `Timeout during migration` | Large table lock | Add index CONCURRENTLY, batch data changes |

### Stuck Migration State

```bash
# Check migration status
npx prisma migrate status

# Mark a failed migration as rolled back
npx prisma migrate resolve --rolled-back "20260213120000_add_phone"

# Mark a migration as already applied (e.g., applied manually)
npx prisma migrate resolve --applied "20260213120000_add_phone"
```

---

## ✅ Exit Checklist

- [ ] Migration created with descriptive name (`--name add_phone_to_users`)
- [ ] Generated SQL reviewed before applying
- [ ] Destructive changes use expand-and-contract pattern
- [ ] Large table changes use CONCURRENTLY for indexes
- [ ] Data backfills run in batches (not one giant UPDATE)
- [ ] Rollback plan documented (SQL or backup restore)
- [ ] Production backup taken before applying migration
- [ ] Migration tested on staging with production-like data volume
- [ ] Seed script is idempotent (safe to run multiple times)
- [ ] Migration file committed alongside code changes
