---
name: Test Driven Build
description: Embed red-green-refactor into the Phase 3 implementation loop with minimum coverage gates.
---

# Test Driven Build Skill

**Purpose**: Bridge skill that activates TDD workflow within the Phase 3 build loop. Requires failing tests before implementation, enforces minimum coverage gates for spec_build completion, and ensures every feature ships with validated test coverage from the start.

## TRIGGER COMMANDS

```text
"Write tests as I build"
"TDD workflow during implementation"
"Test-first for [module]"
```

## When to Use
- Building a new module or feature in Phase 3
- spec_build gate requires passing tests alongside working code
- You want to prevent implementation drift from requirements
- Retrofitting tests is too expensive and you want tests from the start

---

## PROCESS

### Step 1: Extract Testable Requirements from Spec

Before writing any implementation, extract assertions from the spec or user story.

```typescript
// From spec: "Users can create a workspace with a name (3-50 chars)"
// Extract test cases:
// 1. Valid name creates workspace
// 2. Name under 3 chars is rejected
// 3. Name over 50 chars is rejected
// 4. Duplicate name for same user is rejected
// 5. Created workspace belongs to the requesting user
```

### Step 2: Write Failing Unit Tests (RED)

Write tests for the service layer first. These MUST fail before any implementation.

```typescript
// workspace.service.spec.ts
import { Test } from '@nestjs/testing';
import { WorkspaceService } from './workspace.service';
import { PrismaService } from '../prisma/prisma.service';
import { BadRequestException, ConflictException } from '@nestjs/common';

describe('WorkspaceService', () => {
  let service: WorkspaceService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        WorkspaceService,
        {
          provide: PrismaService,
          useValue: {
            workspace: {
              create: jest.fn(),
              findFirst: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get(WorkspaceService);
    prisma = module.get(PrismaService);
  });

  describe('create', () => {
    it('should create a workspace with valid name', async () => {
      const mockWorkspace = { id: 'uuid-1', name: 'My Workspace', ownerId: 'user-1' };
      jest.spyOn(prisma.workspace, 'findFirst').mockResolvedValue(null);
      jest.spyOn(prisma.workspace, 'create').mockResolvedValue(mockWorkspace);

      const result = await service.create('user-1', { name: 'My Workspace' });
      expect(result).toEqual(mockWorkspace);
    });

    it('should reject name shorter than 3 characters', async () => {
      await expect(service.create('user-1', { name: 'Ab' }))
        .rejects.toThrow(BadRequestException);
    });

    it('should reject name longer than 50 characters', async () => {
      const longName = 'A'.repeat(51);
      await expect(service.create('user-1', { name: longName }))
        .rejects.toThrow(BadRequestException);
    });

    it('should reject duplicate name for same user', async () => {
      jest.spyOn(prisma.workspace, 'findFirst').mockResolvedValue({ id: 'existing' } as any);
      await expect(service.create('user-1', { name: 'Existing' }))
        .rejects.toThrow(ConflictException);
    });
  });
});
```

Run the tests to confirm they fail:

```bash
npx jest workspace.service.spec.ts --no-coverage
# Expected: 4 tests, all FAIL (service does not exist yet)
```

### Step 3: Implement Minimum Code to Pass (GREEN)

Write only enough code to make the failing tests pass.

```typescript
// workspace.service.ts
import { Injectable, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateWorkspaceDto } from './dto/create-workspace.dto';

@Injectable()
export class WorkspaceService {
  constructor(private readonly prisma: PrismaService) {}

  async create(userId: string, dto: CreateWorkspaceDto) {
    if (dto.name.length < 3 || dto.name.length > 50) {
      throw new BadRequestException('Name must be between 3 and 50 characters');
    }

    const existing = await this.prisma.workspace.findFirst({
      where: { name: dto.name, ownerId: userId },
    });

    if (existing) {
      throw new ConflictException('Workspace with this name already exists');
    }

    return this.prisma.workspace.create({
      data: { name: dto.name, ownerId: userId },
    });
  }
}
```

### Step 4: Write Integration Tests for Controllers

After the service passes, write controller-level integration tests.

```typescript
// workspace.controller.spec.ts
import { Test } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { WorkspaceModule } from './workspace.module';
import { PrismaService } from '../prisma/prisma.service';

describe('WorkspaceController (integration)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const module = await Test.createTestingModule({
      imports: [WorkspaceModule],
    })
      .overrideProvider(PrismaService)
      .useValue(mockPrisma)
      .compile();

    app = module.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
    await app.init();
  });

  it('POST /workspaces returns 201 with valid data', () => {
    return request(app.getHttpServer())
      .post('/workspaces')
      .send({ name: 'Test Workspace' })
      .expect(201)
      .expect((res) => {
        expect(res.body.success).toBe(true);
        expect(res.body.data.name).toBe('Test Workspace');
      });
  });

  it('POST /workspaces returns 400 with short name', () => {
    return request(app.getHttpServer())
      .post('/workspaces')
      .send({ name: 'Ab' })
      .expect(400);
  });

  afterAll(() => app.close());
});
```

### Step 5: Refactor with Test Safety Net (REFACTOR)

With green tests, refactor the implementation. Tests protect against regressions.

```typescript
// Extract validation to a reusable decorator or pipe
// workspace.validation.ts
export class WorkspaceNamePipe implements PipeTransform {
  transform(value: CreateWorkspaceDto) {
    if (value.name.length < 3 || value.name.length > 50) {
      throw new BadRequestException('Name must be between 3 and 50 characters');
    }
    return value;
  }
}
```

Run the full suite after refactoring to confirm nothing broke.

### Step 6: Enforce Coverage Gates

Configure minimum coverage thresholds in `jest.config.ts`:

```typescript
// jest.config.ts
export default {
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  collectCoverageFrom: [
    'src/**/*.service.ts',
    'src/**/*.controller.ts',
    '!src/**/*.module.ts',
    '!src/main.ts',
  ],
};
```

### Step 7: spec_build Gate Verification

The spec_build gate condition becomes: "Feature builds AND all tests pass."

```bash
# Gate check script (run before marking spec_build complete)
npm run build && npm run test -- --coverage --passWithNoTests=false
# Both commands must exit 0
```

---

## CHECKLIST

- [ ] Testable requirements extracted from spec before coding
- [ ] Failing unit tests written for service layer (RED confirmed)
- [ ] Minimum implementation passes all tests (GREEN confirmed)
- [ ] Integration tests written for controller endpoints
- [ ] Refactoring done with passing test safety net
- [ ] Coverage thresholds configured (minimum 80% lines for services)
- [ ] spec_build gate includes "all tests pass" condition
- [ ] No test uses `.skip()` or `.todo()` without a tracked issue
