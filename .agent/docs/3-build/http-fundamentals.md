# HTTP Fundamentals

> **Everything is HTTP.** Every API call, every page load, every webhook — it all speaks HTTP. Understanding HTTP is understanding how the web works.

---

## The Request Lifecycle

```
┌──────────┐    ┌─────┐    ┌──────────────┐    ┌───────────────┐    ┌──────────┐
│  Browser  │───→│ DNS │───→│ Load Balancer│───→│  NestJS App   │───→│ Database │
│  (React)  │    │     │    │ (nginx/ALB)  │    │               │    │(Postgres)│
│           │    │     │    │              │    │ Middleware     │    │          │
│ fetch()   │    │     │    │              │    │  → Guard      │    │          │
│           │    │     │    │              │    │    → Pipe      │    │          │
│           │    │     │    │              │    │      → Ctrl    │    │          │
│           │    │     │    │              │    │        → Svc   │───→│  Query   │
│           │    │     │    │              │    │        ← Svc   │←───│  Result  │
│ setState()│←───│     │←───│              │←───│      ← Ctrl   │    │          │
│ re-render │    │     │    │              │    │    ← Intercept │    │          │
└──────────┘    └─────┘    └──────────────┘    └───────────────┘    └──────────┘
```

---

## HTTP Methods

| Method | Purpose | Idempotent? | Safe? | Request Body? | NestJS Decorator |
|--------|---------|-------------|-------|--------------|-----------------|
| `GET` | Read / list data | Yes | Yes | No | `@Get()` |
| `POST` | Create new resource | No | No | Yes | `@Post()` |
| `PUT` | Replace entire resource | Yes | No | Yes | `@Put()` |
| `PATCH` | Update part of resource | Yes | No | Yes | `@Patch()` |
| `DELETE` | Remove resource | Yes | No | Optional | `@Delete()` |
| `OPTIONS` | CORS preflight check | Yes | Yes | No | (automatic) |
| `HEAD` | Like GET but no body | Yes | Yes | No | `@Head()` |

**Idempotent** = same request N times has the same effect as 1 time.
**Safe** = doesn't modify data (read-only).

---

## Status Codes

### 2xx — Success

| Code | Name | When to Use | NestJS |
|------|------|------------|--------|
| `200` | OK | Successful GET, PUT, PATCH, DELETE | Default return |
| `201` | Created | Successful POST (resource created) | `@HttpCode(201)` or default for POST |
| `204` | No Content | Successful DELETE (nothing to return) | `@HttpCode(204)` |

### 3xx — Redirection

| Code | Name | When to Use |
|------|------|------------|
| `301` | Moved Permanently | URL changed permanently (SEO) |
| `302` | Found | Temporary redirect |
| `304` | Not Modified | Client cache is still valid |

### 4xx — Client Errors

| Code | Name | When to Use | NestJS Exception |
|------|------|------------|-----------------|
| `400` | Bad Request | Validation failed, malformed request | `throw new BadRequestException('message')` |
| `401` | Unauthorized | Not authenticated (no token, expired token) | `throw new UnauthorizedException()` |
| `403` | Forbidden | Authenticated but not authorized | `throw new ForbiddenException()` |
| `404` | Not Found | Resource doesn't exist | `throw new NotFoundException('User not found')` |
| `409` | Conflict | Duplicate resource (unique constraint) | `throw new ConflictException('Email already exists')` |
| `422` | Unprocessable Entity | Semantically invalid (valid JSON but bad data) | `throw new UnprocessableEntityException()` |
| `429` | Too Many Requests | Rate limit exceeded | `throw new HttpException('Rate limit', 429)` |

### 5xx — Server Errors

| Code | Name | When to Use |
|------|------|------------|
| `500` | Internal Server Error | Unhandled exception (BUG — fix it!) |
| `502` | Bad Gateway | Upstream server failed (database down, external API down) |
| `503` | Service Unavailable | Server overloaded or in maintenance |
| `504` | Gateway Timeout | Upstream server didn't respond in time |

---

## Important Headers

### Request Headers

| Header | Purpose | Example |
|--------|---------|---------|
| `Authorization` | Authentication token | `Bearer eyJhbGciOiJIUzI1NiIs...` |
| `Content-Type` | Format of request body | `application/json` |
| `Accept` | Desired response format | `application/json` |
| `X-Request-ID` | Request correlation ID | `550e8400-e29b-41d4-a716-446655440000` |
| `Origin` | Where the request came from (CORS) | `https://myapp.com` |

### Response Headers

| Header | Purpose | Example |
|--------|---------|---------|
| `Content-Type` | Format of response body | `application/json; charset=utf-8` |
| `Cache-Control` | Caching instructions | `no-cache` or `max-age=3600` |
| `X-RateLimit-Remaining` | Requests left in window | `95` |
| `X-RateLimit-Reset` | When limit resets | `1697000000` (Unix timestamp) |
| `Access-Control-Allow-Origin` | CORS: allowed origins | `https://myapp.com` |

---

## Request Body Formats

### JSON (most common for APIs)

```typescript
// React — sending JSON
const response = await fetch('/api/users', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: 'Jane', email: 'jane@example.com' }),
});

// NestJS — receiving JSON
@Post()
async create(@Body() createUserDto: CreateUserDto) {
  return this.usersService.create(createUserDto);
}
```

### FormData (file uploads)

```typescript
// React — sending files
const formData = new FormData();
formData.append('file', selectedFile);
formData.append('description', 'Profile photo');

const response = await fetch('/api/upload', {
  method: 'POST',
  body: formData, // No Content-Type header! Browser sets it with boundary
});

// NestJS — receiving files
@Post('upload')
@UseInterceptors(FileInterceptor('file'))
async upload(@UploadedFile() file: Express.Multer.File) {
  return { filename: file.originalname, size: file.size };
}
```

---

## REST Conventions with NestJS

### Resource Naming

```
✅ GET    /api/users              — List users
✅ POST   /api/users              — Create user
✅ GET    /api/users/:id          — Get one user
✅ PATCH  /api/users/:id          — Update user
✅ DELETE /api/users/:id          — Delete user
✅ GET    /api/users/:id/projects — List user's projects

❌ GET    /api/getUsers           — Verb in URL (redundant)
❌ GET    /api/user               — Singular (should be plural)
❌ POST   /api/users/create       — Verb in URL
❌ GET    /api/users/delete/:id   — Using GET for deletion
```

### NestJS Controller Example

```typescript
@Controller('users')
@UseGuards(JwtAuthGuard)
@ApiTags('Users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async findAll(
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
  ) {
    return this.usersService.findAll({ page, limit });
  }

  @Get(':id')
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.usersService.findOne(id);
  }

  @Post()
  @HttpCode(201)
  async create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto);
  }

  @Patch(':id')
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateUserDto,
  ) {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return this.usersService.remove(id);
  }
}
```

---

## CORS Deep Dive

### Why CORS Exists

Browsers enforce the Same-Origin Policy: a page at `https://myapp.com` cannot make requests to `https://api.myapp.com` without permission. CORS headers are how the API grants that permission.

### NestJS CORS Configuration

```typescript
// main.ts
app.enableCors({
  origin: ['https://myapp.com', 'http://localhost:5173'],
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  credentials: true,  // Allow cookies
  allowedHeaders: ['Content-Type', 'Authorization'],
});
```

### Preflight Requests

For "non-simple" requests (POST with JSON, custom headers), the browser sends an OPTIONS request first:

```
Browser → OPTIONS /api/users (Can I send POST with JSON?)
Server  → 200 OK + CORS headers (Yes, from these origins)
Browser → POST /api/users (actual request)
Server  → 201 Created
```

---

## Cookies vs Tokens

| Feature | Cookies | Bearer Tokens (localStorage) |
|---------|---------|------------------------------|
| Sent automatically | Yes (every request to same domain) | No (must add header manually) |
| XSS vulnerable | No (httpOnly flag prevents JS access) | Yes (JS can read localStorage) |
| CSRF vulnerable | Yes (auto-sent = CSRF risk) | No (not auto-sent) |
| Cross-domain | Limited (SameSite attribute) | Works across domains |
| Mobile apps | Awkward | Natural |
| SSR compatible | Yes | No (server can't read localStorage) |

**Recommendation**: Use httpOnly cookies for web apps (most secure). Use Bearer tokens for mobile apps and SPAs that need cross-domain access.

---

*HTTP Fundamentals v1.0 | Created: February 13, 2026*
