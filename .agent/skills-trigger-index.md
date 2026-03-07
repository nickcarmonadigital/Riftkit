# Skills Trigger Index

> Quick-lookup reference mapping natural language intents to skills, phases, and commands.
> Scan this file to find the right skill for any user request.

---

## Phase 0 — Context

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| recover architecture, reverse engineer system, map existing architecture | 0 | architecture_recovery | — |
| understand the codebase structure, what does this system look like | 0 | architecture_recovery | — |
| audit codebase health, code quality check, how healthy is this codebase | 0 | codebase_health_audit | — |
| assess code quality, codebase fitness, tech health score | 0 | codebase_health_audit | — |
| navigate the codebase, find my way around, where is everything | 0 | codebase_navigation | — |
| explore project structure, how is this repo organized | 0 | codebase_navigation | — |
| map the codebase, give me a tour of the code | 0 | codebase_navigation | update-codemaps |
| check compliance context, regulatory requirements, what rules apply | 0 | compliance_context | — |
| compliance landscape, governance context, legal constraints | 0 | compliance_context | — |
| set up dev environment, configure development tools, get my machine ready | 0 | dev_environment_setup | — |
| install dependencies, bootstrap project, onboard developer | 0 | dev_environment_setup | — |
| set up local environment, dev setup, configure tooling | 0 | dev_environment_setup | — |
| create documentation framework, set up docs structure, organize documentation | 0 | documentation_framework | — |
| docs architecture, documentation strategy, how should we document | 0 | documentation_framework | — |
| review incident history, past incidents, what went wrong before | 0 | incident_history_review | — |
| postmortem review, incident log, previous outages | 0 | incident_history_review | — |
| audit infrastructure, review infra, what infrastructure do we have | 0 | infrastructure_audit | — |
| infra assessment, infrastructure review, check our servers | 0 | infrastructure_audit | — |
| modernize legacy code, legacy migration, upgrade old system | 0 | legacy_modernization | — |
| refactor legacy, migrate from old stack, deal with legacy | 0 | legacy_modernization | — |
| start new project, initialize project, create new repo | 0 | new_project | — |
| bootstrap new app, scaffold project, greenfield project | 0 | new_project | — |
| phase 0 playbook, context phase guide, how to do phase 0 | 0 | phase_0_playbook | — |
| run the context phase, phase 0 checklist | 0 | phase_0_playbook | — |
| phase exit summary, summarize phase, phase completion report | 0 | phase_exit_summary | — |
| wrap up this phase, phase gate report, ready for next phase | 0 | phase_exit_summary | — |
| gather project context, understand the project, project overview | 0 | project_context | — |
| what is this project about, project background, project scope | 0 | project_context | — |
| set project guidelines, coding standards, define conventions | 0 | project_guidelines | — |
| project rules, team conventions, style guide | 0 | project_guidelines | — |
| create risk register, identify risks, what could go wrong | 0 | risk_register | — |
| risk assessment, risk log, project risks | 0 | risk_register | — |
| search first, check existing solutions, look before building | 0 | search_first | — |
| find existing tools, dont reinvent the wheel, is there a library for this | 0 | search_first | — |
| define ssot structure, single source of truth, canonical data layout | 0 | ssot_structure | — |
| truth structure, ssot design, authoritative data source | 0 | ssot_structure | — |
| map stakeholders, who are the stakeholders, stakeholder analysis | 0 | stakeholder_map | — |
| identify decision makers, stakeholder register, who matters | 0 | stakeholder_map | — |
| regulated industry, healthcare compliance, defense requirements | 0 | regulated_industry_context | — |
| financial regulations context, industry-specific compliance | 0 | regulated_industry_context | — |
| audit supply chain, check dependencies for risk, dependency supply chain | 0 | supply_chain_audit | — |
| third party risk, vendor audit, open source supply chain | 0 | supply_chain_audit | — |
| review system design, design review, architecture review | 0 | system_design_review | — |
| evaluate system architecture, design critique, is this design sound | 0 | system_design_review | — |
| knowledge transfer, onboard new team member, share team knowledge | 0 | team_knowledge_transfer | — |
| document tribal knowledge, team onboarding, bus factor | 0 | team_knowledge_transfer | — |
| assess tech debt, technical debt inventory, how much debt do we have | 0 | tech_debt_assessment | — |
| tech debt audit, code debt, refactoring backlog | 0 | tech_debt_assessment | — |

## Phase 1 — Brainstorm

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| test assumptions, validate hypothesis, challenge our assumptions | 1 | assumption_testing | — |
| assumption audit, are we sure about this, validate beliefs | 1 | assumption_testing | — |
| client discovery, understand client needs, client interview | 1 | client_discovery | — |
| customer discovery, learn about the client, client requirements | 1 | client_discovery | — |
| competitive analysis, analyze competitors, who are our competitors | 1 | competitive_analysis | — |
| competitor research, market landscape, competitive landscape | 1 | competitive_analysis | — |
| go no go decision, should we proceed, gate check | 1 | go_no_go_gate | — |
| kill or continue, feasibility gate, proceed or stop | 1 | go_no_go_gate | — |
| turn idea into spec, idea to specification, flesh out this idea | 1 | idea_to_spec | — |
| spec from idea, write a spec, convert idea to requirements | 1 | idea_to_spec | — |
| create lean canvas, business model canvas, lean startup canvas | 1 | lean_canvas | — |
| business model, value proposition canvas, startup canvas | 1 | lean_canvas | — |
| estimate market size, market sizing, how big is the market | 1 | market_sizing | — |
| TAM SAM SOM, addressable market, market opportunity | 1 | market_sizing | — |
| generate PRD, product requirements document, write a PRD | 1 | prd_generator | — |
| product spec, requirements doc, feature requirements | 1 | prd_generator | — |
| prioritize features, prioritization framework, what should we build first | 1 | prioritization_frameworks | — |
| RICE scoring, MoSCoW, priority matrix, rank features | 1 | prioritization_frameworks | — |
| define product metrics, success metrics, how do we measure success | 1 | product_metrics | — |
| KPIs, north star metric, product analytics goals | 1 | product_metrics | — |
| generate proposal, write a proposal, project proposal | 1 | proposal_generator | — |
| business proposal, client proposal, bid document | 1 | proposal_generator | — |
| SMB launchpad, small business launch, quick MVP | 1 | smb_launchpad | — |
| launch small product, SMB product, rapid launch | 1 | smb_launchpad | — |
| user research, understand users, user interviews | 1 | user_research | — |
| UX research, user needs, user study | 1 | user_research | — |
| write user stories, user story format, story standards | 1 | user_story_standards | — |
| acceptance criteria, given when then, story template | 1 | user_story_standards | — |

## Phase 2 — Design

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| accessibility design, a11y design, inclusive design | 2 | accessibility_design | — |
| design for accessibility, WCAG compliance, screen reader support | 2 | accessibility_design | — |
| design API contract, API specification, define API endpoints | 2 | api_contract_design | — |
| OpenAPI spec, API schema, REST contract | 2 | api_contract_design | — |
| write ADR, architecture decision record, document architecture decision | 2 | architecture_decision_records | — |
| design decision, why did we choose this, record technical decision | 2 | architecture_decision_records | — |
| atomic reverse architecture, decompose architecture, break down system | 2 | atomic_reverse_architecture | — |
| reverse architect, atomic decomposition, system breakdown | 2 | atomic_reverse_architecture | — |
| draw C4 diagrams, architecture diagrams, system context diagram | 2 | c4_architecture_diagrams | — |
| C4 model, container diagram, component diagram | 2 | c4_architecture_diagrams | — |
| cross platform architecture, react native vs flutter, mobile web decision | 2 | cross_platform_architecture | — |
| choose mobile framework, native vs cross-platform | 2 | cross_platform_architecture | — |
| design for cost, cost architecture, cloud cost design | 2 | cost_architecture | — |
| optimize cloud spend, cost-efficient architecture, FinOps design | 2 | cost_architecture | — |
| data privacy design, privacy architecture, GDPR design | 2 | data_privacy_design | — |
| distributed tracing design, trace architecture, span design | 2 | distributed_tracing_design | — |
| design for privacy, PII handling, data protection design | 2 | data_privacy_design | — |
| design deployment modes, on-prem vs cloud, deployment strategy design | 2 | deployment_modes | — |
| hybrid deployment, SaaS vs self-hosted, deployment topology | 2 | deployment_modes | — |
| embedding pipeline, vector embedding architecture, embedding model selection | 2 | embedding_pipeline_design | — |
| choose embedding model, chunking strategy design | 2 | embedding_pipeline_design | — |
| feature store architecture, feature engineering design | 2 | feature_store_design | — |
| online offline feature store, ML feature pipeline | 2 | feature_store_design | — |
| design handoff, hand off designs, designer to developer | 2 | design_handoff | — |
| Figma handoff, design specs for devs, pixel perfect specs | 2 | design_handoff | — |
| design intake, new design request, design brief | 2 | design_intake | — |
| start design work, design kickoff, design requirements | 2 | design_intake | — |
| feature architecture, design a feature, feature technical design | 2 | feature_architecture | — |
| feature blueprint, technical design for feature, how to build this feature | 2 | feature_architecture | — |
| inclusive design, cognitive accessibility, neurodivergent UX | 2 | inclusive_design_patterns | — |
| accessible design patterns, multi-language UX design | 2 | inclusive_design_patterns | — |
| internationalization design, i18n architecture, design for multiple languages | 2 | internationalization_design | — |
| localization design, multi-language support, translation architecture | 2 | internationalization_design | — |
| multi-tenancy architecture, tenant isolation, SaaS multi-tenant | 2 | multi_tenancy_architecture | — |
| design multi-tenant, shared vs isolated tenants, tenant data separation | 2 | multi_tenancy_architecture | — |
| non-functional requirements, NFR specification, quality attributes | 2 | nfr_specification | — |
| observability architecture, monitoring design, telemetry architecture | 2 | observability_architecture_design | — |
| performance requirements, scalability requirements, reliability targets | 2 | nfr_specification | — |
| RTO RPO design, disaster recovery design, recovery objectives | 2 | rto_rpo_design | — |
| backup and recovery design, failover design, business continuity | 2 | rto_rpo_design | — |
| schema standards, database schema design, data model conventions | 2 | schema_standards | — |
| naming conventions for DB, schema guidelines, table design rules | 2 | schema_standards | — |
| SLO SLA design, error budget planning, service level design | 2 | slo_sla_design | — |
| security threat model, threat modeling, identify security threats | 2 | security_threat_modeling | — |
| STRIDE analysis, attack surface, threat assessment | 2 | security_threat_modeling | — |

## Phase 3 — Build

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| WCAG implementation, ARIA patterns, screen reader support | 3 | accessibility_implementation | — |
| keyboard navigation, focus management, accessible forms | 3 | accessibility_implementation | — |
| build AI agent, LangChain agent, multi-agent system | 3 | ai_agent_development | — |
| CrewAI setup, ReAct agent, tool-using AI agent | 3 | ai_agent_development | — |
| airflow DAG, workflow orchestration, data pipeline scheduling | 3 | airflow_orchestration | — |
| apache airflow setup, task scheduling, ETL orchestration | 3 | airflow_orchestration | — |
| design API, build API, REST API design | 3 | api_design | — |
| create endpoints, API implementation, build REST service | 3 | api_design | — |
| API gateway, Kong setup, rate limiting gateway | 3 | api_gateway_patterns | — |
| API routing, gateway authentication, API versioning gateway | 3 | api_gateway_patterns | — |
| audit logging, compliance audit trail | 3 | audit_logging_architecture | — |
| implement authentication, build auth, add login | 3 | auth_implementation | — |
| JWT auth, OAuth setup, authentication flow | 3 | auth_implementation | — |
| authorization patterns, role-based access, RBAC implementation | 3 | authorization_patterns | — |
| permissions, access control, who can do what | 3 | authorization_patterns | — |
| backend patterns, backend best practices, server-side patterns | 3 | backend_patterns | — |
| backend architecture, service layer, repository pattern | 3 | backend_patterns | — |
| backward compatibility, don't break clients, backwards compat | 3 | backward_compatibility | — |
| API versioning, non-breaking changes, deprecation strategy | 3 | backward_compatibility | — |
| caching strategy, Redis cache, CDN caching, cache invalidation | 3 | caching_strategies | — |
| write-through cache, cache stampede, cache-aside pattern | 3 | caching_strategies | — |
| fix a bug, troubleshoot issue, debug problem | 3 | bug_troubleshoot | build-fix |
| something is broken, find the bug, diagnose error | 3 | bug_troubleshoot | build-fix |
| why is this failing, investigate issue, root cause analysis | 3 | bug_troubleshoot | build-fix |
| ClickHouse setup, ClickHouse queries, analytics database | 3 | clickhouse_io | — |
| OLAP database, columnar store, ClickHouse integration | 3 | clickhouse_io | — |
| compliance as code, automated compliance checks | 3 | compliance_as_code | — |
| computer vision, image classification, object detection | 3 | computer_vision_pipeline | — |
| YOLO setup, image segmentation, OCR pipeline | 3 | computer_vision_pipeline | — |
| generate changelog, code changelog, what changed | 3 | code_changelog | — |
| release notes, change log, diff summary | 3 | code_changelog | — |
| review my code, code review, PR review | 3 | code_review | code-review |
| check my code, review pull request, look at my changes | 3 | code_review | code-review |
| respond to code review, address review comments, fix review feedback | 3 | code_review_response | — |
| handle PR feedback, review response, update after review | 3 | code_review_response | — |
| content hash cache, cache busting, content-addressable cache | 3 | content_hash_cache | — |
| hash-based caching, immutable cache, fingerprint assets | 3 | content_hash_cache | — |
| estimate cost, how much will this cost, cost estimation | 3 | cost_estimation | — |
| project cost, budget estimate, effort estimation | 3 | cost_estimation | — |
| C++ coding standards, C++ best practices, write C++ code | 3 | cpp_coding_standards | — |
| C++ style guide, modern C++, C++ conventions | 3 | cpp_coding_standards | — |
| database migration, zero downtime migration, schema evolution | 3 | database_migration_patterns | — |
| expand contract migration, Flyway Alembic Prisma migrate | 3 | database_migration_patterns | — |
| build dApp, decentralized app, blockchain development | 3 | dapp_development | — |
| Web3 frontend, dApp development, smart contract UI | 3 | dapp_development | — |
| build dashboard, create dashboard, analytics dashboard | 3 | dashboard_development | — |
| admin panel, data visualization, metrics dashboard | 3 | dashboard_development | — |
| build data warehouse, data warehouse design, DWH setup | 3 | data_warehouse | — |
| star schema, dimensional modeling, data lake | 3 | data_warehouse | — |
| optimize database, slow queries, database performance | 3 | database_optimization | — |
| query optimization, index tuning, DB performance | 3 | database_optimization | — |
| design system, component library, design tokens, Storybook | 3 | design_system_development | — |
| UI component library, multi-framework components | 3 | design_system_development | — |
| distributed training, multi-GPU training, FSDP DeepSpeed | 3 | distributed_training | — |
| data parallel training, model parallel, gradient accumulation | 3 | distributed_training | — |
| manage dependencies, dependency hygiene, update packages | 3 | dependency_hygiene | — |
| outdated dependencies, clean up deps, package management | 3 | dependency_hygiene | — |
| Django patterns, build with Django, Django best practices | 3 | django_patterns | — |
| Django models, Django views, Django REST framework | 3 | django_patterns | — |
| set up Docker, Dockerfile, containerize application | 3 | docker_development | — |
| Docker compose, build container, docker setup | 3 | docker_development | — |
| set up environment, environment configuration, env vars | 3 | environment_setup | — |
| configure environments, staging setup, env management | 3 | environment_setup | — |
| error handling patterns, handle errors, exception handling | 3 | error_handling | — |
| error strategy, graceful degradation, fault tolerance | 3 | error_handling | — |
| experiment tracking, MLflow setup, Weights and Biases | 3 | experiment_tracking | — |
| ML experiment logging, hyperparameter tracking | 3 | experiment_tracking | — |
| build ETL pipeline, data pipeline, extract transform load | 3 | etl_pipeline | — |
| data ingestion, batch processing, data flow | 3 | etl_pipeline | — |
| event driven architecture, pub sub, message queue | 3 | event_driven_architecture | — |
| event sourcing, CQRS, async messaging | 3 | event_driven_architecture | — |
| build extension, browser extension, plugin development | 3 | extension_development | — |
| VS Code extension, Chrome extension, add-on development | 3 | extension_development | — |
| implement feature flags, feature toggles, toggle features | 3 | feature_flags | — |
| gradual rollout, dark launch, feature switches | 3 | feature_flags | — |
| flutter app, Dart patterns, Riverpod BLoC state management | 3 | flutter_development | — |
| flutter widget testing, platform channels | 3 | flutter_development | — |
| firmware development, embedded code, write firmware | 3 | firmware_development | — |
| microcontroller, embedded systems, IoT firmware | 3 | firmware_development | — |
| frontend patterns, React patterns, UI development | 3 | frontend_patterns | — |
| frontend best practices, component patterns, client-side architecture | 3 | frontend_patterns | — |
| game development, build a game, game programming | 3 | game_development | — |
| game engine, game loop, game mechanics | 3 | game_development | — |
| git workflow, branching strategy, git best practices | 3 | git_workflow | — |
| branch naming, merge strategy, git flow | 3 | git_workflow | — |
| Go patterns, write Go code, Golang best practices | 3 | golang_patterns | go-build |
| Go idioms, Go modules, Golang development | 3 | golang_patterns | go-build |
| helm chart, kubernetes helm, chart templating | 3 | helm_chart_development | — |
| helm values, chart dependencies, helm testing | 3 | helm_chart_development | — |
| implement i18n, add translations, internationalization | 3 | i18n_implementation | — |
| localize app, multi-language, translation implementation | 3 | i18n_implementation | — |
| developer portal, Backstage setup, service catalog | 3 | internal_developer_portal | — |
| internal platform, golden paths, TechDocs | 3 | internal_developer_portal | — |
| build IoT platform, IoT backend, connected devices | 3 | iot_platform | — |
| device management, IoT architecture, sensor data | 3 | iot_platform | — |
| kafka setup, event streaming, consumer groups | 3 | kafka_event_streaming | — |
| kafka topics, avro schema, kafka connect, exactly once | 3 | kafka_event_streaming | — |
| kubernetes, k8s deployment, pod management, RBAC | 3 | kubernetes_operations | — |
| statefulset, k8s networking, persistent volumes | 3 | kubernetes_operations | — |
| Java coding standards, Java best practices, write Java | 3 | java_coding_standards | — |
| Java conventions, Java style guide, Java patterns | 3 | java_coding_standards | — |
| JPA patterns, Hibernate patterns, ORM best practices | 3 | jpa_patterns | — |
| JPA repository, entity mapping, Spring Data JPA | 3 | jpa_patterns | — |
| log aggregation, ELK stack, Loki, structured logging | 3 | log_aggregation_pipeline | — |
| centralized logging, correlation IDs, log retention | 3 | log_aggregation_pipeline | — |
| fine-tune LLM, LoRA training, QLoRA, PEFT adapter | 3 | lora_finetuning_workflow | — |
| finetune model, adapter training, dataset preparation for fine-tuning | 3 | lora_finetuning_workflow | — |
| liquid glass design, glassmorphism, frosted glass UI | 3 | liquid_glass_design | — |
| glass UI, translucent design, blur effect UI | 3 | liquid_glass_design | — |
| message queue, RabbitMQ, SQS, NATS, pub sub | 3 | message_queue_patterns | — |
| dead letter queue, fan-out pattern, event-driven messaging | 3 | message_queue_patterns | — |
| monorepo, Nx workspace, Turborepo, Bazel build | 3 | monorepo_tooling | — |
| shared packages, affected detection, remote caching | 3 | monorepo_tooling | — |
| multi-stack observability, cross-service monitoring | 3 | multi_stack_observability | — |
| build ML pipeline, machine learning pipeline, train model | 3 | ml_pipeline | — |
| ML workflow, model training, data science pipeline | 3 | ml_pipeline | — |
| multiplayer systems, build multiplayer, real-time multiplayer | 3 | multiplayer_systems | — |
| game networking, player sync, multiplayer backend | 3 | multiplayer_systems | — |
| NLP pipeline, text classification, named entity recognition | 3 | nlp_text_pipeline | — |
| sentiment analysis, spaCy pipeline, text preprocessing | 3 | nlp_text_pipeline | — |
| notification systems, push notifications, build notifications | 3 | notification_systems | — |
| email notifications, in-app notifications, alert system | 3 | notification_systems | — |
| add observability, monitoring setup, logging and tracing | 3 | observability | — |
| OpenTelemetry, structured logging, distributed tracing | 3 | observability | — |
| OpenTelemetry, OTEL instrumentation, trace collector | 3 | opentelemetry_implementation | — |
| privacy by design, build for privacy, GDPR implementation | 3 | privacy_by_design | — |
| data minimization, consent management, privacy engineering | 3 | privacy_by_design | — |
| progressive web app, PWA, service worker, offline first | 3 | progressive_web_app | — |
| web app manifest, push notifications, installable web app | 3 | progressive_web_app | — |
| prompt engineering, write prompts, optimize LLM prompts | 3 | prompt_engineering | — |
| LLM prompts, AI prompts, prompt tuning | 3 | prompt_engineering | — |
| Python patterns, write Python, Python best practices | 3 | python_patterns | — |
| Pythonic code, Python conventions, Python development | 3 | python_patterns | — |
| advanced RAG, re-ranking, hybrid search, CRAG | 3 | rag_advanced_patterns | — |
| RAG evaluation, RAGAS, recursive retrieval, self-RAG | 3 | rag_advanced_patterns | — |
| react native app, mobile development, expo setup | 3 | react_native_patterns | — |
| react native navigation, native modules, mobile performance | 3 | react_native_patterns | — |
| refactor code, clean up code, improve code structure | 3 | refactoring | refactor-clean |
| restructure code, simplify code, reduce complexity | 3 | refactoring | refactor-clean |
| regex vs LLM, when to use regex, text extraction approach | 3 | regex_vs_llm | — |
| parsing strategy, regex or AI, structured extraction | 3 | regex_vs_llm | — |
| runtime security monitoring, intrusion detection | 3 | runtime_security_monitoring | — |
| resiliency patterns, circuit breaker, retry patterns | 3 | resiliency_patterns | — |
| fault tolerance, bulkhead, resilient services | 3 | resiliency_patterns | — |
| run retrospective, sprint retro, what went well | 3 | retrospective | — |
| team retro, lessons learned, improve process | 3 | retrospective | — |
| service mesh, Istio setup, Linkerd, mTLS | 3 | service_mesh_patterns | — |
| traffic management, sidecar proxy, circuit breaking mesh | 3 | service_mesh_patterns | — |
| manage secrets, secret management, vault setup | 3 | secret_management | — |
| store secrets safely, API keys, credentials management | 3 | secret_management | — |
| build smart contract, Solidity development, blockchain contract | 3 | smart_contract_dev | — |
| write smart contract, EVM development, Web3 contract | 3 | smart_contract_dev | — |
| spark job, data processing, PySpark, Delta Lake | 3 | spark_data_processing | — |
| spark streaming, dataframe optimization, spark SQL | 3 | spark_data_processing | — |
| build from spec, implement specification, spec to code | 3 | spec_build | — |
| turn spec into code, implement design, build the feature | 3 | spec_build | — |
| Spring Boot patterns, Spring best practices, build Spring app | 3 | springboot_patterns | — |
| Spring Boot development, Spring REST, Spring service | 3 | springboot_patterns | — |
| sprint planning, plan the sprint, sprint backlog | 3 | sprint_planning | — |
| story points, sprint capacity, iteration planning | 3 | sprint_planning | — |
| stakeholder communication, update stakeholders, status report | 3 | stakeholder_communication | — |
| project update, stakeholder email, progress report | 3 | stakeholder_communication | — |
| state machine, implement state machine, FSM pattern | 3 | state_machine_patterns | — |
| workflow engine, state transitions, statechart | 3 | state_machine_patterns | — |
| synthetic data, generate training data, data augmentation | 3 | synthetic_data_generation | — |
| CTGAN, synthetic dataset, LLM data generation | 3 | synthetic_data_generation | — |
| Swift actor persistence, Swift actors, persist actor state | 3 | swift_actor_persistence | — |
| actor model Swift, Swift concurrency persistence | 3 | swift_actor_persistence | — |
| Swift concurrency, async await Swift, Swift structured concurrency | 3 | swift_concurrency | — |
| Swift tasks, Swift actors, concurrent Swift | 3 | swift_concurrency | — |
| Swift protocol testing, Swift DI, Swift dependency injection | 3 | swift_protocol_di_testing | — |
| protocol-oriented testing, Swift mock, testable Swift | 3 | swift_protocol_di_testing | — |
| test driven build, TDD build, build with tests first | 3 | test_driven_build | tdd |
| write tests first then code, TDD workflow, red green refactor | 3 | test_driven_build | tdd |
| trading systems, build trading bot, algorithmic trading | 3 | trading_systems | — |
| market data, order execution, trading engine | 3 | trading_systems | — |
| UI polish, polish the UI, pixel perfect, visual refinement | 3 | ui_polish | — |
| make it look good, UI tweaks, design polish | 3 | ui_polish | — |
| vector database, pgvector, Pinecone, similarity search | 3 | vector_database_operations | — |
| vector index, HNSW, hybrid search vectors, Qdrant Weaviate | 3 | vector_database_operations | — |
| build website, create website, website development | 3 | website_build | — |
| static site, landing page, web app | 3 | website_build | — |

## Phase 4 — Secure

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| AI safety, content filtering, prompt injection defense | 4 | ai_safety_guardrails | — |
| guardrails AI, toxicity detection, red teaming AI | 4 | ai_safety_guardrails | — |
| accessibility testing, test a11y, WCAG testing | 4 | accessibility_testing | — |
| screen reader test, accessibility audit, a11y compliance | 4 | accessibility_testing | — |
| API security test, OWASP API testing | 4 | api_security_testing | — |
| build reproducibility, reproducible builds testing | 4 | build_reproducibility_testing | — |
| chaos engineering, chaos testing, break things on purpose | 4 | chaos_engineering | — |
| failure injection, resilience testing, chaos monkey | 4 | chaos_engineering | — |
| compliance testing, test compliance, regulatory testing | 4 | compliance_testing_framework | — |
| audit compliance, SOC2 testing, HIPAA testing | 4 | compliance_testing_framework | — |
| HIPAA compliance test, healthcare security testing | 4 | hipaa_compliance_testing | — |
| container security, Docker security, scan containers | 4 | container_security | — |
| image scanning, container hardening, Kubernetes security | 4 | container_security | — |
| C++ testing, test C++ code, C++ unit tests | 4 | cpp_testing | — |
| Google Test, C++ test framework, catch2 | 4 | cpp_testing | — |
| Django security, secure Django app, Django vulnerabilities | 4 | django_security | — |
| Django CSRF, Django XSS, Django auth security | 4 | django_security | — |
| Django TDD, test Django app, Django test driven | 4 | django_tdd | — |
| Django tests, pytest Django, Django test cases | 4 | django_tdd | — |
| Django verification, verify Django app, Django checks | 4 | django_verification | — |
| Django health check, validate Django, Django smoke test | 4 | django_verification | — |
| end to end testing, E2E tests, browser testing | 4 | e2e_testing | e2e |
| Playwright tests, Cypress tests, integration E2E | 4 | e2e_testing | e2e |
| eval harness, evaluate AI model, LLM evaluation | 4 | eval_harness | eval |
| benchmark model, AI accuracy, model evaluation | 4 | eval_harness | eval |
| infrastructure testing, Terratest, Checkov, tfsec | 4 | infrastructure_testing | — |
| IaC testing, policy as code, Conftest OPA | 4 | infrastructure_testing | — |
| financial compliance, financial audit, SOX compliance | 4 | financial_compliance | — |
| financial regulations, accounting compliance, financial controls | 4 | financial_compliance | — |
| Go testing, test Go code, Golang tests | 4 | golang_testing | go-test |
| Go test, table driven tests, Go benchmarks | 4 | golang_testing | go-test |
| integration testing, integration tests, test service integration | 4 | integration_testing | — |
| LLM evaluation, model benchmarking, MT-Bench HELM | 4 | llm_evaluation_benchmarking | /eval |
| LLM quality testing, perplexity BLEU ROUGE, LLM-as-judge | 4 | llm_evaluation_benchmarking | /eval |
| API integration test, service test, cross-service testing | 4 | integration_testing | — |
| IP protection, intellectual property, protect our code | 4 | ip_protection | — |
| license compliance, code ownership, IP audit | 4 | ip_protection | — |
| mobile security test, OWASP MASVS, certificate pinning | 4 | mobile_security_testing | — |
| app security testing, jailbreak detection, secure storage mobile | 4 | mobile_security_testing | — |
| mobile testing, device farm testing, Detox Maestro | 4 | mobile_testing_strategy | — |
| mobile E2E test, widget testing, mobile CI | 4 | mobile_testing_strategy | — |
| mutation testing, test quality, kill mutants | 4 | mutation_testing | — |
| test effectiveness, mutation score, are tests good enough | 4 | mutation_testing | — |
| PCI DSS testing, payment security compliance | 4 | pci_dss_compliance_testing | — |
| performance testing, load test, stress test | 4 | performance_testing | — |
| benchmark, latency testing, throughput test | 4 | performance_testing | — |
| privacy testing, test privacy controls, GDPR testing | 4 | privacy_by_design_testing | — |
| data protection test, privacy compliance test, PII test | 4 | privacy_by_design_testing | — |
| RLHF, DPO alignment, reward modeling, preference tuning | 4 | rlhf_alignment | — |
| model alignment, constitutional AI, KTO ORPO | 4 | rlhf_alignment | — |
| Python testing, test Python code, pytest | 4 | python_testing | — |
| Python unit tests, Python test suite, unittest | 4 | python_testing | — |
| SAST scanning, static analysis, scan code for vulnerabilities | 4 | sast_scanning | — |
| code scanning, security static analysis, Semgrep | 4 | sast_scanning | — |
| secrets scanning, find leaked secrets, detect hardcoded keys | 4 | secrets_scanning | — |
| SSRF testing, server-side request forgery test | 4 | ssrf_testing_harness | — |
| secret detection, credential leak, API key scan | 4 | secrets_scanning | — |
| security audit, penetration test, security review | 4 | security_audit | — |
| vulnerability assessment, security check, OWASP review | 4 | security_audit | — |
| Spring Boot security, secure Spring app, Spring Security | 4 | springboot_security | — |
| Spring auth, Spring OAuth, Spring security config | 4 | springboot_security | — |
| Spring Boot TDD, test Spring app, Spring test driven | 4 | springboot_tdd | — |
| Spring tests, JUnit Spring, Spring Boot test | 4 | springboot_tdd | — |
| Spring Boot verification, verify Spring app, Spring checks | 4 | springboot_verification | — |
| Spring health check, validate Spring, Spring smoke test | 4 | springboot_verification | — |
| supply chain security, dependency security, SCA scan | 4 | supply_chain_security | — |
| vulnerable dependencies, npm audit, dependency vulnerabilities | 4 | supply_chain_security | — |
| TDD workflow, test driven development, write tests first | 4 | tdd_workflow | tdd |
| red green refactor, TDD cycle, test first | 4 | tdd_workflow | tdd |
| unit testing, write unit tests, test individual functions | 4 | unit_testing | — |
| unit test, test coverage, test a function | 4 | unit_testing | test-coverage |
| verification loop, verify everything works, run all checks | 4 | verification_loop | verify |
| full verification, validate build, confirm it works | 4 | verification_loop | verify |
| Web3 security, smart contract audit, blockchain security | 4 | web3_security | — |
| Solidity audit, DeFi security, reentrancy check | 4 | web3_security | — |

## Phase 5 — Ship

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| app store submission, iOS publish, Google Play deploy | 5 | app_store_deployment | — |
| Fastlane setup, app signing, app review process | 5 | app_store_deployment | — |
| artifact provenance, SLSA compliance, supply chain attestation | 5 | artifact_provenance_chain | — |
| canary deployment, canary verification, verify canary | 5 | canary_verification | — |
| canary release, gradual rollout check, canary health | 5 | canary_verification | — |
| change management, manage changes, change advisory board | 5 | change_management | — |
| change control, change request, RFC process | 5 | change_management | — |
| CI/CD pipeline, set up CI, build pipeline | 5 | ci_cd_pipeline | — |
| GitHub Actions, Jenkins, continuous integration, continuous deployment | 5 | ci_cd_pipeline | — |
| database migrations, run migrations, schema migration | 5 | db_migrations | — |
| migrate database, alter table, migration script | 5 | db_migrations | — |
| deployment approval, deployment gate, approve release | 5 | deployment_approval_gates | — |
| release gate, go-live approval, deploy permission | 5 | deployment_approval_gates | — |
| deployment patterns, blue green, rolling deployment | 5 | deployment_patterns | — |
| deploy strategy, zero downtime deploy, deployment approach | 5 | deployment_patterns | — |
| GitOps, ArgoCD setup, Flux deployment, git-based deployment | 5 | gitops_workflow | — |
| gitops sync strategy, declarative infrastructure | 5 | gitops_workflow | — |
| verify deployment, post-deploy check, deployment verification | 5 | deployment_verification | — |
| smoke test production, is deploy healthy, deployment health | 5 | deployment_verification | — |
| publish desktop app, package desktop, Electron build | 5 | desktop_publishing | — |
| distribute desktop app, installer, DMG or MSI | 5 | desktop_publishing | — |
| publish game, game release, ship the game | 5 | game_publishing | — |
| Steam release, app store game, game distribution | 5 | game_publishing | — |
| infrastructure as code, IaC, Terraform setup | 5 | infrastructure_as_code | — |
| Pulumi, CloudFormation, provision infrastructure | 5 | infrastructure_as_code | — |
| legal compliance, legal review, terms of service | 5 | legal_compliance | — |
| privacy policy, EULA, legal requirements | 5 | legal_compliance | — |
| MLOps pipeline, ML CI/CD, automated retraining | 5 | mlops_pipeline | — |
| Kubeflow pipeline, model validation gate, CT CD CM | 5 | mlops_pipeline | — |
| MLOps, deploy ML model, model serving | 5 | mlops | — |
| ML deployment, model pipeline, ML infrastructure | 5 | mlops | — |
| model registry, model versioning, model promotion | 5 | model_registry_management | — |
| MLflow registry, model staging, model rollback | 5 | model_registry_management | — |
| model serving, deploy ML model, vLLM TGI Triton | 5 | model_serving_deployment | — |
| inference server, model quantization deployment, GPU serving | 5 | model_serving_deployment | — |
| multi-stack deployment, polyglot deployment | 5 | multi_stack_deployment | — |
| publish open source, OSS release, open source project | 5 | oss_publishing | — |
| npm publish, crate publish, PyPI release | 5 | oss_publishing | — |
| release signing, sign artifacts, code signing | 5 | release_signing | — |
| GPG sign, binary signing, verify release integrity | 5 | release_signing | — |
| seed data, populate database, initial data | 5 | seed_data | — |
| test data, fixtures, seed the database | 5 | seed_data | — |
| launch website, go live, website launch checklist | 5 | website_launch | — |
| DNS cutover, production launch, site go-live | 5 | website_launch | — |

## Phase 5.5 — Alpha

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| AI model monitoring, data drift detection, model performance | 5.5 | ai_model_monitoring | — |
| concept drift, retraining trigger, Evidently WhyLabs | 5.5 | ai_model_monitoring | — |
| alpha exit criteria, ready to leave alpha, alpha gate | 5.5 | alpha_exit_criteria | — |
| alpha checklist, alpha done, graduate from alpha | 5.5 | alpha_exit_criteria | — |
| alpha incident communication, alpha outage notice, communicate alpha issue | 5.5 | alpha_incident_communication | — |
| notify alpha users, alpha incident update | 5.5 | alpha_incident_communication | — |
| alpha program management, manage alpha, alpha planning | 5.5 | alpha_program_management | — |
| run alpha program, alpha users, alpha coordination | 5.5 | alpha_program_management | — |
| alpha telemetry, alpha metrics, track alpha usage | 5.5 | alpha_telemetry | — |
| alpha monitoring, alpha analytics, alpha signals | 5.5 | alpha_telemetry | — |
| backup strategy, set up backups, data backup | 5.5 | backup_strategy | — |
| backup plan, disaster recovery backup, backup schedule | 5.5 | backup_strategy | — |
| env validation, validate environment, check environment | 5.5 | env_validation | — |
| environment check, verify env config, env health | 5.5 | env_validation | — |
| error tracking, set up Sentry, track errors | 5.5 | error_tracking | — |
| error monitoring, crash reporting, exception tracking | 5.5 | error_tracking | — |
| health checks, add health check, liveness probe | 5.5 | health_checks | — |
| readiness probe, health endpoint, service health | 5.5 | health_checks | — |
| QA playbook, quality assurance plan, testing strategy | 5.5 | qa_playbook | — |
| QA process, test plan, QA checklist | 5.5 | qa_playbook | — |

## Phase 5.75 — Beta

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| beta cohort management, manage beta users, beta groups | 5.75 | beta_cohort_management | — |
| beta invites, beta user segments, cohort analysis | 5.75 | beta_cohort_management | — |
| beta graduation criteria, exit beta, beta to GA | 5.75 | beta_graduation_criteria | — |
| ready for GA, beta done, graduate from beta | 5.75 | beta_graduation_criteria | — |
| beta SLA definition, beta service levels, beta uptime target | 5.75 | beta_sla_definition | — |
| beta reliability, beta availability commitment | 5.75 | beta_sla_definition | — |
| beta to GA migration, migrate from beta, GA cutover | 5.75 | beta_to_ga_migration | — |
| transition to production, beta migration plan | 5.75 | beta_to_ga_migration | — |
| email templates, transactional emails, email design | 5.75 | email_templates | — |
| welcome email, notification email, email content | 5.75 | email_templates | — |
| error boundaries, React error boundary, graceful error UI | 5.75 | error_boundaries | — |
| catch rendering errors, fallback UI, error containment | 5.75 | error_boundaries | — |
| beta feature flags, beta toggles, beta feature control | 5.75 | feature_flags | — |
| beta rollout flags, progressive beta features | 5.75 | feature_flags | — |
| feedback system, collect feedback, user feedback | 5.75 | feedback_system | — |
| feedback widget, NPS survey, user satisfaction | 5.75 | feedback_system | — |
| load testing, stress test at scale, simulate traffic | 5.75 | load_testing | — |
| k6 test, JMeter, performance under load | 5.75 | load_testing | — |
| privacy consent management, cookie consent, consent flow | 5.75 | privacy_consent_management | — |
| GDPR consent, privacy preferences, opt-in management | 5.75 | privacy_consent_management | — |
| product analytics, track user behavior, analytics setup | 5.75 | product_analytics | — |
| Mixpanel, Amplitude, event tracking, user analytics | 5.75 | product_analytics | — |
| rate limiting, throttle requests, API rate limit | 5.75 | rate_limiting | — |
| request throttling, DDoS protection, API quota | 5.75 | rate_limiting | — |
| usage metering, billing system, metered billing | 5.75 | usage_metering_billing | — |
| Stripe metering, usage-based pricing, subscription billing | 5.75 | usage_metering_billing | — |

## Phase 6 — Handoff

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| handoff access, transfer access, access provisioning | 6 | access_handoff | — |
| hand over credentials, access transfer, permission handoff | 6 | access_handoff | — |
| API reference docs, API documentation, document the API | 6 | api_reference | — |
| Swagger docs, API docs, endpoint documentation | 6 | api_reference | update-docs |
| community management, manage community, community building | 6 | community_management | — |
| Discord community, forum management, community engagement | 6 | community_management | — |
| disaster recovery plan, DR runbook, recovery procedure | 6 | disaster_recovery | — |
| failover plan, DR testing, business continuity plan | 6 | disaster_recovery | — |
| compliance certification handoff, audit documentation transfer | 6 | compliance_certification_handoff | — |
| reorganize docs, restructure documentation, doc cleanup | 6 | doc_reorganize | — |
| fix documentation structure, documentation audit, docs overhaul | 6 | doc_reorganize | update-docs |
| feature walkthrough, demo a feature, show how it works | 6 | feature_walkthrough | — |
| feature tour, walkthrough video, feature demo | 6 | feature_walkthrough | — |
| knowledge audit, audit what we know, documentation gaps | 6 | knowledge_audit | — |
| tribal knowledge, undocumented knowledge, knowledge map | 6 | knowledge_audit | — |
| monitoring handoff, hand over monitoring, ops monitoring | 6 | monitoring_handoff | — |
| transfer alerts, monitoring ownership, observability handoff | 6 | monitoring_handoff | — |
| observability handoff, monitoring ownership transfer | 6 | observability_handoff | — |
| operational readiness review, ORR, production readiness | 6 | operational_readiness_review | — |
| ready for production, ops review, go-live readiness | 6 | operational_readiness_review | — |
| SLA handoff, hand over SLAs, service level handoff | 6 | sla_handoff | — |
| transfer SLA ownership, SLA documentation | 6 | sla_handoff | — |
| support enablement, train support team, support docs | 6 | support_enablement | — |
| support runbook, escalation guide, support readiness | 6 | support_enablement | — |
| user documentation, write user docs, help articles | 6 | user_documentation | update-docs |
| user guide, how-to docs, end user documentation | 6 | user_documentation | update-docs |

## Phase 7 — Maintenance

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| capacity planning, plan for growth, performance capacity | 7 | capacity_planning_and_performance | — |
| compliance dashboard, compliance monitoring status | 7 | compliance_dashboard | — |
| scale planning, resource forecasting, growth capacity | 7 | capacity_planning_and_performance | — |
| continuous learning, team learning, upskill team | 7 | continuous_learning | — |
| learning plan, knowledge sharing, tech talks | 7 | continuous_learning | — |
| dependency management, update dependencies, keep deps current | 7 | dependency_management | — |
| Dependabot, Renovate, dependency updates | 7 | dependency_management | — |
| documentation standards, doc standards, how to write docs | 7 | documentation_standards | — |
| documentation guidelines, doc conventions, writing standards | 7 | documentation_standards | — |
| incident response, handle incident, production incident | 7 | incident_response_operations | — |
| on-call runbook, incident management, PagerDuty response | 7 | incident_response_operations | — |
| operational readiness gate, ops gate, production gate | 7 | operational_readiness_gate | — |
| regulatory change monitoring, regulation tracking | 7 | regulatory_change_monitoring | — |
| operational checkpoint, ops validation, maintenance readiness | 7 | operational_readiness_gate | — |
| security maintenance, security patching, keep secure | 7 | security_maintenance | — |
| CVE patching, security updates, vulnerability management | 7 | security_maintenance | — |
| SLO SLA management, manage SLOs, service level objectives | 7 | slo_sla_management | — |
| error budget, SLI tracking, reliability targets | 7 | slo_sla_management | — |
| SOP standards, standard operating procedures, write SOPs | 7 | sop_standards | — |
| ops procedures, runbook standards, operational playbook | 7 | sop_standards | — |
| update SSOT, refresh single source of truth, update canonical data | 7 | ssot_update | — |
| sync truth data, SSOT refresh, keep SSOT current | 7 | ssot_update | — |
| work instruction standards, write work instructions, WI format | 7 | wi_standards | — |
| step-by-step instructions, procedure writing, task instructions | 7 | wi_standards | — |

## Toolkit (Cross-Phase)

| Intent Keywords | Phase | Skill | Command |
|---|---|---|---|
| AI cost optimization, GPU cost, token cost tracking | toolkit | ai_cost_optimization | — |
| inference cost, model distillation ROI, AI budgeting | toolkit | ai_cost_optimization | — |
| ATOM protocol, run ATOM, axiomatic thinking, omnidirectional meta-analysis | toolkit | age | /atom |
| AGE framework, AGE analysis, adversarial gap engine | toolkit | age | /age |
| gap analysis, find gaps, capability gaps, what is missing | toolkit | age | /gap-analysis |
| adversarial audit, adversarial analysis, red team analysis | toolkit | age | /adversarial-audit |
| discovery engine, systematic discovery, blind spot analysis | toolkit | age | /discovery |
| agentic gap analysis, AGE assessment, first principles gap analysis | toolkit | age | /atom |
| ATOM to skill pipeline, convert ATOM gaps to skills | toolkit | age_to_skill_pipeline | — |
| turn gaps into skills, gap remediation, AGE to skill | toolkit | age_to_skill_pipeline | — |
| AI security hardening, secure AI systems, LLM security | toolkit | ai_security_hardening | — |
| prompt injection defense, AI safety, model security | toolkit | ai_security_hardening | — |
| AI tool orchestration, coordinate AI tools, multi-agent | toolkit | ai_tool_orchestration | orchestrate |
| tool chain, AI pipeline, agent orchestration | toolkit | ai_tool_orchestration | orchestrate |
| CEO brain, strategic thinking, executive overview | toolkit | ceo-brain | — |
| big picture, strategic view, business strategy | toolkit | ceo-brain | — |
| compliance program, build compliance, compliance framework | toolkit | compliance_program | — |
| compliance roadmap, regulatory program, compliance maturity | toolkit | compliance_program | — |
| content creation, write content, create blog post | toolkit | content_creation | — |
| copywriting, marketing content, content strategy | toolkit | content_creation | — |
| content waterfall, repurpose content, content multiplication | toolkit | content_waterfall | — |
| content repurposing, one to many content, content cascade | toolkit | content_waterfall | — |
| cost aware LLM, optimize AI costs, cheap LLM pipeline | toolkit | cost_aware_llm_pipeline | — |
| LLM cost optimization, token budget, model cost routing | toolkit | cost_aware_llm_pipeline | — |
| developer experience, dev containers, golden paths | toolkit | developer_experience_tooling | — |
| onboarding automation, CLI tooling, devex | toolkit | developer_experience_tooling | — |
| docs as code, Docusaurus, MkDocs, documentation CI | toolkit | documentation_as_code | — |
| API documentation, versioned docs, doc site | toolkit | documentation_as_code | — |
| delivery metrics, track delivery, team velocity | toolkit | delivery_metrics | — |
| throughput, cycle time, lead time | toolkit | delivery_metrics | — |
| DORA metrics, deployment frequency, change failure rate | toolkit | dora_metrics_tracking | — |
| EU AI Act, AI regulation compliance, risk classification | toolkit | eu_ai_act_compliance | — |
| DORA tracking, mean time to recovery, engineering metrics | toolkit | dora_metrics_tracking | — |
| green software, carbon aware, SCI scoring, energy efficient | toolkit | green_software_practices | — |
| sustainable computing, carbon footprint, eco-friendly code | toolkit | green_software_practices | — |
| governance framework, set up governance, decision framework | toolkit | governance_framework | — |
| governance model, oversight structure, governance board | toolkit | governance_framework | — |
| ISO 27001, information security management | toolkit | iso_27001_implementation | — |
| iterative retrieval, RAG optimization, retrieval improvement | toolkit | iterative_retrieval | — |
| better RAG, retrieval augmented generation, search refinement | toolkit | iterative_retrieval | — |
| observability maturity, observability assessment, monitoring maturity | toolkit | observability_maturity_model | — |
| observability level, monitoring gaps, observability roadmap | toolkit | observability_maturity_model | — |
| personal brand, build personal brand, thought leadership | toolkit | personal_brand | — |
| LinkedIn presence, personal branding, professional reputation | toolkit | personal_brand | — |
| phase gate contracts, gate criteria, phase transitions | toolkit | phase_gate_contracts | — |
| phase boundaries, gate approval, phase completion | toolkit | phase_gate_contracts | — |
| progressive rollout playbook, gradual release, staged rollout | toolkit | progressive_rollout_playbook | — |
| responsible AI, fairness testing, bias detection, explainability | toolkit | responsible_ai_framework | — |
| SHAP LIME, model cards, AI transparency, AI audit | toolkit | responsible_ai_framework | — |
| percentage rollout, feature percentage, incremental release | toolkit | progressive_rollout_playbook | — |
| project state persistence, save project state, resume project | toolkit | project_state_persistence | — |
| checkpoint project, project snapshot, project continuity | toolkit | project_state_persistence | checkpoint |
| skill lifecycle manager, manage skills, skill CRUD | toolkit | skill_lifecycle_manager | skill-create |
| create skill, update skill, skill maintenance | toolkit | skill_lifecycle_manager | skill-create |
| skill registry, list skills, available skills | toolkit | skill_registry | — |
| what skills exist, skill inventory, skill catalog | toolkit | skill_registry | — |
| SRE foundations, site reliability, SRE practices | toolkit | sre_foundations | — |
| SRE setup, reliability engineering, toil reduction | toolkit | sre_foundations | — |
| strategic compact, team alignment, strategic agreement | toolkit | strategic_compact | — |
| team charter, working agreement, strategic alignment | toolkit | strategic_compact | — |
| toolkit phase integration, connect toolkit to phases, phase hooks | toolkit | toolkit_phase_integration_guide | — |
| integrate tools with phases, toolkit and phases | toolkit | toolkit_phase_integration_guide | — |
| video research, research videos, video analysis | toolkit | video_research | — |
| YouTube research, video content analysis, video summarization | toolkit | video_research | — |

## Commands Quick Reference

| Intent Keywords | Command | Related Skill |
|---|---|---|
| fix the build, build is broken, compile error | build-fix | bug_troubleshoot |
| save checkpoint, snapshot progress, save state | checkpoint | project_state_persistence |
| run claw, openclaw command | claw | — |
| review code, check PR, code quality | code-review | code_review |
| end to end test, browser test, E2E | e2e | e2e_testing |
| evaluate model, AI eval, benchmark | eval | eval_harness |
| evolve the system, improve architecture | evolve | — |
| build Go project, Go compile | go-build | golang_patterns |
| review Go code, Go code review | go-review | code_review |
| test Go code, run Go tests | go-test | golang_testing |
| export instincts, save instincts | instinct-export | — |
| import instincts, load instincts | instinct-import | — |
| check instinct status, instinct health | instinct-status | — |
| learn from eval, eval learning | learn-eval | — |
| learn from experience, improve from feedback | learn | — |
| multi backend, run multiple backends | multi-backend | — |
| multi execute, run multiple commands | multi-execute | — |
| multi frontend, run multiple frontends | multi-frontend | — |
| multi plan, plan across services | multi-plan | — |
| multi workflow, orchestrate workflows | multi-workflow | — |
| orchestrate agents, coordinate tools | orchestrate | ai_tool_orchestration |
| make a plan, create plan, planning | plan | — |
| pm2 process manager, manage processes | pm2 | — |
| review Python code, Python code review | python-review | code_review |
| refactor and clean, clean code | refactor-clean | refactoring |
| manage sessions, list sessions | sessions | — |
| set up project management, PM setup | setup-pm | — |
| create a skill, new skill | skill-create | skill_lifecycle_manager |
| run TDD, test driven | tdd | tdd_workflow |
| check test coverage, coverage report | test-coverage | unit_testing |
| update code maps, refresh maps | update-codemaps | codebase_navigation |
| update documentation, refresh docs | update-docs | user_documentation |
| verify everything, full check | verify | verification_loop |
