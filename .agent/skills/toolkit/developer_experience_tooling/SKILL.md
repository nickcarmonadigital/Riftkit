---
name: Developer Experience Tooling
description: DevEx tooling including CLI tools, dev containers, dotfiles, onboarding automation, and golden paths
---

# Developer Experience Tooling Skill

**Purpose**: Guide teams in building excellent developer experience through CLI tools, standardized development environments, automated onboarding, and golden path templates that reduce friction and increase productivity.

---

## TRIGGER COMMANDS

```text
"Improve our developer experience"
"Set up dev containers for the team"
"Build a CLI tool for our workflow"
"Automate developer onboarding"
"Using developer_experience_tooling skill: [task]"
```

---

## DevEx Maturity Model

| Level | Description | Characteristics |
|-------|-------------|-----------------|
| 1 - Ad Hoc | No standardization | "Works on my machine", tribal knowledge |
| 2 - Documented | README-driven | Setup docs exist but drift from reality |
| 3 - Scripted | Automated setup | `make setup` works, basic tooling |
| 4 - Containerized | Reproducible environments | Dev containers, consistent across team |
| 5 - Golden Path | Self-service platform | Templates, scaffolding, service catalog |

---

## Dev Containers

### Standard devcontainer.json

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "My Project",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:20",
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {},
    "ghcr.io/devcontainers/features/github-cli:1": {},
    "ghcr.io/devcontainers/features/aws-cli:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "dbaeumer.vscode-eslint",
        "esbenp.prettier-vscode",
        "bradlc.vscode-tailwindcss",
        "ms-azuretools.vscode-docker"
      ],
      "settings": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.codeActionsOnSave": {
          "source.fixAll.eslint": "explicit"
        }
      }
    }
  },
  "forwardPorts": [3000, 5432, 6379],
  "postCreateCommand": "npm install && npm run db:setup",
  "postStartCommand": "npm run dev",
  "remoteUser": "node"
}
```

### Docker Compose Dev Container

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "Full Stack Dev",
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "shutdownAction": "stopCompose",
  "postCreateCommand": "npm install && npx prisma migrate dev",
  "forwardPorts": [3000, 5432, 6379]
}
```

```yaml
# .devcontainer/docker-compose.yml
services:
  app:
    build:
      context: ..
      dockerfile: .devcontainer/Dockerfile
    volumes:
      - ..:/workspace:cached
      - node_modules:/workspace/node_modules
    command: sleep infinity
    depends_on:
      - db
      - redis

  db:
    image: postgres:16
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
      POSTGRES_DB: myapp_dev
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  pgdata:
  node_modules:
```

---

## CLI Tool Development

### Node.js CLI with Commander

```typescript
// src/cli.ts
#!/usr/bin/env node
import { Command } from 'commander';
import { scaffold } from './commands/scaffold';
import { deploy } from './commands/deploy';
import { dbMigrate } from './commands/db';

const program = new Command();

program
  .name('mytools')
  .description('Internal developer tools')
  .version('1.0.0');

program
  .command('scaffold <type> <name>')
  .description('Scaffold a new component, service, or module')
  .option('-d, --directory <dir>', 'target directory', '.')
  .option('--dry-run', 'show what would be created')
  .action(scaffold);

program
  .command('deploy <environment>')
  .description('Deploy to specified environment')
  .option('--skip-tests', 'skip test suite')
  .option('--force', 'skip confirmation')
  .action(deploy);

program
  .command('db <action>')
  .description('Database operations (migrate, seed, reset)')
  .action(dbMigrate);

program.parse();
```

```typescript
// src/commands/scaffold.ts
import fs from 'node:fs';
import path from 'node:path';
import chalk from 'chalk';
import { confirm } from '@inquirer/prompts';

interface ScaffoldOptions {
  directory: string;
  dryRun?: boolean;
}

const TEMPLATES: Record<string, string[]> = {
  component: ['Component.tsx', 'Component.test.tsx', 'Component.module.css', 'index.ts'],
  service: ['service.ts', 'service.test.ts', 'types.ts', 'index.ts'],
  module: ['module.ts', 'controller.ts', 'service.ts', 'dto.ts', 'index.ts'],
};

export async function scaffold(type: string, name: string, options: ScaffoldOptions) {
  const template = TEMPLATES[type];
  if (!template) {
    console.error(chalk.red(`Unknown type: ${type}. Available: ${Object.keys(TEMPLATES).join(', ')}`));
    process.exit(1);
  }

  const targetDir = path.join(options.directory, name);
  const files = template.map(f => path.join(targetDir, f.replace('Component', name)));

  console.log(chalk.blue(`Creating ${type}: ${name}`));
  files.forEach(f => console.log(`  ${chalk.green('+')} ${f}`));

  if (options.dryRun) {
    console.log(chalk.yellow('Dry run - no files created'));
    return;
  }

  const proceed = await confirm({ message: 'Create these files?' });
  if (!proceed) return;

  fs.mkdirSync(targetDir, { recursive: true });
  for (const file of files) {
    const content = generateTemplate(type, name, path.basename(file));
    fs.writeFileSync(file, content);
  }

  console.log(chalk.green(`Created ${files.length} files in ${targetDir}`));
}
```

### package.json CLI Setup

```json
{
  "name": "@company/tools",
  "version": "1.0.0",
  "bin": {
    "mytools": "./dist/cli.js"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsx src/cli.ts"
  },
  "dependencies": {
    "chalk": "^5.0.0",
    "commander": "^12.0.0",
    "@inquirer/prompts": "^5.0.0"
  }
}
```

---

## Makefile / Task Runner

```makefile
# Makefile
.PHONY: setup dev test lint build deploy clean help

# Default target
.DEFAULT_GOAL := help

## Setup and Installation
setup: ## First-time setup for new developers
	@echo "Setting up development environment..."
	cp .env.example .env
	npm install
	npm run db:setup
	npm run db:seed
	@echo "Setup complete. Run 'make dev' to start."

## Development
dev: ## Start development server with hot reload
	npm run dev

dev-full: ## Start all services (app + db + redis + worker)
	docker compose -f docker-compose.dev.yml up -d db redis
	npm run dev & npm run worker:dev

## Testing
test: ## Run all tests
	npm test

test-watch: ## Run tests in watch mode
	npm test -- --watch

test-coverage: ## Run tests with coverage report
	npm test -- --coverage

test-e2e: ## Run end-to-end tests
	npm run test:e2e

## Code Quality
lint: ## Lint and check formatting
	npm run lint
	npm run format:check
	npm run typecheck

lint-fix: ## Auto-fix lint and formatting issues
	npm run lint:fix
	npm run format

## Database
db-migrate: ## Run pending migrations
	npx prisma migrate dev

db-reset: ## Reset database and re-seed
	npx prisma migrate reset --force

db-studio: ## Open Prisma Studio
	npx prisma studio

## Build and Deploy
build: ## Build for production
	npm run build

deploy-staging: ## Deploy to staging
	./scripts/deploy.sh staging

deploy-prod: ## Deploy to production (requires confirmation)
	@read -p "Deploy to PRODUCTION? (y/N): " confirm && [ "$$confirm" = "y" ] || exit 1
	./scripts/deploy.sh production

## Cleanup
clean: ## Remove build artifacts and node_modules
	rm -rf dist node_modules .next coverage

## Help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
```

---

## Onboarding Automation

### Setup Script

```bash
#!/bin/bash
# scripts/onboard.sh - First-time developer setup
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}[SETUP]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check prerequisites
log "Checking prerequisites..."

command -v node >/dev/null 2>&1 || error "Node.js is required. Install from https://nodejs.org"
command -v docker >/dev/null 2>&1 || error "Docker is required. Install from https://docker.com"

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
[ "$NODE_VERSION" -ge 20 ] || error "Node.js 20+ required (found v${NODE_VERSION})"

log "Prerequisites OK"

# Environment setup
log "Setting up environment..."
if [ ! -f .env ]; then
  cp .env.example .env
  log "Created .env from .env.example"
else
  warn ".env already exists, skipping"
fi

# Install dependencies
log "Installing dependencies..."
npm ci

# Setup git hooks
log "Setting up git hooks..."
npx husky install

# Database setup
log "Setting up database..."
docker compose up -d db redis
sleep 3  # Wait for db to be ready
npx prisma migrate dev
npx prisma db seed

# Verify setup
log "Verifying setup..."
npm run typecheck
npm test -- --run

log "============================="
log "Setup complete!"
log ""
log "Quick start:"
log "  make dev        - Start development server"
log "  make test       - Run tests"
log "  make help       - Show all commands"
log "============================="
```

### .env.example

```bash
# .env.example - Copy to .env and fill in values
# Database
DATABASE_URL=postgresql://dev:dev@localhost:5432/myapp_dev

# Redis
REDIS_URL=redis://localhost:6379

# Auth (generate with: openssl rand -base64 32)
JWT_SECRET=change-me-in-local-env

# External APIs (get from team lead for dev keys)
# STRIPE_SECRET_KEY=sk_test_...
# SENDGRID_API_KEY=SG...

# Feature flags
ENABLE_NEW_CHECKOUT=true
```

---

## Git Hooks and Pre-Commit

### Husky + lint-staged

```json
// package.json
{
  "scripts": {
    "prepare": "husky"
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ],
    "*.prisma": [
      "prisma format"
    ]
  }
}
```

```bash
# .husky/pre-commit
npx lint-staged

# .husky/commit-msg
npx commitlint --edit $1

# .husky/pre-push
npm run typecheck
npm test -- --run --bail
```

### commitlint

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert',
    ]],
    'subject-max-length': [2, 'always', 72],
    'body-max-line-length': [2, 'always', 100],
  },
};
```

---

## Golden Paths

### What is a Golden Path?

A golden path is the recommended, well-supported way to accomplish a common task. It reduces decision fatigue and ensures consistency.

```
Golden Path Examples:
  "Create a new microservice"  → Template with CI/CD, monitoring, docs
  "Add a database migration"   → CLI command + testing guide
  "Deploy to production"       → Automated pipeline with gates
  "Add a new API endpoint"     → Scaffold command + test template
```

### Project Template (cookiecutter/yeoman style)

```
templates/
  microservice/
    {{cookiecutter.service_name}}/
      src/
        index.ts
        server.ts
        routes/
          health.ts
        middleware/
          auth.ts
          errorHandler.ts
      test/
        health.test.ts
      Dockerfile
      docker-compose.yml
      .github/
        workflows/
          ci.yml
          deploy.yml
      package.json
      tsconfig.json
      .env.example
      README.md
    cookiecutter.json
```

```json
// cookiecutter.json
{
  "service_name": "my-service",
  "description": "A new microservice",
  "port": "3000",
  "database": ["postgres", "none"],
  "auth": ["jwt", "api-key", "none"],
  "team": "platform"
}
```

---

## Developer Dashboard

### Key Metrics to Track

| Metric | What it Measures | Target |
|--------|-----------------|--------|
| Time to first commit | Onboarding effectiveness | < 4 hours |
| CI build time | Pipeline speed | < 10 minutes |
| PR review time | Review process | < 4 hours |
| Deploy frequency | Delivery speed | Daily |
| Test coverage | Code quality | > 80% |
| Flaky test rate | CI reliability | < 1% |
| Dev env setup time | Environment standardization | < 15 minutes |
| Incident response | Operational maturity | < 15 min MTTD |

---

## Dotfiles and Editor Config

### EditorConfig

```ini
# .editorconfig
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

### Shared VS Code Settings

```jsonc
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit",
    "source.organizeImports": "explicit"
  },
  "typescript.preferences.importModuleSpecifier": "non-relative",
  "files.exclude": {
    "node_modules": true,
    "dist": true,
    "coverage": true
  },
  "search.exclude": {
    "node_modules": true,
    "dist": true,
    "coverage": true,
    "*.lock": true
  }
}
```

```jsonc
// .vscode/extensions.json
{
  "recommendations": [
    "dbaeumer.vscode-eslint",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "prisma.prisma",
    "ms-azuretools.vscode-docker"
  ]
}
```

---

## Cross-References

- `toolkit/documentation_as_code` - Documentation tooling and docs-as-code
- `3-build/internal_developer_portal` - Internal developer portal (Backstage)
- `toolkit/documentation_as_code` - API documentation automation

---

## EXIT CHECKLIST

- [ ] Dev container configured and tested (works with one click)
- [ ] `make setup` or equivalent runs in under 15 minutes
- [ ] `.env.example` maintained with all required variables
- [ ] Git hooks configured (lint-staged, commitlint)
- [ ] EditorConfig and shared VS Code settings committed
- [ ] CLI tools documented and published to internal registry
- [ ] Golden path templates exist for common tasks
- [ ] Onboarding script validates prerequisites
- [ ] Makefile/task runner covers all common workflows
- [ ] New developer can make first commit within 4 hours

---

*Skill Version: 1.0 | Created: March 2026*
