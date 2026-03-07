---
name: API Gateway Patterns
description: API gateways with Kong and AWS API Gateway covering rate limiting, auth, transformation, and versioning
---

# API Gateway Patterns Skill

**Purpose**: Design and configure API gateways for traffic management, authentication, rate limiting, request transformation, and API versioning using Kong, AWS API Gateway, or similar platforms.

---

## TRIGGER COMMANDS

```text
"Set up an API gateway"
"Configure rate limiting"
"Add authentication to API gateway"
"API versioning strategy"
"Using api_gateway_patterns skill: [task]"
```

---

## Gateway Comparison

| Feature | Kong | AWS API Gateway | Traefik | NGINX | Envoy Gateway |
|---------|------|----------------|---------|-------|---------------|
| Deployment | Self-hosted/Cloud | Managed | Self-hosted | Self-hosted | Self-hosted |
| Protocol | HTTP, gRPC, WebSocket, TCP | HTTP, WebSocket | HTTP, gRPC, TCP | HTTP, gRPC, TCP | HTTP, gRPC |
| Plugin system | Lua/Go plugins | Lambda authorizers | Middleware | Modules | xDS filters |
| Rate limiting | Built-in plugin | Built-in | Built-in | Module | Built-in |
| Auth | OAuth2, JWT, OIDC, mTLS | IAM, Cognito, Lambda | ForwardAuth | JWT | OIDC |
| Observability | Prometheus, OpenTelemetry | CloudWatch | Prometheus | Access logs | OpenTelemetry |
| Cost | Free (OSS) / Enterprise | Pay per request | Free (OSS) | Free (OSS) | Free (OSS) |
| Best for | Full-featured, multi-cloud | AWS-native, serverless | Kubernetes-native | High performance | Envoy-based mesh |

---

## Architecture

```
                          +------------------+
Internet ──> [CDN/WAF] ──>|   API Gateway    |
                          |  - Auth          |
                          |  - Rate Limit    |
                          |  - Transform     |
                          |  - Route         |
                          +--------+---------+
                                   |
                    +--------------+--------------+
                    |              |              |
               +----+----+  +----+----+  +------+------+
               | Service | | Service  | | Service     |
               |   A     | |   B      | |   C         |
               +---------+ +----------+ +-------------+

North-South traffic: Client -> Gateway -> Service (API Gateway handles)
East-West traffic:   Service -> Service (Service Mesh handles)
```

---

## Kong Gateway

### Docker Compose Setup

```yaml
version: "3.8"
services:
  kong-database:
    image: postgres:16
    environment:
      POSTGRES_DB: kong
      POSTGRES_USER: kong
      POSTGRES_PASSWORD: kongpass
    volumes:
      - kong-data:/var/lib/postgresql/data

  kong-migration:
    image: kong:3.6
    command: kong migrations bootstrap
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: kong-database
      KONG_PG_PASSWORD: kongpass
    depends_on:
      - kong-database

  kong:
    image: kong:3.6
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: kong-database
      KONG_PG_PASSWORD: kongpass
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
    ports:
      - "8000:8000"    # Proxy
      - "8443:8443"    # Proxy SSL
      - "8001:8001"    # Admin API
    depends_on:
      - kong-migration

volumes:
  kong-data:
```

### Kong Declarative Config (DB-less)

```yaml
# kong.yaml
_format_version: "3.0"

services:
  - name: order-service
    url: http://order-service:8080
    routes:
      - name: orders-route
        paths:
          - /api/v1/orders
        methods:
          - GET
          - POST
          - PUT
          - DELETE
        strip_path: false
    plugins:
      - name: rate-limiting
        config:
          minute: 100
          hour: 5000
          policy: redis
          redis_host: redis
          redis_port: 6379
      - name: jwt
        config:
          uri_param_names: []
          cookie_names: []
          key_claim_name: iss
      - name: correlation-id
        config:
          header_name: X-Request-ID
          generator: uuid
          echo_downstream: true
      - name: prometheus

  - name: user-service
    url: http://user-service:8080
    routes:
      - name: users-route
        paths:
          - /api/v1/users

consumers:
  - username: mobile-app
    jwt_secrets:
      - key: mobile-app-key
        algorithm: RS256
        rsa_public_key: |
          -----BEGIN PUBLIC KEY-----
          ...
          -----END PUBLIC KEY-----

plugins:
  - name: cors
    config:
      origins: ["https://app.example.com"]
      methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
      headers: ["Authorization", "Content-Type", "X-Request-ID"]
      max_age: 3600
  - name: ip-restriction
    service: admin-service
    config:
      allow: ["10.0.0.0/8", "172.16.0.0/12"]
```

### Kong Plugin Categories

| Category | Plugins | Purpose |
|----------|---------|---------|
| Authentication | jwt, oauth2, key-auth, ldap-auth, oidc | Verify identity |
| Security | cors, ip-restriction, bot-detection, acl | Protect endpoints |
| Traffic Control | rate-limiting, request-size-limiting, proxy-cache | Manage load |
| Transformation | request-transformer, response-transformer | Modify req/res |
| Logging | file-log, http-log, syslog, tcp-log | Audit trail |
| Analytics | prometheus, datadog, opentelemetry | Metrics |

---

## Rate Limiting

### Rate Limiting Strategies

| Strategy | Description | Use Case |
|----------|-------------|----------|
| Fixed window | N requests per time window | Simple, predictable |
| Sliding window | Rolling count over window | Smoother distribution |
| Token bucket | Tokens refill at fixed rate | Burst-friendly |
| Leaky bucket | Requests drain at fixed rate | Smooth output rate |
| Concurrent | Limit in-flight requests | Protect backend capacity |

### Kong Rate Limiting

```yaml
plugins:
  - name: rate-limiting
    config:
      minute: 60
      hour: 1000
      policy: redis
      redis_host: redis
      redis_port: 6379
      redis_timeout: 2000
      fault_tolerant: true      # Allow traffic if Redis is down
      hide_client_headers: false # Return X-RateLimit-* headers
      error_code: 429
      error_message: "Rate limit exceeded. Try again later."
```

### Tiered Rate Limiting

```yaml
# Free tier consumer
consumers:
  - username: free-tier
    plugins:
      - name: rate-limiting
        config:
          minute: 10
          hour: 100

# Pro tier consumer
  - username: pro-tier
    plugins:
      - name: rate-limiting
        config:
          minute: 100
          hour: 5000

# Enterprise tier consumer
  - username: enterprise-tier
    plugins:
      - name: rate-limiting
        config:
          minute: 1000
          hour: 50000
```

### Response Headers

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1709715600
Retry-After: 30
```

---

## Authentication Patterns

### JWT Validation

```yaml
# Kong JWT plugin
plugins:
  - name: jwt
    config:
      uri_param_names: []
      header_names: ["Authorization"]
      claims_to_verify: ["exp"]
      key_claim_name: "iss"
      maximum_expiration: 3600
```

### OAuth2 / OIDC

```yaml
# Kong OIDC plugin (Enterprise or community plugin)
plugins:
  - name: openid-connect
    config:
      issuer: https://auth.example.com/.well-known/openid-configuration
      client_id: ["gateway-client"]
      client_secret: ["secret"]
      redirect_uri: ["https://api.example.com/callback"]
      scopes: ["openid", "profile"]
      token_endpoint_auth_method: client_secret_basic
```

### API Key Authentication

```yaml
plugins:
  - name: key-auth
    config:
      key_names: ["X-API-Key", "apikey"]
      key_in_header: true
      key_in_query: true
      key_in_body: false
      hide_credentials: true  # Strip key before forwarding
```

---

## AWS API Gateway

### REST API with Lambda

```yaml
# serverless.yml (Serverless Framework)
service: order-api

provider:
  name: aws
  runtime: nodejs20.x
  stage: ${opt:stage, 'dev'}
  region: us-east-1
  apiGateway:
    shouldStartNameWithService: true
    apiKeys:
      - name: mobile-app-key
    usagePlan:
      quota:
        limit: 10000
        period: MONTH
      throttle:
        burstLimit: 50
        rateLimit: 100

functions:
  getOrders:
    handler: src/handlers/orders.list
    events:
      - http:
          path: /orders
          method: get
          cors: true
          authorizer:
            name: jwtAuthorizer
            type: TOKEN
            identitySource: method.request.header.Authorization

  createOrder:
    handler: src/handlers/orders.create
    events:
      - http:
          path: /orders
          method: post
          cors: true
          private: true  # Requires API key
```

### HTTP API (v2) with JWT

```yaml
# AWS SAM template
Resources:
  HttpApi:
    Type: AWS::Serverless::HttpApi
    Properties:
      StageName: prod
      CorsConfiguration:
        AllowOrigins: ["https://app.example.com"]
        AllowMethods: ["GET", "POST", "PUT", "DELETE"]
        AllowHeaders: ["Authorization", "Content-Type"]
      Auth:
        DefaultAuthorizer: JWTAuthorizer
        Authorizers:
          JWTAuthorizer:
            AuthorizationScopes:
              - email
              - profile
            IdentitySource: $request.header.Authorization
            JwtConfiguration:
              audience:
                - api-client-id
              issuer: https://auth.example.com/
```

---

## API Versioning

### Versioning Strategies

| Strategy | Example | Pros | Cons |
|----------|---------|------|------|
| URL path | /api/v1/orders | Explicit, cacheable | URL pollution |
| Header | Accept: application/vnd.api.v2+json | Clean URLs | Hidden, harder to test |
| Query param | /api/orders?version=2 | Easy to test | Not RESTful |
| Subdomain | v2.api.example.com | Clean separation | DNS complexity |

### URL Path Versioning (Recommended)

```yaml
# Kong routes for versioned API
services:
  - name: orders-v1
    url: http://orders-v1:8080
    routes:
      - name: orders-v1-route
        paths: ["/api/v1/orders"]

  - name: orders-v2
    url: http://orders-v2:8080
    routes:
      - name: orders-v2-route
        paths: ["/api/v2/orders"]
```

### Request Transformation (Version Adapter)

```yaml
# Transform v1 requests to v2 format
plugins:
  - name: request-transformer
    service: orders-v2
    route: orders-v1-route
    config:
      add:
        headers: ["X-API-Version:v1"]
      rename:
        body: ["customer_name:customerName"]
```

---

## Request/Response Transformation

### Header Injection

```yaml
plugins:
  - name: request-transformer
    config:
      add:
        headers:
          - "X-Request-Source:gateway"
          - "X-Forwarded-Proto:https"
      remove:
        headers:
          - "X-Internal-Token"
```

### Response Transformation

```yaml
plugins:
  - name: response-transformer
    config:
      remove:
        headers:
          - "X-Powered-By"
          - "Server"
      add:
        headers:
          - "X-Content-Type-Options:nosniff"
          - "Strict-Transport-Security:max-age=31536000"
```

---

## Health Checks and Load Balancing

### Active Health Checks (Kong)

```yaml
services:
  - name: order-service
    url: http://order-service:8080
    connect_timeout: 5000
    write_timeout: 60000
    read_timeout: 60000
    retries: 3

upstreams:
  - name: order-service
    algorithm: round-robin
    healthchecks:
      active:
        healthy:
          interval: 10
          successes: 3
          http_statuses: [200, 302]
        unhealthy:
          interval: 5
          http_failures: 3
          tcp_failures: 3
          timeouts: 3
          http_statuses: [429, 500, 503]
        http_path: /healthz
        timeout: 5
      passive:
        healthy:
          successes: 5
          http_statuses: [200, 201, 301, 302]
        unhealthy:
          http_failures: 5
          tcp_failures: 3
          timeouts: 3
          http_statuses: [500, 502, 503]
    targets:
      - target: order-service-1:8080
        weight: 100
      - target: order-service-2:8080
        weight: 100
```

---

## Cross-References

- `3-build/service_mesh_patterns` - East-west traffic (gateway handles north-south)
- `3-build/caching_strategies` - Gateway-level caching (proxy-cache plugin)
- `4-secure/infrastructure_testing` - Test gateway config with policy-as-code

---

## EXIT CHECKLIST

- [ ] Gateway deployed with health checks and monitoring
- [ ] Rate limiting configured per consumer tier
- [ ] Authentication enforced (JWT, OAuth2, or API key)
- [ ] CORS configured for allowed origins
- [ ] Request/response transformation removes sensitive headers
- [ ] API versioning strategy selected and routes configured
- [ ] Security headers added (HSTS, X-Content-Type-Options)
- [ ] Upstream health checks configured (active + passive)
- [ ] Logging and tracing enabled (correlation ID propagated)
- [ ] Error responses standardized across all endpoints
- [ ] Gateway configuration managed declaratively (version controlled)
- [ ] Load testing validates gateway throughput under expected load

---

*Skill Version: 1.0 | Created: March 2026*
