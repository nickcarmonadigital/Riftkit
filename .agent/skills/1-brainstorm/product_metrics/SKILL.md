---
name: Product Metrics
description: Choose the right metrics to measure product success from North Star down to feature level
---

# Product Metrics Skill

> **PURPOSE**: Help you pick the right numbers to track so you know whether your product is succeeding, and stop wasting time on metrics that look good but mean nothing.

## 🎯 When to Use

- You are launching a product and need to define success metrics
- You need to set KPIs for a new feature before building it
- A stakeholder asks "how will we know if this is working?"
- You are building a dashboard and need to decide what goes on page 1
- You suspect you are tracking vanity metrics and want to fix it

---

## Step 1: Choose Your North Star Metric

Your North Star metric is the single number that best captures the value your product delivers. Every team member should know it.

### How to Find Your North Star

Answer this question: **"What is the one action that means a user got real value from our product?"**

| Product Type | North Star Metric | Why |
|-------------|------------------|-----|
| SaaS tool | Weekly active users who complete a core action | Shows real usage, not just logins |
| E-commerce | Purchases per month | Revenue-driving action |
| Content platform | Time spent consuming content | Shows engagement and value |
| Marketplace | Transactions completed | Both sides got value |
| Communication tool | Messages sent per day | Core value delivery |

### North Star Checklist

Your North Star should pass all of these:

- [ ] It measures value delivered, not vanity (not page views or signups)
- [ ] It is a leading indicator of revenue (more of this = more money eventually)
- [ ] It is actionable (your team can build features that move it)
- [ ] Every team member can understand it in one sentence
- [ ] It can be measured weekly or daily

---

## Step 2: AARRR Pirate Metrics

AARRR covers the entire user lifecycle. For each stage, pick 1-2 metrics.

| Stage | What It Measures | Example Metrics | Example Targets |
|-------|-----------------|----------------|----------------|
| **Acquisition** | How do users find you? | Website visitors, signup rate | 1000 visitors/week, 5% signup rate |
| **Activation** | Do they have a good first experience? | Completed onboarding, first core action | 60% complete onboarding in day 1 |
| **Retention** | Do they come back? | Week 1 retention, monthly active users | 40% return after week 1 |
| **Revenue** | Do they pay? | Conversion to paid, average revenue per user | 5% free-to-paid, $25 ARPU |
| **Referral** | Do they tell others? | Invites sent, referral signups | 15% of users invite someone |

### AARRR Worksheet

Fill this out for your product:

```
ACQUISITION
- How users find us: _______________
- Metric: _______________
- Current: _____ | Target: _____

ACTIVATION
- First "aha" moment: _______________
- Metric: _______________
- Current: _____ | Target: _____

RETENTION
- Why they come back: _______________
- Metric: _______________
- Current: _____ | Target: _____

REVENUE
- How we make money: _______________
- Metric: _______________
- Current: _____ | Target: _____

REFERRAL
- Why they share: _______________
- Metric: _______________
- Current: _____ | Target: _____
```

---

## Step 3: KPI Hierarchy

Metrics cascade from company level down to individual features. Each level supports the one above it.

```
COMPANY LEVEL (CEO cares about)
├── Monthly recurring revenue (MRR)
├── Customer count
└── Churn rate

PRODUCT LEVEL (PM cares about)
├── Weekly active users
├── Feature adoption rate
├── Net promoter score (NPS)
└── Time to value (how fast new users get value)

FEATURE LEVEL (Developer cares about)
├── Feature usage count
├── Task completion rate
├── Error rate
└── Performance (load time)
```

### Example: KPI Hierarchy for a Project Management Tool

| Level | Metric | Target | Owner |
|-------|--------|--------|-------|
| Company | MRR | $50K/mo | CEO |
| Company | Paying customers | 200 | Sales |
| Product | Weekly active projects | 500 | PM |
| Product | Activation rate (created first project in day 1) | 60% | PM |
| Feature: Templates | % of projects created from templates | 40% | Dev team |
| Feature: Notifications | Notification click-through rate | 25% | Dev team |
| Feature: Search | Searches with 0 results | <5% | Dev team |

---

## Step 4: Leading vs Lagging Indicators

| Type | Definition | Example | Use For |
|------|-----------|---------|---------|
| **Leading** | Predicts future results | Signups this week, feature usage | Early warnings, quick action |
| **Lagging** | Confirms past results | Revenue this month, churn rate | Measuring actual outcomes |

### Why This Matters

If your lagging indicator is "monthly revenue dropped," it is too late to react. Track leading indicators that predict the drop early:

| Lagging (Too Late) | Leading (Early Warning) |
|--------------------|----------------------|
| Revenue dropped | Daily active users declined 2 weeks ago |
| Users churned | Support tickets spiked last month |
| NPS score fell | Feature adoption rate dropped |
| Conversion rate dropped | Onboarding completion rate fell |

**Rule**: Dashboard page 1 should be 70% leading indicators and 30% lagging indicators.

---

## Step 5: Choosing Metrics Per Feature

Before building any feature, define how you will measure its success.

### Feature Metric Template

```
Feature: [Name]
Purpose: [Why are we building this?]

SUCCESS METRIC (the main one):
- Metric: _______________
- Current baseline: _____
- Target after 30 days: _____

SECONDARY METRICS (watch for side effects):
- Metric 1: _______________
- Metric 2: _______________

GUARDRAIL METRIC (should NOT get worse):
- Metric: _______________
- Acceptable range: _____
```

### Example: Adding a Search Feature

```
Feature: Product Search
Purpose: Help users find items faster

SUCCESS METRIC:
- Metric: Searches leading to a purchase within 5 minutes
- Current baseline: N/A (new feature)
- Target after 30 days: 20% of searches lead to purchase

SECONDARY METRICS:
- Average time to find a product (should decrease)
- Search usage rate (should be >30% of sessions)

GUARDRAIL METRIC:
- Browse page engagement (should not drop -- search should add to browsing, not replace it)
```

---

## Step 6: Dashboard Design

Your main dashboard should answer "how is the product doing?" in 10 seconds.

### What Goes on Page 1

| Slot | What to Show | Example |
|------|-------------|---------|
| Top center (biggest) | North Star metric + trend | "Weekly Active Users: 1,240 (+8%)" |
| Top row (3-4 cards) | AARRR stage metrics | Signups, Activation %, Retention %, MRR |
| Middle section | Leading indicators with sparklines | Daily active users, feature usage, support tickets |
| Bottom section | Lagging indicators for context | Monthly revenue, churn rate, NPS |

### Dashboard Anti-Patterns

| Bad Practice | Why It Hurts | Do This Instead |
|-------------|-------------|----------------|
| 50 metrics on one page | Information overload | Limit to 8-12 key metrics |
| All numbers, no trends | Cannot see direction | Always show trend (arrow or sparkline) |
| No comparison period | "Is 500 good?" is unanswerable | Show vs last week / last month |
| Only showing good numbers | Hides problems | Include at least 2 health/guardrail metrics |

---

## Step 7: Vanity Metrics to Avoid

These look impressive in reports but do not help you make decisions.

| Vanity Metric | Why It Is Misleading | Better Alternative |
|--------------|---------------------|-------------------|
| Total registered users | Includes dead accounts | Monthly active users |
| Page views | Bots, accidental clicks | Engaged sessions (>30 sec) |
| Total downloads | Many never open the app | Day-1 retention rate |
| Social media followers | Followers do not equal customers | Click-through rate from social |
| "Time on site" (alone) | Could mean confused, not engaged | Task completion rate |
| Total revenue (all time) | Always goes up, hides decline | Monthly recurring revenue trend |

### The Vanity Test

Ask yourself: **"If this number doubled overnight, would I change anything about the product?"** If not, it is a vanity metric.

---

## ✅ Skill Complete When

- [ ] North Star metric defined and passes the checklist
- [ ] AARRR metrics filled out with current values and targets
- [ ] KPI hierarchy mapped (company > product > feature level)
- [ ] At least 2 leading indicators identified per lagging indicator
- [ ] Every planned feature has a success metric, secondary metric, and guardrail metric
- [ ] Dashboard page 1 designed with 8-12 key metrics
- [ ] Vanity metrics identified and replaced with actionable alternatives
