# Blueprint: SaaS Multi-Tenant

A multi-tenant SaaS platform where multiple organizations share the same application instance with isolated data. This blueprint covers tenant isolation, billing integration, white-labeling, and data privacy.

## Recommended Tech Stacks

| Stack | Language | Best For |
|-------|----------|----------|
| NestJS + React | TypeScript | Full-stack TypeScript, enterprise features |
| Django + React | Python | Rapid development, strong admin, django-tenants |
| Rails + Hotwire | Ruby | Convention-heavy, fast to market |
| Spring Boot + React | Java/Kotlin | Enterprise, JVM ecosystem, complex domains |
| Next.js + Supabase | TypeScript | Serverless-friendly, fast prototyping |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define tenant model, pricing tiers, isolation requirements
- **prd_generator** -- Document tenant lifecycle, admin flows, billing rules
- **market_sizing** -- TAM/SAM for target vertical
- **lean_canvas** -- Business model with per-seat or usage-based pricing

### Phase 2: Architecture
- **schema_design** -- Tenant isolation strategy (shared DB, schema-per-tenant, DB-per-tenant)
- **auth_architecture** -- Tenant-scoped auth, SSO/SAML for enterprise tenants
- **api_design** -- Tenant context in every request (subdomain, header, or path)
- **caching_strategy** -- Tenant-aware cache keys, eviction per tenant

### Phase 3: Implementation
- **tdd_workflow** -- Test with multiple tenants, verify isolation
- **code_review** -- Review every query for tenant scoping
- **validation_patterns** -- Tenant-aware input validation

### Phase 4: Testing and Security
- **security_audit** -- Cross-tenant data leak testing
- **integration_testing** -- Multi-tenant scenario tests
- **compliance_as_code** -- Data residency, GDPR per-tenant controls
- **load_testing** -- Noisy neighbor simulation

### Phase 5: Deployment
- **ci_cd_pipeline** -- Tenant provisioning automation
- **infrastructure_as_code** -- Scalable infrastructure with tenant routing
- **db_migrations** -- Migrations across all tenant schemas

### Phase 6-7: Release and Operations
- **monitoring_setup** -- Per-tenant metrics, usage tracking for billing
- **incident_response** -- Tenant-scoped incident isolation

## Key Domain-Specific Concerns

### Tenant Isolation Strategies

| Strategy | Isolation | Complexity | Cost | Best For |
|----------|-----------|------------|------|----------|
| Shared DB, shared schema | Row-level (`tenant_id`) | Low | Low | Most SaaS, <1000 tenants |
| Shared DB, schema-per-tenant | Schema-level | Medium | Medium | Regulated industries |
| Database-per-tenant | Full | High | High | Enterprise, compliance-heavy |

For most SaaS, start with **shared schema + row-level isolation**:
- Add `tenant_id` to every table
- Apply tenant filter on every query (middleware or ORM scope)
- Use Row-Level Security (RLS) in PostgreSQL as defense in depth
- Index on `(tenant_id, ...)` for all queries

### Tenant Context Resolution

How to determine which tenant a request belongs to:

| Method | Example | Pros | Cons |
|--------|---------|------|------|
| Subdomain | `acme.app.com` | Clean, natural | DNS/cert management |
| Path prefix | `app.com/acme/...` | Simple routing | Cluttered URLs |
| Header | `X-Tenant-ID: acme` | API-friendly | Not browser-friendly |
| JWT claim | `{ tenantId: "acme" }` | Secure, no URL change | Requires auth first |

### Billing Integration (Stripe)

Core concepts:
- **Customer** = Tenant/Organization (not individual user)
- **Subscription** = Active plan with billing cycle
- **Usage records** = Metered billing data points
- **Webhook events** = Subscription lifecycle (created, updated, canceled, past_due)

Billing models:
| Model | Example | Stripe Feature |
|-------|---------|----------------|
| Flat rate | $49/mo for Pro plan | Simple subscription |
| Per-seat | $10/user/mo | Subscription with quantity |
| Usage-based | $0.01/API call | Metered billing |
| Tiered | First 1000 free, then $0.005/call | Graduated pricing |
| Hybrid | $29/mo base + $0.01/call overage | Subscription + metered |

### White-Labeling

Levels of customization:
1. **Logo and colors** -- Tenant-specific theme stored in DB
2. **Custom domain** -- Tenant brings their own domain (CNAME + SSL)
3. **Email branding** -- Tenant logo in transactional emails
4. **Full rebrand** -- Remove all references to your brand

### Data Privacy

- Tenant data must never leak to other tenants (test this explicitly)
- Support data export per tenant (GDPR Article 20)
- Support tenant data deletion (GDPR Article 17)
- Audit log per tenant for compliance
- Consider data residency requirements (EU, US, APAC)

### Onboarding Flow

1. Sign up creates organization + first admin user
2. Provision tenant (schema, defaults, seed data)
3. Invite team members (email invitations)
4. Configure workspace (branding, integrations)
5. Choose plan and enter billing details
6. First value moment (guided by onboarding checklist)

## Getting Started

1. **Choose isolation strategy** -- Shared schema with `tenant_id` for most cases
2. **Design tenant model** -- Organization, membership, roles, invitations
3. **Implement tenant middleware** -- Resolve tenant from subdomain/header on every request
4. **Add tenant scoping to ORM** -- Global filter/scope that adds `WHERE tenant_id = ?`
5. **Build auth with tenant context** -- JWT includes `tenantId`, login resolves org
6. **Create tenant provisioning** -- Sign-up creates org, seeds defaults
7. **Integrate Stripe** -- Customer per org, webhook handler, billing portal
8. **Add admin dashboard** -- Tenant management, user management, plan management
9. **Implement usage tracking** -- Metered features for billing and limits
10. **Test cross-tenant isolation** -- Explicitly verify no data leaks between tenants

## Project Structure (NestJS Example)

```
src/
  app.module.ts
  common/
    middleware/
      tenant.middleware.ts    # Resolve tenant from request
    guards/
      auth.guard.ts           # JWT + tenant validation
    decorators/
      current-tenant.ts       # @CurrentTenant() decorator
    interceptors/
      tenant-scope.ts         # Auto-apply tenant filter
  modules/
    tenants/                  # Tenant CRUD, provisioning
    auth/                     # Login, register, invite
    billing/                  # Stripe integration
    users/                    # User management within tenant
    [feature]/                # Business logic modules
  prisma/
    schema.prisma             # All models have tenantId
    migrations/
```
