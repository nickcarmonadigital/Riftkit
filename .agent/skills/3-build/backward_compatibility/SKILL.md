---
name: Backward Compatibility
description: Evolve APIs and database schemas without breaking existing consumers using additive changes and deprecation patterns.
---

# Backward Compatibility Skill

**Purpose**: Provide a systematic approach to evolving APIs and database schemas without breaking existing consumers. Covers breaking vs non-breaking change classification, additive-only API evolution, deprecation headers, the expand-contract migration pattern, and consumer-driven contract testing.

## TRIGGER COMMANDS

```text
"How to evolve [API] without breaking consumers"
"Add sunset header"
"Backward compatible change"
```

## When to Use
- Adding new fields or endpoints to an existing API
- Changing the shape of an API response
- Renaming or removing a database column in production
- Multiple consumers depend on the same API
- Running blue-green deployments that require schema compatibility

---

## PROCESS

### Step 1: Classify the Change

```text
NON-BREAKING (safe to ship immediately):
  + Add new optional field to request body
  + Add new field to response body
  + Add new endpoint
  + Add new optional query parameter
  + Widen an enum (add new values)

BREAKING (requires migration strategy):
  - Remove or rename a field
  - Change a field's type
  - Make an optional field required
  - Narrow an enum (remove values)
  - Change URL path structure
  - Change authentication mechanism
  - Change error response format
```

### Step 2: Additive-Only API Evolution

```typescript
// Version 1: Original response
interface WorkspaceResponseV1 {
  id: string;
  name: string;
  createdAt: string;
}

// Version 2: ADD fields, never remove
interface WorkspaceResponseV2 {
  id: string;
  name: string;
  createdAt: string;
  // New fields added -- old consumers ignore them
  description: string | null;
  memberCount: number;
  updatedAt: string;
}

// Controller returns the superset -- old clients simply ignore new fields
@Get(':id')
async getWorkspace(@Param('id') id: string) {
  const workspace = await this.workspaceService.findById(id);
  return {
    success: true,
    data: {
      id: workspace.id,
      name: workspace.name,
      createdAt: workspace.createdAt.toISOString(),
      // New fields
      description: workspace.description,
      memberCount: workspace.memberCount,
      updatedAt: workspace.updatedAt.toISOString(),
    },
  };
}
```

### Step 3: Deprecation Headers (RFC 8594)

```typescript
// common/deprecation.interceptor.ts
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable, tap } from 'rxjs';
import { Reflector } from '@nestjs/core';

export const Deprecated = (sunsetDate: string, successor?: string) =>
  SetMetadata('deprecated', { sunsetDate, successor });

@Injectable()
export class DeprecationInterceptor implements NestInterceptor {
  constructor(private reflector: Reflector) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const deprecation = this.reflector.get('deprecated', context.getHandler());
    if (!deprecation) return next.handle();

    return next.handle().pipe(
      tap(() => {
        const response = context.switchToHttp().getResponse();
        response.setHeader('Deprecation', 'true');
        response.setHeader('Sunset', deprecation.sunsetDate);
        if (deprecation.successor) {
          response.setHeader('Link', `<${deprecation.successor}>; rel="successor-version"`);
        }
      }),
    );
  }
}

// Usage
@Get('v1/workspaces')
@Deprecated('2025-06-01', '/v2/workspaces')
getWorkspacesV1() {
  return this.workspaceService.findAll();
}
```

### Step 4: Expand-Contract Pattern for API Fields

When a field MUST be renamed or restructured:

```typescript
// Phase 1 - EXPAND: Add new field alongside old field
// Both old and new consumers work
@Get(':id')
async getUser(@Param('id') id: string) {
  const user = await this.userService.findById(id);
  return {
    success: true,
    data: {
      name: user.displayName,         // OLD field (kept for compatibility)
      displayName: user.displayName,  // NEW field (preferred)
    },
  };
}

// Phase 2 - MIGRATE: Notify consumers to switch
// Log usage of old field to track migration progress
// Add deprecation warning in API docs and headers

// Phase 3 - CONTRACT: Remove old field after sunset date
// Only after confirming zero usage of old field in logs
```

### Step 5: Database Schema Backward Compatibility

For blue-green deployments, the old app version and new app version run simultaneously. Schema changes MUST be compatible with both.

```sql
-- SAFE: Add nullable column (old code ignores it, new code uses it)
ALTER TABLE workspaces ADD COLUMN description TEXT;

-- SAFE: Add column with default (old code ignores it)
ALTER TABLE workspaces ADD COLUMN is_archived BOOLEAN DEFAULT false;

-- UNSAFE: Rename column (old code breaks)
-- Instead, use expand-contract:

-- Step 1: Add new column
ALTER TABLE workspaces ADD COLUMN display_name TEXT;

-- Step 2: Backfill data
UPDATE workspaces SET display_name = name;

-- Step 3: Deploy app that reads from BOTH columns
-- Step 4: Deploy app that writes to BOTH columns
-- Step 5: Deploy app that reads from NEW column only
-- Step 6: Drop old column (after confirming no reads)
ALTER TABLE workspaces DROP COLUMN name;
```

```typescript
// Prisma migration strategy for expand-contract
// migration-1: Add new column (deployed with old app code running)
// migration-2: Backfill (run as separate script, not in deploy)
// migration-3: Drop old column (only after full cutover)

// Service handles both columns during transition
@Injectable()
export class WorkspaceService {
  async findById(id: string) {
    const ws = await this.prisma.workspace.findUnique({ where: { id } });
    return {
      ...ws,
      // Read from new column, fall back to old
      displayName: ws.displayName ?? ws.name,
    };
  }

  async update(id: string, dto: UpdateWorkspaceDto) {
    return this.prisma.workspace.update({
      where: { id },
      data: {
        name: dto.displayName,         // Write to old column (compat)
        displayName: dto.displayName,  // Write to new column
      },
    });
  }
}
```

### Step 6: Consumer-Driven Contract Testing

```typescript
// Use Pact to let consumers define what they expect from your API
// consumer.pact.spec.ts (in consumer's repo)
import { PactV3 } from '@pact-foundation/pact';

const provider = new PactV3({
  consumer: 'FrontendApp',
  provider: 'WorkspaceAPI',
});

describe('Workspace API Contract', () => {
  it('returns workspace with required fields', async () => {
    provider
      .given('workspace exists')
      .uponReceiving('a request for a workspace')
      .withRequest({ method: 'GET', path: '/workspaces/uuid-1' })
      .willRespondWith({
        status: 200,
        body: {
          success: true,
          data: {
            id: like('uuid-1'),
            name: like('My Workspace'),
            createdAt: like('2025-01-01T00:00:00Z'),
          },
        },
      });

    await provider.executeTest(async (mockServer) => {
      const response = await fetch(`${mockServer.url}/workspaces/uuid-1`);
      const data = await response.json();
      expect(data.success).toBe(true);
      expect(data.data.id).toBeDefined();
    });
  });
});
```

### Step 7: API Changelog Communication

```markdown
<!-- docs/api-changelog.md -->
## API Changelog

### 2025-03-15
- **Added**: `description` field to GET /workspaces/:id response
- **Added**: `memberCount` field to GET /workspaces/:id response
- **Deprecated**: `name` field in favor of `displayName` (sunset: 2025-06-01)

### 2025-02-01
- **Added**: POST /workspaces/:id/archive endpoint
```

---

## CHECKLIST

- [ ] Change classified as breaking or non-breaking before implementation
- [ ] New response fields are additive (old consumers unaffected)
- [ ] Deprecated endpoints have Sunset and Deprecation headers
- [ ] Database migrations follow expand-contract for column renames/removals
- [ ] Blue-green deployment tested: old app works with new schema
- [ ] Consumer contract tests validate critical API shapes
- [ ] API changelog updated with every change
- [ ] Old field usage logged to track migration progress before removal
- [ ] Sunset date enforced: remove deprecated code on schedule
