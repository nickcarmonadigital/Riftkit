# Development Workflow Guide

**Purpose**: How to use `.agent` skills and documents together for smooth, efficient development.

---

## 🗺️ The Workflow Map

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DEVELOPMENT WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  START                                                                       │
│    │                                                                         │
│    ▼                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 1. DISCOVERY: What are we building?                               │       │
│  │    Skills: idea_to_spec, project_context                           │       │
│  │    Output: Feature spec, context update                           │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 2. REFERENCE: Check existing architecture                         │       │
│  │    Docs: Project documentation, feature registry                  │       │
│  │    Check: Does this exist? Where does it fit?                     │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 3. PLAN: Create implementation plan                               │       │
│  │    Skills: documentation_framework                                │       │
│  │    Agent: /plan (planner + architect agents)                      │       │
│  │    Output: Implementation plan with done criteria                 │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 4. BUILD: Implement the feature                                   │       │
│  │    Skills: bug_troubleshoot, code_review                          │       │
│  │    Agents: /tdd, /build-fix, /code-review                        │       │
│  │    Tools: Your AI coding assistant                                │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 5. DOCUMENT: Record what was built                                │       │
│  │    Skills: feature_architecture, feature_walkthrough              │       │
│  │    Agent: /update-docs (doc-updater agent)                        │       │
│  │    Output: Architecture doc, walkthrough                          │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 6. SECURE: Audit for vulnerabilities                              │       │
│  │    Skills: security_audit                                         │       │
│  │    Agents: security-reviewer, /e2e (e2e-runner)                   │       │
│  │    Output: Security audit report                                  │       │
│  └────────────────────────────┬─────────────────────────────────────┘       │
│                               │                                              │
│                               ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────┐       │
│  │ 7. COMPLETE: Update knowledge base                                │       │
│  │    Skills: ssot_structure, project_context                        │       │
│  │    Output: Updated project state                                  │       │
│  └──────────────────────────────────────────────────────────────────┘       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📚 Skills Quick Reference

| Skill / Command | Trigger | When to Use |
|-----------------|---------|-------------|
| `idea_to_spec` | "I have an idea for..." | Brain dump → structured spec |
| `project_context` | "Update project context" | Track project state |
| `documentation_framework` | "What docs do I need?" | Reference for doc types |
| `/plan` | "Plan the implementation" | Create detailed plan (planner agent) |
| `/tdd` | "Write tests first" | Test-driven development (tdd-guide agent) |
| `/code-review` | "Review this code" | Automated code review (code-reviewer agent) |
| `/build-fix` | "Fix this build error" | Build error resolution (build-error-resolver agent) |
| `/e2e` | "Run E2E tests" | End-to-end testing (e2e-runner agent) |
| `/refactor-clean` | "Clean up dead code" | Automated cleanup (refactor-cleaner agent) |
| `/update-docs` | "Update the docs" | Documentation update (doc-updater agent) |
| `feature_architecture` | "Document [feature] architecture" | After building complex features |
| `feature_walkthrough` | "Create walkthrough" | After completing features |
| `security_audit` | "Security audit for..." | Before shipping (security-reviewer agent) |
| `bug_troubleshoot` | "I have a bug..." | Structured debugging |
| `code_review_response` | "Respond to PR feedback" | Address review comments |
| `/checkpoint` | "Save session state" | Context window management |
| `/learn` | "Extract patterns" | Learn from session |

---

## 🚀 Workflow by Task Type

### Adding a New Feature

```text
1. Start with: idea_to_spec
   → Outputs structured feature spec

2. Check: existing project documentation
   → Does this already exist?

3. Update: implementation plan
   → Add feature with done criteria

4. Build the feature
   → Use bug_troubleshoot if stuck

5. After building: feature_architecture (if complex)
   → Create architecture doc

6. Run: security_audit
   → Check for vulnerabilities

7. Update: project_context
   → Record what was built
```

### Fixing a Bug

```text
1. Start with: bug_troubleshoot
   → Structured bug report

2. Check: relevant architecture docs
   → Understand the data flow

3. Fix the bug
   → Use code_review to review fix

4. Update: project_context
   → Note the fix
```

---

## 🔄 Daily Workflow Ritual

### Start of Session

1. Read `project_context` to catch up
2. Check current implementation plan
3. Pick task from unchecked items

### During Work

1. Reference docs for file locations
2. Use skills as needed
3. Document as you go

### End of Session

1. Update `project_context` with what was done
2. Update implementation plan checkboxes
3. Create any needed architecture docs

---

## ✅ Workflow Checklist

Before starting any feature:

- [ ] Checked project documentation for context
- [ ] Checked implementation plan for priority
- [ ] Checked for existing related code

After completing any feature:

- [ ] Updated feature registry with new files
- [ ] Created architecture doc if complex
- [ ] Ran security_audit if security-sensitive
- [ ] Updated implementation plan checkboxes
- [ ] Updated project_context
