---
description: Prepare for deployment with security and quality checks
---

# /ship Workflow

> Use when preparing to deploy a feature or release

## Pre-Flight Checks

- [ ] All features complete?
- [ ] All tests passing?
- [ ] Environment variables documented?

---

## Step 1: Read Ship Skills

// turbo

```bash
view_file .agent/skills/security_audit/SKILL.md
view_file .agent/skills/website_launch/SKILL.md
```

---

## Step 2: Security Audit

Run security_audit skill checklist:

### Critical Checks

- [ ] No secrets in code
- [ ] No secrets in git history
- [ ] Authentication on all protected routes
- [ ] Authorization checks (IDOR prevention)
- [ ] Input validation on all user inputs
- [ ] XSS prevention (content escaped)
- [ ] HTTPS enforced

### API Security

- [ ] Rate limiting configured
- [ ] Error messages don't leak info
- [ ] CORS configured correctly

---

## Step 3: Dependency Audit

// turbo

```bash
npm audit
```

- [ ] No critical vulnerabilities
- [ ] No high vulnerabilities (or documented exceptions)

---

## Step 4: Environment Preparation

- [ ] Production environment variables set
- [ ] Database migrations ready
- [ ] Backup strategy in place (if applicable)

---

## Step 5: Build Verification

// turbo

```bash
npm run build
```

- [ ] Build completes without errors
- [ ] No TypeScript errors
- [ ] No lint errors

---

## Step 6: Pre-Deploy Testing

- [ ] Test critical user flows
- [ ] Test on mobile viewport
- [ ] Check performance (no obvious slowness)

---

## Step 7: Deploy

Deploy to staging first if available:

1. Deploy to staging
2. Verify staging works
3. Deploy to production
4. Verify production

---

## Step 8: Post-Deploy Verification

- [ ] Site accessible
- [ ] Core functionality works
- [ ] No console errors
- [ ] Analytics/monitoring active

---

## Exit Checklist

- [ ] Security audit passed
- [ ] Dependencies audited
- [ ] Build successful
- [ ] Deployed and verified
- [ ] Documentation updated
