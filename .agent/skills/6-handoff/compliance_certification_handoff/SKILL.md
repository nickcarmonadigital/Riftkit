---
name: Compliance Certification Handoff
description: Compliance evidence assembly, control owner matrix, audit calendar, continuous compliance monitoring transfer, and vendor compliance status
---

# Compliance Certification Handoff Skill

**Purpose**: Transfer ownership of compliance programs, certification evidence, audit responsibilities, and regulatory monitoring to the receiving team. A successful compliance handoff ensures the new owner can maintain certifications, prepare for audits, respond to regulatory changes, and manage third-party vendor compliance without gaps in coverage or lapsed controls.

## TRIGGER COMMANDS

```text
"Compliance handoff"
"Audit ownership transfer"
"Compliance evidence transfer"
"Control owner handoff"
"Certification transfer"
```

## When to Use
- Transferring compliance program ownership during team reorganization
- Handing off audit preparation responsibilities to a new compliance lead
- Transitioning regulatory monitoring to a dedicated GRC team
- Completing a compliance implementation project and handing to operations
- Onboarding a new compliance officer or security team member

### Cross-References
- **compliance_program** -- building a compliance program from scratch
- **compliance_as_code** -- automating compliance checks as code
- **audit_logging_architecture** -- technical audit log implementation

---

## PROCESS

### Step 1: Compliance Evidence Package Assembly

Gather all evidence artifacts that demonstrate compliance with each framework.

**Evidence inventory template:**

| Control ID | Framework | Control Description | Evidence Type | Evidence Location | Last Collected | Collection Method | Freshness Req |
|------------|-----------|-------------------|---------------|-------------------|----------------|-------------------|---------------|
| AC-1 | SOC 2 | Access control policy | Document | /compliance/policies/access-control.md | 2026-02-15 | Manual | Annual |
| AC-2 | SOC 2 | User account provisioning | Screenshot + logs | /compliance/evidence/ac-2/ | 2026-03-01 | Automated (Vanta) | Quarterly |
| CC6.1 | SOC 2 | Encryption in transit | Config export | /compliance/evidence/cc6-1/ | 2026-02-28 | Automated (script) | Monthly |
| A.9.4.1 | ISO 27001 | Information access restriction | IAM export | /compliance/evidence/a941/ | 2026-03-01 | Automated (AWS CLI) | Monthly |
| 164.312(a)(1) | HIPAA | Access control | Audit logs | /compliance/evidence/hipaa-access/ | 2026-02-28 | Automated (SIEM) | Continuous |

**Evidence package structure:**

```
compliance/
  policies/                    # Written policies and procedures
    access-control.md
    incident-response.md
    data-classification.md
    vendor-management.md
  evidence/                    # Collected evidence per control
    ac-1/
    ac-2/
    cc6-1/
  scripts/                     # Automated evidence collection
    collect-iam-evidence.sh
    export-audit-logs.sh
    generate-compliance-report.py
  reports/                     # Audit reports and certifications
    soc2-type2-2025.pdf
    iso27001-certificate-2025.pdf
    pentest-report-2026-q1.pdf
  vendor/                      # Third-party compliance docs
    aws-soc2-report.pdf
    stripe-pci-aoc.pdf
```

**Evidence collection automation:**

```bash
#!/bin/bash
# collect-evidence.sh -- Run monthly to refresh automated evidence
set -euo pipefail

EVIDENCE_DIR="compliance/evidence"
DATE=$(date +%Y-%m-%d)

# IAM user list with MFA status
aws iam generate-credential-report
aws iam get-credential-report --output text --query Content | base64 -d \
  > "$EVIDENCE_DIR/ac-2/iam-credential-report-$DATE.csv"

# Encryption in transit -- TLS configuration
aws elbv2 describe-listeners --load-balancer-arn "$LB_ARN" \
  > "$EVIDENCE_DIR/cc6-1/elb-listeners-$DATE.json"

# Security group audit
aws ec2 describe-security-groups \
  > "$EVIDENCE_DIR/network/security-groups-$DATE.json"

echo "Evidence collected: $DATE"
```

### Step 2: Control Owner Matrix

Every compliance control must have a named owner responsible for maintaining evidence and responding to audit inquiries.

**Control owner matrix:**

| Control Area | Control IDs | Current Owner | New Owner | Backup Owner | Review Frequency |
|-------------|-------------|---------------|-----------|--------------|------------------|
| Access Control | AC-1 through AC-7 | @alice | @bob | @carol | Quarterly |
| Change Management | CM-1 through CM-5 | @alice | @dave | @bob | Monthly |
| Incident Response | IR-1 through IR-6 | @eve | @eve (retained) | @bob | Semi-annual |
| Data Protection | DP-1 through DP-4 | @alice | @carol | @dave | Quarterly |
| Vendor Management | VM-1 through VM-3 | @alice | @bob | @carol | Annual |
| Business Continuity | BC-1 through BC-3 | @frank | @frank (retained) | @dave | Annual |
| Logging & Monitoring | LM-1 through LM-4 | @alice | @bob | @eve | Monthly |

**Owner responsibilities:**

```markdown
## Control Owner Responsibilities
1. Maintain current evidence for assigned controls
2. Respond to auditor inquiries within 48 hours during audit periods
3. Remediate control gaps within SLA (Critical: 7 days, High: 30 days)
4. Attend quarterly compliance review meetings
5. Update control documentation when processes change
6. Escalate regulatory changes that affect assigned controls
```

### Step 3: Audit Calendar and Preparation Timeline

```markdown
## Audit Calendar 2026

| Audit/Assessment | Framework | Auditor | Start Date | End Date | Prep Start | Owner |
|-----------------|-----------|---------|------------|----------|------------|-------|
| SOC 2 Type II | SOC 2 | Deloitte | 2026-06-01 | 2026-06-15 | 2026-04-15 | @bob |
| ISO 27001 Surveillance | ISO 27001 | BSI | 2026-09-01 | 2026-09-05 | 2026-07-15 | @bob |
| PCI DSS v4.0 | PCI DSS | QSA TBD | 2026-11-01 | 2026-11-10 | 2026-09-01 | @carol |
| Penetration Test | Multiple | NCC Group | 2026-04-01 | 2026-04-14 | 2026-03-15 | @eve |
| Vendor Risk Review | Internal | Internal | 2026-07-01 | 2026-07-15 | 2026-06-15 | @bob |

## Audit Preparation Timeline (SOC 2 Example)

| Weeks Before | Activity | Responsible |
|-------------|----------|-------------|
| T-8 weeks | Refresh all automated evidence collection | Control owners |
| T-6 weeks | Internal control testing (sample 25 items per control) | Compliance lead |
| T-4 weeks | Gap remediation for any failed controls | Control owners |
| T-3 weeks | Evidence package review and organization | Compliance lead |
| T-2 weeks | Pre-audit readiness check with auditor | Compliance lead + auditor |
| T-1 week | Freeze evidence collection, final review | Compliance lead |
| Audit week | Auditor on-site/remote, daily standups | All control owners |
| T+2 weeks | Respond to auditor findings/questions | Control owners |
| T+4 weeks | Receive draft report, review for accuracy | Compliance lead |
| T+6 weeks | Final report issued | Auditor |
```

### Step 4: Continuous Compliance Monitoring Handoff

Transfer automated compliance monitoring tools and configurations.

```markdown
## Continuous Compliance Monitoring

### Automated Tools
| Tool | Purpose | Access | Config Location | Owner |
|------|---------|--------|----------------|-------|
| Vanta | SOC 2 continuous monitoring | app.vanta.com | N/A (SaaS) | @bob |
| Drata | ISO 27001 evidence collection | app.drata.com | N/A (SaaS) | @bob |
| AWS Config | Cloud resource compliance | AWS Console | /infra/aws-config-rules/ | @dave |
| OPA/Gatekeeper | K8s policy enforcement | kubectl | /infra/opa-policies/ | @dave |
| Custom scripts | Evidence collection | CI/CD | /compliance/scripts/ | @bob |

### AWS Config Rules (Active)
| Rule | Compliance Check | Auto-Remediate |
|------|-----------------|----------------|
| s3-bucket-server-side-encryption | All S3 buckets encrypted | Yes (SSE-S3) |
| iam-user-mfa-enabled | All IAM users have MFA | No (notify only) |
| restricted-ssh | No 0.0.0.0/0 on port 22 | Yes (remove rule) |
| rds-storage-encrypted | All RDS instances encrypted | No (notify only) |
| cloudtrail-enabled | CloudTrail active in all regions | Yes (enable) |

### Monitoring Alert Channels
- Vanta findings: #compliance-alerts (Slack)
- AWS Config violations: #security-alerts (Slack) + PagerDuty (P3)
- OPA policy violations: Kubernetes admission webhook (blocks non-compliant resources)
- Custom script failures: #compliance-alerts (Slack)
```

### Step 5: Regulatory Change Monitoring Responsibility Transfer

```markdown
## Regulatory Change Monitoring

### Current Monitoring Sources
| Source | Regulations | Frequency | Current Owner | New Owner |
|--------|------------|-----------|---------------|-----------|
| Federal Register (federalregister.gov) | US federal regulations | Daily RSS | @alice | @bob |
| EU Official Journal | GDPR updates, EU AI Act | Weekly review | @alice | @carol |
| NIST CSF updates | Security framework changes | Quarterly check | @alice | @bob |
| PCI SSC blog | PCI DSS updates | Monthly review | @alice | @carol |
| HHS/OCR guidance | HIPAA updates | Monthly review | @alice | @bob |
| State privacy laws | CCPA, state-level changes | Monthly review | @alice | @carol |

### Change Assessment Process
1. New regulation identified → log in regulatory change tracker
2. Impact assessment: Does this affect our systems/data/processes?
3. If YES: Create compliance gap analysis, assign control owners
4. Implementation timeline: Map requirements to engineering work
5. Evidence update: Update evidence collection for new controls
6. Policy update: Revise written policies to reflect changes

### Regulatory Change Tracker Location
- Spreadsheet: [compliance/regulatory-changes.xlsx]
- Or Notion/Jira board: [link to tracking board]
```

### Step 6: Third-Party/Vendor Compliance Status

```markdown
## Vendor Compliance Status

| Vendor | Service | Compliance Certs | Last Reviewed | Expires | Risk Tier | Owner |
|--------|---------|-----------------|---------------|---------|-----------|-------|
| AWS | Cloud infrastructure | SOC 2, ISO 27001, PCI DSS | 2026-01-15 | 2026-12-31 | Critical | @bob |
| Stripe | Payment processing | PCI DSS L1, SOC 2 | 2026-02-01 | 2026-09-30 | Critical | @carol |
| Datadog | Monitoring | SOC 2, ISO 27001 | 2026-01-20 | 2026-12-31 | High | @bob |
| Auth0 | Authentication | SOC 2, ISO 27001 | 2026-02-15 | 2026-11-30 | Critical | @bob |
| SendGrid | Email | SOC 2 | 2026-03-01 | 2027-02-28 | Medium | @carol |

### Vendor Review Process
- **Critical vendors**: Annual SOC 2 report review + quarterly security questionnaire
- **High vendors**: Annual SOC 2 report review
- **Medium vendors**: Annual self-assessment questionnaire
- **Low vendors**: Biennial review

### Vendor Compliance Documents Location
- All vendor SOC 2 reports: /compliance/vendor/
- Security questionnaires: /compliance/vendor/questionnaires/
- BAAs (HIPAA): /compliance/vendor/baas/
- DPAs (GDPR): /compliance/vendor/dpas/
```

### Step 7: Compliance Tool Access Transfer

```markdown
## Compliance Tool Access Checklist

| Tool | Access Level Needed | Current Admin | Transfer To | Status |
|------|-------------------|---------------|-------------|--------|
| Vanta | Admin | @alice | @bob | [ ] Pending |
| Drata | Admin | @alice | @bob | [ ] Pending |
| AWS Config | Read + Write | @alice | @dave | [ ] Pending |
| Jira (compliance board) | Project Admin | @alice | @bob | [ ] Pending |
| Evidence S3 bucket | Read + Write | @alice | @bob | [ ] Pending |
| Compliance Slack channels | Owner | @alice | @bob | [ ] Pending |
| PCI cardholder data env | Restricted access | @alice | @carol | [ ] Pending |
| Auditor portal (Deloitte) | Primary contact | @alice | @bob | [ ] Pending |

### Access Transfer Steps
1. Add new owner to all compliance tools with appropriate role
2. Verify new owner can access all evidence repositories
3. Update primary contact with auditors and certification bodies
4. Transfer ownership of compliance Slack channels
5. Update emergency contact lists with new compliance lead
6. Remove departing team member access after 30-day overlap period
```

---

## CHECKLIST

- [ ] Complete evidence package inventory with locations and freshness dates
- [ ] All evidence collection scripts documented and tested by new owner
- [ ] Control owner matrix updated with new owners for every control
- [ ] Backup owners assigned for all critical control areas
- [ ] Audit calendar shared with dates, auditors, and preparation timelines
- [ ] Audit preparation playbook documented (T-8 weeks through completion)
- [ ] Continuous compliance monitoring tools transferred (Vanta, Drata, AWS Config)
- [ ] Alert channels for compliance violations confirmed working
- [ ] Regulatory change monitoring sources and responsibilities transferred
- [ ] Regulatory change tracker handed over with current pipeline
- [ ] Vendor compliance status documented with review dates and expiration
- [ ] Vendor compliance documents (SOC 2 reports, BAAs, DPAs) location shared
- [ ] All compliance tool access transferred and verified
- [ ] Auditor relationships introduced (new owner meets auditor contact)
- [ ] 30-day overlap period scheduled for knowledge transfer
- [ ] First compliance review meeting scheduled under new ownership

*Skill Version: 1.0 | Created: March 2026*
