# CI/CD Pipeline Templates

**Purpose**: Copy-paste ready GitHub Actions workflows for a mono-repo with backend (NestJS), frontend (React/Vite), and website (Next.js).

---

## 1. PR Check Workflow

Save as `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
    branches: [main, develop]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  backend:
    name: Backend Checks
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd="pg_isready -U test"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5

    defaults:
      run:
        working-directory: backend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: backend/package-lock.json

      - run: npm ci

      - name: Cache Prisma engines
        uses: actions/cache@v4
        with:
          path: backend/node_modules/.prisma
          key: prisma-${{ runner.os }}-${{ hashFiles('backend/prisma/schema.prisma') }}

      - name: Generate Prisma client
        run: npx prisma generate

      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/testdb

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Unit tests
        run: npm test -- --coverage
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/testdb
          JWT_SECRET: ci-test-secret

      - name: Build
        run: npm run build

  frontend:
    name: Frontend Checks
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: frontend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: frontend/package-lock.json

      - run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Unit tests
        run: npm test -- --coverage

      - name: Build
        run: npm run build

  website:
    name: Website Checks
    runs-on: ubuntu-latest

    defaults:
      run:
        working-directory: website

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: website/package-lock.json

      - run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npx tsc --noEmit

      - name: Build
        run: npm run build

      - name: Cache Next.js build
        uses: actions/cache@v4
        with:
          path: website/.next/cache
          key: nextjs-${{ runner.os }}-${{ hashFiles('website/package-lock.json') }}

---

## 2. Deploy Workflow

Save as `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-backend:
    name: Deploy Backend
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: backend/package-lock.json

      - run: npm ci
        working-directory: backend

      - run: npm run build
        working-directory: backend

      - name: Run migrations
        run: npx prisma migrate deploy
        working-directory: backend
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      # Replace with your deploy command (Railway, Fly.io, Docker, etc.)
      - name: Deploy
        run: echo "Add your deploy command here"
        env:
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}

  deploy-frontend:
    name: Deploy Frontend
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: frontend/package-lock.json

      - run: npm ci
        working-directory: frontend

      - run: npm run build
        working-directory: frontend
        env:
          VITE_API_URL: ${{ vars.VITE_API_URL }}
          VITE_SENTRY_DSN: ${{ vars.VITE_SENTRY_DSN }}

      # Replace with your deploy command (Vercel, Netlify, S3, etc.)
      - name: Deploy
        run: echo "Add your deploy command here"

  deploy-website:
    name: Deploy Website
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
          cache-dependency-path: website/package-lock.json

      - run: npm ci
        working-directory: website

      - run: npm run build
        working-directory: website

      - name: Deploy
        run: echo "Add your deploy command here"
```

---

## 3. Required Secrets and Variables

Configure these in GitHub repository settings under Settings > Secrets and variables > Actions:

### Secrets (sensitive)

| Secret | Used By | Description |
|--------|---------|-------------|
| `DATABASE_URL` | Backend deploy | Production PostgreSQL connection string |
| `JWT_SECRET` | Backend deploy | JWT signing secret |
| `DEPLOY_TOKEN` | All deploys | Platform-specific deploy token |
| `SENTRY_AUTH_TOKEN` | Source maps upload | Sentry API token |
| `STRIPE_SECRET_KEY` | Backend deploy | Stripe API secret key |
| `POSTHOG_API_KEY` | Backend deploy | PostHog project API key |

### Variables (non-sensitive)

| Variable | Used By | Description |
|----------|---------|-------------|
| `VITE_API_URL` | Frontend build | Backend API URL |
| `VITE_SENTRY_DSN` | Frontend build | Sentry DSN for frontend |
| `NEXT_PUBLIC_URL` | Website build | Public website URL |

---

## 4. Caching Strategy Summary

| What | Cache Key | Typical Savings |
|------|-----------|-----------------|
| node_modules | `package-lock.json` hash | 30-60s per job |
| Prisma engines | `schema.prisma` hash | 10-20s |
| Next.js .next/cache | `package-lock.json` hash | 20-40s on rebuild |
| Docker layers | Dockerfile + package-lock hash | 1-3 min |
