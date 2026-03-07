# Blueprint: Data Pipeline

Building data engineering pipelines for ETL/ELT, batch processing, streaming, data quality validation, and warehouse loading. The backbone of any data-driven application.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| Apache Airflow + dbt + Snowflake | Batch ELT, analytics engineering, SQL-first teams |
| Dagster + Polars/DuckDB | Modern data orchestration, local-first, type-safe |
| Apache Spark + Delta Lake | Large-scale batch processing, lakehouse architecture |
| Apache Kafka + Flink | Real-time streaming, event-driven architectures |
| Prefect + pandas/Polars | Python-native orchestration, lightweight pipelines |
| AWS Glue + Redshift | Serverless ETL on AWS, minimal infrastructure |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define data sources, destinations, freshness SLAs, volume estimates
- **prd_generator** -- Document schemas, transformation rules, data quality requirements
- **prioritization_frameworks** -- Rank data sources by business value for MVP

Key scoping questions:
- Batch or streaming? (Most teams should start batch and add streaming later)
- What is the data freshness SLA? (Daily, hourly, near-real-time, real-time)
- Data volume: GBs (Polars/DuckDB), TBs (Spark), PBs (Spark + cloud storage)
- Who consumes the data? (Analysts = warehouse, ML = feature store, app = API)

### Phase 2: Architecture
- **schema_design** -- Source schemas, staging tables, dimensional models (star/snowflake)
- **api_design** -- Data contracts between producers and consumers

Architecture patterns:
- **Medallion (Bronze/Silver/Gold)**: Raw ingestion -> cleaned/typed -> aggregated/business-ready
- **ELT over ETL**: Load raw data into warehouse first, transform with SQL (dbt)
- **Lambda**: Batch layer (historical accuracy) + speed layer (low latency) merged at serving
- **Kappa**: Everything is a stream, batch is just a bounded stream

### Phase 3: Implementation
- **tdd_workflow** -- Test transformations with fixed input/output fixtures
- **error_handling** -- Dead letter queues, retry logic, partial failure handling
- **validation_patterns** -- Schema validation (Great Expectations, Soda), row counts, null checks

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end pipeline runs with test data
- **security_audit** -- PII detection and masking, access controls, encryption at rest/in transit
- **data_quality** -- Freshness checks, completeness, uniqueness, referential integrity

### Phase 5: Deployment
- **ci_cd_pipeline** -- dbt CI (slim builds), Airflow DAG deployment, schema migration
- **infrastructure_as_code** -- Terraform for warehouses, queues, storage buckets
- **monitoring_setup** -- Pipeline SLA tracking, data quality dashboards, cost monitoring

## Key Domain-Specific Concerns

### Data Quality
- Validate at every boundary: ingestion, after transformation, before serving
- Implement checks: not-null, uniqueness, referential integrity, freshness, row count deltas
- Use Great Expectations or Soda Core for declarative data quality tests
- Alert on quality failures -- do not silently pass bad data downstream
- Quarantine failed records in a dead letter table for investigation

### Idempotency
- Every pipeline step must be safe to re-run without duplicating data
- Use merge/upsert (not insert) for incremental loads
- Partition data by date and overwrite full partitions on reprocessing
- Track watermarks for incremental extraction (last modified timestamp)
- Design for exactly-once semantics where possible, at-least-once with dedup otherwise

### Schema Evolution
- Use schema registries (Confluent, AWS Glue) for streaming pipelines
- Handle additive changes (new columns) automatically
- Breaking changes (column rename, type change) require versioned migrations
- Store raw data with original schema -- transform into target schema in silver/gold layer

### Performance Optimization
- Partition tables by date or high-cardinality filter columns
- Use columnar formats (Parquet, ORC) for analytical workloads
- Push filters down to the source when possible (predicate pushdown)
- Prefer SQL transformations in the warehouse over Python for large datasets
- Use incremental models in dbt instead of full-refresh where data is append-only

### Orchestration
- Use DAGs with clear dependencies -- avoid monolithic "do everything" tasks
- Set task-level retries with exponential backoff
- Implement SLA alerts for pipelines that must complete by a deadline
- Keep orchestrator logic thin -- call external services, do not embed business logic

## Getting Started

1. **Map data sources and sinks** -- List every system you ingest from and write to
2. **Define the data model** -- Star schema, entity tables, or document model
3. **Choose orchestrator** -- Airflow (mature), Dagster (modern), Prefect (lightweight)
4. **Set up staging layer** -- Raw data landing zone with schema-on-read
5. **Build extraction tasks** -- API pulls, DB replication, file ingestion
6. **Implement transformations** -- dbt models or Python transforms, test each one
7. **Add data quality checks** -- Great Expectations or dbt tests on every model
8. **Configure scheduling** -- Cron-based or event-driven triggers
9. **Set up monitoring** -- Pipeline run dashboards, SLA alerts, cost tracking
10. **Document data lineage** -- Source-to-destination mapping for every field

## Project Structure

```
dags/                       # Airflow DAGs (if using Airflow)
  ingestion/
    source_a.py
    source_b.py
  transformations/
    daily_aggregate.py
dbt/
  models/
    staging/                # 1:1 source mappings, renamed/typed
      stg_source_a.sql
    intermediate/           # Joins, business logic
      int_orders.sql
    marts/                  # Final business tables
      dim_customers.sql
      fct_orders.sql
  tests/                    # dbt data tests
  macros/                   # Reusable SQL macros
  dbt_project.yml
src/
  extractors/               # Source-specific extraction logic
    api_extractor.py
    db_extractor.py
  loaders/                  # Destination-specific loading
    warehouse_loader.py
    s3_loader.py
  quality/
    expectations.py          # Great Expectations suites
    alerts.py               # Quality failure notifications
  utils/
    connections.py           # Connection management
    backfill.py             # Historical data loading
config/
  sources.yaml              # Source connection configs
  schedules.yaml            # Pipeline scheduling
infrastructure/
  terraform/                # Warehouse, storage, networking
```
