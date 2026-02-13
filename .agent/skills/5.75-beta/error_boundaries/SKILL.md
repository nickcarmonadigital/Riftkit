---
name: error_boundaries
description: React error boundaries, toast notifications, and graceful error handling UI
---

# Error Boundaries Skill

**Purpose**: Eliminate white-screen crashes and unhandled errors by implementing React error boundaries, a toast notification system, and comprehensive API error handling throughout the application.

## :dart: TRIGGER COMMANDS

```text
"add error boundaries"
"error handling UI"
"toast system"
"set up error handling"
"Using error_boundaries skill: add error handling to [project]"
```

## :rotating_light: REACT ERROR BOUNDARY

### Core Error Boundary Component

```typescript
// src/components/ErrorBoundary.tsx
import React, { Component, ErrorInfo, ReactNode } from 'react';

interface ErrorBoundaryProps {
  children: ReactNode;
  fallback?: ReactNode;
  onError?: (error: Error, errorInfo: ErrorInfo) => void;
  level?: 'page' | 'widget';
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    // Log to console in development
    console.error('[ErrorBoundary] Caught error:', error, errorInfo);

    // Report to Sentry (if configured)
    if (typeof window !== 'undefined' && (window as any).Sentry) {
      (window as any).Sentry.captureException(error, {
        contexts: { react: { componentStack: errorInfo.componentStack } },
      });
    }

    // Call custom error handler
    this.props.onError?.(error, errorInfo);
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) return this.props.fallback;

      return this.props.level === 'widget' ? (
        <WidgetErrorFallback error={this.state.error} onRetry={this.handleRetry} />
      ) : (
        <PageErrorFallback error={this.state.error} onRetry={this.handleRetry} />
      );
    }

    return this.props.children;
  }
}
```

### Page-Level Fallback

```typescript
// src/components/PageErrorFallback.tsx
interface ErrorFallbackProps {
  error: Error | null;
  onRetry: () => void;
}

export function PageErrorFallback({ error, onRetry }: ErrorFallbackProps) {
  return (
    <div className="flex min-h-[60vh] flex-col items-center justify-center px-4">
      <div className="text-center max-w-md">
        <div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-red-100">
          <svg className="h-8 w-8 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                  d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
          Something went wrong
        </h2>
        <p className="mt-2 text-sm text-gray-500 dark:text-gray-400">
          An unexpected error occurred. Our team has been notified.
        </p>
        {error && process.env.NODE_ENV === 'development' && (
          <pre className="mt-4 max-h-40 overflow-auto rounded-md bg-gray-100 p-3 text-left text-xs text-red-700 dark:bg-gray-800 dark:text-red-400">
            {error.message}
            {'\n'}
            {error.stack}
          </pre>
        )}
        <div className="mt-6 flex gap-3 justify-center">
          <button
            onClick={onRetry}
            className="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
          >
            Try Again
          </button>
          <button
            onClick={() => (window.location.href = '/')}
            className="rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 dark:border-gray-600 dark:text-gray-300"
          >
            Go Home
          </button>
        </div>
      </div>
    </div>
  );
}
```

### Widget-Level Fallback

```typescript
// src/components/WidgetErrorFallback.tsx
export function WidgetErrorFallback({ error, onRetry }: ErrorFallbackProps) {
  return (
    <div className="rounded-lg border border-red-200 bg-red-50 p-4 dark:border-red-800 dark:bg-red-900/20">
      <div className="flex items-center gap-2">
        <svg className="h-4 w-4 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <span className="text-sm font-medium text-red-700 dark:text-red-400">
          This section failed to load
        </span>
      </div>
      <button
        onClick={onRetry}
        className="mt-2 text-xs font-medium text-red-600 underline hover:text-red-800"
      >
        Retry
      </button>
    </div>
  );
}
```

## :jigsaw: GRANULAR ERROR BOUNDARY PLACEMENT

### Strategy: Per-Page + Per-Widget

```text
App
 +-- ErrorBoundary (level="page")     <-- catches catastrophic failures
      +-- Layout
           +-- Sidebar
           +-- Main Content
                +-- ErrorBoundary (level="page")     <-- per-route
                |    +-- DashboardPage
                |         +-- ErrorBoundary (level="widget")  <-- per-widget
                |         |    +-- RevenueChart
                |         +-- ErrorBoundary (level="widget")
                |         |    +-- ActivityFeed
                |         +-- ErrorBoundary (level="widget")
                |              +-- QuickActions
                +-- ErrorBoundary (level="page")
                     +-- ContactsPage
```

> [!TIP]
> Use `level="widget"` for non-critical UI sections (charts, feeds, widgets). If one widget crashes, the rest of the page remains functional. Use `level="page"` for entire route pages.

### Route-Level Error Boundaries

```typescript
// src/router.tsx
import { createBrowserRouter } from 'react-router-dom';
import { ErrorBoundary } from './components/ErrorBoundary';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <Layout />,
    errorElement: <PageErrorFallback error={null} onRetry={() => window.location.reload()} />,
    children: [
      {
        path: 'dashboard',
        element: (
          <ErrorBoundary level="page">
            <DashboardPage />
          </ErrorBoundary>
        ),
      },
      {
        path: 'contacts',
        element: (
          <ErrorBoundary level="page">
            <ContactsPage />
          </ErrorBoundary>
        ),
      },
      {
        path: 'pipeline',
        element: (
          <ErrorBoundary level="page">
            <PipelinePage />
          </ErrorBoundary>
        ),
      },
    ],
  },
]);
```

## :speech_balloon: TOAST NOTIFICATION SYSTEM

### Toast Types

| Type | Color | Icon | Auto-Dismiss | Use Case |
|------|-------|------|-------------|----------|
| Success | Green | Checkmark | 5 seconds | Action completed |
| Error | Red | X circle | Manual close | API failure, validation |
| Warning | Yellow/Amber | Triangle | 8 seconds | Non-blocking issues |
| Info | Blue | Info circle | 5 seconds | Neutral updates |

### Toast Context and Provider

```typescript
// src/providers/ToastProvider.tsx
import React, { createContext, useCallback, useContext, useState } from 'react';

type ToastType = 'success' | 'error' | 'warning' | 'info';

interface Toast {
  id: string;
  type: ToastType;
  title: string;
  message?: string;
  duration: number;
}

interface ToastContextType {
  toasts: Toast[];
  addToast: (type: ToastType, title: string, message?: string, duration?: number) => void;
  removeToast: (id: string) => void;
  success: (title: string, message?: string) => void;
  error: (title: string, message?: string) => void;
  warning: (title: string, message?: string) => void;
  info: (title: string, message?: string) => void;
}

const ToastContext = createContext<ToastContextType | null>(null);

const DEFAULT_DURATIONS: Record<ToastType, number> = {
  success: 5000,
  error: 0, // persistent, must be manually closed
  warning: 8000,
  info: 5000,
};

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = useState<Toast[]>([]);

  const removeToast = useCallback((id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  const addToast = useCallback(
    (type: ToastType, title: string, message?: string, duration?: number) => {
      const id = `toast-${Date.now()}-${Math.random().toString(36).slice(2)}`;
      const resolvedDuration = duration ?? DEFAULT_DURATIONS[type];

      setToasts((prev) => [...prev, { id, type, title, message, duration: resolvedDuration }]);

      if (resolvedDuration > 0) {
        setTimeout(() => removeToast(id), resolvedDuration);
      }
    },
    [removeToast],
  );

  const value: ToastContextType = {
    toasts,
    addToast,
    removeToast,
    success: (title, message) => addToast('success', title, message),
    error: (title, message) => addToast('error', title, message),
    warning: (title, message) => addToast('warning', title, message),
    info: (title, message) => addToast('info', title, message),
  };

  return <ToastContext.Provider value={value}>{children}</ToastContext.Provider>;
}

export function useToast() {
  const ctx = useContext(ToastContext);
  if (!ctx) throw new Error('useToast must be used within ToastProvider');
  return ctx;
}
```

### Toast Container Component

```typescript
// src/components/ToastContainer.tsx
import { useToast } from '../providers/ToastProvider';

const STYLES: Record<string, { bg: string; icon: string; border: string }> = {
  success: { bg: 'bg-green-50 dark:bg-green-900/20', icon: 'text-green-500', border: 'border-green-200 dark:border-green-800' },
  error:   { bg: 'bg-red-50 dark:bg-red-900/20',     icon: 'text-red-500',   border: 'border-red-200 dark:border-red-800' },
  warning: { bg: 'bg-amber-50 dark:bg-amber-900/20',  icon: 'text-amber-500', border: 'border-amber-200 dark:border-amber-800' },
  info:    { bg: 'bg-blue-50 dark:bg-blue-900/20',    icon: 'text-blue-500',  border: 'border-blue-200 dark:border-blue-800' },
};

export function ToastContainer() {
  const { toasts, removeToast } = useToast();

  return (
    <div className="fixed bottom-4 right-4 z-[100] flex flex-col gap-2 max-w-sm">
      {toasts.map((toast) => {
        const style = STYLES[toast.type];
        return (
          <div
            key={toast.id}
            className={`flex items-start gap-3 rounded-lg border p-4 shadow-lg
                       ${style.bg} ${style.border} animate-slide-in`}
            role="alert"
          >
            <span className={`mt-0.5 ${style.icon}`}>
              {toast.type === 'success' && '✓'}
              {toast.type === 'error' && '✕'}
              {toast.type === 'warning' && '⚠'}
              {toast.type === 'info' && 'ℹ'}
            </span>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-gray-900 dark:text-white">{toast.title}</p>
              {toast.message && (
                <p className="mt-1 text-xs text-gray-600 dark:text-gray-400">{toast.message}</p>
              )}
            </div>
            <button
              onClick={() => removeToast(toast.id)}
              className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
            >
              ✕
            </button>
          </div>
        );
      })}
    </div>
  );
}
```

### Toast CSS Animation

```css
/* Add to your global CSS / tailwind config */
@keyframes slide-in {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

.animate-slide-in {
  animation: slide-in 0.3s ease-out;
}
```

## :globe_with_meridians: API ERROR HANDLING

### Axios Error Interceptor

```typescript
// src/lib/api.ts
import axios, { AxiosError } from 'axios';

// Store toast reference for use outside React
let toastRef: {
  error: (title: string, message?: string) => void;
  warning: (title: string, message?: string) => void;
} | null = null;

export function setToastRef(ref: typeof toastRef) {
  toastRef = ref;
}

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || '/api',
  timeout: 30000,
});

// Request interceptor: attach JWT
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// Response interceptor: handle errors globally
api.interceptors.response.use(
  (response) => response,
  (error: AxiosError<{ message?: string; statusCode?: number }>) => {
    const status = error.response?.status;
    const message = error.response?.data?.message || error.message;

    // Network error (no response)
    if (!error.response) {
      toastRef?.error('Network Error', 'Unable to reach the server. Check your connection.');
      return Promise.reject(error);
    }

    switch (status) {
      case 401:
        // Token expired or invalid — redirect to login
        localStorage.removeItem('token');
        window.location.href = '/login';
        break;
      case 403:
        toastRef?.error('Access Denied', 'You do not have permission for this action.');
        break;
      case 404:
        toastRef?.warning('Not Found', message);
        break;
      case 422:
        toastRef?.error('Validation Error', message);
        break;
      case 429:
        toastRef?.warning('Too Many Requests', 'Please slow down and try again in a moment.');
        break;
      case 500:
        toastRef?.error('Server Error', 'Something went wrong on our end. Please try again.');
        break;
      default:
        toastRef?.error('Error', message);
    }

    return Promise.reject(error);
  },
);

export default api;
```

### Wire up Toast ref in App

```typescript
// src/App.tsx
import { useEffect } from 'react';
import { useToast } from './providers/ToastProvider';
import { setToastRef } from './lib/api';
import { ToastContainer } from './components/ToastContainer';

function AppInner() {
  const toast = useToast();

  useEffect(() => {
    setToastRef(toast);
    return () => setToastRef(null);
  }, [toast]);

  return (
    <>
      <RouterProvider router={router} />
      <ToastContainer />
    </>
  );
}

export default function App() {
  return (
    <ToastProvider>
      <AppInner />
    </ToastProvider>
  );
}
```

## :satellite: OFFLINE DETECTION

### Offline Banner Component

```typescript
// src/components/OfflineBanner.tsx
import { useEffect, useState } from 'react';

export function OfflineBanner() {
  const [isOffline, setIsOffline] = useState(!navigator.onLine);

  useEffect(() => {
    const handleOnline = () => setIsOffline(false);
    const handleOffline = () => setIsOffline(true);

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  if (!isOffline) return null;

  return (
    <div className="fixed top-0 left-0 right-0 z-[110] bg-amber-500 px-4 py-2 text-center text-sm font-medium text-white shadow-md">
      You are offline. Some features may not be available. Changes will sync when you reconnect.
    </div>
  );
}
```

## :bone: LOADING STATES: SKELETON SCREENS

```typescript
// src/components/Skeleton.tsx
interface SkeletonProps {
  className?: string;
  lines?: number;
}

export function Skeleton({ className = '', lines = 1 }: SkeletonProps) {
  return (
    <div className={`animate-pulse space-y-2 ${className}`}>
      {Array.from({ length: lines }).map((_, i) => (
        <div
          key={i}
          className="h-4 rounded bg-gray-200 dark:bg-gray-700"
          style={{ width: i === lines - 1 ? '60%' : '100%' }}
        />
      ))}
    </div>
  );
}

export function TableSkeleton({ rows = 5, cols = 4 }: { rows?: number; cols?: number }) {
  return (
    <div className="animate-pulse">
      <div className="grid gap-4" style={{ gridTemplateColumns: `repeat(${cols}, 1fr)` }}>
        {Array.from({ length: rows * cols }).map((_, i) => (
          <div key={i} className="h-8 rounded bg-gray-200 dark:bg-gray-700" />
        ))}
      </div>
    </div>
  );
}

export function CardSkeleton() {
  return (
    <div className="animate-pulse rounded-lg border border-gray-200 p-4 dark:border-gray-700">
      <div className="h-4 w-3/4 rounded bg-gray-200 dark:bg-gray-700" />
      <div className="mt-3 h-3 w-full rounded bg-gray-200 dark:bg-gray-700" />
      <div className="mt-2 h-3 w-5/6 rounded bg-gray-200 dark:bg-gray-700" />
      <div className="mt-4 h-8 w-1/3 rounded bg-gray-200 dark:bg-gray-700" />
    </div>
  );
}
```

> [!TIP]
> Use skeleton screens instead of spinners. They provide better perceived performance because the user can see the layout loading, which feels faster than a spinning circle.

## :no_entry: ASYNC ERROR HANDLING RULES

### In useEffect

```typescript
// WRONG - unhandled promise rejection
useEffect(() => {
  fetchData(); // if this throws, it's uncaught
}, []);

// CORRECT - catch errors in useEffect
useEffect(() => {
  const load = async () => {
    try {
      const data = await fetchData();
      setData(data);
    } catch (err) {
      console.error('Failed to load data:', err);
      setError(err instanceof Error ? err : new Error('Unknown error'));
    }
  };
  load();
}, []);
```

### In Event Handlers

```typescript
// WRONG - error crashes silently
const handleSave = async () => {
  await api.post('/contacts', formData); // uncaught if fails
};

// CORRECT - catch and show toast
const handleSave = async () => {
  try {
    await api.post('/contacts', formData);
    toast.success('Contact saved');
  } catch (err) {
    // Error toast already shown by API interceptor
    // Handle any component-specific cleanup here
    console.error('Save failed:', err);
  }
};
```

> [!WARNING]
> Never swallow errors silently. Every `catch` block should either: (1) show a user-facing message, (2) log to error tracking (Sentry), or (3) re-throw for a parent handler. Ideally, do all three.

## :white_check_mark: EXIT CHECKLIST

- [ ] `ErrorBoundary` component created with `componentDidCatch` and Sentry reporting
- [ ] Page-level fallback: "Something went wrong" with retry button and go-home button
- [ ] Widget-level fallback: inline error message with retry, does not crash the page
- [ ] Error boundaries wrap every route in the router
- [ ] Critical widgets wrapped with `level="widget"` error boundaries
- [ ] Toast system: `ToastProvider`, `useToast` hook, `ToastContainer` component
- [ ] Toast types: success (green, 5s), error (red, persistent), warning (amber, 8s), info (blue, 5s)
- [ ] Multiple toasts stack vertically, each has a close button
- [ ] Axios interceptor catches all API errors and shows appropriate toast
- [ ] 401 errors redirect to login, 429 shows rate limit message
- [ ] Offline banner appears when network is lost, disappears on reconnect
- [ ] Skeleton screens used for loading states instead of spinners
- [ ] All `useEffect` async calls wrapped in try/catch
- [ ] All event handler async calls wrapped in try/catch
- [ ] No white screens of death anywhere in the application
- [ ] Errors logged to console (dev) and Sentry (production)

*Skill Version: 1.0 | Created: February 2026*
