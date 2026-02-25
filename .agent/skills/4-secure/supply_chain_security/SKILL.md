---
name: Supply Chain Security
description: Software Composition Analysis with SBOM generation, dependency confusion detection, and license compliance
---

# Supply Chain Security Skill

**Purpose**: Secure the software supply chain through Software Composition Analysis (SCA), SBOM generation, license compliance detection, and dependency confusion/typosquatting prevention. This skill ensures every third-party component is inventoried, scanned for known vulnerabilities, and verified for license compatibility before it reaches production.

## TRIGGER COMMANDS

```text
"SCA scan"
"Dependency audit"
"Supply chain check"
"Generate SBOM"
"License compliance check"
```

## When to Use
- Adding dependency security scanning to CI/CD pipeline
- Generating a Software Bill of Materials for compliance or customer requests
- Auditing dependencies for license conflicts (GPL/AGPL in commercial products)
- Investigating potential dependency confusion or typosquatting attacks
- Preparing supply chain evidence for SOC2 or ISO 27001 audits

---

## PROCESS

### Step 1: Software Composition Analysis (SCA) in CI

Configure automated dependency vulnerability scanning as a CI gate.

**npm/Node.js projects:**

```bash
# Built-in audit
npm audit --audit-level=high

# Snyk (more comprehensive, includes transitive deps)
npx snyk test --severity-threshold=high

# OWASP Dependency-Check
dependency-check --project "myapp" --scan . --format JSON --out dependency-check-report.json
```

**Python projects:**

```bash
# pip-audit (recommended)
pip install pip-audit
pip-audit --strict --desc

# Safety
pip install safety
safety check --json --output safety-report.json
```

**GitHub Actions Workflow (`.github/workflows/supply-chain.yml`):**

```yaml
name: Supply Chain Security
on:
  pull_request:
    paths: ['package*.json', 'requirements*.txt', 'Pipfile.lock', 'go.sum']
  push:
    branches: [main]
  schedule:
    - cron: '0 6 * * 1'  # Weekly Monday 6am

jobs:
  sca-scan:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Run Snyk SCA
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high --sarif-file-output=snyk-results.sarif
        continue-on-error: true

      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: snyk-results.sarif

      - name: npm audit (fallback)
        run: npm audit --audit-level=high
```

### Step 2: SBOM Generation (CycloneDX Format)

Generate a Software Bill of Materials for every release.

```bash
# Node.js -- CycloneDX
npx @cyclonedx/cyclonedx-npm --output-file sbom.json --spec-version 1.5

# Python
pip install cyclonedx-bom
cyclonedx-py environment --output-format json --outfile sbom.json

# Container image (via Trivy)
trivy image --format cyclonedx --output sbom-container.json myapp:latest

# Multi-format: also generate SPDX
trivy image --format spdx-json --output sbom-spdx.json myapp:latest
```

**Attach SBOM to GitHub Release:**

```yaml
# In release workflow
- name: Generate SBOM
  run: npx @cyclonedx/cyclonedx-npm --output-file sbom.json

- name: Upload SBOM to Release
  uses: softprops/action-gh-release@v2
  with:
    files: sbom.json
```

### Step 3: License Compliance Detection

Detect license conflicts that could create legal risk:

```bash
# license-checker for Node.js
npx license-checker --production --json --out licenses.json

# Check for problematic licenses
npx license-checker --production --failOn 'GPL-2.0;GPL-3.0;AGPL-3.0;AGPL-1.0'
```

**License risk classification:**

| Risk Level | Licenses | Action |
|------------|----------|--------|
| Permissive (safe) | MIT, Apache-2.0, BSD-2, BSD-3, ISC | No action needed |
| Weak copyleft (review) | LGPL-2.1, MPL-2.0, EPL-2.0 | Legal review if linking statically |
| Strong copyleft (block) | GPL-2.0, GPL-3.0, AGPL-3.0 | Block in commercial/proprietary projects |
| Unknown | UNLICENSED, custom | Manual review required |

### Step 4: Dependency Confusion and Typosquatting Detection

**Lockfile integrity verification:**

```bash
# Verify lockfile matches package.json (detects tampering)
npm ci  # Fails if lockfile is out of sync

# Check for lockfile in git
git ls-files --error-unmatch package-lock.json
```

**Typosquatting detection:**

```bash
# socket.dev CLI (detects supply chain attacks)
npx socket npm info <package-name>

# Manual checks for suspicious patterns:
# - Recently published packages with similar names to popular ones
# - Packages with install scripts (preinstall, postinstall)
# - Packages with very few downloads but claiming to be popular
```

**Private registry scoping (prevent dependency confusion):**

```ini
# .npmrc -- Scope internal packages to private registry
@mycompany:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
```

### Step 5: Dependency Pinning Strategy

```json
{
  "overrides": {},
  "engines": {
    "node": ">=20.0.0",
    "npm": ">=10.0.0"
  }
}
```

| Strategy | When to Use |
|----------|-------------|
| Exact pinning (`1.2.3`) | Security-critical dependencies, CI tools |
| Caret range (`^1.2.3`) | Application dependencies (default npm behavior) |
| Lockfile committed | Always -- ensures reproducible builds |
| Renovate/Dependabot | Automated PR for dependency updates with CI checks |

**Renovate configuration (`.github/renovate.json`):**

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": ["config:recommended", "group:recommended"],
  "vulnerabilityAlerts": { "enabled": true },
  "labels": ["dependencies", "security"],
  "prConcurrentLimit": 5,
  "packageRules": [
    { "matchDepTypes": ["devDependencies"], "automerge": true },
    { "matchPackagePatterns": ["*"], "groupName": "all-non-major", "matchUpdateTypes": ["minor", "patch"] }
  ]
}
```

---

## CHECKLIST

- [ ] SCA scanner configured in CI (Snyk, npm audit, or OWASP Dependency-Check)
- [ ] CI blocks on HIGH/CRITICAL vulnerability findings
- [ ] SBOM generated in CycloneDX format for each release
- [ ] SBOM attached to GitHub Release artifacts
- [ ] License compliance check runs in CI (blocks GPL/AGPL in commercial projects)
- [ ] Lockfile committed and `npm ci` used in CI (not `npm install`)
- [ ] Private registry scoped for internal packages (`.npmrc`)
- [ ] Dependabot or Renovate configured for automated dependency updates
- [ ] Weekly scheduled SCA scan (catches newly disclosed CVEs)
- [ ] Dependency risk report generated and reviewed before major releases

*Skill Version: 1.0 | Created: February 2026*
