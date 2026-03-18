# Skills Index

Complete list of all 298 skills in this framework, organized by lifecycle phase.

## Quick Reference

| # | Skill | Phase | Description |
|---|-------|-------|-------------|
| 1 | `architecture_recovery` | 0-context | Reverse-engineer architecture from code when no documentation exists, generating |
| 2 | `codebase_health_audit` | 0-context | Automated quality, security, and dependency baseline scan with severity triage a |
| 3 | `codebase_navigation` | 0-context | Systematic approach to understanding and navigating an unfamiliar codebase |
| 4 | `compliance_context` | 0-context | Inventory applicable regulatory frameworks and produce a compliance posture base |
| 5 | `dev_environment_setup` | 0-context | Guided process from fresh clone to fully operational local development environme |
| 6 | `documentation_framework` | 0-context | Reference for all document types needed in software development |
| 7 | `incident_history_review` | 0-context | Analyze past incidents, post-mortems, and on-call runbooks to understand failure |
| 8 | `infrastructure_audit` | 0-context | Map networking, DNS, load balancers, CDN, caches, databases, and deployment topo |
| 9 | `legacy_modernization` | 0-context | Incremental modernization strategies for legacy codebases using strangler fig, b |
| 10 | `new_project` | 0-context | Template and checklist for starting a brand new project from scratch |
| 11 | `phase_0_playbook` | 0-context | Meta-skill that determines the correct Phase 0 skill sequence based on project s |
| 12 | `phase_exit_summary` | 0-context | Synthesize all Phase 0 artifacts into a formal Phase 0 to Phase 1 handoff brief |
| 13 | `project_context` | 0-context | Single source of truth for project state - UPDATE AFTER EVERY CHANGE |
| 14 | `project_guidelines` | 0-context | Example project-specific skill template based on a real production application. |
| 15 | `regulated_industry_context` | 0-context | Identify regulated industry requirements, map applicable regulations to technica |
| 16 | `risk_register` | 0-context | Aggregate and score all project risks into a prioritized risk register with heat |
| 17 | `search_first` | 0-context | Research-before-coding workflow. Search for existing tools, libraries, and patte |
| 18 | `ssot_structure` | 0-context | How to structure a Single Source of Truth document and auto-generate from onboar |
| 19 | `stakeholder_map` | 0-context | Identify and document all project stakeholders, decision-makers, and business co |
| 20 | `supply_chain_audit` | 0-context | Assess software supply chain security covering SBOM, dependency integrity, and b |
| 21 | `system_design_review` | 0-context | Evaluate scalability, fault tolerance, data consistency, and service boundaries  |
| 22 | `team_knowledge_transfer` | 0-context | Structured protocols for extracting knowledge from outgoing developers or inheri |
| 23 | `tech_debt_assessment` | 0-context | Quantify and prioritize technical debt with business impact scoring and a living |
| 24 | `assumption_testing` | 1-brainstorm | Enumerate project assumptions, rank by risk, and design experiments to invalidat |
| 25 | `client_discovery` | 1-brainstorm | Simplified client intake process for service projects |
| 26 | `competitive_analysis` | 1-brainstorm | Systematically evaluate competitors to find market gaps and build your different |
| 27 | `go_no_go_gate` | 1-brainstorm | Formal decision gate evaluating 7 dimensions to produce a GO/NO-GO/CONDITIONAL-G |
| 28 | `idea_to_spec` | 1-brainstorm | Convert unstructured feature ideas into structured implementation specs ready fo |
| 29 | `lean_canvas` | 1-brainstorm | One-page business model canvas with uncertainty analysis and MVP scope definitio |
| 30 | `market_sizing` | 1-brainstorm | TAM-SAM-SOM analysis with top-down and bottom-up approaches for product viabilit |
| 31 | `prd_generator` | 1-brainstorm | Synthesize all Phase 1 outputs into a comprehensive Product Requirements Documen |
| 32 | `prioritization_frameworks` | 1-brainstorm | Score and rank features using RICE, MoSCoW, and Kano to build the right things f |
| 33 | `product_metrics` | 1-brainstorm | Choose the right metrics to measure product success from North Star down to feat |
| 34 | `proposal_generator` | 1-brainstorm | Quick proposal creation for client projects |
| 35 | `smb_launchpad` | 1-brainstorm | Complete service delivery workflow for SMB website + consulting clients |
| 36 | `user_research` | 1-brainstorm | Validate assumptions before building — user interviews, usability testing, fee |
| 37 | `user_story_standards` | 1-brainstorm | Write clear user stories with acceptance criteria using proven formats and quali |
| 38 | `accessibility_design` | 2-design | WCAG 2.1/2.2 conformance planning with keyboard navigation, ARIA patterns, and a |
| 39 | `api_contract_design` | 2-design | Contract-first API design producing OpenAPI 3.0 specs before implementation with |
| 40 | `architecture_decision_records` | 2-design | Capture architectural decisions using MADR v3.0 format with full lifecycle manag |
| 41 | `atomic_reverse_architecture` | 2-design | Unified methodology combining First Principles decomposition with Reverse Thinki |
| 42 | `c4_architecture_diagrams` | 2-design | Produces all 4 C4 model levels in Mermaid syntax with audience guidance per leve |
| 43 | `cost_architecture` | 2-design | Cloud cost modeling during design phase with resource sizing, FinOps tagging, bu |
| 44 | `cross_platform_architecture` | 2-design | Choosing cross-platform approach between React Native, Flutter, KMP, and web wit |
| 45 | `data_privacy_design` | 2-design | PII classification, data residency, retention policies, right-to-erasure design, |
| 46 | `deployment_modes` | 2-design | Mandatory 3-tier compliance check (Cloud/Hybrid/Sovereign) for every feature, sp |
| 47 | `design_handoff` | 2-design | Consolidates all Phase 2 outputs into a Design Package with sign-off -- the Phas |
| 48 | `design_intake` | 2-design | Validates Phase 1 artifacts for completeness before design work begins -- the Ph |
| 49 | `distributed_tracing_design` | 2-design | Designs end-to-end distributed tracing with context propagation, span convention |
| 50 | `embedding_pipeline_design` | 2-design | Design embedding pipelines with model selection, chunking strategies, dimension  |
| 51 | `feature_architecture` | 2-design | Create comprehensive architecture documentation for any feature - includes data  |
| 52 | `feature_store_design` | 2-design | Design and implement feature stores with Feast, Tecton, and Hopsworks for online |
| 53 | `inclusive_design_patterns` | 2-design | Inclusive design covering cognitive accessibility, multilingual UX, color contra |
| 54 | `internationalization_design` | 2-design | Phase 2 i18n architecture decisions covering string externalization, locale-awar |
| 55 | `multi_tenancy_architecture` | 2-design | Tenancy model selection framework with isolation patterns, tenant resolution, cr |
| 56 | `nfr_specification` | 2-design | Produces measurable Non-Functional Requirements across 7 dimensions with SLO tar |
| 57 | `observability_architecture_design` | 2-design | Designs the three pillars of observability (logs, metrics, traces) with tool sel |
| 58 | `rto_rpo_design` | 2-design | Captures Recovery Time and Recovery Point Objectives with tiered service classif |
| 59 | `schema_standards` | 2-design | Template and guide for creating rigorous data schemas that developers can implem |
| 60 | `security_threat_modeling` | 2-design | STRIDE-based threat modeling against system architecture with DFD, threat enumer |
| 61 | `slo_sla_design` | 2-design | Designs Service Level Indicators, Objectives, and Agreements with error budget c |
| 62 | `accessibility_implementation` | 3-build | WCAG 2.2 implementation with ARIA, semantic HTML, screen readers, keyboard navig |
| 63 | `ai_agent_development` | 3-build | Build AI agents with LangChain, LangGraph, CrewAI, AutoGen, and custom framework |
| 64 | `airflow_orchestration` | 3-build | Apache Airflow DAG design, operators, sensors, XCom, connections, pools, and pro |
| 65 | `api_design` | 3-build | RESTful API design patterns with NestJS implementation |
| 66 | `api_gateway_patterns` | 3-build | API gateways with Kong and AWS API Gateway covering rate limiting, auth, transfo |
| 67 | `audit_logging_architecture` | 3-build | Design and implement compliance-grade immutable audit logging with tamper detect |
| 68 | `auth_implementation` | 3-build | Authentication and authorization patterns including JWT, RBAC, OAuth, and sessio |
| 69 | `authorization_patterns` | 3-build | Implement RBAC, ABAC, and ownership-based authorization with NestJS guards and p |
| 70 | `backend_patterns` | 3-build | Backend architecture patterns, API design, database optimization, and server-sid |
| 71 | `backward_compatibility` | 3-build | Evolve APIs and database schemas without breaking existing consumers using addit |
| 72 | `bug_troubleshoot` | 3-build | Systematic debugging process for identifying, isolating, and fixing bugs in full |
| 73 | `caching_strategies` | 3-build | Caching with Redis, Memcached, and CDN covering cache invalidation, write-throug |
| 74 | `clickhouse_io` | 3-build | ClickHouse database patterns, query optimization, analytics, and data engineerin |
| 75 | `code_changelog` | 3-build | Document every code change with version info for team onboarding and audit trail |
| 76 | `code_review` | 3-build | Bug reporting, troubleshooting, and code verification workflow |
| 77 | `code_review_response` | 3-build | How to receive, respond to, and learn from code reviews as a junior developer |
| 78 | `compliance_as_code` | 3-build | Automated compliance verification for SOC2, GDPR, HIPAA, and PCI-DSS using polic |
| 79 | `computer_vision_pipeline` | 3-build | Build CV pipelines for image classification, object detection, segmentation, and |
| 80 | `content_hash_cache` | 3-build | Cache expensive file processing results using SHA-256 content hashes — path-in |
| 81 | `cost_estimation` | 3-build | AI token costs, infrastructure pricing, time estimation, and budget tracking for |
| 82 | `cpp_coding_standards` | 3-build | C++ coding standards based on the C++ Core Guidelines (isocpp.github.io). Use wh |
| 83 | `dapp_development` | 3-build | Building decentralized applications with React, wagmi, and blockchain integratio |
| 84 | `dashboard_development` | 3-build | Building data dashboards, analytics interfaces, and business intelligence visual |
| 85 | `data_warehouse` | 3-build | Designing data warehouses, dimensional models, and analytical data layers with d |
| 86 | `database_migration_patterns` | 3-build | Schema migrations with zero-downtime, expand-contract, backfill strategies, roll |
| 87 | `database_optimization` | 3-build | PostgreSQL and Prisma query optimization, indexing, and performance patterns |
| 88 | `dependency_hygiene` | 3-build | Audit, pin, and secure project dependencies with automated vulnerability scannin |
| 89 | `design_system_development` | 3-build | Building design systems with component libraries, design tokens, Storybook, vers |
| 90 | `distributed_training` | 3-build | Distributed training with DDP, FSDP, DeepSpeed covering multi-GPU, multi-node, p |
| 91 | `django_patterns` | 3-build | Django architecture patterns, REST API design with DRF, ORM best practices, cach |
| 92 | `docker_development` | 3-build | Docker and Docker Compose patterns for full-stack NestJS + React development |
| 93 | `environment_setup` | 3-build | Development environment configuration for NestJS + React projects |
| 94 | `error_handling` | 3-build | Comprehensive error handling patterns for NestJS backend and React frontend |
| 95 | `etl_pipeline` | 3-build | Data extraction, transformation, and loading pipelines for reliable data process |
| 96 | `event_driven_architecture` | 3-build | Decouple services with event-based messaging using BullMQ, Redis Streams, and sa |
| 97 | `experiment_tracking` | 3-build | Track ML experiments with MLflow, W&B, Neptune, and ClearML for reproducible mod |
| 98 | `extension_development` | 3-build | Building browser extensions and IDE plugins for Chrome, Firefox, Safari, and VS  |
| 99 | `feature_flags` | 3-build | Comprehensive feature flag lifecycle from creation through rollout to cleanup. |
| 100 | `firmware_development` | 3-build | Embedded systems and firmware programming for microcontrollers and IoT devices |
| 101 | `flutter_development` | 3-build | Flutter widget architecture, state management with Riverpod and BLoC, platform c |
| 102 | `frontend_patterns` | 3-build | Frontend development patterns for React, Next.js, state management, performance  |
| 103 | `game_development` | 3-build | Game architecture patterns, engine selection, and core system implementation for |
| 104 | `git_workflow` | 3-build | Professional Git workflows including branching, commits, PRs, and recovery |
| 105 | `golang_patterns` | 3-build | Idiomatic Go patterns, best practices, and conventions for building robust, effi |
| 106 | `helm_chart_development` | 3-build | Helm chart creation, templating, values management, dependencies, testing, and c |
| 107 | `i18n_implementation` | 3-build | Implement internationalization with extraction-first development, locale-safe fo |
| 108 | `internal_developer_portal` | 3-build | Building internal developer portals with Backstage, service catalogs, templates, |
| 109 | `iot_platform` | 3-build | IoT cloud platform, device management, and connectivity for connected device fle |
| 110 | `java_coding_standards` | 3-build | Java coding standards for Spring Boot services: naming, immutability, Optional u |
| 111 | `jpa_patterns` | 3-build | JPA/Hibernate patterns for entity design, relationships, query optimization, tra |
| 112 | `kafka_event_streaming` | 3-build | Apache Kafka topics, partitions, consumer groups, schemas, exactly-once semantic |
| 113 | `kubernetes_operations` | 3-build | K8s workload management covering deployments, statefulsets, jobs, CRDs, RBAC, ne |
| 114 | `liquid_glass_design` | 3-build | iOS 26 Liquid Glass design system — dynamic glass material with blur, reflecti |
| 115 | `log_aggregation_pipeline` | 3-build | Log aggregation with ELK/EFK stack and Loki covering structured logging, correla |
| 116 | `lora_finetuning_workflow` | 3-build | End-to-end LoRA/QLoRA/PEFT fine-tuning workflows with dataset preparation, hyper |
| 117 | `message_queue_patterns` | 3-build | Message queues with RabbitMQ, SQS, and NATS covering pub/sub, fan-out, dead lett |
| 118 | `ml_pipeline` | 3-build | Machine learning model training, evaluation, and experiment tracking pipelines |
| 119 | `monorepo_tooling` | 3-build | Monorepo management with Nx, Turborepo, and Bazel covering task orchestration, a |
| 120 | `multi_stack_observability` | 3-build | Observability patterns for Django, Go, and Swift — structured logging, metrics |
| 121 | `multiplayer_systems` | 3-build | Real-time multiplayer game networking architecture, netcode patterns, and scalab |
| 122 | `nlp_text_pipeline` | 3-build | Build NLP pipelines for tokenization, NER, sentiment analysis, text classificati |
| 123 | `notification_systems` | 3-build | Design and implement multi-channel notification systems — email, SMS, push, in |
| 124 | `observability` | 3-build | Structured logging, metrics, tracing, and alerting for NestJS production applica |
| 125 | `opentelemetry_implementation` | 3-build | OpenTelemetry SDK setup for distributed tracing, metrics, and log correlation ac |
| 126 | `privacy_by_design` | 3-build | Implement data minimization, PII encryption, right-to-erasure, consent managemen |
| 127 | `progressive_web_app` | 3-build | PWA development with service workers, web app manifest, offline support, push no |
| 128 | `prompt_engineering` | 3-build | Designing effective LLM prompts and building RAG (Retrieval Augmented Generation |
| 129 | `python_patterns` | 3-build | Pythonic idioms, PEP 8 standards, type hints, and best practices for building ro |
| 130 | `rag_advanced_patterns` | 3-build | Advanced RAG patterns including query routing, re-ranking, hybrid search, recurs |
| 131 | `react_native_patterns` | 3-build | React Native navigation, state management, native modules, performance optimizat |
| 132 | `refactoring` | 3-build | Safe refactoring techniques and code smell detection for TypeScript codebases |
| 133 | `regex_vs_llm` | 3-build | Decision framework for choosing between regex and LLM when parsing structured te |
| 134 | `resiliency_patterns` | 3-build | Implement timeout, retry, circuit breaker, fallback, and bulkhead patterns for f |
| 135 | `retrospective` | 3-build | Sprint retrospective formats, root cause analysis, and continuous improvement fr |
| 136 | `runtime_security_monitoring` | 3-build | Real-time threat detection, WAF configuration, container runtime security, and a |
| 137 | `secret_management` | 3-build | Progress from .env files to production-grade secret management with rotation and |
| 138 | `service_mesh_patterns` | 3-build | Service mesh with Istio and Linkerd covering traffic management, mTLS, observabi |
| 139 | `smart_contract_dev` | 3-build | Blockchain smart contract development with Solidity, testing, and deployment wor |
| 140 | `spark_data_processing` | 3-build | Apache Spark DataFrames, SQL, structured streaming, partitioning, optimization,  |
| 141 | `spec_build` | 3-build | 12-phase autonomous spec creation workflow - the master loop for building featur |
| 142 | `springboot_patterns` | 3-build | Spring Boot architecture patterns, REST API design, layered services, data acces |
| 143 | `sprint_planning` | 3-build | Plan, estimate, and run 1-2 week sprints with story points, standups, and review |
| 144 | `stakeholder_communication` | 3-build | Templates and frameworks for keeping stakeholders informed throughout a project |
| 145 | `state_machine_patterns` | 3-build | Model workflows as explicit state machines with database-backed transitions and  |
| 146 | `swift_actor_persistence` | 3-build | Thread-safe data persistence in Swift using actors — in-memory cache with file |
| 147 | `swift_concurrency` | 3-build | Swift 6.2 Approachable Concurrency — single-threaded by default, @concurrent f |
| 148 | `swift_protocol_di_testing` | 3-build | Protocol-based dependency injection for testable Swift code — mock file system |
| 149 | `synthetic_data_generation` | 3-build | Generate high-quality synthetic training data using LLMs, statistical methods, G |
| 150 | `test_driven_build` | 3-build | Embed red-green-refactor into the Phase 3 implementation loop with minimum cover |
| 151 | `trading_systems` | 3-build | Building trading bots, backtesting engines, and financial data pipelines |
| 152 | `ui_polish` | 3-build | Debug and polish user interfaces for professional, production-ready quality |
| 153 | `vector_database_operations` | 3-build | Vector DB operations with pgvector, Pinecone, Weaviate, Qdrant, ChromaDB, and Mi |
| 154 | `website_build` | 3-build | Standards and checklist for building premium, high-converting websites (Anti-AI- |
| 155 | `accessibility_testing` | 4-secure | WCAG 2.1 AA compliance auditing with axe-core, keyboard testing, and screen read |
| 156 | `ai_safety_guardrails` | 4-secure | AI safety implementation including content filtering, prompt injection defense,  |
| 157 | `api_security_testing` | 4-secure | OWASP API Security Top 10 testing methodology with per-endpoint checklists for R |
| 158 | `build_reproducibility_testing` | 4-secure | Deterministic build validation, artifact hash comparison, hermetic build verific |
| 159 | `chaos_engineering` | 4-secure | Scheduled failure injection testing with gameday runbooks to validate system res |
| 160 | `compliance_testing_framework` | 4-secure | Map testing activities to compliance controls for SOC2, HIPAA, GDPR, and PCI-DSS |
| 161 | `container_security` | 4-secure | Dockerfile hardening, image vulnerability scanning with Trivy, and runtime secur |
| 162 | `cpp_testing` | 4-secure | Use only when writing/updating/fixing C++ tests, configuring GoogleTest/CTest, d |
| 163 | `django_security` | 4-secure | Django security best practices, authentication, authorization, CSRF protection,  |
| 164 | `django_tdd` | 4-secure | Django testing strategies with pytest-django, TDD methodology, factory_boy, mock |
| 165 | `django_verification` | 4-secure | Verification loop for Django projects: migrations, linting, tests with coverage, |
| 166 | `e2e_testing` | 4-secure | End-to-end testing with Playwright for full-stack NestJS + React applications |
| 167 | `eval_harness` | 4-secure | Formal evaluation framework for Claude Code sessions implementing eval-driven de |
| 168 | `financial_compliance` | 4-secure | Regulatory compliance guidance for financial and fintech applications |
| 169 | `golang_testing` | 4-secure | Go testing patterns including table-driven tests, subtests, benchmarks, fuzzing, |
| 170 | `hipaa_compliance_testing` | 4-secure | Comprehensive HIPAA Security Rule testing for applications handling Protected He |
| 171 | `infrastructure_testing` | 4-secure | IaC testing with Terratest, Checkov, tfsec, Conftest, Kitchen-Terraform, and pol |
| 172 | `integration_testing` | 4-secure | Supertest API integration tests for NestJS endpoints with auth and org-scoping |
| 173 | `ip_protection` | 4-secure | Intellectual property protection checklist for patents, trademarks, trade secret |
| 174 | `llm_evaluation_benchmarking` | 4-secure | Evaluate LLM quality using automated metrics, human evaluation, LLM-as-judge, an |
| 175 | `mobile_security_testing` | 4-secure | Mobile security testing with OWASP MASVS, certificate pinning, secure storage, j |
| 176 | `mobile_testing_strategy` | 4-secure | Mobile testing approaches including unit, widget, integration, E2E with Detox an |
| 177 | `mutation_testing` | 4-secure | Validate test suite effectiveness using Stryker.js, mutmut, or PIT to ensure tes |
| 178 | `pci_dss_compliance_testing` | 4-secure | PCI-DSS v4.0 compliance testing for applications processing, storing, or transmi |
| 179 | `performance_testing` | 4-secure | k6 load tests, Lighthouse CI, and Node.js performance profiling |
| 180 | `privacy_by_design_testing` | 4-secure | DPIA assessment, PII discovery with Presidio, consent verification, and right-to |
| 181 | `python_testing` | 4-secure | Python testing strategies using pytest, TDD methodology, fixtures, mocking, para |
| 182 | `rlhf_alignment` | 4-secure | Model alignment with RLHF, DPO, ORPO, KTO including reward modeling, preference  |
| 183 | `sast_scanning` | 4-secure | Configure and run Static Application Security Testing with Semgrep or CodeQL as  |
| 184 | `secrets_scanning` | 4-secure | Three-layer secret detection covering pre-commit prevention, CI gate scanning, a |
| 185 | `security_audit` | 4-secure | Comprehensive security checklist for features, projects, and AI coding tool eval |
| 186 | `springboot_security` | 4-secure | Spring Security best practices for authn/authz, validation, CSRF, secrets, heade |
| 187 | `springboot_tdd` | 4-secure | Test-driven development for Spring Boot using JUnit 5, Mockito, MockMvc, Testcon |
| 188 | `springboot_verification` | 4-secure | Verification loop for Spring Boot projects: build, static analysis, tests with c |
| 189 | `ssrf_testing_harness` | 4-secure | Comprehensive Server-Side Request Forgery testing methodology covering attack ta |
| 190 | `supply_chain_security` | 4-secure | Software Composition Analysis with SBOM generation, dependency confusion detecti |
| 191 | `tdd_workflow` | 4-secure | Use this skill when writing new features, fixing bugs, or refactoring code. Enfo |
| 192 | `unit_testing` | 4-secure | Jest/Vitest unit test patterns for NestJS services and React components |
| 193 | `verification_loop` | 4-secure | A comprehensive verification system for Claude Code sessions. |
| 194 | `web3_security` | 4-secure | Smart contract security auditing, vulnerability detection, and audit reporting |
| 195 | `ai_model_monitoring` | 5.5-alpha | Monitor ML models in production for data drift, concept drift, performance degra |
| 196 | `alpha_exit_criteria` | 5.5-alpha | Measurable exit gates for alpha graduation to beta with scoring rubric and exit  |
| 197 | `alpha_incident_communication` | 5.5-alpha | Incident communication protocol for alpha's small, high-trust tester cohort with |
| 198 | `alpha_program_management` | 5.5-alpha | End-to-end alpha program lifecycle including tester recruitment, access gating,  |
| 199 | `alpha_telemetry` | 5.5-alpha | Alpha-specific instrumentation for session-level events, crash reporting, perfor |
| 200 | `backup_strategy` | 5.5-alpha | Database backup and disaster recovery procedures for PostgreSQL |
| 201 | `env_validation` | 5.5-alpha | Fail-fast startup validation for missing or malformed environment variables |
| 202 | `error_tracking` | 5.5-alpha | Sentry setup for production error monitoring across NestJS, React, and Next.js |
| 203 | `health_checks` | 5.5-alpha | Application health and readiness endpoints with NestJS Terminus |
| 204 | `qa_playbook` | 5.5-alpha | Manual QA testing procedures with structured test cases and severity classificat |
| 205 | `beta_cohort_management` | 5.75-beta | Manage beta tester segments with cohort creation, per-cohort analytics, feature  |
| 206 | `beta_graduation_criteria` | 5.75-beta | Measurable exit gates and GA readiness assessment for transitioning from beta to |
| 207 | `beta_sla_definition` | 5.75-beta | Define and communicate beta service level commitments including uptime targets,  |
| 208 | `beta_to_ga_migration` | 5.75-beta | Complete transition procedure from beta to general availability including flag c |
| 209 | `email_templates` | 5.75-beta | Branded transactional email templates with Resend and React Email |
| 210 | `error_boundaries` | 5.75-beta | React error boundaries, toast notifications, and graceful error handling UI |
| 211 | `feature_flags` | 5.75-beta | Gradual rollouts, A/B testing, kill switches, and flag management for safe featu |
| 212 | `feedback_system` | 5.75-beta | In-app bug reporter and feedback collection system with triage workflow |
| 213 | `load_testing` | 5.75-beta | k6-based load testing for beta with script development, acceptance criteria, CI  |
| 214 | `privacy_consent_management` | 5.75-beta | GDPR/CCPA consent infrastructure with consent collection, withdrawal flows, audi |
| 215 | `product_analytics` | 5.75-beta | PostHog setup for user behavior tracking across backend, frontend, and website |
| 216 | `rate_limiting` | 5.75-beta | API rate limiting with @nestjs/throttler and plan-based tiers |
| 217 | `usage_metering_billing` | 5.75-beta | Stripe Meters API integration for usage-based billing, metering service implemen |
| 218 | `app_store_deployment` | 5-ship | App store submission for iOS App Store and Google Play including signing, versio |
| 219 | `artifact_provenance_chain` | 5-ship | SLSA provenance attestation, Sigstore/cosign signing, SBOM generation, and suppl |
| 220 | `canary_verification` | 5-ship | Automated canary deployment promotion gates using error rate, latency, and busin |
| 221 | `change_management` | 5-ship | Lightweight auditable change records for production deployments mapped to SOC2 C |
| 222 | `ci_cd_pipeline` | 5-ship | GitHub Actions CI/CD configuration for mono-repo projects with automated lint, t |
| 223 | `db_migrations` | 5-ship | Safe database schema evolution with Prisma Migrate — zero-downtime strategies, |
| 224 | `deployment_approval_gates` | 5-ship | Multi-gate deployment pipeline with pre-deploy checks, migration gates, manual a |
| 225 | `deployment_patterns` | 5-ship | Deployment workflows, CI/CD pipeline patterns, Docker containerization, health c |
| 226 | `deployment_verification` | 5-ship | Automated post-deployment verification with health checks, smoke tests, and metr |
| 227 | `desktop_publishing` | 5-ship | Building, signing, and distributing desktop applications with Electron, Tauri, o |
| 228 | `game_publishing` | 5-ship | Publishing and distributing games to Steam, mobile app stores, and other game pl |
| 229 | `gitops_workflow` | 5-ship | GitOps with ArgoCD and Flux covering directory structures, sync strategies, roll |
| 230 | `infrastructure_as_code` | 5-ship | Docker, Docker Compose, Terraform, and Kubernetes patterns for containerized ful |
| 231 | `legal_compliance` | 5-ship | Terms of Service, Privacy Policy, Cookie Policy, and Acceptable Use Policy templ |
| 232 | `mlops` | 5-ship | ML model deployment, serving, monitoring, and lifecycle management in production |
| 233 | `mlops_pipeline` | 5-ship | Build end-to-end MLOps pipelines with CI/CD for ML, model validation gates, auto |
| 234 | `model_registry_management` | 5-ship | Version, stage, promote, and govern ML models through their lifecycle with MLflo |
| 235 | `model_serving_deployment` | 5-ship | Deploy and serve ML models with TorchServe, TGI, vLLM, Triton, and BentoML inclu |
| 236 | `multi_stack_deployment` | 5-ship | Deployment patterns for Django, Go, and Swift/iOS — production configs, CI/CD  |
| 237 | `oss_publishing` | 5-ship | Publishing, maintaining, and growing open source projects across package registr |
| 238 | `release_signing` | 5-ship | Cryptographic signing of release artifacts including Docker images, npm packages |
| 239 | `seed_data` | 5-ship | Database seeding patterns for demo data, testing fixtures, and development envir |
| 240 | `website_launch` | 5-ship | Complete checklist for launching websites including design, content, SEO, analyt |
| 241 | `access_handoff` | 6-handoff | Structured credential and access transfer with inventory, transfer matrix, revoc |
| 242 | `api_reference` | 6-handoff | OpenAPI/Swagger documentation for NestJS APIs — setup, decorators, client SDK  |
| 243 | `community_management` | 6-handoff | Managing open source communities, contributor ecosystems, and project governance |
| 244 | `compliance_certification_handoff` | 6-handoff | Compliance evidence assembly, control owner matrix, audit calendar, continuous c |
| 245 | `disaster_recovery` | 6-handoff | Runbook creation for production failures, incident response procedures, and post |
| 246 | `doc_reorganize` | 6-handoff | Analyze and restructure documents for clarity without deleting content - the fin |
| 247 | `feature_walkthrough` | 6-handoff | ALWAYS create a walkthrough after completing any feature or workflow - explains  |
| 248 | `knowledge_audit` | 6-handoff | Capture undocumented tribal knowledge before team transitions using a 5-step aud |
| 249 | `monitoring_handoff` | 6-handoff | Transfer monitoring ownership with alert maps, on-call rotation setup, dashboard |
| 250 | `observability_handoff` | 6-handoff | Dashboard inventory transfer, alert rule documentation, on-call rotation setup,  |
| 251 | `operational_readiness_review` | 6-handoff | Formal readiness gate verifying all Phase 6 skills are complete with stakeholder |
| 252 | `sla_handoff` | 6-handoff | Define and communicate GA service level agreements with SLO definitions, error b |
| 253 | `support_enablement` | 6-handoff | Onboard support teams with diagnostic decision trees, escalation matrices, known |
| 254 | `user_documentation` | 6-handoff | Standards and templates for creating user-facing documentation, in-app help, and |
| 255 | `capacity_planning_and_performance` | 7-maintenance | Performance baseline establishment, monthly trend tracking, capacity forecasting |
| 256 | `compliance_dashboard` | 7-maintenance | Real-time compliance status visualization, control health scoring, evidence fres |
| 257 | `continuous_learning` | 7-maintenance | Instinct-based learning system that observes sessions via hooks, creates atomic  |
| 258 | `dependency_management` | 7-maintenance | npm audit workflows, license checking, update cadence, and supply chain security |
| 259 | `documentation_standards` | 7-maintenance | Master template and guide for creating SOPs, Work Instructions, and Schemas |
| 260 | `incident_response_operations` | 7-maintenance | Active incident lifecycle management from detection through post-mortem with on- |
| 261 | `operational_readiness_gate` | 7-maintenance | Phase 6-to-7 transition gate validating all operational artifacts, plus Phase 7- |
| 262 | `regulatory_change_monitoring` | 7-maintenance | Regulatory feed monitoring, change impact assessment, compliance gap analysis, i |
| 263 | `security_maintenance` | 7-maintenance | Ongoing security practice with monthly CVE monitoring, patch prioritization, pen |
| 264 | `slo_sla_management` | 7-maintenance | Ongoing SLO/SLA tracking, error budget management, burn-rate monitoring, and dep |
| 265 | `sop_standards` | 7-maintenance | Master template and guide for creating machine-readable, delegation-ready Standa |
| 266 | `ssot_update` | 7-maintenance | Ensure the Single Source of Truth (SSoT) Master Index is updated after every sig |
| 267 | `wi_standards` | 7-maintenance | Template and guide for creating click-level, granular Work Instructions that sup |
| 268 | `age` | toolkit | Axiomatic Thinking for Omnidirectional Meta-analysis — A 53-Loop, 51-Method Un |
| 269 | `age_to_skill_pipeline` | toolkit | Converts ATOM analysis gap findings into production-ready skills through triage, |
| 270 | `ai_cost_optimization` | toolkit | Optimize AI infrastructure costs including GPU selection, token tracking, model  |
| 271 | `ai_security_hardening` | toolkit | Security hardening for AI-assisted development workflows covering prompt injecti |
| 272 | `ai_tool_orchestration` | toolkit | When and how to use Claude Code, Cursor, Copilot, and Gemini together for maximu |
| 273 | `ceo-brain` | toolkit | Orchestrates high-level strategy and decision making with the 9 Universal Brains |
| 274 | `compliance_program` | toolkit | Three-part compliance program covering regime identification, per-phase checklis |
| 275 | `content_creation` | toolkit | Script writing, hooks, filming, and editing for content |
| 276 | `content_waterfall` | toolkit | Extract 30+ shorts from 1 long-form video (Magnum Opus) - combines cascade and w |
| 277 | `cost_aware_llm_pipeline` | toolkit | Cost optimization patterns for LLM API usage — model routing by task complexit |
| 278 | `delivery_metrics` | toolkit | DORA metrics instrumentation capturing deployment frequency, lead time, MTTR, an |
| 279 | `developer_experience_tooling` | toolkit | DevEx tooling including CLI tools, dev containers, dotfiles, onboarding automati |
| 280 | `documentation_as_code` | toolkit | Docs-as-code workflows with Docusaurus, MkDocs, OpenAPI documentation, versioned |
| 281 | `dora_metrics_tracking` | toolkit | Four-quadrant DORA metrics collection and reporting covering deployment frequenc |
| 282 | `eu_ai_act_compliance` | toolkit | Risk classification, conformity assessment, and compliance guidance for AI syste |
| 283 | `governance_framework` | toolkit | Team-scale configuration guide with three tiers (Solo, SMB, Enterprise) defining |
| 284 | `green_software_practices` | toolkit | Carbon-aware computing, energy-efficient algorithms, cloud region selection, and |
| 285 | `iso_27001_implementation` | toolkit | End-to-end ISO 27001:2022 ISMS implementation covering scope definition, risk as |
| 286 | `iterative_retrieval` | toolkit | Pattern for progressively refining context retrieval to solve the subagent conte |
| 287 | `observability_maturity_model` | toolkit | Four-level observability maturity framework mapping implementation guidance from |
| 288 | `personal_brand` | toolkit | Voice consistency, content scheduling, and brand maintenance |
| 289 | `phase_gate_contracts` | toolkit | Machine-checkable entry and exit criteria for all 10 phase transitions, transfor |
| 290 | `progressive_rollout_playbook` | toolkit | End-to-end traffic migration playbook from dev (0%) through alpha, beta, canary, |
| 291 | `project_state_persistence` | toolkit | Persistent project health artifact updated at each phase exit, capturing current |
| 292 | `responsible_ai_framework` | toolkit | Implement responsible AI practices including fairness, bias detection, explainab |
| 293 | `skill_lifecycle_manager` | toolkit | Manages skill versioning, deprecation, sunsetting, compatibility matrices, and h |
| 294 | `skill_registry` | toolkit | Central registry for all framework skills with metadata, search, usage auditing, |
| 295 | `sre_foundations` | toolkit | Comprehensive SRE practice framework covering SLO definition, error budgets, toi |
| 296 | `strategic_compact` | toolkit | Suggests manual context compaction at logical intervals to preserve context thro |
| 297 | `toolkit_phase_integration_guide` | toolkit | Definitive reference for which toolkit skills activate at which phase events, wi |
| 298 | `video_research` | toolkit | Analyze viral videos to extract hooks, structures, and patterns |

---

## Summary

| Phase | Count |
|-------|-------|
| 0-context | 23 |
| 1-brainstorm | 14 |
| 2-design | 24 |
| 3-build | 93 |
| 4-secure | 40 |
| 5-ship | 23 |
| 5.5-alpha | 10 |
| 5.75-beta | 13 |
| 6-handoff | 14 |
| 7-maintenance | 13 |
| toolkit | 31 |
| **Total** | **298** |
