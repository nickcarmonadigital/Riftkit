---
description: Security hardening workflow — systematic process to identify and remediate security vulnerabilities across the full stack, from threat modeling through runtime monitoring.
---

# /security-hardening Workflow

> Use when hardening a system's security posture before launch, after an incident, or as part of a periodic security review. Run all steps — skipping any creates blind spots.

## When to Use

- [ ] Pre-launch security review
- [ ] Post-incident security hardening
- [ ] Periodic security assessment (quarterly recommended)
- [ ] New attack surface introduced (new API, new integration, new deployment)

---

## Step 1: Threat Model

Identify what you're protecting and from whom.

```bash
view_file .agent/skills/2-design/security_threat_modeling/SKILL.md
```

- [ ] Assets cataloged (data, services, infrastructure)
- [ ] Trust boundaries identified (internal vs. external, service-to-service)
- [ ] Threat actors profiled (script kiddies, insiders, nation-state)
- [ ] Attack vectors enumerated (STRIDE or similar framework)
- [ ] Risk ratings assigned to each threat
- [ ] Threat model document created/updated

---

## Step 2: SAST Scan — Static Analysis

Find vulnerabilities in source code.

```bash
view_file .agent/skills/4-secure/sast_scanning/SKILL.md
```

- [ ] SAST tool configured and run against codebase
- [ ] Critical and high findings triaged (false positives marked)
- [ ] SQL injection patterns checked
- [ ] XSS patterns checked
- [ ] Insecure deserialization checked
- [ ] All confirmed critical/high findings fixed

---

## Step 3: Secrets Scan

Ensure no secrets are exposed in code or history.

```bash
view_file .agent/skills/4-secure/secrets_scanning/SKILL.md
```

- [ ] Secrets scanner run against current codebase
- [ ] Git history scanned for leaked secrets
- [ ] Any found secrets rotated immediately
- [ ] Pre-commit hook installed to prevent future leaks
- [ ] CI pipeline includes secrets scanning step

**Gate**: Any active secret found in code = stop and rotate before proceeding.

---

## Step 4: Dependency Audit — Supply Chain

Check third-party dependencies for known vulnerabilities.

```bash
view_file .agent/skills/4-secure/supply_chain_security/SKILL.md
```

- [ ] Dependency audit run (npm audit, pip audit, etc.)
- [ ] Critical/high CVEs identified and patched
- [ ] Lockfile integrity verified
- [ ] Unused dependencies removed
- [ ] Dependency update policy documented
- [ ] SBOM generated

---

## Step 5: Container Hardening

Secure container images and runtime configuration.

```bash
view_file .agent/skills/4-secure/container_security/SKILL.md
```

- [ ] Base images use minimal distro (Alpine, distroless)
- [ ] No root user in container (USER directive set)
- [ ] Read-only filesystem where possible
- [ ] No unnecessary capabilities (drop ALL, add only needed)
- [ ] Image scanning run (Trivy, Snyk Container)
- [ ] Docker socket not mounted into containers

---

## Step 6: API Security Review

Test API endpoints for security weaknesses.

```bash
view_file .agent/skills/4-secure/api_security_testing/SKILL.md
```

- [ ] Authentication required on all non-public endpoints
- [ ] Authorization checked at every endpoint (not just middleware)
- [ ] Rate limiting configured on auth and public endpoints
- [ ] Input validation on all request bodies and parameters
- [ ] CORS configured restrictively (not wildcard)
- [ ] API responses do not leak internal details (stack traces, DB errors)

---

## Step 7: SSRF Testing

Test for server-side request forgery vulnerabilities.

```bash
view_file .agent/skills/4-secure/ssrf_testing_harness/SKILL.md
```

- [ ] All user-controlled URL inputs identified
- [ ] Internal network access blocked from URL inputs
- [ ] Metadata endpoint access blocked (169.254.169.254)
- [ ] URL scheme restricted (https only where possible)
- [ ] Redirect following disabled or restricted
- [ ] SSRF test cases executed and passing

---

## Step 8: Runtime Monitoring Setup

Detect attacks and anomalies in production.

```bash
view_file .agent/skills/3-build/runtime_security_monitoring/SKILL.md
```

- [ ] Intrusion detection rules configured
- [ ] Anomalous request pattern alerting set up
- [ ] Failed authentication attempt monitoring active
- [ ] File integrity monitoring on critical configs
- [ ] Network traffic monitoring for unusual patterns
- [ ] Alert escalation paths defined

---

## Step 9: Security Audit Sign-Off

Final comprehensive review and approval.

```bash
view_file .agent/skills/4-secure/security_audit/SKILL.md
```

- [ ] All previous steps completed and documented
- [ ] Open findings cataloged with severity and remediation plan
- [ ] No critical or high findings remain unaddressed
- [ ] Security audit report generated
- [ ] Sign-off from security lead or designated reviewer
- [ ] Next review date scheduled

---

## Exit Checklist — Security Hardened

- [ ] Threat model current and documented
- [ ] No critical/high SAST findings open
- [ ] No secrets in codebase or git history
- [ ] Dependencies patched and monitored
- [ ] Containers follow hardening best practices
- [ ] API security verified
- [ ] SSRF protections tested
- [ ] Runtime monitoring active
- [ ] Security audit signed off

*Workflow Version: 1.0 | Created: March 2026*
