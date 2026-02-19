---
name: codebase_navigation
description: Systematic approach to understanding and navigating an unfamiliar codebase
---

# Codebase Navigation Skill

**Purpose**: Provides a structured process for ramping up on any codebase quickly — whether joining a new team, onboarding to a project, or inheriting legacy code. Eliminates the "where do I even start?" paralysis.

## 🎯 TRIGGER COMMANDS

```text
"I just joined a project, where do I start?"
"Help me understand this codebase"
"Map out this project's architecture"
"Trace how [feature] works end-to-end"
"Navigate this codebase"
"Onboard me to this repo"
"Using codebase_navigation skill"
```

## When to Use

- First day on a new team or project
- Inheriting a codebase from another developer
- Picking up a feature in a part of the codebase you haven't touched
- Reviewing an open-source project before contributing
- Auditing a codebase for quality or security

---

## PART 1: THE FIRST 30 MINUTES

### Step 1: README (Minutes 0-5)

```
[ ] What does this project do? (one sentence)
[ ] How to install and run locally?
[ ] Prerequisites (Node version, database, etc.)?
[ ] Links to docs, wiki, architecture diagrams?
```

### Step 2: package.json (Minutes 5-10)

```json
// Check scripts — HOW to run things
"scripts": {
  "start:dev": "nest start --watch",
  "build": "nest build",
  "test": "jest",
  "db:migrate": "prisma migrate dev"
}
```

Check dependencies — WHAT'S the stack:
```
[ ] Framework: @nestjs/core? express? next?
[ ] ORM: @prisma/client? typeorm?
[ ] Auth: passport-jwt? passport-local?
[ ] Validation: class-validator? zod?
[ ] Testing: jest? vitest?
```

### Step 3: Entry Point (Minutes 10-15)

**NestJS**: `src/main.ts` → Look for global pipes, guards, CORS, API prefix, Swagger setup.

**React**: `src/main.tsx` → Check `App.tsx` for routes → Router config lists all pages.

### Step 4: CI/CD (Minutes 15-20)

```
[ ] .github/workflows/*.yml (GitHub Actions)
[ ] Dockerfile / docker-compose.yml
[ ] .env.example (required env vars)
```

### Step 5: Database Schema (Minutes 20-30)

```
[ ] How many models? (complexity indicator)
[ ] Core entities? (User, Project, etc.)
[ ] Relationships? (1:1, 1:N, N:M)
[ ] Enums? (roles, statuses, types)
```

---

## PART 2: TRACE A REQUEST END-TO-END

```
HTTP Request → Middleware → Guard → Pipe → Controller → Service → Prisma → DB
                                                                    ↓
HTTP Response ← Interceptor ← Controller ← Service ← Prisma ← DB Result
```

### Example: Trace `GET /api/users/:id`

```typescript
// 1. Controller — find the route handler
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }
}

// 2. Service — find the business logic
@Injectable()
export class UsersService {
  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: { projects: true },
    });
    if (!user) throw new NotFoundException('User not found');
    return { success: true, data: user };
  }
}

// 3. Module — see how it's wired
@Module({
  imports: [PrismaModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}

// 4. AppModule — confirm it's registered
@Module({ imports: [UsersModule, /* ... */] })
export class AppModule {}
```

---

## PART 3: MAP THE AUTH FLOW

```
[ ] Where is the JWT secret configured?
[ ] What is the token payload shape? (e.g., { sub, email })
[ ] Which routes are public vs protected?
[ ] Is there role-based access control?
[ ] How are refresh tokens handled?
```

Typical files: `jwt.strategy.ts`, `jwt-auth.guard.ts`, `user.decorator.ts`

---

## PART 4: TEAM CONVENTIONS

### Files to Inspect

| File | What It Tells You |
|------|------------------|
| `.eslintrc.js` | Code style rules |
| `.prettierrc` | Formatting preferences |
| `tsconfig.json` | Strict mode? Path aliases? |
| `.husky/` | Git hooks (lint on commit? test on push?) |
| PR template | Expected PR format |

### Patterns to Observe

```
[ ] File naming: camelCase vs kebab-case vs PascalCase?
[ ] Database columns: camelCase vs snake_case?
[ ] API endpoint naming convention?
[ ] Commit message format? (Conventional Commits?)
```

---

## PART 5: READ RECENT PRS

Recent PRs tell you the team's actual practices (not just what docs say):

```
[ ] PR size (small focused PRs vs large PRs?)
[ ] Description quality (template? thorough?)
[ ] Review process (how many reviewers? how detailed?)
[ ] Test expectations (tests required?)
[ ] Branch naming convention?
```

---

## PART 6: CODEBASE MAP TEMPLATE

### NestJS Backend Structure
```
src/
├── main.ts               # Entry point — global config
├── app.module.ts          # Module registry — all features listed
├── common/                # Shared: decorators, guards, filters, pipes
├── auth/                  # Auth module: strategy, guard, decorator
├── prisma/                # Database: module + service
└── [feature]/             # Each feature: module + service + controller + dto/
```

### React Frontend Structure
```
src/
├── main.tsx               # Entry point
├── App.tsx                # Root component + router
├── pages/                 # One component per route
├── components/            # Reusable components
├── hooks/                 # Custom React hooks
├── services/              # API call functions
├── stores/                # State management (Zustand)
├── types/                 # TypeScript types
└── utils/                 # Helper functions
```

---

## PART 7: RED FLAGS

```
🔴 No README or setup instructions
🔴 No tests
🔴 God files (1000+ lines)
🔴 Hardcoded secrets in source code
🔴 No .env.example
🔴 No CI/CD pipeline
🔴 console.log everywhere (no structured logging)
🔴 node_modules or .env committed to git
```

---

## ✅ Exit Checklist

- [ ] Can explain what the project does in one sentence
- [ ] Local dev environment is running
- [ ] Can trace a request from HTTP → database → response
- [ ] Auth flow is understood
- [ ] Key files reference is documented
- [ ] Team conventions are noted
- [ ] At least 3 recent PRs reviewed
- [ ] Red flags (if any) noted for follow-up
