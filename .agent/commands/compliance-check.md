---
description: Run automated compliance checks against SOC2, HIPAA, PCI-DSS, or GDPR frameworks with evidence collection.
---

# Compliance Check Command

Validates codebase and infrastructure against regulatory compliance frameworks using compliance-as-code policies.

## Instructions

1. **Framework Selection**
   - Identify target compliance framework from arguments
   - Load applicable control mappings and policy rules
   - Determine which controls apply to the current project type

2. **Automated Control Checks**

   **SOC2 Controls:**
   - Access control: authentication required on all endpoints
   - Audit logging: sensitive operations logged with user context
   - Encryption: data encrypted at rest and in transit (TLS)
   - Change management: commits signed, PRs reviewed
   - Availability: health checks and monitoring configured

   **HIPAA Controls:**
   - PHI handling: no PII/PHI in logs, error messages, or URLs
   - Access audit trail: all data access logged
   - Encryption: AES-256 at rest, TLS 1.2+ in transit
   - Minimum necessary: role-based access, no wildcard permissions
   - BAA verification: third-party services have BAA in place

   **PCI-DSS Controls:**
   - No cardholder data stored in plaintext
   - No card numbers in logs or error output
   - Input validation on all payment-related fields
   - Network segmentation for payment processing
   - Dependency scanning for known vulnerabilities

   **GDPR Controls:**
   - Consent collection before data processing
   - Data deletion capability (right to erasure)
   - Data export capability (right to portability)
   - Privacy policy references in data collection points
   - Data retention policies implemented

3. **Evidence Collection** (if `--evidence`)
   - Screenshot/log each passing control with timestamp
   - Document failing controls with remediation steps
   - Generate evidence package for auditor review

4. **Gap Analysis**
   - List controls not yet implemented
   - Prioritize by risk (CRITICAL gaps first)
   - Provide implementation guidance for each gap

## Output

```
COMPLIANCE CHECK: [framework] [PASS/FAIL]

Framework:     [SOC2/HIPAA/PCI-DSS/GDPR]
Controls:      X/Y passing (Z%)
Critical Gaps: X
High Gaps:     X
Medium Gaps:   X

Passing Controls:
  [CC-001] Access Control          PASS
  [CC-002] Audit Logging           PASS
  [CC-003] Encryption at Rest      FAIL - No encryption configured

Failing Controls:
  [CC-003] Encryption at Rest
    Gap:    Database not configured with encryption
    Risk:   CRITICAL
    Fix:    Enable TDE or application-level encryption
    Ref:    SOC2 CC6.1

Evidence: [collected/not requested]
```

## Arguments

$ARGUMENTS can be:
- `soc2` - SOC2 Type II controls
- `hipaa` - HIPAA Security Rule controls
- `pci` or `pci-dss` - PCI-DSS v4.0 controls
- `gdpr` - GDPR data protection controls
- `--evidence` - Collect audit evidence for each control
- `--gaps-only` - Only show failing controls
- `--export` - Export report as markdown file

## Example Usage

```
/compliance-check soc2
/compliance-check hipaa --evidence
/compliance-check pci --gaps-only
/compliance-check gdpr --export
```

## Mapped Skills

- `compliance_as_code` - Policy-as-code rule engine
- `compliance_testing_framework` - Automated control validation
- `hipaa_compliance_testing` - HIPAA-specific checks
- `pci_dss_compliance_testing` - PCI-DSS-specific checks

## Related Commands

- `/security-audit` - Security vulnerability scanning
- `/code-review` - Code quality and security review
