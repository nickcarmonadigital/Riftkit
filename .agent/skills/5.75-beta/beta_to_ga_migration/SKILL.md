---
name: Beta to GA Migration
description: Complete transition procedure from beta to general availability including flag cleanup, billing migration, and launch communications
---

# Beta to GA Migration Skill

**Purpose**: Execute the full transition from beta to general availability in a controlled, reversible sequence. This skill covers feature flag cleanup, billing migration from free-beta to paid-GA, user communication workflows, infrastructure cutover, and monitoring adjustments. A botched GA launch can undo months of goodwork -- this skill ensures nothing is missed.

## TRIGGER COMMANDS

```text
"Migrate beta to GA"
"GA launch procedure"
"Beta cleanup and launch"
"Execute GA cutover"
"Using beta_to_ga_migration skill: launch [project]"
```

## When to Use

- Beta graduation criteria have been met (see `beta_graduation_criteria` skill)
- GA Readiness Report has been signed off
- You are executing the actual transition from beta to GA
- Rolling back a failed GA launch

---

## PROCESS

### Step 1: Pre-Launch Verification (T-7 Days)

Verify all prerequisites before beginning the migration sequence.

```text
PRE-LAUNCH CHECKLIST

Infrastructure:
- [ ] Load test results confirm capacity for projected GA traffic (2-5x beta)
- [ ] CDN configuration updated for GA traffic levels
- [ ] Database connection pool sized for GA load
- [ ] Auto-scaling policies configured and tested
- [ ] SSL certificates valid for 90+ days

Billing:
- [ ] Stripe products and prices created for GA plans
- [ ] Payment webhook handler tested end-to-end
- [ ] Beta-to-paid migration path tested with test accounts
- [ ] Metering reconciliation verified at 100% accuracy
- [ ] Refund and cancellation flows tested

Legal:
- [ ] Terms of Service updated for GA (remove "beta" disclaimers)
- [ ] Privacy policy reflects GA data practices
- [ ] Cookie consent banner reflects GA analytics

Communications:
- [ ] GA announcement email drafted and reviewed
- [ ] In-app notification for beta users prepared
- [ ] Status page updated with GA SLA information
- [ ] Support team briefed on GA changes
```

### Step 2: Feature Flag Cleanup (T-3 Days)

Remove beta-only feature flags systematically. Never remove all flags at once.

**Flag Cleanup Sequence**:

| Order | Flag Category | Action | Verification |
|-------|--------------|--------|-------------|
| 1 | Alpha-only flags | Remove code paths and flag checks | Run full test suite |
| 2 | Beta-gate flags | Switch to GA-open (100% rollout) | Verify in staging |
| 3 | Experiment flags | Conclude experiments, pick winners | Document decisions |
| 4 | Beta pricing flags | Keep until billing migration complete | Verify billing flow |
| 5 | Kill switches | Keep permanently (operational flags) | Verify they still work |

```text
For each flag being removed:
1. Search codebase for all references: grep -r "FLAG_NAME" src/
2. Remove the flag check and dead code path
3. Remove flag from flag store (DB, env, or service)
4. Run tests to confirm no regressions
5. Commit: "cleanup: remove [flag-name] beta feature flag"
```

> Never delete a kill switch or ops flag during GA migration. These are permanent operational controls.

### Step 3: Billing Migration (T-1 Day)

Transition beta users from free access to GA pricing.

**Migration Strategies**:

| Strategy | When to Use | Implementation |
|----------|-------------|---------------|
| **Hard cutover** | All users move to paid on GA date | Set trial end date in Stripe |
| **Grandfather period** | Beta users get free access for 30-90 days | Create beta-specific coupon |
| **Beta discount** | Reward early adopters with permanent discount | Create lifetime discount in Stripe |
| **Freemium conversion** | Free tier continues, premium features gated | Update feature flag targeting |

**Recommended Approach** (grandfather with discount):

```text
1. Create Stripe coupon: "BETA_EARLY_ADOPTER" - 50% off for 6 months
2. For each active beta user:
   a. Create Stripe customer (if not exists)
   b. Apply BETA_EARLY_ADOPTER coupon
   c. Set trial end date to GA date + 30 days
   d. Send migration email with pricing details
3. New GA users get standard pricing (no coupon)
```

### Step 4: GA Launch Execution (T-0)

Execute the cutover in this exact sequence. Each step has a rollback procedure.

| Order | Action | Rollback |
|-------|--------|----------|
| 1 | Enable GA monitoring thresholds | Revert to beta thresholds |
| 2 | Update DNS/CDN for GA traffic | Revert DNS records (TTL must be low) |
| 3 | Activate GA billing (end trials) | Extend trials by 7 days |
| 4 | Remove "Beta" branding from UI | Redeploy previous frontend build |
| 5 | Publish GA announcement email | Send correction email |
| 6 | Update status page with GA SLAs | Revert status page |
| 7 | Enable GA onboarding flow | Switch back to beta onboarding |
| 8 | Open public registration (if gated) | Re-enable registration gate |

**Launch Day Monitoring** (first 24 hours):

```text
Monitor every 30 minutes:
- Error rate (target: < 0.1%, abort if > 0.5%)
- p95 latency (target: < 500ms, investigate if > 800ms)
- Signup rate (compare to projection)
- Payment success rate (target: > 95%)
- Support ticket volume (compare to beta baseline)

Escalation triggers:
- Error rate > 0.5% for 15 minutes --> rollback consideration
- Payment failures > 5% --> pause billing, investigate
- Support ticket spike > 3x baseline --> activate incident comms
```

### Step 5: Post-Launch Verification (T+1 to T+7)

```text
POST-LAUNCH CHECKLIST

Day 1:
- [ ] All monitoring dashboards green
- [ ] Payment processing confirmed working
- [ ] No critical support tickets
- [ ] GA announcement email delivered successfully
- [ ] Public registration working (if applicable)

Day 3:
- [ ] Billing reconciliation matches expected revenue
- [ ] No beta feature flags remaining in codebase
- [ ] User activation rate within expected range
- [ ] Performance metrics stable under GA traffic

Day 7:
- [ ] 7-day retention comparable to beta retention
- [ ] Support ticket volume stabilized
- [ ] All beta-specific infrastructure decommissioned
- [ ] GA Readiness Report marked as COMPLETE
- [ ] Retrospective scheduled for GA launch process
```

---

## CHECKLIST

- [ ] Pre-launch checklist completed (T-7)
- [ ] Feature flag cleanup executed and verified (T-3)
- [ ] Billing migration tested with real test accounts (T-1)
- [ ] GA launch sequence executed in correct order (T-0)
- [ ] Launch day monitoring active with defined escalation triggers
- [ ] Rollback procedures documented and tested for each step
- [ ] Post-launch verification completed at Day 1, 3, and 7
- [ ] Beta infrastructure decommissioned
- [ ] GA launch retrospective conducted

---

*Skill Version: 1.0 | Created: February 2026*
