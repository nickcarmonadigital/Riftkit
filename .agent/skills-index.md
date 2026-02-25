# Skills Index

Complete list of all 228 skills in this framework, organized by lifecycle phase.

## Quick Reference

| # | Skill | Phase | Trigger Example |
|---|-------|-------|-----------------|
| 1 | `architecture_recovery` | 0-context | "Reverse-engineer this architecture" |
| 2 | `codebase_health_audit` | 0-context | "Run a health audit" |
| 3 | `codebase_navigation` | 0-context | "Help me understand this codebase" |
| 4 | `compliance_context` | 0-context | "What compliance requirements apply" |
| 5 | `dev_environment_setup` | 0-context | "Set up local development environment" |
| 6 | `documentation_framework` | 0-context | "What docs do I need for [project]?" |
| 7 | `incident_history_review` | 0-context | "Review incident history" |
| 8 | `infrastructure_audit` | 0-context | "Audit the infrastructure" |
| 9 | `legacy_modernization` | 0-context | "Modernize this legacy code" |
| 10 | `new_project` | 0-context | "I want to start a new project" |
| 11 | `phase_0_playbook` | 0-context | "I'm starting Phase 0" |
| 12 | `phase_exit_summary` | 0-context | "Complete Phase 0" |
| 13 | `project_context` | 0-context | "Update the project context with what we just did" |
| 14 | `project_guidelines` | 0-context | "Set up project CLAUDE.md" |
| 15 | `risk_register` | 0-context | "Consolidate project risks" |
| 16 | `search_first` | 0-context | "Research before coding" |
| 17 | `ssot_structure` | 0-context | "Create an SSoT for [business]" |
| 18 | `stakeholder_map` | 0-context | "Who owns this project" |
| 19 | `supply_chain_audit` | 0-context | "Audit supply chain security" |
| 20 | `system_design_review` | 0-context | "Review the system design" |
| 21 | `team_knowledge_transfer` | 0-context | "Someone is leaving the team" |
| 22 | `tech_debt_assessment` | 0-context | "Assess technical debt" |
| 23 | `assumption_testing` | 1-brainstorm | "Test our assumptions" |
| 24 | `client_discovery` | 1-brainstorm | "Prepare for discovery call" |
| 25 | `competitive_analysis` | 1-brainstorm | "Analyze competitors and find market gaps" |
| 26 | `go_no_go_gate` | 1-brainstorm | "Go or no-go for [project]" |
| 27 | `idea_to_spec` | 1-brainstorm | "I want to add a feature that..." |
| 28 | `lean_canvas` | 1-brainstorm | "Lean canvas for [product]" |
| 29 | `market_sizing` | 1-brainstorm | "Market sizing for [product]" |
| 30 | `prd_generator` | 1-brainstorm | "Generate PRD for [product]" |
| 31 | `prioritization_frameworks` | 1-brainstorm | "Score and rank features using RICE/MoSCoW" |
| 32 | `product_metrics` | 1-brainstorm | "Choose KPIs and North Star metric" |
| 33 | `proposal_generator` | 1-brainstorm | "Create a proposal for [client]" |
| 34 | `smb_launchpad` | 1-brainstorm | "SMB launch plan for [business]" |
| 35 | `user_research` | 1-brainstorm | "Run user research for [feature]" |
| 36 | `user_story_standards` | 1-brainstorm | "Write user stories and acceptance criteria" |
| 37 | `accessibility_design` | 2-design | "Design accessibility for [product]" |
| 38 | `api_contract_design` | 2-design | "Define API contract for [service]" |
| 39 | `architecture_decision_records` | 2-design | "Record architectural decision" |
| 40 | `atomic_reverse_architecture` | 2-design | "Design the architecture for a [project type]" |
| 41 | `c4_architecture_diagrams` | 2-design | "Create C4 diagrams for [system]" |
| 42 | `cost_architecture` | 2-design | "Cloud cost model for [system]" |
| 43 | `data_privacy_design` | 2-design | "Design data privacy for [system]" |
| 44 | `deployment_modes` | 2-design | "Plan deployment modes for [app]" |
| 45 | `design_handoff` | 2-design | "Complete design phase" |
| 46 | `design_intake` | 2-design | "Begin design phase" |
| 47 | `feature_architecture` | 2-design | "Document the [feature name] architecture" |
| 48 | `internationalization_design` | 2-design | "i18n architecture" |
| 49 | `multi_tenancy_architecture` | 2-design | "Multi-tenant design" |
| 50 | `nfr_specification` | 2-design | "Define NFRs for [system]" |
| 51 | `rto_rpo_design` | 2-design | "Define RTO and RPO" |
| 52 | `schema_standards` | 2-design | "Create a schema for [database/table]" |
| 53 | `security_threat_modeling` | 2-design | "Threat model for [system]" |
| 54 | `api_design` | 3-build | "Design the API for [feature]" |
| 55 | `auth_implementation` | 3-build | "Set up authentication for [project]" |
| 56 | `authorization_patterns` | 3-build | "Add ownership check for [resource]" |
| 57 | `backend_patterns` | 3-build | "Backend architecture patterns" |
| 58 | `backward_compatibility` | 3-build | "How to evolve [API] without breaking consumers" |
| 59 | `bug_troubleshoot` | 3-build | "Bug: [description]" |
| 60 | `clickhouse_io` | 3-build | "ClickHouse patterns" |
| 61 | `code_changelog` | 3-build | "Log the changes I just made" |
| 62 | `code_review` | 3-build | "Code review for [feature]" |
| 63 | `code_review_response` | 3-build | "How do I respond to this code review?" |
| 64 | `content_hash_cache` | 3-build | "Content hash caching" |
| 65 | `cost_estimation` | 3-build | "Estimate project costs and budget" |
| 66 | `cpp_coding_standards` | 3-build | "C++ coding standards" |
| 67 | `dapp_development` | 3-build | "Build a dApp for [use case]" |
| 68 | `dashboard_development` | 3-build | "Build a dashboard for [data/domain]" |
| 69 | `data_warehouse` | 3-build | "Design data warehouse / star schema" |
| 70 | `database_optimization` | 3-build | "This query is slow, help me optimize" |
| 71 | `dependency_hygiene` | 3-build | "Audit dependencies" |
| 72 | `django_patterns` | 3-build | "Django patterns" |
| 73 | `docker_development` | 3-build | "Dockerize this project" |
| 74 | `environment_setup` | 3-build | "Set up development environment" |
| 75 | `error_handling` | 3-build | "Set up error handling for [project]" |
| 76 | `etl_pipeline` | 3-build | "Build ETL pipeline" |
| 77 | `event_driven_architecture` | 3-build | "Decouple [service] with events" |
| 78 | `extension_development` | 3-build | "Build a browser extension for [use case]" |
| 79 | `feature_flags` | 3-build | "Add feature flag for [feature]" |
| 80 | `firmware_development` | 3-build | "Build firmware / embedded dev" |
| 81 | `frontend_patterns` | 3-build | "Frontend architecture patterns" |
| 82 | `game_development` | 3-build | "Build a game / game architecture" |
| 83 | `git_workflow` | 3-build | "Set up Git workflow for this project" |
| 84 | `golang_patterns` | 3-build | "Go coding patterns" |
| 85 | `i18n_implementation` | 3-build | "Extract strings for translation" |
| 86 | `iot_platform` | 3-build | "Build IoT platform / connect devices" |
| 87 | `java_coding_standards` | 3-build | "Java coding standards" |
| 88 | `jpa_patterns` | 3-build | "JPA/Hibernate patterns" |
| 89 | `liquid_glass_design` | 3-build | "Liquid glass UI design" |
| 90 | `ml_pipeline` | 3-build | "Build an ML pipeline for [task]" |
| 91 | `multiplayer_systems` | 3-build | "Add multiplayer / netcode" |
| 92 | `notification_systems` | 3-build | "Set up notifications for [feature]" |
| 93 | `observability` | 3-build | "Set up monitoring for [service]" |
| 94 | `privacy_by_design` | 3-build | "Implement right to erasure" |
| 95 | `prompt_engineering` | 3-build | "Design prompts for [use case]" |
| 96 | `python_patterns` | 3-build | "Python coding patterns" |
| 97 | `refactoring` | 3-build | "Refactor [service] for maintainability" |
| 98 | `regex_vs_llm` | 3-build | "Regex vs LLM for text parsing" |
| 99 | `resiliency_patterns` | 3-build | "Add circuit breaker to [service]" |
| 100 | `retrospective` | 3-build | "Run a sprint retro or post-mortem" |
| 101 | `secret_management` | 3-build | "Set up secrets for [project]" |
| 102 | `smart_contract_dev` | 3-build | "Build a smart contract for [use case]" |
| 103 | `spec_build` | 3-build | "Build [feature] from spec" |
| 104 | `springboot_patterns` | 3-build | "Spring Boot patterns" |
| 105 | `sprint_planning` | 3-build | "Break features into sprints" |
| 106 | `stakeholder_communication` | 3-build | "Write status updates and roadmaps" |
| 107 | `state_machine_patterns` | 3-build | "Model [workflow] as state machine" |
| 108 | `swift_actor_persistence` | 3-build | "Swift actor persistence" |
| 109 | `swift_concurrency` | 3-build | "Swift concurrency patterns" |
| 110 | `swift_protocol_di_testing` | 3-build | "Swift protocol DI testing" |
| 111 | `test_driven_build` | 3-build | "Write tests as I build" |
| 112 | `trading_systems` | 3-build | "Build a trading bot for [exchange/asset]" |
| 113 | `ui_polish` | 3-build | "Polish the UI for [feature/page]" |
| 114 | `website_build` | 3-build | "Build a website for [client]" |
| 115 | `accessibility_testing` | 4-secure | "Accessibility audit for this page" |
| 116 | `chaos_engineering` | 4-secure | "Chaos test" |
| 117 | `compliance_testing_framework` | 4-secure | "Compliance testing for SOC2" |
| 118 | `container_security` | 4-secure | "Scan Docker image" |
| 119 | `cpp_testing` | 4-secure | "C++ testing patterns" |
| 120 | `django_security` | 4-secure | "Django security patterns" |
| 121 | `django_tdd` | 4-secure | "Django TDD workflow" |
| 122 | `django_verification` | 4-secure | "Django verification loop" |
| 123 | `e2e_testing` | 4-secure | "Write E2E tests for [flow]" |
| 124 | `eval_harness` | 4-secure | "Evaluation harness for testing" |
| 125 | `financial_compliance` | 4-secure | "Run a financial compliance check on [project]" |
| 126 | `golang_testing` | 4-secure | "Go testing patterns" |
| 127 | `integration_testing` | 4-secure | "Write API integration tests" |
| 128 | `ip_protection` | 4-secure | "Check IP protection for [project]" |
| 129 | `mutation_testing` | 4-secure | "Run mutation tests" |
| 130 | `performance_testing` | 4-secure | "Load test this API" |
| 131 | `privacy_by_design_testing` | 4-secure | "Privacy impact assessment" |
| 132 | `python_testing` | 4-secure | "Python testing patterns" |
| 133 | `sast_scanning` | 4-secure | "Run SAST scan" |
| 134 | `secrets_scanning` | 4-secure | "Scan for secrets" |
| 135 | `security_audit` | 4-secure | "Security audit for [feature]" |
| 136 | `springboot_security` | 4-secure | "Spring Boot security" |
| 137 | `springboot_tdd` | 4-secure | "Spring Boot TDD" |
| 138 | `springboot_verification` | 4-secure | "Spring Boot verification" |
| 139 | `supply_chain_security` | 4-secure | "SCA scan" |
| 140 | `tdd_workflow` | 4-secure | "RED-GREEN-REFACTOR TDD workflow" |
| 141 | `unit_testing` | 4-secure | "Write unit tests for [service]" |
| 142 | `verification_loop` | 4-secure | "Verification loop for changes" |
| 143 | `web3_security` | 4-secure | "Audit this smart contract" |
| 144 | `canary_verification` | 5-ship | "Canary deployment" |
| 145 | `change_management` | 5-ship | "Change management records" |
| 146 | `ci_cd_pipeline` | 5-ship | "Set up CI/CD with GitHub Actions" |
| 147 | `db_migrations` | 5-ship | "Plan database migration" |
| 148 | `deployment_approval_gates` | 5-ship | "Add deployment gates" |
| 149 | `deployment_patterns` | 5-ship | "Deployment best practices" |
| 150 | `deployment_verification` | 5-ship | "Verify deployment" |
| 151 | `desktop_publishing` | 5-ship | "Build desktop app" |
| 152 | `game_publishing` | 5-ship | "Submit to Steam / App Store" |
| 153 | `infrastructure_as_code` | 5-ship | "Set up infrastructure for [app]" |
| 154 | `legal_compliance` | 5-ship | "Create legal pages (ToS, Privacy)" |
| 155 | `mlops` | 5-ship | "Deploy ML model / model serving" |
| 156 | `oss_publishing` | 5-ship | "Publish open source / npm package" |
| 157 | `release_signing` | 5-ship | "Sign release artifacts" |
| 158 | `seed_data` | 5-ship | "Create seed data for demos" |
| 159 | `website_launch` | 5-ship | "Prepare for website launch" |
| 160 | `alpha_exit_criteria` | 5.5-alpha | "Alpha exit criteria" |
| 161 | `alpha_incident_communication` | 5.5-alpha | "Alpha incident communication" |
| 162 | `alpha_program_management` | 5.5-alpha | "Set up alpha program" |
| 163 | `alpha_telemetry` | 5.5-alpha | "Alpha telemetry setup" |
| 164 | `backup_strategy` | 5.5-alpha | "Set up database backups" |
| 165 | `env_validation` | 5.5-alpha | "Validate environment variables" |
| 166 | `error_tracking` | 5.5-alpha | "Set up Sentry error tracking" |
| 167 | `health_checks` | 5.5-alpha | "Add health check endpoints" |
| 168 | `qa_playbook` | 5.5-alpha | "Create QA test playbook" |
| 169 | `beta_cohort_management` | 5.75-beta | "Create beta cohort" |
| 170 | `beta_graduation_criteria` | 5.75-beta | "Define beta exit criteria" |
| 171 | `beta_sla_definition` | 5.75-beta | "Define beta SLA" |
| 172 | `beta_to_ga_migration` | 5.75-beta | "Migrate beta to GA" |
| 173 | `email_templates` | 5.75-beta | "Create branded email templates" |
| 174 | `error_boundaries` | 5.75-beta | "Add error boundaries and toasts" |
| 175 | `feature_flags` | 5.75-beta | "Set up feature flags and gradual rollout" |
| 176 | `feedback_system` | 5.75-beta | "Add in-app bug reporter" |
| 177 | `load_testing` | 5.75-beta | "Load test for [service]" |
| 178 | `privacy_consent_management` | 5.75-beta | "Set up consent management" |
| 179 | `product_analytics` | 5.75-beta | "Set up PostHog analytics" |
| 180 | `rate_limiting` | 5.75-beta | "Configure API rate limiting" |
| 181 | `usage_metering_billing` | 5.75-beta | "Set up usage billing" |
| 182 | `access_handoff` | 6-handoff | "Transfer access for [project]" |
| 183 | `api_reference` | 6-handoff | "Generate API documentation" |
| 184 | `community_management` | 6-handoff | "Set up open source community" |
| 185 | `disaster_recovery` | 6-handoff | "Create disaster recovery runbook" |
| 186 | `doc_reorganize` | 6-handoff | "Reorganize project documentation" |
| 187 | `feature_walkthrough` | 6-handoff | "Create a walkthrough for [feature]" |
| 188 | `knowledge_audit` | 6-handoff | "Run knowledge audit" |
| 189 | `monitoring_handoff` | 6-handoff | "Transfer monitoring ownership" |
| 190 | `operational_readiness_review` | 6-handoff | "Run readiness review" |
| 191 | `sla_handoff` | 6-handoff | "Define GA SLAs" |
| 192 | `support_enablement` | 6-handoff | "Create support playbook" |
| 193 | `user_documentation` | 6-handoff | "Create help center / user guides" |
| 194 | `capacity_planning_and_performance` | 7-maintenance | "Capacity trends for [service]" |
| 195 | `continuous_learning` | 7-maintenance | "Extract patterns, evolve instincts" |
| 196 | `dependency_management` | 7-maintenance | "Audit npm dependencies" |
| 197 | `documentation_standards` | 7-maintenance | "Review documentation standards" |
| 198 | `incident_response_operations` | 7-maintenance | "Run incident response" |
| 199 | `operational_readiness_gate` | 7-maintenance | "Validate operational readiness" |
| 200 | `security_maintenance` | 7-maintenance | "Monthly security review" |
| 201 | `slo_sla_management` | 7-maintenance | "SLO status" |
| 202 | `sop_standards` | 7-maintenance | "Create an SOP for [process]" |
| 203 | `ssot_update` | 7-maintenance | "Update the SSoT" |
| 204 | `wi_standards` | 7-maintenance | "Create a Work Instruction for [task]" |
| 205 | `age` | toolkit | "Run AGE analysis" |
| 206 | `age_to_skill_pipeline` | toolkit | "Convert gaps to skills" |
| 207 | `ai_security_hardening` | toolkit | "Harden AI workflow" |
| 208 | `ai_tool_orchestration` | toolkit | "Choose and chain AI tools for workflows" |
| 209 | `ceo_brain` | toolkit | "Strategic analysis for [topic]" |
| 210 | `compliance_program` | toolkit | "Set up compliance program" |
| 211 | `content_creation` | toolkit | "Write a script for [topic]" |
| 212 | `content_waterfall` | toolkit | "Extract shorts from [video]" |
| 213 | `cost_aware_llm_pipeline` | toolkit | "Model routing and token optimization" |
| 214 | `delivery_metrics` | toolkit | "DORA metrics" |
| 215 | `dora_metrics_tracking` | toolkit | "DORA metrics report" |
| 216 | `governance_framework` | toolkit | "Configure for [team size]" |
| 217 | `iterative_retrieval` | toolkit | "Progressive context refinement" |
| 218 | `observability_maturity_model` | toolkit | "Assess observability maturity" |
| 219 | `personal_brand` | toolkit | "Build personal brand strategy" |
| 220 | `phase_gate_contracts` | toolkit | "/gate-check [from-phase] [to-phase]" |
| 221 | `progressive_rollout_playbook` | toolkit | "Progressive rollout plan" |
| 222 | `project_state_persistence` | toolkit | "/project-status" |
| 223 | `skill_lifecycle_manager` | toolkit | "Deprecate skill [name]" |
| 224 | `skill_registry` | toolkit | "Search for skill about [topic]" |
| 225 | `sre_foundations` | toolkit | "Set up SRE practices" |
| 226 | `strategic_compact` | toolkit | "Context window management" |
| 227 | `toolkit_phase_integration_guide` | toolkit | "Toolkit setup for [phase]" |
| 228 | `video_research` | toolkit | "Research viral hooks for [niche]" |

---

## Phase Summary

| Phase | Skill Count |
|-------|-------------|
| 0-Context | 22 |
| 1-Brainstorm | 14 |
| 2-Design | 17 |
| 3-Build | 61 |
| 4-Secure | 29 |
| 5-Ship | 16 |
| 5.5-Alpha | 9 |
| 5.75-Beta | 13 |
| 6-Handoff | 12 |
| 7-Maintenance | 11 |
| Toolkit | 24 |
| **Total** | **228** |

---

## How to Use

1. Read the skill's `SKILL.md` file in `.agent/skills/[phase]/[skill-name]/`
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

*Updated: February 2026 -- v9.0 (228 skills)*
