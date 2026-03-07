# Blueprint: Microservices

A microservices architecture where the system is composed of independently deployable services communicating over network boundaries. This blueprint covers service decomposition, communication patterns, observability, and operational concerns.

## Recommended Tech Stacks

| Stack | Language | Best For |
|-------|----------|----------|
| NestJS Microservices | TypeScript | Teams standardizing on TS, built-in transport layer |
| Go (stdlib / chi) | Go | High-performance services, low resource usage |
| Spring Boot / Spring Cloud | Java/Kotlin | Enterprise, mature ecosystem, service mesh support |
| FastAPI | Python | Data/ML services, async, auto-docs |
| Mixed (polyglot) | Multiple | Best tool per service, team autonomy |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define bounded contexts and service boundaries
- **prd_generator** -- Document service responsibilities and SLAs
- **prioritization_frameworks** -- Decide which services to build first

### Phase 2: Architecture
- **api_design** -- Inter-service contracts (REST, gRPC, events)
- **schema_design** -- Database-per-service, no shared databases
- **caching_strategy** -- Service-local caches, distributed cache for shared data
- **auth_architecture** -- Service-to-service auth (mTLS, JWT propagation)

### Phase 3: Implementation
- **tdd_workflow** -- Unit + contract tests per service
- **code_review** -- Review API contracts and backward compatibility
- **error_handling** -- Circuit breakers, retries, fallbacks

### Phase 4: Testing and Security
- **integration_testing** -- Consumer-driven contract tests (Pact)
- **security_audit** -- Network policies, service mesh security
- **load_testing** -- Per-service and end-to-end load testing
- **api_security_testing** -- Auth between services, input validation

### Phase 5: Deployment
- **ci_cd_pipeline** -- Independent pipelines per service
- **infrastructure_as_code** -- Kubernetes manifests, Helm charts
- **deployment_patterns** -- Independent deploys, canary per service
- **db_migrations** -- Per-service migration strategy

### Phase 6-7: Release and Operations
- **monitoring_setup** -- Distributed tracing (Jaeger/Zipkin), per-service dashboards
- **incident_response** -- Service dependency maps, cascade failure runbooks

## Key Domain-Specific Concerns

### Service Decomposition

Decompose by business capability, not by technical layer:

| Good (Business Boundary) | Bad (Technical Layer) |
|---------------------------|-----------------------|
| Order Service | API Service |
| Payment Service | Database Service |
| Notification Service | Auth Service (if it does too much) |
| Inventory Service | Frontend Service |

Rules of thumb:
- Each service owns its data (no shared databases)
- A service should be deployable independently
- Team size: one service per 2-4 engineers
- If two services always deploy together, merge them

### Communication Patterns

| Pattern | When to Use | Technology |
|---------|-------------|------------|
| Synchronous (Request/Reply) | Need immediate response | REST, gRPC |
| Asynchronous (Events) | Fire-and-forget, eventual consistency OK | Kafka, RabbitMQ, NATS |
| Saga | Multi-service transactions | Choreography or Orchestration |
| CQRS | Read/write have different scale needs | Separate read/write models |

### API Gateway

The gateway is the single entry point for external clients:
- Route requests to appropriate services
- Handle authentication and rate limiting
- Aggregate responses from multiple services
- Protocol translation (HTTP to gRPC)
- Options: Kong, NGINX, AWS API Gateway, custom NestJS gateway

### Service Discovery

| Method | Complexity | Best For |
|--------|------------|----------|
| Kubernetes DNS | Low | K8s-native services |
| Consul | Medium | Multi-platform, health-aware |
| Eureka | Medium | Spring Cloud ecosystem |
| Static config | Lowest | Small number of services |

### Distributed Tracing

Every request that crosses service boundaries must carry a trace:
- Propagate `trace-id` and `span-id` headers across all calls
- Use OpenTelemetry for instrumentation (vendor-neutral)
- Visualize with Jaeger, Zipkin, or cloud provider tools
- Include trace ID in all log entries for correlation

### Data Consistency

Microservices sacrifice strong consistency for autonomy:
- **Eventual consistency** is the default -- design for it
- **Saga pattern** for multi-service transactions (compensating actions on failure)
- **Outbox pattern** to reliably publish events with database changes
- **Idempotency** on all event consumers (events may be delivered more than once)

### Failure Handling

| Pattern | Purpose | Library |
|---------|---------|---------|
| Circuit Breaker | Stop cascading failures | opossum, resilience4j, gobreaker |
| Retry with backoff | Handle transient failures | Built-in or polly |
| Timeout | Prevent hanging requests | HTTP client config |
| Bulkhead | Isolate failure domains | Thread pool / connection pool limits |
| Fallback | Degrade gracefully | Application logic |

### Observability Stack

| Pillar | Tool | Purpose |
|--------|------|---------|
| Metrics | Prometheus + Grafana | Latency, error rate, throughput per service |
| Logging | ELK or Loki | Centralized, structured, correlated by trace ID |
| Tracing | Jaeger / Zipkin | Request flow across services |
| Alerting | Alertmanager / PagerDuty | SLO-based alerts per service |

## Getting Started

1. **Identify bounded contexts** -- Map business domains, find natural service boundaries
2. **Start with a monolith** -- Build modular monolith first if domain is unclear
3. **Extract first service** -- Pick the most independent module to extract
4. **Set up API gateway** -- Single entry point for external traffic
5. **Add event bus** -- RabbitMQ or Kafka for async communication
6. **Implement service template** -- Standardize logging, health checks, metrics, tracing
7. **Write contract tests** -- Consumer-driven contracts between services
8. **Set up CI/CD per service** -- Independent build/test/deploy pipelines
9. **Deploy to Kubernetes** -- Helm charts or Kustomize per service
10. **Build observability** -- Tracing, centralized logging, per-service dashboards

## Project Structure (Monorepo Example)

```
services/
  api-gateway/
    src/
    Dockerfile
    k8s/
  order-service/
    src/
    prisma/                # Own database schema
    Dockerfile
    k8s/
  payment-service/
    src/
    prisma/
    Dockerfile
    k8s/
  notification-service/
    src/
    Dockerfile
    k8s/
shared/
  contracts/               # Shared API types / protobuf definitions
  events/                  # Event schemas (Avro / JSON Schema)
  service-template/        # Base Dockerfile, health check, logging config
infra/
  docker-compose.yml       # Local development
  helm/                    # Kubernetes Helm charts
  terraform/               # Cloud infrastructure
```
