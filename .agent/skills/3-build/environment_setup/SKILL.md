---
name: environment_setup
description: Development environment configuration for NestJS + React projects
---

# Environment Setup Skill

**Purpose**: Configure a consistent, professional development environment with linting, formatting, Git hooks, and editor settings.

## 🎯 TRIGGER COMMANDS

```text
"Set up development environment for [project]"
"Configure ESLint and Prettier"
"Add Git hooks with Husky"
"Set up .env management"
"First day setup checklist"
"Using environment_setup skill"
```

## When to Use

- Starting a new project from scratch
- Onboarding to a team (first day setup)
- Adding linting/formatting to an existing project
- Setting up Git hooks for code quality enforcement
- Configuring environment variables properly

---

## PART 1: NODE VERSION MANAGEMENT

```bash
# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install and use correct Node version
nvm install 20
nvm use 20

# Pin version for the project (.nvmrc)
echo "20" > .nvmrc

# Team members just run:
nvm use  # Reads from .nvmrc
```

---

## PART 2: PACKAGE MANAGERS

| Feature | npm | pnpm | yarn |
|---------|-----|------|------|
| Speed | Moderate | Fastest | Fast |
| Disk usage | High (copies) | Low (symlinks) | High |
| Lockfile | package-lock.json | pnpm-lock.yaml | yarn.lock |
| Workspaces | Yes | Yes (best) | Yes |
| CI install | `npm ci` | `pnpm install --frozen-lockfile` | `yarn --frozen-lockfile` |

**Key rule**: ALWAYS commit your lockfile. Use `npm ci` (not `npm install`) in CI to ensure exact versions.

---

## PART 3: ESLINT CONFIGURATION

### NestJS Backend

```javascript
// .eslintrc.js
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'prettier', // Must be last — disables conflicting rules
  ],
  root: true,
  env: { node: true, jest: true },
  rules: {
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/no-explicit-any': 'warn',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/no-floating-promises': 'error',
  },
};
```

### React Frontend

```javascript
// .eslintrc.cjs
module.exports = {
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'prettier',
  ],
  plugins: ['react-refresh'],
  rules: {
    'react-refresh/only-export-components': 'warn',
    'react-hooks/exhaustive-deps': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
    'jsx-a11y/anchor-is-valid': 'warn',
  },
};
```

---

## PART 4: PRETTIER CONFIGURATION

```json
// .prettierrc
{
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "semi": true,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

```
// .prettierignore
node_modules
dist
build
coverage
*.min.js
pnpm-lock.yaml
package-lock.json
```

**Why eslint-config-prettier**: ESLint and Prettier can conflict on formatting rules. `eslint-config-prettier` disables ESLint rules that Prettier handles.

```bash
npm install -D prettier eslint-config-prettier
```

---

## PART 5: HUSKY + LINT-STAGED + COMMITLINT

### Setup

```bash
# Install
npm install -D husky lint-staged @commitlint/cli @commitlint/config-conventional

# Initialize Husky
npx husky init

# Create pre-commit hook
echo "npx lint-staged" > .husky/pre-commit

# Create commit-msg hook
echo 'npx --no -- commitlint --edit "$1"' > .husky/commit-msg
```

### lint-staged Configuration

```json
// package.json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix --max-warnings=0",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

### commitlint Configuration

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'chore', 'ci', 'revert',
    ]],
    'subject-max-length': [2, 'always', 100],
  },
};
```

---

## PART 6: EDITOR CONFIGURATION

### .editorconfig

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
```

### VS Code Settings

```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "files.eol": "\n"
}
```

### VS Code Recommended Extensions

```json
// .vscode/extensions.json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "prisma.prisma",
    "bradlc.vscode-tailwindcss",
    "ms-azuretools.vscode-docker",
    "github.copilot",
    "editorconfig.editorconfig"
  ]
}
```

---

## PART 7: .ENV MANAGEMENT

### NestJS ConfigModule

```typescript
// app.module.ts
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
      validationSchema: Joi.object({
        DATABASE_URL: Joi.string().required(),
        JWT_SECRET: Joi.string().required().min(32),
        PORT: Joi.number().default(3000),
        NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
      }),
    }),
  ],
})
```

### .env.example (Committed to Git)

```bash
# .env.example — documents ALL required env vars
# Copy to .env and fill in actual values

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/mydb

# Auth
JWT_SECRET=change-this-to-a-secure-random-string-at-least-32-chars
JWT_REFRESH_SECRET=another-secure-random-string

# App
PORT=3000
NODE_ENV=development
FRONTEND_URL=http://localhost:5173
```

---

## PART 8: 20-STEP FIRST DAY CHECKLIST

```markdown
## First Day Setup

### System Prerequisites
- [ ] 1. Install Node.js via nvm: `nvm install 20`
- [ ] 2. Install Docker Desktop
- [ ] 3. Install VS Code + recommended extensions
- [ ] 4. Install Git and configure: `git config --global user.name/email`
- [ ] 5. Generate SSH key and add to GitHub

### Project Setup
- [ ] 6. Clone the repository
- [ ] 7. Run `nvm use` (reads .nvmrc)
- [ ] 8. Copy `.env.example` to `.env` and fill in values
- [ ] 9. Run `npm install` (or `pnpm install`)
- [ ] 10. Start database: `docker compose up -d postgres redis`
- [ ] 11. Run migrations: `npx prisma migrate dev`
- [ ] 12. Seed database: `npx prisma db seed`
- [ ] 13. Start backend: `npm run start:dev`
- [ ] 14. Start frontend: `cd frontend && npm run dev`
- [ ] 15. Verify app loads at http://localhost:5173

### Verification
- [ ] 16. Run tests: `npm run test`
- [ ] 17. Run linter: `npm run lint`
- [ ] 18. Open Prisma Studio: `npx prisma studio`
- [ ] 19. Check Swagger docs: http://localhost:3000/api/docs
- [ ] 20. Create a test commit to verify Husky hooks work
```

---

## ✅ Exit Checklist

- [ ] Node version pinned with .nvmrc
- [ ] ESLint configured for TypeScript (NestJS + React)
- [ ] Prettier configured with eslint-config-prettier
- [ ] Husky hooks: pre-commit (lint-staged) + commit-msg (commitlint)
- [ ] .editorconfig for consistent editor settings
- [ ] .vscode/settings.json for format-on-save
- [ ] .env.example documents all required variables
- [ ] ConfigModule validates env vars on startup
