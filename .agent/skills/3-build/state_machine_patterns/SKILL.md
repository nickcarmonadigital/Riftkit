---
name: State Machine Patterns
description: Model workflows as explicit state machines with database-backed transitions and frontend XState integration.
---

# State Machine Patterns Skill

**Purpose**: Replace implicit status fields and ad-hoc conditional logic with explicit state machines. Covers when to use state machines, database-backed state transitions with guard tables, NestJS service-level enforcement, XState for frontend workflows, state history audit logging, and visualization.

## TRIGGER COMMANDS

```text
"Model [workflow] as state machine"
"Prevent invalid state transitions"
"State machine for [entity]"
```

## When to Use
- An entity has a "status" column with more than 3 possible values
- Business logic depends on "if status is X, then allow Y"
- Bugs arise from invalid state transitions (e.g., "completed" order gets "shipped")
- You need an audit trail of state changes
- Complex multi-step workflows (approval flows, order processing, document review)

---

## PROCESS

### Step 1: Identify State Machine Candidates

```text
Signs you need a state machine:
- Status column with 4+ values
- Multiple if/else or switch blocks checking status
- Bugs where entities end up in impossible states
- "How did this order get to 'refunded' without being 'shipped' first?"
- Business stakeholders describe the process as a flowchart

Common state machine candidates:
- Orders: draft -> submitted -> approved -> processing -> shipped -> delivered
- Documents: draft -> review -> approved -> published -> archived
- Tickets: open -> in_progress -> review -> resolved -> closed
- Users: pending -> active -> suspended -> deactivated
```

### Step 2: Define States and Transitions

```typescript
// order/order-states.ts
export enum OrderStatus {
  DRAFT = 'draft',
  SUBMITTED = 'submitted',
  APPROVED = 'approved',
  PROCESSING = 'processing',
  SHIPPED = 'shipped',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}

// Explicit transition map: from -> allowed destinations
export const ORDER_TRANSITIONS: Record<OrderStatus, OrderStatus[]> = {
  [OrderStatus.DRAFT]:      [OrderStatus.SUBMITTED, OrderStatus.CANCELLED],
  [OrderStatus.SUBMITTED]:  [OrderStatus.APPROVED, OrderStatus.CANCELLED],
  [OrderStatus.APPROVED]:   [OrderStatus.PROCESSING, OrderStatus.CANCELLED],
  [OrderStatus.PROCESSING]: [OrderStatus.SHIPPED, OrderStatus.CANCELLED],
  [OrderStatus.SHIPPED]:    [OrderStatus.DELIVERED],
  [OrderStatus.DELIVERED]:  [],  // Terminal state
  [OrderStatus.CANCELLED]:  [],  // Terminal state
};
```

### Step 3: Database-Backed Transition Guard

```typescript
// common/state-machine.service.ts
import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class StateMachineService {
  constructor(private prisma: PrismaService) {}

  async transition<T extends string>(
    model: string,
    id: string,
    fromStatus: T,
    toStatus: T,
    transitions: Record<T, T[]>,
    userId: string,
    metadata?: Record<string, unknown>,
  ): Promise<void> {
    // 1. Validate transition is allowed
    const allowed = transitions[fromStatus];
    if (!allowed?.includes(toStatus)) {
      throw new BadRequestException(
        `Invalid transition: ${fromStatus} -> ${toStatus}. ` +
        `Allowed: ${allowed?.join(', ') || 'none (terminal state)'}`,
      );
    }

    // 2. Optimistic lock: update only if current status matches
    const result = await (this.prisma[model] as any).updateMany({
      where: { id, status: fromStatus },
      data: { status: toStatus, updatedAt: new Date() },
    });

    if (result.count === 0) {
      throw new BadRequestException(
        `Transition failed: ${model} ${id} is no longer in '${fromStatus}' state`,
      );
    }

    // 3. Record state change in audit log
    await this.prisma.stateTransitionLog.create({
      data: {
        entityType: model,
        entityId: id,
        fromStatus,
        toStatus,
        triggeredBy: userId,
        metadata: metadata ? JSON.stringify(metadata) : null,
        transitionedAt: new Date(),
      },
    });
  }
}
```

### Step 4: NestJS Service-Level Enforcement

```typescript
// order/order.service.ts
@Injectable()
export class OrderService {
  constructor(
    private prisma: PrismaService,
    private stateMachine: StateMachineService,
  ) {}

  async submitOrder(orderId: string, userId: string) {
    const order = await this.prisma.order.findUniqueOrThrow({ where: { id: orderId } });

    await this.stateMachine.transition(
      'order',
      orderId,
      order.status as OrderStatus,
      OrderStatus.SUBMITTED,
      ORDER_TRANSITIONS,
      userId,
      { submittedVia: 'web' },
    );

    // Side effects AFTER successful transition
    await this.notificationService.notifyApprovers(orderId);
  }

  async cancelOrder(orderId: string, userId: string, reason: string) {
    const order = await this.prisma.order.findUniqueOrThrow({ where: { id: orderId } });

    await this.stateMachine.transition(
      'order',
      orderId,
      order.status as OrderStatus,
      OrderStatus.CANCELLED,
      ORDER_TRANSITIONS,
      userId,
      { reason },
    );
  }

  // Controller exposes explicit actions, NOT a generic "updateStatus" endpoint
  // BAD:  PATCH /orders/:id/status { status: 'shipped' }
  // GOOD: POST /orders/:id/submit
  // GOOD: POST /orders/:id/cancel
}
```

### Step 5: XState for Frontend Workflow States

```typescript
// machines/orderMachine.ts
import { createMachine, assign } from 'xstate';

export const orderMachine = createMachine({
  id: 'order',
  initial: 'draft',
  context: {
    orderId: null as string | null,
    error: null as string | null,
  },
  states: {
    draft: {
      on: {
        SUBMIT: {
          target: 'submitting',
          guard: 'hasRequiredFields',
        },
        CANCEL: 'cancelled',
      },
    },
    submitting: {
      invoke: {
        src: 'submitOrder',
        onDone: { target: 'submitted', actions: 'clearError' },
        onError: { target: 'draft', actions: 'setError' },
      },
    },
    submitted: {
      on: {
        APPROVE: 'approved',
        CANCEL: 'cancelled',
      },
    },
    approved: {
      on: { PROCESS: 'processing' },
    },
    processing: {
      on: { SHIP: 'shipped', CANCEL: 'cancelled' },
    },
    shipped: {
      on: { DELIVER: 'delivered' },
    },
    delivered: { type: 'final' },
    cancelled: { type: 'final' },
  },
}, {
  guards: {
    hasRequiredFields: (ctx) => !!ctx.orderId,
  },
  actions: {
    setError: assign({ error: (_, event) => event.data?.message }),
    clearError: assign({ error: null }),
  },
});
```

```tsx
// components/OrderWorkflow.tsx
import { useMachine } from '@xstate/react';
import { orderMachine } from '../machines/orderMachine';

export function OrderWorkflow({ orderId }: { orderId: string }) {
  const [state, send] = useMachine(orderMachine, {
    context: { orderId },
  });

  return (
    <div>
      <p>Status: {state.value as string}</p>

      {state.matches('draft') && (
        <button onClick={() => send({ type: 'SUBMIT' })}>Submit Order</button>
      )}
      {state.matches('submitted') && (
        <button onClick={() => send({ type: 'APPROVE' })}>Approve</button>
      )}
      {state.can({ type: 'CANCEL' }) && (
        <button onClick={() => send({ type: 'CANCEL' })}>Cancel</button>
      )}

      {state.context.error && <p className="text-red-500">{state.context.error}</p>}
    </div>
  );
}
```

### Step 6: State History Audit Log

```sql
-- Prisma schema for state transitions
-- model StateTransitionLog {
--   id             String   @id @default(uuid())
--   entityType     String
--   entityId       String
--   fromStatus     String
--   toStatus       String
--   triggeredBy    String
--   metadata       String?
--   transitionedAt DateTime @default(now())
--   @@index([entityType, entityId])
--   @@map("state_transition_logs")
-- }
```

```typescript
// Query full state history for an entity
async getStateHistory(entityType: string, entityId: string) {
  return this.prisma.stateTransitionLog.findMany({
    where: { entityType, entityId },
    orderBy: { transitionedAt: 'asc' },
  });
}

// Result:
// [
//   { from: 'draft', to: 'submitted', by: 'user-1', at: '2025-03-01T10:00:00Z' },
//   { from: 'submitted', to: 'approved', by: 'user-2', at: '2025-03-01T14:00:00Z' },
//   { from: 'approved', to: 'processing', by: 'system', at: '2025-03-02T09:00:00Z' },
// ]
```

### Step 7: Visualizing State Machines

```typescript
// Generate a Mermaid diagram from the transition map
function generateMermaidDiagram(transitions: Record<string, string[]>): string {
  const lines = ['stateDiagram-v2'];
  for (const [from, targets] of Object.entries(transitions)) {
    if (targets.length === 0) {
      lines.push(`    ${from} --> [*]`);  // Terminal state
    }
    for (const to of targets) {
      lines.push(`    ${from} --> ${to}`);
    }
  }
  return lines.join('\n');
}

// Output for ORDER_TRANSITIONS:
// stateDiagram-v2
//     draft --> submitted
//     draft --> cancelled
//     submitted --> approved
//     submitted --> cancelled
//     ...
```

Include the generated diagram in your module's documentation or README.

---

## CHECKLIST

- [ ] Entity statuses defined as TypeScript enum (not loose strings)
- [ ] Transition map explicitly lists every valid from -> to pair
- [ ] Invalid transitions throw descriptive error (not silent no-op)
- [ ] Optimistic locking prevents race conditions on status change
- [ ] State transition audit log records who/what/when for every change
- [ ] Controller exposes action endpoints (submit, approve) not generic status update
- [ ] Frontend uses XState or equivalent for complex multi-step workflows
- [ ] Terminal states are explicitly marked (no transitions out)
- [ ] State machine diagram generated and included in documentation
- [ ] Side effects (notifications, emails) run AFTER successful transition
