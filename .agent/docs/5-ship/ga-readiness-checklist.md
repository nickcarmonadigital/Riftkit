# GA (General Availability) Readiness Checklist

**Date**: _______________
**Project**: _______________
**Reviewer**: _______________

**Prerequisite**: Both Alpha and Beta checklists must be fully passed before starting GA readiness.

---

## 1. CI/CD Pipeline

| Check | Status | Notes |
|-------|--------|-------|
| PR check workflow (lint, typecheck, test, build) | ☐ | |
| Deploy workflow triggered on push to main | ☐ | |
| Staging environment deploys automatically | ☐ | |
| Production deploy requires manual approval | ☐ | |
| Rollback procedure documented and tested | ☐ | |
| Database migration runs in CI before deploy | ☐ | |

## 2. Load Testing

| Check | Status | Notes |
|-------|--------|-------|
| Load test scripts written (k6 or Artillery) | ☐ | |
| API endpoints sustain 100 concurrent users | ☐ | |
| P95 response time < 500ms under load | ☐ | |
| Database connection pooling configured | ☐ | |
| No memory leaks under sustained load | ☐ | |
| Auto-scaling configured (if applicable) | ☐ | |

## 3. WCAG Compliance

| Check | Status | Notes |
|-------|--------|-------|
| WCAG 2.1 AA audit completed | ☐ | |
| Screen reader tested (NVDA or VoiceOver) | ☐ | |
| All ARIA roles and landmarks correct | ☐ | |
| Skip-to-content link present | ☐ | |
| Form error messages announced to screen readers | ☐ | |
| No keyboard traps | ☐ | |

## 4. User Documentation

| Check | Status | Notes |
|-------|--------|-------|
| Getting started guide written | ☐ | |
| Feature documentation for each module | ☐ | |
| FAQ page published | ☐ | |
| Help center or knowledge base live | ☐ | |
| In-app tooltips for complex features | ☐ | |
| Video walkthroughs recorded (optional) | ☐ | |

## 5. Disaster Recovery Runbook

| Check | Status | Notes |
|-------|--------|-------|
| Runbook document created (see DR template) | ☐ | |
| Database failover procedure tested | ☐ | |
| Service recovery procedure tested | ☐ | |
| RTO and RPO defined and achievable | ☐ | |
| Emergency contacts list up to date | ☐ | |
| Post-incident review template ready | ☐ | |

## 6. Mobile Responsiveness

| Check | Status | Notes |
|-------|--------|-------|
| All pages tested at 375px width (mobile) | ☐ | |
| All pages tested at 768px width (tablet) | ☐ | |
| Touch targets >= 44x44px | ☐ | |
| No horizontal scrolling on mobile | ☐ | |
| Navigation works on mobile (hamburger/drawer) | ☐ | |
| Forms usable on mobile keyboard | ☐ | |

## 7. SEO (Marketing Website)

| Check | Status | Notes |
|-------|--------|-------|
| Meta titles and descriptions on all pages | ☐ | |
| Open Graph tags for social sharing | ☐ | |
| sitemap.xml generated and submitted | ☐ | |
| robots.txt configured correctly | ☐ | |
| Canonical URLs set | ☐ | |
| Structured data (JSON-LD) for key pages | ☐ | |
| Core Web Vitals passing (LCP, FID, CLS) | ☐ | |

## 8. Performance Budget

| Check | Status | Notes |
|-------|--------|-------|
| Initial JS bundle < 200KB gzipped | ☐ | |
| Largest Contentful Paint < 2.5s | ☐ | |
| First Input Delay < 100ms | ☐ | |
| Cumulative Layout Shift < 0.1 | ☐ | |
| Code splitting for route-based chunks | ☐ | |
| Images optimized (WebP, lazy loading) | ☐ | |
| CDN configured for static assets | ☐ | |

## 9. Dependency Audit

| Check | Status | Notes |
|-------|--------|-------|
| npm audit: 0 critical vulnerabilities | ☐ | |
| npm audit: 0 high vulnerabilities | ☐ | |
| No deprecated packages in use | ☐ | |
| License compatibility verified (no GPL in proprietary) | ☐ | |
| Dependabot or Renovate configured | ☐ | |
| Lock files committed and up to date | ☐ | |

## 10. Penetration Testing

| Check | Status | Notes |
|-------|--------|-------|
| Automated scan completed (OWASP ZAP or similar) | ☐ | |
| Authentication bypass attempts tested | ☐ | |
| SQL injection tested | ☐ | |
| XSS injection tested | ☐ | |
| IDOR / broken access control tested | ☐ | |
| CSRF protection verified | ☐ | |
| Findings documented and remediated | ☐ | |

---

## Sign-Off

| Role | Name | Date | Approved |
|------|------|------|----------|
| Developer | | | ☐ |
| Tech Lead | | | ☐ |
| QA Lead | | | ☐ |
| Product Owner | | | ☐ |
| Security Lead | | | ☐ |

**GA Release Approved**: ☐ Yes  ☐ No

**Blocking Issues** (if No):
1. _______________
2. _______________
3. _______________

**Target GA Date**: _______________
