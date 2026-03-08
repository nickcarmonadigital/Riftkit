# Phase Gate Contracts -- Entry & Exit Criteria

This document defines machine-checkable entry and exit criteria for all 10 phase transitions in riftkit. Each gate specifies required artifacts, quality bars, and approval requirements. Gate rigor is adjustable by team scale (see governance_framework skill).

**Usage**: Reference this document when running `/gate-check [from-phase] [to-phase]`. The phase_gate_contracts skill provides the process for evaluating these gates.

---

## G0-1: Context -> Brainstorm

**Purpose**: Ensure sufficient project understanding before ideation begins.

### Entry Criteria for Phase 1

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Codebase health audit completed (or greenfield declared) | Advisory | Required | Required | `codebase-health-report.md` |
| 2 | Tech stack documented | Required | Required | Required | SSoT or `tech-stack.md` |
| 3 | Stakeholder map completed | Advisory | Required | Required | `stakeholder-map.md` |
| 4 | Compliance context identified (if regulated) | Advisory | Required | Required | `compliance-manifest.json` |
| 5 | Risk register initialized | Advisory | Advisory | Required | `risk-register.md` |
| 6 | Phase 0 exit summary produced | Advisory | Required | Required | `phase-0-exit-brief.md` |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Context documentation completeness | > 50% | > 75% | > 90% |
| Known risks documented | >= 3 | >= 5 | >= 10 |

---

## G1-2: Brainstorm -> Design

**Purpose**: Validate that the product concept is viable before investing in design.

### Entry Criteria for Phase 2

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Problem statement defined | Required | Required | Required | `client-discovery.md` or PRD |
| 2 | User research completed (personas, journeys) | Advisory | Required | Required | `user-research.md` |
| 3 | Competitive analysis done | Advisory | Required | Required | `competitive-analysis.md` |
| 4 | Prioritization framework applied | Advisory | Required | Required | `prioritization.md` |
| 5 | Success metrics defined | Required | Required | Required | `product-metrics.md` |
| 6 | Go/No-Go gate passed | Advisory | Required | Required | `go-no-go-decision.md` |
| 7 | PRD produced | Advisory | Required | Required | `prd.md` |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| User stories with acceptance criteria | >= 3 | >= 10 | >= 20 |
| Assumptions tested | >= 1 | >= 3 | >= 5 |
| Business case validated | Advisory | Required | Required |

---

## G2-3: Design -> Build

**Purpose**: Ensure architecture and design decisions are complete before implementation.

### Entry Criteria for Phase 3

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Architecture defined (ARA or equivalent) | Required | Required | Required | `architecture.md` or ADRs |
| 2 | Database schema designed | Required | Required | Required | Schema file or `schema-design.md` |
| 3 | API contracts defined | Advisory | Required | Required | OpenAPI spec or `api-design.md` |
| 4 | Security threat model completed | Advisory | Required | Required | `threat-model.md` |
| 5 | NFRs specified (performance, reliability) | Advisory | Required | Required | `nfr-specification.md` |
| 6 | ADRs for key decisions | Advisory | Required | Required | `docs/adr/` directory |
| 7 | Design handoff package complete | Advisory | Required | Required | `design-handoff.md` |
| 8 | Data privacy design (if PII) | Advisory | Required | Required | `data-privacy-design.md` |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| ADRs for technology choices | >= 1 | >= 3 | >= 5 |
| Threat model coverage | N/A | STRIDE on critical paths | Full STRIDE on all boundaries |
| NFR dimensions specified | >= 2 | >= 4 | >= 6 |

---

## G3-4: Build -> Secure

**Purpose**: Verify the implementation is functionally complete and testable before security hardening.

### Entry Criteria for Phase 4

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Core features implemented and functional | Required | Required | Required | Passing integration tests |
| 2 | Unit test coverage meets threshold | Required | Required | Required | Coverage report |
| 3 | Linting and formatting passing | Required | Required | Required | CI green |
| 4 | Database migrations tested | Required | Required | Required | Migration scripts |
| 5 | API contract conformance verified | Advisory | Required | Required | Contract test results |
| 6 | Code review completed | Advisory | Required | Required | PR approvals |
| 7 | Feature flags configured for incomplete features | Advisory | Advisory | Required | Flag configuration |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Unit test coverage | >= 60% | >= 70% | >= 80% |
| Integration test coverage | >= 40% | >= 50% | >= 60% |
| Lint errors | 0 | 0 | 0 |
| Open P0 bugs | 0 | 0 | 0 |

---

## G4-5: Secure -> Ship

**Purpose**: Confirm security posture is acceptable before production deployment.

### Entry Criteria for Phase 5

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Security audit completed | Required | Required | Required | `security-audit-report.md` |
| 2 | SAST scan clean (no critical/high) | Required | Required | Required | SARIF report |
| 3 | Dependency audit clean (no critical CVEs) | Required | Required | Required | `npm audit` / SCA report |
| 4 | Secrets scanning passing | Required | Required | Required | Pre-commit hook evidence |
| 5 | Container security scan (if applicable) | Advisory | Required | Required | Trivy report |
| 6 | Penetration test (if applicable) | N/A | Advisory | Required | Pen test report |
| 7 | Compliance testing passed (if regulated) | Advisory | Required | Required | Compliance evidence package |
| 8 | E2E tests passing | Required | Required | Required | Test results |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Critical/High SAST findings | 0 | 0 | 0 |
| Critical dependency CVEs | 0 | 0 | 0 |
| Security audit score | Pass | Pass | Pass with no waivers |
| E2E test pass rate | 100% | 100% | 100% |

---

## G5-55: Ship -> Alpha

**Purpose**: Verify production deployment infrastructure before exposing to alpha testers.

### Entry Criteria for Phase 5.5

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | CI/CD pipeline deploying to production | Required | Required | Required | Pipeline configuration |
| 2 | Deployment verification passing | Required | Required | Required | Post-deploy check report |
| 3 | Health checks operational | Required | Required | Required | `/health` endpoint |
| 4 | Error tracking configured | Required | Required | Required | Sentry/equivalent setup |
| 5 | Logging and monitoring operational (L1+) | Required | Required | Required | Dashboard evidence |
| 6 | Rollback procedure tested | Advisory | Required | Required | Rollback runbook |
| 7 | Alpha access gating implemented | Required | Required | Required | Feature flag / allowlist |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Deployment success rate | 100% (last 3) | 100% (last 5) | 100% (last 10) |
| Health check uptime (staging) | > 99% over 48h | > 99.5% over 72h | > 99.9% over 1 week |
| Observability level | L1 | L1+ | L2 |

---

## G55-575: Alpha -> Beta

**Purpose**: Validate product stability from alpha feedback before broader beta exposure.

### Entry Criteria for Phase 5.75

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Alpha exit criteria met | Required | Required | Required | Alpha exit report |
| 2 | P0 bugs from alpha resolved | Required | Required | Required | Issue tracker evidence |
| 3 | Core workflow completion rate acceptable | Required | Required | Required | Analytics data |
| 4 | Performance baseline established | Advisory | Required | Required | Performance report |
| 5 | Crash-free session rate acceptable | Required | Required | Required | Error tracking data |
| 6 | Beta access gating implemented | Required | Required | Required | Feature flag config |
| 7 | Beta communication channels established | Advisory | Required | Required | Channel configuration |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Crash-free session rate | > 98% | > 99% | > 99.5% |
| Core workflow completion | > 70% | > 80% | > 85% |
| Open P0 bugs | 0 | 0 | 0 |
| Alpha tester satisfaction | N/A | NPS > 0 | NPS > 20 |

---

## G575-6: Beta -> Handoff

**Purpose**: Confirm product is GA-ready before operational handoff.

### Entry Criteria for Phase 6

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Beta graduation criteria met | Required | Required | Required | GA readiness report |
| 2 | Load testing passed | Advisory | Required | Required | k6/load test results |
| 3 | SLOs defined and measurable | Advisory | Required | Required | SLO document |
| 4 | Billing/metering verified (if applicable) | Required | Required | Required | Billing test results |
| 5 | Feature flag cleanup completed | Required | Required | Required | Flag audit |
| 6 | Documentation complete (user-facing) | Advisory | Required | Required | Docs site/README |
| 7 | Pricing migration plan (if beta-free to paid) | Advisory | Required | Required | Migration plan |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Error rate | < 0.5% | < 0.1% | < 0.05% |
| p95 API latency | < 500ms | < 300ms | < 200ms |
| 7-day retention | > 30% | > 40% | > 50% |
| Open P0/P1 bugs | 0 | 0 | 0 |
| Load test capacity | 2x expected | 3x expected | 5x expected |

---

## G6-7: Handoff -> Maintenance

**Purpose**: Ensure operational readiness for ongoing production support.

### Entry Criteria for Phase 7

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Operational runbooks complete | Advisory | Required | Required | Runbook directory |
| 2 | On-call rotation established | N/A | Required | Required | PagerDuty/rotation config |
| 3 | Incident response plan documented | Advisory | Required | Required | `incident-response.md` |
| 4 | Monitoring dashboards operational (L2+) | Advisory | Required | Required | Dashboard evidence |
| 5 | Backup and recovery tested | Advisory | Required | Required | DR test report |
| 6 | Knowledge transfer completed | N/A | Required | Required | Handoff meeting notes |
| 7 | Compliance evidence collection automated | N/A | Advisory | Required | Automation config |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| Runbook coverage (top alerts) | >= 3 | >= 8 | >= 15 |
| Observability level | L1 | L2 | L3 |
| On-call rotation size | N/A | >= 3 people | >= 4 people |
| DR test pass | N/A | Annual | Quarterly |

---

## G7-loop: Maintenance -> Maintenance (Periodic Review)

**Purpose**: Prevent operational drift through periodic re-assessment.

### Review Criteria (run quarterly or after significant changes)

| # | Criterion | Solo | SMB | Enterprise | Artifact |
|---|-----------|------|-----|-----------|----------|
| 1 | Dependency health re-audited | Required | Required | Required | SCA report |
| 2 | Security scan re-run | Required | Required | Required | SAST/DAST results |
| 3 | SLO compliance reviewed | Advisory | Required | Required | SLO report |
| 4 | DORA metrics reviewed | Advisory | Required | Required | DORA report |
| 5 | Toil audit updated | Advisory | Advisory | Required | Toil report |
| 6 | Compliance drift check (if regulated) | Advisory | Required | Required | Compliance drift report |
| 7 | Incident postmortem actions completed | Advisory | Required | Required | Action item tracker |
| 8 | Capacity planning updated | Advisory | Advisory | Required | Capacity projection |

### Quality Bars

| Metric | Solo | SMB | Enterprise |
|--------|------|-----|-----------|
| SLO compliance | N/A | >= 99% of target | >= 99.5% of target |
| Error budget remaining | N/A | > 25% | > 30% |
| Postmortem action completion | N/A | > 80% | > 95% |
| Review cadence | Semi-annual | Quarterly | Monthly |

---

## Gate Decision Status Values

| Status | Meaning |
|--------|---------|
| **APPROVED** | All criteria met. Phase transition proceeds. |
| **CONDITIONAL** | Transition proceeds with time-boxed conditions that must be resolved. |
| **BLOCKED** | Critical criteria not met. Transition does not proceed until resolved. |
| **WAIVED** | Individual criterion skipped with documented rationale and approver. |

---

*Document Version: 1.0 | Last Updated: 2026-02-25 | Maintained by: phase_gate_contracts skill*
