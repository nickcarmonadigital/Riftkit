---
name: API Contract Design
description: Contract-first API design producing OpenAPI 3.0 specs before implementation with versioning and breaking-change policy
---

# API Contract Design Skill

**Purpose**: Produces an OpenAPI 3.0 specification as a design artifact before any implementation begins. The spec becomes the authoritative contract between frontend and backend (or between services), validated in CI, and governs how the API evolves without breaking consumers.

## TRIGGER COMMANDS

```text
"Define API contract for [service]"
"Contract-first API design"
"Design API spec before implementation"
```

## When to Use
- Before implementing any new API endpoints
- When multiple teams or services will consume the same API
- When frontend and backend are developed in parallel
- Before integrating with external partners or third-party systems

---

## PROCESS

### Step 1: Identify Consumers and Operations

Before writing schemas, enumerate WHO calls the API and WHAT they need:

```markdown
## Consumer Map

| Consumer | Operations Needed | Auth Method |
|----------|-------------------|-------------|
| Web Frontend | CRUD on resources, search, bulk ops | JWT Bearer |
| Mobile App | Read resources, push token registration | JWT Bearer |
| Partner Webhook | Event notifications | API Key + HMAC |
| Internal Worker | Batch processing, status updates | Service Token |
```

### Step 2: Define Resource Schemas

Design the core data shapes using JSON Schema within OpenAPI:

```yaml
components:
  schemas:
    Resource:
      type: object
      required: [id, name, createdAt]
      properties:
        id:
          type: string
          format: uuid
        name:
          type: string
          maxLength: 255
        status:
          type: string
          enum: [draft, active, archived]
        createdAt:
          type: string
          format: date-time

    ResourceCreate:
      type: object
      required: [name]
      properties:
        name:
          type: string
          maxLength: 255

    ErrorResponse:
      type: object
      required: [success, error]
      properties:
        success:
          type: boolean
          example: false
        error:
          type: string
        code:
          type: string
          description: Machine-readable error code
```

### Step 3: Define the Error Contract

Standardize error responses across all endpoints:

| HTTP Status | When to Use | Error Code Pattern |
|-------------|-------------|-------------------|
| 400 | Validation failure | `VALIDATION_ERROR` |
| 401 | Missing or invalid auth | `UNAUTHORIZED` |
| 403 | Valid auth, insufficient permissions | `FORBIDDEN` |
| 404 | Resource not found | `NOT_FOUND` |
| 409 | Conflict (duplicate, state violation) | `CONFLICT` |
| 422 | Business rule violation | `UNPROCESSABLE` |
| 429 | Rate limit exceeded | `RATE_LIMITED` |
| 500 | Unexpected server error | `INTERNAL_ERROR` |

### Step 4: Specify Auth and Authz Per Endpoint

Document authorization requirements at the endpoint level:

```yaml
paths:
  /api/v1/resources:
    get:
      security:
        - bearerAuth: []
      x-authz: "authenticated user, returns only owned resources"
    post:
      security:
        - bearerAuth: []
      x-authz: "authenticated user with 'resource:create' permission"
  /api/v1/resources/{id}:
    delete:
      security:
        - bearerAuth: []
      x-authz: "resource owner OR admin role"
```

### Step 5: Define Versioning and Breaking-Change Policy

```markdown
## Versioning Strategy
- **Method**: URL path prefix (`/api/v1/`, `/api/v2/`)
- **Supported versions**: Current (N) and previous (N-1)
- **Deprecation notice**: Minimum 90 days via `Sunset` header (RFC 8594)

## Breaking Change Definition
A change is BREAKING if it:
- Removes or renames a field from a response
- Adds a new required field to a request
- Changes a field type
- Removes an endpoint
- Changes authentication requirements

A change is NON-BREAKING if it:
- Adds an optional field to a request
- Adds a field to a response
- Adds a new endpoint
- Adds a new enum value (if consumers handle unknown values)
```

### Step 6: CI Validation Setup

Specify how the contract will be enforced:

- **Spectral**: Lint the OpenAPI spec for style and completeness
- **Prism**: Mock server for frontend development against the spec
- **Dredd/Schemathesis**: Contract testing against the live implementation

---

## OUTPUT

**Spec**: `.agent/docs/2-design/api-contract.yaml` (OpenAPI 3.0)
**Policy**: `.agent/docs/2-design/api-versioning-policy.md`

---

## CHECKLIST

- [ ] All consumers identified with their required operations
- [ ] Request and response schemas defined for every endpoint
- [ ] Error contract standardized across all endpoints
- [ ] Auth requirements documented per endpoint
- [ ] Versioning strategy chosen and documented
- [ ] Breaking vs non-breaking change policy defined
- [ ] Pagination strategy specified (cursor vs offset)
- [ ] Rate limiting documented per consumer tier
- [ ] CI validation tool selected (Spectral, Dredd, or equivalent)
- [ ] OpenAPI spec passes linting without errors

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
