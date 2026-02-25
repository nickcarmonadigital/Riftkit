---
name: Deployment Verification
description: Automated post-deployment verification with health checks, smoke tests, and metric comparison
---

# Deployment Verification Skill

**Purpose**: Automate the validation of every production deployment by running health endpoint polling, smoke test suites, metric comparisons, and dependency connectivity checks. This ensures broken deployments are caught within minutes rather than discovered by users, and produces an auditable PASS/FAIL verification report.

## TRIGGER COMMANDS

```text
"Verify deployment"
"Post-deploy checks"
"Deployment smoke test"
"Run deployment verification"
"Using deployment_verification skill: verify [environment]"
```

## When to Use
- Immediately after every production or staging deployment
- After database migration deployments to verify schema changes took effect
- When setting up a new deployment pipeline that needs automated verification
- After infrastructure changes (scaling, region migration, provider switch)

---

## PROCESS

### Step 1: Define Verification Targets

Identify what must be verified after each deployment:

| Check Category | What to Verify | Timeout |
|----------------|----------------|---------|
| Health endpoints | `/health` returns 200, `/health/ready` returns 200 | 30s |
| Smoke tests | Critical user flows execute without error | 120s |
| Metric comparison | Error rate delta < 1%, latency p99 delta < 20% | 300s |
| Dependency connectivity | Database, Redis, external APIs reachable | 15s |
| Migration verification | Expected schema version matches deployed version | 10s |

### Step 2: Create Reusable Verification Workflow

```yaml
# .github/workflows/deployment-verification.yml
name: Deployment Verification

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      base_url:
        required: true
        type: string
      previous_sha:
        required: false
        type: string
    outputs:
      result:
        description: "PASS or FAIL"
        value: ${{ jobs.verify.outputs.result }}

jobs:
  verify:
    name: Verify Deployment
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    outputs:
      result: ${{ steps.verdict.outputs.result }}
    steps:
      - uses: actions/checkout@v4

      - name: Wait for service readiness
        run: |
          for i in $(seq 1 30); do
            STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${{ inputs.base_url }}/health" || true)
            if [ "$STATUS" = "200" ]; then
              echo "Service is healthy"
              exit 0
            fi
            echo "Attempt $i: status $STATUS, retrying in 5s..."
            sleep 5
          done
          echo "Service did not become healthy within 150 seconds"
          exit 1

      - name: Health endpoint verification
        run: |
          echo "--- Liveness Check ---"
          curl -sf "${{ inputs.base_url }}/health" | jq .

          echo "--- Readiness Check ---"
          curl -sf "${{ inputs.base_url }}/health/ready" | jq .

      - name: Smoke test suite
        run: |
          npm ci
          SMOKE_BASE_URL="${{ inputs.base_url }}" npx jest \
            --config tests/smoke/jest.config.js \
            --forceExit --detectOpenHandles

      - name: Dependency connectivity
        run: |
          READY=$(curl -sf "${{ inputs.base_url }}/health/ready")
          STATUS=$(echo "$READY" | jq -r '.status')
          if [ "$STATUS" != "ok" ]; then
            echo "Dependency check failed:"
            echo "$READY" | jq '.error'
            exit 1
          fi

      - name: Determine verdict
        id: verdict
        if: always()
        run: |
          if [ "${{ job.status }}" = "success" ]; then
            echo "result=PASS" >> "$GITHUB_OUTPUT"
          else
            echo "result=FAIL" >> "$GITHUB_OUTPUT"
          fi
```

### Step 3: Write Smoke Test Suite

Create a lightweight smoke test file that tests critical paths against the live deployment:

```typescript
// tests/smoke/critical-paths.smoke.ts
const BASE_URL = process.env.SMOKE_BASE_URL;

describe('Post-Deployment Smoke Tests', () => {
  it('GET /health returns 200 with status ok', async () => {
    const res = await fetch(`${BASE_URL}/health`);
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body.status).toBe('ok');
  });

  it('GET /api/v1/public-endpoint returns expected shape', async () => {
    const res = await fetch(`${BASE_URL}/api/v1/public-endpoint`);
    expect(res.status).toBe(200);
    const body = await res.json();
    expect(body).toHaveProperty('success', true);
  });

  it('POST /auth/login rejects invalid credentials with 401', async () => {
    const res = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'invalid@test.com', password: 'wrong' }),
    });
    expect(res.status).toBe(401);
  });

  it('Protected route rejects unauthenticated request', async () => {
    const res = await fetch(`${BASE_URL}/api/v1/me`);
    expect(res.status).toBe(401);
  });
});
```

### Step 4: Integrate Into Deploy Workflow

Call the verification workflow after every deployment:

```yaml
# In deploy-backend.yml, add after the deploy step:
  verify:
    needs: deploy
    uses: ./.github/workflows/deployment-verification.yml
    with:
      environment: production
      base_url: https://api.yourapp.com

  rollback:
    needs: verify
    if: needs.verify.outputs.result == 'FAIL'
    runs-on: ubuntu-latest
    steps:
      - name: Alert team
        run: |
          curl -X POST "${{ secrets.SLACK_WEBHOOK }}" \
            -H 'Content-Type: application/json' \
            -d '{"text":"DEPLOYMENT VERIFICATION FAILED for ${{ github.sha }}. Initiating rollback."}'

      - name: Trigger rollback
        run: echo "Implement rollback logic for your platform here"
```

### Step 5: Generate Verification Report

After each verification run, produce an artifact:

```yaml
      - name: Generate verification report
        if: always()
        run: |
          cat > verification-report.json << EOF
          {
            "sha": "${{ github.sha }}",
            "environment": "${{ inputs.environment }}",
            "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
            "result": "${{ steps.verdict.outputs.result }}",
            "checks": {
              "health_liveness": "${{ steps.health.outcome }}",
              "health_readiness": "${{ steps.health.outcome }}",
              "smoke_tests": "${{ steps.smoke.outcome }}",
              "dependency_connectivity": "${{ steps.deps.outcome }}"
            }
          }
          EOF

      - name: Upload verification report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: deployment-verification-${{ github.sha }}
          path: verification-report.json
          retention-days: 90
```

---

## CHECKLIST

- [ ] Health endpoint polling implemented with retry loop (30 attempts, 5s interval)
- [ ] Smoke test suite covers critical user flows (auth, core API, public endpoints)
- [ ] Verification workflow is reusable via `workflow_call`
- [ ] Deploy workflow calls verification after every deployment
- [ ] Rollback or alert triggers automatically on FAIL result
- [ ] Verification report artifact uploaded for audit trail
- [ ] Dependency connectivity checked via `/health/ready`
- [ ] Smoke tests use environment-specific base URL
- [ ] Timeouts configured for each verification category
- [ ] Slack/email alert fires on verification failure

---

*Skill Version: 1.0 | Created: February 2026*
