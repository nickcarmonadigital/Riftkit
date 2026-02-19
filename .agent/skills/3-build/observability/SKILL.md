---
name: observability
description: Structured logging, metrics, tracing, and alerting for NestJS production applications
---

# Observability Skill

**Purpose**: "Turn on the lights" in production. Ensure that when things break, you know **What**, **Where**, and **Why** without guessing — through structured logs, metrics, traces, and actionable alerts.

> [!IMPORTANT]
> **Zero-Blindness Policy**: No critical feature goes to production without logging and error tracking.

## 🎯 TRIGGER COMMANDS

```text
"Add logging to [feature]"
"Setup observability for [project]"
"Implement metrics for [service]"
"Add request tracing"
"Configure alerting for [threshold]"
"Using observability skill: instrument [component]"
```

## When to Use

- Setting up logging in a new NestJS project
- Adding structured logging to existing services
- Implementing request tracing with correlation IDs
- Setting up Prometheus metrics and Grafana dashboards
- Configuring actionable alerting rules
- Debugging production issues through logs

---

## PART 1: THE THREE PILLARS

```
Observability
├── LOGS — What happened (events, errors, audit trail)
├── METRICS — How much (rates, counts, durations, gauges)
└── TRACES — Where (request flow across services)
```

### The Golden Signals (RED Method)

Every service must track:

| Signal | What | Example |
|--------|------|---------|
| **Rate** | Requests per second | 150 req/s |
| **Errors** | Failed request percentage | 0.3% error rate |
| **Duration** | Response time (p50, p95, p99) | p99 = 450ms |

---

## PART 2: STRUCTURED LOGGING WITH PINO

### Why Pino Over Winston

| Feature | Pino | Winston |
|---------|------|---------|
| Speed | 5x faster (low overhead) | Slower |
| Output | JSON by default | Text by default |
| NestJS integration | `nestjs-pino` package | Manual setup |
| Production-ready | Yes, minimal config | Needs more config |

### NestJS + Pino Setup

```bash
npm install nestjs-pino pino-http pino-pretty
```

```typescript
// app.module.ts
import { LoggerModule } from 'nestjs-pino';

@Module({
  imports: [
    LoggerModule.forRoot({
      pinoHttp: {
        level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
        transport: process.env.NODE_ENV !== 'production'
          ? { target: 'pino-pretty', options: { colorize: true } }
          : undefined,

        // Customize what gets logged per request
        customProps: (req) => ({
          correlationId: req.headers['x-request-id'] || req.id,
        }),

        // Redact sensitive fields
        redact: {
          paths: [
            'req.headers.authorization',
            'req.headers.cookie',
            'req.body.password',
            'req.body.token',
            'req.body.creditCard',
          ],
          censor: '[REDACTED]',
        },

        // Customize serializers
        serializers: {
          req: (req) => ({
            method: req.method,
            url: req.url,
            query: req.query,
            // Don't log full headers or body by default
          }),
          res: (res) => ({
            statusCode: res.statusCode,
          }),
        },
      },
    }),
  ],
})
export class AppModule {}
```

```typescript
// main.ts — Replace default NestJS logger
import { Logger } from 'nestjs-pino';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  app.useLogger(app.get(Logger));
  // ...
}
```

### Log Levels and When to Use Them

```typescript
import { Logger } from '@nestjs/common';

@Injectable()
export class OrderService {
  private readonly logger = new Logger(OrderService.name);

  async createOrder(userId: string, dto: CreateOrderDto) {
    // DEBUG — Verbose data for developer troubleshooting
    this.logger.debug(`Creating order for user ${userId}`, { dto });

    const order = await this.prisma.order.create({ data: { ... } });

    // INFO — Standard lifecycle events (happy path)
    this.logger.log(`Order created`, {
      orderId: order.id,
      userId,
      total: order.total,
      itemCount: dto.items.length,
    });

    return order;
  }

  async processPayment(orderId: string) {
    try {
      const result = await this.paymentGateway.charge(orderId);
      this.logger.log(`Payment processed`, { orderId, transactionId: result.id });
    } catch (error) {
      // WARN — Something odd but system survived
      if (error.code === 'CARD_DECLINED') {
        this.logger.warn(`Payment declined`, { orderId, reason: error.message });
        throw new BadRequestException('Payment declined');
      }

      // ERROR — System is broken, needs investigation
      this.logger.error(`Payment gateway error`, {
        orderId,
        error: error.message,
        stack: error.stack,
      });
      throw new InternalServerErrorException('Payment processing failed');
    }
  }
}
```

### What to Log

```
ALWAYS LOG:
├── Authentication events (login, logout, failed attempts)
├── Authorization failures (access denied)
├── Business-critical operations (order created, payment processed)
├── External service calls (API calls, response times)
├── Errors with full context (stack trace, request data)
└── Application lifecycle (startup, shutdown, config loaded)

NEVER LOG:
├── Passwords, tokens, API keys
├── Credit card numbers, SSNs
├── Full request bodies in production (too verbose)
├── Health check requests (noise)
└── Successful authentication tokens
```

---

## PART 3: NESTJS INTERCEPTORS

### Logging Interceptor

```typescript
// common/interceptors/logging.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url, body } = request;
    const userAgent = request.headers['user-agent'] || '';
    const userId = request.user?.sub || 'anonymous';

    const now = Date.now();

    return next.handle().pipe(
      tap({
        next: (data) => {
          const response = context.switchToHttp().getResponse();
          const duration = Date.now() - now;

          this.logger.log({
            method,
            url,
            statusCode: response.statusCode,
            duration: `${duration}ms`,
            userId,
            userAgent: userAgent.substring(0, 100),
          });

          // Warn on slow responses
          if (duration > 1000) {
            this.logger.warn(`Slow response: ${method} ${url} took ${duration}ms`, {
              userId,
              duration,
            });
          }
        },
        error: (error) => {
          const duration = Date.now() - now;
          this.logger.error({
            method,
            url,
            statusCode: error.status || 500,
            duration: `${duration}ms`,
            userId,
            error: error.message,
          });
        },
      }),
    );
  }
}
```

### Apply Globally

```typescript
// main.ts
app.useGlobalInterceptors(new LoggingInterceptor());
```

### Timing Interceptor (Performance Tracking)

```typescript
// common/interceptors/timing.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class TimingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('Performance');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const start = process.hrtime.bigint();

    return next.handle().pipe(
      tap(() => {
        const end = process.hrtime.bigint();
        const durationMs = Number(end - start) / 1_000_000;

        // Add response header for client-side timing
        const response = context.switchToHttp().getResponse();
        response.setHeader('X-Response-Time', `${durationMs.toFixed(2)}ms`);

        // Log slow endpoints for optimization
        if (durationMs > 500) {
          this.logger.warn(`Slow endpoint`, {
            method: request.method,
            url: request.url,
            duration: durationMs.toFixed(2),
            handler: context.getHandler().name,
            controller: context.getClass().name,
          });
        }
      }),
    );
  }
}
```

---

## PART 4: REQUEST TRACING (CORRELATION IDs)

### Why Correlation IDs

When a single user action triggers multiple internal calls:

```
User clicks "Place Order"
→ POST /api/orders         (correlationId: req-abc-123)
  → OrderService.create    (correlationId: req-abc-123)
  → PaymentService.charge  (correlationId: req-abc-123)
  → EmailService.send      (correlationId: req-abc-123)
  → InventoryService.reserve (correlationId: req-abc-123)
```

Without a correlation ID, these are 4 unrelated log entries. With one, you can trace the entire flow.

### NestJS Middleware Implementation

```typescript
// common/middleware/correlation-id.middleware.ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { randomUUID } from 'crypto';
import { AsyncLocalStorage } from 'async_hooks';

// Store correlation ID for the entire request lifecycle
export const requestContext = new AsyncLocalStorage<{ correlationId: string }>();

@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const correlationId = (req.headers['x-request-id'] as string) || randomUUID();

    // Set on request for easy access
    req['correlationId'] = correlationId;

    // Set response header so frontend can see it
    res.setHeader('x-request-id', correlationId);

    // Run the rest of the request within this context
    requestContext.run({ correlationId }, () => {
      next();
    });
  }
}
```

```typescript
// app.module.ts
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(CorrelationIdMiddleware).forRoutes('*');
  }
}
```

### Accessing Correlation ID in Services

```typescript
import { requestContext } from '../common/middleware/correlation-id.middleware';

@Injectable()
export class PaymentService {
  private readonly logger = new Logger(PaymentService.name);

  async charge(orderId: string, amount: number) {
    const ctx = requestContext.getStore();
    const correlationId = ctx?.correlationId || 'unknown';

    this.logger.log('Processing payment', {
      correlationId,
      orderId,
      amount,
    });

    // Now you can search logs by correlationId to trace the full request
  }
}
```

---

## PART 5: PROMETHEUS METRICS

### Setup with prom-client

```bash
npm install prom-client @willsoto/nestjs-prometheus
```

```typescript
// app.module.ts
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [
    PrometheusModule.register({
      path: '/metrics',           // Prometheus scrapes this endpoint
      defaultMetrics: {
        enabled: true,
        config: { prefix: 'app_' },
      },
    }),
  ],
})
export class AppModule {}
```

### Custom Metrics

```typescript
// common/metrics/metrics.service.ts
import { Injectable } from '@nestjs/common';
import { Counter, Histogram, Gauge } from 'prom-client';

@Injectable()
export class MetricsService {
  // Count total requests by endpoint and status
  readonly httpRequestsTotal = new Counter({
    name: 'http_requests_total',
    help: 'Total HTTP requests',
    labelNames: ['method', 'path', 'status'],
  });

  // Track response time distribution
  readonly httpRequestDuration = new Histogram({
    name: 'http_request_duration_seconds',
    help: 'HTTP request duration in seconds',
    labelNames: ['method', 'path'],
    buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
  });

  // Track active connections
  readonly activeConnections = new Gauge({
    name: 'active_connections',
    help: 'Number of active connections',
  });

  // Business metrics
  readonly ordersCreated = new Counter({
    name: 'orders_created_total',
    help: 'Total orders created',
    labelNames: ['status'],
  });

  readonly paymentAmount = new Histogram({
    name: 'payment_amount_dollars',
    help: 'Payment amounts in dollars',
    buckets: [10, 50, 100, 500, 1000, 5000],
  });
}
```

### Metrics Interceptor

```typescript
// common/interceptors/metrics.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, tap } from 'rxjs';
import { MetricsService } from '../metrics/metrics.service';

@Injectable()
export class MetricsInterceptor implements NestInterceptor {
  constructor(private metrics: MetricsService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, route } = request;
    const path = route?.path || request.url;

    const timer = this.metrics.httpRequestDuration.startTimer({ method, path });

    return next.handle().pipe(
      tap({
        next: () => {
          const response = context.switchToHttp().getResponse();
          timer();
          this.metrics.httpRequestsTotal.inc({
            method,
            path,
            status: response.statusCode,
          });
        },
        error: (error) => {
          timer();
          this.metrics.httpRequestsTotal.inc({
            method,
            path,
            status: error.status || 500,
          });
        },
      }),
    );
  }
}
```

### Using Business Metrics in Services

```typescript
@Injectable()
export class OrderService {
  constructor(private metrics: MetricsService) {}

  async createOrder(dto: CreateOrderDto) {
    const order = await this.prisma.order.create({ data: { ... } });

    // Track business metrics
    this.metrics.ordersCreated.inc({ status: 'created' });
    this.metrics.paymentAmount.observe(order.total / 100); // cents to dollars

    return order;
  }
}
```

---

## PART 6: HEALTH CHECKS

```bash
npm install @nestjs/terminus
```

```typescript
// health/health.controller.ts
import { Controller, Get } from '@nestjs/common';
import {
  HealthCheck,
  HealthCheckService,
  PrismaHealthIndicator,
  MemoryHealthIndicator,
  DiskHealthIndicator,
} from '@nestjs/terminus';

@Controller('health')
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private prisma: PrismaHealthIndicator,
    private memory: MemoryHealthIndicator,
    private disk: DiskHealthIndicator,
  ) {}

  @Get()
  @HealthCheck()
  check() {
    return this.health.check([
      // Database connectivity
      () => this.prisma.pingCheck('database'),

      // Memory usage (< 300MB heap)
      () => this.memory.checkHeap('memory_heap', 300 * 1024 * 1024),

      // Disk usage (< 90%)
      () => this.disk.checkStorage('disk', { thresholdPercent: 0.9, path: '/' }),
    ]);
  }

  @Get('ready')
  @HealthCheck()
  readiness() {
    // Only check if the app can serve requests
    return this.health.check([
      () => this.prisma.pingCheck('database'),
    ]);
  }
}
```

---

## PART 7: GRAFANA DASHBOARD

### Essential Dashboard Panels

```
Dashboard: Application Overview
┌─────────────────────┬─────────────────────┐
│ Request Rate (req/s)│ Error Rate (%)      │
│ rate(http_total[5m])│ rate(errors[5m])    │
│                     │ / rate(total[5m])   │
├─────────────────────┼─────────────────────┤
│ Response Time (p95) │ Active Connections  │
│ histogram_quantile( │ active_connections  │
│ 0.95, duration)     │                     │
├─────────────────────┼─────────────────────┤
│ Orders Created/hour │ Payment Amount Dist │
│ rate(orders[1h])    │ histogram(payment)  │
└─────────────────────┴─────────────────────┘
```

### Key PromQL Queries

```promql
# Request rate (last 5 minutes)
rate(http_requests_total[5m])

# Error rate percentage
sum(rate(http_requests_total{status=~"5.."}[5m]))
/
sum(rate(http_requests_total[5m]))
* 100

# P95 response time
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# P99 response time
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Top 5 slowest endpoints
topk(5, histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])))
```

---

## PART 8: ALERTING RULES

### Alert on User Pain, Not System Noise

```yaml
# prometheus/alerts.yml
groups:
  - name: application
    rules:
      # High error rate — users are seeing errors
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          / sum(rate(http_requests_total[5m])) > 0.01
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Error rate above 1% for 5 minutes"
          runbook: "https://wiki.internal/runbooks/high-error-rate"

      # Slow responses — users are waiting
      - alert: HighLatency
        expr: |
          histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "P95 latency above 2 seconds"

      # Database connection issues
      - alert: DatabaseDown
        expr: up{job="postgres"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Database is unreachable"

      # Disk space running low
      - alert: DiskSpaceLow
        expr: disk_usage_percent > 85
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Disk usage above 85%"
```

### Severity Levels

| Severity | Response | Example |
|----------|----------|---------|
| **critical** | Page on-call immediately | Error rate > 1%, database down |
| **warning** | Investigate next business day | P95 latency > 2s, disk > 85% |
| **info** | Log for trend analysis | Deployment completed, feature flag toggled |

### Alert Best Practices

```
GOOD ALERTS:
├── Actionable — Someone can DO something about it
├── Include runbook link — "what do I do when this fires?"
├── Use `for` duration — Avoid flapping (alert → resolve → alert)
└── Track user impact — Error rate, not CPU usage

BAD ALERTS:
├── "CPU is at 80%" — So what? Is the user affected?
├── Every 404 — Expected behavior for broken links
├── Disk at 50% — Not urgent yet
└── No runbook — Alert fires, nobody knows what to do
```

---

## PART 9: PII REDACTION

Never log personally identifiable information.

```typescript
// Fields to always redact
const REDACT_PATHS = [
  'req.headers.authorization',
  'req.headers.cookie',
  'req.body.password',
  'req.body.confirmPassword',
  'req.body.token',
  'req.body.refreshToken',
  'req.body.creditCard',
  'req.body.ssn',
  'req.body.dateOfBirth',
  '*.password',
  '*.secret',
  '*.apiKey',
];

// In pino config
pinoHttp: {
  redact: {
    paths: REDACT_PATHS,
    censor: '[REDACTED]',
  },
}
```

### Email/Phone Masking

```typescript
// For logs where you need partial info for debugging
function maskEmail(email: string): string {
  const [local, domain] = email.split('@');
  return `${local[0]}***@${domain}`;
  // "john.doe@example.com" → "j***@example.com"
}

function maskPhone(phone: string): string {
  return phone.replace(/.(?=.{4})/g, '*');
  // "+15551234567" → "*******4567"
}
```

---

## PART 10: LOG AGGREGATION & SEARCH

### Docker Compose for Local Stack

```yaml
# docker-compose.observability.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - '9090:9090'

  grafana:
    image: grafana/grafana:latest
    ports:
      - '3001:3000'
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana

  loki:
    image: grafana/loki:latest
    ports:
      - '3100:3100'

volumes:
  grafana_data:
```

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'nestjs-app'
    scrape_interval: 15s
    static_configs:
      - targets: ['host.docker.internal:3000']
```

---

## ✅ Exit Checklist

- [ ] Pino structured logging configured (JSON in production, pretty in dev)
- [ ] Log levels used correctly (ERROR / WARN / INFO / DEBUG)
- [ ] PII redacted from all logs (passwords, tokens, cards)
- [ ] Correlation IDs attached to every request (X-Request-ID)
- [ ] LoggingInterceptor logs method, URL, status, duration
- [ ] Slow responses logged as warnings (> 1s)
- [ ] Health check endpoint exists (`/health`)
- [ ] Prometheus metrics exposed (`/metrics`)
- [ ] Custom business metrics tracked (orders, payments)
- [ ] Alerting rules configured for user-impacting issues
- [ ] Runbook links included in alert annotations
- [ ] Log transport configured (not just console.log)
