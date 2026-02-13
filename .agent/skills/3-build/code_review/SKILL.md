---
name: Code Review
description: Bug reporting, troubleshooting, and code verification workflow
---

# Code Review Skill

**Purpose**: Structured workflow for reporting bugs, troubleshooting issues, and verifying code quality.

---

## 🎯 TRIGGER COMMANDS

```text
"This is broken: [description]"
"Bug: [description]"
"Error: [paste error message]"
"Review this code: [paste code]"
"Check this for bugs: [paste code]"
"Security review: [paste code]"
"Using code_review skill: [issue or code]"
```

---

# PART 1: BUG REPORTING

## When to Use

- Feature isn't working as expected
- Getting error messages
- Something that worked before is now broken
- Console/terminal showing errors

---

## The Big 5 (Answer These)

```
1. EXPECTED: What should happen?
2. ACTUAL: What's actually happening?
3. STEPS: How do you reproduce it?
4. ERRORS: Any error messages? (paste them)
5. CHANGED: What changed recently before it broke?
```

---

## Context That Speeds Up Debugging

### Environment

```
- Browser: [Chrome/Firefox/Safari]
- Page URL: [where does it happen]
- User state: [logged in/out, specific user?]
```

### Error Details

```
- Console errors: [paste browser console output]
- Network errors: [any failed requests in Network tab]
- Backend logs: [any errors in terminal]
```

### Recent Changes

```
- Last code change: [what file/feature was modified]
- Last working time: [when did it last work?]
- What triggered it: [did you do something specific?]
```

---

## Quick Bug Format

```
BUG: [one-line description]

Expected: [what should happen]
Actual: [what happens instead]
Steps: 
1. [do this]
2. [then this]
3. [bug appears]

Error: 
[paste error message]

Last change: [what changed before it broke]
```

---

## Production Bug Format

For urgent live issues:

```
🚨 PRODUCTION BUG - LIVE USERS AFFECTED

Impact: [X users affected, Y% of traffic]
Severity: [Critical/High/Medium]
First Report: [when did users start reporting]

[Then regular bug report format above]
```

---

# PART 2: CODE VERIFICATION

## When to Verify

- After building a feature
- Before deploying significant changes
- When you suspect hidden bugs
- For security review
- When code seems complex

---

## The Verification Workflow

```
Build (implementation) → Review (verification) → Fix (if needed)
```

---

## How to Request Review

### Option 1: Simple Review

```
Please review this code from [file path]:

[paste code]
```

### Option 2: Specific Focus

```
Please review this code for [security/performance/best practices]:

[paste code]
```

### Option 3: Compare Implementation to Spec

```
This was the spec:
[paste feature spec]

This is the implementation:
[paste code]

Does it match?
```

---

## What to Check

### Security

- Input validation
- SQL injection risks
- XSS vulnerabilities
- Auth on protected routes
- Secrets in code (should be in env)

### Code Quality

- TypeScript types correct
- Error handling
- N+1 query problems
- Async/await usage
- Separation of concerns

### Best Practices

- Environment variables for secrets
- No console.log in production
- Graceful error messages
- Loading and error states in UI

---

## Review Output Format

```markdown
### ✅ What's Good
[Things done well]

### ⚠️ Issues Found
| Severity | File:Line | Issue | Fix |
|----------|-----------|-------|-----|
| High | file.ts:42 | [problem] | [solution] |

### 💡 Suggestions
[Optional improvements]

### 🔒 Security Notes
[Any security concerns]
```

---

# PART 3: TROUBLESHOOTING WORKFLOW

## Step 1: Reproduce

```
[ ] Can you reproduce the bug consistently?
[ ] What are the exact steps?
[ ] Does it happen in all environments?
```

## Step 2: Isolate

```
[ ] Which component is failing?
[ ] What was the last working state?
[ ] What changed between then and now?
```

## Step 3: Diagnose

```
[ ] Check console for errors
[ ] Check network requests
[ ] Check backend logs
[ ] Add debug logging if needed
```

## Step 4: Fix

```
[ ] Implement the fix
[ ] Test the fix locally
[ ] Verify no regressions
[ ] Document what was wrong
```

## Step 5: Verify

```
[ ] Bug is fixed
[ ] No new bugs introduced
[ ] Tests pass (if applicable)
[ ] Update changelog/docs
```

---

## Quick Reviews

```
Quick security check on this endpoint:
[paste endpoint code]
```

```
Any bugs in this function?
[paste function]
```

```
Is this query vulnerable to injection?
[paste query]
```

---

## Tips for Faster Fixes

1. **Paste exact error messages** - Don't paraphrase, copy/paste
2. **Include file paths** - "Error in service.ts line 42"
3. **Show, don't tell** - Screenshots > descriptions
4. **Mention recent changes** - 90% of bugs are from recent changes
5. **Note what you've tried** - Saves time from suggesting things you've done

---

*Skill Version: 2.0 | Merged from: bug_troubleshoot + claude_verification | Updated: January 26, 2026*
