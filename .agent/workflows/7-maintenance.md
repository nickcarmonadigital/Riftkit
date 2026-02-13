# Maintenance Workflow

**Purpose**: Systematic bug fixing, updates, and technical debt repayment.
**Skill**: Use `code_review` and `code_changelog`.

---

# Phase 1: Triage

**Goal**: Assess severity and priority.

1. **Replication**
   - Can I reproduce the bug?
   - Steps to reproduce confirmed?

2. **Impact Assessment**
   - Critical (System down)? -> Drop everything.
   - High (Feature broken)? -> Fix today.
   - Low (Visual/Annoyance)? -> Schedule for batch.

---

# Phase 2: Diagnosis

**Goal**: Find the root cause.

1. **Logs & Metrics**
   - Check server logs.
   - Check browser console.

2. **Isolation**
   - Is it the FE? BE? DB? Network?

---

# Phase 3: The Fix

**Goal**: Resolve the issue without creating new ones.

1. **Draft Fix**
   - Implement solution locally.

2. **Verify Fix**
   - Test the specific edge case.
   - Run existing tests to ensure no regression.

---

# Phase 4: Review & Deploy

**Goal**: Safe release.

1. **Code Review**
   - Self-review or AI-review (`code_review` skill).

2. **Deploy**
   - Push to production.

3. **Verification**
   - Check live site.

---

# Phase 5: Documentation

**Goal**: Don't solve the same problem twice.

1. **Changelog**
   - Update `CHANGELOG.md`.

2. **Post-Mortem (If Critical)**
   - Why did this happen?
   - How do we prevent it forever? (Add test / Change arch).

---
*Workflow Version: 1.0*
