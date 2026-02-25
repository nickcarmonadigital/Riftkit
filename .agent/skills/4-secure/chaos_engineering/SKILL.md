---
name: Chaos Engineering
description: Scheduled failure injection testing with gameday runbooks to validate system resilience before production
---

# Chaos Engineering Skill

**Purpose**: Proactively discover system weaknesses by injecting controlled failures before they happen in production. This skill defines a chaos engineering protocol covering failure injection scenarios, gameday runbooks, chaos test result analysis, and DR runbook validation. Phase 4 runs pre-production chaos experiments; Phase 7 extends to scheduled production experiments.

## TRIGGER COMMANDS

```text
"Chaos test"
"Failure injection test"
"Resilience testing"
"Gameday"
"What happens when [dependency] goes down?"
```

## When to Use
- Validating that circuit breakers, retries, and fallbacks work under real failure conditions
- Running a pre-production gameday before a major release
- Verifying disaster recovery runbooks actually work
- Testing graceful degradation when a dependency becomes unavailable
- Building confidence in system resilience after implementing resiliency patterns

---

## PROCESS

### Step 1: Define Chaos Experiment Hypothesis

Every chaos experiment follows the scientific method:

```markdown
## Chaos Experiment Card

**Experiment**: [Name]
**Date**: [Date]
**Hypothesis**: When [failure condition], the system should [expected behavior],
                and users should experience [expected user impact].
**Blast Radius**: [Scope -- single service, single AZ, full region]
**Abort Conditions**: [When to stop -- error rate > X%, latency > Yms, data loss]
**Rollback Plan**: [How to undo the injection]
**Steady State Metrics**:
  - Error rate: < 0.1%
  - p99 latency: < 500ms
  - Throughput: > 100 req/s
```

### Step 2: Failure Injection Scenarios

Prioritize experiments by likelihood and impact:

| Scenario | Tool | Blast Radius | Priority |
|----------|------|-------------|----------|
| Container crash/restart | Docker kill, K8s pod delete | Single service | P0 |
| Network latency injection | tc netem, Toxiproxy | Between services | P0 |
| Database connection exhaustion | Toxiproxy, connection limit | Data layer | P0 |
| Dependency timeout | Toxiproxy, mock delay | External services | P1 |
| Disk full | fallocate, dd | Single node | P1 |
| DNS failure | iptables, CoreDNS mutation | Service discovery | P1 |
| Memory pressure | stress-ng | Single container | P2 |
| Clock skew | chrony manipulation | Distributed systems | P2 |

### Step 3: Set Up Chaos Tools

**Toxiproxy (dependency failure simulation):**

```bash
# Install Toxiproxy
docker run -d --name toxiproxy -p 8474:8474 ghcr.io/shopify/toxiproxy:latest

# Create proxy for database
toxiproxy-cli create postgres -l 0.0.0.0:5433 -u postgres:5432

# Add latency toxic (simulate slow DB)
toxiproxy-cli toxic add postgres -t latency -a latency=2000 -a jitter=500

# Simulate connection refused (DB down)
toxiproxy-cli toggle postgres

# Remove toxic (restore normal)
toxiproxy-cli toxic remove postgres -t latency
```

**Docker-based failure injection:**

```bash
# Kill a container (test restart resilience)
docker kill app-service

# Simulate network partition
docker network disconnect app-network app-service
sleep 30
docker network connect app-network app-service

# Simulate resource constraints
docker update --memory=64m --cpus=0.25 app-service
```

**Kubernetes chaos (using kubectl):**

```bash
# Delete a pod (test self-healing)
kubectl delete pod app-deployment-xxxxx -n production

# Simulate node drain
kubectl drain node-1 --grace-period=30 --ignore-daemonsets

# Network policy to block traffic between services
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: chaos-block-db
spec:
  podSelector:
    matchLabels:
      app: api-service
  policyTypes:
    - Egress
  egress:
    - to:
        - podSelector:
            matchLabels:
              app: NOT-database
EOF
```

### Step 4: Gameday Runbook

Execute chaos experiments as a structured team exercise:

```markdown
## Gameday Runbook

### Pre-Gameday (1 week before)
- [ ] Experiments documented with hypothesis and abort conditions
- [ ] Monitoring dashboards prepared (error rate, latency, throughput)
- [ ] All participants identified (facilitator, operator, observer, oncall)
- [ ] Rollback procedures tested in staging
- [ ] Incident channel created (#gameday-YYYY-MM-DD)

### During Gameday
- [ ] Announce gameday start in incident channel
- [ ] Verify steady-state metrics baseline (record for 10 minutes)
- [ ] Execute experiments one at a time with 15-min gaps
- [ ] For each experiment:
  1. Announce: "Injecting [failure] in 60 seconds"
  2. Record baseline metrics screenshot
  3. Inject failure
  4. Observe for 5 minutes (or until abort condition)
  5. Record failure metrics screenshot
  6. Remove injection
  7. Verify recovery to steady state
  8. Document: hypothesis confirmed/denied, surprises
- [ ] Abort if any abort condition is triggered

### Post-Gameday (within 48 hours)
- [ ] Compile experiment results into report
- [ ] File tickets for unexpected failures
- [ ] Update DR runbooks with learnings
- [ ] Schedule follow-up for unresolved findings
```

### Step 5: Chaos Test Automation in CI

Run lightweight chaos tests in pre-production CI:

```yaml
# .github/workflows/chaos-tests.yml
name: Chaos Tests
on:
  schedule:
    - cron: '0 3 * * 3'  # Weekly Wednesday 3am
  workflow_dispatch:

jobs:
  chaos:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
        ports: ['5432:5432']
      toxiproxy:
        image: ghcr.io/shopify/toxiproxy:latest
        ports: ['8474:8474']

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - name: Configure Toxiproxy
        run: |
          curl -s -X POST http://localhost:8474/proxies \
            -d '{"name":"postgres","listen":"0.0.0.0:5433","upstream":"postgres:5432"}'

      - name: Run resilience tests
        run: npm run test:chaos
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5433/test

      - name: Inject latency and retest
        run: |
          curl -s -X POST http://localhost:8474/proxies/postgres/toxics \
            -d '{"type":"latency","attributes":{"latency":3000}}'
          npm run test:chaos:degraded

      - name: Upload chaos report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: chaos-report
          path: reports/chaos/
```

### Step 6: Analyze Results and Update Runbooks

**Chaos Test Result Template:**

```markdown
## Chaos Experiment Results

| Experiment | Hypothesis | Result | Action Items |
|-----------|-----------|--------|-------------|
| DB connection pool exhaustion | Circuit breaker trips in < 5s | CONFIRMED | None |
| Redis timeout (3s latency) | Cache fallback to DB | DENIED | Add fallback handler |
| API container kill | K8s restarts in < 30s | CONFIRMED | None |
| DNS failure | Graceful degradation | DENIED | Add DNS cache/retry |

### Findings Requiring Action
1. **Redis fallback missing**: When Redis latency exceeds 2s, the application throws
   unhandled timeout errors instead of falling back to database queries.
   - **Ticket**: PROJ-1234
   - **Priority**: High
   - **Owner**: [Name]

### DR Runbook Updates
- Updated RTO from 5min to 2min based on observed recovery time
- Added DNS failure recovery procedure
```

---

## CHECKLIST

- [ ] Chaos experiment cards documented with hypothesis and abort conditions
- [ ] Toxiproxy or equivalent failure injection tool configured
- [ ] Container crash/restart resilience validated
- [ ] Network latency injection tested (circuit breaker triggers correctly)
- [ ] Database connection exhaustion scenario tested
- [ ] Dependency timeout scenario tested (fallback works)
- [ ] Gameday runbook prepared and pre-gameday checklist completed
- [ ] At least one gameday executed with documented results
- [ ] Action items filed as tickets for denied hypotheses
- [ ] DR runbooks updated with gameday learnings
- [ ] Lightweight chaos tests automated in weekly CI schedule
- [ ] Chaos test results stored as resilience evidence

*Skill Version: 1.0 | Created: February 2026*
