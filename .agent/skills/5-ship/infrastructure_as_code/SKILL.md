---
name: infrastructure_as_code
description: Docker, Docker Compose, Terraform, and Kubernetes patterns for containerized full-stack deployments
---

# Infrastructure as Code (IaC) Skill

**Purpose**: Treat infrastructure exactly like application code — versioned, tested, and reproducible. If it's not in code, it doesn't exist.

> [!CAUTION]
> **ClickOps Ban**: Do NOT configure production servers by clicking buttons in a web console. Every infrastructure change must be a code commit.

## 🎯 TRIGGER COMMANDS

```text
"Provision new server for [project]"
"Create docker compose for [app]"
"Setup Terraform for [infra]"
"Write a production Dockerfile"
"Deploy to Kubernetes"
"Using IaC skill: deploy [resource]"
```

## When to Use

- Containerizing a NestJS + React project for production
- Setting up Docker Compose for local development and CI
- Provisioning cloud resources with Terraform
- Deploying to Kubernetes
- Managing secrets in containerized environments
- Setting up CI/CD for container builds

---

## PART 1: CORE CONCEPTS

### Declarative vs Imperative

```
Imperative (scripting): "Create a server, install Node, copy files, start app"
  → Fragile, order-dependent, hard to reproduce

Declarative (IaC): "I want 2 containers running my app behind a load balancer"
  → Reproducible, idempotent, self-documenting
```

### Idempotency

Running the code once or 100 times produces the same result:
- Run 1: Creates the server
- Run 2: Sees server exists, does nothing
- Run 100: Still does nothing

### Immutable Infrastructure

Don't SSH in and patch servers. **Replace them.**
- Need to update Node.js? Build a new image, deploy it, destroy the old one.
- Need to fix a bug? Deploy a new container, not a hotfix on the running one.

---

## PART 2: MULTI-STAGE DOCKER (NestJS)

### Production Dockerfile

```dockerfile
# ============================================
# Stage 1: Install dependencies
# ============================================
FROM node:20-alpine AS deps
WORKDIR /app

# Copy only package files first (Docker layer caching)
COPY package*.json ./
COPY prisma ./prisma/

# Install ALL dependencies (including devDependencies for build)
RUN npm ci

# Generate Prisma client
RUN npx prisma generate

# ============================================
# Stage 2: Build TypeScript
# ============================================
FROM node:20-alpine AS build
WORKDIR /app

# Copy node_modules from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the NestJS application
RUN npm run build

# Remove devDependencies after build
RUN npm prune --production

# ============================================
# Stage 3: Production runtime
# ============================================
FROM node:20-alpine AS production
WORKDIR /app

# Security: run as non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup
USER appuser

# Copy only what's needed for production
COPY --from=build --chown=appuser:appgroup /app/dist ./dist
COPY --from=build --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=build --chown=appuser:appgroup /app/package.json ./
COPY --from=build --chown=appuser:appgroup /app/prisma ./prisma

# Expose port and set production mode
EXPOSE 3000
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/main.js"]
```

### Why Multi-Stage?

```
Single-stage image: ~1.2 GB (includes TypeScript, devDeps, source code)
Multi-stage image:  ~180 MB (only compiled JS, production deps, Prisma)

Benefits:
├── Smaller image = faster deploys
├── No source code in production image (security)
├── No devDependencies (smaller attack surface)
└── Docker layer caching speeds up rebuilds
```

### React + Vite + Nginx Dockerfile

```dockerfile
# Stage 1: Build React app
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine AS production

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```nginx
# nginx.conf
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    # SPA: all routes serve index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets aggressively
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API proxy (if frontend and backend on same domain)
    location /api/ {
        proxy_pass http://backend:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
}
```

---

## PART 3: PRODUCTION DOCKER COMPOSE

```yaml
# docker-compose.prod.yml
services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: production
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://app:${DB_PASSWORD}@postgres:5432/mydb
      - JWT_SECRET=${JWT_SECRET}
      - REDIS_URL=redis://redis:6379
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
      target: production
    restart: unless-stopped
    ports:
      - "80:80"
    depends_on:
      - backend

  postgres:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 1G

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M

volumes:
  pgdata:
    driver: local
  redis_data:
    driver: local
```

### Production vs Development Compose Differences

| Setting | Development | Production |
|---------|------------|------------|
| `restart` | Not set | `unless-stopped` |
| `volumes` | Source code mounted for hot reload | No source mounting |
| `target` | `deps` stage | `production` stage |
| `resources` | Not set | CPU/memory limits |
| `healthcheck` | Optional | Required |
| Secrets | `.env` file | Docker secrets or env from CI |
| Ports | All exposed for debugging | Only necessary ports |

---

## PART 4: DOCKER .dockerignore

```dockerignore
# Dependencies (installed inside container)
node_modules
npm-debug.log*

# Build output (built inside container)
dist
build

# Version control
.git
.gitignore

# Environment (secrets — never copy to image)
.env
.env.local
.env.production

# IDE
.vscode
.idea
*.swp

# Testing
coverage
test-results
playwright-report

# Documentation
*.md
LICENSE

# Docker (prevent recursive copy)
Dockerfile
docker-compose*.yml
.dockerignore
```

---

## PART 5: TERRAFORM BASICS

### State Management

```hcl
# backend.tf — Store state remotely (NEVER in git)
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"  # Prevents concurrent modifications
    encrypt        = true
  }
}
```

### Resource Examples

```hcl
# main.tf — AWS resources
provider "aws" {
  region = var.aws_region
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier          = "${var.project}-db"
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  db_name             = "mydb"
  username            = "app"
  password            = var.db_password  # From tfvars or secrets manager
  skip_final_snapshot = false

  vpc_security_group_ids = [aws_security_group.db.id]

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

# S3 bucket for file storage
resource "aws_s3_bucket" "assets" {
  bucket = "${var.project}-assets-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### Variables and Outputs

```hcl
# variables.tf
variable "project" {
  type    = string
  default = "myapp"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db_password" {
  type      = string
  sensitive = true  # Won't be shown in plan output
}

# outputs.tf
output "database_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}
```

### Terraform Workflow

```bash
# Initialize (download providers)
terraform init

# Preview changes (ALWAYS do this first)
terraform plan -var-file="prod.tfvars"

# Apply changes (requires confirmation)
terraform apply -var-file="prod.tfvars"

# Destroy all resources (DANGEROUS)
terraform destroy -var-file="prod.tfvars"
```

### Workspaces for Environments

```bash
# Create separate state per environment
terraform workspace new staging
terraform workspace new production

# Switch between environments
terraform workspace select staging
terraform plan

terraform workspace select production
terraform plan
```

---

## PART 6: KUBERNETES BASICS

### Pod → Deployment → Service → Ingress

```
Internet
  └── Ingress (routing rules, TLS)
       └── Service (load balancer, stable IP)
            └── Deployment (manages replica sets)
                 └── Pod (one or more containers)
```

### NestJS Deployment

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
        - name: backend
          image: myregistry/backend:latest
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: "production"
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: database-url
          resources:
            requests:
              cpu: "250m"
              memory: "128Mi"
            limits:
              cpu: "1000m"
              memory: "512Mi"
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 15
            periodSeconds: 10
```

### Service

```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - port: 80
      targetPort: 3000
  type: ClusterIP
```

### Ingress

```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - api.myapp.com
      secretName: api-tls
  rules:
    - host: api.myapp.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: backend
                port:
                  number: 80
```

---

## PART 7: SECRET MANAGEMENT

### Docker Compose Secrets

```yaml
# docker-compose.prod.yml
services:
  backend:
    environment:
      - DATABASE_URL_FILE=/run/secrets/db_url
    secrets:
      - db_url
      - jwt_secret

secrets:
  db_url:
    file: ./secrets/db_url.txt      # Local file
  jwt_secret:
    external: true                    # From Docker Swarm secrets
```

### Kubernetes Secrets

```bash
# Create secret from literal values
kubectl create secret generic app-secrets \
  --from-literal=database-url='postgresql://...' \
  --from-literal=jwt-secret='your-secret-here'

# Create secret from file
kubectl create secret generic app-secrets \
  --from-file=./secrets/database-url
```

```yaml
# k8s/secret.yaml (NEVER commit actual values)
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  database-url: cG9zdGdyZXNxbDovLy4uLg==  # base64 encoded
```

### Secret Management Best Practices

```
NEVER:
├── Commit secrets to git
├── Put secrets in Dockerfiles (they're in image layers!)
├── Use environment variables for highly sensitive secrets
└── Share secrets via Slack/email

ALWAYS:
├── Use a secrets manager (Vault, AWS Secrets Manager, Infisical)
├── Rotate secrets regularly
├── Use different secrets per environment
├── Audit secret access
└── Encrypt secrets at rest
```

---

## PART 8: CONTAINER REGISTRY

### Build and Push

```bash
# Build with tag
docker build -t myregistry/backend:v1.2.3 -t myregistry/backend:latest .

# Push to registry
docker push myregistry/backend:v1.2.3
docker push myregistry/backend:latest
```

### Tagging Strategy

```
Tags:
├── myapp:latest           — Most recent build (mutable, use with caution)
├── myapp:v1.2.3           — Semantic version (immutable, preferred for production)
├── myapp:abc1234          — Git commit SHA (immutable, great for tracing)
└── myapp:staging-abc1234  — Environment + commit (for env-specific builds)
```

### CI/CD Image Build (GitHub Actions)

```yaml
# .github/workflows/docker.yml
name: Build & Push Docker Image
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Log in to container registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: |
            ghcr.io/${{ github.repository }}/backend:latest
            ghcr.io/${{ github.repository }}/backend:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### Container Scanning

```yaml
# Add to CI pipeline after build
- name: Scan for vulnerabilities
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ghcr.io/${{ github.repository }}/backend:${{ github.sha }}
    format: 'sarif'
    output: 'trivy-results.sarif'
    severity: 'CRITICAL,HIGH'
```

---

## PART 9: COMMON ISSUES

| Issue | Cause | Fix |
|-------|-------|-----|
| Prisma binary not found in container | Wrong binary target | Add `binaryTargets = ["native", "linux-musl-openssl-3.0.x"]` to schema |
| Container OOM killed | Memory limit too low | Increase `memory` limit or optimize app |
| Build takes 10+ minutes | No Docker layer caching | Copy package.json first, install deps, then copy source |
| Hot reload not working | Volume mount missing | Mount `./src:/app/src` in development compose |
| Container can't reach database | Wrong network or hostname | Use service name as hostname (e.g., `postgres` not `localhost`) |
| Permission denied on volume | Host/container UID mismatch | Use `user: "${UID}:${GID}"` or match container user ID |

---

## ✅ Exit Checklist

- [ ] Multi-stage Dockerfile for backend (deps → build → production)
- [ ] Multi-stage Dockerfile for frontend (build → nginx)
- [ ] Non-root user in production images
- [ ] .dockerignore excludes node_modules, .env, .git
- [ ] docker-compose.yml with health checks and resource limits
- [ ] Secrets never committed to git or baked into images
- [ ] Terraform state stored remotely with locking
- [ ] Container images tagged with version/SHA (not just `latest`)
- [ ] Container scanning in CI pipeline
- [ ] Health checks configured for all services
