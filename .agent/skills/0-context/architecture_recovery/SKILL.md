---
name: Architecture Recovery
description: Reverse-engineer architecture from code when no documentation exists, generating ADRs, component diagrams, and dependency graphs.
---

# Architecture Recovery

## TRIGGER COMMANDS
- "Reverse-engineer this architecture"
- "There are no architecture docs"
- "Map the system architecture"
- "Generate architecture diagrams from code"
- "What does this system look like?"
- "Recover the architecture"

## When to Use
Use this skill when you inherit a codebase with no architecture documentation, when existing docs are severely outdated, or when you need to understand how a complex system is structured before making significant changes. This is the starting point for any project where the architecture exists only in code and in the heads of developers who may no longer be available.

## The Process

### 1. Entry Point Discovery
- Find `main()`, `app.bootstrap()`, `index.ts`, `server.py`, route definitions, or equivalent entry points
- Identify the application framework (Express, NestJS, Django, Spring, etc.)
- Trace the startup sequence: what gets initialized, in what order, with what configuration
- Document environment variables and configuration files that affect behavior
- Map CLI entry points, cron jobs, and background workers in addition to the main server

### 2. Dependency Graph Generation
- Trace imports/requires across all modules to build a full dependency tree
- Map inter-module dependencies: which modules depend on which
- Identify circular dependencies and tightly coupled clusters
- Distinguish between runtime dependencies and build/dev dependencies
- Catalog shared utilities, common libraries, and cross-cutting concerns
- Produce a module-level dependency graph (not file-level -- that's too noisy)

### 3. Layer Identification
- Identify the architectural layers: presentation, business logic, data access, infrastructure
- Determine the primary architectural pattern: MVC, hexagonal, event-driven, microservices, monolith, modular monolith
- Check for layer violations (e.g., controllers directly accessing the database, business logic in templates)
- Document middleware pipelines, interceptors, guards, and filters
- Identify cross-cutting concerns: logging, auth, validation, error handling

### 4. Data Flow Mapping
- Trace representative requests end-to-end: HTTP request -> middleware -> controller -> service -> repository -> database -> response
- Map async flows: event emission -> handler -> side effects
- Document data transformation points (DTOs, serializers, mappers)
- Identify where validation happens at each layer
- Map error propagation paths: where errors originate, how they bubble up, where they're caught

### 5. External Integration Inventory
- Catalog all third-party API integrations (REST, GraphQL, gRPC, SOAP)
- Document message queues and event buses (Kafka, RabbitMQ, SQS, Redis pub/sub)
- List all caching layers (Redis, Memcached, in-memory, CDN)
- Map database connections (primary, read replicas, analytics DBs)
- Identify file storage integrations (S3, GCS, local filesystem)
- Document authentication providers (OAuth, SAML, LDAP)

### 6. Boundary Analysis
- Identify bounded contexts and their relationships
- Measure module coupling: how many modules depend on each module
- Calculate module cohesion: does each module have a single responsibility
- Find service boundaries (or where they should be if the system were split)
- Document shared state and shared databases between modules
- Identify anti-patterns: god modules, anemic domain models, distributed monolith symptoms

### 7. Architecture Decision Records
- For each significant architectural choice discovered, generate an ADR:
  - **Title**: Short description of the decision
  - **Status**: Discovered (inferred from code)
  - **Context**: What problem was being solved
  - **Decision**: What was chosen and how it's implemented
  - **Consequences**: What trade-offs resulted (positive and negative)
- Prioritize ADRs for decisions that would surprise a new developer
- Use git blame and PR history to find the "when" and "who" for each decision

### 8. Diagram Generation
- **Component Diagram**: High-level boxes showing major modules/services and their relationships
- **Sequence Diagrams**: For 3-5 critical flows (auth, main business operation, data ingestion, error handling)
- **Deployment Diagram**: How components map to infrastructure (servers, containers, cloud services)
- Use Mermaid syntax for all diagrams so they render in markdown
- Keep diagrams at the right level of abstraction (too detailed = useless, too abstract = useless)

## Checklist
- [ ] All entry points identified and documented
- [ ] Module dependency graph generated with no unknown dependencies
- [ ] Architectural layers identified and layer violations noted
- [ ] At least 3 critical data flows traced end-to-end
- [ ] All external integrations cataloged with connection details
- [ ] Bounded contexts and module boundaries mapped
- [ ] ADRs generated for at least 5 significant architectural decisions
- [ ] Mermaid diagrams produced for component, sequence, and deployment views
- [ ] Architecture summary document is understandable by a new team member
- [ ] Known gaps and areas needing further investigation are explicitly called out
