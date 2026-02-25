---
name: Resiliency Patterns
description: Implement timeout, retry, circuit breaker, fallback, and bulkhead patterns for fault-tolerant services.
---

# Resiliency Patterns Skill

**Purpose**: Build fault-tolerant services using a layered resiliency pyramid: timeouts, retries with backoff, circuit breakers, fallback responses, and bulkhead isolation. Provides NestJS-native implementations and integrates with health checks for runtime resiliency decisions.

## TRIGGER COMMANDS

```text
"Add circuit breaker to [service]"
"Make [feature] resilient"
"Graceful degradation"
```

## When to Use
- Calling external APIs or third-party services
- Database calls that may time out under load
- Microservice-to-microservice communication
- Any dependency that can fail independently of your service
- Production incidents revealed cascading failures

---

## PROCESS

### Step 1: Resiliency Pyramid (Apply Bottom-Up)

```text
Level 5: Graceful Degradation  (serve reduced functionality)
Level 4: Fallback              (cached or default response)
Level 3: Circuit Breaker       (stop calling failed service)
Level 2: Retry + Backoff       (handle transient errors)
Level 1: Timeout               (never wait forever) <-- START HERE
```

Always implement from Level 1 upward. Every external call needs at least a timeout.

### Step 2: Timeout Enforcement

```typescript
// common/timeout.util.ts
export async function withTimeout<T>(
  promise: Promise<T>,
  ms: number,
  label: string,
): Promise<T> {
  const timeout = new Promise<never>((_, reject) =>
    setTimeout(() => reject(new Error(`${label} timed out after ${ms}ms`)), ms),
  );
  return Promise.race([promise, timeout]);
}

// Usage
const result = await withTimeout(
  this.paymentApi.charge(orderId, amount),
  5000,
  'PaymentAPI.charge',
);
```

For HTTP clients, configure timeouts at the client level:

```typescript
// http.module.ts
HttpModule.register({
  timeout: 5000,          // 5s default
  maxRedirects: 3,
});
```

### Step 3: Retry with Exponential Backoff and Jitter

```typescript
// common/retry.util.ts
export interface RetryOptions {
  maxAttempts: number;
  baseDelayMs: number;
  maxDelayMs: number;
  retryableErrors?: (error: Error) => boolean;
}

export async function withRetry<T>(
  fn: () => Promise<T>,
  opts: RetryOptions,
): Promise<T> {
  let lastError: Error;

  for (let attempt = 0; attempt < opts.maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;

      // Only retry on retryable errors
      if (opts.retryableErrors && !opts.retryableErrors(lastError)) {
        throw lastError;
      }

      if (attempt < opts.maxAttempts - 1) {
        // Exponential backoff with jitter
        const delay = Math.min(
          opts.baseDelayMs * Math.pow(2, attempt) + Math.random() * 1000,
          opts.maxDelayMs,
        );
        await new Promise((r) => setTimeout(r, delay));
      }
    }
  }

  throw lastError!;
}

// Usage
const result = await withRetry(
  () => this.externalApi.fetchData(id),
  {
    maxAttempts: 3,
    baseDelayMs: 1000,
    maxDelayMs: 10000,
    retryableErrors: (e) => e.message.includes('ECONNRESET') || e.message.includes('503'),
  },
);
```

### Step 4: Circuit Breaker with Opossum

```typescript
// common/circuit-breaker.service.ts
import CircuitBreaker from 'opossum';

@Injectable()
export class CircuitBreakerService {
  private breakers = new Map<string, CircuitBreaker>();

  getBreaker<T>(
    name: string,
    fn: (...args: any[]) => Promise<T>,
    options?: Partial<CircuitBreaker.Options>,
  ): CircuitBreaker {
    if (!this.breakers.has(name)) {
      const breaker = new CircuitBreaker(fn, {
        timeout: 5000,               // 5s timeout per call
        errorThresholdPercentage: 50, // Open at 50% failure rate
        resetTimeout: 30000,          // Try again after 30s
        volumeThreshold: 10,          // Min calls before tripping
        ...options,
      });

      breaker.on('open', () =>
        this.logger.warn(`Circuit OPEN: ${name}`),
      );
      breaker.on('halfOpen', () =>
        this.logger.log(`Circuit HALF-OPEN: ${name}`),
      );
      breaker.on('close', () =>
        this.logger.log(`Circuit CLOSED: ${name}`),
      );

      this.breakers.set(name, breaker);
    }

    return this.breakers.get(name)!;
  }
}
```

```typescript
// payment/payment.service.ts
@Injectable()
export class PaymentService {
  private chargeBreaker: CircuitBreaker;

  constructor(private cbService: CircuitBreakerService) {
    this.chargeBreaker = this.cbService.getBreaker(
      'payment-charge',
      (orderId: string, amount: number) => this.callPaymentApi(orderId, amount),
    );

    // Attach fallback
    this.chargeBreaker.fallback(() => ({
      status: 'queued',
      message: 'Payment queued for processing when service recovers',
    }));
  }

  async charge(orderId: string, amount: number) {
    return this.chargeBreaker.fire(orderId, amount);
  }
}
```

### Step 5: Fallback Response Patterns

```typescript
// Three fallback strategies:

// 1. Cached fallback: return last known good response
async getProductCatalog(): Promise<Product[]> {
  try {
    const products = await this.catalogApi.fetchAll();
    await this.redis.set('catalog:cache', JSON.stringify(products), 'EX', 3600);
    return products;
  } catch {
    const cached = await this.redis.get('catalog:cache');
    if (cached) return JSON.parse(cached);
    throw new ServiceUnavailableException('Catalog unavailable');
  }
}

// 2. Degraded fallback: return partial data
async getDashboard(userId: string) {
  const [profile, analytics, recommendations] = await Promise.allSettled([
    this.userService.getProfile(userId),
    this.analyticsService.getSummary(userId),
    this.recommendationService.getForUser(userId),
  ]);

  return {
    profile: profile.status === 'fulfilled' ? profile.value : null,
    analytics: analytics.status === 'fulfilled' ? analytics.value : null,
    recommendations: recommendations.status === 'fulfilled' ? recommendations.value : [],
    degraded: [profile, analytics, recommendations].some(r => r.status === 'rejected'),
  };
}

// 3. Static fallback: return hardcoded safe default
async getFeatureConfig(): Promise<FeatureConfig> {
  try {
    return await this.configService.fetchRemote();
  } catch {
    return DEFAULT_FEATURE_CONFIG; // Hardcoded safe defaults
  }
}
```

### Step 6: Bulkhead Isolation

```typescript
// Separate connection pools per dependency to prevent one failing
// dependency from consuming all connections.

// database.module.ts -- separate pools
const mainPool = new Pool({ max: 20 });         // Main DB operations
const analyticsPool = new Pool({ max: 5 });      // Analytics (can degrade)
const searchPool = new Pool({ max: 5 });          // Search (can degrade)

// HTTP -- separate Axios instances per dependency
const paymentClient = axios.create({ timeout: 5000, maxSockets: 10 });
const emailClient = axios.create({ timeout: 10000, maxSockets: 5 });
```

### Step 7: Health Check Integration

```typescript
// health/health.controller.ts
@Controller('health')
export class HealthController {
  constructor(
    private health: TerminusModule,
    private cbService: CircuitBreakerService,
  ) {}

  @Get()
  check() {
    return this.health.check([
      () => this.db.pingCheck('database', { timeout: 3000 }),
      () => ({
        paymentCircuit: {
          status: this.cbService.getBreaker('payment-charge').opened ? 'down' : 'up',
        },
      }),
    ]);
  }
}
```

---

## CHECKLIST

- [ ] Every external call has an explicit timeout (no unbounded waits)
- [ ] Retries use exponential backoff with jitter (no thundering herd)
- [ ] Retries only apply to transient/retryable errors (not 400s)
- [ ] Circuit breakers configured for each external dependency
- [ ] Fallback strategy defined for each circuit breaker
- [ ] Bulkhead isolation separates connection pools per dependency
- [ ] Health check reports circuit breaker states
- [ ] Resiliency behavior is logged and observable (open/close events)
- [ ] Degraded responses clearly indicate partial data to the client
