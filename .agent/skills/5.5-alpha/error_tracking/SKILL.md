---
name: error_tracking
description: Sentry setup for production error monitoring across NestJS, React, and Next.js
---

# Error Tracking Skill

**Purpose**: Set up Sentry for production error monitoring so crashes, unhandled exceptions, and performance issues are caught, reported, and alerted on before users complain.

## 🎯 TRIGGER COMMANDS

```text
"set up Sentry"
"add error tracking"
"production monitoring"
"configure error reporting"
"Using error_tracking skill: integrate Sentry into the stack"
```

## 📦 PACKAGE INSTALLATION

Install the correct Sentry SDK for each platform in your stack:

| Platform | Package | Version |
|----------|---------|---------|
| NestJS Backend | `@sentry/nestjs @sentry/profiling-node` | 8.x+ |
| React Frontend | `@sentry/react` | 8.x+ |
| Next.js Website | `@sentry/nextjs` | 8.x+ |

```bash
# Backend
cd backend && npm install @sentry/nestjs @sentry/profiling-node

# React Frontend
cd frontend && npm install @sentry/react

# Next.js Website
cd website && npm install @sentry/nextjs
npx @sentry/wizard@latest -i nextjs
```

## 🏗️ SENTRY PROJECT SETUP

1. Create a Sentry account at [sentry.io](https://sentry.io)
2. Create one **Sentry Project per deployable unit** (backend, frontend, website)
3. Grab the DSN from **Settings → Projects → [Project] → Client Keys (DSN)**
4. Store each DSN in `.env`:

```bash
# Backend .env
SENTRY_DSN=https://examplePublicKey@o0.ingest.sentry.io/0
SENTRY_ENVIRONMENT=production
SENTRY_RELEASE=  # set at build time via git SHA

# Frontend .env
VITE_SENTRY_DSN=https://examplePublicKey@o0.ingest.sentry.io/1

# Next.js .env
NEXT_PUBLIC_SENTRY_DSN=https://examplePublicKey@o0.ingest.sentry.io/2
```

> [!WARNING]
> DSNs are **public** keys (safe in frontend bundles) but should still live in env vars so you can rotate them or disable Sentry per environment.

## 🔧 BACKEND: NestJS INTEGRATION

### Sentry Module Initialization

Create `src/sentry/sentry.module.ts`:

```typescript
import { Module } from '@nestjs/common';
import { SentryModule as SentryNestModule } from '@sentry/nestjs/setup';

@Module({
  imports: [SentryNestModule.forRoot()],
})
export class SentryModule {}
```

### Instrument File (loaded before anything else)

Create `src/instrument.ts` — this MUST be imported at the very top of `main.ts`:

```typescript
import * as Sentry from '@sentry/nestjs';
import { nodeProfilingIntegration } from '@sentry/profiling-node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.SENTRY_ENVIRONMENT || 'development',
  release: process.env.SENTRY_RELEASE || 'dev',
  integrations: [nodeProfilingIntegration()],
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.2 : 1.0,
  profilesSampleRate: 0.1,
  beforeSend(event) {
    // Scrub sensitive data
    if (event.request?.headers) {
      delete event.request.headers['authorization'];
      delete event.request.headers['cookie'];
    }
    if (event.request?.data) {
      const data =
        typeof event.request.data === 'string'
          ? event.request.data
          : JSON.stringify(event.request.data);
      event.request.data = data
        .replace(/"password"\s*:\s*"[^"]*"/g, '"password":"[REDACTED]"')
        .replace(/"token"\s*:\s*"[^"]*"/g, '"token":"[REDACTED]"')
        .replace(/\b\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}\b/g, '[CARD_REDACTED]');
    }
    return event;
  },
});
```

### main.ts — Import Order Matters

```typescript
import './instrument'; // MUST be first import
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // ... your setup
  await app.listen(3000);
}
bootstrap();
```

### Global Exception Filter with Sentry

```typescript
import { Catch, ArgumentsHost, HttpException, HttpStatus } from '@nestjs/common';
import { BaseExceptionFilter } from '@nestjs/core';
import * as Sentry from '@sentry/nestjs';

@Catch()
export class SentryExceptionFilter extends BaseExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    // Only report 5xx errors to Sentry (not 4xx client errors)
    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      if (status >= 500) {
        Sentry.captureException(exception);
      }
    } else {
      // Non-HTTP exceptions are always reported
      Sentry.captureException(exception);
    }
    super.catch(exception, host);
  }
}
```

### User Context on Login

```typescript
import * as Sentry from '@sentry/nestjs';

// In your auth guard or middleware, after JWT verification:
Sentry.setUser({
  id: user.sub,
  email: user.email,
});

// On logout:
Sentry.setUser(null);
```

## ⚛️ FRONTEND: React INTEGRATION

### Sentry Initialization

Create `src/sentry.ts` — import at the top of `main.tsx`:

```typescript
import * as Sentry from '@sentry/react';

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN,
  environment: import.meta.env.MODE,
  release: import.meta.env.VITE_APP_VERSION || 'dev',
  integrations: [
    Sentry.browserTracingIntegration(),
    Sentry.replayIntegration({
      maskAllText: true,
      blockAllMedia: true,
    }),
  ],
  tracesSampleRate: import.meta.env.PROD ? 0.2 : 1.0,
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
  beforeSend(event) {
    // Filter noise
    if (event.exception?.values?.some(
      (e) => e.type === 'ResizeObserver loop' ||
             e.value?.includes('ResizeObserver loop')
    )) {
      return null;
    }
    // Drop network errors in development
    if (!import.meta.env.PROD && event.exception?.values?.some(
      (e) => e.value?.includes('Failed to fetch') ||
             e.value?.includes('NetworkError')
    )) {
      return null;
    }
    return event;
  },
});
```

### ErrorBoundary Component

```tsx
import * as Sentry from '@sentry/react';

function FallbackComponent({ error, resetError }: { error: Error; resetError: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[400px] p-8">
      <h2 className="text-xl font-semibold text-red-600 mb-2">Something went wrong</h2>
      <p className="text-gray-600 mb-4">{error.message}</p>
      <button
        onClick={resetError}
        className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      >
        Try Again
      </button>
    </div>
  );
}

// Wrap your app or major sections
export function AppWithErrorBoundary({ children }: { children: React.ReactNode }) {
  return (
    <Sentry.ErrorBoundary fallback={FallbackComponent} showDialog>
      {children}
    </Sentry.ErrorBoundary>
  );
}
```

### User Context in React

```typescript
import * as Sentry from '@sentry/react';

// After login:
Sentry.setUser({ id: user.id, email: user.email });

// After logout:
Sentry.setUser(null);
```

## 🌐 NEXT.JS WEBSITE INTEGRATION

### sentry.client.config.ts

```typescript
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.2 : 1.0,
  replaysOnErrorSampleRate: 1.0,
  replaysSessionSampleRate: 0.1,
  integrations: [
    Sentry.replayIntegration({ maskAllText: true, blockAllMedia: true }),
  ],
});
```

### sentry.server.config.ts

```typescript
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.2 : 1.0,
});
```

### sentry.edge.config.ts

```typescript
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.2 : 1.0,
});
```

### next.config.mjs — Source Map Upload

```javascript
import { withSentryConfig } from '@sentry/nextjs';

const nextConfig = { /* your config */ };

export default withSentryConfig(nextConfig, {
  org: 'your-sentry-org',
  project: 'your-nextjs-project',
  authToken: process.env.SENTRY_AUTH_TOKEN,
  silent: true,
  hideSourceMaps: true,
});
```

## 🗺️ SOURCE MAP CONFIGURATION

| Platform | Method | Notes |
|----------|--------|-------|
| NestJS | `@sentry/nestjs` auto-uploads if `SENTRY_AUTH_TOKEN` set | Add `sentry-cli` to CI |
| React (Vite) | `@sentry/vite-plugin` in `vite.config.ts` | Upload during `vite build` |
| Next.js | `withSentryConfig` wrapper | Built-in with `@sentry/nextjs` |

### Vite Source Map Plugin

```typescript
// vite.config.ts
import { sentryVitePlugin } from '@sentry/vite-plugin';

export default defineConfig({
  build: { sourcemap: true },
  plugins: [
    react(),
    sentryVitePlugin({
      org: 'your-sentry-org',
      project: 'your-react-project',
      authToken: process.env.SENTRY_AUTH_TOKEN,
    }),
  ],
});
```

## 🚀 RELEASE TRACKING

Tag every deploy with the git SHA so Sentry groups errors by release:

```bash
# In CI/CD pipeline
export SENTRY_RELEASE=$(git rev-parse --short HEAD)
export SENTRY_ENVIRONMENT=production

# Pass to build
VITE_APP_VERSION=$SENTRY_RELEASE npm run build
```

## 🔔 ALERT RULES

Configure in Sentry UI under **Alerts → Create Alert Rule**:

| Alert | Condition | Action |
|-------|-----------|--------|
| New Issue | First seen event | Slack #errors + email on-call |
| High Volume | >50 events in 1 hour | Slack #errors + PagerDuty |
| Regression | Resolved issue reappears | Slack #errors + assign to last resolver |
| P0 Endpoint Down | 5xx on `/api/health` | PagerDuty immediate |

> [!TIP]
> Start with just "New Issue → Slack notification." You can add volume-based alerts later once you know your baseline error rate.

## 🔒 PRIVACY: SCRUBBING SENSITIVE DATA

Sentry's `beforeSend` hook (shown above) handles custom scrubbing. Additionally, configure in Sentry UI:

- **Settings → Security & Privacy → Data Scrubbing**: Enable "Scrub data" and "Scrub IP addresses"
- **Advanced Data Scrubbing**: Add rules for credit card patterns, SSNs, API keys
- Never log full request bodies for auth endpoints (`/login`, `/register`, `/reset-password`)

## ✅ EXIT CHECKLIST

- [ ] Sentry project created for each deployable (backend, frontend, website)
- [ ] DSNs stored in environment variables (not hardcoded)
- [ ] Backend: `instrument.ts` imported first in `main.ts`
- [ ] Backend: Global exception filter reports 5xx to Sentry
- [ ] Frontend: `Sentry.init()` runs before React renders
- [ ] Frontend: `ErrorBoundary` wraps the application root
- [ ] Next.js: client, server, and edge configs present
- [ ] Source maps upload during CI build
- [ ] User context attached on login, cleared on logout
- [ ] `beforeSend` scrubs passwords, tokens, and credit card numbers
- [ ] ResizeObserver and network noise filtered out
- [ ] Alert rule: new error sends Slack notification
- [ ] Release tracking tags deploys with git SHA
- [ ] `tracesSampleRate` set to 0.2 in production (not 1.0)
- [ ] Verified: throw a test error, confirm it appears in Sentry dashboard

*Skill Version: 1.0 | Created: February 2026*
