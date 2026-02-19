# Full-Stack Developer Foundation — The WHY Behind Everything

> **Read this first.** Every other doc in this framework tells you HOW. This one tells you WHY. Understanding WHY decisions are made is what separates a developer from someone who copies code.

---

## How to Use This Document

Each section follows the same structure:
1. **Why It Matters** — The core reasoning
2. **Key Concepts** — What you need to understand
3. **In Practice** — How it applies to NestJS + React
4. **Common Mistakes** — What beginners get wrong and why
5. **Terms You'll Hear** — Vocabulary for meetings and code reviews

---

## 1. The Full Stack

### Why It Matters

A "full-stack" application has layers, and each layer has a job. When you understand why layers exist, you stop putting database queries in React components and SQL in API routes.

**The fundamental principle**: Separation of Concerns. Each layer handles one responsibility so that changes in one layer don't break another.

### Key Concepts

**The Layers**:
```
┌─────────────────────────────────┐
│  Frontend (React + TypeScript)  │  What the user sees and interacts with
├─────────────────────────────────┤
│  API Layer (NestJS Controllers) │  HTTP interface — routes, validation
├─────────────────────────────────┤
│  Business Logic (NestJS Services)│  Rules, calculations, decisions
├─────────────────────────────────┤
│  Data Layer (Prisma ORM)        │  Database queries, data shaping
├─────────────────────────────────┤
│  Database (PostgreSQL)          │  Persistent storage
├─────────────────────────────────┤
│  Infrastructure (Docker, CI/CD) │  Where and how it all runs
└─────────────────────────────────┘
```

**The Request Lifecycle** (what happens when a user clicks a button):
```
User clicks "Save" in React
  → React calls fetch('/api/users', { method: 'POST', body: JSON })
    → Browser sends HTTP request over the network
      → DNS resolves your-api.com to an IP address
        → Load balancer routes to a server
          → NestJS middleware runs (logging, CORS)
            → Guard checks JWT token (authenticated?)
              → Pipe validates the request body
                → Controller receives the request
                  → Service executes business logic
                    → Prisma sends SQL to PostgreSQL
                    ← PostgreSQL returns rows
                  ← Prisma maps rows to TypeScript objects
                ← Service returns data
              ← Controller sends HTTP response
            ← Interceptor transforms response format
          ← Response travels back over network
        ← React receives JSON response
      ← React updates state → UI re-renders
    ← User sees "Saved!" toast notification
```

### In Practice

Why you don't put SQL in React:
- Frontend code is **public** — anyone can view it in browser DevTools
- Database credentials would be exposed
- Business rules would be bypassable (users could modify client-side validation)
- You'd have no central place to enforce authorization

Why you don't put UI logic in NestJS:
- Backend doesn't know about screen sizes, animations, or user interactions
- Coupling HTML to your API makes both impossible to change independently
- Different clients (web, mobile, CLI) need different UIs but the same API

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Calling the database directly from React | Security: exposes credentials, bypasses auth | Always go through your API |
| Putting business rules in the controller | Controllers should only handle HTTP concerns | Put logic in services |
| One giant file for everything | Impossible to test, review, or maintain | One file, one responsibility |
| "Full stack means I know everything" | Nobody knows everything — it means you understand how layers connect | Focus on depth in 1-2 layers, breadth across all |

### Terms You'll Hear

- **Frontend / Client-side**: Code that runs in the browser
- **Backend / Server-side**: Code that runs on the server
- **API**: The contract between frontend and backend
- **Middleware**: Code that runs between the request and your handler
- **ORM**: Object-Relational Mapper — translates between code objects and database rows (Prisma)
- **SPA**: Single Page Application — one HTML file, JavaScript handles navigation (React)
- **SSR/SSG**: Server-Side Rendering / Static Site Generation (Next.js)

---

## 2. Version Control / Git

### Why It Matters

Without version control, you have one copy of your code. If it breaks, you lose everything. If two people edit the same file, someone's work gets overwritten. If you want to undo a change from three weeks ago, you can't.

Git solves all of these problems. It is not optional — every professional software team uses it.

### Key Concepts

**Why commits matter**: Each commit is a snapshot of your entire project. Small, descriptive commits let you:
- Find exactly when a bug was introduced (`git bisect`)
- Understand why a change was made (commit message)
- Undo one specific change without losing others (`git revert`)

**Why branches exist**: Branches let multiple people work on different features simultaneously without stepping on each other. The `main` branch is always deployable. Feature branches are where you experiment safely.

**Why code review exists**: Pull Requests are not about catching mistakes (though they do). They're about:
- Knowledge sharing (someone else learns your part of the codebase)
- Collective ownership (no one person is the only expert)
- Consistency (team conventions are maintained)

**Why merge conflicts happen**: Two people changed the same lines. Git can't decide which change wins, so it asks you. This is a feature, not a bug.

### In Practice

```bash
# The daily workflow
git checkout -b feature/JIRA-123-add-user-dashboard  # Create branch from main
# ... write code, make commits ...
git add src/dashboard/                                 # Stage specific files
git commit -m "feat(dashboard): add usage chart component"  # Descriptive commit
git push -u origin feature/JIRA-123-add-user-dashboard     # Push to remote
# → Open Pull Request → Get reviewed → Merge to main
```

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| `git add .` blindly | May commit .env files, secrets, or debug code | `git add` specific files, check `git diff --staged` |
| "WIP" or "fix" as commit messages | Useless history — nobody knows what changed or why | Use Conventional Commits: `feat:`, `fix:`, `refactor:` |
| Working directly on main | One bad commit breaks everyone | Always use feature branches |
| Force pushing to shared branches | Overwrites other people's commits | Only force-push your own branches |
| Giant PRs (1000+ lines) | Impossible to review properly | Keep PRs under 400 lines when possible |

### Terms You'll Hear

- **PR / MR**: Pull Request (GitHub) / Merge Request (GitLab) — request to merge your branch
- **Rebase**: Replay your commits on top of the latest main (cleaner history)
- **Cherry-pick**: Copy one specific commit to another branch
- **Stash**: Temporarily save uncommitted changes
- **HEAD**: The commit you're currently on
- **Origin**: The remote repository (usually GitHub)
- **Upstream**: The original repository you forked from

---

## 3. HTTP & APIs

### Why It Matters

Every interaction between your React frontend and NestJS backend happens over HTTP. Every third-party service you integrate (Stripe, AWS, OpenAI) communicates over HTTP. Understanding HTTP is understanding how the internet works.

### Key Concepts

**Why REST conventions exist**: If every API invented its own rules, every integration would require reading a manual. REST gives us predictable conventions:
- `GET /users` — list users (always safe, never modifies data)
- `POST /users` — create a user (not safe, creates something)
- `GET /users/123` — get one user
- `PUT /users/123` — replace user 123 entirely
- `PATCH /users/123` — update some fields of user 123
- `DELETE /users/123` — remove user 123

**Why status codes matter**: Clients (React, mobile apps, other services) make decisions based on status codes:
- `200` → Show the data
- `201` → Show "Created successfully!"
- `400` → Show validation errors to the user
- `401` → Redirect to login page
- `403` → Show "You don't have permission"
- `404` → Show "Not found" page
- `429` → Back off, you're sending too many requests
- `500` → Show "Something went wrong, try again"

**Why CORS exists**: Browsers block requests from one origin (your-site.com) to another (your-api.com) by default. This prevents malicious sites from making requests with your cookies. CORS headers explicitly allow specific origins.

### In Practice (NestJS)

```typescript
// Controller — HTTP concerns ONLY
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  @Get()
  async findAll(@Query() query: PaginationDto) {
    // 200 OK is automatic for successful responses
    return this.usersService.findAll(query);
  }

  @Post()
  async create(@Body() dto: CreateUserDto) {
    // Validation failures automatically return 400
    return this.usersService.create(dto);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    // Service throws NotFoundException → 404 automatically
    return this.usersService.findOne(id);
  }
}
```

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Using POST for everything | Breaks caching, confuses API consumers, violates REST | Use the right HTTP method |
| Returning 200 with `{ error: true }` | Clients can't distinguish success from failure by status code | Return proper 4xx/5xx codes |
| Ignoring CORS in development | Works in dev, breaks in production | Configure CORS properly from day one |
| Putting verbs in URLs (`/getUsers`) | Redundant — the HTTP method IS the verb | Use nouns: `GET /users` |

### Terms You'll Hear

- **Endpoint**: A specific URL + method combination (e.g., `GET /api/users`)
- **Payload / Body**: The data sent with a POST/PUT/PATCH request
- **Headers**: Metadata about the request (Authorization, Content-Type)
- **Idempotent**: Making the same request multiple times has the same effect (GET, PUT, DELETE are idempotent; POST is not)
- **Rate limiting**: Restricting how many requests a client can make per time period
- **Webhook**: An API calling YOUR API when something happens (Stripe notifying you of a payment)

---

## 4. TypeScript / Type Safety

### Why It Matters

JavaScript lets you pass anything anywhere. You can call `user.name` on `undefined`, pass a string where a number is expected, or misspell a property name — and you won't know until a user hits the bug in production.

TypeScript catches these bugs at compile time (before your code ever runs). It's the difference between finding a bug in your editor vs. finding it in a production error log at 3 AM.

### Key Concepts

**Why strict mode matters**: TypeScript's `strict: true` enables all strict checks. Without it, TypeScript is just JavaScript with extra steps that don't actually protect you.

```json
// tsconfig.json — non-negotiable settings
{
  "compilerOptions": {
    "strict": true,           // Enable ALL strict checks
    "noUncheckedIndexedAccess": true,  // array[0] might be undefined
    "noImplicitReturns": true          // Every code path must return
  }
}
```

**Why `any` is dangerous**: `any` turns off type checking. Once you use `any`, all downstream code also loses type safety. It's a virus that spreads through your codebase.

```typescript
// BAD — any disables all checks
function processUser(user: any) {
  return user.nmae; // Typo! No error. Bug in production.
}

// GOOD — types catch mistakes instantly
function processUser(user: { name: string; email: string }) {
  return user.nmae; // TS Error: Property 'nmae' does not exist. Did you mean 'name'?
}
```

**Why interfaces exist for data shapes**: Classes create runtime objects. Interfaces only exist at compile time (zero runtime cost). For data that comes from APIs or databases, interfaces are perfect.

```typescript
// For data shapes (API responses, DTOs) — use interfaces
interface User {
  id: string;
  name: string;
  email: string;
}

// For things with behavior (services, strategies) — use classes
class UserService {
  async findOne(id: string): Promise<User> { ... }
}
```

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Using `any` to silence errors | Defeats the purpose of TypeScript | Use `unknown` + type narrowing |
| Not using strict mode | Half the bugs TypeScript catches are missed | Always `"strict": true` |
| Typing everything manually | Unnecessary work, types get out of sync | Let TypeScript infer when it can |
| Ignoring type errors with `// @ts-ignore` | Hiding bugs, not fixing them | Fix the underlying type issue |
| Using `as` everywhere (type assertions) | You're telling the compiler "trust me" — and you might be wrong | Use type guards instead |

### Terms You'll Hear

- **Type inference**: TypeScript figures out the type automatically (`const x = 5` → x is `number`)
- **Generics**: Types that work with any type (`Array<T>`, `Promise<T>`)
- **Union type**: `string | number` — can be either
- **Intersection type**: `A & B` — must be both
- **Type guard**: A runtime check that narrows a type (`if (typeof x === 'string')`)
- **DTO**: Data Transfer Object — the shape of data coming into your API
- **Discriminated union**: A union where each member has a `type` field to distinguish them

---

## 5. Architecture & Design Patterns

### Why It Matters

On a small project, architecture doesn't matter — everything works. On a large project (or any project that lives longer than a few months), bad architecture means:
- Changing one thing breaks five other things
- New features take 10x longer because you're fighting the code
- Testing is impossible because everything is coupled
- New team members can't understand the codebase

Architecture is about making your codebase easy to change. Because requirements ALWAYS change.

### Key Concepts

**Why SOLID matters**:
- **S**ingle Responsibility: One service does one thing. When it changes, it changes for one reason. A `UserService` doesn't also send emails — that's `EmailService`'s job.
- **O**pen/Closed: Add new behavior by adding new code, not modifying existing code. Use interfaces and strategies.
- **L**iskov Substitution: If your code works with a `PaymentProvider` interface, it should work with ANY implementation (Stripe, PayPal, Square).
- **I**nterface Segregation: Don't force a class to implement methods it doesn't need. Many small interfaces > one big interface.
- **D**ependency Inversion: Depend on abstractions (interfaces), not concretions (classes). This is why NestJS has dependency injection.

**Why Dependency Injection exists**: Without DI, classes create their own dependencies:
```typescript
// WITHOUT DI — tightly coupled, untestable
class UserService {
  private db = new PrismaClient(); // Can't swap this in tests!
  private mailer = new SendGridClient(); // Tests would send real emails!
}

// WITH DI (NestJS) — loosely coupled, testable
@Injectable()
class UserService {
  constructor(
    private prisma: PrismaService,  // NestJS injects this
    private mailer: MailService,    // Can inject a mock in tests
  ) {}
}
```

**Why patterns exist**: Design patterns are named solutions to recurring problems. When you say "this uses the Strategy pattern," everyone on the team immediately understands the structure.

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| God Service (one service does everything) | Impossible to test, change, or understand | Split by domain responsibility |
| Using patterns for the sake of using patterns | Over-engineering makes code harder to understand | Only use a pattern when you have the problem it solves |
| Skipping interfaces | Can't swap implementations, can't mock for tests | Define interfaces for external dependencies |
| Circular dependencies | A depends on B depends on A — breaks at runtime | Restructure or use events |

### Terms You'll Hear

- **DI (Dependency Injection)**: Framework provides dependencies to your class instead of you creating them
- **IoC (Inversion of Control)**: The framework calls your code, not the other way around
- **Coupling**: How much two modules depend on each other (low coupling is good)
- **Cohesion**: How related the things inside a module are (high cohesion is good)
- **Abstraction**: Hiding complex details behind a simple interface
- **Clean Architecture**: Organizing code in layers where inner layers don't know about outer layers

---

## 6. Testing

### Why It Matters

Tests are not about proving code works. Tests are about **confidence to change code**. Without tests:
- Every change might break something you can't see
- Refactoring is gambling — you won't know what broke until users report it
- Onboarding new developers is terrifying — they can't tell if their changes broke something

### Key Concepts

**The Testing Pyramid**:
```
        /  E2E  \        Few: slow, expensive, test full user flows
       / Integra- \      Some: test module interactions, API endpoints
      /   tion     \
     /    Unit      \    Many: fast, cheap, test individual functions
    /________________\
```

- **Unit tests** (many): Test one function or service in isolation. Mock all dependencies. Should run in milliseconds. (~70% of tests)
- **Integration tests** (some): Test multiple modules working together. Use real database. Test API endpoints. (~20% of tests)
- **E2E tests** (few): Test complete user flows in a real browser. Slowest but most realistic. (~10% of tests)

**Why mocking exists**: Unit tests need to test ONE thing in isolation. If your `UserService.create()` calls `PrismaService`, `EmailService`, and `CacheService`, you mock those dependencies so you're only testing the logic inside `UserService`.

**Why 100% coverage is a lie**: Coverage measures which lines executed during tests, not whether the tests are meaningful. You can have 100% coverage with tests that assert nothing. Focus on testing behavior, not reaching a number.

**Why flaky tests are worse than no tests**: A test that sometimes passes and sometimes fails teaches your team to ignore test failures. "Oh that test is flaky, just re-run CI." Eventually you ignore a REAL failure because you assumed it was flaky.

### In Practice

```typescript
// Unit test: fast, isolated, mocked dependencies
describe('UserService', () => {
  it('should throw NotFoundException when user does not exist', async () => {
    prisma.user.findUnique.mockResolvedValue(null); // Mock: no user found
    await expect(service.findOne('nonexistent-id')).rejects.toThrow(NotFoundException);
  });
});

// Integration test: real HTTP request, real database
describe('GET /api/users/:id', () => {
  it('should return 404 for nonexistent user', () => {
    return request(app.getHttpServer())
      .get('/api/users/nonexistent-id')
      .expect(404);
  });
});
```

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| No tests at all | No confidence to change anything | Start with critical paths: auth, payments |
| Testing implementation details | Tests break when you refactor even if behavior is unchanged | Test inputs → outputs, not internal methods |
| Huge test setup (100+ lines before the actual test) | Tests are unreadable, hard to maintain | Use factories and helpers |
| Not testing error paths | Happy path works, error handling doesn't | Test what happens when things fail |

### Terms You'll Hear

- **AAA Pattern**: Arrange (setup), Act (execute), Assert (verify)
- **Mock**: A fake object that replaces a real dependency
- **Stub**: A simplified version of a function that returns predetermined data
- **Fixture**: Reusable test data
- **Coverage**: Percentage of code lines executed by tests
- **Regression**: A bug introduced by a change (tests prevent regressions)
- **TDD**: Test-Driven Development — write the test first, then the code

---

## 7. Security

### Why It Matters

Security is everyone's job. A single vulnerability can expose user data, result in lawsuits, destroy trust, and kill a company. You don't need to be a security expert, but you need to understand the basics.

The core principle: **Never trust input from outside your trust boundary.** User input, API responses, URL parameters, cookies — all of it can be manipulated.

### Key Concepts

**Auth ≠ Authz**:
- **Authentication (AuthN)**: WHO are you? (Login, JWT, "prove your identity")
- **Authorization (AuthZ)**: WHAT can you do? (Roles, permissions, "are you allowed to do this?")

Both are required. Authentication without authorization means any logged-in user can access anything.

**Why you never trust client input**:
```typescript
// BAD — trusting the client
@Post('transfer')
async transfer(@Body() dto: { amount: number; fromAccount: string }) {
  // What if the user sends fromAccount: "someone-elses-account"?
  await this.bankService.transfer(dto.fromAccount, dto.amount);
}

// GOOD — use the authenticated user's data
@Post('transfer')
async transfer(@CurrentUser() user, @Body() dto: { amount: number }) {
  // Always use the server-side user identity
  await this.bankService.transfer(user.sub, dto.amount);
}
```

**Why secrets in code is catastrophic**: If you commit an API key to Git:
- It's in the Git history forever (even after you delete the file)
- Anyone with repo access has the key
- If the repo is public, the entire internet has the key
- Bots actively scan GitHub for leaked credentials (and exploit them within minutes)

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Storing JWT secret in code | Anyone with repo access can forge tokens | Use environment variables |
| Not validating input server-side | Client-side validation is bypassable | Use class-validator + ValidationPipe |
| Trusting user-supplied IDs without access checks | User A can access User B's data | Always verify ownership server-side |
| Storing passwords in plaintext | Database breach = all passwords leaked | bcrypt with 12+ rounds |
| Using `*` for CORS origins | Any website can make requests to your API | Whitelist specific origins |

### Terms You'll Hear

- **OWASP**: Open Web Application Security Project — the standard for web security
- **JWT**: JSON Web Token — a signed token that contains user identity claims
- **XSS**: Cross-Site Scripting — injecting malicious scripts into web pages
- **CSRF**: Cross-Site Request Forgery — tricking a user's browser into making unwanted requests
- **SQL Injection**: Inserting SQL code through user input (Prisma prevents this)
- **RBAC**: Role-Based Access Control — permissions based on user roles
- **Zero trust**: Never assume a request is legitimate, always verify

---

## 8. DevOps & CI/CD

### Why It Matters

Without automation:
- Developer A deploys differently than Developer B → production breaks
- Tests are "optional" → bugs reach production
- Deployments are scary → teams deploy rarely → deployments are huge → more risk → more scary (death spiral)

CI/CD automates the build-test-deploy pipeline. When it works, deploying to production is boring. Boring deployments are good deployments.

### Key Concepts

**Why environments exist**:
- **Development**: Your local machine. Break whatever you want.
- **Staging**: A clone of production. Test with real-ish data. Catch environment-specific bugs.
- **Production**: Real users, real data. Changes here have consequences.

Each environment should be as similar as possible. Docker makes this achievable.

**Why containers exist**: "Works on my machine" happens because your machine has different versions of Node, PostgreSQL, etc. Docker packages your app AND its dependencies into a container that runs identically everywhere.

**CI (Continuous Integration)**: Every push to a branch automatically:
1. Installs dependencies
2. Runs linter
3. Runs all tests
4. Builds the application
5. Reports back (pass/fail)

**CD (Continuous Deployment)**: After CI passes on main, automatically deploy to production. No manual steps. No "deployment Friday."

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| "I'll test it in production" | Users are not your QA team | Test in staging first |
| No CI pipeline | Broken code merges without anyone knowing | Set up GitHub Actions from day one |
| Different Node versions locally vs. CI | "Works on my machine" but fails in CI | Use `.nvmrc` + Docker |
| Manual deployments | Human error, inconsistency, no audit trail | Automate with CI/CD |

### Terms You'll Hear

- **Pipeline**: The automated sequence of build/test/deploy steps
- **Artifact**: The output of a build (Docker image, compiled files)
- **Rolling deployment**: Replace old containers one at a time (zero downtime)
- **Canary deployment**: Send 5% of traffic to the new version, monitor, then increase
- **Rollback**: Revert to the previous version when something goes wrong
- **Infrastructure as Code (IaC)**: Define servers and infrastructure in version-controlled files

---

## 9. Code Quality

### Why It Matters

Code is read 10x more than it's written. Clever code that only you understand is a liability. Clear code that a new hire can understand is an asset.

### Key Concepts

**Why code reviews exist**: Not to catch bugs (that's what tests are for). Code reviews exist for:
1. Knowledge sharing — two people now understand the code
2. Consistency — team conventions are maintained
3. Mentoring — juniors learn from seniors (and vice versa)
4. Design improvement — a second perspective catches over-engineering or missed cases

**Why readability > cleverness**:
```typescript
// CLEVER but unreadable
const r = u.filter(x => x.a && !x.d).reduce((a, c) => a + c.v, 0);

// CLEAR and readable
const activeUsers = users.filter(user => user.isActive && !user.isDeleted);
const totalValue = activeUsers.reduce((sum, user) => sum + user.accountValue, 0);
```

**Why naming matters more than comments**:
```typescript
// BAD — name is meaningless, comment is a crutch
const d = 7; // days until expiry

// GOOD — name is self-documenting
const daysUntilExpiry = 7;
```

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Inconsistent formatting | Distracting, causes unnecessary merge conflicts | Use Prettier (auto-format) |
| "I'll clean it up later" | Later never comes | Write clean code the first time |
| Over-commenting obvious code | Clutter, comments go stale | Only comment WHY, not WHAT |
| Premature optimization | Makes code complex for imaginary performance gains | Profile first, then optimize the bottleneck |

### Terms You'll Hear

- **Linting**: Automated code style and quality checking (ESLint)
- **Formatting**: Automated code style enforcement (Prettier)
- **Tech debt**: Shortcuts taken now that will cost time later
- **Refactoring**: Improving code structure without changing behavior
- **Code smell**: A surface indication of a deeper problem (e.g., 500-line function)
- **DRY**: Don't Repeat Yourself (but don't over-abstract either)
- **YAGNI**: You Aren't Gonna Need It — don't build for hypothetical future requirements

---

## 10. Documentation

### Why It Matters

Documentation is part of the product. If nobody can understand how to use, deploy, or maintain your code, the code has no value.

The most important documentation is the README. It's the first thing anyone sees. If it says "TODO: add instructions," you've already lost.

### Key Concepts

**Why comments explain WHY, not WHAT**:
```typescript
// BAD — explains WHAT (the code already says this)
// Increment counter by 1
counter++;

// GOOD — explains WHY (the code can't tell you this)
// Compensate for the off-by-one error in the legacy import format
counter++;
```

**Why ADRs (Architecture Decision Records) exist**: Six months from now, someone will ask "Why did we choose PostgreSQL instead of MongoDB?" Without an ADR, the answer is lost. An ADR captures the decision, the context, the alternatives considered, and the rationale.

**Why outdated docs are worse than no docs**: Outdated documentation actively misleads. A developer follows incorrect instructions, wastes hours, then loses trust in all documentation. Keep docs accurate or delete them.

### Terms You'll Hear

- **README**: The first file anyone reads. Setup instructions, architecture overview
- **ADR**: Architecture Decision Record — why a technical decision was made
- **SOP**: Standard Operating Procedure — step-by-step instructions for a process
- **API docs**: Machine-readable documentation (Swagger/OpenAPI) for API consumers
- **Runbook**: Step-by-step instructions for handling an incident
- **Changelog**: Record of what changed in each version

---

## 11. Observability & Monitoring

### Why It Matters

In production, you can't `console.log` and watch the terminal. You can't reproduce bugs locally because they depend on production data, load, and timing. Observability is how you understand what your system is doing without being able to attach a debugger.

The three pillars: **Logs** (what happened), **Metrics** (how much/how fast), **Traces** (the path through your system).

### Key Concepts

**Why structured logging > console.log**:
```typescript
// BAD — unstructured, unsearchable, unparseable
console.log('User created: ' + user.email);

// GOOD — structured JSON, searchable, parseable
logger.info({ userId: user.id, email: user.email }, 'User created');
// Output: {"level":"info","userId":"abc-123","email":"user@example.com","msg":"User created","time":"2026-02-13T..."}
```

**Why correlation IDs exist**: When a user reports "I got an error," you need to find their specific request in potentially millions of log lines. A correlation ID (a unique UUID per request) tags every log line for that request, so you can filter and see the complete story.

**Why alerting matters**: Metrics are useless if nobody looks at them. Alerts notify your team when something is wrong BEFORE users notice. Good alerts are actionable (tell you what to do) and not noisy (don't fire for non-issues).

### Terms You'll Hear

- **APM**: Application Performance Monitoring (Sentry, Datadog, New Relic)
- **P95/P99 latency**: 95th/99th percentile response time — "95% of requests finish in X ms"
- **Error rate**: Percentage of requests that return errors
- **Uptime**: Percentage of time the service is available (99.9% = 8.7 hours downtime/year)
- **Dashboard**: Visual display of system health metrics (Grafana)
- **SLI/SLO/SLA**: Service Level Indicator/Objective/Agreement — how you measure and promise reliability

---

## 12. Performance

### Why It Matters

Speed is a feature. A 1-second delay in page load reduces conversions by 7%. Users leave if your app feels slow. Performance directly impacts revenue.

But: **measure first, optimize second**. Premature optimization wastes time on things that don't matter. Profile your app, find the actual bottleneck, and fix that.

### Key Concepts

**Why N+1 queries are deadly**:
```typescript
// N+1 PROBLEM — 1 query for users + N queries for projects
const users = await prisma.user.findMany(); // 1 query
for (const user of users) {
  const projects = await prisma.project.findMany({ where: { userId: user.id } }); // N queries
}

// SOLUTION — 1 query total with include
const users = await prisma.user.findMany({
  include: { projects: true }, // Prisma does a JOIN or batch query
});
```

**Why caching is powerful but dangerous**: Caching makes things fast by avoiding repeated computation. But stale caches serve outdated data. Cache invalidation is one of the hardest problems in computer science. Start without caching, add it when you have a measured performance problem.

**Why pagination exists**: You can't send 100,000 rows to a browser. It would crash the browser, take forever to download, and overload your database. Pagination sends manageable chunks (20-50 items at a time).

**Why bundle size matters (frontend)**: Every kilobyte of JavaScript must be downloaded, parsed, and executed before users see your app. A 2MB bundle takes seconds on slow connections. Tree-shaking, code splitting, and lazy loading keep bundles small.

### Terms You'll Hear

- **Lazy loading**: Loading code/data only when needed
- **Code splitting**: Breaking your JavaScript bundle into smaller chunks
- **CDN**: Content Delivery Network — serves static files from the server closest to the user
- **Connection pooling**: Reusing database connections instead of creating new ones for each query
- **Indexing**: Creating a data structure that makes database lookups fast (like a book index)
- **Profiling**: Measuring where your code spends its time

---

## 13. Database Management

### Why It Matters

Your database schema IS your application's architecture. Everything else is code that reads from and writes to this schema. Get the schema wrong and everything built on top of it will be painful.

### Key Concepts

**Why migrations exist**: They're version control for your database schema. Without migrations, you'd need to manually run SQL on every developer's machine and every server. With migrations, schema changes are code that runs automatically.

**Why indexes matter**: Without an index, finding one user in a million requires scanning every single row (O(n)). With an index, it's a tree lookup (O(log n)). The difference is milliseconds vs. seconds.

**Why normalization exists**: Normalization prevents data duplication. If a user's name is stored in 5 tables and they change their name, you'd need to update all 5 tables. With normalization, the name is stored once and referenced by ID.

**When to denormalize**: Sometimes performance requires duplication. If you always display a user's name alongside their comments, joining the user table every time is slow. Store the name on the comment too (but update it when the name changes).

**Why transactions exist**: Some operations must succeed or fail together. If a bank transfer debits account A but the credit to account B fails, you need to undo the debit. Transactions guarantee all-or-nothing.

### Terms You'll Hear

- **Migration**: A versioned change to the database schema
- **Seed data**: Test/initial data loaded into the database
- **Foreign key**: A reference from one table's column to another table's primary key
- **Join**: Combining data from multiple tables in one query
- **Deadlock**: Two queries waiting for each other forever (transaction conflict)
- **Connection pool**: A set of reusable database connections
- **VACUUM**: PostgreSQL's garbage collection (reclaims space from deleted rows)

---

## 14. State Management

### Why It Matters

The fundamental equation of UI: **UI = f(state)**. Your interface is a function of your data. When state is messy, your UI is buggy. When state is clear and predictable, your UI just works.

### Key Concepts

**5 types of state** (treat them differently):

| Type | What It Is | Example | Tool |
|------|-----------|---------|------|
| Server state | Data from your API | User list, project details | React Query / TanStack Query |
| URL state | Current page and filters | `/users?page=2&role=admin` | useSearchParams, react-router |
| Local state | Component-specific | Form input value, modal open | useState |
| Global client state | App-wide UI state | Theme, sidebar collapsed | Zustand / Context |
| Ephemeral state | Temporary, not persisted | Hover state, scroll position | CSS / useRef |

**Why server state ≠ client state**: Data from your API (users, projects) is owned by the server. Your React app just has a cached copy. React Query manages this cache — refetching when stale, deduplicating requests, handling loading/error states.

**Why cache invalidation is hard**: After creating a new user, the user list cache is stale. Do you refetch the entire list? Add the new user to the cache manually? What if another user was added by someone else in the meantime? React Query's `invalidateQueries` handles this elegantly.

### Terms You'll Hear

- **Stale data**: Cached data that may no longer match the server
- **Optimistic update**: Update the UI immediately, then send the API request (undo if it fails)
- **Cache invalidation**: Marking cached data as stale so it gets refetched
- **Global state**: Data accessible by any component (use sparingly)
- **Derived state**: Computed from other state (don't store it — compute it)

---

## 15. Auth & Authorization

### Why It Matters

Auth is the most critical feature in any application. Get it wrong and strangers access your users' data. Get it really wrong and it makes the news.

### Key Concepts

**Why JWTs work the way they do**: A JWT is a signed token that contains claims (user ID, email, role). The server signs it with a secret. When the client sends it back, the server verifies the signature without hitting the database. This makes JWTs fast and stateless.

The trade-off: you can't invalidate a JWT (unless you track a blacklist). That's why access tokens are short-lived (15 minutes) and refresh tokens exist to get new ones.

**Why refresh tokens exist**: Access tokens expire quickly (security). But you don't want users logging in every 15 minutes (UX). Refresh tokens are long-lived tokens stored securely that can request new access tokens. When a refresh token is used, it should be rotated (old one invalidated, new one issued) for security.

**Why RBAC exists**: Not every user should have the same permissions. An admin can delete users. A regular user can only view their own data. RBAC maps users to roles, and roles to permissions.

**Why OAuth exists**: Instead of every app implementing its own login system (and storing passwords), OAuth lets users log in with Google, GitHub, etc. The provider handles password security, MFA, and account recovery.

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Storing tokens in localStorage | XSS attacks can steal them | Use httpOnly cookies (or be very careful with localStorage) |
| No refresh token rotation | Stolen refresh token = permanent access | Rotate on every use |
| Checking roles only on the frontend | User can bypass by calling the API directly | Always enforce on the backend |
| Same error for "user not found" and "wrong password" | Attackers can enumerate valid emails | Generic: "Invalid credentials" |

### Terms You'll Hear

- **JWT**: JSON Web Token — a self-contained, signed token
- **OAuth 2.0**: Authorization framework for third-party access
- **OIDC**: OpenID Connect — authentication layer on top of OAuth
- **SSO**: Single Sign-On — one login for multiple applications
- **MFA/2FA**: Multi-Factor/Two-Factor Authentication
- **TOTP**: Time-based One-Time Password (authenticator app codes)
- **Bearer token**: A token sent in the `Authorization: Bearer <token>` header

---

## 16. Team Collaboration

### Why It Matters

Software is a team sport. A brilliant developer who can't communicate, can't estimate, and can't work with others is less valuable than a good developer who can do all three.

Communication is a technical skill. Learn it like you'd learn a framework.

### Key Concepts

**Why standups exist**: Not to report to a manager. Standups exist to:
1. Identify blockers early ("I'm stuck on X" → someone helps)
2. Avoid duplicate work ("I'm about to refactor the auth module" → "Wait, I'm also working on that")
3. Stay aligned as a team

**Why estimation is hard but necessary**: Humans are terrible at estimating. But stakeholders need to plan. The solution: estimate in relative sizes (story points), not hours. Track velocity (how many points you complete per sprint) and use that for forecasting.

**Why asking questions early saves time**: If you're stuck for 30 minutes, ask. If you've been stuck for 2 hours, you've wasted 1.5 hours. Nobody expects you to know everything. They expect you to unblock yourself quickly — and asking is the fastest way.

**Why "it works on my machine" is never acceptable**: If it doesn't work in CI/staging/production, it doesn't work. Your local environment is not the standard. The pipeline is.

### Common Mistakes

| Mistake | Why It's Wrong | What to Do Instead |
|---------|---------------|-------------------|
| Suffering in silence for hours | Wasted time, missed deadlines | Ask for help after 30-60 minutes of being stuck |
| Saying "it's easy" to estimates | Creates unrealistic expectations | Say "I need to investigate before I can estimate" |
| Not updating your team when blocked | They can't help if they don't know | Communicate blockers immediately |
| Skipping standup | Team loses visibility into your work | Participate, keep it brief (30-90 seconds) |

### Terms You'll Hear

- **Sprint**: A fixed time period (usually 2 weeks) for completing a set of work
- **Standup**: Brief daily meeting (yesterday/today/blockers)
- **Retro (Retrospective)**: End-of-sprint reflection (what went well, what didn't)
- **Story points**: Relative estimate of effort (not time)
- **Velocity**: How many story points the team completes per sprint
- **RFC**: Request for Comments — a document proposing a technical decision for team input
- **Blocker**: Something preventing you from making progress
- **Pair programming**: Two developers working on one computer (one types, one reviews)

---

## Day One Survival Guide

When you walk in on Monday:

1. **Clone the repo, read the README, get the dev environment running.** If you can't, that's your first question — not a failure.

2. **Read the last 5 pull requests.** This tells you the team's code style, review expectations, and what they're working on.

3. **Find these files**: `main.ts` (entry point), `app.module.ts` (everything registered here), `schema.prisma` (data model), router config (all pages), `.github/workflows/` (CI/CD).

4. **Trace one request end-to-end.** Pick a simple GET endpoint and follow it from React component → API call → Controller → Service → Prisma → Database and back. This teaches you more than any doc.

5. **Ask questions.** "Where is X?" "Why does this do Y?" "What's the convention for Z?" — these are not stupid questions. They're how you get productive faster.

6. **Your first PR should be small.** Fix a typo, update a dependency, add a test. The goal is to learn the PR process, not to impress with a huge feature.

7. **You will feel lost. That's normal.** Every developer feels lost on a new codebase. The feeling goes away in 2-4 weeks. Focus on learning, not on looking like you know everything.

> **Key Takeaway**: You have 1,000+ hours of building things. That's real experience. What you're adding now is the WHY behind what you already know HOW to do. The skills transfer — you just need context.

---

*Foundation Document v1.0 | Created: February 13, 2026*
