---
name: Canary Verification
description: Automated canary deployment promotion gates using error rate, latency, and business metric thresholds
---

# Canary Verification Skill

**Purpose**: Implement automated canary deployment verification that progressively shifts traffic to a new release while continuously monitoring error rates, latency percentiles, and business metrics. If thresholds are breached, the canary is automatically rolled back. This prevents bad deployments from reaching 100% of users.

## TRIGGER COMMANDS

```text
"Canary deployment"
"Progressive rollout"
"Automated rollout verification"
"Set up canary releases"
"Using canary_verification skill: configure canary for [service]"
```

## When to Use
- When deploying high-risk changes to production (new features, major refactors)
- When transitioning from all-at-once to progressive deployment strategies
- When compliance requires demonstrable deployment safety controls
- For ML model deployments where behavior changes need gradual validation

---

## PROCESS

### Step 1: Choose Canary Strategy

| Strategy | Complexity | Best For | Requirement |
|----------|-----------|----------|-------------|
| Feature-flag canary | Low | Any infrastructure | Feature flag system |
| Weighted routing (K8s) | Medium | Kubernetes clusters | Istio / Linkerd / Nginx Ingress |
| Blue-green with canary | Medium | PaaS (Railway, Render) | Two deployment targets |
| CDN-level split | Low | Static frontends | Cloudflare Workers / Vercel Edge Config |

### Step 2: Define Canary Thresholds

Create a canary configuration that defines pass/fail criteria:

```yaml
# canary-config.yml
canary:
  stages:
    - name: "canary-5"
      weight: 5
      duration: "10m"
      thresholds:
        error_rate_max: 0.01        # 1% error rate ceiling
        latency_p99_max_ms: 500     # 500ms p99 latency ceiling
        latency_p99_delta_max: 1.2  # No more than 20% slower than baseline

    - name: "canary-25"
      weight: 25
      duration: "15m"
      thresholds:
        error_rate_max: 0.005
        latency_p99_max_ms: 500
        latency_p99_delta_max: 1.15

    - name: "canary-50"
      weight: 50
      duration: "20m"
      thresholds:
        error_rate_max: 0.005
        latency_p99_max_ms: 500
        latency_p99_delta_max: 1.1

    - name: "full-rollout"
      weight: 100
      duration: "0m"

  rollback:
    on_failure: automatic
    cooldown_minutes: 30
```

### Step 3: Implement Feature-Flag Canary (Simple Path)

For teams without Kubernetes, use feature flags for canary:

```typescript
// canary.service.ts
@Injectable()
export class CanaryService {
  constructor(
    private readonly redis: RedisService,
    private readonly metrics: MetricsService,
  ) {}

  async isCanaryEnabled(userId: string, feature: string): Promise<boolean> {
    const canaryConfig = await this.redis.get(`canary:${feature}`);
    if (!canaryConfig) return false;

    const config = JSON.parse(canaryConfig);
    const bucket = this.hashToBucket(userId, 100);
    return bucket < config.weightPercent;
  }

  async recordCanaryMetric(feature: string, variant: 'canary' | 'stable', metric: {
    latencyMs: number;
    isError: boolean;
  }): Promise<void> {
    await this.metrics.record(`canary.${feature}.${variant}`, metric);
  }

  private hashToBucket(userId: string, buckets: number): number {
    let hash = 0;
    for (let i = 0; i < userId.length; i++) {
      hash = ((hash << 5) - hash) + userId.charCodeAt(i);
      hash |= 0;
    }
    return Math.abs(hash) % buckets;
  }
}
```

### Step 4: Create Canary Verification Script

```typescript
// scripts/canary-verify.ts
interface CanaryMetrics {
  errorRate: number;
  latencyP99Ms: number;
  requestCount: number;
}

interface StageThresholds {
  error_rate_max: number;
  latency_p99_max_ms: number;
  latency_p99_delta_max: number;
}

async function verifyCanaryStage(
  canaryMetrics: CanaryMetrics,
  stableMetrics: CanaryMetrics,
  thresholds: StageThresholds,
): Promise<{ pass: boolean; reasons: string[] }> {
  const reasons: string[] = [];

  if (canaryMetrics.errorRate > thresholds.error_rate_max) {
    reasons.push(
      `Error rate ${(canaryMetrics.errorRate * 100).toFixed(2)}% exceeds max ${(thresholds.error_rate_max * 100).toFixed(2)}%`
    );
  }

  if (canaryMetrics.latencyP99Ms > thresholds.latency_p99_max_ms) {
    reasons.push(
      `Latency p99 ${canaryMetrics.latencyP99Ms}ms exceeds max ${thresholds.latency_p99_max_ms}ms`
    );
  }

  const latencyDelta = canaryMetrics.latencyP99Ms / stableMetrics.latencyP99Ms;
  if (latencyDelta > thresholds.latency_p99_delta_max) {
    reasons.push(
      `Latency delta ${latencyDelta.toFixed(2)}x exceeds max ${thresholds.latency_p99_delta_max}x`
    );
  }

  if (canaryMetrics.requestCount < 100) {
    reasons.push(
      `Insufficient sample size: ${canaryMetrics.requestCount} requests (minimum 100)`
    );
  }

  return { pass: reasons.length === 0, reasons };
}
```

### Step 5: GitHub Actions Canary Workflow

```yaml
# .github/workflows/canary-deploy.yml
name: Canary Deploy

on:
  workflow_dispatch:
    inputs:
      service:
        description: 'Service to deploy'
        required: true
        type: choice
        options: [backend, frontend]

jobs:
  canary-5:
    name: "Canary 5%"
    runs-on: ubuntu-latest
    environment: canary
    steps:
      - uses: actions/checkout@v4

      - name: Deploy canary (5% traffic)
        run: |
          # Set feature flag to route 5% of traffic to canary
          curl -sf -X PUT "${{ secrets.API_URL }}/admin/canary" \
            -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{"feature":"${{ inputs.service }}-v${{ github.sha }}","weightPercent":5}'

      - name: Wait for metric collection
        run: sleep 600  # 10 minutes

      - name: Verify canary metrics
        id: verify
        run: |
          RESULT=$(curl -sf "${{ secrets.API_URL }}/admin/canary/verify" \
            -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}")
          PASS=$(echo "$RESULT" | jq -r '.pass')
          echo "pass=$PASS" >> "$GITHUB_OUTPUT"
          echo "$RESULT" | jq .
          if [ "$PASS" != "true" ]; then exit 1; fi

      - name: Auto-rollback on failure
        if: failure()
        run: |
          curl -sf -X DELETE "${{ secrets.API_URL }}/admin/canary" \
            -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}"
          curl -X POST "${{ secrets.SLACK_WEBHOOK }}" \
            -d '{"text":"Canary FAILED at 5% for ${{ inputs.service }}. Auto-rolled back."}'

  promote-100:
    name: "Promote to 100%"
    needs: canary-5
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Full rollout
        run: |
          curl -sf -X PUT "${{ secrets.API_URL }}/admin/canary" \
            -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{"feature":"${{ inputs.service }}-v${{ github.sha }}","weightPercent":100}'

      - name: Clean up canary flag
        run: |
          # Schedule flag removal after 24h observation
          echo "Canary promoted. Remove flag after 24h observation window."
```

### Step 6: Kubernetes Canary with Istio (Advanced)

```yaml
# k8s/canary-virtualservice.yml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: backend-canary
spec:
  hosts:
    - backend.default.svc.cluster.local
  http:
    - route:
        - destination:
            host: backend-stable
          weight: 95
        - destination:
            host: backend-canary
          weight: 5
```

---

## CHECKLIST

- [ ] Canary strategy selected (feature-flag, K8s weighted, or CDN-level)
- [ ] Canary thresholds defined for error rate, latency p99, and latency delta
- [ ] Multi-stage progression configured (5% -> 25% -> 50% -> 100%)
- [ ] Automatic rollback triggers on threshold breach
- [ ] Minimum sample size enforced before making promotion decisions
- [ ] Slack/email alerts fire on canary failure and rollback
- [ ] Canary metrics distinguish canary traffic from stable traffic
- [ ] Consistent user bucketing ensures same user stays in same variant
- [ ] Observation window defined per stage (minimum 10 minutes at 5%)
- [ ] Rollback cooldown period prevents rapid re-deploy after failure
- [ ] Post-promotion monitoring continues for 24h observation window

---

*Skill Version: 1.0 | Created: February 2026*
