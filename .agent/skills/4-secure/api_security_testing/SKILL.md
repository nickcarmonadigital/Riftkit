---
name: API Security Testing
description: OWASP API Security Top 10 testing methodology with per-endpoint checklists for REST, GraphQL, and gRPC APIs
---

# API Security Testing Skill

**Purpose**: Systematically test APIs against the OWASP API Security Top 10 (2023 edition), plus GraphQL and gRPC-specific attack vectors. Produces a per-endpoint test plan with pass/fail tracking.

---

## TRIGGER COMMANDS

```text
"Test API security for [service]"
"OWASP API Top 10 audit for [project]"
"Check [endpoint] for BOLA/IDOR"
"API security test plan for [feature]"
"Using api_security_testing skill: audit [service]"
```

---

## PREREQUISITE: API INVENTORY

Before testing, enumerate the attack surface:

```text
Inventory Checklist:
[ ] OpenAPI/Swagger spec located and version-checked
[ ] All endpoints listed (including undocumented — check route files)
[ ] Authentication mechanisms identified (JWT, API key, OAuth, session)
[ ] Authorization model mapped (RBAC, ABAC, resource ownership)
[ ] Rate limiting configuration documented
[ ] Request/response content types identified
[ ] WebSocket and SSE endpoints cataloged
[ ] Internal-only vs public endpoints distinguished
```

```bash
# Extract routes from common frameworks
# NestJS
grep -rn "@(Get|Post|Put|Patch|Delete|All)\(" --include="*.ts" src/

# Express
grep -rn "router\.\(get\|post\|put\|patch\|delete\)\(" --include="*.ts" --include="*.js" src/

# Django
grep -rn "path\|re_path\|url(" --include="*.py" */urls.py

# Spring Boot
grep -rn "@(GetMapping|PostMapping|PutMapping|PatchMapping|DeleteMapping|RequestMapping)" --include="*.java" src/
```

---

## API1: BROKEN OBJECT LEVEL AUTHORIZATION (BOLA)

The most critical API vulnerability. Users access objects belonging to other users by manipulating IDs.

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Access own resource with valid token | GET /api/resources/{ownId} | 200 | [ ] |
| Access other user's resource | GET /api/resources/{otherId} | 403 | [ ] |
| Access resource with no token | GET /api/resources/{id} | 401 | [ ] |
| Enumerate sequential IDs | GET /api/resources/1, /2, /3... | 403 for non-owned | [ ] |
| UUID prediction (if UUIDs used) | GET /api/resources/{guessedUuid} | 403 | [ ] |
| Nested resource ownership | GET /api/orgs/{orgId}/users/{userId} | 403 if wrong org | [ ] |
| Batch endpoint ID injection | POST /api/resources/batch with mixed IDs | Partial 403 | [ ] |
| Filter parameter manipulation | GET /api/resources?userId={otherId} | Ignored or 403 | [ ] |

### Testing Script Pattern

```typescript
// BOLA test: verify resource isolation between users
async function testBOLA(baseUrl: string, endpoints: string[]) {
  const userAToken = await login('userA@test.com', 'password');
  const userBToken = await login('userB@test.com', 'password');

  // Create resource as User A
  const resource = await fetch(`${baseUrl}/api/resources`, {
    method: 'POST',
    headers: { Authorization: `Bearer ${userAToken}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: 'private-data' }),
  });
  const { id } = await resource.json();

  // Attempt access as User B — MUST return 403
  const unauthorized = await fetch(`${baseUrl}/api/resources/${id}`, {
    headers: { Authorization: `Bearer ${userBToken}` },
  });
  assert(unauthorized.status === 403, `BOLA FOUND: User B accessed User A resource ${id}`);

  // Attempt modification as User B — MUST return 403
  const modify = await fetch(`${baseUrl}/api/resources/${id}`, {
    method: 'PUT',
    headers: { Authorization: `Bearer ${userBToken}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: 'hijacked' }),
  });
  assert(modify.status === 403, `BOLA FOUND: User B modified User A resource ${id}`);
}
```

### Remediation Pattern

```typescript
// Every query MUST scope to the authenticated user
async findOne(id: string, userId: string) {
  const resource = await this.prisma.resource.findFirst({
    where: { id, ownerId: userId },  // CRITICAL: always include ownerId
  });
  if (!resource) throw new NotFoundException();
  return resource;
}
```

---

## API2: BROKEN AUTHENTICATION

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Login with valid credentials | POST /auth/login | 200 + token | [ ] |
| Login with wrong password | POST /auth/login | 401, generic message | [ ] |
| Login with nonexistent user | POST /auth/login | 401, same generic message | [ ] |
| Brute force (10+ rapid attempts) | POST /auth/login x10 | 429 after threshold | [ ] |
| Expired JWT accepted | GET /api/protected | 401 | [ ] |
| JWT with modified payload (re-signed) | GET /api/protected | 401 | [ ] |
| JWT with `alg: none` | GET /api/protected | 401 | [ ] |
| JWT with HMAC/RSA confusion | GET /api/protected | 401 | [ ] |
| Refresh token reuse after rotation | POST /auth/refresh | 401 + invalidate family | [ ] |
| Token in URL parameter | GET /api/resource?token=X | Rejected or not supported | [ ] |
| Missing Authorization header | GET /api/protected | 401 | [ ] |
| Bearer prefix missing | Authorization: {token} | 401 | [ ] |
| Password reset token expiry | POST /auth/reset (old token) | 400 | [ ] |
| Password reset token reuse | POST /auth/reset (used token) | 400 | [ ] |

### JWT-Specific Tests

```bash
# Decode JWT without verification (inspection only)
echo "$JWT" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .

# Check for weak signing — alg:none attack
# Replace header with {"alg":"none","typ":"JWT"}, remove signature
HEADER=$(echo -n '{"alg":"none","typ":"JWT"}' | base64 | tr -d '=')
PAYLOAD=$(echo "$JWT" | cut -d'.' -f2)
FORGED="${HEADER}.${PAYLOAD}."

# Check for HMAC/RSA confusion — if server uses RS256, try HS256 with public key
# This is a known vulnerability in some JWT libraries
```

### Remediation Checklist

```text
[ ] JWT library explicitly rejects alg:none
[ ] JWT verification specifies allowed algorithms (no auto-detect)
[ ] Token expiration enforced (short-lived: 15-60min)
[ ] Refresh token rotation with family invalidation
[ ] Account lockout after N failed attempts (5-10)
[ ] Lockout is time-based, not permanent (15-30min)
[ ] Password reset tokens are single-use and time-limited (1hr max)
[ ] Generic error messages for auth failures (no user enumeration)
[ ] Timing-safe comparison for tokens (crypto.timingSafeEqual)
```

---

## API3: BROKEN OBJECT PROPERTY LEVEL AUTHORIZATION

Users read or modify object properties they should not access (combines mass assignment + excessive data exposure).

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Response excludes sensitive fields | GET /api/users/me | No password, no internal IDs | [ ] |
| Cannot set `role` via update | PUT /api/users/me {role: "admin"} | role unchanged | [ ] |
| Cannot set `isVerified` via update | PUT /api/users/me {isVerified: true} | Ignored | [ ] |
| Cannot set `balance` via update | PUT /api/accounts/me {balance: 9999} | Ignored | [ ] |
| Nested object injection | PUT /api/users/me {profile: {role: "admin"}} | Ignored | [ ] |
| Extra fields in creation | POST /api/resources {name: "x", ownerId: "other"} | ownerId from token | [ ] |
| GraphQL field selection abuse | query { user { passwordHash }} | Field not queryable | [ ] |

### Remediation Pattern

```typescript
// Whitelist allowed update fields — never spread request body directly
class UpdateUserDto {
  @IsOptional() @IsString() @MaxLength(100)
  name?: string;

  @IsOptional() @IsString() @MaxLength(500)
  bio?: string;

  // role, isAdmin, balance — intentionally NOT included
}

// Response serialization — exclude sensitive fields
class UserResponseDto {
  id: string;
  name: string;
  email: string;
  // password, passwordHash, internalNotes — intentionally NOT included
}
```

---

## API4: UNRESTRICTED RESOURCE CONSUMPTION

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Rate limit: normal usage | 50 req/min | 200 | [ ] |
| Rate limit: exceed threshold | 200 req/min | 429 after limit | [ ] |
| Rate limit: auth endpoints | 10 req/min to /auth/login | 429 after 10 | [ ] |
| Large request body | POST with 100MB body | 413 | [ ] |
| Deep JSON nesting | POST with 100-level nested JSON | 400 | [ ] |
| Array bomb | POST with 100K element array | 400 | [ ] |
| Pagination abuse | GET /api/resources?limit=999999 | Capped to max (100) | [ ] |
| Missing pagination | GET /api/resources (no limit) | Default limit applied | [ ] |
| Regex DoS (ReDoS) | Input triggering catastrophic backtracking | No timeout | [ ] |
| GraphQL complexity bomb | query { a { b { c { d { e }}}}} x100 | 400 complexity exceeded | [ ] |
| File upload size | POST with oversized file | 413 | [ ] |
| Concurrent connection flood | 1000 parallel connections | Throttled | [ ] |

### Remediation Checklist

```text
[ ] Global rate limiter configured (e.g., express-rate-limit, @nestjs/throttler)
[ ] Per-endpoint rate limits for sensitive operations (auth, password reset)
[ ] Request body size limits (e.g., 1MB default)
[ ] JSON parsing depth limits
[ ] Pagination enforced with max limit (e.g., max 100 per page)
[ ] Default pagination applied when client omits limit
[ ] File upload size limits (e.g., 5MB images, 50MB documents)
[ ] Query timeout configured at database level
[ ] GraphQL query complexity/depth scoring enabled
```

---

## API5: BROKEN FUNCTION LEVEL AUTHORIZATION

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| User accesses admin endpoint | GET /api/admin/users | 403 | [ ] |
| User calls admin action | POST /api/admin/promote | 403 | [ ] |
| HTTP method confusion (GET vs DELETE) | DELETE /api/resources/{id} (read-only user) | 403 | [ ] |
| Case manipulation | GET /api/Admin/users | 403 or 404 | [ ] |
| Path traversal to admin | GET /api/users/../admin/config | 403 or 404 | [ ] |
| API version rollback | GET /v1/admin/users (if v2 fixed) | 403 | [ ] |
| Internal endpoint via direct URL | GET /internal/health-check | 403 from external | [ ] |
| Scope escalation (OAuth) | Token with `read` scope calls write endpoint | 403 | [ ] |

### Remediation Pattern

```typescript
// Role-based guard — apply at controller or route level
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@Controller('admin')
export class AdminController {
  @Delete('users/:id')
  async deleteUser(@Param('id') id: string) { /* ... */ }
}

// Method-level granularity where needed
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('resources')
export class ResourceController {
  @Get(':id')
  @Roles('user', 'admin')  // Both can read
  async findOne() { /* ... */ }

  @Delete(':id')
  @Roles('admin')           // Only admin can delete
  async remove() { /* ... */ }
}
```

---

## API6: UNRESTRICTED ACCESS TO SENSITIVE BUSINESS FLOWS

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Purchase flow without payment | Skip payment step, call order endpoint | 400 | [ ] |
| Workflow state skip | Jump from step 1 to step 5 | 400 invalid state | [ ] |
| Replay completed transaction | Resubmit completed order | 400 already processed | [ ] |
| Coupon reuse | Apply same coupon twice | 400 already applied | [ ] |
| Referral self-referral | Refer own account | 400 | [ ] |
| Inventory race condition | Buy last item concurrently x10 | Only 1 succeeds | [ ] |
| Price manipulation | Modify price in request body | Server-side price used | [ ] |
| Negative quantity | Order quantity: -1 | 400 validation error | [ ] |

### State Machine Validation

```text
Order State Machine — valid transitions only:
  DRAFT -> SUBMITTED -> PAYMENT_PENDING -> PAID -> FULFILLED -> COMPLETED
  DRAFT -> CANCELLED
  SUBMITTED -> CANCELLED
  PAYMENT_PENDING -> CANCELLED

Invalid transitions to test:
  DRAFT -> PAID (skip payment)
  FULFILLED -> DRAFT (rollback)
  COMPLETED -> PAID (replay)
  CANCELLED -> FULFILLED (resurrect)
```

### Remediation Pattern

```typescript
// Server-side state machine enforcement
async transitionOrder(orderId: string, targetState: OrderState, userId: string) {
  const order = await this.prisma.order.findFirst({
    where: { id: orderId, ownerId: userId },
  });
  if (!order) throw new NotFoundException();

  const validTransitions: Record<OrderState, OrderState[]> = {
    DRAFT: ['SUBMITTED', 'CANCELLED'],
    SUBMITTED: ['PAYMENT_PENDING', 'CANCELLED'],
    PAYMENT_PENDING: ['PAID', 'CANCELLED'],
    PAID: ['FULFILLED'],
    FULFILLED: ['COMPLETED'],
    COMPLETED: [],
    CANCELLED: [],
  };

  if (!validTransitions[order.state]?.includes(targetState)) {
    throw new BadRequestException(`Cannot transition from ${order.state} to ${targetState}`);
  }

  return this.prisma.order.update({
    where: { id: orderId },
    data: { state: targetState },
  });
}
```

---

## API7: SERVER-SIDE REQUEST FORGERY (SSRF)

Brief coverage here — see **ssrf_testing_harness** skill for comprehensive SSRF testing.

### Quick Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| URL pointing to localhost | POST /api/fetch-url {url: "http://127.0.0.1"} | 400 blocked | [ ] |
| URL pointing to metadata service | POST /api/fetch-url {url: "http://169.254.169.254"} | 400 blocked | [ ] |
| URL with DNS rebinding | POST /api/fetch-url {url: "http://rebind.example.com"} | 400 blocked | [ ] |
| URL with redirect to internal | POST /api/fetch-url {url: "http://evil.com/redirect"} | 400 blocked | [ ] |
| file:// schema | POST /api/fetch-url {url: "file:///etc/passwd"} | 400 blocked | [ ] |

> **Cross-reference**: For DNS rebinding, cloud metadata, redirect chains, and framework-specific SSRF patterns, use the `ssrf_testing_harness` skill.

---

## API8: LACK OF PROTECTION FROM AUTOMATED THREATS

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Credential stuffing (bulk login attempts) | POST /auth/login x1000 | Blocked after threshold | [ ] |
| Account creation spam | POST /auth/register x100 | Rate limited / CAPTCHA | [ ] |
| Scraping protection | GET /api/products x10000 | Rate limited | [ ] |
| CAPTCHA bypass (empty/fake token) | POST with invalid CAPTCHA | 400 | [ ] |
| Bot fingerprinting | Request without typical headers | Flagged | [ ] |
| Automated checkout | POST /api/checkout in <1s | Rate limited or CAPTCHA | [ ] |

### Remediation Checklist

```text
[ ] CAPTCHA on registration, login (after N failures), and checkout
[ ] Device fingerprinting for anomaly detection
[ ] Progressive delays on repeated failures
[ ] IP reputation checking for known bot networks
[ ] Behavioral analysis (request timing, mouse movement for web)
[ ] Account creation rate limits per IP
[ ] Monitoring for credential stuffing patterns
```

---

## API9: IMPROPER INVENTORY MANAGEMENT

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Deprecated API version accessible | GET /v1/endpoint (v2 is current) | 404 or redirect | [ ] |
| Undocumented endpoint accessible | GET /api/debug/info | 404 or 403 | [ ] |
| OpenAPI spec completeness | Compare spec vs actual routes | All routes in spec | [ ] |
| Staging/dev endpoints in production | GET /api/test/*, /api/debug/* | 404 | [ ] |
| Different auth on old version | GET /v1/endpoint (no auth) | 401 | [ ] |
| Shadow API detection | Compare traffic logs vs spec | No unknown routes | [ ] |

### Audit Script

```bash
# Compare OpenAPI spec routes vs actual code routes
# Step 1: Extract routes from spec
cat openapi.yaml | yq '.paths | keys[]' > spec-routes.txt

# Step 2: Extract routes from code (NestJS example)
grep -rn "@(Get|Post|Put|Patch|Delete)\(" --include="*.ts" src/ \
  | sed "s/.*@\(Get\|Post\|Put\|Patch\|Delete\)('\(.*\)').*/\1 \2/" \
  > code-routes.txt

# Step 3: Find mismatches
diff spec-routes.txt code-routes.txt
```

### Remediation Checklist

```text
[ ] API versioning strategy documented and enforced
[ ] Deprecated versions return Sunset header with deprecation date
[ ] Deprecated versions removed after sunset date
[ ] OpenAPI spec auto-generated from code (single source of truth)
[ ] CI check: no undocumented routes
[ ] Debug/test endpoints stripped from production builds
[ ] API inventory maintained with ownership and lifecycle status
```

---

## API10: UNSAFE CONSUMPTION OF APIS

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Third-party API response validation | Mock malicious response | Sanitized before use | [ ] |
| Third-party API timeout | Simulate 30s delay | Timeout at threshold | [ ] |
| Third-party TLS verification | Connect to self-signed cert | Rejected | [ ] |
| Webhook signature validation | POST with invalid signature | 401 | [ ] |
| Webhook replay attack | POST with old timestamp | 400 | [ ] |
| Third-party redirect following | 302 to internal URL | Blocked | [ ] |
| Certificate pinning (mobile) | MITM proxy | Connection refused | [ ] |
| Response size limits | Mock 1GB response | Truncated/rejected | [ ] |

### Remediation Pattern

```typescript
// Webhook signature validation (Stripe example pattern)
function verifyWebhookSignature(payload: string, signature: string, secret: string): boolean {
  const timestamp = signature.split(',')[0]?.split('=')[1];
  const sig = signature.split(',')[1]?.split('=')[1];

  // Reject old timestamps (prevent replay)
  const age = Math.floor(Date.now() / 1000) - parseInt(timestamp, 10);
  if (age > 300) return false; // 5 minute tolerance

  const expected = crypto
    .createHmac('sha256', secret)
    .update(`${timestamp}.${payload}`)
    .digest('hex');

  return crypto.timingSafeEqual(Buffer.from(sig), Buffer.from(expected));
}

// Third-party API client with safety defaults
const apiClient = axios.create({
  timeout: 10000,           // 10s timeout
  maxContentLength: 5e6,    // 5MB max response
  maxRedirects: 0,          // No redirect following
  httpsAgent: new https.Agent({
    rejectUnauthorized: true, // Enforce TLS verification
  }),
});
```

---

## GRAPHQL-SPECIFIC TESTING

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| Introspection in production | POST {query: "{__schema{types{name}}}"} | 400 disabled | [ ] |
| Query depth bomb | Deeply nested query (20+ levels) | 400 depth exceeded | [ ] |
| Query complexity bomb | Wide query selecting all fields | 400 complexity exceeded | [ ] |
| Batch query abuse | Array of 100 queries in single request | Rate limited | [ ] |
| Field suggestion leak | Misspell field name | No suggestions in prod | [ ] |
| Alias-based BOLA | {a: user(id:1){} b: user(id:2){}} | 403 for non-owned | [ ] |
| Mutation without auth | mutation { deleteUser(id:"x") } | 401 | [ ] |
| Subscription auth bypass | WebSocket subscription without token | Rejected | [ ] |

### Remediation Checklist

```text
[ ] Introspection disabled in production
[ ] Query depth limit set (e.g., max 10)
[ ] Query complexity scoring enabled (e.g., max cost 1000)
[ ] Batch query limit (e.g., max 5 per request)
[ ] Field-level authorization (not just type-level)
[ ] Persisted queries in production (optional, high security)
[ ] Error messages do not suggest field names
[ ] Subscription authentication enforced at WebSocket handshake
```

---

## GRPC-SPECIFIC TESTING

### Test Matrix

| Test Case | Method | Expected | Status |
|-----------|--------|----------|--------|
| TLS enforcement | Connect without TLS | Rejected | [ ] |
| Metadata auth validation | Call without auth metadata | UNAUTHENTICATED | [ ] |
| Reflection in production | grpc.reflection.v1.ServerReflection | Disabled | [ ] |
| Message size limit | Send 100MB message | RESOURCE_EXHAUSTED | [ ] |
| Unknown service call | Call non-existent service | UNIMPLEMENTED | [ ] |
| Deadline/timeout enforcement | Call with 0ms deadline | DEADLINE_EXCEEDED | [ ] |
| Interceptor bypass | Call without going through auth interceptor | Not possible | [ ] |

### Remediation Checklist

```text
[ ] Mutual TLS (mTLS) for service-to-service communication
[ ] Auth interceptor applied globally (not per-method opt-in)
[ ] Reflection disabled in production
[ ] Max message size configured (default 4MB, adjust as needed)
[ ] Deadline propagation enforced
[ ] Input validation on protobuf messages (proto3 defaults are zero-values)
[ ] Rate limiting via interceptor
```

---

## OUTPUT: API Security Test Plan

After running this skill, create: `.agent/docs/4-secure/api-security-test-plan-[date].md`

```markdown
# API Security Test Plan

**Date**: [Date]
**Service**: [Service Name]
**Base URL**: [Base URL]
**API Type**: [REST / GraphQL / gRPC / Mixed]
**OpenAPI Spec**: [Path or URL]
**Tester**: [Agent/Human]

## Endpoint Inventory

| Endpoint | Method | Auth | Roles | BOLA | Rate Limit | Status |
|----------|--------|------|-------|------|------------|--------|
| /api/users/:id | GET | JWT | user,admin | Scoped | 100/min | [ ] |
| /api/users/:id | PUT | JWT | owner,admin | Scoped | 50/min | [ ] |
| /api/admin/users | GET | JWT | admin | N/A | 20/min | [ ] |

## OWASP API Top 10 Results

| # | Category | Tested | Findings | Severity |
|---|----------|--------|----------|----------|
| API1 | BOLA | [ ] | | |
| API2 | Broken Auth | [ ] | | |
| API3 | Property Auth | [ ] | | |
| API4 | Resource Consumption | [ ] | | |
| API5 | Function Auth | [ ] | | |
| API6 | Business Flow | [ ] | | |
| API7 | SSRF | [ ] | | |
| API8 | Automated Threats | [ ] | | |
| API9 | Inventory | [ ] | | |
| API10 | Unsafe Consumption | [ ] | | |

## Findings

### [FINDING-001] [Title]
- **Category**: API[N]
- **Severity**: Critical / High / Medium / Low
- **Endpoint**: [METHOD /path]
- **Description**: [What was found]
- **Reproduction**: [Steps to reproduce]
- **Remediation**: [How to fix]

## Protocol-Specific Results

### GraphQL (if applicable)
| Check | Status | Notes |
|-------|--------|-------|
| Introspection disabled | [ ] | |
| Depth limit | [ ] | |
| Complexity limit | [ ] | |

### gRPC (if applicable)
| Check | Status | Notes |
|-------|--------|-------|
| TLS enforced | [ ] | |
| Reflection disabled | [ ] | |
| Auth interceptor | [ ] | |

## Remediation Priority

1. [ ] [Critical findings — fix immediately]
2. [ ] [High findings — fix before release]
3. [ ] [Medium findings — fix in next sprint]
4. [ ] [Low findings — track in backlog]
```

---

## EXIT CHECKLIST

- [ ] API endpoint inventory complete (compare routes vs OpenAPI spec)
- [ ] BOLA tested on every resource endpoint
- [ ] Authentication tested (JWT attacks, brute force, token handling)
- [ ] Property-level authorization tested (mass assignment, excessive data)
- [ ] Rate limiting verified on all tiers (global, per-endpoint, auth)
- [ ] Function-level authorization tested (admin endpoints, HTTP methods)
- [ ] Business logic flows tested (state machine, race conditions)
- [ ] SSRF vectors tested (or deferred to ssrf_testing_harness skill)
- [ ] Bot protection evaluated (CAPTCHA, fingerprinting, rate limits)
- [ ] API inventory validated (no shadow/deprecated endpoints exposed)
- [ ] Third-party API consumption hardened (timeouts, TLS, signatures)
- [ ] GraphQL-specific tests run (if applicable)
- [ ] gRPC-specific tests run (if applicable)
- [ ] Test plan document generated with all findings
- [ ] Remediation plan prioritized and assigned

---

*Skill Version: 1.0 | Created: March 2026 | OWASP API Security Top 10 (2023)*
