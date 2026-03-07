---
description: Run comprehensive security audit covering secrets scanning, SAST, container security, dependency vulnerabilities, and API security testing.
---

# Security Audit Command

Runs a multi-layered security audit across the codebase and infrastructure.

## Instructions

Execute all applicable scan categories:

1. **Secrets Scanning**
   - Scan for hardcoded API keys, tokens, passwords, private keys
   - Check .env files are gitignored
   - Scan git history for previously committed secrets
   - Check for credentials in config files, comments, and test fixtures

2. **Static Application Security Testing (SAST)**
   - SQL injection vulnerabilities
   - XSS and output encoding issues
   - Command injection / path traversal
   - Insecure deserialization
   - Missing authentication/authorization checks on routes
   - Unsafe use of eval, exec, or dynamic code execution

3. **Dependency Vulnerability Scan**
   - Check for known CVEs in dependencies (npm audit / pip audit / similar)
   - Flag outdated packages with known security patches
   - Identify packages with no maintainer or low trust score

4. **Container Security** (if applicable)
   - Check Dockerfile for running as root
   - Verify base images are pinned and up to date
   - Scan for unnecessary packages or exposed ports
   - Check for secrets baked into image layers

5. **API Security Testing** (if `--focus api`)
   - Check for missing rate limiting
   - Verify authentication on all endpoints
   - Check for overly permissive CORS
   - Validate input sanitization on all request parameters
   - Check for mass assignment vulnerabilities

6. **Supply Chain Security**
   - Verify lockfile integrity
   - Check for typosquatting package names
   - Review post-install scripts in dependencies

## Output

```
SECURITY AUDIT: [PASS/FAIL]

Secrets:       [OK/X found]     (CRITICAL)
SAST:          [OK/X issues]    (HIGH: X, MEDIUM: X, LOW: X)
Dependencies:  [OK/X vulnerable] (CRITICAL: X, HIGH: X)
Containers:    [OK/X issues]    (or N/A)
API Security:  [OK/X issues]    (or N/A)
Supply Chain:  [OK/X concerns]

Total: X critical, Y high, Z medium findings
```

For each finding, include:
- Severity (CRITICAL/HIGH/MEDIUM/LOW)
- File path and line number
- Description and attack vector
- Remediation guidance

## Arguments

$ARGUMENTS can be:
- (none) - Run all applicable scans
- `--focus secrets` - Only secrets scanning
- `--focus sast` - Only SAST
- `--focus deps` - Only dependency vulnerabilities
- `--focus api` - Only API security testing
- `--focus containers` - Only container security
- `--sarif` - Output in SARIF format for CI integration

## Example Usage

```
/security-audit
/security-audit --focus api
/security-audit --focus secrets
```

## Agent

This command invokes the `security-agent` located at:
`.agent/agents/security-agent.md`

## Mapped Skills

- `security_audit` - Overall audit orchestration
- `sast_scanning` - Static analysis
- `secrets_scanning` - Credential detection
- `container_security` - Container hardening
- `supply_chain_security` - Dependency integrity
- `api_security_testing` - API attack surface analysis

## Related Commands

- `/code-review` - Includes basic security checks
- `/compliance-check` - Regulatory compliance validation
