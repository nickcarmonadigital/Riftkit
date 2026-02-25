# Security Audit Report Template

**Date**: [YYYY-MM-DD]
**Scope**: [Feature / Module / Full Application]
**Auditor**: [Agent / Human Name]
**Application**: [Project Name]
**Environment**: [Development / Staging / Production]

---

## Executive Summary

| Metric | Value |
|--------|-------|
| **Total Checks** | __ |
| **Passed** | __ |
| **Failed** | __ |
| **Critical Findings** | __ |
| **High Findings** | __ |
| **Risk Score** | __/100 |

**Overall Assessment**: [ PASS / CONDITIONAL PASS / FAIL ]

---

## OWASP Top 10 (2021) Checklist

### A01: Broken Access Control

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | All endpoints require authentication (except explicitly public) | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Users cannot access other users' data (horizontal privilege escalation) | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Regular users cannot access admin endpoints (vertical privilege escalation) | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | CORS is configured with explicit allowed origins (not `*`) | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | Direct object references (IDs in URLs) are access-checked | ☐ Pass ☐ Fail ☐ N/A | |
| 6 | API rate limiting is enabled | ☐ Pass ☐ Fail ☐ N/A | |
| 7 | JWT tokens are validated on every request | ☐ Pass ☐ Fail ☐ N/A | |
| 8 | Role-based access control (RBAC) is enforced server-side | ☐ Pass ☐ Fail ☐ N/A | |

### A02: Cryptographic Failures

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Passwords hashed with bcrypt (rounds >= 12) or argon2 | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | No sensitive data in JWT payload (no passwords, SSN, etc.) | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | HTTPS enforced in production (no HTTP fallback) | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | Encryption at rest for sensitive database fields | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | TLS 1.2+ required for all connections | ☐ Pass ☐ Fail ☐ N/A | |

### A03: Injection

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | SQL injection prevented (parameterized queries / ORM) | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | No raw SQL with string concatenation | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Command injection prevented (no exec/spawn with user input) | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | NoSQL injection prevented (Prisma handles this) | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | LDAP injection prevented (if using LDAP) | ☐ Pass ☐ Fail ☐ N/A | |

### A04: Insecure Design

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Threat model documented for critical flows | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Business logic abuse cases identified and mitigated | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Rate limiting on expensive operations (AI calls, emails) | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | Input validation on all user-supplied data | ☐ Pass ☐ Fail ☐ N/A | |

### A05: Security Misconfiguration

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Debug mode disabled in production | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Default credentials changed | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Unnecessary features/endpoints disabled | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | Security headers set (HSTS, X-Content-Type-Options, X-Frame-Options) | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | Error messages don't leak stack traces or internal details | ☐ Pass ☐ Fail ☐ N/A | |
| 6 | Server version headers removed | ☐ Pass ☐ Fail ☐ N/A | |

### A06: Vulnerable and Outdated Components

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | `npm audit` shows zero critical/high vulnerabilities | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | No deprecated packages without migration plan | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Automated dependency scanning (Dependabot/Renovate) configured | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | License compliance verified (no GPL/AGPL in proprietary code) | ☐ Pass ☐ Fail ☐ N/A | |

### A07: Identification and Authentication Failures

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Brute force protection on login (rate limiting / lockout) | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Password reset tokens are single-use and expire | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Session tokens invalidated on logout | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | JWT expiration enforced (not infinite tokens) | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | Generic error messages for login failures ("Invalid credentials" not "User not found") | ☐ Pass ☐ Fail ☐ N/A | |

### A08: Software and Data Integrity Failures

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | CI/CD pipeline has integrity checks | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Package lock file committed and verified | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | No unsigned or unverified plugins/extensions | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | Webhook signatures verified (Stripe, GitHub, etc.) | ☐ Pass ☐ Fail ☐ N/A | |

### A09: Security Logging and Monitoring Failures

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Authentication events logged (login, logout, failed attempts) | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Authorization failures logged | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | Input validation failures logged | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | Logs don't contain sensitive data (passwords, tokens, PII) | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | Error tracking configured (Sentry or equivalent) | ☐ Pass ☐ Fail ☐ N/A | |
| 6 | Alerting on suspicious patterns (brute force, rate limit hits) | ☐ Pass ☐ Fail ☐ N/A | |

### A10: Server-Side Request Forgery (SSRF)

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | User-supplied URLs validated and sanitized | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | Internal network addresses blocked in outgoing requests | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | URL schemes restricted (only http/https) | ☐ Pass ☐ Fail ☐ N/A | |

---

## AI-Specific Security Checks

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | AI API keys stored in env vars, never in code | ☐ Pass ☐ Fail ☐ N/A | |
| 2 | User input sanitized before sending to LLM (prompt injection prevention) | ☐ Pass ☐ Fail ☐ N/A | |
| 3 | AI-generated output sanitized before rendering (XSS from AI responses) | ☐ Pass ☐ Fail ☐ N/A | |
| 4 | AI token usage rate-limited per user/tenant | ☐ Pass ☐ Fail ☐ N/A | |
| 5 | AI model responses don't leak system prompts | ☐ Pass ☐ Fail ☐ N/A | |
| 6 | Package names from AI verified before installation (hallucination risk) | ☐ Pass ☐ Fail ☐ N/A | |
| 7 | MCP tool calls validated and sandboxed | ☐ Pass ☐ Fail ☐ N/A | |

---

## Severity Scoring

| Severity | CVSS Range | Response Time | Description |
|----------|-----------|---------------|-------------|
| **Critical** | 9.0 - 10.0 | Fix immediately (same day) | Active exploitation possible, data breach risk |
| **High** | 7.0 - 8.9 | Fix within 48 hours | Significant vulnerability, exploitation likely |
| **Medium** | 4.0 - 6.9 | Fix within 1 sprint | Exploitable under specific conditions |
| **Low** | 0.1 - 3.9 | Fix when convenient | Minor risk, defense-in-depth improvement |

### Risk Matrix

```
              │ Low Impact │ Medium Impact │ High Impact │
──────────────┼────────────┼───────────────┼─────────────┤
High Likelihood│  Medium    │    High       │  Critical   │
──────────────┼────────────┼───────────────┼─────────────┤
Med Likelihood │  Low       │    Medium     │  High       │
──────────────┼────────────┼───────────────┼─────────────┤
Low Likelihood │  Low       │    Low        │  Medium     │
```

---

## Findings Detail

### Finding #1

| Field | Value |
|-------|-------|
| **ID** | SEC-[YYYY]-[NNN] |
| **Severity** | Critical / High / Medium / Low |
| **OWASP Category** | A01-A10 |
| **Location** | `file_path:line_number` |
| **Description** | [What is the vulnerability?] |
| **Impact** | [What could an attacker do?] |
| **Reproduction** | [Steps to reproduce] |
| **Remediation** | [How to fix — specific code changes] |
| **Verification** | [How to verify the fix works] |
| **Status** | Open / In Progress / Fixed / Accepted Risk |
| **Owner** | [Assignee] |
| **Target Date** | [Fix-by date based on severity] |

*(Copy this template for each finding)*

---

## Recommendations

| Priority | Recommendation | Effort | Impact |
|----------|---------------|--------|--------|
| 1 | [Recommendation] | Low/Med/High | Low/Med/High |
| 2 | [Recommendation] | Low/Med/High | Low/Med/High |
| 3 | [Recommendation] | Low/Med/High | Low/Med/High |

---

## Re-Audit Schedule

| Audit Type | Cadence | Next Date |
|------------|---------|-----------|
| Full security audit | Quarterly | [Date] |
| Dependency audit | Weekly (automated) | [Date] |
| Penetration test | Annually | [Date] |
| Code review (security focus) | Every PR | Ongoing |

---

## Sign-Off

| Role | Name | Date | Approved |
|------|------|------|----------|
| Developer | | | ☐ |
| Tech Lead | | | ☐ |
| Security Lead | | | ☐ |
