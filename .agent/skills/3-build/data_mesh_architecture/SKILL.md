---
name: Data Mesh Architecture
description: Design domain-oriented decentralized data platforms — data as a product, self-serve infrastructure, federated governance, data contracts, using Dataplex, Unity Catalog, and open standards.
triggers:
  - /data-mesh
  - /data-products
  - /data-contracts
---

# Data Mesh Architecture

## WHEN TO USE

- Scaling a data platform beyond a central team bottleneck
- Shifting data ownership to domain teams (orders, payments, logistics)
- Establishing data contracts between producers and consumers
- Implementing federated governance without a monolithic data lake
- Evaluating self-serve data infrastructure platforms

## PROCESS

1. **Identify domains** — map organizational domains to data product boundaries; each domain owns its analytical and operational data; avoid splitting domains too granularly early on.
2. **Define data products** — for each domain, specify output ports (datasets, APIs, streams) with SLOs: freshness, completeness, schema stability; assign a data product owner per domain.
3. **Design data contracts** — write schema contracts (Protobuf, Avro, JSON Schema) with versioning policy (backward-compatible by default); include quality expectations, SLAs, and contact info.
4. **Build self-serve platform** — provide domain teams with templated infrastructure: storage (Iceberg/Delta tables), compute (Spark/dbt), orchestration (Airflow/Dagster), and observability — all via IaC.
5. **Implement federated governance** — establish global interoperability standards (naming conventions, PII tagging, retention policies) enforced via automation; use Dataplex for GCP or Unity Catalog for Databricks.
6. **Set up discovery and cataloging** — deploy a data catalog (DataHub, OpenMetadata, Atlan) with automated lineage tracking; require domain teams to register products with documentation and ownership.
7. **Enable consumption** — provide consumers with standard access patterns: SQL interface, API gateway, event streams; enforce access control via attribute-based policies (ABAC).
8. **Monitor and evolve** — track data product adoption, SLO adherence, and consumer satisfaction; run quarterly reviews; deprecate unused products; evolve contracts through versioned migrations.

## CHECKLIST

- [ ] Domain boundaries mapped and data product owners assigned
- [ ] Data contracts defined with schema, SLOs, and versioning policy
- [ ] Self-serve platform enables domain teams to ship without central team tickets
- [ ] Federated governance policies automated (naming, PII, retention)
- [ ] Data catalog populated with lineage, ownership, and quality scores
- [ ] Access control enforced per data product (ABAC or RBAC)
- [ ] Consumer onboarding takes <1 day for a new data product
- [ ] SLO dashboards visible to both producers and consumers

## Related Skills

- `federated_learning` — decentralized ML training on domain-owned data
- `causal_inference_production` — causal analysis using governed data products
