---
name: HIPAA Compliance Testing
description: Comprehensive HIPAA Security Rule testing for applications handling Protected Health Information (PHI)
---

# HIPAA Compliance Testing Skill

**Purpose**: Structured testing methodology for verifying HIPAA Security Rule compliance (45 CFR 164.308-312) in applications that create, receive, maintain, or transmit electronic Protected Health Information (ePHI). Maps technical controls to regulatory requirements with actionable test cases and auditor-ready evidence templates.

---

## TRIGGER COMMANDS

```text
"Run HIPAA compliance tests on [project]"
"Verify PHI protections in [application]"
"HIPAA security rule audit for [system]"
"Test PHI access controls and encryption"
"Using hipaa_compliance_testing skill: [task]"
```

---

> [!WARNING]
> This skill provides **technical testing guidance only**. It is NOT legal advice. ALWAYS engage a qualified HIPAA compliance officer and legal counsel. HIPAA violations carry penalties from $100 to $50,000 per violation (up to $1.5M per year per category), plus potential criminal penalties including imprisonment.

---

## PHI IDENTIFICATION AND CLASSIFICATION

### What Qualifies as PHI

PHI is any individually identifiable health information held or transmitted by a covered entity or business associate. It includes **all 18 HIPAA identifiers** when combined with health data:

| # | Identifier | Examples | Detection Pattern |
|---|-----------|----------|-------------------|
| 1 | Names | Full name, maiden name | Regex: name fields, free text |
| 2 | Geographic data (smaller than state) | Street address, city, ZIP | Address fields, geo coordinates |
| 3 | Dates (except year) | Birth date, admission date, discharge date | Date fields associated with patients |
| 4 | Phone numbers | Mobile, home, work | `\d{3}[-.]?\d{3}[-.]?\d{4}` |
| 5 | Fax numbers | Fax line | Similar to phone pattern |
| 6 | Email addresses | Patient email | `[\w.]+@[\w.]+\.\w+` |
| 7 | SSN | Social Security Number | `\d{3}-\d{2}-\d{4}` |
| 8 | Medical record numbers | MRN, chart number | System-specific format |
| 9 | Health plan beneficiary numbers | Insurance ID | Payer-specific format |
| 10 | Account numbers | Patient account | Numeric identifiers |
| 11 | Certificate/license numbers | DEA, NPI | Provider identifiers |
| 12 | Vehicle identifiers | VIN, plates | Vehicle-related fields |
| 13 | Device identifiers | Serial numbers, UDI | Medical device fields |
| 14 | Web URLs | Patient portal links | URL fields with patient context |
| 15 | IP addresses | Access logs with patient context | `\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}` |
| 16 | Biometric identifiers | Fingerprints, voiceprints | Binary/encoded biometric data |
| 17 | Full-face photos | Profile images | Image files linked to patients |
| 18 | Any unique identifying number | Custom IDs | Any field that can re-identify |

### PHI Data Flow Mapping

Before testing, map where PHI flows through the system:

```markdown
## PHI Data Flow Map

| Data Element | Source | Storage | Processing | Transmission | Disposal |
|-------------|--------|---------|------------|--------------|----------|
| Patient name | Registration form | PostgreSQL `patients` table | Display, search | API responses, HL7 | Retention policy |
| DOB | Registration form | PostgreSQL `patients` table | Age calculation | API responses | Retention policy |
| Diagnosis codes | EHR integration | PostgreSQL `encounters` table | Billing, analytics | Claims submission | Retention policy |
| Lab results | HL7 feed | PostgreSQL `lab_results` table | Display, alerting | API responses, FHIR | Retention policy |

**PHI touchpoints requiring protection**: [count]
**Systems with PHI access**: [list]
**Third-party PHI sharing**: [list with BAA status]
```

---

## HIPAA SECURITY RULE CONTROL MAPPING

### Administrative Safeguards (164.308)

| Control | Requirement | Test Approach |
|---------|------------|---------------|
| 164.308(a)(1) | Security management process | Verify risk assessment documentation exists and is current |
| 164.308(a)(3) | Workforce security | Test role provisioning/deprovisioning, verify termination procedures |
| 164.308(a)(4) | Information access management | Test access authorization workflows, verify minimum necessary |
| 164.308(a)(5) | Security awareness training | Verify training records, test phishing awareness |
| 164.308(a)(6) | Security incident procedures | Test incident response plan, verify reporting timelines |
| 164.308(a)(7) | Contingency plan | Test backup/restore, verify disaster recovery procedures |
| 164.308(a)(8) | Evaluation | Verify periodic technical and nontechnical evaluation |

### Physical Safeguards (164.310)

| Control | Requirement | Test Approach |
|---------|------------|---------------|
| 164.310(a)(1) | Facility access controls | Verify physical access logs, test badge/key controls |
| 164.310(b) | Workstation use | Verify workstation policies, test screen lock enforcement |
| 164.310(c) | Workstation security | Verify physical positioning, test encryption on workstations |
| 164.310(d)(1) | Device and media controls | Test media disposal procedures, verify encryption on portable devices |

### Technical Safeguards (164.312) -- Primary Testing Focus

| Control | Requirement | Test Type | Priority |
|---------|------------|-----------|----------|
| 164.312(a)(1) | Access control | Integration test | CRITICAL |
| 164.312(a)(2)(i) | Unique user identification | Unit test | CRITICAL |
| 164.312(a)(2)(ii) | Emergency access procedure | Manual + integration test | HIGH |
| 164.312(a)(2)(iii) | Automatic logoff | Integration test | HIGH |
| 164.312(a)(2)(iv) | Encryption and decryption | Config verification + unit test | CRITICAL |
| 164.312(b) | Audit controls | Integration test | CRITICAL |
| 164.312(c)(1) | Integrity controls | E2E test | HIGH |
| 164.312(c)(2) | Mechanism to authenticate ePHI | Unit test | HIGH |
| 164.312(d) | Person or entity authentication | Integration test | CRITICAL |
| 164.312(e)(1) | Transmission security | Config verification | CRITICAL |
| 164.312(e)(2)(i) | Integrity controls (transmission) | Integration test | HIGH |
| 164.312(e)(2)(ii) | Encryption (transmission) | Config verification | CRITICAL |

---

## ACCESS CONTROL TESTING (164.312(a))

### Test 1: RBAC Verification

```typescript
describe('HIPAA Access Control - RBAC', () => {
  it('should enforce role-based access to PHI endpoints', async () => {
    const roles = ['patient', 'nurse', 'physician', 'admin', 'billing'];
    const phiEndpoints = [
      { path: '/api/patients/:id/records', allowedRoles: ['physician', 'nurse', 'admin'] },
      { path: '/api/patients/:id/billing', allowedRoles: ['billing', 'admin'] },
      { path: '/api/patients/:id/medications', allowedRoles: ['physician', 'nurse', 'admin'] },
      { path: '/api/patients/:id/psychotherapy-notes', allowedRoles: ['physician'] },
    ];

    for (const endpoint of phiEndpoints) {
      for (const role of roles) {
        const token = await getTokenForRole(role);
        const res = await request(app.getHttpServer())
          .get(endpoint.path.replace(':id', testPatientId))
          .set('Authorization', `Bearer ${token}`);

        if (endpoint.allowedRoles.includes(role)) {
          expect(res.status).not.toBe(403);
        } else {
          expect(res.status).toBe(403);
        }
      }
    }
  });

  it('should enforce minimum necessary principle', async () => {
    // Nurse should see vitals but not psychotherapy notes
    const nurseToken = await getTokenForRole('nurse');
    const res = await request(app.getHttpServer())
      .get(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${nurseToken}`);

    expect(res.body.data).toHaveProperty('vitals');
    expect(res.body.data).not.toHaveProperty('psychotherapyNotes');
  });
});
```

### Test 2: Emergency Access (Break-the-Glass)

```typescript
describe('HIPAA Emergency Access', () => {
  it('should allow emergency access with audit trail', async () => {
    const nurseToken = await getTokenForRole('nurse');

    // Normal access to restricted record should fail
    const normalRes = await request(app.getHttpServer())
      .get(`/api/patients/${restrictedPatientId}/records`)
      .set('Authorization', `Bearer ${nurseToken}`);
    expect(normalRes.status).toBe(403);

    // Emergency access with reason should succeed
    const emergencyRes = await request(app.getHttpServer())
      .get(`/api/patients/${restrictedPatientId}/records`)
      .set('Authorization', `Bearer ${nurseToken}`)
      .set('X-Emergency-Access', 'true')
      .set('X-Emergency-Reason', 'Patient in cardiac arrest, need medication history');
    expect(emergencyRes.status).toBe(200);

    // Verify emergency access was logged
    const auditLog = await prisma.auditLog.findFirst({
      where: {
        action: 'EMERGENCY_ACCESS',
        entityId: restrictedPatientId,
      },
      orderBy: { createdAt: 'desc' },
    });
    expect(auditLog).not.toBeNull();
    expect(auditLog!.metadata).toContain('cardiac arrest');
  });
});
```

### Test 3: Automatic Logoff

```typescript
describe('HIPAA Automatic Logoff', () => {
  it('should expire sessions after inactivity timeout', async () => {
    const token = await getTokenForRole('physician');

    // Token should work immediately
    const res1 = await request(app.getHttpServer())
      .get('/api/patients')
      .set('Authorization', `Bearer ${token}`);
    expect(res1.status).toBe(200);

    // Verify token has appropriate expiration (max 15 min for PHI access)
    const decoded = jwt.decode(token) as { exp: number; iat: number };
    const sessionDuration = decoded.exp - decoded.iat;
    expect(sessionDuration).toBeLessThanOrEqual(15 * 60); // 15 minutes max
  });
});
```

---

## AUDIT LOGGING VERIFICATION (164.312(b))

### Test 4: Audit Log Completeness

```typescript
describe('HIPAA Audit Controls', () => {
  it('should log all PHI access events', async () => {
    const physicianToken = await getTokenForRole('physician');
    const beforeTimestamp = new Date();

    // Perform PHI access
    await request(app.getHttpServer())
      .get(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${physicianToken}`);

    // Verify audit log entry
    const auditEntry = await prisma.auditLog.findFirst({
      where: {
        action: 'PHI_ACCESS',
        entityId: testPatientId,
        createdAt: { gte: beforeTimestamp },
      },
    });

    expect(auditEntry).not.toBeNull();
    expect(auditEntry).toMatchObject({
      action: 'PHI_ACCESS',
      entityType: 'PatientRecord',
      entityId: testPatientId,
    });
    // Verify required audit fields
    expect(auditEntry!.performedBy).toBeDefined();
    expect(auditEntry!.ipAddress).toBeDefined();
    expect(auditEntry!.userAgent).toBeDefined();
    expect(auditEntry!.createdAt).toBeDefined();
  });

  it('should log PHI modifications with before/after values', async () => {
    const physicianToken = await getTokenForRole('physician');

    await request(app.getHttpServer())
      .patch(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${physicianToken}`)
      .send({ diagnosis: 'Updated diagnosis' });

    const auditEntry = await prisma.auditLog.findFirst({
      where: { action: 'PHI_MODIFY', entityId: testPatientId },
      orderBy: { createdAt: 'desc' },
    });

    expect(auditEntry!.previousValue).toBeDefined();
    expect(auditEntry!.newValue).toBeDefined();
  });

  it('should prevent audit log tampering', async () => {
    // Audit logs should be append-only -- no UPDATE or DELETE
    await expect(
      prisma.auditLog.update({
        where: { id: 'any-audit-id' },
        data: { action: 'TAMPERED' },
      })
    ).rejects.toThrow(); // Should fail via DB trigger or policy
  });
});
```

### Audit Log Required Fields

Every PHI-related audit entry must capture:

| Field | Description | Example |
|-------|------------|---------|
| `timestamp` | UTC time of event | `2026-03-06T14:30:00Z` |
| `userId` | Authenticated user ID | `usr_abc123` |
| `userRole` | Role at time of access | `physician` |
| `action` | Type of operation | `PHI_ACCESS`, `PHI_MODIFY`, `PHI_DELETE` |
| `entityType` | PHI record type | `PatientRecord`, `LabResult` |
| `entityId` | Record identifier | `rec_xyz789` |
| `ipAddress` | Source IP | `10.0.1.42` |
| `userAgent` | Client application | `EHR-Web/2.1` |
| `outcome` | Success or failure | `SUCCESS`, `DENIED` |
| `phiFields` | Which PHI fields accessed | `["name", "dob", "diagnosis"]` |

---

## ENCRYPTION TESTING (164.312(a)(2)(iv) and 164.312(e))

### Test 5: Encryption at Rest

```bash
# Verify database encryption
# PostgreSQL: check for TDE or column-level encryption
psql -c "SELECT setting FROM pg_settings WHERE name = 'ssl';"
# Expected: on

# Verify encrypted columns for PHI fields
psql -c "SELECT column_name, data_type FROM information_schema.columns
  WHERE table_name = 'patients' AND column_name IN ('ssn', 'diagnosis');"
# PHI columns should use encrypted types or application-level encryption

# Verify disk encryption
lsblk -o NAME,FSTYPE,MOUNTPOINT,SIZE,ENCRYPTION
# or for cloud: verify EBS/disk encryption settings

# Verify backup encryption
aws s3api get-bucket-encryption --bucket my-hipaa-backups 2>/dev/null
# Expected: AES256 or aws:kms
```

### Test 6: Encryption in Transit

```bash
# Test TLS version and cipher suites
nmap --script ssl-enum-ciphers -p 443 api.example.com
# Expected: TLS 1.2+ only, no weak ciphers

# Verify HSTS header
curl -sI https://api.example.com | grep -i strict-transport
# Expected: Strict-Transport-Security: max-age=31536000; includeSubDomains

# Test for TLS 1.0/1.1 (should be rejected)
openssl s_client -connect api.example.com:443 -tls1 2>&1 | grep -i "alert\|error"
# Expected: handshake failure
openssl s_client -connect api.example.com:443 -tls1_1 2>&1 | grep -i "alert\|error"
# Expected: handshake failure

# Verify minimum TLS 1.2
openssl s_client -connect api.example.com:443 -tls1_2 2>&1 | grep "Protocol"
# Expected: TLSv1.2
```

### Test 7: Key Management

| Check | Requirement | Pass Criteria |
|-------|------------|---------------|
| Key storage | Keys separate from encrypted data | Keys in HSM/KMS, not in application config |
| Key rotation | Regular rotation schedule | Rotation policy documented, automated |
| Key access | Restricted to authorized services | IAM policies limit key access |
| Key backup | Secure key backup exists | Backup in separate secure location |
| Algorithm | NIST-approved algorithms | AES-256, RSA-2048+, SHA-256+ |

---

## DATA INTEGRITY TESTING (164.312(c))

### Test 8: PHI Modification Tracking

```typescript
describe('HIPAA Data Integrity', () => {
  it('should detect unauthorized PHI modifications', async () => {
    // Get current record hash
    const record = await prisma.patientRecord.findUnique({
      where: { id: testRecordId },
    });
    const originalHash = record!.integrityHash;

    // Simulate direct DB modification (bypassing application)
    await prisma.$executeRaw`
      UPDATE patient_records SET diagnosis = 'TAMPERED' WHERE id = ${testRecordId}
    `;

    // Integrity check should detect modification
    const integrityCheck = await integrityService.verifyRecord(testRecordId);
    expect(integrityCheck.valid).toBe(false);
    expect(integrityCheck.discrepancy).toContain('hash mismatch');
  });

  it('should maintain version history for all PHI changes', async () => {
    const physicianToken = await getTokenForRole('physician');

    // Make multiple modifications
    await request(app.getHttpServer())
      .patch(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${physicianToken}`)
      .send({ diagnosis: 'Version 1' });

    await request(app.getHttpServer())
      .patch(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${physicianToken}`)
      .send({ diagnosis: 'Version 2' });

    // Verify full version history exists
    const history = await prisma.patientRecordHistory.findMany({
      where: { recordId: testRecordId },
      orderBy: { createdAt: 'asc' },
    });
    expect(history.length).toBeGreaterThanOrEqual(2);
  });
});
```

---

## BREACH DETECTION TESTING (164.308(a)(6))

### Test 9: Unauthorized Access Monitoring

```typescript
describe('HIPAA Breach Detection', () => {
  it('should detect and alert on suspicious PHI access patterns', async () => {
    const nurseToken = await getTokenForRole('nurse');

    // Simulate bulk PHI access (potential breach indicator)
    for (let i = 0; i < 50; i++) {
      await request(app.getHttpServer())
        .get(`/api/patients/${patientIds[i]}/records`)
        .set('Authorization', `Bearer ${nurseToken}`);
    }

    // Verify anomaly alert was generated
    const alerts = await prisma.securityAlert.findMany({
      where: {
        type: 'BULK_PHI_ACCESS',
        createdAt: { gte: testStartTime },
      },
    });
    expect(alerts.length).toBeGreaterThan(0);
  });

  it('should detect after-hours PHI access', async () => {
    // Mock system time to 3 AM
    jest.useFakeTimers().setSystemTime(new Date('2026-03-06T03:00:00'));

    const nurseToken = await getTokenForRole('nurse');
    await request(app.getHttpServer())
      .get(`/api/patients/${testPatientId}/records`)
      .set('Authorization', `Bearer ${nurseToken}`);

    const alerts = await prisma.securityAlert.findMany({
      where: { type: 'AFTER_HOURS_ACCESS' },
      orderBy: { createdAt: 'desc' },
    });
    expect(alerts.length).toBeGreaterThan(0);

    jest.useRealTimers();
  });
});
```

---

## PATIENT RIGHTS TESTING

### Test 10: Right to Access (164.524)

```typescript
describe('HIPAA Patient Rights - Access', () => {
  it('should provide patient access to their records within 30 days', async () => {
    const patientToken = await getTokenForRole('patient');

    const res = await request(app.getHttpServer())
      .post('/api/patients/me/access-request')
      .set('Authorization', `Bearer ${patientToken}`)
      .send({ format: 'electronic' });

    expect(res.status).toBe(201);
    expect(res.body.data.estimatedCompletionDate).toBeDefined();

    // Verify completion date is within 30 days
    const completionDate = new Date(res.body.data.estimatedCompletionDate);
    const thirtyDaysFromNow = new Date();
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30);
    expect(completionDate.getTime()).toBeLessThanOrEqual(thirtyDaysFromNow.getTime());
  });
});
```

### Test 11: Right to Amendment (164.526)

```typescript
describe('HIPAA Patient Rights - Amendment', () => {
  it('should accept amendment requests and track disposition', async () => {
    const patientToken = await getTokenForRole('patient');

    const res = await request(app.getHttpServer())
      .post('/api/patients/me/amendment-request')
      .set('Authorization', `Bearer ${patientToken}`)
      .send({
        recordId: testRecordId,
        requestedChange: 'Correct medication allergy from penicillin to amoxicillin',
        reason: 'Original entry was inaccurate',
      });

    expect(res.status).toBe(201);
    expect(res.body.data).toHaveProperty('requestId');
    expect(res.body.data.status).toBe('PENDING_REVIEW');
  });
});
```

### Test 12: Accounting of Disclosures (164.528)

```typescript
describe('HIPAA Patient Rights - Accounting of Disclosures', () => {
  it('should track and report all PHI disclosures', async () => {
    const patientToken = await getTokenForRole('patient');

    const res = await request(app.getHttpServer())
      .get('/api/patients/me/disclosures')
      .set('Authorization', `Bearer ${patientToken}`)
      .query({ startDate: '2025-03-06', endDate: '2026-03-06' });

    expect(res.status).toBe(200);
    expect(Array.isArray(res.body.data)).toBe(true);

    // Each disclosure must include required fields
    if (res.body.data.length > 0) {
      const disclosure = res.body.data[0];
      expect(disclosure).toHaveProperty('date');
      expect(disclosure).toHaveProperty('recipientName');
      expect(disclosure).toHaveProperty('recipientAddress');
      expect(disclosure).toHaveProperty('description');
    }
  });
});
```

---

## DE-IDENTIFICATION TESTING

### Safe Harbor Method (164.514(b)(2))

All 18 identifiers must be removed or generalized:

```typescript
describe('HIPAA De-identification - Safe Harbor', () => {
  it('should remove all 18 HIPAA identifiers', async () => {
    const deidentified = await deidentificationService.safeHarbor(patientRecord);

    // Verify all 18 identifiers are removed
    expect(deidentified.name).toBeUndefined();
    expect(deidentified.address).toBeUndefined();
    expect(deidentified.dateOfBirth).toBeUndefined(); // Only year allowed
    expect(deidentified.phone).toBeUndefined();
    expect(deidentified.email).toBeUndefined();
    expect(deidentified.ssn).toBeUndefined();
    expect(deidentified.mrn).toBeUndefined();
    expect(deidentified.ipAddress).toBeUndefined();

    // ZIP codes must be truncated to 3 digits (or 000 if population < 20,000)
    if (deidentified.zipCode) {
      expect(deidentified.zipCode).toMatch(/^\d{3}00$/);
    }

    // Dates must be year-only for ages > 89
    if (deidentified.birthYear && deidentified.birthYear < 1937) {
      expect(deidentified.birthYear).toBeUndefined(); // Ages > 89 aggregated
    }

    // Verify no residual identifiers in free text
    const freeText = JSON.stringify(deidentified);
    expect(freeText).not.toMatch(/\d{3}-\d{2}-\d{4}/); // No SSN patterns
    expect(freeText).not.toMatch(/[\w.]+@[\w.]+\.\w+/); // No email patterns
  });
});
```

---

## BUSINESS ASSOCIATE AGREEMENT (BAA) TECHNICAL VERIFICATION

### BAA Checklist for Third-Party Services

| Service Category | BAA Required? | Technical Verification |
|-----------------|---------------|----------------------|
| Cloud hosting (AWS, Azure, GCP) | Yes | Verify BAA signed, encryption enabled, region restrictions |
| Database service | Yes | Verify BAA, encryption at rest, access logging |
| Email/messaging | Yes, if PHI transmitted | Verify BAA, TLS enforcement, no PHI in subjects |
| Analytics | Yes, if PHI accessed | Verify BAA, or ensure de-identification before ingestion |
| Backup/DR | Yes | Verify BAA, encryption, access controls |
| CDN | Only if PHI cached | Verify no PHI caching, or BAA + encryption |

### BAA Technical Requirements Test

```bash
# Verify cloud provider BAA configuration
# AWS: Check for HIPAA-eligible services only
aws configservice get-compliance-details-by-config-rule \
  --config-rule-name hipaa-eligible-services-only

# Verify S3 buckets with PHI have proper settings
aws s3api get-bucket-encryption --bucket phi-data-bucket
aws s3api get-bucket-versioning --bucket phi-data-bucket
aws s3api get-bucket-logging --bucket phi-data-bucket
aws s3api get-public-access-block --bucket phi-data-bucket
# Expected: encryption=AES256/KMS, versioning=Enabled, logging=Enabled, public=AllBlocked
```

---

## BREACH NOTIFICATION TESTING (164.404-408)

### Breach Response Timeline

| Action | Deadline | Responsible Party |
|--------|----------|-------------------|
| Discover breach | Immediately | Security team |
| Investigate and document | Within 30 days | Privacy officer |
| Notify affected individuals | Within 60 days of discovery | Covered entity |
| Notify HHS (>500 individuals) | Within 60 days of discovery | Covered entity |
| Notify HHS (<500 individuals) | Annual log, within 60 days of calendar year end | Covered entity |
| Notify media (>500 in state) | Within 60 days of discovery | Covered entity |
| Business associate notify covered entity | Without unreasonable delay | Business associate |

### Breach Notification Procedure Test

```markdown
## Breach Notification Drill Checklist

- [ ] Simulated breach scenario defined (e.g., stolen laptop with unencrypted PHI)
- [ ] Breach detected by monitoring system or reported by staff
- [ ] Incident response team activated within SLA
- [ ] Breach scope assessed: number of individuals, PHI types affected
- [ ] Risk assessment performed (4-factor test):
  - [ ] Nature and extent of PHI involved
  - [ ] Unauthorized person who accessed PHI
  - [ ] Whether PHI was actually acquired or viewed
  - [ ] Extent to which risk has been mitigated
- [ ] Determination: breach vs. exception (encryption safe harbor)
- [ ] Notification letters drafted with required content:
  - [ ] Description of breach
  - [ ] Types of PHI involved
  - [ ] Steps individuals should take
  - [ ] What entity is doing to investigate/mitigate
  - [ ] Contact procedures (toll-free number, email, website)
- [ ] HHS notification form prepared (if applicable)
- [ ] Timeline compliance verified (60-day window)
- [ ] Post-incident review scheduled
```

---

## HIPAA COMPLIANCE TEST REPORT TEMPLATE

```markdown
# HIPAA Compliance Test Report

**System**: [Application Name]
**Version**: [Version/Build]
**Test Date**: [Date]
**Tester**: [Name/Title]
**Covered Entity**: [Organization Name]

## Executive Summary
- Total controls tested: [X]
- Controls passing: [Y] ([Z]%)
- Critical findings: [count]
- High findings: [count]
- Medium findings: [count]

## PHI Inventory
- PHI data elements identified: [count]
- PHI storage locations: [count]
- PHI transmission channels: [count]
- Business associates with PHI access: [count]

## Technical Safeguard Results (164.312)

| Control | Section | Status | Evidence | Finding |
|---------|---------|--------|----------|---------|
| Access control (RBAC) | 164.312(a)(1) | PASS/FAIL | [test results link] | [description] |
| Unique user ID | 164.312(a)(2)(i) | PASS/FAIL | [test results link] | [description] |
| Emergency access | 164.312(a)(2)(ii) | PASS/FAIL | [test results link] | [description] |
| Auto logoff | 164.312(a)(2)(iii) | PASS/FAIL | [test results link] | [description] |
| Encryption at rest | 164.312(a)(2)(iv) | PASS/FAIL | [config evidence] | [description] |
| Audit controls | 164.312(b) | PASS/FAIL | [audit log samples] | [description] |
| Integrity controls | 164.312(c)(1) | PASS/FAIL | [test results link] | [description] |
| Authentication | 164.312(d) | PASS/FAIL | [test results link] | [description] |
| Transmission encryption | 164.312(e)(1) | PASS/FAIL | [TLS scan results] | [description] |

## Administrative Safeguard Results (164.308)

| Control | Section | Status | Evidence |
|---------|---------|--------|----------|
| Risk assessment | 164.308(a)(1) | PASS/FAIL | [document link] |
| Workforce security | 164.308(a)(3) | PASS/FAIL | [HR records] |
| Access management | 164.308(a)(4) | PASS/FAIL | [access review logs] |
| Security training | 164.308(a)(5) | PASS/FAIL | [training records] |
| Incident procedures | 164.308(a)(6) | PASS/FAIL | [IR plan link] |
| Contingency plan | 164.308(a)(7) | PASS/FAIL | [DR test results] |

## Findings and Remediation

| # | Severity | Control | Finding | Remediation | Target Date | Owner |
|---|----------|---------|---------|-------------|-------------|-------|
| 1 | CRITICAL | 164.312(a)(2)(iv) | PHI stored unencrypted in cache | Enable encryption for cache layer | [date] | [name] |

## BAA Status

| Vendor | Service | BAA Signed | BAA Date | Technical Verification |
|--------|---------|-----------|----------|----------------------|
| AWS | Cloud hosting | Yes/No | [date] | Encryption, logging verified |

## Attestation
I certify that this testing was performed using the methodology described above
and the results accurately reflect the system's compliance posture.

Signature: ___________________  Date: ___________
Name: _______________________  Title: ___________
```

---

## CHECKLIST

- [ ] PHI data flow mapped across all system components
- [ ] All 18 HIPAA identifiers catalogued in data stores
- [ ] RBAC enforces minimum necessary principle for PHI access
- [ ] Emergency access (break-the-glass) procedure implemented and tested
- [ ] Session timeout enforced (15 min max for PHI-accessing sessions)
- [ ] Audit logs capture all PHI access, modification, and deletion events
- [ ] Audit logs are immutable (append-only, tamper-evident)
- [ ] Encryption at rest: AES-256 for all PHI storage (database, backups, files)
- [ ] Encryption in transit: TLS 1.2+ enforced, weak ciphers disabled
- [ ] Key management uses HSM/KMS with documented rotation schedule
- [ ] Data integrity verification (hash-based) for PHI records
- [ ] Breach detection monitors for anomalous PHI access patterns
- [ ] Patient right to access implemented (30-day response)
- [ ] Patient right to amendment implemented with tracking
- [ ] Accounting of disclosures available to patients (6-year lookback)
- [ ] De-identification tested (Safe Harbor: all 18 identifiers removed)
- [ ] BAA signed and technically verified for all business associates
- [ ] Breach notification procedure documented and drill-tested
- [ ] Backup and disaster recovery tested with PHI restoration verified
- [ ] Compliance test report generated and reviewed by privacy officer

---

*Skill Version: 1.0 | Created: March 2026*
