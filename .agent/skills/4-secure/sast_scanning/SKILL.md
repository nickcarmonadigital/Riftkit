---
name: SAST Scanning
description: Configure and run Static Application Security Testing with Semgrep or CodeQL as a blocking CI gate
---

# SAST Scanning Skill

**Purpose**: Configure and execute Static Application Security Testing (SAST) using Semgrep or CodeQL to detect vulnerabilities in source code before they reach production. This skill covers tool installation, ruleset selection, baseline management for existing findings, custom rule authoring, and CI/CD integration that outputs SARIF-format results for the GitHub Security tab.

## TRIGGER COMMANDS

```text
"Run SAST scan"
"Static security analysis"
"Configure Semgrep"
"Setup CodeQL"
"Scan code for vulnerabilities"
```

## When to Use
- Setting up static analysis for a new or existing project
- Adding security scanning as a blocking PR gate in CI
- Triaging and baselining existing findings to focus on new issues
- Writing custom Semgrep rules for project-specific vulnerability patterns
- Preparing SARIF reports for GitHub Advanced Security or audit evidence

---

## PROCESS

### Step 1: Select and Install SAST Tool

Choose based on project needs:

| Tool | Best For | Languages | Speed | Custom Rules |
|------|----------|-----------|-------|--------------|
| Semgrep | Fast PR scanning, custom rules | 30+ languages | Fast | YAML-based, easy |
| CodeQL | Deep semantic analysis | 10 languages | Slower | QL language, powerful |

**Semgrep Installation:**

```bash
# Install Semgrep CLI
pip install semgrep
# Or via Homebrew
brew install semgrep

# Verify installation
semgrep --version

# Run with recommended rulesets
semgrep scan --config=auto .
```

**CodeQL Installation:**

```bash
# Install CodeQL CLI (GitHub provides runners with it pre-installed)
gh extension install github/gh-codeql

# Initialize CodeQL database
codeql database create codeql-db --language=javascript --source-root=.
```

### Step 2: Configure Language-Appropriate Rulesets

**Semgrep Configuration (`.semgrep.yml`):**

```yaml
rules:
  - id: project-custom-rules
    patterns: []

# Include recommended rulesets
# semgrep scan --config=p/typescript --config=p/nodejs --config=p/react --config=p/security-audit
```

**Recommended Semgrep rulesets by stack:**

| Stack | Rulesets |
|-------|----------|
| TypeScript/Node | `p/typescript`, `p/nodejs`, `p/security-audit` |
| React | `p/react`, `p/browser` |
| Python | `p/python`, `p/flask`, `p/django` |
| Go | `p/golang`, `p/security-audit` |
| Java | `p/java`, `p/spring` |

### Step 3: Establish Baseline for Existing Findings

For brownfield projects, baseline existing findings so only new issues block PRs:

```bash
# Generate baseline of existing findings
semgrep scan --config=auto --json --output=.semgrep-baseline.json .

# Run scan comparing against baseline (only new findings fail)
semgrep scan --config=auto --baseline-commit=$(git merge-base HEAD main) .
```

### Step 4: Write Custom Rules for Project Patterns

```yaml
# .semgrep/custom-rules.yml
rules:
  - id: no-raw-sql-with-user-input
    patterns:
      - pattern: $PRISMA.$queryRawUnsafe($INPUT, ...)
      - pattern-not: $PRISMA.$queryRawUnsafe("...", ...)
    message: "Raw SQL with dynamic input detected. Use parameterized $queryRaw instead."
    severity: ERROR
    languages: [typescript]

  - id: no-hardcoded-jwt-secret
    pattern: |
      JwtModule.register({ secret: "..." })
    message: "Hardcoded JWT secret. Use environment variable via ConfigService."
    severity: ERROR
    languages: [typescript]

  - id: require-auth-guard-on-controllers
    patterns:
      - pattern: |
          @Controller(...)
          class $CLASS { ... }
      - pattern-not: |
          @UseGuards(JwtAuthGuard)
          @Controller(...)
          class $CLASS { ... }
    message: "Controller missing @UseGuards(JwtAuthGuard). All controllers must enforce authentication."
    severity: WARNING
    languages: [typescript]
```

### Step 5: Integrate as CI/CD Blocking Gate

**GitHub Actions Workflow (`.github/workflows/sast.yml`):**

```yaml
name: SAST Scan
on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  semgrep:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    container:
      image: semgrep/semgrep
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Semgrep scan
        run: |
          semgrep scan \
            --config=auto \
            --config=.semgrep/custom-rules.yml \
            --sarif --output=semgrep-results.sarif \
            --error \
            --baseline-commit=${{ github.event.pull_request.base.sha }} \
            .

      - name: Upload SARIF to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: semgrep-results.sarif

      - name: Upload SARIF artifact
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: semgrep-sarif
          path: semgrep-results.sarif
          retention-days: 30
```

### Step 6: False-Positive Triage Workflow

```yaml
# Inline suppression (use sparingly, require justification)
# nosemgrep: rule-id -- Justification: <reason>
example_code()  # nosemgrep: no-raw-sql-with-user-input -- Uses static query, no user input

# File-level ignore in .semgrepignore
tests/
node_modules/
*.test.ts
*.spec.ts
```

Triage process:
1. Review each finding in the SARIF output or GitHub Security tab
2. Classify as **True Positive** (fix), **False Positive** (suppress with justification), or **Acceptable Risk** (document in risk register)
3. Suppressions require a code review approval and inline comment explaining why
4. Re-review suppressions quarterly

---

## CHECKLIST

- [ ] SAST tool installed and verified locally (Semgrep or CodeQL)
- [ ] Language-appropriate rulesets configured
- [ ] Baseline established for existing findings (brownfield projects)
- [ ] Custom rules written for project-specific patterns
- [ ] CI/CD workflow added as blocking PR gate
- [ ] SARIF output uploaded to GitHub Security tab
- [ ] False-positive triage process documented
- [ ] Suppression comments require justification and review
- [ ] Scan runs in under 5 minutes for PR builds
- [ ] Results accessible in GitHub Security tab or artifact store
- [ ] Team trained on interpreting and resolving findings

*Skill Version: 1.0 | Created: February 2026*
