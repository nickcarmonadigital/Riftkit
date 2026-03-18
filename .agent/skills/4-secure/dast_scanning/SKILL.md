---
name: "DAST Scanning"
description: "Dynamic Application Security Testing — runtime vulnerability scanning with OWASP ZAP, Burp Suite, and Nuclei"
triggers:
  - "/dast"
  - "/dast-scanning"
  - "/dynamic-security-testing"
---

# DAST Scanning

## WHEN TO USE
- Testing a running application for security vulnerabilities
- Complementing SAST with runtime analysis
- Pre-release security validation
- Continuous security scanning in CI/CD

## PROCESS

### 1. Tool Selection
| Tool | Best For | License |
|------|----------|---------|
| OWASP ZAP | Free, full-featured, CI/CD friendly | Apache 2.0 |
| Burp Suite | Manual + automated, best proxy | Commercial |
| Nuclei | Template-based, fast, CVE scanning | MIT |
| Nikto | Quick web server scanning | GPL |

### 2. Scan Configuration
- Start with passive scan (spider + observe)
- Configure authentication (login sequence, session tokens)
- Define scope (include/exclude URL patterns)
- Set scan policy (speed vs thoroughness)

### 3. CI/CD Integration
```yaml
# Example: ZAP in GitHub Actions
- name: ZAP Scan
  uses: zaproxy/action-full-scan@v0.9.0
  with:
    target: 'https://staging.example.com'
    rules_file_name: '.zap/rules.tsv'
    fail_action: 'true'
```

### 4. Triage Results
- Filter false positives (mark in baseline file)
- Prioritize by CVSS score and exploitability
- Cross-reference with SAST findings (confirmed = higher priority)
- Track remediation in issue tracker

## CHECKLIST
- [ ] DAST tool selected and configured
- [ ] Authentication configured for authenticated scanning
- [ ] Scope defined (no scanning third-party services)
- [ ] Baseline file for known false positives
- [ ] CI/CD integration for pre-release scanning
- [ ] Results triaged and tracked

## Related Skills
- [`sast_scanning`](../sast_scanning/SKILL.md)
- [`security_audit`](../security_audit/SKILL.md)
