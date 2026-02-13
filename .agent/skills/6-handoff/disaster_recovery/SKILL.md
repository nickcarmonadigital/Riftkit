---
name: Disaster Recovery & Incident Response
description: Runbook creation for production failures, incident response procedures, and post-incident reviews
---

# Disaster Recovery & Incident Response Skill

**Purpose**: When production is on fire, you need a runbook -- not a brainstorming session. This skill provides scenario-based playbooks so anyone on the team can respond to outages quickly and correctly.

> [!CAUTION]
> **Write runbooks BEFORE you need them.** During an incident is the worst time to figure out your recovery process. Document it now while things are calm.

---

## 🎯 TRIGGER COMMANDS

```text
"Create DR runbook for [project]"
"Write disaster recovery plan"
"Set up incident response procedures"
"Create runbook for [scenario]"
"Using disaster_recovery skill: plan for [project/service]"
```

---

## 🏗️ SERVICE ARCHITECTURE MAP

Before writing runbooks, document your stack. Every service in the chain is a potential failure point.

```text
┌──────────────┐
│    USERS     │
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│     CDN      │     │  DNS (e.g.   │
│ (CloudFront/ │◄────│  Cloudflare) │
│  Vercel Edge)│     └──────────────┘
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│   FRONTEND   │     │   AUTH       │
│ (Vercel/     │────▶│ (Supabase/   │
│  Netlify)    │     │  Auth0)      │
└──────┬───────┘     └──────────────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   BACKEND    │────▶│  DATABASE    │     │   CACHE      │
│  (API/NestJS │     │ (PostgreSQL/ │     │  (Redis)     │
│   Railway/   │     │  Supabase)   │     └──────────────┘
│   Render)    │     └──────────────┘
└──────┬───────┘
       │
       ├────────────────────┬────────────────────┐
       ▼                    ▼                    ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   PAYMENTS   │     │    EMAIL     │     │  AI / LLM    │
│  (Stripe)    │     │  (Resend/    │     │  (OpenAI/    │
│              │     │  SendGrid)   │     │   Claude)    │
└──────────────┘     └──────────────┘     └──────────────┘
```

**Action**: Replace the above with your actual stack. Every box is a failure domain.

---

## 📋 STATUS PAGES TO BOOKMARK

Bookmark these NOW. During an outage, checking if it is your fault or theirs saves critical minutes.

| Service | Status Page | What Breaks If Down |
|---------|-------------|---------------------|
| **Vercel** | https://www.vercel-status.com | Frontend deploys, edge functions |
| **Netlify** | https://www.netlifystatus.com | Frontend hosting |
| **Railway** | https://status.railway.app | Backend hosting |
| **Render** | https://status.render.com | Backend hosting |
| **Supabase** | https://status.supabase.com | Database, auth, storage |
| **AWS** | https://health.aws.amazon.com | Infrastructure |
| **Cloudflare** | https://www.cloudflarestatus.com | DNS, CDN, DDoS protection |
| **Stripe** | https://status.stripe.com | Payments, webhooks |
| **Resend** | https://resend-status.com | Transactional email |
| **SendGrid** | https://status.sendgrid.com | Transactional email |
| **OpenAI** | https://status.openai.com | GPT API, embeddings |
| **GitHub** | https://www.githubstatus.com | CI/CD, source control |

> [!TIP]
> **Subscribe to RSS/email alerts** on every status page you depend on. You will often know about an outage before your users report it.

---

## 🚨 INCIDENT SEVERITY LEVELS

Classify every incident immediately. Severity determines response urgency and communication.

| Level | Name | Definition | Response Time | Who Gets Notified |
|-------|------|------------|---------------|-------------------|
| **SEV1** | Critical | Service is completely down for all users | Immediate (drop everything) | Entire team, stakeholders, users |
| **SEV2** | Major | Service is significantly degraded or down for subset | Within 30 minutes | Engineering team, stakeholders |
| **SEV3** | Minor | Feature is broken but workaround exists | Within 4 hours | Engineering team |
| **SEV4** | Cosmetic | Visual bug, typo, minor UX issue | Next business day | Logged in backlog |

---

## 📕 SCENARIO RUNBOOKS

### Runbook Format

Every runbook follows this structure:

```text
SCENARIO: [What happened]
SEVERITY: [SEV1-4]
SYMPTOMS: [What you see / what users report]
STEPS: [Numbered recovery actions]
RECOVERY TIME TARGET: [How fast you should fix it]
PREVENTION: [How to stop it from happening again]
```

---

### Scenario 1: Backend Service Down

**Severity**: SEV1
**Symptoms**: API returns 502/503, frontend shows "Connection error", health check fails

**Steps**:

1. **Confirm the outage**
   - Check your hosting dashboard (Railway/Render/AWS)
   - Check hosting provider status page
   - Run: `curl -I https://api.yourapp.com/health`

2. **Check logs**
   - Go to your hosting provider's log viewer
   - Look for: crash loop, OOM (Out of Memory), unhandled exceptions
   - Search for the last successful request timestamp

3. **Identify root cause**

   | Symptom | Likely Cause | Fix |
   |---------|-------------|-----|
   | `FATAL ERROR: heap out of memory` | OOM - memory leak or payload too large | Increase memory limit, find the leak |
   | Crash loop (restarts every 30s) | Unhandled exception at startup | Check recent deploys, rollback |
   | `ECONNREFUSED` to database | DB connection issue | Check DB status, connection string |
   | CPU at 100% | Infinite loop or expensive query | Identify hot path, rollback if recent deploy |

4. **Rollback if recent deploy caused it**
   - Railway: Click "Rollback" on previous deployment
   - Render: "Manual Deploy" with previous commit
   - Verify health check passes after rollback

5. **Restart the service** (if not a code issue)
   - Railway: Redeploy current version
   - Render: "Manual Deploy" > same commit
   - Docker: `docker restart <container>`

6. **Verify recovery**
   - Health check returns 200
   - Test critical user flows manually
   - Monitor error rate for 15 minutes

**Recovery Time Target**: 30 minutes

**Prevention**:
- [ ] Health check endpoint implemented (`/health`)
- [ ] Memory limits configured with alerts
- [ ] Auto-scaling or restart policies enabled
- [ ] Deploy previews tested before production

---

### Scenario 2: Frontend Deploy Broken

**Severity**: SEV1 (white screen) / SEV2 (partial break)
**Symptoms**: White screen, old version showing, JavaScript console errors, broken layout

**Steps**:

1. **Check if it is a CDN/caching issue**
   - Hard refresh: `Ctrl+Shift+R`
   - Check in incognito window
   - Check from a different network/device

2. **Check Vercel/Netlify deployment status**
   - Is the latest deploy marked as "Ready"?
   - Check build logs for errors

3. **Rollback the deploy**
   - Vercel: Deployments > click three dots on previous deploy > "Promote to Production"
   - Netlify: Deploys > click previous deploy > "Publish deploy"

4. **If CDN is serving stale content**
   - Vercel: Automatic, but check edge cache
   - Cloudflare: Purge cache via dashboard or API
   - Wait 2-5 minutes for propagation

5. **Debug the build failure**
   - Check build logs for TypeScript/ESLint errors
   - Check environment variables are set correctly
   - Verify `npm run build` succeeds locally

**Recovery Time Target**: 15 minutes (rollback), 1 hour (fix forward)

**Prevention**:
- [ ] Preview deployments reviewed before merge
- [ ] Build tested in CI before deploy
- [ ] Environment variables managed via hosting dashboard, not hardcoded

---

### Scenario 3: Database Corruption or Data Loss

**Severity**: SEV1
**Symptoms**: Missing records, query errors, foreign key violations, application errors on reads

**Steps**:

1. **Stop the bleeding**
   - If writes are corrupting data, put the app in read-only mode or maintenance mode
   - Do NOT run fix-up queries until you understand the scope

2. **Assess the damage**
   - Which tables are affected?
   - When did the corruption start? (check application logs, deploy history)
   - How many records are affected?

3. **Choose a recovery strategy**

   | Strategy | When to Use | Data Loss Window |
   |----------|-------------|------------------|
   | **Point-in-Time Recovery (PITR)** | Exact moment of corruption is known | Seconds |
   | **Daily Backup Restore** | PITR not available or corruption was gradual | Up to 24 hours |
   | **Manual Fix** | Small number of records, known scope | None (surgical fix) |

4. **Execute PITR (Supabase)**
   - Dashboard > Database > Backups > Point in Time Recovery
   - Select timestamp just before corruption
   - Restore creates a new project -- verify data, then switch DNS

5. **Execute daily backup restore**
   - Download latest backup
   - Restore to a staging database first
   - Verify critical tables
   - Swap connection string to restored database

6. **After recovery**
   - Verify data integrity with count checks
   - Test critical application flows
   - Notify affected users if data was lost

**Recovery Time Target**: 1-4 hours

**Prevention**:
- [ ] PITR enabled (Supabase Pro plan or AWS RDS)
- [ ] Daily backups automated and tested
- [ ] Destructive migrations require approval
- [ ] `DELETE`/`UPDATE` queries always include `WHERE` clause (lint for this)

---

### Scenario 4: Auth Provider Down

**Severity**: SEV1 (nobody can log in)
**Symptoms**: Login returns 500, "Unable to verify token", auth callback hangs

**Steps**:

1. **Check provider status page** (Supabase, Auth0, Firebase Auth)
2. **Determine scope**: Is it login only, or are existing sessions broken too?
3. **If provider outage**:
   - If existing JWTs still validate locally, users with active sessions are fine
   - Communicate to users: "New logins temporarily unavailable"
   - Wait for provider resolution (you cannot fix their outage)
4. **If configuration issue**:
   - Check environment variables (`SUPABASE_URL`, `SUPABASE_ANON_KEY`)
   - Check JWT secret has not changed
   - Check OAuth redirect URLs match your domain
   - Check SSL certificates are valid
5. **Post-resolution**: Force a test login, verify JWT creation and validation

**Recovery Time Target**: Depends on provider (minutes to hours)

**Prevention**:
- [ ] JWT validation can work offline (public key cached)
- [ ] Auth environment variables documented
- [ ] Provider status page bookmarked and alerts subscribed

---

### Scenario 5: Payment Webhook Failures

**Severity**: SEV2
**Symptoms**: Payments succeed in Stripe but app doesn't update, subscription status stale, users report "paid but no access"

**Steps**:

1. **Check Stripe webhook dashboard**
   - Go to Stripe Dashboard > Developers > Webhooks
   - Look for failed deliveries (red indicators)
   - Check the error message on failed events

2. **Common causes and fixes**

   | Error | Cause | Fix |
   |-------|-------|-----|
   | `Signature verification failed` | Webhook secret mismatch | Update `STRIPE_WEBHOOK_SECRET` env var |
   | `Connection refused` / `Timeout` | Backend is down or URL wrong | Fix backend, update webhook URL |
   | `400 Bad Request` | Code bug in webhook handler | Check logs, fix handler code |
   | `410 Gone` | Endpoint URL changed after deploy | Update webhook URL in Stripe |

3. **Replay failed events**
   - Stripe Dashboard > Webhooks > Failed Events > "Resend"
   - Or use the CLI: `stripe events resend evt_xxxxx`

4. **Manually reconcile** (if replay is not sufficient)
   - Export affected Stripe events
   - Cross-reference with your database
   - Apply missing state changes manually

**Recovery Time Target**: 1 hour

**Prevention**:
- [ ] Webhook handler is idempotent (processing same event twice is safe)
- [ ] Webhook signature verification implemented
- [ ] Failed webhook alerts configured in Stripe
- [ ] Reconciliation job runs daily to catch missed webhooks

---

### Scenario 6: Security Breach

**Severity**: SEV1
**Symptoms**: Unusual database activity, unauthorized access in logs, user reports of compromised accounts, data appearing where it should not

**Steps**:

1. **CONTAIN immediately**
   - Rotate ALL compromised credentials (API keys, DB passwords, JWT secrets)
   - Revoke all active user sessions (invalidate all JWTs)
   - If database: change password and restrict network access
   - If code: revert malicious commits, lock repository access

2. **ASSESS the impact**
   - What data was accessed or exfiltrated?
   - How many users are affected?
   - How did the attacker get in? (check access logs, audit trails)
   - Timeline: when did it start, when was it discovered?

3. **NOTIFY required parties**
   - Legal/compliance team (GDPR requires notification within 72 hours)
   - Affected users (see communication template below)
   - Relevant authorities if legally required

4. **REMEDIATE**
   - Patch the vulnerability that was exploited
   - Implement additional monitoring on the attack vector
   - Force password resets for affected users
   - Enable MFA if not already required

5. **DOCUMENT everything**
   - Full incident timeline
   - Evidence preserved (logs, screenshots)
   - Actions taken with timestamps

**Recovery Time Target**: Containment within 1 hour. Full remediation within 24-48 hours.

**Prevention**:
- [ ] Security audit completed (see `security_audit` skill)
- [ ] All secrets in environment variables, not code
- [ ] Audit logging enabled for all sensitive operations
- [ ] Principle of least privilege enforced

---

### Scenario 7: Email Service Down

**Severity**: SEV2 (unless critical emails like password resets are affected, then SEV1)
**Symptoms**: Emails not arriving, Resend/SendGrid dashboard shows failures, users report "never received the email"

**Steps**:

1. **Check provider status page** (Resend, SendGrid, SES)
2. **Check your sending domain**
   - DNS records correct? (SPF, DKIM, DMARC)
   - Domain not blocklisted? (Check https://mxtoolbox.com/blacklists.aspx)
3. **Check API key and rate limits**
   - API key valid and not expired?
   - Daily sending quota exceeded?
4. **If provider outage**: Wait. Queue emails for retry.
5. **If your configuration**:
   - Verify environment variables (`RESEND_API_KEY`)
   - Test with a simple send via CLI or dashboard
   - Check application logs for send errors

**Recovery Time Target**: 1-2 hours

**Prevention**:
- [ ] Email sends are queued with retry logic (not fire-and-forget)
- [ ] SPF, DKIM, DMARC records configured
- [ ] Separate sending domain (not your main domain)
- [ ] Delivery rate monitoring

---

### Scenario 8: Performance Degradation

**Severity**: SEV2 (slow) / SEV1 (unusably slow)
**Symptoms**: Page load > 5 seconds, API responses > 2 seconds, timeouts, users report "it's slow"

**Steps**:

1. **Identify the bottleneck**

   | Symptom | Check | Tool |
   |---------|-------|------|
   | Frontend slow | Bundle size, render blocking | Chrome DevTools, Lighthouse |
   | API slow | Database queries, external calls | Application logs, query timing |
   | Database slow | Missing indexes, table scans | `EXPLAIN ANALYZE` on slow queries |
   | Everything slow | Infrastructure (CPU/Memory/Disk) | Hosting dashboard metrics |

2. **If database slow queries**
   - Run `EXPLAIN ANALYZE` on the slow query
   - Add missing indexes
   - Check for N+1 queries (Prisma: use `include` instead of separate queries)
   - Check for full table scans on large tables

3. **If DDoS or traffic spike**
   - Enable rate limiting if not already active
   - Enable Cloudflare "Under Attack" mode
   - Scale up infrastructure temporarily
   - Identify and block abusive IPs

4. **If memory leak**
   - Check memory usage over time (gradual increase = leak)
   - Restart the service (temporary fix)
   - Profile with `--inspect` flag and Chrome DevTools
   - Check for unclosed connections, growing arrays, event listener accumulation

**Recovery Time Target**: 30 minutes (mitigation), 1 week (root cause fix)

**Prevention**:
- [ ] Performance monitoring enabled (response time alerts)
- [ ] Database query logging for slow queries (> 500ms)
- [ ] Load testing done before launch
- [ ] Auto-scaling configured

---

## 📢 COMMUNICATION TEMPLATES

### Status Page Update

```text
[INVESTIGATING] We are aware of issues with [service name] and are
actively investigating. Users may experience [specific symptom].
We will provide updates every 30 minutes.

[IDENTIFIED] The issue has been identified as [brief cause].
We are working on a fix. ETA: [time estimate].

[RESOLVED] The issue with [service name] has been resolved.
[Brief explanation]. We apologize for any inconvenience.
All systems are operating normally.
```

### User Email Notification (Outage)

```text
Subject: [Service Name] - Service Disruption Update

Hi [Name],

We experienced a service disruption on [date] between [start time]
and [end time] UTC that affected [what was affected].

What happened: [1-2 sentence non-technical explanation]

Impact: [What users experienced]

What we've done: [Actions taken to fix and prevent recurrence]

If you have questions, reply to this email or contact
support@yourapp.com.

We apologize for the disruption.

[Your team name]
```

---

## 🔍 POST-INCIDENT REVIEW TEMPLATE

Conduct within 48 hours of every SEV1 and SEV2 incident.

```markdown
# Post-Incident Review: [Incident Title]

**Date of Incident**: [YYYY-MM-DD]
**Duration**: [Start time] - [End time] ([X hours Y minutes])
**Severity**: [SEV1/SEV2]
**Incident Commander**: [Name]

## Timeline

| Time (UTC) | Event |
|------------|-------|
| HH:MM | [First symptom observed / alert fired] |
| HH:MM | [Investigation started] |
| HH:MM | [Root cause identified] |
| HH:MM | [Fix deployed] |
| HH:MM | [Service confirmed restored] |

## Root Cause

[Clear, non-blaming description of what went wrong and why]

## Impact

| Metric | Value |
|--------|-------|
| Users affected | [Number or percentage] |
| Revenue impact | [Estimated $ or "None"] |
| Data loss | [Yes/No - details if yes] |
| SLA breach | [Yes/No] |

## What Went Well

- [Thing that worked during the response]
- [Thing that worked during the response]

## What Could Be Improved

- [Thing that slowed down the response]
- [Thing that slowed down the response]

## Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| [Preventive measure] | [Name] | [Date] | [ ] |
| [Monitoring improvement] | [Name] | [Date] | [ ] |
| [Documentation update] | [Name] | [Date] | [ ] |
```

> [!WARNING]
> **Blameless culture**: Post-incident reviews are about systems, not people. Focus on "what" and "how", never "who".

---

## 📞 EMERGENCY CONTACTS

Fill this in for your project and keep it accessible (pinned in Slack, bookmarked, printed).

| Service | Support Email | Support Link | SLA |
|---------|---------------|--------------|-----|
| Hosting (Vercel/Railway/Render) | | | |
| Database (Supabase/AWS RDS) | | | |
| Auth Provider | | | |
| Payment (Stripe) | support@stripe.com | https://support.stripe.com | |
| Email (Resend/SendGrid) | | | |
| DNS (Cloudflare) | | https://dash.cloudflare.com | |
| Domain Registrar | | | |
| AI Provider (OpenAI/Anthropic) | | | |

---

## 🗓️ REGULAR MAINTENANCE SCHEDULE

| Cadence | Task | Owner |
|---------|------|-------|
| **Daily** | Check error monitoring dashboard (Sentry/LogRocket) | On-call |
| **Daily** | Review failed background jobs / queues | On-call |
| **Weekly** | Review application error rates and trends | Engineering lead |
| **Weekly** | Run `npm audit` and address critical vulnerabilities | Engineering lead |
| **Monthly** | Test backup restore process (actually restore a backup) | DevOps / Engineering lead |
| **Monthly** | Review and update runbooks if stack changed | Engineering lead |
| **Quarterly** | Rotate all secrets (API keys, DB passwords) | Engineering lead |
| **Quarterly** | Review third-party service dependencies | Engineering lead |
| **Annually** | Full disaster recovery drill (simulate SEV1) | Entire team |

> [!TIP]
> **Test your backups.** A backup you have never restored is not a backup -- it is a hope. Restore to a staging environment monthly.

---

## 👥 ON-CALL ROTATION (Teams > 1 Person)

| Week | Primary On-Call | Secondary On-Call |
|------|----------------|-------------------|
| Week 1 | Person A | Person B |
| Week 2 | Person B | Person A |

**On-call responsibilities**:
- Respond to SEV1/SEV2 alerts within 15 minutes
- Triage and escalate as needed
- Update status page for user-facing outages
- Write post-incident review for all SEV1/SEV2

**Solo founder/developer?** You are always on-call. Make sure your phone receives alerts and your runbooks are thorough enough that a contractor could follow them in an emergency.

---

## ✅ EXIT CHECKLIST

- [ ] Service architecture diagram documented with all dependencies
- [ ] All 8 scenario runbooks written and reviewed
- [ ] Status pages for all third-party services bookmarked
- [ ] Emergency contacts table filled in
- [ ] Incident severity levels defined and communicated to team
- [ ] Communication templates ready (status page, user email)
- [ ] Post-incident review template ready
- [ ] Regular maintenance schedule established
- [ ] Backup restore tested at least once
- [ ] On-call rotation set up (if team > 1)

---

*Skill Version: 1.0 | Created: February 2026*
