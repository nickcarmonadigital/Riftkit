# Alpha Readiness Checklist

**Date**: _______________
**Project**: _______________
**Reviewer**: _______________

---

## 1. Error Tracking

| Check | Status | Notes |
|-------|--------|-------|
| Backend Sentry installed and configured | ☐ | |
| Frontend Sentry installed and configured | ☐ | |
| Website Sentry installed and configured | ☐ | |
| Source maps uploading on deploy | ☐ | |
| Test error verified in Sentry dashboard | ☐ | |
| Alert rules configured (email/Slack on error) | ☐ | |

## 2. Health Checks

| Check | Status | Notes |
|-------|--------|-------|
| GET /health returns 200 with { status: "ok" } | ☐ | |
| GET /health/ready verifies DB connectivity | ☐ | |
| GET /health/detailed (auth-protected) shows system info | ☐ | |
| External monitoring pings /health every 60s | ☐ | |
| Downtime alerts configured (email/Slack/PagerDuty) | ☐ | |

## 3. Environment Validation

| Check | Status | Notes |
|-------|--------|-------|
| Validation class with class-validator decorators | ☐ | |
| App refuses to start if required vars missing | ☐ | |
| Error output lists ALL missing vars at once | ☐ | |
| .env.example is complete and up to date | ☐ | |

## 4. Structured Logging

| Check | Status | Notes |
|-------|--------|-------|
| Pino logger configured (JSON prod, pretty dev) | ☐ | |
| Request ID attached to every log line | ☐ | |
| Sensitive data redacted (passwords, tokens) | ☐ | |
| Appropriate log levels used throughout | ☐ | |

## 5. QA Test Playbook

| Check | Status | Notes |
|-------|--------|-------|
| Auth flow test cases documented | ☐ | |
| CRUD operations test cases per feature | ☐ | |
| Error handling test cases written | ☐ | |
| Performance spot-check (< 3s load) | ☐ | |
| Security spot-check (no auth bypass) | ☐ | |
| 5-minute regression smoke test defined | ☐ | |

## 6. Backup Strategy

| Check | Status | Notes |
|-------|--------|-------|
| Automatic backups configured and running | ☐ | |
| Backup restore tested on temp database | ☐ | |
| Pre-migration backup procedure documented | ☐ | |
| Backup failure alerts configured | ☐ | |

---

## Sign-Off

| Role | Name | Date | Approved |
|------|------|------|----------|
| Developer | | | ☐ |
| Tech Lead | | | ☐ |
| QA Lead | | | ☐ |

**Alpha Release Approved**: ☐ Yes  ☐ No

**Blocking Issues** (if No):
1. _______________
2. _______________
3. _______________
