---
name: Accessibility Implementation
description: WCAG 2.2 implementation with ARIA, semantic HTML, screen readers, keyboard navigation, and focus management
---

# Accessibility Implementation Skill

**Purpose**: Provide actionable implementation guidance for WCAG 2.2 compliance including ARIA patterns, semantic HTML, screen reader support, keyboard navigation, focus management, and automated testing.

---

## TRIGGER COMMANDS

```text
"Make this component accessible"
"Implement WCAG 2.2 compliance"
"Add screen reader support"
"Fix keyboard navigation"
"Using accessibility_implementation skill: [task]"
```

---

## WCAG 2.2 Conformance Levels

| Level | Requirement | Target Audience |
|-------|------------|-----------------|
| A | Minimum accessibility | All public sites (legal baseline) |
| AA | Standard accessibility | Required by most laws (ADA, EAA) |
| AAA | Enhanced accessibility | Specialized (government, education) |

### Key WCAG 2.2 Success Criteria

| Criterion | Level | Summary | Common Failure |
|-----------|-------|---------|----------------|
| 1.1.1 Non-text Content | A | Alt text for images | Missing/generic alt text |
| 1.3.1 Info and Relationships | A | Semantic structure | Div soup, missing headings |
| 1.4.3 Contrast (Minimum) | AA | 4.5:1 text, 3:1 large | Light gray on white |
| 1.4.11 Non-text Contrast | AA | 3:1 for UI components | Low-contrast borders |
| 2.1.1 Keyboard | A | All functionality via keyboard | Click-only interactions |
| 2.4.3 Focus Order | A | Logical focus sequence | Tab order jumps around |
| 2.4.7 Focus Visible | AA | Visible focus indicator | `outline: none` without replacement |
| 2.4.11 Focus Not Obscured | AA (new) | Focus not hidden by sticky elements | Fixed header covers focus |
| 2.5.8 Target Size | AA (new) | 24x24px minimum target | Tiny icons, close buttons |
| 3.3.8 Accessible Authentication | AA (new) | No cognitive function tests | CAPTCHA without alternatives |
| 4.1.2 Name, Role, Value | A | Programmatic name for controls | Unlabeled buttons/inputs |

---

## Semantic HTML

### Document Structure

```html
<!-- GOOD: Semantic structure -->
<body>
  <header>
    <nav aria-label="Main navigation">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/products">Products</a></li>
        <li><a href="/about">About</a></li>
      </ul>
    </nav>
  </header>

  <main>
    <h1>Product Catalog</h1>

    <section aria-labelledby="featured-heading">
      <h2 id="featured-heading">Featured Products</h2>
      <article>
        <h3>Product Name</h3>
        <p>Description...</p>
      </article>
    </section>

    <aside aria-label="Filters">
      <h2>Filter by Category</h2>
      <!-- filter controls -->
    </aside>
  </main>

  <footer>
    <nav aria-label="Footer navigation">
      <!-- footer links -->
    </nav>
  </footer>
</body>
```

```html
<!-- BAD: Div soup -->
<div class="header">
  <div class="nav">
    <div class="nav-item"><span onclick="go('/')">Home</span></div>
  </div>
</div>
<div class="main">
  <div class="title">Product Catalog</div>
  <div class="section">
    <div class="subtitle">Featured Products</div>
  </div>
</div>
```

### Heading Hierarchy

```
h1: Page Title (one per page)
  h2: Section Heading
    h3: Subsection
      h4: Sub-subsection
  h2: Another Section
    h3: Subsection
```

> WARNING: Never skip heading levels (e.g., h1 to h3). Screen reader users navigate by headings.

---

## ARIA Patterns

### When to Use ARIA

```
Rule 1: Don't use ARIA if native HTML works
         <button> > <div role="button">
         <nav>    > <div role="navigation">
         <input>  > <div role="textbox">

Rule 2: Don't change native semantics unless necessary
         <h2 role="tab"> -- BAD
         <div role="tab"><h2>Title</h2></div> -- GOOD

Rule 3: All interactive ARIA roles need keyboard support
Rule 4: Don't use role="presentation" or aria-hidden="true" on focusable elements
Rule 5: All interactive elements must have an accessible name
```

### Common ARIA Patterns

#### Modal Dialog

```html
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
  aria-describedby="dialog-desc"
>
  <h2 id="dialog-title">Confirm Deletion</h2>
  <p id="dialog-desc">Are you sure you want to delete this item? This cannot be undone.</p>
  <div>
    <button onclick="cancel()">Cancel</button>
    <button onclick="confirm()">Delete</button>
  </div>
</div>
```

```typescript
// Focus management for modals
function openModal(modalEl: HTMLElement) {
  const previouslyFocused = document.activeElement as HTMLElement;

  modalEl.style.display = 'block';
  modalEl.setAttribute('aria-hidden', 'false');

  // Focus first focusable element
  const firstFocusable = modalEl.querySelector<HTMLElement>(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  firstFocusable?.focus();

  // Trap focus inside modal
  modalEl.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeModal(modalEl, previouslyFocused);
      return;
    }
    if (e.key === 'Tab') {
      trapFocus(e, modalEl);
    }
  });
}

function closeModal(modalEl: HTMLElement, returnFocus: HTMLElement) {
  modalEl.style.display = 'none';
  modalEl.setAttribute('aria-hidden', 'true');
  returnFocus.focus(); // Return focus to trigger element
}

function trapFocus(e: KeyboardEvent, container: HTMLElement) {
  const focusables = container.querySelectorAll<HTMLElement>(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  const first = focusables[0];
  const last = focusables[focusables.length - 1];

  if (e.shiftKey && document.activeElement === first) {
    e.preventDefault();
    last.focus();
  } else if (!e.shiftKey && document.activeElement === last) {
    e.preventDefault();
    first.focus();
  }
}
```

#### Tabs

```html
<div role="tablist" aria-label="Account settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1">
    Profile
  </button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2" tabindex="-1">
    Security
  </button>
  <button role="tab" aria-selected="false" aria-controls="panel-3" id="tab-3" tabindex="-1">
    Billing
  </button>
</div>

<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">
  <!-- Profile content -->
</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>
  <!-- Security content -->
</div>
<div role="tabpanel" id="panel-3" aria-labelledby="tab-3" hidden>
  <!-- Billing content -->
</div>
```

```typescript
// Tab keyboard navigation (arrow keys, not Tab)
function handleTabKeyboard(e: KeyboardEvent, tabs: HTMLElement[]) {
  const currentIndex = tabs.indexOf(e.target as HTMLElement);
  let newIndex: number;

  switch (e.key) {
    case 'ArrowRight':
    case 'ArrowDown':
      newIndex = (currentIndex + 1) % tabs.length;
      break;
    case 'ArrowLeft':
    case 'ArrowUp':
      newIndex = (currentIndex - 1 + tabs.length) % tabs.length;
      break;
    case 'Home':
      newIndex = 0;
      break;
    case 'End':
      newIndex = tabs.length - 1;
      break;
    default:
      return;
  }

  e.preventDefault();
  activateTab(tabs[newIndex]);
}
```

#### Live Regions

```html
<!-- Polite: announced after current speech -->
<div aria-live="polite" aria-atomic="true">
  <!-- Updated dynamically -->
  3 results found
</div>

<!-- Assertive: interrupts current speech (use sparingly) -->
<div role="alert">
  Error: Payment failed. Please try again.
</div>

<!-- Status: polite live region for status messages -->
<div role="status">
  Saving...
</div>
```

---

## Keyboard Navigation

### Required Keyboard Support

| Element | Keys | Behavior |
|---------|------|----------|
| Links, buttons | Enter, Space | Activate |
| Checkboxes | Space | Toggle |
| Radio buttons | Arrow keys | Move selection |
| Tabs | Arrow keys | Switch tab |
| Menus | Arrow keys, Enter, Escape | Navigate, select, close |
| Dialogs | Escape, Tab | Close, cycle focus |
| Sliders | Arrow keys | Adjust value |
| Combobox | Arrow keys, Enter, Escape | Navigate, select, close |

### Skip Navigation

```html
<!-- First element in body -->
<a href="#main-content" class="skip-link">
  Skip to main content
</a>

<style>
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  padding: 8px 16px;
  background: #000;
  color: #fff;
  z-index: 100;
  transition: top 0.2s;
}

.skip-link:focus {
  top: 0;
}
</style>

<main id="main-content" tabindex="-1">
  <!-- Main content -->
</main>
```

### Focus Indicators

```css
/* NEVER do this without a replacement */
/* :focus { outline: none; } */

/* GOOD: Custom focus indicator */
:focus-visible {
  outline: 3px solid #2563eb;
  outline-offset: 2px;
  border-radius: 2px;
}

/* Remove outline for mouse clicks but keep for keyboard */
:focus:not(:focus-visible) {
  outline: none;
}

/* High-contrast focus for dark backgrounds */
.dark-section :focus-visible {
  outline: 3px solid #fbbf24;
  outline-offset: 2px;
}
```

---

## Form Accessibility

```html
<form>
  <!-- Associated label (required for every input) -->
  <div>
    <label for="email">Email address</label>
    <input
      type="email"
      id="email"
      name="email"
      required
      aria-describedby="email-help email-error"
      aria-invalid="false"
      autocomplete="email"
    />
    <span id="email-help">We will never share your email</span>
    <span id="email-error" role="alert" hidden>
      Please enter a valid email address
    </span>
  </div>

  <!-- Group related controls -->
  <fieldset>
    <legend>Notification preferences</legend>
    <div>
      <input type="checkbox" id="email-notif" name="notifications" value="email" />
      <label for="email-notif">Email notifications</label>
    </div>
    <div>
      <input type="checkbox" id="sms-notif" name="notifications" value="sms" />
      <label for="sms-notif">SMS notifications</label>
    </div>
  </fieldset>

  <button type="submit">Save preferences</button>
</form>
```

### Error Handling

```typescript
function showFieldError(input: HTMLInputElement, message: string) {
  const errorEl = document.getElementById(`${input.id}-error`);
  if (!errorEl) return;

  input.setAttribute('aria-invalid', 'true');
  errorEl.textContent = message;
  errorEl.hidden = false;
  input.focus();
}

function clearFieldError(input: HTMLInputElement) {
  const errorEl = document.getElementById(`${input.id}-error`);
  if (!errorEl) return;

  input.setAttribute('aria-invalid', 'false');
  errorEl.hidden = true;
}

// Summary of errors at top of form
function showErrorSummary(errors: { field: string; message: string }[]) {
  const summary = document.getElementById('error-summary');
  if (!summary) return;

  summary.innerHTML = `
    <h2>There are ${errors.length} errors in this form</h2>
    <ul>
      ${errors.map(e => `<li><a href="#${e.field}">${e.message}</a></li>`).join('')}
    </ul>
  `;
  summary.hidden = false;
  summary.focus();
}
```

---

## React Accessibility Patterns

### Accessible Component

```tsx
// components/Accordion.tsx
import { useState, useId } from 'react';

interface AccordionItemProps {
  title: string;
  children: React.ReactNode;
  defaultOpen?: boolean;
}

export function AccordionItem({ title, children, defaultOpen = false }: AccordionItemProps) {
  const [isOpen, setIsOpen] = useState(defaultOpen);
  const id = useId();
  const headingId = `${id}-heading`;
  const panelId = `${id}-panel`;

  return (
    <div>
      <h3>
        <button
          id={headingId}
          aria-expanded={isOpen}
          aria-controls={panelId}
          onClick={() => setIsOpen(!isOpen)}
          style={{ width: '100%', textAlign: 'left' }}
        >
          {title}
          <span aria-hidden="true">{isOpen ? '\u25B2' : '\u25BC'}</span>
        </button>
      </h3>
      <div
        id={panelId}
        role="region"
        aria-labelledby={headingId}
        hidden={!isOpen}
      >
        {children}
      </div>
    </div>
  );
}
```

### Screen Reader Only Text

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

```tsx
// Usage
<button aria-label="Close dialog">
  <XIcon aria-hidden="true" />
</button>

// Or with visually hidden text
<button>
  <XIcon aria-hidden="true" />
  <span className="sr-only">Close dialog</span>
</button>
```

---

## Mobile Accessibility (React Native)

```tsx
import { AccessibilityInfo, Platform } from 'react-native';

// Accessible touchable
<Pressable
  accessible
  accessibilityRole="button"
  accessibilityLabel="Add to cart"
  accessibilityHint="Adds this item to your shopping cart"
  accessibilityState={{ disabled: isOutOfStock }}
  onPress={handleAddToCart}
>
  <Text>Add to Cart</Text>
</Pressable>

// Announce to screen reader
AccessibilityInfo.announceForAccessibility('Item added to cart');

// Group related elements
<View accessible accessibilityLabel={`${product.name}, ${product.price}`}>
  <Text>{product.name}</Text>
  <Text>{product.price}</Text>
</View>
```

---

## Automated Testing

### axe-core (Unit/Integration)

```typescript
// jest + axe-core
import { render } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

test('LoginForm has no accessibility violations', async () => {
  const { container } = render(<LoginForm />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

### Lighthouse CI

```yaml
# .github/workflows/a11y.yml
- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v11
  with:
    urls: |
      https://myapp.com/
      https://myapp.com/products
      https://myapp.com/checkout
    budgetPath: ./lighthouse-budget.json
    configPath: ./lighthouserc.json
```

### Color Contrast Checker

| Ratio | Passes | Text Size |
|-------|--------|-----------|
| 3:1 | AA Large (18pt+, 14pt bold) | Headers, large UI |
| 4.5:1 | AA Normal | Body text |
| 7:1 | AAA Normal | Enhanced contrast |

---

## Cross-References

- `2-design/inclusive_design_patterns` - Inclusive design beyond WCAG compliance
- `3-build/react_native_patterns` - RN accessibility specifics
- `3-build/design_system_development` - Accessible design system components
- `3-build/progressive_web_app` - PWA accessibility

---

## EXIT CHECKLIST

- [ ] Semantic HTML used throughout (no div soup)
- [ ] Heading hierarchy is logical and complete
- [ ] All images have meaningful alt text (or alt="" for decorative)
- [ ] All form inputs have associated labels
- [ ] Color contrast meets AA (4.5:1 normal, 3:1 large)
- [ ] Focus indicators visible on all interactive elements
- [ ] Keyboard navigation works for all functionality
- [ ] Skip navigation link present
- [ ] Modal focus trapping and return implemented
- [ ] Live regions announce dynamic content changes
- [ ] axe-core tests pass with zero violations
- [ ] Tested with at least one screen reader (VoiceOver/NVDA/TalkBack)
- [ ] Touch targets are at least 24x24px (WCAG 2.5.8)

---

*Skill Version: 1.0 | Created: March 2026*
