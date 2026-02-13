---
name: rate_limiting
description: API rate limiting with @nestjs/throttler and plan-based tiers
---

# Rate Limiting Skill

**Purpose**: Protect API endpoints from abuse and enforce usage limits per billing plan using `@nestjs/throttler`, with Redis support for multi-instance deployments.

## :dart: TRIGGER COMMANDS

```text
"add rate limiting"
"throttle API"
"rate limit endpoints"
"set up throttling"
"Using rate_limiting skill: add rate limiting to [project]"
```

## :package: INSTALLATION AND SETUP

### Install Dependencies

```bash
# Core throttler
npm install @nestjs/throttler

# Redis storage (for multi-instance deployments)
npm install @nestjs-modules/ioredis ioredis
# or
npm install @nestjs/throttler-storage-redis
```

### ThrottlerModule Configuration

```typescript
// src/app.module.ts
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';

@Module({
  imports: [
    ThrottlerModule.forRoot([
      {
        name: 'short',
        ttl: 1000,   // 1 second
        limit: 3,     // 3 requests per second (burst protection)
      },
      {
        name: 'medium',
        ttl: 10000,  // 10 seconds
        limit: 20,    // 20 requests per 10 seconds
      },
      {
        name: 'long',
        ttl: 60000,  // 1 minute
        limit: 60,    // 60 requests per minute (general limit)
      },
    ]),
    // ... other modules
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard, // Apply globally
    },
  ],
})
export class AppModule {}
```

> [!TIP]
> Using multiple throttle tiers (short/medium/long) provides layered protection. The short tier prevents burst attacks, while the long tier enforces sustained rate limits.

## :shield: DEFAULT RATE LIMITS

### Limits by Endpoint Category

| Category | Limit | TTL (Window) | Rationale |
|----------|-------|-------------|-----------|
| General API | 60 req | 1 minute | Standard browsing rate |
| Auth (login/register) | 5 req | 1 minute | Prevent brute force |
| Password reset | 3 req | 1 minute | Prevent enumeration |
| AI/Generation | 20 req | 1 minute | Expensive compute |
| File upload | 10 req | 1 minute | Bandwidth/storage cost |
| Webhook receivers | Unlimited | N/A | External services need reliability |
| Health checks | Unlimited | N/A | Load balancer probes |
| Search | 30 req | 1 minute | Moderate compute |
| Export/download | 5 req | 1 minute | Heavy DB queries |

## :wrench: PER-ENDPOINT CONFIGURATION

### @Throttle() Decorator for Custom Limits

```typescript
// src/auth/auth.controller.ts
import { Controller, Post, Body } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @Throttle({ long: { limit: 5, ttl: 60000 } }) // 5 per minute
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('register')
  @Throttle({ long: { limit: 5, ttl: 60000 } }) // 5 per minute
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('forgot-password')
  @Throttle({ long: { limit: 3, ttl: 60000 } }) // 3 per minute
  async forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgotPassword(dto);
  }
}
```

### AI Endpoint Limits

```typescript
// src/ai/ai.controller.ts
import { Controller, Post, UseGuards } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('ai')
@UseGuards(JwtAuthGuard)
export class AiController {
  @Post('generate')
  @Throttle({ long: { limit: 20, ttl: 60000 } }) // 20 per minute
  async generate(@Body() dto: GenerateDto) {
    return this.aiService.generate(dto);
  }

  @Post('chat')
  @Throttle({ long: { limit: 30, ttl: 60000 } }) // 30 per minute (chat is lighter)
  async chat(@Body() dto: ChatDto) {
    return this.aiService.chat(dto);
  }

  @Post('embed')
  @Throttle({ long: { limit: 100, ttl: 60000 } }) // 100 per minute (embeddings are cheap)
  async embed(@Body() dto: EmbedDto) {
    return this.aiService.embed(dto);
  }
}
```

### File Upload Limits

```typescript
// src/files/files.controller.ts
@Controller('files')
@UseGuards(JwtAuthGuard)
export class FilesController {
  @Post('upload')
  @Throttle({ long: { limit: 10, ttl: 60000 } }) // 10 per minute
  @UseInterceptors(FileInterceptor('file'))
  async upload(@UploadedFile() file: Express.Multer.File) {
    return this.filesService.upload(file);
  }

  @Post('export')
  @Throttle({ long: { limit: 5, ttl: 60000 } }) // 5 per minute (expensive)
  async export(@Body() dto: ExportDto) {
    return this.filesService.export(dto);
  }
}
```

## :fast_forward: SKIPPING RATE LIMITS

### @SkipThrottle() for Exempt Endpoints

```typescript
import { SkipThrottle } from '@nestjs/throttler';

// Skip for entire controller
@Controller('health')
@SkipThrottle()
export class HealthController {
  @Get()
  check() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }
}

// Skip for single endpoint within a throttled controller
@Controller('webhooks')
export class WebhooksController {
  @Post('stripe')
  @SkipThrottle() // Stripe needs reliable delivery
  async handleStripe(@Body() payload: any, @Headers('stripe-signature') sig: string) {
    return this.webhookService.handleStripe(payload, sig);
  }

  @Post('github')
  @SkipThrottle()
  async handleGithub(@Body() payload: any) {
    return this.webhookService.handleGithub(payload);
  }
}

// Skip only a specific throttler tier
@Post('search')
@SkipThrottle({ short: true }) // Allow burst searches, but enforce minute limit
async search(@Body() dto: SearchDto) {
  return this.searchService.search(dto);
}
```

## :crown: PLAN-BASED RATE LIMITING

### Custom Throttler Guard with Billing Awareness

```typescript
// src/common/guards/plan-throttler.guard.ts
import { Injectable, ExecutionContext } from '@nestjs/common';
import { ThrottlerGuard, ThrottlerModuleOptions, ThrottlerStorage } from '@nestjs/throttler';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';

interface PlanLimits {
  requestsPerMinute: number;
  aiRequestsPerMinute: number;
  uploadsPerMinute: number;
}

const PLAN_LIMITS: Record<string, PlanLimits> = {
  free:       { requestsPerMinute: 30,  aiRequestsPerMinute: 10,  uploadsPerMinute: 5  },
  pro:        { requestsPerMinute: 120, aiRequestsPerMinute: 60,  uploadsPerMinute: 30 },
  enterprise: { requestsPerMinute: 600, aiRequestsPerMinute: 300, uploadsPerMinute: 100 },
};

@Injectable()
export class PlanThrottlerGuard extends ThrottlerGuard {
  constructor(
    options: ThrottlerModuleOptions,
    storageService: ThrottlerStorage,
    reflector: Reflector,
    private prisma: PrismaService,
  ) {
    super(options, storageService, reflector);
  }

  protected async getTracker(req: Record<string, any>): Promise<string> {
    // Use user ID if authenticated, otherwise fall back to IP
    const userId = req.user?.sub;
    return userId || req.ip;
  }

  protected async handleRequest(
    requestProps: {
      context: ExecutionContext;
      limit: number;
      ttl: number;
      throttler: any;
      blockDuration: number;
      generateKey: (...args: any[]) => string;
    },
  ): Promise<boolean> {
    const { context } = requestProps;
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.sub;

    if (userId) {
      const user = await this.prisma.user.findUnique({
        where: { id: userId },
        select: { plan: true },
      });

      const plan = user?.plan || 'free';
      const limits = PLAN_LIMITS[plan] || PLAN_LIMITS.free;

      // Determine which limit to apply based on route
      const path = request.route?.path || '';
      if (path.includes('/ai/')) {
        requestProps.limit = limits.aiRequestsPerMinute;
      } else if (path.includes('/files/')) {
        requestProps.limit = limits.uploadsPerMinute;
      } else {
        requestProps.limit = limits.requestsPerMinute;
      }
    }

    return super.handleRequest(requestProps);
  }
}
```

### Use the Custom Guard

```typescript
// src/app.module.ts
import { PlanThrottlerGuard } from './common/guards/plan-throttler.guard';

@Module({
  providers: [
    {
      provide: APP_GUARD,
      useClass: PlanThrottlerGuard, // Replace default ThrottlerGuard
    },
  ],
})
export class AppModule {}
```

### Plan Limits Summary

| Plan | General API | AI Endpoints | File Uploads |
|------|------------|-------------|-------------|
| Free | 30/min | 10/min | 5/min |
| Pro | 120/min | 60/min | 30/min |
| Enterprise | 600/min | 300/min | 100/min |

> [!TIP]
> Cache the user's plan in the JWT payload or in Redis to avoid a database query on every request. Only refresh when the plan changes.

## :floppy_disk: REDIS STORAGE (Multi-Instance)

### Why Redis?

| Deployment | Storage | Reason |
|------------|---------|--------|
| Single instance | In-memory (default) | Simple, no external deps |
| Multi-instance / k8s | Redis | Shared state across instances |

### Redis Storage Configuration

```typescript
// src/app.module.ts
import { ThrottlerModule } from '@nestjs/throttler';
import { ThrottlerStorageRedisService } from '@nestjs/throttler-storage-redis';

@Module({
  imports: [
    ThrottlerModule.forRoot({
      throttlers: [
        { name: 'short', ttl: 1000, limit: 3 },
        { name: 'medium', ttl: 10000, limit: 20 },
        { name: 'long', ttl: 60000, limit: 60 },
      ],
      storage: new ThrottlerStorageRedisService({
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379', 10),
        password: process.env.REDIS_PASSWORD || undefined,
        db: 1, // Use a separate DB from cache/sessions
      }),
    }),
  ],
})
export class AppModule {}
```

> [!WARNING]
> If you deploy multiple instances behind a load balancer and use in-memory storage, each instance tracks limits independently. A user could get N times the intended limit by hitting different instances. Always use Redis for multi-instance.

## :memo: RESPONSE HEADERS AND 429 FORMAT

### Standard Rate Limit Headers

The throttler automatically adds these headers:

| Header | Description | Example |
|--------|------------|---------|
| `X-RateLimit-Limit` | Max requests in window | `60` |
| `X-RateLimit-Remaining` | Requests remaining | `45` |
| `X-RateLimit-Reset` | Seconds until window resets | `32` |
| `Retry-After` | Seconds to wait (on 429 only) | `15` |

### 429 Response Format

```typescript
// When rate limit is exceeded, the response looks like:
{
  "statusCode": 429,
  "message": "ThrottlerException: Too Many Requests",
  "error": "Too Many Requests"
}
```

### Custom 429 Response

```typescript
// src/common/filters/throttler-exception.filter.ts
import { ExceptionFilter, Catch, ArgumentsHost, HttpStatus } from '@nestjs/common';
import { ThrottlerException } from '@nestjs/throttler';
import { Response } from 'express';

@Catch(ThrottlerException)
export class ThrottlerExceptionFilter implements ExceptionFilter {
  catch(exception: ThrottlerException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    response.status(HttpStatus.TOO_MANY_REQUESTS).json({
      success: false,
      statusCode: 429,
      message: 'You have made too many requests. Please wait before trying again.',
      retryAfter: response.getHeader('Retry-After') || 60,
    });
  }
}
```

### Register the Filter

```typescript
// src/main.ts
import { ThrottlerExceptionFilter } from './common/filters/throttler-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalFilters(new ThrottlerExceptionFilter());
  // ... rest of bootstrap
}
```

## :test_tube: TESTING RATE LIMITS

### E2E Test for Rate Limiting

```typescript
// test/rate-limiting.e2e-spec.ts
import { Test } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Rate Limiting (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('should return 429 after exceeding login limit', async () => {
    const loginDto = { email: 'test@example.com', password: 'wrong' };

    // Send 5 requests (the limit)
    for (let i = 0; i < 5; i++) {
      await request(app.getHttpServer())
        .post('/auth/login')
        .send(loginDto)
        .expect((res) => {
          expect(res.status).not.toBe(429);
        });
    }

    // 6th request should be rate limited
    await request(app.getHttpServer())
      .post('/auth/login')
      .send(loginDto)
      .expect(429);
  });

  it('should include rate limit headers', async () => {
    const res = await request(app.getHttpServer()).get('/api/contacts');

    expect(res.headers['x-ratelimit-limit']).toBeDefined();
    expect(res.headers['x-ratelimit-remaining']).toBeDefined();
  });

  it('should skip rate limiting for health check', async () => {
    // Send many requests to health endpoint
    for (let i = 0; i < 100; i++) {
      await request(app.getHttpServer())
        .get('/health')
        .expect(200);
    }
  });

  it('should allow higher limits for pro plan users', async () => {
    const proToken = await getProUserToken(); // Helper to get a pro user JWT

    // Pro users get 120/min, so 70 requests should succeed
    for (let i = 0; i < 70; i++) {
      await request(app.getHttpServer())
        .get('/api/contacts')
        .set('Authorization', `Bearer ${proToken}`)
        .expect((res) => {
          expect(res.status).not.toBe(429);
        });
    }
  });
});
```

### Manual Testing Checklist

| Test | How to Verify |
|------|--------------|
| General limit triggers | Send 61+ requests in 1 minute to any endpoint |
| Auth limit triggers | Send 6+ login attempts in 1 minute |
| Headers present | Check response for `X-RateLimit-*` headers |
| 429 response format | Verify JSON structure matches custom filter |
| Health check exempt | Send 200+ requests to `/health`, none return 429 |
| Webhook exempt | Send 200+ requests to `/webhooks/stripe`, none return 429 |
| Plan-based limits | Login as free user vs pro user, verify different limits |
| Redis shared state | Hit different instances, verify combined limit |

## :clipboard: CONFIGURATION REFERENCE

### Full ThrottlerModule Config

```typescript
ThrottlerModule.forRoot({
  throttlers: [
    {
      name: 'short',
      ttl: 1000,        // Window in milliseconds
      limit: 3,          // Max requests in window
      blockDuration: 0,  // Extra block time after limit hit (0 = just wait for window)
    },
    {
      name: 'long',
      ttl: 60000,
      limit: 60,
    },
  ],
  // Optional: Redis storage
  storage: new ThrottlerStorageRedisService({ host: 'localhost', port: 6379 }),
  // Optional: skip certain routes
  skipIf: (context: ExecutionContext) => {
    const request = context.switchToHttp().getRequest();
    return request.path === '/health';
  },
  // Optional: custom error message
  errorMessage: 'Rate limit exceeded. Please try again later.',
})
```

### Decorator Reference

| Decorator | Usage | Example |
|-----------|-------|---------|
| `@Throttle()` | Override limit for endpoint | `@Throttle({ long: { limit: 5, ttl: 60000 } })` |
| `@SkipThrottle()` | Exempt from all throttling | `@SkipThrottle()` on controller or method |
| `@SkipThrottle({ short: true })` | Exempt from specific tier | Skip burst limit, keep minute limit |

## :white_check_mark: EXIT CHECKLIST

- [ ] `@nestjs/throttler` installed and `ThrottlerModule.forRoot()` configured in `app.module.ts`
- [ ] Global `ThrottlerGuard` (or `PlanThrottlerGuard`) registered as `APP_GUARD`
- [ ] Default limit set: 60 requests per minute for general API
- [ ] Auth endpoints (login, register): 5 per minute
- [ ] Password reset: 3 per minute
- [ ] AI/generation endpoints: 20 per minute
- [ ] File upload endpoints: 10 per minute
- [ ] Health check endpoints decorated with `@SkipThrottle()`
- [ ] Webhook endpoints (Stripe, GitHub) decorated with `@SkipThrottle()`
- [ ] Response headers present: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
- [ ] Custom 429 response format with `ThrottlerExceptionFilter`
- [ ] Plan-based limits: free < pro < enterprise
- [ ] Redis storage configured if running multiple instances
- [ ] E2E tests verify rate limits trigger correctly
- [ ] Rate limit exceeded message is user-friendly, not a raw exception

*Skill Version: 1.0 | Created: February 2026*
