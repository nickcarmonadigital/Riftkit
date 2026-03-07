---
description: Orchestrate a production deployment with pre-deploy checks, migration safety, deployment execution, and post-deploy verification.
---

# Deploy Command

Orchestrates a safe, verified deployment to the target environment.

## Instructions

Execute deployment in this exact order:

1. **Pre-Deploy Checks**
   - Run build and type checks (fail fast)
   - Run test suite (block on failures)
   - Check for uncommitted changes (warn)
   - Validate environment configuration
   - Review pending database migrations for safety (destructive column drops, data loss)

2. **Migration Safety Review**
   - List pending migrations
   - Flag irreversible operations (DROP, TRUNCATE, column removal)
   - Verify rollback scripts exist for each migration
   - If unsafe migrations found, STOP and require explicit confirmation

3. **Deployment Execution**
   - If `--canary`: deploy to canary subset first, wait for health checks
   - If `--rolling`: deploy incrementally with health gate between batches
   - If neither: standard deployment to target environment
   - Tag the commit with deployment metadata

4. **Post-Deploy Verification**
   - Run health checks against deployed environment
   - Verify critical API endpoints respond correctly
   - Check error rates in logs (compare to pre-deploy baseline)
   - Validate database migrations applied cleanly

5. **Rollback Gate**
   - If post-deploy checks fail, prompt for rollback
   - Provide rollback command with exact version to restore

## Output

```
DEPLOYMENT: [SUCCESS/FAILED/ROLLED BACK]

Environment:  [staging/production]
Version:      [tag or commit SHA]
Pre-checks:   [PASS/FAIL]
Migrations:   [N applied / none pending]
Health:       [OK/DEGRADED/DOWN]
Error Rate:   [X% (baseline: Y%)]
Duration:     [Xm Xs]

Rollback cmd: deploy rollback --to <previous-version>
```

## Arguments

$ARGUMENTS can be:
- `staging` - Deploy to staging (default)
- `production` - Deploy to production (requires confirmation)
- `--canary` - Canary deployment (partial rollout)
- `--rolling` - Rolling deployment with health gates
- `--skip-tests` - Skip test suite (staging only, never production)
- `--dry-run` - Simulate deployment without executing

## Example Usage

```
/deploy staging
/deploy production --canary
/deploy production --rolling --dry-run
```

## Mapped Skills

- `deployment_patterns` - Deployment strategy selection
- `ci_cd_pipeline` - Pipeline execution
- `deployment_verification` - Post-deploy health validation
- `deployment_approval_gates` - Approval and sign-off checks

## Related Commands

- `/verify` - Run pre-deploy checks independently
- `/release` - Cut a release before deploying
- `/observe` - Check observability after deployment
