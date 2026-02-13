---
name: Dependency Management & Audit
description: npm audit workflows, license checking, update cadence, and supply chain security for Node.js projects
---

# Dependency Management & Audit Skill

**Purpose**: Your dependencies are your attack surface. This skill provides workflows for auditing vulnerabilities, checking license compatibility, managing updates, and protecting against supply chain attacks.

> [!WARNING]
> **Every dependency is a trust decision.** You are trusting the maintainer, their CI pipeline, their npm credentials, and every transitive dependency they pull in. Treat dependency management as a security practice, not a chore.

---

## 🎯 TRIGGER COMMANDS

```text
"Audit dependencies for [project]"
"Update packages in [project]"
"Check npm vulnerabilities"
"Run dependency audit"
"Check license compatibility"
"Using dependency_management skill: audit [project]"
```

---

## 🔍 NPM AUDIT WORKFLOW

### Step 1: Run the Audit

```bash
# Full audit report
npm audit

# JSON output (for CI/automation)
npm audit --json

# Only production dependencies (skip devDependencies)
npm audit --omit=dev

# If using pnpm
pnpm audit

# If using yarn
yarn audit
```

### Step 2: Analyze the Results

```text
┌───────────────┬──────────────────────────────────────────────────────┐
│  Severity     │  Action Required                                      │
├───────────────┼──────────────────────────────────────────────────────┤
│  critical     │  Fix NOW. Stop what you're doing.                     │
│  high         │  Fix this week. Schedule it today.                    │
│  moderate     │  Fix this month. Add to sprint backlog.               │
│  low          │  Fix when convenient. Batch with other updates.       │
└───────────────┴──────────────────────────────────────────────────────┘
```

### Step 3: Fix Vulnerabilities

```bash
# SAFE: Apply compatible fixes (minor/patch bumps only)
npm audit fix

# Review what WOULD change before running
npm audit fix --dry-run
```

> [!CAUTION]
> **`npm audit fix --force` is DANGEROUS.** It may install major version bumps that introduce breaking changes. NEVER run it blindly. Always review what it will change and test thoroughly after.

```bash
# See what --force would do WITHOUT doing it
npm audit fix --force --dry-run

# If you must use --force, do it one package at a time
npm install package-name@latest
npm test
```

### Step 4: Verify the Fix

```bash
# Re-run audit to confirm zero critical/high
npm audit

# Run your test suite
npm test

# Run the application locally
npm run dev
```

---

## 📅 UPDATE STRATEGY

### Update Cadence

| Update Type | Cadence | Risk Level | Process |
|-------------|---------|------------|---------|
| **Patch** (1.0.x) | Weekly (automated) | Low | Auto-merge if tests pass |
| **Minor** (1.x.0) | Weekly | Low-Medium | Review changelog, run tests |
| **Major** (x.0.0) | Monthly | High | Read migration guide, update code, full QA |
| **Security fixes** | Immediately | Varies | Drop everything for critical/high |

### Using npm-check-updates (ncu)

The essential tool for managing updates.

```bash
# Install globally
npm install -g npm-check-updates

# Check for updates (does NOT modify anything)
ncu

# Output example:
#  @prisma/client  ^5.10.0  →  ^5.22.0
#  react           ^18.2.0  →  ^19.0.0   ← MAJOR (careful!)
#  typescript      ^5.3.0   →  ^5.7.0

# Update only patch and minor versions (SAFE)
ncu -u --target minor

# Update a specific package
ncu -u --filter @prisma/client

# Interactive mode: choose which to update
ncu -u --interactive

# After ncu updates package.json, install the changes
npm install

# Always run tests after updating
npm test
```

### Automated Updates with Dependabot

Create `.github/dependabot.yml`:

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
      time: "09:00"
      timezone: "America/New_York"
    open-pull-requests-limit: 10
    # Group minor/patch updates into one PR
    groups:
      minor-and-patch:
        update-types:
          - "minor"
          - "patch"
    # Auto-merge patch updates
    labels:
      - "dependencies"
    reviewers:
      - "your-github-username"
    # Ignore major updates for certain packages (handle manually)
    ignore:
      - dependency-name: "react"
        update-types: ["version-update:semver-major"]
      - dependency-name: "next"
        update-types: ["version-update:semver-major"]
```

### Alternative: Renovate

If you prefer Renovate over Dependabot, create `renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:recommended",
    ":automergeMinor",
    ":automergeDigest",
    "group:allNonMajor"
  ],
  "schedule": ["every weekend"],
  "prHourlyLimit": 5,
  "labels": ["dependencies"],
  "packageRules": [
    {
      "matchUpdateTypes": ["major"],
      "automerge": false,
      "labels": ["dependencies", "major-update"]
    }
  ]
}
```

---

## ⚖️ LICENSE COMPATIBILITY

### License Categories

| Category | Licenses | Safe for SaaS? | Safe for Proprietary? | Notes |
|----------|----------|----------------|-----------------------|-------|
| **Permissive** | MIT, Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, Unlicense | Yes | Yes | Use freely |
| **Weak Copyleft** | LGPL-2.1, LGPL-3.0, MPL-2.0 | Usually yes | Careful | Modifications to the library itself must be shared |
| **Strong Copyleft** | GPL-2.0, GPL-3.0 | Risky | No | Derivative works must also be GPL |
| **Network Copyleft** | AGPL-3.0 | No | No | Even SaaS use triggers copyleft |
| **No License** | None specified | No | No | No license = all rights reserved. Do not use. |

> [!WARNING]
> **AGPL-3.0 is a SaaS killer.** If you use an AGPL package in a web service, you must open-source your entire application. Always check before installing.

### Checking Licenses

```bash
# Install license-checker
npm install -g license-checker

# List all licenses
license-checker --summary

# Check for problematic licenses
license-checker --failOn "GPL-2.0;GPL-3.0;AGPL-3.0"

# Output to CSV for review
license-checker --csv --out licenses.csv

# Check only production dependencies
license-checker --production --summary
```

### Automated License Check in CI

```yaml
# .github/workflows/license-check.yml
name: License Check

on:
  pull_request:
    paths:
      - 'package.json'
      - 'package-lock.json'

jobs:
  check-licenses:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - run: npm ci

      - name: Check for prohibited licenses
        run: |
          npx license-checker --failOn \
            "GPL-2.0-only;GPL-2.0-or-later;GPL-3.0-only;GPL-3.0-or-later;AGPL-3.0-only;AGPL-3.0-or-later" \
            --production
```

---

## 🔒 LOCK FILE INTEGRITY

### Rules

| Rule | Why |
|------|-----|
| **Always commit `package-lock.json`** (or `pnpm-lock.yaml`) | Ensures reproducible builds across environments |
| **Never manually edit lock files** | Let the package manager handle it |
| **Use `npm ci` in CI/CD** (not `npm install`) | Installs exactly what is in the lock file |
| **Review lock file changes in PRs** | Catch unexpected dependency additions |

```bash
# CI/CD: clean install from lock file (faster, deterministic)
npm ci

# If lock file is out of sync, regenerate it
rm package-lock.json && npm install

# Verify lock file integrity
npm audit signatures
```

> [!TIP]
> **`npm ci` vs `npm install`**: Use `npm ci` in CI/CD pipelines. It is faster, it deletes `node_modules` first, and it fails if `package-lock.json` is out of sync with `package.json`. Use `npm install` only in development.

---

## 🔧 PEER DEPENDENCY CONFLICTS

### Diagnosing Conflicts

```bash
# See the full dependency tree
npm ls

# Check a specific package
npm ls react

# Find why a package is installed
npm explain <package-name>
```

### Resolution Strategies

| Strategy | When to Use | How |
|----------|-------------|-----|
| **Update the parent package** | Parent has a newer version supporting the peer | `npm install parent-package@latest` |
| **Use `--legacy-peer-deps`** | Temporary workaround only | `npm install --legacy-peer-deps` |
| **Use `overrides`** | Force a specific version | Add `overrides` in `package.json` |
| **Replace the package** | Dependency is unmaintained | Find an alternative |

### Using Overrides (package.json)

```json
{
  "overrides": {
    "react": "^18.2.0",
    "some-package": {
      "problematic-dep": "^2.0.0"
    }
  }
}
```

> [!WARNING]
> **Overrides can mask real incompatibilities.** Only use them when you have verified the override is safe. Test thoroughly.

---

## 📦 BREAKING CHANGE HANDLING

### Process for Major Version Upgrades

1. **Read the changelog / migration guide** (always exists for good packages)
2. **Check GitHub issues** for common migration problems
3. **Create a branch** for the upgrade
4. **Update one major package at a time** (never batch major upgrades)
5. **Run the full test suite**
6. **Test manually** in the browser / Postman
7. **Deploy to staging** before production

### Common Major Upgrade Patterns

```bash
# Step 1: Check what will change
ncu --filter <package-name>

# Step 2: Read the migration guide
# (Usually at github.com/<org>/<repo>/blob/main/MIGRATION.md)

# Step 3: Update
npm install <package-name>@latest

# Step 4: Fix breaking changes (TypeScript will catch most)
npx tsc --noEmit

# Step 5: Test
npm test
```

---

## 🤖 AUTOMATED WEEKLY AUDIT (GitHub Actions)

```yaml
# .github/workflows/dependency-audit.yml
name: Weekly Dependency Audit

on:
  schedule:
    # Every Monday at 9:00 AM UTC
    - cron: '0 9 * * 1'
  workflow_dispatch: # Allow manual trigger

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run npm audit
        id: audit
        run: |
          # Capture audit output
          npm audit --omit=dev 2>&1 | tee audit-results.txt
          # Fail only on critical and high
          npm audit --omit=dev --audit-level=high
        continue-on-error: true

      - name: Check for outdated packages
        run: npm outdated || true

      - name: Create issue on failure
        if: steps.audit.outcome == 'failure'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const auditResults = fs.readFileSync('audit-results.txt', 'utf8');
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: `[Security] npm audit found vulnerabilities - ${new Date().toISOString().split('T')[0]}`,
              body: `## Weekly Dependency Audit Failed\n\nThe automated npm audit found high or critical vulnerabilities.\n\n\`\`\`\n${auditResults.slice(0, 3000)}\n\`\`\`\n\n### Action Required\n1. Run \`npm audit\` locally\n2. Fix with \`npm audit fix\` (safe fixes)\n3. For remaining issues, update packages manually\n4. Re-run tests before merging`,
              labels: ['security', 'dependencies']
            });
```

---

## 🧹 DEPENDENCY HYGIENE

### Remove Unused Packages

```bash
# Install depcheck
npm install -g depcheck

# Find unused dependencies
depcheck

# Output example:
# Unused dependencies:
#   * lodash
#   * moment
# Unused devDependencies:
#   * @types/express

# Remove unused packages
npm uninstall lodash moment
```

### Package Size Awareness

```bash
# Check bundle impact BEFORE installing
npx bundlephobia <package-name>

# Or use the website: https://bundlephobia.com/

# Analyze your current bundle
npx webpack-bundle-analyzer stats.json   # webpack
npx vite-bundle-visualizer                # vite
```

| Check | Question |
|-------|----------|
| **Need** | Do I actually need this package or can I write 20 lines of code? |
| **Size** | Is the package smaller than 50KB gzipped? (check bundlephobia) |
| **Maintenance** | Was it updated in the last 6 months? |
| **Downloads** | Does it have > 10K weekly downloads? |
| **Dependencies** | How many transitive dependencies does it pull in? |

> [!TIP]
> **The best dependency is no dependency.** Before running `npm install`, ask: "Can I write this in 20 lines?" If yes, write it yourself. You eliminate a trust decision, a maintenance burden, and a potential vulnerability.

---

## 🛡️ SUPPLY CHAIN SECURITY

### Typosquatting Protection

Attackers publish malicious packages with names similar to popular ones.

| Real Package | Typosquat Examples |
|--------------|--------------------|
| `lodash` | `1odash`, `lodash-es-utils`, `lodashs` |
| `express` | `expres`, `expresss`, `express-framework` |
| `react` | `reactt`, `reacr`, `react-core-lib` |

**Protection**:
- [ ] Double-check package names before `npm install`
- [ ] Copy package names from the official documentation, never type from memory
- [ ] Review `package-lock.json` changes in PRs for unexpected new packages

### npm Provenance

Verify packages were built from known source code.

```bash
# Check if a package has provenance
npm audit signatures

# Verify a specific package
npm view <package-name> --json | jq '.dist'
```

### Lockfile Monitoring

```bash
# In CI: detect if new packages were added without approval
# Compare lock file against the base branch
git diff origin/main -- package-lock.json | head -100
```

### Dealing with Deprecated Packages

```bash
# Check for deprecated packages
npm outdated

# npm will warn on install:
# npm warn deprecated package@version: This package is no longer maintained

# Process:
# 1. Find the replacement (check the deprecation message)
# 2. Update imports throughout your codebase
# 3. Remove the old package
# 4. Test
```

---

## 📊 DEPENDENCY AUDIT REPORT

After running this skill, document the results:

```markdown
# Dependency Audit Report

**Date**: [YYYY-MM-DD]
**Project**: [Project name]
**Node version**: [X.Y.Z]
**Total dependencies**: [N production, M dev]

## Vulnerability Summary

| Severity | Count | Status |
|----------|-------|--------|
| Critical | 0 | All clear |
| High | 0 | All clear |
| Moderate | 2 | Tracked in backlog |
| Low | 5 | Acceptable risk |

## License Summary

| License | Count | Compliant |
|---------|-------|-----------|
| MIT | 142 | Yes |
| Apache-2.0 | 23 | Yes |
| ISC | 18 | Yes |
| BSD-3-Clause | 7 | Yes |

## Outdated Packages (Major)

| Package | Current | Latest | Migration Guide |
|---------|---------|--------|-----------------|
| react | 18.2.0 | 19.0.0 | [Link] |

## Actions Taken

- [ ] `npm audit fix` applied [N] safe fixes
- [ ] [Package] updated from X to Y
- [ ] [Package] replaced with [alternative]
```

---

## ✅ EXIT CHECKLIST

- [ ] `npm audit` shows zero critical and zero high vulnerabilities
- [ ] All dependency licenses are compatible (no GPL/AGPL in proprietary SaaS)
- [ ] `package-lock.json` (or `pnpm-lock.yaml`) is committed and up to date
- [ ] Automated weekly audit configured (GitHub Actions / Dependabot)
- [ ] Unused dependencies removed (`depcheck` run)
- [ ] No deprecated packages without a migration plan
- [ ] Lock file integrity verified (`npm ci` succeeds)
- [ ] Package names verified (no typosquatting risk)
- [ ] Major version upgrades documented with migration notes

---

*Skill Version: 1.0 | Created: February 2026*
