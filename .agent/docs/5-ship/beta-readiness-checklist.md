# Beta Readiness Checklist

**Date**: _______________
**Project**: _______________
**Reviewer**: _______________

**Prerequisite**: Alpha checklist must be fully passed before starting beta readiness.

---

## 1. Automated Tests

| Check | Status | Notes |
|-------|--------|-------|
| Backend unit tests: auth service | ☐ | |
| Backend unit tests: billing service | ☐ | |
| Backend unit tests: AI provider service | ☐ | |
| Backend coverage >= 80% on critical services | ☐ | |
| API integration tests: auth flow | ☐ | |
| API integration tests: CRUD operations | ☐ | |
| API integration tests: org-scoping | ☐ | |
| API integration tests: error responses | ☐ | |
| Frontend component tests: auth forms | ☐ | |
| Frontend component tests: dashboard | ☐ | |
| E2E: signup through dashboard flow | ☐ | |
| E2E: full CRUD user journey | ☐ | |
| E2E: billing upgrade flow | ☐ | |
| E2E: at least 5 critical journeys | ☐ | |

## 2. Legal Pages

| Check | Status | Notes |
|-------|--------|-------|
| Terms of Service page live | ☐ | |
| Privacy Policy page live | ☐ | |
| Cookie Policy page live | ☐ | |
| Acceptable Use Policy page live | ☐ | |
| Cookie consent banner working | ☐ | |
| Links in app footer and signup form | ☐ | |
| Legal review scheduled or completed | ☐ | |

## 3. API Documentation

| Check | Status | Notes |
|-------|--------|-------|
| @nestjs/swagger installed and configured | ☐ | |
| Swagger UI available at /api/docs | ☐ | |
| All endpoints have descriptions | ☐ | |
| DTOs decorated with @ApiProperty | ☐ | |
| Auth requirements shown per endpoint | ☐ | |

## 4. Rate Limiting

| Check | Status | Notes |
|-------|--------|-------|
| Global rate limit: 60 req/min | ☐ | |
| Auth endpoints: 5 req/min | ☐ | |
| AI endpoints: 20 req/min | ☐ | |
| Health and webhooks exempt | ☐ | |
| 429 response includes Retry-After header | ☐ | |

## 5. Bug Reporter

| Check | Status | Notes |
|-------|--------|-------|
| Bug report button on every page | ☐ | |
| Report form captures type, description, severity | ☐ | |
| Reports saved with user context | ☐ | |
| Admin can view and triage reports | ☐ | |

## 6. Product Analytics

| Check | Status | Notes |
|-------|--------|-------|
| PostHog initialized (frontend + backend) | ☐ | |
| User identified on login | ☐ | |
| Key events tracked (signup, login, features, upgrade) | ☐ | |
| Basic dashboard created | ☐ | |

## 7. Error Boundaries

| Check | Status | Notes |
|-------|--------|-------|
| Error boundary wrapping each route | ☐ | |
| Fallback UI with retry button | ☐ | |
| Toast notification system working | ☐ | |
| API errors show user-friendly toast | ☐ | |
| Offline detection banner | ☐ | |

## 8. Accessibility

| Check | Status | Notes |
|-------|--------|-------|
| All elements keyboard-accessible | ☐ | |
| Visible focus indicators | ☐ | |
| Form inputs have labels | ☐ | |
| Images have alt text | ☐ | |
| Color contrast >= 4.5:1 | ☐ | |
| axe-core: 0 critical violations | ☐ | |

## 9. Seed Data

| Check | Status | Notes |
|-------|--------|-------|
| prisma/seed.ts creates admin + demo org | ☐ | |
| Sample data for key features | ☐ | |
| Seed is idempotent (safe to re-run) | ☐ | |
| `npx prisma db seed` succeeds | ☐ | |

## 10. Email Templates

| Check | Status | Notes |
|-------|--------|-------|
| Welcome email | ☐ | |
| Team invitation email | ☐ | |
| Password reset email | ☐ | |
| Payment receipt email | ☐ | |
| All emails branded | ☐ | |
| Plain text fallback for each | ☐ | |

## 11. Security Verification

| Check | Status | Notes |
|-------|--------|-------|
| OWASP Top 10 checklist passed | ☐ | |
| All controllers have @UseGuards(JwtAuthGuard) | ☐ | |
| No hardcoded secrets in source | ☐ | |
| CORS limited to frontend origin | ☐ | |
| Helmet middleware enabled | ☐ | |
| npm audit: 0 critical/high vulnerabilities | ☐ | |

---

## Sign-Off

| Role | Name | Date | Approved |
|------|------|------|----------|
| Developer | | | ☐ |
| Tech Lead | | | ☐ |
| QA Lead | | | ☐ |
| Product Owner | | | ☐ |

**Beta Release Approved**: ☐ Yes  ☐ No

**Blocking Issues** (if No):
1. _______________
2. _______________
3. _______________
