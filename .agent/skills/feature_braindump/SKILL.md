---
name: Feature Brain Dump
description: Convert unstructured feature ideas into structured implementation specs
---

# Feature Brain Dump Skill

Use this when you have a rough idea for a feature and want to quickly communicate it for implementation.

---

## 🎯 TRIGGER COMMANDS

Use any of these phrases to activate this skill:

```
"I want to add a feature that..."
"Brain dump: [your idea]"
"New feature idea: [description]"
"Can you build [feature]?"
"I need a way to [user goal]"
"Add [feature] to the project"
"Using feature_braindump skill: [your idea]"
```

---

## WHEN TO USE

- You have a feature idea but haven't fully structured it
- You're brain dumping and want help organizing it
- You have a napkin sketch of what you want

---

## WHAT'S NEEDED (Minimum)

Just answer these 5 questions:

```
1. WHAT: What should this feature do? (1-2 sentences)
2. WHY: What problem does it solve?
3. WHO: Who uses this? (all users, admins only, etc.)
4. WHERE: What page/section does it live in?
5. PRIORITY: How urgent? (P0-Critical, P1-High, P2-Medium, P3-Low)
```

---

## OPTIONAL (Helps Build Faster)

```
- LIKE: "Similar to how [product] does [feature]"
- DATA: What data does it need to store?
- DEPENDS: What existing features does it rely on?
- SKIP: What can we skip for MVP? (tests, animations, etc.)
```

---

## EXAMPLE BRAIN DUMP

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

## WHAT HAPPENS NEXT

1. Clarify anything unclear
2. Propose data model, API, and UI structure
3. Create implementation plan
4. Build it in MVP mode (unless you specify Polish)

---

## QUICK FORMAT

If you're in a hurry, just paste:

```
Feature: [name]
Does: [what it does]
Solves: [problem]
Priority: [P0/P1/P2/P3]
Mode: MVP / Polish
```
