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

## ✅ Exit Checklist

- [ ] Resources use plural nouns (`/users` not `/user`)
- [ ] HTTP methods match CRUD operations correctly
- [ ] Pagination implemented (offset or cursor)
- [ ] Error responses follow consistent format
- [ ] Input validation with class-validator + ValidationPipe
- [ ] Rate limiting configured for sensitive endpoints
- [ ] Swagger/OpenAPI decorators added
- [ ] No verbs in URLs
