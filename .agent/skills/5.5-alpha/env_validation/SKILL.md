---
name: env_validation
description: Fail-fast startup validation for missing or malformed environment variables
---

# Environment Validation Skill

**Purpose**: Ensure your application fails immediately at startup with a clear, actionable error message when required environment variables are missing or malformed, instead of crashing mysteriously 30 minutes later when code finally tries to use an undefined value.

## 🎯 TRIGGER COMMANDS

```text
"validate env vars"
"environment validation"
"fail-fast startup"
"check environment variables"
"Using env_validation skill: add startup env validation"
```

## 📦 PACKAGE INSTALLATION

```bash
# Backend (NestJS)
cd backend && npm install @nestjs/config class-validator class-transformer

# Frontend env validation needs no extra packages (build-time check)
```

## 🏗️ ENVIRONMENT VARIABLE CATEGORIES

Classify every env var into one of three categories:

| Category | Behavior | Example |
|----------|----------|---------|
| **REQUIRED** | App refuses to start if missing | `DATABASE_URL`, `JWT_SECRET` |
| **OPTIONAL** | Has a sensible default | `PORT=3000`, `LOG_LEVEL=info` |
| **FEATURE_FLAG** | Enables/disables a feature | `ENABLE_WEBSOCKETS=true`, `ENABLE_AI=false` |

> [!WARNING]
> A "sensible default" for `JWT_SECRET` is NOT acceptable. Secrets must always be REQUIRED with no fallback. Falling back to a default secret is worse than crashing -- it silently runs with a known, insecure value.

## 🔧 BACKEND: NestJS VALIDATION

### EnvironmentVariables Class

Create `src/config/env.validation.ts`:

```typescript
import {
  IsString,
  IsUrl,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsIn,
  IsPort,
  Min,
  Max,
  Matches,
  validateSync,
} from 'class-validator';
import { plainToInstance, Type } from 'class-transformer';

export class EnvironmentVariables {
  // ═══════════════════════════════════════
  // REQUIRED — App will not start without these
  // ═══════════════════════════════════════

  @IsString()
  @Matches(/^postgresql:\/\//, {
    message: 'DATABASE_URL must start with postgresql://',
  })
  DATABASE_URL: string;

  @IsString()
  JWT_SECRET: string;

  @IsString()
  @Matches(/^https?:\/\//, {
    message: 'SENTRY_DSN must be a valid URL',
  })
  @IsOptional()
  SENTRY_DSN?: string;

  // ═══════════════════════════════════════
  // OPTIONAL — Defaults provided
  // ═══════════════════════════════════════

  @IsNumber()
  @Min(1)
  @Max(65535)
  @Type(() => Number)
  @IsOptional()
  PORT: number = 3000;

  @IsString()
  @IsIn(['development', 'staging', 'production', 'test'])
  @IsOptional()
  NODE_ENV: string = 'development';

  @IsString()
  @IsIn(['debug', 'info', 'warn', 'error'])
  @IsOptional()
  LOG_LEVEL: string = 'info';

  @IsUrl({ require_tld: false })
  @IsOptional()
  CORS_ORIGIN: string = 'http://localhost:5173';

  @IsUrl({ require_tld: false })
  @IsOptional()
  REDIS_URL?: string;

  // ═══════════════════════════════════════
  // FEATURE FLAGS — Enable/disable features
  // ═══════════════════════════════════════

  @IsBoolean()
  @Type(() => Boolean)
  @IsOptional()
  ENABLE_WEBSOCKETS: boolean = false;

  @IsBoolean()
  @Type(() => Boolean)
  @IsOptional()
  ENABLE_AI_PROVIDERS: boolean = false;

  @IsBoolean()
  @Type(() => Boolean)
  @IsOptional()
  ENABLE_SWAGGER: boolean = true;
}

/**
 * Validates all environment variables at startup.
 * Returns the validated config or throws with ALL errors listed.
 */
export function validate(config: Record<string, unknown>): EnvironmentVariables {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    enableImplicitConversion: true,
  });

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: false,
    whitelist: true,
  });

  if (errors.length > 0) {
    const errorMessages = errors.map((err) => {
      const constraints = Object.values(err.constraints || {}).join(', ');
      return `  - ${err.property}: ${constraints}`;
    });

    throw new Error(
      `\n\n` +
      `╔══════════════════════════════════════════════════╗\n` +
      `║       ENVIRONMENT VALIDATION FAILED             ║\n` +
      `╠══════════════════════════════════════════════════╣\n` +
      `║ The following environment variables are          ║\n` +
      `║ missing or invalid:                              ║\n` +
      `╚══════════════════════════════════════════════════╝\n\n` +
      errorMessages.join('\n') +
      `\n\n` +
      `Fix these in your .env file or environment.\n` +
      `See .env.example for required variables.\n`,
    );
  }

  return validatedConfig;
}
```

### ConfigModule Integration

In `app.module.ts`:

```typescript
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { validate } from './config/env.validation';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      validate,
      // Load .env file only in development
      envFilePath: process.env.NODE_ENV !== 'production' ? '.env' : undefined,
    }),
    // ... other modules
  ],
})
export class AppModule {}
```

### Using Validated Config in Services

```typescript
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { EnvironmentVariables } from './config/env.validation';

@Injectable()
export class SomeService {
  constructor(private config: ConfigService<EnvironmentVariables, true>) {}

  getPort(): number {
    // Fully typed -- TypeScript knows this is a number
    return this.config.get('PORT');
  }

  isDevelopment(): boolean {
    return this.config.get('NODE_ENV') === 'development';
  }
}
```

## ⚛️ FRONTEND: VITE ENV VALIDATION

Create `src/env.ts` -- import at the top of `main.tsx`:

```typescript
/**
 * Validate VITE_* environment variables at application startup.
 * Vite inlines these at build time, so missing vars = empty strings.
 */

interface EnvConfig {
  VITE_API_URL: string;
  VITE_SENTRY_DSN?: string;
  VITE_APP_VERSION?: string;
  VITE_WS_URL?: string;
}

function validateEnv(): EnvConfig {
  const required: (keyof EnvConfig)[] = ['VITE_API_URL'];
  const missing: string[] = [];

  for (const key of required) {
    if (!import.meta.env[key]) {
      missing.push(key);
    }
  }

  if (missing.length > 0) {
    const message = [
      '======================================',
      ' MISSING ENVIRONMENT VARIABLES',
      '======================================',
      '',
      ...missing.map((v) => `  - ${v}`),
      '',
      'Create a .env file in the frontend root',
      'with these variables. See .env.example.',
      '======================================',
    ].join('\n');

    // In development: show a visible error
    if (import.meta.env.DEV) {
      document.body.innerHTML = `<pre style="color:red;padding:2rem;font-size:16px;">${message}</pre>`;
    }

    throw new Error(message);
  }

  return {
    VITE_API_URL: import.meta.env.VITE_API_URL,
    VITE_SENTRY_DSN: import.meta.env.VITE_SENTRY_DSN || undefined,
    VITE_APP_VERSION: import.meta.env.VITE_APP_VERSION || 'dev',
    VITE_WS_URL: import.meta.env.VITE_WS_URL || undefined,
  };
}

export const env = validateEnv();
```

Usage throughout the app:

```typescript
import { env } from './env';

// Fully typed, guaranteed to exist
fetch(`${env.VITE_API_URL}/users`);
```

## 🌐 NEXT.JS ENV VALIDATION

Next.js has built-in env support but no validation. Use a validation file:

Create `src/env.mjs`:

```javascript
import { createEnv } from '@t3-oss/env-nextjs';
import { z } from 'zod';

export const env = createEnv({
  // Server-side env vars (never exposed to client)
  server: {
    DATABASE_URL: z.string().url().startsWith('postgresql://'),
    JWT_SECRET: z.string().min(32),
    NODE_ENV: z.enum(['development', 'staging', 'production']).default('development'),
    SENTRY_AUTH_TOKEN: z.string().optional(),
  },

  // Client-side env vars (prefixed with NEXT_PUBLIC_)
  client: {
    NEXT_PUBLIC_API_URL: z.string().url(),
    NEXT_PUBLIC_SENTRY_DSN: z.string().url().optional(),
  },

  // Map process.env to the schema
  runtimeEnv: {
    DATABASE_URL: process.env.DATABASE_URL,
    JWT_SECRET: process.env.JWT_SECRET,
    NODE_ENV: process.env.NODE_ENV,
    SENTRY_AUTH_TOKEN: process.env.SENTRY_AUTH_TOKEN,
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
    NEXT_PUBLIC_SENTRY_DSN: process.env.NEXT_PUBLIC_SENTRY_DSN,
  },
});
```

> [!TIP]
> The `@t3-oss/env-nextjs` package (`npm install @t3-oss/env-nextjs zod`) provides type-safe env validation specifically designed for Next.js's server/client split. It is the community standard.

## 📝 DEVELOPMENT VS PRODUCTION REQUIREMENTS

Some variables are only needed in certain environments:

```typescript
// In env.validation.ts — conditional validation
export class EnvironmentVariables {
  @IsString()
  @ValidateIf((o) => o.NODE_ENV === 'production')
  SENTRY_DSN: string;

  @IsString()
  @ValidateIf((o) => o.NODE_ENV === 'production')
  REDIS_URL: string;

  @IsString()
  @ValidateIf((o) => o.ENABLE_AI_PROVIDERS === true)
  OPENAI_API_KEY: string;

  @IsString()
  @ValidateIf((o) => o.ENABLE_AI_PROVIDERS === true)
  ANTHROPIC_API_KEY: string;
}
```

## 📄 .env.example TEMPLATE

Maintain a `.env.example` that documents every variable:

```bash
# ============================================================
# REQUIRED — Application will not start without these
# ============================================================

# PostgreSQL connection string
# Format: postgresql://USER:PASSWORD@HOST:PORT/DATABASE
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/zenith

# JWT signing secret — generate with: openssl rand -base64 64
JWT_SECRET=

# ============================================================
# OPTIONAL — Sensible defaults provided
# ============================================================

# Server port (default: 3000)
PORT=3000

# Environment (development | staging | production | test)
NODE_ENV=development

# Log level (debug | info | warn | error)
LOG_LEVEL=info

# CORS allowed origin (default: http://localhost:5173)
CORS_ORIGIN=http://localhost:5173

# Redis URL (optional — used for caching and WebSockets)
# REDIS_URL=redis://localhost:6379

# ============================================================
# FEATURE FLAGS — Enable/disable optional features
# ============================================================

# Enable WebSocket connections (default: false)
ENABLE_WEBSOCKETS=false

# Enable AI provider integrations (default: false)
ENABLE_AI_PROVIDERS=false

# Show Swagger API docs at /api (default: true in dev)
ENABLE_SWAGGER=true

# ============================================================
# PRODUCTION ONLY — Required when NODE_ENV=production
# ============================================================

# Sentry DSN for error tracking
# SENTRY_DSN=https://key@o0.ingest.sentry.io/0

# ============================================================
# AI PROVIDERS — Required when ENABLE_AI_PROVIDERS=true
# ============================================================

# OPENAI_API_KEY=sk-...
# ANTHROPIC_API_KEY=sk-ant-...
```

## 🛡️ ERROR OUTPUT BEST PRACTICES

When validation fails, show ALL errors at once (not just the first one):

```text
╔══════════════════════════════════════════════════╗
║       ENVIRONMENT VALIDATION FAILED             ║
╠══════════════════════════════════════════════════╣
║ The following environment variables are          ║
║ missing or invalid:                              ║
╚══════════════════════════════════════════════════╝

  - DATABASE_URL: DATABASE_URL must start with postgresql://
  - JWT_SECRET: JWT_SECRET should not be empty
  - PORT: PORT must not be greater than 65535

Fix these in your .env file or environment.
See .env.example for required variables.
```

> [!TIP]
> Displaying all errors at once saves developers from the frustrating cycle of fix-one-restart-find-next-fix-restart. Catch everything in a single pass.

## 🔄 .env.example MAINTENANCE STRATEGY

Keep `.env.example` in sync automatically:

1. Add a pre-commit hook or CI check that compares keys in `.env.example` against the `EnvironmentVariables` class
2. When adding a new env var to the code, always add it to both the validation class AND `.env.example`
3. Review `.env.example` in every PR that touches configuration

```bash
# Simple CI check script: compare .env.example keys with validation class
#!/bin/bash
EXAMPLE_KEYS=$(grep -E '^[A-Z_]+=' .env.example | sed 's/=.*//' | sort)
CLASS_KEYS=$(grep -oP '^\s+[A-Z_]+(?=[:;])' src/config/env.validation.ts | tr -d ' ' | sort)

DIFF=$(diff <(echo "$EXAMPLE_KEYS") <(echo "$CLASS_KEYS"))
if [ -n "$DIFF" ]; then
  echo "ERROR: .env.example is out of sync with EnvironmentVariables class"
  echo "$DIFF"
  exit 1
fi
```

## ✅ EXIT CHECKLIST

- [ ] `EnvironmentVariables` class created with all env vars decorated
- [ ] `validate()` function integrated into `ConfigModule.forRoot()`
- [ ] App fails immediately on startup if required vars are missing
- [ ] Error message shows ALL missing/invalid vars (not just the first)
- [ ] Error message is human-readable with clear fix instructions
- [ ] `REQUIRED` vars have no default values
- [ ] `OPTIONAL` vars have sensible defaults
- [ ] Secrets (`JWT_SECRET`, API keys) are always REQUIRED with no fallback
- [ ] Production-only vars use `@ValidateIf` for conditional validation
- [ ] Frontend env validation runs before React renders
- [ ] `.env.example` is complete with comments for every variable
- [ ] `.env.example` is committed to git (`.env` is NOT)
- [ ] `ConfigService` is typed with `EnvironmentVariables` throughout codebase
- [ ] CI pipeline validates `.env.example` stays in sync

*Skill Version: 1.0 | Created: February 2026*
