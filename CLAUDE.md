# riftkit

A phase-based software development framework with 339 skills, 19 agents, 44 commands, 25 workflows, and 45 rules.
Skills live in `.agent/skills/{phase}/`, agents in `.agent/agents/`, commands in `.agent/commands/`.

---

## Quick Start

1. **New project?** Read `.agent/skills/0-context/new_project/SKILL.md` then `.agent/skills/0-context/phase_0_playbook/SKILL.md`
2. **Existing project?** Read `.agent/skills/0-context/project_context/SKILL.md` to establish context
3. **Know what you need?** Use the Common Tasks table below to find the right skill
4. **Want a command?** Run any `/command` listed in the Commands section (e.g., `/plan`, `/tdd`, `/code-review`)

---

## How It All Fits Together

**Skills** are the knowledge -- step-by-step guides for specific tasks (339 total).
**Agents** are the specialists -- AI personas that apply skills with domain expertise (19 total).
**Commands** are the shortcuts -- `/slash-commands` that invoke agents with the right skills (44 total).

When you run `/code-review`, it activates the `code-reviewer` agent, which follows the `code_review` skill.
You can also reference skills directly: "Follow the `code_review` skill to review this PR."

---

## Common Tasks -- Intent to Skill Router

| What you want to do | Skills to read | Command |
|---|---|---|
| Start a new project | `0-context/new_project` + `0-context/phase_0_playbook` | `/plan` |
| Write a PRD | `1-brainstorm/idea_to_spec` + `1-brainstorm/prd_generator` | `/plan` |
| Design architecture | `2-design/atomic_reverse_architecture` + `2-design/feature_architecture` + `2-design/c4_architecture_diagrams` | Use skill directly |
| Build a feature | `3-build/spec_build` (master build loop) | `/plan` then `/tdd` |
| Fix a bug | `3-build/bug_troubleshoot` | `/build-fix` |
| Write tests | `4-secure/tdd_workflow` + `4-secure/unit_testing` | `/tdd` |
| Do a code review | `3-build/code_review` + `3-build/code_review_response` | `/code-review` |
| Run security audit | `4-secure/security_audit` + `4-secure/sast_scanning` + `4-secure/secrets_scanning` | `/verify` |
| Deploy to production | `5-ship/deployment_patterns` + `5-ship/ci_cd_pipeline` + `5-ship/deployment_verification` | `/deploy` |
| Set up monitoring | `3-build/observability` + `5.5-alpha/error_tracking` + `5.5-alpha/health_checks` | Use skill directly |
| Prepare for launch | `7-maintenance/operational_readiness_gate` + `5.75-beta/beta_graduation_criteria` | `/verify` |
| Handle an incident | `7-maintenance/incident_response_operations` + `6-handoff/disaster_recovery` | `/incident` |
| Update documentation | `7-maintenance/documentation_standards` | `/update-docs` |
| Refactor code | `3-build/refactoring` | `/refactor-clean` |
| Plan a sprint | `3-build/sprint_planning` + `1-brainstorm/prioritization_frameworks` | `/plan` |
| Build a website | `3-build/website_build` + `5-ship/website_launch` | Use skill directly |
| Client project intake | `1-brainstorm/client_discovery` + `1-brainstorm/proposal_generator` | Use skill directly |
| Database review | `3-build/database_optimization` | Use skill directly |
| Set up CI/CD | `5-ship/ci_cd_pipeline` | Use skill directly |
| Go language review | -- | `/go-review` |
| Python code review | -- | `/python-review` |
| E2E testing | `4-secure/e2e_testing` | `/e2e` |
| Manage tech debt | `0-context/tech_debt_assessment` + `3-build/refactoring` | Use skill directly |
| Run gap analysis / ATOM | `toolkit/age` (53-loop discovery engine) | `/atom` or `/age` |
| Run adversarial audit | `toolkit/age` + `toolkit/age_to_skill_pipeline` | `/adversarial-audit` |
| Fine-tune an LLM | `3-build/lora_finetuning_workflow` + `4-secure/llm_evaluation_benchmarking` | Use skill directly |
| Build a RAG system | `3-build/rag_advanced_patterns` + `3-build/vector_database_operations` | Use skill directly |
| Build an AI agent | `3-build/ai_agent_development` + `4-secure/ai_safety_guardrails` | Use skill directly |
| Deploy ML models | `5-ship/model_serving_deployment` + `5-ship/mlops_pipeline` | Use skill directly |
| Set up Kubernetes | `3-build/kubernetes_operations` + `3-build/helm_chart_development` | Use skill directly |
| Build mobile app | `3-build/react_native_patterns` or `3-build/flutter_development` | Use skill directly |
| Set up GitOps | `5-ship/gitops_workflow` + `5-ship/ci_cd_pipeline` | Use skill directly |
| Event streaming | `3-build/kafka_event_streaming` + `3-build/message_queue_patterns` | Use skill directly |
| Accessibility | `3-build/accessibility_implementation` + `2-design/inclusive_design_patterns` | Use skill directly |
| Build multi-agent system | `3-build/agent_communication_protocols` + `3-build/agent_memory_systems` | Use skill directly |
| Manage AI agent fleet | `3-build/ai_agent_fleet_management` + `3-build/llm_provider_management` | `/fleet` |
| Build voice AI | `3-build/voice_ai_patterns` + `3-build/websocket_patterns` | Use skill directly |
| Quant trading | `3-build/quantitative_trading_strategies` + `3-build/ml_trading_signals` + `4-secure/backtesting_methodology` | Use skill directly |
| Run AI red team | `4-secure/ai_red_teaming` + `4-secure/prompt_injection_hardening` | Use skill directly |
| Deploy with NVIDIA NIM | `5-ship/nvidia_nim_deployment` + `5-ship/model_serving_deployment` | Use skill directly |
| Quantum computing | `3-build/quantum_computing_fundamentals` + `3-build/quantum_optimization_algorithms` | Use skill directly |

**Skill path pattern:** `.agent/skills/{phase}/{skill_name}/SKILL.md`

---

## Phases Overview

| Phase | Name | Focus | Skill Count |
|---|---|---|---|
| 0 | Context | Understand the project, codebase, risks, team | 23 |
| 1 | Brainstorm | Ideas, research, requirements, PRDs | 14 |
| 2 | Design | Architecture, schemas, threat models, ADRs | 24 |
| 3 | Build | Implementation, patterns, tools, workflows | 123 |
| 4 | Secure | Testing, security audits, compliance | 47 |
| 5 | Ship | CI/CD, deployment, publishing, migrations | 25 |
| 5.5 | Alpha | Error tracking, health checks, QA, backups | 10 |
| 5.75 | Beta | Analytics, feedback, rate limiting, billing | 13 |
| 6 | Handoff | Docs, DR, monitoring handoff, access handoff | 14 |
| 7 | Maintenance | SLOs, incidents, dependencies, capacity | 13 |
| -- | Toolkit | Cross-cutting: AGE, content, governance, SRE | 33 |

---

## Phase 0 -- Context (23 skills)

| Skill | What it does |
|---|---|
| `architecture_recovery` | Reverse-engineer architecture from existing code |
| `codebase_health_audit` | Automated quality, security, and dependency scan |
| `codebase_navigation` | Navigate and understand unfamiliar codebases |
| `compliance_context` | Inventory regulatory frameworks that apply |
| `dev_environment_setup` | Fresh clone to working dev environment |
| `documentation_framework` | Reference for all documentation types |
| `incident_history_review` | Analyze patterns in past incidents |
| `infrastructure_audit` | Map networking, DNS, and infra topology |
| `legacy_modernization` | Strangler fig and modernization strategies |
| `new_project` | Start a brand new project from scratch |
| `phase_0_playbook` | Meta-skill: sequence all Phase 0 skills |
| `phase_exit_summary` | Phase 0 to Phase 1 handoff brief |
| `project_context` | Single source of truth for project state |
| `project_guidelines` | Establish project-specific conventions |
| `regulated_industry_context` | Regulated industry context assessment |
| `risk_register` | Prioritized risk register with heat map |
| `search_first` | Research before coding |
| `ssot_structure` | Structure a Single Source of Truth document |
| `stakeholder_map` | Identify stakeholders and decision-makers |
| `supply_chain_audit` | SBOM and dependency integrity analysis |
| `system_design_review` | Evaluate scalability and fault tolerance |
| `team_knowledge_transfer` | Extract knowledge from outgoing team members |
| `tech_debt_assessment` | Quantify and prioritize technical debt |

## Phase 1 -- Brainstorm (14 skills)

| Skill | What it does |
|---|---|
| `assumption_testing` | Validate risky assumptions with experiments |
| `client_discovery` | Client intake questionnaire for service projects |
| `competitive_analysis` | Evaluate competitors, find market gaps |
| `go_no_go_gate` | 7-dimension GO/NO-GO decision gate |
| `idea_to_spec` | Convert raw ideas to implementation specs |
| `lean_canvas` | One-page business model canvas |
| `market_sizing` | TAM-SAM-SOM market analysis |
| `prd_generator` | Generate comprehensive PRD from Phase 1 outputs |
| `prioritization_frameworks` | RICE, MoSCoW, Kano scoring models |
| `product_metrics` | North Star and feature-level metrics |
| `proposal_generator` | Quick proposal for client projects |
| `smb_launchpad` | SMB website + consulting delivery |
| `user_research` | User interviews and usability testing |
| `user_story_standards` | User stories with acceptance criteria |

## Phase 2 -- Design (24 skills)

| Skill | What it does |
|---|---|
| `accessibility_design` | WCAG 2.1/2.2 conformance planning |
| `api_contract_design` | Contract-first OpenAPI 3.0 specs |
| `architecture_decision_records` | MADR v3.0 ADR format |
| `atomic_reverse_architecture` | First Principles + Reverse Thinking architecture |
| `c4_architecture_diagrams` | C4 model diagrams in Mermaid syntax |
| `cost_architecture` | Cloud cost modeling and FinOps |
| `cross_platform_architecture` | Cross-platform mobile/web architecture decisions |
| `data_privacy_design` | PII classification, GDPR Article 30 |
| `deployment_modes` | Cloud/Hybrid/Sovereign compliance check |
| `design_handoff` | Phase 2 to Phase 3 gate with sign-off |
| `design_intake` | Phase 1 to Phase 2 gate validation |
| `distributed_tracing_design` | Distributed tracing architecture design |
| `embedding_pipeline_design` | Embedding model selection and pipeline design |
| `feature_architecture` | Comprehensive feature architecture documents |
| `feature_store_design` | Feature store architecture for ML systems |
| `inclusive_design_patterns` | Inclusive and accessible design patterns |
| `internationalization_design` | i18n architecture decisions |
| `multi_tenancy_architecture` | Tenancy model selection guide |
| `nfr_specification` | Non-Functional Requirements with SLO targets |
| `observability_architecture_design` | Observability architecture design |
| `rto_rpo_design` | Recovery Time/Point Objective design |
| `schema_standards` | Rigorous data schema templates |
| `security_threat_modeling` | STRIDE-based threat modeling |
| `slo_sla_design` | SLO/SLA design and error budget planning |

## Phase 3 -- Build (123 skills)

| Skill | What it does |
|---|---|
| `accessibility_implementation` | WCAG 2.2 implementation with ARIA and focus management |
| `agent_communication_protocols` | Standardized protocols for agent-to-agent communication — A2A, ACP, MCP integration, message schemas, and authentication |
| `agent_conflict_resolution` | Mutex/lock patterns for shared resources, optimistic concurrency, consensus protocols, deadlock detection, and conflict merge strategies for multi-agent systems |
| `agent_memory_systems` | Persistent memory for AI agents — short-term, long-term, episodic, and semantic memory with Mem0, Zep, and custom stores |
| `agent_registry_discovery` | Service registry for AI agents — capability advertisement, dynamic routing, health-aware load balancing |
| `ai_agent_development` | AI agent building with LangChain, CrewAI, multi-agent |
| `ai_agent_fleet_management` | Managing multiple AI agent instances across machines — provisioning, monitoring, coordination, and cost control |
| `airflow_orchestration` | Apache Airflow DAG development and orchestration |
| `api_design` | API endpoint design patterns |
| `api_gateway_patterns` | API gateway patterns with Kong, AWS API Gateway |
| `audit_logging_architecture` | Audit logging architecture design |
| `auth_implementation` | Authentication implementation |
| `authorization_patterns` | Authorization and RBAC/ABAC patterns |
| `autonomous_systems` | Build autonomous vehicles and robotics using perception (cameras, LiDAR, sensor fusion), planning, control (PID, MPC), simulation (CARLA, AirSim), and safety validation with V2X |
| `backend_patterns` | Backend architecture patterns |
| `backward_compatibility` | Backward compatibility strategies |
| `bug_troubleshoot` | Systematic bug diagnosis and fix |
| `caching_strategies` | Caching with Redis, CDN, invalidation strategies |
| `causal_inference_production` | Move beyond correlation with DoWhy, EconML, and CausalML — A/B testing beyond averages, uplift modeling, instrumental variables, regression discontinuity, and causal discovery (PC, NOTEARS) |
| `clickhouse_io` | ClickHouse database patterns |
| `code_changelog` | Generate changelogs from commits |
| `code_review` | Code review checklist and process |
| `code_review_response` | Respond to code review feedback |
| `compliance_as_code` | Compliance as code patterns |
| `computational_physics` | Simulate physical systems using PDE/ODE solvers, FEniCS, OpenFOAM, PyBullet, and JAX for GPU-accelerated physics including fluid dynamics, molecular dynamics, and N-body problems |
| `computer_vision_pipeline` | CV pipelines with YOLO, Detectron2, torchvision |
| `content_hash_cache` | Content-addressable caching |
| `cost_estimation` | Development effort estimation |
| `cpp_coding_standards` | C++ coding standards |
| `dapp_development` | Decentralized application development |
| `dashboard_development` | Dashboard and data visualization |
| `data_mesh_architecture` | Design domain-oriented decentralized data platforms — data as a product, self-serve infrastructure, federated governance, data contracts, using Dataplex, Unity Catalog, and open standards |
| `data_warehouse` | Data warehouse design |
| `database_migration_patterns` | Zero-downtime schema migrations |
| `database_optimization` | Database query and schema optimization |
| `dependency_hygiene` | Dependency management best practices |
| `design_system_development` | Design system components, tokens, Storybook |
| `digital_twin_development` | Build real-time virtual replicas of physical systems using NVIDIA Omniverse, Azure Digital Twins, and AWS IoT TwinMaker — sensor integration, simulation, and predictive maintenance |
| `distributed_training` | Distributed ML training with DDP, FSDP, DeepSpeed |
| `django_patterns` | Django-specific patterns |
| `docker_development` | Docker containerization |
| `environment_setup` | Development environment configuration |
| `error_handling` | Error handling strategies |
| `etl_pipeline` | ETL/ELT pipeline development |
| `event_driven_architecture` | Event-driven and message queue patterns |
| `experiment_tracking` | ML experiment tracking with MLflow, W&B |
| `extension_development` | Browser/IDE extension development |
| `feature_flags` | Feature flag implementation |
| `federated_learning` | Train ML models across decentralized data sources without sharing raw data — FedAvg, secure aggregation, differential privacy using PySyft, Flower, TFF, and NVIDIA FLARE |
| `firmware_development` | Embedded/firmware development |
| `flutter_development` | Flutter development with Riverpod/BLoC |
| `frontend_patterns` | Frontend architecture patterns |
| `game_development` | Game development patterns |
| `git_workflow` | Git branching and workflow strategies |
| `golang_patterns` | Go language patterns |
| `graphql_patterns` | GraphQL API design, schema-first development, resolvers, federation, and performance optimization |
| `helm_chart_development` | Helm chart creation and templating |
| `hft_infrastructure` | Build ultra-low-latency trading systems using kernel bypass (DPDK), lock-free data structures, FPGA order routing, co-location strategies, and tick-to-trade measurement |
| `i18n_implementation` | Internationalization implementation |
| `internal_developer_portal` | Internal developer portal with Backstage |
| `iot_platform` | IoT platform development |
| `java_coding_standards` | Java coding standards |
| `jpa_patterns` | JPA/Hibernate patterns |
| `kafka_event_streaming` | Apache Kafka event streaming pipelines |
| `knowledge_graph_patterns` | Graph database design, ontology modeling (RDF/OWL), GraphRAG retrieval, and graph-enhanced LLM pipelines using Neo4j, Neptune, and ArangoDB |
| `kubernetes_operations` | Kubernetes workload management and operations |
| `liquid_glass_design` | Apple Liquid Glass UI design |
| `llm_provider_management` | Managing multiple LLM providers — routing, failover, cost optimization, rate limiting, and model selection |
| `log_aggregation_pipeline` | Log aggregation with ELK, Loki, structured logging |
| `lora_finetuning_workflow` | LoRA/QLoRA fine-tuning workflows |
| `message_queue_patterns` | Message queue patterns with RabbitMQ, SQS, NATS |
| `ml_pipeline` | Machine learning pipeline development |
| `ml_trading_signals` | Feature engineering for financial data, time series models (LSTM, Transformer, N-BEATS), reinforcement learning for portfolio management (PPO, SAC), alternative data integration, regime detection, ML-based risk models |
| `monorepo_tooling` | Monorepo management with Nx, Turborepo, Bazel |
| `multi_stack_observability` | Multi-stack observability patterns |
| `multiplayer_systems` | Real-time multiplayer systems |
| `nemo_data_curation` | NeMo Curator for training data filtering, deduplication, quality scoring, PII removal, language classification, and dataset preparation pipelines |
| `nemo_guardrails` | Colang 2.0 rail definitions, topical rails, fact-checking, jailbreak detection, LangChain/LlamaIndex integration, custom actions, and guardrail testing |
| `nl_to_structured_output` | Convert natural language to structured outputs including SQL, code, and validated JSON using constrained generation, schema-aware prompting, and AST validation |
| `nlp_text_pipeline` | NLP text pipelines with spaCy, Transformers |
| `notification_systems` | Notification system design |
| `observability` | Logging, metrics, and tracing |
| `opentelemetry_implementation` | OpenTelemetry implementation |
| `portfolio_risk_management` | Portfolio construction and risk management using Modern Portfolio Theory, Black-Litterman, risk parity, VaR/CVaR, Kelly criterion sizing, and stress testing |
| `privacy_by_design` | Privacy-first development |
| `progressive_web_app` | Progressive web app with service workers |
| `prompt_engineering` | LLM prompt engineering |
| `prompt_ops` | DevOps for prompts — versioning, testing pipelines, A/B comparison, performance metrics, review workflows, template engines, registries, and rollback procedures |
| `python_patterns` | Python-specific patterns |
| `quantitative_trading_strategies` | Factor models (Fama-French, momentum, mean reversion), statistical arbitrage, pairs trading, alpha research methodology, signal combination, transaction cost modeling, slippage estimation |
| `quantum_computing_fundamentals` | Build and simulate quantum circuits using Qiskit, Cirq, and PennyLane — covers qubit types, gates, measurement, and key algorithms (Grover, Shor, VQE, QAOA) on simulators and real hardware |
| `quantum_machine_learning` | Build hybrid quantum-classical ML models using variational circuits, quantum kernels, and NISQ-compatible architectures with PennyLane and PyTorch |
| `quantum_optimization_algorithms` | Implement QAOA, VQE, and quantum annealing for combinatorial and continuous optimization — QUBO formulation, D-Wave hybrid solvers, and quantum-vs-classical benchmarking |
| `rag_advanced_patterns` | Advanced RAG: re-ranking, hybrid search, CRAG |
| `react_native_patterns` | React Native cross-platform development |
| `refactoring` | Code refactoring techniques |
| `regex_vs_llm` | When to use regex vs LLM |
| `resiliency_patterns` | Circuit breaker, retry, bulkhead |
| `retrospective` | Sprint retrospective facilitation |
| `robotics_ros2` | Build robotic systems with ROS 2 — node architecture, Nav2 navigation, MoveIt manipulation, SLAM, sensor fusion, Gazebo/Isaac Sim simulation, and real-time control with ISO 13849 safety |
| `runtime_security_monitoring` | Runtime security monitoring |
| `secret_management` | Secrets and credential management |
| `service_mesh_patterns` | Service mesh with Istio/Linkerd |
| `smart_contract_dev` | Smart contract development |
| `spark_data_processing` | Apache Spark data processing and Delta Lake |
| `spatial_computing` | Build AR/VR/MR experiences with ARKit, ARCore, WebXR, and visionOS — spatial anchors, hand/eye tracking, multi-user shared spaces, and 3D asset pipelines in Unity and Unreal |
| `spec_build` | Master build loop: spec to implementation |
| `springboot_patterns` | Spring Boot patterns |
| `sprint_planning` | Sprint planning and estimation |
| `stakeholder_communication` | Stakeholder updates and reporting |
| `state_machine_patterns` | State machine implementation |
| `swift_actor_persistence` | Swift actor persistence patterns |
| `swift_concurrency` | Swift concurrency patterns |
| `swift_protocol_di_testing` | Swift protocol/DI/testing patterns |
| `synthetic_data_generation` | Synthetic training data generation |
| `test_driven_build` | TDD-first feature building |
| `trading_systems` | Trading system development |
| `ui_polish` | UI polish and micro-interactions |
| `vector_database_operations` | Vector DB operations with pgvector, Pinecone, Qdrant |
| `voice_ai_patterns` | Voice AI development — STT, TTS, real-time audio streaming, barge-in detection, and conversational AI |
| `website_build` | Full website build workflow |
| `websocket_patterns` | WebSocket implementation, real-time communication, Socket.IO, SSE, and pub/sub patterns |
| `zero_knowledge_applications` | Build ZK-SNARK and ZK-STARK applications using Circom, Noir, and SP1 for identity verification, private voting, ZK-rollups, and proof generation optimization |

## Phase 4 -- Secure (47 skills)

| Skill | What it does |
|---|---|
| `accessibility_testing` | Accessibility compliance testing |
| `agent_evaluation_framework` | Task completion metrics, tool call accuracy, multi-step trajectory eval, cost-per-task analysis, regression testing, A/B testing configs, and benchmarks (AgentBench, SWE-bench) |
| `ai_red_teaming` | Systematic adversarial testing of AI systems using MITRE ATLAS, automated tools (Garak, PyRIT, ART), prompt injection campaigns, jailbreak taxonomies, and remediation reporting |
| `ai_safety_guardrails` | AI safety: content filtering, prompt injection defense |
| `api_security_testing` | API security testing |
| `backtesting_methodology` | Rigorous backtesting with walk-forward optimization, Monte Carlo simulation, out-of-sample testing, bias detection (lookahead, survivorship, selection), performance metrics (Sharpe, Sortino, Calmar, max drawdown), statistical significance |
| `build_reproducibility_testing` | Build reproducibility testing |
| `chaos_engineering` | Chaos experiments and resilience testing |
| `compliance_testing_framework` | Compliance test automation |
| `confidential_computing` | Protect data in use with TEEs (Intel SGX, AMD SEV, ARM TrustZone), remote attestation, Confidential VMs, Gramine, and EGo for secure enclave development |
| `container_security` | Container and Kubernetes security |
| `cpp_testing` | C++ testing patterns |
| `dast_scanning` | Dynamic Application Security Testing — runtime vulnerability scanning with OWASP ZAP, Burp Suite, and Nuclei |
| `django_security` | Django security hardening |
| `django_tdd` | Django TDD workflow |
| `django_verification` | Django verification checklist |
| `e2e_testing` | End-to-end test design and execution |
| `eval_harness` | LLM evaluation harness |
| `financial_compliance` | Financial regulation compliance |
| `golang_testing` | Go testing patterns |
| `hipaa_compliance_testing` | HIPAA compliance testing |
| `homomorphic_encryption` | Implement fully homomorphic encryption using TFHE, BFV, CKKS schemes with Microsoft SEAL, concrete-ml, and Zama for encrypted inference, private set intersection, and secure computation |
| `infrastructure_testing` | IaC testing with Terratest, Checkov, tfsec |
| `integration_testing` | Integration test strategies |
| `ip_protection` | Intellectual property protection |
| `llm_evaluation_benchmarking` | LLM evaluation and benchmarking |
| `mobile_security_testing` | Mobile security testing (OWASP MASVS) |
| `mobile_testing_strategy` | Mobile testing: unit, widget, E2E, device farms |
| `mutation_testing` | Mutation testing for test quality |
| `pci_dss_compliance_testing` | PCI-DSS compliance testing |
| `performance_testing` | Load and performance testing |
| `privacy_by_design_testing` | Privacy compliance testing |
| `prompt_injection_hardening` | Production defense-in-depth against prompt injection — input sanitization, output filtering, instruction hierarchy, canary tokens, sandwich defense, system prompt isolation, indirect injection via tools, and detection pipelines |
| `python_testing` | Python testing patterns |
| `rlhf_alignment` | RLHF, DPO, ORPO alignment methods |
| `sast_scanning` | Static application security testing |
| `secrets_scanning` | Secret detection in code |
| `security_audit` | Comprehensive security audit |
| `springboot_security` | Spring Boot security |
| `springboot_tdd` | Spring Boot TDD workflow |
| `springboot_verification` | Spring Boot verification |
| `ssrf_testing_harness` | SSRF testing harness |
| `supply_chain_security` | Supply chain security validation |
| `tdd_workflow` | Test-driven development workflow |
| `unit_testing` | Unit test design patterns |
| `verification_loop` | Iterative verification cycle |
| `web3_security` | Web3/blockchain security |

## Phase 5 -- Ship (25 skills)

| Skill | What it does |
|---|---|
| `app_store_deployment` | iOS App Store and Google Play submission |
| `artifact_provenance_chain` | Artifact provenance and SLSA compliance |
| `canary_verification` | Canary deployment verification |
| `change_management` | Change management process |
| `ci_cd_pipeline` | CI/CD pipeline setup |
| `db_migrations` | Database migration strategies |
| `deployment_approval_gates` | Deployment approval workflows |
| `deployment_patterns` | Blue-green, rolling, canary patterns |
| `deployment_verification` | Post-deployment verification |
| `desktop_publishing` | Desktop app publishing |
| `edge_ai_deployment` | Deploy optimized ML models to edge devices using quantization, pruning, distillation, ONNX Runtime, TFLite, and edge orchestration platforms |
| `game_publishing` | Game store publishing |
| `gitops_workflow` | GitOps with ArgoCD/Flux |
| `infrastructure_as_code` | IaC with Terraform/Pulumi |
| `legal_compliance` | Legal page and compliance review |
| `mlops` | ML model deployment operations |
| `mlops_pipeline` | End-to-end MLOps CI/CD for ML |
| `model_registry_management` | Model versioning, staging, promotion |
| `model_serving_deployment` | Model serving with vLLM, TGI, Triton |
| `multi_stack_deployment` | Multi-stack deployment patterns |
| `nvidia_nim_deployment` | Deploy pre-built optimized inference containers for LLMs, vision, and embeddings using NVIDIA NIM with TensorRT-LLM optimization, GPU allocation, and Kubernetes scaling |
| `oss_publishing` | Open source publishing |
| `release_signing` | Release artifact signing |
| `seed_data` | Seed data management |
| `website_launch` | Website launch checklist |

## Phase 5.5 -- Alpha (10 skills)

| Skill | What it does |
|---|---|
| `ai_model_monitoring` | AI model monitoring: drift, performance, retraining |
| `alpha_exit_criteria` | Alpha phase exit criteria |
| `alpha_incident_communication` | Alpha incident communication |
| `alpha_program_management` | Alpha program management |
| `alpha_telemetry` | Alpha telemetry setup |
| `backup_strategy` | Backup and restore strategy |
| `env_validation` | Environment validation checks |
| `error_tracking` | Error tracking integration |
| `health_checks` | Health check endpoints |
| `qa_playbook` | QA testing playbook |

## Phase 5.75 -- Beta (13 skills)

| Skill | What it does |
|---|---|
| `beta_cohort_management` | Beta user cohort management |
| `beta_graduation_criteria` | Beta to GA graduation criteria |
| `beta_sla_definition` | Beta SLA definition |
| `beta_to_ga_migration` | Beta to GA migration plan |
| `email_templates` | Transactional email templates |
| `error_boundaries` | Error boundary implementation |
| `feature_flags` | Feature flag management |
| `feedback_system` | User feedback collection system |
| `load_testing` | Load testing execution |
| `privacy_consent_management` | Privacy consent flows |
| `product_analytics` | Product analytics integration |
| `rate_limiting` | Rate limiting implementation |
| `usage_metering_billing` | Usage metering and billing |

## Phase 6 -- Handoff (14 skills)

| Skill | What it does |
|---|---|
| `access_handoff` | Access and credential handoff |
| `api_reference` | API reference documentation |
| `community_management` | Community management setup |
| `compliance_certification_handoff` | Compliance certification handoff |
| `disaster_recovery` | Disaster recovery procedures |
| `doc_reorganize` | Documentation reorganization |
| `feature_walkthrough` | Feature walkthrough guides |
| `knowledge_audit` | Knowledge gap audit |
| `monitoring_handoff` | Monitoring ownership handoff |
| `observability_handoff` | Observability ownership handoff |
| `operational_readiness_review` | Operational readiness review |
| `sla_handoff` | SLA handoff documentation |
| `support_enablement` | Support team enablement |
| `user_documentation` | End-user documentation |

## Phase 7 -- Maintenance (13 skills)

| Skill | What it does |
|---|---|
| `capacity_planning_and_performance` | Capacity planning and perf tuning |
| `compliance_dashboard` | Compliance monitoring dashboard |
| `continuous_learning` | Team continuous learning |
| `dependency_management` | Dependency update management |
| `documentation_standards` | Documentation maintenance standards |
| `incident_response_operations` | Incident response runbooks |
| `operational_readiness_gate` | Operational readiness gate checks |
| `regulatory_change_monitoring` | Regulatory change monitoring |
| `security_maintenance` | Ongoing security maintenance |
| `slo_sla_management` | SLO/SLA monitoring and management |
| `sop_standards` | Standard Operating Procedure templates |
| `ssot_update` | SSoT document updates |
| `wi_standards` | Work instruction standards |

## Toolkit (33 cross-cutting skills)

| Skill | What it does |
|---|---|
| `age` | ATOM (Axiomatic Thinking for Omnidirectional Meta-analysis) — 53-loop, 51-method universal discovery engine |
| `age_to_skill_pipeline` | Convert ATOM gap findings to framework skills |
| `ai_cost_optimization` | AI infrastructure cost management and optimization |
| `ai_model_governance` | Model cards, registry governance, approval workflows, bias auditing, drift monitoring, EU AI Act risk tiers, deprecation lifecycle, and audit trails |
| `ai_security_hardening` | AI/LLM security hardening |
| `ai_tool_orchestration` | Multi-AI tool orchestration |
| `ceo-brain` | CEO-level strategic thinking |
| `compliance_program` | Compliance program management |
| `content_creation` | Content creation workflows |
| `content_waterfall` | Content repurposing waterfall |
| `cost_aware_llm_pipeline` | Cost-optimized LLM pipelines |
| `delivery_metrics` | Delivery performance metrics |
| `developer_experience_tooling` | Developer experience and golden paths |
| `documentation_as_code` | Docs-as-code with Docusaurus, MkDocs |
| `dora_metrics_tracking` | DORA metrics tracking |
| `eu_ai_act_compliance` | EU AI Act compliance |
| `governance_framework` | Governance framework setup |
| `green_software_practices` | Carbon-aware computing and SCI scoring |
| `iso_27001_implementation` | ISO 27001 implementation |
| `iterative_retrieval` | Iterative retrieval patterns |
| `observability_maturity_model` | Observability maturity assessment |
| `openclaw_platform_patterns` | Architecture conventions for the OpenClaw AI agent platform — agent schemas, provider plugins, channel adapters, Riftkit-to-OpenClaw deployment, and fleet management with PM2/Ansible |
| `personal_brand` | Personal brand building |
| `phase_gate_contracts` | Phase gate contract definitions |
| `progressive_rollout_playbook` | Progressive rollout strategies |
| `project_state_persistence` | Project state persistence across sessions |
| `responsible_ai_framework` | Responsible AI: fairness, bias, explainability |
| `skill_lifecycle_manager` | Skill creation and maintenance |
| `skill_registry` | Skill registry management |
| `sre_foundations` | SRE foundations and practices |
| `strategic_compact` | Strategic compact documents |
| `toolkit_phase_integration_guide` | Toolkit-to-phase integration |
| `video_research` | Video content research |

---

## Commands (44)

Invoke with `/command-name`. Read full docs at `.agent/commands/{name}.md`.

| Command | What it does |
|---|---|
| `/build-fix` | Diagnose and fix build errors |
| `/checkpoint` | Save a project checkpoint |
| `/claw` | OpenClaw integration commands |
| `/code-review` | Run automated code review |
| `/compliance-check` | Run compliance checks |
| `/deploy` | Deploy to environment |
| `/e2e` | Execute end-to-end tests |
| `/eval` | Run evaluation harness |
| `/evolve` | Evolve skills via AGE |
| `/incident` | Incident response workflow |
| `/go-build` | Fix Go build errors |
| `/go-review` | Go-specific code review |
| `/go-test` | Run Go tests |
| `/instinct-export` | Export learned instincts |
| `/instinct-import` | Import instincts from file |
| `/instinct-status` | Show current instinct state |
| `/learn-eval` | Evaluate learning outcomes |
| `/learn` | Learn from code or documentation |
| `/multi-backend` | Multi-service backend operations |
| `/multi-execute` | Execute across multiple services |
| `/multi-frontend` | Multi-frontend operations |
| `/multi-plan` | Plan across multiple services |
| `/multi-workflow` | Run multi-service workflows |
| `/observe` | Observability setup |
| `/orchestrate` | Orchestrate complex multi-step tasks |
| `/plan` | Create implementation plan |
| `/pm2` | PM2 process management |
| `/python-review` | Python-specific code review |
| `/release` | Release management |
| `/refactor-clean` | Refactor and clean code |
| `/security-audit` | Security audit workflow |
| `/sessions` | Manage development sessions |
| `/setup-pm` | Set up project management |
| `/skill-create` | Create a new framework skill |
| `/tdd` | Test-driven development workflow |
| `/test-coverage` | Analyze test coverage |
| `/update-codemaps` | Update code maps |
| `/update-docs` | Update project documentation |
| `/verify` | Run verification checks |

---

## Agents (19)

Agents are specialized AI personas. Read full docs at `.agent/agents/{name}.md`.

| Agent | Specialty |
|---|---|
| `planner` | Project planning, task breakdown, roadmaps |
| `architect` | System architecture, design decisions, trade-offs |
| `brainstorm-agent` | Brainstorm and ideation facilitation |
| `code-reviewer` | Code quality, patterns, best practices review |
| `compliance-agent` | Compliance review and audit |
| `security-reviewer` | Security-focused code and config review |
| `tdd-guide` | Test-driven development guidance and coaching |
| `build-error-resolver` | Build error diagnosis, dependency resolution |
| `e2e-runner` | End-to-end test execution and debugging |
| `framework-router` | Route requests to correct skills and agents |
| `doc-updater` | Documentation generation and maintenance |
| `refactor-cleaner` | Code refactoring, dead code removal |
| `database-reviewer` | Schema design, query optimization, migration review |
| `go-reviewer` | Go-specific code review and idioms |
| `go-build-resolver` | Go build and module error resolution |
| `python-reviewer` | Python-specific code review and patterns |
| `security-agent` | Security-focused analysis and review |
| `ship-agent` | Deployment and shipping operations |
| `sre-agent` | SRE practices and reliability engineering |

---

## Workflows (25)

Multi-step orchestrated processes at `.agent/workflows/`. See also [WORKFLOWS_README.md](.agent/workflows/WORKFLOWS_README.md) for orchestration guidance and [WORKFLOW_ECOSYSTEM.md](.agent/workflows/WORKFLOW_ECOSYSTEM.md) for workflow relationships.

| Workflow | File | What it does |
|---|---|---|
| Context | `0-context.md` | Context gathering workflow |
| Brainstorm | `1-brainstorm.md` | Brainstorm and ideation workflow |
| Design | `2-design.md` | Design phase workflow |
| Build | `3-build.md` | Build phase workflow |
| Secure | `4-secure.md` | Security and testing workflow |
| Ship | `5-ship.md` | Full deployment workflow |
| Handoff | `6-handoff.md` | Project handoff workflow |
| Maintenance | `7-maintenance.md` | Ongoing maintenance workflow |
| ATOM Commission | `age-commission.md` | Commission ATOM discovery analysis |
| Alpha Release | `alpha-release.md` | Alpha release process |
| Beta Release | `beta-release.md` | Beta release process |
| Compliance Audit | `compliance-audit.md` | Compliance audit workflow |
| Hotfix Critical | `hotfix-critical.md` | Critical hotfix workflow |
| Incident Response | `incident-response.md` | Incident response workflow |
| Migration Upgrade | `migration-upgrade.md` | Migration and upgrade workflow |
| Onboarding | `onboarding-new-dev.md` | New developer onboarding |
| Performance Optimization | `performance-optimization.md` | Performance optimization workflow |
| Security Hardening | `security-hardening.md` | Security hardening workflow |
| Content Production | `toolkit/content_production.md` | Content production pipeline |
| Debug | `toolkit/debug.md` | Debug workflow |
| Design Review | `toolkit/design-review.md` | Design review process |
| Launch | `toolkit/launch.md` | Full launch workflow |
| New Project | `toolkit/new-project.md` | New project bootstrap |
| Observability | `toolkit/observability.md` | Observability setup workflow |
| Post-Task | `toolkit/post-task.md` | Post-task retrospective |

---

## How to Use Skills

1. **Find the skill** using the tables above or the Common Tasks router
2. **Read the SKILL.md**: `.agent/skills/{phase}/{skill_name}/SKILL.md`
3. **Follow its instructions** -- each skill has inputs, steps, and outputs
4. **Chain skills** -- use phase exit skills (e.g., `phase_exit_summary`, `design_handoff`) to transition between phases

## Phase Flow

```
0-Context --> 1-Brainstorm --> 2-Design --> 3-Build --> 4-Secure --> 5-Ship --> 5.5-Alpha --> 5.75-Beta --> 6-Handoff --> 7-Maintenance
```

Not every project needs every phase. Skip phases that do not apply. Use phase gate skills to validate transitions.
