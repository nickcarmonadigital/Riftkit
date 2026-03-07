---
name: Model Registry Management
description: Version, stage, promote, and govern ML models through their lifecycle with MLflow Registry, HF Hub, and SageMaker
---

# Model Registry Management Skill

**Purpose**: Manage the full lifecycle of ML models from registration through staging, production promotion, rollback, and retirement using industry-standard model registries.

---

## TRIGGER COMMANDS

```text
"Register and version this model in the registry"
"Promote the model from staging to production"
"Set up model approval workflows and governance"
"Using model_registry_management skill: [task]"
```

---

## Registry Platform Comparison

| Feature | MLflow Registry | HF Hub | SageMaker Registry | Vertex AI Registry |
|---------|----------------|--------|--------------------|--------------------|
| Self-hosted | Yes | Yes (Enterprise) | No (AWS only) | No (GCP only) |
| Model stages | Staging/Prod/Archived | Community/Gated | Approval groups | Versions + endpoints |
| Approval workflows | Webhooks + custom | Community review | CI/CD integration | IAM-based |
| A/B testing | Manual | No | Built-in (endpoints) | Built-in (endpoints) |
| Model cards | Plugin | Built-in | No | Built-in |
| Version control | Sequential | Git-based | Sequential | Sequential |
| Access control | Basic (OSS) | Token-based | IAM | IAM |
| Best for | MLOps teams | Open-source models | AWS shops | GCP shops |

---

## Model Lifecycle Stages

```
+----------+     +---------+     +------------+     +----------+
|          |     |         |     |            |     |          |
|  None    +---->+ Staging +---->+ Production +---->+ Archived |
|  (new)   |     |         |     |            |     |          |
+----------+     +----+----+     +-----+------+     +----------+
                      |               |
                      |  (rejected)   |  (rollback)
                      +<--------------+
```

### Stage Definitions

| Stage | Purpose | Who decides | Typical checks |
|-------|---------|-------------|----------------|
| None | Newly registered, untested | Automatic | None |
| Staging | Candidate for production | ML Engineer | Metrics pass thresholds |
| Production | Serving live traffic | ML Lead + PM | A/B test results, approval |
| Archived | Retired, kept for audit | Ops team | Replacement verified |

---

## MLflow Model Registry

### Registering Models

```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import GradientBoostingClassifier

mlflow.set_tracking_uri("http://localhost:5000")

with mlflow.start_run() as run:
    model = GradientBoostingClassifier(n_estimators=200, max_depth=5)
    model.fit(X_train, y_train)

    # Register model during logging
    model_info = mlflow.sklearn.log_model(
        model,
        artifact_path="model",
        registered_model_name="churn-classifier",
        input_example=X_train[:5],
        signature=mlflow.models.infer_signature(X_train, y_train),
    )
    print(f"Model URI: {model_info.model_uri}")
    print(f"Model Version: {model_info.registered_model_version}")
```

### Managing Model Versions

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# List all versions of a model
versions = client.search_model_versions("name='churn-classifier'")
for v in versions:
    print(f"Version {v.version}: stage={v.current_stage}, "
          f"run_id={v.run_id[:8]}, status={v.status}")

# Get specific version details
version = client.get_model_version("churn-classifier", version=3)
print(f"Description: {version.description}")
print(f"Tags: {version.tags}")

# Update version description and tags
client.update_model_version(
    name="churn-classifier",
    version=3,
    description="GBM with balanced class weights, trained on v2.3 dataset",
)
client.set_model_version_tag("churn-classifier", 3, "validation_status", "passed")
client.set_model_version_tag("churn-classifier", 3, "approved_by", "ml-lead")
```

### Stage Transitions

```python
from mlflow.tracking import MlflowClient

client = MlflowClient()

# Promote to staging
client.transition_model_version_stage(
    name="churn-classifier",
    version=3,
    stage="Staging",
    archive_existing_versions=False,
)

# Promote to production (archive previous production version)
client.transition_model_version_stage(
    name="churn-classifier",
    version=3,
    stage="Production",
    archive_existing_versions=True,  # Auto-archive previous prod version
)

# Rollback: promote previous version back to production
client.transition_model_version_stage(
    name="churn-classifier",
    version=2,
    stage="Production",
    archive_existing_versions=True,
)

# Archive a model version
client.transition_model_version_stage(
    name="churn-classifier",
    version=1,
    stage="Archived",
)
```

### Loading Models by Stage

```python
import mlflow

# Load production model
prod_model = mlflow.sklearn.load_model("models:/churn-classifier/Production")

# Load staging model for comparison
staging_model = mlflow.sklearn.load_model("models:/churn-classifier/Staging")

# Load specific version
v3_model = mlflow.sklearn.load_model("models:/churn-classifier/3")

# Use in inference
predictions = prod_model.predict(X_new)
```

---

## Hugging Face Hub Registry

### Publishing Models

```python
from transformers import AutoModelForSequenceClassification, AutoTokenizer

model = AutoModelForSequenceClassification.from_pretrained("./fine-tuned-model")
tokenizer = AutoTokenizer.from_pretrained("./fine-tuned-model")

# Push to Hub with model card
model.push_to_hub(
    "myorg/churn-classifier-bert",
    commit_message="v2: trained on balanced dataset",
    private=True,
)
tokenizer.push_to_hub("myorg/churn-classifier-bert")
```

### Model Cards

```python
from huggingface_hub import ModelCard, ModelCardData

card_data = ModelCardData(
    language="en",
    license="apache-2.0",
    model_name="Churn Classifier BERT",
    pipeline_tag="text-classification",
    tags=["churn", "classification", "finance"],
    datasets=["myorg/customer-churn-v2"],
    metrics=[
        {"type": "f1", "value": 0.923, "name": "F1 Score"},
        {"type": "accuracy", "value": 0.945, "name": "Accuracy"},
    ],
)

card = ModelCard.from_template(
    card_data,
    model_description="Fine-tuned BERT for customer churn prediction.",
    training_procedure="Fine-tuned for 5 epochs on balanced dataset with AdamW.",
    intended_uses="Predict customer churn from support ticket text.",
    limitations="English only. May not generalize to B2B customers.",
    eval_results="F1=0.923 on held-out test set (n=5000).",
)
card.push_to_hub("myorg/churn-classifier-bert")
```

### Version Management on HF Hub

```python
from huggingface_hub import HfApi

api = HfApi()

# List model revisions (commits)
commits = api.list_repo_commits("myorg/churn-classifier-bert")
for commit in commits[:5]:
    print(f"{commit.commit_id[:8]}: {commit.title} ({commit.created_at})")

# Create a tagged version
api.create_tag(
    repo_id="myorg/churn-classifier-bert",
    tag="v2.0-production",
    revision="main",
    tag_message="Approved for production deployment 2026-03-06",
)

# Load specific version
from transformers import AutoModel
model_v1 = AutoModel.from_pretrained("myorg/churn-classifier-bert", revision="v1.0")
model_v2 = AutoModel.from_pretrained("myorg/churn-classifier-bert", revision="v2.0-production")
```

---

## SageMaker Model Registry

### Registering Models

```python
import boto3
import sagemaker
from sagemaker.model_metrics import MetricsSource, ModelMetrics

sm_client = boto3.client("sagemaker")
sagemaker_session = sagemaker.Session()

# Create model package group (like MLflow registered model)
sm_client.create_model_package_group(
    ModelPackageGroupName="churn-classifier",
    ModelPackageGroupDescription="Customer churn prediction models",
)

# Define model metrics
model_metrics = ModelMetrics(
    model_statistics=MetricsSource(
        s3_uri="s3://bucket/eval/statistics.json",
        content_type="application/json",
    ),
    model_constraints=MetricsSource(
        s3_uri="s3://bucket/eval/constraints.json",
        content_type="application/json",
    ),
)

# Register model version
model_package = sm_client.create_model_package(
    ModelPackageGroupName="churn-classifier",
    ModelPackageDescription="GBM v3 - balanced weights",
    InferenceSpecification={
        "Containers": [{
            "Image": "123456789.dkr.ecr.us-east-1.amazonaws.com/churn:latest",
            "ModelDataUrl": "s3://bucket/models/churn-v3/model.tar.gz",
        }],
        "SupportedContentTypes": ["text/csv", "application/json"],
        "SupportedResponseMIMETypes": ["application/json"],
    },
    ModelApprovalStatus="PendingManualApproval",
)
```

### Approval Workflow

```python
# Approve model (typically done by ML Lead after review)
sm_client.update_model_package(
    ModelPackageArn=model_package["ModelPackageArn"],
    ModelApprovalStatus="Approved",
    ApprovalDescription="Approved after A/B test showed +2.3% conversion lift",
)

# Reject model
sm_client.update_model_package(
    ModelPackageArn=model_package["ModelPackageArn"],
    ModelApprovalStatus="Rejected",
    ApprovalDescription="F1 below 0.90 threshold on segment B",
)
```

---

## A/B Testing and Shadow Deployment

### Shadow Deployment Pattern

```
                    +-------------------+
                    |   Load Balancer   |
                    +--------+----------+
                             |
                    +--------v----------+
                    |   Router/Proxy    |
                    +---+----------+----+
                        |          |
              (100%)    |          |    (mirror)
                        v          v
                +-------+--+  +---+--------+
                | Primary  |  |   Shadow   |
                | Model v2 |  |  Model v3  |
                +----------+  +-----+------+
                                    |
                            (log predictions,
                             compare offline)
```

```python
# Shadow deployment comparison script
import pandas as pd
from datetime import datetime, timedelta

def compare_shadow_results(primary_preds, shadow_preds, actuals):
    """Compare primary and shadow model predictions against actuals."""
    results = {
        "primary": {
            "accuracy": (primary_preds == actuals).mean(),
            "f1": f1_score(actuals, primary_preds, average="weighted"),
        },
        "shadow": {
            "accuracy": (shadow_preds == actuals).mean(),
            "f1": f1_score(actuals, shadow_preds, average="weighted"),
        },
        "agreement_rate": (primary_preds == shadow_preds).mean(),
        "shadow_improvement": {
            "accuracy_delta": (shadow_preds == actuals).mean() - (primary_preds == actuals).mean(),
            "f1_delta": f1_score(actuals, shadow_preds, average="weighted") - f1_score(actuals, primary_preds, average="weighted"),
        },
    }
    return results
```

### A/B Test with Traffic Splitting

```python
# A/B test configuration
ab_config = {
    "experiment_name": "churn-model-v3-rollout",
    "variants": {
        "control": {"model_version": 2, "traffic_pct": 80},
        "treatment": {"model_version": 3, "traffic_pct": 20},
    },
    "success_metric": "conversion_rate",
    "min_sample_size": 10000,
    "significance_level": 0.05,
    "max_duration_days": 14,
}

# Traffic router (simplified)
import hashlib

def route_request(user_id: str, config: dict) -> str:
    hash_val = int(hashlib.md5(user_id.encode()).hexdigest(), 16) % 100
    cumulative = 0
    for variant, settings in config["variants"].items():
        cumulative += settings["traffic_pct"]
        if hash_val < cumulative:
            return variant
    return "control"
```

---

## Model Governance

### Governance Checklist Template

```yaml
# model-governance-checklist.yaml
model_name: churn-classifier
version: 3
date: 2026-03-06

technical_review:
  - metric_thresholds_met: true
  - regression_tests_passed: true
  - latency_within_sla: true  # p99 < 100ms
  - memory_within_budget: true  # < 2GB
  - input_validation_tested: true

business_review:
  - stakeholder_approval: pending
  - a_b_test_results_positive: true
  - rollback_plan_documented: true
  - monitoring_alerts_configured: true

compliance_review:
  - bias_audit_completed: true
  - data_privacy_verified: true
  - model_card_published: true
  - explainability_report_available: true

deployment_readiness:
  - staging_environment_tested: true
  - canary_deployment_planned: true
  - rollback_procedure_verified: true
  - on_call_team_notified: false
```

### Automated Validation Gate

```python
def validate_model_for_promotion(model_name: str, version: int, client: MlflowClient) -> dict:
    """Automated validation gate before model promotion."""
    model_version = client.get_model_version(model_name, version)
    run = client.get_run(model_version.run_id)
    metrics = run.data.metrics

    checks = {}

    # Performance thresholds
    checks["f1_above_threshold"] = metrics.get("f1_score", 0) >= 0.85
    checks["accuracy_above_threshold"] = metrics.get("accuracy", 0) >= 0.90
    checks["latency_within_sla"] = metrics.get("inference_p99_ms", 999) <= 100

    # Regression check against current production
    prod_versions = client.get_latest_versions(model_name, stages=["Production"])
    if prod_versions:
        prod_run = client.get_run(prod_versions[0].run_id)
        prod_f1 = prod_run.data.metrics.get("f1_score", 0)
        checks["no_regression"] = metrics.get("f1_score", 0) >= prod_f1 - 0.01
    else:
        checks["no_regression"] = True

    # Required artifacts
    artifacts = [a.path for a in client.list_artifacts(model_version.run_id)]
    checks["model_card_exists"] = "model_card.md" in artifacts
    checks["eval_report_exists"] = "evaluation_report.json" in artifacts

    # Required tags
    checks["approved_by_tagged"] = "approved_by" in model_version.tags
    checks["dataset_version_tagged"] = "dataset_version" in model_version.tags

    all_passed = all(checks.values())
    return {"passed": all_passed, "checks": checks}
```

---

## Rollback Procedures

### Automated Rollback Script

```python
from mlflow.tracking import MlflowClient
import logging

logger = logging.getLogger(__name__)

def rollback_model(model_name: str, client: MlflowClient) -> dict:
    """Roll back production model to the previous version."""
    # Find current production version
    prod_versions = client.get_latest_versions(model_name, stages=["Production"])
    if not prod_versions:
        raise ValueError(f"No production version found for {model_name}")

    current_prod = prod_versions[0]
    logger.info(f"Current production: version {current_prod.version}")

    # Find previous production version (now archived)
    all_versions = client.search_model_versions(f"name='{model_name}'")
    archived = [
        v for v in all_versions
        if v.current_stage == "Archived"
        and int(v.version) < int(current_prod.version)
    ]

    if not archived:
        raise ValueError("No archived version available for rollback")

    # Get the most recent archived version
    rollback_target = max(archived, key=lambda v: int(v.version))
    logger.info(f"Rolling back to version {rollback_target.version}")

    # Promote rollback target to production
    client.transition_model_version_stage(
        name=model_name,
        version=rollback_target.version,
        stage="Production",
        archive_existing_versions=True,
    )

    # Tag the rolled-back version
    client.set_model_version_tag(
        model_name, current_prod.version,
        "rollback_reason", "performance_degradation",
    )
    client.set_model_version_tag(
        model_name, current_prod.version,
        "rolled_back_at", datetime.utcnow().isoformat(),
    )

    return {
        "rolled_back_from": current_prod.version,
        "rolled_back_to": rollback_target.version,
        "status": "success",
    }
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track experiments before registering models
- Related: `5-ship/mlops_pipeline` -- Automate registry transitions in CI/CD
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor deployed model performance for rollback triggers
- Related: `toolkit/responsible_ai_framework` -- Model cards and governance documentation

---

## EXIT CHECKLIST

- [ ] Model registry platform selected and configured
- [ ] Models registered with signatures, input examples, and descriptions
- [ ] Stage transition workflow defined (who approves, what checks)
- [ ] Automated validation gate implemented before promotion
- [ ] Model cards created with metrics, limitations, and intended use
- [ ] Rollback procedure documented and tested
- [ ] A/B testing or shadow deployment strategy defined
- [ ] Version tags include dataset version, git commit, and approver
- [ ] Access control configured (who can promote to production)
- [ ] Archived versions retained for audit trail

---

*Skill Version: 1.0 | Created: March 2026*
