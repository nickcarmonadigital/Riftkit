---
name: Idea to Spec
description: Convert unstructured feature ideas into structured implementation specs ready for handoff
---

# Idea to Spec Skill

**Purpose**: Transform brain dumps and rough ideas into structured, implementation-ready specifications.

> [!CAUTION]
> **AI DOCUMENT RULE**: When any AI updates documents, they must ONLY ADD to existing content - NEVER DELETE. Mark outdated sections with `[DEPRECATED]` but preserve all historical text.

---

## 🎯 TRIGGER COMMANDS

```text
"I want to add a feature that..."
"Brain dump: [your idea]"
"New feature idea: [description]"
"Can you build [feature]?"
"Here's the spec from Gemini: [paste]"
"Build this spec: [paste structured spec]"
"Using idea_to_spec skill: [your idea]"
```

---

## WHEN TO USE

- You have a feature idea but haven't fully structured it
- You're brain dumping and want help organizing it
- You have a napkin sketch of what you want
- You've structured something in Gemini and want to hand off to implementation

---

# PART 1: BRAIN DUMP INPUT

## The 5 Essential Questions

Just answer these to get started:

```
1. WHAT: What should this feature do? (1-2 sentences)
2. WHY: What problem does it solve?
3. WHO: Who uses this? (all users, admins only, etc.)
4. WHERE: What page/section does it live in?
5. PRIORITY: How urgent? (P0-Critical, P1-High, P2-Medium, P3-Low)
```

## Optional Context (Helps Build Faster)

```
- LIKE: "Similar to how [product] does [feature]"
- DATA: What data does it need to store?
- DEPENDS: What existing features does it rely on?
- SKIP: What can we skip for MVP? (tests, animations, etc.)
```

## Example Brain Dump

```
WHAT: Users should be able to tag contacts and filter by tags
WHY: Right now you can't organize contacts at all
WHO: All users
WHERE: CRM Contacts page
PRIORITY: P1-High
LIKE: Similar to Gmail labels
DATA: Tags attached to contacts, probably a junction table
SKIP: Bulk tag editing, nested tags
```

---

# PART 2: STRUCTURED OUTPUT FORMAT

After processing a brain dump, produce this format:

```markdown
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

# PART 3: GEMINI HANDOFF

## Prompt for Gemini

Copy this to start a new Gemini chat for structuring ideas:

```
You are my Product Architect. I'll brain dump feature ideas and you structure them for my coding AI.

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

## Example Gemini Output

After brain dump "I want users to save custom filters as views":

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

# PART 4: WHAT HAPPENS NEXT

After receiving a structured spec:

1. **Verify completeness** - Check all sections are filled
2. **Ask clarifications** - Any missing details?
3. **Create implementation plan** - Break into phases
4. **Build it** - MVP or Full Polish mode

---

## Quick Format (For Speed)

If you're in a hurry, just paste:

```
Feature: [name]
Does: [what it does]
Solves: [problem]
Priority: [P0/P1/P2/P3]
Mode: MVP / Polish
```

---

## Tips for Better Specs

1. **Brain dump freely** - Don't self-edit, let AI structure
2. **Reference products** - "Like Notion views" helps
3. **State constraints** - "Must work on mobile"
4. **Note priorities** - "Most important is X"
5. **Mention what to skip** - Saves time on scope creep

---

*Skill Version: 2.0 | Merged from: feature_braindump + gemini_handoff | Updated: January 26, 2026*
