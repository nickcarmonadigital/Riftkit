---
name: "GraphQL Patterns"
description: "GraphQL API design, schema-first development, resolvers, federation, and performance optimization"
triggers:
  - "/graphql"
  - "/graphql-patterns"
  - "/schema-first"
---

# GraphQL Patterns

## WHEN TO USE
- Building a GraphQL API (Apollo, Mercurius, Strawberry, gqlgen)
- Migrating from REST to GraphQL
- Implementing GraphQL federation for microservices
- Optimizing N+1 query problems with DataLoader

## PROCESS

### 1. Schema-First Design
- Define your schema before writing resolvers
- Use SDL (Schema Definition Language) as the contract
- Validate schema changes with schema linting (graphql-eslint)

### 2. Resolver Implementation
- Keep resolvers thin — delegate to service layer
- Use DataLoader for batching to prevent N+1 queries
- Implement field-level authorization in resolvers
- Handle errors with union types (Result pattern) not exceptions

### 3. Performance
- Implement query complexity analysis and depth limiting
- Use persisted queries in production
- Add response caching (Apollo Cache, CDN with cache-control)
- Monitor with Apollo Studio or similar observability

### 4. Federation (Microservices)
- Use Apollo Federation or Schema Stitching
- Define entity types with @key directives
- Implement reference resolvers for cross-service joins
- Gateway handles routing, subgraphs own their data

### 5. Security
- Disable introspection in production
- Implement query depth limiting (max 10-15 levels)
- Add rate limiting per query complexity, not per request
- Validate input types strictly

## CHECKLIST
- [ ] Schema defined before implementation
- [ ] DataLoader used for all list relationships
- [ ] Query depth and complexity limits configured
- [ ] Introspection disabled in production
- [ ] Error handling uses union types
- [ ] N+1 queries verified absent with query logging

## Related Skills
- [`api_design`](../api_design/SKILL.md)
- [`api_contract_design`](../../2-design/api_contract_design/SKILL.md)
