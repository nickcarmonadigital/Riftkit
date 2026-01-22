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

## Step 3: Database First (if applicable)

If schema changes needed:

1. Read schema_standards skill
2. Create migration with proper naming
3. Document in architecture doc
4. Apply migration

---

## Step 4: Backend Implementation (if applicable)

1. Create/modify services
2. Create/modify controllers
3. Add proper validation (DTOs)
4. Add error handling

---

## Step 5: Frontend Implementation (if applicable)

1. Check website_build skill for standards
2. Apply design system consistently
3. Ensure responsive design
4. Add proper accessibility

---

## Step 6: Integration

1. Connect frontend to backend
2. Test data flow end-to-end
3. Handle loading/error states

---

## Step 7: Verification

1. Test locally
2. Check for console errors
3. Verify in browser (if applicable)
4. Run any automated tests

---

## Step 8: Run /post-task

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
