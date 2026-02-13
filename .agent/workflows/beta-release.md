---
description: Beta release readiness workflow — ensures automated tests, legal pages, API docs, rate limiting, bug reporter, analytics, error boundaries, accessibility, seed data, email templates, and security verification are all in place before inviting external beta users.
---

# /beta Workflow

> Use when preparing for closed beta (10-50 external users). Run this AFTER alpha testing is complete and major bugs are fixed.

## When to Use

- [ ] Alpha testing complete — no P0 or P1 bugs remaining
- [ ] Sentry, health checks, env validation already in place (from /alpha)
- [ ] Core features stable and working end-to-end
- [ ] You're ready for external users to test

---

## Step 1: Automated Testing

Write tests for critical paths.

```bash
view_file .agent/skills/4-secure/unit_testing/SKILL.md
view_file .agent/skills/4-secure/integration_testing/SKILL.md
view_file .agent/skills/4-secure/e2e_testing/SKILL.md
```

### 1a. Backend Unit Tests

- [ ] Auth service tests (login, register, token validation)
- [ ] Billing service tests (plan check, usage tracking)
- [ ] AI provider tests (mock external APIs)
- [ ] Coverage: 80%+ on auth, billing, AI services

### 1b. API Integration Tests

- [ ] Auth endpoints (register → login → protected route)
- [ ] CRUD endpoints (create → read → update → delete)
- [ ] Org-scoping verification (user A can't see org B data)
- [ ] Error responses (401, 403, 404, 422)

### 1c. Frontend Component Tests

- [ ] Auth forms (login, register)
- [ ] Dashboard rendering
- [ ] Key interactive components

### 1d. E2E Tests (Playwright)

- [ ] Signup → onboarding → dashboard flow
- [ ] Login → create contact → verify → logout flow
- [ ] Billing: upgrade → verify plan change flow
- [ ] At least 5 critical user journeys covered

---

## Step 2: Legal Pages

Create required legal documents.

```bash
view_file .agent/skills/5-ship/legal_compliance/SKILL.md
```

- [ ] Terms of Service page on website
- [ ] Privacy Policy page on website
- [ ] Cookie Policy page on website
- [ ] Acceptable Use Policy page on website
- [ ] Cookie consent banner in frontend
- [ ] Links in app footer and signup form
- [ ] Legal review scheduled (flag for human review)

---

## Step 3: API Documentation

Generate interactive API docs.

```bash
view_file .agent/skills/6-handoff/api_reference/SKILL.md
```

- [ ] @nestjs/swagger configured
- [ ] Swagger UI available at /api/docs (auth-protected or staging-only)
- [ ] All endpoints documented with descriptions
- [ ] Request/response DTOs have @ApiProperty decorators
- [ ] Auth requirement shown for each endpoint

---

## Step 4: Rate Limiting

Protect against abuse.

```bash
view_file .agent/skills/5.75-beta/rate_limiting/SKILL.md
```

- [ ] Global rate limit: 60 requests/minute
- [ ] Auth endpoints: 5/minute
- [ ] AI endpoints: 20/minute
- [ ] Health + webhooks: exempt from rate limiting
- [ ] 429 response includes Retry-After header

---

## Step 5: Bug Reporter

Let beta users report issues easily.

```bash
view_file .agent/skills/5.75-beta/feedback_system/SKILL.md
```

- [ ] Bug reporter button visible on every page
- [ ] Report form: type, description, severity, optional screenshot
- [ ] Reports saved to database with user context
- [ ] Admin can view and triage reports

---

## Step 6: Product Analytics

Understand how users actually use the app.

```bash
view_file .agent/skills/5.75-beta/product_analytics/SKILL.md
```

- [ ] PostHog initialized in frontend and backend
- [ ] User identified on login (posthog.identify)
- [ ] Key events tracked: signup, login, feature usage, upgrade
- [ ] Basic dashboard created (activation funnel, feature adoption)

---

## Step 7: Error Boundaries & Toasts

Prevent white screens, show meaningful errors.

```bash
view_file .agent/skills/5.75-beta/error_boundaries/SKILL.md
```

- [ ] Error boundary wrapping each route
- [ ] Fallback UI with retry button (not white screen)
- [ ] Toast notification system (success, error, warning, info)
- [ ] API errors show toast (not silent failure)
- [ ] Offline detection banner

---

## Step 8: Accessibility Basics

Ensure keyboard navigability and screen reader support.

```bash
view_file .agent/skills/4-secure/accessibility_testing/SKILL.md
```

- [ ] All interactive elements keyboard-accessible (Tab/Enter/Escape)
- [ ] Visible focus indicators on all focusable elements
- [ ] Form inputs have associated labels
- [ ] Images have alt text
- [ ] Color contrast meets 4.5:1 ratio
- [ ] axe-core reports 0 critical violations

---

## Step 9: Seed Data

Create demo data for new instances.

```bash
view_file .agent/skills/5-ship/seed_data/SKILL.md
```

- [ ] prisma/seed.ts creates admin user + demo org
- [ ] Sample data for key features (contacts, projects, pipelines)
- [ ] Seed is idempotent (safe to re-run)
- [ ] `npx prisma db seed` works without errors

---

## Step 10: Email Templates

Branded transactional emails.

```bash
view_file .agent/skills/5.75-beta/email_templates/SKILL.md
```

- [ ] Welcome email (after signup)
- [ ] Team invitation email
- [ ] Password reset email
- [ ] Payment receipt email
- [ ] All emails branded with logo and colors
- [ ] Plain text fallback for every email

---

## Step 11: Security Verification

Final security check before external users.

```bash
view_file .agent/skills/4-secure/security_audit/SKILL.md
```

- [ ] OWASP Top 10 checklist passed
- [ ] All controllers have @UseGuards(JwtAuthGuard)
- [ ] No hardcoded secrets in source code
- [ ] CORS limited to frontend origin only
- [ ] Helmet middleware enabled
- [ ] npm audit: zero critical/high vulnerabilities

---

## Exit Checklist — Beta Ready

- [ ] All automated tests pass (unit, integration, E2E)
- [ ] Legal pages live on website
- [ ] API docs available at /api/docs
- [ ] Rate limiting active on all endpoints
- [ ] Bug reporter visible and working
- [ ] Analytics tracking key events
- [ ] Error boundaries prevent white screens
- [ ] Basic accessibility verified
- [ ] Seed data script works
- [ ] Email templates created and tested
- [ ] Security checklist passed
- [ ] All items verified on staging before promoting to production
- [ ] Ready to invite 10-50 external beta users

*Workflow Version: 1.0 | Created: February 2026*
