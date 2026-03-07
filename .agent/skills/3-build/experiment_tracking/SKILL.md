---
name: Experiment Tracking
description: Track ML experiments with MLflow, W&B, Neptune, and ClearML for reproducible model development
---

# Experiment Tracking Skill

**Purpose**: Systematically track, compare, and reproduce machine learning experiments using industry-standard platforms and best practices.

---

## TRIGGER COMMANDS

```text
"Set up experiment tracking for this ML project"
"Compare experiment runs and find the best model"
"Track hyperparameters, metrics, and artifacts"
"Using experiment_tracking skill: [task]"
```

---

## Platform Selection Matrix

| Feature | MLflow | W&B | Neptune | ClearML |
|---------|--------|-----|---------|---------|
| Self-hosted | Yes (free) | Yes (enterprise) | Yes (enterprise) | Yes (free) |
| Cloud hosted | Databricks | wandb.ai | neptune.ai | clear.ml |
| Auto-logging | Yes | Yes | Limited | Yes |
| Artifact storage | Local/S3/GCS/Azure | W&B servers | Neptune servers | S3/GCS/Azure |
| Hyperparameter sweeps | Limited | Built-in (Sweeps) | Built-in | Built-in (HyperDataset) |
| UI quality | Good | Excellent | Good | Good |
| Model registry | Built-in | Model Registry | Model Registry | Model Management |
| Team collaboration | Basic | Excellent | Good | Good |
| Pricing model | Free OSS | Free tier + paid | Free tier + paid | Free tier + paid |
| Best for | Self-hosted, MLOps | Research teams | Data science teams | Full pipeline |

### Decision Guide

```
Need self-hosted + free?          --> MLflow
Need best collaboration UI?       --> W&B
Need tight CI/CD integration?     --> ClearML
Need Databricks ecosystem?        --> MLflow (managed)
Need advanced visualization?      --> W&B or Neptune
Budget-constrained team?          --> MLflow or ClearML (self-hosted)
```

---

## MLflow Setup and Usage

### Installation and Server Setup

```bash
# Install MLflow
pip install mlflow[extras]

# Start local tracking server with SQLite backend
mlflow server \
  --backend-store-uri sqlite:///mlflow.db \
  --default-artifact-root ./mlartifacts \
  --host 0.0.0.0 \
  --port 5000

# Production: PostgreSQL backend + S3 artifacts
mlflow server \
  --backend-store-uri postgresql://user:pass@db:5432/mlflow \
  --default-artifact-root s3://mlflow-artifacts/runs \
  --host 0.0.0.0 \
  --port 5000
```

### Experiment Structure

```
MLflow Hierarchy:
+-- Experiment (project-level grouping)
|   +-- Run (single training execution)
|   |   +-- Parameters (hyperparameters, config)
|   |   +-- Metrics (loss, accuracy, F1, etc.)
|   |   +-- Artifacts (models, plots, data samples)
|   |   +-- Tags (metadata, git commit, team info)
|   +-- Run
|   +-- Run
+-- Experiment
```

### Core Tracking API

```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score

# Set tracking URI (local server or remote)
mlflow.set_tracking_uri("http://localhost:5000")

# Create or get experiment
mlflow.set_experiment("customer-churn-prediction")

# Start a run with full tracking
with mlflow.start_run(run_name="rf-baseline-v1") as run:
    # Log parameters
    params = {
        "n_estimators": 100,
        "max_depth": 10,
        "min_samples_split": 5,
        "random_state": 42,
        "class_weight": "balanced",
    }
    mlflow.log_params(params)

    # Train model
    model = RandomForestClassifier(**params)
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)

    # Log metrics
    metrics = {
        "accuracy": accuracy_score(y_test, y_pred),
        "f1_score": f1_score(y_test, y_pred, average="weighted"),
        "precision": precision_score(y_test, y_pred, average="weighted"),
        "recall": recall_score(y_test, y_pred, average="weighted"),
    }
    mlflow.log_metrics(metrics)

    # Log step-wise metrics (for training curves)
    for epoch in range(num_epochs):
        train_loss = train_one_epoch(model, train_loader)
        val_loss = evaluate(model, val_loader)
        mlflow.log_metrics({
            "train_loss": train_loss,
            "val_loss": val_loss,
        }, step=epoch)

    # Log model artifact
    mlflow.sklearn.log_model(
        model,
        artifact_path="model",
        registered_model_name="churn-classifier",
    )

    # Log custom artifacts
    mlflow.log_artifact("confusion_matrix.png")
    mlflow.log_artifact("feature_importance.csv")

    # Log tags
    mlflow.set_tags({
        "team": "ml-platform",
        "dataset_version": "v2.3",
        "git_commit": "abc123f",
    })

    print(f"Run ID: {run.info.run_id}")
```

### Auto-Logging

```python
# Sklearn auto-logging (logs params, metrics, model automatically)
mlflow.sklearn.autolog(
    log_input_examples=True,
    log_model_signatures=True,
    log_models=True,
)

# PyTorch auto-logging
mlflow.pytorch.autolog(
    log_every_n_epoch=1,
    log_models=True,
)

# TensorFlow/Keras auto-logging
mlflow.tensorflow.autolog()

# XGBoost auto-logging
mlflow.xgboost.autolog()

# LightGBM auto-logging
mlflow.lightgbm.autolog()

# Hugging Face Transformers auto-logging
mlflow.transformers.autolog()
```

### Querying and Comparing Runs

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Search runs with filters
runs = mlflow.search_runs(
    experiment_names=["customer-churn-prediction"],
    filter_string="metrics.f1_score > 0.85 AND params.n_estimators = '100'",
    order_by=["metrics.f1_score DESC"],
    max_results=10,
)

# Get best run
best_run = runs.iloc[0]
print(f"Best F1: {best_run['metrics.f1_score']}")
print(f"Run ID: {best_run['run_id']}")

# Load model from best run
best_model = mlflow.sklearn.load_model(f"runs:/{best_run['run_id']}/model")

# Compare runs programmatically
for _, run in runs.iterrows():
    print(f"Run {run['run_id'][:8]}: "
          f"F1={run['metrics.f1_score']:.4f}, "
          f"Acc={run['metrics.accuracy']:.4f}, "
          f"Depth={run['params.max_depth']}")
```

---

## Weights & Biases (W&B) Setup and Usage

### Installation and Configuration

```bash
pip install wandb
wandb login  # Enter API key from wandb.ai/authorize
```

### Core Tracking

```python
import wandb

# Initialize run
run = wandb.init(
    project="customer-churn",
    name="rf-baseline-v1",
    config={
        "n_estimators": 100,
        "max_depth": 10,
        "learning_rate": 0.01,
        "dataset": "churn-v2.3",
        "architecture": "random-forest",
    },
    tags=["baseline", "production-candidate"],
)

# Log metrics over steps
for epoch in range(num_epochs):
    train_loss, val_loss = train_epoch(model, epoch)
    wandb.log({
        "epoch": epoch,
        "train/loss": train_loss,
        "val/loss": val_loss,
        "val/accuracy": val_accuracy,
        "val/f1": val_f1,
    })

# Log summary metrics
wandb.run.summary["best_f1"] = best_f1
wandb.run.summary["best_epoch"] = best_epoch

# Log artifacts
artifact = wandb.Artifact("model-weights", type="model")
artifact.add_file("model.pkl")
run.log_artifact(artifact)

# Log tables for data visualization
table = wandb.Table(
    columns=["input", "prediction", "ground_truth", "confidence"],
    data=predictions_data,
)
wandb.log({"predictions": table})

# Log confusion matrix
wandb.log({"confusion_matrix": wandb.plot.confusion_matrix(
    y_true=y_test,
    preds=y_pred,
    class_names=["retained", "churned"],
)})

wandb.finish()
```

### Hyperparameter Sweeps

```python
# Define sweep configuration
sweep_config = {
    "method": "bayes",  # bayes, grid, random
    "metric": {
        "name": "val/f1",
        "goal": "maximize",
    },
    "parameters": {
        "n_estimators": {"values": [50, 100, 200, 500]},
        "max_depth": {"min": 3, "max": 20},
        "learning_rate": {"distribution": "log_uniform_values", "min": 1e-4, "max": 1e-1},
        "min_samples_split": {"values": [2, 5, 10]},
        "batch_size": {"values": [16, 32, 64]},
    },
    "early_terminate": {
        "type": "hyperband",
        "min_iter": 5,
        "eta": 3,
    },
}

# Create sweep
sweep_id = wandb.sweep(sweep_config, project="customer-churn")

def train_sweep():
    with wandb.init() as run:
        config = wandb.config
        model = build_model(config)
        for epoch in range(50):
            metrics = train_epoch(model, epoch)
            wandb.log(metrics)

# Run sweep agent (runs 50 trials)
wandb.agent(sweep_id, function=train_sweep, count=50)
```

---

## Artifact Management

### Artifact Types and Organization

```
Artifact Hierarchy:
+-- Dataset Artifacts
|   +-- raw-data:v0 --> raw-data:v1 --> raw-data:v2
|   +-- processed-data:v0 --> processed-data:v1
+-- Model Artifacts
|   +-- model-weights:v0 --> model-weights:v1
|   +-- model-onnx:v0
+-- Evaluation Artifacts
|   +-- eval-results:v0
|   +-- predictions:v0
```

### MLflow Artifact Logging

```python
import mlflow
import json
import matplotlib.pyplot as plt

with mlflow.start_run():
    # Log single file
    mlflow.log_artifact("model_config.json")

    # Log directory of artifacts
    mlflow.log_artifacts("output/plots/", artifact_path="plots")

    # Log a dict as JSON artifact
    mlflow.log_dict(
        {"features": feature_list, "version": "2.3"},
        artifact_file="dataset_metadata.json",
    )

    # Log a figure
    fig, ax = plt.subplots()
    ax.plot(training_history["loss"])
    mlflow.log_figure(fig, "training_loss.png")

    # Log a text file
    mlflow.log_text(
        classification_report_str,
        artifact_file="classification_report.txt",
    )
```

### W&B Artifact Versioning and Lineage

```python
import wandb

run = wandb.init(project="my-project")

# Log dataset artifact with lineage
dataset_artifact = wandb.Artifact(
    name="training-data",
    type="dataset",
    description="Preprocessed training data v2",
    metadata={
        "num_samples": 50000,
        "num_features": 128,
        "preprocessing": "standardized",
        "source": "s3://data-lake/raw/2026-03/",
    },
)
dataset_artifact.add_dir("data/processed/")
run.log_artifact(dataset_artifact)

# Use artifact as input (creates lineage link)
dataset = run.use_artifact("training-data:latest")
data_dir = dataset.download()

# Log model that depends on dataset
model_artifact = wandb.Artifact(
    name="churn-model",
    type="model",
    metadata={"framework": "pytorch", "architecture": "transformer"},
)
model_artifact.add_file("model.pt")
run.log_artifact(model_artifact)
```

---

## Experiment Comparison Strategies

### Comparison Table Pattern

```python
import pandas as pd
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Pull all runs from experiment
experiment = client.get_experiment_by_name("customer-churn")
runs = client.search_runs(
    experiment_ids=[experiment.experiment_id],
    filter_string="status = 'FINISHED'",
    order_by=["metrics.f1_score DESC"],
)

# Build comparison DataFrame
comparison = []
for run in runs:
    comparison.append({
        "run_name": run.info.run_name,
        "run_id": run.info.run_id[:8],
        "f1_score": run.data.metrics.get("f1_score"),
        "accuracy": run.data.metrics.get("accuracy"),
        "precision": run.data.metrics.get("precision"),
        "recall": run.data.metrics.get("recall"),
        "n_estimators": run.data.params.get("n_estimators"),
        "max_depth": run.data.params.get("max_depth"),
        "duration_min": (run.info.end_time - run.info.start_time) / 60000,
    })

df = pd.DataFrame(comparison)
print(df.to_markdown(index=False))
```

### Statistical Significance Testing

```python
import numpy as np
from scipy import stats

def compare_models_statistically(model_a_scores, model_b_scores, alpha=0.05):
    """Compare two models using paired t-test on cross-validation scores."""
    t_stat, p_value = stats.ttest_rel(model_a_scores, model_b_scores)

    mean_diff = np.mean(model_a_scores) - np.mean(model_b_scores)
    ci = stats.t.interval(
        1 - alpha,
        len(model_a_scores) - 1,
        loc=mean_diff,
        scale=stats.sem(model_a_scores - model_b_scores),
    )

    return {
        "t_statistic": t_stat,
        "p_value": p_value,
        "mean_difference": mean_diff,
        "confidence_interval": ci,
        "significant": p_value < alpha,
    }
```

---

## Model Lineage Tracking

### Full Lineage Example

```python
import mlflow

# Track data lineage
with mlflow.start_run(run_name="data-preprocessing") as data_run:
    mlflow.set_tag("pipeline_stage", "preprocessing")
    mlflow.log_param("source_table", "raw_customers")
    mlflow.log_param("preprocessing_version", "v2.3")
    mlflow.log_metric("input_rows", 100000)
    mlflow.log_metric("output_rows", 95000)
    mlflow.log_metric("dropped_rows", 5000)
    mlflow.log_artifact("processed_data.parquet")
    data_run_id = data_run.info.run_id

# Track training with lineage to data
with mlflow.start_run(run_name="model-training") as train_run:
    mlflow.set_tag("pipeline_stage", "training")
    mlflow.set_tag("data_run_id", data_run_id)  # Lineage link
    mlflow.set_tag("data_version", "v2.3")
    # ... training code ...

# Track evaluation with lineage to training
with mlflow.start_run(run_name="model-evaluation") as eval_run:
    mlflow.set_tag("pipeline_stage", "evaluation")
    mlflow.set_tag("training_run_id", train_run.info.run_id)
    # ... evaluation code ...
```

---

## Best Practices

### Naming Conventions

```
Experiments:  {project}-{task}                    (customer-churn-prediction)
Runs:         {model_type}-{variant}-{version}    (rf-balanced-v3)
Artifacts:    {type}-{description}                (model-weights, eval-report)
Tags:         {category}.{key}                    (data.version, model.framework)
```

### Configuration Management

```python
# config.yaml for reproducible experiments
import yaml
import mlflow

with open("config.yaml") as f:
    config = yaml.safe_load(f)

with mlflow.start_run():
    # Log entire config as params (flattened)
    mlflow.log_params({
        f"model.{k}": v for k, v in config["model"].items()
    })
    mlflow.log_params({
        f"data.{k}": v for k, v in config["data"].items()
    })
    mlflow.log_params({
        f"training.{k}": v for k, v in config["training"].items()
    })

    # Also log config file as artifact for exact reproduction
    mlflow.log_artifact("config.yaml")
```

### Environment Reproducibility

```python
import mlflow
import subprocess

with mlflow.start_run():
    # Log Python environment
    pip_freeze = subprocess.check_output(["pip", "freeze"]).decode()
    mlflow.log_text(pip_freeze, "requirements.txt")

    # Log git info
    git_hash = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode().strip()
    git_diff = subprocess.check_output(["git", "diff"]).decode()
    mlflow.set_tag("git.commit", git_hash)
    if git_diff:
        mlflow.log_text(git_diff, "uncommitted_changes.diff")

    # Log system info
    mlflow.set_tag("gpu", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "none")
    mlflow.set_tag("python_version", sys.version)
```

---

## Cross-References

- Related: `5-ship/model_registry_management` -- Promote tracked experiments to model registry
- Related: `5-ship/mlops_pipeline` -- Integrate experiment tracking into CI/CD pipelines
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor deployed models from tracked experiments
- Related: `toolkit/ai_cost_optimization` -- Track compute costs alongside experiment metrics

---

## EXIT CHECKLIST

- [ ] Experiment tracking platform selected and configured
- [ ] All hyperparameters logged (not hardcoded in training scripts)
- [ ] Metrics logged at appropriate granularity (per-step for training curves, summary for comparison)
- [ ] Model artifacts versioned and stored with lineage metadata
- [ ] Dataset version linked to each experiment run
- [ ] Environment captured (requirements.txt, git commit, hardware info)
- [ ] Naming conventions documented and followed by team
- [ ] Comparison queries tested (filter, sort, retrieve best runs)
- [ ] Auto-logging enabled where available to prevent missing data
- [ ] Artifact storage configured with appropriate backend (S3/GCS for production)

---

*Skill Version: 1.0 | Created: March 2026*
