---
name: Load Testing
description: k6-based load testing for beta with script development, acceptance criteria, CI integration, and capacity baseline establishment
---

# Load Testing Skill

**Purpose**: Establish your application's performance baseline and capacity limits before GA launch. This skill covers k6 load test script development, acceptance criteria definition, CI pipeline integration, and producing the capacity report consumed by `beta_graduation_criteria`. You cannot set realistic SLAs without knowing where your system breaks.

## TRIGGER COMMANDS

```text
"Load test for [service]"
"Establish capacity baseline"
"Run k6 against beta"
"Performance baseline for [project]"
"Using load_testing skill: test [endpoint/service]"
```

## When to Use

- Approaching beta graduation and need performance data for the readiness scorecard
- After significant architecture changes that could affect throughput
- Before a marketing campaign or event expected to drive traffic spikes
- Establishing SLA targets for `beta_sla_definition` skill

---

## PROCESS

### Step 1: Define Acceptance Criteria

Set pass/fail thresholds before writing test scripts. These feed directly into the GA Readiness Scorecard.

| Metric | Target | Failure Threshold | Notes |
|--------|--------|-------------------|-------|
| p95 response time | < 500ms | > 800ms | Measured at the API gateway |
| p99 response time | < 2000ms | > 3000ms | Tail latency matters |
| Error rate | < 0.1% | > 1% | 5xx responses only |
| Throughput | >= 100 RPS | < 50 RPS | Sustained for 10 minutes |
| Time to first byte | < 200ms | > 500ms | Frontend initial load |

### Step 2: Install and Configure k6

```bash
# macOS
brew install k6

# Linux
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg \
  --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D68
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update && sudo apt-get install k6

# Docker
docker run --rm -i grafana/k6 run -
```

### Step 3: Write Load Test Scripts

**API Load Test** (core scenario):

```javascript
// tests/load/api-load.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

const errorRate = new Rate('errors');
const apiDuration = new Trend('api_duration');

export const options = {
  stages: [
    { duration: '2m', target: 20 },   // Ramp up to 20 VUs
    { duration: '5m', target: 50 },   // Ramp up to 50 VUs
    { duration: '10m', target: 50 },  // Sustain 50 VUs
    { duration: '5m', target: 100 },  // Push to 100 VUs
    { duration: '5m', target: 100 },  // Sustain 100 VUs
    { duration: '3m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<2000'],
    errors: ['rate<0.01'],
    http_req_failed: ['rate<0.01'],
  },
};

const BASE_URL = __ENV.BASE_URL || 'https://api.yourapp.com';
const API_TOKEN = __ENV.API_TOKEN;

export default function () {
  const headers = { Authorization: `Bearer ${API_TOKEN}`, 'Content-Type': 'application/json' };

  // Scenario 1: List resources (GET)
  const listRes = http.get(`${BASE_URL}/api/items`, { headers });
  check(listRes, { 'list status 200': (r) => r.status === 200 });
  errorRate.add(listRes.status >= 400);
  apiDuration.add(listRes.timings.duration);

  sleep(1);

  // Scenario 2: Create resource (POST)
  const createRes = http.post(`${BASE_URL}/api/items`, JSON.stringify({
    name: `load-test-${Date.now()}`,
    description: 'Created by k6 load test',
  }), { headers });
  check(createRes, { 'create status 201': (r) => r.status === 201 });
  errorRate.add(createRes.status >= 400);

  sleep(2);
}
```

**Spike Test** (sudden traffic surge):

```javascript
// tests/load/spike-test.js
export const options = {
  stages: [
    { duration: '1m', target: 10 },   // Normal load
    { duration: '30s', target: 200 },  // Spike to 200 VUs
    { duration: '3m', target: 200 },   // Sustain spike
    { duration: '30s', target: 10 },   // Drop back to normal
    { duration: '2m', target: 10 },    // Recovery observation
  ],
  thresholds: {
    http_req_duration: ['p(95)<1000'],  // Relaxed during spike
    http_req_failed: ['rate<0.05'],     // Allow 5% errors during spike
  },
};
```

**Soak Test** (long-running stability):

```javascript
// tests/load/soak-test.js
export const options = {
  stages: [
    { duration: '5m', target: 30 },    // Ramp up
    { duration: '4h', target: 30 },    // Sustain for 4 hours
    { duration: '5m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};
```

### Step 4: Run Tests and Capture Baselines

```bash
# Standard load test
k6 run --env BASE_URL=https://api-beta.yourapp.com \
       --env API_TOKEN=$LOAD_TEST_TOKEN \
       --out json=results/load-test.json \
       tests/load/api-load.js

# Generate HTML report (requires k6-reporter extension)
k6 run --out json=results/load-test.json tests/load/api-load.js
```

**Baseline Capture Template**:

```markdown
# Load Test Baseline - [Date]

## Environment
- Target: [URL]
- Infrastructure: [instance type, replicas, DB size]
- Test: [script name, duration, max VUs]

## Results
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| p50 latency | 120ms | -- | Baseline |
| p95 latency | 380ms | < 500ms | PASS |
| p99 latency | 890ms | < 2000ms | PASS |
| Max throughput | 142 RPS | >= 100 RPS | PASS |
| Error rate | 0.02% | < 0.1% | PASS |
| Breaking point | 180 VUs / 250 RPS | -- | Baseline |

## Bottleneck Identified
- [Description of what fails first and at what load level]

## Recommendations
- [Actions to improve capacity before GA]
```

### Step 5: CI Integration

Add load tests to your CI pipeline. Run on every release candidate, not on every commit.

```yaml
# .github/workflows/load-test.yml
name: Load Test
on:
  workflow_dispatch:
  push:
    tags: ['rc-*']  # Run on release candidates only

jobs:
  load-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: grafana/k6-action@v0.3.1
        with:
          filename: tests/load/api-load.js
          flags: --env BASE_URL=${{ secrets.STAGING_URL }} --env API_TOKEN=${{ secrets.LOAD_TEST_TOKEN }}
      - uses: actions/upload-artifact@v4
        with:
          name: load-test-results
          path: results/
```

---

## CHECKLIST

- [ ] Acceptance criteria defined with specific numeric thresholds
- [ ] k6 installed and configured in the project
- [ ] API load test script covers critical user journeys
- [ ] Spike test script validates behavior under sudden traffic surges
- [ ] Soak test script validates long-running stability (4+ hours)
- [ ] Baseline captured with current infrastructure configuration
- [ ] Breaking point identified (what fails first and at what load)
- [ ] Bottleneck documented with remediation recommendations
- [ ] Load tests integrated into CI for release candidates
- [ ] Results artifact produced for `beta_graduation_criteria` consumption
- [ ] Load test results inform `beta_sla_definition` targets

---

*Skill Version: 1.0 | Created: February 2026*
