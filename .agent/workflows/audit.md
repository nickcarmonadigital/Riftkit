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
view_file .agent/skills/claude_verification/SKILL.md
```

---

## Step 2: Determine Audit Scope

What type of audit?

- [ ] Full project audit
- [ ] Single feature audit
- [ ] Security-only audit
- [ ] Pre-launch checklist

---

## Step 3: Security Checklist (from security_audit skill)

### Injection Prevention

- [ ] Parameterized queries (no SQL injection)
- [ ] No eval() or exec() with user input
- [ ] File paths validated

### Authentication

- [ ] All protected routes require auth
- [ ] JWT tokens expire appropriately
- [ ] Password hashing is strong (bcrypt/Argon2)

### Authorization

- [ ] Users can only access their own data
- [ ] Role checks before sensitive operations
- [ ] No reliance on client-provided user ID

### Data Exposure

- [ ] API responses don't leak sensitive data
- [ ] Error messages are generic
- [ ] No secrets in code or logs

### XSS Prevention

- [ ] User content is escaped
- [ ] No dangerouslySetInnerHTML with user data
- [ ] CSP headers configured

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

Use claude_verification skill to get external review:

1. Export relevant code
2. Ask Claude to review for security issues
3. Document findings

---

## Step 7: Document Findings

Create audit report at `.agent/docs/security-audit-[date].md`:

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
