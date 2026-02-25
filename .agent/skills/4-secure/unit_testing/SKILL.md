---
name: unit_testing
description: Jest/Vitest unit test patterns for NestJS services and React components
---

# Unit Testing Skill

**Purpose**: Generate robust, maintainable unit tests for NestJS backend services and React frontend components using Jest and Vitest with proper mocking strategies and coverage targets.

## 🎯 TRIGGER COMMANDS

```text
"write unit tests for this service"
"add test coverage for [module]"
"test this service"
"generate unit tests"
"create spec file for [component/service]"
"Using unit_testing skill: test [target]"
```

## 📁 File Naming & Structure

| Context | Convention | Example |
|---------|-----------|---------|
| NestJS service | `*.spec.ts` | `auth.service.spec.ts` |
| NestJS controller | `*.spec.ts` | `auth.controller.spec.ts` |
| React component | `*.test.tsx` | `Dashboard.test.tsx` |
| React hook | `*.test.ts` | `useAuth.test.ts` |
| Utility function | `*.spec.ts` or `*.test.ts` | `formatCurrency.spec.ts` |
| Test placement | Co-located next to source | `src/auth/auth.service.spec.ts` |

## 🏗️ Test Structure Pattern (AAA)

Every test should follow the **Arrange-Act-Assert** pattern inside a `describe`/`it` block:

```typescript
describe('AuthService', () => {
  // Shared setup (Arrange at suite level)
  let service: AuthService;
  let prisma: DeepMockProxy<PrismaService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockDeep<PrismaService>() },
      ],
    }).compile();

    service = module.get(AuthService);
    prisma = module.get(PrismaService);
  });

  describe('validateUser', () => {
    it('should return user when credentials are valid', async () => {
      // Arrange
      const mockUser = { id: 'uuid-1', email: 'test@example.com', password: hashedPassword };
      prisma.user.findUnique.mockResolvedValue(mockUser);

      // Act
      const result = await service.validateUser('test@example.com', 'password123');

      // Assert
      expect(result).toBeDefined();
      expect(result.email).toBe('test@example.com');
    });

    it('should throw UnauthorizedException when user not found', async () => {
      // Arrange
      prisma.user.findUnique.mockResolvedValue(null);

      // Act & Assert
      await expect(service.validateUser('bad@email.com', 'pass'))
        .rejects.toThrow(UnauthorizedException);
    });
  });
});
```

## 🧪 NestJS Service Testing

### Full Service Test Example with Mock Prisma

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentService } from './document.service';
import { NotFoundException, ForbiddenException } from '@nestjs/common';

describe('DocumentService', () => {
  let service: DocumentService;
  let prisma: DeepMockProxy<PrismaService>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DocumentService,
        { provide: PrismaService, useValue: mockDeep<PrismaService>() },
      ],
    }).compile();

    service = module.get<DocumentService>(DocumentService);
    prisma = module.get(PrismaService) as DeepMockProxy<PrismaService>;
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findById', () => {
    const orgId = 'org-uuid-1';
    const docId = 'doc-uuid-1';

    it('should return document when found and user has access', async () => {
      const mockDoc = {
        id: docId,
        title: 'Test Doc',
        orgId,
        content: 'Hello world',
        createdAt: new Date(),
        updatedAt: new Date(),
      };
      prisma.document.findFirst.mockResolvedValue(mockDoc);

      const result = await service.findById(docId, orgId);

      expect(result).toEqual(mockDoc);
      expect(prisma.document.findFirst).toHaveBeenCalledWith({
        where: { id: docId, orgId },
      });
    });

    it('should throw NotFoundException when document does not exist', async () => {
      prisma.document.findFirst.mockResolvedValue(null);

      await expect(service.findById(docId, orgId))
        .rejects.toThrow(NotFoundException);
    });

    it('should not return documents from other organizations', async () => {
      prisma.document.findFirst.mockResolvedValue(null);

      await expect(service.findById(docId, 'other-org-id'))
        .rejects.toThrow(NotFoundException);

      expect(prisma.document.findFirst).toHaveBeenCalledWith({
        where: { id: docId, orgId: 'other-org-id' },
      });
    });
  });

  describe('create', () => {
    it('should create a document with correct orgId', async () => {
      const input = { title: 'New Doc', content: 'Content here' };
      const orgId = 'org-uuid-1';
      const expected = { id: 'new-uuid', ...input, orgId, createdAt: new Date(), updatedAt: new Date() };

      prisma.document.create.mockResolvedValue(expected);

      const result = await service.create(input, orgId);

      expect(result.orgId).toBe(orgId);
      expect(prisma.document.create).toHaveBeenCalledWith({
        data: { ...input, orgId },
      });
    });
  });
});
```

### Testing Services with AIProviderFactory

```typescript
import { AIProviderFactory } from '../providers/ai-provider.factory';

describe('SummaryService', () => {
  let service: SummaryService;
  let aiFactory: jest.Mocked<AIProviderFactory>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        SummaryService,
        {
          provide: AIProviderFactory,
          useValue: {
            getProvider: jest.fn().mockReturnValue({
              generateText: jest.fn().mockResolvedValue({
                text: 'Mocked summary output',
                usage: { promptTokens: 100, completionTokens: 50 },
              }),
            }),
          },
        },
      ],
    }).compile();

    service = module.get(SummaryService);
    aiFactory = module.get(AIProviderFactory);
  });

  it('should generate summary using the configured AI provider', async () => {
    const result = await service.summarize('Long document text...');

    expect(result.summary).toBe('Mocked summary output');
    expect(aiFactory.getProvider).toHaveBeenCalled();
  });
});
```

## ⚛️ React Component Testing (Vitest + Testing Library)

### Component Render Test

```typescript
import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { BrowserRouter } from 'react-router-dom';
import { Dashboard } from './Dashboard';
import { useAuth } from '@/hooks/useAuth';

// Mock the hook
vi.mock('@/hooks/useAuth', () => ({
  useAuth: vi.fn(),
}));

const renderWithRouter = (ui: React.ReactElement) =>
  render(<BrowserRouter>{ui}</BrowserRouter>);

describe('Dashboard', () => {
  beforeEach(() => {
    vi.mocked(useAuth).mockReturnValue({
      user: { id: '1', email: 'test@example.com', orgId: 'org-1' },
      isAuthenticated: true,
      logout: vi.fn(),
    });
  });

  it('should render the welcome message with user email', () => {
    renderWithRouter(<Dashboard />);

    expect(screen.getByText(/welcome/i)).toBeInTheDocument();
    expect(screen.getByText('test@example.com')).toBeInTheDocument();
  });

  it('should call logout when logout button is clicked', async () => {
    const mockLogout = vi.fn();
    vi.mocked(useAuth).mockReturnValue({
      user: { id: '1', email: 'test@example.com', orgId: 'org-1' },
      isAuthenticated: true,
      logout: mockLogout,
    });

    renderWithRouter(<Dashboard />);

    await userEvent.click(screen.getByRole('button', { name: /logout/i }));

    expect(mockLogout).toHaveBeenCalledOnce();
  });

  it('should show loading skeleton when data is fetching', () => {
    renderWithRouter(<Dashboard loading={true} />);

    expect(screen.getByTestId('dashboard-skeleton')).toBeInTheDocument();
  });
});
```

### React Hook Test with renderHook

```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, act, waitFor } from '@testing-library/react';
import { useDebounce } from '@/hooks/useDebounce';

describe('useDebounce', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('should return initial value immediately', () => {
    const { result } = renderHook(() => useDebounce('hello', 500));
    expect(result.current).toBe('hello');
  });

  it('should debounce value changes', () => {
    const { result, rerender } = renderHook(
      ({ value, delay }) => useDebounce(value, delay),
      { initialProps: { value: 'hello', delay: 500 } },
    );

    rerender({ value: 'world', delay: 500 });

    // Value should not have changed yet
    expect(result.current).toBe('hello');

    // Fast-forward past debounce delay
    act(() => {
      vi.advanceTimersByTime(500);
    });

    expect(result.current).toBe('world');
  });
});
```

## 🎭 Mocking Strategies

| Strategy | When to Use | Example |
|----------|------------|---------|
| `jest.mock()` / `vi.mock()` | Module-level mocking | External APIs, file system |
| `mockDeep<T>()` | Deep Prisma mocks | `mockDeep<PrismaService>()` |
| DI override | NestJS provider replacement | `{ provide: Service, useValue: mock }` |
| `jest.spyOn()` / `vi.spyOn()` | Partial mock of real object | Spy on one method, keep rest real |
| Manual mock | Complex mock with state | `__mocks__/` directory files |
| `jest.fn()` / `vi.fn()` | Inline simple mocks | Callback arguments |

> [!WARNING]
> Never mock what you don't own unless necessary. Prefer testing through the public API of your modules. Over-mocking makes tests brittle and can hide real bugs.

## 📊 Coverage Targets

| Module Category | Target | Rationale |
|----------------|--------|-----------|
| Auth / Security | 90%+ | Critical path, security-sensitive |
| Billing / Payments | 90%+ | Financial accuracy required |
| AI Provider Factory | 85%+ | Core infrastructure |
| CRUD Services | 80%+ | Standard business logic |
| Controllers | 70%+ | Thin layer, mostly delegation |
| React Components | 75%+ | UI logic and user interactions |
| Utility Functions | 95%+ | Pure functions, easy to test |

> [!TIP]
> Focus on **meaningful** coverage. 100% line coverage with no assertions is worse than 80% coverage with strong assertions. Test behavior, not implementation.

## 🚫 What NOT to Test

- **Framework internals**: Don't test that NestJS DI works or React renders JSX
- **Third-party libraries**: Don't test that `bcrypt.hash()` hashes correctly
- **Type definitions**: TypeScript types are compile-time checks, not runtime
- **Simple getters/setters**: No logic to test
- **Prisma query syntax**: Test your service logic, not that Prisma generates SQL
- **Static configuration**: Module metadata, route definitions

## 🔥 Edge Cases to Always Cover

```typescript
describe('edge cases', () => {
  it('should handle null input gracefully', async () => {
    await expect(service.process(null as any)).rejects.toThrow();
  });

  it('should handle empty arrays', async () => {
    const result = await service.processItems([]);
    expect(result).toEqual([]);
  });

  it('should handle permission denied', async () => {
    prisma.resource.findFirst.mockResolvedValue(null); // org-scoped query returns nothing
    await expect(service.getResource('id', 'wrong-org'))
      .rejects.toThrow(NotFoundException);
  });

  it('should handle network/database errors', async () => {
    prisma.user.findUnique.mockRejectedValue(new Error('Connection refused'));
    await expect(service.findUser('id'))
      .rejects.toThrow('Connection refused');
  });

  it('should handle duplicate entries', async () => {
    prisma.user.create.mockRejectedValue({ code: 'P2002', meta: { target: ['email'] } });
    await expect(service.createUser({ email: 'dup@test.com' }))
      .rejects.toThrow(ConflictException);
  });

  it('should handle extremely long strings', async () => {
    const longTitle = 'A'.repeat(10000);
    await expect(service.create({ title: longTitle }))
      .rejects.toThrow(); // validation should catch this
  });
});
```

---

## Agent Automation

> Use the **tdd-guide** agent (`.agent/agents/tdd-guide.md`) for test-driven development guidance.
> Invoke via: `/tdd`

### RED-GREEN-REFACTOR Workflow

1. **RED**: Write a failing test that describes the desired behavior
2. **GREEN**: Write the minimum code to make the test pass
3. **REFACTOR**: Clean up while keeping tests green

### TDD Rules
- Never write production code without a failing test
- Write only enough test to fail
- Write only enough code to pass

### TDD Step-by-Step Process

```
Step 1: Write User Journey
  "As a [role], I want to [action], so that [benefit]"

Step 2: Generate Test Cases
  - Happy path
  - Edge cases (null, empty, boundary values)
  - Error scenarios
  - Fallback behavior

Step 3: Run Tests (They Should FAIL)
  npm test  →  RED

Step 4: Implement Minimum Code
  Write just enough to make the tests pass

Step 5: Run Tests (They Should PASS)
  npm test  →  GREEN

Step 6: Refactor
  - Remove duplication
  - Improve naming
  - Optimize performance
  - Keep tests green throughout

Step 7: Verify Coverage
  npm run test:coverage  →  80%+ required
```

### Coverage Thresholds Configuration

```json
{
  "jest": {
    "coverageThresholds": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```

### Common Testing Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|-----------------|
| Testing implementation details | Brittle, breaks on refactor | Test user-visible behavior |
| Tests depend on each other | Order-dependent failures | Each test creates its own data |
| Arbitrary `waitForTimeout` | Flaky, slow | Use `vi.useFakeTimers()` or `waitFor` |
| Brittle CSS selectors | Break on style changes | Use `getByRole`, `getByTestId` |
| No test isolation | State leaks between tests | `beforeEach` setup, `afterEach` cleanup |

### Continuous Testing Integration

```bash
# Watch mode during development (re-runs on file change)
npm test -- --watch

# Pre-commit hook
npm test && npm run lint

# CI/CD pipeline
- name: Run Tests
  run: npm test -- --coverage
- name: Upload Coverage
  uses: codecov/codecov-action@v3
```

---

## ✅ EXIT CHECKLIST

- [ ] All tests pass (`npm test` / `npx vitest run` exits clean)
- [ ] Coverage meets module-specific target (see coverage table above)
- [ ] No flaky tests (run suite 3x, all pass consistently)
- [ ] Mocks are cleaned up (afterEach with `jest.clearAllMocks()` or `vi.clearAllMocks()`)
- [ ] Each test is independent (can run in any order, no shared mutable state)
- [ ] Test names clearly describe the expected behavior
- [ ] Edge cases covered: null inputs, empty collections, auth failures, network errors
- [ ] No `console.log` left in test files
- [ ] No hardcoded timeouts (use `vi.useFakeTimers()` instead)
- [ ] Tests run in under 30 seconds total for the module
- [ ] TDD workflow followed: RED -> GREEN -> REFACTOR
- [ ] Coverage thresholds configured and enforced in CI

*Skill Version: 1.1 | Updated: February 2026 | Merged with ECC tdd-workflow*
