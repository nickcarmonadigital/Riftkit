---
name: Design System Development
description: Building design systems with component libraries, design tokens, Storybook, versioning, and multi-framework support
---

# Design System Development Skill

**Purpose**: Guide teams in building and maintaining design systems including component libraries, design tokens, Storybook documentation, semantic versioning, and supporting multiple frameworks from a single source of truth.

---

## TRIGGER COMMANDS

```text
"Build a design system for our organization"
"Set up Storybook for component documentation"
"Implement design tokens"
"Create a multi-framework component library"
"Using design_system_development skill: [task]"
```

---

## Design System Architecture

```
+----------------------------------------------------+
|                   DESIGN SYSTEM                     |
+----------------------------------------------------+
|                                                     |
|  FOUNDATIONS                                        |
|    ├── Design Tokens (colors, spacing, typography)  |
|    ├── Icons                                        |
|    └── Theme (light/dark/brand variants)            |
|                                                     |
|  COMPONENTS                                         |
|    ├── Primitives (Button, Input, Text)             |
|    ├── Composites (Card, Modal, DataTable)           |
|    └── Patterns (LoginForm, SearchBar, Navigation)  |
|                                                     |
|  DOCUMENTATION                                      |
|    ├── Storybook (interactive examples)             |
|    ├── Usage guidelines                             |
|    └── Accessibility requirements                   |
|                                                     |
|  TOOLING                                            |
|    ├── Figma plugin (token sync)                    |
|    ├── Linting (ESLint plugin)                      |
|    └── Visual regression (Chromatic)                |
|                                                     |
+----------------------------------------------------+
```

---

## Design Tokens

### Token Architecture (3-Tier)

```
Tier 1: Global Tokens (raw values)
  --color-blue-500: #2563EB;
  --space-4: 16px;
  --font-size-md: 16px;

Tier 2: Alias Tokens (semantic meaning)
  --color-primary: var(--color-blue-500);
  --color-text-primary: var(--color-gray-900);
  --space-component-gap: var(--space-4);

Tier 3: Component Tokens (scoped)
  --button-bg: var(--color-primary);
  --button-text: var(--color-white);
  --button-padding: var(--space-3) var(--space-4);
```

### Token Definition (Style Dictionary)

```json
// tokens/color/base.json
{
  "color": {
    "blue": {
      "50":  { "value": "#EFF6FF", "type": "color" },
      "100": { "value": "#DBEAFE", "type": "color" },
      "200": { "value": "#BFDBFE", "type": "color" },
      "300": { "value": "#93C5FD", "type": "color" },
      "400": { "value": "#60A5FA", "type": "color" },
      "500": { "value": "#2563EB", "type": "color" },
      "600": { "value": "#1D4ED8", "type": "color" },
      "700": { "value": "#1E40AF", "type": "color" },
      "800": { "value": "#1E3A8A", "type": "color" },
      "900": { "value": "#1E3B5F", "type": "color" }
    }
  }
}
```

```json
// tokens/semantic/light.json
{
  "color": {
    "bg": {
      "primary":   { "value": "{color.white}", "type": "color" },
      "secondary": { "value": "{color.gray.50}", "type": "color" },
      "inverse":   { "value": "{color.gray.900}", "type": "color" }
    },
    "text": {
      "primary":   { "value": "{color.gray.900}", "type": "color" },
      "secondary": { "value": "{color.gray.600}", "type": "color" },
      "inverse":   { "value": "{color.white}", "type": "color" }
    },
    "action": {
      "primary":       { "value": "{color.blue.500}", "type": "color" },
      "primary-hover": { "value": "{color.blue.600}", "type": "color" },
      "danger":        { "value": "{color.red.500}", "type": "color" }
    }
  }
}
```

### Style Dictionary Configuration

```javascript
// style-dictionary.config.js
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'dist/css/',
      files: [{
        destination: 'tokens.css',
        format: 'css/variables',
        options: { outputReferences: true },
      }],
    },
    scss: {
      transformGroup: 'scss',
      buildPath: 'dist/scss/',
      files: [{
        destination: '_tokens.scss',
        format: 'scss/variables',
      }],
    },
    ts: {
      transformGroup: 'js',
      buildPath: 'dist/ts/',
      files: [{
        destination: 'tokens.ts',
        format: 'javascript/es6',
      }],
    },
    ios: {
      transformGroup: 'ios-swift-separate',
      buildPath: 'dist/ios/',
      files: [{
        destination: 'Tokens.swift',
        format: 'ios-swift/enum.swift',
        className: 'DesignTokens',
      }],
    },
    android: {
      transformGroup: 'android',
      buildPath: 'dist/android/',
      files: [{
        destination: 'tokens.xml',
        format: 'android/resources',
      }],
    },
  },
};
```

Output:

```css
/* dist/css/tokens.css */
:root {
  --color-blue-500: #2563EB;
  --color-bg-primary: #FFFFFF;
  --color-text-primary: var(--color-gray-900);
  --color-action-primary: var(--color-blue-500);
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
}
```

---

## Component Library

### Component API Design Principles

1. **Consistent prop naming** across all components
2. **Composition over configuration** (use slots/children, not mega-props)
3. **Accessibility built-in** (ARIA, keyboard, focus management)
4. **Theme-aware** (uses tokens, supports variants)
5. **Polymorphic** (render as different HTML elements via `as` prop)

### Button Component Example

```typescript
// packages/react/src/Button/Button.tsx
import { forwardRef, type ButtonHTMLAttributes } from 'react';
import { clsx } from 'clsx';
import styles from './Button.module.css';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
  fullWidth?: boolean;
  as?: React.ElementType;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  function Button(
    {
      variant = 'primary',
      size = 'md',
      isLoading = false,
      leftIcon,
      rightIcon,
      fullWidth = false,
      disabled,
      children,
      className,
      as: Component = 'button',
      ...props
    },
    ref
  ) {
    const isDisabled = disabled || isLoading;

    return (
      <Component
        ref={ref}
        className={clsx(
          styles.button,
          styles[variant],
          styles[size],
          fullWidth && styles.fullWidth,
          isLoading && styles.loading,
          className
        )}
        disabled={isDisabled}
        aria-disabled={isDisabled}
        aria-busy={isLoading}
        {...props}
      >
        {isLoading && <Spinner className={styles.spinner} size={size} />}
        {!isLoading && leftIcon && (
          <span className={styles.icon} aria-hidden="true">{leftIcon}</span>
        )}
        <span className={styles.label}>{children}</span>
        {!isLoading && rightIcon && (
          <span className={styles.icon} aria-hidden="true">{rightIcon}</span>
        )}
      </Component>
    );
  }
);
```

```css
/* packages/react/src/Button/Button.module.css */
.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  border: 1px solid transparent;
  border-radius: var(--radius-md);
  font-family: var(--font-family-sans);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  transition: background-color 150ms, border-color 150ms, color 150ms;
}
.button:focus-visible {
  outline: 3px solid var(--color-focus-ring);
  outline-offset: 2px;
}
.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Variants */
.primary {
  background: var(--color-action-primary);
  color: var(--color-text-inverse);
}
.primary:hover:not(:disabled) {
  background: var(--color-action-primary-hover);
}

.secondary {
  background: transparent;
  color: var(--color-action-primary);
  border-color: var(--color-action-primary);
}

.ghost {
  background: transparent;
  color: var(--color-text-primary);
}
.ghost:hover:not(:disabled) {
  background: var(--color-bg-secondary);
}

.danger {
  background: var(--color-action-danger);
  color: var(--color-text-inverse);
}

/* Sizes */
.sm { height: 32px; padding: 0 var(--space-3); font-size: var(--font-size-sm); }
.md { height: 40px; padding: 0 var(--space-4); font-size: var(--font-size-md); }
.lg { height: 48px; padding: 0 var(--space-5); font-size: var(--font-size-lg); }

.fullWidth { width: 100%; }

.loading .label { opacity: 0; }
.spinner { position: absolute; }
```

---

## Storybook

### Configuration

```typescript
// .storybook/main.ts
import type { StorybookConfig } from '@storybook/react-vite';

const config: StorybookConfig = {
  stories: ['../packages/react/src/**/*.stories.@(ts|tsx)'],
  addons: [
    '@storybook/addon-essentials',
    '@storybook/addon-a11y',
    '@storybook/addon-interactions',
    '@storybook/addon-designs',
    'storybook-dark-mode',
  ],
  framework: {
    name: '@storybook/react-vite',
    options: {},
  },
  docs: {
    autodocs: 'tag',
  },
};

export default config;
```

### Component Story

```typescript
// packages/react/src/Button/Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { Button } from './Button';
import { PlusIcon, ArrowRightIcon } from '../icons';

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'ghost', 'danger'],
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
    },
  },
  args: {
    onClick: fn(),
    children: 'Button',
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: { variant: 'primary', children: 'Primary Button' },
};

export const Secondary: Story = {
  args: { variant: 'secondary', children: 'Secondary Button' },
};

export const WithIcons: Story = {
  args: {
    leftIcon: <PlusIcon />,
    children: 'Add Item',
  },
};

export const Loading: Story = {
  args: { isLoading: true, children: 'Saving...' },
};

export const AllVariants: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="danger">Danger</Button>
    </div>
  ),
};

export const AllSizes: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: 16, alignItems: 'center' }}>
      <Button size="sm">Small</Button>
      <Button size="md">Medium</Button>
      <Button size="lg">Large</Button>
    </div>
  ),
};
```

---

## Versioning Strategy

### Semantic Versioning for Design Systems

```
MAJOR.MINOR.PATCH
  |     |     |
  |     |     └── Bug fixes, token value adjustments
  |     └── New components, new variants, new tokens
  └── Breaking changes: removed components, renamed props, changed token names
```

### Changelog Automation

```json
// package.json
{
  "scripts": {
    "changeset": "changeset",
    "version": "changeset version",
    "release": "changeset publish"
  }
}
```

```markdown
<!-- .changeset/awesome-change.md -->
---
"@myds/react": minor
"@myds/tokens": minor
---

Added new `Badge` component with `success`, `warning`, `error`, and `info` variants.
```

### Package Structure (Monorepo)

```
design-system/
  packages/
    tokens/                  # Design tokens (CSS, SCSS, TS, iOS, Android)
      package.json           # @myds/tokens
    react/                   # React component library
      package.json           # @myds/react
    vue/                     # Vue component library (optional)
      package.json           # @myds/vue
    icons/                   # Icon library
      package.json           # @myds/icons
    eslint-plugin/           # Lint rules for DS usage
      package.json           # @myds/eslint-plugin
  .storybook/
  .changeset/
  package.json
  turbo.json
```

---

## Multi-Framework Support

### Strategy: Web Components as Base

```
Design Tokens (source of truth)
       │
       ├── CSS Custom Properties
       │
       ├── React Components (@myds/react)
       │    └── Wraps tokens + React patterns
       │
       ├── Vue Components (@myds/vue)
       │    └── Wraps tokens + Vue patterns
       │
       └── Web Components (@myds/web)
            └── Framework-agnostic base
```

### Alternative: Shared Styles, Framework-Specific Components

```typescript
// packages/core/src/button.styles.ts (shared)
export const buttonStyles = {
  base: 'inline-flex items-center justify-center font-medium rounded-md transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2',
  variants: {
    primary: 'bg-blue-500 text-white hover:bg-blue-600',
    secondary: 'border border-blue-500 text-blue-500 hover:bg-blue-50',
    ghost: 'text-gray-700 hover:bg-gray-100',
    danger: 'bg-red-500 text-white hover:bg-red-600',
  },
  sizes: {
    sm: 'h-8 px-3 text-sm',
    md: 'h-10 px-4 text-base',
    lg: 'h-12 px-5 text-lg',
  },
};
```

---

## Visual Regression Testing

### Chromatic (Recommended)

```yaml
# .github/workflows/chromatic.yml
name: Visual Tests

on: push

jobs:
  chromatic:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - run: npm ci
      - uses: chromaui/action@latest
        with:
          projectToken: ${{ secrets.CHROMATIC_TOKEN }}
          autoAcceptChanges: main
```

### Playwright Visual Tests (Self-Hosted Alternative)

```typescript
// tests/visual/button.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Button', () => {
  test('primary variant', async ({ page }) => {
    await page.goto('/iframe.html?id=components-button--primary');
    await expect(page.locator('.button')).toHaveScreenshot('button-primary.png');
  });

  test('all variants', async ({ page }) => {
    await page.goto('/iframe.html?id=components-button--all-variants');
    await expect(page.locator('body')).toHaveScreenshot('button-all-variants.png');
  });
});
```

---

## Adoption Metrics

| Metric | How to Measure | Target |
|--------|---------------|--------|
| Component coverage | % of UI built with DS components | >80% |
| Token usage | % of styles using tokens vs hardcoded | >90% |
| Storybook coverage | Components with stories / total components | 100% |
| Accessibility score | axe-core violations per component | 0 |
| Breaking changes | Major versions per year | <2 |
| Adoption rate | Teams using DS / total teams | >90% |
| Custom overrides | CSS overrides per app | <10 |

---

## Cross-References

- `3-build/accessibility_implementation` - Accessible component patterns
- `2-design/inclusive_design_patterns` - Inclusive design tokens (contrast, motion)
- `toolkit/documentation_as_code` - Component documentation strategies
- `3-build/internal_developer_portal` - Design system in service catalog

---

## EXIT CHECKLIST

- [ ] Design tokens defined with 3-tier architecture (global, alias, component)
- [ ] Style Dictionary configured to output CSS, TS, iOS, Android
- [ ] Core components built (Button, Input, Select, Modal, Card, Typography)
- [ ] All components accessible (ARIA, keyboard, focus, contrast)
- [ ] Storybook configured with autodocs, a11y addon, and interactions
- [ ] Visual regression testing set up (Chromatic or Playwright)
- [ ] Semantic versioning with changesets
- [ ] Package published to npm registry (public or private)
- [ ] ESLint plugin enforces design system usage
- [ ] Migration guide exists for adopting teams
- [ ] Figma-to-token sync configured (if applicable)

---

*Skill Version: 1.0 | Created: March 2026*
