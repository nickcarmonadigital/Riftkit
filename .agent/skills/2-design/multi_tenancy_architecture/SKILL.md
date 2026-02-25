---
name: Multi-Tenancy Architecture
description: Tenancy model selection framework with isolation patterns, tenant resolution, cross-tenant prevention, and offboarding design
---

# Multi-Tenancy Architecture Skill

**Purpose**: Provides a complete tenancy model selection framework and implementation design for SaaS applications. Covers the three primary isolation models, tenant resolution patterns, cross-tenant data leak prevention, tenant-aware caching, and tenant offboarding -- ensuring isolation decisions are made at design time rather than discovered during a security incident.

## TRIGGER COMMANDS

```text
"Multi-tenant design"
"Tenant isolation architecture"
"SaaS tenancy model"
```

## When to Use
- When building a SaaS product serving multiple organizations
- When tenant data isolation is a compliance requirement
- Before designing database schemas, caching layers, or API middleware
- When evaluating whether to move from single-tenant to multi-tenant

---

## PROCESS

### Step 1: Evaluate Tenancy Models

Use this decision matrix to select the right model:

```markdown
## Tenancy Model Decision Matrix

| Factor | Row-Level (Shared DB) | Schema-Per-Tenant | Database-Per-Tenant |
|--------|----------------------|-------------------|---------------------|
| **Data Isolation** | Low (logical) | Medium (schema) | High (physical) |
| **Regulatory Compliance** | May not satisfy | Often sufficient | Gold standard |
| **Operational Complexity** | Low | Medium | High |
| **Cost Per Tenant** | Lowest | Medium | Highest |
| **Max Tenant Scale** | 10,000+ | 1,000 | 100 |
| **Cross-Tenant Query Risk** | Highest | Medium | Lowest |
| **Customization Per Tenant** | Limited | Schema-level | Full |
| **Backup/Restore Granularity** | All-or-nothing | Per-schema | Per-database |
| **Noisy Neighbor Risk** | Highest | Medium | Lowest |

## Selection Guide
- **Row-Level**: Default for most SaaS. Best cost/scale ratio.
- **Schema-Per-Tenant**: When regulation requires stronger isolation but budget limits separate DBs.
- **Database-Per-Tenant**: When contracts require physical isolation (enterprise, healthcare, government).
```

### Step 2: Design Tenant Resolution

Define how the system determines which tenant a request belongs to:

```markdown
## Tenant Resolution Strategies

| Strategy | Implementation | Pros | Cons |
|----------|---------------|------|------|
| **Subdomain** | `{tenant}.app.com` | Clean URL, DNS-based | SSL wildcard cert needed |
| **Path prefix** | `app.com/{tenant}/` | Simple, single domain | Routing complexity |
| **JWT claim** | `token.tenantId` | No URL changes | Requires auth on every request |
| **Header** | `X-Tenant-ID` | Flexible | Easy to spoof if not validated |
| **Database lookup** | Resolve from user's org membership | Most secure | Extra DB query per request |

## Recommended: JWT claim + database verification
1. Extract `tenantId` from JWT payload
2. Verify user actually belongs to tenant (prevent token manipulation)
3. Inject `tenantId` into request context via middleware
4. All downstream services read tenant from context, never from user input
```

### Step 3: Implement Cross-Tenant Query Prevention

For row-level isolation, design the enforcement layer:

```markdown
## Cross-Tenant Prevention Architecture

### Layer 1: Middleware Tenant Injection
Every request gets `tenantId` injected into the execution context.
No service can operate without a resolved tenant.

### Layer 2: Repository/ORM Scoping
All queries are automatically scoped:

// Prisma middleware example
prisma.$use(async (params, next) => {
  if (params.action === 'findMany' || params.action === 'findFirst') {
    params.args.where = { ...params.args.where, tenantId: ctx.tenantId };
  }
  return next(params);
});

### Layer 3: Database-Level (Defense in Depth)
PostgreSQL Row-Level Security as the final safety net:

CREATE POLICY tenant_isolation ON resources
  USING (tenant_id = current_setting('app.current_tenant')::uuid);

### Layer 4: Audit
Log any query that does NOT include a tenant filter (should be zero in production).
```

### Step 4: Tenant-Aware Caching

```markdown
## Caching Strategy

| Approach | Key Pattern | Use When |
|----------|-------------|----------|
| **Prefixed keys** | `tenant:{id}:resource:{rid}` | Row-level isolation |
| **Separate databases** | Redis DB 0-15 per tenant | Schema-per-tenant (limited) |
| **Separate clusters** | Dedicated Redis per tenant | Database-per-tenant |

## Cache Invalidation
- Tenant data changes invalidate ONLY that tenant's cache keys
- Global config changes (feature flags) invalidate all tenants
- Tenant offboarding: flush all keys matching `tenant:{id}:*`
```

### Step 5: Tenant Offboarding and Data Export

```markdown
## Offboarding Procedure

1. **Disable tenant**: Set tenant status to `suspended` (blocks new API calls)
2. **Data export**: Generate complete data export (JSON/CSV) for the tenant
3. **Grace period**: 30-day window for tenant to download export
4. **Data purge**: Delete all rows where `tenantId = X` across all tables
5. **Cache flush**: Remove all cache keys for the tenant
6. **Audit log**: Retain offboarding audit record (without tenant PII)
7. **Confirmation**: Notify tenant that data has been purged

## Phase 4 Test Requirements
- Integration test: Tenant A cannot read Tenant B's data
- Integration test: Tenant offboarding removes all data
- Load test: Tenant isolation holds under concurrent multi-tenant load
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/multi-tenancy-architecture.md`

---

## CHECKLIST

- [ ] Tenancy model selected with decision matrix justification
- [ ] Tenant resolution strategy designed and documented
- [ ] Cross-tenant query prevention implemented at 3+ layers
- [ ] Tenant-aware caching strategy defined with key patterns
- [ ] Tenant offboarding procedure covers export, purge, and confirmation
- [ ] Database-level RLS policies specified (for row-level model)
- [ ] Phase 4 cross-tenant isolation test cases defined
- [ ] Noisy neighbor mitigation strategy documented
- [ ] Tenant provisioning flow designed (create tenant, seed data)
- [ ] ADR created for tenancy model selection

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
