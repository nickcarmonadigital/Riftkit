---
name: Claude Code Verification
description: Utilize the running Claude Code CLI to verify code changes, analyze files for bugs, and suggest improvements.
---

# Claude Code Verification Skill

Use Claude (via Claude Code CLI or browser) to review and verify code changes made by Antigravity.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"Review this code: [paste code]"
"Check this for bugs: [paste code]"
"Security review: [paste code]"
"Is this secure? [paste code]"
"Verify this implementation: [paste code]"
"Claude found these issues: [paste issues]"
"Using claude_verification skill: [paste code]"
```

---

## WHEN TO USE

- After Antigravity builds a feature
- Before deploying significant changes
- When you suspect hidden bugs
- For security review
- When code seems complex

---

## THE WORKFLOW

```
Antigravity (builds) → Claude (reviews) → Antigravity (fixes if needed)
```

---

## HOW TO REQUEST REVIEW

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

## WHAT CLAUDE CHECKS

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

## CLAUDE'S OUTPUT FORMAT

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

## HANDOFF BACK TO ANTIGRAVITY

After Claude review, tell Antigravity:

```
Claude found these issues:

[paste Claude's ⚠️ Issues Found table]

Please fix them.
```

---

## QUICK REVIEW REQUESTS

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
