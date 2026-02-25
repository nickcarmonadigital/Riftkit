---
name: Privacy By Design Testing
description: DPIA assessment, PII discovery with Presidio, consent verification, and right-to-erasure cascade testing
---

# Privacy By Design Testing Skill

**Purpose**: Verify that privacy protections are implemented correctly through automated testing. This skill covers Data Protection Impact Assessment (DPIA) trigger evaluation, automated PII discovery in code and test data using Microsoft Presidio, consent management verification tests, right-to-erasure cascade validation, and data minimization assessment to detect over-collection in API schemas.

## TRIGGER COMMANDS

```text
"Privacy impact assessment"
"DPIA for [feature]"
"GDPR compliance testing"
"Scan for PII in codebase"
"Right to erasure test"
```

## When to Use
- Launching a new feature that processes personal data
- Performing a DPIA for high-risk processing activities (GDPR Article 35)
- Verifying that right-to-erasure actually cascades through all data stores
- Auditing test fixtures and seed data for real PII
- Assessing whether API endpoints collect more data than necessary

---

## PROCESS

### Step 1: DPIA Trigger Assessment

Determine if a Data Protection Impact Assessment is required (GDPR Article 35):

| Trigger Condition | Applies? | Notes |
|-------------------|----------|-------|
| Systematic profiling with legal/significant effects | | Automated decision-making |
| Large-scale processing of special category data | | Health, biometric, genetic data |
| Systematic monitoring of public areas | | CCTV, location tracking |
| New technology processing personal data | | AI/ML on personal data |
| Cross-border data transfers | | EU to non-adequate countries |
| Processing of children's data | | Under 16 (or local threshold) |
| Combined datasets from multiple sources | | Data enrichment/matching |

If two or more triggers apply, a DPIA is mandatory.

**DPIA Template Output (`docs/compliance/dpia-[feature].md`):**

```markdown
# Data Protection Impact Assessment

## Feature: [Feature Name]
## Date: [Date] | Assessor: [Name]

### 1. Processing Description
- Data subjects: [who]
- Data types: [what PII]
- Purpose: [why]
- Legal basis: [consent/legitimate interest/contract]

### 2. Necessity and Proportionality
- Is this processing necessary for the stated purpose?
- Could the purpose be achieved with less data?
- Data retention period justified?

### 3. Risk Assessment
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Unauthorized access | | | |
| Data breach | | | |
| Purpose creep | | | |

### 4. Mitigations Implemented
- [ ] Encryption at rest and in transit
- [ ] Access control (role-based)
- [ ] Audit logging
- [ ] Data minimization
- [ ] Consent management

### 5. DPO Sign-Off
- Status: APPROVED / CONDITIONAL / REJECTED
```

### Step 2: PII Discovery with Microsoft Presidio

Scan codebase, test fixtures, and log outputs for personally identifiable information:

```bash
# Install Presidio
pip install presidio-analyzer presidio-anonymizer

# Install spaCy model
python -m spacy download en_core_web_lg
```

**PII Scanner Script (`scripts/pii-scan.py`):**

```python
import os
import json
from presidio_analyzer import AnalyzerEngine

analyzer = AnalyzerEngine()

PII_ENTITIES = [
    "PERSON", "EMAIL_ADDRESS", "PHONE_NUMBER", "CREDIT_CARD",
    "US_SSN", "IP_ADDRESS", "IBAN_CODE", "MEDICAL_LICENSE",
    "US_PASSPORT", "US_DRIVER_LICENSE"
]

def scan_file(filepath):
    """Scan a single file for PII entities."""
    with open(filepath, 'r', errors='ignore') as f:
        content = f.read()
    results = analyzer.analyze(text=content, entities=PII_ENTITIES, language='en')
    return [
        {"entity": r.entity_type, "score": r.score, "start": r.start, "end": r.end}
        for r in results if r.score > 0.7
    ]

def scan_directory(directory, extensions=('.ts', '.json', '.sql', '.csv', '.yml')):
    """Scan all matching files in directory for PII."""
    findings = {}
    for root, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if d not in ('node_modules', '.git', 'dist')]
        for f in files:
            if any(f.endswith(ext) for ext in extensions):
                path = os.path.join(root, f)
                result = scan_file(path)
                if result:
                    findings[path] = result
    return findings

if __name__ == '__main__':
    findings = scan_directory('.')
    print(json.dumps(findings, indent=2))
    if findings:
        print(f"\nWARNING: PII detected in {len(findings)} files")
        exit(1)
```

**Scan targets:**
- `test/fixtures/` -- test data must use synthetic PII
- `seed/` -- database seed files
- `*.sql` -- migration files with sample data
- `*.log` -- log output samples
- `docs/` -- documentation with example data

### Step 3: Consent Management Verification Tests

```typescript
describe('Consent Management', () => {
  it('should not process data without valid consent record', async () => {
    const user = await createTestUser(prisma, jwtService);

    // Attempt to enable marketing emails without consent
    const response = await request(app.getHttpServer())
      .post('/api/users/me/preferences')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ marketingEmails: true })
      .expect(400);

    expect(response.body.message).toContain('consent required');
  });

  it('should record consent with timestamp and version', async () => {
    const user = await createTestUser(prisma, jwtService);

    await request(app.getHttpServer())
      .post('/api/consent')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ type: 'marketing', granted: true, policyVersion: '2.1' })
      .expect(201);

    const consent = await prisma.consentRecord.findFirst({
      where: { userId: user.id, type: 'marketing' },
    });
    expect(consent).not.toBeNull();
    expect(consent!.grantedAt).toBeDefined();
    expect(consent!.policyVersion).toBe('2.1');
  });

  it('should allow consent withdrawal at any time', async () => {
    const user = await createTestUser(prisma, jwtService);

    // Grant then withdraw
    await request(app.getHttpServer())
      .post('/api/consent')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ type: 'marketing', granted: true, policyVersion: '2.1' })
      .expect(201);

    await request(app.getHttpServer())
      .post('/api/consent')
      .set('Authorization', `Bearer ${user.token}`)
      .send({ type: 'marketing', granted: false, policyVersion: '2.1' })
      .expect(201);

    const consent = await prisma.consentRecord.findFirst({
      where: { userId: user.id, type: 'marketing' },
      orderBy: { createdAt: 'desc' },
    });
    expect(consent!.granted).toBe(false);
  });
});
```

### Step 4: Right-to-Erasure Cascade Tests

```typescript
describe('Right to Erasure (GDPR Article 17)', () => {
  it('should cascade delete across all user-linked tables', async () => {
    const user = await createTestUser(prisma, jwtService);
    const userId = user.id;

    // Create related records
    await prisma.document.create({ data: { title: 'Doc', orgId: user.orgId, createdById: userId } });
    await prisma.consentRecord.create({ data: { userId, type: 'marketing', granted: true, policyVersion: '1.0' } });

    // Execute erasure
    await request(app.getHttpServer())
      .delete('/api/users/me')
      .set('Authorization', `Bearer ${user.token}`)
      .expect(200);

    // Verify cascade across ALL tables containing user data
    expect(await prisma.user.findUnique({ where: { id: userId } })).toBeNull();
    expect(await prisma.document.findMany({ where: { createdById: userId } })).toHaveLength(0);
    expect(await prisma.consentRecord.findMany({ where: { userId } })).toHaveLength(0);
  });

  it('should anonymize audit logs instead of deleting them', async () => {
    const user = await createTestUser(prisma, jwtService);

    await request(app.getHttpServer())
      .delete('/api/users/me')
      .set('Authorization', `Bearer ${user.token}`)
      .expect(200);

    const auditLogs = await prisma.auditLog.findMany({
      where: { entityId: user.id },
    });
    for (const log of auditLogs) {
      expect(log.actorEmail).toBe('REDACTED');
      expect(log.metadata).not.toContain(user.email);
    }
  });
});
```

### Step 5: Data Minimization Assessment

Review API request schemas for over-collection:

```typescript
// Automated check: compare DTO fields to actual usage
describe('Data Minimization', () => {
  it('should not collect unnecessary fields in registration', () => {
    const registrationDto = {
      email: 'test@example.com',
      password: 'SecurePass123!',
      name: 'Test User',
    };

    // These fields should NOT be in registration DTO
    const overCollectionFields = [
      'dateOfBirth', 'phoneNumber', 'address',
      'socialSecurityNumber', 'driversLicense',
    ];

    for (const field of overCollectionFields) {
      expect(registrationDto).not.toHaveProperty(field);
    }
  });
});
```

---

## CHECKLIST

- [ ] DPIA trigger assessment completed for each feature processing personal data
- [ ] DPIA document produced for features meeting two or more triggers
- [ ] Presidio PII scan run against test fixtures, seed data, and log samples
- [ ] All test data uses synthetic PII (no real names, emails, SSNs)
- [ ] Consent management tests verify grant, withdrawal, and timestamp recording
- [ ] Right-to-erasure cascade test covers all tables with user foreign keys
- [ ] Audit logs are anonymized (not deleted) during erasure
- [ ] Data minimization assessment confirms no over-collection in DTOs
- [ ] PII scan integrated into CI (fails if real PII found in test data)
- [ ] DPIA and PII scan reports stored as compliance evidence

*Skill Version: 1.0 | Created: February 2026*
