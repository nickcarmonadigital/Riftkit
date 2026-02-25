---
name: Compliance Program
description: Three-part compliance program covering regime identification, per-phase checklist injection, and drift detection across all project phases.
---

# Compliance Program Skill

**Purpose**: Establish and maintain a project-specific compliance program that identifies applicable regulatory frameworks, injects phase-appropriate compliance checklists, and detects compliance drift over time. This skill spans Phases 0, 2, 4, 6, and 7 as a cross-cutting governance concern.

## TRIGGER COMMANDS

```text
"Set up compliance program"
"What compliance applies?"
"Run compliance audit"
"Compliance check for phase [N]"
"Identify regulatory requirements"
```

## When to Use
- Starting a new project and need to identify applicable regulations
- Entering a new phase and need phase-specific compliance requirements
- Performing periodic compliance drift detection (Phase 7)
- Onboarding a project in a regulated industry (healthcare, fintech, government)
- Preparing for an external audit or certification renewal

---

## PROCESS

### Step 1: Regime Identification Questionnaire

Run the intake questionnaire to determine which compliance frameworks apply.

**Product Classification:**
- What type of product? (SaaS / Mobile / On-prem / Embedded / API-only)
- What data does it process? (PII / PHI / Financial / Children's data / Government)
- What geographies are served? (US / EU / UK / APAC / Global)
- What customer segments? (Consumer / SMB / Enterprise / Government / Healthcare)
- Is it a critical infrastructure service?

**Framework Mapping Matrix:**

| Signal | Framework | Phase Impact |
|--------|-----------|-------------|
| Processes EU personal data | GDPR | P0: data inventory, P2: privacy design, P4: DPIA |
| US consumer PII | CCPA/CPRA | P0: data inventory, P3: opt-out implementation |
| Health data (US) | HIPAA | P0: BAA inventory, P2: PHI architecture, P4: audit controls |
| Payment card data | PCI-DSS | P2: network segmentation, P3: encryption, P4: ASV scans |
| Enterprise SaaS customers | SOC 2 Type II | P3: audit logging, P5: change management, P7: evidence collection |
| US government customers | FedRAMP | P0: boundary definition, P2: FIPS encryption, P4: 3PAO assessment |
| AI/ML processing | EU AI Act | P0: risk classification, P2: transparency design, P4: bias testing |
| Children's data (US) | COPPA | P0: age gating, P2: parental consent design |

**Output**: `compliance-manifest.json` listing identified frameworks with phase-specific requirements.

### Step 2: Per-Phase Compliance Checklist Injection

Based on the compliance manifest, inject relevant checks at each phase gate.

**Phase 0 -- Context:**
- [ ] Data inventory completed (what PII/PHI/financial data exists)
- [ ] Applicable frameworks identified and documented
- [ ] Business Associate Agreements inventoried (HIPAA)
- [ ] Data Processing Agreements reviewed (GDPR)
- [ ] Current compliance posture scored per framework

**Phase 2 -- Design:**
- [ ] Privacy-by-design requirements documented
- [ ] Data residency constraints mapped to architecture
- [ ] Encryption requirements defined (at-rest, in-transit, field-level)
- [ ] Consent architecture designed
- [ ] Audit logging architecture specified
- [ ] Retention and deletion policies designed

**Phase 4 -- Secure:**
- [ ] SAST/DAST scans cover compliance-relevant code paths
- [ ] Penetration test scope includes compliance controls
- [ ] DPIA completed for high-risk processing (GDPR Art. 35)
- [ ] Access control tests verify least-privilege
- [ ] Evidence collection automated for audit artifacts

**Phase 5/6 -- Ship/Handoff:**
- [ ] Change management records satisfy CC8.1 (SOC 2)
- [ ] Deployment audit trail complete
- [ ] Operational runbooks include compliance procedures
- [ ] Incident response plan covers breach notification timelines

**Phase 7 -- Maintenance:**
- [ ] Compliance drift detection running on schedule
- [ ] Evidence collection pipeline operational
- [ ] Periodic re-assessment scheduled (quarterly/annually)
- [ ] Regulatory change monitoring active

### Step 3: Compliance Drift Detection

Periodic re-assessment detects when the project drifts out of compliance.

**Drift Detection Triggers:**
1. New dependency introduces data processing (check DPA coverage)
2. New feature collects additional PII fields (update data inventory)
3. New geography served (check local data protection laws)
4. Infrastructure change (re-validate encryption and residency)
5. Scheduled quarterly re-assessment

**Drift Report Format:**

```markdown
# Compliance Drift Report -- [Date]

## Framework: [Name]
## Status: COMPLIANT | DRIFT DETECTED | NON-COMPLIANT

### Changes Since Last Assessment
- [Change description and compliance impact]

### New Findings
| Finding | Severity | Control | Remediation |
|---------|----------|---------|-------------|
| ... | Critical/High/Medium/Low | [Control ID] | [Action required] |

### Remediation Timeline
- [Finding]: [Owner] by [Date]
```

### Step 4: Evidence Collection Automation

For SOC 2 and similar audit frameworks, automate evidence collection.

**Evidence Sources:**
- Git commit history (change management evidence)
- CI/CD pipeline logs (deployment controls)
- Access control configurations (least privilege)
- Security scan results (vulnerability management)
- Incident response records (incident management)
- Code review records (peer review controls)

**Output**: `.agent/docs/compliance/` directory containing:
- `compliance-manifest.json` -- Identified frameworks and requirements
- `compliance-checklist-phase-N.md` -- Phase-specific checklists
- `compliance-drift-YYYY-MM.md` -- Drift detection reports
- `evidence-index.md` -- Audit evidence catalog

---

## CHECKLIST

- [ ] Regime identification questionnaire completed
- [ ] Compliance manifest generated with framework-to-phase mapping
- [ ] Phase-specific checklists injected for current phase
- [ ] Data inventory completed for identified PII/PHI/financial data
- [ ] Evidence collection automation configured
- [ ] Drift detection schedule established
- [ ] Compliance findings documented with remediation owners
- [ ] Phase gate criteria updated to include compliance checks

---

*Skill Version: 1.0 | Cross-Phase: 0, 2, 4, 6, 7 | Priority: P0*
