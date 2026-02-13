---
description: Alpha release readiness workflow — ensures error tracking, health checks, env validation, QA playbook, and backup strategy are all in place before inviting first internal testers.
---

# /alpha Workflow

> Use when preparing for alpha release (first internal testers). Run this AFTER features are built and deployed to staging, BEFORE inviting anyone to test.

## When to Use

- [ ] All core features are implemented and deployed to staging
- [ ] Backend builds with zero errors
- [ ] Frontend builds with zero errors
- [ ] Database migrations are applied
- [ ] You're ready for internal testing (team, stakeholders)

---

## Step 1: Error Tracking Setup

Set up Sentry for all platforms.

```bash
view_file .agent/skills/5.5-alpha/error_tracking/SKILL.md
```

- [ ] Backend: @sentry/nestjs installed, DSN configured, global exception filter active
- [ ] Frontend: @sentry/react installed, Sentry.init() in main.tsx, ErrorBoundary wrapping App
- [ ] Website: @sentry/nextjs installed, sentry configs created
- [ ] Source maps uploading to Sentry on deploy
- [ ] Test: throw a test error → verify it appears in Sentry dashboard

---

## Step 2: Health Check Endpoints

Create liveness and readiness endpoints.

```bash
view_file .agent/skills/5.5-alpha/health_checks/SKILL.md
```

- [ ] GET /health returns { status: "ok" }
- [ ] GET /health/ready checks database connectivity
- [ ] GET /health/detailed (auth-protected) shows memory, uptime, DB status
- [ ] External monitoring service configured to ping /health every 60s

---

## Step 3: Environment Validation

Ensure app fails fast with clear errors if env vars are missing.

```bash
view_file .agent/skills/5.5-alpha/env_validation/SKILL.md
```

- [ ] EnvironmentVariables class created with class-validator decorators
- [ ] App refuses to start if required vars are missing
- [ ] Error output lists ALL missing vars (not just the first one)
- [ ] .env.example is complete and matches actual requirements

---

## Step 4: Structured Logging

Set up production-grade logging.

```bash
view_file .agent/skills/3-build/observability/SKILL.md
```

- [ ] Pino logger configured (JSON in production, pretty in development)
- [ ] Request ID attached to every log line
- [ ] Sensitive data redacted from logs (passwords, tokens, credit cards)
- [ ] Log levels appropriate: error for failures, warn for degraded, info for events, debug for development

---

## Step 5: QA Test Playbook

Create manual test procedures.

```bash
view_file .agent/skills/5.5-alpha/qa_playbook/SKILL.md
```

- [ ] Auth flow test cases written
- [ ] CRUD operations test cases for each feature
- [ ] Error handling test cases (invalid input, unauthorized, 500s)
- [ ] Performance spot-check (dashboard < 3s, no console errors)
- [ ] Security spot-check (no auth bypass, no cross-org access)
- [ ] Regression checklist (5-minute smoke test)

---

## Step 6: Backup Verification

Ensure database backups are running and tested.

```bash
view_file .agent/skills/5.5-alpha/backup_strategy/SKILL.md
```

- [ ] Automatic backups configured (Supabase daily or pg_dump cron)
- [ ] Backup restore tested: downloaded backup → restored to temp DB → verified data
- [ ] Pre-migration backup procedure documented
- [ ] Backup failure alerts configured

---

## Exit Checklist — Alpha Ready

- [ ] Sentry captures errors from all platforms
- [ ] /health and /health/ready endpoints respond correctly
- [ ] App fails fast with clear error if env vars missing
- [ ] Structured JSON logging in production
- [ ] QA playbook exists with all critical test cases
- [ ] Backups running and restore tested
- [ ] All items above verified on staging environment
- [ ] Ready to invite internal testers

*Workflow Version: 1.0 | Created: February 2026*
