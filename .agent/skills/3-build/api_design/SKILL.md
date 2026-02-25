---
name: api_design
description: RESTful API design patterns with NestJS implementation
---

# API Design Skill

**Purpose**: Design consistent, predictable REST APIs following industry conventions. Every endpoint should be self-documenting and follow the same patterns.

## 🎯 TRIGGER COMMANDS

```text
"Design the API for [feature]"
"Create REST endpoints for [resource]"
"Add pagination to [endpoint]"
"Set up API versioning"
"Design the error response format"
"Using api_design skill"
```

## When to Use

- Designing a new API or adding endpoints
- Adding pagination, filtering, or sorting
- Standardizing error responses across the API
- Setting up API versioning
- Adding Swagger/OpenAPI documentation

---

## PART 1: RESOURCE NAMING

```
✅ GET    /api/users                  — List users
✅ POST   /api/users                  — Create user
✅ GET    /api/users/:id              — Get one user
✅ PATCH  /api/users/:id              — Update user
✅ DELETE /api/users/:id              — Delete user
✅ GET    /api/users/:id/projects     — User's projects (nested resource)

❌ GET    /api/getUsers               — Verb in URL
❌ POST   /api/users/create           — Verb in URL
❌ GET    /api/user                   — Singular (use plural)
❌ GET    /api/Users                  — Capitalized
```

---

## PART 2: PAGINATION

### Offset-Based (Simple, Most Common)

```typescript
// DTO
class PaginationDto {
  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number = 1;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;
}

// Service
async findAll(query: PaginationDto) {
  const { page = 1, limit = 20 } = query;
  const skip = (page - 1) * limit;

  const [data, total] = await Promise.all([
    this.prisma.user.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' } }),
    this.prisma.user.count(),
  ]);

  return {
    success: true,
    data,
    meta: {
      total,
      page,
      limit,
      lastPage: Math.ceil(total / limit),
      hasNext: page < Math.ceil(total / limit),
      hasPrev: page > 1,
    },
  };
}
// GET /api/users?page=2&limit=20
```

### Cursor-Based (Better for Large Datasets)

```typescript
// Service
async findAll(cursor?: string, limit = 20) {
  const items = await this.prisma.user.findMany({
    take: limit + 1, // Fetch one extra to check if there's more
    ...(cursor && {
      cursor: { id: cursor },
      skip: 1, // Skip the cursor item itself
    }),
    orderBy: { createdAt: 'desc' },
  });

  const hasNext = items.length > limit;
  const data = hasNext ? items.slice(0, -1) : items;

  return {
    success: true,
    data,
    meta: {
      hasNext,
      nextCursor: hasNext ? data[data.length - 1].id : null,
    },
  };
}
// GET /api/users?cursor=abc-123&limit=20
```

---

## PART 3: FILTERING & SORTING

```typescript
// DTO
class FilterUsersDto extends PaginationDto {
  @IsOptional()
  @IsEnum(Role)
  role?: Role;

  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsEnum(['createdAt', 'name', 'email'])
  sortBy?: string = 'createdAt';

  @IsOptional()
  @IsEnum(['asc', 'desc'])
  order?: 'asc' | 'desc' = 'desc';
}

// Service
async findAll(query: FilterUsersDto) {
  const where: Prisma.UserWhereInput = {};

  if (query.role) where.role = query.role;
  if (query.search) {
    where.OR = [
      { name: { contains: query.search, mode: 'insensitive' } },
      { email: { contains: query.search, mode: 'insensitive' } },
    ];
  }

  const [data, total] = await Promise.all([
    this.prisma.user.findMany({
      where,
      skip: (query.page - 1) * query.limit,
      take: query.limit,
      orderBy: { [query.sortBy]: query.order },
    }),
    this.prisma.user.count({ where }),
  ]);

  return { success: true, data, meta: { total, page: query.page } };
}
// GET /api/users?role=ADMIN&search=jane&sortBy=name&order=asc&page=1&limit=20
```

---

## PART 4: ERROR RESPONSE FORMAT

### Standard Error Shape

```typescript
// Every error follows this format
interface ErrorResponse {
  statusCode: number;
  error: string;
  message: string;
  details?: any[];      // Validation errors
  timestamp: string;
  path: string;
  requestId?: string;   // For log correlation
}

// Example: Validation error
{
  "statusCode": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "details": [
    { "field": "email", "message": "email must be a valid email" },
    { "field": "name", "message": "name must be at least 2 characters" }
  ],
  "timestamp": "2026-02-13T12:00:00.000Z",
  "path": "/api/users"
}
```

### Global Exception Filter

```typescript
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    let status = 500;
    let message = 'Internal server error';
    let details = undefined;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      message = typeof res === 'string' ? res : (res as any).message;
      details = (res as any).details;
    }

    response.status(status).json({
      statusCode: status,
      error: HttpStatus[status],
      message,
      details,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

---

## PART 5: BULK OPERATIONS

```typescript
// Batch create
@Post('bulk')
async createMany(@Body() dto: CreateUsersDto) {
  return this.prisma.$transaction(async (tx) => {
    const users = await tx.user.createMany({
      data: dto.users,
      skipDuplicates: true,
    });
    return { success: true, data: { created: users.count } };
  });
}

// Batch delete
@Delete('bulk')
async deleteMany(@Body() dto: { ids: string[] }) {
  const result = await this.prisma.user.deleteMany({
    where: { id: { in: dto.ids } },
  });
  return { success: true, data: { deleted: result.count } };
}
```

---

## PART 6: API VERSIONING

```typescript
// main.ts — enable versioning
app.enableVersioning({
  type: VersioningType.URI, // /api/v1/users, /api/v2/users
  defaultVersion: '1',
});

// Controller — version-specific endpoints
@Controller('users')
export class UsersController {
  @Get()
  @Version('1')
  findAllV1() {
    return this.usersService.findAllV1(); // Old format
  }

  @Get()
  @Version('2')
  findAllV2() {
    return this.usersService.findAllV2(); // New format
  }
}
```

---

## PART 7: REQUEST VALIDATION

```typescript
// DTO with class-validator decorators
class CreateUserDto {
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name: string;

  @IsEmail()
  email: string;

  @IsEnum(Role)
  @IsOptional()
  role?: Role;

  @IsStrongPassword({
    minLength: 8,
    minLowercase: 1,
    minUppercase: 1,
    minNumbers: 1,
  })
  password: string;
}

// Global validation pipe (main.ts)
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,              // Strip unknown properties
  forbidNonWhitelisted: true,   // Error on unknown properties
  transform: true,              // Auto-transform types
  transformOptions: {
    enableImplicitConversion: true,
  },
}));
```

---

## PART 8: RATE LIMITING

```typescript
// Install: npm install @nestjs/throttler

// app.module.ts
@Module({
  imports: [
    ThrottlerModule.forRoot([{
      ttl: 60000,   // 1 minute window
      limit: 100,   // 100 requests per minute
    }]),
  ],
})

// Controller — custom rate limit
@Controller('auth')
export class AuthController {
  @Post('login')
  @Throttle({ default: { ttl: 60000, limit: 5 } }) // 5 attempts per minute
  async login(@Body() dto: LoginDto) { ... }
}

// Rate limit headers in response:
// X-RateLimit-Limit: 100
// X-RateLimit-Remaining: 95
// X-RateLimit-Reset: 1697000060
```

---

---

## PART 9: HTTP METHOD SEMANTICS

| Method | Idempotent | Safe | Use For |
|--------|-----------|------|---------|
| GET | Yes | Yes | Retrieve resources |
| POST | No | No | Create resources, trigger actions |
| PUT | Yes | No | Full replacement of a resource |
| PATCH | No* | No | Partial update of a resource |
| DELETE | Yes | No | Remove a resource |

*PATCH can be made idempotent with proper implementation

---

## PART 10: STATUS CODE REFERENCE

```
# Success
200 OK                    -- GET, PUT, PATCH (with response body)
201 Created               -- POST (include Location header)
204 No Content            -- DELETE, PUT (no response body)

# Client Errors
400 Bad Request           -- Validation failure, malformed JSON
401 Unauthorized          -- Missing or invalid authentication
403 Forbidden             -- Authenticated but not authorized
404 Not Found             -- Resource doesn't exist
409 Conflict              -- Duplicate entry, state conflict
422 Unprocessable Entity  -- Semantically invalid (valid JSON, bad data)
429 Too Many Requests     -- Rate limit exceeded

# Server Errors
500 Internal Server Error -- Unexpected failure (never expose details)
502 Bad Gateway           -- Upstream service failed
503 Service Unavailable   -- Temporary overload, include Retry-After
```

**Common mistakes to avoid:**
- 200 for everything (use proper status codes semantically)
- 500 for validation errors (use 400 or 422)
- 200 for created resources (use 201 with Location header)

---

## PART 11: ADVANCED FILTERING PATTERNS

### Comparison Operators (Bracket Notation)

```
GET /api/v1/products?price[gte]=10&price[lte]=100
GET /api/v1/orders?created_at[after]=2025-01-01
```

### Multiple Values (Comma-Separated)

```
GET /api/v1/products?category=electronics,clothing
```

### Sparse Fieldsets (Reduce Payload)

```
GET /api/v1/users?fields=id,name,email
GET /api/v1/orders?fields=id,total,status&include=customer.name
```

### Sort with Prefix Notation

```
# Single field (prefix - for descending)
GET /api/v1/products?sort=-created_at

# Multiple fields (comma-separated)
GET /api/v1/products?sort=-featured,price,-created_at
```

---

## PART 12: RATE LIMIT TIERS

| Tier | Limit | Window | Use Case |
|------|-------|--------|----------|
| Anonymous | 30/min | Per IP | Public endpoints |
| Authenticated | 100/min | Per user | Standard API access |
| Premium | 1000/min | Per API key | Paid API plans |
| Internal | 10000/min | Per service | Service-to-service |

Rate limit response headers:

```
HTTP/1.1 429 Too Many Requests
Retry-After: 60
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1640000000
```

---

## PART 13: VERSIONING STRATEGY

```
1. Start with /api/v1/ -- don't version until you need to
2. Maintain at most 2 active versions (current + previous)
3. Deprecation timeline:
   - Announce deprecation (6 months notice for public APIs)
   - Add Sunset header: Sunset: Sat, 01 Jan 2026 00:00:00 GMT
   - Return 410 Gone after sunset date
4. Non-breaking changes don't need a new version:
   - Adding new fields to responses
   - Adding new optional query parameters
   - Adding new endpoints
5. Breaking changes require a new version:
   - Removing or renaming fields
   - Changing field types
   - Changing URL structure
   - Changing authentication method
```

---

## PART 14: NAMING RULES

```
# GOOD
/api/v1/team-members          # kebab-case for multi-word resources
/api/v1/orders?status=active  # query params for filtering
/api/v1/users/123/orders      # nested resources for ownership

# Actions that don't map to CRUD (use verbs sparingly)
POST /api/v1/orders/:id/cancel
POST /api/v1/auth/login
POST /api/v1/auth/refresh

# BAD
/api/v1/getUsers              # verb in URL
/api/v1/user                  # singular (use plural)
/api/v1/team_members          # snake_case in URLs
/api/v1/users/123/getOrders   # verb in nested resource
```

---

## ✅ Exit Checklist

- [ ] Resources use plural nouns (`/users` not `/user`)
- [ ] HTTP methods match CRUD operations correctly
- [ ] Correct HTTP status codes returned (not 200 for everything)
- [ ] Pagination implemented (offset or cursor based on use case)
- [ ] Error responses follow consistent format with codes and messages
- [ ] Input validation with class-validator + ValidationPipe
- [ ] Rate limiting configured with appropriate tiers
- [ ] Swagger/OpenAPI decorators added
- [ ] No verbs in URLs (kebab-case for multi-word resources)
- [ ] Authorization checked (users access own resources only)
- [ ] Sparse fieldsets or `select` used to minimize response payload
- [ ] Versioning strategy documented
