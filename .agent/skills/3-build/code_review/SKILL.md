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

---

## Agent Automation

> Use the **code-reviewer** agent (`.agent/agents/code-reviewer.md`) for automated reviews.
> Invoke via: `/code-review`

### Severity Classification Matrix

When reviewing code, classify issues by severity:

| Severity | Description | Action |
|----------|-------------|--------|
| CRITICAL | Security vulnerability, data loss risk | Block merge |
| HIGH | Bug, performance regression, missing test | Must fix before merge |
| MEDIUM | Code smell, style violation, missing docs | Should fix, can defer |
| LOW | Nitpick, naming suggestion, optional improvement | Optional |

### Confidence Filtering

Only report issues with confidence > 0.7. For lower-confidence observations, prefix with "Consider:" rather than stating as a definite issue.

### Coding Standards Quick Reference

These principles should be applied during every code review:

#### Code Quality Principles

- **Readability First**: Code is read more than written. Clear names, self-documenting code preferred over comments.
- **KISS**: Simplest solution that works. No premature optimization. Easy to understand > clever code.
- **DRY**: Extract common logic into functions. Share utilities across modules.
- **YAGNI**: Don't build features before they're needed. Add complexity only when required.

#### TypeScript Patterns to Enforce

```typescript
// Enforce immutability — use spread operator, not mutation
const updated = { ...original, name: 'New' }  // GOOD
original.name = 'New'                          // BAD

// Enforce parallel async when independent
const [a, b, c] = await Promise.all([fetchA(), fetchB(), fetchC()])  // GOOD

// Enforce proper types — reject 'any'
function process(input: string): Result { }  // GOOD
function process(input: any): any { }        // BAD

// Enforce named constants over magic numbers
const MAX_RETRIES = 3;                       // GOOD
if (retryCount > 3) { }                      // BAD
```

#### React Patterns to Enforce

- Functional components with typed props interfaces
- `useMemo` / `useCallback` for expensive computations and callbacks
- Functional state updates: `setState(prev => prev + 1)` not `setState(count + 1)`
- Avoid ternary hell in JSX — use `&&` for conditional rendering
- Lazy load heavy components with `React.lazy()` + `Suspense`

#### Code Smell Thresholds

| Smell | Threshold | Action |
|-------|-----------|--------|
| Long function | > 50 lines | Extract methods |
| Deep nesting | > 3 levels | Early returns |
| God class | > 300 lines, 10+ methods | Split into focused services |
| Duplicate code | Same logic in 2+ places | Extract shared utility |

#### Comment Standards

- Comment **WHY**, never **WHAT** — the code shows what, comments explain intent
- Use JSDoc with `@param`, `@returns`, `@throws`, `@example` for public APIs
- Flag deliberate deviations: `// Deliberately using mutation here for performance`

---

*Skill Version: 2.1 | Merged from: bug_troubleshoot + claude_verification + ECC coding-standards | Updated: February 2026*
