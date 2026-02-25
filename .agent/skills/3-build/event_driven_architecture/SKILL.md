---
name: Event Driven Architecture
description: Decouple services with event-based messaging using BullMQ, Redis Streams, and saga patterns.
---

# Event Driven Architecture Skill

**Purpose**: Guide the transition from direct service calls to event-driven communication. Covers technology selection (BullMQ vs Redis Streams vs RabbitMQ vs Kafka), event schema design, idempotent consumers, dead-letter queue handling, and the saga pattern for distributed transactions.

## TRIGGER COMMANDS

```text
"Decouple [service] with events"
"Add message queue"
"Implement pub/sub"
```

## When to Use
- Service A calls Service B synchronously but should not block on the response
- Background processing needed (email, PDF generation, indexing)
- Fan-out: one event triggers multiple downstream reactions
- Distributed transactions span multiple services
- You need replay or audit capability for operations

---

## PROCESS

### Step 1: Technology Selection

| Criteria | BullMQ | Redis Streams | RabbitMQ | Kafka |
|----------|--------|---------------|----------|-------|
| Best for | Job queues, scheduled tasks | Lightweight pub/sub | Complex routing | High-throughput log |
| Ordering | Per-queue FIFO | Per-stream | Per-queue | Per-partition |
| Persistence | Redis (AOF) | Redis (AOF) | Disk | Disk (retention) |
| NestJS support | `@nestjs/bullmq` | Manual | `@nestjs/microservices` | `@nestjs/microservices` |
| Ops complexity | Low (Redis) | Low (Redis) | Medium | High |
| Recommended | Default choice | Simple events | Routing needed | >100K events/sec |

### Step 2: Event Schema Design (Envelope Pattern)

```typescript
// events/event-envelope.ts
export interface EventEnvelope<T = unknown> {
  id: string;              // UUID for deduplication
  type: string;            // e.g., 'workspace.created'
  version: number;         // Schema version for evolution
  timestamp: string;       // ISO 8601
  source: string;          // Producing service name
  correlationId: string;   // Trace through event chain
  data: T;                 // Event-specific payload
}

// Example concrete event
export interface WorkspaceCreatedEvent {
  workspaceId: string;
  name: string;
  ownerId: string;
}

// Factory function
export function createEvent<T>(
  type: string,
  data: T,
  correlationId?: string,
): EventEnvelope<T> {
  return {
    id: randomUUID(),
    type,
    version: 1,
    timestamp: new Date().toISOString(),
    source: process.env.SERVICE_NAME ?? 'unknown',
    correlationId: correlationId ?? randomUUID(),
    data,
  };
}
```

### Step 3: BullMQ Producer/Consumer in NestJS

```typescript
// workspace/workspace.module.ts
import { BullModule } from '@nestjs/bullmq';

@Module({
  imports: [
    BullModule.registerQueue({ name: 'workspace-events' }),
  ],
  providers: [WorkspaceService, WorkspaceEventsProcessor],
})
export class WorkspaceModule {}
```

```typescript
// workspace/workspace.service.ts (Producer)
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';

@Injectable()
export class WorkspaceService {
  constructor(
    private prisma: PrismaService,
    @InjectQueue('workspace-events') private eventQueue: Queue,
  ) {}

  async create(userId: string, dto: CreateWorkspaceDto) {
    const workspace = await this.prisma.workspace.create({
      data: { name: dto.name, ownerId: userId },
    });

    // Publish event after successful write
    await this.eventQueue.add('workspace.created', createEvent('workspace.created', {
      workspaceId: workspace.id,
      name: workspace.name,
      ownerId: userId,
    }));

    return workspace;
  }
}
```

```typescript
// workspace/workspace-events.processor.ts (Consumer)
import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';

@Processor('workspace-events')
export class WorkspaceEventsProcessor extends WorkerHost {
  constructor(
    private readonly notificationService: NotificationService,
    private readonly analyticsService: AnalyticsService,
  ) {
    super();
  }

  async process(job: Job<EventEnvelope>): Promise<void> {
    switch (job.name) {
      case 'workspace.created':
        await this.notificationService.sendWelcomeEmail(job.data.data);
        await this.analyticsService.trackCreation(job.data);
        break;
      default:
        this.logger.warn(`Unknown event type: ${job.name}`);
    }
  }
}
```

### Step 4: Idempotent Consumers

Consumers MUST handle duplicate deliveries gracefully.

```typescript
// common/idempotency.service.ts
@Injectable()
export class IdempotencyService {
  constructor(private readonly redis: Redis) {}

  async isProcessed(eventId: string): Promise<boolean> {
    const exists = await this.redis.exists(`processed:${eventId}`);
    return exists === 1;
  }

  async markProcessed(eventId: string, ttlSeconds = 86400): Promise<void> {
    await this.redis.setex(`processed:${eventId}`, ttlSeconds, '1');
  }
}

// Usage in processor
async process(job: Job<EventEnvelope>): Promise<void> {
  if (await this.idempotency.isProcessed(job.data.id)) {
    this.logger.debug(`Skipping duplicate event: ${job.data.id}`);
    return;
  }

  // Process event...

  await this.idempotency.markProcessed(job.data.id);
}
```

### Step 5: Dead-Letter Queue (DLQ) Handling

```typescript
// Configure DLQ in BullMQ
BullModule.registerQueue({
  name: 'workspace-events',
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: 'exponential', delay: 1000 },
    removeOnComplete: 1000,
    removeOnFail: false,  // Keep failed jobs for inspection
  },
});

// Monitor DLQ
@Cron(CronExpression.EVERY_HOUR)
async monitorFailedJobs() {
  const queue = this.queueRef;
  const failed = await queue.getFailed(0, 100);
  if (failed.length > 0) {
    this.logger.error(`${failed.length} failed jobs in workspace-events queue`);
    // Alert via Slack/PagerDuty
  }
}
```

### Step 6: Saga Pattern for Distributed Transactions

```typescript
// When creating an order requires: reserve inventory + charge payment + send confirmation
// If any step fails, compensate previous steps.

@Injectable()
export class OrderSagaService {
  async executeCreateOrderSaga(orderId: string): Promise<void> {
    const compensations: (() => Promise<void>)[] = [];

    try {
      // Step 1: Reserve inventory
      await this.inventoryService.reserve(orderId);
      compensations.push(() => this.inventoryService.releaseReservation(orderId));

      // Step 2: Charge payment
      await this.paymentService.charge(orderId);
      compensations.push(() => this.paymentService.refund(orderId));

      // Step 3: Send confirmation
      await this.notificationService.sendConfirmation(orderId);

    } catch (error) {
      // Compensate in reverse order
      for (const compensate of compensations.reverse()) {
        try {
          await compensate();
        } catch (compError) {
          this.logger.error('Compensation failed', compError);
          // Alert: manual intervention required
        }
      }
      throw error;
    }
  }
}
```

---

## CHECKLIST

- [ ] Technology selected with documented rationale
- [ ] Event envelope schema includes id, type, version, timestamp, correlationId
- [ ] Producer publishes AFTER successful database write (not before)
- [ ] Consumer is idempotent (duplicate delivery handled)
- [ ] Dead-letter queue configured with retry policy (3 attempts, exponential backoff)
- [ ] DLQ monitoring and alerting in place
- [ ] Saga compensation logic implemented for multi-step workflows
- [ ] Event types documented in a shared registry or schema file
