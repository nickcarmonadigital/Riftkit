---
name: multi-stack-deployment
description: Deployment patterns for Django, Go, and Swift/iOS — production configs, CI/CD pipelines, Dockerfiles, and cross-stack deployment verification
---

# Multi-Stack Deployment

**Purpose**: Extend deployment coverage beyond NestJS/Docker. This skill provides production-ready deployment patterns for Django/Python, Go, and Swift/iOS including CI/CD pipelines, container builds, and cross-stack verification.

> [!IMPORTANT]
> **Every stack ships the same way**: health checks, zero-downtime deploys, rollback capability, smoke tests. The tooling differs but the guarantees do not.

## TRIGGER COMMANDS

```text
"Deploy Django to production"
"Create Dockerfile for Go service"
"Setup CI/CD for Swift app"
"Configure Gunicorn for production"
"Build static Go binary"
"Using multi-stack-deployment skill: deploy [component]"
```

## When to Use

- Deploying a Django application with Gunicorn + Nginx
- Building minimal Docker images for Go services
- Setting up Xcode Cloud or Fastlane for iOS distribution
- Creating GitHub Actions workflows for polyglot monorepos
- Implementing deployment verification across stacks

---

## PART 1: DJANGO DEPLOYMENT

### 1.1 Gunicorn + Nginx

```bash
pip install gunicorn
```

```python
# gunicorn.conf.py
import multiprocessing

bind = "0.0.0.0:8000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "gthread"
threads = 2
timeout = 30
keepalive = 5
max_requests = 1000          # restart workers after N requests (prevents memory leaks)
max_requests_jitter = 50
accesslog = "-"               # stdout
errorlog = "-"
loglevel = "info"
```

```nginx
# nginx/default.conf
upstream django {
    server app:8000;
}

server {
    listen 80;
    server_name _;

    client_max_body_size 10M;

    location /static/ {
        alias /app/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location /media/ {
        alias /app/media/;
        expires 7d;
    }

    location / {
        proxy_pass http://django;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Request-ID $request_id;
        proxy_read_timeout 30s;
    }
}
```

### 1.2 Production Django Settings

```python
# settings/production.py
import os

DEBUG = False
ALLOWED_HOSTS = os.environ["ALLOWED_HOSTS"].split(",")
SECRET_KEY = os.environ["DJANGO_SECRET_KEY"]

# Security headers
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SECURE_BROWSER_XSS_FILTER = True
X_FRAME_OPTIONS = "DENY"

# Static files
STATIC_ROOT = os.path.join(BASE_DIR, "staticfiles")
STATICFILES_STORAGE = "django.contrib.staticfiles.storage.ManifestStaticFilesStorage"

# Database with connection pooling
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ["DB_NAME"],
        "USER": os.environ["DB_USER"],
        "PASSWORD": os.environ["DB_PASSWORD"],
        "HOST": os.environ["DB_HOST"],
        "PORT": os.environ.get("DB_PORT", "5432"),
        "CONN_MAX_AGE": 600,
        "CONN_HEALTH_CHECKS": True,
    }
}

# Logging
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {"class": "logging.StreamHandler"},
    },
    "root": {"handlers": ["console"], "level": "INFO"},
}
```

### 1.3 Django Dockerfile

```dockerfile
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev gcc && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "-c", "gunicorn.conf.py"]
```

### 1.4 Celery Worker Deployment

```yaml
# docker-compose.prod.yml
services:
  app:
    build: .
    command: gunicorn config.wsgi:application -c gunicorn.conf.py
    env_file: .env.production
    depends_on:
      db:
        condition: service_healthy

  celery-worker:
    build: .
    command: celery -A config worker -l info --concurrency=4
    env_file: .env.production
    depends_on:
      - redis
      - db

  celery-beat:
    build: .
    command: celery -A config beat -l info --scheduler django_celery_beat.schedulers:DatabaseScheduler
    env_file: .env.production
    depends_on:
      - redis
      - db

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx:/etc/nginx/conf.d
      - static_data:/app/staticfiles
    depends_on:
      - app

volumes:
  redis_data:
  static_data:
```

### 1.5 Database Migration in CI/CD

```yaml
# In deployment pipeline — run BEFORE starting new app containers
deploy:
  steps:
    - name: Run migrations
      run: |
        docker compose -f docker-compose.prod.yml run --rm app \
          python manage.py migrate --noinput

    - name: Start services
      run: docker compose -f docker-compose.prod.yml up -d
```

Migration safety rules:
- Never rename columns in a single step (add new, migrate data, drop old)
- Never drop columns that old code still reads (deploy code first, then migrate)
- Use `RunSQL` with `reverse_sql` for every raw SQL migration
- Test migrations against a production-size dataset before deploying

---

## PART 2: GO DEPLOYMENT

### 2.1 Static Binary Build

```bash
# Build a fully static binary — no libc dependency
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server ./cmd/server
```

### 2.2 Multi-Stage Dockerfile

```dockerfile
# Build stage
FROM golang:1.23-alpine AS build
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /server ./cmd/server

# Runtime stage — scratch for minimal image, distroless for slightly more convenience
FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /server /server
EXPOSE 8080
USER nonroot:nonroot
ENTRYPOINT ["/server"]
```

Result: ~10-20MB image with zero attack surface (no shell, no package manager).

### 2.3 Graceful Shutdown

```go
func main() {
    srv := &http.Server{
        Addr:         ":" + os.Getenv("PORT"),
        Handler:      router,
        ReadTimeout:  10 * time.Second,
        WriteTimeout: 30 * time.Second,
        IdleTimeout:  120 * time.Second,
    }

    go func() {
        if err := srv.ListenAndServe(); err != http.ErrServerClosed {
            slog.Error("server.listen_error", "error", err)
            os.Exit(1)
        }
    }()

    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    sig := <-quit

    slog.Info("server.shutdown_signal", "signal", sig.String())

    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()

    if err := srv.Shutdown(ctx); err != nil {
        slog.Error("server.shutdown_error", "error", err)
    }
    slog.Info("server.stopped")
}
```

### 2.4 Configuration via Environment

```go
// config/config.go
type Config struct {
    Port        string `env:"PORT"        default:"8080"`
    DatabaseURL string `env:"DATABASE_URL" required:"true"`
    LogLevel    string `env:"LOG_LEVEL"   default:"info"`
    Environment string `env:"ENV"         default:"development"`
}

func Load() (*Config, error) {
    cfg := &Config{}
    // Use github.com/caarlos0/env or manual os.Getenv
    // No config files in containers — 12-factor app compliance
    return cfg, nil
}
```

### 2.5 Health Check

```go
// Wire into router
mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
    if err := db.PingContext(r.Context()); err != nil {
        w.WriteHeader(http.StatusServiceUnavailable)
        json.NewEncoder(w).Encode(map[string]string{"status": "unhealthy", "db": err.Error()})
        return
    }
    json.NewEncoder(w).Encode(map[string]string{"status": "healthy"})
})
```

```yaml
# Kubernetes / Docker health check
healthcheck:
  test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/healthz"]
  interval: 10s
  timeout: 5s
  retries: 3
```

---

## PART 3: SWIFT / iOS DEPLOYMENT

### 3.1 Fastlane Setup

```ruby
# fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Run tests"
  lane :test do
    run_tests(
      scheme: "MyApp",
      devices: ["iPhone 15"],
      clean: true
    )
  end

  desc "Build and upload to TestFlight"
  lane :beta do
    increment_build_number(
      build_number: ENV["CI_BUILD_NUMBER"] || latest_testflight_build_number + 1
    )

    build_app(
      scheme: "MyApp",
      export_method: "app-store",
      output_directory: "./build"
    )

    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Release to App Store"
  lane :release do
    build_app(scheme: "MyApp", export_method: "app-store")
    upload_to_app_store(
      submit_for_review: true,
      automatic_release: false,  # manual release after approval
      force: true
    )
  end
end
```

### 3.2 Code Signing in CI

```ruby
# fastlane/Matchfile — use match for team code signing
git_url("git@github.com:org/certificates.git")
storage_mode("git")
type("appstore")
app_identifier("com.example.myapp")
```

```ruby
# In Fastfile, before build_app
lane :beta do
  setup_ci           # configure CI keychain
  match(type: "appstore", readonly: true)
  build_app(scheme: "MyApp", export_method: "app-store")
  upload_to_testflight
end
```

### 3.3 Xcode Cloud Configuration

```yaml
# ci_scripts/ci_post_clone.sh (runs after Xcode Cloud clones repo)
#!/bin/sh
set -e

# Install dependencies
cd ../..
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Set build number from Xcode Cloud environment
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CI_BUILD_NUMBER" \
  "$CI_WORKSPACE/MyApp/Info.plist"
```

### 3.4 App Store Connect API

```bash
# Generate API key in App Store Connect > Users and Access > Keys
# Store as CI secrets: APP_STORE_CONNECT_API_KEY_ID, ISSUER_ID, KEY_CONTENT
```

```ruby
# fastlane/Appfile
app_store_connect_api_key(
  key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
  issuer_id: ENV["APP_STORE_CONNECT_ISSUER_ID"],
  key_content: ENV["APP_STORE_CONNECT_API_KEY"],
  is_key_content_base64: true,
  in_house: false
)
```

---

## PART 4: CROSS-STACK CI/CD

### 4.1 GitHub Actions Matrix Build

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  detect-changes:
    runs-on: ubuntu-latest
    outputs:
      django: ${{ steps.changes.outputs.django }}
      go: ${{ steps.changes.outputs.go }}
      ios: ${{ steps.changes.outputs.ios }}
    steps:
      - uses: actions/checkout@v4
      - uses: dorny/paths-filter@v3
        id: changes
        with:
          filters: |
            django:
              - 'services/api/**'
            go:
              - 'services/gateway/**'
            ios:
              - 'apps/ios/**'

  test-django:
    needs: detect-changes
    if: needs.detect-changes.outputs.django == 'true'
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: testdb
          POSTGRES_PASSWORD: testpass
        ports: ["5432:5432"]
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: pip
      - run: pip install -r services/api/requirements.txt
      - run: |
          cd services/api
          python manage.py migrate --noinput
          python manage.py test --parallel
        env:
          DATABASE_URL: postgres://postgres:testpass@localhost:5432/testdb

  test-go:
    needs: detect-changes
    if: needs.detect-changes.outputs.go == 'true'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: "1.23"
      - run: |
          cd services/gateway
          go test -race -coverprofile=coverage.out ./...

  test-ios:
    needs: detect-changes
    if: needs.detect-changes.outputs.ios == 'true'
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - run: |
          cd apps/ios
          xcodebuild test \
            -scheme MyApp \
            -destination 'platform=iOS Simulator,name=iPhone 15' \
            -resultBundlePath TestResults

  deploy:
    needs: [test-django, test-go]
    if: github.ref == 'refs/heads/main' && !failure() && !cancelled()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy changed services
        run: |
          # Only deploy services that changed and passed tests
          echo "Deploying changed services..."
```

### 4.2 Monorepo Deploy-Only-Changed

```yaml
# deploy job continued
- name: Deploy Django
  if: needs.detect-changes.outputs.django == 'true'
  run: |
    docker build -t registry.example.com/api:${{ github.sha }} services/api/
    docker push registry.example.com/api:${{ github.sha }}
    kubectl set image deployment/api api=registry.example.com/api:${{ github.sha }}

- name: Deploy Go Gateway
  if: needs.detect-changes.outputs.go == 'true'
  run: |
    docker build -t registry.example.com/gateway:${{ github.sha }} services/gateway/
    docker push registry.example.com/gateway:${{ github.sha }}
    kubectl set image deployment/gateway gateway=registry.example.com/gateway:${{ github.sha }}
```

### 4.3 Stack-Agnostic Smoke Tests

```yaml
# .github/workflows/smoke-test.yml
name: Post-Deploy Smoke Test

on:
  workflow_call:
    inputs:
      base_url:
        required: true
        type: string

jobs:
  smoke:
    runs-on: ubuntu-latest
    steps:
      - name: Health check
        run: |
          for endpoint in /health /healthz /api/health; do
            status=$(curl -s -o /dev/null -w "%{http_code}" "${{ inputs.base_url }}${endpoint}" || true)
            if [ "$status" = "200" ]; then
              echo "Health check passed: ${endpoint}"
              exit 0
            fi
          done
          echo "No health endpoint responded with 200"
          exit 1

      - name: Response time check
        run: |
          time_total=$(curl -s -o /dev/null -w "%{time_total}" "${{ inputs.base_url }}/health")
          echo "Response time: ${time_total}s"
          if (( $(echo "$time_total > 5.0" | bc -l) )); then
            echo "Response time exceeds 5s threshold"
            exit 1
          fi

      - name: Error rate check (Prometheus query)
        if: inputs.prometheus_url != ''
        run: |
          rate=$(curl -s "${{ inputs.prometheus_url }}/api/v1/query?query=sum(rate(http_requests_total{status=~\"5..\"}[5m]))/sum(rate(http_requests_total[5m]))" \
            | jq -r '.data.result[0].value[1] // "0"')
          echo "Error rate: ${rate}"
          if (( $(echo "$rate > 0.01" | bc -l) )); then
            echo "Error rate exceeds 1% threshold"
            exit 1
          fi
```

---

## Exit Checklist

- [ ] Django: Gunicorn configured with appropriate workers and timeout
- [ ] Django: Nginx reverse proxy with static file serving
- [ ] Django: Production settings hardened (SECURE_*, DEBUG=False, ALLOWED_HOSTS)
- [ ] Django: collectstatic runs in build step, not at runtime
- [ ] Django: Migrations run before new containers start
- [ ] Django: Celery workers deployed as separate containers
- [ ] Go: Static binary built with CGO_ENABLED=0
- [ ] Go: Multi-stage Dockerfile produces minimal image (<20MB)
- [ ] Go: Graceful shutdown handles SIGTERM with drain timeout
- [ ] Go: Configuration via environment variables only (no config files)
- [ ] Go: Health check endpoint at /healthz
- [ ] Swift: Fastlane or Xcode Cloud configured for builds
- [ ] Swift: Code signing managed via match (not manual)
- [ ] Swift: Build number auto-incremented in CI
- [ ] Swift: TestFlight distribution automated
- [ ] CI/CD: Change detection deploys only affected services
- [ ] CI/CD: Stack-agnostic smoke tests verify each deployment
- [ ] CI/CD: Rollback plan documented for each stack
