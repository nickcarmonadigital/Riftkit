# Skills Index

Complete list of all 100 skills in this framework, organized by lifecycle phase.

## Quick Reference

| # | Skill | Phase | Trigger Example |
|---|-------|-------|-----------------|
| 1 | `new_project` | 0-context | "I want to start a new project" |
| 2 | `project_context` | 0-context | "Update the project context" |
| 3 | `documentation_framework` | 0-context | "What docs do I need for [project]?" |
| 4 | `ssot_structure` | 0-context | "Create an SSoT for [business]" |
| 5 | `codebase_navigation` | 0-context | "Help me understand this codebase" |
| 6 | `client_discovery` | 1-brainstorm | "Prepare for discovery call" |
| 7 | `idea_to_spec` | 1-brainstorm | "Turn this idea into a spec" |
| 8 | `proposal_generator` | 1-brainstorm | "Create a proposal for [client]" |
| 9 | `smb_launchpad` | 1-brainstorm | "SMB launch plan for [business]" |
| 10 | `prioritization_frameworks` | 1-brainstorm | "Score and rank features using RICE/MoSCoW" |
| 11 | `user_story_standards` | 1-brainstorm | "Write user stories and acceptance criteria" |
| 12 | `competitive_analysis` | 1-brainstorm | "Analyze competitors and find market gaps" |
| 13 | `product_metrics` | 1-brainstorm | "Choose KPIs and North Star metric" |
| 14 | `user_research` | 1-brainstorm | "Validate assumptions with user interviews" |
| 15 | `atomic_reverse_architecture` | 2-design | "Decompose [feature] into atoms" |
| 15 | `feature_architecture` | 2-design | "Document the [feature] architecture" |
| 16 | `deployment_modes` | 2-design | "Plan deployment modes for [app]" |
| 17 | `schema_standards` | 2-design | "Create a schema for [table]" |
| 18 | `spec_build` | 3-build | "Build [feature] from spec" |
| 19 | `bug_troubleshoot` | 3-build | "Bug: [description]" |
| 20 | `website_build` | 3-build | "Build a website for [client]" |
| 21 | `observability` | 3-build | "Set up monitoring for [service]" |
| 22 | `code_review` | 3-build | "Code review for [feature]" |
| 23 | `ui_polish` | 3-build | "Polish the UI for [page]" |
| 24 | `code_changelog` | 3-build | "Log the changes I just made" |
| 25 | `sprint_planning` | 3-build | "Break features into sprints" |
| 26 | `stakeholder_communication` | 3-build | "Write status updates and roadmaps" |
| 27 | `retrospective` | 3-build | "Run a sprint retro or post-mortem" |
| 28 | `cost_estimation` | 3-build | "Estimate project costs and budget" |
| 29 | `git_workflow` | 3-build | "Set up Git branching strategy" |
| 30 | `api_design` | 3-build | "Design REST API for [resource]" |
| 31 | `error_handling` | 3-build | "Add error handling to [service]" |
| 32 | `auth_implementation` | 3-build | "Implement JWT authentication" |
| 33 | `docker_development` | 3-build | "Dockerize this project" |
| 34 | `environment_setup` | 3-build | "Set up development environment" |
| 35 | `refactoring` | 3-build | "Refactor [service] for maintainability" |
| 36 | `code_review_response` | 3-build | "How do I respond to this code review?" |
| 37 | `database_optimization` | 3-build | "This query is slow, help me optimize" |
| 38 | `notification_systems` | 3-build | "Set up email/push/in-app notifications" |
| 38 | `game_development` | 3-build | "Build a game / game architecture" |
| 39 | `multiplayer_systems` | 3-build | "Add multiplayer / netcode" |
| 40 | `smart_contract_dev` | 3-build | "Build smart contract / Solidity" |
| 41 | `dapp_development` | 3-build | "Build dApp / connect wallet" |
| 42 | `ml_pipeline` | 3-build | "Build ML pipeline / train model" |
| 43 | `prompt_engineering` | 3-build | "Design prompts / build RAG system" |
| 44 | `firmware_development` | 3-build | "Build firmware / embedded dev" |
| 45 | `iot_platform` | 3-build | "Build IoT platform / connect devices" |
| 46 | `etl_pipeline` | 3-build | "Build ETL pipeline / data pipeline" |
| 47 | `data_warehouse` | 3-build | "Design data warehouse / star schema" |
| 48 | `trading_systems` | 3-build | "Build trading bot / backtesting" |
| 49 | `extension_development` | 3-build | "Build browser extension / VS Code plugin" |
| 50 | `dashboard_development` | 3-build | "Build analytics dashboard" |
| 51 | `security_audit` | 4-secure | "Security audit for [feature]" |
| 52 | `e2e_testing` | 4-secure | "Write E2E tests for [flow]" |
| 53 | `ip_protection` | 4-secure | "Check IP protection for [project]" |
| 54 | `unit_testing` | 4-secure | "Write unit tests for [service]" |
| 55 | `integration_testing` | 4-secure | "Write API integration tests" |
| 56 | `accessibility_testing` | 4-secure | "Run accessibility audit" |
| 57 | `performance_testing` | 4-secure | "Load test the API" |
| 58 | `web3_security` | 4-secure | "Audit smart contract security" |
| 59 | `financial_compliance` | 4-secure | "Financial regulatory compliance" |
| 60 | `infrastructure_as_code` | 5-ship | "Set up infrastructure for [app]" |
| 61 | `db_migrations` | 5-ship | "Plan database migration" |
| 62 | `website_launch` | 5-ship | "Website launch checklist" |
| 63 | `ci_cd_pipeline` | 5-ship | "Set up CI/CD with GitHub Actions" |
| 64 | `legal_compliance` | 5-ship | "Create legal pages (ToS, Privacy)" |
| 65 | `seed_data` | 5-ship | "Create seed data for demos" |
| 66 | `desktop_publishing` | 5-ship | "Package desktop app / code sign" |
| 67 | `oss_publishing` | 5-ship | "Publish open source / npm package" |
| 68 | `game_publishing` | 5-ship | "Submit to Steam / App Store" |
| 69 | `mlops` | 5-ship | "Deploy ML model / model serving" |
| 70 | `error_tracking` | 5.5-alpha | "Set up Sentry error tracking" |
| 71 | `health_checks` | 5.5-alpha | "Add health check endpoints" |
| 72 | `env_validation` | 5.5-alpha | "Validate environment variables" |
| 73 | `qa_playbook` | 5.5-alpha | "Create QA test playbook" |
| 74 | `backup_strategy` | 5.5-alpha | "Set up database backups" |
| 75 | `product_analytics` | 5.75-beta | "Set up PostHog analytics" |
| 76 | `feedback_system` | 5.75-beta | "Add in-app bug reporter" |
| 77 | `email_templates` | 5.75-beta | "Create branded email templates" |
| 78 | `error_boundaries` | 5.75-beta | "Add error boundaries and toasts" |
| 79 | `rate_limiting` | 5.75-beta | "Configure API rate limiting" |
| 80 | `feature_flags` | 5.75-beta | "Set up feature flags and gradual rollout" |
| 81 | `api_reference` | 6-handoff | "Generate API documentation" |
| 82 | `feature_walkthrough` | 6-handoff | "Create a walkthrough for [feature]" |
| 83 | `doc_reorganize` | 6-handoff | "Reorganize project documentation" |
| 84 | `user_documentation` | 6-handoff | "Create help center / user guides" |
| 85 | `disaster_recovery` | 6-handoff | "Create disaster recovery runbook" |
| 86 | `community_management` | 6-handoff | "Set up open source community" |
| 87 | `ssot_update` | 7-maintenance | "Update the SSoT" |
| 88 | `documentation_standards` | 7-maintenance | "Review documentation standards" |
| 89 | `sop_standards` | 7-maintenance | "Create an SOP for [process]" |
| 90 | `wi_standards` | 7-maintenance | "Create a Work Instruction for [task]" |
| 91 | `dependency_management` | 7-maintenance | "Audit npm dependencies" |
| 92 | `video_research` | toolkit | "Research viral hooks for [niche]" |
| 93 | `content_creation` | toolkit | "Write a script for [topic]" |
| 94 | `content_waterfall` | toolkit | "Extract shorts from [video]" |
| 95 | `personal_brand` | toolkit | "Build personal brand strategy" |
| 96 | `ceo_brain` | toolkit | "Strategic analysis for [topic]" |
| 97 | `ai_tool_orchestration` | toolkit | "Choose and chain AI tools for workflows" |

---

## Skills by Phase

```
.agent/skills/
├── 0-context/                    (5 skills)
│   ├── new_project/
│   ├── project_context/
│   ├── documentation_framework/
│   ├── ssot_structure/
│   └── codebase_navigation/       ★ NEW: Navigate unfamiliar codebases
├── 1-brainstorm/                 (9 skills)
│   ├── client_discovery/
│   ├── idea_to_spec/
│   ├── proposal_generator/
│   ├── smb_launchpad/
│   ├── prioritization_frameworks/  ★ PM: RICE, MoSCoW, Kano
│   ├── user_story_standards/       ★ PM: Stories, Gherkin, JTBD
│   ├── competitive_analysis/       ★ PM: Market & competitor analysis
│   ├── product_metrics/            ★ PM: KPIs, North Star, AARRR
│   └── user_research/              ★ NEW: Interviews, usability testing, synthesis
├── 2-design/                     (4 skills)
│   ├── atomic_reverse_architecture/
│   ├── feature_architecture/
│   ├── deployment_modes/
│   └── schema_standards/
├── 3-build/                      (34 skills)
│   ├── spec_build/
│   ├── bug_troubleshoot/
│   ├── website_build/
│   ├── observability/
│   ├── code_review/
│   ├── ui_polish/
│   ├── code_changelog/
│   ├── sprint_planning/            ★ PM: Iterations, estimation, velocity
│   ├── stakeholder_communication/  ★ PM: Status updates, RACI, roadmaps
│   ├── retrospective/              ★ PM: Retros, post-mortems, 5 Whys
│   ├── cost_estimation/            ★ PM: Budgets, token costs, pricing
│   ├── git_workflow/              ★ NEW: Branching, commits, PRs, recovery
│   ├── api_design/                ★ NEW: RESTful API patterns with NestJS
│   ├── error_handling/            ★ NEW: Exception filters, Prisma errors
│   ├── auth_implementation/       ★ NEW: JWT, RBAC, OAuth, security
│   ├── docker_development/        ★ NEW: Dockerfiles, docker-compose
│   ├── environment_setup/         ★ NEW: ESLint, Prettier, Husky, .env
│   ├── refactoring/               ★ NEW: Code smells, extract patterns
│   ├── code_review_response/      ★ NEW: Receiving and responding to reviews
│   ├── database_optimization/     ★ NEW: Indexes, N+1, EXPLAIN, pooling
│   ├── notification_systems/     ★ NEW: Email, push, in-app, webhooks
│   ├── game_development/         ★ DOMAIN: Games
│   ├── multiplayer_systems/      ★ DOMAIN: Games
│   ├── smart_contract_dev/       ★ DOMAIN: Web3
│   ├── dapp_development/         ★ DOMAIN: Web3
│   ├── ml_pipeline/              ★ DOMAIN: AI & ML
│   ├── prompt_engineering/       ★ DOMAIN: AI & ML
│   ├── firmware_development/     ★ DOMAIN: Hardware & IoT
│   ├── iot_platform/             ★ DOMAIN: Hardware & IoT
│   ├── etl_pipeline/             ★ DOMAIN: Data & Analytics
│   ├── data_warehouse/           ★ DOMAIN: Data & Analytics
│   ├── trading_systems/          ★ DOMAIN: Trading & Finance
│   ├── extension_development/    ★ DOMAIN: Plugins & Extensions
│   └── dashboard_development/    ★ DOMAIN: Data & Analytics
├── 4-secure/                     (9 skills)
│   ├── security_audit/
│   ├── e2e_testing/
│   ├── ip_protection/
│   ├── unit_testing/
│   ├── integration_testing/
│   ├── accessibility_testing/
│   ├── performance_testing/
│   ├── web3_security/            ★ DOMAIN: Web3
│   └── financial_compliance/     ★ DOMAIN: Trading & Finance
├── 5-ship/                       (10 skills)
│   ├── infrastructure_as_code/
│   ├── db_migrations/
│   ├── website_launch/
│   ├── ci_cd_pipeline/
│   ├── legal_compliance/
│   ├── seed_data/
│   ├── desktop_publishing/       ★ DOMAIN: Desktop Apps
│   ├── oss_publishing/           ★ DOMAIN: Open Source
│   ├── game_publishing/          ★ DOMAIN: Games
│   └── mlops/                    ★ DOMAIN: AI & ML
├── 5.5-alpha/                    (5 skills)
│   ├── error_tracking/
│   ├── health_checks/
│   ├── env_validation/
│   ├── qa_playbook/
│   └── backup_strategy/
├── 5.75-beta/                    (6 skills)
│   ├── product_analytics/
│   ├── feedback_system/
│   ├── email_templates/
│   ├── error_boundaries/
│   ├── rate_limiting/
│   └── feature_flags/              ★ PM: Gradual rollout, A/B testing
├── 6-handoff/                    (6 skills)
│   ├── api_reference/
│   ├── feature_walkthrough/
│   ├── doc_reorganize/
│   ├── user_documentation/
│   ├── disaster_recovery/
│   └── community_management/     ★ DOMAIN: Open Source
├── 7-maintenance/                (5 skills)
│   ├── ssot_update/
│   ├── documentation_standards/
│   ├── sop_standards/
│   ├── wi_standards/
│   └── dependency_management/
└── toolkit/                      (6 skills)
    ├── video_research/
    ├── content_creation/
    ├── content_waterfall/
    ├── personal_brand/
    ├── ceo_brain/
    └── ai_tool_orchestration/      ★ PM: Multi-AI workflows, tool selection
```

**Total: 100 skills** (40 original + 20 lifecycle + 20 domain-specific + 10 PM-focused + 12 full-stack dev + 1 navigation - 3 deleted)

---

## Domain Skills by Blueprint Category

Skills that cover specific project types from the blueprint library:

| Blueprint Category | Skills | Phase |
|-------------------|--------|-------|
| **01 — Web & Apps** | All lifecycle skills + `desktop_publishing` | All |
| **02 — Games** | `game_development`, `multiplayer_systems`, `game_publishing` | 3-build, 5-ship |
| **03 — Trading & Finance** | `trading_systems`, `financial_compliance` | 3-build, 4-secure |
| **04 — Web3 & Blockchain** | `smart_contract_dev`, `dapp_development`, `web3_security` | 3-build, 4-secure |
| **05 — AI & ML** | `ml_pipeline`, `prompt_engineering`, `mlops` | 3-build, 5-ship |
| **06 — Hardware & IoT** | `firmware_development`, `iot_platform` | 3-build |
| **07 — Automation & DevOps** | `ci_cd_pipeline`, `infrastructure_as_code`, `observability` | 3-build, 5-ship |
| **08 — Plugins & Extensions** | `extension_development` | 3-build |
| **09 — Data & Analytics** | `etl_pipeline`, `data_warehouse`, `dashboard_development` | 3-build |
| **Open Source** | `oss_publishing`, `community_management` | 5-ship, 6-handoff |

---

## Full-Stack Developer Skills

Skills specifically covering core full-stack development fundamentals:

| Skill | What It Covers |
|-------|---------------|
| `codebase_navigation` | First 30 minutes in an unfamiliar codebase |
| `git_workflow` | Branching, commits, PRs, conflict resolution, recovery |
| `api_design` | RESTful patterns, pagination, validation, versioning |
| `error_handling` | NestJS exceptions, Prisma errors, frontend error states |
| `auth_implementation` | JWT, refresh tokens, RBAC, OAuth, password security |
| `docker_development` | Dockerfiles, docker-compose, hot reload, debugging |
| `environment_setup` | ESLint, Prettier, Husky, .env management |
| `refactoring` | Code smells, extract patterns, safe refactoring process |
| `code_review_response` | Receiving reviews, responding to feedback, growing |
| `database_optimization` | Indexes, N+1 detection, EXPLAIN, connection pooling |

---

## Workflows Index

| # | Workflow | Command | Phase | Status |
|---|---------|---------|-------|--------|
| 1 | Context | `/0-context` | 0 | Original |
| 2 | New Project | `/new-project` | 0 | Original |
| 3 | Brainstorm | `/1-brainstorm` | 1 | Original |
| 4 | Design | `/2-design` | 2 | Original |
| 5 | Design Review | `/design-review` | 2 | Original |
| 6 | Build | `/3-build` | 3 | Original |
| 7 | Debug | `/debug` | 3 | Original |
| 8 | Post-Task | `/post-task` | 3 | Original |
| 9 | Secure | `/4-secure` | 4 | Original |
| 10 | Ship | `/5-ship` | 5 | Original |
| 11 | Launch | `/launch` | 5 | Original |
| 12 | **Alpha Release** | **`/alpha`** | **5.5** | **NEW** |
| 13 | **Beta Release** | **`/beta`** | **5.75** | **NEW** |
| 14 | Handoff | `/6-handoff` | 6 | Original |
| 15 | Maintenance | `/7-maintenance` | 7 | Original |
| 16 | Observability | `/observability` | toolkit | Original |
| 17 | AGE Commission | `/age-commission` | toolkit | Original |
| 18 | Content Production | `/content_production` | toolkit | Original |

**Total: 18 workflows** (16 original + 2 new)

---

## Documents Index

| # | Document | Phase | Status |
|---|----------|-------|--------|
| 1 | ai-onboarding-template (2) | 0-context | Original |
| 2 | glossary | 0-context | Original |
| 3 | master-workflow-guide | 0-context | Original |
| 4 | project-workflow-checklist | 0-context | Original |
| 5 | **full-stack-developer-foundation** | **0-context** | **NEW — WHY document** |
| 6 | **enterprise-development-guide** | **0-context** | **NEW — Enterprise patterns** |
| 7 | client-discovery-template | 1-brainstorm | Original |
| 8 | proposal-template | 1-brainstorm | Original |
| 9 | **prioritization-matrix** | **1-brainstorm** | **NEW — PM** |
| 10 | **user-story-template** | **1-brainstorm** | **NEW — PM** |
| 11 | **competitive-analysis-template** | **1-brainstorm** | **NEW — PM** |
| 12 | **product-metrics-template** | **1-brainstorm** | **NEW — PM** |
| 13 | ara-template | 2-design | Original |
| 14 | frontend-architect-standards | 2-design | Original |
| 15 | tech-stack-guide | 2-design | Original |
| 16 | **state-management-guide** | **2-design** | **NEW — React state patterns** |
| 17 | **css-tailwind-patterns** | **2-design** | **NEW — Layout & components** |
| 18 | **architecture-trigger-map** | **2-design** | **NEW — When to use what technology** |
| 19 | code-snippets | 3-build | Original |
| 19 | common-mistakes | 3-build | Original |
| 20 | project-templates | 3-build | Original |
| 21 | prompt-library | 3-build | Original |
| 22 | skill-combos | 3-build | Original |
| 23 | website-build-checklist | 3-build | Original |
| 24 | **http-fundamentals** | **3-build** | **NEW — Methods, status codes, CORS** |
| 25 | **typescript-patterns** | **3-build** | **NEW — Generics, utility types** |
| 26 | **terminal-essentials** | **3-build** | **NEW — CLI, SSH, curl** |
| 27 | **code-architecture-patterns** | **3-build** | **NEW — SOLID, DI, design patterns** |
| 28 | **browser-devtools-guide** | **3-build** | **NEW — Chrome DevTools debugging** |
| 29 | **sprint-planning-template** | **3-build** | **NEW — PM** |
| 30 | **stakeholder-update-template** | **3-build** | **NEW — PM** |
| 31 | **retrospective-template** | **3-build** | **NEW — PM** |
| 32 | **cost-estimation-template** | **3-build** | **NEW — PM** |
| 33 | security-audit-template | 4-secure | Original |
| 34 | **unit-test-patterns** | **4-secure** | **NEW** |
| 35 | website-launch-checklist-template | 5-ship | Original |
| 36 | industry-compliance-ref | 5-ship | Original |
| 37 | **ci-cd-templates** | **5-ship** | **NEW** |
| 38 | **legal-page-templates** | **5-ship** | **NEW** |
| 39 | **alpha-readiness-checklist** | **5-ship** | **NEW** |
| 40 | **beta-readiness-checklist** | **5-ship** | **NEW** |
| 41 | **ga-readiness-checklist** | **5-ship** | **NEW** |
| 42 | **analytics-event-taxonomy** | **5-ship** | **NEW** |
| 43 | **feature-flag-checklist** | **5-ship** | **NEW — PM** |
| 44 | feature-walkthrough-template | 6-handoff | Original |
| 45 | **disaster-recovery-template** | **6-handoff** | **NEW** |
| 46 | ssot-master-index | 7-maintenance | Original |
| 47-51 | SOPs (5) | sops | Original |
| 52 | long-form-video-protocol | toolkit | Original |
| 53 | **ai-tool-comparison** | **toolkit** | **NEW — PM** |
| 54 | **roadmap-planning-template** | **2-design** | **NEW — Now/Next/Later roadmaps** |

**Total: 67 documents** (38 original + 8 lifecycle + 10 PM-focused + 11 full-stack dev)

---

## How to Use

1. Read the skill's `SKILL.md` file
2. Use one of the trigger commands
3. Follow the process steps
4. Complete the exit checklist

## Adding New Skills

Create: `.agent/skills/[phase]/[your-skill]/SKILL.md`

Required sections:

- YAML frontmatter (name, description)
- Trigger commands
- When to use
- Step-by-step process
- Completion checklist

---

*Updated: February 2026 — v6.1 (100 skills, 18 workflows, 67 documents)*
