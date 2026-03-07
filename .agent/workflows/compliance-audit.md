---
description: Compliance audit workflow — structured process for preparing and executing regulatory compliance audits, from scoping through evidence assembly and post-audit remediation.
---

# /compliance-audit Workflow

> Use when preparing for a regulatory audit (SOC 2, HIPAA, PCI DSS, GDPR) or conducting an internal compliance review. Start this workflow at least 4 weeks before an external audit.

## When to Use

- [ ] External audit scheduled (SOC 2, HIPAA, PCI DSS, GDPR)
- [ ] Internal compliance review cycle due
- [ ] New regulation applies to the product
- [ ] Post-incident compliance verification required

---

## Step 1: Scope — Identify Applicable Frameworks

Determine which regulations and controls apply.

```bash
view_file .agent/skills/4-secure/regulated_industry_context/SKILL.md
```

- [ ] Industry and data types cataloged (PII, PHI, PCI, financial)
- [ ] Applicable frameworks identified (SOC 2, HIPAA, PCI DSS, GDPR)
- [ ] Scope boundaries defined (which systems, data flows, teams)
- [ ] Previous audit findings reviewed (if any)
- [ ] Audit timeline and deadlines confirmed

---

## Step 2: Evidence Collection — Automated Gathering

Collect compliance evidence programmatically where possible.

```bash
view_file .agent/skills/4-secure/compliance_as_code/SKILL.md
```

- [ ] Infrastructure-as-code reviewed for compliance controls
- [ ] Automated evidence collection scripts run
- [ ] CI/CD pipeline compliance checks documented
- [ ] Configuration drift detection results captured
- [ ] Evidence catalog created with timestamps and sources

---

## Step 3: Control Testing — Framework-Specific Validation

Test controls against the specific compliance framework.

```bash
view_file .agent/skills/4-secure/compliance_testing_framework/SKILL.md
view_file .agent/skills/4-secure/hipaa_compliance_testing/SKILL.md
view_file .agent/skills/4-secure/pci_dss_compliance_testing/SKILL.md
```

- [ ] Control objectives mapped to implementation
- [ ] Each control tested: effective, partially effective, or ineffective
- [ ] Framework-specific tests executed (HIPAA/PCI DSS as applicable)
- [ ] Test results documented with pass/fail evidence
- [ ] Compensating controls identified for any gaps

**Gate**: Any ineffective control on a critical requirement must be remediated before proceeding.

---

## Step 4: Audit Logging Review

Verify audit trail completeness and integrity.

```bash
view_file .agent/skills/4-secure/audit_logging_architecture/SKILL.md
```

- [ ] All authentication events logged (login, logout, failed attempts)
- [ ] Data access events logged (read, write, delete of sensitive data)
- [ ] Administrative actions logged (config changes, user management)
- [ ] Logs are tamper-resistant (append-only, centralized)
- [ ] Log retention meets regulatory requirements
- [ ] Log search and retrieval tested

---

## Step 5: Access Control Review

Verify authorization and secret management.

```bash
view_file .agent/skills/4-secure/authorization_patterns/SKILL.md
view_file .agent/skills/4-secure/secret_management/SKILL.md
```

- [ ] Principle of least privilege verified across roles
- [ ] Service account permissions audited
- [ ] Secret rotation policy in place and functioning
- [ ] No hardcoded secrets in codebase (scan results clean)
- [ ] MFA enabled for administrative access
- [ ] Access reviews completed (who has access to what)

---

## Step 6: Gap Remediation

Fix identified compliance gaps before the audit.

- [ ] Gap list prioritized by severity and audit risk
- [ ] Remediation plan created with owners and deadlines
- [ ] Critical gaps fixed and re-tested
- [ ] High-priority gaps fixed or compensating controls documented
- [ ] Medium/low gaps tracked with remediation timeline
- [ ] Re-run control tests on remediated items

**Gate**: All critical and high-priority gaps must be resolved or have documented compensating controls.

---

## Step 7: Report Generation

Create the compliance report package.

- [ ] Executive summary written (scope, methodology, findings)
- [ ] Control matrix completed (control, status, evidence reference)
- [ ] Finding details documented (gap, risk, remediation, status)
- [ ] Risk ratings assigned (critical, high, medium, low)
- [ ] Remediation timeline included for open items
- [ ] Report reviewed by compliance lead

---

## Step 8: Auditor Preparation — Evidence Package

Assemble everything the auditor needs.

- [ ] Evidence index created (document name, control mapping, location)
- [ ] All evidence organized in shared folder structure
- [ ] Personnel interview list prepared (who knows what)
- [ ] System access prepared for auditor (read-only, scoped)
- [ ] FAQ document prepared for common auditor questions
- [ ] Dry-run walkthrough completed internally

---

## Step 9: Post-Audit — Update and Track

Incorporate audit findings into ongoing compliance program.

```bash
view_file .agent/skills/4-secure/risk_register/SKILL.md
view_file .agent/skills/4-secure/compliance_program/SKILL.md
```

- [ ] Audit findings received and reviewed
- [ ] Risk register updated with new findings
- [ ] Remediation plan created for audit findings
- [ ] Compliance program updated with lessons learned
- [ ] Next audit cycle planned
- [ ] Continuous monitoring adjustments made

---

## Exit Checklist — Audit Complete

- [ ] All applicable controls tested and documented
- [ ] Critical/high gaps remediated or compensated
- [ ] Evidence package assembled and organized
- [ ] Audit report finalized
- [ ] Risk register current
- [ ] Post-audit action items tracked with owners
- [ ] Next review cycle scheduled

*Workflow Version: 1.0 | Created: March 2026*
