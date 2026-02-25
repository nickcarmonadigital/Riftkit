---
description: Debug and fix bugs using structured troubleshooting
---

# /debug Workflow

> Use when encountering bugs, errors, or unexpected behavior

## Input Required

- Error message or symptom description
- Steps to reproduce (if known)

---

## Step 1: Read Debug Skills

// turbo

```bash
view_file .agent/skills/bug_troubleshoot/SKILL.md
view_file .agent/skills/code_review/SKILL.md
```

---

## Step 2: Gather Information

1. **Error Details**
   - Exact error message
   - Stack trace
   - Console output

2. **Context**
   - What was the user doing?
   - When did it start happening?
   - What changed recently?

3. **Environment**
   - Browser/OS/Node version
   - Dev vs Production
   - Relevant config

---

## Step 3: Reproduce the Bug

1. Follow exact steps to reproduce
2. Document reproduction steps
3. Identify minimum reproduction case

---

## Step 4: Hypothesize Root Causes

List possible causes in order of likelihood:

1. [Most likely cause]
2. [Second most likely]
3. [Edge case possibility]

---

## Step 5: Investigate

For each hypothesis:

1. Check relevant code
2. Add logging if needed
3. Verify or eliminate hypothesis

---

## Step 6: Implement Fix

1. Make minimal change to fix issue
2. Don't fix unrelated things
3. Add test if applicable

---

## Step 7: Verify Fix

1. Reproduce original bug → confirm fixed
2. Check for regressions
3. Test edge cases

---

## Step 8: Document

Update:

- [ ] Code changelog (what was fixed, why)
- [ ] Project context (if status changed)
- [ ] Bug report (if one exists)

---

## Exit Checklist

- [ ] Root cause identified
- [ ] Fix implemented
- [ ] Fix verified
- [ ] No regressions
- [ ] Documentation updated
- [ ] Git committed
