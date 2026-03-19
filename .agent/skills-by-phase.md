# Skills by Phase Reference

> **Loadable registry** -- When you need skills for a specific phase, read this file.
> 339 skills across 10 phases + 1 cross-phase toolkit.

---

## Phase 0 -- Context (23 skills)

**Purpose:** Understand the project before changing anything.
**Entry criteria:** Project initiated or inherited.
**Exit criteria:** `phase_exit_summary` completed, `risk_register` populated.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| architecture_recovery | Reverse-engineer architecture from existing code | architect | -- |
| codebase_health_audit | Automated quality/security/dependency scan with A-F grading | -- | -- |
| codebase_navigation | Systematic approach to understanding unfamiliar codebases | -- | -- |
| compliance_context | Inventory applicable regulatory frameworks | -- | -- |
| dev_environment_setup | Fresh clone to fully operational local dev environment | -- | -- |
| documentation_framework | Reference for all document types and templates | -- | -- |
| incident_history_review | Analyze past incidents and post-mortems for patterns | -- | -- |
| infrastructure_audit | Map networking, DNS, load balancers, topology | architect | -- |
| legacy_modernization | Strangler fig and modernization strategies | architect | -- |
| new_project | Template for starting a brand new project | -- | -- |
| phase_0_playbook | Meta-skill for correct Phase 0 sequencing | planner | -- |
| phase_exit_summary | Phase 0 to Phase 1 handoff brief | planner | -- |
| project_context | Single source of truth for project state | -- | -- |
| project_guidelines | Project-specific conventions and standards | -- | -- |
| regulated_industry_context | Regulated industry context assessment (healthcare, finance, defense) | -- | -- |
| risk_register | Prioritized risk register with heat map | -- | -- |
| search_first | Research before coding workflow | -- | -- |
| ssot_structure | Structure a Single Source of Truth document | -- | -- |
| stakeholder_map | Identify stakeholders and decision-makers | -- | -- |
| supply_chain_audit | SBOM and dependency integrity assessment | -- | -- |
| system_design_review | Evaluate scalability and fault tolerance | architect | -- |
| team_knowledge_transfer | Extract knowledge from outgoing developers | -- | -- |
| tech_debt_assessment | Quantify and prioritize technical debt | -- | -- |

**Related workflows:** `phase-0-workflow`

---

## Phase 1 -- Brainstorm (14 skills)

**Purpose:** Explore ideas, validate assumptions, define what to build.
**Entry criteria:** Phase 0 exit summary approved.
**Exit criteria:** `prd_generator` completed, `go_no_go_gate` = GO.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| assumption_testing | Validate risky assumptions with lightweight experiments | -- | -- |
| client_discovery | Client intake questionnaire for service projects | planner | -- |
| competitive_analysis | Evaluate competitors and find market gaps | -- | -- |
| go_no_go_gate | 7-dimension GO/NO-GO decision gate | planner | -- |
| idea_to_spec | Convert raw ideas into implementation specs | planner | -- |
| lean_canvas | One-page business model canvas | -- | -- |
| market_sizing | TAM-SAM-SOM market analysis | -- | -- |
| prd_generator | Comprehensive PRD from Phase 1 outputs | planner | -- |
| prioritization_frameworks | RICE, MoSCoW, Kano scoring methods | -- | -- |
| product_metrics | North Star and feature-level metrics definition | -- | -- |
| proposal_generator | Quick proposal for client projects | -- | -- |
| smb_launchpad | SMB website + consulting delivery bundle | -- | -- |
| user_research | User interviews, usability testing protocols | -- | -- |
| user_story_standards | User stories with acceptance criteria | -- | -- |

**Related workflows:** `phase-1-workflow`

---

## Phase 2 -- Design (24 skills)

**Purpose:** Architect the solution before writing code.
**Entry criteria:** `design_intake` validates Phase 1 artifacts.
**Exit criteria:** `design_handoff` completed with stakeholder sign-off.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| accessibility_design | WCAG 2.1/2.2 conformance planning | -- | -- |
| api_contract_design | Contract-first OpenAPI 3.0 specifications | architect | -- |
| architecture_decision_records | MADR v3.0 ADR format for design decisions | architect | -- |
| atomic_reverse_architecture | First Principles + Reverse Thinking architecture | architect | -- |
| c4_architecture_diagrams | C4 model diagrams in Mermaid syntax | architect | -- |
| cost_architecture | Cloud cost modeling and FinOps strategy | architect | -- |
| cross_platform_architecture | Cross-platform mobile/web architecture decisions | architect | -- |
| data_privacy_design | PII classification, GDPR Article 30 compliance | -- | -- |
| deployment_modes | Cloud/Hybrid/Sovereign compliance check | architect | -- |
| design_handoff | Phase 2 to Phase 3 gate with sign-off | architect | -- |
| design_intake | Phase 1 to Phase 2 gate validation | architect | -- |
| distributed_tracing_design | Distributed tracing architecture and design | architect | -- |
| embedding_pipeline_design | Embedding model selection and pipeline architecture | -- | -- |
| feature_architecture | Comprehensive feature architecture documents | architect | -- |
| feature_store_design | Feature store architecture for ML systems | -- | -- |
| inclusive_design_patterns | Inclusive and accessible design patterns | -- | -- |
| internationalization_design | i18n architecture decisions and planning | -- | -- |
| multi_tenancy_architecture | Tenancy model selection and design | architect | -- |
| nfr_specification | Non-Functional Requirements with SLO targets | architect | -- |
| observability_architecture_design | Observability architecture design | architect | -- |
| rto_rpo_design | Recovery Time/Point Objectives definition | architect | -- |
| schema_standards | Rigorous data schema templates | -- | -- |
| security_threat_modeling | STRIDE-based threat modeling | -- | -- |
| slo_sla_design | SLO/SLA design and error budget planning | architect | -- |

**Related workflows:** `phase-2-workflow`

---

## Phase 3 -- Build (123 skills)

**Purpose:** Implement the solution according to design specs.
**Entry criteria:** `design_handoff` approved.
**Exit criteria:** All specs built, `test_driven_build` passing, `code_review` completed.

### Core Build Skills (36)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| spec_build | 12-phase autonomous spec creation (MASTER LOOP) | -- | -- |
| api_design | RESTful API patterns with NestJS | -- | -- |
| audit_logging_architecture | Audit logging architecture and compliance trails | -- | -- |
| auth_implementation | JWT, RBAC, OAuth, session management | -- | -- |
| authorization_patterns | RBAC, ABAC, ownership-based authorization | -- | -- |
| backend_patterns | Node.js/Express/Next.js backend patterns | -- | -- |
| bug_troubleshoot | Systematic debugging process | build-error-resolver | /build-fix |
| code_review | Code review and verification workflow | code-reviewer | /code-review |
| code_review_response | Responding to code review feedback | code-reviewer | -- |
| code_changelog | Document every code change | -- | -- |
| compliance_as_code | Compliance requirements as automated checks | -- | -- |
| cost_estimation | Token costs, infrastructure pricing, budgets | -- | -- |
| database_optimization | PostgreSQL/Prisma query optimization | database-reviewer | -- |
| dependency_hygiene | Audit, pin, and secure dependencies | -- | -- |
| docker_development | Docker/Compose for NestJS+React | -- | -- |
| environment_setup | NestJS+React dev environment config | -- | -- |
| error_handling | NestJS backend + React frontend error patterns | -- | -- |
| feature_flags | Feature flag lifecycle management | -- | -- |
| frontend_patterns | React/Next.js state and performance patterns | -- | -- |
| git_workflow | Branching, commits, PRs, recovery | -- | -- |
| multi_stack_observability | Multi-stack observability patterns | -- | -- |
| notification_systems | Multi-channel notification implementation | -- | -- |
| observability | Structured logging, metrics, tracing | -- | -- |
| opentelemetry_implementation | OpenTelemetry instrumentation | -- | -- |
| privacy_by_design | Data minimization, PII encryption, GDPR | -- | -- |
| refactoring | Safe refactoring and code smell detection | -- | /refactor-clean |
| resiliency_patterns | Timeout, retry, circuit breaker, bulkhead | -- | -- |
| runtime_security_monitoring | Runtime security monitoring and detection | security-reviewer | -- |
| secret_management | .env to production-grade secrets | -- | -- |
| sprint_planning | Sprint planning with story points | -- | -- |
| stakeholder_communication | Stakeholder update templates | -- | -- |
| state_machine_patterns | DB-backed state machines + XState | -- | -- |
| test_driven_build | Red-green-refactor in Phase 3 | tdd-guide | /tdd |
| ui_polish | Debug and polish UIs to production quality | -- | -- |
| website_build | Premium website standards (Anti-AI-Slop) | -- | -- |
| backward_compatibility | Safe API/schema evolution strategies | -- | -- |
| retrospective | Sprint/project retrospective facilitation | -- | -- |

### Language-Specific Skills (10)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| cpp_coding_standards | C++ coding standards and best practices | -- | -- |
| django_patterns | Django project patterns and conventions | -- | -- |
| golang_patterns | Go project patterns and conventions | go-reviewer | /go-build, /go-review |
| java_coding_standards | Java coding standards and best practices | -- | -- |
| jpa_patterns | JPA/Hibernate persistence patterns | -- | -- |
| python_patterns | Python project patterns and conventions | python-reviewer | /python-review |
| springboot_patterns | Spring Boot application patterns | -- | -- |
| swift_actor_persistence | Swift actor persistence patterns | -- | -- |
| swift_concurrency | Swift structured concurrency patterns | -- | -- |
| swift_protocol_di_testing | Swift protocol-based DI and testing | -- | -- |

### Domain-Specific Skills (47)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| accessibility_implementation | WCAG 2.2 implementation with ARIA and focus management | -- | -- |
| ai_agent_development | AI agent building with LangChain, CrewAI, multi-agent | -- | -- |
| airflow_orchestration | Apache Airflow DAG development and orchestration | -- | -- |
| api_gateway_patterns | API gateway patterns with Kong, AWS API Gateway | -- | -- |
| caching_strategies | Caching with Redis, CDN, invalidation strategies | -- | -- |
| clickhouse_io | ClickHouse analytics database patterns | -- | -- |
| computer_vision_pipeline | CV pipelines with YOLO, Detectron2, torchvision | -- | -- |
| content_hash_cache | Content-addressable caching strategies | -- | -- |
| dapp_development | Decentralized application development | -- | -- |
| dashboard_development | Analytics dashboard implementation | -- | -- |
| data_warehouse | Data warehouse design and ETL | -- | -- |
| database_migration_patterns | Zero-downtime schema migrations (expand-contract) | -- | -- |
| design_system_development | Design system tokens, components, Storybook | -- | -- |
| distributed_training | Distributed ML training with DDP, FSDP, DeepSpeed | -- | -- |
| etl_pipeline | Extract-Transform-Load pipeline patterns | -- | -- |
| event_driven_architecture | Event sourcing and CQRS patterns | -- | -- |
| experiment_tracking | ML experiment tracking with MLflow, W&B, Neptune | -- | -- |
| extension_development | Browser/IDE extension development | -- | -- |
| firmware_development | Embedded firmware development | -- | -- |
| flutter_development | Flutter development with Riverpod/BLoC patterns | -- | -- |
| game_development | Game development patterns and engines | -- | -- |
| helm_chart_development | Helm chart creation, templating, testing | -- | -- |
| i18n_implementation | Internationalization implementation | -- | -- |
| internal_developer_portal | Internal developer portal with Backstage | -- | -- |
| iot_platform | IoT platform development | -- | -- |
| kafka_event_streaming | Apache Kafka event streaming pipelines | -- | -- |
| kubernetes_operations | Kubernetes workload management and operations | -- | -- |
| liquid_glass_design | Apple Liquid Glass UI design patterns | -- | -- |
| log_aggregation_pipeline | Log aggregation with ELK, Loki, structured logging | -- | -- |
| lora_finetuning_workflow | LoRA/QLoRA/PEFT fine-tuning workflows | -- | -- |
| message_queue_patterns | Message queue patterns (RabbitMQ, SQS, NATS) | -- | -- |
| ml_pipeline | Machine learning pipeline development | -- | -- |
| monorepo_tooling | Monorepo management with Nx, Turborepo, Bazel | -- | -- |
| multiplayer_systems | Multiplayer networking and sync | -- | -- |
| nlp_text_pipeline | NLP text pipelines with spaCy, Transformers | -- | -- |
| progressive_web_app | Progressive web app with service workers, offline | -- | -- |
| prompt_engineering | LLM prompt design and optimization | -- | -- |
| rag_advanced_patterns | Advanced RAG: re-ranking, hybrid search, CRAG, self-RAG | -- | -- |
| react_native_patterns | React Native cross-platform mobile development | -- | -- |
| regex_vs_llm | When to use regex vs LLM for text processing | -- | -- |
| service_mesh_patterns | Service mesh with Istio/Linkerd, mTLS, traffic mgmt | -- | -- |
| smart_contract_dev | Solidity smart contract development | -- | -- |
| spark_data_processing | Apache Spark data processing and Delta Lake | -- | -- |
| synthetic_data_generation | Synthetic training data generation (LLM, CTGAN) | -- | -- |
| trading_systems | Trading system development | -- | -- |
| vector_database_operations | Vector DB operations (pgvector, Pinecone, Qdrant) | -- | -- |

**Related agents:** code-reviewer, build-error-resolver, tdd-guide, database-reviewer, go-reviewer, python-reviewer
**Related commands:** /build-fix, /code-review, /tdd, /go-build, /go-review, /python-review, /refactor-clean
**Related workflows:** `phase-3-workflow`

---

## Phase 4 -- Secure (47 skills)

**Purpose:** Test, verify, and harden the build.
**Entry criteria:** Phase 3 build complete, feature branch ready.
**Exit criteria:** `verification_loop` passing, `security_audit` complete.

### Core Testing Skills (19)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| tdd_workflow | TDD with 80%+ coverage target | tdd-guide | /tdd |
| unit_testing | Jest/Vitest for NestJS+React | tdd-guide | /test-coverage |
| integration_testing | Supertest API tests with auth context | -- | -- |
| e2e_testing | Playwright full-stack end-to-end testing | e2e-runner | /e2e |
| infrastructure_testing | IaC testing with Terratest, Checkov, tfsec | -- | -- |
| llm_evaluation_benchmarking | LLM evaluation and benchmarking (MT-Bench, HELM) | -- | /eval |
| performance_testing | k6 load tests, Lighthouse CI | -- | -- |
| accessibility_testing | WCAG 2.1 AA with axe-core | -- | -- |
| security_audit | OWASP checklist, auth, secrets, AI risks | security-reviewer | -- |
| sast_scanning | Semgrep/CodeQL as CI gate | security-reviewer | -- |
| secrets_scanning | Pre-commit + CI + historical secret scanning | security-reviewer | -- |
| container_security | Dockerfile hardening, Trivy scanning | security-reviewer | -- |
| supply_chain_security | SCA, SBOM, license compliance | security-reviewer | -- |
| compliance_testing_framework | SOC2/HIPAA/GDPR/PCI-DSS mapping | -- | -- |
| privacy_by_design_testing | DPIA, PII discovery, consent verification | -- | -- |
| verification_loop | Comprehensive verification system | -- | /verify |
| chaos_engineering | Failure injection testing | -- | -- |
| mutation_testing | Test suite effectiveness with Stryker | -- | -- |
| eval_harness | Eval-driven development for AI features | -- | /eval |

### AI Safety Skills (2)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| ai_safety_guardrails | AI safety: content filtering, prompt injection defense | security-reviewer | -- |
| rlhf_alignment | RLHF, DPO, ORPO alignment methods | -- | -- |

### Compliance Skills (8)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| api_security_testing | API security testing (OWASP API Top 10) | security-reviewer | -- |
| build_reproducibility_testing | Build reproducibility testing | -- | -- |
| financial_compliance | Fintech regulatory compliance | -- | -- |
| hipaa_compliance_testing | HIPAA compliance testing | -- | -- |
| ip_protection | Patent, trademark, copyright checklist | -- | -- |
| pci_dss_compliance_testing | PCI-DSS compliance testing | -- | -- |
| ssrf_testing_harness | SSRF testing harness | security-reviewer | -- |
| web3_security | Smart contract security auditing | -- | -- |

### Mobile Testing Skills (2)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| mobile_security_testing | Mobile security testing (OWASP MASVS) | -- | -- |
| mobile_testing_strategy | Mobile testing: unit, widget, E2E, device farms | -- | -- |

### Language-Specific Testing Skills (9)

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| django_security | Django security hardening | -- | -- |
| django_tdd | Django test-driven development | -- | -- |
| django_verification | Django verification and validation | -- | -- |
| springboot_security | Spring Boot security hardening | -- | -- |
| springboot_tdd | Spring Boot test-driven development | -- | -- |
| springboot_verification | Spring Boot verification and validation | -- | -- |
| golang_testing | Go testing patterns and tooling | go-reviewer | -- |
| python_testing | Python testing patterns and tooling | python-reviewer | -- |
| cpp_testing | C++ testing patterns and tooling | -- | -- |

**Related agents:** security-reviewer, e2e-runner, tdd-guide
**Related commands:** /tdd, /e2e, /verify, /test-coverage, /eval
**Related workflows:** `phase-4-workflow`

---

## Phase 5 -- Ship (25 skills)

**Purpose:** Deploy to production.
**Entry criteria:** Phase 4 verification complete.
**Exit criteria:** `deployment_verification` passing in production.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| app_store_deployment | iOS App Store and Google Play submission (Fastlane) | -- | -- |
| artifact_provenance_chain | Artifact provenance and SLSA compliance | -- | -- |
| canary_verification | Automated canary promotion gates | -- | -- |
| change_management | SOC2 CC8.1 change records | -- | -- |
| ci_cd_pipeline | GitHub Actions CI/CD setup | -- | -- |
| db_migrations | Safe schema evolution with Prisma | -- | -- |
| deployment_approval_gates | Multi-gate deployment pipeline | -- | -- |
| deployment_patterns | Blue-green, canary, rolling strategies | -- | -- |
| deployment_verification | Post-deploy health/smoke/metrics checks | -- | -- |
| desktop_publishing | Desktop app packaging and distribution | -- | -- |
| game_publishing | Game store submission and compliance | -- | -- |
| gitops_workflow | GitOps with ArgoCD/Flux, sync strategies | -- | -- |
| infrastructure_as_code | Docker/Terraform/Kubernetes configuration | -- | -- |
| legal_compliance | ToS, Privacy Policy templates | -- | -- |
| mlops | ML model deployment and monitoring | -- | -- |
| mlops_pipeline | End-to-end MLOps CI/CD for ML systems | -- | -- |
| model_registry_management | Model versioning, staging, promotion, rollback | -- | -- |
| model_serving_deployment | Model serving with vLLM, TGI, Triton, TorchServe | -- | -- |
| multi_stack_deployment | Multi-stack deployment patterns | -- | -- |
| oss_publishing | Open source release preparation | -- | -- |
| release_signing | Sigstore artifact signing | -- | -- |
| seed_data | Demo data and fixture generation | -- | -- |
| website_launch | Launch checklist (SEO, analytics, DNS) | -- | -- |

**Related workflows:** `phase-5-workflow`

---

## Phase 5.5 -- Alpha (10 skills)

**Purpose:** Controlled release to early testers, collect crash/telemetry data.
**Entry criteria:** First production deployment complete.
**Exit criteria:** `alpha_exit_criteria` met.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| ai_model_monitoring | AI model monitoring: drift detection, retraining triggers | -- | -- |
| alpha_program_management | Tester recruitment and access gating | -- | -- |
| alpha_telemetry | Session events and crash reporting setup | -- | -- |
| error_tracking | Sentry setup for NestJS/React/Next.js | -- | -- |
| health_checks | NestJS Terminus liveness/readiness probes | -- | -- |
| env_validation | Fail-fast startup environment validation | -- | -- |
| backup_strategy | PostgreSQL backup and recovery procedures | -- | -- |
| qa_playbook | Manual QA test cases and checklists | -- | -- |
| alpha_incident_communication | Incident comms templates for alpha testers | -- | -- |
| alpha_exit_criteria | Alpha to Beta graduation gates | -- | -- |

**Related workflows:** `phase-5.5-workflow`

---

## Phase 5.75 -- Beta (13 skills)

**Purpose:** Broader release, usage analytics, billing integration.
**Entry criteria:** Alpha exit criteria met.
**Exit criteria:** `beta_graduation_criteria` met.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| product_analytics | PostHog user behavior tracking | -- | -- |
| feedback_system | In-app bug reporter with triage workflow | -- | -- |
| feature_flags | Gradual rollouts, A/B testing, kill switches | -- | -- |
| rate_limiting | @nestjs/throttler with plan-based tiers | -- | -- |
| error_boundaries | React error boundaries + toast notifications | -- | -- |
| email_templates | Resend + React Email transactional templates | -- | -- |
| load_testing | k6 load testing with CI integration | -- | -- |
| beta_cohort_management | Tester segments and targeting strategies | -- | -- |
| beta_sla_definition | Beta uptime and support commitments | -- | -- |
| beta_graduation_criteria | Beta to GA readiness gates | -- | -- |
| beta_to_ga_migration | Flag cleanup and billing migration | -- | -- |
| privacy_consent_management | GDPR/CCPA consent infrastructure | -- | -- |
| usage_metering_billing | Stripe Meters usage-based billing | -- | -- |

**Related workflows:** `phase-5.75-workflow`

---

## Phase 6 -- Handoff (14 skills)

**Purpose:** Document, transfer knowledge, prepare for GA.
**Entry criteria:** Beta graduation criteria met.
**Exit criteria:** `operational_readiness_review` approved.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| feature_walkthrough | User-facing feature documentation | doc-updater | /update-docs |
| api_reference | OpenAPI/Swagger docs + client SDKs | doc-updater | -- |
| user_documentation | Help center articles + in-app help | doc-updater | /update-docs |
| compliance_certification_handoff | Compliance certification handoff procedures | -- | -- |
| disaster_recovery | Production failure runbooks | -- | -- |
| doc_reorganize | Restructure docs for clarity and navigation | doc-updater | -- |
| observability_handoff | Observability ownership handoff | -- | -- |
| operational_readiness_review | GA go/no-go gate | -- | -- |
| access_handoff | Credential and access transfer procedures | -- | -- |
| knowledge_audit | Capture tribal knowledge before handoff | -- | -- |
| monitoring_handoff | Alert maps and on-call setup | -- | -- |
| sla_handoff | GA SLA definitions + error budgets | -- | -- |
| support_enablement | Support team onboarding materials | -- | -- |
| community_management | OSS community governance framework | -- | -- |

**Related agents:** doc-updater
**Related commands:** /update-docs
**Related workflows:** `phase-6-workflow`

---

## Phase 7 -- Maintenance (13 skills)

**Purpose:** Keep the system healthy, learn, and loop back.
**Entry criteria:** `operational_readiness_gate` passed.
**Exit criteria:** `operational_readiness_gate` triggers loop back to Phase 0.

| Skill | Description | Related Agent | Related Command |
|-------|-------------|---------------|-----------------|
| slo_sla_management | SLO tracking, error budgets, burn-rate alerts | -- | -- |
| incident_response_operations | Incident lifecycle + post-mortem facilitation | -- | -- |
| capacity_planning_and_performance | Baselines, forecasting, cost optimization | -- | -- |
| compliance_dashboard | Compliance monitoring dashboard | -- | -- |
| dependency_management | npm audit, license checks, update cadence | -- | -- |
| documentation_standards | SOP/WI master templates | -- | -- |
| operational_readiness_gate | Phase 7 to Phase 0 loop-back gate | -- | -- |
| regulatory_change_monitoring | Regulatory change monitoring and impact assessment | -- | -- |
| security_maintenance | CVE monitoring, patch priority, pen test scheduling | -- | -- |
| sop_standards | Machine-readable Standard Operating Procedures | -- | -- |
| ssot_update | Keep SSoT current after changes | -- | -- |
| wi_standards | Click-level work instructions | -- | -- |
| continuous_learning | Instinct-based learning system | -- | -- |

**Related workflows:** `phase-7-workflow`

---

## Toolkit -- Cross-Phase (33 skills)

**Purpose:** Skills that apply across multiple phases or outside the main lifecycle.

| Skill | Description | Typical Phases |
|-------|-------------|----------------|
| age | 53-loop adversarial gap analysis | Any |
| age_to_skill_pipeline | Convert AGE findings into new skills | Any |
| ai_cost_optimization | AI infrastructure cost management and optimization | 3, 5 |
| ai_security_hardening | Security patterns for AI-assisted development | 3, 4 |
| ai_tool_orchestration | Claude Code + Cursor + Copilot + Gemini coordination | 3 |
| ceo-brain | Strategy orchestration with 9 Universal Brains | 0, 1 |
| compliance_program | 3-part compliance program (identify, inject, detect) | 0, 4 |
| content_creation | Script writing, hooks, filming, editing | Any |
| content_waterfall | 30+ shorts from 1 long-form video | Any |
| cost_aware_llm_pipeline | LLM cost optimization patterns | 3 |
| delivery_metrics | DORA metrics instrumentation | 3, 7 |
| developer_experience_tooling | Developer experience, golden paths, dev containers | 0, 3 |
| documentation_as_code | Docs-as-code with Docusaurus, MkDocs, OpenAPI | 3, 6 |
| dora_metrics_tracking | DORA 4-quadrant collection and reporting | 7 |
| eu_ai_act_compliance | EU AI Act compliance assessment | 0, 4 |
| governance_framework | Solo/SMB/Enterprise tier configuration | 0, 2 |
| green_software_practices | Carbon-aware computing and SCI scoring | 3, 7 |
| iso_27001_implementation | ISO 27001 implementation guide | 0, 4 |
| iterative_retrieval | Progressive context retrieval for large codebases | 0, 3 |
| observability_maturity_model | L1-L4 observability maturity framework | 3, 7 |
| personal_brand | Voice consistency and content scheduling | Any |
| phase_gate_contracts | Machine-checkable gate criteria for phase transitions | All transitions |
| progressive_rollout_playbook | Dev to Alpha to Beta to Canary to GA | 5, 5.5, 5.75 |
| project_state_persistence | Persistent project health artifact | 0, 7 |
| responsible_ai_framework | Responsible AI: fairness, bias, explainability | 3, 4 |
| skill_lifecycle_manager | Skill versioning and deprecation | Any |
| skill_registry | Central skill registry with metadata | Any |
| sre_foundations | SLO, error budgets, toil audits, postmortems | 5.5, 7 |
| strategic_compact | Manual context compaction for large sessions | Any |
| toolkit_phase_integration_guide | Which toolkit skills activate in which phase | Any |
| video_research | Analyze viral videos for content patterns | Any |

---

## Quick Reference: Phase Flow

```
Phase 0 (Context) --> Phase 1 (Brainstorm) --> Phase 2 (Design)
    --> Phase 3 (Build) --> Phase 4 (Secure) --> Phase 5 (Ship)
    --> Phase 5.5 (Alpha) --> Phase 5.75 (Beta) --> Phase 6 (Handoff)
    --> Phase 7 (Maintenance) --> loops back to Phase 0
```

## Quick Reference: All Agents

| Agent | Primary Phases | Purpose |
|-------|---------------|---------|
| planner | 0, 1 | Project planning and phase sequencing |
| architect | 0, 2 | System design and architecture decisions |
| code-reviewer | 3 | Code review and quality gates |
| build-error-resolver | 3 | Debugging build failures |
| tdd-guide | 3, 4 | Test-driven development coaching |
| database-reviewer | 3 | Database schema and query review |
| go-reviewer | 3, 4 | Go-specific code review |
| python-reviewer | 3, 4 | Python-specific code review |
| security-reviewer | 4 | Security audit and hardening |
| e2e-runner | 4 | End-to-end test execution |
| doc-updater | 6 | Documentation generation and updates |

## Quick Reference: All Commands

| Command | Phase | Purpose |
|---------|-------|---------|
| /build-fix | 3 | Fix build errors |
| /code-review | 3 | Run code review |
| /tdd | 3, 4 | Run TDD workflow |
| /go-build | 3 | Build Go project |
| /go-review | 3 | Review Go code |
| /python-review | 3 | Review Python code |
| /refactor-clean | 3 | Safe refactoring |
| /e2e | 4 | Run E2E tests |
| /verify | 4 | Run verification loop |
| /test-coverage | 4 | Check test coverage |
| /eval | 4 | Run eval harness |
| /update-docs | 6 | Update documentation |
