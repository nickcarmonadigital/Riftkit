---
description: Hand off work to another AI or session with full context, OR resume from a previous session
---

# /handoff Workflow

> **2-Way Workflow**: Use for ENDING a session (handoff) OR STARTING a session (resume)

---

## 🔀 Choose Your Mode

| Mode | When to Use |
|------|-------------|
| **RESUME** | Starting a new session, picking up where you left off |
| **HANDOFF** | Ending a session, preparing for next session or another AI |

---

# MODE A: RESUME (Starting a Session)

> Use at the START of a session to quickly load context and continue work

## Step R1: Quick Context Load

// turbo

```bash
view_file .agent/docs/0-context/session-handoff-prompt.md
view_file .agent/docs/0-context/implementation-plan.md
view_file .agent/docs/0-context/feature-registry.md
```

### 2. Verify Onboarding

Ensure `.agent/docs/0-context/ai-onboarding-starter-template.md` is current:

```bash
view_file .agent/docs/0-context/ai-onboarding-starter-template.md
```

### 3. Create Session Artifacts

Create or update `.agent/docs/0-context/session-handoff-prompt.md`:

---

## Step R2: Check Current State

Ask yourself (or check these docs):

- [ ] What phase am I in? (Check `implementation-plan.md`)
- [ ] What was last worked on? (Check `session-handoff-prompt.md` or `dev-log.md`)
- [ ] What's the next priority task?

---

## Step R3: Sync with Git

// turbo

```bash
git pull origin main
git status
```

See if there are any changes from other sessions/agents.

---

## Step R4: Confirm with User

Ask: **"Here's what I see as the current state and next priority. Is this what you'd like to work on?"**

Present:

- Current phase/priority from implementation plan
- Last session's deferred tasks
- Your recommended starting point

---

## Step R5: Begin Work

Once confirmed, transition to the appropriate workflow:

- Feature work → Use `/plan` or `/build`
- Bug fix → Use `/debug`
- New idea → Use `/idea-to-spec`

---

# MODE B: HANDOFF (Ending a Session)

> Use when ending a session or handing work to Gemini/Claude/another agent

## Step H1: Read Handoff Skills

// turbo

```bash
view_file .agent/skills/1-brainstorm/idea_to_spec/SKILL.md
view_file .agent/skills/0-context/project_context/SKILL.md
```

---

## Step H2: Update Project Context

Ensure `.agent/docs/ai-onboarding-starter.md` is current:

- [ ] Tech stack accurate
- [ ] Current blockers listed
- [ ] Recent changes documented
- [ ] File structure up to date

---

## Step H3: Create Handoff Summary

Create or update `.agent/docs/session-handoff-prompt.md`:

```markdown
# Session Handoff - [Date]

## What Was Done This Session
- [List completed tasks]

## Current State
- [What's working]
- [What's not working]

## Next Steps (Priority Order)
1. [Most important next task]
2. [Second priority]
3. [Third priority]

## Key Files Changed
- [List important files with brief note on changes]

## Blockers/Questions
- [Any open questions for next session]

## Resume Command
Next session: Start with `/handoff` (Resume mode) and focus on: [specific task]
```

---

## Step H4: Update Dev Log

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

## Step H5: Git Commit

// turbo

```bash
git add -A
git commit -m "chore: Session end - [brief description]"
git push origin main
```

---

## Step H6: Verify Handoff Quality

Can the next agent answer:

- [ ] What is this project?
- [ ] What state is it in?
- [ ] What needs to happen next?
- [ ] Where are the key files?

---

## For Multi-AI Handoff

If handing to another AI for architecture/planning/review:

1. Copy relevant parts from `ai-onboarding-starter.md`
2. Add specific question or task
3. Format as structured prompt
4. Reference `ai_tool_orchestration` skill for tool selection

---

# Quick Reference

| Task | Command |
|------|---------|
| New session, continue work | `/handoff` → Choose Resume |
| End session, save context | `/handoff` → Choose Handoff |
| Switch to another AI | `/handoff` → Handoff + relevant context |

---

## Exit Checklist (Handoff Mode Only)

- [ ] Project context updated
- [ ] Session handoff doc created/updated
- [ ] Dev log updated
- [ ] All changes committed
- [ ] Pushed to remote
- [ ] Next priority clearly stated
