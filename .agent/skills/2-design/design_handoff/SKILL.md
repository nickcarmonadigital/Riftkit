---
name: Design Handoff
description: Consolidates all Phase 2 outputs into a Design Package with sign-off -- the Phase 2 to Phase 3 gate
---

# Design Handoff Skill

**Purpose**: Acts as the terminal Phase 2 skill that consolidates all design artifacts into a verified Design Package, validates completeness, produces a signed Design Sign-Off document, and defines the locked decisions list that Phase 3 must respect. This is the formal Phase 2 to Phase 3 gate.

## TRIGGER COMMANDS

```text
"Complete design phase"
"Package design artifacts for build"
"Design sign-off"
```

## When to Use
- After all required Phase 2 design skills have been completed
- Before any Phase 3 build work begins
- When a project checkpoint requires formal design approval

---

## PROCESS

### Step 1: Inventory Phase 2 Artifacts

Scan for all expected Phase 2 outputs and record their status:

| Artifact | Source Skill | Required? | Found? |
|----------|-------------|-----------|--------|
| Design Readiness Report | design_intake | Yes | |
| Architecture (ARA) | atomic_reverse_architecture | Yes | |
| ADR Index + Records | architecture_decision_records | Yes | |
| Threat Register | security_threat_modeling | Yes | |
| NFR Specification | nfr_specification | Recommended | |
| API Contract (OpenAPI) | api_contract_design | Recommended | |
| Data Privacy Design | data_privacy_design | Conditional | |
| C4 Diagrams | c4_architecture_diagrams | Recommended | |
| Schema Documentation | schema_standards | Yes | |
| RTO/RPO Requirements | rto_rpo_design | Conditional | |
| Multi-Tenancy Design | multi_tenancy_architecture | Conditional | |
| i18n Architecture | internationalization_design | Conditional | |
| Accessibility Plan | accessibility_design | Conditional | |
| Cost Model | cost_architecture | Optional | |

"Conditional" means required if the project scope includes that concern (e.g., data_privacy_design is required if PII is handled).

### Step 2: Quality Validation

For each found artifact, verify minimum quality:

- **ARA**: Contains component decomposition with at least 2 levels
- **ADRs**: At least 1 ADR exists; all have status != "Proposed" (must be decided)
- **Threat Register**: All DREAD > 7 threats have mitigations assigned
- **NFRs**: Performance targets are numeric, not qualitative
- **API Contracts**: Endpoints have request/response schemas defined
- **Schemas**: All entities have primary keys, types, and validation rules

Flag quality failures as WARNINGS (non-blocking) or ERRORS (blocking).

### Step 3: Build Locked Decisions List

Extract from accepted ADRs the decisions that Phase 3 MUST NOT change without a new ADR:

```markdown
## Locked Decisions (Must Not Change Without ADR)

| Decision | ADR | Rationale Summary |
|----------|-----|-------------------|
| PostgreSQL as primary datastore | ADR-0001 | Team expertise + pgvector |
| JWT auth with refresh tokens | ADR-0002 | Stateless scaling requirement |
| Monorepo with Turborepo | ADR-0005 | Shared types, atomic deploys |
```

### Step 4: Produce Implementation Constraints

Document constraints that Phase 3 must respect, derived from design artifacts:

```markdown
## Implementation Constraints for Phase 3

### From NFRs
- API p95 latency must stay under [X]ms
- Minimum [X]% unit test coverage on services

### From Threat Register
- All user-input endpoints must validate with class-validator
- Ownership checks required on all resource endpoints

### From API Contract
- Response envelope: `{ success: boolean, data: T, error?: string }`
- Versioning via URL path prefix `/api/v1/`

### From Data Privacy
- PII fields must be encrypted at rest
- Retention policy: soft-delete with 90-day hard purge
```

### Step 5: Generate Design Sign-Off Document

```markdown
# Design Sign-Off
**Project**: [name]
**Date**: YYYY-MM-DD
**Phase 2 Duration**: [start] to [end]

## Verdict: APPROVED | BLOCKED

## Artifact Summary
| Artifact | Status | Quality |
|----------|--------|---------|
| ... | Found/Missing | Pass/Warning/Error |

## Locked Decisions
[from Step 3]

## Implementation Constraints
[from Step 4]

## Phase 3 Entry Checklist
- [ ] All BLOCKED items resolved
- [ ] Locked decisions acknowledged by build team
- [ ] Implementation constraints added to project standards
- [ ] Threat mitigations assigned to sprint backlog
- [ ] Design package committed to version control
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/design-sign-off.md`

---

## CHECKLIST

- [ ] All required Phase 2 artifacts inventoried
- [ ] Each artifact validated for minimum quality
- [ ] Locked decisions extracted from accepted ADRs
- [ ] Implementation constraints documented per source
- [ ] Design Sign-Off document generated with verdict
- [ ] Phase 3 entry checklist included
- [ ] BLOCKED items have specific remediation steps
- [ ] Design package committed to version control
- [ ] Stakeholders notified of sign-off status

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P0*
