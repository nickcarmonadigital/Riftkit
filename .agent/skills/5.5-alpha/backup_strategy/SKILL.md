---
name: backup_strategy
description: Database backup and disaster recovery procedures for PostgreSQL
---

# Backup Strategy Skill

**Purpose**: Establish automated database backup procedures, define recovery objectives, and verify restore processes so that data loss events are survivable and recovery is predictable rather than panicked.

## 🎯 TRIGGER COMMANDS

```text
"set up backups"
"backup strategy"
"disaster recovery for database"
"configure database backups"
"Using backup_strategy skill: implement backup and recovery"
```

## 📊 RECOVERY OBJECTIVES

Define these FIRST -- they dictate every decision that follows:

| Metric | Definition | Typical Target | Your Target |
|--------|-----------|----------------|-------------|
| **RPO** (Recovery Point Objective) | Maximum acceptable data loss measured in time | 1 hour | _________ |
| **RTO** (Recovery Time Objective) | Maximum acceptable downtime during recovery | 4 hours | _________ |

**Examples:**
- RPO of 1 hour means you need backups at least every hour
- RTO of 4 hours means your restore process must complete in under 4 hours
- RPO of 0 (zero data loss) requires continuous replication or PITR

> [!WARNING]
> An untested backup is not a backup -- it is a hope. If you have never restored from your backups, you do NOT have a disaster recovery plan. You have a disaster.

## ☁️ SUPABASE BACKUP TIERS

If using Supabase as your PostgreSQL host:

| Tier | Backup Type | Frequency | Retention | Cost |
|------|------------|-----------|-----------|------|
| **Free** | Daily snapshot | Every 24 hours | 7 days | $0/month |
| **Pro** | Daily snapshot | Every 24 hours | 14 days | $25/month (plan cost) |
| **Pro + PITR** | Point-in-Time Recovery | Continuous (WAL) | 7 days | ~$100/month addon |
| **Enterprise** | PITR + cross-region | Continuous | 30 days | Custom |

**PITR (Point-in-Time Recovery)** allows restoring to any second within the retention window. Essential for:
- Recovering from accidental `DELETE FROM users` at 14:32:07
- Precise rollback after a bad migration
- Compliance requirements (financial, healthcare)

> [!TIP]
> For most SaaS apps, Supabase Pro with daily backups is sufficient during early stages. Add PITR when you have paying customers and your RPO drops below 24 hours.

## 🛠️ MANUAL BACKUP: pg_dump

For any PostgreSQL database, `pg_dump` is the standard backup tool:

### Basic Backup Script

Create `scripts/backup.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Configuration
DB_URL="${DATABASE_URL:?DATABASE_URL is required}"
BACKUP_DIR="${BACKUP_DIR:-./backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql.gz"

# Ensure backup directory exists
mkdir -p "${BACKUP_DIR}"

echo "[$(date)] Starting backup..."

# Dump and compress in one step
pg_dump "${DB_URL}" \
  --format=custom \
  --no-owner \
  --no-privileges \
  --verbose \
  2>"${BACKUP_DIR}/backup_${TIMESTAMP}.log" \
  | gzip > "${BACKUP_FILE}"

# Verify the backup is not empty
FILESIZE=$(stat -f%z "${BACKUP_FILE}" 2>/dev/null || stat --printf="%s" "${BACKUP_FILE}")
if [ "${FILESIZE}" -lt 1024 ]; then
  echo "[$(date)] ERROR: Backup file suspiciously small (${FILESIZE} bytes)"
  exit 1
fi

echo "[$(date)] Backup complete: ${BACKUP_FILE} ($(du -h "${BACKUP_FILE}" | cut -f1))"

# Clean up old local backups (keep last 7 days)
find "${BACKUP_DIR}" -name "backup_*.sql.gz" -mtime +7 -delete
echo "[$(date)] Old backups cleaned up"
```

### Upload to S3

```bash
#!/bin/bash
set -euo pipefail

# After creating the backup file...
S3_BUCKET="${S3_BACKUP_BUCKET:?S3_BACKUP_BUCKET is required}"
S3_PREFIX="database-backups"

# Upload with server-side encryption
aws s3 cp "${BACKUP_FILE}" \
  "s3://${S3_BUCKET}/${S3_PREFIX}/${BACKUP_FILE##*/}" \
  --storage-class STANDARD_IA \
  --sse AES256

echo "[$(date)] Uploaded to s3://${S3_BUCKET}/${S3_PREFIX}/${BACKUP_FILE##*/}"
```

> [!WARNING]
> Store backups in a DIFFERENT AWS account or at minimum a different region from your production infrastructure. If your production account is compromised, the attacker should not have access to backups.

## ⏰ AUTOMATED BACKUP SCHEDULE

### Option A: Cron Job (VPS/EC2)

```bash
# Edit crontab: crontab -e

# Daily backup at 3:00 AM UTC
0 3 * * * /opt/scripts/backup.sh >> /var/log/backup.log 2>&1

# Weekly full backup on Sunday at 2:00 AM UTC
0 2 * * 0 /opt/scripts/full-backup.sh >> /var/log/backup.log 2>&1
```

### Option B: GitHub Actions (Recommended for Most Teams)

Create `.github/workflows/database-backup.yml`:

```yaml
name: Database Backup

on:
  schedule:
    # Daily at 3:00 AM UTC
    - cron: '0 3 * * *'
  workflow_dispatch:
    inputs:
      reason:
        description: 'Reason for manual backup'
        required: true

env:
  BACKUP_RETENTION_DAYS: 7

jobs:
  backup:
    runs-on: ubuntu-latest
    timeout-minutes: 30

    steps:
      - name: Install PostgreSQL client
        run: |
          sudo apt-get update
          sudo apt-get install -y postgresql-client-16

      - name: Create backup
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
        run: |
          TIMESTAMP=$(date +%Y%m%d_%H%M%S)
          BACKUP_FILE="backup_${TIMESTAMP}.dump"

          pg_dump "${DATABASE_URL}" \
            --format=custom \
            --no-owner \
            --no-privileges \
            --file="${BACKUP_FILE}"

          # Verify backup integrity
          pg_restore --list "${BACKUP_FILE}" > /dev/null 2>&1
          echo "Backup verified: ${BACKUP_FILE}"
          echo "BACKUP_FILE=${BACKUP_FILE}" >> $GITHUB_ENV

      - name: Upload to S3
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_BACKUP_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_BACKUP_SECRET_KEY }}
          AWS_DEFAULT_REGION: us-east-1
        run: |
          aws s3 cp "${BACKUP_FILE}" \
            "s3://${{ secrets.S3_BACKUP_BUCKET }}/daily/${BACKUP_FILE}" \
            --storage-class STANDARD_IA \
            --sse AES256

      - name: Notify on failure
        if: failure()
        env:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}
        run: |
          curl -X POST "${SLACK_WEBHOOK}" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"DATABASE BACKUP FAILED at $(date). Check GitHub Actions.\"}"

      - name: Notify on success
        if: success()
        env:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}
        run: |
          FILESIZE=$(du -h "${BACKUP_FILE}" | cut -f1)
          curl -X POST "${SLACK_WEBHOOK}" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"Database backup complete: ${BACKUP_FILE} (${FILESIZE})\"}"
```

## 🔄 RESTORE PROCEDURES

### Step-by-Step Restore

```bash
#!/bin/bash
set -euo pipefail

# 1. Download the backup
BACKUP_FILE="backup_20260208_030000.dump"
aws s3 cp "s3://${S3_BACKUP_BUCKET}/daily/${BACKUP_FILE}" ./"${BACKUP_FILE}"

# 2. Create a temporary database to verify the restore
createdb -h localhost -U postgres "restore_verification_$(date +%s)"
TEMP_DB="restore_verification_$(date +%s)"

# 3. Restore to temporary database first (ALWAYS verify before overwriting production)
pg_restore \
  --dbname="${TEMP_DB}" \
  --no-owner \
  --no-privileges \
  --verbose \
  "${BACKUP_FILE}"

# 4. Verify data integrity
psql "${TEMP_DB}" -c "SELECT COUNT(*) FROM users;"
psql "${TEMP_DB}" -c "SELECT COUNT(*) FROM organizations;"
echo "Verify the counts above match expected values"

# 5. If verification passes, restore to actual target
# WARNING: This will overwrite the target database
read -p "Restore to production? (yes/no): " CONFIRM
if [ "${CONFIRM}" = "yes" ]; then
  pg_restore \
    --dbname="${DATABASE_URL}" \
    --clean \
    --if-exists \
    --no-owner \
    --no-privileges \
    --verbose \
    "${BACKUP_FILE}"
  echo "Production restore complete"
fi

# 6. Clean up temp database
dropdb "${TEMP_DB}"
```

### Monthly Restore Verification

Create `.github/workflows/backup-verify.yml`:

```yaml
name: Verify Backup Restore

on:
  schedule:
    # First Sunday of every month at 5:00 AM UTC
    - cron: '0 5 1-7 * 0'
  workflow_dispatch: {}

jobs:
  verify-restore:
    runs-on: ubuntu-latest
    timeout-minutes: 60

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: testpassword
          POSTGRES_DB: restore_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - name: Install PostgreSQL client
        run: sudo apt-get install -y postgresql-client-16

      - name: Download latest backup
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_BACKUP_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_BACKUP_SECRET_KEY }}
          AWS_DEFAULT_REGION: us-east-1
        run: |
          LATEST=$(aws s3 ls "s3://${{ secrets.S3_BACKUP_BUCKET }}/daily/" \
            | sort | tail -1 | awk '{print $4}')
          aws s3 cp "s3://${{ secrets.S3_BACKUP_BUCKET }}/daily/${LATEST}" ./backup.dump
          echo "Downloaded: ${LATEST}"

      - name: Restore backup
        env:
          PGPASSWORD: testpassword
        run: |
          pg_restore \
            --host=localhost \
            --username=postgres \
            --dbname=restore_test \
            --no-owner \
            --no-privileges \
            --verbose \
            ./backup.dump

      - name: Verify data integrity
        env:
          PGPASSWORD: testpassword
        run: |
          echo "=== Table row counts ==="
          psql -h localhost -U postgres -d restore_test -c "
            SELECT schemaname, relname, n_live_tup
            FROM pg_stat_user_tables
            ORDER BY n_live_tup DESC
            LIMIT 20;
          "

          echo "=== Critical tables exist ==="
          psql -h localhost -U postgres -d restore_test -c "
            SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'users');
            SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'organizations');
          "

      - name: Notify result
        if: always()
        env:
          SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}
        run: |
          STATUS="${{ job.status }}"
          if [ "${STATUS}" = "success" ]; then
            MSG="Monthly backup restore verification PASSED"
          else
            MSG="Monthly backup restore verification FAILED — investigate immediately"
          fi
          curl -X POST "${SLACK_WEBHOOK}" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"${MSG}\"}"
```

## 🔒 BACKUP TYPES EXPLAINED

| Type | What It Captures | Size | Restore Speed | When to Use |
|------|-----------------|------|---------------|-------------|
| **Full (pg_dump)** | Complete database snapshot | Large | Medium | Daily backups |
| **Incremental (WAL)** | Only changes since last backup | Small | Slow (replay) | Continuous backup |
| **PITR** | WAL archiving + base backup | Medium | Variable | Need second-level precision |
| **Logical** | SQL statements to recreate | Large | Slow | Cross-version migration |

## 🛡️ PRE-MIGRATION BACKUP

**Always** backup before running migrations:

```bash
#!/bin/bash
set -euo pipefail

# scripts/migrate-with-backup.sh
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="pre_migration_${TIMESTAMP}.dump"

echo "[$(date)] Creating pre-migration backup..."
pg_dump "${DATABASE_URL}" \
  --format=custom \
  --no-owner \
  --file="${BACKUP_FILE}"

echo "[$(date)] Backup created: ${BACKUP_FILE}"
echo "[$(date)] Running migrations..."

npx prisma migrate deploy

if [ $? -eq 0 ]; then
  echo "[$(date)] Migration successful"
  # Upload backup to S3 for safekeeping
  aws s3 cp "${BACKUP_FILE}" \
    "s3://${S3_BACKUP_BUCKET}/pre-migration/${BACKUP_FILE}" \
    --sse AES256
else
  echo "[$(date)] MIGRATION FAILED — Restore from: ${BACKUP_FILE}"
  echo "[$(date)] Restore command:"
  echo "  pg_restore --dbname=\${DATABASE_URL} --clean --if-exists ${BACKUP_FILE}"
  exit 1
fi
```

## 📋 RETENTION POLICY

| Backup Type | Keep For | Storage Class | Purpose |
|-------------|----------|---------------|---------|
| Daily | 7 days | S3 Standard-IA | Quick recovery from recent issues |
| Weekly (Sunday) | 4 weeks | S3 Standard-IA | Recover from issues found late |
| Monthly (1st) | 12 months | S3 Glacier | Compliance and audit |
| Pre-migration | 30 days | S3 Standard-IA | Migration rollback |

### S3 Lifecycle Policy

```json
{
  "Rules": [
    {
      "ID": "DailyBackupRetention",
      "Filter": { "Prefix": "daily/" },
      "Status": "Enabled",
      "Expiration": { "Days": 7 }
    },
    {
      "ID": "WeeklyBackupRetention",
      "Filter": { "Prefix": "weekly/" },
      "Status": "Enabled",
      "Expiration": { "Days": 28 }
    },
    {
      "ID": "MonthlyToGlacier",
      "Filter": { "Prefix": "monthly/" },
      "Status": "Enabled",
      "Transitions": [
        { "Days": 30, "StorageClass": "GLACIER" }
      ],
      "Expiration": { "Days": 365 }
    },
    {
      "ID": "PreMigrationRetention",
      "Filter": { "Prefix": "pre-migration/" },
      "Status": "Enabled",
      "Expiration": { "Days": 30 }
    }
  ]
}
```

## 🔐 ENCRYPTION

All backups must be encrypted at rest:

```bash
# Option A: S3 Server-Side Encryption (recommended)
aws s3 cp backup.dump s3://bucket/backup.dump --sse AES256

# Option B: Client-Side Encryption with GPG (for non-S3 storage)
gpg --symmetric --cipher-algo AES256 --output backup.dump.gpg backup.dump

# Decrypt:
gpg --decrypt --output backup.dump backup.dump.gpg
```

> [!TIP]
> Use S3 Server-Side Encryption (SSE-S3 or SSE-KMS) for simplicity. Client-side encryption adds complexity and key management overhead. Only use it if compliance requires you to manage your own keys.

## 📤 GDPR DATA EXPORT

For user data export requests (GDPR Article 20 - Right to Data Portability):

```bash
#!/bin/bash
# scripts/export-user-data.sh
USER_ID="${1:?Usage: export-user-data.sh <user-uuid>}"

psql "${DATABASE_URL}" -c "
  COPY (
    SELECT row_to_json(t)
    FROM (
      SELECT u.*,
        (SELECT json_agg(p) FROM projects p WHERE p.user_id = u.id) as projects,
        (SELECT json_agg(d) FROM documents d WHERE d.user_id = u.id) as documents
      FROM users u
      WHERE u.id = '${USER_ID}'
    ) t
  ) TO STDOUT;
" > "user_export_${USER_ID}.json"

echo "User data exported to user_export_${USER_ID}.json"
```

## 🚫 WHAT NOT TO BACKUP

These are reproducible and should NOT be in your database backup strategy:

| Item | Why Not |
|------|---------|
| `node_modules/` | Reinstall with `npm install` |
| `dist/` / `build/` / `.next/` | Rebuild from source |
| Application logs | Use a log aggregation service |
| Docker images | Rebuild from Dockerfile |
| Temporary files | By definition, temporary |
| Git history | Already stored in Git remote |

## 📡 MONITORING: BACKUP FAILURE ALERTS

Backup monitoring checklist:

| Check | Alert If | Severity |
|-------|----------|----------|
| Backup completed | No backup in last 26 hours | P1 Critical |
| Backup size | Size decreased >50% from yesterday | P2 Major |
| S3 upload | Upload failed | P1 Critical |
| Monthly restore test | Restore failed | P0 Blocker |
| Backup encryption | Unencrypted backup detected | P1 Critical |

## ✅ EXIT CHECKLIST

- [ ] RPO and RTO defined and documented
- [ ] Automated daily backups running (cron or GitHub Actions)
- [ ] Backups uploaded to S3 (separate from production infrastructure)
- [ ] Backups encrypted at rest (SSE-S3 or GPG)
- [ ] Restore procedure documented step-by-step
- [ ] Restore tested successfully on a temporary database
- [ ] Monthly automated restore verification configured
- [ ] Pre-migration backup script exists and is used before every `prisma migrate deploy`
- [ ] Retention policy configured (7 daily, 4 weekly, 12 monthly)
- [ ] S3 lifecycle rules enforce automatic deletion of expired backups
- [ ] Slack/email alert fires if a backup fails
- [ ] Backup size monitored for unexpected changes
- [ ] GDPR data export script available for user data requests
- [ ] Team knows where backups are stored and how to restore

*Skill Version: 1.0 | Created: February 2026*
