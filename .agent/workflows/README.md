# Workflow System Index

**Purpose**: Grab-and-drop workflows for the full software development lifecycle.  
**Location**: `.agent/workflows/`

> **How to use**: Say `/workflow-name` or "run the [workflow-name] workflow" to trigger.

---

## Workflow Map

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SOFTWARE DEVELOPMENT LIFECYCLE                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   VISION                  BUILD                     SHIP                     │
│   ──────                  ─────                     ────                     │
│   /new-project            /build                    /ship                    │
│   /plan                   /debug                    /launch                  │
│   /design-review          /post-task                                         │
│                                                                              │
│   MAINTAIN                HANDOFF                   ADMIN                    │
│   ────────                ───────                   ─────                    │
│   /audit                  /handoff                  /update-docs             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Quick Reference

| Workflow | When to Use | Skills Used |
|----------|-------------|-------------|
| `/new-project` | Starting a brand new project | new_project |
| `/plan` | Planning a feature from vision doc | atomic_reverse_architecture, feature_braindump |
| `/design-review` | Review UI/UX before building | website_build |
| `/build` | Implementing a planned feature | feature_architecture, code_changelog |
| `/debug` | Fixing bugs or issues | bug_troubleshoot, claude_verification |
| `/post-task` | After completing ANY work | feature_walkthrough, project_context |
| `/ship` | Preparing for deployment | security_audit, website_launch |
| `/launch` | Go-live checklist | website_launch |
| `/audit` | Security or quality review | security_audit |
| `/handoff` | Passing work to another AI | gemini_handoff |

---

## The Build Loop

```text
┌──────────────────────┐
│ 1. PLAN              │  ← /plan workflow
│    Use ARA skill     │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ 2. DESIGN            │  ← /design-review workflow
│    Review UI/UX      │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ 3. BUILD             │  ← /build workflow
│    Implement         │
│    + /post-task      │  ← After each feature
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ 4. QUALITY           │  ← /audit workflow
│    Security review   │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ 5. SHIP              │  ← /ship + /launch
│    Deploy & go-live  │
└──────────────────────┘
```

---

## Skills → Workflow Mapping

| Phase | Skills Used |
|-------|-------------|
| **Pre-Build** | atomic_reverse_architecture, feature_braindump, new_project |
| **Build** | feature_architecture, code_changelog, website_build, schema_standards |
| **Post-Build** | feature_walkthrough, project_context |
| **Quality** | security_audit, claude_verification |
| **Ship** | website_launch |
| **Maintenance** | bug_troubleshoot, doc_reorganize |
| **Handoff** | gemini_handoff |

---

*Works for any project type: Web, Mobile, Games, Trading, Web3, AI/ML, IoT, and more.*
