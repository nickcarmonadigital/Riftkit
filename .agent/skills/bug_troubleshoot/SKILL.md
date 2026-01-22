---
name: Bug Report & Troubleshooting
description: Structured format for reporting bugs and getting help fixing issues
---

# Bug Report & Troubleshooting Skill

Use this when something is broken and you need help fixing it.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"This is broken: [description]"
"Bug: [description]"
"Error: [paste error message]"
"[Feature] isn't working"
"Fix: [description of issue]"
"Something's wrong with [feature]"
"Help, [feature] is broken"
"Using bug_troubleshoot skill: [issue]"
```

---

## WHEN TO USE

- Feature isn't working as expected
- Getting error messages
- Something that worked before is now broken
- Console/terminal showing errors

---

## THE BIG 5 (Answer These)

```
1. EXPECTED: What should happen?
2. ACTUAL: What's actually happening?
3. STEPS: How do you reproduce it?
4. ERRORS: Any error messages? (paste them)
5. CHANGED: What changed recently before it broke?
```

---

## CONTEXT THAT SPEEDS UP DEBUGGING

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

## QUICK FORMAT

For fast bug reports:

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

## PRODUCTION BUG FORMAT

For urgent live issues:

```
🚨 PRODUCTION BUG - LIVE USERS AFFECTED

Impact: [X users affected, Y% of traffic]
Severity: [Critical/High/Medium]
First Report: [when did users start reporting]

[Then regular bug report format above]
```

---

## TIPS FOR FASTER FIXES

1. **Paste exact error messages** - Don't paraphrase, copy/paste
2. **Include file paths** - "Error in service.ts line 42"
3. **Show, don't tell** - Screenshots > descriptions
4. **Mention recent changes** - 90% of bugs are from recent changes
5. **Note what you've tried** - Saves time from suggesting things you've done
