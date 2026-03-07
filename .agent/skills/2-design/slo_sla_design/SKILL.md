---
name: SLO/SLA Design
description: Designs Service Level Indicators, Objectives, and Agreements with error budget calculations, burn-rate alerting, and dependency composition before implementation begins
---

# SLO/SLA Design Skill

**Purpose**: Produces a complete SLO/SLA Design Document that defines what to measure (SLIs), what targets to set (SLOs), and how to contractually commit (SLAs) -- all before building. This skill handles the DESIGN phase: choosing indicators, calculating error budgets, and planning burn-rate alerts. For operational SLO tracking and burn-rate monitoring after deployment, see Phase 7's `slo_sla_management` skill.

## TRIGGER COMMANDS

```text
"Design SLOs for [system]"
"Define SLAs for [service]"
"Set reliability targets"
"Calculate error budgets"
"What should our availability target be?"
```

## When to Use
- After NFR specification defines high-level reliability targets
- Before implementation begins (Phase 3) to bake SLO awareness into code
- When establishing contractual SLAs with external customers
- When defining alerting strategy (burn-rate alerts replace naive threshold alerts)
- Before cost_architecture to understand reliability cost trade-offs

---

## PROCESS

### Step 1: Clarify SLI vs SLO vs SLA

Ensure the team shares precise definitions before proceeding:

```markdown
## Definitions

**SLI (Service Level Indicator)**
A quantitative measurement of service behavior from the USER's perspective.
Example: "The proportion of HTTP requests that return in < 300ms"

**SLO (Service Level Objective)**
An internal target for an SLI over a time window.
Example: "99.9% of requests complete in < 300ms, measured over a 30-day rolling window"

**SLA (Service Level Agreement)**
A contractual commitment to customers with consequences for violation.
Example: "99.9% monthly availability. If breached, customer receives 10% service credit."

## Relationship
SLI (what you measure) --> SLO (what you target internally) --> SLA (what you promise externally)

Rule: SLO targets MUST be stricter than SLA commitments.
If your SLA promises 99.9%, your internal SLO should target 99.95%.
This gives you a buffer before contractual consequences trigger.
```

### Step 2: Select Service Level Indicators (SLIs)

Choose SLIs based on what matters to users, not what is easy to measure.

#### 2a. SLI Categories

| SLI Category | Measures | Good For | Example |
|-------------|----------|----------|---------|
| **Availability** | Can the user reach the service? | All services | Proportion of successful (non-5xx) requests |
| **Latency** | How fast does the service respond? | User-facing APIs, pages | Proportion of requests < threshold at p50/p95/p99 |
| **Correctness** | Does the service return right answers? | Data pipelines, calculations, search | Proportion of responses matching expected output |
| **Freshness** | Is the data up to date? | Dashboards, caches, replicas | Proportion of data updated within threshold |
| **Throughput** | Can the service handle the load? | Batch processing, queues | Proportion of time throughput exceeds minimum |
| **Durability** | Is stored data safe? | Storage, databases, backups | Proportion of data successfully persisted/retrievable |

#### 2b. SLI Specification Template

For each SLI, define it precisely using this template:

```markdown
### SLI: [Name]

**Category**: [Availability | Latency | Correctness | Freshness | Throughput | Durability]

**Definition**: [Precise mathematical definition]
  Numerator: [count of "good" events]
  Denominator: [count of total valid events]

**Measurement Source**: [Where the data comes from]
  - Server-side metrics (Prometheus counter)
  - Load balancer logs (ALB access logs)
  - Synthetic probes (external uptime monitor)
  - Client-side telemetry (Real User Monitoring)

**Exclusions**: [What does NOT count against the SLI]
  - Planned maintenance windows
  - Requests from health checks / internal monitoring
  - Requests rejected by rate limiting (429s are intentional, not failures)

**Example Calculation**:
  Good events: 9,985 successful requests
  Total events: 10,000 requests
  SLI value: 9,985 / 10,000 = 99.85%
```

#### 2c. Common SLI Definitions

```markdown
## Availability SLI
  Good: HTTP responses with status < 500 (excluding health checks)
  Total: All HTTP responses (excluding health checks)
  Source: Load balancer access logs or application metrics

## Latency SLI (p99 < 300ms)
  Good: HTTP responses completed in < 300ms
  Total: All HTTP responses
  Source: Application histogram metric (http_request_duration_seconds)

## Correctness SLI
  Good: Pipeline runs producing output matching validation checksums
  Total: All pipeline runs
  Source: Pipeline orchestrator metrics

## Freshness SLI (data < 5 min old)
  Good: Dashboard queries returning data updated within 5 minutes
  Total: All dashboard queries
  Source: Custom metric tracking last-update timestamp vs query timestamp
```

### Step 3: Set SLO Targets

#### 3a. Choosing the Right Target

SLO targets are NOT aspirational -- they represent the minimum reliability users will tolerate. Setting them too high wastes engineering effort. Setting them too low causes user churn.

```markdown
## Target Selection Framework

| Factor | Lower Target OK (99.0-99.5%) | Higher Target Needed (99.9-99.99%) |
|--------|-------------------------------|-------------------------------------|
| User impact | Internal tool, async workflow | Revenue-critical, real-time user-facing |
| Alternatives | Users can retry, use fallback | No alternative, blocking workflow |
| Data sensitivity | Read-only, cacheable | Financial transactions, medical records |
| Competitive pressure | Unique product, captive users | Commodity, users switch easily |
| Cost of nines | Linear investment | Exponential investment |
```

#### 3b. The Cost of Additional Nines

| Target | Allowed Downtime/month | Allowed Downtime/year | Engineering Cost |
|--------|------------------------|------------------------|-----------------|
| 99.0% | 7h 18m | 3d 15h 36m | Basic |
| 99.5% | 3h 39m | 1d 19h 48m | Moderate |
| 99.9% | 43m 50s | 8h 45m 36s | Significant |
| 99.95% | 21m 55s | 4h 22m 48s | High |
| 99.99% | 4m 23s | 52m 36s | Very high (redundancy, multi-region) |
| 99.999% | 26s | 5m 15s | Extreme (active-active, zero-downtime deploys) |

**Rule**: Start with the lowest target that keeps users happy. You can always tighten later. Loosening an SLO after users expect high reliability is much harder.

#### 3c. SLO Definition Template

```markdown
### SLO: [Service] [SLI Category]

**SLI**: [Reference to SLI definition from Step 2]
**Target**: [X]% of [events] over a [rolling window]
**Window**: [30-day rolling | calendar month]
**Threshold**: [value, e.g., < 300ms for latency]

**Example**:
  SLO: "99.9% of API requests return non-5xx responses over a 30-day rolling window"

**Rationale**: [Why this target, not higher or lower]
**Review Cadence**: [Quarterly | after major incidents]
```

### Step 4: Calculate Error Budgets

The error budget is the inverse of the SLO -- it quantifies how much unreliability you can afford.

#### 4a. Error Budget Formula

```
Error Budget = 1 - SLO Target

Example (99.9% availability SLO, 30-day window):
  Total minutes in 30 days: 43,200
  Error budget: 0.1% x 43,200 = 43.2 minutes of allowed downtime

  Or in request terms:
  Total requests in 30 days: 10,000,000
  Error budget: 0.1% x 10,000,000 = 10,000 allowed failed requests
```

#### 4b. Error Budget Policy

Define what happens as the error budget depletes:

```markdown
## Error Budget Policy

| Budget Remaining | Status | Actions |
|-----------------|--------|---------|
| > 50% | Healthy | Normal development velocity. Ship features freely. |
| 25-50% | Caution | Review recent deployments. Increase test coverage for next release. |
| 10-25% | Warning | Freeze non-critical deployments. Prioritize reliability work. |
| 0-10% | Critical | Feature freeze. All engineering effort on reliability. |
| Exhausted (0%) | Frozen | No deployments except reliability fixes. Incident review required. |

## Budget Reset
- Rolling window: Budget continuously recalculates (no hard reset)
- Calendar window: Budget resets at month/quarter boundary

Recommendation: Use 30-day rolling window. Calendar windows create perverse incentives
(team is cautious at month-end, reckless at month-start).
```

### Step 5: Design Multi-Tier SLOs

Different services and user segments may need different reliability targets:

```markdown
## Multi-Tier SLO Structure

### By Service Tier
| Tier | Services | Availability SLO | Latency SLO (p99) | Rationale |
|------|----------|-------------------|--------------------|-----------|
| Tier 1 (Critical) | Auth, Payments, Core API | 99.95% | < 200ms | Revenue-blocking |
| Tier 2 (Important) | Search, Notifications, Dashboard | 99.9% | < 500ms | Degraded UX |
| Tier 3 (Standard) | Analytics, Reports, Admin | 99.5% | < 2000ms | Internal, async |

### By User Segment (if applicable)
| Segment | Availability SLO | Latency SLO | Rationale |
|---------|-------------------|-------------|-----------|
| Enterprise (paid) | 99.95% | < 150ms | Contractual SLA |
| Free tier | 99.5% | < 500ms | Best-effort |
| Internal users | 99.0% | < 1000ms | Tolerant, can retry |
```

### Step 6: Compose Dependency SLOs

Your service's SLO cannot exceed the combined reliability of its dependencies.

#### 6a. Serial Dependency (all must succeed)

```
Combined Availability = Dependency_A x Dependency_B x ... x Dependency_N

Example:
  API Gateway: 99.99%
  Auth Service: 99.95%
  Database: 99.99%
  Payment Provider (external): 99.9%

  Combined: 0.9999 x 0.9995 x 0.9999 x 0.999 = 99.83%

  Your SLO CANNOT be higher than 99.83% for this request path
  without adding redundancy, caching, or graceful degradation.
```

#### 6b. Parallel Dependency (any one succeeds)

```
Combined Availability = 1 - (1 - Dep_A) x (1 - Dep_B)

Example (multi-region):
  Region A: 99.9%
  Region B: 99.9%
  Combined: 1 - (0.001 x 0.001) = 99.9999%
```

#### 6c. Dependency Mapping Template

```markdown
## Dependency SLO Map

| Your Service | Critical Dependencies | Combined Floor | Your SLO Target | Buffer |
|-------------|----------------------|----------------|-----------------|--------|
| Order API | Auth (99.95%) x DB (99.99%) x Inventory (99.9%) | 99.84% | 99.9% | Requires: retry + circuit breaker on Inventory |
| Search API | DB (99.99%) x Elasticsearch (99.9%) | 99.89% | 99.9% | Tight -- consider read replica fallback |
| Report Worker | DB (99.99%) x S3 (99.99%) | 99.98% | 99.5% | Comfortable margin |

Action items for dependencies that constrain your SLO:
1. [dependency]: Add [mitigation] to achieve [improvement]
2. [dependency]: Negotiate higher SLO with provider or add redundancy
```

### Step 7: Design Burn-Rate Alerting

Replace naive threshold alerts ("error rate > 1%") with burn-rate alerts that predict SLO violation.

#### 7a. Burn Rate Concept

```
Burn Rate = Actual error rate / Error budget consumption rate for 1x budget depletion

1x burn rate = consuming budget at exactly the pace to exhaust it in 30 days
2x burn rate = will exhaust budget in 15 days
10x burn rate = will exhaust budget in 3 days
36x burn rate = will exhaust budget in 20 hours
```

#### 7b. Multi-Window Burn-Rate Alert Matrix

Use two windows per alert to reduce false positives: a long window for significance and a short window for recency.

```markdown
## Burn-Rate Alert Configuration

### For 99.9% SLO (0.1% error budget over 30 days)

| Severity | Burn Rate | Long Window | Short Window | Budget Consumed | Response |
|----------|-----------|-------------|--------------|-----------------|----------|
| **Page** (P1) | 14.4x | 1 hour | 5 minutes | 2% in 1h | Wake on-call, immediate response |
| **Page** (P2) | 6x | 6 hours | 30 minutes | 5% in 6h | Interrupt current work |
| **Ticket** (P3) | 3x | 3 days | 6 hours | 10% in 3d | Address within business hours |
| **Ticket** (P4) | 1x | 7 days | 1 day | ~23% in 7d | Plan for next sprint |

### Alert Firing Condition (both must be true)
  error_rate[long_window] > (1 - SLO_target) * burn_rate
  AND
  error_rate[short_window] > (1 - SLO_target) * burn_rate

### Example (P1 alert for 99.9% availability SLO):
  error_rate[1h] > 0.001 * 14.4 = 1.44%
  AND
  error_rate[5m] > 0.001 * 14.4 = 1.44%
```

#### 7c. Alerting Anti-Patterns to Avoid

| Anti-Pattern | Problem | Better Approach |
|-------------|---------|-----------------|
| Alert on every 5xx | Alert fatigue, no SLO context | Burn-rate alert with error budget context |
| Static threshold (error > 1%) | Doesn't account for traffic volume | Burn rate normalized to SLO |
| Single window alert | High false positive rate | Multi-window (long + short) |
| Alert on SLI dip without budget context | May fire when budget is healthy | Include remaining budget in alert |
| Missing severity levels | Everything is P1 | Tiered burn rates (14.4x, 6x, 3x, 1x) |

### Step 8: Define SLA Terms (If Applicable)

Only proceed if the system has external customers requiring contractual commitments.

```markdown
## SLA Definition Template

### Service: [name]
**Effective Date**: YYYY-MM-DD
**Measurement Period**: Calendar month

### Covered SLIs
| SLI | SLA Target | Measurement Source |
|-----|------------|-------------------|
| Availability | 99.9% monthly uptime | External synthetic monitoring |
| Latency | 95% of requests < 500ms | Load balancer p95 |

### Exclusions
- Scheduled maintenance (with 72h advance notice)
- Force majeure events
- Customer-caused issues (misconfigured API usage)
- Beta/preview features

### Remedies
| Monthly Uptime | Service Credit |
|----------------|----------------|
| 99.0% - 99.9% | 10% of monthly fee |
| 95.0% - 99.0% | 25% of monthly fee |
| < 95.0% | 50% of monthly fee |

### Reporting
- Monthly SLA report published by 5th business day
- Customer can request detailed incident reports
- SLA dashboard accessible at [URL]

### Key Principle
SLA targets MUST be lower than internal SLO targets.
  Internal SLO: 99.95% --> External SLA: 99.9%
  This gives a 0.05% buffer (~21 minutes/month) before credits trigger.
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/slo-sla-design.md`

The output document should follow this structure:
1. SLI/SLO/SLA Definitions (from Step 1)
2. SLI Specifications (from Step 2)
3. SLO Targets with rationale (from Step 3)
4. Error Budget Calculations and Policy (from Step 4)
5. Multi-Tier SLO Structure (from Step 5)
6. Dependency SLO Composition (from Step 6)
7. Burn-Rate Alerting Configuration (from Step 7)
8. SLA Terms if applicable (from Step 8)

---

## CHECKLIST

- [ ] SLI/SLO/SLA definitions clarified with team (no ambiguity)
- [ ] SLIs selected from user's perspective (availability, latency, correctness, freshness)
- [ ] Each SLI has precise numerator/denominator definition
- [ ] SLI measurement source identified (server metrics, LB logs, synthetic probes, RUM)
- [ ] SLI exclusions documented (health checks, rate-limited requests, maintenance)
- [ ] SLO targets set based on user expectations and business tier, not aspirationally
- [ ] Cost of additional nines reviewed (team understands 99.99% vs 99.9% investment)
- [ ] Error budgets calculated for each SLO with concrete numbers (minutes, requests)
- [ ] Error budget policy defined (what happens at 50%, 25%, 10%, 0% remaining)
- [ ] Multi-tier SLOs defined if services have different criticality levels
- [ ] Dependency SLO composition calculated (serial and parallel)
- [ ] Dependency constraints identified with mitigation plans (retry, circuit breaker, fallback)
- [ ] Burn-rate alerting configured with multi-window approach (not naive thresholds)
- [ ] Four severity tiers defined (P1: 14.4x, P2: 6x, P3: 3x, P4: 1x)
- [ ] SLA terms drafted if external customers exist (targets lower than SLOs)
- [ ] SLA exclusions and remedies documented
- [ ] Downstream phase linkage: Phase 3 (instrument SLIs), Phase 6 (deploy dashboards), Phase 7 (operational SLO management)

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
