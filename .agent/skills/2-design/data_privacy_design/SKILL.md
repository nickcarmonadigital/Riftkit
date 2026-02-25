---
name: Data Privacy Design
description: PII classification, data residency, retention policies, right-to-erasure design, and GDPR Article 30 RoPA compliance
---

# Data Privacy Design Skill

**Purpose**: Designs the privacy architecture during Phase 2 so that data protection is built into the system from the start rather than retrofitted. Covers PII classification, data residency constraints, retention policies, erasure strategies, consent architecture, and regulatory documentation templates.

## TRIGGER COMMANDS

```text
"Design data privacy for [system]"
"GDPR compliance design"
"PII classification"
```

## When to Use
- When the system collects, stores, or processes personal data
- When operating in GDPR, CCPA, HIPAA, or similar regulatory jurisdictions
- Before designing database schemas that will hold user data
- When third-party data processors are involved (analytics, payment, email)

---

## PROCESS

### Step 1: PII Classification Matrix

Classify every data field in the system by privacy tier:

| Tier | Classification | Examples | Handling Requirements |
|------|---------------|----------|----------------------|
| T0 | Public | Product names, public content | No restrictions |
| T1 | Internal | User IDs, timestamps | Access logging |
| T2 | Sensitive-PII | Email, name, phone, IP address | Encryption at rest, access control |
| T3 | Sensitive-PHI | Health data, disability status | Encryption + audit trail + DPA |
| T4 | Sensitive-Financial | Payment cards, bank accounts | PCI-DSS scope, tokenization |

Produce a field-level classification table:

```markdown
## Field Classification

| Entity | Field | Tier | Encrypted | Retention | Legal Basis |
|--------|-------|------|-----------|-----------|-------------|
| User | email | T2 | Yes | Account lifetime + 30d | Contract |
| User | name | T2 | Yes | Account lifetime + 30d | Contract |
| User | ip_address | T2 | No | 90 days | Legitimate interest |
| Payment | card_last4 | T4 | Tokenized | 7 years | Legal obligation |
| HealthRecord | diagnosis | T3 | Yes (AES-256) | As required by law | Explicit consent |
```

### Step 2: Data Residency Map

Document where data is stored and processed geographically:

```markdown
## Data Residency

| Data Category | Storage Location | Processing Location | Transfer Mechanism |
|---------------|-----------------|--------------------|--------------------|
| User PII | EU (Frankfurt) | EU (Frankfurt) | N/A (same region) |
| Analytics | US (Virginia) | US (Virginia) | SCCs + DPA |
| Backups | EU (Ireland) | N/A | Encrypted at rest |
| CDN Cache | Global edge | Global edge | No PII in cache |
```

Flag any cross-border transfers that require Standard Contractual Clauses (SCCs) or adequacy decisions.

### Step 3: Retention Policy Specification

Define retention periods per data category:

```markdown
## Retention Policy

| Data Category | Retention Period | Trigger | Disposal Method |
|---------------|-----------------|---------|-----------------|
| Active user data | Account lifetime | Account deletion request | Anonymize or delete |
| Inactive user data | 2 years after last login | Automated check | Anonymize |
| Access logs | 90 days | Rolling window | Hard delete |
| Financial records | 7 years | Regulatory requirement | Archive then delete |
| Support tickets | 3 years | Ticket closure date | Anonymize PII fields |
```

### Step 4: Right-to-Erasure Design

Design the erasure strategy for GDPR Article 17 / CCPA deletion requests:

```markdown
## Erasure Strategy Decision

| Approach | When to Use | Trade-offs |
|----------|-------------|------------|
| **Hard Delete** | No referential integrity deps | Clean but may break FKs |
| **Anonymization** | Data needed for analytics | Retains structure, removes PII |
| **Pseudonymization** | Reversibility may be needed | Key management overhead |
| **Cascade Delete** | Entire user context is disposable | Simplest but most destructive |

## Chosen Strategy: [Anonymization with cascade for orphans]

### Erasure Procedure
1. Receive deletion request via API or admin panel
2. Verify identity of requestor
3. Queue erasure job (async, within 30-day GDPR window)
4. Anonymize T2+ fields: replace with `REDACTED-{hash}`
5. Hard-delete orphaned records with no analytical value
6. Purge from backups within next backup rotation cycle
7. Log erasure completion (retain log, not the data)
8. Confirm to requestor
```

### Step 5: Consent Architecture

Design the consent management system:

```markdown
## Consent Model

| Purpose | Legal Basis | Consent Required? | Withdrawal UX |
|---------|-------------|-------------------|---------------|
| Account creation | Contract | No (contractual necessity) | Delete account |
| Marketing emails | Consent | Yes (opt-in) | Unsubscribe link |
| Analytics tracking | Legitimate interest | No (with opt-out) | Privacy settings |
| AI training on data | Consent | Yes (explicit opt-in) | Settings toggle |
```

### Step 6: GDPR Article 30 RoPA Template

Produce the Record of Processing Activities:

```markdown
## Record of Processing Activities (RoPA)

| Field | Value |
|-------|-------|
| Controller | [Company name and contact] |
| DPO Contact | [email] |
| Processing Purpose | [e.g., Service delivery, analytics] |
| Categories of Data Subjects | [e.g., Customers, employees] |
| Categories of Personal Data | [e.g., Name, email, IP] |
| Recipients | [e.g., Payment processor, analytics] |
| Transfers to Third Countries | [Yes/No, mechanism] |
| Retention Periods | [per category, from Step 3] |
| Technical Measures | [encryption, access control, backups] |
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/data-privacy-design.md`

---

## CHECKLIST

- [ ] Every PII field classified by tier (T0-T4)
- [ ] Encryption requirements specified per tier
- [ ] Data residency map covers all storage locations
- [ ] Cross-border transfers have legal mechanisms identified
- [ ] Retention periods defined for every data category
- [ ] Erasure strategy chosen with implementation procedure
- [ ] Consent model documents legal basis per processing purpose
- [ ] RoPA template completed for primary processing activities
- [ ] Schema annotations planned for privacy tier metadata
- [ ] Third-party data processors listed with DPA status

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
