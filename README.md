# AI Development Workflow Framework

> **100 Skills** | **67 Docs** | **18 Workflows** | **9 Blueprint Categories** | **Zero Fluff**

A battle-tested toolkit for AI-assisted development. Drop the `.agent` folder into any project and supercharge your workflow.

---

## ⚡ Quick Start

```bash
# Clone and copy to your project
git clone https://github.com/nickcarmonadigital/ai-dev-framework.git
cp -r ai-dev-workflow-framework/.agent ./your-project/
```

Your AI assistant will automatically detect and use these skills.

📖 **New here?** Start with [.agent/GETTING_STARTED.md](.agent/GETTING_STARTED.md)

---

## 🔄 The Master Lifecycle

The framework follows a strict Idea → Production → Growth lifecycle.

```mermaid
graph TD
    START((New Project)) --> P0

    subgraph "PHASE 0: CONTEXT"
        P0["/0-context<br/>Load or Create Project"]
        P0 --> P0a["new_project<br/>+ blueprint selection"]
        P0 --> P0b["project_context<br/>+ ai-onboarding-template"]
        P0a --> P0c["ssot_structure<br/>+ documentation_framework"]
        P0b --> P0c
    end

    P0c --> P1

    subgraph "PHASE 1: BRAINSTORM"
        P1["/1-brainstorm<br/>Raw Ideas → Structured Docs"]
        P1 --> P1a["idea_to_spec<br/>Brain dump → Full spec"]
        P1 --> P1b["client_discovery<br/>+ proposal_generator"]
        P1a --> P1c["Multi-AI review<br/>Cross-validate spec"]
        P1b --> P1c
    end

    P1c --> P2

    subgraph "PHASE 2: DESIGN"
        P2["/2-design<br/>Architecture & Planning"]
        P2 --> P2a["atomic_reverse_architecture<br/>First Principles + Reverse"]
        P2 --> P2b["feature_architecture<br/>+ schema_standards"]
        P2 --> P2c["deployment_modes<br/>Cloud/Hybrid/Sovereign"]
        P2a --> P2d["design-review workflow<br/>UI/UX approval"]
        P2b --> P2d
        P2c --> P2d
    end

    P2d --> P3

    subgraph "PHASE 3: BUILD"
        P3["/3-build<br/>Implementation"]
        P3 --> P3a["spec_build<br/>12-phase orchestrator"]
        P3a --> P3b["code_review<br/>+ bug_troubleshoot"]
        P3a --> P3c["observability<br/>Golden Signals + logging"]
        P3a --> P3d["ui_polish<br/>10-point checklist"]
        P3a --> P3e["website_build<br/>Anti-AI-slop standards"]
        P3b --> P3f["code_changelog<br/>+ post-task workflow"]
        P3c --> P3f
        P3d --> P3f
        P3e --> P3f
    end

    P3f --> P4

    subgraph "PHASE 4: TEST & SECURE"
        P4["/4-secure<br/>Quality & Security"]
        P4 --> P4a["🟢 security_audit<br/>OWASP Top 10"]
        P4 --> P4b["🟢 e2e_testing<br/>Playwright/Cypress"]
        P4 --> P4c["🟢 unit_testing<br/>Jest/Vitest"]
        P4 --> P4d["🟢 integration_testing<br/>Supertest"]
        P4 --> P4e["🟢 accessibility_testing<br/>WCAG AA"]
        P4 --> P4f["🟢 performance_testing<br/>k6/Lighthouse"]
        P4a --> P4g["ip_protection<br/>Patents/Trademarks"]
        P4b --> P4g
    end

    P4g --> P5

    subgraph "PHASE 5: SHIP"
        P5["/5-ship<br/>Deploy to Production"]
        P5 --> P5a["🟢 db_migrations<br/>Safe schema changes"]
        P5 --> P5b["🟢 infrastructure_as_code<br/>Docker/Terraform"]
        P5 --> P5c["🟢 website_launch<br/>Go-live checklist"]
        P5 --> P5d["🟢 ci_cd_pipeline<br/>GitHub Actions"]
        P5 --> P5e["🟢 legal_compliance<br/>ToS/Privacy"]
        P5 --> P5f["🟢 seed_data<br/>Demo data"]
    end

    P5c --> P6_ALPHA

    subgraph "PHASE 5.5: ALPHA OPS"
        P6_ALPHA["Alpha Release"]
        P6_ALPHA --> P6a["🟢 error_tracking<br/>Sentry setup"]
        P6_ALPHA --> P6b["🟢 health_checks<br/>Readiness endpoints"]
        P6_ALPHA --> P6c["🟢 env_validation<br/>Fail-fast startup"]
        P6_ALPHA --> P6d["🟢 qa_playbook<br/>Manual test script"]
        P6_ALPHA --> P6e["🟢 backup_strategy<br/>DB backups"]
    end

    P6a --> P6_BETA
    P6b --> P6_BETA
    P6c --> P6_BETA
    P6d --> P6_BETA
    P6e --> P6_BETA

    subgraph "PHASE 5.75: BETA OPS"
        P6_BETA["Beta Release"]
        P6_BETA --> P6f["🟢 product_analytics<br/>PostHog"]
        P6_BETA --> P6g["🟢 feedback_system<br/>Bug reporter"]
        P6_BETA --> P6h["🟢 email_templates<br/>Branded transactional"]
        P6_BETA --> P6i["🟢 error_boundaries<br/>UX resilience"]
        P6_BETA --> P6j["🟢 rate_limiting<br/>Throttler config"]
    end

    P6f --> P6

    subgraph "PHASE 6: HANDOFF"
        P6["/6-handoff<br/>Documentation & Transfer"]
        P6 --> P6k["🟢 feature_walkthrough<br/>Plain English docs"]
        P6 --> P6l["🟢 api_reference<br/>Swagger/OpenAPI"]
        P6 --> P6m["🟢 doc_reorganize<br/>Content cleanup"]
        P6 --> P6n["🟢 user_documentation<br/>Help center"]
        P6 --> P6o["🟢 disaster_recovery<br/>Runbook"]
    end

    P6k --> P7

    subgraph "PHASE 7: MAINTENANCE"
        P7["/7-maintenance<br/>Sustain & Grow"]
        P7 --> P7a["🟢 ssot_update<br/>Keep docs current"]
        P7 --> P7b["🟢 documentation_standards<br/>SOP/WI/Schema"]
        P7 --> P7c["🟢 sop_standards + wi_standards"]
        P7 --> P7d["🟢 dependency_management<br/>Audit + update cycle"]
    end

    P7 --> |"Next feature"| P1
    P7 --> |"Bug found"| DEBUG

    subgraph "TOOLKIT WORKFLOWS"
        DEBUG["/debug<br/>Structured troubleshooting"]
        OBS["/observability<br/>Monitoring strategy"]
        AGE["/age-commission<br/>25-loop gap analysis"]
        CONTENT["/content_production<br/>1 video → 30 clips"]
    end

    style P4c fill:#22c55e,color:#fff
    style P4d fill:#22c55e,color:#fff
    style P4e fill:#22c55e,color:#fff
    style P4f fill:#22c55e,color:#fff
    style P5d fill:#22c55e,color:#fff
    style P5e fill:#22c55e,color:#fff
    style P5f fill:#22c55e,color:#fff
    style P6a fill:#22c55e,color:#fff
    style P6b fill:#22c55e,color:#fff
    style P6c fill:#22c55e,color:#fff
    style P6d fill:#22c55e,color:#fff
    style P6e fill:#22c55e,color:#fff
    style P6f fill:#22c55e,color:#fff
    style P6g fill:#22c55e,color:#fff
    style P6h fill:#22c55e,color:#fff
    style P6i fill:#22c55e,color:#fff
    style P6j fill:#22c55e,color:#fff
    style P6n fill:#22c55e,color:#fff
    style P6o fill:#22c55e,color:#fff
    style P7d fill:#22c55e,color:#fff
```

---

## 📋 Phase-by-Phase Workflow

### PHASE 0: CONTEXT (Project Setup)

` /new-project ` or ` /0-context ` (if resuming)

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Pick blueprint | `new_project` + blueprint library | 🟢 Exists |
| Set up .agent folder | `ssot_structure` + `documentation_framework` | 🟢 Exists |
| Create project context | `project_context` + onboarding template | 🟢 Exists |

### PHASE 1: BRAINSTORM (Requirements)

` /1-brainstorm `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Brain dump → full spec | `idea_to_spec` | 🟢 Exists |
| Client intake (if client project) | `client_discovery` → `proposal_generator` | 🟢 Exists |
| Cross-AI validation | `idea_to_spec` Part 3 + `ai_tool_orchestration` | 🟢 Exists |
| **Prioritize features** | `prioritization_frameworks` | 🟢 PM Skill |
| **User stories** | `user_story_standards` | 🟢 PM Skill |
| **Metrics planning** | `product_metrics` | 🟢 PM Skill |

### PHASE 2: DESIGN (Architecture)

` /2-design `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Decompose into atoms | `atomic_reverse_architecture` | 🟢 Exists |
| Design data models | `schema_standards` | 🟢 Exists |
| Plan architecture | `feature_architecture` | 🟢 Exists |
| Verify deployment modes | `deployment_modes` | 🟢 Exists |
| Review UI/UX | `/design-review` workflow | 🟢 Exists |
| Threat modeling | `security_audit` (shift-left) | 🟢 Exists |

### PHASE 3: BUILD (Implementation)

` /3-build `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Orchestrate feature build | `spec_build` (12-phase) | 🟢 Exists |
| **Sprint planning** | `sprint_planning` | 🟢 PM Skill |
| Polish UI | `ui_polish` | 🟢 Exists |
| Review code | `code_review` | 🟢 Exists |
| Set up monitoring | `observability` | 🟢 Exists |
| Debug issues | `/debug` workflow | 🟢 Exists |
| Document changes | `code_changelog` + `/post-task` | 🟢 Exists |
| **Retrospectives** | `retrospective` | 🟢 PM Skill |

### PHASE 4: TEST & SECURE

` /4-secure `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Security audit (OWASP) | `security_audit` | 🟢 Exists |
| E2E browser tests | `e2e_testing` | 🟢 Exists |
| IP protection check | `ip_protection` | 🟢 Exists |
| **Unit tests** | `unit_testing` | 🟢 Created |
| **Integration tests** | `integration_testing` | 🟢 Created |
| **Accessibility audit** | `accessibility_testing` | 🟢 Created |
| **Load/performance tests** | `performance_testing` | 🟢 Created |

### PHASE 5: SHIP (Deploy)

` /5-ship `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Run migrations | `db_migrations` | 🟢 Exists |
| Set up infrastructure | `infrastructure_as_code` | 🟢 Exists |
| Pre-launch checklist | `website_launch` | 🟢 Exists |
| **CI/CD pipeline** | `ci_cd_pipeline` | 🟢 Created |
| **Legal pages** | `legal_compliance` | 🟢 Created |
| **Seed data** | `seed_data` | 🟢 Created |

### PHASE 5.5: ALPHA OPS (First Users)

` /alpha `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| **Error tracking (Sentry)** | `error_tracking` | 🟢 Created |
| **Health check endpoints** | `health_checks` | 🟢 Created |
| **Env var validation** | `env_validation` | 🟢 Created |
| **QA test playbook** | `qa_playbook` | 🟢 Created |
| **Backup verification** | `backup_strategy` | 🟢 Created |

### PHASE 5.75: BETA OPS (External Users)

` /beta `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| **Product analytics** | `product_analytics` | 🟢 Created |
| **In-app bug reporter** | `feedback_system` | 🟢 Created |
| **Rate limiting config** | `rate_limiting` | 🟢 Created |
| **Error boundaries + toasts** | `error_boundaries` | 🟢 Created |
| **Email templates** | `email_templates` | 🟢 Created |
| **Feature flags** | `feature_flags` | 🟢 PM Skill |

### PHASE 6: HANDOFF (Documentation & GA)

` /6-handoff ` + ` /launch `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| Feature walkthroughs | `feature_walkthrough` | 🟢 Exists |
| API documentation | `api_reference` | 🟢 Exists |
| Doc cleanup | `doc_reorganize` | 🟢 Exists |
| **User-facing help center** | `user_documentation` | 🟢 Created |
| **Disaster recovery** | `disaster_recovery` | 🟢 Created |
| Go live | `/launch` workflow | 🟢 Exists |

### PHASE 7: MAINTENANCE (Operate & Grow)

` /7-maintenance `

| Step | Skill/Workflow | Status |
|------|---------------|--------|
| SSoT updates | `ssot_update` | 🟢 Exists |
| SOP/WI/Schema docs | `documentation_standards` | 🟢 Exists |
| Bug fixing | `/debug` + `/7-maintenance` | 🟢 Exists |
| **Dependency audit** | `dependency_management` | 🟢 Created |

---

## 📚 What's Included

### Skills (100)

| Category | Skills |
|----------|--------|
| **Context (5)** | `new_project` `project_context` `documentation_framework` `ssot_structure` `codebase_navigation` |
| **Brainstorm (9)** | `client_discovery` `idea_to_spec` `proposal_generator` `smb_launchpad` `prioritization_frameworks` `user_story_standards` `competitive_analysis` `product_metrics` `user_research` |
| **Design (4)** | `atomic_reverse_architecture` `feature_architecture` `deployment_modes` `schema_standards` |
| **Build (32)** | `spec_build` `bug_troubleshoot` `website_build` `observability` `code_review` `ui_polish` `code_changelog` `git_workflow` `api_design` `error_handling` `auth_implementation` `docker_development` `environment_setup` `refactoring` `code_review_response` `database_optimization` `notification_systems` `sprint_planning` `stakeholder_communication` `retrospective` `cost_estimation` + 11 domain-specific |
| **Secure (9)** | `security_audit` `e2e_testing` `ip_protection` `unit_testing` `integration_testing` `accessibility_testing` `performance_testing` + 2 domain |
| **Ship (10)** | `infrastructure_as_code` `db_migrations` `website_launch` `ci_cd_pipeline` `legal_compliance` `seed_data` + 4 domain |
| **Alpha Ops (5)** | `error_tracking` `health_checks` `env_validation` `qa_playbook` `backup_strategy` |
| **Beta Ops (6)** | `product_analytics` `feedback_system` `email_templates` `error_boundaries` `rate_limiting` `feature_flags` |
| **Handoff (6)** | `api_reference` `feature_walkthrough` `doc_reorganize` `user_documentation` `disaster_recovery` `community_management` |
| **Maintenance (5)** | `ssot_update` `documentation_standards` `sop_standards` `wi_standards` `dependency_management` |
| **Toolkit (6)** | `video_research` `content_creation` `content_waterfall` `personal_brand` `ceo_brain` `ai_tool_orchestration` |

→ Full reference: [.agent/docs/skills-index.md](.agent/docs/skills-index.md)

### Guides (19)

| Guide | What You Get |
|-------|--------------|
| [**Prompt Library**](.agent/docs/prompt-library.md) | 50+ ready-to-use prompts |
| [**Code Snippets**](.agent/docs/code-snippets.md) | Copy-paste solutions |
| [**Skill Combos**](.agent/docs/skill-combos.md) | Power workflows |
| [**Common Mistakes**](.agent/docs/common-mistakes.md) | Avoid pitfalls |
| [**Project Templates**](.agent/docs/project-templates.md) | Starter structures |
| [**Tech Stack Guide**](.agent/docs/tech-stack-guide.md) | Decision framework |
| [**Development Workflow**](.agent/docs/development-workflow.md) | Complete process map |
| [**Glossary**](.agent/docs/glossary.md) | Quick term reference |

---

## 🚀 Example Usage

```
You: /idea-to-spec I need a user dashboard with analytics

AI: [Creates structured spec with user stories, tech requirements, and implementation plan]

You: /architecture dashboard

AI: [Generates comprehensive architecture doc with data flow, APIs, and component design]

You: Build it

AI: [Implements the feature following the spec]

You: /walkthrough dashboard

AI: [Creates documentation explaining how it works]
```

---

## 🧩 Skill Format

```markdown
---
name: Skill Name
description: What this skill does
---

# Skill Name

## 🎯 TRIGGER COMMANDS
[Commands to activate]

## When to Use
[Situations where this applies]

## The Process
[Step-by-step instructions]

## ✅ Checklist
[Completion criteria]
```

---

## 📁 Structure

```
.
├── README.md              # You are here (Merged Master Lifecycle)
├── MASTER-LIFECYCLE.md    # Full reference documentation
├── CLIENT_LIFECYCLE_GUIDE.md
└── .agent/
    ├── GETTING_STARTED.md     # 5-minute setup guide
    ├── skills/                # 100 skill folders (organized by phase)
    │   ├── bug_troubleshoot/
    │   ├── idea_to_spec/
    │   └── ...
    ├── workflows/             # 18 workflow definitions
    └── docs/                  # 67 reference guides + templates
        ├── prompt-library.md
        ├── code-snippets.md
        └── ...
```

---

## 🤝 Contributing

1. Fork the repo
2. Create a skill folder: `.agent/skills/[skill-name]/SKILL.md`
3. Follow the skill format above
4. Submit a PR

---

## 📜 License

MIT License - Use freely.
