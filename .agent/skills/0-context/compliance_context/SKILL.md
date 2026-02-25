---
name: Compliance Context
description: Inventory applicable regulatory frameworks and produce a compliance posture baseline
---

# Compliance Context Skill

**Purpose**: Determine which regulatory frameworks apply to the project based on product type, geography, and customer segment. Perform a Personal Data Inventory, document the legal basis for data processing, verify consent management, and produce a compliance posture score per framework. This prevents costly late-stage compliance discoveries.

## TRIGGER COMMANDS

```text
"What compliance requirements apply"
"Map regulatory obligations"
"Privacy engineering baseline"
```

## When to Use
- Starting any project that handles user data
- Before designing data models or authentication systems
- When expanding to new geographies or customer segments
- When a stakeholder mentions compliance requirements during `stakeholder_map`

---

## PROCESS

### Step 1: Determine Applicable Frameworks

Answer each question to identify which frameworks apply:

| Question | If Yes, Framework Applies |
|----------|--------------------------|
| Do you store data of EU residents? | GDPR |
| Do you store data of California residents? | CCPA/CPRA |
| Do you handle health information? | HIPAA |
| Do you process payment card data? | PCI-DSS |
| Do customers require audit reports? | SOC 2 |
| Is ISO certification required contractually? | ISO 27001 |
| Do you serve US federal agencies? | FedRAMP |
| Do you handle children's data (under 13/16)? | COPPA / GDPR Art. 8 |

Record each applicable framework with rationale:

```markdown
## Applicable Frameworks

| Framework | Applies | Rationale |
|-----------|---------|-----------|
| GDPR | Yes | EU users in scope, personal data collected |
| CCPA | No | No California-targeted operations |
| HIPAA | No | No PHI processed |
| PCI-DSS | Yes | Credit card payments via Stripe |
| SOC 2 | Pending | Enterprise customers may require |
```

### Step 2: Personal Data Inventory (PII Mapping)

For each type of personal data, document the full lifecycle:

```markdown
## Personal Data Inventory

| Data Element | Collected | Stored | Retention | Shared With | Deletion Method |
|-------------|-----------|--------|-----------|-------------|-----------------|
| Email | Registration | users table | Account lifetime + 30d | SendGrid (email) | Hard delete |
| Name | Registration | users table | Account lifetime + 30d | None | Hard delete |
| IP Address | Every request | logs table | 90 days | None | Auto-purge |
| Payment info | Checkout | Stripe only | Per Stripe policy | Stripe | Stripe handles |
| Location | Opt-in | preferences | Account lifetime | None | Hard delete |
```

### Step 3: Document Legal Basis for Processing

For GDPR (and similar frameworks), each processing activity needs a legal basis:

```markdown
## Legal Basis for Processing

| Processing Activity | Legal Basis | Justification |
|--------------------|-------------|---------------|
| Account creation | Contract (Art. 6(1)(b)) | Necessary to provide the service |
| Marketing emails | Consent (Art. 6(1)(a)) | Opt-in checkbox at registration |
| Fraud detection | Legitimate interest (Art. 6(1)(f)) | Security of the platform |
| Analytics | Consent (Art. 6(1)(a)) | Cookie consent banner |
| Legal compliance | Legal obligation (Art. 6(1)(c)) | Tax records retention |
```

### Step 4: Verify Consent Management

Check each consent mechanism:

- [ ] Cookie consent banner present and functional
- [ ] Consent is granular (separate purposes, not bundled)
- [ ] Consent is freely given (no dark patterns, no pre-checked boxes)
- [ ] Consent records stored with timestamp and version
- [ ] Withdrawal mechanism exists and is as easy as giving consent
- [ ] Privacy policy is accessible and up to date
- [ ] Data Subject Access Request (DSAR) process defined

### Step 5: Score Compliance Posture

For each applicable framework, rate current compliance:

```markdown
## Compliance Posture Scores

| Framework | Score | Rating | Key Gaps |
|-----------|-------|--------|----------|
| GDPR | 6/10 | Partial | Missing DSAR process, no DPO assigned |
| PCI-DSS | 8/10 | Good | Stripe handles most; need to verify no card data in logs |
| SOC 2 | 3/10 | Low | No formal controls documented |
```

**Scoring Guide**: 1-3 = Critical gaps, 4-6 = Partial compliance, 7-8 = Good with minor gaps, 9-10 = Fully compliant.

### Step 6: Produce Compliance Context Document

Save the combined output to:

```
.agent/docs/0-context/compliance-context.md
```

---

## CHECKLIST

- [ ] All applicable regulatory frameworks identified with rationale
- [ ] Personal Data Inventory completed for every PII element
- [ ] Legal basis documented for each processing activity
- [ ] Consent mechanisms verified (banner, granularity, withdrawal)
- [ ] Compliance posture scored per framework
- [ ] Key gaps identified with remediation priority
- [ ] Document saved to `.agent/docs/0-context/compliance-context.md`
- [ ] Findings fed into `risk_register` skill

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P1*
