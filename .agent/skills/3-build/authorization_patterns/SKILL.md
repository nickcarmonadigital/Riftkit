---
name: Authorization Patterns
description: Implement RBAC, ABAC, and ownership-based authorization with NestJS guards and policy services.
---

# Authorization Patterns Skill

**Purpose**: Provide a structured approach to authorization beyond simple authentication. Covers the decision between RBAC, ABAC, and ReBAC, implements ownership guards, centralizes policy logic, handles multi-tenant authorization, and ensures every endpoint has a documented authorization rule.

## TRIGGER COMMANDS

```text
"Add ownership check for [resource]"
"Can user access [resource]?"
"Authorization patterns"
```

## When to Use
- Building endpoints that need more than "is the user logged in?"
- Users should only access their own resources (ownership)
- Different user roles have different capabilities
- Multi-tenant system where tenants must be isolated
- Compliance requires documented access control policies

---

## PROCESS

### Step 1: Choose Authorization Model

| Model | Best For | Complexity | Example |
|-------|----------|------------|---------|
| RBAC | Fixed roles, simple apps | Low | Admin, Editor, Viewer |
| ABAC | Dynamic rules, context-dependent | Medium | "Owner AND created < 24h ago" |
| ReBAC | Social/graph relationships | High | "Member of team that owns project" |

Decision guide:
- Start with RBAC. Upgrade to ABAC only when RBAC rules become unwieldy.
- Use ReBAC when authorization depends on graph relationships (teams, organizations).

### Step 2: Role-Based Access Control (RBAC)

```typescript
// auth/roles.decorator.ts
import { SetMetadata } from '@nestjs/common';

export enum Role {
  ADMIN = 'admin',
  EDITOR = 'editor',
  VIEWER = 'viewer',
}

export const Roles = (...roles: Role[]) => SetMetadata('roles', roles);
```

```typescript
// auth/roles.guard.ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from './roles.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<Role[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) return true;

    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.some((role) => user.roles?.includes(role));
  }
}

// Usage
@Controller('settings')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SettingsController {
  @Patch()
  @Roles(Role.ADMIN)
  updateSettings(@Body() dto: UpdateSettingsDto) {
    return this.settingsService.update(dto);
  }
}
```

### Step 3: Ownership-Based Authorization

```typescript
// auth/ownership.guard.ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../prisma/prisma.service';

export const CheckOwnership = (model: string, paramKey = 'id') =>
  SetMetadata('ownership', { model, paramKey });

@Injectable()
export class OwnershipGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const config = this.reflector.get<{ model: string; paramKey: string }>(
      'ownership',
      context.getHandler(),
    );

    if (!config) return true;

    const request = context.switchToHttp().getRequest();
    const userId = request.user.sub;
    const resourceId = request.params[config.paramKey];

    // Dynamic Prisma model lookup
    const resource = await (this.prisma[config.model] as any).findUnique({
      where: { id: resourceId },
      select: { ownerId: true },
    });

    if (!resource) return false;
    return resource.ownerId === userId;
  }
}

// Usage
@Controller('workspaces')
@UseGuards(JwtAuthGuard, OwnershipGuard)
export class WorkspaceController {
  @Patch(':id')
  @CheckOwnership('workspace')
  update(
    @Param('id') id: string,
    @Body() dto: UpdateWorkspaceDto,
    @CurrentUser() user: UserPayload,
  ) {
    return this.workspaceService.update(id, dto);
  }
}
```

### Step 4: Policy Service Pattern (Centralized Logic)

```typescript
// auth/policy.service.ts
@Injectable()
export class PolicyService {
  constructor(private prisma: PrismaService) {}

  async canAccessResource(
    userId: string,
    resourceType: string,
    resourceId: string,
    action: 'read' | 'write' | 'delete',
  ): Promise<boolean> {
    // 1. Check if user is admin (bypass)
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { roles: true },
    });
    if (user?.roles.includes('admin')) return true;

    // 2. Check direct ownership
    const resource = await this.getResource(resourceType, resourceId);
    if (resource?.ownerId === userId) return true;

    // 3. Check team membership (ReBAC)
    if (resource?.teamId) {
      const membership = await this.prisma.teamMember.findFirst({
        where: { teamId: resource.teamId, userId },
      });

      if (!membership) return false;

      // Role within team determines action permission
      const teamPermissions: Record<string, string[]> = {
        owner: ['read', 'write', 'delete'],
        editor: ['read', 'write'],
        viewer: ['read'],
      };

      return teamPermissions[membership.role]?.includes(action) ?? false;
    }

    return false;
  }

  private async getResource(type: string, id: string) {
    return (this.prisma[type] as any).findUnique({
      where: { id },
      select: { ownerId: true, teamId: true },
    });
  }
}
```

### Step 5: Multi-Tenant Authorization

```typescript
// auth/tenant.guard.ts
@Injectable()
export class TenantGuard implements CanActivate {
  constructor(private prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user.sub;
    const tenantId = request.headers['x-tenant-id'] || request.params.tenantId;

    if (!tenantId) return false;

    // Verify user belongs to this tenant
    const membership = await this.prisma.tenantMember.findFirst({
      where: { tenantId, userId, status: 'active' },
    });

    if (!membership) return false;

    // Attach tenant context to request for downstream use
    request.tenantId = tenantId;
    request.tenantRole = membership.role;

    return true;
  }
}

// Apply tenant scoping to all queries
@Injectable()
export class TenantScopedService {
  async findAll(tenantId: string) {
    // ALWAYS include tenantId in WHERE clause
    return this.prisma.project.findMany({
      where: { tenantId },  // Tenant isolation
    });
  }
}
```

### Step 6: Guard Composition Order

```typescript
// Guards execute in order. The correct sequence is:
@Controller('projects')
@UseGuards(
  JwtAuthGuard,       // 1. Is the user authenticated?
  TenantGuard,        // 2. Does the user belong to this tenant?
  RolesGuard,         // 3. Does the user have the required role?
  OwnershipGuard,     // 4. Does the user own this specific resource?
)
export class ProjectController {}
```

### Step 7: Authorization Audit Logging

```typescript
// auth/auth-audit.interceptor.ts
@Injectable()
export class AuthAuditInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url, user, params } = request;

    return next.handle().pipe(
      tap(() => {
        this.logger.log({
          event: 'authorization.granted',
          userId: user?.sub,
          method,
          resource: url,
          resourceId: params?.id,
        });
      }),
      catchError((err) => {
        if (err.status === 403) {
          this.logger.warn({
            event: 'authorization.denied',
            userId: user?.sub,
            method,
            resource: url,
            resourceId: params?.id,
          });
        }
        throw err;
      }),
    );
  }
}
```

---

## CHECKLIST

- [ ] Authorization model chosen (RBAC/ABAC/ReBAC) with documented rationale
- [ ] Every endpoint has `@UseGuards()` with appropriate guards
- [ ] Ownership check implemented for user-owned resources
- [ ] Policy service centralizes complex authorization logic
- [ ] Multi-tenant isolation enforced at query level (tenantId in every WHERE)
- [ ] Guard execution order is correct (auth -> tenant -> role -> ownership)
- [ ] Authorization denials return 403 (not 404) with audit logging
- [ ] Admin bypass is explicit and logged
- [ ] WebSocket gateways have equivalent authorization checks
