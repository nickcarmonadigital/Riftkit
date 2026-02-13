# Disaster Recovery Runbook

**Date**: _______________
**Project**: _______________
**Last Tested**: _______________
**RTO (Recovery Time Objective)**: _______________
**RPO (Recovery Point Objective)**: _______________

---

## 1. Service Architecture

```
[Draw or describe your architecture here]

Example:
  Users → CDN (CloudFront) → Frontend (Vercel)
                            → Backend (Railway/Fly.io) → PostgreSQL (Supabase)
                                                       → Redis (Upstash)
                                                       → S3 (file storage)
```

| Service | Provider | Region | URL / Endpoint |
|---------|----------|--------|----------------|
| Frontend | | | |
| Backend API | | | |
| Database | | | |
| Cache | | | |
| File Storage | | | |
| Email | | | |
| DNS | | | |

---

## 2. Status Pages

| Service | Status Page URL | Alert Channel |
|---------|-----------------|---------------|
| AWS | https://health.aws.amazon.com | |
| Vercel | https://www.vercel-status.com | |
| Supabase | https://status.supabase.com | |
| Stripe | https://status.stripe.com | |
| Sentry | https://status.sentry.io | |
| [Add yours] | | |

---

## 3. Scenario 1: Database Down

**Symptoms**: API returns 500 errors, /health/ready returns failure, Sentry floods with connection errors.

**Steps**:
1. Check database provider status page
2. Check database connection from local machine: `psql $DATABASE_URL -c "SELECT 1"`
3. If provider outage: wait, monitor status page, communicate to users
4. If connection issue: verify connection string, check IP allowlists, check connection pool limits
5. If data corruption: restore from latest backup (see Backup Restore below)
6. Verify recovery: hit /health/ready, check Sentry error rate

**Recovery Time**: 5-30 minutes (connection issue) | 1-4 hours (restore from backup)
**Prevention**: Connection pooling, read replicas, automated backups every 6 hours

---

## 4. Scenario 2: Backend Service Down

**Symptoms**: Frontend shows connection errors, /health returns timeout, monitoring alerts fire.

**Steps**:
1. Check hosting provider status page
2. Check deployment logs for crash reason
3. If OOM: increase memory limit, investigate memory leak
4. If crash loop: roll back to last known good deployment
5. If provider outage: wait, communicate to users
6. Verify recovery: hit /health, check application logs

**Rollback Command**:
```bash
# Railway
railway rollback

# Fly.io
fly releases list
fly deploy --image <previous-image>

# Docker
docker service update --rollback <service-name>
```

**Recovery Time**: 2-15 minutes (rollback) | varies (provider outage)
**Prevention**: Health checks with auto-restart, memory limits, graceful shutdown handling

---

## 5. Scenario 3: Frontend Deployment Broken

**Symptoms**: Users see white screen, broken UI, or old version. No backend errors.

**Steps**:
1. Check deployment logs (Vercel/Netlify dashboard)
2. Verify build output locally: `npm run build && npm run preview`
3. If build issue: revert last commit, redeploy
4. If CDN issue: purge CDN cache
5. If DNS issue: check DNS propagation (dig command)
6. Verify recovery: clear browser cache, check in incognito

**Recovery Time**: 5-10 minutes
**Prevention**: Preview deployments on PRs, smoke test after deploy

---

## 6. Scenario 4: Authentication System Down

**Symptoms**: Users cannot log in, 401 errors on all protected routes, JWT validation failures.

**Steps**:
1. Check if JWT_SECRET environment variable is set correctly
2. Check if auth service is running (backend logs)
3. If secret rotated accidentally: restore previous secret, existing tokens still work
4. If auth provider down (if using external): check provider status, enable maintenance mode
5. Verify recovery: test login flow end-to-end

**Recovery Time**: 5-20 minutes
**Prevention**: Never rotate JWT_SECRET without a migration plan, monitor auth error rates

---

## 7. Scenario 5: Payment System Down

**Symptoms**: Users cannot upgrade, webhook failures, Stripe dashboard shows errors.

**Steps**:
1. Check Stripe status page
2. Check webhook endpoint logs for failures
3. If webhook secret wrong: update STRIPE_WEBHOOK_SECRET in environment
4. If Stripe outage: enable graceful degradation (allow feature access, queue billing)
5. Replay missed webhooks from Stripe dashboard
6. Verify recovery: test checkout flow, verify webhook delivery

**Recovery Time**: varies (Stripe outage) | 10-30 minutes (webhook fix)
**Prevention**: Idempotent webhook handlers, webhook retry logic, billing grace period

---

## 8. Scenario 6: Data Breach Detected

**Symptoms**: Unauthorized data access, suspicious API patterns, user reports.

**Steps**:
1. **IMMEDIATELY**: Revoke compromised credentials (API keys, JWT secrets, DB passwords)
2. Rotate all secrets in production environment
3. Force logout all users (invalidate all sessions)
4. Audit access logs for scope of breach
5. Identify attack vector and patch vulnerability
6. Notify affected users within 72 hours (GDPR requirement)
7. File incident report
8. Engage legal counsel if user data was accessed

**Recovery Time**: 1-24 hours (initial containment) | days-weeks (full resolution)
**Prevention**: Regular security audits, principle of least privilege, audit logging

---

## 9. Scenario 7: DNS / Domain Issues

**Symptoms**: Site unreachable, DNS resolution fails, SSL certificate errors.

**Steps**:
1. Check DNS propagation: `dig yourdomain.com`
2. If DNS provider issue: check provider status page
3. If SSL expired: renew certificate, verify auto-renewal is configured
4. If domain expired: renew immediately through registrar
5. If nameserver issue: verify NS records at registrar match DNS provider
6. Verify recovery: check from multiple locations (use online DNS checker)

**Recovery Time**: 5 minutes (SSL) | up to 48 hours (DNS propagation)
**Prevention**: Auto-renewal on domain and SSL, DNS monitoring, calendar reminders

---

## 10. Scenario 8: Third-Party API Outage

**Symptoms**: Specific features fail (AI, email, storage), errors from external service calls.

**Steps**:
1. Identify which third-party service is down
2. Check their status page
3. Enable graceful degradation: show user-friendly message, queue requests
4. If prolonged: switch to backup provider (if available)
5. Retry queued requests when service recovers
6. Verify recovery: test affected feature end-to-end

**Recovery Time**: varies (depends on third-party)
**Prevention**: Circuit breaker pattern, request timeouts, fallback providers, queue failed requests

---

## 11. Backup Restore Procedure

```bash
# 1. Download latest backup
# (Replace with your actual backup location)
pg_dump $DATABASE_URL > pre_restore_backup.sql

# 2. Create a temporary database for verification
createdb temp_restore_test

# 3. Restore backup to temp database
psql temp_restore_test < backup_file.sql

# 4. Verify data integrity
psql temp_restore_test -c "SELECT count(*) FROM users;"
psql temp_restore_test -c "SELECT count(*) FROM organizations;"

# 5. If verified, restore to production
# WARNING: This will overwrite production data
psql $DATABASE_URL < backup_file.sql

# 6. Run any pending migrations
npx prisma migrate deploy

# 7. Verify application works
curl https://your-api.com/health/ready
```

---

## 12. Emergency Contacts

| Role | Name | Phone | Email | Availability |
|------|------|-------|-------|-------------|
| On-call Engineer | | | | |
| Tech Lead | | | | |
| DevOps / Infra | | | | |
| Product Owner | | | | |
| Legal (breach) | | | | |

---

## 13. Scheduled Maintenance Windows

| Task | Frequency | Day / Time | Duration | Responsible |
|------|-----------|------------|----------|-------------|
| Database backup verify | Weekly | | 30 min | |
| Dependency updates | Bi-weekly | | 1 hour | |
| Security patch review | Weekly | | 30 min | |
| DR drill (test restore) | Monthly | | 2 hours | |
| SSL/domain renewal check | Monthly | | 15 min | |

---

## 14. Post-Incident Review Template

After any incident, complete this within 48 hours:

**Incident Date**: _______________
**Duration**: _______________
**Severity**: P0 / P1 / P2 / P3
**Affected Users**: _______________

**Timeline**:
- HH:MM — Issue detected
- HH:MM — Investigation started
- HH:MM — Root cause identified
- HH:MM — Fix deployed
- HH:MM — Service restored

**Root Cause**: _______________

**What Went Well**:
1. _______________

**What Went Poorly**:
1. _______________

**Action Items**:

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| | | | ☐ |
| | | | ☐ |
| | | | ☐ |
