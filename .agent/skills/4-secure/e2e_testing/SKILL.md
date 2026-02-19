---
name: e2e_testing
description: End-to-end testing with Playwright for full-stack NestJS + React applications
---

# End-to-End (E2E) Testing Skill

**Purpose**: Test the *system*, not just the code. Ensure that a user can actually accomplish their goals (Sign up, Buy, Post) across the full stack — browser, frontend, API, database.

> [!TIP]
> **Pyramid Rule**: E2E tests are slow and expensive. Have FEW E2E tests, MANY unit tests. Only test value-critical paths.

## 🎯 TRIGGER COMMANDS

```text
"Write E2E test for [flow]"
"Test the [feature] user journey"
"Setup Playwright for [app]"
"Add E2E tests to CI"
"Using e2e_testing skill: verify [scenario]"
```

## When to Use

- Testing critical user flows (auth, checkout, core feature)
- Verifying frontend + backend integration works end-to-end
- Setting up Playwright in a new project
- Adding E2E tests to CI/CD pipeline
- Debugging flaky E2E tests

---

## PART 1: WHAT TO TEST (Critical Paths Only)

Do not test every button click. Test the **"Money Flows"** and **"Trust Flows"**.

```
MUST test (breaks = revenue loss or security issue):
├── Auth: Sign up, Log in, Password Reset, Logout
├── Core Value: The main thing your app does
├── Conversion: Checkout, Payment, Subscription
└── Destructive: Delete account, Remove data

SHOULD test (breaks = bad user experience):
├── Navigation: Can users reach key pages?
├── Search: Does search return results?
└── Forms: Do complex forms submit correctly?

DON'T test (unit/integration tests cover these):
├── Individual component rendering
├── API response formats
├── CSS styling (unless design system)
└── Third-party service behavior
```

---

## PART 2: PLAYWRIGHT SETUP

### Installation

```bash
# Install Playwright
npm init playwright@latest

# Or add to existing project
npm install -D @playwright/test
npx playwright install  # Downloads browser binaries
```

### Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  timeout: 30_000,           // 30s per test
  expect: { timeout: 5_000 }, // 5s for assertions
  fullyParallel: true,
  forbidOnly: !!process.env.CI,  // Fail if .only left in CI
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['list'],
  ],

  use: {
    baseURL: 'http://localhost:5173',
    trace: 'on-first-retry',      // Capture trace on failure
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    // Run auth setup before other tests
    { name: 'setup', testMatch: /.*\.setup\.ts/ },

    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
      dependencies: ['setup'],
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
      dependencies: ['setup'],
    },
    {
      name: 'mobile',
      use: { ...devices['iPhone 14'] },
      dependencies: ['setup'],
    },
  ],

  // Start dev server before tests
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:5173',
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
```

### Project Structure

```
e2e/
├── playwright.config.ts
├── fixtures/
│   ├── test-fixtures.ts      # Custom fixtures (authenticated page, etc.)
│   └── test-data.ts           # Test user credentials, seed data
├── pages/                     # Page Object Models
│   ├── base.page.ts
│   ├── login.page.ts
│   ├── dashboard.page.ts
│   └── settings.page.ts
├── tests/
│   ├── auth.spec.ts
│   ├── dashboard.spec.ts
│   └── settings.spec.ts
└── auth.setup.ts              # Auth state setup (runs once)
```

---

## PART 3: TEST STRUCTURE (AAA Pattern)

Every test follows **Arrange → Act → Assert**.

```typescript
import { test, expect } from '@playwright/test';

test.describe('Project Management', () => {
  test('user can create a new project', async ({ page }) => {
    // ARRANGE — Navigate to the starting point
    await page.goto('/dashboard');

    // ACT — Perform the user action
    await page.getByRole('button', { name: 'New Project' }).click();
    await page.getByLabel('Project Name').fill('My E2E Project');
    await page.getByLabel('Description').fill('Created by Playwright');
    await page.getByRole('button', { name: 'Create' }).click();

    // ASSERT — Verify the outcome
    await expect(page.getByText('Project created')).toBeVisible();
    await expect(page).toHaveURL(/\/projects\/[\w-]+/);
    await expect(page.getByRole('heading')).toHaveText('My E2E Project');
  });

  test('user can delete a project', async ({ page }) => {
    // ARRANGE
    await page.goto('/projects/test-project-id');

    // ACT
    await page.getByRole('button', { name: 'Settings' }).click();
    await page.getByRole('button', { name: 'Delete Project' }).click();
    await page.getByRole('button', { name: 'Confirm Delete' }).click();

    // ASSERT
    await expect(page).toHaveURL('/dashboard');
    await expect(page.getByText('test-project-id')).not.toBeVisible();
  });
});
```

---

## PART 4: PAGE OBJECT MODEL

Encapsulate page interactions so tests read like user stories.

### Base Page

```typescript
// e2e/pages/base.page.ts
import { Page, Locator } from '@playwright/test';

export class BasePage {
  constructor(protected page: Page) {}

  async waitForPageLoad() {
    await this.page.waitForLoadState('networkidle');
  }

  async getToast(): Promise<Locator> {
    return this.page.locator('[data-testid="toast"]');
  }

  async expectToast(message: string) {
    const toast = this.page.locator('[data-testid="toast"]');
    await expect(toast).toContainText(message);
  }
}
```

### Login Page

```typescript
// e2e/pages/login.page.ts
import { Page, expect } from '@playwright/test';
import { BasePage } from './base.page';

export class LoginPage extends BasePage {
  private emailInput = this.page.getByLabel('Email');
  private passwordInput = this.page.getByLabel('Password');
  private submitButton = this.page.getByRole('button', { name: 'Sign In' });
  private errorMessage = this.page.getByTestId('login-error');

  constructor(page: Page) {
    super(page);
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectLoginSuccess() {
    await expect(this.page).toHaveURL('/dashboard');
  }

  async expectLoginError(message: string) {
    await expect(this.errorMessage).toHaveText(message);
  }
}
```

### Dashboard Page

```typescript
// e2e/pages/dashboard.page.ts
import { Page, expect, Locator } from '@playwright/test';
import { BasePage } from './base.page';

export class DashboardPage extends BasePage {
  private projectList = this.page.getByTestId('project-list');
  private newProjectBtn = this.page.getByRole('button', { name: 'New Project' });

  constructor(page: Page) {
    super(page);
  }

  async goto() {
    await this.page.goto('/dashboard');
  }

  async createProject(name: string) {
    await this.newProjectBtn.click();
    await this.page.getByLabel('Project Name').fill(name);
    await this.page.getByRole('button', { name: 'Create' }).click();
  }

  async getProjectCount(): Promise<number> {
    return this.projectList.locator('[data-testid="project-card"]').count();
  }

  async expectProjectVisible(name: string) {
    await expect(this.projectList.getByText(name)).toBeVisible();
  }
}
```

### Using Page Objects in Tests

```typescript
// e2e/tests/auth.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/login.page';

test.describe('Authentication', () => {
  test('user can log in with valid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.login('test@example.com', 'password123');
    await loginPage.expectLoginSuccess();
  });

  test('shows error for invalid credentials', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.login('test@example.com', 'wrong-password');
    await loginPage.expectLoginError('Invalid email or password');
  });
});
```

---

## PART 5: AUTH STATE REUSE (storageState)

Don't log in before every test. Save auth state once and reuse it.

### Auth Setup File

```typescript
// e2e/auth.setup.ts
import { test as setup, expect } from '@playwright/test';
import path from 'path';

const authFile = path.join(__dirname, '.auth/user.json');

setup('authenticate', async ({ page }) => {
  // Log in once
  await page.goto('/login');
  await page.getByLabel('Email').fill('e2e-test@example.com');
  await page.getByLabel('Password').fill('testpassword123');
  await page.getByRole('button', { name: 'Sign In' }).click();

  // Wait for login to complete
  await expect(page).toHaveURL('/dashboard');

  // Save auth state (cookies + localStorage)
  await page.context().storageState({ path: authFile });
});
```

### Use Auth State in Tests

```typescript
// playwright.config.ts — projects section
projects: [
  { name: 'setup', testMatch: /.*\.setup\.ts/ },
  {
    name: 'chromium',
    use: {
      ...devices['Desktop Chrome'],
      storageState: 'e2e/.auth/user.json',  // Reuse auth state
    },
    dependencies: ['setup'],
  },
],
```

### Tests That Need Different Roles

```typescript
// For admin-only tests
test.describe('Admin features', () => {
  test.use({
    storageState: 'e2e/.auth/admin.json',  // Admin auth state
  });

  test('admin can access user management', async ({ page }) => {
    await page.goto('/admin/users');
    await expect(page.getByRole('heading')).toHaveText('User Management');
  });
});

// For unauthenticated tests
test.describe('Public pages', () => {
  test.use({ storageState: { cookies: [], origins: [] } });

  test('redirects to login when not authenticated', async ({ page }) => {
    await page.goto('/dashboard');
    await expect(page).toHaveURL('/login');
  });
});
```

---

## PART 6: TEST DATA MANAGEMENT

### Seeding Test Data

```typescript
// e2e/fixtures/test-data.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function seedTestData() {
  // Create test user
  const user = await prisma.user.upsert({
    where: { email: 'e2e-test@example.com' },
    update: {},
    create: {
      email: 'e2e-test@example.com',
      name: 'E2E Test User',
      passwordHash: await hashPassword('testpassword123'),
    },
  });

  // Create test projects
  await prisma.project.createMany({
    data: [
      { name: 'Test Project 1', userId: user.id },
      { name: 'Test Project 2', userId: user.id },
    ],
    skipDuplicates: true,
  });

  return { user };
}

export async function cleanupTestData() {
  // Delete in dependency order
  await prisma.project.deleteMany({
    where: { user: { email: 'e2e-test@example.com' } },
  });
  await prisma.user.deleteMany({
    where: { email: 'e2e-test@example.com' },
  });
}
```

### Global Setup / Teardown

```typescript
// e2e/global-setup.ts
import { seedTestData } from './fixtures/test-data';

async function globalSetup() {
  await seedTestData();
}

export default globalSetup;

// e2e/global-teardown.ts
import { cleanupTestData } from './fixtures/test-data';

async function globalTeardown() {
  await cleanupTestData();
}

export default globalTeardown;

// playwright.config.ts
export default defineConfig({
  globalSetup: require.resolve('./e2e/global-setup'),
  globalTeardown: require.resolve('./e2e/global-teardown'),
  // ...
});
```

---

## PART 7: NETWORK INTERCEPTION

### Mock API Responses

```typescript
test('shows error state when API fails', async ({ page }) => {
  // Intercept API call and return error
  await page.route('**/api/projects', (route) =>
    route.fulfill({
      status: 500,
      contentType: 'application/json',
      body: JSON.stringify({ message: 'Internal Server Error' }),
    }),
  );

  await page.goto('/dashboard');
  await expect(page.getByText('Failed to load projects')).toBeVisible();
});

test('shows loading state', async ({ page }) => {
  // Delay the API response
  await page.route('**/api/projects', async (route) => {
    await new Promise((resolve) => setTimeout(resolve, 3000));
    await route.continue();
  });

  await page.goto('/dashboard');
  await expect(page.getByTestId('loading-spinner')).toBeVisible();
});
```

### Wait for Specific API Calls

```typescript
test('form submission triggers API call', async ({ page }) => {
  await page.goto('/projects/new');

  // Set up response listener BEFORE the action
  const responsePromise = page.waitForResponse(
    (resp) => resp.url().includes('/api/projects') && resp.request().method() === 'POST',
  );

  // Fill and submit form
  await page.getByLabel('Name').fill('New Project');
  await page.getByRole('button', { name: 'Create' }).click();

  // Wait for the API response
  const response = await responsePromise;
  expect(response.status()).toBe(201);
});
```

---

## PART 8: SELECTORS STRATEGY

### Priority Order (Best → Worst)

```typescript
// 1. Role-based (BEST — accessible and stable)
page.getByRole('button', { name: 'Submit' })
page.getByRole('heading', { name: 'Dashboard' })
page.getByRole('link', { name: 'Settings' })

// 2. Label-based (GOOD — tied to visible text)
page.getByLabel('Email')
page.getByPlaceholder('Search...')
page.getByText('Welcome back')

// 3. Test ID (GOOD — explicit and stable)
page.getByTestId('project-card')
page.getByTestId('submit-btn')

// 4. CSS selectors (AVOID — brittle, breaks with styling changes)
page.locator('.btn-primary')  // Don't do this
page.locator('#submit')       // Fragile

// 5. XPath (NEVER — unreadable and extremely brittle)
page.locator('//div[@class="container"]//button')  // Never do this
```

### Adding Test IDs in React

```tsx
// Only add data-testid where role/label selectors aren't sufficient
<div data-testid="project-card">
  <h3>{project.name}</h3>
  <button data-testid="delete-project">Delete</button>
</div>
```

---

## PART 9: CI INTEGRATION

### GitHub Actions

```yaml
# .github/workflows/e2e.yml
name: E2E Tests
on: [push, pull_request]

jobs:
  e2e:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: e2e_test
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps chromium

      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/e2e_test

      - name: Run E2E tests
        run: npx playwright test --project=chromium
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/e2e_test

      - name: Upload test artifacts
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 7
```

### Sharding for Speed

```yaml
# Split tests across multiple machines
jobs:
  e2e:
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - run: npx playwright test --shard=${{ matrix.shard }}/4
```

---

## PART 10: DEBUGGING FAILED TESTS

### Trace Viewer

```bash
# View the trace of a failed test
npx playwright show-trace test-results/auth-spec-ts/trace.zip

# The trace includes:
# - Screenshots at each step
# - Network requests
# - Console logs
# - DOM snapshots (time-travel debugging)
```

### Run in Headed Mode

```bash
# Watch the test run in a visible browser
npx playwright test --headed

# Run with Playwright Inspector (step through interactively)
npx playwright test --debug

# Run a single test file
npx playwright test e2e/tests/auth.spec.ts
```

### Common Flaky Test Fixes

| Issue | Cause | Fix |
|-------|-------|-----|
| Element not found | Page hasn't loaded yet | Use `await expect(locator).toBeVisible()` before interacting |
| Click does nothing | Element is covered by overlay/modal | Wait for overlay to disappear, or click with `force: true` |
| Wrong data shown | Previous test's data leaking | Isolate test data, use unique identifiers |
| Timeout on CI | CI is slower than local | Increase timeout, add `waitForLoadState` |
| Different on mobile | Responsive layout hides elements | Check viewport-specific selectors |

---

## PART 11: VISUAL REGRESSION

Use sparingly — only for design system components.

```typescript
test('button variants match design', async ({ page }) => {
  await page.goto('/storybook/buttons');

  // Full-page screenshot comparison
  await expect(page).toHaveScreenshot('button-variants.png', {
    maxDiffPixelRatio: 0.01,  // Allow 1% pixel difference
  });
});

test('dashboard layout is correct', async ({ page }) => {
  await page.goto('/dashboard');

  // Element-specific screenshot
  const sidebar = page.getByTestId('sidebar');
  await expect(sidebar).toHaveScreenshot('sidebar.png');
});
```

```bash
# Update baseline screenshots after intentional design changes
npx playwright test --update-snapshots
```

---

## ✅ Exit Checklist

- [ ] Playwright installed and configured
- [ ] Critical user flows covered (auth, core feature, destructive actions)
- [ ] Page Object Model used for reusable page interactions
- [ ] Auth state saved and reused (storageState)
- [ ] Test data seeded in global setup and cleaned in teardown
- [ ] Tests use stable selectors (role > label > testid)
- [ ] CI pipeline runs E2E tests on every PR
- [ ] Trace/screenshot/video captured on failure
- [ ] Tests pass reliably (no flaky tests)
- [ ] Tests run against dedicated test database (not production)
