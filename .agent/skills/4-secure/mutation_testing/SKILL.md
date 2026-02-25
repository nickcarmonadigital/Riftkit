---
name: Mutation Testing
description: Validate test suite effectiveness using Stryker.js, mutmut, or PIT to ensure tests catch real bugs
---

# Mutation Testing Skill

**Purpose**: Validate that your test suite actually catches bugs by systematically introducing small code changes (mutations) and verifying that tests detect them. Line coverage alone does not prove test quality -- a test can execute a line without asserting on its behavior. Mutation testing measures whether tests would catch a real defect, producing a mutation score that reflects true test effectiveness.

## TRIGGER COMMANDS

```text
"Run mutation tests"
"Validate test suite effectiveness"
"Mutation score for [module]"
"Are my tests actually good?"
"Stryker mutation testing"
```

## When to Use
- After achieving high line coverage but wanting to verify test quality
- Validating that critical business logic is meaningfully tested
- Identifying tests that execute code without asserting on behavior
- Improving test suites for security-critical or financial calculation modules
- As a quality gate for modules with > 80% line coverage but unknown assertion quality

---

## PROCESS

### Step 1: Select Mutation Testing Tool

| Tool | Language | Speed | Integration |
|------|----------|-------|-------------|
| Stryker.js | TypeScript/JavaScript | Fast (incremental) | Jest, Vitest, Mocha |
| mutmut | Python | Medium | pytest |
| PIT (pitest) | Java/Kotlin | Fast | JUnit, Maven/Gradle |

### Step 2: Install and Configure Stryker.js (TypeScript/Node.js)

```bash
# Install Stryker
npm install -D @stryker-mutator/core @stryker-mutator/jest-runner @stryker-mutator/typescript-checker

# Initialize configuration
npx stryker init
```

**Stryker Configuration (`stryker.config.mjs`):**

```javascript
/** @type {import('@stryker-mutator/api/core').PartialStrykerOptions} */
export default {
  packageManager: 'npm',
  reporters: ['html', 'clear-text', 'progress', 'json'],
  testRunner: 'jest',
  jest: {
    configFile: 'jest.config.ts',
  },
  checkers: ['typescript'],
  tsconfigFile: 'tsconfig.json',
  coverageAnalysis: 'perTest',

  // Incremental mode: only mutate changed files
  incremental: true,
  incrementalFile: '.stryker-cache/incremental.json',

  // Target specific modules for focused testing
  mutate: [
    'src/**/*.ts',
    '!src/**/*.spec.ts',
    '!src/**/*.test.ts',
    '!src/**/*.module.ts',
    '!src/**/*.dto.ts',
    '!src/main.ts',
  ],

  // Thresholds
  thresholds: {
    high: 80,
    low: 70,
    break: 60,  // Fail CI if mutation score drops below 60%
  },

  // Timeout: kill mutants that cause infinite loops
  timeoutMS: 10000,
  timeoutFactor: 1.5,
};
```

### Step 3: Run Mutation Tests

```bash
# Full mutation run
npx stryker run

# Incremental run (only changed files -- use in CI)
npx stryker run --incremental

# Target specific files
npx stryker run --mutate 'src/services/payment.service.ts'
```

**Python (mutmut):**

```bash
pip install mutmut

# Run mutation tests
mutmut run --paths-to-mutate=src/ --tests-dir=tests/

# View results
mutmut results

# Show surviving mutants
mutmut show <mutant-id>
```

### Step 4: Interpret Results and Fix Surviving Mutants

Stryker classifies each mutant:

| Status | Meaning | Action |
|--------|---------|--------|
| Killed | Test caught the mutation | Good -- no action needed |
| Survived | Test did NOT catch the mutation | Write better assertion |
| Timeout | Mutation caused infinite loop | Usually acceptable (still detected) |
| No coverage | No test covers this code | Write a new test |
| Compile error | Mutation created invalid code | Ignored in scoring |

**Example: surviving mutant analysis**

```typescript
// Original code
function calculateDiscount(price: number, percentage: number): number {
  return price * (percentage / 100);
}

// Surviving mutant: changed * to +
// return price + (percentage / 100);
// This survived because the test was:
test('calculates discount', () => {
  const result = calculateDiscount(100, 10);
  expect(result).toBeDefined();  // BAD: does not check value
});

// Fixed test that kills the mutant:
test('calculates discount', () => {
  expect(calculateDiscount(100, 10)).toBe(10);
  expect(calculateDiscount(200, 25)).toBe(50);
  expect(calculateDiscount(0, 50)).toBe(0);
});
```

### Step 5: CI/CD Integration (Incremental Only)

Run mutation tests on changed files only to keep CI fast:

```yaml
# .github/workflows/mutation-testing.yml
name: Mutation Testing
on:
  pull_request:
    branches: [main, develop]

jobs:
  stryker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - name: Restore Stryker cache
        uses: actions/cache@v4
        with:
          path: .stryker-cache
          key: stryker-${{ github.base_ref }}-${{ hashFiles('src/**/*.ts') }}
          restore-keys: stryker-${{ github.base_ref }}-

      - name: Run incremental mutation tests
        run: npx stryker run --incremental

      - name: Upload mutation report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: stryker-report
          path: reports/mutation/
          retention-days: 14
```

### Step 6: Set Mutation Score Thresholds

| Module Type | Target Score | Rationale |
|-------------|-------------|-----------|
| Financial calculations | 90%+ | Money-handling code must be thoroughly tested |
| Authentication/authorization | 85%+ | Security-critical paths |
| Business logic services | 75%+ | Core domain logic |
| CRUD controllers | 60%+ | Lower value, higher test cost |
| Utility/helper functions | 70%+ | Shared code with wide impact |

---

## CHECKLIST

- [ ] Mutation testing tool installed and configured (Stryker/mutmut/PIT)
- [ ] `mutate` patterns target source files, exclude tests and boilerplate
- [ ] Incremental mode enabled for CI performance
- [ ] Mutation score thresholds set per module criticality
- [ ] CI workflow runs incremental mutation tests on PRs
- [ ] Stryker cache persisted between CI runs
- [ ] Surviving mutants triaged and converted into better tests
- [ ] HTML report generated and accessible as CI artifact
- [ ] Critical modules (auth, payments, business logic) achieve target score
- [ ] Team understands difference between line coverage and mutation score

*Skill Version: 1.0 | Created: February 2026*
