---
name: bug_troubleshoot
description: Systematic debugging process for identifying, isolating, and fixing bugs in full-stack TypeScript applications
---

# Bug Troubleshoot Skill

**Purpose**: Turn "it's broken" into a fixed, tested, understood problem. Systematic debugging beats random guessing every time — this skill gives you a repeatable process for any bug.

## 🎯 TRIGGER COMMANDS

```text
"Bug: [description]"
"It's broken"
"Error: [message]"
"Debug this issue"
"Why is [feature] not working?"
"Help me troubleshoot [problem]"
"Using bug_troubleshoot skill"
```

## When to Use

- You encounter an unexpected error, test failure, or broken functionality
- A feature works locally but fails in staging/production
- You need to find when a bug was introduced (git bisect)
- You're dealing with intermittent/flaky bugs
- A stack trace points to code you don't understand

---

## PART 1: THE DEBUGGING MINDSET

**Before touching code, understand the bug.**

```
1. DON'T PANIC — Bugs are normal, not emergencies
2. DON'T GUESS — Hypothesize, then verify
3. DON'T FIX SYMPTOMS — Find root causes
4. READ THE ERROR — The full error message, not just the first line
5. REPRODUCE FIRST — If you can't reproduce it, you can't fix it
```

---

## PART 2: BUG REPORT TEMPLATE

Fill this out BEFORE debugging. It forces you to think clearly.

```markdown
## Bug Report

**Expected**: What should happen?
**Actual**: What IS happening?
**Steps to Reproduce**:
1. Go to [URL]
2. Click [button]
3. Enter [data]
4. Observe [error]

**Environment**: Browser/OS/Node version
**Error Message**: Full stack trace (not just the first line)
**Recent Changes**: What was last deployed or modified?
**Frequency**: Always / Sometimes / Once
**Affected Users**: All / Specific role / Specific tenant
```

---

## PART 3: SYSTEMATIC DEBUGGING STRATEGIES

### Strategy 1: Binary Search (Divide and Conquer)

The fastest way to narrow down a bug in a large codebase.

```
Problem: "The API returns wrong data"

Step 1: Is the data wrong in the database?
  YES → Bug is in data ingestion (writes)
  NO  → Bug is in data retrieval (reads)

Step 2 (if reads): Is the data correct after the Prisma query?
  YES → Bug is in the response transformation
  NO  → Bug is in the Prisma query itself

Step 3 (if query): Is the WHERE clause correct?
  → Add console.log to see the actual query parameters
  → Found: tenantId was undefined because @CurrentUser() wasn't applied
```

### Strategy 2: Printf Debugging (Strategic Logging)

When you can't use a debugger (production, async flows, WebSockets):

```typescript
// Add temporary numbered checkpoints
async processOrder(orderId: string, userId: string) {
  console.log('[DEBUG-1] processOrder called', { orderId, userId });

  const order = await this.prisma.order.findUnique({ where: { id: orderId } });
  console.log('[DEBUG-2] order fetched', { found: !!order, status: order?.status });

  const items = await this.getOrderItems(orderId);
  console.log('[DEBUG-3] items fetched', { count: items.length });

  const total = this.calculateTotal(items);
  console.log('[DEBUG-4] total calculated', { total });

  // ... rest of function
}

// Output reveals: DEBUG-3 shows count: 0 — the items query is wrong
```

**Rules for printf debugging:**
- Number your checkpoints sequentially
- Log the VALUES, not just "reached here"
- Remove ALL debug logs before committing
- Use a prefix like `[DEBUG]` so you can grep for them

### Strategy 3: Rubber Duck Debugging

Explain the problem out loud (or in writing). The act of articulating forces you to think through assumptions.

```
"The user clicks 'Save' and nothing happens.
When they click Save, the form calls handleSubmit...
handleSubmit calls the API with a POST to /api/projects...
Wait — I just changed that endpoint to /api/v2/projects yesterday.
The frontend is still calling v1. That's the bug."
```

### Strategy 4: Minimal Reproduction

Strip away everything until you find the smallest case that reproduces the bug.

```typescript
// Instead of debugging the entire checkout flow:

// 1. Can you reproduce with a simple curl?
// curl -X POST localhost:3000/api/orders -H "Authorization: Bearer $TOKEN" -d '{}'

// 2. Can you reproduce in a unit test?
it('should calculate tax correctly', () => {
  const result = calculateTax(100, 'CA');
  expect(result).toBe(8.25); // Fails! Returns 0
  // Now you know: the bug is in calculateTax, not in the UI or API layer
});
```

---

## PART 4: FRONTEND VS BACKEND ISOLATION

### Step 1: Check the Network Tab

Open Chrome DevTools → Network tab → reproduce the bug.

| What You See | Where the Bug Is |
|-------------|-----------------|
| Request never sent | Frontend (event handler, form, routing) |
| Request sent, 4xx response | Frontend sent bad data OR backend validation |
| Request sent, 5xx response | Backend error (check server logs) |
| Request sent, 200 response, wrong data | Backend returns wrong data |
| Request sent, 200 response, correct data, wrong display | Frontend rendering logic |
| Request hangs (pending) | Backend timeout, deadlock, or missing response |
| CORS error | Backend CORS config or proxy config |

### Step 2: Reproduce with curl

Remove the frontend entirely to isolate backend issues:

```bash
# Get a token
TOKEN=$(curl -s -X POST localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"password"}' | jq -r '.data.accessToken')

# Test the endpoint directly
curl -v localhost:3000/api/projects \
  -H "Authorization: Bearer $TOKEN"
```

If curl works but the frontend doesn't → frontend bug.
If curl also fails → backend bug.

---

## PART 5: GIT BISECT — FIND WHEN IT BROKE

When you know something USED to work but now doesn't:

```bash
# Start bisect
git bisect start

# Mark current commit as bad
git bisect bad

# Mark a known good commit (e.g., last release tag)
git bisect good v1.2.0

# Git checks out a middle commit — test it
# If the bug exists:
git bisect bad
# If the bug doesn't exist:
git bisect good

# Repeat until git identifies the exact commit
# "abc1234 is the first bad commit"

# Done — clean up
git bisect reset
```

**Automate with a test script:**

```bash
# Runs a command at each step — fully automatic
git bisect start HEAD v1.2.0
git bisect run npm test -- --grep "order total"
# Git automatically finds the commit that broke the test
```

---

## PART 6: COMMON BUG PATTERNS

### NestJS Backend Bugs

| # | Pattern | Symptom | Fix |
|---|---------|---------|-----|
| 1 | Missing `@UseGuards(JwtAuthGuard)` | 200 OK but no user context, or 500 error | Add guard to controller |
| 2 | `@CurrentUser()` returns `undefined` | `Cannot read property 'sub' of undefined` | Check guard is applied, check JWT strategy |
| 3 | Prisma `P2002` (Unique constraint) | 500 instead of 409 on duplicate | Catch and throw `ConflictException` |
| 4 | Prisma `P2025` (Record not found) | 500 instead of 404 | Catch and throw `NotFoundException` |
| 5 | Missing module import | `Nest can't resolve dependencies of X` | Add provider to module's `providers` or `imports` |
| 6 | Circular dependency | `A circular dependency has been detected` | Use `forwardRef(() => ModuleName)` |
| 7 | Wrong DTO validation | Request passes but data is wrong | Add `whitelist: true, forbidNonWhitelisted: true` to ValidationPipe |
| 8 | Async without await | Function returns before async work completes | Add `await` to async calls |

### React Frontend Bugs

| # | Pattern | Symptom | Fix |
|---|---------|---------|-----|
| 1 | Stale closure | Event handler uses old state value | Use `useCallback` with correct deps, or functional setState |
| 2 | Missing dependency in useEffect | Effect doesn't re-run when expected | Add missing dep to dependency array |
| 3 | Infinite re-render | Page freezes, console floods | Check for state updates inside render body (not in useEffect) |
| 4 | Uncontrolled to controlled | Warning about switching input types | Initialize state with `''` not `undefined` |
| 5 | Key prop missing | List items re-render incorrectly | Add unique `key` to mapped elements |
| 6 | Race condition in useEffect | Old request overwrites new data | Use cleanup function or abort controller |
| 7 | CORS error | `Access-Control-Allow-Origin` error | Configure backend CORS, or fix proxy |

### Database / Prisma Bugs

| # | Pattern | Symptom | Fix |
|---|---------|---------|-----|
| 1 | N+1 query | Page loads slowly with many DB queries | Use `include` or `select` instead of loop |
| 2 | Missing index | Query takes seconds on large table | Add `@@index([column])` to schema |
| 3 | Schema drift | Prisma types don't match DB | Run `npx prisma db pull` then `npx prisma generate` |
| 4 | Transaction timeout | Bulk operation fails partway | Use `$transaction` with timeout option |

---

## PART 7: PRODUCTION DEBUGGING

When the bug only happens in production:

### 1. Check Logs First

```bash
# If using Docker
docker compose logs --tail=100 backend | grep ERROR

# If using a logging service (Datadog, CloudWatch)
# Filter by: level=ERROR, timestamp=last 1 hour
```

### 2. Compare Environments

```
Production vs Local differences:
- Environment variables (different API keys, URLs)
- Database size (100 rows locally, 1M in prod)
- Network (latency, timeouts, firewalls)
- Node.js version
- OS (Linux in Docker vs macOS locally)
- Concurrent users (1 locally, 1000 in prod)
```

### 3. Feature Flags for Safe Fixes

```typescript
// Don't deploy a risky fix to everyone at once
if (await this.featureFlags.isEnabled('new-order-calculation', userId)) {
  return this.newCalculation(order);
}
return this.legacyCalculation(order);
```

### 4. Reproduce Locally with Production Data Shape

```typescript
// Create a seed script that mimics production data patterns
// Don't copy actual production data — create synthetic data with similar:
// - Volume (same number of rows)
// - Edge cases (null values, unicode, long strings)
// - Relationships (deep nesting, many-to-many)
```

---

## PART 8: LOG ANALYSIS

### Reading NestJS Stack Traces

```
[Nest] ERROR [ExceptionFilter]
TypeError: Cannot read properties of undefined (reading 'id')
    at ProjectService.findOne (/app/src/project/project.service.ts:45:28)
    at ProjectController.getProject (/app/src/project/project.controller.ts:23:31)
    at /app/node_modules/@nestjs/core/router/router-execution-context.js:38:29
```

**How to read it:**
1. **Error type**: `TypeError` — accessing property of undefined
2. **What failed**: Reading `.id` from something that's `undefined`
3. **Where**: `project.service.ts` line 45 — this is YOUR code, start here
4. **Call chain**: Controller (line 23) called Service (line 45)
5. **Framework lines**: Ignore `node_modules` lines — the bug is in YOUR code

### Structured Log Analysis

```typescript
// NestJS Pino setup for structured logs
// In development, look for patterns:

// Find all errors in the last hour
// grep "level\":50" logs.json | tail -20

// Find all slow requests (> 1000ms)
// grep "responseTime" logs.json | jq 'select(.responseTime > 1000)'

// Find all requests for a specific user
// grep "userId\":\"abc123" logs.json
```

### Correlation IDs for Tracing

When a single user action triggers multiple service calls:

```typescript
// Middleware adds correlation ID to every request
@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const correlationId = req.headers['x-request-id'] || randomUUID();
    req['correlationId'] = correlationId;
    res.setHeader('x-request-id', correlationId);
    next();
  }
}

// Then search logs by correlation ID to trace the full request flow
// grep "correlationId\":\"abc-123" logs.json
```

---

## PART 9: ROOT CAUSE ANALYSIS

### The 5 Whys

```
Problem: User's order total is $0

Why 1: The calculateTotal function returned 0
Why 2: The items array was empty
Why 3: The query filtered by tenantId but tenantId was null
Why 4: The @CurrentUser() decorator returned { sub: '...', email: '...' } but no tenantId
Why 5: The JWT payload doesn't include tenantId — it was never added to the token

Root Cause: JWT token creation doesn't include tenantId
Fix: Add tenantId to JWT payload in auth.service.ts
```

### Fishbone Diagram (Ishikawa)

For complex bugs with multiple possible causes:

```
Bug: Dashboard loads slowly (> 5 seconds)

  Code              Database           Network
  ├─ N+1 queries    ├─ Missing index   ├─ Large payload
  ├─ No caching     ├─ Full table scan ├─ No compression
  └─ Sync blocking  └─ Lock contention └─ CDN miss

  Frontend           Infrastructure
  ├─ Re-renders      ├─ CPU throttled
  ├─ Large bundle    ├─ Memory pressure
  └─ No lazy load    └─ Cold start
```

---

## PART 10: FLAKY / INTERMITTENT BUGS

The hardest bugs to fix — they don't reproduce consistently.

### Common Causes

| Cause | Detection | Fix |
|-------|-----------|-----|
| Race condition | Happens under load, not in isolation | Add proper locking, use transactions |
| Timing dependency | Depends on network speed or DB response time | Add proper await/retry, don't depend on timing |
| State pollution | Test passes alone, fails in suite | Clean up state between tests |
| Floating point | `0.1 + 0.2 !== 0.3` | Use integer cents for money, or `toFixed()` |
| Timezone | Works in your timezone, fails in UTC | Always use UTC internally, convert only for display |
| Cache stale | Works after cache clear, breaks after a while | Check TTL, add cache invalidation |

### Debugging Intermittent Issues

```bash
# Run the test 100 times — if it fails even once, it's flaky
for i in $(seq 1 100); do npm test -- --grep "order flow" || echo "FAILED on run $i"; done

# Run with verbose logging to capture the failing state
DEBUG=* npm test -- --grep "order flow" 2>&1 | tee test-output.log
```

---

## PART 11: DEBUGGING TOOLS

### NestJS Debugging with VS Code

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug NestJS",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "start:debug"],
      "console": "integratedTerminal",
      "restart": true,
      "sourceMaps": true
    }
  ]
}
```

### Prisma Query Debugging

```typescript
// Enable query logging to see exact SQL
const prisma = new PrismaClient({
  log: [
    { level: 'query', emit: 'stdout' },
    { level: 'error', emit: 'stdout' },
    { level: 'warn', emit: 'stdout' },
  ],
});

// Output shows exact SQL:
// prisma:query SELECT "public"."User"."id", ... FROM "public"."User" WHERE ...
```

### React DevTools Debugging

```
1. Components tab → Find the component → Check props and state
2. Profiler → Record → Reproduce bug → Check what re-rendered and why
3. Console → Use $r to access the selected component's instance
```

---

---

## Agent Automation

> Use the **build-error-resolver** agent (`.agent/agents/build-error-resolver.md`) for automated build error diagnosis and resolution.
> Invoke via: `/build-fix`

The build-error-resolver agent can:
- Parse build error output
- Identify root causes across the dependency chain
- Apply targeted fixes
- Verify the fix compiles successfully

---

## ✅ Exit Checklist

- [ ] Bug reproduced consistently (or documented as intermittent with pattern)
- [ ] Root cause identified (not just symptoms)
- [ ] Fix implemented at the root cause level
- [ ] Fix verified — reproduction steps no longer trigger the bug
- [ ] Regression test written to prevent recurrence
- [ ] Debug logs removed before committing
- [ ] Related bugs checked (same pattern elsewhere?)
- [ ] Bug report updated with resolution
