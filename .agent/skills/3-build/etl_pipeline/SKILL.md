---
name: etl_pipeline
description: Data extraction, transformation, and loading pipelines for reliable data processing
---

# ETL Pipeline Skill

**Purpose**: Build reliable, idempotent data pipelines that extract from diverse sources, transform with quality checks, and load into analytical destinations without data loss or duplication.

## :dart: TRIGGER COMMANDS

```text
"build ETL pipeline"
"data pipeline"
"extract transform load"
"Using etl_pipeline skill: [source] [destination] [orchestrator]"
```

## :arrows_counterclockwise: ETL vs ELT COMPARISON

| Aspect | ETL (Traditional) | ELT (Modern Data Stack) |
|---|---|---|
| Transform location | Before loading (in pipeline) | After loading (in warehouse) |
| Processing | Custom code (Python, Spark) | SQL in warehouse (dbt) |
| Raw data preserved | No (transformed before storage) | Yes (raw loaded first) |
| Flexibility | Fixed transformations | Ad-hoc transformations on raw data |
| Best for | Complex logic, data cleansing | Analytics, BI, iterative modeling |
| Cost | Compute in pipeline | Compute in warehouse |
| Tools | Airflow + Python/Spark | Fivetran/Airbyte + dbt |

> [!TIP]
> For most modern analytics use cases, ELT is the right choice. Load raw data to your warehouse, then transform with dbt. Reserve traditional ETL for cases where raw data cannot be stored (PII scrubbing) or where transformation requires non-SQL logic (ML feature engineering, image processing).

## :building_construction: PIPELINE ARCHITECTURE

```text
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Sources   │     │   Extract   │     │  Transform  │     │    Load     │
│             │     │             │     │             │     │             │
│ - Databases │────>│ - Full pull │────>│ - Clean     │────>│ - Insert    │
│ - APIs      │     │ - Incremental│    │ - Enrich    │     │ - Upsert    │
│ - Files     │     │ - CDC       │     │ - Aggregate │     │ - Append    │
│ - Streams   │     │ - Paginate  │     │ - Validate  │     │ - Partition │
│ - SaaS      │     │             │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
                                │                                   │
                         ┌──────┴──────┐                    ┌───────┴──────┐
                         │ Orchestrator │                    │  Destination │
                         │ (Airflow,    │                    │ (Warehouse,  │
                         │  Prefect)    │                    │  Data Lake)  │
                         └─────────────┘                    └──────────────┘
```

## :control_knobs: ORCHESTRATION TOOLS

| Tool | Language | Architecture | Strengths | Best For |
|---|---|---|---|---|
| **Apache Airflow** | Python | Scheduler + Workers | Most popular, huge ecosystem | Production data engineering |
| **Prefect** | Python | Cloud or self-hosted | Modern API, easy debugging | Python-native teams |
| **Dagster** | Python | Asset-oriented | Software-defined assets, great testing | Data platform teams |
| **Luigi** | Python | Central scheduler | Simple, low overhead | Small pipelines |
| **Temporal** | Multi-language | Durable workflows | Fault tolerance, long-running | Mission-critical workflows |
| **cron** | Shell | OS scheduler | Zero dependencies | Single-script jobs |

## :electric_plug: EXTRACTION PATTERNS

### Full vs Incremental Extraction

| Pattern | When to Use | Complexity | Data Volume |
|---|---|---|---|
| **Full extraction** | Small tables (<100K rows), lookup data | Low | Entire table each run |
| **Incremental (timestamp)** | Tables with `updated_at` column | Medium | Only changed rows |
| **CDC (Change Data Capture)** | High-volume transactional tables | High | Real-time row changes |
| **API pagination** | REST API data sources | Medium | Page through results |

### Python API Extraction with Pagination and Rate Limiting

```python
import requests
import time
from typing import Generator

def extract_from_api(
    base_url: str,
    endpoint: str,
    api_key: str,
    params: dict = None,
    page_size: int = 100,
    rate_limit_per_sec: float = 5.0,
) -> Generator[dict, None, None]:
    """
    Extract all records from a paginated REST API with rate limiting.
    Yields individual records.
    """
    headers = {"Authorization": f"Bearer {api_key}"}
    params = params or {}
    params["limit"] = page_size
    cursor = None
    total_extracted = 0
    min_interval = 1.0 / rate_limit_per_sec

    while True:
        if cursor:
            params["cursor"] = cursor

        start_time = time.monotonic()
        response = requests.get(
            f"{base_url}/{endpoint}",
            headers=headers,
            params=params,
            timeout=30,
        )
        response.raise_for_status()
        data = response.json()

        records = data.get("data", [])
        if not records:
            break

        for record in records:
            yield record
            total_extracted += 1

        # Pagination
        cursor = data.get("next_cursor")
        if not cursor or not data.get("has_more", False):
            break

        # Rate limiting
        elapsed = time.monotonic() - start_time
        if elapsed < min_interval:
            time.sleep(min_interval - elapsed)

    print(f"Extracted {total_extracted} records from {endpoint}")


# Usage
for record in extract_from_api(
    base_url="https://api.stripe.com/v1",
    endpoint="charges",
    api_key=os.environ["STRIPE_API_KEY"],
    params={"created[gte]": int(yesterday.timestamp())},
):
    process_record(record)
```

### Incremental Extraction with Bookmarks

```python
import json
from datetime import datetime, timezone

BOOKMARK_FILE = "/data/bookmarks/orders_bookmark.json"

def get_bookmark() -> str:
    """Get the last extraction timestamp."""
    try:
        with open(BOOKMARK_FILE) as f:
            return json.load(f)["last_updated_at"]
    except FileNotFoundError:
        return "1970-01-01T00:00:00Z"  # Full extraction on first run

def save_bookmark(timestamp: str):
    """Save the latest timestamp for next run."""
    with open(BOOKMARK_FILE, "w") as f:
        json.dump({"last_updated_at": timestamp, "saved_at": datetime.now(timezone.utc).isoformat()}, f)

def extract_orders_incremental(db_conn) -> list[dict]:
    bookmark = get_bookmark()
    query = """
        SELECT id, customer_id, total, status, updated_at
        FROM orders
        WHERE updated_at > %(bookmark)s
        ORDER BY updated_at ASC
    """
    rows = db_conn.execute(query, {"bookmark": bookmark}).fetchall()

    if rows:
        # Save bookmark as the latest updated_at value
        save_bookmark(rows[-1]["updated_at"].isoformat())

    return rows
```

## :broom: TRANSFORMATION PATTERNS

### Common Transformations

| Pattern | Example | SQL/Python |
|---|---|---|
| **Null handling** | Replace NULL city with "Unknown" | `COALESCE(city, 'Unknown')` |
| **Deduplication** | Keep latest record per customer | `ROW_NUMBER() OVER (PARTITION BY id ORDER BY updated_at DESC)` |
| **Type casting** | String dates to timestamps | `CAST(date_str AS TIMESTAMP)` |
| **Enrichment** | Add country from IP address | Join with geo lookup table |
| **Aggregation** | Daily revenue summary | `SUM(amount) GROUP BY date` |
| **Normalization** | Split full name into first/last | `SPLIT_PART(full_name, ' ', 1)` |
| **SCD Type 2** | Track customer address history | Add `valid_from`, `valid_to`, `is_current` |

### Python Transformation Example

```python
import pandas as pd
from datetime import datetime

def transform_orders(raw_orders: list[dict]) -> pd.DataFrame:
    """Clean and enrich raw order data."""
    df = pd.DataFrame(raw_orders)

    # 1. Remove exact duplicates
    df = df.drop_duplicates(subset=["id"])

    # 2. Handle nulls
    df["shipping_address"] = df["shipping_address"].fillna("Not Provided")
    df["discount"] = df["discount"].fillna(0.0)

    # 3. Type casting
    df["created_at"] = pd.to_datetime(df["created_at"], utc=True)
    df["total"] = df["total"].astype(float)

    # 4. Derived columns
    df["order_date"] = df["created_at"].dt.date
    df["net_total"] = df["total"] - df["discount"]
    df["is_high_value"] = df["net_total"] > 500

    # 5. Filter invalid records
    invalid_mask = (df["total"] < 0) | (df["customer_id"].isna())
    if invalid_mask.any():
        print(f"WARNING: Dropping {invalid_mask.sum()} invalid records")
        # Send to dead letter queue for investigation
        df[invalid_mask].to_parquet(f"/data/dead_letter/orders_{datetime.now():%Y%m%d}.parquet")
    df = df[~invalid_mask]

    # 6. Standardize column names (snake_case)
    df.columns = [c.lower().replace(" ", "_") for c in df.columns]

    return df
```

## :inbox_tray: LOADING STRATEGIES

| Strategy | Use Case | Duplicate Handling | Complexity |
|---|---|---|---|
| **INSERT** | Append-only logs, events | No dedup (assumes unique) | Low |
| **UPSERT (MERGE)** | Dimension updates, syncing state | Updates existing, inserts new | Medium |
| **Truncate + Load** | Small lookup tables, full refresh | Full replace each run | Low |
| **Partition Replace** | Date-partitioned fact tables | Replace entire partition | Medium |
| **SCD Type 2** | Historical tracking of changes | New row per change, versioned | High |

### Upsert Example (PostgreSQL)

```sql
INSERT INTO dim_customer (customer_id, name, email, plan, updated_at)
VALUES
    ('cust_001', 'Alice Smith', 'alice@example.com', 'pro', NOW()),
    ('cust_002', 'Bob Jones', 'bob@example.com', 'free', NOW())
ON CONFLICT (customer_id)
DO UPDATE SET
    name = EXCLUDED.name,
    email = EXCLUDED.email,
    plan = EXCLUDED.plan,
    updated_at = EXCLUDED.updated_at;
```

## :shield: DATA QUALITY

### Great Expectations Validation Suite

```python
import great_expectations as gx

context = gx.get_context()

# Define expectations for the orders table
validator = context.sources.pandas_default.read_dataframe(orders_df)

# Schema checks
validator.expect_column_to_exist("order_id")
validator.expect_column_to_exist("customer_id")
validator.expect_column_to_exist("total")

# Uniqueness
validator.expect_column_values_to_be_unique("order_id")

# Not null
validator.expect_column_values_to_not_be_null("customer_id")
validator.expect_column_values_to_not_be_null("total")

# Value ranges
validator.expect_column_values_to_be_between("total", min_value=0, max_value=100000)
validator.expect_column_values_to_be_in_set("status", ["pending", "paid", "shipped", "delivered", "cancelled"])

# Freshness (most recent record should be within last 24 hours)
validator.expect_column_max_to_be_between(
    "created_at",
    min_value=(datetime.now() - timedelta(hours=24)).isoformat(),
)

# Row count sanity check
validator.expect_table_row_count_to_be_between(min_value=100, max_value=10000000)

results = validator.validate()
if not results.success:
    failed = [r for r in results.results if not r.success]
    raise DataQualityError(f"Data quality checks failed: {failed}")
```

> [!WARNING]
> Never skip data quality checks in production pipelines. A single corrupted source load can cascade through your entire warehouse, producing wrong dashboards and broken ML models. Check at extraction (schema), after transformation (business rules), and after loading (row counts match).

## :repeat_button: IDEMPOTENCY

Idempotent pipelines produce the same result whether run once or ten times.

| Technique | How It Works | Example |
|---|---|---|
| **Upsert on natural key** | INSERT ... ON CONFLICT UPDATE | Orders loaded by `order_id` |
| **Partition overwrite** | Delete partition, then insert | Replace all of `2026-02-08` data |
| **Deduplication at read** | SELECT DISTINCT or ROW_NUMBER | Dedup before transform |
| **Bookmark-based extraction** | Only extract records newer than last bookmark | Timestamp-based incremental |
| **Idempotency key** | Hash of record content | `md5(concat(all_columns))` |

> [!TIP]
> Always design for idempotency from day one. The question is not "will this pipeline need to be re-run?" but "when will this pipeline need to be re-run?" Backfills, bug fixes, and late-arriving data all require re-running.

## :card_file_box: DATA FORMATS

| Format | Type | Human Readable | Compression | Schema | Best For |
|---|---|---|---|---|---|
| **CSV** | Row | Yes | Poor | No | Small exports, legacy systems |
| **JSON** | Row | Yes | Poor | Optional | APIs, semi-structured data |
| **Parquet** | Columnar | No | Excellent (snappy/zstd) | Embedded | Analytics, data lakes (recommended) |
| **Avro** | Row | No | Good | Required (evolves) | Streaming, Kafka messages |
| **Delta Lake** | Columnar + ACID | No | Excellent | Required | Data lakehouse (ACID on Parquet) |
| **ORC** | Columnar | No | Excellent | Embedded | Hive/Hadoop ecosystem |

## :building_construction: MODERN DATA STACK

```text
┌─────────────┐     ┌─────────────────┐     ┌──────────────┐     ┌─────────────┐
│ Data Sources │     │  Extract + Load  │     │  Transform   │     │  Visualize  │
│             │     │                   │     │              │     │             │
│ PostgreSQL  │────>│  Fivetran         │────>│  dbt         │────>│  Looker     │
│ Stripe API  │     │  or Airbyte       │     │  (SQL in     │     │  Metabase   │
│ HubSpot     │     │  (managed EL)     │     │   warehouse) │     │  Preset     │
│ Google Ads  │     │                   │     │              │     │             │
└─────────────┘     └────────┬──────────┘     └──────┬───────┘     └─────────────┘
                             │                       │
                      ┌──────┴──────┐         ┌──────┴──────┐
                      │  Warehouse  │         │  Warehouse  │
                      │  (raw data) │────────>│ (modeled)   │
                      │  Snowflake  │         │  star schema│
                      └─────────────┘         └─────────────┘
```

## :wrench: dbt (DATA BUILD TOOL)

### dbt Incremental Model

```sql
-- models/marts/fct_orders.sql
{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge',
        on_schema_change='append_new_columns'
    )
}}

WITH source_orders AS (
    SELECT * FROM {{ ref('stg_stripe__charges') }}
    {% if is_incremental() %}
        WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}
),

enriched AS (
    SELECT
        o.charge_id AS order_id,
        o.customer_id,
        c.name AS customer_name,
        c.segment AS customer_segment,
        o.amount / 100.0 AS amount_usd,  -- Stripe stores in cents
        o.currency,
        o.status,
        o.created_at,
        o.updated_at,
        DATE_TRUNC('day', o.created_at) AS order_date,
        DATE_TRUNC('month', o.created_at) AS order_month
    FROM source_orders o
    LEFT JOIN {{ ref('dim_customer') }} c
        ON o.customer_id = c.customer_id
)

SELECT * FROM enriched
```

### dbt Test Definitions

```yaml
# models/marts/schema.yml
version: 2

models:
  - name: fct_orders
    description: "Fact table for all Stripe charges, one row per order"
    columns:
      - name: order_id
        description: "Primary key - Stripe charge ID"
        tests:
          - unique
          - not_null
      - name: customer_id
        description: "Foreign key to dim_customer"
        tests:
          - not_null
          - relationships:
              to: ref('dim_customer')
              field: customer_id
      - name: amount_usd
        description: "Order amount in USD"
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
              max_value: 100000
      - name: status
        tests:
          - accepted_values:
              values: ['succeeded', 'pending', 'failed', 'refunded']
```

## :airplane: APACHE AIRFLOW DAG

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator
from airflow.utils.dates import days_ago
from datetime import timedelta

default_args = {
    "owner": "data-engineering",
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
    "retry_exponential_backoff": True,
    "email_on_failure": True,
    "email": ["data-team@company.com"],
}

with DAG(
    dag_id="orders_etl_pipeline",
    default_args=default_args,
    description="Extract orders from Stripe, transform, load to warehouse",
    schedule_interval="0 6 * * *",  # Daily at 6 AM UTC
    start_date=days_ago(1),
    catchup=False,  # Don't backfill on first deploy
    tags=["etl", "orders", "stripe"],
) as dag:

    start = EmptyOperator(task_id="start")

    extract_orders = PythonOperator(
        task_id="extract_orders",
        python_callable=extract_stripe_charges,
        op_kwargs={"date": "{{ ds }}"},  # Airflow execution date
    )

    extract_customers = PythonOperator(
        task_id="extract_customers",
        python_callable=extract_stripe_customers,
        op_kwargs={"date": "{{ ds }}"},
    )

    validate_raw = PythonOperator(
        task_id="validate_raw_data",
        python_callable=run_quality_checks,
        op_kwargs={"suite": "raw_orders"},
    )

    transform = PythonOperator(
        task_id="transform_orders",
        python_callable=transform_and_enrich_orders,
        op_kwargs={"date": "{{ ds }}"},
    )

    load = PythonOperator(
        task_id="load_to_warehouse",
        python_callable=upsert_to_warehouse,
        op_kwargs={"table": "fct_orders", "date": "{{ ds }}"},
    )

    validate_loaded = PythonOperator(
        task_id="validate_loaded_data",
        python_callable=run_quality_checks,
        op_kwargs={"suite": "loaded_orders"},
    )

    end = EmptyOperator(task_id="end")

    # Task dependencies (parallel extraction, sequential transform/load)
    start >> [extract_orders, extract_customers] >> validate_raw
    validate_raw >> transform >> load >> validate_loaded >> end
```

## :prefect: PREFECT FLOW

```python
from prefect import flow, task
from prefect.tasks import task_input_hash
from datetime import timedelta

@task(retries=3, retry_delay_seconds=60, cache_key_fn=task_input_hash, cache_expiration=timedelta(hours=1))
def extract(source: str, date: str) -> list[dict]:
    """Extract records from source for given date."""
    if source == "stripe":
        return extract_stripe_charges(date)
    elif source == "database":
        return extract_from_postgres(date)
    raise ValueError(f"Unknown source: {source}")

@task
def transform(raw_data: list[dict]) -> list[dict]:
    """Clean and enrich raw records."""
    df = pd.DataFrame(raw_data)
    df = clean_and_enrich(df)
    return df.to_dict("records")

@task
def validate(data: list[dict], suite_name: str) -> bool:
    """Run data quality checks. Raises on failure."""
    results = run_great_expectations(data, suite_name)
    if not results.success:
        raise Exception(f"Quality checks failed for {suite_name}")
    return True

@task
def load(data: list[dict], table: str):
    """Load data to warehouse using upsert."""
    upsert_to_warehouse(table, data)

@flow(name="orders-etl", log_prints=True)
def orders_etl(date: str):
    """Main ETL flow for order data."""
    # Extract (parallel)
    orders = extract("stripe", date)
    customers = extract("database", date)

    # Validate raw
    validate(orders, "raw_orders")

    # Transform
    enriched = transform(orders)

    # Load
    load(enriched, "fct_orders")

    # Validate loaded
    validate(enriched, "loaded_orders")

    print(f"Pipeline completed for {date}")

if __name__ == "__main__":
    orders_etl(date="2026-02-08")
```

## :bar_chart: MONITORING

| Metric | What to Track | Alert Threshold |
|---|---|---|
| **Pipeline duration** | Total and per-task runtime | > 2x historical average |
| **Record counts** | Extracted vs transformed vs loaded | Mismatch > 1% |
| **Data freshness** | Time since last successful load | > SLA (e.g., 2 hours) |
| **Error rate** | Failed records / total records | > 5% |
| **Null rate** | Nulls per column in loaded data | Above historical baseline |
| **Schema changes** | New/removed/changed columns in source | Any change (alert for review) |
| **Cost** | Warehouse compute credits consumed | > 120% of budget |

## :white_check_mark: EXIT CHECKLIST

- [ ] Pipeline is idempotent (safe to re-run without duplicating data)
- [ ] Data quality checks pass at extraction, transformation, and loading stages
- [ ] Incremental loads work correctly using timestamps or CDC
- [ ] Error handling includes retries, dead letter queue, and alerting
- [ ] Scheduling configured with appropriate frequency and SLA monitoring
- [ ] Backfill capability tested (can re-process historical date ranges)
- [ ] Documentation covers data flow, source-to-target mapping, and dependencies
- [ ] Monitoring dashboards show pipeline health, record counts, and freshness
- [ ] Secrets (API keys, DB passwords) stored securely (env vars, secrets manager)
- [ ] Pipeline tested with edge cases (empty results, schema changes, API downtime)

*Skill Version: 1.0 | Created: February 2026*
