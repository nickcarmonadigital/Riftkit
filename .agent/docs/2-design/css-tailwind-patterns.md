# CSS & Tailwind Patterns

> **Utility-first CSS with Tailwind.** Instead of writing custom CSS files, compose styles from pre-built utility classes directly in your markup.

---

## Flexbox with Tailwind

```html
<!-- Horizontal layout with gap -->
<div class="flex items-center gap-4">
  <Avatar />
  <span>Username</span>
  <button>Settings</button>
</div>

<!-- Vertical layout (stack) -->
<div class="flex flex-col gap-2">
  <Label />
  <Input />
  <ErrorMessage />
</div>

<!-- Space between (header pattern) -->
<header class="flex items-center justify-between px-6 py-4">
  <Logo />
  <nav class="flex gap-6">...</nav>
  <UserMenu />
</header>

<!-- Center content (both axes) -->
<div class="flex items-center justify-center h-screen">
  <LoginCard />
</div>

<!-- Wrap items -->
<div class="flex flex-wrap gap-2">
  {tags.map(tag => <Badge key={tag}>{tag}</Badge>)}
</div>
```

### Flex Utilities Reference

| Class | CSS | Purpose |
|-------|-----|---------|
| `flex` | `display: flex` | Enable flexbox |
| `flex-col` | `flex-direction: column` | Stack vertically |
| `items-center` | `align-items: center` | Center vertically |
| `items-start` | `align-items: flex-start` | Align to top |
| `justify-between` | `justify-content: space-between` | Push apart |
| `justify-center` | `justify-content: center` | Center horizontally |
| `gap-4` | `gap: 1rem` | Space between items |
| `flex-1` | `flex: 1 1 0%` | Grow to fill space |
| `flex-shrink-0` | `flex-shrink: 0` | Don't shrink |
| `flex-wrap` | `flex-wrap: wrap` | Wrap to next line |

---

## CSS Grid with Tailwind

```html
<!-- 3-column grid -->
<div class="grid grid-cols-3 gap-6">
  <Card />
  <Card />
  <Card />
</div>

<!-- Responsive grid (1 col mobile, 2 tablet, 3 desktop) -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
  {items.map(item => <Card key={item.id} />)}
</div>

<!-- Dashboard layout with sidebar -->
<div class="grid grid-cols-[250px_1fr] h-screen">
  <Sidebar />
  <main class="overflow-auto p-6">
    <Outlet />
  </main>
</div>

<!-- Spanning columns -->
<div class="grid grid-cols-4 gap-4">
  <div class="col-span-4">Full-width header</div>
  <div class="col-span-1">Sidebar</div>
  <div class="col-span-3">Main content</div>
</div>
```

---

## Responsive Design

### Mobile-First Approach

Tailwind breakpoints build UP from mobile. Base styles = mobile, then add larger screen styles.

```html
<!-- Mobile: stack, Tablet: side-by-side, Desktop: 3 columns -->
<div class="flex flex-col md:flex-row lg:grid lg:grid-cols-3 gap-4">
  ...
</div>

<!-- Mobile: full width, Desktop: max width centered -->
<div class="w-full max-w-4xl mx-auto px-4 md:px-6 lg:px-8">
  ...
</div>

<!-- Mobile: hidden, Desktop: visible -->
<nav class="hidden md:flex gap-4">Desktop nav</nav>
<button class="md:hidden">Mobile menu</button>
```

### Breakpoints

| Prefix | Min Width | Typical Device |
|--------|-----------|---------------|
| (none) | 0px | Mobile (default) |
| `sm:` | 640px | Large phone / small tablet |
| `md:` | 768px | Tablet |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |
| `2xl:` | 1536px | Large desktop |

---

## Component Patterns

### Button Variants

```tsx
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}

const variants = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300',
  outline: 'border border-gray-300 text-gray-700 hover:bg-gray-50',
  ghost: 'text-gray-700 hover:bg-gray-100',
  danger: 'bg-red-600 text-white hover:bg-red-700',
};

const sizes = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg',
};

function Button({ variant = 'primary', size = 'md', loading, children, onClick }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={loading}
      className={cn(
        'inline-flex items-center justify-center rounded-md font-medium transition-colors',
        'focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2',
        'disabled:opacity-50 disabled:pointer-events-none',
        variants[variant],
        sizes[size],
      )}
    >
      {loading && <Spinner className="mr-2 h-4 w-4" />}
      {children}
    </button>
  );
}
```

### Card Component

```tsx
function Card({ children, className }: { children: React.ReactNode; className?: string }) {
  return (
    <div className={cn(
      'rounded-lg border border-gray-200 bg-white shadow-sm',
      'hover:shadow-md transition-shadow',
      className,
    )}>
      {children}
    </div>
  );
}

function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="px-6 py-4 border-b border-gray-200">{children}</div>;
}

function CardBody({ children }: { children: React.ReactNode }) {
  return <div className="px-6 py-4">{children}</div>;
}

function CardFooter({ children }: { children: React.ReactNode }) {
  return <div className="px-6 py-4 border-t border-gray-100 bg-gray-50">{children}</div>;
}
```

### Modal / Dialog

```tsx
function Modal({ open, onClose, title, children }: ModalProps) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Overlay */}
      <div
        className="fixed inset-0 bg-black/50 transition-opacity"
        onClick={onClose}
      />

      {/* Modal content */}
      <div className="relative z-10 w-full max-w-lg mx-4 bg-white rounded-xl shadow-xl">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b">
          <h2 className="text-lg font-semibold">{title}</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
            <XIcon className="h-5 w-5" />
          </button>
        </div>

        {/* Body */}
        <div className="px-6 py-4 max-h-[60vh] overflow-y-auto">
          {children}
        </div>
      </div>
    </div>
  );
}
```

### Form Input

```tsx
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
}

function Input({ label, error, className, ...props }: InputProps) {
  return (
    <div className="space-y-1">
      <label className="block text-sm font-medium text-gray-700">
        {label}
      </label>
      <input
        className={cn(
          'w-full rounded-md border px-3 py-2 text-sm',
          'focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent',
          'placeholder:text-gray-400',
          error
            ? 'border-red-500 focus:ring-red-500'
            : 'border-gray-300',
          className,
        )}
        {...props}
      />
      {error && (
        <p className="text-sm text-red-500">{error}</p>
      )}
    </div>
  );
}
```

---

## Design System Setup

### tailwind.config.ts

```typescript
import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  darkMode: 'class', // Toggle via class, not system preference
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          900: '#1e3a8a',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
};

export default config;
```

### cn() Utility (clsx + tailwind-merge)

```typescript
// lib/utils.ts
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Usage — handles conditional classes and prevents conflicts
<div className={cn(
  'rounded-lg p-4',
  isActive && 'bg-blue-500 text-white',
  isDisabled && 'opacity-50 pointer-events-none',
  className, // Allows parent to override
)} />
```

### Dark Mode

```tsx
// Toggle dark mode
function ThemeToggle() {
  const { theme, setTheme } = useUIStore();

  return (
    <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
      {theme === 'light' ? <MoonIcon /> : <SunIcon />}
    </button>
  );
}

// In your root layout
<html className={theme === 'dark' ? 'dark' : ''}>

// Component with dark mode support
<div className="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
  <p className="text-gray-600 dark:text-gray-400">Content</p>
</div>
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Do This Instead |
|-------------|-------------|----------------|
| Inline style objects everywhere | Inconsistent, no responsive/hover/dark | Use Tailwind classes |
| `@apply` for everything | Defeats the purpose of utility-first | Only `@apply` for truly shared base styles |
| Fighting Tailwind (overriding with `!important`) | Means you're using the wrong approach | Use Tailwind's built-in modifiers |
| Creating custom CSS for every component | Style bloat, inconsistency | Compose from existing utilities |
| Not using a consistent spacing scale | Visual inconsistency | Stick to Tailwind's default scale (4, 6, 8, etc.) |
| Hardcoding colors instead of using theme | Can't change theme or dark mode | Use your design tokens from tailwind.config |

---

*CSS & Tailwind Patterns v1.0 | Created: February 13, 2026*
