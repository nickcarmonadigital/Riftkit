---
name: System Design Review
description: Evaluate scalability, fault tolerance, data consistency, and service boundaries of an existing system.
---

# System Design Review

## TRIGGER COMMANDS
- "Review the system design"
- "Can this system scale"
- "Find single points of failure"
- "Evaluate the architecture"
- "Is this system resilient"
- "What are the architectural bottlenecks"
- "Stress test the design"

## When to Use
Use this skill when preparing a system for significant traffic growth, when recurring production issues suggest architectural problems, or when evaluating whether an existing system can support new business requirements. This is a design-level review -- it examines the architecture and its properties rather than individual code quality. It is most valuable before committing to expensive infrastructure changes or scaling efforts.

## The Process

### 1. Scalability Assessment
- Identify the current bottleneck: what component would fail first under 10x load?
- Analyze each tier independently: web servers, application servers, databases, caches, queues
- Check for horizontal scalability: can you add more instances of each component?
- Identify stateful components that resist horizontal scaling (sticky sessions, local file storage, in-memory state)
- Review database scaling strategy: read replicas, sharding, connection pooling, query optimization
- Check for N+1 query patterns, unbounded result sets, and missing pagination
- Assess whether the current architecture supports auto-scaling or requires manual intervention
- Document the theoretical maximum throughput and the observed current utilization

### 2. Fault Tolerance Analysis
- Identify all single points of failure (SPOFs): components where one failure takes down the system
- For each SPOF, determine: is there redundancy? What is the failover mechanism? Is failover automatic or manual?
- Check for graceful degradation: when a non-critical service fails, does the system continue with reduced functionality or crash entirely?
- Review circuit breaker patterns: are they implemented for external service calls? Are thresholds appropriate?
- Assess timeout configurations: are all external calls wrapped with timeouts? Are timeouts tuned appropriately?
- Check retry logic: is it implemented with exponential backoff and jitter? Is there a maximum retry limit?
- Review health check endpoints: do they verify actual functionality (deep checks) or just that the process is running (shallow checks)?
- Assess the system's behavior under partial network failures (split-brain scenarios)

### 3. Data Consistency Model
- Determine the consistency model: strong consistency, eventual consistency, or a mix
- Identify where eventual consistency is used and verify that the business logic tolerates it
- Check for race conditions: concurrent writes to the same data, read-modify-write patterns without locking
- Review transaction boundaries: are multi-step operations wrapped in transactions where needed?
- Identify distributed transaction patterns (saga, two-phase commit) and assess their failure handling
- Check for data conflicts: what happens when two users edit the same entity simultaneously?
- Review cache invalidation strategy: how long can stale data persist? What are the consequences?
- Assess data integrity checks: foreign key constraints, unique constraints, application-level validations

### 4. Service Boundary Review
- Map the current service boundaries and the business domains they represent
- Check for domain alignment: does each service own a coherent business capability?
- Identify inappropriate coupling: services that share databases, services that call each other synchronously in chains
- Look for distributed monolith symptoms: deploying one service requires deploying others, shared data models across services
- Check for chatty communication: services making many small calls to each other instead of fewer, larger ones
- Assess whether shared libraries create hidden coupling between services
- Review event-driven boundaries: are events used for loose coupling? Are event schemas versioned?
- Evaluate whether current boundaries would support independent team ownership

### 5. API Contract Analysis
- Check if APIs are versioned and what the versioning strategy is (URL path, header, query param)
- Review backward compatibility: can old clients work with the new API? Are breaking changes managed?
- Assess API documentation: is it generated from code (OpenAPI/Swagger), manually maintained, or absent?
- Check for consistent error response formats across all endpoints
- Review pagination, filtering, and sorting patterns for consistency
- Assess rate limiting and throttling: are they implemented? Are limits documented?
- Check for API idempotency: are mutation operations safe to retry?
- Review authentication and authorization patterns across API boundaries

### 6. State Management Audit
- Catalog where state lives: primary database, cache layers, session stores, local filesystem, in-memory
- For each state location, determine: what happens when it is lost? How is it restored?
- Check session management: are sessions stored in a shared store (Redis) or locally? What happens on server restart?
- Review cache strategy: cache-aside, write-through, write-behind? What is the eviction policy?
- Identify ephemeral state that is treated as durable (and vice versa)
- Check for state that should be externalized: configuration in code, secrets in environment variables vs vault
- Assess warm-up time: how long does a new instance take to become fully operational?

### 7. Performance Characteristics
- Document latency profiles: p50, p95, p99 for critical endpoints
- Identify latency outliers and their root causes (slow queries, external calls, garbage collection)
- Measure throughput limits: requests per second at current capacity
- Profile resource utilization: CPU, memory, disk I/O, network I/O under normal and peak load
- Identify hot spots: specific endpoints or operations that consume disproportionate resources
- Check for resource leaks: memory leaks, connection pool exhaustion, file descriptor leaks
- Review background job processing: are jobs prioritized? What happens when the queue backs up?
- Assess cold start performance for serverless functions or lazy-loaded components

### 8. Recommendations
- Produce a prioritized list of architectural improvements, scored by:
  - **Impact**: How much does this improve scalability, reliability, or performance? (1-5)
  - **Effort**: How much work is required? (S/M/L/XL)
  - **Risk**: How risky is the change itself? (Low/Medium/High)
  - **Urgency**: Is this needed now or can it wait? (Immediate/Next Quarter/Someday)
- Group recommendations into themes: scalability improvements, reliability improvements, performance improvements, simplification
- For each recommendation, provide:
  - The specific problem it addresses
  - The proposed solution with enough detail to estimate
  - The expected outcome and how to measure success
  - Dependencies on other recommendations
- Identify quick wins (high impact, low effort) separately from strategic initiatives

## Checklist
- [ ] Scalability bottleneck identified with theoretical maximum throughput documented
- [ ] All single points of failure cataloged with failover mechanisms (or lack thereof) noted
- [ ] Data consistency model documented with race conditions and conflict handling assessed
- [ ] Service boundaries reviewed for domain alignment and inappropriate coupling
- [ ] API contracts checked for versioning, backward compatibility, and consistency
- [ ] All state locations cataloged with loss/recovery scenarios documented
- [ ] Performance characteristics measured with p50/p95/p99 latencies for critical paths
- [ ] Prioritized recommendation list produced with impact/effort/risk scoring
- [ ] Quick wins identified separately from strategic initiatives
- [ ] Review findings are actionable and understandable by the engineering team
