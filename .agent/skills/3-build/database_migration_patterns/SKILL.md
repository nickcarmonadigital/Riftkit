---
name: Database Migration Patterns
description: Schema migrations with zero-downtime, expand-contract, backfill strategies, rollback, and migration tools
---

# Database Migration Patterns Skill

**Purpose**: Execute database schema migrations safely in production with zero-downtime strategies, expand-contract patterns, data backfill workflows, and reliable rollback procedures.

---

## TRIGGER COMMANDS

```text
"Run a database migration"
"Zero-downtime schema change"
"Add a column without downtime"
"Migrate database schema safely"
"Using database_migration_patterns skill: [task]"
```

---

## Migration Strategy Decision Matrix

| Change Type | Risk | Strategy | Downtime |
|-------------|------|----------|----------|
| Add nullable column | Low | Direct migration | Zero |
| Add non-nullable column | Medium | Expand-contract | Zero |
| Rename column | High | Expand-contract | Zero |
| Drop column | Medium | Contract (after code deploy) | Zero |
| Add index | Medium | CREATE INDEX CONCURRENTLY | Zero |
| Change column type | High | Expand-contract | Zero |
| Split table | Very high | Expand-contract + CDC | Zero |
| Merge tables | Very high | Expand-contract + backfill | Zero |

---

## Expand-Contract Pattern

### Phase Diagram

```
Phase 1: EXPAND          Phase 2: MIGRATE          Phase 3: CONTRACT
                          (code + data)

+----------+             +----------+               +----------+
| old_col  |             | old_col  | (read)        |          |
| new_col  | (nullable)  | new_col  | (write+read)  | new_col  |
+----------+             +----------+               +----------+
     |                        |                          |
Code writes to old_col   Code writes to both,       Code only uses new_col
new_col is NULL           reads from new_col         old_col dropped
```

### Example: Rename Column (username -> display_name)

**Step 1: Expand (add new column)**

```sql
-- Migration V1: Add new column
ALTER TABLE users ADD COLUMN display_name VARCHAR(255);

-- Backfill existing data
UPDATE users SET display_name = username WHERE display_name IS NULL;
```

**Step 2: Dual-write (deploy code changes)**

```python
# Application code writes to both columns
class UserService:
    def update_name(self, user_id: str, name: str):
        db.execute("""
            UPDATE users
            SET username = :name, display_name = :name
            WHERE id = :user_id
        """, {"name": name, "user_id": user_id})

    def get_name(self, user_id: str) -> str:
        row = db.execute("""
            SELECT COALESCE(display_name, username) AS name
            FROM users WHERE id = :user_id
        """, {"user_id": user_id})
        return row["name"]
```

**Step 3: Contract (drop old column)**

```sql
-- Migration V2: After all code reads from display_name only
ALTER TABLE users DROP COLUMN username;
```

---

## Zero-Downtime Migration Patterns

### Add Index Without Locking

```sql
-- PostgreSQL: CONCURRENTLY avoids exclusive table lock
CREATE INDEX CONCURRENTLY idx_orders_customer_id ON orders (customer_id);

-- MySQL: Use pt-online-schema-change for large tables
-- pt-online-schema-change --alter "ADD INDEX idx_customer_id (customer_id)" \
--   D=mydb,t=orders --execute
```

> **Warning**: `CREATE INDEX CONCURRENTLY` in PostgreSQL cannot run inside a transaction. Your migration tool must support non-transactional migrations.

### Add NOT NULL Column Safely

```sql
-- Step 1: Add nullable column with default
ALTER TABLE orders ADD COLUMN status VARCHAR(20) DEFAULT 'pending';

-- Step 2: Backfill (in batches to avoid lock contention)
UPDATE orders SET status = 'pending' WHERE status IS NULL AND id BETWEEN 1 AND 10000;
UPDATE orders SET status = 'pending' WHERE status IS NULL AND id BETWEEN 10001 AND 20000;
-- ... continue in batches

-- Step 3: Add NOT NULL constraint (after backfill complete)
ALTER TABLE orders ALTER COLUMN status SET NOT NULL;
```

### Change Column Type

```sql
-- WRONG: ALTER TABLE orders ALTER COLUMN amount TYPE DECIMAL(12,2);
-- This rewrites the entire table and locks it.

-- RIGHT: Expand-contract
-- Step 1: Add new column
ALTER TABLE orders ADD COLUMN amount_decimal DECIMAL(12,2);

-- Step 2: Backfill
UPDATE orders SET amount_decimal = amount::DECIMAL(12,2)
WHERE amount_decimal IS NULL AND id BETWEEN 1 AND 10000;

-- Step 3: Deploy code to write to both, read from new
-- Step 4: Drop old column
ALTER TABLE orders DROP COLUMN amount;
ALTER TABLE orders RENAME COLUMN amount_decimal TO amount;
```

---

## Backfill Strategies

### Batched Backfill Script

```python
import time
from contextlib import contextmanager

BATCH_SIZE = 5000
SLEEP_BETWEEN_BATCHES = 0.5  # seconds

def backfill_display_name(db):
    """Backfill display_name from username in batches."""
    total = 0
    while True:
        result = db.execute("""
            UPDATE users
            SET display_name = username
            WHERE id IN (
                SELECT id FROM users
                WHERE display_name IS NULL
                LIMIT :batch_size
                FOR UPDATE SKIP LOCKED
            )
            RETURNING id
        """, {"batch_size": BATCH_SIZE})

        count = result.rowcount
        total += count
        db.commit()

        if count == 0:
            break

        print(f"Backfilled {total} rows...")
        time.sleep(SLEEP_BETWEEN_BATCHES)

    print(f"Backfill complete: {total} total rows")
```

### Backfill Best Practices

| Practice | Why |
|----------|-----|
| Batch updates (1K-10K rows) | Avoid long transactions, reduce lock time |
| `FOR UPDATE SKIP LOCKED` | Allow concurrent access during backfill |
| Sleep between batches | Reduce replication lag and I/O pressure |
| Monitor replication lag | Pause backfill if lag exceeds threshold |
| Run during low-traffic hours | Minimize user impact |
| Idempotent updates | Safe to re-run if interrupted |

---

## Migration Tools

### Tool Comparison

| Tool | Language | Versioning | Rollback | Features |
|------|----------|-----------|----------|----------|
| Flyway | Java/CLI | Versioned (V1__) | Undo (Pro) | Simple, SQL-first |
| Liquibase | Java/CLI | Changelog | Built-in | XML/YAML/SQL, diff |
| Alembic | Python | Branch-based | Downgrade | SQLAlchemy integration |
| Prisma Migrate | JS/TS | Sequential | Manual | Schema-driven |
| golang-migrate | Go | Sequential | Down files | Lightweight |
| Atlas | Go | Declarative | Planned | HCL schema |

### Flyway

```sql
-- V1__create_orders_table.sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_customer_id ON orders (customer_id);
```

```sql
-- V2__add_order_status.sql
ALTER TABLE orders ADD COLUMN status VARCHAR(20) DEFAULT 'pending';
```

```bash
# Run migrations
flyway -url=jdbc:postgresql://db:5432/myapp \
  -user=admin -password=secret \
  -locations=filesystem:./migrations \
  migrate

# Check status
flyway info

# Validate
flyway validate
```

### Alembic

```bash
# Initialize
alembic init migrations

# Generate migration from model changes
alembic revision --autogenerate -m "add_order_status"

# Run migrations
alembic upgrade head

# Rollback one step
alembic downgrade -1

# Show history
alembic history --verbose
```

```python
# migrations/versions/abc123_add_order_status.py
from alembic import op
import sqlalchemy as sa

revision = "abc123"
down_revision = "prev456"

def upgrade():
    op.add_column("orders",
        sa.Column("status", sa.String(20), server_default="pending"))

def downgrade():
    op.drop_column("orders", "status")
```

### Prisma Migrate

```bash
# Generate migration from schema changes
npx prisma migrate dev --name add_order_status

# Apply in production
npx prisma migrate deploy

# Reset (dev only)
npx prisma migrate reset

# Check status
npx prisma migrate status
```

```prisma
// schema.prisma
model Order {
  id          String   @id @default(uuid())
  customerId  String   @map("customer_id")
  totalAmount Decimal  @map("total_amount") @db.Decimal(10, 2)
  status      String   @default("pending")
  createdAt   DateTime @default(now()) @map("created_at")

  customer Customer @relation(fields: [customerId], references: [id])

  @@map("orders")
}
```

---

## Rollback Strategies

### Pre-Deployment Rollback Plan

```markdown
## Migration Rollback Plan

**Migration**: V5__add_payment_method
**Date**: 2026-03-06
**Author**: Data Team

### Forward Migration
- Adds `payment_method` column (nullable) to `orders`
- Creates index on `payment_method`

### Rollback SQL
```sql
DROP INDEX IF EXISTS idx_orders_payment_method;
ALTER TABLE orders DROP COLUMN IF EXISTS payment_method;
```

### Rollback Decision Criteria
- Migration takes > 30 minutes (expected: 5 minutes)
- Error rate increases > 1% after code deployment
- Replication lag exceeds 60 seconds during backfill

### Rollback Window
- Safe to rollback within 24 hours (before new code depends on column)
- After 24 hours: must use expand-contract to remove
```

### Automated Rollback Check

```python
def validate_migration(db, migration_id: str) -> bool:
    """Run post-migration health checks."""
    checks = [
        ("Table exists", "SELECT 1 FROM information_schema.tables WHERE table_name = 'orders'"),
        ("Column exists", "SELECT 1 FROM information_schema.columns WHERE table_name = 'orders' AND column_name = 'status'"),
        ("Row count stable", "SELECT COUNT(*) FROM orders"),
        ("No null violations", "SELECT COUNT(*) FROM orders WHERE status IS NULL"),
    ]
    for name, query in checks:
        try:
            result = db.execute(query).fetchone()
            print(f"  [PASS] {name}: {result}")
        except Exception as e:
            print(f"  [FAIL] {name}: {e}")
            return False
    return True
```

---

## CI/CD Integration

```yaml
# .github/workflows/migration.yml
name: Database Migration
on:
  push:
    branches: [main]
    paths: ['migrations/**']

jobs:
  migrate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Validate migrations
        run: flyway validate -url=${{ secrets.DB_URL }}

      - name: Dry-run migration
        run: flyway migrate -url=${{ secrets.DB_URL }} -dryRunOutput=dryrun.sql

      - name: Review dry-run output
        run: cat dryrun.sql

      - name: Apply migration
        run: flyway migrate -url=${{ secrets.DB_URL }}
        if: github.ref == 'refs/heads/main'

      - name: Post-migration health check
        run: python scripts/migration_health_check.py
```

---

## Cross-References

- `3-build/kubernetes_operations` - Run migrations as K8s Jobs before deployment
- `3-build/airflow_orchestration` - Schedule backfill tasks via Airflow
- `5-ship/gitops_workflow` - Sync migrations via GitOps sync waves

---

## EXIT CHECKLIST

- [ ] Migration strategy selected (direct vs expand-contract)
- [ ] Migration file is idempotent (safe to re-run)
- [ ] Rollback SQL prepared and tested
- [ ] Backfill runs in batches with sleep between iterations
- [ ] Large tables use CONCURRENTLY for index creation
- [ ] NOT NULL added after backfill (not during column creation)
- [ ] Replication lag monitored during backfill
- [ ] Post-migration health check validates schema and data
- [ ] Migration tested in staging with production-like data volume
- [ ] Expand-contract phases documented (which deploy enables which phase)
- [ ] Migration integrated into CI/CD pipeline

---

*Skill Version: 1.0 | Created: March 2026*
