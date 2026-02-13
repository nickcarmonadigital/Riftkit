---
name: performance_testing
description: k6 load tests, Lighthouse CI, and Node.js performance profiling
---

# Performance Testing Skill

**Purpose**: Validate application performance under load using k6, audit frontend performance with Lighthouse CI, and detect memory leaks and slow database queries before they reach production.

## 🎯 TRIGGER COMMANDS

```text
"load test this API"
"performance test the endpoints"
"benchmark API response times"
"run lighthouse audit"
"check for memory leaks"
"Using performance_testing skill: test [target]"
```

## 🛠️ k6 Setup & Installation

```bash
# macOS
brew install k6

# Linux (Debian/Ubuntu)
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg \
  --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D68
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update && sudo apt-get install k6

# Docker
docker run --rm -i grafana/k6 run - < script.js

# Verify
k6 version
```

## 📊 k6 Test Script Structure

### Smoke Test (Sanity Check — 1 User)

```typescript
// tests/performance/smoke.ts
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 1,
  duration: '30s',
  thresholds: {
    http_req_duration: ['p(95)<500'],   // 95th percentile under 500ms
    http_req_failed: ['rate<0.01'],      // less than 1% errors
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

export default function () {
  const res = http.get(`${BASE_URL}/api/health`);

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
    'body contains success': (r) => {
      const body = JSON.parse(r.body as string);
      return body.success === true;
    },
  });

  sleep(1);
}
```

### Load Test (Normal Traffic — 50 Users)

```typescript
// tests/performance/load.ts
import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { SharedArray } from 'k6/data';

export const options = {
  stages: [
    { duration: '2m', target: 20 },   // Ramp up to 20 users over 2 minutes
    { duration: '5m', target: 50 },   // Hold at 50 users for 5 minutes
    { duration: '2m', target: 0 },    // Ramp down to 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    http_req_failed: ['rate<0.01'],
    http_reqs: ['rate>100'],           // At least 100 req/s throughput
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

// Pre-generated auth tokens (created before test run)
const tokens = new SharedArray('tokens', function () {
  return JSON.parse(open('./test-tokens.json'));
});

export default function () {
  const token = tokens[Math.floor(Math.random() * tokens.length)];
  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  };

  group('GET /api/documents', () => {
    const res = http.get(`${BASE_URL}/api/documents`, { headers });

    check(res, {
      'list documents 200': (r) => r.status === 200,
      'has data array': (r) => {
        const body = JSON.parse(r.body as string);
        return Array.isArray(body.data);
      },
    });
  });

  group('POST /api/documents', () => {
    const payload = JSON.stringify({
      title: `Load Test Doc ${Date.now()}`,
      content: 'Performance test content',
    });

    const res = http.post(`${BASE_URL}/api/documents`, payload, { headers });

    check(res, {
      'create document 201': (r) => r.status === 201,
      'returns id': (r) => {
        const body = JSON.parse(r.body as string);
        return body.data?.id !== undefined;
      },
    });
  });

  sleep(Math.random() * 3 + 1); // Random 1-4 second think time
}
```

### Stress Test (Breaking Point — 200 Users)

```typescript
// tests/performance/stress.ts
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 50 },
    { duration: '2m', target: 100 },
    { duration: '2m', target: 200 },   // Push to breaking point
    { duration: '2m', target: 200 },   // Hold at max
    { duration: '2m', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<2000'],  // More relaxed under stress
    http_req_failed: ['rate<0.05'],      // Allow up to 5% errors under stress
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

export default function () {
  const res = http.get(`${BASE_URL}/api/documents`, {
    headers: { 'Authorization': `Bearer ${__ENV.TEST_TOKEN}` },
  });

  check(res, {
    'status is not 500': (r) => r.status !== 500,
    'response under 2s': (r) => r.timings.duration < 2000,
  });

  sleep(1);
}
```

### Spike Test (Sudden Burst)

```typescript
// tests/performance/spike.ts
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 5 },    // Normal baseline
    { duration: '10s', target: 200 },   // Sudden spike
    { duration: '1m', target: 200 },    // Hold the spike
    { duration: '10s', target: 5 },     // Drop back
    { duration: '1m', target: 5 },      // Recovery period
    { duration: '30s', target: 0 },     // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'],
    http_req_failed: ['rate<0.10'],      // 10% error rate allowed during spike
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';

export default function () {
  const res = http.get(`${BASE_URL}/api/health`);
  check(res, { 'alive': (r) => r.status === 200 });
  sleep(0.5);
}
```

## 🔑 Testing Authenticated Endpoints with k6

```typescript
// tests/performance/helpers/auth.ts
import http from 'k6/http';

export function getAuthToken(baseUrl: string, email: string, password: string): string {
  const res = http.post(`${baseUrl}/api/auth/login`, JSON.stringify({
    email,
    password,
  }), {
    headers: { 'Content-Type': 'application/json' },
  });

  if (res.status !== 200) {
    throw new Error(`Auth failed: ${res.status} ${res.body}`);
  }

  const body = JSON.parse(res.body as string);
  return body.data.accessToken;
}

// Usage in setup function (runs once before all VUs)
export function setup(): { token: string } {
  const token = getAuthToken(
    __ENV.BASE_URL || 'http://localhost:3000',
    'loadtest@example.com',
    'LoadTestPass123!',
  );
  return { token };
}

export default function (data: { token: string }) {
  const headers = {
    'Authorization': `Bearer ${data.token}`,
    'Content-Type': 'application/json',
  };

  http.get(`${__ENV.BASE_URL}/api/documents`, { headers });
}
```

## 📏 Performance Budgets

| Metric | Target | Critical | Measurement |
|--------|--------|----------|-------------|
| **p95 Response Time** | < 500ms | < 1000ms | k6 `http_req_duration` |
| **p99 Response Time** | < 1000ms | < 2000ms | k6 `http_req_duration` |
| **Error Rate** | < 1% | < 5% | k6 `http_req_failed` |
| **Throughput** | > 100 req/s | > 50 req/s | k6 `http_reqs` |
| **TTFB** | < 200ms | < 400ms | Lighthouse / k6 |
| **FCP** | < 1.8s | < 3.0s | Lighthouse |
| **LCP** | < 2.5s | < 4.0s | Lighthouse |
| **CLS** | < 0.1 | < 0.25 | Lighthouse |
| **INP** | < 200ms | < 500ms | Lighthouse / Chrome UX |
| **Bundle Size (JS)** | < 300KB gzip | < 500KB gzip | Build output |
| **Bundle Size (CSS)** | < 50KB gzip | < 100KB gzip | Build output |

## 🏗️ Lighthouse CI Setup

### Installation & Configuration

```bash
npm install -D @lhci/cli
```

```typescript
// lighthouserc.ts (or .lighthouserc.json)
export default {
  ci: {
    collect: {
      url: [
        'http://localhost:5173/',
        'http://localhost:5173/login',
        'http://localhost:5173/dashboard',
      ],
      startServerCommand: 'npm run preview',
      startServerReadyPattern: 'Local:',
      numberOfRuns: 3,
      settings: {
        preset: 'desktop',
        // Use 'mobile' for mobile testing
      },
    },
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'categories:accessibility': ['error', { minScore: 0.9 }],
        'categories:best-practices': ['warn', { minScore: 0.9 }],
        'categories:seo': ['warn', { minScore: 0.8 }],
        'first-contentful-paint': ['error', { maxNumericValue: 1800 }],
        'largest-contentful-paint': ['error', { maxNumericValue: 2500 }],
        'cumulative-layout-shift': ['error', { maxNumericValue: 0.1 }],
        'total-blocking-time': ['error', { maxNumericValue: 300 }],
      },
    },
    upload: {
      target: 'temporary-public-storage', // or 'lhci' for self-hosted
    },
  },
};
```

### Running Lighthouse CI

```bash
# Build the frontend first
npm run build

# Run LHCI
npx lhci autorun

# Or run individual steps
npx lhci collect
npx lhci assert
npx lhci upload
```

## 📦 Bundle Analysis

### Vite Bundle Visualizer

```bash
# Install
npm install -D rollup-plugin-visualizer

# Add to vite.config.ts
import { visualizer } from 'rollup-plugin-visualizer';

export default defineConfig({
  plugins: [
    react(),
    visualizer({
      open: true,
      filename: 'dist/bundle-stats.html',
      gzipSize: true,
      brotliSize: true,
    }),
  ],
});
```

```bash
# Run build and open visualizer
npm run build
# Opens bundle-stats.html automatically
```

### Bundle Size Check Script

```typescript
// scripts/check-bundle-size.ts
import { readdirSync, statSync } from 'fs';
import { join } from 'path';
import { gzipSync } from 'zlib';
import { readFileSync } from 'fs';

const DIST_DIR = 'dist/assets';
const MAX_JS_GZIP_KB = 300;
const MAX_CSS_GZIP_KB = 50;

function getGzipSize(filePath: string): number {
  const content = readFileSync(filePath);
  const gzipped = gzipSync(content);
  return gzipped.length / 1024; // KB
}

const files = readdirSync(DIST_DIR);
let totalJsKb = 0;
let totalCssKb = 0;

for (const file of files) {
  const filePath = join(DIST_DIR, file);
  const gzipKb = getGzipSize(filePath);

  if (file.endsWith('.js')) {
    totalJsKb += gzipKb;
    console.log(`  JS: ${file} — ${gzipKb.toFixed(1)} KB gzip`);
  } else if (file.endsWith('.css')) {
    totalCssKb += gzipKb;
    console.log(`  CSS: ${file} — ${gzipKb.toFixed(1)} KB gzip`);
  }
}

console.log(`\nTotal JS:  ${totalJsKb.toFixed(1)} KB gzip (budget: ${MAX_JS_GZIP_KB} KB)`);
console.log(`Total CSS: ${totalCssKb.toFixed(1)} KB gzip (budget: ${MAX_CSS_GZIP_KB} KB)`);

if (totalJsKb > MAX_JS_GZIP_KB) {
  console.error(`\nFAIL: JS bundle exceeds budget by ${(totalJsKb - MAX_JS_GZIP_KB).toFixed(1)} KB`);
  process.exit(1);
}
if (totalCssKb > MAX_CSS_GZIP_KB) {
  console.error(`\nFAIL: CSS bundle exceeds budget by ${(totalCssKb - MAX_CSS_GZIP_KB).toFixed(1)} KB`);
  process.exit(1);
}

console.log('\nPASS: Bundle sizes within budget');
```

## 🗄️ Database Query Performance

### EXPLAIN ANALYZE for Slow Queries

```sql
-- Find slow queries in PostgreSQL
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Analyze a specific query
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT d.* FROM documents d
WHERE d.org_id = 'org-uuid'
AND d.created_at > NOW() - INTERVAL '30 days'
ORDER BY d.created_at DESC
LIMIT 50;
```

### Prisma Query Logging

```typescript
// Enable query logging in development/test
const prisma = new PrismaClient({
  log: [
    { emit: 'event', level: 'query' },
    { emit: 'stdout', level: 'warn' },
    { emit: 'stdout', level: 'error' },
  ],
});

prisma.$on('query', (e) => {
  if (e.duration > 100) { // Log queries taking > 100ms
    console.warn(`Slow query (${e.duration}ms): ${e.query}`);
  }
});
```

### Missing Index Detection

```sql
-- Find tables with sequential scans (may need indexes)
SELECT relname AS table,
       seq_scan,
       idx_scan,
       CASE WHEN seq_scan + idx_scan > 0
            THEN round(100.0 * idx_scan / (seq_scan + idx_scan), 1)
            ELSE 0
       END AS idx_usage_pct
FROM pg_stat_user_tables
WHERE seq_scan > 1000
ORDER BY seq_scan DESC;
```

## 🧠 Memory Leak Detection

### Node.js Heap Profiling

```typescript
// Start the app with inspect flag
// node --inspect dist/main.js

// Or add to package.json scripts:
// "start:profile": "node --inspect --max-old-space-size=512 dist/main.js"
```

### Programmatic Heap Snapshot

```typescript
// utils/heap-check.ts
import v8 from 'v8';
import fs from 'fs';

export function takeHeapSnapshot(label: string): void {
  const snapshotStream = v8.writeHeapSnapshot();
  console.log(`Heap snapshot written: ${snapshotStream} (${label})`);
}

// Memory usage monitoring middleware
export function memoryMonitor() {
  return (req: any, res: any, next: any) => {
    const usage = process.memoryUsage();
    const heapUsedMB = Math.round(usage.heapUsed / 1024 / 1024);
    const heapTotalMB = Math.round(usage.heapTotal / 1024 / 1024);

    if (heapUsedMB > 400) { // Alert if heap > 400MB
      console.warn(`HIGH MEMORY: ${heapUsedMB}MB / ${heapTotalMB}MB`);
    }

    next();
  };
}
```

### k6 Memory Leak Detection Pattern

```typescript
// Run a sustained load test and monitor memory
// tests/performance/memory-leak.ts
import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '30m', // Long duration to detect leaks
  thresholds: {
    http_req_duration: ['p(95)<1000'],
    http_req_failed: ['rate<0.01'],
  },
};

export default function () {
  http.get(`${__ENV.BASE_URL}/api/documents`, {
    headers: { 'Authorization': `Bearer ${__ENV.TEST_TOKEN}` },
  });
  sleep(1);
}

// While this runs, monitor the server process:
// watch -n 5 'curl -s http://localhost:3000/api/health | jq .memoryUsage'
// Memory should stay flat. If it climbs steadily, there is a leak.
```

## 📈 Key Web Vitals Reference

| Metric | Full Name | Good | Needs Work | Poor |
|--------|-----------|------|------------|------|
| **TTFB** | Time to First Byte | < 200ms | 200-600ms | > 600ms |
| **FCP** | First Contentful Paint | < 1.8s | 1.8-3.0s | > 3.0s |
| **LCP** | Largest Contentful Paint | < 2.5s | 2.5-4.0s | > 4.0s |
| **CLS** | Cumulative Layout Shift | < 0.1 | 0.1-0.25 | > 0.25 |
| **INP** | Interaction to Next Paint | < 200ms | 200-500ms | > 500ms |
| **TBT** | Total Blocking Time | < 200ms | 200-600ms | > 600ms |

> [!TIP]
> Focus on LCP, CLS, and INP — these are the Core Web Vitals that Google uses for search ranking. TTFB and FCP are important diagnostic metrics but do not directly affect rankings.

## 🔄 CI Integration

### k6 in GitHub Actions

```yaml
# .github/workflows/performance.yml
name: Performance Tests
on:
  pull_request:
    branches: [main]

jobs:
  load-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: zenith_test
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports: ['5432:5432']

    steps:
      - uses: actions/checkout@v4

      - name: Setup k6
        uses: grafana/setup-k6-action@v1

      - name: Start server
        run: |
          npm ci
          npm run build
          npm run start:test &
          sleep 10

      - name: Run smoke test
        run: k6 run tests/performance/smoke.ts --env BASE_URL=http://localhost:3000

      - name: Run load test
        run: k6 run tests/performance/load.ts --env BASE_URL=http://localhost:3000
```

### Lighthouse CI in GitHub Actions

```yaml
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - run: npm ci
      - run: npm run build

      - name: Run Lighthouse CI
        run: |
          npm install -g @lhci/cli
          lhci autorun
        env:
          LHCI_GITHUB_APP_TOKEN: ${{ secrets.LHCI_GITHUB_APP_TOKEN }}
```

> [!WARNING]
> Never run load tests against production without explicit approval. Always test against a staging or dedicated performance environment. Even smoke tests can trigger rate limiters or alert systems.

## ✅ EXIT CHECKLIST

- [ ] k6 smoke test passes all thresholds (p95 < 500ms, error rate < 1%)
- [ ] k6 load test at target concurrency passes (50 VUs sustained)
- [ ] Stress test identifies the breaking point and it is documented
- [ ] Lighthouse Performance score >= 90 on all critical pages
- [ ] Lighthouse Accessibility score >= 90
- [ ] No memory leaks detected (heap stable over 30-minute sustained load)
- [ ] Bundle size within budget (JS < 300KB gzip, CSS < 50KB gzip)
- [ ] No database queries > 100ms identified (or optimized with indexes)
- [ ] Core Web Vitals all in "Good" range (LCP < 2.5s, CLS < 0.1, INP < 200ms)
- [ ] Performance tests integrated into CI pipeline
- [ ] Results documented with baseline numbers for future comparison

*Skill Version: 1.0 | Created: February 2026*
