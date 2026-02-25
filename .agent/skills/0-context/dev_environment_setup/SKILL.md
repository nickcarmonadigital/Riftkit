---
name: Dev Environment Setup
description: Guided process from fresh clone to fully operational local development environment
---

# Dev Environment Setup Skill

**Purpose**: Walk a developer (or AI agent) through every step from `git clone` to a fully running local development environment. This skill verifies prerequisites, installs dependencies, configures environment variables, seeds databases, and confirms everything works by running the test suite. It tracks "time to first green build" as the key metric.

## TRIGGER COMMANDS

```text
"Set up local development environment"
"Get this project running locally"
"New developer setup"
```

## When to Use
- A new developer or AI agent is joining the project and needs to get the codebase running
- The project was cloned fresh and nothing has been configured yet
- A developer's environment broke and they need a clean rebuild
- You want to document or automate the setup process for reproducibility

---

## PROCESS

### Step 1: Verify Prerequisites

Check that all required tooling is installed and at compatible versions.

```bash
# Record start time for "time to first green build" metric
echo "Setup started: $(date -Iseconds)" > .setup-timer.tmp

# Check language runtimes
node --version    # Expected: v18+ or v20+
python3 --version # If applicable
go version        # If applicable

# Check package managers
npm --version || yarn --version || pnpm --version

# Check infrastructure tools
docker --version && docker compose version
git --version

# Check databases (if running natively)
psql --version   # PostgreSQL
redis-cli --version  # Redis, if used
```

If any prerequisite is missing, install it before proceeding. Document the exact versions that work.

### Step 2: Clone and Install Dependencies

```bash
git clone <repo-url> && cd <project-dir>

# Install backend dependencies
cd backend && npm install   # or yarn / pnpm install

# Install frontend dependencies
cd ../frontend && npm install
```

If there is a monorepo root, run the root install first. Check for `.nvmrc`, `.node-version`, or `engines` in `package.json` for pinned versions.

### Step 3: Configure Environment Variables

```bash
# Copy example env files
cp .env.example .env
cp backend/.env.example backend/.env  # if separate
cp frontend/.env.example frontend/.env

# Open .env and fill in required values
# Required variables (check .env.example comments):
#   DATABASE_URL, JWT_SECRET, API keys, etc.
```

Generate secrets for local dev where needed:

```bash
# Generate a random JWT secret
openssl rand -hex 32
```

### Step 4: Start Infrastructure Services

```bash
# Using Docker Compose for databases and services
docker compose up -d postgres redis

# Wait for services to be healthy
docker compose ps  # Confirm all show "healthy" or "running"

# Verify database connectivity
psql $DATABASE_URL -c "SELECT 1"
```

### Step 5: Initialize Database

```bash
# Run migrations
npx prisma migrate dev     # Prisma
# OR
npx knex migrate:latest    # Knex
# OR
npm run db:migrate         # Custom script

# Seed initial data
npx prisma db seed         # Prisma
# OR
npm run db:seed            # Custom script
```

### Step 6: Run the Test Suite

```bash
# Run all tests to confirm environment is healthy
npm test

# Record completion time
echo "Setup completed: $(date -Iseconds)" >> .setup-timer.tmp
```

All tests should pass. If any fail, check the Troubleshooting section below.

### Step 7: Start the Application

```bash
# Start backend
cd backend && npm run start:dev

# Start frontend (separate terminal)
cd frontend && npm run dev
```

Verify the application loads in the browser and can connect to the backend.

---

## TROUBLESHOOTING: Top 10 Setup Failures

| # | Symptom | Fix |
|---|---------|-----|
| 1 | `EACCES` permission errors on npm install | Run `npm config set prefix ~/.npm-global` and update PATH |
| 2 | Port already in use (3000, 5432, etc.) | `lsof -i :<port>` to find and kill the process |
| 3 | Database connection refused | Confirm Docker container is running: `docker compose ps` |
| 4 | Migration fails with "relation already exists" | Reset DB: `npx prisma migrate reset` |
| 5 | Missing `.env` variable | Compare `.env` against `.env.example` line by line |
| 6 | Node version mismatch | Install nvm and run `nvm use` in project root |
| 7 | Docker daemon not running | Start Docker Desktop or `sudo systemctl start docker` |
| 8 | `prisma generate` not run | Run `npx prisma generate` before starting the app |
| 9 | Native module build fails | Install build tools: `sudo apt install build-essential` |
| 10 | WSL2 file permission issues | Clone into Linux filesystem (`~/projects/`), not `/mnt/c/` |

---

## CHECKLIST

- [ ] All prerequisite tools installed and at compatible versions
- [ ] Repository cloned successfully
- [ ] All dependencies installed without errors
- [ ] Environment variables configured from `.env.example`
- [ ] Infrastructure services (DB, cache) running and healthy
- [ ] Database migrations applied successfully
- [ ] Database seeded with initial data
- [ ] Full test suite passes (record pass count)
- [ ] Application starts and loads in browser
- [ ] "Time to first green build" recorded

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P0*
