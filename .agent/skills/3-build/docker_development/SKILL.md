---
name: docker_development
description: Docker and Docker Compose patterns for full-stack NestJS + React development
---

# Docker Development Skill

**Purpose**: Containerize your full-stack application for consistent development and production environments. Eliminate "works on my machine."

## 🎯 TRIGGER COMMANDS

```text
"Dockerize this project"
"Create docker-compose for full stack"
"Write a Dockerfile for NestJS"
"Set up Docker for development"
"Using docker_development skill"
```

## When to Use

- Containerizing a NestJS + React project
- Setting up Docker Compose for local development
- Creating production-ready Docker images
- Debugging container issues
- Onboarding new developers (one-command setup)

---

## PART 1: NESTJS MULTI-STAGE DOCKERFILE

```dockerfile
# Stage 1: Install dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma/
RUN npm ci
RUN npx prisma generate

# Stage 2: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Stage 3: Production
FROM node:20-alpine AS production
WORKDIR /app

# Security: run as non-root user
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001
USER appuser

# Copy only what's needed
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
COPY --from=build /app/prisma ./prisma

EXPOSE 3000
CMD ["node", "dist/main.js"]
```

---

## PART 2: REACT VITE + NGINX DOCKERFILE

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf (SPA Routing)

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    # SPA: all routes serve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API proxy (if frontend and backend on same domain)
    location /api/ {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

## PART 3: DOCKER COMPOSE (DEVELOPMENT)

```yaml
# docker-compose.yml
services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: deps  # Use deps stage for dev (has all node_modules)
    volumes:
      - ./backend/src:/app/src       # Hot reload source code
      - backend_modules:/app/node_modules  # Persist node_modules in volume
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@postgres:5432/mydb
      - JWT_SECRET=dev-secret-change-in-prod
      - REDIS_URL=redis://redis:6379
      - NODE_ENV=development
    depends_on:
      postgres:
        condition: service_healthy
    command: npm run start:dev

  frontend:
    build:
      context: ./frontend
      target: deps
    volumes:
      - ./frontend/src:/app/src
      - frontend_modules:/app/node_modules
    ports:
      - "5173:5173"
    environment:
      - VITE_API_URL=http://localhost:3000
    command: npm run dev -- --host

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  pgdata:
  redis_data:
  backend_modules:
  frontend_modules:
```

---

## PART 4: .dockerignore

```dockerignore
node_modules
dist
build
.git
.env
.env.local
*.md
.vscode
.idea
coverage
.next
```

---

## PART 5: DEBUGGING CONTAINERS

```bash
# View running containers
docker compose ps

# View logs
docker compose logs backend          # All logs for backend
docker compose logs -f backend       # Follow/stream logs
docker compose logs --tail=50 backend # Last 50 lines

# Execute command in running container
docker compose exec backend sh       # Shell into container
docker compose exec postgres psql -U postgres -d mydb  # Connect to DB

# Run one-off command
docker compose run --rm backend npx prisma migrate dev
docker compose run --rm backend npx prisma studio

# Rebuild after dependency changes
docker compose build --no-cache backend
docker compose up -d --build backend
```

---

## PART 6: COMMON ISSUES & FIXES

| Issue | Cause | Fix |
|-------|-------|-----|
| Port already in use | Another process on same port | `lsof -i :3000` then `kill <PID>` |
| node_modules from host conflicts | Architecture mismatch (Mac vs Linux) | Use named volume for node_modules |
| Prisma binary not found | Wrong binary target | Add `binaryTargets = ["native", "linux-musl-openssl-3.0.x"]` to schema.prisma |
| Hot reload not working | Volume mount missing src/ | Check volume mounts in docker-compose |
| Permission denied on volume | Container user vs host user mismatch | Use `user: "${UID}:${GID}"` in compose |
| Database connection refused | Backend starts before DB is ready | Use `depends_on` with `healthcheck` |

---

## PART 7: DOCKER COMMANDS CHEAT SHEET

```bash
# Build & Run
docker compose up                # Start all services (foreground)
docker compose up -d             # Start all services (background)
docker compose up -d --build     # Rebuild and start
docker compose down              # Stop and remove containers
docker compose down -v           # Stop and remove containers + volumes

# Individual services
docker compose up -d backend     # Start only backend
docker compose restart backend   # Restart backend
docker compose stop backend      # Stop backend

# Cleanup
docker system prune              # Remove unused containers, networks, images
docker volume prune              # Remove unused volumes
docker image prune -a            # Remove all unused images
```

---

---

## PART 8: CONTAINER SECURITY HARDENING

### Dockerfile Security Practices

```dockerfile
# 1. Use specific image tags — NEVER :latest
FROM node:22.12-alpine3.20

# 2. Run as non-root user
RUN addgroup -g 1001 -S app && adduser -S app -u 1001
USER app

# 3. Add a HEALTHCHECK to the production image
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
```

### Compose Security Options

```yaml
services:
  app:
    security_opt:
      - no-new-privileges:true      # Prevent privilege escalation
    read_only: true                  # Read-only root filesystem
    tmpfs:
      - /tmp                         # Writable tmp
      - /app/.cache                  # Writable cache
    cap_drop:
      - ALL                          # Drop all Linux capabilities
    cap_add:
      - NET_BIND_SERVICE             # Only add what's needed
```

### Secret Management in Docker

```yaml
# GOOD: Use .env files (gitignored) — injected at runtime
services:
  app:
    env_file:
      - .env
    environment:
      - API_KEY                      # Inherits from host env

# GOOD: Docker secrets (Swarm mode)
secrets:
  db_password:
    file: ./secrets/db_password.txt

services:
  db:
    secrets:
      - db_password

# BAD: Hardcoded in image layer — NEVER DO THIS
# ENV API_KEY=sk-proj-xxxxx
```

---

## PART 9: NETWORKING PATTERNS

### Custom Networks for Isolation

```yaml
services:
  frontend:
    networks:
      - frontend-net

  api:
    networks:
      - frontend-net
      - backend-net

  db:
    networks:
      - backend-net                  # Only reachable from API, not frontend

networks:
  frontend-net:
  backend-net:
```

### Expose Only What's Needed

```yaml
services:
  db:
    ports:
      - "127.0.0.1:5432:5432"       # Only accessible from host, not network
    # Omit ports entirely in production — accessible only within Docker network
```

### Debugging Network Issues

```bash
# Check DNS resolution inside container
docker compose exec app nslookup db

# Check connectivity between services
docker compose exec app wget -qO- http://api:3000/health

# Inspect the Docker network
docker network ls
docker network inspect <project>_default
```

---

## PART 10: OVERRIDE FILES & RESOURCE LIMITS

### Development vs Production Overrides

```yaml
# docker-compose.override.yml (auto-loaded, dev-only settings)
services:
  app:
    environment:
      - DEBUG=app:*
      - LOG_LEVEL=debug
    ports:
      - "9229:9229"                   # Node.js debugger

# docker-compose.prod.yml (explicit for production)
services:
  app:
    build:
      target: production
    restart: always
    deploy:
      resources:
        limits:
          cpus: "1.0"
          memory: 512M
```

```bash
# Development (auto-loads override)
docker compose up

# Production (explicit file composition)
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Useful Additional Services

```yaml
  mailpit:                            # Local email testing
    image: axllent/mailpit
    ports:
      - "8025:8025"                   # Web UI
      - "1025:1025"                   # SMTP
```

---

## PART 11: ANTI-PATTERNS

```
BAD: Using docker compose in production without orchestration
     → Use Kubernetes, ECS, or Docker Swarm for production multi-container workloads

BAD: Storing data in containers without volumes
     → Containers are ephemeral — all data lost on restart without volumes

BAD: Running as root
     → Always create and use a non-root user

BAD: Using :latest tag
     → Pin to specific versions for reproducible builds

BAD: One giant container with all services
     → Separate concerns: one process per container

BAD: Putting secrets in docker-compose.yml
     → Use .env files (gitignored) or Docker secrets
```

---

## ✅ Exit Checklist

- [ ] Multi-stage Dockerfile for backend (deps → build → production)
- [ ] Multi-stage Dockerfile for frontend (build → nginx)
- [ ] docker-compose.yml with all services (backend, frontend, postgres, redis)
- [ ] Volume mounts for hot reload in development
- [ ] Named volume for node_modules (architecture isolation)
- [ ] Health checks on database and application containers
- [ ] .dockerignore excludes unnecessary files
- [ ] Non-root user in production image
- [ ] Security options applied (no-new-privileges, cap_drop, read_only)
- [ ] Custom networks isolate frontend from database
- [ ] Secrets managed via env files or Docker secrets (never hardcoded)
- [ ] Specific image tags pinned (no `:latest`)
- [ ] Override files separate dev and production configs
