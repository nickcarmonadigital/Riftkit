---
name: Security Maintenance
description: Ongoing security practice with monthly CVE monitoring, patch prioritization, penetration test scheduling, and certificate rotation tracking.
---

# Security Maintenance Skill

**Purpose**: Security is not a phase -- it is a continuous practice. This skill establishes recurring cadences for CVE monitoring, security patch prioritization using CVSS scores, penetration test scheduling, certificate rotation, and advisory monitoring so that your security posture does not degrade after launch.

## TRIGGER COMMANDS

```text
"Monthly security review"
"CVE check for [project]"
"Security patch planning"
"Certificate rotation status"
"Schedule penetration test"
"Security advisory check"
```

## When to Use
- Monthly security review cadence
- When a new CVE is published affecting your stack
- Planning quarterly or annual penetration tests
- Tracking certificate and secret expiration dates
- After a security incident to reassess posture

---

## PROCESS

### Step 1: Monthly CVE Monitoring

Run on the first Monday of every month:

```markdown
## Monthly CVE Review — [YYYY-MM]

### Sources Checked
- [ ] GitHub Security Advisories (Dependabot alerts)
- [ ] NVD (National Vulnerability Database) feed
- [ ] OWASP dependency-check report
- [ ] Vendor-specific advisories (cloud provider, framework)
- [ ] Snyk / Trivy / Grype scan results

### Findings
| CVE ID | Component | CVSS Score | Severity | Exploitability | Status |
|--------|-----------|------------|----------|----------------|--------|
| CVE-YYYY-XXXXX | [pkg@version] | [0-10] | [C/H/M/L] | [Active/PoC/None] | [Open/Patched] |
```

Automated scanning commands:
```bash
# npm audit (Node.js)
npm audit --omit=dev

# Trivy (container images)
trivy image [image:tag]

# OWASP dependency-check
dependency-check --project [name] --scan .

# Snyk (if configured)
snyk test
```

### Step 2: Patch Prioritization (CVSS-Based)

| CVSS Score | Severity | Patch SLA | Process |
|------------|----------|-----------|---------|
| **9.0 - 10.0** | Critical | 24 hours | Emergency patch, skip normal release cycle |
| **7.0 - 8.9** | High | 7 days | Priority sprint item, expedited review |
| **4.0 - 6.9** | Medium | 30 days | Normal sprint backlog |
| **0.1 - 3.9** | Low | 90 days | Batch with other maintenance |

Prioritization factors beyond CVSS:
- **Exploitability**: Is there a known exploit in the wild? (Bump up urgency)
- **Exposure**: Is the vulnerable component internet-facing? (Bump up urgency)
- **Data sensitivity**: Does it handle PII, credentials, or financial data? (Bump up urgency)
- **Compensating controls**: Is there a WAF rule, network segmentation, or feature flag that mitigates? (May allow deferral)

### Step 3: Penetration Test Management

| Activity | Cadence | Scope |
|----------|---------|-------|
| **Automated DAST scan** | Monthly | All public endpoints |
| **Dependency audit** | Monthly | All direct + transitive deps |
| **Internal pen test** | Quarterly | Top 5 risk areas |
| **External pen test** | Annually | Full application + infrastructure |
| **Red team exercise** | Annually (if applicable) | Social engineering + technical |

Penetration test preparation checklist:
- [ ] Scope document signed (in-scope/out-of-scope systems)
- [ ] Test environment provisioned (prefer staging, not production)
- [ ] Emergency contact list provided to testers
- [ ] Legal authorization / rules of engagement signed
- [ ] Monitoring team notified to avoid false incident declarations

### Step 4: Certificate and Secret Rotation

Track all certificates and secrets with expiration dates:

```markdown
## Certificate & Secret Inventory

| Asset | Type | Expires | Auto-Renew | Owner | Status |
|-------|------|---------|------------|-------|--------|
| *.example.com | TLS (Let's Encrypt) | [date] | Yes | DevOps | OK |
| API signing key | RSA-2048 | [date] | No | Backend | Needs rotation |
| DB credentials | Password | [date] | No | DBA | OK |
| OAuth client secret | Secret | [date] | No | Auth team | OK |
| JWT signing key | HMAC-256 | Never (rotate annually) | No | Backend | Due for rotation |
```

Rotation alerts:
- **90 days before expiry**: Email notification
- **30 days before expiry**: Ticket created, assigned to owner
- **7 days before expiry**: Page on-call, escalate to manager

### Step 5: Security Advisory Monitoring

Subscribe to and monitor:
- [ ] GitHub Security Advisories for all repositories
- [ ] Framework-specific mailing lists (e.g., Node.js security, Django security)
- [ ] Cloud provider security bulletins (AWS, GCP, Azure)
- [ ] CISA Known Exploited Vulnerabilities catalog
- [ ] Container base image advisories (Alpine, Debian, Ubuntu)

### Step 6: Incident Security Assessment

After any production incident, assess security implications:

```markdown
## Post-Incident Security Assessment

- [ ] Was the incident caused by a security vulnerability?
- [ ] Was any sensitive data exposed or exfiltrated?
- [ ] Were access logs reviewed for unauthorized access?
- [ ] Do any credentials need immediate rotation?
- [ ] Does this incident require breach notification (regulatory)?
- [ ] Are additional monitoring rules needed to detect recurrence?
```

---

## CHECKLIST

- [ ] Monthly CVE scan executed and findings documented
- [ ] All critical/high CVEs patched within SLA (24h / 7d)
- [ ] Penetration test scheduled per cadence (quarterly internal, annual external)
- [ ] Certificate inventory current with expiration alerts configured
- [ ] Secret rotation policy enforced (no secrets older than policy allows)
- [ ] Security advisory subscriptions active for all stack components
- [ ] Post-incident security assessment completed for every production incident
- [ ] OWASP dependency check integrated in CI pipeline
- [ ] Quarterly security posture summary shared with engineering leadership

---

*Skill Version: 1.0 | Created: February 2026*
