---
name: NFR Specification
description: Produces measurable Non-Functional Requirements across 7 dimensions with SLO targets and "Not Applicable" justification
---

# NFR Specification Skill

**Purpose**: Produces a rigorous Non-Functional Requirements document covering seven quality dimensions with measurable targets. Every NFR is either a concrete SLO with a number or explicitly marked "Not Applicable" with a documented reason -- eliminating ambiguous quality expectations before build begins.

## TRIGGER COMMANDS

```text
"Define NFRs for [system]"
"Specify performance requirements"
"Set SLO targets"
```

## When to Use
- After design intake is approved and before implementation begins
- When the PRD says "must be fast" or "highly available" without numbers
- Before infrastructure sizing or cloud cost modeling
- When defining SLAs for external consumers

---

## PROCESS

### Step 1: Gather Context

Collect inputs that inform NFR targets:
- User count projections (from market sizing or PRD)
- Business criticality tier (revenue-generating, internal tool, hobby project)
- Compliance requirements (from Phase 0 compliance-context if available)
- Existing baselines (from Phase 0 codebase health audit if available)

### Step 2: Complete the 7-Dimension NFR Template

For each dimension, specify measurable targets or mark N/A with justification.

```markdown
# Non-Functional Requirements
**System**: [name]
**Date**: YYYY-MM-DD
**Business Tier**: [Critical | Standard | Internal | Experimental]

---

## 1. Performance

| Metric | Target | Measurement Method |
|--------|--------|--------------------|
| API Latency (p50) | [X]ms | Application APM |
| API Latency (p95) | [X]ms | Application APM |
| API Latency (p99) | [X]ms | Application APM |
| Throughput | [X] req/s sustained | Load test |
| LCP (Largest Contentful Paint) | < 2.5s | Lighthouse CI |
| FID (First Input Delay) | < 100ms | Web Vitals |
| CLS (Cumulative Layout Shift) | < 0.1 | Web Vitals |
| DB Query Time (p95) | [X]ms | Query analyzer |

## 2. Reliability

| Metric | Target | Notes |
|--------|--------|-------|
| Availability | [X]% (e.g., 99.9%) | Monthly measurement window |
| RTO | [X] minutes/hours | See rto_rpo_design |
| RPO | [X] minutes/hours | See rto_rpo_design |
| Error Budget | [X]% per month | (100% - availability target) |
| MTTR | < [X] minutes | Mean time to recovery |

## 3. Scalability

| Metric | Target | Strategy |
|--------|--------|----------|
| Concurrent Users | [X] at peak | Horizontal pod autoscaling |
| Data Volume | [X] GB/year growth | Partition strategy at [X] GB |
| Scale-Out Time | < [X] minutes | Auto-scaling trigger threshold |
| Max Tenant Count | [X] | Multi-tenancy ceiling |

## 4. Security

| Requirement | Target | Standard |
|-------------|--------|----------|
| Encryption at Rest | AES-256 | SOC2 / GDPR |
| Encryption in Transit | TLS 1.3 | Industry standard |
| Auth Token Expiry | [X] minutes | OWASP recommendation |
| Password Policy | [describe] | NIST 800-63B |
| Vulnerability SLA | Critical: 24h, High: 7d | SLA policy |

## 5. Maintainability (DORA Metrics)

| Metric | Target | Current Baseline |
|--------|--------|-----------------|
| Deployment Frequency | [X]/week | [current or N/A] |
| Lead Time for Changes | < [X] hours | [current or N/A] |
| Change Failure Rate | < [X]% | [current or N/A] |
| Time to Restore | < [X] minutes | [current or N/A] |

## 6. Consistency (Data/AI)

| Requirement | Choice | Justification |
|-------------|--------|---------------|
| Consistency Model | Strong / Eventual | [why] |
| Read-After-Write | Required / Not Required | [why] |
| AI Model Selection | [model] | [cost, latency, accuracy] |

*Mark "Not Applicable" if no distributed data or AI components.*

## 7. Accessibility

| Requirement | Target | Standard |
|-------------|--------|----------|
| WCAG Level | A / AA / AAA | [regulatory requirement] |
| Screen Reader | Full support | [scope] |
| Keyboard Navigation | All interactive elements | [scope] |

*Mark "Not Applicable" for backend-only or API-only systems.*
```

### Step 3: Validate Consistency

Cross-check NFRs for contradictions:
- High availability (99.99%) + low budget = conflict
- Sub-50ms p99 + eventual consistency = may conflict
- AAA accessibility + aggressive timeline = scope risk

Document any tensions in a "Trade-offs" section.

### Step 4: Link to Downstream Skills

Map each NFR dimension to the Phase that validates it:
- Performance --> Phase 4 (performance testing), Phase 6 (monitoring)
- Reliability --> Phase 5.5 (backup), Phase 6 (DR), Phase 7 (incident response)
- Security --> Phase 4 (security audit), Phase 3 (implementation guards)

---

## OUTPUT

**Path**: `.agent/docs/2-design/nfr-specification.md`

---

## CHECKLIST

- [ ] All 7 dimensions addressed (completed or marked N/A with reason)
- [ ] Every target is a number, not a qualitative statement
- [ ] Business tier documented and consistent with targets
- [ ] Core Web Vitals included if frontend exists
- [ ] DORA metric targets set if CI/CD is in scope
- [ ] Trade-offs section documents any NFR tensions
- [ ] Downstream phase linkage documented
- [ ] Stakeholder sign-off on availability and RTO/RPO targets

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
