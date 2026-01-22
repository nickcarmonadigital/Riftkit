---
name: Gemini Handoff
description: Instructions for structuring AI output for handoff to Antigravity
---

# Gemini Handoff Skill

Prompt and format for having Gemini (or another AI) structure your brain dumps for implementation.

> [!CAUTION]
> **AI DOCUMENT RULE**: When any AI (Gemini, Claude, Antigravity) updates documents, they must ONLY ADD to existing content - NEVER DELETE. Mark outdated sections with `[DEPRECATED]` or `[SUPERSEDED]` but preserve all historical text.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"Here's the spec from Gemini: [paste]"
"Gemini structured this feature: [paste]"
"From Gemini: [paste output]"
"PRD from Gemini: [paste]"
"Build this spec: [paste structured spec]"
"Using gemini_handoff skill: [paste spec]"
```

---

## WHEN TO USE

- You brain dumped an idea into Gemini
- Now you want structured output for Antigravity
- You want Gemini to format things consistently

---

## PROMPT FOR GEMINI

Copy this to start a new Gemini chat:

```
You are my Product Architect. I'll brain dump feature ideas and you structure them for my coding AI (Antigravity).

YOUR JOB:
1. Listen to my brain dump
2. Ask clarifying questions
3. Output structured doc using format below
4. Focus on WHAT and WHY - coding AI handles HOW

OUTPUT FORMAT:

# Feature: [Name]

## OVERVIEW
- Problem: [pain point]
- Solution: [what it does]
- Priority: P0/P1/P2/P3
- Success: [how we know it works]

## TECHNICAL
### Data
| Table | Purpose | Key Columns |
|-------|---------|-------------|

### API
| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|

### UI
| Route/Component | Purpose |
|-----------------|---------|

## SECURITY
- Auth: Required/Optional/Public
- Who: Owner only / Role-based / All users
- Validation: [what to check]

## BUILD
- Mode: MVP / Full Polish
- Skip: [tests/animations/analytics]

## NOTES
[Edge cases, assumptions]
```

---

## EXAMPLE OUTPUT FROM GEMINI

After brain dump "I want users to save custom filters as views"

Gemini outputs:

```markdown
# Feature: Saved Views

## OVERVIEW
- Problem: Users can't save filter configurations
- Solution: Save named views with filter/sort settings
- Priority: P2-Medium  
- Success: User creates view, switches between views, views persist

## TECHNICAL
### Data
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| views | Store views | id, userId, name, filters, isDefault |

### API
| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | /views | List views | Required |
| POST | /views | Create view | Required |
| DELETE | /views/:id | Delete | Required |

### UI
| Route/Component | Purpose |
|-----------------|---------|
| ViewSelector | Switch between views |
| SaveViewModal | Save current filters |

## SECURITY
- Auth: Required
- Who: Owner only
- Validation: Sanitize name, validate filter JSON

## BUILD
- Mode: MVP
- Skip: Tests, animations

## NOTES
- Max 20 views per user
```

---

## THEN PASTE TO ANTIGRAVITY

Just paste Gemini's output. Antigravity will:

1. Verify completeness
2. Ask any clarifications
3. Create implementation plan
4. Build it

---

## TIPS

1. **Brain dump freely** - Don't self-edit, let Gemini structure
2. **Reference products** - "Like Notion views" helps
3. **State constraints** - "Must work on mobile"
4. **Note priorities** - "Most important is X"
