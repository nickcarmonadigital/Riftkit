# Atomic Reverse Architecture (ARA) Template

> **Reference**: For full methodology and theory, see the `atomic_reverse_architecture` skill.

---

## When to Use ARA

| Use ARA When... | Skip ARA When... |
|-----------------|------------------|
| Building a new feature with 3+ moving parts | Simple CRUD endpoint (just build it) |
| Designing a system you haven't built before | Fixing a bug (use `bug_troubleshoot`) |
| Planning a project with multiple phases | Adding a field to an existing form |
| You need to identify hidden dependencies | Task takes less than a day |
| Multiple services or modules must coordinate | You've built this exact thing before |

**Time Investment**: ~30-60 minutes per ARA analysis. Saves 2-10x that in avoided rework.

---

## Phase 1: Vision State

State the goal as a concrete, measurable outcome.

**Template**:

"I have a **[PROJECT TYPE]** that needs to **[CORE CAPABILITY]** so that **[USER OUTCOME]**."

**Capabilities** (what the system must do):

- [ ] [Capability 1]
- [ ] [Capability 2]
- [ ] [Capability 3]

**Success Metrics** (how you know it works):

| Metric | Target | How to Measure |
|--------|--------|---------------|
| [Metric 1] | [Target] | [Measurement method] |
| [Metric 2] | [Target] | [Measurement method] |

### Example: User Dashboard Feature

"I have a **SaaS application** that needs to **display real-time analytics for each user** so that **users can track their usage and make informed decisions**."

**Capabilities**:
- [ ] Display usage statistics (API calls, storage, active sessions)
- [ ] Show trends over time (daily/weekly/monthly charts)
- [ ] Alert users when approaching plan limits
- [ ] Allow date range filtering

**Success Metrics**:
| Metric | Target | How to Measure |
|--------|--------|---------------|
| Dashboard load time | < 2 seconds | Performance testing |
| Data freshness | < 5 minutes old | Timestamp comparison |
| User engagement | 60% weekly active users view dashboard | Analytics tracking |

---

## Phase 2: Atomic Decomposition

Break the vision into the smallest independent units (atoms) that can be built and tested separately.

| Atom | Responsibility | Inputs | Outputs | Can Be Built Independently? |
|------|---------------|--------|---------|---------------------------|
| [Atom 1] | [What it does] | [Data in] | [Data out] | Yes / Needs [Atom X] |
| [Atom 2] | [What it does] | [Data in] | [Data out] | Yes / Needs [Atom X] |

### Example: Dashboard Atoms

| Atom | Responsibility | Inputs | Outputs | Can Be Built Independently? |
|------|---------------|--------|---------|---------------------------|
| **Auth Gate** | Verify user has access to dashboard | JWT token, userId | Authenticated user object | Yes |
| **Data Aggregation** | Calculate usage metrics | userId, dateRange | AggregatedMetrics object | Yes |
| **Chart Renderer** | Display data as interactive charts | AggregatedMetrics | React chart components | Yes (with mock data) |
| **Date Filter** | Allow user to select date range | User interaction | { startDate, endDate } | Yes |
| **Limit Alert** | Check if user approaches plan limits | CurrentUsage, PlanLimits | Alert notifications | Needs Data Aggregation |
| **Caching Layer** | Cache expensive aggregation queries | Query params | Cached results | Needs Data Aggregation |

---

## Phase 3: Reverse Condition Mapping

For each atom, ask: "What must be true BEFORE this atom can function?"

### [Atom Name]

**Prerequisites** (must exist before this works):

- [ ] [Condition 1 — e.g., database table exists]
- [ ] [Condition 2 — e.g., API endpoint returns data]

**Error States** (what can go wrong):

- [ ] [Error 1 — e.g., user has no data yet (empty state)]
- [ ] [Error 2 — e.g., aggregation query times out]

**Edge Cases**:

- [ ] [Edge 1 — e.g., user created today, no historical data]
- [ ] [Edge 2 — e.g., timezone differences in date filtering]

### Example: Data Aggregation Atom

**Prerequisites**:
- [ ] Usage events are being logged to the database (event tracking exists)
- [ ] Database has indexes on userId + timestamp columns
- [ ] User's plan/tier is accessible (to determine limits)

**Error States**:
- [ ] Query timeout on large datasets (>1M rows) → implement pagination/sampling
- [ ] Database connection failure → return cached data or error state

**Edge Cases**:
- [ ] New user with zero events → show onboarding state, not empty charts
- [ ] User in UTC-12 timezone, data stored in UTC → timezone conversion needed
- [ ] User changed plans mid-month → split metrics by plan period

---

## Phase 4: Gap Synthesis

What's missing that Phase 3 revealed?

| Gap Category | Missing Piece | Resolution | Effort |
|--------------|---------------|------------|--------|
| Integration | [What doesn't connect] | [How to connect it] | S/M/L |
| Security | [What's unprotected] | [How to protect it] | S/M/L |
| Performance | [What will be slow] | [How to optimize] | S/M/L |
| UX | [What confuses users] | [How to clarify] | S/M/L |
| Data | [What data is missing] | [Where to get it] | S/M/L |

### Example: Dashboard Gaps

| Gap Category | Missing Piece | Resolution | Effort |
|--------------|---------------|------------|--------|
| Data | No usage event logging exists | Create UsageEvent model + logging service | M |
| Performance | Aggregation on 1M+ rows will be slow | Add materialized view or pre-computed daily rollups | L |
| UX | No empty state design for new users | Design onboarding cards with sample data | S |
| Security | Dashboard exposes user's billing plan | Verify only the user themselves can see their dashboard | S |
| Integration | Chart library not chosen | Evaluate Recharts vs Chart.js vs Tremor | S |
| Data | Timezone handling not considered | Store UTC, convert client-side using user's timezone preference | M |

---

## Phase 5: Dependency Ordering

Order the atoms so each phase only depends on completed phases.

**Build Phases**:

1. **Phase 1** (no dependencies): [Items that can be built first]
2. **Phase 2** (depends on Phase 1): [Items that need Phase 1 complete]
3. **Phase 3** (depends on Phase 2): [Items that need Phase 2 complete]

**Critical Path** (longest dependency chain):

```
[Atom A] → [Atom B] → [Atom C] → [Atom D]
```

### Example: Dashboard Build Order

```
Phase 1 (Foundation — no dependencies):
  ├── UsageEvent Prisma model + migration
  ├── Event logging service (track API calls, storage, sessions)
  └── Date filter component (standalone)

Phase 2 (Core — needs Phase 1):
  ├── Data aggregation service (needs events to aggregate)
  ├── Caching layer for aggregation queries
  └── Empty state / onboarding UI

Phase 3 (Presentation — needs Phase 2):
  ├── Chart components (needs real aggregated data)
  ├── Dashboard page layout
  └── Limit alert system (needs aggregation + plan data)

Phase 4 (Polish — needs Phase 3):
  ├── Loading skeletons
  ├── Error states
  └── Performance optimization (if needed after real data testing)
```

**Critical Path**: Event Model → Event Logging → Aggregation Service → Chart Components → Dashboard Page

**Estimated Total**: 2 sprints (assumes 1 developer)

---

## Common Mistakes in ARA

| Phase | Mistake | Fix |
|-------|---------|-----|
| Vision | Too vague ("make it good") | Use measurable success metrics |
| Decomposition | Atoms too large (>3 days of work) | Break down further |
| Decomposition | Atoms too small (individual functions) | Group related logic |
| Reverse Conditions | Skipping error states | Ask "what if this fails?" for every atom |
| Gap Synthesis | Ignoring performance gaps | Always ask "what happens at 10x scale?" |
| Dependency Ordering | Starting with the fun part | Start with the foundation, not the UI |
