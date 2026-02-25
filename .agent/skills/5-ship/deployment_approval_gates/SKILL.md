---
name: Deployment Approval Gates
description: Multi-gate deployment pipeline with pre-deploy checks, migration gates, manual approvals, and post-deploy verification
---

# Deployment Approval Gates Skill

**Purpose**: Enforce a structured sequence of automated and manual gates that every production deployment must pass before and after release. This prevents "merge-and-pray" deployments by requiring test passage, security scan clearance, migration safety validation, human approval, and post-deploy verification as mandatory pipeline stages.

## TRIGGER COMMANDS

```text
"Add deployment gates"
"Require approval for deploy"
"Production deploy checklist"
"Set up deployment approval workflow"
"Using deployment_approval_gates skill: configure gates for [environment]"
```

## When to Use
- When establishing a production deployment pipeline for the first time
- When compliance (SOC2, HIPAA, PCI-DSS) requires documented approval workflows
- When the team has experienced broken deployments due to insufficient pre-checks
- When multiple teams contribute to the same deployable service

---

## PROCESS

### Step 1: Define the Gate Sequence

```text
GATE SEQUENCE (all must pass in order)

  Gate 1: Pre-Deploy Checks (automated)
  ├── All CI tests pass (unit, integration, e2e)
  ├── Security scan clean (SAST, SCA, secrets)
  ├── No open P0/P1 bugs tagged for this release
  └── Build artifact exists and is signed

  Gate 2: Migration Safety (automated)
  ├── Migration is backward-compatible (expand-contract)
  ├── Migration tested against production schema snapshot
  └── Migration sequence validated (no gaps, no conflicts)

  Gate 3: Manual Approval (human)
  ├── GitHub Environment required_reviewers approved
  ├── Change record created with description and rollback plan
  └── On-call engineer acknowledged

  Gate 4: Post-Deploy Verification (automated)
  ├── Health endpoints return 200
  ├── Smoke tests pass
  └── Error rate delta within threshold
```

### Step 2: Configure GitHub Environments

Set up required reviewers in GitHub repository settings:

```text
Repository Settings > Environments > production

  Required reviewers:
    - @team-lead
    - @senior-engineer (any 1 of 2)

  Wait timer: 0 minutes (approval is the gate, not a delay)

  Deployment branches:
    - main (only)
```

### Step 3: Implement Multi-Gate Workflow

```yaml
# .github/workflows/deploy-with-gates.yml
name: Gated Production Deploy

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.github/workflows/deploy-with-gates.yml'

jobs:
  # ─── GATE 1: Pre-Deploy Checks ─────────────────────────
  pre-deploy-checks:
    name: "Gate 1: Pre-Deploy Checks"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Verify CI passed for this SHA
        run: |
          STATUS=$(gh api repos/${{ github.repository }}/commits/${{ github.sha }}/check-runs \
            --jq '[.check_runs[] | select(.conclusion != "success")] | length')
          if [ "$STATUS" != "0" ]; then
            echo "ERROR: Not all CI checks passed for ${{ github.sha }}"
            exit 1
          fi
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Check for blocking bugs
        run: |
          BLOCKERS=$(gh issue list --label "priority:P0,priority:P1" --label "release-blocker" \
            --state open --json number --jq 'length')
          if [ "$BLOCKERS" != "0" ]; then
            echo "ERROR: $BLOCKERS open release-blocking bugs found"
            gh issue list --label "priority:P0,priority:P1" --label "release-blocker" --state open
            exit 1
          fi
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Verify build artifact exists
        run: |
          ARTIFACTS=$(gh api repos/${{ github.repository }}/actions/runs/${{ github.run_id }}/artifacts \
            --jq '.artifacts | length')
          echo "Found $ARTIFACTS artifacts for this run"

  # ─── GATE 2: Migration Safety ──────────────────────────
  migration-check:
    name: "Gate 2: Migration Safety"
    needs: pre-deploy-checks
    runs-on: ubuntu-latest
    services:
      postgres:
        image: pgvector/pgvector:pg16
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: migration_test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - run: cd backend && npm ci

      - name: Test migration against clean database
        working-directory: backend
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/migration_test

      - name: Verify no pending migrations
        working-directory: backend
        run: |
          PENDING=$(npx prisma migrate status 2>&1 | grep -c "not yet applied" || true)
          if [ "$PENDING" != "0" ]; then
            echo "ERROR: Unapplied migrations detected after deploy"
            exit 1
          fi
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/migration_test

  # ─── GATE 3: Manual Approval ───────────────────────────
  approval:
    name: "Gate 3: Manual Approval"
    needs: migration-check
    runs-on: ubuntu-latest
    environment: production  # This triggers the required_reviewers gate
    steps:
      - name: Approval received
        run: echo "Deployment approved by required reviewers"

  # ─── DEPLOY ────────────────────────────────────────────
  deploy:
    name: "Deploy to Production"
    needs: approval
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: |
          # Your deployment command here
          echo "Deploying ${{ github.sha }} to production"

  # ─── GATE 4: Post-Deploy Verification ──────────────────
  post-deploy:
    name: "Gate 4: Post-Deploy Verification"
    needs: deploy
    uses: ./.github/workflows/deployment-verification.yml
    with:
      environment: production
      base_url: ${{ vars.PRODUCTION_URL }}

  notify:
    name: Notify Result
    needs: post-deploy
    if: always()
    runs-on: ubuntu-latest
    steps:
      - name: Send deployment notification
        run: |
          if [ "${{ needs.post-deploy.outputs.result }}" = "PASS" ]; then
            STATUS="deployed successfully"
          else
            STATUS="FAILED verification - investigate immediately"
          fi
          curl -X POST "${{ secrets.SLACK_WEBHOOK }}" \
            -H 'Content-Type: application/json' \
            -d "{\"text\":\"Production deploy ${{ github.sha }}: $STATUS\"}"
```

### Step 4: Emergency Deploy Bypass

For critical hotfixes, provide a documented bypass path:

```yaml
# Add to workflow trigger:
on:
  workflow_dispatch:
    inputs:
      emergency:
        description: 'Emergency deploy - skip approval gate'
        type: boolean
        default: false
      justification:
        description: 'Justification for emergency deploy (required if emergency=true)'
        type: string

# In the approval job:
  approval:
    if: ${{ !inputs.emergency }}
    # ... normal approval flow

  emergency-log:
    if: ${{ inputs.emergency }}
    runs-on: ubuntu-latest
    steps:
      - name: Log emergency deploy
        run: |
          gh issue create \
            --title "EMERGENCY DEPLOY: ${{ github.sha }}" \
            --label "emergency-change" \
            --body "**Justification**: ${{ inputs.justification }}
          **Deployed by**: ${{ github.actor }}
          **SHA**: ${{ github.sha }}
          **Time**: $(date -u +%Y-%m-%dT%H:%M:%SZ)
          **Requires post-incident review within 48h**"
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## CHECKLIST

- [ ] GitHub Environment `production` created with required reviewers
- [ ] Gate 1: CI status verification blocks deploy on test failure
- [ ] Gate 1: Release-blocker bug check prevents deploy with open P0/P1 issues
- [ ] Gate 2: Migration tested against clean database before production apply
- [ ] Gate 3: At least one human reviewer must approve production deploys
- [ ] Gate 4: Post-deploy verification runs automatically after deploy
- [ ] Emergency bypass path documented with mandatory justification and issue creation
- [ ] Slack/email notifications fire on deploy success and failure
- [ ] Deployment branches restricted to `main` only
- [ ] All gate results visible in GitHub Actions workflow visualization
- [ ] Emergency deploys are auditable (GitHub Issue created automatically)

---

*Skill Version: 1.0 | Created: February 2026*
