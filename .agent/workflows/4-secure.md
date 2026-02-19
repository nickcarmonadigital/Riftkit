---
description: Run security and quality audit on a feature or project
---

# /audit Workflow

> Use for security review, quality checks, or pre-launch verification

## When to Use

- Before deploying to production
- After implementing authentication/authorization
- Before public launch
- Periodic security review

---

## Step 1: Read Audit Skills

// turbo

```bash
view_file .agent/skills/security_audit/SKILL.md
view_file .agent/skills/code_review/SKILL.md
```

---

## Step 2: Determine Audit Scope

What type of audit?

- [ ] Full project audit
- [ ] Single feature audit
- [ ] Security-only audit
- [ ] Pre-launch checklist

---

## Step 3: OWASP Top 10 Checklist

*(See `security_audit` skill for full details)*

### A01: Broken Access Control

- [ ] Users can ONLY access their own data (`WHERE user_id = ?`)
- [ ] Admin routes strictly protected by middleware
- [ ] IDOR checks on all resource IDs

### A02: Cryptographic Failures

- [ ] No cleartext passwords (bcrypt/Argon2 only)
- [ ] HTTPS enforced everywhere
- [ ] Secrets managed via ENV (not hardcoded)

### A03: Injection

- [ ] Parameterized queries used (No raw SQL)
- [ ] Input validation on ALL fields
- [ ] No `eval()` or dangerous sinks

### A04: Insecure Design

- [ ] Rate limiting enabled
- [ ] Business logic validated (e.g., negative prices)

### A05: Security Misconfiguration

- [ ] Error messages don't leak stack traces
- [ ] Production config is hardened (cookies secure/httpOnly)

### A06: Vulnerable Dependencies

- [ ] `npm audit` is clean
- [ ] Unused packages removed

### A07: Identification Failures

- [ ] MFA supported/considered
- [ ] Session timeout logic active

### A07-A10 (Advanced)

- [ ] Integrity: CI/CD pipeline secure
- [ ] Logging: Auth failures logged
- [ ] SSRF: No fetching arbitrary user-provided URLs

---

## Step 4: Dependency Audit

// turbo

```bash
npm audit
```

Review and address vulnerabilities.

---

## Step 5: Code Quality Check

- [ ] No console.log in production code
- [ ] Error handling in place
- [ ] TypeScript strict mode passing
- [ ] No lint errors

---

## Step 6: Second Opinion (Optional)

Use code_review skill to get external review:

1. Export relevant code
2. Ask Claude to review for security issues
3. Document findings

---

## Step 7: Document Findings

Create audit report at `.agent/docs/4-secure/security-audit-[date].md`:

```markdown
# Security Audit Report

**Date**: [Date]
**Scope**: [What was audited]

## Summary
| Category | Passed | Failed | N/A |
|----------|--------|--------|-----|
| Injection | X | X | X |
| Auth | X | X | X |
| XSS | X | X | X |

## Findings
1. [Finding] - [Severity]

## Remediation
- [ ] Fix 1
- [ ] Fix 2
```

---

## Exit Checklist

- [ ] All checklist items reviewed
- [ ] Dependencies audited
- [ ] Findings documented
- [ ] Critical issues resolved
- [ ] Report saved
