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

## ✅ Exit Checklist

- [ ] Indexes created for commonly filtered/sorted columns
- [ ] No N+1 queries (verified with query logging)
- [ ] EXPLAIN ANALYZE run on slow queries
- [ ] Connection pooling configured for production
- [ ] Batch operations used instead of loops
- [ ] Cursor pagination for large datasets
- [ ] Slow query logging enabled in development
- [ ] Cache hit ratio > 99%
