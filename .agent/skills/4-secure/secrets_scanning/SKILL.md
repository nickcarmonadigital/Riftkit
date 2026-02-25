---
name: Secrets Scanning
description: Three-layer secret detection covering pre-commit prevention, CI gate scanning, and historical remediation
---

# Secrets Scanning Skill

**Purpose**: Implement a three-layer defense against secrets leaking into version control. Layer 1 prevents commits locally with pre-commit hooks. Layer 2 catches anything that slips through via CI gates. Layer 3 handles historical remediation when secrets are discovered in git history. This skill covers tool configuration, baseline management, and rotation playbooks.

## TRIGGER COMMANDS

```text
"Scan for secrets"
"Detect credentials in code"
"Install secrets pre-commit hook"
"Check git history for leaked secrets"
"Set up gitleaks"
```

## When to Use
- Setting up a new project and need pre-commit secret detection
- Adding secret scanning to an existing CI pipeline
- Responding to a secret leak incident (historical remediation)
- Onboarding a new repository that may have secrets in history
- Preparing for SOC2 or compliance audit evidence on secret management

---

## PROCESS

### Step 1: Layer 1 -- Pre-Commit Prevention

Install and configure pre-commit hooks to block secrets before they enter git history.

**Option A: gitleaks (recommended)**

```bash
# Install gitleaks
brew install gitleaks
# Or download binary from https://github.com/gitleaks/gitleaks/releases

# Initialize pre-commit hook
cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
EOF

# Install pre-commit framework
pip install pre-commit
pre-commit install
```

**Option B: detect-secrets (Yelp)**

```bash
pip install detect-secrets

# Generate initial baseline (marks existing findings as known)
detect-secrets scan > .secrets.baseline

# Install pre-commit hook
cat >> .pre-commit-config.yaml << 'EOF'
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']
EOF

pre-commit install
```

**Gitleaks Configuration (`.gitleaks.toml`):**

```toml
[extend]
useDefault = true

[allowlist]
description = "Project-specific allowlist"
paths = [
    '''\.secrets\.baseline''',
    '''\.env\.example''',
    '''test/fixtures/.*''',
]
regexTarget = "match"

# Custom rules for project-specific patterns
[[rules]]
id = "project-internal-token"
description = "Internal service token pattern"
regex = '''ZENITH_SVC_[A-Za-z0-9]{32,}'''
tags = ["token", "internal"]
```

### Step 2: Layer 2 -- CI Gate Scanning

Add gitleaks as a required CI check that blocks merging if secrets are detected.

**GitHub Actions Workflow (`.github/workflows/secrets-scan.yml`):**

```yaml
name: Secrets Scan
on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run gitleaks on PR diff
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          GITLEAKS_CONFIG: .gitleaks.toml
```

**Enforcing the .gitignore for auth tokens and secrets:**

```gitignore
# Secrets and credentials
.env
.env.local
.env.production
*.pem
*.key
*credentials*.json
service-account*.json
.secrets.baseline
```

### Step 3: Layer 3 -- Historical Remediation

When secrets are discovered in git history, follow this remediation playbook.

**Discovery with TruffleHog:**

```bash
# Install TruffleHog
pip install trufflehog

# Scan entire git history
trufflehog git file://. --only-verified --json > trufflehog-report.json

# Scan specific branch
trufflehog git file://. --branch=main --only-verified
```

**Rotation Playbook (execute in order):**

1. **Revoke immediately**: Disable the leaked credential at the provider (AWS IAM, GitHub, Stripe, etc.)
2. **Generate replacement**: Create a new credential and store in secret manager
3. **Deploy new credential**: Update all services using the compromised credential
4. **Verify rotation**: Confirm old credential returns 401/403
5. **Clean git history** (if needed):

```bash
# Remove secrets from git history using git-filter-repo
pip install git-filter-repo

# Replace secret with placeholder in all history
git filter-repo --replace-text <(echo 'AKIAIOSFODNN7EXAMPLE==>REDACTED_AWS_KEY')

# Force push cleaned history (coordinate with team)
git push --force-with-lease --all
```

6. **Document incident**: Record in incident log with timeline, scope, and remediation steps

### Step 4: Enforce E2E Auth Token Protection

Ensure test auth tokens and fixtures never contain real credentials:

```typescript
// test/fixtures/auth.ts -- ALWAYS use fake tokens
export const TEST_JWT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ0ZXN0LXVzZXItaWQiLCJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20ifQ.fake-signature';
export const TEST_API_KEY = 'test_key_not_real_00000000000000';
```

---

## CHECKLIST

- [ ] Pre-commit hook installed (gitleaks or detect-secrets)
- [ ] Baseline generated for existing findings
- [ ] `.gitleaks.toml` configured with project-specific allowlist
- [ ] CI workflow added as required check on PRs
- [ ] `.gitignore` covers `.env`, `*.pem`, `*.key`, credentials files
- [ ] Historical scan completed with TruffleHog (no verified secrets in history)
- [ ] Rotation playbook documented and accessible to team
- [ ] Test fixtures use only fake/synthetic credentials
- [ ] Team members have run `pre-commit install` locally
- [ ] Secret scanning results reviewed and triaged quarterly

*Skill Version: 1.0 | Created: February 2026*
