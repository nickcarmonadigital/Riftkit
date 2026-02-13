# Skills Index

Complete list of all 90 skills in this framework, organized by lifecycle phase.

## Quick Reference

| # | Skill | Phase | Trigger Example |
|---|-------|-------|-----------------|
| 1 | `new_project` | 0-context | "I want to start a new project" |
| 2 | `project_context` | 0-context | "Update the project context" |
| 3 | `documentation_framework` | 0-context | "What docs do I need for [project]?" |
| 4 | `ssot_structure` | 0-context | "Create an SSoT for [business]" |
| 5 | `client_discovery` | 1-brainstorm | "Prepare for discovery call" |
| 6 | `feature_braindump` | 1-brainstorm | "Brain dump: [your idea]" |
| 7 | `gemini_handoff` | 1-brainstorm | "Here's the spec from Gemini: [paste]" |
| 8 | `idea_to_spec` | 1-brainstorm | "Turn this idea into a spec" |
| 9 | `proposal_generator` | 1-brainstorm | "Create a proposal for [client]" |
| 10 | `smb_launchpad` | 1-brainstorm | "SMB launch plan for [business]" |
| 11 | `prioritization_frameworks` | 1-brainstorm | "Score and rank features using RICE/MoSCoW" |
| 12 | `user_story_standards` | 1-brainstorm | "Write user stories and acceptance criteria" |
| 13 | `competitive_analysis` | 1-brainstorm | "Analyze competitors and find market gaps" |
| 14 | `product_metrics` | 1-brainstorm | "Choose KPIs and North Star metric" |
| 15 | `atomic_reverse_architecture` | 2-design | "Decompose [feature] into atoms" |
| 12 | `feature_architecture` | 2-design | "Document the [feature] architecture" |
| 13 | `deployment_modes` | 2-design | "Plan deployment modes for [app]" |
| 14 | `schema_standards` | 2-design | "Create a schema for [table]" |
| 15 | `spec_build` | 3-build | "Build [feature] from spec" |
| 16 | `bug_troubleshoot` | 3-build | "Bug: [description]" |
| 17 | `claude_verification` | 3-build | "Review this code: [paste]" |
| 18 | `website_build` | 3-build | "Build a website for [client]" |
| 19 | `observability` | 3-build | "Set up monitoring for [service]" |
| 20 | `code_review` | 3-build | "Code review for [feature]" |
| 21 | `ui_polish` | 3-build | "Polish the UI for [page]" |
| 22 | `code_changelog` | 3-build | "Log the changes I just made" |
| 23 | `sprint_planning` | 3-build | "Break features into sprints" |
| 24 | `stakeholder_communication` | 3-build | "Write status updates and roadmaps" |
| 25 | `retrospective` | 3-build | "Run a sprint retro or post-mortem" |
| 26 | `cost_estimation` | 3-build | "Estimate project costs and budget" |
| 27 | `game_development` | 3-build | "Build a game / game architecture" |
| 24 | `multiplayer_systems` | 3-build | "Add multiplayer / netcode" |
| 25 | `smart_contract_dev` | 3-build | "Build smart contract / Solidity" |
| 26 | `dapp_development` | 3-build | "Build dApp / connect wallet" |
| 27 | `ml_pipeline` | 3-build | "Build ML pipeline / train model" |
| 28 | `prompt_engineering` | 3-build | "Design prompts / build RAG system" |
| 29 | `firmware_development` | 3-build | "Build firmware / embedded dev" |
| 30 | `iot_platform` | 3-build | "Build IoT platform / connect devices" |
| 31 | `etl_pipeline` | 3-build | "Build ETL pipeline / data pipeline" |
| 32 | `data_warehouse` | 3-build | "Design data warehouse / star schema" |
| 33 | `trading_systems` | 3-build | "Build trading bot / backtesting" |
| 34 | `extension_development` | 3-build | "Build browser extension / VS Code plugin" |
| 35 | `dashboard_development` | 3-build | "Build analytics dashboard" |
| 36 | `security_audit` | 4-secure | "Security audit for [feature]" |
| 37 | `e2e_testing` | 4-secure | "Write E2E tests for [flow]" |
| 38 | `ip_protection` | 4-secure | "Check IP protection for [project]" |
| 39 | `unit_testing` | 4-secure | "Write unit tests for [service]" |
| 40 | `integration_testing` | 4-secure | "Write API integration tests" |
| 41 | `accessibility_testing` | 4-secure | "Run accessibility audit" |
| 42 | `performance_testing` | 4-secure | "Load test the API" |
| 43 | `web3_security` | 4-secure | "Audit smart contract security" |
| 44 | `financial_compliance` | 4-secure | "Financial regulatory compliance" |
| 45 | `infrastructure_as_code` | 5-ship | "Set up infrastructure for [app]" |
| 46 | `db_migrations` | 5-ship | "Plan database migration" |
| 47 | `website_launch` | 5-ship | "Website launch checklist" |
| 48 | `ci_cd_pipeline` | 5-ship | "Set up CI/CD with GitHub Actions" |
| 49 | `legal_compliance` | 5-ship | "Create legal pages (ToS, Privacy)" |
| 50 | `seed_data` | 5-ship | "Create seed data for demos" |
| 51 | `desktop_publishing` | 5-ship | "Package desktop app / code sign" |
| 52 | `oss_publishing` | 5-ship | "Publish open source / npm package" |
| 53 | `game_publishing` | 5-ship | "Submit to Steam / App Store" |
| 54 | `mlops` | 5-ship | "Deploy ML model / model serving" |
| 55 | `error_tracking` | 5.5-alpha | "Set up Sentry error tracking" |
| 56 | `health_checks` | 5.5-alpha | "Add health check endpoints" |
| 57 | `env_validation` | 5.5-alpha | "Validate environment variables" |
| 58 | `qa_playbook` | 5.5-alpha | "Create QA test playbook" |
| 59 | `backup_strategy` | 5.5-alpha | "Set up database backups" |
| 60 | `product_analytics` | 5.75-beta | "Set up PostHog analytics" |
| 61 | `feedback_system` | 5.75-beta | "Add in-app bug reporter" |
| 62 | `email_templates` | 5.75-beta | "Create branded email templates" |
| 63 | `error_boundaries` | 5.75-beta | "Add error boundaries and toasts" |
| 64 | `rate_limiting` | 5.75-beta | "Configure API rate limiting" |
| 65 | `feature_flags` | 5.75-beta | "Set up feature flags and gradual rollout" |
| 66 | `api_reference` | 6-handoff | "Generate API documentation" |
| 66 | `feature_walkthrough` | 6-handoff | "Create a walkthrough for [feature]" |
| 67 | `doc_reorganize` | 6-handoff | "Reorganize project documentation" |
| 68 | `user_documentation` | 6-handoff | "Create help center / user guides" |
| 69 | `disaster_recovery` | 6-handoff | "Create disaster recovery runbook" |
| 70 | `community_management` | 6-handoff | "Set up open source community" |
| 71 | `ssot_update` | 7-maintenance | "Update the SSoT" |
| 72 | `documentation_standards` | 7-maintenance | "Review documentation standards" |
| 73 | `sop_standards` | 7-maintenance | "Create an SOP for [process]" |
| 74 | `wi_standards` | 7-maintenance | "Create a Work Instruction for [task]" |
| 75 | `dependency_management` | 7-maintenance | "Audit npm dependencies" |
| 76 | `video_research` | toolkit | "Research viral hooks for [niche]" |
| 77 | `content_creation` | toolkit | "Write a script for [topic]" |
| 78 | `content_waterfall` | toolkit | "Extract shorts from [video]" |
| 79 | `personal_brand` | toolkit | "Build personal brand strategy" |
| 80 | `ceo_brain` | toolkit | "Strategic analysis for [topic]" |
| 81 | `ai_tool_orchestration` | toolkit | "Choose and chain AI tools for workflows" |

---

## Skills by Phase

```
.agent/skills/
├── 0-context/                    (4 skills)
│   ├── new_project/
│   ├── project_context/
│   ├── documentation_framework/
│   └── ssot_structure/
├── 1-brainstorm/                 (10 skills) ← was 6, added 4 PM-focused
│   ├── client_discovery/
│   ├── feature_braindump/
│   ├── gemini_handoff/
│   ├── idea_to_spec/
│   ├── proposal_generator/
│   ├── smb_launchpad/
│   ├── prioritization_frameworks/  ★ PM: RICE, MoSCoW, Kano
│   ├── user_story_standards/       ★ PM: Stories, Gherkin, JTBD
│   ├── competitive_analysis/       ★ PM: Market & competitor analysis
│   └── product_metrics/            ★ PM: KPIs, North Star, AARRR
├── 2-design/                     (4 skills)
│   ├── atomic_reverse_architecture/
│   ├── feature_architecture/
│   ├── deployment_modes/
│   └── schema_standards/
├── 3-build/                      (23 skills) ← was 19, added 4 PM-focused
│   ├── spec_build/
│   ├── bug_troubleshoot/
│   ├── claude_verification/
│   ├── website_build/
│   ├── observability/
│   ├── code_review/
│   ├── ui_polish/
│   ├── code_changelog/
│   ├── sprint_planning/            ★ PM: Iterations, estimation, velocity
│   ├── stakeholder_communication/  ★ PM: Status updates, RACI, roadmaps
│   ├── retrospective/              ★ PM: Retros, post-mortems, 5 Whys
│   ├── cost_estimation/            ★ PM: Budgets, token costs, pricing
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
├── 4-secure/                     (9 skills) ← was 7, added 2 domain-specific
│   ├── security_audit/
│   ├── e2e_testing/
│   ├── ip_protection/
│   ├── unit_testing/
│   ├── integration_testing/
│   ├── accessibility_testing/
│   ├── performance_testing/
│   ├── web3_security/            ★ DOMAIN: Web3
│   └── financial_compliance/     ★ DOMAIN: Trading & Finance
├── 5-ship/                       (10 skills) ← was 6, added 4 domain-specific
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
├── 5.75-beta/                    (6 skills) ← was 5, added 1 PM-focused
│   ├── product_analytics/
│   ├── feedback_system/
│   ├── email_templates/
│   ├── error_boundaries/
│   ├── rate_limiting/
│   └── feature_flags/              ★ PM: Gradual rollout, A/B testing
├── 6-handoff/                    (6 skills) ← was 5, added 1 domain-specific
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
└── toolkit/                      (6 skills) ← was 5, added 1 PM-focused
    ├── video_research/
    ├── content_creation/
    ├── content_waterfall/
    ├── personal_brand/
    ├── ceo_brain/
    └── ai_tool_orchestration/      ★ PM: Multi-AI workflows, tool selection
```

**Total: 90 skills** (40 original + 20 lifecycle + 20 domain-specific + 10 PM-focused)

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
| 5 | client-discovery-template | 1-brainstorm | Original |
| 6 | proposal-template | 1-brainstorm | Original |
| 7 | **prioritization-matrix** | **1-brainstorm** | **NEW — PM** |
| 8 | **user-story-template** | **1-brainstorm** | **NEW — PM** |
| 9 | **competitive-analysis-template** | **1-brainstorm** | **NEW — PM** |
| 10 | **product-metrics-template** | **1-brainstorm** | **NEW — PM** |
| 11 | ara-template | 2-design | Original |
| 8 | frontend-architect-standards | 2-design | Original |
| 9 | tech-stack-guide | 2-design | Original |
| 10 | code-snippets | 3-build | Original |
| 11 | common-mistakes | 3-build | Original |
| 12 | project-templates | 3-build | Original |
| 13 | prompt-library | 3-build | Original |
| 14 | skill-combos | 3-build | Original |
| 15 | website-build-checklist | 3-build | Original |
| 16 | **sprint-planning-template** | **3-build** | **NEW — PM** |
| 17 | **stakeholder-update-template** | **3-build** | **NEW — PM** |
| 18 | **retrospective-template** | **3-build** | **NEW — PM** |
| 19 | **cost-estimation-template** | **3-build** | **NEW — PM** |
| 20 | security-audit-template | 4-secure | Original |
| 17 | **unit-test-patterns** | **4-secure** | **NEW** |
| 18 | website-launch-checklist-template | 5-ship | Original |
| 19 | industry-compliance-ref | 5-ship | Original |
| 20 | **ci-cd-templates** | **5-ship** | **NEW** |
| 21 | **legal-page-templates** | **5-ship** | **NEW** |
| 22 | **alpha-readiness-checklist** | **5-ship** | **NEW** |
| 23 | **beta-readiness-checklist** | **5-ship** | **NEW** |
| 24 | **ga-readiness-checklist** | **5-ship** | **NEW** |
| 25 | **analytics-event-taxonomy** | **5-ship** | **NEW** |
| 26 | **feature-flag-checklist** | **5-ship** | **NEW — PM** |
| 27 | feature-walkthrough-template | 6-handoff | Original |
| 27 | **disaster-recovery-template** | **6-handoff** | **NEW** |
| 28 | ssot-master-index | 7-maintenance | Original |
| 29-33 | SOPs (5) | sops | Original |
| 34 | long-form-video-protocol | toolkit | Original |
| 35 | **ai-tool-comparison** | **toolkit** | **NEW — PM** |

**Total: 56 documents** (38 original + 8 lifecycle + 10 PM-focused)

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

*Updated: February 2026 — v5.0 (90 skills, 18 workflows, 56 documents)*
