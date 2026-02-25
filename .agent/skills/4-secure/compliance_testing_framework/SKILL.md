---
name: Compliance Testing Framework
description: Map testing activities to compliance controls for SOC2, HIPAA, GDPR, and PCI-DSS with auditor-ready evidence packages
---

# Compliance Testing Framework Skill

**Purpose**: Bridge the gap between security testing and regulatory compliance by mapping test results to specific compliance controls. This skill covers four major frameworks (SOC2 Type II, HIPAA, GDPR, PCI-DSS), generates compliance evidence packages from existing CI/CD artifacts, and produces auditor-ready documentation that demonstrates continuous compliance through automated testing.

## TRIGGER COMMANDS

```text
"Compliance testing for SOC2"
"HIPAA testing requirements"
"Map tests to compliance controls"
"Generate compliance evidence package"
"GDPR compliance testing"
```

## When to Use
- Preparing for a SOC2 Type II audit and need to map tests to controls
- Building a HIPAA-compliant application and need safeguard verification tests
- Demonstrating GDPR Article 25 (data protection by design) compliance
- PCI-DSS Requirement 6 (secure development) or Requirement 11 (testing) evidence
- Consolidating existing Phase 4 scan results into a unified compliance report

---

## PROCESS

### Step 1: Identify Applicable Frameworks

Determine which frameworks apply based on product, geography, and customer:

| Framework | Applies When | Key Test-Related Controls |
|-----------|-------------|--------------------------|
| SOC2 Type II | B2B SaaS handling customer data | CC6 (Access), CC7 (System Operations), CC8 (Change Management) |
| HIPAA | Processing Protected Health Information | 164.306 (Security Standards), 164.312 (Technical Safeguards) |
| GDPR | EU residents' personal data | Article 25 (DPbD), Article 32 (Security), Article 35 (DPIA) |
| PCI-DSS v4.0 | Processing payment card data | Req 6 (Secure Development), Req 11 (Security Testing) |

### Step 2: SOC2 Type II Control Mapping

Map Phase 4 security scans to SOC2 Trust Services Criteria:

```markdown
## SOC2 Control Evidence Matrix

| Control | Criteria | Evidence Source | Skill |
|---------|----------|-----------------|-------|
| CC6.1 | Logical access security | Auth integration tests | integration_testing |
| CC6.1 | Access control mechanisms | RBAC/ABAC test results | security_audit |
| CC6.6 | System boundaries protection | SAST scan results (SARIF) | sast_scanning |
| CC6.8 | Vulnerability management | SCA/Trivy scan reports | supply_chain_security |
| CC7.1 | Infrastructure monitoring | Container scan reports | container_security |
| CC7.2 | Security incident detection | Secret scan CI logs | secrets_scanning |
| CC8.1 | Change management | PR gate enforcement logs | CI/CD pipeline |
```

**Evidence collection automation:**

```yaml
# .github/workflows/compliance-evidence.yml
name: Compliance Evidence Collection
on:
  schedule:
    - cron: '0 0 1 * *'  # Monthly
  workflow_dispatch:

jobs:
  collect-evidence:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run SAST scan with evidence output
        run: |
          semgrep scan --config=auto --json \
            --output=evidence/sast-scan-$(date +%Y%m%d).json .

      - name: Run dependency audit
        run: |
          npm audit --json > evidence/dependency-audit-$(date +%Y%m%d).json || true

      - name: Run secret scan
        run: |
          gitleaks detect --source=. --report-format=json \
            --report-path=evidence/secrets-scan-$(date +%Y%m%d).json || true

      - name: Generate SBOM
        run: |
          npx @cyclonedx/cyclonedx-npm \
            --output-file evidence/sbom-$(date +%Y%m%d).json

      - name: Upload evidence bundle
        uses: actions/upload-artifact@v4
        with:
          name: compliance-evidence-${{ github.run_id }}
          path: evidence/
          retention-days: 400  # SOC2 requires 12+ months
```

### Step 3: HIPAA Technical Safeguard Testing

Map tests to HIPAA Section 164.312 safeguards:

| Safeguard | Requirement | Test Type | Implementation |
|-----------|------------|-----------|----------------|
| 164.312(a)(1) | Access control | Integration test | Verify endpoint auth enforcement |
| 164.312(a)(2)(i) | Unique user identification | Unit test | Verify UUID-based user IDs |
| 164.312(a)(2)(iv) | Encryption at rest | Config verification | Verify database encryption settings |
| 164.312(b) | Audit controls | Integration test | Verify audit log creation on PHI access |
| 164.312(c)(1) | Integrity controls | E2E test | Verify data integrity on write/read |
| 164.312(d) | Authentication | Integration test | Verify MFA enforcement for PHI access |
| 164.312(e)(1) | Transmission security | Config verification | Verify TLS 1.2+ enforcement |

### Step 4: GDPR Compliance Testing

Map tests to GDPR Articles 25, 32, and 35:

```typescript
// Example: GDPR Article 17 (Right to Erasure) compliance test
describe('GDPR Right to Erasure', () => {
  it('should delete all user PII when erasure is requested', async () => {
    const user = await createTestUser(prisma, jwtService);

    await request(app.getHttpServer())
      .delete('/api/users/me')
      .set('Authorization', `Bearer ${user.token}`)
      .expect(200);

    // Verify PII is removed from all tables
    const dbUser = await prisma.user.findUnique({ where: { id: user.id } });
    expect(dbUser).toBeNull();

    const userDocs = await prisma.document.findMany({ where: { createdById: user.id } });
    expect(userDocs).toHaveLength(0);

    // Verify audit log records the deletion (but does not contain PII)
    const auditLog = await prisma.auditLog.findFirst({
      where: { action: 'USER_DELETED', entityId: user.id },
    });
    expect(auditLog).not.toBeNull();
    expect(auditLog!.metadata).not.toContain(user.email);
  });
});
```

### Step 5: PCI-DSS Testing Requirements

Map to PCI-DSS v4.0 Requirements 6 and 11:

| PCI-DSS Req | Description | Evidence | Frequency |
|-------------|------------|----------|-----------|
| 6.2.1 | Secure development training | Training completion records | Annual |
| 6.2.3 | Code review before release | PR review logs | Every PR |
| 6.3.1 | Vulnerability identification | SAST/SCA scan results | Every build |
| 6.3.2 | Software inventory (SBOM) | CycloneDX SBOM | Every release |
| 6.5.1-6.5.6 | Common vulnerability prevention | SAST rules coverage | Every build |
| 11.3.1 | Internal vulnerability scans | Trivy/Snyk reports | Quarterly min |
| 11.3.2 | External vulnerability scans | ASV scan reports | Quarterly |
| 11.4.1 | Penetration testing | Pen test report | Annual |

### Step 6: Generate Compliance Evidence Package

Produce a consolidated report for auditors:

```markdown
# Compliance Evidence Package

**Period**: [Start Date] - [End Date]
**Generated**: [Date]
**Framework**: [SOC2 | HIPAA | GDPR | PCI-DSS]

## Executive Summary
- Total controls mapped: X
- Controls with automated evidence: Y (Z%)
- Controls requiring manual evidence: A
- Findings requiring remediation: B

## Control Evidence Matrix
| Control ID | Description | Evidence Type | Artifact Path | Status |
|-----------|-------------|---------------|---------------|--------|
| CC6.1 | Access control | SAST + Integration | evidence/sast-*.json | PASS |

## Artifact Inventory
- SAST Reports: evidence/sast-scan-*.json
- SCA Reports: evidence/dependency-audit-*.json
- Secret Scans: evidence/secrets-scan-*.json
- SBOMs: evidence/sbom-*.json
- Container Scans: evidence/trivy-*.sarif
- Test Results: evidence/test-results-*.xml

## Gaps and Remediation Plan
| Gap | Control | Remediation | Target Date | Owner |
|-----|---------|-------------|-------------|-------|
```

---

## CHECKLIST

- [ ] Applicable compliance frameworks identified for the project
- [ ] Control-to-test mapping documented for each framework
- [ ] Automated evidence collection workflow configured in CI
- [ ] Evidence retention meets framework requirements (SOC2: 12mo, PCI: 12mo, HIPAA: 6yr)
- [ ] GDPR erasure cascade tests written and passing
- [ ] SBOM generated and attached to releases
- [ ] Monthly compliance evidence bundle generated and archived
- [ ] Gaps between automated and manual controls identified
- [ ] Compliance evidence package template filled for auditor review
- [ ] Quarterly review scheduled for control mapping accuracy

*Skill Version: 1.0 | Created: February 2026*
