---
name: Dependency Hygiene
description: Audit, pin, and secure project dependencies with automated vulnerability scanning and license compliance.
---

# Dependency Hygiene Skill

**Purpose**: Keep project dependencies secure, compliant, and up to date. Covers vulnerability auditing in pre-commit and CI, Dependabot configuration, license compliance checking, lockfile integrity, dependency pinning strategies, and the distinction between SCA and SAST.

## TRIGGER COMMANDS

```text
"Audit dependencies"
"Check for vulnerabilities"
"Configure Dependabot"
```

## When to Use
- Starting a new project and setting up the dependency pipeline
- Adding a new third-party package
- Preparing for a security audit or compliance review
- A vulnerability advisory is published for a dependency you use
- CI pipeline lacks dependency security gates

---

## PROCESS

### Step 1: Understand SCA vs SAST

```text
SCA (Software Composition Analysis):
  - Scans your DEPENDENCIES for known vulnerabilities
  - Tools: npm audit, Snyk, OWASP Dependency-Check
  - Answers: "Am I using a vulnerable library?"

SAST (Static Application Security Testing):
  - Scans YOUR CODE for security bugs
  - Tools: Semgrep, CodeQL, ESLint security rules
  - Answers: "Did I write insecure code?"

This skill covers SCA. For SAST, see Phase 4 sast_scanning skill.
```

### Step 2: npm Audit in Pre-Commit and CI

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: npm-audit
        name: npm audit
        entry: npm audit --audit-level=high
        language: system
        always_run: true
        pass_filenames: false
```

```yaml
# .github/workflows/security.yml
name: Dependency Security
on:
  pull_request:
  schedule:
    - cron: '0 6 * * 1'  # Weekly Monday 6am

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - run: npm ci
      - run: npm audit --audit-level=high
        continue-on-error: false  # Block PR on high/critical vulns

      # Alternative: Snyk for richer reporting
      - uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high
```

### Step 3: Dependabot Configuration

```yaml
# .github/dependabot.yml
version: 2
updates:
  # npm dependencies
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
      day: monday
    open-pull-requests-limit: 10
    reviewers:
      - team-name/security
    labels:
      - dependencies
      - automated
    # Group minor/patch updates to reduce PR noise
    groups:
      production-deps:
        patterns: ["*"]
        update-types: ["minor", "patch"]
        exclude-patterns: ["@types/*"]
      type-definitions:
        patterns: ["@types/*"]

  # GitHub Actions
  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: weekly

  # Docker base images
  - package-ecosystem: docker
    directory: /
    schedule:
      interval: weekly
```

### Step 4: Dependency Pinning Strategy

```jsonc
// package.json -- pinning rules
{
  "dependencies": {
    // PIN exact versions for production deps (predictable builds)
    "express": "4.18.2",
    "@nestjs/core": "10.3.0",
    "prisma": "5.8.1",

    // RANGE for types and dev tools (less critical)
    "@types/node": "^20.0.0"
  },
  "overrides": {
    // Force a transitive dependency to a patched version
    "lodash": "4.17.21"
  }
}
```

```bash
# Verify lockfile integrity in CI
# If lockfile is out of sync with package.json, fail
npm ci  # Uses lockfile exactly; fails if out of sync

# NEVER use `npm install` in CI (it may modify lockfile)
```

### Step 5: License Compliance Checking

```bash
# Install license checker
npm install -g license-checker

# Check for problematic licenses
license-checker --failOn "GPL-2.0;GPL-3.0;AGPL-3.0;AGPL-1.0"

# Generate license report
license-checker --json --out licenses.json
```

```yaml
# CI job for license compliance
- name: Check licenses
  run: |
    npx license-checker --failOn "GPL-2.0;GPL-3.0;AGPL-3.0" --production
```

```text
License risk levels:
  SAFE:     MIT, Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC
  CAUTION:  MPL-2.0 (file-level copyleft), LGPL (linking rules)
  BLOCKED:  GPL-2.0, GPL-3.0, AGPL (viral copyleft -- incompatible with proprietary)
  UNKNOWN:  Unlicensed packages -- investigate before using
```

### Step 6: Lockfile Integrity and Supply Chain Safety

```bash
# Verify no tampering with lockfile
npm ci --ignore-scripts  # Install without running postinstall scripts first
npm audit signatures     # Verify npm registry signatures (npm 9+)
```

```yaml
# .npmrc -- security settings
ignore-scripts=false          # Set to true if you want to block postinstall
audit=true                    # Auto-audit on install
fund=false                    # Suppress funding messages
engine-strict=true            # Enforce engines field
```

```typescript
// Detect typosquatting: review new dependencies manually
// In PR review, always check:
// 1. Is the package name spelled correctly?
// 2. Does the package have meaningful downloads on npm?
// 3. Is the publisher a known/trusted entity?
// 4. When was the last publish? (abandoned packages are risky)
```

### Step 7: Private Registry Configuration

```bash
# .npmrc for private packages
@mycompany:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NPM_TOKEN}

# Always fetch scoped packages from private registry
# All other packages from public npm
```

### Step 8: Dependency Freshness Audit

```bash
# Check for outdated packages
npm outdated --long

# Show which packages have newer major versions
npx npm-check-updates

# Scheduled CI job to track dependency age
# Flag any dependency >1 major version behind
```

---

## CHECKLIST

- [ ] `npm audit --audit-level=high` passes in CI (blocks PRs on high/critical)
- [ ] Dependabot configured for npm, GitHub Actions, and Docker
- [ ] Production dependencies pinned to exact versions
- [ ] `npm ci` used in CI (not `npm install`)
- [ ] License compliance check blocks GPL/AGPL in commercial projects
- [ ] Lockfile committed to repo and integrity verified in CI
- [ ] New dependency additions reviewed for typosquatting risk
- [ ] Private registry configured for internal packages (if applicable)
- [ ] Weekly scheduled audit runs even without code changes
- [ ] Dependency freshness audit runs monthly (no major version >1 behind)
