# Unit Test Patterns Reference

**Purpose**: Reusable testing patterns for NestJS backend and React frontend projects.

---

## 1. NestJS Service Testing

### Basic Service Test Structure

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { ContactsService } from './contacts.service';
import { PrismaService } from '../prisma/prisma.service';

describe('ContactsService', () => {
  let service: ContactsService;
  let prisma: PrismaService;

  const mockPrisma = {
    contact: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ContactsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ContactsService>(ContactsService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  describe('findAll', () => {
    it('should return contacts scoped to org', async () => {
      const expected = [{ id: '1', name: 'Test Contact' }];
      mockPrisma.contact.findMany.mockResolvedValue(expected);

      const result = await service.findAll('org-123');

      expect(mockPrisma.contact.findMany).toHaveBeenCalledWith(
        expect.objectContaining({ where: { orgId: 'org-123' } }),
      );
      expect(result).toEqual(expected);
    });

    it('should throw on database error', async () => {
      mockPrisma.contact.findMany.mockRejectedValue(new Error('DB down'));
      await expect(service.findAll('org-123')).rejects.toThrow('DB down');
    });
  });
});
```

---

## 2. React Component Testing

### Basic Component Test with @testing-library/react

```typescript
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { LoginForm } from './LoginForm';
import { vi } from 'vitest';

describe('LoginForm', () => {
  const mockOnSubmit = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('renders email and password fields', () => {
    render(<LoginForm onSubmit={mockOnSubmit} />);

    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
  });

  it('calls onSubmit with form data', async () => {
    const user = userEvent.setup();
    render(<LoginForm onSubmit={mockOnSubmit} />);

    await user.type(screen.getByLabelText(/email/i), 'test@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      });
    });
  });

  it('shows validation error for empty email', async () => {
    const user = userEvent.setup();
    render(<LoginForm onSubmit={mockOnSubmit} />);

    await user.click(screen.getByRole('button', { name: /sign in/i }));

    expect(await screen.findByText(/email is required/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });
});
```

---

## 3. Mocking Patterns

### DI Mock (NestJS — preferred)

```typescript
// Provide a mock implementation via the DI container
{ provide: AIProviderFactory, useValue: { getProvider: jest.fn() } }
{ provide: PrismaService, useValue: mockPrisma }
{ provide: ConfigService, useValue: { get: jest.fn((key) => configMap[key]) } }
```

### jest.mock / vi.mock (module-level)

```typescript
// Jest
jest.mock('../utils/stripe', () => ({
  createCheckoutSession: jest.fn().mockResolvedValue({ url: 'https://checkout' }),
}));

// Vitest
vi.mock('../api/client', () => ({
  apiClient: { get: vi.fn(), post: vi.fn() },
}));
```

### Manual Mock (__mocks__ directory)

```
src/
  services/
    __mocks__/
      email.service.ts    ← auto-used when jest.mock('./email.service')
    email.service.ts
```

---

## 4. Test Utility Helpers

```typescript
// test/helpers.ts — shared across all test files

export function createMockUser(overrides?: Partial<User>): User {
  return {
    id: 'user-001',
    email: 'test@example.com',
    name: 'Test User',
    orgId: 'org-001',
    role: 'MEMBER',
    createdAt: new Date('2026-01-01'),
    ...overrides,
  };
}

export function createMockOrg(overrides?: Partial<Organization>): Organization {
  return {
    id: 'org-001',
    name: 'Test Organization',
    plan: 'PRO',
    createdAt: new Date('2026-01-01'),
    ...overrides,
  };
}

export function createMockRequest(user?: Partial<User>) {
  return { user: createMockUser(user) } as unknown as Request;
}
```

---

## 5. Coverage Configuration

### Jest (backend — jest config in package.json or jest.config.ts)

```json
{
  "collectCoverageFrom": [
    "src/**/*.service.ts",
    "src/**/*.controller.ts",
    "!src/**/*.module.ts",
    "!src/main.ts"
  ],
  "coverageThreshold": {
    "global": { "branches": 70, "functions": 80, "lines": 80, "statements": 80 }
  }
}
```

### Vitest (frontend — vitest.config.ts)

```typescript
export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      include: ['src/**/*.{ts,tsx}'],
      exclude: ['src/**/*.d.ts', 'src/main.tsx', 'src/vite-env.d.ts'],
      thresholds: { branches: 70, functions: 75, lines: 75, statements: 75 },
    },
  },
});
```

---

## 6. What to Test vs What NOT to Test

### Test These (high value)

| Category | Examples |
|----------|----------|
| Business logic | Price calculation, permission checks, data transformations |
| Edge cases | Empty arrays, null values, max lengths, boundary conditions |
| Error handling | Invalid input, missing records, network failures, auth failures |
| State transitions | Order status changes, workflow progressions |
| Security-sensitive | Auth, authorization, input validation, org-scoping |

### Skip These (low value)

| Category | Reason |
|----------|--------|
| Framework internals | NestJS module wiring, React rendering engine |
| Simple getters/setters | No logic to break |
| Auto-generated code | Prisma client, GraphQL codegen |
| Third-party libraries | Already tested by maintainers |
| CSS/styling | Use visual regression tools instead |

---

## 7. Testing Anti-Patterns to Avoid

- **Testing implementation details**: Don't assert that a private method was called; assert the public output.
- **Snapshot overuse**: Snapshots break on any change and train developers to blindly update them.
- **God test files**: Keep test files close to source. One test file per source file.
- **Skipping error paths**: If the code has a catch block, there should be a test for that catch.
- **Shared mutable state**: Use `beforeEach` to reset. Never rely on test execution order.
