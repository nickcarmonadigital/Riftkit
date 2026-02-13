---
name: Feature Flags
description: Gradual rollouts, A/B testing, kill switches, and flag management for safe feature releases
---

# Feature Flags Skill

> **PURPOSE**: Release features safely using flags that let you turn functionality on or off without deploying new code.

## When to Use

- Launching a risky feature and want to roll it out gradually
- Running an A/B test to compare two versions
- Needing a kill switch to instantly disable something in production
- Gating features by user role, plan, or region
- Decoupling deployment from release (deploy dark, enable later)

---

## What Is a Feature Flag?

A feature flag is a simple on/off switch in your code that controls whether a feature is visible to users.

```
Without flags:  Deploy code → Feature is live for everyone immediately
With flags:     Deploy code → Feature is hidden → Turn on for 1% → 10% → 100%
```

Think of it like a light switch. The wiring (code) is installed, but the light only turns on when you flip the switch (flag).

---

## Types of Feature Flags

| Type | Purpose | Lifespan | Example |
|------|---------|----------|---------|
| **Release flag** | Gradually roll out a new feature | Days to weeks | "Show new checkout flow" |
| **Experiment flag** | A/B test two variations | Weeks | "Test blue vs green CTA button" |
| **Ops flag** | Control operational behavior | Permanent | "Enable maintenance mode" |
| **Permission flag** | Gate features by plan/role | Permanent | "Show analytics for Pro users only" |

---

## Gradual Rollout Strategy

Never go from 0% to 100%. Use a phased approach.

| Phase | Audience | Duration | What to Watch |
|-------|----------|----------|---------------|
| **Phase 1** | Internal team only | 1-2 days | Does it work at all? |
| **Phase 2** | 1% of users | 2-3 days | Error rates, performance |
| **Phase 3** | 10% of users | 3-5 days | User feedback, metrics |
| **Phase 4** | 50% of users | 3-5 days | Scalability, edge cases |
| **Phase 5** | 100% of users | Permanent | Monitor for 1 week, then remove flag |

### When to Stop a Rollout

Roll back immediately if you see any of these:

- Error rate increases by more than 2x
- Page load time increases by more than 500ms
- User complaints spike in support channels
- Revenue metrics drop (conversion, checkout, etc.)

---

## A/B Testing with Feature Flags

Feature flags make A/B testing simple. Show different experiences to different users, measure which performs better.

### Step-by-Step Process

```
1. HYPOTHESIS
   "Changing the CTA button from blue to green will increase
   click-through rate by 10%."

2. SETUP
   - Create flag: "green-cta-experiment"
   - Variant A (control): Blue button (50% of users)
   - Variant B (test):    Green button (50% of users)

3. MEASURE (run for 2+ weeks)
   - Click-through rate per variant
   - Conversion rate per variant
   - Sample size: at least 1,000 users per variant

4. DECIDE
   - If B wins with statistical significance → roll out B to 100%
   - If no difference → keep A (simpler, no change needed)
   - If B loses → remove B, keep A
```

### What to A/B Test

| Good Tests (Measurable) | Bad Tests (Too Vague) |
|------------------------|-----------------------|
| Button color/text | "Is the app better?" |
| Pricing page layout | "Do users like it more?" |
| Onboarding flow (3 steps vs 5) | Entire app redesign |
| Email subject line | Backend architecture |

---

## Kill Switch Pattern

A kill switch lets you instantly disable a feature without deploying code. Essential for production safety.

### When to Use Kill Switches

- New third-party integrations (payment, email, SMS)
- Features with high load impact (real-time dashboards, AI processing)
- Features that depend on external APIs (could go down)
- Anything touching money or user data

### Implementation Approach

```typescript
// Simple environment variable kill switch
// .env
FEATURE_AI_CHAT_ENABLED=true

// In your code
if (process.env.FEATURE_AI_CHAT_ENABLED === 'true') {
  // Show AI chat feature
} else {
  // Show "Feature temporarily unavailable" message
}
```

```typescript
// Database-backed kill switch (change without restart)
async function isFeatureEnabled(flagName: string): Promise<boolean> {
  const flag = await db.featureFlag.findUnique({
    where: { name: flagName }
  });
  return flag?.enabled ?? false;
}

// Usage
if (await isFeatureEnabled('ai-chat')) {
  return this.processChatMessage(input);
} else {
  return { message: 'This feature is temporarily unavailable.' };
}
```

> Database-backed flags can be toggled instantly via an admin panel. Environment variable flags require a restart or redeployment.

---

## Implementation Approaches

### Approach 1: Environment Variables (Simplest)

```bash
# .env
FEATURE_NEW_DASHBOARD=true
FEATURE_AI_ASSISTANT=false
FEATURE_DARK_MODE=true
```

**Pros**: Zero dependencies, works anywhere
**Cons**: Requires redeployment to change, no per-user targeting

### Approach 2: Database Config Table

```sql
CREATE TABLE feature_flags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) UNIQUE NOT NULL,
  enabled BOOLEAN DEFAULT false,
  rollout_percentage INT DEFAULT 0,
  description TEXT,
  updated_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO feature_flags (name, enabled, rollout_percentage, description)
VALUES ('new-dashboard', true, 25, 'New analytics dashboard UI');
```

**Pros**: Toggle without deployment, supports rollout percentages
**Cons**: Adds database queries, need to build admin UI

### Approach 3: Dedicated Feature Flag Service

| Service | Free Tier | Pricing | Best For |
|---------|-----------|---------|----------|
| **LaunchDarkly** | None | $12/seat/month | Enterprise, advanced targeting |
| **Unleash** | Open source (self-host) | Free (self-host) | Teams wanting full control |
| **PostHog** | 1M events free | $0 to start | Already using PostHog for analytics |
| **Flagsmith** | Open source | Free (self-host) | Open source preference |
| **GrowthBook** | Open source | Free (self-host) | A/B testing focused |

**Pros**: Rich targeting, audit logs, scheduling, analytics
**Cons**: Added cost and dependency

### Decision Guide

```
Are you a solo dev or small team?
  YES → Start with environment variables
  NO  → Continue below

Do you need per-user targeting or A/B tests?
  NO  → Use a database config table
  YES → Continue below

Do you already use PostHog?
  YES → Use PostHog feature flags (already integrated)
  NO  → Use Unleash (self-host, free) or GrowthBook
```

---

## Implementing Rollout Percentages

To roll out to a percentage of users, hash the user ID and check if it falls within the target percentage.

```typescript
import { createHash } from 'crypto';

function isUserInRollout(userId: string, flagName: string, percentage: number): boolean {
  // Create a consistent hash from user ID + flag name
  const hash = createHash('md5')
    .update(`${userId}-${flagName}`)
    .digest('hex');

  // Convert first 8 hex chars to a number (0-4294967295)
  const hashNum = parseInt(hash.substring(0, 8), 16);

  // Normalize to 0-100
  const userPercentile = (hashNum / 0xFFFFFFFF) * 100;

  return userPercentile < percentage;
}

// Usage
if (isUserInRollout(user.id, 'new-dashboard', 25)) {
  // Show new dashboard (25% of users, consistently per user)
}
```

> The hash ensures the same user always sees the same variant. Increasing the percentage from 25% to 50% adds new users without changing existing ones.

---

## Flag Cleanup Discipline

Feature flags are temporary. If you never remove them, your code becomes unreadable.

### Flag Lifecycle

```
Create flag → Deploy code → Roll out gradually → Reach 100% →
Monitor for 1 week → REMOVE the flag and dead code path
```

### Cleanup Checklist

| Step | Action |
|------|--------|
| 1 | Flag has been at 100% for at least 1 week |
| 2 | No incidents related to the flagged feature |
| 3 | Remove the flag check from code |
| 4 | Remove the old code path (the "else" branch) |
| 5 | Delete the flag from your flag store (env, DB, or service) |
| 6 | Commit with message: "cleanup: remove [flag-name] feature flag" |

### Warning Signs of Flag Debt

- More than 10 active flags at once
- Flags older than 30 days that are still at less than 100%
- Nested flag checks (`if flagA && flagB && !flagC`)
- Nobody remembers what a flag was for

> Schedule a monthly "flag cleanup" session. Review all active flags and remove any that are fully rolled out.

---

## Skill Complete When

- [ ] Understand the four types of flags (release, experiment, ops, permission)
- [ ] Implementation approach chosen (env vars, database, or service)
- [ ] Gradual rollout plan in place (not going from 0% to 100%)
- [ ] Kill switches added for risky features and external dependencies
- [ ] A/B tests follow the hypothesis > test > measure > decide process
- [ ] Flag cleanup process established (remove flags after full rollout)
- [ ] No more than 10 active flags at any time

*Skill Version: 1.0 | Created: February 2026*
