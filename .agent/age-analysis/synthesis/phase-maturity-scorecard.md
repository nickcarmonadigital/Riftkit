# AGE Phase Maturity Scorecard -- AI Dev Workflow Framework
## Analysis Date: 2026-02-25
## Grading Scale: A (Excellent) | B (Good) | C (Adequate) | D (Deficient) | F (Absent/Critical)

---

## Scoring Methodology

Each phase is graded across 6 dimensions on an A-F scale:

1. **Coverage**: Does the phase have skills for all its atomic responsibilities?
2. **Depth**: Are existing skills thorough or surface-level?
3. **Handoffs**: Are upstream/downstream contracts well-defined?
4. **Industry Alignment**: Does the phase meet industry standards (DORA, OWASP, SRE, ISO)?
5. **Failure Resilience**: Do skills handle edge cases, context changes, and failure modes?
6. **Infrastructure**: Does the phase have adequate agents, commands, and workflows?

Grades are derived from the 8-loop adversarial analysis findings. An "A" means no significant gaps were found. An "F" means the dimension is essentially absent or critically broken.

---

## Phase 0: Context

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | C | 15 skills cover codebase navigation, health audit, architecture recovery well. Missing: dev environment setup, stakeholder mapping, compliance context, risk consolidation, phase exit summary. ~7 of 22 atomic responsibilities uncovered. |
| Depth | B | Existing skills (codebase_health_audit, architecture_recovery, infrastructure_audit) are genuinely thorough with multi-step processes. codebase_navigation is NestJS-biased but structurally sound. |
| Handoffs | D | No Phase 0 exit artifact. No defined "done state." Phase 1 skills receive no formal handoff from Phase 0. Session-handoff-prompt.md is a context dump, not a structured gate. |
| Industry Alignment | C- | OWASP API Security Top 10 not covered. SRE error budget/toil baseline absent. No supply chain security assessment (post-Log4Shell table stakes). DORA baseline not captured. No CIS benchmark coverage. |
| Failure Resilience | C | Handles single-repo greenfield well. Fails on: multi-repo systems, forensic archaeology (original team gone), multi-cloud/hybrid infrastructure, serverless-only architectures, OSS contribution contexts. |
| Infrastructure | C+ | Has checkpoint command, sessions command. No dedicated Phase 0 agent. No Phase 0-specific workflow beyond the general 0-context.md. |
| **Overall** | **C+** | Phase 0 has strong existing skills but is missing foundational pieces (dev setup, stakeholder mapping) and has no exit gate. |

---

## Phase 1: Brainstorm

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | C- | 9 skills cover discovery, competitive analysis, spec writing, prioritization, and user research. Missing: assumption testing, market sizing, PRD generation, go/no-go gate, lean canvas, business model validation. Critical gaps in validation discipline. |
| Depth | B- | Existing skills are reasonably thorough. idea_to_spec has a 5-section structure. competitive_analysis covers 10 competitor dimensions. user_research covers 5 research methods. But idea_to_spec lacks NFR requirements, STRIDE threat surface, and compliance tier. |
| Handoffs | D- | No Phase 1 exit artifact. No go/no-go gate. No PRD as a formal output. Phase 2 begins on implicit, unreviewed specs. No Phase 0 to Phase 1 intake validation either. |
| Industry Alignment | C- | No Lean Startup methodology (LOFAs, RAT, Lean Canvas). No PMF (Product-Market Fit) framework. No TAM-SAM-SOM methodology. Product management industry best practices are absent. |
| Failure Resilience | C | Works for single-product SaaS brainstorming. Fails for: enterprise (no stakeholder alignment skill), marketplace (no multi-sided platform analysis), hardware/firmware products, B2G (no compliance-first brainstorming). |
| Infrastructure | D | No dedicated agent. No dedicated commands. No Phase 1-specific workflows. Everything is manual skill invocation. |
| **Overall** | **C** | Phase 1 has a good base of 9 skills but critically lacks validation discipline and has no formal exit gate. |

---

## Phase 2: Design

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | D | Only 4 skills (ARA, deployment_modes, feature_architecture, schema_standards) for a domain requiring 15-20. Missing: ADRs, threat modeling, NFR specification, API contract design, data privacy design, C4 diagrams, accessibility design, cost architecture, intake/handoff gates. The most under-resourced phase. |
| Depth | B | The 4 existing skills are well-designed. ARA is a comprehensive 8-phase methodology. deployment_modes covers 6 deployment modes with compliance tables. schema_standards has thorough Prisma-specific guidance. Quality is high; quantity is critically low. |
| Handoffs | F | No intake gate (Phase 1 to Phase 2). No handoff gate (Phase 2 to Phase 3). Design work can begin on unreviewed PRDs and Phase 3 can begin without verifying design completeness. Both transitions are undefined. |
| Industry Alignment | D- | No TOGAF ADR practice. No STRIDE/PASTA threat modeling. No ISO 25010 quality model. No C4 model diagramming. No API-first/contract-first design (industry mandate). No DORA-aware delivery architecture. No WCAG accessibility design. |
| Failure Resilience | D | ARA handles greenfield well but fails for brownfield (no current-state mapping step). deployment_modes fails for IoT/firmware/dApp contexts. feature_architecture fails for event-driven systems. No multi-repo design patterns. |
| Infrastructure | C | Has architect and planner agents. Has /plan and /multi-plan commands. Has design-review workflow. But design-review only covers UI/UX, not architecture approval. |
| **Overall** | **D** | Phase 2 is the most critical gap in the entire framework. With only 4 skills and no gates, it produces architectures missing ADRs, threat models, and NFR contracts, making every downstream phase harder. |

---

## Phase 3: Build

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | B+ | 50 skills covering web, mobile, embedded, financial, game, data, and process domains. Comprehensive vertical coverage. Cross-cutting gaps: feature flags, event-driven architecture, resiliency patterns, secret management, authorization patterns, backward compatibility, privacy-by-design, i18n. ~11 missing cross-cutting skills in the most critical category. |
| Depth | A- | Existing skills are genuinely thorough. api_design has 14 parts. backend_patterns covers 12 service patterns. auth_implementation is comprehensive (JWT, RBAC, session, OAuth). observability covers metrics/logs/traces with real code. Swagger/OpenAPI setup is the only notable depth gap in a core skill. |
| Handoffs | C | spec_build is a 12-phase orchestrator with exit checklists -- the best handoff mechanism in the framework. But: no Phase 2 to Phase 3 intake validation, TDD lives in Phase 4 (not Phase 3), and there is no formal build-complete artifact for Phase 4. |
| Industry Alignment | B- | OWASP A01-A10 partially covered (A03 SQL injection good, A05 security headers missing, A10 SSRF absent). SLSA framework partially covered (Level 1 yes, Level 3 no). GDPR Article 25 partially covered (PII redaction in logs yes, right-to-erasure patterns no). SOC2 change management adequate through git_workflow. |
| Failure Resilience | B- | Handles NestJS/React stack extremely well. Handles Django, Spring Boot, Go, C++, Swift through dedicated skills. Fails on: multi-service architectures (no event-driven patterns), high-scale systems (no circuit breaker/bulkhead), and any system requiring i18n. |
| Infrastructure | A- | 8 agents (code-reviewer, tdd-guide, build-error-resolver, refactor-cleaner, database-reviewer, go-reviewer, go-build-resolver, python-reviewer). 12+ commands. Strong orchestration via /orchestrate. Best-supported phase. |
| **Overall** | **B+** | Phase 3 is the framework's crown jewel. Strong vertical coverage, deep existing skills, and excellent infrastructure. Gaps are in cross-cutting patterns (security headers, event-driven, resiliency, feature flags) rather than core implementation. |

---

## Phase 4: Secure

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | C+ | 21 skills, but 14 are testing methodology (TDD, unit, integration, E2E, accessibility, performance, eval, and language-specific variants). Only 4 address security directly (security_audit, django_security, springboot_security, web3_security). Missing: SAST scanning, secrets scanning, container security, supply chain security, compliance testing, mutation testing, privacy testing. Phase is named "Secure" but is primarily a testing phase. |
| Depth | B | Testing skills are thorough: tdd_workflow is comprehensive, e2e_testing covers Playwright with auth state, performance_testing covers k6 with multiple scenarios. security_audit covers OWASP Top 10 checklist. However, security_audit is a manual checklist -- no automated scanning integration. |
| Handoffs | D+ | No Phase 3 to Phase 4 intake gate. No Phase 4 exit artifact bundle. No machine-readable security sign-off consumed by Phase 5 CI/CD. Performance baselines established but never referenced downstream. |
| Industry Alignment | C- | OWASP Top 10 covered (checklist-only, no SAST). OWASP SAMM coverage ~10-15%. No CIS benchmarks. No NIST SSDF automated compliance. No SLSA framework coverage. SOC2 Type II testing evidence not generated. ISO 27001 A.8.29 (security testing) not formally addressed. |
| Failure Resilience | C | Handles web app security review well. Fails on: container security (Docker ubiquitous, no scanning), supply chain attacks (dependency confusion, typosquatting), API-only Django deployments (DRF security gaps), Swift testing (Phase 3 has Swift skills, Phase 4 has no Swift testing), and legacy code without test infrastructure. |
| Infrastructure | B+ | Has security-reviewer, e2e-runner, code-reviewer, tdd-guide agents. Has /e2e, /verify, /test-coverage, /eval commands. 4-secure workflow exists. Good automation but no SAST/SCA CI integration. |
| **Overall** | **C+** | Phase 4 has strong testing methodology but is misleadingly named "Secure" when security coverage is thin. Adding SAST, secrets scanning, container security, and supply chain security would transform it. |

---

## Phase 5: Ship

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | C | 12 skills covering CI/CD, deployment patterns, IaC, database migrations, legal compliance, website launch, game publishing, OSS publishing, seed data, MLOps, and changelog. Missing: deployment verification, canary verification, deployment approval gates, release signing, change management. No post-deployment automation. |
| Depth | B- | ci_cd_pipeline is thorough (GitHub Actions multi-stage). deployment_patterns covers blue-green, canary (conceptually). infrastructure_as_code covers Terraform and K8s. But: ci_cd_pipeline has a migration-before-app-deploy bug, IaC has :latest tag anti-pattern in K8s manifests, and legal_compliance is surface-level boilerplate. |
| Handoffs | D | No Phase 4 to Phase 5 intake gate (security audit not consumed). No deployment verification after deploy. No canary gate before full rollout. Phase 5 to Phase 5.5 transition has no verification that ship workflow completed. |
| Industry Alignment | C- | No DORA metrics instrumentation. No SOC2 change management records. No SLSA artifact signing. No CIS Docker/K8s hardening. NIST SSDF deployment security partially covered. SRE deployment practices (SLO-aware releases, error budget gates) completely absent. |
| Failure Resilience | C- | Works for single-service deployment. Fails on: multi-service partial failure (Service A deploys, Service B fails -- no rollback coordination), CDN cache invalidation failures, Terraform state lock corruption, IaC secret verification, config drift between IaC and running state, and game store/app store rejection recovery. |
| Infrastructure | D | No dedicated agents. No dedicated commands. 5-ship workflow exists but no /deploy, /rollback, or /canary commands. Deployments are the highest-stakes operations with the least automation. |
| **Overall** | **C** | Phase 5 has adequate skill coverage for basic deployments but critically lacks post-deployment verification, canary gates, and deployment approval workflows. High-stakes operations have low automation. |

---

## Phase 5.5: Alpha

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | D- | 5 skills (backup_strategy, env_validation, error_tracking, health_checks, qa_playbook) are general infrastructure, not alpha-specific. Missing: alpha program management, access gating, cohort management, exit criteria, alpha-specific telemetry, incident communication, data policies. The phase has no skills addressing what makes an "alpha" distinct from "production." |
| Depth | C+ | Existing skills are adequate: backup_strategy covers 3-2-1 rule and verification, health_checks covers HTTP endpoints and dependencies, error_tracking covers Sentry setup. But they are generic production skills, not alpha-specific skills. |
| Handoffs | D | No Phase 5 to Phase 5.5 intake verification. No alpha exit criteria (no defined "done" state for alpha). Alpha to beta transition relies on a single line in beta-release.md: "Alpha testing complete -- no P0 or P1 bugs remaining" with no defined bug severity rubric. |
| Industry Alignment | D | No structured alpha testing methodology (Google's Dogfooding, Microsoft's Ring deployment model). No alpha-specific SLA framework. No staged rollout verification pattern. |
| Failure Resilience | D | No access gating (anyone can sign up during "alpha"). No alpha-specific data policies (will alpha data be preserved?). No incident communication for small, high-trust cohort. No handling of alpha data migration to beta. |
| Infrastructure | F | No dedicated agents. No dedicated commands. No dedicated workflows beyond alpha-release.md (which is a high-level checklist, not automation). |
| **Overall** | **D-** | Phase 5.5 is alpha in name only. The 5 existing skills are generic production infrastructure that any phase could use. The alpha-specific lifecycle (cohort management, access gating, exit criteria) is completely absent. |

---

## Phase 5.75: Beta

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | D+ | 6 skills (email_templates, error_boundaries, feature_flags, feedback_system, product_analytics, rate_limiting) implement useful Beta capabilities but miss: graduation criteria, GA migration, usage metering/billing, load testing, cohort management, consent management, A/B testing rigor, SLA definition. 8-10 critical skills missing. |
| Depth | C | Existing skills are functional but have gaps: product_analytics collects without GDPR consent gate (active legal violation), feedback_system has OWASP API authorization vulnerabilities, feature_flags lacks Redis caching (fails at scale), rate_limiting lacks trust proxy guidance. Each existing skill needs corrections. |
| Handoffs | F | No beta graduation criteria (beta runs indefinitely). No beta-to-GA migration procedure. No formal verification that alpha prerequisites were met before beta begins. The Phase 5.75 to Phase 6 transition is the worst-defined gate in the entire framework. |
| Industry Alignment | D | No load testing before opening to real users (industry standard). No statistical rigor for A/B testing (academic standard). No GDPR consent management (legal requirement). No SOC2 readiness foundation (enterprise requirement). No DORA metrics baseline. |
| Failure Resilience | C- | Works for simple feature rollout. Fails on: usage-based billing (revenue blocked), enterprise beta customers (no SOC2 evidence), GDPR-regulated markets (consent gate absent), high-scale beta (feature_flags lacks Redis caching), and beta tester churn (no feedback loop closure). |
| Infrastructure | F | No dedicated agents. No dedicated commands. beta-release.md workflow exists but is a high-level checklist. No /beta-check, /beta-status, or /beta-graduate commands. |
| **Overall** | **D+** | Phase 5.75 has useful building blocks but is critically missing exit criteria, GA migration, billing, and has active security/compliance vulnerabilities in existing skills. |

---

## Phase 6: Handoff

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | D | 6 skills (api_reference, community_management, disaster_recovery, doc_reorganize, feature_walkthrough, user_documentation). Missing: knowledge audit, access handoff, support enablement, operational readiness review, SLA handoff, monitoring handoff. The phase covers documentation but not operational transfer. |
| Depth | B- | api_reference has good NestJS-specific coverage. disaster_recovery has 8 scenario runbooks. user_documentation covers 8 doc types. But: api_reference is NestJS-only (no FastAPI/Express), disaster_recovery lacks formal RTO/RPO tables and DR drill playbook, and community_management only covers OSS (not SaaS/enterprise). |
| Handoffs | D- | No Phase 5.75 to Phase 6 intake verification (beta graduation not confirmed). No Phase 6 to Phase 7 formal transfer (no operational readiness gate). No stakeholder sign-off mechanism. Handoff has no authoritative ending condition. |
| Industry Alignment | C- | ISO 27001 information asset inventory partially addressed. ITIL change/release management absent. SRE production readiness review absent. GDPR data breach notification not covered in disaster_recovery. No formal DR drill cadence (industry standard: quarterly). |
| Failure Resilience | C | Handles documentation handoff for single-team projects. Fails on: multi-team handoffs (no role-based access transfer), regulated industries (no compliance artifact handoff), enterprise customers (no SLA documentation), on-premise deployments (no air-gapped runbook variants), and support team transitions (no support enablement). |
| Infrastructure | D+ | Has doc-updater agent. Has /update-docs and /update-codemaps commands. But: no /readiness-check command, no handoff artifact naming convention, no phase completion verification. |
| **Overall** | **D** | Phase 6 produces documentation but does not perform operational transfer. The gap between "writing docs" and "transferring a live system to a new team" is the core deficiency. |

---

## Phase 7: Maintenance

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | D | 6 skills (continuous_learning, dependency_management, documentation_standards, sop_standards, ssot_update, wi_standards). Missing: incident response, SLO/SLA management, security maintenance, capacity planning, operational readiness gate (Phase 7 intake). The phase covers process documentation but not operational practice. |
| Depth | C+ | dependency_management is thorough for npm but npm-only (no Python, Docker, Terraform). documentation_standards and sop_standards provide good templates. continuous_learning captures patterns. But: all skills are documentation/process focused, none are operational execution skills. |
| Handoffs | D- | No Phase 6 to Phase 7 intake gate. No Phase 7 to Phase 0 loop-back mechanism. The maintenance lifecycle is linear (things decay) rather than cyclical (improvement feeds back to context). |
| Industry Alignment | F | No SRE practices (SLOs, error budgets, toil reduction). No DORA metrics tracking. No incident response framework (ITIL, PagerDuty model). No capacity planning (TOGAF operational). No change management for production changes. ISO 27001 operational controls not addressed. This is the phase with the worst industry alignment. |
| Failure Resilience | D | Works for simple documentation maintenance. Fails on: production incidents (no incident response), performance degradation (no capacity monitoring), security patches (no CVE response cadence), compliance drift (no audit cycle), and non-npm ecosystems (dependency_management is npm-only). |
| Infrastructure | D | refactor-cleaner agent shared from Phase 3. No dedicated commands. 7-maintenance workflow exists but is basic. No /incident, /slo-status, /capacity-review, or /security-patch commands. |
| **Overall** | **D** | Phase 7 is a documentation maintenance phase pretending to be an operational excellence phase. Without incident response, SLO management, security maintenance, and capacity planning, it cannot sustain a production system. |

---

## Toolkit

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | C- | 10 skills covering AGE, AI orchestration, CEO-brain, content creation/waterfall, cost-aware LLM, iterative retrieval, personal brand, strategic compact, video research. Missing: skill registry, AGE-to-skill pipeline, AI security hardening, delivery metrics, phase integration guide, skill lifecycle manager. The toolkit cannot manage itself. |
| Depth | C- | Most skills are surface-level. age describes the loop protocol but not implementation steps. ceo-brain describes 9 "brains" but has no debate log format or decision record template. cost_aware_llm_pipeline covers cost tracking but lacks multi-provider support and cross-session budgets. Only iterative_retrieval and content_waterfall have adequate depth. |
| Handoffs | D | No defined integration points between toolkit skills and phase skills. No "which toolkit skill activates at which phase event" reference. The toolkit is isolated from the lifecycle it's supposed to support. |
| Industry Alignment | C | cost_aware_llm_pipeline aligns with FinOps for AI. iterative_retrieval aligns with RAG best practices. But: no DORA metrics capability, no OWASP AI Security guidelines (prompt injection, model poisoning), no AI compliance frameworks (EU AI Act). |
| Failure Resilience | D | Skills assume interactive, single-user sessions. Fail on: batch/automated use, multi-session continuity, non-interactive contexts (CI/CD), and scenarios where AI provider is unavailable or over-budget. |
| Infrastructure | C | Has /learn, /evolve, /skill-create, /orchestrate commands. But: /orchestrate only covers 4 intra-Phase-3 patterns, no cross-phase orchestration. No skill registry commands. No metrics/reporting commands. |
| **Overall** | **C-** | The Toolkit has useful individual skills but lacks the meta-infrastructure to manage itself (skill registry, lifecycle management) and has no integration protocol with the phases it serves. |

---

## Cross-Cutting Infrastructure (TX)

| Dimension | Grade | Rationale |
|-----------|-------|-----------|
| Coverage | F | No cross-phase skills exist. Compliance, observability maturity, feature flag lifecycle, progressive rollout, i18n, multi-tenancy, capacity planning, and DORA metrics all have zero dedicated cross-phase coverage. Every cross-cutting concern is either absent or fragmented across phases. |
| Depth | F | There is nothing to evaluate for depth -- no cross-phase skills or infrastructure exist. |
| Handoffs | F | Every single phase transition (10 total) is informal. No machine-checkable gate contracts. No phase artifact bill-of-materials. No cross-reference ensuring Phase N outputs are consumed by Phase N+1. The framework's lifecycle is nominal, not enforced. |
| Industry Alignment | F | DORA: 0% coverage. OWASP SAMM: ~10-15% overall. SRE: ~5% (basic observability only). ISO 27001: ~8-10% of technological controls, 0% of organizational/people controls. SOC2: No audit trail, no change management. The framework claims comprehensive coverage but achieves minimal industry standard compliance. |
| Failure Resilience | F | The framework works for a solo developer building a single NestJS/React app. It breaks for: teams >5 people, multi-repo systems, non-JS stacks (workflows hardcode npm), regulated industries, international markets, and enterprise customers requiring compliance evidence. |
| Infrastructure | F | 13 agents but 8 serve Phase 3/4 only. 32 commands but 0 for operational phases. 21 workflows but no GA-release, rollback, incident-response, or compliance-review workflows. No persistent project state. No rules directory (referenced but absent). No hooks directory (referenced but absent). |
| **Overall** | **F** | Cross-cutting infrastructure is the framework's most critical weakness. The absence of phase gate contracts, persistent project state, compliance program, and cross-phase concern management means the framework is structurally a collection of disconnected tools rather than a unified lifecycle. |

---

## Framework-Wide Summary

| Phase | Coverage | Depth | Handoffs | Industry | Resilience | Infrastructure | Overall |
|-------|----------|-------|----------|----------|------------|----------------|---------|
| T0 Context | C | B | D | C- | C | C+ | **C+** |
| T1 Brainstorm | C- | B- | D- | C- | C | D | **C** |
| T2 Design | D | B | F | D- | D | C | **D** |
| T3 Build | B+ | A- | C | B- | B- | A- | **B+** |
| T4 Secure | C+ | B | D+ | C- | C | B+ | **C+** |
| T5 Ship | C | B- | D | C- | C- | D | **C** |
| T55 Alpha | D- | C+ | D | D | D | F | **D-** |
| T575 Beta | D+ | C | F | D | C- | F | **D+** |
| T6 Handoff | D | B- | D- | C- | C | D+ | **D** |
| T7 Maintenance | D | C+ | D- | F | D | D | **D** |
| TK Toolkit | C- | C- | D | C | D | C | **C-** |
| TX Cross-cutting | F | F | F | F | F | F | **F** |

---

## Framework-Wide Grade: **C-**

### Grade Justification

The AI Dev Workflow Framework earns a C- because it contains one genuinely excellent phase (Build, B+), two adequate phases (Context and Secure, both C+), and nine phases graded D or below. The quality floor (Phase 3 Build with 50+ deep skills) demonstrates the team's capability -- the problem is not skill quality but coverage distribution. The framework invested 3-5x more effort in the Build phase than in Design, Ship, Alpha, Beta, Handoff, and Maintenance combined.

The single most impactful improvement would be implementing phase gate contracts (TX-Loop3, P0). This one piece of infrastructure would transform the framework from a collection of 138 disconnected skills into a gated lifecycle where each phase's outputs are formally consumed by the next. Until this exists, the framework's lifecycle claims are aspirational rather than operational.

### Path from C- to B+

To reach B+ overall (every phase at C+ or above), the framework needs:
1. **Phase 2 Design**: +8 skills (ADRs, threat model, NFRs, API contracts, privacy, C4, intake/handoff gates)
2. **Phase 5.5 Alpha**: +4 skills (program management, exit criteria, telemetry, incident comms)
3. **Phase 5.75 Beta**: +5 skills (graduation criteria, GA migration, billing, load testing, consent)
4. **Phase 6 Handoff**: +4 skills (knowledge audit, access handoff, support enablement, readiness review)
5. **Phase 7 Maintenance**: +4 skills (incident response, SLO management, security maintenance, capacity planning)
6. **Cross-cutting**: Phase gate contracts, compliance program, observability maturity model, persistent project state

Estimated effort: 35-45 developer-days of skill authoring. No code. No infrastructure beyond SKILL.md files, a few agent definitions, and a handful of commands. The framework's architecture supports this growth -- the skill/agent/command/workflow system is well-designed and extensible. The gap is content, not architecture.
