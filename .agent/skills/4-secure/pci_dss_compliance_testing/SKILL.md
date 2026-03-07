---
name: PCI-DSS Compliance Testing
description: PCI-DSS v4.0 compliance testing for applications processing, storing, or transmitting cardholder data
---

# PCI-DSS Compliance Testing Skill

**Purpose**: Systematic testing methodology for verifying PCI-DSS v4.0 compliance across all 12 requirements. Maps technical controls to specific PCI requirements, provides actionable test cases, and generates Self-Assessment Questionnaire (SAQ) evidence for applications in the Cardholder Data Environment (CDE).

---

## TRIGGER COMMANDS

```text
"Run PCI-DSS compliance tests on [project]"
"Verify payment card security for [application]"
"PCI-DSS v4.0 audit for [system]"
"Test cardholder data protection in [service]"
"Using pci_dss_compliance_testing skill: [task]"
```

---

> [!WARNING]
> This skill provides **technical testing guidance only**. It is NOT a substitute for a Qualified Security Assessor (QSA). PCI-DSS non-compliance can result in fines of $5,000-$100,000 per month, increased transaction fees, and loss of card processing privileges. Always engage a QSA for formal assessments.

---

## CDE SCOPE DEFINITION AND VALIDATION

### Step 1: Identify Cardholder Data

| Data Element | Storage Permitted | Protection Required | PCI Sensitivity |
|-------------|-------------------|--------------------|----|
| Primary Account Number (PAN) | Yes (encrypted) | Render unreadable | CRITICAL |
| Cardholder Name | Yes | Protect per requirements | HIGH |
| Service Code | Yes | Protect per requirements | HIGH |
| Expiration Date | Yes | Protect per requirements | HIGH |
| Full Track Data (mag stripe) | **NEVER** | N/A -- must not store | PROHIBITED |
| CAV2/CVC2/CVV2/CID | **NEVER** | N/A -- must not store | PROHIBITED |
| PIN / PIN Block | **NEVER** | N/A -- must not store | PROHIBITED |

### Step 2: Map the CDE

```markdown
## Cardholder Data Environment Scope

### Systems IN Scope
| System | Role | Data Elements | Justification |
|--------|------|---------------|---------------|
| Payment API | Processes PAN | PAN (transient) | Routes to payment processor |
| Order database | Stores masked PAN | Last-4 digits | Order history display |
| Log aggregator | May capture PAN | Check for leakage | Log all API traffic |

### Systems OUT of Scope (with justification)
| System | Justification | Segmentation Method |
|--------|---------------|---------------------|
| Marketing site | No cardholder data flow | Separate VLAN, no CDE access |
| HR portal | No cardholder data flow | Separate network segment |

### Network Segmentation Diagram
[Document how CDE is isolated from non-CDE systems]
- CDE VLAN/subnet: [range]
- Firewall rules between CDE and non-CDE: [reference]
- Monitoring points: [list]
```

### Scope Reduction Strategy: Tokenization

> [!TIP]
> **The single most effective PCI scope reduction**: Use a PCI-compliant payment processor (Stripe, Braintree, Adyen, Square) with tokenization. Your systems never see raw PANs, reducing your SAQ from **SAQ D (300+ controls)** to **SAQ A (22 controls)**.

```typescript
// CORRECT: Tokenized payment flow (SAQ A eligible)
// Client-side: Stripe.js collects card data directly
// Server-side: Only receives a token, never raw PAN
async function processPayment(orderId: string, stripeToken: string) {
  const charge = await stripe.charges.create({
    amount: order.totalCents,
    currency: 'usd',
    source: stripeToken, // Token, not card number
    metadata: { orderId },
  });
  return charge;
}

// WRONG: Server handles raw PAN (SAQ D required)
// async function processPayment(orderId: string, cardNumber: string, cvv: string) {
//   // NEVER DO THIS -- you are now in full PCI scope
// }
```

---

## REQUIREMENT 1: NETWORK SECURITY CONTROLS

### Firewall and Network Segmentation Testing

```bash
# Test 1.1: Verify firewall rules restrict CDE access
# List all rules allowing traffic into CDE segment
iptables -L -n -v | grep -A5 "CDE"
# or for cloud:
aws ec2 describe-security-groups --filters "Name=tag:Environment,Values=CDE" \
  --query 'SecurityGroups[*].{ID:GroupId,Rules:IpPermissions}'

# Test 1.2: Verify no unauthorized inbound to CDE
nmap -sT -p- <CDE_SUBNET> --open
# Expected: Only documented ports open (443, database port from app tier only)

# Test 1.3: Verify CDE cannot reach non-CDE directly
# From within CDE, attempt to reach non-CDE systems
curl -s --connect-timeout 5 http://marketing-site.internal:80
# Expected: Connection refused or timeout

# Test 1.4: Verify DMZ isolates public-facing components
nmap -sT -p 443,8443 <DMZ_IP>
# Only web/API ports should be reachable from internet
```

### Firewall Rule Review Checklist

- [ ] All inbound rules to CDE documented and justified
- [ ] Default deny for all inbound traffic to CDE
- [ ] Outbound from CDE restricted to necessary destinations only
- [ ] No "any/any" rules in CDE firewall policies
- [ ] Firewall rules reviewed at least every 6 months (Req 1.2.7)
- [ ] Personal firewall on all portable devices with CDE access

---

## REQUIREMENT 2: SECURE CONFIGURATIONS

### Default Credential and Configuration Testing

```bash
# Test 2.1: Check for default credentials on CDE systems
# Database
psql -h <DB_HOST> -U postgres -c "SELECT 1" 2>&1
# Expected: Authentication failure (default 'postgres' user should be disabled or renamed)

# Test 2.2: Verify unnecessary services disabled
systemctl list-units --type=service --state=running
# Compare against approved service baseline -- flag any extras

# Test 2.3: CIS Benchmark compliance scan
# Using OpenSCAP or similar
oscap xccdf eval --profile cis_level1_server \
  --results cis-scan-results.xml \
  /usr/share/xml/scap/ssg/content/ssg-ubuntu2204-xccdf.xml

# Test 2.4: Verify single primary function per server
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}"
# Each container should serve one function (web, app, db -- not combined)
```

---

## REQUIREMENT 3: PROTECT STORED CARDHOLDER DATA

### Stored Data Protection Testing

```typescript
describe('PCI Requirement 3 - Stored Data Protection', () => {
  it('should never store prohibited data elements', async () => {
    // Search all database tables for CVV/CVC patterns
    const tables = await prisma.$queryRaw`
      SELECT table_name, column_name FROM information_schema.columns
      WHERE table_schema = 'public'
      AND (column_name ILIKE '%cvv%' OR column_name ILIKE '%cvc%'
        OR column_name ILIKE '%pin%' OR column_name ILIKE '%track%'
        OR column_name ILIKE '%magnetic%')
    `;
    expect(tables).toHaveLength(0);
  });

  it('should mask PAN when displayed (show first 6 / last 4 max)', async () => {
    const res = await request(app.getHttpServer())
      .get('/api/orders/123/payment')
      .set('Authorization', `Bearer ${adminToken}`);

    // PAN should be masked: at most first-6/last-4
    const displayedPan = res.body.data.cardNumber;
    expect(displayedPan).toMatch(/^(\d{4,6})\*{4,6}(\d{4})$|^\*+\d{4}$/);
  });

  it('should encrypt stored PANs with strong cryptography', async () => {
    // If PANs are stored (tokenization preferred), verify encryption
    const rawRecord = await prisma.$queryRaw`
      SELECT card_token FROM payments WHERE id = ${testPaymentId}
    `;
    // Stored value should be a token or encrypted blob, not a recognizable PAN
    const stored = (rawRecord as any[])[0]?.card_token;
    expect(stored).not.toMatch(/^\d{13,19}$/); // Not a raw PAN
  });

  it('should enforce data retention limits', async () => {
    // Cardholder data older than business need must be purged
    const oldRecords = await prisma.payment.findMany({
      where: {
        createdAt: { lt: retentionCutoffDate },
        cardToken: { not: null },
      },
    });
    expect(oldRecords).toHaveLength(0);
  });
});
```

### Encryption Key Management (Req 3.6-3.7)

| Check | Requirement | Test |
|-------|------------|------|
| Key generation | Strong random generation | Verify key entropy source (HSM, /dev/urandom) |
| Key distribution | Secure channel only | Verify no keys in email, chat, or tickets |
| Key storage | Encrypted or in HSM | Verify keys not stored in plaintext config |
| Key rotation | At least annually | Check key creation dates, rotation logs |
| Key destruction | Secure deletion | Verify old keys are cryptographically destroyed |
| Split knowledge | No single person holds full key | Verify dual-control key ceremonies |

---

## REQUIREMENT 4: ENCRYPT TRANSMISSIONS

### Transmission Encryption Testing

```bash
# Test 4.1: Verify TLS 1.2+ on all CDE endpoints
testssl.sh --protocols --ciphers <CDE_ENDPOINT>:443
# Expected: TLS 1.2 and 1.3 only, no SSLv3/TLS 1.0/TLS 1.1

# Test 4.2: Verify certificate validity
openssl s_client -connect <CDE_ENDPOINT>:443 -servername <CDE_ENDPOINT> < /dev/null 2>&1 | \
  openssl x509 -noout -dates -subject -issuer
# Expected: Valid dates, trusted CA, correct subject

# Test 4.3: Check for weak cipher suites
nmap --script ssl-enum-ciphers -p 443 <CDE_ENDPOINT> | grep -E "TLSv1\.[01]|RC4|DES|EXPORT|NULL"
# Expected: No output (no weak ciphers)

# Test 4.4: Verify internal CDE communications are encrypted
# Check database connections use TLS
psql "host=<DB_HOST> sslmode=verify-full" -c "SHOW ssl;"
# Expected: on

# Test 4.5: Check for PAN in unencrypted channels
# Search logs for PAN patterns
grep -rn '[0-9]\{13,19\}' /var/log/app/ | grep -v '\*\*\*\*'
# Expected: No matches (no raw PANs in logs)
```

---

## REQUIREMENT 5: MALWARE PROTECTION

### Anti-Malware Verification

| Check | Test Method | Pass Criteria |
|-------|------------|---------------|
| AV installed on all CDE systems | `dpkg -l | grep -i antivirus` or endpoint agent check | AV present and running |
| AV definitions current | Check update timestamp | Updated within 24 hours |
| Real-time scanning enabled | Verify AV config | On-access scanning active |
| Periodic scans scheduled | Check cron/scheduler | At least weekly full scan |
| AV logs retained | Check log retention | 12 months minimum |
| Cannot be disabled by users | Attempt to stop AV service as non-root | Permission denied |

> [!NOTE]
> For Linux container environments, traditional AV may not apply. Document compensating controls: image scanning (Trivy), runtime security (Falco), read-only filesystems, minimal base images.

---

## REQUIREMENT 6: SECURE DEVELOPMENT

### Secure SDLC Testing

```yaml
# CI pipeline checks for PCI Requirement 6
name: PCI-Req6-SecureDev
on: [pull_request]
jobs:
  sast-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: SAST scan (Req 6.3.1)
        run: semgrep scan --config=auto --sarif --output=sast.sarif .
      - name: Dependency audit (Req 6.3.2)
        run: npm audit --audit-level=high
      - name: SBOM generation (Req 6.3.2)
        run: npx @cyclonedx/cyclonedx-npm --output-file sbom.json
      - name: Secret scan
        run: gitleaks detect --source=. --report-format=sarif --report-path=secrets.sarif

  code-review:
    runs-on: ubuntu-latest
    steps:
      - name: Verify PR has reviewer approval (Req 6.2.3)
        run: |
          APPROVALS=$(gh pr view ${{ github.event.pull_request.number }} --json reviews \
            --jq '[.reviews[] | select(.state == "APPROVED")] | length')
          if [ "$APPROVALS" -lt 1 ]; then
            echo "ERROR: PCI Req 6.2.3 requires code review approval"
            exit 1
          fi
```

### OWASP Top 10 Coverage (Req 6.2.4)

| OWASP Category | PCI Test | Verification |
|---------------|----------|--------------|
| A01: Broken Access Control | RBAC tests, IDOR tests | Automated integration tests |
| A02: Cryptographic Failures | Encryption verification | TLS scans, key management review |
| A03: Injection | SQL injection, XSS tests | SAST + DAST scanning |
| A04: Insecure Design | Threat modeling review | Design review documentation |
| A05: Security Misconfiguration | CIS benchmark scans | Automated config scanning |
| A06: Vulnerable Components | SCA scanning | `npm audit`, Trivy, Snyk |
| A07: Auth Failures | Auth testing suite | Automated integration tests |
| A08: Data Integrity Failures | SBOM, signature verification | CI pipeline checks |
| A09: Logging Failures | Audit log completeness tests | Log review automation |
| A10: SSRF | SSRF test harness | DAST + manual testing |

### Change Management (Req 6.5)

- [ ] All changes to CDE documented in change management system
- [ ] Impact analysis performed before deployment
- [ ] Rollback procedures documented and tested
- [ ] Separation of duties: developer != deployer in production
- [ ] Production code matches approved/reviewed code (no hotfixes without review)

---

## REQUIREMENT 7: RESTRICT ACCESS

### Least Privilege Testing

```typescript
describe('PCI Requirement 7 - Access Control', () => {
  it('should enforce least privilege on CDE endpoints', async () => {
    const testCases = [
      { role: 'customer_support', endpoint: '/api/admin/payments', expected: 403 },
      { role: 'customer_support', endpoint: '/api/orders/lookup', expected: 200 },
      { role: 'developer', endpoint: '/api/admin/payments/refund', expected: 403 },
      { role: 'payment_admin', endpoint: '/api/admin/payments/refund', expected: 200 },
    ];

    for (const tc of testCases) {
      const token = await getTokenForRole(tc.role);
      const res = await request(app.getHttpServer())
        .get(tc.endpoint)
        .set('Authorization', `Bearer ${token}`);
      expect(res.status).toBe(tc.expected);
    }
  });

  it('should deny access by default (default-deny)', async () => {
    // New role with no explicit permissions should be denied everything
    const newRoleToken = await createTokenForRole('new_employee');
    const res = await request(app.getHttpServer())
      .get('/api/payments')
      .set('Authorization', `Bearer ${newRoleToken}`);
    expect(res.status).toBe(403);
  });
});
```

---

## REQUIREMENT 8: IDENTIFY AND AUTHENTICATE

### Authentication Testing

```typescript
describe('PCI Requirement 8 - Authentication', () => {
  it('should enforce MFA for all CDE access', async () => {
    // Attempt CDE access without MFA
    const tokenWithoutMfa = await getTokenWithoutMfa('payment_admin');
    const res = await request(app.getHttpServer())
      .get('/api/admin/payments')
      .set('Authorization', `Bearer ${tokenWithoutMfa}`);
    expect(res.status).toBe(403);
    expect(res.body.message).toContain('MFA required');
  });

  it('should enforce password complexity (Req 8.3.6)', async () => {
    const weakPasswords = [
      'short1!',          // Too short (min 12 chars in v4.0)
      'alllowercase123!', // Missing uppercase
      'ALLUPPERCASE123!', // Missing lowercase
      'NoSpecialChar123', // Missing special character
      'NoNumbers!Abcdef', // Missing number
    ];

    for (const pwd of weakPasswords) {
      const res = await request(app.getHttpServer())
        .post('/api/auth/change-password')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ currentPassword: validOldPassword, newPassword: pwd });
      expect(res.status).toBe(400);
    }
  });

  it('should lock account after failed attempts (Req 8.3.4)', async () => {
    const maxAttempts = 10; // PCI v4.0: max 10 attempts
    for (let i = 0; i <= maxAttempts; i++) {
      await request(app.getHttpServer())
        .post('/api/auth/login')
        .send({ email: 'admin@test.com', password: 'wrong' });
    }

    // Account should now be locked
    const res = await request(app.getHttpServer())
      .post('/api/auth/login')
      .send({ email: 'admin@test.com', password: correctPassword });
    expect(res.status).toBe(423); // Locked
  });

  it('should expire sessions after 15 minutes of inactivity (Req 8.2.8)', async () => {
    const token = await getTokenForRole('payment_admin');
    const decoded = jwt.decode(token) as { exp: number; iat: number };
    const sessionDuration = decoded.exp - decoded.iat;
    expect(sessionDuration).toBeLessThanOrEqual(15 * 60);
  });
});
```

---

## REQUIREMENT 9: PHYSICAL ACCESS

> [!NOTE]
> For cloud-native applications, Requirement 9 physical access controls are largely inherited from the cloud provider. Document this with evidence:

```markdown
## Requirement 9 - Physical Security (Cloud Inherited)

**Hosting**: [AWS/Azure/GCP] -- [Region]
**Provider PCI Certification**: [AOC reference number]
**Applicable SAQ**: SAQ A / SAQ A-EP (no physical CDE under our control)

### Evidence
- Cloud provider Attestation of Compliance (AOC): [link/reference]
- Cloud provider responsibility matrix: [link]
- No on-premises systems process or store cardholder data: [attestation]

### Residual Physical Controls (Our Responsibility)
- [ ] Employee workstations with CDE access: screen locks, clean desk policy
- [ ] No cardholder data on removable media
- [ ] Visitor logs for offices where CDE-accessing workstations exist
```

---

## REQUIREMENT 10: LOGGING AND MONITORING

### Audit Trail Testing

```typescript
describe('PCI Requirement 10 - Logging', () => {
  it('should log all access to cardholder data (Req 10.2.1)', async () => {
    const before = new Date();
    await request(app.getHttpServer())
      .get('/api/admin/payments/123')
      .set('Authorization', `Bearer ${adminToken}`);

    const log = await getAuditLog({ action: 'PAYMENT_ACCESS', after: before });
    expect(log).not.toBeNull();
    expect(log).toMatchObject({
      userId: expect.any(String),
      action: 'PAYMENT_ACCESS',
      ipAddress: expect.any(String),
      timestamp: expect.any(Date),
      outcome: 'SUCCESS',
    });
  });

  it('should log all authentication events (Req 10.2.1.2)', async () => {
    const before = new Date();

    // Successful login
    await request(app.getHttpServer())
      .post('/api/auth/login')
      .send({ email: 'admin@test.com', password: correctPassword });

    // Failed login
    await request(app.getHttpServer())
      .post('/api/auth/login')
      .send({ email: 'admin@test.com', password: 'wrong' });

    const successLog = await getAuditLog({ action: 'AUTH_SUCCESS', after: before });
    const failLog = await getAuditLog({ action: 'AUTH_FAILURE', after: before });
    expect(successLog).not.toBeNull();
    expect(failLog).not.toBeNull();
  });

  it('should log all admin actions (Req 10.2.1.1)', async () => {
    const before = new Date();
    await request(app.getHttpServer())
      .post('/api/admin/users/456/role')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ role: 'payment_admin' });

    const log = await getAuditLog({ action: 'ROLE_CHANGE', after: before });
    expect(log).not.toBeNull();
    expect(log!.previousValue).toBeDefined();
    expect(log!.newValue).toBeDefined();
  });

  it('should synchronize time across all CDE systems (Req 10.6)', async () => {
    // Verify NTP is configured
    // In test: verify log timestamps are within acceptable skew
    const logs = await prisma.auditLog.findMany({
      orderBy: { createdAt: 'desc' },
      take: 10,
    });

    for (const log of logs) {
      const skew = Math.abs(Date.now() - log.createdAt.getTime());
      expect(skew).toBeLessThan(60_000); // Within 1 minute of current time
    }
  });
});
```

### Log Retention Requirements

| Log Type | Minimum Retention | Immediately Available |
|----------|------------------|-----------------------|
| Audit trails | 12 months | Last 3 months |
| System logs | 12 months | Last 3 months |
| Firewall logs | 12 months | Last 3 months |
| Authentication logs | 12 months | Last 3 months |

---

## REQUIREMENT 11: SECURITY TESTING

### Vulnerability Scanning and Penetration Testing

```bash
# Test 11.1: Wireless access point detection (if applicable)
# Quarterly scan for rogue wireless APs near CDE
# Use wireless IDS or manual survey tool

# Test 11.2: Internal vulnerability scan (quarterly minimum)
# Using OpenVAS, Nessus, or Qualys
openvas-cli --scan-target <CDE_HOSTS> --profile "PCI-DSS" --format pdf \
  --output pci-internal-scan-$(date +%Y%m%d).pdf

# Test 11.3: External ASV scan (quarterly, must use PCI-approved ASV)
# ASV list: https://www.pcisecuritystandards.org/assessors_and_solutions/approved_scanning_vendors
# Results must show PASS status from the ASV

# Test 11.4: Penetration test scope (annual minimum)
# Must cover:
# - Network-layer penetration testing (CDE perimeter and internal)
# - Application-layer penetration testing (all CDE web apps/APIs)
# - Segmentation verification (if segmentation used for scope reduction)
```

### Penetration Test Report Requirements

```markdown
## PCI-DSS Penetration Test Summary

**Scope**: [CDE systems, segmentation boundaries]
**Methodology**: [PTES, OWASP, NIST SP 800-115]
**Date**: [test dates]
**Tester**: [QSA or qualified internal resource]

### Network Layer Findings
| # | Severity | Finding | Affected System | Remediation |
|---|----------|---------|-----------------|-------------|

### Application Layer Findings
| # | Severity | Finding | Affected App | OWASP Category | Remediation |

### Segmentation Verification
| Source | Destination | Expected | Actual | Status |
|--------|-------------|----------|--------|--------|
| Non-CDE VLAN | CDE DB port | BLOCKED | BLOCKED | PASS |
```

---

## REQUIREMENT 12: SECURITY POLICIES

### Policy and Procedure Verification

- [ ] Information security policy reviewed and approved annually
- [ ] Acceptable use policy for CDE technologies documented
- [ ] Risk assessment performed annually and after significant changes
- [ ] Incident response plan documented, tested annually
- [ ] Security awareness training completed by all personnel annually
- [ ] Service provider management: all providers with CDE access have written agreements
- [ ] Service provider PCI compliance status verified annually

---

## SAQ MAPPING TEMPLATE

```markdown
# PCI-DSS v4.0 Self-Assessment Questionnaire Mapping

**Merchant Name**: [name]
**SAQ Type**: [A | A-EP | B | B-IP | C | C-VT | D-Merchant | D-ServiceProvider]
**Assessment Date**: [date]
**PCI-DSS Version**: 4.0

## SAQ Type Determination

| Question | Answer |
|----------|--------|
| Do you accept card-present transactions? | Yes/No |
| Do you accept card-not-present (e-commerce) transactions? | Yes/No |
| Does your system store, process, or transmit cardholder data? | Yes/No |
| Is all card processing fully outsourced to PCI-validated processor? | Yes/No |
| Does your website redirect to / iframe the processor's payment page? | Yes/No |

**Determined SAQ Type**: [type with justification]

## Control Assessment Summary

| Req | Description | Status | Evidence | Notes |
|-----|------------|--------|----------|-------|
| 1 | Network security controls | PASS/FAIL/N-A | [ref] | |
| 2 | Secure configurations | PASS/FAIL/N-A | [ref] | |
| 3 | Protect stored account data | PASS/FAIL/N-A | [ref] | |
| 4 | Encrypt transmissions | PASS/FAIL/N-A | [ref] | |
| 5 | Malware protection | PASS/FAIL/N-A | [ref] | |
| 6 | Secure development | PASS/FAIL/N-A | [ref] | |
| 7 | Restrict access | PASS/FAIL/N-A | [ref] | |
| 8 | Identify and authenticate | PASS/FAIL/N-A | [ref] | |
| 9 | Physical access | PASS/FAIL/N-A | [ref] | |
| 10 | Logging and monitoring | PASS/FAIL/N-A | [ref] | |
| 11 | Security testing | PASS/FAIL/N-A | [ref] | |
| 12 | Security policies | PASS/FAIL/N-A | [ref] | |

## Compensating Controls (if any)

| Req | Original Control | Compensating Control | Justification |
|-----|-----------------|---------------------|---------------|

## Findings Requiring Remediation

| # | Req | Severity | Finding | Remediation Plan | Target Date | Owner |
|---|-----|----------|---------|-----------------|-------------|-------|

## Attestation
**Merchant Representative**:
Name: ___________________  Title: ___________  Date: ___________
Signature: ___________________

**QSA (if applicable)**:
Name: ___________________  Company: ___________  Date: ___________
Signature: ___________________
```

---

## TOKENIZATION PATTERNS

### Stripe Integration (SAQ A)

```typescript
// Server-side: Create PaymentIntent (never touches raw card data)
const paymentIntent = await stripe.paymentIntents.create({
  amount: order.totalCents,
  currency: 'usd',
  automatic_payment_methods: { enabled: true },
  metadata: { orderId: order.id },
});
// Return client_secret to frontend for Stripe Elements to complete payment
```

### Braintree Integration (SAQ A)

```typescript
// Server-side: Generate client token
const clientToken = await gateway.clientToken.generate({
  customerId: customer.braintreeId,
});
// Frontend uses Drop-in UI with clientToken
// Server receives payment_method_nonce (token), never raw PAN

const result = await gateway.transaction.sale({
  amount: order.total,
  paymentMethodNonce: nonce, // Token from client
  options: { submitForSettlement: true },
});
```

### Key Tokenization Principles

| Principle | Description |
|-----------|------------|
| Client-side collection | Card data goes directly to processor, bypasses your servers |
| Token storage | Store processor tokens (tok_xxx), never raw PANs |
| No logging of PAN | Ensure no middleware, proxy, or WAF logs raw card numbers |
| PCI scope validation | Confirm with QSA that your integration qualifies for target SAQ |

---

## CHECKLIST

- [ ] Cardholder Data Environment (CDE) scope defined and documented
- [ ] Tokenization implemented to minimize PCI scope (SAQ A target)
- [ ] Network segmentation isolates CDE from non-CDE systems
- [ ] Firewall rules restrict CDE access to documented, justified flows
- [ ] No default credentials on any CDE system
- [ ] CIS benchmarks applied to CDE operating systems and databases
- [ ] No prohibited data stored (CVV, full track, PIN)
- [ ] PANs encrypted at rest (AES-256) or tokenized
- [ ] PAN masked in all displays (first-6/last-4 maximum)
- [ ] TLS 1.2+ enforced on all CDE communications
- [ ] No PANs in log files, error messages, or debug output
- [ ] SAST scanning runs on every code change to CDE applications
- [ ] Dependency scanning (SCA) runs on every build
- [ ] Code review required before CDE code deployed to production
- [ ] MFA enforced for all CDE administrative access
- [ ] Password policy meets v4.0 requirements (12+ chars, complexity)
- [ ] Account lockout after 10 failed attempts
- [ ] Session timeout at 15 minutes of inactivity
- [ ] Audit logging captures all CDE access and authentication events
- [ ] Logs retained 12 months (3 months immediately available)
- [ ] NTP synchronized across all CDE systems
- [ ] Internal vulnerability scans quarterly (or after significant changes)
- [ ] External ASV scans quarterly with passing status
- [ ] Annual penetration test covering network and application layers
- [ ] Annual risk assessment performed and documented
- [ ] Incident response plan tested annually
- [ ] All third-party service providers with CDE access have PCI AOC on file
- [ ] SAQ completed and filed with acquirer

---

*Skill Version: 1.0 | Created: March 2026*
