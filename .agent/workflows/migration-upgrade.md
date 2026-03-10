---
description: Migration and upgrade workflow — structured process for upgrading frameworks, languages, or databases with backward compatibility, rollback plans, and verification at every stage.
---

# /migration-upgrade Workflow

> Use when upgrading a major dependency, migrating a database, or refactoring a significant system component. The key principle: never lose the ability to roll back.

## When to Use

- [ ] Major framework or language version upgrade
- [ ] Database migration (schema change, engine change, data migration)
- [ ] Infrastructure migration (cloud provider, deployment platform)
- [ ] Large-scale refactoring affecting multiple modules
- [ ] Dependency replacement (swapping one library for another)

---

## Step 1: Assess — Understand the Migration Scope

Catalog what needs to change and what might break.

```bash
view_file .agent/skills/0-context/tech_debt_assessment/SKILL.md
view_file .agent/skills/7-maintenance/dependency_management/SKILL.md
```

- [ ] Current version and target version documented
- [ ] Breaking changes cataloged (read changelogs, migration guides)
- [ ] Affected files and modules identified
- [ ] Dependency compatibility verified (transitive dependencies)
- [ ] Risk assessment completed (what could go wrong)
- [ ] Effort estimate created (small/medium/large per component)

---

## Step 2: Plan — Backward Compatibility Strategy

Design the migration to be incremental and reversible.

```bash
view_file .agent/skills/3-build/backward_compatibility/SKILL.md
```

- [ ] Migration strategy chosen (big bang, strangler fig, parallel run)
- [ ] Backward compatibility requirements defined
- [ ] Feature flags identified (if running old/new in parallel)
- [ ] Rollback procedure documented for each migration step
- [ ] Communication plan: who needs to know, when
- [ ] Migration order defined (dependencies first, dependents last)

**Gate**: Rollback plan must exist for every step. If you can't roll back, re-design the approach.

---

## Step 3: Database Migration

Apply schema and data changes with tested rollback.

```bash
view_file .agent/skills/5-ship/db_migrations/SKILL.md
```

- [ ] Migration scripts written (up and down)
- [ ] Down migration tested: apply up, then down, verify clean state
- [ ] Data migration tested on production-size dataset copy
- [ ] Migration performance acceptable (not locking tables for minutes)
- [ ] Backup taken immediately before migration
- [ ] Migration applied to staging and verified

**Gate**: Down migration MUST be tested. Do not proceed with an irreversible schema change without explicit approval.

---

## Step 4: Code Migration

Update application code to work with the new version.

```bash
view_file .agent/skills/3-build/refactoring/SKILL.md
```

- [ ] Deprecated API calls replaced
- [ ] New patterns adopted per migration guide
- [ ] Type errors resolved (TypeScript strict, compiler warnings)
- [ ] Test coverage maintained or improved (no deleting tests to make it pass)
- [ ] Code changes are incremental commits (not one giant commit)
- [ ] Each commit compiles and tests pass

---

## Step 5: Test — Comprehensive Verification

Verify nothing is broken across all test levels.

```bash
view_file .agent/skills/4-secure/integration_testing/SKILL.md
view_file .agent/skills/4-secure/e2e_testing/SKILL.md
view_file .agent/skills/4-secure/verification_loop/SKILL.md
```

- [ ] Unit tests passing (100% of pre-migration tests)
- [ ] Integration tests passing
- [ ] E2E tests passing on staging
- [ ] Manual smoke test of critical user flows
- [ ] Performance comparison: no regression from migration
- [ ] Verification loop completed (build, test, deploy, verify)

**Gate**: All pre-existing tests must pass. New test failures = fix or investigate, never skip.

---

## Step 6: Deploy — Gradual Rollout

Deploy using a strategy that allows quick rollback.

```bash
view_file .agent/skills/5-ship/deployment_patterns/SKILL.md
```

- [ ] Deployment strategy chosen (blue-green or canary)
- [ ] Blue-green: old environment kept running until verified
- [ ] Canary: gradual traffic shift (5% -> 25% -> 100%)
- [ ] Monitoring active during rollout (errors, latency, resource usage)
- [ ] Rollback trigger defined (error rate > X%, latency > Yms)

---

## Step 7: Verify — Post-Deployment Confirmation

Confirm the migration is successful in production.

```bash
view_file .agent/skills/5-ship/deployment_verification/SKILL.md
```

- [ ] Health checks passing
- [ ] Error rates at or below pre-migration baseline
- [ ] Performance metrics at or below pre-migration baseline
- [ ] Core user flows verified manually in production
- [ ] 24-hour stability period observed
- [ ] No rollback needed

---

## Step 8: Cleanup — Remove Old Code

Remove migration scaffolding and update documentation.

- [ ] Feature flags removed (if parallel run strategy was used)
- [ ] Old compatibility shims removed
- [ ] Deprecated code paths deleted
- [ ] Documentation updated (README, architecture docs, runbooks)
- [ ] Team notified: migration complete, here's what changed
- [ ] Old environment decommissioned (if blue-green)

---

## Exit Checklist — Migration Complete

- [ ] Target version running in production, stable for 24+ hours
- [ ] All tests passing at every level
- [ ] No performance regression
- [ ] Rollback artifacts preserved (but not active)
- [ ] Old code and infrastructure cleaned up
- [ ] Documentation updated
- [ ] Team informed of changes and new patterns

*Workflow Version: 1.0 | Created: March 2026*
