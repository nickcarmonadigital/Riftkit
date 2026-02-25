---
name: Alpha Exit Criteria
description: Measurable exit gates for alpha graduation to beta with scoring rubric and exit report
---

# Alpha Exit Criteria Skill

**Purpose**: Define and evaluate measurable criteria that must be met before an alpha product graduates to beta. This prevents premature beta launches by requiring quantitative thresholds for stability, user engagement, performance, and data integrity. The skill produces an Alpha Exit Report with a GO/NO-GO/CONDITIONAL-GO decision.

## TRIGGER COMMANDS

```text
"Alpha exit criteria"
"Ready for beta?"
"Alpha graduation checklist"
"Evaluate alpha readiness"
"Using alpha_exit_criteria skill: evaluate [product]"
```

## When to Use
- When the alpha program has been running for the planned duration
- When the team believes the product is ready to expand beyond alpha testers
- When stakeholders ask "when will we be in beta?"
- As a recurring weekly evaluation during the alpha program

---

## PROCESS

### Step 1: Define Exit Gate Categories

Each gate has a threshold that must be met. Gates are scored as PASS, FAIL, or WAIVED (with documented justification).

```markdown
## Alpha Exit Gates

### Gate 1: Stability
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| Crash-free session rate | >= 95% | ___% | PASS/FAIL |
| P0 bugs open | 0 | ___ | PASS/FAIL |
| P1 bugs resolved | >= 80% | ___% | PASS/FAIL |
| Uptime (last 14 days) | >= 95% | ___% | PASS/FAIL |

### Gate 2: Core Workflow Completion
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| Testers completing primary workflow | >= 80% | ___% | PASS/FAIL |
| Testers completing secondary workflow | >= 50% | ___% | PASS/FAIL |
| Average workflow completion time | <= 2x design target | ___x | PASS/FAIL |

### Gate 3: Performance Baseline
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| API p95 latency | <= 500ms | ___ms | PASS/FAIL |
| API p99 latency | <= 1000ms | ___ms | PASS/FAIL |
| Page load time (LCP) | <= 2.5s | ___s | PASS/FAIL |
| Error rate (5xx) | <= 1% | ___% | PASS/FAIL |

### Gate 4: Data Integrity
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| Data loss incidents | 0 | ___ | PASS/FAIL |
| Successful backup/restore test | Yes | ___ | PASS/FAIL |
| Migration rollback tested | Yes | ___ | PASS/FAIL |

### Gate 5: Tester Diversity
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| Active testers (weekly) | >= 60% of cohort | ___% | PASS/FAIL |
| Testers from different use cases | >= 3 distinct | ___ | PASS/FAIL |
| Feedback submissions | >= 2/tester/week avg | ___ | PASS/FAIL |

### Gate 6: Operational Readiness
| Metric | Threshold | Current | Status |
|--------|-----------|---------|--------|
| Monitoring and alerting active | Yes | ___ | PASS/FAIL |
| On-call rotation established | Yes | ___ | PASS/FAIL |
| Runbook for top 5 failure modes | Yes | ___ | PASS/FAIL |
| Incident response tested | Yes | ___ | PASS/FAIL |
```

### Step 2: Scoring Rubric

```text
DECISION MATRIX

  All gates PASS                     --> GO (proceed to beta)
  1-2 gates FAIL with mitigation     --> CONDITIONAL-GO (proceed with conditions)
  3+ gates FAIL                      --> NO-GO (continue alpha, re-evaluate in 2 weeks)
  Any Gate 1 or Gate 4 FAIL          --> NO-GO (stability and data are non-negotiable)

WAIVER RULES
  - A gate may be WAIVED only with written justification and stakeholder sign-off
  - Gate 1 (Stability) and Gate 4 (Data Integrity) cannot be waived
  - Maximum 2 gates may be waived per evaluation
```

### Step 3: Run the Evaluation

Gather metrics from your monitoring and feedback systems:

```typescript
// alpha-exit-evaluator.ts
interface GateResult {
  gate: string;
  metric: string;
  threshold: string;
  current: string | number;
  status: 'PASS' | 'FAIL' | 'WAIVED';
  notes?: string;
}

interface ExitEvaluation {
  evaluationDate: string;
  evaluator: string;
  gates: GateResult[];
  decision: 'GO' | 'NO-GO' | 'CONDITIONAL-GO';
  conditions?: string[];
  nextEvaluationDate?: string;
}

function evaluateAlphaExit(gates: GateResult[]): ExitEvaluation['decision'] {
  const failures = gates.filter(g => g.status === 'FAIL');
  const stabilityFail = failures.some(g => g.gate === 'Stability');
  const dataFail = failures.some(g => g.gate === 'Data Integrity');

  if (stabilityFail || dataFail) return 'NO-GO';
  if (failures.length === 0) return 'GO';
  if (failures.length <= 2) return 'CONDITIONAL-GO';
  return 'NO-GO';
}
```

### Step 4: Generate Alpha Exit Report

```markdown
## Alpha Exit Report Template

### Header
- **Product**: [product name]
- **Alpha Start**: YYYY-MM-DD
- **Evaluation Date**: YYYY-MM-DD
- **Evaluator**: [name/role]
- **Alpha Duration**: ___ weeks
- **Cohort Size**: ___ testers (___ active)

### Gate Results Summary
| Gate | Status | Notes |
|------|--------|-------|
| 1. Stability | PASS/FAIL/WAIVED | |
| 2. Core Workflow | PASS/FAIL/WAIVED | |
| 3. Performance | PASS/FAIL/WAIVED | |
| 4. Data Integrity | PASS/FAIL/WAIVED | |
| 5. Tester Diversity | PASS/FAIL/WAIVED | |
| 6. Operational Readiness | PASS/FAIL/WAIVED | |

### Decision: [GO / NO-GO / CONDITIONAL-GO]

### Conditions (if CONDITIONAL-GO)
1. [Condition 1 with deadline]
2. [Condition 2 with deadline]

### Unresolved Alpha Feedback (carried to beta backlog)
- [Item 1]
- [Item 2]

### Recommendations for Beta Phase
- [Recommendation 1]
- [Recommendation 2]

### Sign-off
- [ ] Product Owner: _____________ Date: ___
- [ ] Engineering Lead: _____________ Date: ___
- [ ] QA Lead: _____________ Date: ___
```

### Step 5: Post-Decision Actions

| Decision | Actions |
|----------|---------|
| GO | Begin beta preparation, alpha closure checklist, expand access |
| CONDITIONAL-GO | Set condition deadlines, begin beta prep in parallel, re-evaluate conditions weekly |
| NO-GO | Identify top 3 blockers, create sprint plan to address, schedule re-evaluation in 2 weeks |

---

## CHECKLIST

- [ ] All 6 exit gate categories defined with specific thresholds
- [ ] Metrics collection automated (not manually gathered)
- [ ] Scoring rubric documented and agreed upon by stakeholders
- [ ] Gate 1 (Stability) and Gate 4 (Data Integrity) marked as non-waivable
- [ ] Alpha Exit Report template prepared
- [ ] Evaluation cadence established (weekly during final alpha weeks)
- [ ] Stakeholder sign-off roles identified
- [ ] CONDITIONAL-GO conditions have specific deadlines
- [ ] NO-GO re-evaluation scheduled within 2 weeks
- [ ] Unresolved alpha feedback logged for beta backlog

---

*Skill Version: 1.0 | Created: February 2026*
