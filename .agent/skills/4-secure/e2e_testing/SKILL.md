---
name: End-to-End (E2E) Testing
description: Validate complete user flows from the user's perspective, simulating real browser interactions
---

# End-to-End (E2E) Testing Skill

**Purpose**: Test the *system*, not just the code. Ensure that a user can actually accomplish their goals (Sign up, Buy, Post) across the full stack.

> [!TIP]
> **Pyramid Rule**: E2E tests are slow and expensive. Have FEW E2E tests, MANY Unit tests. Only test value-critical paths.

---

## 🎯 TRIGGER COMMANDS

```text
"Write E2E test for [flow]"
"Test the [feature] user journey"
"Setup playwright for [app]"
"Using e2e_testing skill: verify [scenario]"
```

---

## 🎭 WHAT TO TEST (Critical Paths)

Do not test every button click. Test the **"Money Flows"**.

1. **Auth**: Sign up, Log in, Password Reset.
2. **Conversion**: Checkout, Subscription, Payment.
3. **Core Value**: The main thing your app does (e.g., "Upload Video").
4. **Destructive**: Deleting an account/project.

---

## 📝 TEST STRUCTURE (AAA Pattern)

Every test should follow **Arrange - Act - Assert**.

```typescript
test('User can purchase a plan', async ({ page }) => {
  // ARRANGE
  await page.goto('/pricing');
  
  // ACT
  await page.click('#buy-pro-plan');
  await page.fill('#card-number', '4242...');
  await page.click('#submit');
  
  // ASSERT
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('.plan-badge')).toHaveText('PRO');
});
```

---

## 📸 VISUAL REGRESSION

Sometimes the code works, but the CSS is broken.

* **Snapshot Testing**: Take a screenshot of the component. Compare it pixel-by-pixel to the "Gold Master".
* *Warning*: Flaky/Brittle. Use sparingly for design systems.

---

## ✅ IMPLEMENTATION CHECKLIST

* [ ] **Environment**: Test runs against a dedicated "E2E" DB, not Prod.
* [ ] **Seeding**: Test creates its own data (Users/Items) before running.
* [ ] **Teardown**: Test cleans up its data after finishing.
* [ ] **Resilience**: Test handles network jitter/loading states.
* [ ] **Selectors**: Use `data-testid="submit-btn"` specific attributes, not generic classes.

---

## 🛠️ RECOMMENDED TOOLS

* **Browser Automation**: Playwright (Recommended), Cypress, Selenium
* **Visual Diff**: Percy, Chromatic
