---
name: Airflow Orchestration
description: Apache Airflow DAG design, operators, sensors, XCom, connections, pools, and production best practices
---

# Airflow Orchestration Skill

**Purpose**: Design and operate production-grade Apache Airflow DAGs with proper task dependencies, operator selection, XCom data passing, connection management, and monitoring.

---

## TRIGGER COMMANDS

```text
"Create an Airflow DAG"
"Orchestrate a data pipeline"
"Schedule a workflow with Airflow"
"Set up Airflow operators and sensors"
"Using airflow_orchestration skill: [task]"
```

---

## DAG Structure

### Production DAG Template

```python
from datetime import datetime, timedelta
from airflow.decorators import dag, task
from airflow.operators.empty import EmptyOperator
from airflow.utils.trigger_rule import TriggerRule

default_args = {
    "owner": "data-team",
    "depends_on_past": False,
    "email_on_failure": True,
    "email": ["data-alerts@example.com"],
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
    "retry_exponential_backoff": True,
    "max_retry_delay": timedelta(minutes=30),
    "execution_timeout": timedelta(hours=2),
    "sla": timedelta(hours=4),
}

@dag(
    dag_id="daily_order_pipeline",
    default_args=default_args,
    description="Daily order data pipeline: extract, transform, load to warehouse",
    schedule="0 6 * * *",          # 6 AM UTC daily
    start_date=datetime(2026, 1, 1),
    catchup=False,
    max_active_runs=1,
    tags=["orders", "warehouse", "daily"],
    doc_md="""
    ## Daily Order Pipeline
    Extracts orders from PostgreSQL, transforms, and loads to warehouse.
    - **Owner**: data-team
    - **SLA**: Completes by 10 AM UTC
    - **On failure**: Alerts #data-alerts Slack channel
    """,
)
def daily_order_pipeline():

    start = EmptyOperator(task_id="start")

    @task()
    def extract_orders(**context):
        execution_date = context["ds"]
        # Extract logic here
        return {"record_count": 15000, "date": execution_date}

    @task()
    def validate_data(extract_result: dict):
        if extract_result["record_count"] == 0:
            raise ValueError(f"No records for {extract_result['date']}")
        return extract_result

    @task()
    def transform_orders(extract_result: dict):
        # Transform logic
        return {"transformed_count": extract_result["record_count"]}

    @task()
    def load_to_warehouse(transform_result: dict):
        # Load logic
        return {"loaded_count": transform_result["transformed_count"]}

    @task(trigger_rule=TriggerRule.ALL_DONE)
    def send_notification(load_result: dict):
        # Notification logic
        pass

    end = EmptyOperator(task_id="end", trigger_rule=TriggerRule.NONE_FAILED_MIN_ONE_SUCCESS)

    extracted = extract_orders()
    validated = validate_data(extracted)
    transformed = transform_orders(validated)
    loaded = load_to_warehouse(transformed)
    notified = send_notification(loaded)

    start >> extracted
    notified >> end

daily_order_pipeline()
```

---

## Operators

### Operator Selection Guide

| Operator | Use Case | Execution |
|----------|----------|-----------|
| PythonOperator / @task | Python callable | In Airflow worker |
| BashOperator | Shell commands | In Airflow worker |
| SparkSubmitOperator | Spark jobs | Spark cluster |
| KubernetesPodOperator | Any container | K8s cluster |
| DockerOperator | Any container | Docker host |
| PostgresOperator | SQL queries | PostgreSQL |
| S3ToRedshiftOperator | S3 to Redshift | AWS |
| DbtCloudRunJobOperator | dbt jobs | dbt Cloud |
| EmptyOperator | DAG structure, branching | No execution |
| TriggerDagRunOperator | Cross-DAG trigger | Triggers child DAG |

### KubernetesPodOperator (Recommended for Isolation)

```python
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)

transform = KubernetesPodOperator(
    task_id="transform_orders",
    namespace="airflow-jobs",
    image="registry.example.com/transform:1.2.0",
    cmds=["python", "transform.py"],
    arguments=["--date", "{{ ds }}"],
    env_vars={
        "DB_HOST": "{{ conn.warehouse.host }}",
    },
    secrets=[
        Secret("env", "DB_PASSWORD", "warehouse-creds", "password"),
    ],
    resources=k8s.V1ResourceRequirements(
        requests={"cpu": "500m", "memory": "1Gi"},
        limits={"cpu": "2", "memory": "4Gi"},
    ),
    is_delete_operator_pod=True,
    get_logs=True,
    startup_timeout_seconds=300,
    retries=2,
)
```

### SparkSubmitOperator

```python
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator

spark_job = SparkSubmitOperator(
    task_id="spark_aggregation",
    application="s3a://jobs/daily_aggregation.py",
    conn_id="spark_default",
    application_args=["--date", "{{ ds }}"],
    conf={
        "spark.executor.memory": "8g",
        "spark.executor.cores": "4",
        "spark.dynamicAllocation.enabled": "true",
    },
    packages="io.delta:delta-spark_2.12:3.1.0",
    verbose=False,
)
```

---

## Sensors

### Sensor Types

| Sensor | Waits For | Mode |
|--------|----------|------|
| S3KeySensor | S3 object exists | poke / reschedule |
| ExternalTaskSensor | Another DAG/task | poke / reschedule |
| HttpSensor | HTTP endpoint returns OK | poke / reschedule |
| SqlSensor | SQL query returns rows | poke / reschedule |
| DateTimeSensor | Specific datetime | reschedule |
| FileSensor | Local file exists | poke |

### Sensor Best Practices

```python
from airflow.providers.amazon.aws.sensors.s3 import S3KeySensor

wait_for_data = S3KeySensor(
    task_id="wait_for_raw_data",
    bucket_name="data-lake",
    bucket_key="raw/orders/dt={{ ds }}/_SUCCESS",
    aws_conn_id="aws_default",
    mode="reschedule",           # Free worker slot while waiting
    poke_interval=300,           # Check every 5 minutes
    timeout=7200,                # Fail after 2 hours
    soft_fail=False,             # Hard fail on timeout
    exponential_backoff=True,
)
```

> **Warning**: Always use `mode="reschedule"` for long-wait sensors. `mode="poke"` holds a worker slot the entire time, consuming pool capacity.

---

## XCom (Cross-Communication)

### TaskFlow API (Recommended)

```python
@task()
def extract():
    return {"count": 1000, "path": "s3://bucket/data/"}

@task()
def transform(data: dict):
    # data is automatically deserialized from XCom
    return {"count": data["count"], "output": "s3://bucket/transformed/"}

@task()
def load(data: dict):
    print(f"Loading {data['count']} records from {data['output']}")

# Automatic XCom wiring
data = extract()
transformed = transform(data)
load(transformed)
```

### XCom Backend for Large Data

```python
# airflow.cfg - use S3 for XCom backend (large payloads)
# [core]
# xcom_backend = airflow.providers.amazon.aws.xcom_backend.S3XComBackend

# Or set env var
# AIRFLOW__CORE__XCOM_BACKEND=airflow.providers.amazon.aws.xcom_backend.S3XComBackend
```

> **Tip**: Keep XCom values small (< 48KB for default DB backend). Pass file paths or S3 URIs instead of raw data. Use a custom XCom backend for larger payloads.

---

## Connections and Variables

### Connection Setup (CLI)

```bash
# Add PostgreSQL connection
airflow connections add 'warehouse' \
  --conn-type 'postgres' \
  --conn-host 'warehouse.example.com' \
  --conn-port 5432 \
  --conn-schema 'analytics' \
  --conn-login 'airflow' \
  --conn-password 'secret'

# Add AWS connection
airflow connections add 'aws_default' \
  --conn-type 'aws' \
  --conn-extra '{"region_name": "us-east-1", "role_arn": "arn:aws:iam::123456789:role/airflow"}'

# Add Slack webhook
airflow connections add 'slack_webhook' \
  --conn-type 'http' \
  --conn-host 'https://hooks.slack.com/services' \
  --conn-password '/T00000/B00000/XXXXXXX'
```

### Secrets Backend (Production)

```python
# airflow.cfg
# [secrets]
# backend = airflow.providers.amazon.aws.secrets.secrets_manager.SecretsManagerBackend
# backend_kwargs = {"connections_prefix": "airflow/connections",
#                   "variables_prefix": "airflow/variables"}
```

---

## Pools and Concurrency

### Pool Configuration

```bash
# Create pool to limit concurrent DB connections
airflow pools set db_pool 5 "Limit concurrent database queries"

# Create pool for external API rate limits
airflow pools set api_pool 3 "Rate-limited external API"
```

### Using Pools in Tasks

```python
@task(pool="db_pool", pool_slots=1, priority_weight=10)
def heavy_query():
    # This task respects the db_pool limit
    pass
```

### Concurrency Hierarchy

```
Airflow Instance
  parallelism = 32                    # Max total active tasks

DAG
  max_active_runs = 3                 # Max concurrent DAG runs
  max_active_tasks = 16               # Max concurrent tasks per DAG

Task
  max_active_tis_per_dag = 2          # Max concurrent instances of this task
  pool = "db_pool" (size=5)           # Pool-level concurrency
  pool_slots = 1                      # Slots consumed per task
```

---

## Branching and Dynamic DAGs

### Branching

```python
from airflow.operators.python import BranchPythonOperator

def choose_branch(**context):
    record_count = context["ti"].xcom_pull(task_ids="extract")["count"]
    if record_count > 10000:
        return "heavy_transform"
    return "light_transform"

branch = BranchPythonOperator(
    task_id="branch_on_size",
    python_callable=choose_branch,
)

# Both paths converge at join
join = EmptyOperator(task_id="join", trigger_rule=TriggerRule.NONE_FAILED_MIN_ONE_SUCCESS)

branch >> [heavy_transform, light_transform] >> join
```

### Dynamic Task Mapping (Airflow 2.3+)

```python
@task()
def get_partitions():
    return ["2026-03-01", "2026-03-02", "2026-03-03"]

@task()
def process_partition(partition: str):
    print(f"Processing {partition}")

partitions = get_partitions()
process_partition.expand(partition=partitions)
```

---

## Monitoring and Alerting

### SLA and Callbacks

```python
def sla_miss_callback(dag, task_list, blocking_task_list, slas, blocking_tis):
    slack_alert(f"SLA missed for DAG {dag.dag_id}: {task_list}")

def failure_callback(context):
    task_id = context["task_instance"].task_id
    dag_id = context["dag"].dag_id
    execution_date = context["ds"]
    slack_alert(f"Task {dag_id}.{task_id} failed on {execution_date}")

@dag(
    sla_miss_callback=sla_miss_callback,
    on_failure_callback=failure_callback,
)
```

### Key Metrics to Monitor

| Metric | Alert Threshold | Meaning |
|--------|----------------|---------|
| DAG run duration | > 2x median | Performance degradation |
| Task failure rate | > 5% | Reliability issue |
| Scheduler heartbeat | Missing > 60s | Scheduler down |
| Pool slot utilization | > 90% sustained | Pool bottleneck |
| DAG bag parse time | > 30s | DAG code complexity |
| Queued tasks | > 100 sustained | Worker capacity issue |

---

## Project Structure Best Practices

```
dags/
  common/
    callbacks.py          # Shared callbacks
    operators.py          # Custom operators
    sensors.py            # Custom sensors
  orders/
    daily_order_pipeline.py
    order_backfill.py
  analytics/
    weekly_report.py
  __init__.py

plugins/
  hooks/
    custom_hook.py
  operators/
    custom_operator.py

tests/
  dags/
    test_daily_order_pipeline.py
  conftest.py
```

### DAG Testing

```python
import pytest
from airflow.models import DagBag

@pytest.fixture(scope="session")
def dagbag():
    return DagBag(include_examples=False)

def test_dag_loaded(dagbag):
    assert "daily_order_pipeline" in dagbag.dags
    assert dagbag.import_errors == {}

def test_dag_has_correct_schedule(dagbag):
    dag = dagbag.get_dag("daily_order_pipeline")
    assert dag.schedule_interval == "0 6 * * *"

def test_dag_has_no_cycles(dagbag):
    dag = dagbag.get_dag("daily_order_pipeline")
    assert not dag.test_cycle()

def test_task_count(dagbag):
    dag = dagbag.get_dag("daily_order_pipeline")
    assert len(dag.tasks) == 7
```

---

## Cross-References

- `3-build/spark_data_processing` - Run Spark jobs from Airflow DAGs
- `3-build/kafka_event_streaming` - Event-driven triggers instead of scheduled
- `3-build/database_migration_patterns` - Run migrations as Airflow tasks

---

## EXIT CHECKLIST

- [ ] DAG has explicit `schedule`, `start_date`, and `catchup=False`
- [ ] `default_args` include retries, retry_delay, and execution_timeout
- [ ] Owner and tags set for DAG discoverability
- [ ] Sensors use `mode="reschedule"` (not poke for long waits)
- [ ] XCom payloads are small (paths, not data blobs)
- [ ] Pools configured for resource-constrained operations
- [ ] Failure and SLA-miss callbacks configured
- [ ] Dynamic task mapping used instead of generating tasks in loops
- [ ] Connections stored in secrets backend (not environment variables)
- [ ] DAG import/cycle tests pass
- [ ] `max_active_runs=1` for DAGs that must not overlap

---

*Skill Version: 1.0 | Created: March 2026*
