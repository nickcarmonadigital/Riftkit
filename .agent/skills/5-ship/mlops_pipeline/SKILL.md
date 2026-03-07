---
name: MLOps Pipeline
description: Build end-to-end MLOps pipelines with CI/CD for ML, model validation gates, automated retraining, and CT/CD/CM
---

# MLOps Pipeline Skill

**Purpose**: Design and implement end-to-end MLOps pipelines that automate the full ML lifecycle including continuous training (CT), continuous delivery (CD), continuous monitoring (CM), and model validation gates.

---

## TRIGGER COMMANDS

```text
"Build an MLOps pipeline for this ML project"
"Set up CI/CD for model training and deployment"
"Automate model retraining with validation gates"
"Using mlops_pipeline skill: [task]"
```

---

## MLOps Maturity Levels

| Level | Name | Characteristics | Automation |
|-------|------|----------------|------------|
| 0 | Manual | Jupyter notebooks, manual deployment | None |
| 1 | ML Pipeline | Automated training, manual deployment | Training only |
| 2 | CI/CD for ML | Automated testing + deployment | Training + deployment |
| 3 | CT/CD/CM | Auto-retraining, monitoring, rollback | Full lifecycle |
| 4 | Full Autonomy | Self-healing, auto-scaling, auto-optimization | Everything |

### Target Architecture (Level 3)

```
+--------+     +----------+     +----------+     +----------+     +-----------+
|        |     |          |     |          |     |          |     |           |
| Code   +---->+ CI/CD    +---->+ Training +---->+ Validate +---->+ Deploy    |
| Change |     | Pipeline |     | Pipeline |     | Gate     |     | Pipeline  |
|        |     |          |     |          |     |          |     |           |
+--------+     +----------+     +-----+----+     +-----+----+     +-----+-----+
                                      |                |                |
                                      v                v                v
                                +-----+----+     +-----+----+     +-----+-----+
                                | Experiment|     | Model    |     | Monitor   |
                                | Tracking  |     | Registry |     | + Alert   |
                                +-----------+     +----------+     +-----+-----+
                                                                        |
                                                       +----------------+
                                                       v
                                                 +-----+-----+
                                                 | Retrain   |
                                                 | Trigger   |
                                                 +-----------+
```

---

## Platform Comparison

| Feature | Kubeflow | Vertex AI | SageMaker | GitHub Actions | Airflow + Custom |
|---------|----------|-----------|-----------|----------------|------------------|
| Infrastructure | Kubernetes | GCP managed | AWS managed | Cloud runners | Self-hosted |
| Pipeline DSL | KFP Python SDK | KFP Python SDK | SageMaker SDK | YAML | Airflow DAGs |
| GPU support | Native (K8s) | Native | Native | Limited | Manual |
| Model serving | KServe | Vertex Endpoints | SageMaker Endpoints | Custom | Custom |
| Cost | K8s infra | Pay-per-use | Pay-per-use | Free tier + paid | Infra cost |
| Complexity | High | Medium | Medium | Low | Medium |
| Best for | K8s shops | GCP users | AWS users | Small-medium teams | Existing Airflow |

---

## GitHub Actions MLOps Pipeline

### Complete CI/CD for ML

```yaml
# .github/workflows/ml-pipeline.yml
name: ML Pipeline

on:
  push:
    branches: [main]
    paths:
      - "src/**"
      - "data/**"
      - "configs/**"
  schedule:
    - cron: "0 6 * * 1"  # Weekly retraining on Monday 6 AM UTC
  workflow_dispatch:
    inputs:
      force_retrain:
        description: "Force model retraining"
        type: boolean
        default: false

env:
  MODEL_NAME: churn-classifier
  PYTHON_VERSION: "3.11"

jobs:
  # Stage 1: Data Validation
  data-validation:
    runs-on: ubuntu-latest
    outputs:
      data_valid: ${{ steps.validate.outputs.valid }}
      data_hash: ${{ steps.validate.outputs.hash }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Validate data schema and quality
        id: validate
        run: |
          python scripts/validate_data.py \
            --config configs/data_validation.yaml \
            --output validation_report.json

          VALID=$(python -c "import json; r=json.load(open('validation_report.json')); print('true' if r['passed'] else 'false')")
          HASH=$(python -c "import hashlib; print(hashlib.md5(open('data/train.parquet','rb').read()).hexdigest()[:12])")
          echo "valid=$VALID" >> $GITHUB_OUTPUT
          echo "hash=$HASH" >> $GITHUB_OUTPUT

      - name: Upload validation report
        uses: actions/upload-artifact@v4
        with:
          name: data-validation-report
          path: validation_report.json

  # Stage 2: Model Training
  train:
    needs: data-validation
    if: needs.data-validation.outputs.data_valid == 'true'
    runs-on: ubuntu-latest
    outputs:
      run_id: ${{ steps.train.outputs.run_id }}
      model_version: ${{ steps.train.outputs.model_version }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Train model
        id: train
        env:
          MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
          MLFLOW_TRACKING_TOKEN: ${{ secrets.MLFLOW_TRACKING_TOKEN }}
        run: |
          python scripts/train.py \
            --config configs/training_config.yaml \
            --data-hash ${{ needs.data-validation.outputs.data_hash }} \
            --output train_output.json

          RUN_ID=$(python -c "import json; print(json.load(open('train_output.json'))['run_id'])")
          MODEL_VERSION=$(python -c "import json; print(json.load(open('train_output.json'))['model_version'])")
          echo "run_id=$RUN_ID" >> $GITHUB_OUTPUT
          echo "model_version=$MODEL_VERSION" >> $GITHUB_OUTPUT

      - name: Upload training artifacts
        uses: actions/upload-artifact@v4
        with:
          name: training-artifacts
          path: |
            train_output.json
            artifacts/

  # Stage 3: Model Validation Gate
  validate:
    needs: [data-validation, train]
    runs-on: ubuntu-latest
    outputs:
      approved: ${{ steps.gate.outputs.approved }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: Install dependencies
        run: pip install -r requirements.txt

      - name: Run validation gate
        id: gate
        env:
          MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
        run: |
          python scripts/validate_model.py \
            --run-id ${{ needs.train.outputs.run_id }} \
            --model-version ${{ needs.train.outputs.model_version }} \
            --config configs/validation_gate.yaml \
            --output validation_result.json

          APPROVED=$(python -c "import json; r=json.load(open('validation_result.json')); print('true' if r['approved'] else 'false')")
          echo "approved=$APPROVED" >> $GITHUB_OUTPUT

      - name: Upload validation results
        uses: actions/upload-artifact@v4
        with:
          name: validation-results
          path: validation_result.json

      - name: Post validation results to PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const results = JSON.parse(fs.readFileSync('validation_result.json'));
            const checks = Object.entries(results.checks)
              .map(([k, v]) => `| ${k} | ${v ? 'PASS' : 'FAIL'} |`)
              .join('\n');
            const body = `## Model Validation Results\n\n` +
              `| Check | Status |\n|-------|--------|\n${checks}\n\n` +
              `**Overall: ${results.approved ? 'APPROVED' : 'REJECTED'}**`;
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: body,
            });

  # Stage 4: Deploy to Staging
  deploy-staging:
    needs: [train, validate]
    if: needs.validate.outputs.approved == 'true'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to staging
        env:
          MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          python scripts/deploy.py \
            --model-version ${{ needs.train.outputs.model_version }} \
            --environment staging \
            --strategy canary \
            --canary-percent 10

      - name: Run smoke tests
        run: |
          python scripts/smoke_tests.py --environment staging

  # Stage 5: Deploy to Production
  deploy-production:
    needs: [train, validate, deploy-staging]
    if: needs.validate.outputs.approved == 'true'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to production
        env:
          MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          python scripts/deploy.py \
            --model-version ${{ needs.train.outputs.model_version }} \
            --environment production \
            --strategy blue-green \
            --rollback-on-failure
```

---

## Model Validation Gate Implementation

```python
# scripts/validate_model.py
import json
import argparse
import mlflow
from mlflow.tracking import MlflowClient

def run_validation_gate(run_id: str, model_version: int, config: dict) -> dict:
    """Run all validation checks before model promotion."""
    client = MlflowClient()
    run = client.get_run(run_id)
    metrics = run.data.metrics
    checks = {}

    # 1. Performance thresholds
    thresholds = config["performance_thresholds"]
    for metric_name, min_value in thresholds.items():
        actual = metrics.get(metric_name, 0)
        checks[f"threshold_{metric_name}"] = actual >= min_value

    # 2. No regression vs current production
    prod_versions = client.get_latest_versions(config["model_name"], stages=["Production"])
    if prod_versions:
        prod_run = client.get_run(prod_versions[0].run_id)
        prod_metrics = prod_run.data.metrics
        max_regression = config.get("max_regression", 0.02)
        for metric_name in thresholds:
            prod_val = prod_metrics.get(metric_name, 0)
            new_val = metrics.get(metric_name, 0)
            checks[f"no_regression_{metric_name}"] = new_val >= prod_val - max_regression
    else:
        checks["no_regression"] = True  # First model, no regression check

    # 3. Inference latency
    if "inference_p99_ms" in metrics:
        max_latency = config.get("max_latency_p99_ms", 100)
        checks["latency_within_sla"] = metrics["inference_p99_ms"] <= max_latency

    # 4. Model size
    if "model_size_mb" in metrics:
        max_size = config.get("max_model_size_mb", 500)
        checks["model_size_within_limit"] = metrics["model_size_mb"] <= max_size

    # 5. Required artifacts exist
    artifacts = [a.path for a in client.list_artifacts(run_id)]
    required = config.get("required_artifacts", [])
    for artifact in required:
        checks[f"artifact_{artifact}"] = artifact in artifacts

    # 6. Data quality checks passed
    data_hash = run.data.tags.get("data_hash", "")
    checks["data_hash_recorded"] = len(data_hash) > 0

    approved = all(checks.values())

    return {
        "approved": approved,
        "checks": checks,
        "metrics": {k: v for k, v in metrics.items()},
        "model_version": model_version,
        "run_id": run_id,
    }
```

### Validation Gate Configuration

```yaml
# configs/validation_gate.yaml
model_name: churn-classifier

performance_thresholds:
  f1_score: 0.85
  accuracy: 0.88
  precision: 0.82
  recall: 0.80

max_regression: 0.02  # Max allowed drop vs production
max_latency_p99_ms: 100
max_model_size_mb: 500

required_artifacts:
  - model
  - evaluation_report.json
  - feature_importance.csv

required_tags:
  - data_hash
  - git_commit
  - training_config_hash
```

---

## Kubeflow Pipelines

### Pipeline Definition

```python
from kfp import dsl
from kfp.dsl import Input, Output, Dataset, Model, Metrics, Artifact

@dsl.component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn", "pyarrow"],
)
def preprocess_data(
    raw_data: Input[Dataset],
    processed_data: Output[Dataset],
    metrics: Output[Metrics],
    test_split: float = 0.2,
):
    import pandas as pd
    from sklearn.model_selection import train_test_split

    df = pd.read_parquet(raw_data.path)

    # Preprocessing steps
    df = df.dropna(subset=["target"])
    df = df.fillna(0)

    # Split
    train_df, test_df = train_test_split(df, test_size=test_split, random_state=42)

    # Save
    train_df.to_parquet(f"{processed_data.path}/train.parquet")
    test_df.to_parquet(f"{processed_data.path}/test.parquet")

    metrics.log_metric("input_rows", len(df))
    metrics.log_metric("train_rows", len(train_df))
    metrics.log_metric("test_rows", len(test_df))

@dsl.component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn", "mlflow", "pyarrow"],
)
def train_model(
    processed_data: Input[Dataset],
    model_artifact: Output[Model],
    metrics: Output[Metrics],
    n_estimators: int = 100,
    max_depth: int = 10,
):
    import pandas as pd
    from sklearn.ensemble import GradientBoostingClassifier
    from sklearn.metrics import f1_score, accuracy_score
    import pickle

    train_df = pd.read_parquet(f"{processed_data.path}/train.parquet")
    test_df = pd.read_parquet(f"{processed_data.path}/test.parquet")

    feature_cols = [c for c in train_df.columns if c != "target"]
    X_train, y_train = train_df[feature_cols], train_df["target"]
    X_test, y_test = test_df[feature_cols], test_df["target"]

    model = GradientBoostingClassifier(n_estimators=n_estimators, max_depth=max_depth)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    f1 = f1_score(y_test, y_pred, average="weighted")
    acc = accuracy_score(y_test, y_pred)

    metrics.log_metric("f1_score", f1)
    metrics.log_metric("accuracy", acc)

    with open(model_artifact.path, "wb") as f:
        pickle.dump(model, f)

@dsl.component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn"],
)
def validate_model(
    model_artifact: Input[Model],
    metrics: Input[Metrics],
    f1_threshold: float = 0.85,
) -> bool:
    f1 = metrics.metadata.get("f1_score", 0)
    return f1 >= f1_threshold

@dsl.pipeline(
    name="churn-model-pipeline",
    description="End-to-end churn model training pipeline",
)
def churn_pipeline(
    raw_data_path: str = "gs://data/raw/customers.parquet",
    n_estimators: int = 100,
    max_depth: int = 10,
    f1_threshold: float = 0.85,
):
    preprocess_task = preprocess_data(
        raw_data=dsl.importer(artifact_uri=raw_data_path, artifact_class=Dataset),
    )

    train_task = train_model(
        processed_data=preprocess_task.outputs["processed_data"],
        n_estimators=n_estimators,
        max_depth=max_depth,
    )

    validate_task = validate_model(
        model_artifact=train_task.outputs["model_artifact"],
        metrics=train_task.outputs["metrics"],
        f1_threshold=f1_threshold,
    )

# Compile pipeline
from kfp import compiler
compiler.Compiler().compile(churn_pipeline, "churn_pipeline.yaml")
```

---

## Deployment Strategies

### Canary Deployment

```python
def deploy_canary(model_version: str, canary_percent: int = 10,
                  evaluation_period_hours: int = 4):
    """Deploy model as canary with gradual traffic shift."""
    config = {
        "model_version": model_version,
        "traffic_split": {
            "production": 100 - canary_percent,
            "canary": canary_percent,
        },
        "evaluation": {
            "period_hours": evaluation_period_hours,
            "success_criteria": {
                "error_rate_max": 0.01,
                "latency_p99_max_ms": 100,
                "performance_regression_max": 0.02,
            },
        },
        "rollback_on_failure": True,
    }
    return config
```

### Blue-Green Deployment

```python
def deploy_blue_green(model_version: str):
    """Blue-green deployment with instant cutover."""
    steps = [
        "1. Deploy new model to green environment",
        "2. Run smoke tests on green",
        "3. Switch load balancer to green",
        "4. Monitor for 30 minutes",
        "5. If healthy: decommission blue",
        "6. If unhealthy: switch back to blue (rollback)",
    ]
    return steps
```

---

## Automated Retraining Pipeline

```python
# scripts/retraining_trigger.py

def check_retraining_needed(config: dict) -> dict:
    """Check if model retraining should be triggered."""
    triggers = []

    # 1. Scheduled retraining
    last_trained = get_last_training_date(config["model_name"])
    days_since = (datetime.utcnow() - last_trained).days
    if days_since >= config.get("max_days_between_training", 30):
        triggers.append({
            "type": "scheduled",
            "reason": f"Model is {days_since} days old (max: {config['max_days_between_training']})",
        })

    # 2. Performance degradation
    current_metrics = get_latest_monitoring_metrics(config["model_name"])
    if current_metrics.get("f1_score", 1.0) < config.get("min_f1_score", 0.85):
        triggers.append({
            "type": "performance",
            "reason": f"F1 dropped to {current_metrics['f1_score']:.3f}",
        })

    # 3. Data drift
    drift_report = get_latest_drift_report(config["model_name"])
    if drift_report.get("drift_share", 0) > config.get("max_drift_share", 0.3):
        triggers.append({
            "type": "drift",
            "reason": f"Data drift at {drift_report['drift_share']:.1%} of features",
        })

    # 4. New data volume
    new_samples = get_new_labeled_samples_count(config["model_name"])
    if new_samples >= config.get("retrain_on_new_samples", 10000):
        triggers.append({
            "type": "data_volume",
            "reason": f"{new_samples} new labeled samples available",
        })

    return {
        "should_retrain": len(triggers) > 0,
        "triggers": triggers,
        "timestamp": datetime.utcnow().isoformat(),
    }
```

---

## Data Validation Script

```python
# scripts/validate_data.py
import pandas as pd
import json
from pathlib import Path

def validate_data(data_path: str, config: dict) -> dict:
    """Validate data before training."""
    df = pd.read_parquet(data_path)
    checks = {}

    # Schema validation
    expected_cols = set(config["expected_columns"])
    actual_cols = set(df.columns)
    checks["schema_match"] = expected_cols.issubset(actual_cols)
    if not checks["schema_match"]:
        missing = expected_cols - actual_cols
        checks["missing_columns"] = list(missing)

    # Row count
    min_rows = config.get("min_rows", 1000)
    checks["sufficient_rows"] = len(df) >= min_rows

    # Null rate
    max_null_rate = config.get("max_null_rate", 0.1)
    null_rates = df.isnull().mean()
    high_null_cols = null_rates[null_rates > max_null_rate]
    checks["null_rates_ok"] = len(high_null_cols) == 0

    # Target distribution
    if "target_column" in config:
        target = config["target_column"]
        if target in df.columns:
            class_dist = df[target].value_counts(normalize=True)
            min_class_pct = config.get("min_class_percentage", 0.05)
            checks["class_balance_ok"] = class_dist.min() >= min_class_pct

    # Duplicate check
    checks["no_duplicates"] = not df.duplicated().any()

    return {
        "passed": all(v for k, v in checks.items() if isinstance(v, bool)),
        "checks": checks,
        "stats": {
            "rows": len(df),
            "columns": len(df.columns),
            "null_rate": float(df.isnull().mean().mean()),
        },
    }
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track experiments within pipeline runs
- Related: `5-ship/model_registry_management` -- Manage model versions produced by pipelines
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor deployed models, trigger retraining
- Related: `2-design/feature_store_design` -- Feature pipelines feed into training pipelines
- Related: `toolkit/ai_cost_optimization` -- Optimize pipeline compute costs

---

## EXIT CHECKLIST

- [ ] Pipeline stages defined: data validation, training, validation gate, deployment
- [ ] CI/CD triggers configured (code change, schedule, manual, drift alert)
- [ ] Model validation gate implemented with clear pass/fail thresholds
- [ ] Deployment strategy selected (canary, blue-green, shadow)
- [ ] Rollback procedure automated and tested
- [ ] Experiment tracking integrated into pipeline
- [ ] Model registry transitions automated (staging, production)
- [ ] Retraining triggers configured (schedule, drift, performance)
- [ ] Data validation runs before every training job
- [ ] Pipeline artifacts stored and versioned
- [ ] Monitoring configured for deployed models
- [ ] Pipeline notifications set up (success, failure, approval needed)

---

*Skill Version: 1.0 | Created: March 2026*
