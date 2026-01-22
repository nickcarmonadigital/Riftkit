---
description: Plan a feature from vision docs using first principles decomposition
---

# /plan Workflow

> Use when you have a vision/requirement and need to break it into implementable tasks

## Input Required

- Vision document or feature description
- Implementation plan (if exists)

---

## Step 1: Read Planning Skills

// turbo

```bash
view_file .agent/skills/atomic_reverse_architecture/SKILL.md
view_file .agent/skills/feature_braindump/SKILL.md
```

---

## Step 2: First Principles Decomposition (ARA)

Using atomic_reverse_architecture skill:

1. **Define the End State**: What does "done" look like?
2. **Reverse Engineer**: What components are needed?
3. **Identify Gaps**: What's missing between now and done?
4. **Atomic Tasks**: Break into smallest implementable units

---

## Step 3: Feature Braindump (if unstructured input)

If starting from unstructured ideas:

1. Capture all requirements/ideas
2. Group by category
3. Identify dependencies
4. Prioritize by value/complexity

---

## Step 4: Create/Update Implementation Plan

Output: `.agent/docs/implementation-plan.md` or brain artifact

Include:

- [ ] Goal description
- [ ] Proposed changes by component
- [ ] File-by-file breakdown
- [ ] Verification plan
- [ ] User review items

---

## Step 5: Identify Skills Needed for Build

Based on the plan, check which skills will be needed:

| Task Type | Skills to Use |
|-----------|---------------|
| Database changes | schema_standards |
| New API endpoints | feature_architecture |
| Frontend pages | website_build |
| Security-sensitive | security_audit |
| Complex feature | feature_architecture |

---

## Step 6: Get User Approval

**STOP HERE** - Present plan to user for approval before /build

---

## Exit Checklist

- [ ] Vision analyzed and understood
- [ ] Tasks broken into atomic units
- [ ] Implementation plan created/updated
- [ ] Dependencies identified
- [ ] Skills needed for build identified
- [ ] User approval received
