---
name: Usage Metering and Billing
description: Stripe Meters API integration for usage-based billing, metering service implementation, and freemium-to-paid conversion flows
---

# Usage Metering and Billing Skill

**Purpose**: Implement accurate usage-based billing so you can charge customers for what they consume. This skill covers Stripe Meters API integration, a Redis-backed usage accumulator, customer-facing usage dashboards, plan limit enforcement, and the freemium-to-paid conversion flow. Getting billing wrong erodes trust faster than any bug.

## TRIGGER COMMANDS

```text
"Set up usage billing"
"Implement metering"
"Stripe billing integration"
"Usage-based pricing setup"
"Using usage_metering_billing skill: configure billing for [project]"
```

## When to Use

- Building a SaaS product with usage-based or hybrid pricing
- Need to track API calls, storage, seats, or other metered resources
- Implementing freemium-to-paid conversion with usage limits
- Setting up Stripe billing infrastructure during beta

---

## PROCESS

### Step 1: Define Billable Metrics

Identify what you charge for. Every metric needs a clear unit and counting method.

| Metric | Unit | Counting Method | Example |
|--------|------|----------------|---------|
| API calls | Request | Increment per successful request | 10,000 calls/month |
| Storage | GB-month | Sample daily, average over billing period | 50 GB included |
| Seats | User | Count active users at billing time | 5 seats/plan |
| AI tokens | Token | Sum input + output tokens per request | 100K tokens/month |
| Messages sent | Message | Increment per sent message | 1,000 messages/month |
| Compute time | Minute | Sum execution duration per job | 500 minutes/month |

**Pricing Model Decision**:

```text
Do users consume a predictable amount?
  YES --> Tiered pricing (Basic: 1K calls, Pro: 50K calls)
  NO  --> Pay-as-you-go with committed minimums

Do you want a free tier?
  YES --> Set generous free limits (enough to evaluate, not enough to run production)
  NO  --> Offer a 14-day free trial instead

Do you have multiple billable dimensions?
  YES --> Consider a platform fee + usage overage model
  NO  --> Simple per-unit pricing
```

### Step 2: Implement the Metering Service

Build a service that records usage events reliably. Usage data must be durable -- lost events mean lost revenue.

**Architecture**:

```text
Request --> MeteringService.record() --> Redis (accumulator)
                                              |
                                     Flush job (every 60s)
                                              |
                                     Stripe Meters API
                                              |
                                     UsageSummary table (audit trail)
```

**MeteringService (NestJS)**:

```typescript
// src/billing/metering.service.ts
@Injectable()
export class MeteringService {
  constructor(
    private readonly redis: RedisService,
    private readonly prisma: PrismaService,
  ) {}

  async record(orgId: string, metric: string, quantity: number = 1): Promise<void> {
    const key = `usage:${orgId}:${metric}:${this.getCurrentPeriod()}`;
    await this.redis.incrby(key, quantity);
    await this.redis.expire(key, 60 * 60 * 24 * 35); // 35 days TTL
  }

  async getCurrentUsage(orgId: string, metric: string): Promise<number> {
    const key = `usage:${orgId}:${metric}:${this.getCurrentPeriod()}`;
    const value = await this.redis.get(key);
    return parseInt(value || '0', 10);
  }

  async isWithinLimit(orgId: string, metric: string, limit: number): Promise<boolean> {
    const current = await this.getCurrentUsage(orgId, metric);
    return current < limit;
  }

  private getCurrentPeriod(): string {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
  }
}
```

**Flush Job** (sends accumulated usage to Stripe):

```typescript
// src/billing/metering-flush.job.ts
@Injectable()
export class MeteringFlushJob {
  @Cron('*/60 * * * * *') // Every 60 seconds
  async flush(): Promise<void> {
    const keys = await this.redis.keys('usage:*');
    for (const key of keys) {
      const [, orgId, metric, period] = key.split(':');
      const quantity = await this.redis.getdel(key);
      if (quantity && parseInt(quantity) > 0) {
        await this.stripe.billing.meterEvents.create({
          event_name: metric,
          payload: {
            stripe_customer_id: await this.getStripeCustomerId(orgId),
            value: quantity,
          },
        });
        await this.prisma.usageSummary.create({
          data: { orgId, metric, quantity: parseInt(quantity), period },
        });
      }
    }
  }
}
```

### Step 3: Enforce Plan Limits

Coordinate with the `rate_limiting` skill to enforce plan-based limits.

| Plan | API Calls | Storage | AI Tokens | Price |
|------|-----------|---------|-----------|-------|
| Free | 1,000/mo | 1 GB | 10K/mo | $0 |
| Pro | 50,000/mo | 50 GB | 500K/mo | $29/mo |
| Enterprise | Unlimited | 500 GB | 5M/mo | $199/mo |

**Limit Enforcement Pattern**:

```typescript
// In a guard or middleware
async canActivate(context: ExecutionContext): Promise<boolean> {
  const user = context.switchToHttp().getRequest().user;
  const plan = await this.billingService.getPlan(user.orgId);
  const withinLimit = await this.meteringService.isWithinLimit(
    user.orgId, 'api_calls', plan.limits.apiCalls,
  );
  if (!withinLimit) {
    throw new HttpException('Plan limit reached. Upgrade to continue.', 429);
  }
  return true;
}
```

### Step 4: Build the Usage Dashboard

Give customers visibility into their consumption. Opacity breeds distrust.

**Usage Summary Endpoint**:

```typescript
// GET /api/billing/usage
{
  "success": true,
  "data": {
    "period": "2026-02",
    "plan": "pro",
    "metrics": {
      "api_calls": { "used": 12450, "limit": 50000, "percentage": 24.9 },
      "storage_gb": { "used": 8.2, "limit": 50, "percentage": 16.4 },
      "ai_tokens": { "used": 125000, "limit": 500000, "percentage": 25.0 }
    },
    "billing": {
      "next_invoice_date": "2026-03-01",
      "estimated_amount_cents": 2900,
      "overage_charges_cents": 0
    }
  }
}
```

### Step 5: Usage Warning Emails

Send automated warnings before users hit limits. Do not surprise them with a hard stop.

| Threshold | Action | Email Template |
|-----------|--------|---------------|
| 75% of limit | Warning email | "You've used 75% of your [metric] limit" |
| 90% of limit | Urgent warning | "You're approaching your [metric] limit" |
| 100% of limit | Limit reached + soft block | "You've reached your limit. Upgrade to continue." |
| 110% of limit (grace) | Hard block | "Service paused. Upgrade or wait for next billing cycle." |

---

## CHECKLIST

- [ ] Billable metrics defined with clear units and counting methods
- [ ] Pricing model chosen (tiered, pay-as-you-go, hybrid)
- [ ] MeteringService implemented with Redis accumulator
- [ ] Flush job sends accumulated usage to Stripe Meters API
- [ ] UsageSummary table provides an audit trail for reconciliation
- [ ] Plan limits enforced at the API layer (429 response)
- [ ] Customer-facing usage dashboard built and accurate
- [ ] Usage warning emails configured at 75%, 90%, and 100% thresholds
- [ ] Metering accuracy verified: Stripe totals match internal records
- [ ] Freemium-to-paid upgrade flow tested end-to-end
- [ ] Billing reconciliation job runs daily to catch discrepancies

---

*Skill Version: 1.0 | Created: February 2026*
