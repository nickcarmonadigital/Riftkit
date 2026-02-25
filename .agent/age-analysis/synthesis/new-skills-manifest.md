# AGE New Skills Manifest -- AI Dev Workflow Framework
## Generated: 2026-02-25
## Total Net-New Skills: 68

This document lists ONLY net-new skills proposed across all 12 AGE target analyses. Modifications to existing skills are documented in `synthesized-gaps.md` and are NOT included here.

---

## Phase 0 -- Context (7 new skills)

### 1. dev-environment-setup
- **Phase Directory**: `0-context/dev_environment_setup/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Step-by-step guided process from fresh clone to fully operational local development environment. Covers prerequisite verification (language versions, Docker, databases), dependency installation, environment variable setup from .env.example, database seeding, and a verification step running the test suite. Includes troubleshooting guide for the 10 most common setup failures and tracks "time to first green build" metric.
- **Trigger Commands**: "Set up local development environment", "Get this project running locally", "New developer setup"
- **Dependencies**: None (foundational)
- **Source Targets**: T0-Loop3

### 2. phase-0-playbook
- **Phase Directory**: `0-context/phase_0_playbook/`
- **Priority**: P0 | **Complexity**: S
- **Scope**: Meta-skill determining the correct Phase 0 skill sequence based on project scenario. Defines four archetypes: Greenfield, Inherit, Archaeological, and Operational Takeover. For each archetype, specifies ordered skill sequence, estimated time per skill, and required artifacts before Phase 1 can begin. Functions as the Phase 0 entry point.
- **Trigger Commands**: "I'm starting Phase 0", "Joining a project, where to start", "Phase 0 entry"
- **Dependencies**: All other Phase 0 skills (write last)
- **Source Targets**: T0-Loop4

### 3. stakeholder-map
- **Phase Directory**: `0-context/stakeholder_map/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Identifies and documents all parties with decision-making authority, funding, operational responsibility, and end-user representation. Produces a stakeholder matrix with name, role, contact, and decision scope. Captures business constraints: budget, deadlines, compliance obligations, and political constraints. Outputs a Stakeholder & Constraints Fact Sheet.
- **Trigger Commands**: "Who owns this project", "Map the stakeholders", "What are the business constraints"
- **Dependencies**: None
- **Source Targets**: T0-Loop1

### 4. compliance-context
- **Phase Directory**: `0-context/compliance_context/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: Inventories all applicable regulatory frameworks (GDPR, CCPA, HIPAA, PCI-DSS, SOC2, ISO 27001, FedRAMP) based on product type, geography, and customer segment. Performs a Personal Data Inventory (PII collected, stored, retained, shared, deleted), documents legal basis for processing, and verifies consent management. Produces a compliance posture score per framework.
- **Trigger Commands**: "What compliance requirements apply", "Map regulatory obligations", "Privacy engineering baseline"
- **Dependencies**: stakeholder-map
- **Source Targets**: T0-Loop1, T0-Loop6

### 5. risk-register
- **Phase Directory**: `0-context/risk_register/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Aggregates risks from all Phase 0 skill outputs into a single scored risk register, rating each on Likelihood x Impact x Velocity. Assigns categories (Technical, Security, Compliance, Operational, Business, Team) with mitigation status and owner. Produces a Risk Heat Map and Top 5 Priority Risks list as primary input to Phase 1 prioritization.
- **Trigger Commands**: "Consolidate project risks", "Create risk register", "What could kill this project"
- **Dependencies**: compliance-context, codebase_health_audit (existing)
- **Source Targets**: T0-Loop4

### 6. phase-exit-summary
- **Phase Directory**: `0-context/phase_exit_summary/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Synthesis skill reading all Phase 0 artifacts and producing a "Phase 0 Exit Brief" covering system health score, top 3 technical risks, business constraints, team velocity baseline (DORA if available), recommended Phase 1 actions, and Phase 0 skills completed vs. skipped with rationale. This IS the formal Phase 0 to Phase 1 handoff artifact.
- **Trigger Commands**: "Complete Phase 0", "Phase 0 exit summary", "Prepare Phase 1 handoff"
- **Dependencies**: All Phase 0 skills (runs last)
- **Source Targets**: T0-Loop3

### 7. supply-chain-audit
- **Phase Directory**: `0-context/supply_chain_audit/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Performs software supply chain security assessment covering SBOM generation (SPDX/CycloneDX), dependency confusion attack surface analysis, GitHub Actions hash-pinning verification, code signing checks, and OpenSSF Scorecard execution. Complements codebase_health_audit (CVE scanning) by focusing on provenance, integrity, and build pipeline security.
- **Trigger Commands**: "Audit supply chain security", "Generate SBOM", "OpenSSF scorecard"
- **Dependencies**: None
- **Source Targets**: T0-Loop6

---

## Phase 1 -- Brainstorm (5 new skills)

### 8. assumption-testing
- **Phase Directory**: `1-brainstorm/assumption_testing/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Forces enumeration of all project assumptions, ranks them by risk (probability x impact), and designs minimum experiments to invalidate the riskiest ones before committing engineering resources. Covers Leap of Faith Assumptions (LOFAs), pre-mortem analysis, and Riskiest Assumption Testing (RAT). Produces a signed assumption log.
- **Trigger Commands**: "Test our assumptions", "What are we assuming?", "Riskiest assumption"
- **Dependencies**: lean-canvas (optional, enhances)
- **Source Targets**: T1-Loop1

### 9. market-sizing
- **Phase Directory**: `1-brainstorm/market_sizing/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Guides TAM-SAM-SOM analysis with both top-down (industry reports) and bottom-up (unit economics) approaches. Covers market sizing for consumer, B2B SaaS, marketplace, and developer tools. Includes willingness-to-pay validation and revenue projection methodology. Produces market-sizing.md with key metrics.
- **Trigger Commands**: "Market sizing for [product]", "TAM SAM SOM analysis", "How big is the market"
- **Dependencies**: competitive_analysis (existing)
- **Source Targets**: T1-Loop1

### 10. prd-generator
- **Phase Directory**: `1-brainstorm/prd_generator/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: Synthesizes all Phase 1 outputs (client_discovery, user_research, competitive_analysis, prioritization_frameworks, product_metrics, user_story_standards, assumption_testing, lean_canvas, market_sizing) into a comprehensive PRD. Includes integrity check that flags sections resting on untested assumptions. Produces prd.md as the primary Phase 1 output artifact.
- **Trigger Commands**: "Generate PRD for [product]", "Create product requirements document", "Synthesize Phase 1"
- **Dependencies**: All Phase 1 skills
- **Source Targets**: T1-Loop5

### 11. go-no-go-gate
- **Phase Directory**: `1-brainstorm/go_no_go_gate/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Formal decision gate that evaluates 7 dimensions with a scoring rubric: market viability, technical feasibility, team capability, assumption validation, competitive differentiation, financial model, and compliance risk. Produces a GO/NO-GO/CONDITIONAL-GO decision with specific conditions and a signed decision document. Blocks Phase 2 entry until gate is passed.
- **Trigger Commands**: "Go or no-go for [project]", "Should we build this?", "Phase 1 gate"
- **Dependencies**: prd-generator, assumption-testing, market-sizing
- **Source Targets**: T1-Loop3

### 12. lean-canvas
- **Phase Directory**: `1-brainstorm/lean_canvas/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Guides completion of Lean Canvas for the product: 9-box canvas covering Problem, Customer Segments, UVP, Solution, Channels, Revenue Streams, Cost Structure, Key Metrics, and Unfair Advantage. After canvas: identifies which box has highest uncertainty (riskiest assumption). Designs MVP scope. Produces lean-canvas.md.
- **Trigger Commands**: "Lean canvas for [product]", "One-page business model", "Validate before building"
- **Dependencies**: client_discovery (existing)
- **Source Targets**: T1-Loop6

---

## Phase 2 -- Design (13 new skills)

### 13. design-intake
- **Phase Directory**: `2-design/design_intake/`
- **Priority**: P0 | **Complexity**: S
- **Scope**: Validates incoming Phase 1 artifacts for completeness before design work begins. Checks for user stories, problem statement, success criteria, priority scores, and scope exclusions. If missing, triggers Phase 1 skill invocations. Produces "Design Readiness: APPROVED" or "BLOCKED" status with missing items list. This is the Phase 1 to Phase 2 gate.
- **Trigger Commands**: "Begin design phase", "Validate design readiness", "Check if spec is ready for design"
- **Dependencies**: Phase 1 skills (validates their outputs)
- **Source Targets**: T2-Loop3, T2-Loop7

### 14. architecture-decision-records
- **Phase Directory**: `2-design/architecture_decision_records/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Implements MADR (Markdown Architectural Decision Records) format v3.0 with fill-in-the-blank template capturing context, decision drivers, considered options with pros/cons, outcome, consequences, and status lifecycle (Proposed/Accepted/Deprecated/Superseded). Maintains ADR index file. Integrates with SSoT.
- **Trigger Commands**: "Record architectural decision", "Create ADR for [decision]", "Document why we chose [X] over [Y]"
- **Dependencies**: design-intake
- **Source Targets**: T2-Loop1, T0-Loop4

### 15. security-threat-modeling
- **Phase Directory**: `2-design/security_threat_modeling/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: 5-step STRIDE threat modeling session against ARA architecture output. Draw DFD from ARA, enumerate threats using STRIDE per boundary, rate with DREAD, define mitigations, produce Threat Register. Output becomes Phase 4's security audit baseline. Also supports PASTA methodology for high-risk systems.
- **Trigger Commands**: "Threat model for [system]", "Run STRIDE analysis", "Identify security threats"
- **Dependencies**: ARA (existing), design-intake
- **Source Targets**: T2-Loop1, T4-Loop1, TX-Loop6

### 16. design-handoff
- **Phase Directory**: `2-design/design_handoff/`
- **Priority**: P0 | **Complexity**: S
- **Scope**: Consolidates all Phase 2 outputs into a Design Package manifest, validates each required artifact exists and meets quality criteria, produces Design Sign-Off document with implementation constraints for Phase 3, a "Must Not Change Without ADR" locked decisions list, and a Phase 3 entry checklist. This is the Phase 2 to Phase 3 gate.
- **Trigger Commands**: "Complete design phase", "Package design artifacts for build", "Design sign-off"
- **Dependencies**: All Phase 2 skills (terminal skill)
- **Source Targets**: T2-Loop3, T2-Loop7

### 17. nfr-specification
- **Phase Directory**: `2-design/nfr_specification/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Produces NFR document covering 7 dimensions: Performance (latency p50/p95/p99, throughput, Core Web Vitals), Reliability (availability, RTO, RPO, error budget), Scalability (scale-out targets, peak concurrency), Security (compliance tiers, encryption), Maintainability (DORA targets), Consistency (model choice with justification), Accessibility (WCAG conformance level). Each has "Not Applicable + reason" option.
- **Trigger Commands**: "Define NFRs for [system]", "Specify performance requirements", "Set SLO targets"
- **Dependencies**: design-intake
- **Source Targets**: T2-Loop1, T2-Loop4, T2-Loop6

### 18. api-contract-design
- **Phase Directory**: `2-design/api_contract_design/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Produces OpenAPI 3.0 specification as design artifact before implementation. Covers consumer identification, required operations per consumer, schema definitions, error contract, auth/authz per endpoint, breaking-change policy, and versioning strategy. The spec becomes the authoritative contract validated in CI via Spectral/Dredd.
- **Trigger Commands**: "Define API contract for [service]", "Contract-first API design", "Design API spec before implementation"
- **Dependencies**: ARA (existing), nfr-specification
- **Source Targets**: T2-Loop2, T2-Loop6

### 19. data-privacy-design
- **Phase Directory**: `2-design/data_privacy_design/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Covers 6 areas: PII classification matrix, data residency map, retention policy specification, right-to-erasure design (cascade delete vs anonymization vs pseudonymization), consent architecture, and GDPR Article 30 RoPA template. Annotates schema fields with privacy tier (public, internal, sensitive-PII, sensitive-PHI, sensitive-financial).
- **Trigger Commands**: "Design data privacy for [system]", "GDPR compliance design", "PII classification"
- **Dependencies**: schema_standards (existing), design-intake
- **Source Targets**: T2-Loop4, T3-Loop6

### 20. c4-architecture-diagrams
- **Phase Directory**: `2-design/c4_architecture_diagrams/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Produces all 4 C4 diagram levels in Mermaid syntax: Level 1 Context (system + users + external deps), Level 2 Container (runtime boundaries), Level 3 Component (internal modules), Level 4 Code (key class/function relationships). Provides audience guidance per level. Integrates with ARA atomic decomposition.
- **Trigger Commands**: "Create C4 diagrams for [system]", "Generate architecture diagrams", "C4 context diagram"
- **Dependencies**: ARA (existing)
- **Source Targets**: T2-Loop6

### 21. accessibility-design
- **Phase Directory**: `2-design/accessibility_design/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: Sets WCAG 2.1/2.2 conformance target, defines keyboard navigation patterns for complex UI components, specifies ARIA roles and landmarks, defines color contrast requirements, establishes accessible form validation patterns, and produces an accessibility requirements checklist that Phase 3 frontend must satisfy. Covers European Accessibility Act 2025 compliance.
- **Trigger Commands**: "Design accessibility for [product]", "Define WCAG requirements", "Accessibility plan"
- **Dependencies**: design-intake
- **Source Targets**: T2-Loop6

### 22. cost-architecture
- **Phase Directory**: `2-design/cost_architecture/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: Cloud cost modeling during design phase. Covers resource sizing for expected load, FinOps tagging strategy, cost allocation per service/feature, budget projection with growth scenarios, cost optimization opportunities (reserved instances, spot instances, serverless thresholds), and cost-per-user-unit calculation.
- **Trigger Commands**: "Cloud cost model for [system]", "FinOps design", "Budget projection for [architecture]"
- **Dependencies**: ARA (existing), nfr-specification
- **Source Targets**: T2-Loop1

### 23. rto-rpo-design
- **Phase Directory**: `2-design/rto_rpo_design/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Captures and documents Recovery Time Objective (RTO) and Recovery Point Objective (RPO) requirements during design. Produces a DR requirements document referenced by Phase 5.5 backup_strategy, Phase 6 disaster_recovery, and Phase 7 incident_response_operations. Covers tiered service classification with different RTO/RPO per tier.
- **Trigger Commands**: "Define RTO and RPO", "Disaster recovery requirements", "Business continuity requirements"
- **Dependencies**: None
- **Source Targets**: TX-Loop7

### 24. multi-tenancy-architecture
- **Phase Directory**: `2-design/multi_tenancy_architecture/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Complete tenancy model selection framework covering three models (row-level, schema-per-tenant, database-per-tenant) with decision matrix based on isolation, regulatory, performance, and operational factors. Includes tenant resolution patterns, cross-tenant query prevention architecture, tenant-aware caching, and tenant offboarding/data export. Specifies Phase 4 cross-tenant isolation tests.
- **Trigger Commands**: "Multi-tenant design", "Tenant isolation architecture", "SaaS tenancy model"
- **Dependencies**: schema_standards (existing)
- **Source Targets**: TX-Loop1, TX-Loop7

### 25. internationalization-design
- **Phase Directory**: `2-design/internationalization_design/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Phase 2 i18n architecture decisions: string externalization strategy (i18next, Fluent, ICU format), locale-aware data model design (timezone storage, currency representation, address formats), RTL layout considerations, locale detection and fallback strategy, translation workflow design, and CAT tool selection. Prevents the 3-5x retrofit cost of adding i18n post-build.
- **Trigger Commands**: "International markets", "i18n architecture", "Multi-language support design"
- **Dependencies**: None
- **Source Targets**: TX-Loop1, TX-Loop7

---

## Phase 3 -- Build (11 new skills)

### 26. test-driven-build
- **Phase Directory**: `3-build/test_driven_build/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Bridge skill activating tdd_workflow (Phase 4) within Phase 3's implementation loop. Defines minimum test coverage gates for spec_build Phase 7 (unit tests for services, integration tests for controllers). Requires failing tests BEFORE implementation. Makes spec_build gate condition: "Feature builds AND all tests pass." Embeds red-green-refactor into the build workflow.
- **Trigger Commands**: "Write tests as I build", "TDD workflow during implementation", "Test-first for [module]"
- **Dependencies**: tdd_workflow (Phase 4, existing), spec_build (existing)
- **Source Targets**: T3-Loop3

### 27. feature-flags
- **Phase Directory**: `3-build/feature_flags/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Comprehensive feature flag lifecycle: when to use flags vs branching, self-hosted flag evaluation (Redis-backed), NestJS guard-level integration, React component wrapping, LaunchDarkly/Unleash patterns, flag lifecycle (create/test/rollout/cleanup), flag debt management with scheduled cleanup. Includes Phase 6 handoff checklist and Phase 7 audit protocol. Merges T3 and T575 proposals into single lifecycle skill.
- **Trigger Commands**: "Add feature flag for [feature]", "Roll out gradually", "Implement kill switch"
- **Dependencies**: environment_setup (existing)
- **Source Targets**: T3-Loop1, T575-Loop2, TX-Loop1

### 28. event-driven-architecture
- **Phase Directory**: `3-build/event_driven_architecture/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: When events vs direct calls, BullMQ in NestJS (producer/consumer/worker patterns), Redis Streams vs Bull vs RabbitMQ vs Kafka selection guide, event schema design (envelope pattern, version field), idempotent consumers (deduplication strategies), dead-letter queue patterns, saga pattern for distributed transactions. Exit checklist: queue configured, consumer idempotent, DLQ handling defined.
- **Trigger Commands**: "Decouple [service] with events", "Add message queue", "Implement pub/sub"
- **Dependencies**: backend_patterns (existing)
- **Source Targets**: T3-Loop1

### 29. resiliency-patterns
- **Phase Directory**: `3-build/resiliency_patterns/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: Resiliency pyramid: timeout, retry, circuit breaker, fallback, graceful degradation. NestJS circuit breaker with opossum, timeout enforcement, retry with exponential backoff and jitter, fallback response patterns (cached, degraded), bulkhead isolation (separate pools per dependency), health-check integration with resiliency decisions.
- **Trigger Commands**: "Add circuit breaker to [service]", "Make [feature] resilient", "Graceful degradation"
- **Dependencies**: backend_patterns (existing), event-driven-architecture
- **Source Targets**: T3-Loop5

### 30. secret-management
- **Phase Directory**: `3-build/secret_management/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Secret management maturity levels (.env to CI secrets to Secrets Manager to Vault). AWS Secrets Manager integration in NestJS (ConfigModule), secret rotation patterns (zero-downtime), secret detection in code (git-secrets, gitleaks pre-commit), the "secret zero" problem (IAM roles, OIDC tokens), per-environment secret scoping.
- **Trigger Commands**: "Set up secrets for [project]", "Move from .env to Secrets Manager", "Rotate secrets"
- **Dependencies**: environment_setup (existing)
- **Source Targets**: T3-Loop4

### 31. authorization-patterns
- **Phase Directory**: `3-build/authorization_patterns/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: RBAC vs ABAC vs ReBAC decision guide, ownership-based authorization guard (OwnershipGuard) in NestJS, policy service pattern (centralized auth logic), resource-level permission patterns, multi-tenant authorization (tenant isolation + within-tenant RBAC), Casbin integration. Exit checklist: every endpoint has documented auth rule, ownership check implemented.
- **Trigger Commands**: "Add ownership check for [resource]", "Can user access [resource]?", "Authorization patterns"
- **Dependencies**: auth_implementation (existing)
- **Source Targets**: T3-Loop5

### 32. backward-compatibility
- **Phase Directory**: `3-build/backward_compatibility/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Breaking vs non-breaking change classification matrix, additive-only API evolution, deprecation headers (Sunset, Deprecation per RFC 8594), expand-contract pattern at API level, consumer-driven contract testing (Pact), API changelog communication, database schema backward compatibility for blue-green deployments.
- **Trigger Commands**: "How to evolve [API] without breaking consumers", "Add sunset header", "Backward compatible change"
- **Dependencies**: api_design (existing)
- **Source Targets**: T3-Loop1

### 33. privacy-by-design
- **Phase Directory**: `3-build/privacy_by_design/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Data minimization patterns (never store unnecessary data), PII classification taxonomy, right-to-erasure strategies (hard delete vs anonymization), field-level PII encryption (application layer), consent model schema and implementation, data retention policy with NestJS scheduled cleanup jobs, GDPR audit logging (who accessed PII when).
- **Trigger Commands**: "Implement right to erasure", "Add GDPR compliance for [feature]", "Privacy by design"
- **Dependencies**: database_optimization (existing)
- **Source Targets**: T3-Loop6

### 34. dependency-hygiene
- **Phase Directory**: `3-build/dependency_hygiene/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: npm audit / pip-audit / cargo audit in pre-commit hooks, Snyk CI integration, Dependabot configuration, license compliance checking, dependency pinning strategy, lockfile integrity, private registry configuration, SCA vs SAST distinction. Covers the build-phase complement to Phase 4's supply_chain_security.
- **Trigger Commands**: "Audit dependencies", "Check for vulnerabilities", "Configure Dependabot"
- **Dependencies**: environment_setup (existing), git_workflow (existing)
- **Source Targets**: T3-Loop4

### 35. i18n-implementation
- **Phase Directory**: `3-build/i18n_implementation/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Phase 3 implementation of i18n decisions from Phase 2 internationalization_design. Covers extraction-first development workflow, locale-safe date/number/currency formatting (frontend Intl API + backend), React i18next integration, NestJS locale middleware, pseudo-localization testing, locale-specific CI test runs.
- **Trigger Commands**: "Extract strings for translation", "Implement locale support", "i18n for [component]"
- **Dependencies**: internationalization-design (Phase 2)
- **Source Targets**: TX-Loop7

### 36. state-machine-patterns
- **Phase Directory**: `3-build/state_machine_patterns/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: When to use state machines, database-backed state machine (status column + transition guard table), XState for frontend workflow states, NestJS service-level state enforcement, state history audit logging, visualizing state machines in documentation.
- **Trigger Commands**: "Model [workflow] as state machine", "Prevent invalid state transitions", "State machine for [entity]"
- **Dependencies**: database_optimization (existing)
- **Source Targets**: T3-Loop1

---

## Phase 4 -- Secure (8 new skills)

### 37. sast-scanning
- **Phase Directory**: `4-secure/sast_scanning/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Configure and run Static Application Security Testing using Semgrep or CodeQL. Covers tool installation, language-appropriate ruleset selection, baseline management for existing findings, CI/CD integration as blocking PR gate, custom rule authoring for project-specific patterns, false-positive triage workflow. Output: SARIF-format results for GitHub Security tab.
- **Trigger Commands**: "Run SAST scan", "Static security analysis", "Configure Semgrep", "Setup CodeQL"
- **Dependencies**: secrets-scanning (pre-commit stack alignment)
- **Source Targets**: T4-Loop1, T4-Loop7

### 38. secrets-scanning
- **Phase Directory**: `4-secure/secrets_scanning/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Three-layer protection: (1) Pre-commit prevention with detect-secrets/gitleaks, baseline management; (2) CI gate with gitleaks GitHub Actions; (3) Historical remediation with truffleHog, rotation playbook, git-filter-repo for history cleanup. Includes E2E auth token .gitignore enforcement.
- **Trigger Commands**: "Scan for secrets", "Detect credentials in code", "Install secrets pre-commit hook"
- **Dependencies**: None
- **Source Targets**: T4-Loop7

### 39. container-security
- **Phase Directory**: `4-secure/container_security/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Three parts: (1) Dockerfile hardening (non-root USER, distroless bases, multi-stage, no secrets in ENV); (2) Image scanning with Trivy/Scout, CI blocking on critical CVEs, SBOM from layers; (3) Runtime security (no --privileged, cap_drop ALL, seccomp profiles, K8s Pod Security Standards). Output: Trivy report + hardened Dockerfile.
- **Trigger Commands**: "Scan Docker image", "Harden Dockerfile", "Container security audit", "CIS Docker benchmark"
- **Dependencies**: None
- **Source Targets**: T4-Loop7

### 40. supply-chain-security
- **Phase Directory**: `4-secure/supply_chain_security/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Comprehensive SCA covering OWASP Dependency-Check/Snyk/pip-audit as CI gates, SBOM generation in CycloneDX format, license compliance detection (GPL/AGPL in commercial), dependency confusion/typosquatting detection, lockfile integrity verification, dependency pinning strategy. Output: SBOM + dependency risk report.
- **Trigger Commands**: "SCA scan", "Dependency audit", "Supply chain check", "Generate SBOM"
- **Dependencies**: secrets-scanning, sast-scanning
- **Source Targets**: T4-Loop7

### 41. compliance-testing-framework
- **Phase Directory**: `4-secure/compliance_testing_framework/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: Maps testing activities to compliance controls for 4 major frameworks: SOC2 Type II (CC6, CC7), HIPAA (Section 164.306 safeguards), GDPR (Articles 25/35), PCI-DSS (Req 6/11). Generates compliance evidence package (test results mapped to controls) ready for auditor review.
- **Trigger Commands**: "Compliance testing for SOC2", "HIPAA testing requirements", "Map tests to compliance controls"
- **Dependencies**: sast-scanning, supply-chain-security, secrets-scanning, container-security
- **Source Targets**: T4-Loop7

### 42. mutation-testing
- **Phase Directory**: `4-secure/mutation_testing/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: Configure and run mutation testing: Stryker.js for TypeScript, mutmut for Python, PIT for Java. Covers incremental mutation (changed files only in CI), 70%+ mutation score threshold, interpreting surviving mutants and converting them to better tests. Validates that line coverage actually catches bugs.
- **Trigger Commands**: "Run mutation tests", "Validate test suite effectiveness", "Mutation score for [module]"
- **Dependencies**: tdd_workflow (existing), unit_testing (existing)
- **Source Targets**: T4-Loop1

### 43. privacy-by-design-testing
- **Phase Directory**: `4-secure/privacy_by_design_testing/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: DPIA trigger assessment (when Article 35 applies), PII discovery in codebase/test data using Presidio, consent management verification tests, right-to-erasure cascade tests (DELETE /user cascades correctly), data minimization assessment (over-collection detection in API schemas). Output: DPIA template + PII scan report.
- **Trigger Commands**: "Privacy impact assessment", "DPIA for [feature]", "GDPR compliance testing"
- **Dependencies**: compliance-testing-framework
- **Source Targets**: T4-Loop6

### 44. chaos-engineering
- **Phase Directory**: `4-secure/chaos_engineering/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Scheduled chaos engineering protocol covering failure injection scenarios (container kill, network partition, DB connection exhaustion, dependency timeout), gameday runbook, chaos test result analysis, DR runbook validation. Phase 4 runs pre-production chaos. Phase 7 runs scheduled production experiments.
- **Trigger Commands**: "Chaos test", "Failure injection test", "Resilience testing", "Gameday"
- **Dependencies**: None
- **Source Targets**: TX-Loop7

---

## Phase 5 -- Ship (5 new skills)

### 45. deployment-verification
- **Phase Directory**: `5-ship/deployment_verification/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Automated post-deployment verification skill: health endpoint polling, smoke test suite execution, metric comparison (error rate delta, latency p99 delta), dependency connectivity verification, database migration verification. Produces PASS/FAIL deployment verification report. Integrates as GitHub Actions reusable workflow.
- **Trigger Commands**: "Verify deployment", "Post-deploy checks", "Deployment smoke test"
- **Dependencies**: deployment_patterns (existing)
- **Source Targets**: T5-Loop1

### 46. canary-verification
- **Phase Directory**: `5-ship/canary_verification/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Automated canary promotion gates using error rate, latency p99, and business metric thresholds. Covers Istio-based K8s canary and feature-flag-based simple canary. Polls metrics after canary deploy and auto-aborts/promotes. Integrates with Datadog/Prometheus/Grafana. Covers both app-level and ML model canary verification.
- **Trigger Commands**: "Canary deployment", "Progressive rollout", "Automated rollout verification"
- **Dependencies**: deployment-verification
- **Source Targets**: T5-Loop1

### 47. deployment-approval-gates
- **Phase Directory**: `5-ship/deployment_approval_gates/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Multi-gate deployment pipeline: pre-deploy (all tests pass, security scan clean, no open P0 bugs), migration gate (backward-compatible, tested, sequenced), approval gate (GitHub Environments required_reviewers), post-deploy (deployment-verification passes). Prevents "merge-to-deploy" without verification.
- **Trigger Commands**: "Add deployment gates", "Require approval for deploy", "Production deploy checklist"
- **Dependencies**: deployment-verification
- **Source Targets**: T5-Loop3

### 48. release-signing
- **Phase Directory**: `5-ship/release_signing/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Artifact signing across types: Docker images (cosign keyless via Sigstore/GitHub OIDC), npm packages (npm provenance), GitHub Releases (cosign blob signing), SBOM attachment to releases (CycloneDX/SPDX). Covers verification commands for each artifact type and CI integration for automated signing.
- **Trigger Commands**: "Sign release artifacts", "Add npm provenance", "Container signing setup"
- **Dependencies**: None
- **Source Targets**: T5-Loop5

### 49. change-management
- **Phase Directory**: `5-ship/change_management/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Lightweight auditable change management for SaaS: automated change record creation (GitHub Issue) on every production deploy, emergency change procedure template, change record retention (GitHub Issues archive), monthly change log for SOC2 auditors, mapping to SOC2 CC8.1 controls. No external tooling required.
- **Trigger Commands**: "Change management records", "SOC2 change log", "Deployment audit trail"
- **Dependencies**: deployment-approval-gates
- **Source Targets**: T5-Loop6

---

## Phase 5.5 -- Alpha (4 new skills)

### 50. alpha-program-management
- **Phase Directory**: `55-alpha/alpha_program_management/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Umbrella skill for the alpha program lifecycle: tester recruitment and onboarding, access-gating (invite-only allowlist), outage communication to alpha cohort, staged rollout verification, alpha-specific data policies (data preservation commitments), tester feedback loop (NPS, in-session annotation), and direct communication channels for high-trust alpha testers.
- **Trigger Commands**: "Set up alpha program", "Alpha tester onboarding", "Alpha access management"
- **Dependencies**: None
- **Source Targets**: T55-Loop1

### 51. alpha-exit-criteria
- **Phase Directory**: `55-alpha/alpha_exit_criteria/`
- **Priority**: P1 | **Complexity**: S
- **Scope**: Defines measurable exit gates for alpha graduation to beta: crash-free session rate, P0/P1 bug resolution rate, core workflow completion rate, performance baseline establishment (what is "normal"), data integrity verification, and minimum tester diversity threshold. Produces alpha exit report.
- **Trigger Commands**: "Alpha exit criteria", "Ready for beta?", "Alpha graduation checklist"
- **Dependencies**: alpha-program-management
- **Source Targets**: T55-Loop1

### 52. alpha-telemetry
- **Phase Directory**: `55-alpha/alpha_telemetry/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: Alpha-specific instrumentation beyond generic error tracking: session-level event collection, crash/panic reporting with session context, performance baseline establishment per user-unit, resource consumption measurement, and telemetry consent management specific to alpha testers.
- **Trigger Commands**: "Alpha telemetry setup", "Instrument alpha build", "Alpha performance baseline"
- **Dependencies**: error_tracking (existing)
- **Source Targets**: T55-Loop1

### 53. alpha-incident-communication
- **Phase Directory**: `55-alpha/alpha_incident_communication/`
- **Priority**: P2 | **Complexity**: S
- **Scope**: Incident communication protocol specific to alpha's small, high-trust cohort. Covers direct notification channels (Slack, email, in-app), outage status page for alpha testers, incident post-mortem sharing with alpha cohort, and managing tester expectations during instability periods.
- **Trigger Commands**: "Alpha incident communication", "Notify alpha testers of outage", "Alpha status update"
- **Dependencies**: None
- **Source Targets**: T55-Loop1

---

## Phase 5.75 -- Beta (7 new skills)

### 54. beta-graduation-criteria
- **Phase Directory**: `575-beta/beta_graduation_criteria/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Defines measurable exit gates: error rate < threshold, P0 feedback resolution >= threshold, 7-day retention >= threshold, p95 API latency < threshold, minimum users from minimum organizations completing activation, zero open P0 bugs. Produces GA_READINESS_REPORT. Aggregates all Beta skill outputs for final decision.
- **Trigger Commands**: "Define beta exit criteria", "Beta graduation checklist", "GA readiness assessment"
- **Dependencies**: All Beta skills
- **Source Targets**: T575-Loop1

### 55. beta-to-ga-migration
- **Phase Directory**: `575-beta/beta_to_ga_migration/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Complete transition procedure: feature flag cleanup automation (remove alpha/beta flags), Stripe pricing migration (beta-free to GA-paid), user communication workflow (GA announcement), data migration verification, DNS/CDN cutover checklist, monitoring threshold adjustment for GA traffic levels.
- **Trigger Commands**: "Migrate beta to GA", "GA launch procedure", "Beta cleanup and launch"
- **Dependencies**: beta-graduation-criteria (gate must pass first)
- **Source Targets**: T575-Loop7

### 56. usage-metering-billing
- **Phase Directory**: `575-beta/usage_metering_billing/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Stripe Meters API integration for usage-based billing, MeteringService implementation, usage accumulator (Redis-backed), UsageSummary endpoint for customer visibility, plan limit enforcement coordination with rate_limiting, usage warning emails, and billing dashboard. Covers freemium-to-paid conversion flow.
- **Trigger Commands**: "Set up usage billing", "Implement metering", "Stripe billing integration"
- **Dependencies**: rate_limiting (existing), email_templates (existing)
- **Source Targets**: T575-Loop3

### 57. load-testing
- **Phase Directory**: `575-beta/load_testing/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: k6-based load testing for Beta: script development (API scenarios, browser scenarios), acceptance criteria definition (p95 latency, error rate, throughput), CI integration for automated load test runs, baseline establishment, capacity limit identification, and load test results artifact for beta_graduation_criteria consumption.
- **Trigger Commands**: "Load test for [service]", "Establish capacity baseline", "Run k6 against beta"
- **Dependencies**: rate_limiting (existing), health_checks (existing)
- **Source Targets**: T575-Loop4

### 58. beta-cohort-management
- **Phase Directory**: `575-beta/beta_cohort_management/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Manages beta tester segments: cohort creation (early adopters, enterprise trial, power users), analytics separation by cohort, cohort-specific feature rollout via feature flags, activation funnel tracking per cohort, and cohort communication (separate email lists, Slack channels).
- **Trigger Commands**: "Create beta cohort", "Segment beta users", "Cohort analytics"
- **Dependencies**: feature_flags (Phase 3 or 5.75), product_analytics (existing)
- **Source Targets**: T575-Loop2

### 59. privacy-consent-management
- **Phase Directory**: `575-beta/privacy_consent_management/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: GDPR/CCPA consent infrastructure: consent collection before analytics/tracking, consent withdrawal flows, consent audit trail, cookie consent banner implementation (no dark patterns), consent propagation to third-party services, and consent management database model. Addresses the P0 GDPR gap in product_analytics.
- **Trigger Commands**: "Set up consent management", "GDPR consent infrastructure", "Cookie consent implementation"
- **Dependencies**: product_analytics (existing, fixes its GDPR gap)
- **Source Targets**: T575-Loop1, T575-Loop4

### 60. beta-sla-definition
- **Phase Directory**: `575-beta/beta_sla_definition/`
- **Priority**: P2 | **Complexity**: S
- **Scope**: Defines and communicates Beta SLA commitments to testers: uptime targets, data durability promises, response time expectations, support response time, and planned maintenance windows. Produces SLA document for beta testers and internal SLO targets for the engineering team.
- **Trigger Commands**: "Define beta SLA", "Beta uptime commitment", "What do we promise beta users"
- **Dependencies**: load-testing (SLA grounded in measured capacity)
- **Source Targets**: T575-Loop4

---

## Phase 6 -- Handoff (6 new skills)

### 61. knowledge-audit
- **Phase Directory**: `6-handoff/knowledge_audit/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Captures undocumented tribal knowledge before team transitions: 5-step audit process (ADR extraction from git/Slack/interviews, configuration registry discovery, gotchas documentation, credential inventory, lessons learned compilation). Includes "stranger test" where someone unfamiliar attempts setup using only documentation. Runs first in Phase 6.
- **Trigger Commands**: "Run knowledge audit", "Capture tribal knowledge", "Document what's undocumented"
- **Dependencies**: None (runs first in Phase 6)
- **Source Targets**: T6-Loop1

### 62. access-handoff
- **Phase Directory**: `6-handoff/access_handoff/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Structured credential and access transfer: credential inventory (every secret, API key, certificate with owner, rotation schedule, expiry), access transfer matrix (who needs access to what), information asset register (ISO 27001), former-access revocation checklist, and emergency access procedure.
- **Trigger Commands**: "Transfer access for [project]", "Credential handoff", "Access inventory"
- **Dependencies**: knowledge-audit (credential inventory section)
- **Source Targets**: T6-Loop1

### 63. support-enablement
- **Phase Directory**: `6-handoff/support_enablement/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Onboards support teams for the product: diagnostic decision trees (symptom to resolution), escalation matrix (who to call for what), known issue tracker (seeded from beta feedback), support SLA targets, knowledge base seed content, and support agent training guide. Bridges the gap between development documentation and support operations.
- **Trigger Commands**: "Create support playbook", "Onboard support team", "Build knowledge base"
- **Dependencies**: user_documentation (existing), disaster_recovery (existing)
- **Source Targets**: T6-Loop1

### 64. operational-readiness-review
- **Phase Directory**: `6-handoff/operational_readiness_review/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Formal readiness gate verifying all Phase 6 skills are complete. Produces readiness scorecard across dimensions (documentation, monitoring, support, DR, access, SLA). Stakeholder sign-off matrix (who must approve what). DORA baseline capture. Formal handoff declaration document. Communication plan for GA announcement.
- **Trigger Commands**: "Run readiness review", "Stakeholder sign-off checklist", "GA readiness check"
- **Dependencies**: All Phase 6 skills (terminal gate)
- **Source Targets**: T6-Loop1

### 65. sla-handoff
- **Phase Directory**: `6-handoff/sla_handoff/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Defines and communicates SLA commitments for GA: SLO definitions per service tier, error budget policy, change freeze policies for high-traffic periods, SLA communication document for customers, internal escalation triggers when SLA is at risk.
- **Trigger Commands**: "Define GA SLAs", "SLA handoff document", "Error budget policy"
- **Dependencies**: Phase 5 monitoring, Phase 5.75 performance data
- **Source Targets**: T6-Loop3

### 66. monitoring-handoff
- **Phase Directory**: `6-handoff/monitoring_handoff/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Transfers monitoring ownership: alert ownership map (who responds to what), on-call rotation configuration (PagerDuty/OpsGenie), dashboard inventory with purpose per dashboard, alert threshold documentation, alert fatigue assessment, and monitoring runbook linking alerts to corresponding DR runbooks.
- **Trigger Commands**: "Transfer monitoring ownership", "On-call setup", "Alert ownership handoff"
- **Dependencies**: sla-handoff (alert thresholds match SLOs)
- **Source Targets**: T6-Loop3

---

## Phase 7 -- Maintenance (5 new skills)

### 67. incident-response-operations
- **Phase Directory**: `7-maintenance/incident_response_operations/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Active incident lifecycle: detect (alert fires), triage (severity classification with rubric), mitigate (immediate user impact reduction), resolve (root cause fix), post-mortem (blameless template with timeline, impact, root cause, action items), action-item tracking (JIRA/GitHub Issues integration). Includes on-call rotation management, escalation trees, and SLA breach tracking.
- **Trigger Commands**: "Run incident response", "Conduct post-mortem", "Incident triage for [event]"
- **Dependencies**: Phase 6 disaster_recovery (consumes runbooks)
- **Source Targets**: T7-Loop1

### 68. slo-sla-management
- **Phase Directory**: `7-maintenance/slo_sla_management/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Ongoing SLO/SLA tracking and error budget management. Covers SLO definition templates (availability, latency, error rate), error budget calculation and burn-rate monitoring, deployment freeze trigger (budget exhausted), weekly SLO review cadence, error budget-aware release decisions, and SLA breach notification workflow.
- **Trigger Commands**: "SLO status", "Error budget remaining", "Should we deploy or freeze?"
- **Dependencies**: Phase 4/5 monitoring infrastructure
- **Source Targets**: T7-Loop1, TX-Loop6

### 69. security-maintenance
- **Phase Directory**: `7-maintenance/security_maintenance/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Ongoing security practice: monthly CVE monitoring cadence, security patch prioritization (CVSS-based), annual penetration test scheduling and management, certificate rotation tracking, OWASP dependency check re-runs, security advisory monitoring (GitHub security advisories, NVD feeds), and incident security assessment protocol.
- **Trigger Commands**: "Monthly security review", "CVE check for [project]", "Security patch planning"
- **Dependencies**: Phase 4 security skill outputs
- **Source Targets**: T7-Loop2

### 70. capacity-planning-and-performance
- **Phase Directory**: `7-maintenance/capacity_planning_and_performance/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Performance baseline establishment (p50/p95/p99, DB query times, memory/CPU per service), monthly trend tracking with 20% deviation alerts, capacity forecasting (6-month and 12-month projections for disk, DB connections, API rate limits), rightsizing recommendations (over/under-provisioned), and cloud cost monitoring (anomaly detection, budget alerts).
- **Trigger Commands**: "Capacity trends for [service]", "Performance baselines", "Forecast resource requirements"
- **Dependencies**: Phase 4/5 monitoring
- **Source Targets**: T7-Loop4, TX-Loop1

### 71. operational-readiness-gate
- **Phase Directory**: `7-maintenance/operational_readiness_gate/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Phase 6-to-7 transition gate plus Phase 7-to-0 loop-back. Validates all Phase 6 artifacts are operational (runbooks tested, monitoring live, SLOs defined, on-call assigned). Establishes Phase 7 operational calendar. On Phase 7 exit: generates structured Phase 0 handoff document with production learnings, tech debt inventory, feature usage data, and recommended next iteration priorities.
- **Trigger Commands**: "Validate operational readiness", "Phase 7 kickoff", "Generate Phase 0 handoff"
- **Dependencies**: All Phase 6 skills, all Phase 7 skills
- **Source Targets**: T7-Loop7

---

## Toolkit (6 new skills)

### 72. skill-registry
- **Phase Directory**: `toolkit/skill_registry/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Central registry for all framework skills: manifest file listing every skill with metadata (name, phase, version, status, trigger commands, dependencies). Provides /skill-search command for discovery, /skill-audit for usage tracking, and skill quality scoring. Enables the framework to know what it contains and whether skills are being used.
- **Trigger Commands**: "Search for skill about [topic]", "Audit skill usage", "List all skills in [phase]"
- **Dependencies**: None (foundational)
- **Source Targets**: TK-Loop1

### 73. age-to-skill-pipeline
- **Phase Directory**: `toolkit/age_to_skill_pipeline/`
- **Priority**: P0 | **Complexity**: M
- **Scope**: Converts AGE analysis findings (gaps.log) into shipping skills. Defines the pipeline: gap triage (P0/P1/P2/P3), skill scope definition (from gap finding to 3-sentence scope), SKILL.md authoring template with quality checklist, peer review process, skill-registry registration, and post-deployment verification (was the gap actually closed?).
- **Trigger Commands**: "Convert gaps to skills", "AGE implementation pipeline", "Build skill from gap finding"
- **Dependencies**: skill-registry, age (existing)
- **Source Targets**: TK-Loop1

### 74. ai-security-hardening
- **Phase Directory**: `toolkit/ai_security_hardening/`
- **Priority**: P0 | **Complexity**: L
- **Scope**: Security hardening for AI-assisted development workflows: prompt injection defense patterns, output validation (never trust LLM output for security-critical decisions), PII leakage prevention in AI context (redact before sending), jailbreak prevention, model output sandboxing, and cost-attack prevention (malicious prompts designed to consume credits).
- **Trigger Commands**: "Harden AI workflow", "Prompt injection defense", "AI security review"
- **Dependencies**: ai_tool_orchestration (existing)
- **Source Targets**: TK-Loop4

### 75. delivery-metrics
- **Phase Directory**: `toolkit/delivery_metrics/`
- **Priority**: P1 | **Complexity**: M
- **Scope**: Instruments the framework to capture DORA metrics: deployment frequency from git tags, lead time from commit-to-production, MTTR from incident timestamps, change failure rate from hotfix tracking. Stores in .agent/metrics/dora.json. Provides /metrics-report command with Elite/High/Medium/Low tier classification.
- **Trigger Commands**: "DORA metrics", "Deployment frequency report", "Lead time analysis", "What's our MTTR?"
- **Dependencies**: None
- **Source Targets**: TK-Loop6, TX-Loop6

### 76. toolkit-phase-integration-guide
- **Phase Directory**: `toolkit/toolkit_phase_integration_guide/`
- **Priority**: P1 | **Complexity**: L
- **Scope**: Definitive reference for which toolkit skills activate at which phase events. Matrix format: rows = phases (0-7 + Alpha/Beta), columns = toolkit skills, cells = activation event. For each activation point: lists prerequisites, expected outputs, handoff artifacts. Defines "preflight check" pattern validating prerequisites before skill execution.
- **Trigger Commands**: "Toolkit setup for [phase]", "Which toolkit skills for build?", "Phase toolkit activation"
- **Dependencies**: All toolkit skills (documents their integration)
- **Source Targets**: TK-Loop3

### 77. skill-lifecycle-manager
- **Phase Directory**: `toolkit/skill_lifecycle_manager/`
- **Priority**: P2 | **Complexity**: M
- **Scope**: Manages skill versioning, deprecation, and sunsetting. Defines semver for skills, deprecation notices with migration guides, sunset timelines, skill compatibility matrices across framework versions, and skill health metrics (trigger frequency, user satisfaction, error rate).
- **Trigger Commands**: "Deprecate skill [name]", "Skill version history", "Sunset schedule"
- **Dependencies**: skill-registry
- **Source Targets**: TK-Loop1

---

## Cross-Phase Infrastructure (8 new skills/documents)

### 78. compliance-program
- **Phase Directory**: Cross-phase (registered in toolkit, used in 0/2/4/6/7)
- **Priority**: P0 | **Complexity**: L
- **Scope**: Three-part compliance program: (1) Regime identification questionnaire (healthcare/fintech/SaaS/government) producing project-specific compliance manifest; (2) Per-phase compliance checklist injection for each identified regime; (3) Phase 7 compliance drift detection with periodic re-assessment. Accompanied by compliance-reviewer agent and /compliance-audit command.
- **Trigger Commands**: "Set up compliance program", "What compliance applies?", "Run compliance audit"
- **Dependencies**: None
- **Source Targets**: TX-Loop1, TX-Loop7

### 79. observability-maturity-model
- **Phase Directory**: Cross-phase (registered in toolkit, spans 2-7)
- **Priority**: P0 | **Complexity**: M
- **Scope**: Defines 4 maturity levels: L1 Reactive (basic logs, error tracking), L2 Proactive (distributed tracing, dashboards), L3 Predictive (SLOs, error budgets, anomaly detection), L4 Autonomous (ML-based detection, auto-remediation). Maps each phase to target level with concrete implementation guidance per level.
- **Trigger Commands**: "Assess observability maturity", "What should we monitor?", "Observability roadmap"
- **Dependencies**: None
- **Source Targets**: TX-Loop1, TX-Loop7

### 80. progressive-rollout-playbook
- **Phase Directory**: Cross-phase (spans 5/5.5/5.75)
- **Priority**: P0 | **Complexity**: L
- **Scope**: End-to-end traffic migration: 0% (dev) to alpha (invite-only) to beta (5-50% feature flags) to canary GA (1-10-50-100% with automated verification at each step). For each step: access gating method, metrics to verify, rollback procedure. Accompanied by /rollout command for state machine management.
- **Trigger Commands**: "Progressive rollout plan", "Traffic migration strategy", "Alpha to GA rollout"
- **Dependencies**: canary-verification, feature-flags
- **Source Targets**: TX-Loop1, TX-Loop7

### 81. phase-gate-contracts
- **Phase Directory**: `.agent/docs/phase-gates.md` (infrastructure document)
- **Priority**: P0 | **Complexity**: M
- **Scope**: Machine-checkable entry and exit criteria for all 10 phase transitions. Each gate defines required input artifacts, quality bars (coverage %, audit status), required approvals (team-scale configurable), and cross-phase artifact references. Accompanied by /gate-check command that validates readiness. The central document that transforms disconnected tools into a lifecycle.
- **Trigger Commands**: "/gate-check [from-phase] [to-phase]", "Phase transition readiness"
- **Dependencies**: None (foundational infrastructure)
- **Source Targets**: TX-Loop3

### 82. dora-metrics-tracking
- **Phase Directory**: Cross-phase (anchor in Phase 7, collection in Phase 5)
- **Priority**: P1 | **Complexity**: M
- **Scope**: Four-quadrant DORA tracking: deployment frequency from CI/CD logs, lead time from merge-to-deploy timestamp, change failure rate from post-deploy incidents, MTTR from incident open/close. Weekly/monthly report templates with elite/high/medium/low thresholds. Accompanied by /dora-report command.
- **Trigger Commands**: "DORA metrics report", "Deployment frequency", "Change failure rate"
- **Dependencies**: None
- **Source Targets**: TX-Loop6

### 83. sre-foundations
- **Phase Directory**: Cross-phase (anchor in Phase 7, SLO design in Phase 2)
- **Priority**: P1 | **Complexity**: L
- **Scope**: Comprehensive SRE practice framework: SLO definition templates, error budget calculation, toil audit framework, blameless postmortem template with action-item tracking, on-call rotation design, alert fatigue management, and the operational excellence cycle (measure, improve, repeat). This is the missing operational excellence layer.
- **Trigger Commands**: "Set up SRE practices", "Toil audit", "On-call rotation design"
- **Dependencies**: slo-sla-management
- **Source Targets**: TX-Loop6

### 84. project-state-persistence
- **Phase Directory**: `.agent/project-state.json` (infrastructure)
- **Priority**: P0 | **Complexity**: M
- **Scope**: Persistent project health artifact updated at each phase exit. Structured JSON capturing: current phase, last audit date, test coverage trend, dependency health, compliance status, DORA metrics, and phase completion checklist. Accompanied by /project-status command showing dashboard. Solves the "framework has no memory across sessions" problem.
- **Trigger Commands**: "/project-status", "What phase are we in?", "Project health dashboard"
- **Dependencies**: None (foundational infrastructure)
- **Source Targets**: TX-Loop4

### 85. governance-framework
- **Phase Directory**: Cross-phase (infrastructure for team-scale)
- **Priority**: P2 | **Complexity**: L
- **Scope**: Team-scale configuration guide with three tiers: Solo/Startup (lightweight, minimal gates), SMB/Agency (standard gates, PR-based approvals), Enterprise (formal CAB, audit trails, RBAC for phase gates, multi-repo coordination). Covers phase gate approval roles, audit trail generation for SOC2, and multi-developer coordination patterns.
- **Trigger Commands**: "Configure for [team size]", "Set up approval roles", "Enterprise governance setup"
- **Dependencies**: phase-gate-contracts
- **Source Targets**: TX-Loop5

---

## Summary Statistics

| Category | Count |
|----------|-------|
| Total net-new skills | 85 |
| Phase 0 (Context) | 7 |
| Phase 1 (Brainstorm) | 5 |
| Phase 2 (Design) | 13 |
| Phase 3 (Build) | 11 |
| Phase 4 (Secure) | 8 |
| Phase 5 (Ship) | 5 |
| Phase 5.5 (Alpha) | 4 |
| Phase 5.75 (Beta) | 7 |
| Phase 6 (Handoff) | 6 |
| Phase 7 (Maintenance) | 5 |
| Toolkit | 6 |
| Cross-Phase Infrastructure | 8 |
| **Priority P0** | **22** |
| **Priority P1** | **41** |
| **Priority P2** | **17** |
| **Priority P3** | **5** |
| **Complexity S** | **12** |
| **Complexity M** | **50** |
| **Complexity L** | **23** |

Note: The initial estimate of 68 net-new skills in the synthesized-gaps.md was conservative after aggressive deduplication. The full manifest contains 85 skills because cross-phase infrastructure items, which were initially categorized as "infrastructure documents" rather than skills, are included here as they require SKILL.md-format authoring. The core deduplicated skill count (excluding pure infrastructure documents like phase-gates.md and project-state.json) is approximately 78.
