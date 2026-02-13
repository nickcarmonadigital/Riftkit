---
name: data_warehouse
description: Designing data warehouses, dimensional models, and analytical data layers with dbt
---

# Data Warehouse Skill

**Purpose**: Design and implement data warehouses with proper dimensional modeling, dbt-based transformation layers, and performant analytical queries that serve business intelligence and data science teams.

## :dart: TRIGGER COMMANDS

```text
"design data warehouse"
"build star schema"
"set up dbt models"
"Using data_warehouse skill: [warehouse platform] [domain] [scale]"
```

## :balance_scale: DATA WAREHOUSE vs DATA LAKE vs DATA LAKEHOUSE

| Aspect | Data Warehouse | Data Lake | Data Lakehouse |
|---|---|---|---|
| **Data format** | Structured (tables) | Any (raw files) | Structured + semi-structured |
| **Schema** | Schema-on-write (defined upfront) | Schema-on-read (interpret later) | Schema-on-write with flexibility |
| **Query engine** | Built-in SQL engine | External (Spark, Presto) | Built-in or external |
| **ACID transactions** | Yes | No (without Delta/Iceberg) | Yes |
| **Cost** | Higher (compute + storage coupled) | Lower (cheap object storage) | Medium (decoupled) |
| **Best for** | BI, dashboards, SQL analysts | ML training data, raw archives | Both analytics and ML |
| **Examples** | Snowflake, BigQuery, Redshift | S3 + Parquet, HDFS | Databricks, Delta Lake, Iceberg |

> [!TIP]
> For most companies under 1TB of analytical data, a well-designed PostgreSQL with proper indexing or DuckDB is sufficient. Only move to Snowflake/BigQuery when query performance degrades or your data exceeds what a single-node database can handle efficiently.

## :office: WAREHOUSE PLATFORM COMPARISON

| Platform | Pricing Model | Auto-Scale | Strengths | Best For |
|---|---|---|---|---|
| **Snowflake** | Compute + storage (credits) | Yes (warehouses) | Time travel, data sharing, cloning | Most teams, multi-cloud |
| **BigQuery** | Per query (bytes scanned) | Yes (serverless) | Zero ops, great for ad-hoc | Google Cloud teams, cost-sensitive |
| **Redshift** | Cluster-based or serverless | Manual (RA3) / Auto (serverless) | Deep AWS integration | AWS-native teams |
| **DuckDB** | Free (open source) | N/A (single process) | Embedded, local analytics, fast | Development, small datasets |
| **PostgreSQL** | Self-managed | Manual | Familiar, extensible (TimescaleDB) | Small scale (<100GB), startups |
| **ClickHouse** | Self-managed or cloud | Yes (cloud) | Extremely fast aggregation | Real-time analytics, logs |

## :star: DIMENSIONAL MODELING

### Star Schema Structure

```text
                    ┌──────────────┐
                    │ dim_customer │
                    │──────────────│
                    │ customer_key │ (surrogate)
                    │ customer_id  │ (natural)
                    │ name         │
                    │ email        │
                    │ segment      │
                    │ created_at   │
                    └──────┬───────┘
                           │
┌──────────────┐    ┌──────┴───────┐    ┌──────────────┐
│  dim_date    │    │  fct_orders  │    │ dim_product  │
│──────────────│    │──────────────│    │──────────────│
│ date_key     │───>│ order_key    │<───│ product_key  │
│ full_date    │    │ date_key     │    │ product_id   │
│ year         │    │ customer_key │    │ name         │
│ quarter      │    │ product_key  │    │ category     │
│ month        │    │ quantity     │    │ price        │
│ day_of_week  │    │ unit_price   │    │ created_at   │
│ is_weekend   │    │ discount     │    └──────────────┘
│ is_holiday   │    │ total_amount │
└──────────────┘    │ created_at   │
                    └──────────────┘
```

### Star vs Snowflake Schema

| Aspect | Star Schema | Snowflake Schema |
|---|---|---|
| Dimension structure | Flat (denormalized) | Normalized (sub-dimensions) |
| Joins required | Fewer (fact + dim) | More (dim + sub-dim) |
| Query performance | Faster (fewer joins) | Slower (more joins) |
| Storage | More (duplicated data) | Less (normalized) |
| Complexity | Simpler to understand | More complex |
| **Recommendation** | Default choice | Only when storage is critical |

## :bar_chart: FACT TABLE TYPES

| Type | Description | Grain | Example |
|---|---|---|---|
| **Transaction fact** | One row per event/transaction | Individual event | `fct_orders` (one row per order) |
| **Periodic snapshot** | One row per entity per period | Entity + time period | `fct_daily_inventory` (product + date) |
| **Accumulating snapshot** | One row per lifecycle, updated | Lifecycle instance | `fct_order_fulfillment` (dates for each stage) |
| **Factless fact** | Records events without measures | Event occurrence | `fct_student_attendance` (who showed up) |

### Transaction Fact Table DDL

```sql
CREATE TABLE fct_orders (
    -- Surrogate key
    order_key       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Foreign keys to dimensions
    date_key        INT NOT NULL REFERENCES dim_date(date_key),
    customer_key    INT NOT NULL REFERENCES dim_customer(customer_key),
    product_key     INT NOT NULL REFERENCES dim_product(product_key),
    channel_key     INT NOT NULL REFERENCES dim_channel(channel_key),

    -- Degenerate dimension (no separate table needed)
    order_number    VARCHAR(50) NOT NULL,

    -- Measures (facts)
    quantity        INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_amount      DECIMAL(10,2) DEFAULT 0,
    total_amount    DECIMAL(10,2) NOT NULL,

    -- Metadata
    created_at      TIMESTAMP NOT NULL,
    loaded_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partition by date for query performance
-- (Snowflake/BigQuery do this automatically via clustering)
CREATE INDEX idx_fct_orders_date ON fct_orders(date_key);
CREATE INDEX idx_fct_orders_customer ON fct_orders(customer_key);
```

## :busts_in_silhouette: DIMENSION TABLES

### Slowly Changing Dimensions (SCD)

| SCD Type | Strategy | History | Example |
|---|---|---|---|
| **Type 0** | Never change | Original value only | Date of birth, SSN |
| **Type 1** | Overwrite | No history (current only) | Fixing a typo in name |
| **Type 2** | Add new row | Full history with date ranges | Customer address changes |
| **Type 3** | Add column | Limited history (current + previous) | Previous and current department |

### SCD Type 2 Implementation

```sql
CREATE TABLE dim_customer (
    -- Surrogate key (auto-increment, unique per version)
    customer_key    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Natural key (business identifier)
    customer_id     VARCHAR(50) NOT NULL,

    -- Attributes (can change over time)
    name            VARCHAR(200) NOT NULL,
    email           VARCHAR(200),
    segment         VARCHAR(50),   -- 'free', 'pro', 'enterprise'
    city            VARCHAR(100),
    country         VARCHAR(100),

    -- SCD Type 2 tracking columns
    valid_from      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to        TIMESTAMP DEFAULT '9999-12-31 23:59:59',
    is_current      BOOLEAN NOT NULL DEFAULT TRUE,

    -- Metadata
    source_system   VARCHAR(50),
    loaded_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for efficient lookups
CREATE INDEX idx_dim_customer_natural ON dim_customer(customer_id, is_current);

-- Query current state
SELECT * FROM dim_customer WHERE is_current = TRUE;

-- Query historical state at a point in time
SELECT * FROM dim_customer
WHERE customer_id = 'cust_001'
  AND valid_from <= '2025-06-15'
  AND valid_to > '2025-06-15';
```

### Date Dimension (Pre-populated)

```sql
-- Generate a date dimension covering 20 years
CREATE TABLE dim_date AS
WITH date_spine AS (
    SELECT
        generate_series('2020-01-01'::date, '2039-12-31'::date, '1 day')::date AS full_date
)
SELECT
    TO_CHAR(full_date, 'YYYYMMDD')::INT AS date_key,
    full_date,
    EXTRACT(YEAR FROM full_date)::INT AS year,
    EXTRACT(QUARTER FROM full_date)::INT AS quarter,
    EXTRACT(MONTH FROM full_date)::INT AS month,
    TO_CHAR(full_date, 'Month') AS month_name,
    EXTRACT(WEEK FROM full_date)::INT AS week_of_year,
    EXTRACT(DOY FROM full_date)::INT AS day_of_year,
    EXTRACT(DOW FROM full_date)::INT AS day_of_week,
    TO_CHAR(full_date, 'Day') AS day_name,
    CASE WHEN EXTRACT(DOW FROM full_date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend,
    full_date = DATE_TRUNC('month', full_date) + INTERVAL '1 month' - INTERVAL '1 day' AS is_month_end,
    TO_CHAR(full_date, 'YYYY-Q') AS year_quarter,
    TO_CHAR(full_date, 'YYYY-MM') AS year_month
FROM date_spine;

ALTER TABLE dim_date ADD PRIMARY KEY (date_key);
```

> [!TIP]
> Always pre-populate your date dimension. It eliminates complex date calculations in queries and enables easy filtering (is_weekend, is_holiday, fiscal_year). Add company-specific columns like fiscal quarters and holidays for your organization.

## :label: NAMING CONVENTIONS

| Prefix | Layer | Description | Example |
|---|---|---|---|
| `src_` | Source | Raw source reference | `src_stripe_charges` |
| `stg_` | Staging | 1:1 with source, cleaned | `stg_stripe__charges` |
| `int_` | Intermediate | Business logic, joins | `int_orders_with_customers` |
| `fct_` | Mart (fact) | Final fact table | `fct_orders` |
| `dim_` | Mart (dimension) | Final dimension table | `dim_customer` |
| `rpt_` | Report | Pre-aggregated for dashboards | `rpt_monthly_revenue` |
| `met_` | Metric | Business metric definitions | `met_customer_ltv` |

Double underscore `__` separates source system from entity: `stg_stripe__charges`, `stg_hubspot__contacts`.

## :file_folder: dbt PROJECT STRUCTURE

```text
dbt_project/
├── dbt_project.yml            # Project configuration
├── profiles.yml               # Connection profiles (local only, not in git)
├── packages.yml               # dbt packages (dbt-utils, etc.)
├── models/
│   ├── staging/               # Layer 1: Clean raw data
│   │   ├── stripe/
│   │   │   ├── _stripe__models.yml    # Schema + tests
│   │   │   ├── _stripe__sources.yml   # Source declarations
│   │   │   ├── stg_stripe__charges.sql
│   │   │   └── stg_stripe__customers.sql
│   │   └── hubspot/
│   │       ├── _hubspot__models.yml
│   │       ├── _hubspot__sources.yml
│   │       └── stg_hubspot__contacts.sql
│   ├── intermediate/          # Layer 2: Business logic
│   │   ├── int_orders_with_customers.sql
│   │   └── int_customer_order_summary.sql
│   └── marts/                 # Layer 3: Final tables (star schema)
│       ├── core/
│       │   ├── _core__models.yml
│       │   ├── dim_customer.sql
│       │   ├── dim_product.sql
│       │   ├── dim_date.sql
│       │   └── fct_orders.sql
│       └── finance/
│           ├── _finance__models.yml
│           ├── fct_revenue.sql
│           └── rpt_monthly_revenue.sql
├── macros/                    # Reusable SQL functions
│   ├── cents_to_dollars.sql
│   └── generate_surrogate_key.sql
├── seeds/                     # Static CSV data (country codes, mappings)
│   └── country_codes.csv
├── snapshots/                 # SCD Type 2 tracking
│   └── snap_customer.sql
└── tests/                     # Custom data tests
    └── assert_total_amount_positive.sql
```

## :construction: dbt MODELING LAYERS

### Layer 1: Staging (1:1 with source)

```sql
-- models/staging/stripe/stg_stripe__charges.sql
WITH source AS (
    SELECT * FROM {{ source('stripe', 'charges') }}
),

renamed AS (
    SELECT
        id AS charge_id,
        customer AS customer_id,
        amount::DECIMAL / 100.0 AS amount_usd,  -- Stripe stores cents
        currency,
        status,
        CASE
            WHEN status = 'succeeded' THEN TRUE
            ELSE FALSE
        END AS is_successful,
        created::TIMESTAMP AS created_at,
        _sdc_extracted_at AS loaded_at       -- Fivetran/Airbyte metadata
    FROM source
)

SELECT * FROM renamed
```

### Layer 2: Intermediate (business logic)

```sql
-- models/intermediate/int_orders_with_customers.sql
WITH orders AS (
    SELECT * FROM {{ ref('stg_stripe__charges') }}
    WHERE is_successful = TRUE
),

customers AS (
    SELECT * FROM {{ ref('stg_stripe__customers') }}
),

joined AS (
    SELECT
        o.charge_id,
        o.customer_id,
        c.name AS customer_name,
        c.email AS customer_email,
        c.metadata_segment AS customer_segment,
        o.amount_usd,
        o.currency,
        o.created_at,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.created_at
        ) AS customer_order_number
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
)

SELECT * FROM joined
```

### Layer 3: Marts (final star schema)

```sql
-- models/marts/core/fct_orders.sql
{{
    config(
        materialized='incremental',
        unique_key='charge_id',
        cluster_by=['order_date']
    )
}}

WITH orders AS (
    SELECT * FROM {{ ref('int_orders_with_customers') }}
    {% if is_incremental() %}
        WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
    {% endif %}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['charge_id']) }} AS order_key,
    charge_id,
    customer_id,
    customer_name,
    customer_segment,
    amount_usd,
    CASE
        WHEN customer_order_number = 1 THEN 'new'
        ELSE 'returning'
    END AS customer_type,
    customer_order_number,
    created_at,
    DATE_TRUNC('day', created_at) AS order_date,
    DATE_TRUNC('month', created_at) AS order_month
FROM orders
```

## :test_tube: dbt BEST PRACTICES

| Practice | Why | Example |
|---|---|---|
| One model per file | Clarity, modularity | `fct_orders.sql` not `all_marts.sql` |
| Use `ref()` not table names | Dependency tracking, environments | `{{ ref('stg_stripe__charges') }}` |
| Document all models | Discovery, trust | YAML descriptions for every model and column |
| Test PK uniqueness + not_null | Data integrity | `tests: [unique, not_null]` on every primary key |
| Incremental for large tables | Performance, cost | `materialized='incremental'` for fact tables >1M rows |
| Staging 1:1 with source | Consistency, single rename point | One `stg_` model per source table |
| No business logic in staging | Separation of concerns | Only rename, cast, trivial cleanup in `stg_` |

### dbt Test Definitions

```yaml
# models/marts/core/_core__models.yml
version: 2

models:
  - name: fct_orders
    description: "One row per successful Stripe charge. Grain: order."
    columns:
      - name: order_key
        description: "Surrogate primary key"
        tests:
          - unique
          - not_null
      - name: charge_id
        description: "Stripe charge ID (natural key)"
        tests:
          - unique
          - not_null
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_customer')
              field: customer_id
      - name: amount_usd
        tests:
          - not_null
          - dbt_utils.accepted_range:
              min_value: 0
      - name: customer_type
        tests:
          - accepted_values:
              values: ['new', 'returning']

  - name: dim_customer
    description: "One row per customer (current state). SCD Type 1."
    columns:
      - name: customer_id
        description: "Primary key - Stripe customer ID"
        tests:
          - unique
          - not_null
```

## :chart_with_upwards_trend: COMMON ANALYTICAL PATTERNS

### Cohort Analysis (User Retention by Signup Month)

```sql
WITH user_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', first_order_date) AS cohort_month
    FROM {{ ref('dim_customer') }}
),

monthly_activity AS (
    SELECT
        o.customer_id,
        DATE_TRUNC('month', o.order_date) AS activity_month
    FROM {{ ref('fct_orders') }} o
),

cohort_retention AS (
    SELECT
        c.cohort_month,
        DATEDIFF('month', c.cohort_month, a.activity_month) AS months_since_signup,
        COUNT(DISTINCT a.customer_id) AS active_customers
    FROM user_cohorts c
    JOIN monthly_activity a ON c.customer_id = a.customer_id
    GROUP BY 1, 2
),

cohort_sizes AS (
    SELECT cohort_month, COUNT(*) AS cohort_size
    FROM user_cohorts
    GROUP BY 1
)

SELECT
    r.cohort_month,
    s.cohort_size,
    r.months_since_signup,
    r.active_customers,
    ROUND(r.active_customers * 100.0 / s.cohort_size, 1) AS retention_pct
FROM cohort_retention r
JOIN cohort_sizes s ON r.cohort_month = s.cohort_month
WHERE r.months_since_signup BETWEEN 0 AND 12
ORDER BY r.cohort_month, r.months_since_signup
```

### Year-over-Year Revenue Comparison

```sql
SELECT
    d.month_name,
    d.month,
    SUM(CASE WHEN d.year = 2025 THEN f.amount_usd ELSE 0 END) AS revenue_2025,
    SUM(CASE WHEN d.year = 2026 THEN f.amount_usd ELSE 0 END) AS revenue_2026,
    ROUND(
        (SUM(CASE WHEN d.year = 2026 THEN f.amount_usd ELSE 0 END) -
         SUM(CASE WHEN d.year = 2025 THEN f.amount_usd ELSE 0 END)) * 100.0 /
        NULLIF(SUM(CASE WHEN d.year = 2025 THEN f.amount_usd ELSE 0 END), 0),
    1) AS yoy_growth_pct
FROM {{ ref('fct_orders') }} f
JOIN {{ ref('dim_date') }} d ON f.order_date = d.full_date
WHERE d.year IN (2025, 2026)
GROUP BY d.month_name, d.month
ORDER BY d.month
```

## :racing_car: PERFORMANCE OPTIMIZATION

| Technique | Platform | Impact | When to Use |
|---|---|---|---|
| **Partitioning** | All | 10-100x for filtered queries | Date-based fact tables |
| **Clustering / Sort keys** | Snowflake, BigQuery, Redshift | 2-10x for filtered queries | Frequently filtered columns |
| **Materialized views** | All | Eliminate repeated computation | Expensive aggregations queried often |
| **Pre-aggregation tables** | All | 10-50x for dashboard queries | Dashboard-specific rollups (`rpt_` models) |
| **Avoid SELECT \*** | All | 2-5x (columnar storage) | Always specify columns needed |
| **Incremental models** | dbt | Faster runs, lower cost | Tables > 1M rows |
| **Column pruning** | BigQuery | Direct cost savings | Always (BigQuery charges per byte scanned) |

> [!WARNING]
> The most common performance mistake in data warehouses is not partitioning fact tables by date. A query scanning 3 years of data when it only needs today's records wastes 99.9% of its I/O. Always partition by the primary date column.

## :lock: DATA GOVERNANCE

| Concern | Solution | Implementation |
|---|---|---|
| **Column documentation** | dbt YAML descriptions | Every column gets a description |
| **Data ownership** | Model-level `meta.owner` | `meta: {owner: "data-team", domain: "finance"}` |
| **PII handling** | Hash or mask sensitive columns | `SHA2(email)` in staging layer |
| **Access control** | Row-level security, column masking | Snowflake secure views, BigQuery authorized views |
| **Lineage tracking** | dbt docs, data catalog | `dbt docs generate && dbt docs serve` |
| **Data freshness** | dbt source freshness | `freshness: {warn_after: {count: 12, period: hour}}` |

### Source Freshness Check

```yaml
# models/staging/stripe/_stripe__sources.yml
version: 2

sources:
  - name: stripe
    database: raw
    schema: stripe
    freshness:
      warn_after: { count: 12, period: hour }
      error_after: { count: 24, period: hour }
    loaded_at_field: _sdc_extracted_at  # Fivetran/Airbyte metadata column
    tables:
      - name: charges
        description: "Stripe charges (payments)"
      - name: customers
        description: "Stripe customer records"
      - name: refunds
        description: "Stripe refund records"
```

## :ladder: MIGRATION PATH

```text
Stage 1: PostgreSQL Views (0-50GB, <5 users)
├── Create views for analytical queries
├── Use materialized views for performance
└── Works for early-stage startups

Stage 2: dbt on PostgreSQL (50-100GB, 5-20 users)
├── Introduce dbt for transformation layer
├── Staging → Intermediate → Marts structure
├── Add tests and documentation
└── Separate analytical schema from production

Stage 3: Dedicated Warehouse (100GB+, 20+ users)
├── Migrate to Snowflake / BigQuery / Redshift
├── Keep dbt models (only change connection profile)
├── Add Fivetran/Airbyte for managed extraction
├── Implement proper access controls
└── Consider BI tool (Looker, Metabase, Preset)
```

## :white_check_mark: EXIT CHECKLIST

- [ ] Star schema designed with clearly identified fact tables and dimension tables
- [ ] dbt models structured in layers: staging (1:1 with source) -> intermediate (business logic) -> marts (star schema)
- [ ] All primary keys tested for uniqueness and not_null in dbt
- [ ] All foreign key relationships validated with dbt relationship tests
- [ ] Documentation complete: every model and column has a description in YAML
- [ ] Source freshness checks configured with warn and error thresholds
- [ ] Incremental models used for large fact tables (>1M rows)
- [ ] Date dimension pre-populated with all required attributes
- [ ] Query performance acceptable for dashboard use cases (< 10 seconds)
- [ ] Naming conventions followed consistently (fct_, dim_, stg_, int_)
- [ ] Data governance policies defined: PII handling, access controls, ownership
- [ ] Migration path documented for scaling to next platform when needed

*Skill Version: 1.0 | Created: February 2026*
