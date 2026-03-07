---
name: Internal Developer Portal
description: Building internal developer portals with Backstage, service catalogs, templates, TechDocs, scorecards, and golden paths
---

# Internal Developer Portal Skill

**Purpose**: Guide teams in building internal developer portals using Backstage or similar platforms, including service catalogs, software templates, TechDocs integration, maturity scorecards, and self-service golden paths.

---

## TRIGGER COMMANDS

```text
"Set up Backstage for our organization"
"Build a service catalog"
"Create software templates for our IDP"
"Implement engineering scorecards"
"Using internal_developer_portal skill: [task]"
```

---

## IDP Platform Comparison

| Feature | Backstage | Port | Cortex | OpsLevel | Rely.io |
|---------|-----------|------|--------|----------|---------|
| Open source | Yes (CNCF) | No | No | No | No |
| Self-hosted | Yes | Cloud | Cloud | Cloud | Cloud |
| Service catalog | Yes | Yes | Yes | Yes | Yes |
| Templates | Yes (scaffolder) | Blueprints | Limited | Limited | Limited |
| TechDocs | Yes (built-in) | No | No | No | No |
| Plugins | 200+ community | Integrations | Integrations | Integrations | Integrations |
| Kubernetes | Yes (plugin) | Yes | Yes | Yes | Yes |
| Scorecards | Plugin | Yes | Yes (core) | Yes (core) | Yes |
| Setup effort | High | Low | Low | Low | Low |
| Customization | Unlimited | Moderate | Low | Low | Low |
| Cost | Free + hosting | $$$ | $$$ | $$$ | $$ |
| Best for | Large orgs | Mid-size | Reliability focus | Ops focus | Small-mid |

---

## Backstage Setup

### Project Initialization

```bash
# Create new Backstage app
npx @backstage/create-app@latest

# Start development
cd my-backstage-app
yarn dev
```

### Architecture

```
+----------------------------------------------------+
|                    BACKSTAGE APP                    |
+----------------------------------------------------+
|  Frontend (React SPA)                              |
|    ├── Service Catalog                             |
|    ├── Software Templates (Scaffolder)             |
|    ├── TechDocs                                    |
|    ├── Search                                      |
|    └── Custom Plugins                              |
+----------------------------------------------------+
|  Backend (Node.js)                                 |
|    ├── Catalog Backend                             |
|    ├── Auth (GitHub, Google, Okta, etc.)           |
|    ├── Scaffolder Backend                          |
|    ├── TechDocs Backend                            |
|    ├── Proxy                                       |
|    └── Custom Plugin Backends                      |
+----------------------------------------------------+
|  Database (PostgreSQL)                             |
+----------------------------------------------------+
|  External Integrations                             |
|    GitHub, GitLab, K8s, PagerDuty, Datadog, etc.  |
+----------------------------------------------------+
```

---

## Service Catalog

### Catalog Entity (catalog-info.yaml)

Every service, library, and system gets a `catalog-info.yaml` in its repo root.

```yaml
# catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: payment-service
  description: Handles payment processing via Stripe
  tags:
    - typescript
    - nestjs
    - payments
  annotations:
    github.com/project-slug: my-org/payment-service
    backstage.io/techdocs-ref: dir:.
    pagerduty.com/service-id: PXXXXXX
    datadoghq.com/slo_tag: service:payment-service
    sonarqube.org/project-key: my-org_payment-service
  links:
    - url: https://grafana.internal/d/payments
      title: Grafana Dashboard
      icon: dashboard
    - url: https://runbooks.internal/payments
      title: Runbook
      icon: docs
spec:
  type: service
  lifecycle: production
  owner: team-payments
  system: commerce-platform
  dependsOn:
    - component:user-service
    - resource:payments-db
    - resource:stripe-api
  providesApis:
    - payments-api
  consumesApis:
    - user-api
    - notification-api
```

### System and Domain Modeling

```yaml
# system.yaml
apiVersion: backstage.io/v1alpha1
kind: System
metadata:
  name: commerce-platform
  description: End-to-end commerce platform
spec:
  owner: group:commerce-team
  domain: commerce

---
apiVersion: backstage.io/v1alpha1
kind: Domain
metadata:
  name: commerce
  description: All commerce-related systems
spec:
  owner: group:commerce-team
```

### Entity Hierarchy

```
Domain: Commerce
  └── System: Commerce Platform
       ├── Component: Payment Service (service)
       │    ├── Provides: Payments API
       │    ├── Depends on: User Service
       │    └── Resource: payments-db
       ├── Component: Cart Service (service)
       ├── Component: Product Service (service)
       ├── Component: Storefront (website)
       └── Resource: commerce-db (database)
```

### API Definition

```yaml
# api.yaml
apiVersion: backstage.io/v1alpha1
kind: API
metadata:
  name: payments-api
  description: Payment processing API
spec:
  type: openapi
  lifecycle: production
  owner: team-payments
  system: commerce-platform
  definition:
    $text: ./openapi.yaml
```

---

## Software Templates (Scaffolder)

### Template Definition

```yaml
# templates/microservice/template.yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: microservice-template
  title: Create a Microservice
  description: Scaffold a new microservice with CI/CD, monitoring, and docs
  tags:
    - recommended
    - typescript
    - microservice
spec:
  owner: platform-team
  type: service

  parameters:
    - title: Service Information
      required: [name, description, owner]
      properties:
        name:
          title: Service Name
          type: string
          description: Unique name for the service (lowercase, hyphens)
          pattern: '^[a-z][a-z0-9-]*$'
          ui:autofocus: true
        description:
          title: Description
          type: string
          description: Brief description of what this service does
        owner:
          title: Owner Team
          type: string
          description: Team that owns this service
          ui:field: OwnerPicker
          ui:options:
            catalogFilter:
              kind: Group

    - title: Technical Options
      properties:
        database:
          title: Database
          type: string
          default: postgres
          enum: [postgres, mysql, none]
          enumNames: [PostgreSQL, MySQL, None]
        messaging:
          title: Message Queue
          type: string
          default: none
          enum: [kafka, rabbitmq, sqs, none]
          enumNames: [Kafka, RabbitMQ, SQS, None]
        port:
          title: Service Port
          type: number
          default: 3000

    - title: Repository Settings
      required: [repoUrl]
      properties:
        repoUrl:
          title: Repository Location
          type: string
          ui:field: RepoUrlPicker
          ui:options:
            allowedHosts: ['github.com']
            allowedOwners: ['my-org']

  steps:
    - id: fetch
      name: Fetch Template
      action: fetch:template
      input:
        url: ./skeleton
        values:
          name: ${{ parameters.name }}
          description: ${{ parameters.description }}
          owner: ${{ parameters.owner }}
          database: ${{ parameters.database }}
          messaging: ${{ parameters.messaging }}
          port: ${{ parameters.port }}

    - id: publish
      name: Publish to GitHub
      action: publish:github
      input:
        allowedHosts: ['github.com']
        repoUrl: ${{ parameters.repoUrl }}
        description: ${{ parameters.description }}
        defaultBranch: main
        protectDefaultBranch: true
        repoVisibility: internal

    - id: register
      name: Register in Catalog
      action: catalog:register
      input:
        repoContentsUrl: ${{ steps.publish.output.repoContentsUrl }}
        catalogInfoPath: /catalog-info.yaml

  output:
    links:
      - title: Repository
        url: ${{ steps.publish.output.remoteUrl }}
      - title: Service in Catalog
        icon: catalog
        entityRef: ${{ steps.register.output.entityRef }}
```

### Template Skeleton

```
templates/microservice/skeleton/
  catalog-info.yaml
  package.json
  tsconfig.json
  Dockerfile
  docker-compose.yml
  .github/
    workflows/
      ci.yml
      deploy.yml
  src/
    index.ts
    server.ts
    health.ts
  docs/
    index.md
  mkdocs.yml
```

```yaml
# templates/microservice/skeleton/catalog-info.yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: ${{ values.name }}
  description: ${{ values.description }}
  annotations:
    github.com/project-slug: my-org/${{ values.name }}
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: experimental
  owner: ${{ values.owner }}
```

---

## TechDocs

### Setup

```yaml
# mkdocs.yml (in each service repo)
site_name: Payment Service
nav:
  - Overview: index.md
  - Architecture: architecture.md
  - API: api.md
  - Runbook: runbook.md
  - ADRs:
    - ADR-001 Use Stripe: adrs/001-use-stripe.md
    - ADR-002 Event Sourcing: adrs/002-event-sourcing.md

plugins:
  - techdocs-core
```

### Backstage TechDocs Config

```yaml
# app-config.yaml (Backstage)
techdocs:
  builder: 'external'  # Use CI to build, not Backstage
  generator:
    runIn: 'local'
  publisher:
    type: 'awsS3'
    awsS3:
      bucketName: 'my-techdocs-bucket'
      region: 'us-east-1'
```

---

## Engineering Scorecards

### Maturity Model

| Category | Bronze | Silver | Gold | Platinum |
|----------|--------|--------|------|----------|
| Documentation | README exists | TechDocs published | ADRs, runbooks | Tutorials, diagrams |
| Testing | Unit tests exist | >70% coverage | >85% + integration | >90% + E2E + perf |
| Security | No critical vulns | SAST in CI | DAST + secrets scan | Pen tested |
| Observability | Health endpoint | Metrics + logs | Distributed tracing | SLOs defined |
| Reliability | Deploys to prod | Rollback capability | Canary deploys | Chaos tested |
| Ownership | Owner defined | On-call rotation | Runbook exists | <15min MTTD |

### Scorecard Implementation

```yaml
# scorecard-rules.yaml
rules:
  - name: has-owner
    description: Service has a defined owner team
    category: Ownership
    level: bronze
    filter:
      kind: Component
      spec.type: service
    check:
      metadata.spec.owner:
        exists: true

  - name: has-techdocs
    description: TechDocs are published
    category: Documentation
    level: silver
    check:
      metadata.annotations:
        contains_key: backstage.io/techdocs-ref

  - name: has-pagerduty
    description: PagerDuty integration configured
    category: Ownership
    level: silver
    check:
      metadata.annotations:
        contains_key: pagerduty.com/service-id

  - name: has-slo
    description: SLO is defined and tracked
    category: Reliability
    level: gold
    check:
      metadata.annotations:
        contains_key: datadoghq.com/slo_tag
```

---

## Backstage Plugins (Essential)

| Plugin | Purpose | Category |
|--------|---------|----------|
| @backstage/plugin-catalog | Service catalog | Core |
| @backstage/plugin-scaffolder | Software templates | Core |
| @backstage/plugin-techdocs | Documentation | Core |
| @backstage/plugin-search | Search across all content | Core |
| @backstage/plugin-kubernetes | K8s cluster visibility | Infra |
| @backstage/plugin-github-actions | CI/CD visibility | DevOps |
| @pagerduty/backstage-plugin | On-call & incidents | Ops |
| @backstage/plugin-cost-insights | Cloud cost tracking | FinOps |
| @roadiehq/backstage-plugin-datadog | Monitoring dashboards | Observability |
| @backstage/plugin-sonarqube | Code quality | Quality |

### Installing a Plugin

```bash
# Frontend plugin
yarn --cwd packages/app add @backstage/plugin-kubernetes

# Backend plugin
yarn --cwd packages/backend add @backstage/plugin-kubernetes-backend
```

```typescript
// packages/app/src/App.tsx
import { KubernetesPage } from '@backstage/plugin-kubernetes';

// Add to routes
<Route path="/kubernetes" element={<KubernetesPage />} />
```

---

## Search Configuration

```typescript
// packages/backend/src/plugins/search.ts
import { DefaultCatalogCollatorFactory } from '@backstage/plugin-search-backend-module-catalog';
import { DefaultTechDocsCollatorFactory } from '@backstage/plugin-search-backend-module-techdocs';

export default async function createPlugin(env: PluginEnvironment) {
  const indexBuilder = new IndexBuilder({ logger: env.logger, searchEngine });

  indexBuilder.addCollator({
    schedule: env.scheduler.createScheduledTaskRunner({
      frequency: { minutes: 10 },
      timeout: { minutes: 15 },
    }),
    factory: DefaultCatalogCollatorFactory.fromConfig(env.config, {
      discovery: env.discovery,
      tokenManager: env.tokenManager,
    }),
  });

  indexBuilder.addCollator({
    schedule: env.scheduler.createScheduledTaskRunner({
      frequency: { minutes: 10 },
      timeout: { minutes: 15 },
    }),
    factory: DefaultTechDocsCollatorFactory.fromConfig(env.config, {
      discovery: env.discovery,
      tokenManager: env.tokenManager,
    }),
  });

  const { scheduler } = await indexBuilder.build();
  scheduler.start();
}
```

---

## Deployment

### Docker Deployment

```dockerfile
# Dockerfile (multi-stage)
FROM node:20-bookworm-slim AS build
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn tsc
RUN yarn build:backend --config app-config.yaml

FROM node:20-bookworm-slim
WORKDIR /app
COPY --from=build /app/packages/backend/dist ./packages/backend/dist
COPY --from=build /app/node_modules ./node_modules
COPY app-config.yaml .
COPY app-config.production.yaml .

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backstage
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backstage
  template:
    metadata:
      labels:
        app: backstage
    spec:
      containers:
        - name: backstage
          image: my-registry/backstage:latest
          ports:
            - containerPort: 7007
          env:
            - name: POSTGRES_HOST
              valueFrom:
                secretKeyRef:
                  name: backstage-secrets
                  key: POSTGRES_HOST
          readinessProbe:
            httpGet:
              path: /healthcheck
              port: 7007
            initialDelaySeconds: 30
          resources:
            requests:
              memory: "512Mi"
              cpu: "250m"
            limits:
              memory: "1Gi"
              cpu: "1000m"
```

---

## Cross-References

- `toolkit/developer_experience_tooling` - CLI tools and onboarding automation
- `toolkit/documentation_as_code` - TechDocs and documentation strategies
- `3-build/design_system_development` - Design system documentation in portal

---

## EXIT CHECKLIST

- [ ] Backstage instance deployed and accessible
- [ ] Authentication configured (GitHub/Google/Okta)
- [ ] All services registered with catalog-info.yaml
- [ ] Systems and domains modeled for service relationships
- [ ] At least 3 software templates published
- [ ] TechDocs building and publishing from CI
- [ ] Search indexing catalog and TechDocs
- [ ] Scorecard rules defined for engineering maturity
- [ ] Essential plugins installed (K8s, GitHub Actions, PagerDuty)
- [ ] API definitions registered and browsable
- [ ] Teams onboarded and creating services via templates

---

*Skill Version: 1.0 | Created: March 2026*
