---
description: Critical hotfix workflow — fast-track process for production-critical bugs requiring immediate fix with minimal risk, from branch creation through backport.
---

# /hotfix-critical Workflow

> Use when a critical bug in production needs an immediate fix. This is a streamlined path — minimal scope, fast review, careful deployment. No feature work allowed.

## When to Use

- [ ] Production bug causing user-facing failures
- [ ] SEV1 or SEV2 incident requiring code change
- [ ] Security vulnerability requiring immediate patch
- [ ] Data integrity issue in production

---

## Step 1: Branch from Production Tag

Create an isolated hotfix branch from the exact production state.

```bash
view_file .agent/skills/3-build/git_workflow/SKILL.md
```

- [ ] Identify current production tag or release commit
- [ ] Create branch: `hotfix/<issue-id>-<short-description>` from production tag
- [ ] Verify branch matches production state exactly
- [ ] Document: what is broken, who is affected, what is the expected behavior

**Gate**: Branch MUST be from production tag, not from main/develop.

---

## Step 2: Minimal Fix Only

Apply the smallest possible change to fix the issue. No refactoring, no cleanup.

```bash
view_file .agent/skills/3-build/bug_troubleshoot/SKILL.md
```

- [ ] Root cause identified and confirmed
- [ ] Fix is minimal — touches as few files as possible
- [ ] No feature work included (zero tolerance)
- [ ] No refactoring, no style changes, no "while we're here" fixes
- [ ] Fix addresses the specific failure mode only

**Gate**: If the fix touches more than 5 files, pause and reassess scope.

---

## Step 3: Write Regression Test

Prove the fix works and prevent recurrence.

```bash
view_file .agent/skills/3-build/tdd_workflow/SKILL.md
```

- [ ] Test reproduces the original bug (fails without fix)
- [ ] Test passes with fix applied
- [ ] Test covers edge cases of the failure mode
- [ ] Existing tests still pass (no regressions)

---

## Step 4: Security Review (if auth-related)

Required only for authentication, authorization, or data access fixes.

```bash
view_file .agent/skills/4-secure/security_audit/SKILL.md
```

- [ ] Auth flow changes reviewed for bypass risks
- [ ] Permission checks verified (no escalation possible)
- [ ] Input validation confirmed
- [ ] Skip this step if fix is not security-related (document why)

---

## Step 5: Fast-Track Code Review

Expedited review — 1 reviewer, not the standard 2.

```bash
view_file .agent/skills/4-secure/code_review/SKILL.md
```

- [ ] Single senior reviewer assigned
- [ ] Review focused on: correctness, regression risk, scope creep
- [ ] Reviewer confirms fix is minimal and targeted
- [ ] Approval received

**Gate**: Do NOT deploy without at least 1 review approval.

---

## Step 6: Deploy to Staging and Smoke Test

Verify the fix works in a production-like environment.

```bash
view_file .agent/skills/5-ship/deployment_verification/SKILL.md
```

- [ ] Deployed to staging environment
- [ ] Smoke test: the specific bug is fixed
- [ ] Smoke test: core user flows still work (login, main features)
- [ ] No new errors in error tracking
- [ ] Health check endpoints responding

---

## Step 7: Deploy to Production with Canary

Gradual rollout to minimize blast radius.

```bash
view_file .agent/skills/5-ship/canary_verification/SKILL.md
```

- [ ] Canary deployment: 5% traffic initially
- [ ] Monitor error rates for 10 minutes
- [ ] Expand to 25%, monitor for 10 minutes
- [ ] Full rollout if metrics are stable
- [ ] Rollback plan ready (revert to previous tag)

**Rollback Trigger**: Any increase in error rate above baseline = immediate rollback.

---

## Step 8: Backport to Main Branch

Merge the fix back to the development branch.

```bash
view_file .agent/skills/3-build/git_workflow/SKILL.md
```

- [ ] Cherry-pick or merge hotfix commits into main/develop
- [ ] Resolve any merge conflicts
- [ ] Verify tests pass on main branch
- [ ] Delete hotfix branch after merge

---

## Step 9: Update Changelog

Document what happened for the team and users.

```bash
view_file .agent/skills/6-handoff/code_changelog/SKILL.md
```

- [ ] Changelog entry added with fix description
- [ ] Production tag updated (patch version bump)
- [ ] Team notified of fix and deployment
- [ ] Related incident ticket updated/closed

---

## Exit Checklist — Hotfix Complete

- [ ] Production bug is resolved and verified
- [ ] Regression test prevents recurrence
- [ ] Fix deployed via canary with stable metrics
- [ ] Backported to main branch
- [ ] Changelog updated, team notified
- [ ] No scope creep — only the bug was fixed

*Workflow Version: 1.0 | Created: March 2026*
