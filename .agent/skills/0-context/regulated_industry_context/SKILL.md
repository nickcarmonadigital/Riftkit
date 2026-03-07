---
name: Regulated Industry Context
description: Identify regulated industry requirements, map applicable regulations to technical controls, and produce a compliance roadmap for projects in healthcare, finance, government, legal, education, insurance, and pharmaceuticals
---

# Regulated Industry Context Skill

**Purpose**: Systematically identify the regulated industry a project operates in, inventory every applicable regulation, map regulations to concrete technical controls, classify sensitive data, identify responsible compliance personnel, assess third-party compliance obligations, estimate compliance costs, and perform a gap analysis. Output is a Regulated Industry Context Document with a phased compliance roadmap. This prevents the catastrophic cost of discovering regulatory obligations after architecture decisions are locked.

> [!IMPORTANT]
> **Compliance is not optional in regulated industries.** A single HIPAA violation can cost $50K-$1.9M per incident. PCI-DSS non-compliance can result in $5K-$100K monthly fines. FedRAMP authorization takes 6-18 months. Identify requirements at project start, not at launch.

## TRIGGER COMMANDS

```text
"What regulations apply to this project"
"Regulated industry context for [healthcare/finance/government]"
"Map compliance requirements for [industry]"
"Identify regulatory obligations"
"Build compliance roadmap"
"What certifications do we need"
```

## When to Use
- Starting any project in healthcare, finance, government, legal, education, insurance, or pharmaceuticals
- Before making architecture, hosting, or vendor decisions
- When the project handles PHI, PCI data, student records, legal records, or government data
- When expanding an existing product into a regulated market
- When a client or stakeholder mentions compliance requirements
- As input to `compliance_context`, `risk_register`, and `architecture_recovery` skills

---

## PROCESS

### Step 1: Industry Identification

Determine the primary and secondary industries. A project can span multiple regulated domains (e.g., a health insurance platform touches Healthcare AND Insurance AND Finance).

**Industry Classification Matrix:**

| Industry | Key Signals | Primary Regulations |
|----------|------------|-------------------|
| Healthcare | PHI, patient records, EHR integration, medical devices | HIPAA, HITECH, FDA 21 CFR Part 11, HL7/FHIR mandates |
| Finance | Bank accounts, trading, lending, payments, credit scores | PCI-DSS, SOX, GLBA, Dodd-Frank, BSA/AML, FCRA |
| Legal | Case files, attorney-client communications, court filings | Attorney-client privilege rules, ABA Model Rules, state bar regulations, e-Discovery rules |
| Government | Federal/state agency data, .gov systems, citizen PII | FedRAMP, FISMA, NIST 800-53, ITAR, EAR, CJIS |
| Education | Student records, enrollment data, grades, financial aid | FERPA, COPPA (if under 13), state student privacy laws, CIPA |
| Insurance | Policy data, claims, actuarial data, underwriting | State insurance regulations, NAIC model laws, HIPAA (health insurance), GLBA |
| Pharmaceuticals | Clinical trial data, drug safety, manufacturing | FDA 21 CFR Part 11, GxP (GMP/GLP/GCP), ICH guidelines, EudraLex |

**Record your classification:**

```markdown
## Industry Classification

| Attribute | Value |
|-----------|-------|
| Primary Industry | Healthcare |
| Secondary Industries | Insurance, Finance |
| Justification | Platform processes PHI for health insurance claims and handles premium payments |
| Geographic Scope | United States (all 50 states), expanding to EU |
| Customer Segments | Health insurers, hospitals, individual patients |
| Data Types | PHI, PII, payment card data, insurance claims |
```

### Step 2: Regulatory Framework Inventory

For each identified industry, enumerate every applicable regulation. Consider data types, geography, customer segment, and business model.

**Healthcare Regulations:**

| Regulation | Applies When | Key Requirements |
|-----------|-------------|-----------------|
| HIPAA Privacy Rule | Any PHI handling | Minimum necessary use, patient rights, NPP |
| HIPAA Security Rule | Electronic PHI | Administrative, physical, technical safeguards |
| HIPAA Breach Notification | Any PHI handling | 60-day notification, HHS reporting |
| HITECH Act | Electronic health records | Meaningful use, enhanced penalties |
| FDA 21 CFR Part 11 | Electronic records/signatures in FDA-regulated context | Audit trails, electronic signatures, validation |
| State health privacy laws | Per state (e.g., CA CMIA, TX HB 300) | May exceed HIPAA requirements |

**Finance Regulations:**

| Regulation | Applies When | Key Requirements |
|-----------|-------------|-----------------|
| PCI-DSS v4.0 | Cardholder data processed/stored/transmitted | 12 requirement domains, SAQ or ROC |
| SOX (Sarbanes-Oxley) | Public companies, financial reporting systems | Internal controls, audit trails, Section 404 |
| GLBA (Gramm-Leach-Bliley) | Financial institutions, customer financial data | Privacy notices, safeguard rules, pretexting protection |
| BSA/AML | Money transmission, banking | KYC, suspicious activity reporting, CTR filing |
| FCRA | Consumer credit data | Permissible purpose, dispute resolution, accuracy |
| Dodd-Frank | Derivatives, swap dealers, consumer financial products | Reporting, clearing, consumer protection |

**Government Regulations:**

| Regulation | Applies When | Key Requirements |
|-----------|-------------|-----------------|
| FedRAMP | Cloud services for federal agencies | Authorization levels (Low/Moderate/High), 3PAO assessment |
| FISMA | Federal information systems | NIST 800-53 controls, continuous monitoring, POA&M |
| NIST 800-171 | CUI in non-federal systems (DoD contractors) | 110 security requirements, CMMC alignment |
| ITAR | Defense articles, technical data | Export controls, US person requirement, licensing |
| CJIS | Criminal justice information | Advanced authentication, encryption, audit logging |

**Education Regulations:**

| Regulation | Applies When | Key Requirements |
|-----------|-------------|-----------------|
| FERPA | Student education records | Parental consent, directory information, annual notification |
| COPPA | Children under 13 | Verifiable parental consent, data minimization |
| State student privacy | Per state (e.g., CA SOPIPA, NY Ed Law 2-d) | May restrict advertising, profiling, data sale |
| CIPA | Schools receiving E-Rate | Internet filtering, monitoring |

**Record your inventory:**

```markdown
## Regulatory Framework Inventory

| # | Regulation | Industry | Applies | Rationale | Compliance Deadline |
|---|-----------|----------|---------|-----------|-------------------|
| 1 | HIPAA Security Rule | Healthcare | Yes | Platform stores ePHI | Pre-launch |
| 2 | HIPAA Privacy Rule | Healthcare | Yes | PHI disclosed to insurers | Pre-launch |
| 3 | PCI-DSS v4.0 | Finance | Yes | Premium payments by card | Pre-launch |
| 4 | SOC 2 Type II | Cross-cutting | Yes | Enterprise customers require | Within 12 months |
| 5 | State privacy (CA CMIA) | Healthcare | Yes | CA patients in scope | Pre-launch |
```

### Step 3: Compliance Requirements Mapping

Map each regulation to specific technical controls. This bridges the gap between legal text and engineering work.

**Regulation-to-Control Mapping Template:**

```markdown
## Compliance Requirements Map

### HIPAA Security Rule -> Technical Controls

| HIPAA Requirement | Section | Technical Control | Implementation |
|------------------|---------|-------------------|----------------|
| Access control | 164.312(a) | RBAC with least privilege | Auth service with role-based permissions |
| Audit controls | 164.312(b) | Immutable audit logging | Append-only audit log with hash chain |
| Integrity controls | 164.312(c) | Data integrity verification | Checksums on PHI records, change tracking |
| Transmission security | 164.312(e) | TLS 1.2+ everywhere | Enforce HTTPS, encrypt inter-service traffic |
| Encryption at rest | 164.312(a)(2)(iv) | AES-256 encryption | Database-level + field-level for PHI |
| Emergency access | 164.312(a)(2)(ii) | Break-glass procedure | Emergency access with full audit trail |
| Automatic logoff | 164.312(a)(2)(iii) | Session timeout | 15-minute idle timeout for PHI access |
| Unique user ID | 164.312(a)(2)(i) | No shared accounts | Individual credentials, no generic logins |

### PCI-DSS v4.0 -> Technical Controls

| PCI Requirement | Section | Technical Control | Implementation |
|----------------|---------|-------------------|----------------|
| Firewall configuration | 1.x | Network segmentation | CDE isolated in separate VPC/subnet |
| No default passwords | 2.x | Credential management | Automated provisioning, no defaults |
| Protect stored data | 3.x | Encryption + tokenization | Tokenize PAN, never store CVV |
| Encrypt transmission | 4.x | TLS 1.2+ | Certificate pinning for payment APIs |
| Anti-malware | 5.x | Endpoint protection | Container scanning, runtime protection |
| Secure development | 6.x | SDLC controls | Code review, SAST/DAST, dependency scanning |
| Access restriction | 7.x | Need-to-know access | RBAC, PAM for admin access to CDE |
| Authentication | 8.x | MFA everywhere | MFA for all CDE access, 12-char minimum |
| Physical security | 9.x | Physical access control | Cloud provider responsibility (shared model) |
| Logging/monitoring | 10.x | Centralized log management | SIEM with 1-year retention, alerting |
| Regular testing | 11.x | Vulnerability management | Quarterly ASV scans, annual pentest |
| Security policy | 12.x | Information security policy | Documented, reviewed annually |
```

### Step 4: Data Classification

Classify every data type in the system by sensitivity level and handling requirements.

**Data Classification Framework:**

| Level | Label | Description | Examples | Handling Requirements |
|-------|-------|-------------|----------|----------------------|
| 4 | Restricted | Regulatory-protected, highest sensitivity | PHI, PAN, SSN, attorney-client privileged | Encrypted at rest + transit, field-level encryption, strict access logging, breach notification required |
| 3 | Confidential | Business-sensitive, internal only | Financial reports, source code, employee records | Encrypted at rest + transit, role-based access, audit logging |
| 2 | Internal | Not public but low risk if exposed | Internal docs, non-sensitive configs, analytics | Standard access controls, no public exposure |
| 1 | Public | Intended for public consumption | Marketing content, public APIs, documentation | No restrictions, integrity protection only |

**Data Classification Inventory:**

```markdown
## Data Classification Register

| Data Element | Classification | Regulation | Storage Location | Encryption | Access Control | Retention |
|-------------|---------------|-----------|-----------------|-----------|---------------|-----------|
| Patient name | L4 Restricted | HIPAA | patients table | AES-256 + field-level | Clinical staff only | 6 years post-treatment |
| Credit card PAN | L4 Restricted | PCI-DSS | Stripe (tokenized) | Stripe manages | Payment service only | Per Stripe policy |
| Student GPA | L4 Restricted | FERPA | students table | AES-256 | Registrar + advisors | 5 years post-graduation |
| Employee salary | L3 Confidential | Internal policy | hr_records | AES-256 | HR team only | Employment + 7 years |
| API docs | L1 Public | None | docs site | None | Public | Indefinite |
```

### Step 5: Compliance Officer / DPO Identification

Identify who is responsible for compliance oversight. Some regulations mandate specific roles.

**Required Roles by Regulation:**

| Regulation | Required Role | Mandatory? | Responsibilities |
|-----------|-------------|-----------|-----------------|
| HIPAA | Privacy Officer | Yes | PHI policies, breach response, training |
| HIPAA | Security Officer | Yes | Technical safeguards, risk analysis |
| GDPR | Data Protection Officer (DPO) | Conditional | Data processing oversight, DPIA, supervisory authority liaison |
| PCI-DSS | Internal Security Assessor (ISA) | Recommended | Ongoing compliance validation |
| FedRAMP | Authorizing Official (AO) | Yes | Risk acceptance, ATO issuance |
| SOX | Internal Audit Lead | Yes (public co.) | Financial control testing |
| FERPA | FERPA Compliance Officer | Yes | Student records policy, complaint handling |

```markdown
## Compliance Personnel

| Role | Person | Contact | Backup | Appointed Date |
|------|--------|---------|--------|---------------|
| HIPAA Privacy Officer | [Name] | [Email] | [Backup] | [Date] |
| HIPAA Security Officer | [Name] | [Email] | [Backup] | [Date] |
| DPO | [Name/External firm] | [Email] | [Backup] | [Date] |
| PCI ISA | [Name] | [Email] | [Backup] | [Date] |
| Compliance Sponsor (Exec) | [Name] | [Email] | N/A | [Date] |
```

### Step 6: Third-Party Compliance

Assess vendor and partner compliance obligations. You inherit risk from every third party that touches regulated data.

**Third-Party Assessment Template:**

```markdown
## Third-Party Compliance Inventory

| Vendor | Data Shared | Regulation | Agreement Type | Status | Expiry | Owner |
|--------|------------|-----------|---------------|--------|--------|-------|
| AWS | PHI (hosting) | HIPAA | BAA | Signed | Annual review | DevOps |
| Stripe | PAN (payments) | PCI-DSS | DPA + PCI AOC | Signed | 2026-12 | Finance |
| SendGrid | Email + name | GDPR | DPA | Signed | 2026-06 | Engineering |
| Analytics Co. | User behavior | CCPA | DPA | Pending | N/A | Product |
```

**Required Agreements by Regulation:**

| Regulation | Agreement Type | Required Contents |
|-----------|---------------|-------------------|
| HIPAA | Business Associate Agreement (BAA) | PHI use limits, safeguards, breach notification, termination |
| GDPR | Data Processing Agreement (DPA) | Processing purpose, duration, data types, sub-processor rules, SCCs if international |
| PCI-DSS | Service Provider Agreement | PCI compliance acknowledgment, responsibility matrix |
| FERPA | Data Sharing Agreement | Purpose limitation, re-disclosure prohibition, destruction requirements |

### Step 7: Compliance Budget Estimation

Estimate costs for achieving and maintaining compliance. Include people, tools, auditors, and certifications.

```markdown
## Compliance Budget Estimate

### One-Time Costs

| Item | Estimated Cost | Timeline | Notes |
|------|---------------|----------|-------|
| HIPAA risk assessment (external) | $15K-$50K | 4-8 weeks | Required before go-live |
| PCI-DSS SAQ-D + ASV scans | $5K-$25K | 6-12 weeks | Or $50K-$200K for ROC if Level 1 |
| SOC 2 Type I audit | $20K-$50K | 8-12 weeks | Readiness assessment first |
| FedRAMP 3PAO assessment | $150K-$500K | 6-18 months | Moderate baseline |
| ISO 27001 certification | $30K-$80K | 6-12 months | Stage 1 + Stage 2 audits |
| Compliance tooling setup | $10K-$30K | 2-4 weeks | GRC platform, SIEM, scanning |
| Legal review of policies | $10K-$25K | 2-4 weeks | Privacy policy, terms, BAAs |

### Recurring Annual Costs

| Item | Estimated Cost | Frequency | Notes |
|------|---------------|-----------|-------|
| SOC 2 Type II audit | $30K-$80K | Annual | Observation period: 6-12 months |
| PCI-DSS compliance validation | $5K-$50K | Annual | SAQ or ROC depending on level |
| Penetration testing | $15K-$50K | Annual (or quarterly) | Required by PCI, SOC 2, FedRAMP |
| Compliance officer (FTE or fractional) | $80K-$180K | Ongoing | Fractional: $2K-$8K/month |
| GRC platform license | $5K-$25K | Annual | Vanta, Drata, Secureframe, etc. |
| Security awareness training | $2K-$10K | Annual | Required by HIPAA, PCI, SOC 2 |
| Continuous monitoring tools | $5K-$20K | Annual | SIEM, vulnerability scanning |

### Total Estimate

| Scenario | Year 1 | Ongoing Annual |
|---------|--------|---------------|
| Single regulation (e.g., SOC 2 only) | $50K-$120K | $40K-$100K |
| Dual regulation (e.g., HIPAA + SOC 2) | $80K-$200K | $60K-$150K |
| Multi-regulation (HIPAA + PCI + SOC 2) | $120K-$350K | $80K-$200K |
| FedRAMP (Moderate) | $300K-$800K | $150K-$300K |
```

### Step 8: Gap Analysis

Assess current state against each regulation's requirements. This identifies what work remains.

**Gap Analysis Template:**

```markdown
## Gap Analysis: [Regulation Name]

| # | Requirement | Current State | Target State | Gap Severity | Remediation | Effort | Owner |
|---|------------|--------------|-------------|-------------|-------------|--------|-------|
| 1 | Encryption at rest | Database encrypted, no field-level | Field-level encryption for PHI | HIGH | Implement field-level encryption | 3 weeks | Backend |
| 2 | Audit logging | Application logs only | Immutable audit trail with hash chain | CRITICAL | Build audit_logging_architecture | 4 weeks | Platform |
| 3 | Access control | Basic RBAC | Attribute-based with break-glass | MEDIUM | Extend auth service | 2 weeks | Backend |
| 4 | Breach notification | No process | 60-day notification SOP | HIGH | Draft incident response plan | 1 week | Security |
| 5 | BAA with cloud provider | Not signed | Signed BAA with AWS | CRITICAL | Legal to execute | 1 week | Legal |

### Gap Summary

| Severity | Count | Estimated Total Effort |
|----------|-------|----------------------|
| CRITICAL | 2 | 5 weeks |
| HIGH | 2 | 4 weeks |
| MEDIUM | 1 | 2 weeks |
| LOW | 0 | 0 |
| **Total** | **5** | **11 weeks** |
```

### Step 9: Produce Regulated Industry Context Document

Compile all outputs into a single document:

```
.agent/docs/0-context/regulated-industry-context.md
```

**Document Structure:**
1. Industry Classification (Step 1)
2. Regulatory Framework Inventory (Step 2)
3. Compliance Requirements Map (Step 3)
4. Data Classification Register (Step 4)
5. Compliance Personnel (Step 5)
6. Third-Party Compliance Inventory (Step 6)
7. Compliance Budget Estimate (Step 7)
8. Gap Analysis per Regulation (Step 8)
9. Compliance Roadmap (phased plan derived from gap analysis)

**Compliance Roadmap Template:**

```markdown
## Compliance Roadmap

### Phase 1: Foundation (Weeks 1-4)
- [ ] Sign all required BAAs and DPAs
- [ ] Appoint compliance officers
- [ ] Complete data classification register
- [ ] Draft information security policies
- [ ] Set up GRC platform

### Phase 2: Critical Controls (Weeks 5-12)
- [ ] Implement encryption (at-rest + field-level for L4 data)
- [ ] Build immutable audit logging (see audit_logging_architecture skill)
- [ ] Deploy access control with RBAC/ABAC
- [ ] Establish incident response procedure
- [ ] Complete employee security training

### Phase 3: Validation (Weeks 13-20)
- [ ] Conduct internal audit against each regulation
- [ ] Perform penetration testing
- [ ] Run vulnerability scans (ASV for PCI)
- [ ] Complete risk assessment documentation
- [ ] Remediate findings from internal audit

### Phase 4: Certification (Weeks 21-30)
- [ ] Engage external auditor (SOC 2 Type I, PCI SAQ/ROC, etc.)
- [ ] Submit FedRAMP package (if applicable)
- [ ] Obtain certifications
- [ ] Establish continuous monitoring program
- [ ] Schedule surveillance/recertification audits
```

---

## CROSS-REFERENCES

| Related Skill | Relationship |
|--------------|-------------|
| `compliance_context` | This skill feeds into compliance_context with deeper regulated-industry specifics |
| `risk_register` | Gap analysis findings become risk register entries |
| `audit_logging_architecture` | Technical implementation of audit controls identified here |
| `iso_27001_implementation` | If ISO 27001 is identified as required, use that skill for implementation |
| `compliance_as_code` | Automate the controls identified in the requirements map |
| `compliance_program` | Ongoing compliance program management after initial context is established |
| `privacy_by_design` | Data classification and handling requirements feed privacy architecture |
| `secret_management` | Encryption key management for regulated data |

---

## CHECKLIST

- [ ] Primary and secondary industries identified with justification
- [ ] Every applicable regulation inventoried with compliance deadlines
- [ ] Regulations mapped to specific technical controls
- [ ] All data types classified by sensitivity level (L1-L4)
- [ ] Handling requirements defined for each data classification level
- [ ] Compliance officers / DPO identified and appointed
- [ ] Third-party vendors assessed and required agreements cataloged
- [ ] BAAs, DPAs, and service provider agreements tracked with status and expiry
- [ ] Compliance budget estimated (one-time and recurring)
- [ ] Gap analysis completed for each applicable regulation
- [ ] Gaps prioritized by severity (Critical > High > Medium > Low)
- [ ] Compliance roadmap produced with phased milestones
- [ ] Document saved to `.agent/docs/0-context/regulated-industry-context.md`
- [ ] Findings fed into `risk_register` and `compliance_context` skills

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
