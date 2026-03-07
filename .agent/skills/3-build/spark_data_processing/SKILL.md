---
name: Spark Data Processing
description: Apache Spark DataFrames, SQL, structured streaming, partitioning, optimization, and Delta Lake integration
---

# Spark Data Processing Skill

**Purpose**: Build efficient data processing pipelines with Apache Spark, covering batch and streaming workloads, query optimization, partitioning strategies, and Delta Lake for reliable data lakes.

---

## TRIGGER COMMANDS

```text
"Build a Spark data pipeline"
"Optimize Spark job performance"
"Set up Spark structured streaming"
"Create a Delta Lake table"
"Using spark_data_processing skill: [task]"
```

---

## Spark Application Structure

```
spark-pipeline/
  src/
    main/
      python/
        jobs/
          daily_aggregation.py
          streaming_ingest.py
        transforms/
          clean.py
          enrich.py
        utils/
          spark_session.py
          schemas.py
    test/
      python/
        test_transforms.py
  configs/
    dev.yaml
    production.yaml
  Dockerfile
  pyproject.toml
```

---

## SparkSession Configuration

```python
from pyspark.sql import SparkSession

def create_spark_session(app_name: str, env: str = "production") -> SparkSession:
    builder = (
        SparkSession.builder
        .appName(app_name)
        .config("spark.sql.adaptive.enabled", "true")
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true")
        .config("spark.sql.adaptive.skewJoin.enabled", "true")
        .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
        .config("spark.sql.shuffle.partitions", "200")
        .config("spark.sql.sources.partitionOverwriteMode", "dynamic")
    )

    if env == "production":
        builder = (
            builder
            .config("spark.sql.extensions",
                "io.delta.sql.DeltaSparkSessionExtension")
            .config("spark.sql.catalog.spark_catalog",
                "org.apache.spark.sql.delta.catalog.DeltaCatalog")
            .config("spark.hadoop.fs.s3a.impl",
                "org.apache.hadoop.fs.s3a.S3AFileSystem")
            .config("spark.hadoop.fs.s3a.aws.credentials.provider",
                "com.amazonaws.auth.DefaultAWSCredentialsProviderChain")
        )

    return builder.getOrCreate()
```

---

## DataFrame Operations

### Reading Data

```python
# CSV with schema enforcement
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, \
    DecimalType, TimestampType

order_schema = StructType([
    StructField("order_id", StringType(), nullable=False),
    StructField("customer_id", StringType(), nullable=False),
    StructField("product_id", StringType(), nullable=False),
    StructField("quantity", IntegerType(), nullable=False),
    StructField("unit_price", DecimalType(10, 2), nullable=False),
    StructField("order_date", TimestampType(), nullable=False),
])

df = (
    spark.read
    .schema(order_schema)
    .option("header", True)
    .option("mode", "DROPMALFORMED")
    .csv("s3a://data-lake/raw/orders/")
)

# Parquet (schema embedded)
df = spark.read.parquet("s3a://data-lake/curated/orders/")

# Delta Lake
df = spark.read.format("delta").load("s3a://data-lake/delta/orders/")

# JDBC
df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql://db:5432/analytics")
    .option("dbtable", "(SELECT * FROM orders WHERE date > '2026-01-01') AS t")
    .option("fetchsize", 10000)
    .option("numPartitions", 8)
    .option("partitionColumn", "id")
    .option("lowerBound", 1)
    .option("upperBound", 1000000)
    .load()
)
```

### Transformations

```python
from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Clean and transform
cleaned = (
    df
    .filter(F.col("quantity") > 0)
    .withColumn("total_amount", F.col("quantity") * F.col("unit_price"))
    .withColumn("order_date", F.to_date("order_date"))
    .withColumn("year_month", F.date_format("order_date", "yyyy-MM"))
    .dropDuplicates(["order_id"])
    .na.fill({"quantity": 0, "unit_price": 0})
)

# Window functions
window_spec = Window.partitionBy("customer_id").orderBy("order_date")

with_running_total = cleaned.withColumn(
    "running_total",
    F.sum("total_amount").over(window_spec)
).withColumn(
    "order_rank",
    F.row_number().over(window_spec)
)

# Aggregations
daily_summary = (
    cleaned
    .groupBy("order_date", "product_id")
    .agg(
        F.count("order_id").alias("order_count"),
        F.sum("total_amount").alias("revenue"),
        F.avg("total_amount").alias("avg_order_value"),
        F.approx_count_distinct("customer_id").alias("unique_customers"),
    )
)
```

### Writing Data

```python
# Partitioned Parquet
(
    daily_summary
    .repartition("year_month")
    .write
    .partitionBy("year_month")
    .mode("overwrite")
    .parquet("s3a://data-lake/curated/daily_summary/")
)

# Delta Lake with merge
from delta.tables import DeltaTable

target = DeltaTable.forPath(spark, "s3a://data-lake/delta/daily_summary/")

(
    target.alias("t")
    .merge(daily_summary.alias("s"), "t.order_date = s.order_date AND t.product_id = s.product_id")
    .whenMatchedUpdateAll()
    .whenNotMatchedInsertAll()
    .execute()
)
```

---

## Spark SQL

```python
# Register temp view
cleaned.createOrReplaceTempView("orders")

result = spark.sql("""
    WITH monthly_revenue AS (
        SELECT
            date_format(order_date, 'yyyy-MM') AS month,
            customer_id,
            SUM(total_amount) AS revenue
        FROM orders
        GROUP BY 1, 2
    )
    SELECT
        month,
        COUNT(DISTINCT customer_id) AS active_customers,
        SUM(revenue) AS total_revenue,
        PERCENTILE_APPROX(revenue, 0.5) AS median_customer_revenue
    FROM monthly_revenue
    GROUP BY month
    ORDER BY month
""")
```

---

## Structured Streaming

### Kafka to Delta Pipeline

```python
# Read from Kafka
stream_df = (
    spark
    .readStream
    .format("kafka")
    .option("kafka.bootstrap.servers", "kafka:9092")
    .option("subscribe", "orders.order.created")
    .option("startingOffsets", "latest")
    .option("maxOffsetsPerTrigger", 10000)
    .option("failOnDataLoss", "false")
    .load()
)

# Parse Avro payload
from pyspark.sql.avro.functions import from_avro

parsed = (
    stream_df
    .select(
        F.col("key").cast("string").alias("order_id"),
        from_avro(F.col("value"), schema_str).alias("data"),
        F.col("timestamp").alias("kafka_timestamp"),
    )
    .select("order_id", "data.*", "kafka_timestamp")
)

# Write to Delta with checkpoint
query = (
    parsed
    .writeStream
    .format("delta")
    .outputMode("append")
    .option("checkpointLocation", "s3a://data-lake/checkpoints/orders/")
    .option("mergeSchema", "true")
    .trigger(processingTime="30 seconds")
    .start("s3a://data-lake/delta/orders_stream/")
)
```

### Watermark and Window Aggregation

```python
windowed = (
    parsed
    .withWatermark("kafka_timestamp", "10 minutes")
    .groupBy(
        F.window("kafka_timestamp", "5 minutes", "1 minute"),
        "product_id"
    )
    .agg(
        F.count("order_id").alias("order_count"),
        F.sum("total_amount").alias("revenue"),
    )
)
```

---

## Performance Optimization

### Optimization Checklist

| Technique | When to Use | Impact |
|-----------|------------|--------|
| Adaptive Query Execution (AQE) | Always on Spark 3.x+ | Auto-coalesce, skew handling |
| Broadcast join | Small table < 100MB | Eliminate shuffle |
| Bucketing | Repeated joins on same key | Pre-sorted join |
| Partition pruning | Date-partitioned reads | Skip irrelevant files |
| Predicate pushdown | Filter before join/agg | Reduce data scanned |
| Cache/persist | Reused DataFrame | Avoid recomputation |
| Coalesce vs repartition | Reduce partitions | Coalesce (no shuffle) |

### Broadcast Join

```python
from pyspark.sql.functions import broadcast

# Small dimension table join
enriched = orders.join(
    broadcast(products),
    "product_id",
    "left"
)
```

### Bucketing for Repeated Joins

```python
# Write bucketed table
(
    orders
    .write
    .bucketBy(64, "customer_id")
    .sortBy("customer_id")
    .saveAsTable("orders_bucketed")
)

# Join without shuffle
bucketed_orders = spark.table("orders_bucketed")
bucketed_customers = spark.table("customers_bucketed")
result = bucketed_orders.join(bucketed_customers, "customer_id")
```

### Handling Data Skew

```python
# Salt key to distribute skewed partition
from pyspark.sql.functions import concat, lit, ceil, rand

salt_factor = 10

salted_orders = orders.withColumn(
    "salted_key",
    concat(F.col("customer_id"), lit("_"), ceil(rand() * salt_factor).cast("int"))
)

salted_customers = customers.crossJoin(
    spark.range(1, salt_factor + 1).withColumnRenamed("id", "salt")
).withColumn(
    "salted_key",
    concat(F.col("customer_id"), lit("_"), F.col("salt").cast("int"))
)

result = salted_orders.join(salted_customers, "salted_key").drop("salted_key", "salt")
```

### Explain Plan Analysis

```python
# Check physical plan
df.explain("formatted")

# Look for:
#   Exchange (shuffle) - minimize these
#   BroadcastHashJoin - good for small tables
#   SortMergeJoin - expected for large-large joins
#   FileScan - check pushed filters
```

---

## Delta Lake

### Table Management

```python
# Create Delta table
(
    spark.createDataFrame([], schema=order_schema)
    .write.format("delta")
    .save("s3a://data-lake/delta/orders/")
)

# Time travel
df_yesterday = (
    spark.read.format("delta")
    .option("timestampAsOf", "2026-03-05")
    .load("s3a://data-lake/delta/orders/")
)

df_version = (
    spark.read.format("delta")
    .option("versionAsOf", 42)
    .load("s3a://data-lake/delta/orders/")
)

# Optimize (compaction)
from delta.tables import DeltaTable
dt = DeltaTable.forPath(spark, "s3a://data-lake/delta/orders/")
dt.optimize().executeCompaction()

# Z-order for query performance
dt.optimize().executeZOrderBy("customer_id", "order_date")

# Vacuum old versions
dt.vacuum(168)  # hours to retain (7 days)

# History
dt.history(10).show()
```

### Schema Evolution

```python
# Auto-merge schema on write
(
    new_data
    .write.format("delta")
    .mode("append")
    .option("mergeSchema", "true")
    .save("s3a://data-lake/delta/orders/")
)
```

---

## Spark Submit and Deployment

```bash
# Submit to YARN
spark-submit \
  --master yarn \
  --deploy-mode cluster \
  --driver-memory 4g \
  --executor-memory 8g \
  --executor-cores 4 \
  --num-executors 10 \
  --conf spark.sql.adaptive.enabled=true \
  --conf spark.dynamicAllocation.enabled=true \
  --conf spark.dynamicAllocation.minExecutors=5 \
  --conf spark.dynamicAllocation.maxExecutors=50 \
  --packages io.delta:delta-spark_2.12:3.1.0 \
  jobs/daily_aggregation.py \
  --date 2026-03-06

# Submit to Kubernetes
spark-submit \
  --master k8s://https://k8s-api:6443 \
  --deploy-mode cluster \
  --conf spark.kubernetes.container.image=registry/spark:3.5 \
  --conf spark.kubernetes.namespace=spark-jobs \
  --conf spark.kubernetes.driver.request.cores=2 \
  --conf spark.kubernetes.executor.request.cores=4 \
  jobs/daily_aggregation.py
```

---

## Testing Spark Jobs

```python
import pytest
from pyspark.sql import SparkSession
from pyspark.testing.utils import assertDataFrameEqual

@pytest.fixture(scope="session")
def spark():
    return (
        SparkSession.builder
        .master("local[2]")
        .appName("tests")
        .config("spark.sql.shuffle.partitions", "2")
        .getOrCreate()
    )

def test_clean_removes_negative_quantities(spark):
    input_df = spark.createDataFrame([
        ("o1", "c1", 5, 10.0),
        ("o2", "c2", -1, 20.0),
    ], ["order_id", "customer_id", "quantity", "unit_price"])

    result = clean_orders(input_df)

    expected = spark.createDataFrame([
        ("o1", "c1", 5, 10.0),
    ], ["order_id", "customer_id", "quantity", "unit_price"])

    assertDataFrameEqual(result, expected)
```

---

## Cross-References

- `3-build/kafka_event_streaming` - Kafka as streaming source for Spark
- `3-build/airflow_orchestration` - Schedule Spark jobs via Airflow DAGs
- `3-build/database_migration_patterns` - Delta Lake schema evolution patterns

---

## EXIT CHECKLIST

- [ ] Schema explicitly defined (not inferred) for production jobs
- [ ] Adaptive Query Execution enabled (spark.sql.adaptive.enabled)
- [ ] Shuffle partitions tuned for data volume
- [ ] Broadcast joins used for small dimension tables (< 100MB)
- [ ] Streaming jobs have checkpoint location configured
- [ ] Delta Lake tables optimized (compaction) and vacuumed on schedule
- [ ] Data skew handled with salting or AQE skew join
- [ ] Idempotent writes (overwrite partitions or Delta merge)
- [ ] Unit tests validate transforms with local SparkSession
- [ ] Resource configuration (executors, memory) tuned via Spark UI metrics
- [ ] Dynamic allocation enabled for variable workloads

---

*Skill Version: 1.0 | Created: March 2026*
