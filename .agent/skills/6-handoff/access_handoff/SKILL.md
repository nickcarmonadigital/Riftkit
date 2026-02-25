---
name: Access Handoff
description: Structured credential and access transfer with inventory, transfer matrix, revocation checklist, and emergency access procedures
---

# Access Handoff Skill

**Purpose**: Transfer all credentials, API keys, service accounts, and access permissions from the current team to the receiving team in a structured, auditable way. This skill ensures no credential is forgotten, no access is left dangling, and emergency access procedures are documented. A missed credential during handoff becomes a production incident at 2 AM.

## TRIGGER COMMANDS

```text
"Transfer access for [project]"
"Credential handoff"
"Access inventory"
"Revoke departing team access"
"Using access_handoff skill: transfer [project] credentials"
```

## When to Use

- Handing off a project to a new team, client, or maintainer
- A team member with critical access is departing
- Conducting a security audit of who has access to what
- After `knowledge_audit` has identified the credential inventory

---

## PROCESS

### Step 1: Complete the Credential Inventory

Expand the credential inventory from `knowledge_audit` into a comprehensive register.

**Credential Categories**:

| Category | Examples | Risk Level |
|----------|----------|-----------|
| **Infrastructure** | Cloud provider (AWS/GCP/Azure), hosting (Vercel/Railway), DNS | Critical |
| **Database** | Connection strings, admin passwords, read replicas | Critical |
| **Payment** | Stripe secret keys, webhook secrets | Critical |
| **Authentication** | JWT secrets, OAuth client secrets, SAML certs | Critical |
| **Email** | SMTP credentials, API keys (SendGrid/Resend) | High |
| **AI/ML** | OpenAI, Anthropic, Hugging Face API keys | High |
| **Monitoring** | Sentry, Datadog, PagerDuty API tokens | Medium |
| **Source Control** | GitHub/GitLab deploy keys, bot tokens | High |
| **CDN/Storage** | S3 bucket credentials, CloudFront keys | High |
| **Domain** | Registrar login, SSL certificate keys | Critical |
| **Third-Party SaaS** | Intercom, Zendesk, PostHog, analytics | Medium |

**Full Credential Register**:

```markdown
# Credential Register - [Project Name]
**Last Updated**: YYYY-MM-DD
**Prepared By**: [Name]
**Classification**: CONFIDENTIAL

| # | Credential | Service | Type | Location | Current Owner | New Owner | Rotation Due | Transfer Status |
|---|-----------|---------|------|----------|--------------|-----------|-------------|-----------------|
| 1 | AWS Root Account | AWS | Login | 1Password vault | [Name] | [Name] | N/A | Pending |
| 2 | DATABASE_URL | Supabase | Conn string | Railway env vars | [Name] | [Name] | Q2 2026 | Pending |
| 3 | STRIPE_SECRET_KEY | Stripe | API key | .env + Railway | [Name] | [Name] | Annually | Pending |
| 4 | JWT_SECRET | Internal | Secret | .env + Railway | [Name] | [Name] | Never set | ROTATE NOW |
| 5 | GH_DEPLOY_KEY | GitHub | SSH key | GitHub settings | [Name] | [Name] | Annually | Pending |
```

### Step 2: Build the Access Transfer Matrix

Map every person to every system they access and what level of access they have.

```markdown
# Access Transfer Matrix

| System | Departing: [Name] | Departing: [Name] | Receiving: [Name] | Receiving: [Name] |
|--------|------------------|-------------------|-------------------|-------------------|
| AWS Console | Admin (revoke) | Read (revoke) | Admin (grant) | Read (grant) |
| GitHub Repo | Maintainer (revoke) | Write (revoke) | Maintainer (grant) | Write (grant) |
| Stripe Dashboard | Admin (revoke) | -- | Admin (grant) | Read (grant) |
| Supabase | Owner (transfer) | -- | Owner (accept) | Developer (grant) |
| Vercel | Owner (transfer) | -- | Owner (accept) | -- |
| Sentry | Admin (revoke) | Member (revoke) | Admin (grant) | Member (grant) |
| PagerDuty | Responder (revoke) | -- | Responder (grant) | Responder (grant) |
| Domain Registrar | Account holder (transfer) | -- | Account holder (accept) | -- |
```

### Step 3: Execute the Transfer Sequence

Follow this sequence strictly. Granting new access before revoking old access prevents lockout.

```text
TRANSFER SEQUENCE (do not skip steps or reorder)

Phase A: Preparation
  1. [ ] New owners create accounts on all services (do NOT share logins)
  2. [ ] New owners set up MFA on all critical services
  3. [ ] Password manager vault shared with receiving team
  4. [ ] Verify new owners can log in to every service

Phase B: Access Grants (new team gets access)
  5. [ ] Grant new team access at appropriate permission levels
  6. [ ] New team verifies they can perform required operations
  7. [ ] Transfer organization ownership where applicable
  8. [ ] Update billing contacts to new team

Phase C: Credential Rotation (invalidate old credentials)
  9. [ ] Rotate all API keys and secrets (new values go to new team only)
  10. [ ] Update environment variables in all deployment targets
  11. [ ] Verify application still works after rotation
  12. [ ] Update credential register with new rotation dates

Phase D: Access Revocation (old team loses access)
  13. [ ] Revoke departing team from all services
  14. [ ] Remove departing team SSH keys from servers
  15. [ ] Remove departing team from GitHub/GitLab org
  16. [ ] Deactivate departing team PagerDuty/on-call schedules
  17. [ ] Verify departing team can no longer access any system

Phase E: Verification
  18. [ ] New team performs a test deployment end-to-end
  19. [ ] New team triggers and resolves a test alert
  20. [ ] Emergency access procedure tested by new team
```

### Step 4: Document Emergency Access Procedures

For critical systems, define how to regain access if the primary administrator is unavailable.

```markdown
# Emergency Access Procedures

## AWS Account Recovery
- **Break-glass method**: Root account credentials stored in [sealed envelope / physical safe / hardware security module]
- **Recovery email**: [recovery email address]
- **MFA backup codes**: Stored in [location]

## Database Emergency Access
- **Supabase**: Organization owner can reset passwords via dashboard
- **Self-hosted**: Break-glass SQL user `emergency_admin` with password in [sealed location]

## Domain Recovery
- **Registrar**: [Name] registered with [registrar email]
- **Transfer lock**: Enabled (must be disabled before transfer)
- **Auth code**: Available in registrar dashboard under [Name]'s account

## Service Account Keys
- **Rotation procedure**: [Step-by-step for each critical service]
- **Who can rotate**: [List of authorized personnel]
- **Impact of rotation**: [What breaks and how to update dependent services]
```

### Step 5: Information Asset Register (ISO 27001 Alignment)

For organizations with compliance requirements, produce a formal information asset register.

```markdown
# Information Asset Register

| Asset ID | Asset Name | Classification | Owner | Custodian | Location | Backup | Retention |
|----------|-----------|---------------|-------|-----------|----------|--------|-----------|
| IA-001 | Production Database | Confidential | [Name] | [Name] | Supabase | Daily/PITR | Indefinite |
| IA-002 | User PII Dataset | Restricted | [Name] | [Name] | PostgreSQL | Daily | Per GDPR |
| IA-003 | Source Code | Internal | [Name] | [Name] | GitHub | Git | Indefinite |
| IA-004 | SSL Certificates | Confidential | [Name] | [Name] | Cloudflare | Auto-renew | 1 year |
| IA-005 | API Keys Vault | Restricted | [Name] | [Name] | 1Password | Vault backup | Indefinite |
```

---

## CHECKLIST

- [ ] Complete credential inventory produced (every secret, key, certificate)
- [ ] Access transfer matrix maps every person to every system
- [ ] New team accounts created with MFA enabled on all critical services
- [ ] Access granted to new team and verified before revoking old access
- [ ] All API keys and secrets rotated during transfer
- [ ] Environment variables updated in all deployment targets
- [ ] Departing team access revoked from every system
- [ ] Emergency access procedures documented and tested
- [ ] New team successfully performs end-to-end test deployment
- [ ] Information asset register produced (if compliance required)
- [ ] Credential register stored in secure, accessible location
- [ ] Transfer sign-off obtained from both departing and receiving teams

---

*Skill Version: 1.0 | Created: February 2026*
