---
name: Feature Flag Implementation
description: Comprehensive feature flag lifecycle from creation through rollout to cleanup.
---

# Feature Flags Skill

**Purpose**: Manage the full feature flag lifecycle including when to use flags vs branching, self-hosted and third-party evaluation patterns, NestJS guard integration, React component wrapping, gradual rollout strategies, and mandatory flag debt cleanup.

## TRIGGER COMMANDS

```text
"Add feature flag for [feature]"
"Roll out gradually"
"Implement kill switch"
```

## When to Use
- Deploying incomplete features behind a gate
- Gradual rollout to a percentage of users
- A/B testing or experimentation
- Kill switch for risky features in production
- Decoupling deployment from release

---

## PROCESS

### Step 1: Decide Flags vs Branching

| Scenario | Use Flag | Use Branch |
|----------|----------|------------|
| Incomplete feature in trunk | Yes | No |
| Long-lived experiment | Yes | No |
| One-time migration | No | Yes |
| Config that never changes back | No | Use env var |
| Kill switch for external dependency | Yes | No |

### Step 2: Define the Flag Schema

```typescript
// feature-flags/flag.interface.ts
export interface FeatureFlag {
  key: string;                          // e.g., 'new-dashboard'
  description: string;
  type: 'boolean' | 'percentage' | 'allowlist';
  enabled: boolean;
  percentage?: number;                  // 0-100 for gradual rollout
  allowlist?: string[];                 // user IDs or emails
  createdAt: Date;
  expiresAt: Date;                      // MANDATORY: prevents flag debt
  owner: string;                        // team or person responsible
}
```

### Step 3: Self-Hosted Flag Evaluation (Redis-Backed)

```typescript
// feature-flags/feature-flag.service.ts
import { Injectable } from '@nestjs/common';
import { Redis } from 'ioredis';
import { createHash } from 'crypto';

@Injectable()
export class FeatureFlagService {
  constructor(private readonly redis: Redis) {}

  async isEnabled(flagKey: string, userId?: string): Promise<boolean> {
    const raw = await this.redis.get(`flag:${flagKey}`);
    if (!raw) return false;

    const flag: FeatureFlag = JSON.parse(raw);
    if (!flag.enabled) return false;

    // Check expiration
    if (new Date(flag.expiresAt) < new Date()) {
      await this.redis.del(`flag:${flagKey}`);
      return false;
    }

    if (flag.type === 'boolean') return true;

    if (flag.type === 'allowlist' && userId) {
      return flag.allowlist?.includes(userId) ?? false;
    }

    if (flag.type === 'percentage' && userId) {
      // Deterministic hashing for consistent bucketing
      const hash = createHash('md5').update(`${flagKey}:${userId}`).digest();
      const bucket = hash.readUInt32BE(0) % 100;
      return bucket < (flag.percentage ?? 0);
    }

    return false;
  }

  async setFlag(flag: FeatureFlag): Promise<void> {
    await this.redis.set(`flag:${flag.key}`, JSON.stringify(flag));
  }
}
```

### Step 4: NestJS Guard Integration

```typescript
// feature-flags/feature-flag.guard.ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { FeatureFlagService } from './feature-flag.service';

export const RequireFlag = (flagKey: string) =>
  SetMetadata('featureFlag', flagKey);

@Injectable()
export class FeatureFlagGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private flagService: FeatureFlagService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const flagKey = this.reflector.get<string>('featureFlag', context.getHandler());
    if (!flagKey) return true;

    const request = context.switchToHttp().getRequest();
    const userId = request.user?.sub;

    return this.flagService.isEnabled(flagKey, userId);
  }
}

// Usage in controller
@Controller('dashboard')
@UseGuards(JwtAuthGuard, FeatureFlagGuard)
export class DashboardController {
  @Get('v2')
  @RequireFlag('new-dashboard')
  getV2Dashboard() {
    return { success: true, data: { version: 'v2' } };
  }
}
```

### Step 5: React Component Wrapping

```tsx
// hooks/useFeatureFlag.ts
import { useQuery } from '@tanstack/react-query';
import { api } from '../lib/api';

export function useFeatureFlag(flagKey: string): boolean {
  const { data } = useQuery({
    queryKey: ['feature-flag', flagKey],
    queryFn: () => api.get<{ enabled: boolean }>(`/flags/${flagKey}`),
    staleTime: 60_000, // Re-evaluate every minute
  });
  return data?.enabled ?? false;
}

// components/FeatureGate.tsx
interface FeatureGateProps {
  flag: string;
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export function FeatureGate({ flag, children, fallback = null }: FeatureGateProps) {
  const enabled = useFeatureFlag(flag);
  return enabled ? <>{children}</> : <>{fallback}</>;
}

// Usage
<FeatureGate flag="new-dashboard" fallback={<OldDashboard />}>
  <NewDashboard />
</FeatureGate>
```

### Step 6: Gradual Rollout Strategy

```text
Day 1:  percentage = 5   (internal team / canary users)
Day 3:  percentage = 10  (monitor error rates, latency)
Day 7:  percentage = 25  (widen, check support tickets)
Day 14: percentage = 50  (half traffic)
Day 21: percentage = 100 (full rollout)
Day 28: Remove flag, delete code paths (MANDATORY)
```

### Step 7: Flag Debt Cleanup

Every flag MUST have an `expiresAt` date. Run a weekly audit:

```bash
# CI job: detect expired flags still in code
grep -rn "RequireFlag\|useFeatureFlag\|FeatureGate" src/ \
  | grep -oP "'[a-z-]+'" | sort -u > active_flags.txt

# Compare against Redis flags where expiresAt < now
# Any matches = flag debt requiring cleanup
```

```typescript
// Scheduled NestJS job to alert on stale flags
@Cron(CronExpression.EVERY_WEEK)
async auditStaleFlags() {
  const flags = await this.redis.keys('flag:*');
  for (const key of flags) {
    const flag: FeatureFlag = JSON.parse(await this.redis.get(key));
    if (new Date(flag.expiresAt) < new Date()) {
      this.logger.warn(`Stale flag detected: ${flag.key} (owner: ${flag.owner})`);
    }
  }
}
```

---

## CHECKLIST

- [ ] Flag vs branch decision documented for each feature
- [ ] Flag schema includes mandatory `expiresAt` and `owner` fields
- [ ] Deterministic user bucketing implemented (no random per-request)
- [ ] NestJS guard wired for backend flag evaluation
- [ ] React FeatureGate component available for frontend gating
- [ ] Gradual rollout plan documented with monitoring checkpoints
- [ ] Stale flag audit scheduled (weekly cron or CI job)
- [ ] Flag removal tracked as a ticket when rollout reaches 100%
- [ ] Phase 6 handoff: flag cleanup included in deploy checklist
