---
name: accessibility_testing
description: WCAG 2.1 AA compliance auditing with axe-core, keyboard testing, and screen reader verification
---

# Accessibility Testing Skill

**Purpose**: Audit and remediate web application accessibility to meet WCAG 2.1 Level AA standards, ensuring the application is usable by people with visual, motor, auditory, and cognitive disabilities.

## 🎯 TRIGGER COMMANDS

```text
"accessibility audit for this page"
"a11y check"
"WCAG compliance review"
"check accessibility"
"screen reader test this component"
"Using accessibility_testing skill: audit [page/component]"
```

## 📋 WCAG 2.1 AA Essentials

| Principle | Key Requirements | Impact |
|-----------|-----------------|--------|
| **Perceivable** | Alt text, captions, contrast, resize text | Blind, low vision, deaf users |
| **Operable** | Keyboard access, no time traps, no seizure triggers | Motor, seizure-prone users |
| **Understandable** | Readable, predictable, input assistance | Cognitive, learning disabilities |
| **Robust** | Valid HTML, ARIA compatibility | Assistive technology users |

### Critical AA Success Criteria

| Criterion | ID | Rule |
|-----------|-----|------|
| Non-text Content | 1.1.1 | All images have alt text (or `alt=""` for decorative) |
| Color Contrast | 1.4.3 | 4.5:1 for normal text, 3:1 for large text (18px+ bold or 24px+) |
| Resize Text | 1.4.4 | Page usable at 200% zoom |
| Keyboard | 2.1.1 | All functionality available via keyboard |
| No Keyboard Trap | 2.1.2 | Focus can always move away from any element |
| Focus Visible | 2.4.7 | Visible focus indicator on interactive elements |
| Language | 3.1.1 | Page has `lang` attribute on `<html>` |
| Error Identification | 3.3.1 | Input errors are clearly described |
| Labels | 3.3.2 | Form inputs have associated labels |
| Name, Role, Value | 4.1.2 | Custom components expose correct ARIA semantics |

## 🛠️ axe-core Setup

### Installation and Integration Test

```typescript
// Install: npm install -D @axe-core/react axe-core @testing-library/jest-dom

// test/helpers/axe.helper.ts
import { configureAxe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

export const axe = configureAxe({
  rules: {
    // Disable rules that don't apply to your context
    region: { enabled: false }, // if not using landmark regions yet
  },
});
```

### Component Accessibility Test

```typescript
import { render } from '@testing-library/react';
import { axe } from '../helpers/axe.helper';
import { LoginForm } from '@/components/LoginForm';

describe('LoginForm accessibility', () => {
  it('should have no axe violations', async () => {
    const { container } = render(<LoginForm />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('should have no violations when showing error state', async () => {
    const { container } = render(
      <LoginForm error="Invalid credentials" />,
    );
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });
});
```

### Page-Level Scan with Playwright + axe

```typescript
// e2e/accessibility.spec.ts
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility scans', () => {
  test('Dashboard page should have no critical violations', async ({ page }) => {
    await page.goto('/dashboard');

    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa'])
      .analyze();

    expect(results.violations).toEqual([]);
  });

  test('Login page should have no violations', async ({ page }) => {
    await page.goto('/login');

    const results = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa'])
      .exclude('.third-party-widget') // exclude uncontrolled content
      .analyze();

    expect(results.violations).toEqual([]);
  });
});
```

## ⌨️ Keyboard Navigation Checklist

| Key | Expected Behavior | Test |
|-----|-------------------|------|
| `Tab` | Move focus to next interactive element | All elements reachable |
| `Shift+Tab` | Move focus to previous element | Can navigate backwards |
| `Enter` | Activate buttons and links | Buttons clickable via Enter |
| `Space` | Toggle checkboxes, activate buttons | Checkboxes work with Space |
| `Escape` | Close modals, dropdowns, popups | Dismisses overlays |
| `Arrow keys` | Navigate within menus, tabs, radio groups | Grouped controls navigable |
| `Home/End` | Jump to first/last item in a list | Optional but helpful |

```typescript
// Keyboard navigation test
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Modal } from '@/components/Modal';

describe('Modal keyboard navigation', () => {
  it('should trap focus inside modal when open', async () => {
    const user = userEvent.setup();
    render(
      <Modal isOpen={true} onClose={vi.fn()}>
        <button>First</button>
        <button>Second</button>
        <button>Close</button>
      </Modal>,
    );

    const firstButton = screen.getByText('First');
    const closeButton = screen.getByText('Close');

    // Focus should start on first focusable element
    expect(firstButton).toHaveFocus();

    // Tab through all elements
    await user.tab();
    expect(screen.getByText('Second')).toHaveFocus();

    await user.tab();
    expect(closeButton).toHaveFocus();

    // Tab wraps back to first element (focus trap)
    await user.tab();
    expect(firstButton).toHaveFocus();
  });

  it('should close modal on Escape key', async () => {
    const onClose = vi.fn();
    const user = userEvent.setup();
    render(
      <Modal isOpen={true} onClose={onClose}>
        <p>Content</p>
      </Modal>,
    );

    await user.keyboard('{Escape}');
    expect(onClose).toHaveBeenCalledOnce();
  });

  it('should return focus to trigger element after modal closes', async () => {
    const user = userEvent.setup();
    const { rerender } = render(
      <>
        <button data-testid="trigger">Open Modal</button>
        <Modal isOpen={false} onClose={vi.fn()}>
          <p>Content</p>
        </Modal>
      </>,
    );

    const trigger = screen.getByTestId('trigger');
    trigger.focus();

    // Simulate opening and closing
    rerender(
      <>
        <button data-testid="trigger">Open Modal</button>
        <Modal isOpen={false} onClose={vi.fn()}>
          <p>Content</p>
        </Modal>
      </>,
    );

    expect(trigger).toHaveFocus();
  });
});
```

## 🎨 Color Contrast Requirements

| Text Type | Minimum Ratio | Example |
|-----------|--------------|---------|
| Normal text (< 18px) | **4.5:1** | `#595959` on `#FFFFFF` = 7:1 |
| Large text (18px+ bold or 24px+) | **3:1** | `#767676` on `#FFFFFF` = 4.5:1 |
| UI components & graphics | **3:1** | Border color on buttons, icons |
| Disabled elements | No requirement | But still should be distinguishable |
| Decorative text | No requirement | Logos, brand names |

> [!WARNING]
> Do not rely on color alone to convey information. Error states should use an icon or text label in addition to red coloring. Status indicators need shape or text, not just green/red.

```typescript
// Tailwind classes that typically meet contrast requirements
// On white background (#FFFFFF):
//   text-gray-900 (#111827) = 16.8:1 — excellent
//   text-gray-700 (#374151) = 10.3:1 — great
//   text-gray-500 (#6B7280) = 5.0:1  — meets AA for normal text
//   text-gray-400 (#9CA3AF) = 3.0:1  — FAILS for normal text, OK for large text only
//   text-red-600  (#DC2626) = 4.6:1  — meets AA for normal text
//   text-red-400  (#F87171) = 2.5:1  — FAILS AA
```

## 🏷️ ARIA Best Practices

### When to Use ARIA

| Scenario | Approach |
|----------|----------|
| Standard HTML element exists | Use native HTML (`<button>`, `<nav>`, `<input>`) — no ARIA needed |
| Custom interactive widget | Add `role`, `aria-*` attributes |
| Dynamic content updates | Use `aria-live` regions |
| Icon-only buttons | Add `aria-label` |
| Error messages linked to inputs | Use `aria-describedby` |
| Expandable sections | Use `aria-expanded` |

> [!TIP]
> The first rule of ARIA: **don't use ARIA if you can use native HTML**. A `<button>` is always better than `<div role="button" tabindex="0">`.

### Common ARIA Mistakes

| Mistake | Fix |
|---------|-----|
| `role="button"` on a `<div>` without keyboard handling | Use `<button>` instead |
| `aria-label` on non-interactive elements | Only use on interactive elements or landmarks |
| `aria-hidden="true"` on focusable elements | Remove from tab order first |
| Missing `aria-expanded` on toggles | Add and update on state change |
| `aria-live="assertive"` for non-urgent updates | Use `aria-live="polite"` for most cases |

## 📝 Accessible Form Pattern

```typescript
// components/AccessibleForm.tsx
import { useState, useId } from 'react';

interface FormFieldProps {
  label: string;
  type?: string;
  required?: boolean;
  error?: string;
  hint?: string;
}

export function FormField({ label, type = 'text', required, error, hint }: FormFieldProps) {
  const id = useId();
  const errorId = `${id}-error`;
  const hintId = `${id}-hint`;

  const describedBy = [
    hint ? hintId : null,
    error ? errorId : null,
  ].filter(Boolean).join(' ') || undefined;

  return (
    <div className="mb-4">
      <label htmlFor={id} className="block text-sm font-medium text-gray-900">
        {label}
        {required && <span aria-hidden="true" className="text-red-600 ml-1">*</span>}
        {required && <span className="sr-only">(required)</span>}
      </label>

      {hint && (
        <p id={hintId} className="text-sm text-gray-600 mt-1">
          {hint}
        </p>
      )}

      <input
        id={id}
        type={type}
        required={required}
        aria-required={required}
        aria-invalid={error ? 'true' : undefined}
        aria-describedby={describedBy}
        className={`mt-1 block w-full rounded-md border px-3 py-2
          ${error
            ? 'border-red-600 focus:ring-red-600'
            : 'border-gray-300 focus:ring-blue-600'
          }
          focus:outline-none focus:ring-2`}
      />

      {error && (
        <p id={errorId} className="text-sm text-red-600 mt-1" role="alert">
          {error}
        </p>
      )}
    </div>
  );
}
```

## 🔀 Dynamic Content & Live Regions

```typescript
// Announce route changes to screen readers
export function RouteAnnouncer() {
  const location = useLocation();
  const [announcement, setAnnouncement] = useState('');

  useEffect(() => {
    const pageTitle = document.title;
    setAnnouncement(`Navigated to ${pageTitle}`);
  }, [location.pathname]);

  return (
    <div
      role="status"
      aria-live="polite"
      aria-atomic="true"
      className="sr-only"
    >
      {announcement}
    </div>
  );
}

// Announce async operation results
export function AsyncStatusAnnouncer({ status }: { status: string }) {
  return (
    <div aria-live="polite" aria-atomic="true" className="sr-only">
      {status}
    </div>
  );
}
// Usage: <AsyncStatusAnnouncer status={isLoading ? 'Loading...' : 'Content loaded'} />
```

## 🔗 Skip Navigation Link

```typescript
// components/SkipNavigation.tsx
export function SkipNavigation() {
  return (
    <a
      href="#main-content"
      className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2
                 focus:z-50 focus:bg-white focus:px-4 focus:py-2 focus:rounded
                 focus:shadow-lg focus:text-blue-700 focus:underline"
    >
      Skip to main content
    </a>
  );
}

// In App.tsx or Layout.tsx:
// <SkipNavigation />
// <header>...</header>
// <main id="main-content" tabIndex={-1}>...</main>
```

## 🔍 Accessible Modal (Complete Pattern)

```typescript
import { useEffect, useRef, useCallback } from 'react';
import { createPortal } from 'react-dom';

interface AccessibleModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

export function AccessibleModal({ isOpen, onClose, title, children }: AccessibleModalProps) {
  const modalRef = useRef<HTMLDivElement>(null);
  const previousFocusRef = useRef<HTMLElement | null>(null);
  const titleId = `modal-title-${title.replace(/\s/g, '-').toLowerCase()}`;

  // Store the element that had focus before modal opened
  useEffect(() => {
    if (isOpen) {
      previousFocusRef.current = document.activeElement as HTMLElement;
    }
  }, [isOpen]);

  // Focus the modal when it opens
  useEffect(() => {
    if (isOpen && modalRef.current) {
      const firstFocusable = modalRef.current.querySelector<HTMLElement>(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])',
      );
      firstFocusable?.focus();
    }
  }, [isOpen]);

  // Return focus when modal closes
  useEffect(() => {
    if (!isOpen && previousFocusRef.current) {
      previousFocusRef.current.focus();
    }
  }, [isOpen]);

  // Focus trap
  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if (e.key === 'Escape') {
        onClose();
        return;
      }

      if (e.key === 'Tab' && modalRef.current) {
        const focusables = modalRef.current.querySelectorAll<HTMLElement>(
          'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])',
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
    },
    [onClose],
  );

  if (!isOpen) return null;

  return createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center"
      role="presentation"
    >
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/50"
        aria-hidden="true"
        onClick={onClose}
      />

      {/* Modal */}
      <div
        ref={modalRef}
        role="dialog"
        aria-modal="true"
        aria-labelledby={titleId}
        onKeyDown={handleKeyDown}
        className="relative z-10 bg-white rounded-lg shadow-xl p-6 max-w-lg w-full mx-4"
      >
        <h2 id={titleId} className="text-xl font-semibold text-gray-900">
          {title}
        </h2>

        <div className="mt-4">{children}</div>

        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-gray-500 hover:text-gray-700
                     focus:outline-none focus:ring-2 focus:ring-blue-600 rounded"
          aria-label="Close dialog"
        >
          <svg aria-hidden="true" className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
            <path
              fillRule="evenodd"
              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
              clipRule="evenodd"
            />
          </svg>
        </button>
      </div>
    </div>,
    document.body,
  );
}
```

## 🔧 Testing Tools Reference

| Tool | Type | Use Case |
|------|------|----------|
| **axe-core** | Automated | Catches ~57% of WCAG issues programmatically |
| **jest-axe** | Unit test | axe inside Jest/Vitest test suite |
| **@axe-core/playwright** | E2E test | axe inside Playwright tests |
| **Lighthouse a11y audit** | Automated | Browser DevTools > Lighthouse > Accessibility |
| **Chrome DevTools** | Manual | Accessibility tree inspector, contrast checker |
| **WAVE** | Browser extension | Visual overlay of a11y issues |
| **VoiceOver** | Screen reader | macOS built-in (Cmd+F5 to toggle) |
| **NVDA** | Screen reader | Windows free screen reader |

> [!TIP]
> Automated tools catch roughly half of WCAG issues. The other half requires manual testing: keyboard navigation, screen reader flow, and cognitive review. Always combine automated scans with manual checks.

## 🚨 Common Violations Quick Reference

| Violation | Impact | Fix |
|-----------|--------|-----|
| Missing alt text on `<img>` | Critical | Add descriptive `alt` or `alt=""` for decorative |
| Empty link / button text | Critical | Add visible text or `aria-label` |
| Missing form `<label>` | Critical | Wrap in `<label>` or use `htmlFor` + `id` |
| Low color contrast | Serious | Adjust to meet 4.5:1 / 3:1 ratio |
| Missing document language | Serious | Add `lang="en"` to `<html>` |
| Missing focus indicator | Serious | Add `:focus-visible` styles, never `outline: none` |
| Missing heading hierarchy | Moderate | Use `h1` > `h2` > `h3` in order, no skipping |
| `tabindex` > 0 | Moderate | Remove positive tabindex, use DOM order |
| Auto-playing media | Moderate | Add controls, no autoplay or provide pause |
| Missing landmark regions | Minor | Wrap in `<main>`, `<nav>`, `<header>`, `<footer>` |

## ✅ EXIT CHECKLIST

- [ ] axe-core automated scan returns 0 violations
- [ ] All pages keyboard-navigable (Tab through every interactive element)
- [ ] No keyboard traps (focus can always escape)
- [ ] Visible focus indicators on all interactive elements
- [ ] Screen reader tested on primary user flows (login, navigation, forms)
- [ ] Color contrast verified (4.5:1 normal text, 3:1 large text)
- [ ] All images have appropriate alt text
- [ ] All form inputs have associated labels
- [ ] Error messages are programmatically associated with inputs
- [ ] Modal dialogs trap focus and return focus on close
- [ ] Skip navigation link present and functional
- [ ] Dynamic content updates announced via `aria-live`
- [ ] Page works at 200% browser zoom
- [ ] `lang` attribute present on `<html>` element

*Skill Version: 1.0 | Created: February 2026*
