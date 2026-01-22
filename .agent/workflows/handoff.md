---
description: Hand off work to another AI or session with full context
---

# /handoff Workflow

> Use when ending a session or handing work to Gemini/Claude/another agent

## When to Use

- Ending a long work session
- Switching to a different AI for specialized work
- Passing to Gemini for architecture review
- Passing to Claude for code review

---

## Step 1: Read Handoff Skills

// turbo

```bash
view_file .agent/skills/gemini_handoff/SKILL.md
view_file .agent/skills/project_context/SKILL.md
```

---

## Step 2: Update Project Context

Ensure `.agent/docs/ai-onboarding-starter.md` is current:

- [ ] Tech stack accurate
- [ ] Current blockers listed
- [ ] Recent changes documented
- [ ] File structure up to date

---

## Step 3: Create Handoff Summary

Create or update `.agent/docs/session-handoff-prompt.md`:

```markdown
# Session Handoff

## What Was Done This Session
- [List completed tasks]

## Current State
- [What's working]
- [What's not working]

## Next Steps
- [What needs to happen next]

## Key Files Changed
- [List important files]

## Blockers/Questions
- [Any open questions for next session]
```

---

## Step 4: Update Dev Log

Add session entry to `.agent/docs/dev-log.md`:

```markdown
## [Date] | Session: [Description]

### Completed
- [x] Task 1
- [x] Task 2

### Deferred
- [ ] Task 3 (reason)

### For Next Session
- Start with: [specific task]
- Context needed: [key info]
```

---

## Step 5: Git Commit

// turbo

```bash
git add -A
git commit -m "chore: Session end - [brief description]"
git push origin main
```

---

## Step 6: Verify Handoff Quality

Can the next agent answer:

- [ ] What is this project?
- [ ] What state is it in?
- [ ] What needs to happen next?
- [ ] Where are the key files?

---

## For Gemini Handoff Specifically

If handing to Gemini for architecture/planning:

1. Copy Part 1 + Part 2 from `ai-onboarding-starter.md`
2. Add specific question or task
3. Format as structured prompt

---

## For Claude Handoff Specifically

If handing to Claude for code review:

1. Copy Part 1 + Part 3 from `ai-onboarding-starter.md`
2. Include specific files to review
3. Ask targeted questions

---

## Exit Checklist

- [ ] Project context updated
- [ ] Session handoff doc created/updated
- [ ] Dev log updated
- [ ] All changes committed
- [ ] Pushed to remote
