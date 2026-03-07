# Blueprint: API Service

A REST or GraphQL API service -- the backend workhorse of most applications. This blueprint covers design, implementation, and production hardening of API services regardless of framework.

## Recommended Tech Stacks

| Stack | Language | Best For |
|-------|----------|----------|
| NestJS | TypeScript | Enterprise APIs, teams familiar with Angular patterns |
| Django REST Framework | Python | Rapid prototyping, data-heavy APIs, admin panel needed |
| Spring Boot | Java/Kotlin | Enterprise, JVM ecosystem, strong typing |
| Go (net/http + chi/gin) | Go | High-performance, low-latency, microservices |
| FastAPI | Python | Modern Python APIs, async, auto-generated docs |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define API purpose, consumers, and data model
- **prd_generator** -- Document endpoints, auth requirements, rate limits
- **competitive_analysis** -- Research existing APIs in the space
- **prioritization_frameworks** -- RICE-score endpoint groups for MVP scoping

### Phase 2: Architecture
- **api_design** -- RESTful conventions, resource naming, versioning strategy
- **schema_design** -- Database schema, relationships, indexes
- **auth_architecture** -- JWT vs session, OAuth2, API key management
- **caching_strategy** -- Redis, CDN, HTTP cache headers

### Phase 3: Implementation
- **tdd_workflow** -- Test-first development for each endpoint
- **error_handling** -- Consistent error response format (RFC 7807)
- **validation_patterns** -- Input validation with Zod, class-validator, or Pydantic
- **pagination** -- Cursor-based vs offset pagination
- **code_review** -- Review each module before moving on

### Phase 4: Testing and Security
- **api_security_testing** -- Auth bypass, injection, rate limit testing
- **integration_testing** -- End-to-end request/response validation
- **load_testing** -- k6 or Artillery for performance baselines
- **security_audit** -- OWASP API Top 10 review

### Phase 5: Deployment
- **ci_cd_pipeline** -- Build, test, deploy automation
- **deployment_patterns** -- Rolling deploy with health checks
- **infrastructure_as_code** -- Container orchestration, load balancer config
- **db_migrations** -- Safe migration workflow

### Phase 6-7: Release and Operations
- **monitoring_setup** -- Latency, error rate, throughput dashboards
- **incident_response** -- Runbook for common failure modes
- **api_versioning** -- Breaking change management, deprecation policy

## Key Domain-Specific Concerns

### Authentication and Authorization
- Choose a strategy early: JWT (stateless) vs sessions (stateful)
- Implement RBAC or ABAC for endpoint-level authorization
- Use refresh token rotation for long-lived sessions
- Never store secrets in code -- use environment variables or vault

### Rate Limiting
- Apply per-user and per-IP limits
- Use sliding window or token bucket algorithm
- Return `429 Too Many Requests` with `Retry-After` header
- Consider tiered limits for free vs paid consumers

### API Versioning
- URL-based (`/v1/resource`) is simplest and most visible
- Header-based (`Accept: application/vnd.api.v2+json`) for cleaner URLs
- Never break existing versions -- deprecate with timeline

### Documentation
- OpenAPI/Swagger spec as source of truth
- Auto-generate from code where possible (NestJS Swagger, FastAPI)
- Include example requests and responses for every endpoint
- Document error codes and their meanings

### Error Handling
- Use consistent error envelope: `{ error: { code, message, details } }`
- Map internal errors to appropriate HTTP status codes
- Never expose stack traces or internal details in production
- Log full context server-side, return safe messages client-side

## Getting Started

1. **Define your data model** -- List entities, relationships, and key fields
2. **Sketch your endpoints** -- Map CRUD operations to REST resources
3. **Choose auth strategy** -- JWT for stateless APIs, sessions for server-rendered
4. **Set up project scaffolding** -- Use framework CLI (`nest new`, `django-admin startproject`)
5. **Create database schema** -- Write migration for core entities
6. **Implement auth first** -- Register, login, token refresh, guards/middleware
7. **Build endpoints TDD** -- Write test, implement handler, validate
8. **Add middleware** -- Rate limiting, CORS, request logging, validation pipes
9. **Generate API docs** -- Swagger/OpenAPI from code annotations
10. **Deploy to staging** -- CI pipeline, Docker build, health check endpoint

## Project Structure (NestJS Example)

```
src/
  app.module.ts
  main.ts
  common/
    filters/          # Exception filters
    guards/           # Auth guards
    interceptors/     # Logging, transform
    pipes/            # Validation
  modules/
    auth/
    users/
    [resource]/
      [resource].module.ts
      [resource].controller.ts
      [resource].service.ts
      [resource].dto.ts
      [resource].spec.ts
  prisma/
    schema.prisma
    migrations/
```
