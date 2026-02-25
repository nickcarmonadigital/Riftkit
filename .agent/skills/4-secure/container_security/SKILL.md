---
name: Container Security
description: Dockerfile hardening, image vulnerability scanning with Trivy, and runtime security policy enforcement
---

# Container Security Skill

**Purpose**: Secure the container lifecycle across three domains: (1) Dockerfile hardening to minimize attack surface at build time, (2) image vulnerability scanning with Trivy or Docker Scout to catch CVEs before deployment, and (3) runtime security policies that prevent privilege escalation and enforce least-privilege in Kubernetes or Docker Compose environments.

## TRIGGER COMMANDS

```text
"Scan Docker image"
"Harden Dockerfile"
"Container security audit"
"CIS Docker benchmark"
"Trivy scan for [image]"
```

## When to Use
- Building or reviewing a Dockerfile for production use
- Adding container image scanning to CI/CD pipeline
- Hardening runtime container configuration (Compose or Kubernetes)
- Preparing for CIS Docker Benchmark compliance
- Generating SBOM from container image layers

---

## PROCESS

### Step 1: Dockerfile Hardening

Apply these hardening patterns to every production Dockerfile:

```dockerfile
# 1. Use specific version tags, never :latest
FROM node:20-alpine AS builder

# 2. Multi-stage build to minimize final image
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# 3. Use distroless or minimal base for runtime
FROM gcr.io/distroless/nodejs20-debian12 AS runtime

# 4. Never run as root
# (distroless runs as nonroot:65534 by default)
# For non-distroless images:
# RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser
# USER appuser

WORKDIR /app
COPY --from=builder --chown=65534:65534 /app/dist ./dist
COPY --from=builder --chown=65534:65534 /app/node_modules ./node_modules

# 5. Never put secrets in ENV or ARG
# BAD:  ENV DATABASE_URL=postgres://user:pass@host/db
# GOOD: Inject at runtime via orchestrator

# 6. Use COPY, not ADD (ADD auto-extracts and fetches URLs)
# 7. Set read-only filesystem where possible
# 8. Expose only needed ports
EXPOSE 3000

CMD ["dist/main.js"]
```

**Hardening checklist for Dockerfile review:**

| Check | Rationale |
|-------|-----------|
| Non-root USER directive | Prevents container escape privilege escalation |
| Multi-stage build | Excludes build tools, source code, devDependencies |
| Pinned base image tag | Reproducible builds, no surprise updates |
| No secrets in ENV/ARG/COPY | Secrets baked into layers persist in image history |
| `.dockerignore` configured | Excludes `.env`, `.git`, `node_modules`, docs |
| Minimal base (alpine/distroless) | Smaller attack surface, fewer CVEs |

### Step 2: Image Vulnerability Scanning with Trivy

**Install and run Trivy:**

```bash
# Install Trivy
brew install trivy
# Or via Docker
docker run --rm aquasec/trivy image <your-image>

# Scan a local image
trivy image --severity HIGH,CRITICAL myapp:latest

# Scan and output SARIF for GitHub Security tab
trivy image --format sarif --output trivy-results.sarif myapp:latest

# Generate SBOM from image layers
trivy image --format cyclonedx --output sbom.json myapp:latest

# Scan Dockerfile for misconfigurations (IaC scanning)
trivy config --severity HIGH,CRITICAL ./Dockerfile
```

**CI/CD Integration (`.github/workflows/container-security.yml`):**

```yaml
name: Container Security
on:
  pull_request:
    paths: ['Dockerfile', 'docker-compose*.yml', '.dockerignore']
  push:
    branches: [main]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    permissions:
      security-events: write
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t ${{ github.repository }}:${{ github.sha }} .

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: '${{ github.repository }}:${{ github.sha }}'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
          exit-code: '1'

      - name: Upload Trivy SARIF
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: trivy-results.sarif

      - name: Run Dockerfile linter
        uses: hadolint/hadolint-action@v3.1.0
        with:
          dockerfile: Dockerfile
```

### Step 3: Runtime Security Policies

**Docker Compose hardening:**

```yaml
services:
  app:
    image: myapp:latest
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE  # Only if binding ports < 1024
    read_only: true
    tmpfs:
      - /tmp
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '1.0'
    # Never use --privileged
```

**Kubernetes Pod Security Standards:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 65534
    fsGroup: 65534
    seccompProfile:
      type: RuntimeDefault
  containers:
    - name: app
      image: myapp:latest
      securityContext:
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
        capabilities:
          drop: ["ALL"]
      resources:
        limits:
          memory: "512Mi"
          cpu: "1000m"
        requests:
          memory: "256Mi"
          cpu: "250m"
```

### Step 4: CIS Docker Benchmark Scan

```bash
# Run Docker Bench for Security (CIS benchmark)
docker run --rm --net host --pid host \
  --userns host --cap-add audit_control \
  -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /etc:/etc:ro \
  docker/docker-bench-security
```

---

## CHECKLIST

- [ ] Dockerfile uses multi-stage build with minimal runtime base
- [ ] Non-root USER directive present in Dockerfile
- [ ] No secrets in ENV, ARG, or COPY instructions
- [ ] `.dockerignore` excludes `.env`, `.git`, `node_modules`
- [ ] Base image uses pinned version tag (not `:latest`)
- [ ] Trivy scan runs in CI and blocks on CRITICAL/HIGH findings
- [ ] SARIF results uploaded to GitHub Security tab
- [ ] SBOM generated from image layers (CycloneDX format)
- [ ] Hadolint or equivalent Dockerfile linter in CI
- [ ] Runtime: `no-new-privileges`, `cap_drop: ALL`, resource limits set
- [ ] Runtime: `read_only` filesystem with tmpfs for writable paths
- [ ] CIS Docker Benchmark scan completed and findings addressed

*Skill Version: 1.0 | Created: February 2026*
