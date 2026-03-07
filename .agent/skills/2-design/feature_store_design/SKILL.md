---
name: Feature Store Design
description: Design and implement feature stores with Feast, Tecton, and Hopsworks for online/offline serving
---

# Feature Store Design Skill

**Purpose**: Design and implement feature store architectures that unify feature engineering, versioning, and serving for both training (offline) and inference (online) with consistent, low-latency access.

---

## TRIGGER COMMANDS

```text
"Design a feature store for this ML system"
"Set up online and offline feature serving"
"Implement feature pipelines with versioning"
"Using feature_store_design skill: [task]"
```

---

## Feature Store Architecture

```
+-------------------+     +-------------------+     +-------------------+
|   Data Sources    |     |   Feature Store   |     |   Consumers       |
+-------------------+     +-------------------+     +-------------------+
|                   |     |                   |     |                   |
| Event streams  ---+---->| Feature Pipeline  +---->| Training jobs     |
| (Kafka, Kinesis)  |     |   (compute)       |     |   (offline)       |
|                   |     |                   |     |                   |
| Databases      ---+---->| Offline Store     +---->| Batch prediction  |
| (PostgreSQL, S3)  |     |   (warehouse)     |     |   (offline)       |
|                   |     |                   |     |                   |
| APIs           ---+---->| Online Store      +---->| Real-time serving |
| (REST, gRPC)      |     |   (Redis/DynamoDB)|     |   (online)        |
|                   |     |                   |     |                   |
| Batch files    ---+---->| Feature Registry  +---->| Feature discovery |
| (Parquet, CSV)    |     |   (metadata)      |     |   (data catalog)  |
+-------------------+     +-------------------+     +-------------------+
```

---

## Platform Comparison

| Feature | Feast | Tecton | Hopsworks | Custom (Redis+Warehouse) |
|---------|-------|--------|-----------|--------------------------|
| Open source | Yes (Apache 2.0) | No (proprietary) | Yes (AGPL) | N/A |
| Online store | Redis, DynamoDB, etc. | Built-in (managed) | RonDB | Redis, DynamoDB |
| Offline store | BigQuery, Redshift, S3 | Built-in (Spark) | Hudi on S3 | Data warehouse |
| Streaming ingestion | Push-based | Native Spark/Flink | Kafka integration | Custom |
| Point-in-time joins | Yes | Yes | Yes | Manual |
| Feature monitoring | Basic | Advanced | Advanced | Custom |
| Managed service | Tecton Cloud | Tecton Cloud | Hopsworks.ai | Self-managed |
| Complexity | Low-medium | Medium | Medium-high | High |
| Best for | Getting started, OSS | Enterprise, real-time | Full MLOps platform | Full control |

### Decision Guide

```
Need open-source + simple?            --> Feast
Need enterprise managed service?      --> Tecton
Need full MLOps platform?             --> Hopsworks
Need maximum control + existing infra?--> Custom (Redis + warehouse)
Budget-constrained?                   --> Feast (self-hosted)
Real-time streaming features?         --> Tecton or Hopsworks
Already on GCP?                       --> Feast + BigQuery
Already on AWS?                       --> Feast + Redshift/DynamoDB
```

---

## Feast Implementation

### Project Setup

```bash
pip install feast[redis,aws]

# Initialize Feast project
feast init feature_store
cd feature_store
```

### Feature Definition

```python
# feature_store/feature_definitions.py
from datetime import timedelta
from feast import (
    Entity,
    FeatureService,
    FeatureView,
    Field,
    FileSource,
    RedisOnlineStore,
    PushSource,
)
from feast.types import Float32, Float64, Int64, String

# Define entities
customer = Entity(
    name="customer",
    join_keys=["customer_id"],
    description="Customer entity for churn prediction",
)

# Define data source (offline)
customer_features_source = FileSource(
    name="customer_features_source",
    path="data/customer_features.parquet",
    timestamp_field="event_timestamp",
    created_timestamp_column="created_timestamp",
)

# Define feature view
customer_features = FeatureView(
    name="customer_features",
    entities=[customer],
    ttl=timedelta(days=90),
    schema=[
        Field(name="total_purchases", dtype=Int64),
        Field(name="avg_order_value", dtype=Float64),
        Field(name="days_since_last_purchase", dtype=Int64),
        Field(name="total_support_tickets", dtype=Int64),
        Field(name="avg_session_duration_min", dtype=Float64),
        Field(name="plan_type", dtype=String),
        Field(name="monthly_spend", dtype=Float64),
        Field(name="lifetime_value", dtype=Float64),
    ],
    online=True,
    source=customer_features_source,
    tags={"team": "ml-platform", "version": "v2"},
)

# Real-time feature view (push-based)
customer_activity_push = PushSource(
    name="customer_activity_push",
    batch_source=customer_features_source,
)

customer_realtime_features = FeatureView(
    name="customer_realtime_features",
    entities=[customer],
    ttl=timedelta(hours=1),
    schema=[
        Field(name="session_count_last_hour", dtype=Int64),
        Field(name="pages_viewed_last_hour", dtype=Int64),
        Field(name="cart_value", dtype=Float64),
    ],
    online=True,
    source=customer_activity_push,
)

# Feature service (groups features for a use case)
churn_prediction_service = FeatureService(
    name="churn_prediction",
    features=[
        customer_features,
        customer_realtime_features,
    ],
    description="Features for customer churn prediction model",
    tags={"model": "churn-classifier-v3"},
)
```

### Feature Store Configuration

```yaml
# feature_store/feature_store.yaml
project: customer_ml
registry: data/registry.db
provider: aws

online_store:
  type: redis
  connection_string: "redis://localhost:6379"

offline_store:
  type: file  # or bigquery, redshift, snowflake

entity_key_serialization_version: 2
```

### Materialization and Serving

```python
from feast import FeatureStore
from datetime import datetime, timedelta
import pandas as pd

store = FeatureStore(repo_path="feature_store/")

# Apply feature definitions
store.apply([customer, customer_features, customer_realtime_features, churn_prediction_service])

# Materialize features to online store
store.materialize(
    start_date=datetime.utcnow() - timedelta(days=7),
    end_date=datetime.utcnow(),
)

# Incremental materialization (for scheduled runs)
store.materialize_incremental(end_date=datetime.utcnow())

# --- Online serving (real-time inference) ---
online_features = store.get_online_features(
    features=[
        "customer_features:total_purchases",
        "customer_features:avg_order_value",
        "customer_features:monthly_spend",
        "customer_realtime_features:session_count_last_hour",
    ],
    entity_rows=[
        {"customer_id": "C001"},
        {"customer_id": "C002"},
    ],
).to_dict()

print(online_features)

# --- Offline serving (training data with point-in-time joins) ---
entity_df = pd.DataFrame({
    "customer_id": ["C001", "C002", "C003", "C001"],
    "event_timestamp": [
        datetime(2026, 1, 15),
        datetime(2026, 1, 15),
        datetime(2026, 2, 1),
        datetime(2026, 2, 1),
    ],
    "label": [0, 1, 0, 1],
})

training_df = store.get_historical_features(
    entity_df=entity_df,
    features=[
        "customer_features:total_purchases",
        "customer_features:avg_order_value",
        "customer_features:monthly_spend",
        "customer_features:lifetime_value",
    ],
).to_df()

print(f"Training data shape: {training_df.shape}")
print(training_df.head())
```

### Push Features (Real-Time)

```python
from feast import FeatureStore
import pandas as pd
from datetime import datetime

store = FeatureStore(repo_path="feature_store/")

# Push real-time features
event_df = pd.DataFrame({
    "customer_id": ["C001"],
    "session_count_last_hour": [5],
    "pages_viewed_last_hour": [23],
    "cart_value": [149.99],
    "event_timestamp": [datetime.utcnow()],
})

store.push("customer_activity_push", event_df, to=PushMode.ONLINE)
```

---

## Point-in-Time Joins

### Why Point-in-Time Joins Matter

```
Without point-in-time joins (DATA LEAKAGE):
  Training row timestamp: Jan 15
  Feature fetched:        Feb 1 value (FUTURE DATA LEAKED!)

With point-in-time joins (CORRECT):
  Training row timestamp: Jan 15
  Feature fetched:        Jan 14 value (latest BEFORE event)
```

### Manual Point-in-Time Join (Without Feature Store)

```python
import pandas as pd

def point_in_time_join(
    entity_df: pd.DataFrame,
    feature_df: pd.DataFrame,
    entity_key: str,
    entity_timestamp: str,
    feature_timestamp: str,
) -> pd.DataFrame:
    """Perform point-in-time join to prevent data leakage."""
    # Sort both by timestamp
    entity_sorted = entity_df.sort_values(entity_timestamp)
    feature_sorted = feature_df.sort_values(feature_timestamp)

    # Merge with asof join (get latest feature BEFORE entity timestamp)
    result = pd.merge_asof(
        entity_sorted,
        feature_sorted,
        left_on=entity_timestamp,
        right_on=feature_timestamp,
        by=entity_key,
        direction="backward",  # Get most recent feature BEFORE entity time
    )

    return result

# Usage
training_data = point_in_time_join(
    entity_df=labels_df,        # Columns: customer_id, event_timestamp, label
    feature_df=features_df,     # Columns: customer_id, feature_timestamp, feature_1, ...
    entity_key="customer_id",
    entity_timestamp="event_timestamp",
    feature_timestamp="feature_timestamp",
)
```

---

## Feature Pipeline Patterns

### Batch Feature Pipeline

```python
# feature_pipelines/batch_customer_features.py
import pandas as pd
from datetime import datetime, timedelta

def compute_customer_features(
    orders_df: pd.DataFrame,
    support_df: pd.DataFrame,
    sessions_df: pd.DataFrame,
    as_of_date: datetime,
) -> pd.DataFrame:
    """Compute batch customer features as of a specific date."""
    # Filter to data before as_of_date
    orders = orders_df[orders_df["order_date"] < as_of_date]
    support = support_df[support_df["ticket_date"] < as_of_date]
    sessions = sessions_df[sessions_df["session_date"] < as_of_date]

    # Aggregate features per customer
    customer_orders = orders.groupby("customer_id").agg(
        total_purchases=("order_id", "count"),
        avg_order_value=("order_amount", "mean"),
        total_spend=("order_amount", "sum"),
        last_purchase_date=("order_date", "max"),
    ).reset_index()

    customer_support = support.groupby("customer_id").agg(
        total_support_tickets=("ticket_id", "count"),
    ).reset_index()

    customer_sessions = sessions.groupby("customer_id").agg(
        avg_session_duration_min=("duration_min", "mean"),
        total_sessions=("session_id", "count"),
    ).reset_index()

    # Merge all features
    features = customer_orders.merge(customer_support, on="customer_id", how="left")
    features = features.merge(customer_sessions, on="customer_id", how="left")

    # Derived features
    features["days_since_last_purchase"] = (
        as_of_date - features["last_purchase_date"]
    ).dt.days
    features["monthly_spend"] = features["total_spend"] / max(
        (as_of_date - orders["order_date"].min()).days / 30, 1
    )

    # Fill nulls
    features = features.fillna(0)

    # Add metadata
    features["event_timestamp"] = as_of_date
    features["created_timestamp"] = datetime.utcnow()

    return features
```

### Streaming Feature Pipeline

```python
# feature_pipelines/streaming_activity_features.py
from collections import defaultdict
from datetime import datetime, timedelta

class StreamingActivityFeatures:
    """Compute real-time activity features from event stream."""

    def __init__(self, window_minutes: int = 60):
        self.window = timedelta(minutes=window_minutes)
        self.events: dict[str, list] = defaultdict(list)

    def process_event(self, customer_id: str, event_type: str, timestamp: datetime, metadata: dict = None):
        """Process a single event and update features."""
        self.events[customer_id].append({
            "type": event_type,
            "timestamp": timestamp,
            "metadata": metadata or {},
        })
        # Prune old events
        cutoff = timestamp - self.window
        self.events[customer_id] = [
            e for e in self.events[customer_id] if e["timestamp"] > cutoff
        ]

    def get_features(self, customer_id: str) -> dict:
        """Get current feature values for a customer."""
        events = self.events.get(customer_id, [])
        page_views = [e for e in events if e["type"] == "page_view"]
        cart_events = [e for e in events if e["type"] == "add_to_cart"]

        return {
            "customer_id": customer_id,
            "session_count_last_hour": len(set(
                e["metadata"].get("session_id") for e in events
                if "session_id" in e.get("metadata", {})
            )),
            "pages_viewed_last_hour": len(page_views),
            "cart_value": sum(
                e["metadata"].get("price", 0) for e in cart_events
            ),
            "event_timestamp": datetime.utcnow(),
        }
```

---

## Feature Versioning and Governance

### Feature Naming Conventions

```
Format: {domain}__{entity}__{feature_name}__{aggregation}__{window}

Examples:
  orders__customer__total_purchases__count__all_time
  orders__customer__avg_order_value__mean__90d
  sessions__customer__page_views__count__1h
  support__customer__tickets__count__30d
```

### Feature Documentation Template

```yaml
# feature_catalog/customer_features.yaml
feature_group: customer_features
owner: ml-platform-team
description: "Core customer features for churn and LTV prediction"
version: "2.3"
update_frequency: daily
sla_freshness: 6 hours

features:
  - name: total_purchases
    type: int64
    description: "Total number of orders placed by customer"
    source: orders table
    aggregation: COUNT(order_id)
    window: all-time
    null_handling: "0 for customers with no orders"
    monitoring:
      expected_range: [0, 10000]
      alert_on_null_rate: 0.01

  - name: avg_order_value
    type: float64
    description: "Average order amount in USD"
    source: orders table
    aggregation: AVG(order_amount)
    window: all-time
    null_handling: "0.0 for customers with no orders"
    monitoring:
      expected_range: [0, 50000]
      alert_on_drift: true

dependencies:
  tables: [orders, customers, sessions, support_tickets]
  pipelines: [daily-feature-pipeline]
```

---

## Serving Latency Optimization

| Strategy | Typical Latency | Use Case |
|----------|----------------|----------|
| Redis (in-memory) | 1-5ms | Real-time inference |
| DynamoDB | 5-15ms | Serverless, auto-scaling |
| Feature cache (local) | <1ms | High-throughput serving |
| Precomputed bundles | <1ms | Known entity sets |
| Warehouse direct query | 100ms-10s | Ad-hoc analysis only |

### Caching Layer

```python
from functools import lru_cache
import redis
import json
from datetime import timedelta

class FeatureCache:
    """Two-tier cache: local LRU + Redis."""

    def __init__(self, redis_url: str, local_max_size: int = 10000, ttl_seconds: int = 300):
        self.redis = redis.from_url(redis_url)
        self.ttl = ttl_seconds
        self._local_cache = {}
        self._local_max = local_max_size

    def get(self, entity_key: str, feature_names: list[str]) -> dict | None:
        # Check local cache first
        cache_key = f"features:{entity_key}"
        if cache_key in self._local_cache:
            cached = self._local_cache[cache_key]
            return {k: cached[k] for k in feature_names if k in cached}

        # Check Redis
        result = self.redis.get(cache_key)
        if result:
            features = json.loads(result)
            # Populate local cache
            if len(self._local_cache) < self._local_max:
                self._local_cache[cache_key] = features
            return {k: features[k] for k in feature_names if k in features}

        return None

    def set(self, entity_key: str, features: dict):
        cache_key = f"features:{entity_key}"
        self.redis.setex(cache_key, self.ttl, json.dumps(features))
        if len(self._local_cache) < self._local_max:
            self._local_cache[cache_key] = features
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track feature engineering experiments
- Related: `5-ship/mlops_pipeline` -- Integrate feature pipelines into MLOps workflows
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor feature drift in production
- Related: `3-build/synthetic_data_generation` -- Generate synthetic feature data for testing

---

## EXIT CHECKLIST

- [ ] Feature store platform selected based on team needs and infrastructure
- [ ] Entity definitions created for all ML use cases
- [ ] Feature views defined with correct TTLs and data sources
- [ ] Online store configured and tested for latency requirements
- [ ] Offline store connected to data warehouse for training data
- [ ] Point-in-time join correctness verified (no data leakage)
- [ ] Feature pipelines implemented (batch and/or streaming)
- [ ] Materialization schedule configured and running
- [ ] Feature documentation published in catalog
- [ ] Feature naming conventions established and followed
- [ ] Serving latency benchmarked and within SLA

---

*Skill Version: 1.0 | Created: March 2026*
