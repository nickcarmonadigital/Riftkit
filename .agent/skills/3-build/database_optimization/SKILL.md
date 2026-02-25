---
name: database_optimization
description: PostgreSQL and Prisma query optimization, indexing, and performance patterns
---

# Database Optimization Skill

**Purpose**: Optimize PostgreSQL queries and Prisma operations for performance — from indexing strategies to N+1 detection to connection pooling.

## 🎯 TRIGGER COMMANDS

```text
"This query is slow, help me optimize"
"Add indexes for [table]"
"Detect N+1 queries in [service]"
"Optimize database performance"
"Set up connection pooling"
"Using database_optimization skill"
```

## When to Use

- A query is slow (>100ms for simple queries, >500ms for complex)
- You suspect N+1 query problems
- Adding indexes to improve read performance
- Setting up connection pooling for production
- Analyzing query execution plans with EXPLAIN

---

## PART 1: INDEX STRATEGY

### Index Types in PostgreSQL + Prisma

| Type | Best For | Prisma Syntax |
|------|---------|--------------|
| **B-tree** (default) | Range queries, sorting, equality | `@@index([field])` |
| **Hash** | Equality-only lookups | `@@index([field], type: Hash)` |
| **GIN** | Full-text search, JSONB, arrays | `@@index([field], type: Gin)` |
| **GiST** | Geometry, full-text ranking | `@@index([field], type: Gist)` |

### Common Index Patterns

```prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique       // Unique index auto-created
  name      String
  role      Role     @default(USER)
  tenantId  String
  createdAt DateTime @default(now())

  // Single column index — fast lookups by tenantId
  @@index([tenantId])

  // Composite index — column ORDER matters
  // Covers: WHERE tenantId = X AND role = Y
  // Also covers: WHERE tenantId = X (leftmost prefix)
  // Does NOT cover: WHERE role = Y (no leftmost prefix)
  @@index([tenantId, role])

  // Index for sorting
  @@index([createdAt(sort: Desc)])
}

model Post {
  id        String   @id @default(uuid())
  title     String
  content   String
  status    Status   @default(DRAFT)
  authorId  String

  // Partial index concept — index only published posts
  // (Prisma doesn't support partial indexes directly — use raw SQL migration)
  @@index([authorId])
  @@index([status, createdAt(sort: Desc)])
}
```

### When NOT to Index

- **Small tables** (<1000 rows): Full scan is fast enough
- **High-write columns**: Every INSERT/UPDATE must update the index
- **Low selectivity**: Boolean columns (50/50 split) don't benefit
- **Unused queries**: Don't index columns you never filter/sort by

---

## PART 2: EXPLAIN ANALYZE

### Running EXPLAIN

```typescript
// In Prisma — use $queryRaw
const result = await this.prisma.$queryRaw`
  EXPLAIN ANALYZE
  SELECT * FROM users
  WHERE tenant_id = ${tenantId}
  AND role = 'ADMIN'
  ORDER BY created_at DESC
  LIMIT 20
`;
```

### Reading the Output

```
Limit (cost=0.42..15.67 rows=20 width=128) (actual time=0.035..0.089 rows=20 loops=1)
  -> Index Scan using users_tenant_id_role_idx on users
       (cost=0.42..380.25 rows=500 width=128) (actual time=0.033..0.083 rows=20 loops=1)
       Index Cond: (tenant_id = 'abc' AND role = 'ADMIN')
Planning Time: 0.152 ms
Execution Time: 0.112 ms     ← This is what matters
```

### Scan Types (Best → Worst)

| Scan Type | What It Means | Performance |
|-----------|-------------|-------------|
| **Index Only Scan** | All data from index, no table access | Best |
| **Index Scan** | Index lookup + table fetch | Good |
| **Bitmap Index Scan** | Multiple index results combined | Good for many rows |
| **Seq Scan** | Full table scan, every row | Worst (for large tables) |

**If you see Seq Scan on a large table with a WHERE clause → you need an index.**

---

## PART 3: N+1 DETECTION AND FIXES

### The Problem

```typescript
// N+1: 1 query for users + N queries for projects
const users = await this.prisma.user.findMany();  // 1 query
for (const user of users) {
  user.projects = await this.prisma.project.findMany({
    where: { userId: user.id },
  });  // N queries (one per user!)
}
// If 100 users → 101 queries!
```

### The Fix: Prisma Include (Eager Loading)

```typescript
// 1-2 queries total (Prisma uses JOIN or batch query)
const users = await this.prisma.user.findMany({
  include: {
    projects: true,         // Fetch related projects
  },
});
```

### Select Only What You Need

```typescript
// Don't fetch ALL columns — select only what's displayed
const users = await this.prisma.user.findMany({
  select: {
    id: true,
    name: true,
    email: true,
    _count: {
      select: { projects: true },  // Just the count, not all project data
    },
  },
});
```

### Detecting N+1 in Development

```typescript
// prisma middleware — log all queries with timing
const prisma = new PrismaClient({
  log: [
    { level: 'query', emit: 'event' },
  ],
});

prisma.$on('query', (e) => {
  if (e.duration > 100) {
    console.warn(`⚠️ Slow query (${e.duration}ms): ${e.query}`);
  }
});

// In development, watch for repeated similar queries
// If you see the same SELECT ... WHERE userId = ? running N times,
// you have an N+1 problem
```

---

## PART 4: CONNECTION POOLING

### Why Connections Are Expensive

Each database connection uses ~5-10MB of memory. PostgreSQL default max is 100 connections. If your app opens a new connection per request, you'll exhaust them quickly under load.

### Prisma Connection Pool

```
# DATABASE_URL with pool parameters
DATABASE_URL="postgresql://user:pass@host:5432/db?connection_limit=20&pool_timeout=10"
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `connection_limit` | `num_cpus * 2 + 1` | Max connections in pool |
| `pool_timeout` | `10` (seconds) | Wait time for available connection |

### PgBouncer (External Pooler)

For production at scale, put PgBouncer in front of PostgreSQL:

```
App → PgBouncer (100 client connections) → PostgreSQL (20 actual connections)
```

Modes:
- **Transaction pooling** (recommended): Connection returned after each transaction
- **Session pooling**: Connection held for entire client session

---

## PART 5: QUERY OPTIMIZATION PATTERNS

### Pagination: Offset vs Cursor

```typescript
// Offset — simple but slow for large offsets
const users = await this.prisma.user.findMany({
  skip: 10000,  // Must scan and discard 10,000 rows!
  take: 20,
  orderBy: { createdAt: 'desc' },
});

// Cursor — consistent performance regardless of page
const users = await this.prisma.user.findMany({
  cursor: { id: lastSeenId },
  skip: 1,      // Skip the cursor item
  take: 20,
  orderBy: { createdAt: 'desc' },
});
```

### Batch Operations

```typescript
// BAD — N individual inserts
for (const item of items) {
  await this.prisma.item.create({ data: item });  // N queries
}

// GOOD — single batch insert
await this.prisma.item.createMany({
  data: items,
  skipDuplicates: true,
});  // 1 query

// GOOD — transaction for related operations
await this.prisma.$transaction([
  this.prisma.order.create({ data: orderData }),
  this.prisma.inventory.updateMany({
    where: { productId: { in: productIds } },
    data: { stock: { decrement: 1 } },
  }),
]);
```

### Check Existence Without Counting

```typescript
// BAD — counts ALL matching rows
const count = await this.prisma.user.count({ where: { email } });
if (count > 0) { ... }

// GOOD — stops after finding one
const exists = await this.prisma.user.findFirst({
  where: { email },
  select: { id: true },  // Minimal data
});
if (exists) { ... }
```

---

## PART 6: MONITORING QUERIES

### Slow Query Logging (PostgreSQL)

```sql
-- Log queries taking more than 200ms
ALTER SYSTEM SET log_min_duration_statement = 200;
SELECT pg_reload_conf();
```

### Useful Monitoring Queries

```sql
-- Table sizes
SELECT relname AS table, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Index usage (find unused indexes)
SELECT indexrelname AS index, idx_scan AS times_used
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Cache hit ratio (should be > 99%)
SELECT
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) AS ratio
FROM pg_statio_user_tables;

-- Active connections
SELECT count(*) FROM pg_stat_activity WHERE state = 'active';
```

---

## PART 7: VACUUM & ANALYZE

```sql
-- VACUUM: reclaim space from deleted/updated rows
VACUUM (VERBOSE) users;

-- ANALYZE: update query planner statistics
ANALYZE users;

-- Both together
VACUUM ANALYZE users;

-- Check autovacuum is running
SELECT relname, last_vacuum, last_autovacuum, last_analyze
FROM pg_stat_user_tables
ORDER BY last_autovacuum DESC NULLS LAST;
```

**Autovacuum** runs automatically. You rarely need to run VACUUM manually unless:
- After a large DELETE or UPDATE (bulk data migration)
- Table is heavily used and autovacuum can't keep up
- Query planner is making bad choices (run ANALYZE)

---

---

## Agent Automation

> Use the **database-reviewer** agent (`.agent/agents/database-reviewer.md`) for automated database review.

---

## PART 8: ADVANCED INDEX PATTERNS

### Covering Index

Avoids table lookup entirely — all required data is in the index itself:

```sql
CREATE INDEX idx_users_email_covering ON users (email) INCLUDE (name, created_at);
-- SELECT email, name, created_at FROM users WHERE email = 'x' → Index Only Scan
```

### Partial Index

Smaller, faster index that only includes rows matching a condition:

```sql
CREATE INDEX idx_users_active ON users (email) WHERE deleted_at IS NULL;
-- Only indexes active users — much smaller than a full index
```

### BRIN Index (Time-Series Data)

For naturally ordered data (timestamps, auto-incrementing IDs):

```sql
CREATE INDEX idx_events_created ON events USING brin (created_at);
-- Much smaller than B-tree, excellent for append-only time-series data
```

### Data Type Quick Reference

| Use Case | Correct Type | Avoid |
|----------|-------------|-------|
| IDs | `bigint` or `uuid` | `int` (overflow risk) |
| Strings | `text` | `varchar(255)` (no performance difference in Postgres) |
| Timestamps | `timestamptz` | `timestamp` (loses timezone info) |
| Money | `numeric(10,2)` | `float` (precision loss) |
| Flags | `boolean` | `varchar`, `int` |

---

## PART 9: QUEUE PROCESSING WITH SKIP LOCKED

For job queues implemented in PostgreSQL — prevents workers from competing on the same row:

```sql
-- Claim a pending job atomically (no contention between workers)
UPDATE jobs SET status = 'processing', started_at = now()
WHERE id = (
  SELECT id FROM jobs
  WHERE status = 'pending'
  ORDER BY created_at
  LIMIT 1
  FOR UPDATE SKIP LOCKED
) RETURNING *;
```

This pattern is critical for:
- Background job processing
- Task queues without external infrastructure (no Redis/RabbitMQ needed)
- Distributed workers reading from the same table

---

## PART 10: ROW LEVEL SECURITY (RLS)

### Optimized RLS Policies

```sql
-- Enable RLS on a table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Optimized policy (wrap auth.uid() in SELECT for plan caching)
CREATE POLICY user_orders ON orders
  USING ((SELECT auth.uid()) = user_id);

-- Note: wrapping in SELECT ensures the function is evaluated once per query,
-- not once per row. This is a critical performance optimization.
```

### Multi-Tenant RLS

```sql
-- Tenant isolation via RLS
CREATE POLICY tenant_isolation ON documents
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

-- Set tenant context at the start of each request
SET LOCAL app.tenant_id = 'tenant-uuid-here';
```

---

## PART 11: ANTI-PATTERN DETECTION QUERIES

```sql
-- Find unindexed foreign keys (performance killer for JOINs)
SELECT conrelid::regclass AS table_name, a.attname AS column_name
FROM pg_constraint c
JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
WHERE c.contype = 'f'
  AND NOT EXISTS (
    SELECT 1 FROM pg_index i
    WHERE i.indrelid = c.conrelid AND a.attnum = ANY(i.indkey)
  );

-- Find slow queries (requires pg_stat_statements extension)
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
WHERE mean_exec_time > 100
ORDER BY mean_exec_time DESC;

-- Check table bloat (dead rows needing VACUUM)
SELECT relname, n_dead_tup, last_vacuum, last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY n_dead_tup DESC;
```

---

## PART 12: CONFIGURATION TUNING

```sql
-- Connection limits (adjust based on available RAM)
ALTER SYSTEM SET max_connections = 100;
ALTER SYSTEM SET work_mem = '8MB';

-- Timeouts (prevent runaway queries and idle transactions)
ALTER SYSTEM SET idle_in_transaction_session_timeout = '30s';
ALTER SYSTEM SET statement_timeout = '30s';

-- Security defaults
REVOKE ALL ON SCHEMA public FROM public;

-- Apply changes
SELECT pg_reload_conf();
```

---

## PART 13: MIGRATION SAFETY

### Core Principles

1. **Every change is a migration** — never alter production databases manually
2. **Migrations are forward-only in production** — rollbacks use new forward migrations
3. **Schema and data migrations are separate** — never mix DDL and DML
4. **Test against production-sized data** — what works on 100 rows may lock on 10M
5. **Migrations are immutable once deployed** — never edit a deployed migration

### Safe Column Operations

```sql
-- GOOD: Nullable column (no lock)
ALTER TABLE users ADD COLUMN avatar_url TEXT;

-- GOOD: Column with default (Postgres 11+ is instant, no rewrite)
ALTER TABLE users ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT true;

-- BAD: NOT NULL without default (full table rewrite + lock)
ALTER TABLE users ADD COLUMN role TEXT NOT NULL;
```

### Safe Index Creation

```sql
-- BAD: Blocks writes on large tables
CREATE INDEX idx_users_email ON users (email);

-- GOOD: Non-blocking, allows concurrent writes
CREATE INDEX CONCURRENTLY idx_users_email ON users (email);
-- Note: Cannot run inside a transaction block
```

### Zero-Downtime Column Rename (Expand-Contract)

```sql
-- Step 1: Add new column
ALTER TABLE users ADD COLUMN display_name TEXT;

-- Step 2: Backfill (separate migration)
UPDATE users SET display_name = username WHERE display_name IS NULL;

-- Step 3: Deploy app reading/writing both columns

-- Step 4: Drop old column (after all reads migrated)
ALTER TABLE users DROP COLUMN username;
```

### Large Data Migration (Batched)

```sql
DO $$
DECLARE
  batch_size INT := 10000;
  rows_updated INT;
BEGIN
  LOOP
    UPDATE users
    SET normalized_email = LOWER(email)
    WHERE id IN (
      SELECT id FROM users
      WHERE normalized_email IS NULL
      LIMIT batch_size
      FOR UPDATE SKIP LOCKED
    );
    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    RAISE NOTICE 'Updated % rows', rows_updated;
    EXIT WHEN rows_updated = 0;
    COMMIT;
  END LOOP;
END $$;
```

---

## ✅ Exit Checklist

- [ ] Indexes created for commonly filtered/sorted columns
- [ ] Covering indexes used for frequent query patterns
- [ ] Partial indexes used where applicable (e.g., active records only)
- [ ] No N+1 queries (verified with query logging)
- [ ] EXPLAIN ANALYZE run on slow queries
- [ ] Connection pooling configured for production
- [ ] Batch operations used instead of loops
- [ ] Cursor pagination for large datasets
- [ ] Slow query logging enabled in development
- [ ] Cache hit ratio > 99%
- [ ] Unindexed foreign keys identified and fixed
- [ ] RLS policies optimized with SELECT wrapper
- [ ] Migrations follow expand-contract for zero-downtime
- [ ] Large data migrations batched with SKIP LOCKED
