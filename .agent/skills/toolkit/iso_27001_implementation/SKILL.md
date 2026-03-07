---
name: ISO 27001 Implementation
description: End-to-end ISO 27001:2022 ISMS implementation covering scope definition, risk assessment, Annex A control selection, Statement of Applicability, internal audit, management review, and certification process
---

# ISO 27001 Implementation Skill

**Purpose**: Guide the complete implementation of an Information Security Management System (ISMS) conforming to ISO/IEC 27001:2022. This skill covers ISMS scope definition, risk assessment methodology, risk treatment with Annex A control selection, Statement of Applicability (SoA), internal audit program design, management review, continuous improvement via PDCA, and the certification journey from Stage 1 through surveillance audits. Use this when ISO 27001 certification is a business requirement or when you need a structured security management framework.

> [!IMPORTANT]
> **ISO 27001:2022 replaced the 2013 version.** The new standard restructured Annex A from 14 domains (114 controls) to 4 themes (93 controls) and added 11 new controls. Ensure all documentation references the 2022 version.

## TRIGGER COMMANDS

```text
"Implement ISO 27001"
"Set up ISMS for [project/organization]"
"Create Statement of Applicability"
"ISO 27001 risk assessment"
"Prepare for ISO 27001 certification"
"Using iso_27001_implementation skill: build ISMS for [scope]"
```

## When to Use
- Organization needs ISO 27001 certification (contractual, market, or regulatory requirement)
- Building a structured information security management program from scratch
- Preparing for ISO 27001 Stage 1 or Stage 2 audit
- Performing annual surveillance audit preparation
- Mapping existing security controls to a recognized international standard
- Enterprise customers require ISO 27001 as a vendor qualification

---

## PART 1: ISMS SCOPE AND CONTEXT

### Step 1.1: Context of the Organization (Clause 4)

Before defining scope, understand the organization's context:

```markdown
## Context of the Organization

### Internal Context
- Organization structure: [departments, reporting lines]
- Business strategy: [growth plans, market position]
- Existing security posture: [current controls, prior audits]
- Technology landscape: [cloud providers, on-prem, hybrid]
- Internal stakeholders: [executive sponsor, IT, legal, HR, operations]

### External Context
- Regulatory environment: [GDPR, HIPAA, PCI-DSS, sector-specific]
- Customer requirements: [enterprise contracts, SLAs, security questionnaires]
- Supplier ecosystem: [cloud vendors, SaaS tools, outsourced services]
- Threat landscape: [industry-specific threats, recent incidents in sector]
- Competitive environment: [competitor certifications, market expectations]

### Interested Parties and Requirements
| Interested Party | Security Requirements | Priority |
|-----------------|----------------------|----------|
| Enterprise customers | ISO 27001 cert, SOC 2 report, pentest results | HIGH |
| Regulators | GDPR compliance, breach notification | HIGH |
| Employees | Data protection, clear security policies | MEDIUM |
| Cloud providers | Shared responsibility model adherence | MEDIUM |
| Investors/Board | Risk management, business continuity | HIGH |
```

### Step 1.2: ISMS Scope Definition (Clause 4.3)

Define what is IN and OUT of scope. The scope statement appears on your certificate.

```markdown
## ISMS Scope Statement

**Organization**: [Company Name]
**Scope**: The Information Security Management System covers the design, development,
deployment, and operation of [product/service name] including:

**In Scope:**
- Cloud infrastructure (AWS [region], [services])
- Application codebase and CI/CD pipelines
- Customer data processing and storage
- Corporate IT systems used by [N] employees
- Third-party integrations ([list key vendors])
- Physical office at [address] (if applicable)

**Out of Scope:**
- [Specific system/service] (justification: [reason])
- Personal devices not used for work (BYOD excluded)

**Locations**: [Office addresses, data center regions]
**Employees**: [Number of staff in scope]
**Applicability**: ISO/IEC 27001:2022
```

**Scope pitfalls to avoid:**
- Too narrow: Auditors will question why critical systems are excluded
- Too broad: Increases cost and complexity without proportional benefit
- Missing interfaces: If scoped systems connect to out-of-scope systems, the boundaries must be controlled

---

## PART 2: RISK ASSESSMENT (Clause 6.1.2)

### Step 2.1: Risk Assessment Methodology

Document the methodology BEFORE performing the assessment. Auditors will verify you followed your own method.

```markdown
## Risk Assessment Methodology

### Approach: Qualitative (5x5 Matrix)

**Asset Identification**: Identify information assets, classify by CIA impact.

**Threat Identification**: For each asset, identify plausible threats.

**Vulnerability Assessment**: For each threat, identify exploitable vulnerabilities.

**Likelihood Scale:**
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Rare | Once in 5+ years, no history |
| 2 | Unlikely | Once in 2-5 years |
| 3 | Possible | Once per year |
| 4 | Likely | Multiple times per year |
| 5 | Almost Certain | Monthly or more frequent |

**Impact Scale:**
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Negligible | No business impact, no data exposure |
| 2 | Minor | Limited impact, internal data only, <$10K |
| 3 | Moderate | Some customers affected, regulatory inquiry, $10K-$100K |
| 4 | Major | Significant breach, regulatory fine, $100K-$1M |
| 5 | Catastrophic | Mass data breach, existential threat, >$1M |

**Risk Score**: Likelihood x Impact (1-25)

**Risk Appetite:**
| Score Range | Risk Level | Treatment |
|-------------|-----------|-----------|
| 1-4 | Low | Accept (document acceptance) |
| 5-9 | Medium | Mitigate or transfer |
| 10-15 | High | Mitigate (priority) |
| 16-25 | Critical | Mitigate immediately or avoid |
```

### Step 2.2: Risk Register Template

```markdown
## Risk Register

| Risk ID | Asset | Threat | Vulnerability | L | I | Score | Level | Treatment | Control(s) | Owner | Due Date | Status |
|---------|-------|--------|--------------|---|---|-------|-------|-----------|-----------|-------|----------|--------|
| R-001 | Customer DB | Unauthorized access | Weak authentication | 4 | 5 | 20 | Critical | Mitigate | A.8.5 (Auth) | CTO | 2026-04-01 | Open |
| R-002 | Source code | IP theft | No access logging | 3 | 4 | 12 | High | Mitigate | A.8.15 (Logging) | Eng Lead | 2026-05-01 | Open |
| R-003 | Laptops | Device theft | No disk encryption | 3 | 3 | 9 | Medium | Mitigate | A.8.1 (Endpoints) | IT | 2026-04-15 | Open |
| R-004 | Office WiFi | Eavesdropping | WPA2 (not WPA3) | 2 | 2 | 4 | Low | Accept | N/A | IT | N/A | Accepted |
```

---

## PART 3: ANNEX A CONTROLS (ISO 27001:2022)

### 93 Controls Across 4 Themes

#### Theme 1: Organizational Controls (A.5) -- 37 Controls

| Control | Title | Summary | Framework Skill Mapping |
|---------|-------|---------|----------------------|
| A.5.1 | Policies for information security | Define and publish security policies | `compliance_program` |
| A.5.2 | Information security roles | Assign ISMS roles and responsibilities | `regulated_industry_context` |
| A.5.3 | Segregation of duties | Prevent fraud through duty separation | `authorization_patterns` |
| A.5.4 | Management responsibilities | Management enforces security policies | Management review (this skill) |
| A.5.5 | Contact with authorities | Maintain regulatory/law enforcement contacts | `regulated_industry_context` |
| A.5.6 | Contact with special interest groups | Participate in security communities | External activity |
| A.5.7 | Threat intelligence | Collect and analyze threat intelligence | `runtime_security_monitoring` |
| A.5.8 | Info security in project management | Security in every project phase | Phase gate model (framework core) |
| A.5.9 | Inventory of information | Maintain asset inventory | `regulated_industry_context` (data classification) |
| A.5.10 | Acceptable use of information | Define acceptable use policies | Policy document |
| A.5.11 | Return of assets | Offboarding asset recovery | HR process |
| A.5.12 | Classification of information | Data classification scheme | `regulated_industry_context` (Step 4) |
| A.5.13 | Labeling of information | Label assets per classification | Implementation of classification |
| A.5.14 | Information transfer | Secure data transfer policies | `secret_management`, encryption |
| A.5.15 | Access control | Access control policy | `authorization_patterns` |
| A.5.16 | Identity management | Identity lifecycle management | `auth_implementation` |
| A.5.17 | Authentication information | Password/credential policies | `auth_implementation` |
| A.5.18 | Access rights | Provisioning and review of access | `authorization_patterns` |
| A.5.19 | Info security in supplier relationships | Vendor security requirements | `regulated_industry_context` (Step 6) |
| A.5.20 | Addressing info security in supplier agreements | Security clauses in contracts | Legal/procurement |
| A.5.21 | Managing info security in ICT supply chain | Supply chain security | `supply_chain_audit` |
| A.5.22 | Monitoring/review of supplier services | Ongoing vendor assessment | `supply_chain_audit` |
| A.5.23 | Info security for cloud services | Cloud security requirements | `infrastructure_audit` |
| A.5.24 | Info security incident management planning | Incident response plan | `sre_foundations` |
| A.5.25 | Assessment and decision on info security events | Event triage procedures | `runtime_security_monitoring` |
| A.5.26 | Response to info security incidents | Incident response execution | `sre_foundations` |
| A.5.27 | Learning from info security incidents | Post-incident improvement | `retrospective` |
| A.5.28 | Collection of evidence | Digital forensics readiness | `audit_logging_architecture` |
| A.5.29 | Info security during disruption | Business continuity | `resiliency_patterns` |
| A.5.30 | ICT readiness for business continuity | Disaster recovery | `resiliency_patterns` |
| A.5.31 | Legal, statutory, regulatory requirements | Compliance identification | `regulated_industry_context` |
| A.5.32 | Intellectual property rights | IP protection | Legal/policy |
| A.5.33 | Protection of records | Records management | `audit_logging_architecture` |
| A.5.34 | Privacy and protection of PII | Privacy program | `privacy_by_design` |
| A.5.35 | Independent review of info security | Internal/external audit | Internal audit (this skill) |
| A.5.36 | Compliance with policies and standards | Compliance verification | `compliance_as_code` |
| A.5.37 | Documented operating procedures | Runbooks and SOPs | `observability` |

#### Theme 2: People Controls (A.6) -- 8 Controls

| Control | Title | Summary |
|---------|-------|---------|
| A.6.1 | Screening | Background checks before employment |
| A.6.2 | Terms and conditions of employment | Security clauses in employment contracts |
| A.6.3 | Information security awareness, education, training | Annual security training program |
| A.6.4 | Disciplinary process | Consequences for security violations |
| A.6.5 | Responsibilities after termination | Post-employment obligations (NDA, data return) |
| A.6.6 | Confidentiality or non-disclosure agreements | NDA requirements |
| A.6.7 | Remote working | Remote work security controls |
| A.6.8 | Information security event reporting | Reporting mechanism for security events |

#### Theme 3: Physical Controls (A.7) -- 14 Controls

| Control | Title | Summary |
|---------|-------|---------|
| A.7.1 | Physical security perimeters | Defined secure areas |
| A.7.2 | Physical entry | Access control to facilities |
| A.7.3 | Securing offices, rooms, and facilities | Physical security of work areas |
| A.7.4 | Physical security monitoring | CCTV, sensors, alarms |
| A.7.5 | Protecting against physical and environmental threats | Fire, flood, power protection |
| A.7.6 | Working in secure areas | Rules for secure areas |
| A.7.7 | Clear desk and clear screen | Clean desk policy |
| A.7.8 | Equipment siting and protection | Secure equipment placement |
| A.7.9 | Security of assets off-premises | Laptop/device security outside office |
| A.7.10 | Storage media | Media handling and disposal |
| A.7.11 | Supporting utilities | Power, cooling, connectivity redundancy |
| A.7.12 | Cabling security | Network cable protection |
| A.7.13 | Equipment maintenance | Regular maintenance schedules |
| A.7.14 | Secure disposal or re-use of equipment | Data wiping before disposal |

#### Theme 4: Technological Controls (A.8) -- 34 Controls

| Control | Title | Framework Skill Mapping |
|---------|-------|----------------------|
| A.8.1 | User endpoint devices | Endpoint management policy |
| A.8.2 | Privileged access rights | `authorization_patterns` |
| A.8.3 | Information access restriction | `authorization_patterns` |
| A.8.4 | Access to source code | `git_workflow`, repository access controls |
| A.8.5 | Secure authentication | `auth_implementation` |
| A.8.6 | Capacity management | `observability`, resource monitoring |
| A.8.7 | Protection against malware | Container scanning, endpoint protection |
| A.8.8 | Management of technical vulnerabilities | `dependency_hygiene`, vulnerability scanning |
| A.8.9 | Configuration management | `compliance_as_code`, IaC |
| A.8.10 | Information deletion | Data retention and deletion procedures |
| A.8.11 | Data masking | `privacy_by_design`, field masking |
| A.8.12 | Data leakage prevention | DLP controls, egress filtering |
| A.8.13 | Information backup | Backup procedures and testing |
| A.8.14 | Redundancy of information processing facilities | Multi-AZ, failover |
| A.8.15 | Logging | `audit_logging_architecture` |
| A.8.16 | Monitoring activities | `runtime_security_monitoring`, `observability` |
| A.8.17 | Clock synchronization | NTP configuration |
| A.8.18 | Use of privileged utility programs | Restricted admin tools |
| A.8.19 | Installation of software on operational systems | Change management |
| A.8.20 | Networks security | Network segmentation, firewalls |
| A.8.21 | Security of network services | TLS, VPN, API gateway security |
| A.8.22 | Segregation of networks | Environment isolation (prod/staging/dev) |
| A.8.23 | Web filtering | URL filtering, proxy |
| A.8.24 | Use of cryptography | `secret_management`, encryption standards |
| A.8.25 | Secure development life cycle | Framework phase model, `code_review` |
| A.8.26 | Application security requirements | Security requirements in design |
| A.8.27 | Secure system architecture | `system_design_review` |
| A.8.28 | Secure coding | `code_review`, SAST/DAST |
| A.8.29 | Security testing in development and acceptance | `test_driven_build`, pentest |
| A.8.30 | Outsourced development | Vendor security requirements |
| A.8.31 | Separation of development, test, and production | Environment separation |
| A.8.32 | Change management | `git_workflow`, `code_review` |
| A.8.33 | Test information | Test data management (no production data) |
| A.8.34 | Protection of information systems during audit testing | Controlled audit access |

---

## PART 4: STATEMENT OF APPLICABILITY (SoA)

The SoA is the most important document in your ISMS. It lists every Annex A control with applicability status and justification.

```markdown
## Statement of Applicability (SoA)

| Organization | [Company Name] |
|-------------|---------------|
| ISMS Scope | [Scope statement] |
| ISO Standard | ISO/IEC 27001:2022 |
| Version | 1.0 |
| Approved by | [CISO/Management] |
| Date | [Date] |

### Control Applicability

| Control | Title | Applicable | Justification | Implementation Status | Evidence |
|---------|-------|-----------|--------------|----------------------|----------|
| A.5.1 | Policies for information security | Yes | Required for ISMS | Implemented | IS-POL-001 |
| A.5.2 | Information security roles | Yes | ISMS roles defined | Implemented | RACI matrix |
| A.5.3 | Segregation of duties | Yes | Financial data processing | Partial | Jira role config |
| ... | ... | ... | ... | ... | ... |
| A.7.1 | Physical security perimeters | No | Fully remote, cloud-hosted | N/A | Remote work policy |
| A.7.2 | Physical entry | No | No physical office | N/A | Remote work policy |
| ... | ... | ... | ... | ... | ... |
| A.8.15 | Logging | Yes | Audit requirements | Implemented | Audit log system |

### Applicability Summary
| Theme | Total Controls | Applicable | Not Applicable | Implemented | Partial | Not Started |
|-------|---------------|-----------|---------------|-------------|---------|-------------|
| Organizational (A.5) | 37 | 35 | 2 | 28 | 5 | 2 |
| People (A.6) | 8 | 8 | 0 | 6 | 2 | 0 |
| Physical (A.7) | 14 | 4 | 10 | 3 | 1 | 0 |
| Technological (A.8) | 34 | 32 | 2 | 24 | 6 | 2 |
| **Total** | **93** | **79** | **14** | **61** | **14** | **4** |
```

---

## PART 5: RISK TREATMENT PLAN

```markdown
## Risk Treatment Plan

| Risk ID | Risk | Treatment Option | Selected Controls | Action | Owner | Due | Status |
|---------|------|-----------------|-------------------|--------|-------|-----|--------|
| R-001 | Unauthorized DB access | Mitigate | A.5.15, A.5.17, A.8.5 | Implement MFA + RBAC | CTO | Q2 | In progress |
| R-002 | Source code theft | Mitigate | A.8.4, A.8.15 | Repo access review + audit logging | Eng Lead | Q2 | Open |
| R-003 | Laptop theft | Mitigate | A.7.9, A.8.1 | FDE + MDM enrollment | IT | Q2 | Open |
| R-004 | Office WiFi eavesdropping | Accept | N/A | Risk accepted by management | IT | N/A | Accepted |

### Treatment Options
- **Mitigate**: Apply controls to reduce risk to acceptable level
- **Transfer**: Insurance or contractual transfer to third party
- **Avoid**: Eliminate the activity that creates the risk
- **Accept**: Acknowledge and accept (must be within risk appetite, approved by management)
```

---

## PART 6: INTERNAL AUDIT PROGRAM (Clause 9.2)

### Audit Program Design

```markdown
## Internal Audit Program

### Audit Cycle: Annual (all ISMS clauses and applicable Annex A controls)

| Quarter | Audit Focus | Clauses/Controls | Auditor |
|---------|------------|-----------------|---------|
| Q1 | Governance and risk | 4, 5, 6.1, A.5.1-A.5.8 | [Internal/External] |
| Q2 | Access control and authentication | A.5.15-A.5.18, A.8.2-A.8.5 | [Internal/External] |
| Q3 | Operations and technology | 8, A.8.6-A.8.34 | [Internal/External] |
| Q4 | Performance evaluation, improvement | 9, 10, A.5.35-A.5.37 | [Internal/External] |

### Auditor Requirements
- Independence: Auditor must not audit their own work
- Competence: ISO 27001 Lead Auditor certification preferred
- Options: Trained internal staff, external consultant, or combination

### Audit Report Template
1. **Audit scope and objectives**
2. **Audit criteria** (ISO 27001:2022 clauses, SoA controls)
3. **Findings**: Nonconformities (major/minor), observations, opportunities for improvement
4. **Evidence reviewed**: Documents, interviews, system demonstrations
5. **Conclusion**: ISMS conformity assessment
6. **Corrective action requests** (with due dates and owners)
```

---

## PART 7: MANAGEMENT REVIEW (Clause 9.3)

```markdown
## Management Review Agenda Template

**Frequency**: At least annually (recommended: semi-annually)
**Attendees**: Top management, CISO/ISO, department heads, risk owners

### Required Inputs (Clause 9.3.2)
1. Status of actions from previous management reviews
2. Changes in external/internal issues relevant to ISMS
3. Changes in needs and expectations of interested parties
4. Feedback on information security performance:
   a. Nonconformities and corrective actions
   b. Monitoring and measurement results
   c. Audit results
   d. Fulfilment of information security objectives
5. Feedback from interested parties
6. Results of risk assessment and status of risk treatment plan
7. Opportunities for continual improvement

### Required Outputs (Clause 9.3.3)
1. Decisions on continual improvement opportunities
2. Decisions on changes to the ISMS (scope, policies, resources)
3. Resource allocation decisions
4. Updated risk treatment plan (if needed)

### Meeting Minutes Template
| Item | Discussion | Decision | Action | Owner | Due |
|------|-----------|----------|--------|-------|-----|
| Previous actions | [Status update] | [Closed/Extended] | [Follow-up] | [Name] | [Date] |
| Risk register changes | [New risks, closed risks] | [Approved] | [Update register] | CISO | [Date] |
| Audit findings | [Summary of Q3 audit] | [Accepted] | [Corrective actions] | [Names] | [Date] |
| Security incidents | [0 major, 2 minor in period] | [Noted] | [Trend monitoring] | SOC | Ongoing |
| Resource needs | [Headcount, tooling] | [Approved $X] | [Procurement] | CISO | [Date] |
```

---

## PART 8: CONTINUOUS IMPROVEMENT (Clause 10)

### PDCA Cycle for ISMS

```
    ┌──────────┐
    │   PLAN   │ Define scope, policy, risk assessment,
    │          │ risk treatment, SoA, objectives
    └────┬─────┘
         │
         v
    ┌──────────┐
    │    DO    │ Implement controls, train staff,
    │          │ operate ISMS, manage incidents
    └────┬─────┘
         │
         v
    ┌──────────┐
    │  CHECK   │ Internal audit, management review,
    │          │ monitoring, measurement, KPIs
    └────┬─────┘
         │
         v
    ┌──────────┐
    │   ACT    │ Corrective actions, preventive actions,
    │          │ continual improvement, update ISMS
    └──────────┘
```

### Corrective Action Process

```markdown
## Corrective Action Register

| CAR ID | Source | Finding | Root Cause | Corrective Action | Owner | Due | Verified | Status |
|--------|--------|---------|-----------|-------------------|-------|-----|----------|--------|
| CAR-001 | Internal audit Q2 | MFA not enforced for admin accounts | Configuration oversight | Enable MFA for all admin roles | IT | 2026-05-15 | Pending | Open |
| CAR-002 | Incident #47 | PHI accessed without audit log | Audit interceptor missing on new endpoint | Add @Audited decorator, add to CI check | Eng | 2026-05-01 | Pending | Open |
```

---

## PART 9: CERTIFICATION PROCESS

### Stage 1: Documentation Review (Readiness Assessment)

**What the auditor reviews:**
- ISMS scope and context documentation
- Information security policy
- Risk assessment methodology and risk register
- Risk treatment plan
- Statement of Applicability
- Internal audit reports
- Management review minutes
- Documented procedures for key processes

**Outcome**: Report of findings, confirmation of readiness for Stage 2, or list of gaps to address.

**Timeline**: 1-2 days on-site or remote, 4-8 weeks before Stage 2.

### Stage 2: Implementation Audit

**What the auditor verifies:**
- Controls are actually implemented (not just documented)
- Staff understand and follow security procedures
- Evidence of ISMS operation (logs, records, meeting minutes)
- Risk treatment plan is being executed
- Incidents have been managed per procedure
- Internal audit findings have been addressed
- Management reviews have occurred

**Outcome**: Certification recommendation (with or without minor nonconformities) or major nonconformities requiring remediation.

**Timeline**: 3-10 days depending on scope and organization size.

### Post-Certification

| Activity | Frequency | Purpose |
|----------|-----------|---------|
| Surveillance audit | Annual (Year 1, Year 2) | Verify continued conformity, sample controls |
| Recertification audit | Every 3 years | Full reassessment, new 3-year cycle |
| Internal audit | Annual (minimum) | Self-assessment, prepare for surveillance |
| Management review | Annual (minimum) | Executive oversight, resource decisions |
| Risk reassessment | Annual or on significant change | Update risk register, adjust controls |

### Certification Timeline

```markdown
## Implementation Roadmap

### Month 1-2: Foundation
- [ ] Define ISMS scope and context
- [ ] Establish information security policy
- [ ] Appoint ISMS roles (ISO, management representative)
- [ ] Define risk assessment methodology
- [ ] Conduct initial risk assessment

### Month 3-4: Risk Treatment
- [ ] Complete risk treatment plan
- [ ] Select Annex A controls
- [ ] Draft Statement of Applicability
- [ ] Begin implementing priority controls

### Month 5-8: Implementation
- [ ] Implement all applicable Annex A controls
- [ ] Develop required procedures and work instructions
- [ ] Conduct security awareness training
- [ ] Deploy technical controls (logging, access, encryption)
- [ ] Begin collecting operational evidence

### Month 9-10: Verification
- [ ] Conduct internal audit (all clauses and controls)
- [ ] Perform management review
- [ ] Address nonconformities from internal audit
- [ ] Verify corrective actions are effective
- [ ] Compile evidence portfolio

### Month 11: Stage 1 Audit
- [ ] Stage 1 documentation review with certification body
- [ ] Address any Stage 1 findings

### Month 12: Stage 2 Audit
- [ ] Stage 2 implementation audit
- [ ] Address any minor nonconformities
- [ ] Receive certification decision
```

---

## CROSS-REFERENCES

| Related Skill | Relationship |
|--------------|-------------|
| `regulated_industry_context` | Feeds industry context and regulatory requirements into ISMS scope |
| `audit_logging_architecture` | Implements A.8.15 (Logging) and A.5.28 (Evidence collection) |
| `compliance_as_code` | Automates control verification for A.5.36 and continuous monitoring |
| `compliance_program` | Ongoing compliance management that complements ISMS |
| `risk_register` | Risk register format aligns with ISO 27001 risk assessment requirements |
| `auth_implementation` | Implements A.5.16, A.5.17, A.8.5 authentication controls |
| `authorization_patterns` | Implements A.5.15, A.5.18, A.8.2, A.8.3 access controls |
| `secret_management` | Implements A.8.24 cryptography controls |
| `privacy_by_design` | Implements A.5.34 PII protection |
| `runtime_security_monitoring` | Implements A.5.7, A.5.25, A.8.16 monitoring controls |
| `supply_chain_audit` | Implements A.5.19-A.5.22 supplier security controls |
| `infrastructure_audit` | Implements A.5.23 cloud security and A.8.20-A.8.22 network controls |

---

## CHECKLIST

- [ ] Context of the organization documented (internal, external, interested parties)
- [ ] ISMS scope defined and documented
- [ ] Information security policy approved by management
- [ ] Risk assessment methodology documented
- [ ] Risk assessment performed, risk register populated
- [ ] Risk treatment plan created with control selection
- [ ] Statement of Applicability completed (all 93 controls addressed)
- [ ] All applicable Annex A controls implemented or in progress
- [ ] Security awareness training delivered to all staff
- [ ] Internal audit program designed and executed
- [ ] Management review conducted with required inputs/outputs
- [ ] Corrective actions tracked and verified for effectiveness
- [ ] Evidence portfolio compiled (policies, logs, meeting minutes, audit reports)
- [ ] Stage 1 audit scheduled with accredited certification body
- [ ] Stage 1 findings addressed
- [ ] Stage 2 audit completed and certification obtained
- [ ] Surveillance audit schedule established (annual)

---

*Skill Version: 1.0 | Phase: Toolkit (cross-cutting) | Priority: P1*
