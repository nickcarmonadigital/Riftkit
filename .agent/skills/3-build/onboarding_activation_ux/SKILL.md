---
name: Onboarding & Activation UX
description: Design first-run experiences, activation funnels, progressive disclosure, product tours, and checklist patterns that drive users to their aha moment fast
---

# Onboarding & Activation UX

**Purpose**: Design and implement onboarding flows that move new users from sign-up to their first moment of value as fast as possible — using progressive disclosure, guided tours, checklists, and activation metrics to eliminate drop-off.

---

## TRIGGER COMMANDS

```text
"Design the onboarding flow for [app]"
"Users are signing up but not activating"
"Build a first-run experience for [feature]"
"Add a product tour to [page]"
"Reduce time-to-value for new users"
"Using onboarding_activation_ux skill: [target]"
```

---

## WHEN TO USE

- Building a new product's first-run experience
- Activation rate is below 40% (sign-up to first value)
- Users sign up but never complete setup
- Adding a major new feature that needs discovery
- Redesigning an existing onboarding flow that has high drop-off

---

## 1. DEFINE THE AHA MOMENT

Before building anything, identify the single moment where a user first experiences the product's core value.

### Aha Moment Examples

| Product Type | Aha Moment | Metric |
|---|---|---|
| Project management | Created first task and moved it to "done" | Task completion within 24h |
| Analytics dashboard | Saw their first real data visualization | Dashboard viewed with live data |
| AI writing tool | Generated first useful output | Copy/download of AI result |
| E-commerce | Found a product they want | Add to cart within first session |
| Social platform | Connected with first friend/followed first creator | First follow/connection |
| Dev tool | Ran first successful build/deploy | First successful execution |

### Finding Your Aha Moment
```
[ ] Identify the ONE action that correlates with long-term retention
[ ] Measure: users who do X within Y days retain at Z% vs A%
[ ] The gap between Z and A should be >20% to be a true aha moment
[ ] Define the critical path: minimum steps from sign-up to aha moment
[ ] Count the steps — if more than 5, you need to reduce
```

---

## 2. FIRST-RUN EXPERIENCE PATTERNS

### Pattern Selection Matrix

| Pattern | Best For | Steps | Effort |
|---|---|---|---|
| **Welcome screen + CTA** | Simple products, single aha moment | 1-2 | Low |
| **Setup wizard** | Products requiring configuration | 3-5 | Medium |
| **Progressive profiling** | Products with varied use cases | 2-3 upfront, rest later | Medium |
| **Guided creation** | Creative/builder tools | 1 guided task | High |
| **Sample data + tour** | Data-heavy products | Tour of pre-loaded state | Medium |
| **Choose your adventure** | Multi-persona products | 1 choice, then tailored path | High |

### Welcome Screen Rules
- **Maximum 3 value propositions** — one sentence each
- **Single primary CTA** — "Get Started", "Create Your First [X]", not "Learn More"
- **Skip option visible** — never trap users in onboarding
- **No login wall before value** — let users see something useful first when possible

### Setup Wizard Rules
```
[ ] Maximum 5 steps (3 is ideal)
[ ] Progress indicator visible at all times
[ ] Each step has a clear purpose the user understands
[ ] "Skip" or "I'll do this later" on every non-critical step
[ ] Save progress — never lose data if user leaves
[ ] Final step leads directly to the aha moment, not a dashboard
```

### Anti-Patterns
- Forcing account creation before showing any value
- 10+ field registration forms
- Mandatory tutorials that can't be skipped
- Showing an empty dashboard after sign-up
- Asking for permissions (notifications, location) before providing value

---

## 3. PROGRESSIVE DISCLOSURE

Layer complexity so new users aren't overwhelmed. Reveal features as users are ready.

### Disclosure Levels

| Level | What's Visible | Trigger to Unlock |
|---|---|---|
| **Level 0** | Core feature only, simplified UI | First login |
| **Level 1** | Secondary features, settings | After aha moment achieved |
| **Level 2** | Power features, integrations | After 3+ sessions or explicit opt-in |
| **Level 3** | Admin, advanced config, API | Manual discovery or role-based |

### Implementation Rules
- **Default to simple** — hide advanced options behind "Advanced" or "More options"
- **Contextual reveal** — show features when the user is in a context where they'd need them
- **Never remove** — once revealed, features stay visible (don't re-hide)
- **Teach at point of need** — explain a feature the first time a user encounters it, not before

### Progressive Disclosure Checklist
```
[ ] Core workflow achievable without clicking "Advanced" or "Settings"
[ ] New user UI has fewer than 7 visible actions on primary screen
[ ] Power features accessible but not prominent for new users
[ ] Each feature reveal includes brief contextual explanation
[ ] Settings page organized by frequency of use, not alphabetically
```

---

## 4. PRODUCT TOURS & TOOLTIPS

### Tour Types

| Type | Format | Best For | Max Steps |
|---|---|---|---|
| **Coachmarks** | Single highlighted element + tooltip | Pointing out one feature | 1 |
| **Hotspots** | Pulsing dots on UI elements | Passive discovery | 3-5 on screen |
| **Step-by-step tour** | Sequential tooltips with backdrop | Explaining a workflow | 5-7 |
| **Interactive walkthrough** | User performs actions with guidance | Teaching by doing | 3-5 |
| **Video overlay** | Embedded video on feature | Complex features | 1 (30-60s) |

### Tour Design Rules
- **Maximum 5-7 steps** — beyond this, completion drops below 30%
- **Each step must be actionable** — "Click here to..." not "This is the..."
- **Dismissable always** — X button and click-outside to close
- **Show once** — don't re-trigger tours users have completed
- **Progress indicator** — "Step 2 of 5" so users know the commitment
- **End with value** — last step should put the user in a productive state

### Tooltip Content Formula
```
Title: [What this does] (3-5 words)
Body: [Why it matters to YOU] (1 sentence, max 80 characters)
CTA: [Action verb] (e.g., "Try it", "Got it", "Next")
```

### When NOT to Use Tours
- The UI is self-explanatory (good design > good tours)
- The feature can be discovered through normal exploration
- You're compensating for bad UX with a tooltip explaining bad UX
- The user has already demonstrated proficiency

---

## 5. CHECKLIST & PROGRESS PATTERNS

### Onboarding Checklist Design

```
[ ] 3-7 items maximum (5 is ideal)
[ ] First item is already completed (momentum: "1 of 5 done!")
[ ] Items ordered by value delivered, not logical sequence
[ ] Each item completable in under 2 minutes
[ ] Visual progress (progress bar, fraction, or checkmarks)
[ ] Checklist persists across sessions (not just first login)
[ ] Dismissable after completion or after 7 days
[ ] Completion triggers celebration (confetti, success message)
```

### Gamification Elements (Use Sparingly)

| Element | When to Use | When to Avoid |
|---|---|---|
| **Progress bar** | Setup flows, multi-step processes | Simple products |
| **Checkmarks** | Task-oriented onboarding | Exploration-oriented products |
| **Streaks** | Habit-building products | Productivity tools |
| **Badges** | Community/social products | B2B enterprise |
| **Confetti/celebration** | Key milestones (aha moment) | Every minor action |

### Completion Incentives
- Show percentage complete: "You're 60% set up" (Zeigarnik effect — people want to finish)
- Unlock a feature: "Complete setup to unlock [premium feature]"
- Social proof: "Most users complete setup in under 3 minutes"
- Don't gate core functionality behind checklist completion

---

## 6. EMPTY STATE TO FIRST VALUE

The empty state IS the onboarding. Never show a blank screen.

### Empty State Strategies

| Strategy | Implementation | Best For |
|---|---|---|
| **Templates** | Pre-built starting points user can customize | Builder/creative tools |
| **Sample data** | Pre-loaded realistic data user can explore | Dashboards, analytics |
| **Guided creation** | Step-by-step wizard to create first item | Any CRUD app |
| **Import** | Import from existing tool or CSV | Migration-heavy products |
| **Quick action** | Single prominent "Create your first [X]" button | Simple products |

### Empty State Content Formula
```
Illustration: [Relevant, not generic — shows what the populated state looks like]
Headline: [What you'll see here once you start] (not "Nothing here yet")
Description: [One sentence explaining the value]
CTA: [Create your first X] or [Import from Y] (primary, prominent)
Secondary: [Watch a 30s demo] or [Use a template] (optional)
```

### Anti-Patterns
- "No data to display" with no guidance
- Generic illustration unrelated to the feature
- "Get started" button that goes to docs instead of creation flow
- Requiring 5+ steps before showing any populated state

---

## 7. MEASURING ACTIVATION

### Key Metrics

| Metric | Formula | Benchmark |
|---|---|---|
| **Activation rate** | Users who reach aha moment / Total sign-ups | 25-40% good, >50% excellent |
| **Time to value** | Median time from sign-up to aha moment | <5 min ideal, <24h acceptable |
| **Setup completion** | Users who finish onboarding / Users who start | >60% good |
| **Day 1 retention** | Users who return day after sign-up | >40% good |
| **Feature adoption** | Users who use feature / Users exposed to feature | Varies by feature |

### Funnel Analysis
```
Step 1: Sign-up page visited       → [X users]
Step 2: Account created            → [conversion %]
Step 3: Onboarding started         → [conversion %]
Step 4: First key action taken     → [conversion %]  ← biggest drop-off usually here
Step 5: Aha moment achieved        → [conversion %]
Step 6: Return visit (Day 1)       → [retention %]
```

### Optimization Loop
```
[ ] Instrument every onboarding step with analytics events
[ ] Identify the biggest drop-off point in the funnel
[ ] Hypothesize why users drop off (survey, session replay, user interviews)
[ ] A/B test one change at a time
[ ] Track cohort-over-cohort improvement
[ ] Re-run analysis monthly
```

---

## EXIT CRITERIA

```
[ ] Aha moment defined and measurable
[ ] Critical path from sign-up to aha moment is 5 steps or fewer
[ ] First-run experience pattern selected and implemented
[ ] Progressive disclosure levels defined — new users see simplified UI
[ ] Product tour is 7 steps or fewer with dismiss option
[ ] Onboarding checklist has 3-7 items with progress indicator
[ ] Empty states guide users to first value — no blank screens
[ ] Activation rate instrumented and baselined
[ ] Time-to-value measured and under target threshold
[ ] Returning users are not re-shown onboarding
[ ] Skip/dismiss options available on every onboarding element
[ ] Mobile onboarding tested and functional
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: Product-led growth research + activation funnel best practices*
