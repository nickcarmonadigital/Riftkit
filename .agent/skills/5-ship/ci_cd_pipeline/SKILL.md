---
name: CI/CD Pipeline
description: GitHub Actions CI/CD configuration for mono-repo projects with automated lint, test, build, and deploy stages
---

# CI/CD Pipeline Skill

**Purpose**: Automate the entire build-test-deploy lifecycle using GitHub Actions so that every push is validated and every merge to main deploys to production without manual intervention.

> [!WARNING]
> **Never store secrets in workflow files.** All credentials must live in GitHub Secrets and be referenced via `${{ secrets.NAME }}`. A single leaked secret can compromise your entire infrastructure.

---

## 🎯 TRIGGER COMMANDS

```text
"Set up CI/CD"
"Create GitHub Actions"
"Automate deployment"
"Add CI pipeline for mono-repo"
"Using ci_cd_pipeline skill: configure [project]"
```

---

## 🏗️ PIPELINE ARCHITECTURE

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                        CI/CD PIPELINE STAGES                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  TRIGGER          VALIDATE            BUILD             DEPLOY          │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐  ┌────────────┐  │
│  │ PR Open  │──▶ │ Lint         │──▶ │ Build        │  │ (PR only)  │  │
│  │ PR Sync  │    │ Type Check   │    │ Artifacts    │  │ No deploy  │  │
│  │ Push     │    │ Unit Tests   │    │              │  │            │  │
│  └──────────┘    └──────────────┘    └──────────────┘  └────────────┘  │
│                                                                         │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐  ┌────────────┐  │
│  │ Push to  │──▶ │ Lint         │──▶ │ Build        │──▶│ Deploy to  │  │
│  │ develop  │    │ Type Check   │    │ Artifacts    │  │ Staging    │  │
│  └──────────┘    │ Unit Tests   │    │              │  │            │  │
│                  └──────────────┘    └──────────────┘  └────────────┘  │
│                                                                         │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐  ┌────────────┐  │
│  │ Push to  │──▶ │ Lint         │──▶ │ Build        │──▶│ Deploy to  │  │
│  │ main     │    │ Type Check   │    │ Artifacts    │  │ Production │  │
│  └──────────┘    │ Unit Tests   │    │              │  │            │  │
│                  └──────────────┘    └──────────────┘  └────────────┘  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🌿 BRANCH STRATEGY

| Branch | Environment | Auto-Deploy | Notes |
|--------|-------------|-------------|-------|
| `main` | Production | Yes | Protected, requires PR + approvals |
| `develop` | Staging | Yes | Integration branch, auto-deploy on push |
| `feature/*` | None | No | PR checks only (lint, test, build) |
| `hotfix/*` | None | No | PR checks, merge directly to main |

> [!TIP]
> Protect your `main` branch in GitHub Settings > Branches > Branch protection rules. Require status checks to pass, require PR reviews, and disable direct pushes.

---

## 📁 MONO-REPO STRUCTURE

```text
project-root/
├── .github/
│   └── workflows/
│       ├── ci.yml              # PR checks (lint, test, build)
│       ├── deploy-backend.yml  # Backend deploy on main push
│       ├── deploy-frontend.yml # Frontend deploy on main push
│       └── deploy-website.yml  # Website deploy on main push
├── backend/
├── frontend/
└── website/
```

---

## 🔑 SECRETS MANAGEMENT

### Required GitHub Secrets

| Secret | Used By | How to Get |
|--------|---------|------------|
| `DATABASE_URL` | Backend CI tests | PostgreSQL connection string for test DB |
| `JWT_SECRET` | Backend CI tests | Any random string for test environment |
| `RAILWAY_TOKEN` | Backend deploy | Railway dashboard > Account > Tokens |
| `VERCEL_TOKEN` | Frontend/Website deploy | Vercel dashboard > Settings > Tokens |
| `VERCEL_ORG_ID` | Frontend/Website deploy | Vercel dashboard > Settings > General |
| `VERCEL_PROJECT_ID_FRONTEND` | Frontend deploy | Vercel project settings |
| `VERCEL_PROJECT_ID_WEBSITE` | Website deploy | Vercel project settings |

### Per-Environment Secrets

```text
Settings > Environments > Production
  └── RAILWAY_TOKEN (production)
  └── DATABASE_URL (production)

Settings > Environments > Staging
  └── RAILWAY_TOKEN (staging)
  └── DATABASE_URL (staging)
```

> [!WARNING]
> Never use production database credentials in CI tests. Create a separate test database or use GitHub Actions service containers.

---

## 📝 WORKFLOW: PR CHECKS (ci.yml)

This workflow runs on every pull request. It validates code quality across the entire mono-repo.

```yaml
# .github/workflows/ci.yml
name: CI

on:
  pull_request:
    branches: [main, develop]
    paths-ignore:
      - '**/*.md'
      - 'docs/**'
      - '.vscode/**'

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  # ─── BACKEND ────────────────────────────────────────────────
  backend-lint:
    name: Backend Lint & Type Check
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./backend
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - run: npm ci

      - name: Generate Prisma Client
        run: npx prisma generate

      - name: Lint
        run: npm run lint

      - name: Type Check
        run: npx tsc --noEmit

  backend-test:
    name: Backend Tests (Node ${{ matrix.node-version }})
    runs-on: ubuntu-latest
    needs: backend-lint
    strategy:
      matrix:
        node-version: [18, 20]
    defaults:
      run:
        working-directory: ./backend

    services:
      postgres:
        image: pgvector/pgvector:pg16
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    env:
      DATABASE_URL: postgresql://test:test@localhost:5432/testdb?schema=public
      JWT_SECRET: test-secret-for-ci-only

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - run: npm ci

      - name: Generate Prisma Client
        run: npx prisma generate

      - name: Push Schema to Test DB
        run: npx prisma db push --skip-generate

      - name: Run Tests
        run: npm test -- --coverage

      - name: Upload Coverage
        if: matrix.node-version == 20
        uses: actions/upload-artifact@v4
        with:
          name: backend-coverage
          path: backend/coverage/

  # ─── FRONTEND ───────────────────────────────────────────────
  frontend-check:
    name: Frontend Lint, Type Check & Build
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./frontend
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type Check
        run: npx tsc --noEmit

      - name: Build
        run: npm run build

      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: frontend-build
          path: frontend/dist/
          retention-days: 7

  # ─── WEBSITE ────────────────────────────────────────────────
  website-check:
    name: Website Lint, Type Check & Build
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: ./website
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: website/package-lock.json

      - run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type Check
        run: npx tsc --noEmit

      - name: Build
        run: npm run build
```

---

## 🚀 WORKFLOW: BACKEND DEPLOY (deploy-backend.yml)

```yaml
# .github/workflows/deploy-backend.yml
name: Deploy Backend

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.github/workflows/deploy-backend.yml'

jobs:
  deploy:
    name: Deploy to Railway
    runs-on: ubuntu-latest
    environment: production
    defaults:
      run:
        working-directory: ./backend
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - run: npm ci

      - name: Generate Prisma Client
        run: npx prisma generate

      - name: Run Migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}

      - name: Install Railway CLI
        run: npm install -g @railway/cli

      - name: Deploy to Railway
        run: railway up --service backend
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

---

## 🚀 WORKFLOW: FRONTEND DEPLOY (deploy-frontend.yml)

```yaml
# .github/workflows/deploy-frontend.yml
name: Deploy Frontend

on:
  push:
    branches: [main]
    paths:
      - 'frontend/**'
      - '.github/workflows/deploy-frontend.yml'

jobs:
  deploy:
    name: Deploy to Vercel
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install Vercel CLI
        run: npm install -g vercel@latest

      - name: Pull Vercel Environment
        run: vercel pull --yes --environment=production --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./frontend
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID_FRONTEND }}

      - name: Build
        run: vercel build --prod --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./frontend
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID_FRONTEND }}

      - name: Deploy
        run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./frontend
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID_FRONTEND }}
```

---

## ⚡ CACHING STRATEGIES

### Node Modules Cache

The `actions/setup-node@v4` `cache` option handles this automatically. It caches based on `package-lock.json`.

### Prisma Client Cache

```yaml
- name: Cache Prisma Client
  uses: actions/cache@v4
  with:
    path: backend/node_modules/.prisma
    key: prisma-${{ runner.os }}-${{ hashFiles('backend/prisma/schema.prisma') }}
    restore-keys: |
      prisma-${{ runner.os }}-
```

### Next.js Build Cache (for Website)

```yaml
- name: Cache Next.js Build
  uses: actions/cache@v4
  with:
    path: website/.next/cache
    key: nextjs-${{ runner.os }}-${{ hashFiles('website/package-lock.json') }}-${{ hashFiles('website/src/**/*') }}
    restore-keys: |
      nextjs-${{ runner.os }}-${{ hashFiles('website/package-lock.json') }}-
      nextjs-${{ runner.os }}-
```

### Vite Build Cache (for Frontend)

```yaml
- name: Cache Vite Build
  uses: actions/cache@v4
  with:
    path: frontend/node_modules/.vite
    key: vite-${{ runner.os }}-${{ hashFiles('frontend/package-lock.json') }}-${{ hashFiles('frontend/src/**/*') }}
    restore-keys: |
      vite-${{ runner.os }}-${{ hashFiles('frontend/package-lock.json') }}-
      vite-${{ runner.os }}-
```

---

## 🧪 MATRIX TESTING

Test across multiple Node.js versions to ensure compatibility:

```yaml
strategy:
  matrix:
    node-version: [18, 20]
  fail-fast: false  # Don't cancel other jobs if one fails
```

> [!TIP]
> Use `fail-fast: false` so you can see failures across all versions, not just the first one. This is especially useful for spotting version-specific bugs.

---

## 🗃️ DATABASE FOR CI TESTS

GitHub Actions supports service containers. Use the `pgvector/pgvector` image to match your production PostgreSQL with pgvector extensions:

```yaml
services:
  postgres:
    image: pgvector/pgvector:pg16
    env:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: testdb
    ports:
      - 5432:5432
    options: >-
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
```

Then push your Prisma schema to the service container:

```yaml
- name: Push Schema to Test DB
  run: npx prisma db push --skip-generate
  env:
    DATABASE_URL: postgresql://test:test@localhost:5432/testdb?schema=public
```

> [!WARNING]
> Use `prisma db push` (not `prisma migrate deploy`) in CI tests. `db push` syncs the schema without requiring migration history, which is exactly what you want for a fresh test database.

---

## ⏭️ CONDITIONAL DEPLOYS

### Skip on Docs-Only Changes

```yaml
on:
  push:
    branches: [main]
    paths-ignore:
      - '**/*.md'
      - 'docs/**'
      - '.vscode/**'
      - 'LICENSE'
```

### Deploy Only When Relevant Paths Change

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.github/workflows/deploy-backend.yml'
```

### Skip CI Entirely

Add `[skip ci]` to your commit message:

```text
docs: update README [skip ci]
```

---

## 📦 ARTIFACT UPLOAD

Upload build outputs for debugging or downstream jobs:

```yaml
- name: Upload Build Artifact
  uses: actions/upload-artifact@v4
  with:
    name: frontend-build
    path: frontend/dist/
    retention-days: 7

- name: Upload Test Results
  if: always()  # Upload even on failure
  uses: actions/upload-artifact@v4
  with:
    name: test-results
    path: backend/coverage/
    retention-days: 14
```

---

## 🔄 ROLLBACK STRATEGY

### Option 1: Revert Commit (Preferred)

```bash
# Revert the bad commit
git revert <bad-commit-sha> --no-edit
git push origin main
# CI/CD will auto-deploy the reverted state
```

### Option 2: Redeploy Previous SHA

```bash
# Railway: deploy a specific commit
railway up --service backend --commit <good-sha>

# Vercel: promote a previous deployment
vercel promote <deployment-url> --token=$VERCEL_TOKEN
```

### Option 3: Database Rollback (if migration was involved)

```bash
# Revert the last migration
npx prisma migrate resolve --rolled-back <migration-name>
# Then manually apply the reverse SQL
```

> [!WARNING]
> Database rollbacks are the riskiest. Always take a snapshot before deploying migrations. If the migration was destructive (dropped columns/tables), data may be unrecoverable.

---

## 🛡️ PR CHECK SUMMARY

Every PR should show these status checks before merge is allowed:

| Check | Required | Job Name |
|-------|----------|----------|
| Backend Lint & Type Check | Yes | `backend-lint` |
| Backend Tests (Node 18) | Yes | `backend-test (18)` |
| Backend Tests (Node 20) | Yes | `backend-test (20)` |
| Frontend Lint, Type Check & Build | Yes | `frontend-check` |
| Website Lint, Type Check & Build | Yes | `website-check` |

Configure in GitHub: Settings > Branches > Branch protection rules > Require status checks.

---

## ✅ EXIT CHECKLIST

- [ ] `.github/workflows/ci.yml` created and passing on PRs
- [ ] Backend deploy workflow triggers on push to main
- [ ] Frontend deploy workflow triggers on push to main
- [ ] Website deploy workflow triggers on push to main (if applicable)
- [ ] All GitHub Secrets configured (DATABASE_URL, JWT_SECRET, RAILWAY_TOKEN, VERCEL_TOKEN)
- [ ] Branch protection rules enabled on `main`
- [ ] Required status checks configured
- [ ] Caching working (check "Post cache" step in Actions logs)
- [ ] PostgreSQL service container working for backend tests
- [ ] Docs-only changes skip CI (`paths-ignore` configured)
- [ ] Matrix testing passing on Node 18 and 20
- [ ] Build artifacts uploading successfully
- [ ] Rollback procedure documented and tested

---

*Skill Version: 1.0 | Created: February 2026*
