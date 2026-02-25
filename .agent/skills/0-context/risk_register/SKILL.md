---
name: Risk Register
description: Aggregate and score all project risks into a prioritized risk register with heat map
---

# Risk Register Skill

**Purpose**: Consolidate risks discovered across all Phase 0 skills into a single scored risk register. Each risk is rated on Likelihood, Impact, and Velocity, assigned a category and owner, and tracked with mitigation status. The output -- a Risk Heat Map and Top 5 Priority Risks list -- becomes the primary input to Phase 1 prioritization decisions.

## TRIGGER COMMANDS

```text
"Consolidate project risks"
"Create risk register"
"What could kill this project"
```

## When to Use
- After completing most Phase 0 skills (especially `compliance_context` and `codebase_health_audit`)
- When you need a single view of all known project risks before entering Phase 1
- At any point during the project when new risks emerge and need to be tracked
- During `phase_exit_summary` to produce the final risk assessment

---

## PROCESS

### Step 1: Collect Risks from Phase 0 Outputs

Pull risks from every completed Phase 0 skill:

| Source Skill | Typical Risk Types |
|-------------|-------------------|
| `codebase_health_audit` | CVEs, code quality, test coverage gaps |
| `compliance_context` | Regulatory non-compliance, missing consent |
| `infrastructure_audit` | Single points of failure, scaling limits |
| `stakeholder_map` | Budget constraints, key-person dependencies |
| `tech_debt_assessment` | Upgrade blockers, deprecated dependencies |
| `supply_chain_audit` | Dependency confusion, unsigned packages |
| `incident_history_review` | Recurring failure patterns |

### Step 2: Categorize Each Risk

Assign each risk to one of six categories:

| Category | Examples |
|----------|---------|
| **Technical** | Outdated framework, no test coverage, scaling bottleneck |
| **Security** | CVEs, missing auth, injection vectors |
| **Compliance** | GDPR gaps, missing audit trail, no DPO |
| **Operational** | No monitoring, manual deployments, no runbooks |
| **Business** | Budget overrun, missed deadline, market shift |
| **Team** | Key-person dependency, skill gaps, burnout |

### Step 3: Score Each Risk (L x I x V)

Rate each dimension on a 1-5 scale:

**Likelihood** (L): How probable is this risk materializing?
- 1 = Rare, 2 = Unlikely, 3 = Possible, 4 = Likely, 5 = Almost Certain

**Impact** (I): How severe if it happens?
- 1 = Negligible, 2 = Minor, 3 = Moderate, 4 = Major, 5 = Critical

**Velocity** (V): How fast does it hit after triggering?
- 1 = Months, 2 = Weeks, 3 = Days, 4 = Hours, 5 = Immediate

**Risk Score** = L x I x V (Range: 1-125)

| Score Range | Severity |
|------------|----------|
| 1-15 | Low |
| 16-45 | Medium |
| 46-75 | High |
| 76-125 | Critical |

### Step 4: Build the Risk Register

```markdown
## Risk Register

| ID | Risk Description | Category | L | I | V | Score | Severity | Owner | Mitigation | Status |
|----|-----------------|----------|---|---|---|-------|----------|-------|------------|--------|
| R1 | PostgreSQL 12 EOL in 3 months | Technical | 5 | 4 | 2 | 40 | Medium | Eng Lead | Upgrade to PG 16 | Planned |
| R2 | No GDPR DSAR process | Compliance | 4 | 5 | 3 | 60 | High | Legal | Build DSAR endpoint | Open |
| R3 | Single deployment engineer | Team | 3 | 4 | 5 | 60 | High | Eng Mgr | Cross-train 2nd person | Open |
| R4 | 12 critical CVEs in deps | Security | 4 | 5 | 4 | 80 | Critical | Eng Lead | Patch sprint | In Progress |
| R5 | No load testing done | Operational | 3 | 3 | 3 | 27 | Medium | QA Lead | Run k6 suite | Open |
```

### Step 5: Generate Risk Heat Map

Create a visual heat map (Likelihood vs Impact):

```
          Impact -->
          1    2    3    4    5
      +----+----+----+----+----+
  5   |    |    |    |    | R4 |  Likelihood
  4   |    |    |    | R1 | R2 |     |
  3   |    |    | R5 | R3 |    |     v
  2   |    |    |    |    |    |
  1   |    |    |    |    |    |
      +----+----+----+----+----+
```

### Step 6: Extract Top 5 Priority Risks

Sort by score descending. For each top risk, provide:

```markdown
## Top 5 Priority Risks

### 1. R4: Critical CVEs in Dependencies (Score: 80 - CRITICAL)
- **What**: 12 critical CVEs across npm dependencies
- **When**: Exploitable now
- **Mitigation**: Dedicated patch sprint, update lockfile, verify no breaking changes
- **Decision Needed**: Allocate 1 sprint to patching before feature work?

### 2. R2: No GDPR DSAR Process (Score: 60 - HIGH)
...
```

### Step 7: Save and Distribute

Save the complete register to:

```
.agent/docs/0-context/risk-register.md
```

This document is a required input for `phase_exit_summary` and Phase 1 `prioritization_frameworks`.

---

## CHECKLIST

- [ ] Risks collected from all completed Phase 0 skills
- [ ] Each risk categorized (Technical/Security/Compliance/Operational/Business/Team)
- [ ] Each risk scored on Likelihood, Impact, and Velocity
- [ ] Risk register table populated with all identified risks
- [ ] Risk heat map generated
- [ ] Top 5 priority risks extracted with mitigation plans
- [ ] Owner assigned to every High and Critical risk
- [ ] Register saved to `.agent/docs/0-context/risk-register.md`

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
