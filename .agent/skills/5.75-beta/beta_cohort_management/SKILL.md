---
name: Beta Cohort Management
description: Manage beta tester segments with cohort creation, per-cohort analytics, feature rollout targeting, and cohort communication
---

# Beta Cohort Management Skill

**Purpose**: Segment beta testers into meaningful cohorts so you can run targeted feature rollouts, measure adoption per segment, and communicate appropriately with each group. Not all beta users are the same -- early adopters, enterprise trials, and power users each need different treatment and produce different signal.

## TRIGGER COMMANDS

```text
"Create beta cohort"
"Segment beta users"
"Cohort analytics"
"Beta user management"
"Using beta_cohort_management skill: segment [project] beta users"
```

## When to Use

- Starting a beta program with more than 10 users
- Running different feature rollouts for different user segments
- Need to separate analytics by user type to avoid misleading aggregate data
- Planning cohort-specific communication (onboarding, feedback requests, graduation notices)

---

## PROCESS

### Step 1: Define Cohort Taxonomy

Define the segments that matter for your product. Start with 3-5 cohorts maximum.

| Cohort | Definition | Selection Criteria | Size Target |
|--------|-----------|-------------------|-------------|
| **Founders** | First beta users, highest trust | Applied during private beta | 10-20 users |
| **Early Adopters** | Signed up in first wave | First 30 days of public beta | 30-50 users |
| **Enterprise Trial** | Evaluating for team purchase | Company size > 50, requested trial | 5-10 orgs |
| **Power Users** | High engagement, stress-testing | > 100 actions/week for 2+ weeks | 10-20 users |
| **Casual Testers** | Low engagement, broad feedback | Everyone else | Remaining |

**Cohort Data Model**:

```sql
CREATE TABLE beta_cohorts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  criteria JSONB NOT NULL,        -- automated assignment rules
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE beta_cohort_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cohort_id UUID REFERENCES beta_cohorts(id),
  user_id UUID REFERENCES users(id),
  joined_at TIMESTAMP DEFAULT NOW(),
  status VARCHAR(20) DEFAULT 'active',  -- active, churned, graduated
  UNIQUE(cohort_id, user_id)
);
```

### Step 2: Implement Cohort Assignment

Assign users to cohorts automatically based on criteria, with manual override capability.

**Assignment Rules Engine**:

```typescript
// src/beta/cohort-assignment.service.ts
interface CohortCriteria {
  minActionsPerWeek?: number;
  minWeeksActive?: number;
  companySize?: { min: number };
  signupDateBefore?: string;
  manual?: boolean;
}

async function assignUserToCohort(userId: string): Promise<string> {
  const user = await getUserWithActivity(userId);

  // Priority order: most specific first
  if (user.companySize > 50 && user.requestedEnterpriseTrial) {
    return 'enterprise_trial';
  }
  if (user.actionsPerWeek > 100 && user.weeksActive >= 2) {
    return 'power_users';
  }
  if (user.signupDate < FOUNDERS_CUTOFF) {
    return 'founders';
  }
  if (user.signupDate < EARLY_ADOPTER_CUTOFF) {
    return 'early_adopters';
  }
  return 'casual_testers';
}
```

### Step 3: Per-Cohort Analytics

Separate analytics by cohort to avoid misleading aggregate data. Power users will skew your metrics if mixed with casual testers.

**Dashboard Structure**:

```text
Beta Analytics Dashboard
|
+-- Overview (all cohorts combined)
|   +-- Total active users
|   +-- Overall activation rate
|   +-- Overall retention
|
+-- Per-Cohort Breakdown
|   +-- Founders
|   |   +-- Activation rate: 90% (expected: high)
|   |   +-- 7-day retention: 78%
|   |   +-- Avg sessions/week: 12
|   |
|   +-- Enterprise Trial
|   |   +-- Activation rate: 45% (investigate)
|   |   +-- 7-day retention: 60%
|   |   +-- Seats per org: 3.2
|   |
|   +-- Casual Testers
|       +-- Activation rate: 30% (expected: lower)
|       +-- 7-day retention: 20%
|       +-- Avg sessions/week: 1.5
|
+-- Feature Adoption by Cohort
    +-- Feature X: Founders 80%, Enterprise 60%, Casual 15%
    +-- Feature Y: Founders 40%, Enterprise 90%, Casual 5%
```

**Analytics Tagging** (PostHog group property):

```typescript
// Tag every event with cohort for segmentation
posthog.capture(userId, 'feature_used', {
  feature: 'ai_assistant',
  cohort: user.betaCohort,        // 'founders', 'enterprise_trial', etc.
  cohort_week: user.betaWeekNumber, // week 1, 2, 3... for trend analysis
});
```

### Step 4: Cohort-Specific Feature Rollout

Use feature flags to roll out features to specific cohorts before wider release.

**Rollout Strategy**:

| Phase | Cohort | Duration | Success Criteria |
|-------|--------|----------|-----------------|
| 1 | Founders | 3 days | No P0 bugs, positive qualitative feedback |
| 2 | Power Users | 5 days | < 0.1% error rate, no performance regression |
| 3 | Early Adopters | 5 days | Activation rate > 50% for the feature |
| 4 | All Beta | 7 days | Meets graduation metrics |
| 5 | GA (public) | Permanent | Monitor for 7 days post-launch |

**Feature Flag Targeting**:

```typescript
// Feature flag targeting by cohort
const flagConfig = {
  name: 'new_ai_assistant',
  rules: [
    { cohort: 'founders', percentage: 100 },
    { cohort: 'power_users', percentage: 100 },
    { cohort: 'early_adopters', percentage: 50 },
    { cohort: 'enterprise_trial', percentage: 0 },
    { cohort: 'casual_testers', percentage: 0 },
  ],
};
```

### Step 5: Cohort Communication

Each cohort needs different communication cadence and channels.

| Cohort | Channel | Cadence | Content Focus |
|--------|---------|---------|--------------|
| Founders | Direct Slack/Discord + email | Weekly | Roadmap previews, deep feedback requests |
| Power Users | Email + in-app | Bi-weekly | New feature announcements, bug fix updates |
| Enterprise Trial | Dedicated CSM + email | Weekly | ROI data, integration guides, pricing preview |
| Early Adopters | Email | Bi-weekly | Feature highlights, usage tips |
| Casual Testers | Email | Monthly | Product updates, re-engagement prompts |

**Cohort Communication Template**:

```markdown
Subject: [Founders Only] New Feature Preview: AI Assistant

Hi [Name],

As one of our founding beta users, you get early access to our
new AI Assistant feature -- 2 weeks before the wider beta group.

What it does: [1-2 sentences]
How to try it: [Direct link or instructions]
What we need from you: [Specific feedback request]

Reply directly to this email with your thoughts.

-- [Your Name]
```

---

## CHECKLIST

- [ ] Cohort taxonomy defined with 3-5 meaningful segments
- [ ] Cohort data model implemented (database tables or analytics groups)
- [ ] Automated cohort assignment rules implemented
- [ ] Manual override capability available for edge cases
- [ ] Analytics dashboards segmented by cohort
- [ ] Feature rollout strategy uses cohort-based phasing
- [ ] Feature flags configured with cohort targeting rules
- [ ] Communication plan defined per cohort (channel, cadence, content)
- [ ] Cohort sizes monitored to ensure statistical significance
- [ ] Cohort data feeds into `beta_graduation_criteria` readiness scorecard

---

*Skill Version: 1.0 | Created: February 2026*
