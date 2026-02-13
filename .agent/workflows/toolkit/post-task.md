---
description: Post-task checklist that MUST run after every feature, fix, or task completion
---

# Post-Task Skill Checklist

> **CRITICAL**: Run through this checklist AFTER completing ANY task, before notifying the user.

## Quick Decision Matrix

| Task Type | Required Skills |
|-----------|-----------------|
| **New Feature** | Walkthrough + SSoT + Project Context + Architecture (if complex) |
| **Bug Fix** | Project Context + Changelog (if significant) |
| **Refactor** | Changelog + Project Context |
| **New Page/Component** | Walkthrough + SSoT |
| **API Change** | Architecture + SSoT |
| **Security-Related** | Security Audit |

---

## Mandatory Skills (Check ALL)

### 1. Feature Walkthrough (REQUIRED for features)

**Skill**: `.agent/skills/3-build/feature_walkthrough/SKILL.md`
**Output**: `.agent/docs/6-handoff/walkthroughs/[feature]-walkthrough.md`

- [ ] Plain English explanation
- [ ] Step-by-step usage guide
- [ ] Flow diagram (ASCII/mermaid)
- [ ] Key files listed
- [ ] "Try It Yourself" section

---

### 2. SSoT Update (REQUIRED for any change)

**Skill**: `.agent/skills/7-maintenance/ssot_update/SKILL.md`
**Output**: Update `.agent/docs/7-maintenance/ssot-master-index.md`

- [ ] Added new item to correct section?
- [ ] Used proper status tag (`[ ]`, `[/]`, `[x]`)?
- [ ] Updated "Last Updated" date?
- [ ] Linked to walkthrough if applicable?

---

### 3. Project Context (REQUIRED)

**Skill**: `.agent/skills/0-context/project_context/SKILL.md`
**Output**: Update `.agent/docs/0-context/ai-onboarding-starter-template.md`

- [ ] Documented what changed?
- [ ] Updated file lists if new files created?
- [ ] Noted any blockers or status changes?

---

### 4. Code Changelog (RECOMMENDED for code changes)

**Skill**: `.agent/skills/3-build/code_changelog/SKILL.md`
**Output**: Update `.agent/docs/3-build/dev-log.md` or module `CHANGELOG.md`

- [ ] What was changed?
- [ ] Why was it changed?
- [ ] Breaking changes noted?
- [ ] Files affected listed?

---

## Conditional Skills (Check IF applicable)

### 5. Feature Architecture (IF complex feature)

**Skill**: `.agent/skills/2-design/feature_architecture/SKILL.md`
**Output**: `.agent/docs/2-design/[feature]-architecture.md`

- [ ] Database tables documented?
- [ ] API endpoints listed?
- [ ] Data flow explained?
- [ ] Modification guide included?

---

### 6. Security Audit (IF security-relevant)

**Skill**: `.agent/skills/4-secure/security_audit/SKILL.md`
**Output**: `.agent/docs/4-secure/security-audit-[date].md`

Run if the task involves:

- Authentication/Authorization
- User input handling
- API endpoints
- Database operations
- Third-party integrations
- Payment/sensitive data

---

### 7. Schema Documentation (IF database changes)

**Skill**: `.agent/skills/2-design/schema_standards/SKILL.md`

- [ ] Schema documented with all fields?
- [ ] Relationships explained?
- [ ] RLS policies documented?

---

## Final Verification

- [ ] All applicable skills checked?
- [ ] Documentation created/updated?
- [ ] Git status clean (commit made)?
- [ ] No lint errors in new files?

---

## How to Trigger

Say any of these:

- `/post-task`
- "Run post-task checklist"
- "Check all skills"
- "Did I miss any skills?"

---

## AI Agent Reminder

```text
┌─────────────────────────────────────────┐
│  BEFORE marking ANY task complete:      │
├─────────────────────────────────────────┤
│  1. ✅ Code/feature working             │
│  2. ✅ Walkthrough created (if feature) │
│  3. ✅ SSoT updated                     │
│  4. ✅ Project context updated          │
│  5. ✅ Changelog entry (if code)        │
│  6. ✅ Git committed                    │
│  7. ✅ Notify user                      │
└─────────────────────────────────────────┘
```
