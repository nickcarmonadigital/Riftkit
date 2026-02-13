---
description: Build a feature from an approved implementation plan
---

# /build Workflow

> Use after /plan workflow when implementation plan is approved

## Pre-Flight Checks

- [ ] Implementation plan approved?
- [ ] Dependencies identified?
- [ ] Dev environment running?

---

## Step 1: Read Build Skills

// turbo

```bash
view_file .agent/skills/feature_architecture/SKILL.md
view_file .agent/skills/code_changelog/SKILL.md
view_file .agent/skills/schema_standards/SKILL.md  # if DB changes
view_file .agent/skills/website_build/SKILL.md     # if frontend
```

---

## Step 2: Set Up Task Tracking

Update brain artifact `task.md`:

- [ ] Break plan into checkable items
- [ ] Mark current phase as `[/]` (in progress)
- [ ] Set task boundary with EXECUTION mode

---

## Step 3: TDD Protocol (The "Test First" Rule)
>
> [!IMPORTANT]
> **NEVER write code without a failing test.**
>
> 1. Write a test case that fails.
> 2. Verify it fails.
> 3. Then write the code to pass it.

## Step 4: Entropy Check

- If editing a file > 100 lines, **STOP**.

- Refactor/split it before adding more features.
- Don't build on top of entropy.

## Step 5: Database First (if applicable)

If schema changes needed:

1. Read schema_standards skill
2. Create migration with proper naming
3. Document in architecture doc
4. Apply migration

---

## Step 6: Backend Implementation (if applicable)

1. Create/modify services
2. Create/modify controllers
3. Add proper validation (DTOs)
4. Add error handling

---

## Step 7: Frontend Implementation (if applicable)

1. Check website_build skill for standards
2. Apply design system consistently
3. Ensure responsive design
4. Add proper accessibility

---

## Step 8: Integration

1. Connect frontend to backend
2. Test data flow end-to-end
3. Handle loading/error states

---

## Step 9: Verification

1. Test locally
2. Check for console errors
3. Verify in browser (if applicable)
4. Run any automated tests

---

## Step 10: Run /post-task

**MANDATORY**: Run post-task workflow before notifying user

```bash
view_file .agent/workflows/post-task.md
```

---

## Exit Checklist

- [ ] Feature implemented per plan
- [ ] Tests passing
- [ ] /post-task workflow completed
- [ ] Git committed
- [ ] User notified
