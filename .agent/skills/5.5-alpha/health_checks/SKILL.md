---
name: health_checks
description: Application health and readiness endpoints with NestJS Terminus
---

# Health Checks Skill

**Purpose**: Add structured health check endpoints so orchestrators (Kubernetes, Railway, Docker), monitoring services, and load balancers can determine if your application is alive, ready to serve traffic, and operating within normal parameters.

## 🎯 TRIGGER COMMANDS

```text
"add health checks"
"readiness endpoint"
"liveness probe"
"set up health monitoring"
"Using health_checks skill: add /health endpoints"
```

## 📦 PACKAGE INSTALLATION

```bash
cd backend && npm install @nestjs/terminus
```

No additional packages needed -- `@nestjs/terminus` wraps everything.

## 🏗️ ENDPOINT ARCHITECTURE

Three tiers of health endpoints, each with a different audience:

| Endpoint | Auth | Purpose | Consumer |
|----------|------|---------|----------|
| `GET /health` | None | Basic liveness -- "process is running" | Load balancer, Kubernetes `livenessProbe` |
| `GET /health/ready` | None | Readiness -- "dependencies are connected" | Kubernetes `readinessProbe`, deploy gates |
| `GET /health/detailed` | JWT (Admin) | Full diagnostics with metrics | Internal dashboards, on-call debugging |

> [!WARNING]
> **Never** expose connection strings, version numbers, or internal IPs on unauthenticated health endpoints. Attackers use these for reconnaissance.

## 🔧 HEALTH MODULE SETUP

### health.module.ts

```typescript
import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { HealthController } from './health.controller';
import { PrismaHealthIndicator } from './indicators/prisma.health';
import { RedisHealthIndicator } from './indicators/redis.health';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [TerminusModule, PrismaModule],
  controllers: [HealthController],
  providers: [PrismaHealthIndicator, RedisHealthIndicator],
})
export class HealthModule {}
```

### health.controller.ts

```typescript
import { Controller, Get, UseGuards } from '@nestjs/common';
import {
  HealthCheck,
  HealthCheckService,
  MemoryHealthIndicator,
  DiskHealthIndicator,
} from '@nestjs/terminus';
import { PrismaHealthIndicator } from './indicators/prisma.health';
import { RedisHealthIndicator } from './indicators/redis.health';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('health')
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private memory: MemoryHealthIndicator,
    private disk: DiskHealthIndicator,
    private prismaHealth: PrismaHealthIndicator,
    private redisHealth: RedisHealthIndicator,
  ) {}

  /**
   * Basic liveness check — is the process running?
   * Used by: load balancers, Kubernetes livenessProbe
   */
  @Get()
  @HealthCheck()
  liveness() {
    return this.health.check([]);
  }

  /**
   * Readiness check — are dependencies connected?
   * Used by: Kubernetes readinessProbe, deploy gates
   */
  @Get('ready')
  @HealthCheck()
  readiness() {
    return this.health.check([
      () => this.prismaHealth.isHealthy('database'),
      () => this.redisHealth.isHealthy('redis'),
    ]);
  }

  /**
   * Detailed check — full diagnostics with resource usage
   * Used by: admin dashboards, on-call debugging
   */
  @Get('detailed')
  @UseGuards(JwtAuthGuard)
  @HealthCheck()
  detailed() {
    return this.health.check([
      () => this.prismaHealth.isHealthy('database'),
      () => this.redisHealth.isHealthy('redis'),
      // Heap must be under 512MB
      () => this.memory.checkHeap('memory_heap', 512 * 1024 * 1024),
      // RSS must be under 1GB
      () => this.memory.checkRSS('memory_rss', 1024 * 1024 * 1024),
      // Disk must have at least 10% free
      () => this.disk.checkStorage('disk', {
        path: '/',
        thresholdPercent: 0.1,
      }),
    ]);
  }
}
```

## 📊 CUSTOM HEALTH INDICATORS

### PrismaHealthIndicator

```typescript
import { Injectable } from '@nestjs/common';
import { HealthIndicator, HealthIndicatorResult, HealthCheckError } from '@nestjs/terminus';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class PrismaHealthIndicator extends HealthIndicator {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async isHealthy(key: string): Promise<HealthIndicatorResult> {
    try {
      // Simple query with timeout to verify DB connectivity
      await Promise.race([
        this.prisma.$queryRaw`SELECT 1`,
        new Promise((_, reject) =>
          setTimeout(() => reject(new Error('Database health check timed out')), 3000),
        ),
      ]);
      return this.getStatus(key, true);
    } catch (error) {
      throw new HealthCheckError(
        'Database check failed',
        this.getStatus(key, false, { message: error.message }),
      );
    }
  }
}
```

### RedisHealthIndicator

```typescript
import { Injectable } from '@nestjs/common';
import { HealthIndicator, HealthIndicatorResult, HealthCheckError } from '@nestjs/terminus';
import { Redis } from 'ioredis';

@Injectable()
export class RedisHealthIndicator extends HealthIndicator {
  private readonly redis: Redis;

  constructor() {
    super();
    this.redis = new Redis(process.env.REDIS_URL, {
      maxRetriesPerRequest: 1,
      connectTimeout: 3000,
      lazyConnect: true,
    });
  }

  async isHealthy(key: string): Promise<HealthIndicatorResult> {
    try {
      const result = await Promise.race([
        this.redis.ping(),
        new Promise<never>((_, reject) =>
          setTimeout(() => reject(new Error('Redis health check timed out')), 3000),
        ),
      ]);
      if (result !== 'PONG') {
        throw new Error(`Unexpected Redis response: ${result}`);
      }
      return this.getStatus(key, true);
    } catch (error) {
      throw new HealthCheckError(
        'Redis check failed',
        this.getStatus(key, false, { message: error.message }),
      );
    }
  }
}
```

### External API Health Indicator

```typescript
import { Injectable } from '@nestjs/common';
import { HealthIndicator, HealthIndicatorResult, HealthCheckError } from '@nestjs/terminus';

@Injectable()
export class ExternalApiHealthIndicator extends HealthIndicator {
  async isHealthy(key: string): Promise<HealthIndicatorResult> {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 5000);

      const response = await fetch('https://api.example.com/health', {
        signal: controller.signal,
      });
      clearTimeout(timeout);

      if (!response.ok) {
        throw new Error(`External API returned ${response.status}`);
      }
      return this.getStatus(key, true, { statusCode: response.status });
    } catch (error) {
      throw new HealthCheckError(
        'External API check failed',
        this.getStatus(key, false, { message: error.message }),
      );
    }
  }
}
```

## 📋 RESPONSE FORMAT

Terminus returns a standardized format:

```json
{
  "status": "ok",
  "info": {
    "database": { "status": "up" },
    "redis": { "status": "up" }
  },
  "error": {},
  "details": {
    "database": { "status": "up" },
    "redis": { "status": "up" }
  }
}
```

When a check fails, the HTTP status becomes **503** and the failing indicator moves to `error`:

```json
{
  "status": "error",
  "info": {
    "redis": { "status": "up" }
  },
  "error": {
    "database": { "status": "down", "message": "Connection refused" }
  },
  "details": {
    "database": { "status": "down", "message": "Connection refused" },
    "redis": { "status": "up" }
  }
}
```

## ☸️ KUBERNETES / RAILWAY CONFIGURATION

### Kubernetes Pod Spec

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 15    # Grace period for app startup
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3        # Kill pod after 3 consecutive failures

readinessProbe:
  httpGet:
    path: /health/ready
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 2        # Remove from LB after 2 failures
```

### Railway Configuration

Railway uses the health check to determine deploy success. Set in `railway.toml`:

```toml
[deploy]
healthcheckPath = "/health"
healthcheckTimeout = 30
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 3
```

> [!TIP]
> Set `initialDelaySeconds` high enough for your app to fully boot. NestJS apps with Prisma migrations and seed data can take 10-30 seconds. If the probe fires too early, Kubernetes kills the pod in a restart loop.

## ⏱️ TIMEOUT CONFIGURATION

Health checks should be fast. If a dependency is slow, the health check should time out rather than hang:

```typescript
// Global timeout for all health checks
@Get('ready')
@HealthCheck()
readiness() {
  return Promise.race([
    this.health.check([
      () => this.prismaHealth.isHealthy('database'),
    ]),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Health check global timeout')), 10000),
    ),
  ]);
}
```

**Recommended timeouts:**

| Check | Timeout |
|-------|---------|
| Database ping | 3 seconds |
| Redis ping | 2 seconds |
| External API | 5 seconds |
| Global health endpoint | 10 seconds |

## 📡 EXTERNAL MONITORING INTEGRATION

After deploying your health endpoints, configure external uptime monitors:

| Service | Free Tier | Check Interval |
|---------|-----------|----------------|
| UptimeRobot | 50 monitors, 5-min interval | 5 minutes |
| Better Uptime | 10 monitors, 3-min interval | 3 minutes |
| Checkly | 5 checks, browser checks | 1 minute |

Setup:
1. Point the monitor at `https://your-api.com/health/ready`
2. Expected status code: `200`
3. Alert via: Slack webhook, email, SMS
4. Create a public status page (optional but builds trust)

## 🛡️ STARTUP GRACE PERIOD

Prevent false alarms during application boot:

```typescript
@Injectable()
export class AppReadinessService {
  private ready = false;

  markReady() {
    this.ready = true;
  }

  isReady(): boolean {
    return this.ready;
  }
}

// In main.ts, after full initialization:
async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // ... all setup ...
  await app.listen(3000);

  const readiness = app.get(AppReadinessService);
  readiness.markReady();
}
```

```typescript
// In HealthController
@Get('ready')
@HealthCheck()
readiness() {
  if (!this.appReadiness.isReady()) {
    throw new ServiceUnavailableException('Application is still starting');
  }
  return this.health.check([
    () => this.prismaHealth.isHealthy('database'),
  ]);
}
```

## 🚫 SECURITY: WHAT NOT TO EXPOSE

Public health endpoints must NOT return:

- [ ] Database connection strings or host names
- [ ] Internal IP addresses
- [ ] Application version or framework version
- [ ] Stack traces or error details
- [ ] Number of active users or connections
- [ ] Environment variable values

> [!WARNING]
> The `/health/detailed` endpoint returns resource metrics. It MUST be behind `JwtAuthGuard` and ideally restricted to admin roles. An attacker knowing your memory usage and disk space aids in planning denial-of-service attacks.

## ✅ EXIT CHECKLIST

- [ ] `@nestjs/terminus` installed
- [ ] `GET /health` returns 200 with `{ status: "ok" }` (no auth required)
- [ ] `GET /health/ready` checks database connectivity
- [ ] `GET /health/ready` checks Redis connectivity (if using Redis)
- [ ] `GET /health/detailed` requires JWT authentication
- [ ] All health indicator checks have timeouts (no hanging)
- [ ] Kubernetes/Railway health check path configured
- [ ] `initialDelaySeconds` accounts for actual startup time
- [ ] External monitoring service pings `/health/ready` every 5 minutes
- [ ] Alert configured: health check failure sends Slack/email notification
- [ ] Public health endpoints expose no sensitive information
- [ ] Startup grace period prevents false negatives during boot

*Skill Version: 1.0 | Created: February 2026*
