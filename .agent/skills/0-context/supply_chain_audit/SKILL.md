---
name: Supply Chain Audit
description: Assess software supply chain security covering SBOM, dependency integrity, and build pipeline
---

# Supply Chain Audit Skill

**Purpose**: Perform a software supply chain security assessment focusing on provenance, integrity, and build pipeline security. This complements `codebase_health_audit` (which covers CVE scanning) by generating an SBOM, analyzing dependency confusion attack surface, verifying GitHub Actions hash-pinning, checking code signing, and running the OpenSSF Scorecard. The goal is to ensure that what you build is what you ship, and that no malicious code enters through the dependency or build chain.

## TRIGGER COMMANDS

```text
"Audit supply chain security"
"Generate SBOM"
"OpenSSF scorecard"
```

## When to Use
- During Phase 0 for any project with external dependencies (nearly all projects)
- When inheriting a codebase with unknown dependency provenance
- Before production deployment to verify build integrity
- When a supply chain attack is reported in your ecosystem (e.g., npm, PyPI)

---

## PROCESS

### Step 1: Generate Software Bill of Materials (SBOM)

Produce an SBOM in SPDX or CycloneDX format:

```bash
# Node.js projects (CycloneDX)
npx @cyclonedx/cyclonedx-npm --output-file sbom.json

# Python projects
pip install cyclonedx-bom
cyclonedx-py environment --output sbom.json

# Multi-language (using Syft)
syft . -o cyclonedx-json > sbom.json

# Validate the SBOM
npx @cyclonedx/cyclonedx-cli validate --input-file sbom.json
```

Record key metrics from the SBOM:
- Total direct dependencies: ___
- Total transitive dependencies: ___
- Unique licenses found: ___
- Dependencies with no license declared: ___

### Step 2: Dependency Confusion Attack Surface Analysis

Check for private package name collisions with public registries:

```bash
# List all packages and check if names exist on public npm
cat package.json | jq -r '.dependencies // {} | keys[]' | while read pkg; do
  npm view "$pkg" name 2>/dev/null && echo "PUBLIC: $pkg" || echo "PRIVATE: $pkg"
done

# Check for .npmrc or .yarnrc scoping
cat .npmrc 2>/dev/null  # Should scope private packages: @company:registry=https://private.registry
```

Verify mitigations:
- [ ] Private packages use scoped names (`@org/package`)
- [ ] `.npmrc` / `.yarnrc` pins private registries
- [ ] Lockfile integrity is verified in CI (`npm ci`, not `npm install`)
- [ ] No `preinstall` / `postinstall` scripts in untrusted dependencies

### Step 3: CI/CD Pipeline Security (GitHub Actions)

Audit GitHub Actions workflows for supply chain risks:

```bash
# Find all workflow files
find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null

# Check for unpinned actions (RISKY: uses tag instead of SHA)
grep -rn "uses:" .github/workflows/ | grep -v "@[a-f0-9]\{40\}" | grep -v "\./"
# All third-party actions should use full SHA: uses: actions/checkout@abc123...
```

**Hash-Pinning Checklist**:
- [ ] All third-party actions pinned to full SHA (not tag or branch)
- [ ] `GITHUB_TOKEN` permissions set to minimum required (`permissions:` block)
- [ ] No secrets passed to untrusted workflows or actions
- [ ] Pull request workflows do not have `write` permissions
- [ ] Self-hosted runners are not used for public repos (or are ephemeral)

### Step 4: Code Signing and Artifact Integrity

```bash
# Check if commits are signed
git log --show-signature -5

# Check for .cosign or .sigstore verification in CI
grep -r "cosign verify" .github/workflows/ 2>/dev/null
grep -r "sigstore" .github/workflows/ 2>/dev/null

# Check Docker image signing
grep -r "docker trust" .github/workflows/ 2>/dev/null
```

### Step 5: Run OpenSSF Scorecard

```bash
# Install and run scorecard
# Via Docker (recommended)
docker run -e GITHUB_AUTH_TOKEN=$GITHUB_TOKEN gcr.io/openssf/scorecard:stable \
  --repo=github.com/org/repo --format=json > scorecard.json

# Or via binary
scorecard --repo=github.com/org/repo --format=json > scorecard.json
```

Record scores for key checks:
- Branch-Protection: ___/10
- Code-Review: ___/10
- Dangerous-Workflow: ___/10
- Dependency-Update-Tool: ___/10
- Pinned-Dependencies: ___/10
- Token-Permissions: ___/10
- Vulnerabilities: ___/10
- **Aggregate Score**: ___/10

### Step 6: Produce Audit Report

Save the combined findings to:

```
.agent/docs/0-context/supply-chain-audit.md
```

Include the SBOM file reference, all checklist results, and the OpenSSF Scorecard summary.

---

## CHECKLIST

- [ ] SBOM generated in SPDX or CycloneDX format
- [ ] Dependency count documented (direct + transitive)
- [ ] License inventory reviewed for compliance risks
- [ ] Dependency confusion attack surface analyzed
- [ ] Private packages properly scoped and registry-pinned
- [ ] GitHub Actions workflows audited for hash-pinning
- [ ] `GITHUB_TOKEN` permissions verified as minimal
- [ ] Code signing status checked (commits, images, artifacts)
- [ ] OpenSSF Scorecard executed and scores recorded
- [ ] Audit report saved to `.agent/docs/0-context/supply-chain-audit.md`
- [ ] Critical findings fed into `risk_register`

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
