---
name: Progressive Rollout Playbook
description: End-to-end traffic migration playbook from dev (0%) through alpha, beta, canary, to GA (100%) with verification gates and rollback procedures at each step.
---

# Progressive Rollout Playbook Skill

**Purpose**: Provide a complete, step-by-step playbook for migrating traffic from zero to full general availability. Each rollout stage defines the access gating method, metrics to verify, hold duration, promotion criteria, and rollback procedure. Spans Phases 5, 5.5, and 5.75.

## TRIGGER COMMANDS

```text
"Progressive rollout plan"
"Traffic migration strategy"
"Alpha to GA rollout"
"Rollout status check"
"Rollback to previous stage"
```

## When to Use
- Planning the release strategy for a new product or major feature
- Moving from alpha to beta or beta to GA
- Implementing canary deployments with automated verification
- Designing a rollback strategy for each rollout stage
- Post-incident review of a rollout failure

---

## PROCESS

### Step 1: Rollout Stage Definitions

Each stage is a discrete step in the traffic migration state machine.

```text
[Dev/Staging] --> [Internal Dogfood] --> [Alpha] --> [Closed Beta]
     0%               <1%               1-5%         5-20%

--> [Open Beta] --> [Canary GA] --> [Progressive GA] --> [Full GA]
      20-50%          1-10%           10-50-100%          100%
```

**Stage 0 -- Dev/Staging (0% external traffic)**
- **Access**: Development team only
- **Gating**: Environment-based (staging environment)
- **Verification**: All tests pass, deployment-verification skill green
- **Duration**: Until feature-complete
- **Promotion Criteria**: Feature acceptance by product owner
- **Rollback**: N/A (not exposed)

**Stage 1 -- Internal Dogfood (<1%)**
- **Access**: Internal team using production
- **Gating**: Feature flag with employee email allowlist
- **Verification**: No P0 bugs in 48 hours of internal use
- **Duration**: 3-5 business days minimum
- **Promotion Criteria**: Internal team sign-off, no showstopper bugs
- **Rollback**: Disable feature flag (instant)

**Stage 2 -- Alpha (1-5%)**
- **Access**: Invited alpha testers
- **Gating**: Feature flag with invite-code allowlist
- **Verification**: Crash-free rate > 99%, core workflow completion > 80%
- **Duration**: 2-4 weeks
- **Promotion Criteria**: Alpha exit criteria met (see alpha_exit_criteria skill)
- **Rollback**: Disable feature flag, notify alpha cohort

**Stage 3 -- Closed Beta (5-20%)**
- **Access**: Approved beta applicants
- **Gating**: Feature flag with percentage rollout + cohort targeting
- **Verification**: Error rate < 0.5%, p95 latency < target, NPS > 30
- **Duration**: 4-8 weeks
- **Promotion Criteria**: Load testing passed, SLOs met for 2+ weeks
- **Rollback**: Reduce flag percentage to 0%, notify beta cohort

**Stage 4 -- Open Beta (20-50%)**
- **Access**: Self-service opt-in
- **Gating**: Feature flag with percentage rollout
- **Verification**: All beta graduation criteria met
- **Duration**: 2-4 weeks
- **Promotion Criteria**: Beta graduation gate passed
- **Rollback**: Reduce percentage, issue status page update

**Stage 5 -- Canary GA (1-10% of GA traffic)**
- **Access**: Random subset of all users
- **Gating**: Traffic splitting (Istio, CloudFront, feature flag)
- **Verification**: Automated canary analysis (error rate, latency, business metrics)
- **Duration**: 1-4 hours per increment
- **Promotion Criteria**: Canary verification passes at each increment
- **Rollback**: Automated rollback on metric breach

**Stage 6 -- Progressive GA (10-50-100%)**
- **Access**: Incrementally all users
- **Gating**: Traffic percentage ramp (10% -> 25% -> 50% -> 100%)
- **Verification**: Same as canary but with broader population
- **Duration**: 15-60 minutes hold at each increment
- **Promotion Criteria**: No metric degradation at each step
- **Rollback**: Shift traffic back to previous version

### Step 2: Metrics Verification at Each Stage

Define what metrics to check and what thresholds to enforce.

**Core Metrics (check at every stage):**

| Metric | Source | Threshold | Breach Action |
|--------|--------|-----------|---------------|
| Error rate (5xx) | APM/Logs | < 0.1% (or baseline + 0.05%) | Auto-rollback at canary, manual at beta |
| Latency p99 | APM | < 2x baseline | Hold promotion, investigate |
| Latency p50 | APM | < 1.5x baseline | Warning, monitor |
| CPU/Memory | Infrastructure | < 80% capacity | Scale or hold |
| Business metric (conversion, activation) | Analytics | No regression > 5% | Hold and investigate |

**Stage-Specific Metrics:**

| Stage | Additional Metrics |
|-------|-------------------|
| Alpha | Crash-free rate, feedback volume, core workflow completion |
| Beta | Retention (D1/D7), NPS score, support ticket volume |
| Canary | Comparison vs control group (statistical significance) |
| GA Ramp | Revenue impact, geographic performance variance |

### Step 3: Rollback Procedures

Each rollback is graded by urgency.

**Immediate Rollback (< 5 minutes):**
- Feature flag disable (Stages 1-4)
- Traffic shift to previous version (Stages 5-6)
- Trigger: P0 bug, data corruption, security vulnerability

**Planned Rollback (< 1 hour):**
- Percentage reduction to last known-good stage
- Trigger: Metric degradation, elevated error rates

**Rollback Communication Template:**

```markdown
## Rollback Notice -- [Feature/Service]
- **Stage**: [Current] -> [Rolling back to]
- **Reason**: [Brief description]
- **Impact**: [User-facing impact]
- **ETA to Resolution**: [Estimate]
- **Status Page**: [URL]
```

### Step 4: Rollout State Tracking

Maintain a rollout state document for each release.

```json
{
  "feature": "feature-name",
  "current_stage": "closed-beta",
  "stage_history": [
    { "stage": "internal-dogfood", "entered": "2026-01-15", "exited": "2026-01-20", "status": "passed" },
    { "stage": "alpha", "entered": "2026-01-21", "exited": "2026-02-04", "status": "passed" },
    { "stage": "closed-beta", "entered": "2026-02-05", "exited": null, "status": "in-progress" }
  ],
  "rollback_count": 0,
  "next_promotion_criteria": "Beta graduation gate",
  "blocking_issues": []
}
```

---

## CHECKLIST

- [ ] Rollout stages defined with gating method for each
- [ ] Metrics and thresholds documented for each stage
- [ ] Rollback procedure tested for each stage
- [ ] Feature flag infrastructure supports percentage rollout
- [ ] Canary verification automation configured
- [ ] Rollout state document created and maintained
- [ ] Communication templates prepared for rollback scenarios
- [ ] On-call team briefed on rollout schedule and rollback triggers
- [ ] Post-rollout retrospective scheduled

---

*Skill Version: 1.0 | Cross-Phase: 5, 5.5, 5.75 | Priority: P0*
