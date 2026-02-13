---
name: Project Context (Living Document)
description: Single source of truth for project state - UPDATE AFTER EVERY CHANGE
---

# Project Context Skill

**This is your living context document.** It should be updated after EVERY feature added or bug fixed.

> [!CAUTION]
> **APPEND-ONLY RULE**: When updating documents, ALWAYS ADD new content at the end of sections. NEVER DELETE existing content. If information is outdated, mark it as deprecated with `[DEPRECATED]` prefix, but keep the original text for historical reference.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"Update the project context with what we just did"
"Update the onboarding doc"
"Document what we changed"
"Add [feature] to the context"
"Update the living document"
"Refresh the project context"
"Using project_context skill: update with [changes]"
```

---

## PURPOSE

This skill maintains a single source of truth that:

1. Onboards any AI (Gemini, Claude, Antigravity) to the project
2. Tracks what exists, what's working, what's broken
3. Gets updated after every change to stay current

---

## THE FILE

**Location**: `.agent/docs/0-context/ai-onboarding-starter-template.md`

This file contains:

- Part 1: Project overview (tech stack, architecture, pages, tables)
- Part 2: Gemini prompt (Product Architect role)
- Part 3: Claude prompt (Code Reviewer role)
- Part 4: Quick reference for handoffs

---

## WHEN TO UPDATE

Update the `ai-onboarding-starter.md` file after:

| Event | What to Update |
|-------|----------------|
| **Feature added** | Add to "Implemented" list, update tables/pages list |
| **Bug fixed** | Remove from "Blockers", update status |
| **New blocker found** | Add to "Current Blocker" section |
| **Database changed** | Update "Database Tables" section |
| **New page created** | Add to "Frontend Pages" table |
| **New module created** | Add to "Backend Modules" table |
| **RLM context changed** | Update if context sources or REPL functions change |
| **AI integration added** | Update "AI Intelligence" section |

---

## UPDATE TEMPLATE

After completing work, use this to update the context:

```markdown
## CONTEXT UPDATE [DATE]

### What Changed
- [Brief description of change]

### Files Modified
- `path/to/file.ts` - [what changed]

### New Tables/Columns
- [table.column] - [purpose]

### RLM Context Updates (if applicable)
- Context Sources: [added/removed sources]
- REPL Functions: [new functions added]
- Cache Changes: [invalidation triggers]

### Status Changes
- [Feature X]: Working → Blocked / Blocked → Working

### New Blockers
- [Description of blocker if any]
```

---

## HOW TO USE FOR NEW AI CHAT

1. Open `.agent/docs/0-context/ai-onboarding-starter-template.md`
2. Copy the relevant parts:
   - **Gemini**: Part 1 + Part 2
   - **Claude**: Part 1 + Part 3
   - **Antigravity**: Part 1 (or full file)
3. Paste at start of new chat

---

## AUTOMATION

After finishing work with Antigravity, say:

> "Please update the project context with what we just did."

This keeps the living document current for next session.
