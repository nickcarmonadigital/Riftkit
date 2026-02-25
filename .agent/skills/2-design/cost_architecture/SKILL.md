---
name: Cost Architecture
description: Cloud cost modeling during design phase with resource sizing, FinOps tagging, budget projections, and cost-per-user analysis
---

# Cost Architecture Skill

**Purpose**: Models cloud infrastructure costs during the design phase before any resources are provisioned. Produces resource sizing estimates, a FinOps tagging strategy, cost-per-user calculations, and growth scenario projections so that budget surprises are caught at design time rather than after the first invoice.

## TRIGGER COMMANDS

```text
"Cloud cost model for [system]"
"FinOps design"
"Budget projection for [architecture]"
```

## When to Use
- After ARA and NFR specification define the architecture and scale targets
- Before selecting instance types, storage tiers, or managed services
- When comparing architectural options with different cost profiles
- When stakeholders need a monthly/annual infrastructure budget estimate

---

## PROCESS

### Step 1: Resource Inventory from Architecture

Map every container from the C4/ARA architecture to a cloud resource:

```markdown
## Resource Inventory

| Component | Cloud Resource | Provider | Sizing Basis |
|-----------|---------------|----------|-------------|
| API Server | ECS Fargate / EC2 | AWS | NFR: 500 req/s, p95 < 200ms |
| Database | RDS PostgreSQL | AWS | NFR: 50GB initial, 10GB/mo growth |
| Cache | ElastiCache Redis | AWS | Hot data set ~2GB |
| Queue | SQS / BullMQ on Redis | AWS | 10K messages/day |
| CDN | CloudFront | AWS | 100GB transfer/mo |
| Storage | S3 | AWS | Document uploads, 500GB/yr |
| Monitoring | CloudWatch + Datadog | AWS/SaaS | All containers |
```

### Step 2: Size Resources for Expected Load

For each resource, calculate the required size using NFR targets:

```markdown
## Sizing Calculations

### API Server
- Target: 500 req/s sustained, 2000 req/s peak
- Per-container capacity: ~250 req/s (benchmarked or estimated)
- Minimum containers: 2 (baseline) + autoscale to 8 (peak)
- Instance: Fargate 0.5 vCPU / 1GB RAM per task
- Monthly cost: 2 tasks x 730 hrs x $0.04048/hr = ~$59/mo baseline

### Database
- Target: 50GB data, 200 connections
- Instance: db.r6g.large (2 vCPU, 16GB RAM)
- Storage: gp3, 100GB provisioned
- Monthly cost: ~$197/mo (instance) + $11.50/mo (storage) = ~$209/mo
```

### Step 3: FinOps Tagging Strategy

Define mandatory tags for cost allocation:

```markdown
## Required Tags (All Resources)

| Tag Key | Values | Purpose |
|---------|--------|---------|
| `project` | [project-name] | Cost allocation to project |
| `environment` | dev, staging, prod | Per-environment cost tracking |
| `service` | api, worker, db, cache | Per-service cost breakdown |
| `owner` | [team-name] | Accountability |
| `cost-center` | [department code] | Finance allocation |
| `managed-by` | terraform, manual | Drift detection |

## Tag Enforcement
- CI pipeline rejects infrastructure PRs missing required tags
- Monthly tag compliance report via AWS Cost Explorer
```

### Step 4: Growth Scenario Projections

Model three scenarios over 12 months:

```markdown
## 12-Month Cost Projection

| Category | Month 1 | Month 6 | Month 12 |
|----------|---------|---------|----------|
| **Conservative (1x)** | | | |
| Compute | $120 | $120 | $180 |
| Database | $209 | $230 | $260 |
| Storage | $12 | $42 | $72 |
| Transfer | $15 | $15 | $20 |
| **Total** | **$356** | **$407** | **$532** |
| **Expected (3x)** | | | |
| Total | $356 | $620 | $980 |
| **Aggressive (10x)** | | | |
| Total | $356 | $1,400 | $3,200 |

## Cost-Per-User
- At 1,000 MAU: $0.53/user/mo
- At 10,000 MAU: $0.10/user/mo
- At 100,000 MAU: $0.03/user/mo
```

### Step 5: Identify Optimization Opportunities

| Opportunity | Savings Estimate | When to Apply |
|-------------|-----------------|---------------|
| Reserved Instances (1yr) | 30-40% on compute | After 3 months of stable baseline |
| Spot/Fargate Spot | 50-70% on workers | Non-critical background jobs |
| S3 Intelligent Tiering | 20-30% on storage | When access patterns vary |
| Right-sizing | 10-30% | After 1 month of utilization data |
| Dev/staging shutdown | 60-70% on non-prod | Nights and weekends |
| Graviton/ARM instances | 10-20% on compute | If application is ARM-compatible |

---

## OUTPUT

**Path**: `.agent/docs/2-design/cost-architecture.md`

---

## CHECKLIST

- [ ] Every architectural component mapped to a cloud resource
- [ ] Resource sizing derived from NFR targets, not guesswork
- [ ] FinOps tagging strategy defined with enforcement plan
- [ ] Three growth scenarios projected over 12 months
- [ ] Cost-per-user calculated at target user milestones
- [ ] Optimization opportunities identified with triggers
- [ ] Monthly budget estimate provided for stakeholder approval
- [ ] Cost comparison included if multiple architecture options exist
- [ ] Non-production environment costs estimated separately

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P2*
