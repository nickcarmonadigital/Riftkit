---
name: mlops
description: ML model deployment, serving, monitoring, and lifecycle management in production
---

# MLOps Skill

**Purpose**: Deploy machine learning models to production with confidence, implementing proper serving infrastructure, monitoring for drift, and automated retraining pipelines.

## :dart: TRIGGER COMMANDS

```text
"deploy ML model"
"MLOps pipeline"
"model serving"
"Using mlops skill: [model type] [serving platform] [scale]"
```

## :repeat: MLOps LIFECYCLE

```text
    ┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
    │  Train   │────>│ Validate │────>│ Package  │────>│  Deploy  │
    │          │     │          │     │          │     │          │
    └──────────┘     └──────────┘     └──────────┘     └────┬─────┘
         ^                                                   │
         │                                                   v
    ┌────┴─────┐                                       ┌──────────┐
    │ Retrain  │<──────────────────────────────────────│ Monitor  │
    │          │          drift / degradation           │          │
    └──────────┘                                       └──────────┘
```

## :rocket: MODEL SERVING OPTIONS

| Tool | Framework Support | GPU | Batching | Best For |
|---|---|---|---|---|
| **FastAPI / Flask** | Any (manual) | Manual | Manual | Simple models, prototyping |
| **TorchServe** | PyTorch | Yes | Yes (dynamic) | PyTorch production |
| **TF Serving** | TensorFlow/Keras | Yes | Yes | TensorFlow production |
| **Triton** | PyTorch, TF, ONNX, TensorRT | Yes (optimized) | Yes (dynamic) | Multi-framework, GPU fleet |
| **BentoML** | Any | Yes | Yes | Packaging + serving combined |
| **vLLM** | Transformers (LLMs) | Yes (required) | Continuous | LLM serving (high throughput) |
| **Ollama** | GGUF models | Optional | Limited | Local LLM development |
| **Ray Serve** | Any | Yes | Yes | Scalable, composable pipelines |

> [!TIP]
> For most teams: start with FastAPI for prototyping, graduate to BentoML for packaging, then Triton/vLLM for GPU-optimized production. Don't over-engineer day one.

## :card_file_box: MODEL REGISTRY (MLflow)

### Model Lifecycle Stages

```text
None ──> Staging ──> Production ──> Archived
              │           │
              │    (rollback possible)
              └───────────┘
```

### Registering a Model

```python
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score

mlflow.set_tracking_uri("http://mlflow.internal:5000")
mlflow.set_experiment("customer-churn-prediction")

with mlflow.start_run(run_name="rf-v3-tuned") as run:
    # Log parameters
    params = {"n_estimators": 200, "max_depth": 15, "min_samples_leaf": 5}
    mlflow.log_params(params)

    # Train
    model = RandomForestClassifier(**params)
    model.fit(X_train, y_train)

    # Evaluate
    y_pred = model.predict(X_test)
    metrics = {
        "accuracy": accuracy_score(y_test, y_pred),
        "f1_score": f1_score(y_test, y_pred, average="weighted"),
        "test_size": len(X_test),
    }
    mlflow.log_metrics(metrics)

    # Log model with signature
    from mlflow.models import infer_signature
    signature = infer_signature(X_test, y_pred)
    mlflow.sklearn.log_model(
        model,
        artifact_path="model",
        signature=signature,
        registered_model_name="customer-churn-model",
    )

    print(f"Run ID: {run.info.run_id}")
    print(f"Metrics: {metrics}")
```

### Promoting a Model

```python
from mlflow import MlflowClient

client = MlflowClient()

# Transition to staging for validation
client.transition_model_version_stage(
    name="customer-churn-model",
    version=3,
    stage="Staging",
)

# After validation passes, promote to production
client.transition_model_version_stage(
    name="customer-churn-model",
    version=3,
    stage="Production",
)

# Archive previous production version
client.transition_model_version_stage(
    name="customer-churn-model",
    version=2,
    stage="Archived",
)
```

## :whale: CONTAINERIZATION FOR ML

### Dockerfile for ML Service

```dockerfile
# Multi-stage build to reduce image size
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-slim AS runtime

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY src/ ./src/
COPY models/ ./models/

# Non-root user for security
RUN useradd -m appuser
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=5s \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000
CMD ["uvicorn", "src.serve:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

### GPU-Enabled Dockerfile

```dockerfile
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements-gpu.txt .
RUN pip3 install --no-cache-dir -r requirements-gpu.txt

COPY src/ ./src/
COPY models/ ./models/

EXPOSE 8000
CMD ["python3", "-m", "uvicorn", "src.serve:app", "--host", "0.0.0.0", "--port", "8000"]
```

> [!WARNING]
> ML Docker images can easily exceed 5GB with CUDA libraries. Always use multi-stage builds, pin exact dependency versions, and consider model loading at runtime (from S3/GCS) instead of baking models into the image.

## :globe_with_meridians: API DESIGN FOR ML SERVING

### FastAPI Model Serving Endpoint

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import mlflow
import numpy as np
import time

app = FastAPI(title="Customer Churn Prediction API", version="1.0.0")

# Load model at startup (not per request)
MODEL = None
MODEL_VERSION = None

@app.on_event("startup")
async def load_model():
    global MODEL, MODEL_VERSION
    MODEL = mlflow.pyfunc.load_model("models:/customer-churn-model/Production")
    MODEL_VERSION = MODEL.metadata.run_id
    print(f"Loaded model version: {MODEL_VERSION}")

class PredictionRequest(BaseModel):
    customer_id: str
    features: dict = Field(..., example={
        "tenure_months": 24,
        "monthly_charges": 65.5,
        "total_charges": 1572.0,
        "contract_type": "month-to-month",
        "payment_method": "electronic_check",
    })

class PredictionResponse(BaseModel):
    customer_id: str
    prediction: str          # "churn" or "retain"
    probability: float       # 0.0 to 1.0
    model_version: str
    latency_ms: float

class BatchPredictionRequest(BaseModel):
    instances: list[PredictionRequest]

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    start = time.perf_counter()

    try:
        features = pd.DataFrame([request.features])
        proba = MODEL.predict(features)[0]
        prediction = "churn" if proba > 0.5 else "retain"
    except Exception as e:
        raise HTTPException(status_code=422, detail=f"Prediction failed: {str(e)}")

    latency = (time.perf_counter() - start) * 1000

    # Log for monitoring
    log_prediction(request.customer_id, request.features, proba, latency)

    return PredictionResponse(
        customer_id=request.customer_id,
        prediction=prediction,
        probability=round(float(proba), 4),
        model_version=MODEL_VERSION,
        latency_ms=round(latency, 2),
    )

@app.post("/predict/batch")
async def predict_batch(request: BatchPredictionRequest):
    results = []
    for instance in request.instances:
        result = await predict(instance)
        results.append(result)
    return {"predictions": results, "count": len(results)}

@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "model_loaded": MODEL is not None,
        "model_version": MODEL_VERSION,
    }
```

## :test_tube: A/B TESTING AND CANARY DEPLOYMENTS

### Traffic Splitting Strategy

```text
                         ┌──────────────────┐
                    90%  │ Champion (v2)     │──> Metrics A
Request ──> Router ─────>│ Current production│
                    │    └──────────────────┘
                    │    ┌──────────────────┐
                    10%  │ Challenger (v3)   │──> Metrics B
                    └───>│ New candidate     │
                         └──────────────────┘

Compare after N days:
- Latency (p50, p95, p99)
- Prediction accuracy (if ground truth available)
- Business metrics (conversion rate, revenue impact)
- Error rate
```

### Kubernetes Canary with Istio

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ml-prediction-service
spec:
  hosts:
    - prediction-api.internal
  http:
    - route:
        - destination:
            host: prediction-api
            subset: champion
          weight: 90
        - destination:
            host: prediction-api
            subset: challenger
          weight: 10

---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: ml-prediction-service
spec:
  host: prediction-api
  subsets:
    - name: champion
      labels:
        version: v2
    - name: challenger
      labels:
        version: v3
```

## :mag: MODEL MONITORING

### Data Drift Detection

```python
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metric_preset import DataDriftPreset, TargetDriftPreset
import pandas as pd

def detect_drift(reference_data: pd.DataFrame, current_data: pd.DataFrame) -> dict:
    """
    Compare production data distribution against training data.
    Run daily or weekly to catch distribution shifts.
    """
    column_mapping = ColumnMapping(
        target="churn",
        prediction="prediction",
        numerical_features=["tenure_months", "monthly_charges", "total_charges"],
        categorical_features=["contract_type", "payment_method"],
    )

    report = Report(metrics=[
        DataDriftPreset(stattest_threshold=0.05),  # p-value threshold
        TargetDriftPreset(),
    ])

    report.run(
        reference_data=reference_data,
        current_data=current_data,
        column_mapping=column_mapping,
    )

    results = report.as_dict()
    drift_detected = results["metrics"][0]["result"]["dataset_drift"]
    drifted_columns = [
        col for col, info in results["metrics"][0]["result"]["drift_by_columns"].items()
        if info["drift_detected"]
    ]

    return {
        "drift_detected": drift_detected,
        "drifted_columns": drifted_columns,
        "drift_share": results["metrics"][0]["result"]["share_of_drifted_columns"],
    }

# Schedule this check
drift_result = detect_drift(training_data, last_7_days_production_data)
if drift_result["drift_detected"]:
    send_alert(
        channel="ml-monitoring",
        message=f"Data drift detected in columns: {drift_result['drifted_columns']}",
        severity="warning",
    )
```

### Key Monitoring Metrics

| Category | Metric | Alert Threshold | Check Frequency |
|---|---|---|---|
| **Performance** | p50 latency | > 100ms | Continuous |
| **Performance** | p99 latency | > 500ms | Continuous |
| **Performance** | Throughput (req/sec) | < 80% capacity | Continuous |
| **Performance** | Error rate | > 1% | Continuous |
| **Data Quality** | Feature drift (PSI) | PSI > 0.2 | Daily |
| **Data Quality** | Missing features | > 5% null rate | Per request |
| **Model Quality** | Prediction distribution | Shift > 2 std dev | Daily |
| **Model Quality** | Accuracy (if labels available) | Drop > 5% from baseline | Weekly |
| **Infrastructure** | GPU utilization | < 20% (over-provisioned) | Continuous |
| **Infrastructure** | Memory usage | > 85% | Continuous |

## :zap: GPU INFERENCE OPTIMIZATION

| Technique | Speedup | Accuracy Impact | Effort |
|---|---|---|---|
| **FP16 (half precision)** | 2x | Negligible (<0.1%) | Low (one flag) |
| **INT8 quantization** | 2-4x | Minor (0.5-2%) | Medium (calibration needed) |
| **TensorRT conversion** | 2-5x | None to minor | Medium (export + optimize) |
| **Dynamic batching** | 2-10x throughput | None | Low (server config) |
| **Model distillation** | 5-20x (smaller model) | 1-5% | High (train student model) |
| **ONNX Runtime** | 1.5-3x | None | Low (export to ONNX) |
| **Speculative decoding (LLMs)** | 2-3x | None | Medium |

## :llama: LLM-SPECIFIC DEPLOYMENT

### vLLM for High-Throughput LLM Serving

```python
# Install: pip install vllm
from vllm import LLM, SamplingParams

# Load model with PagedAttention for efficient KV cache management
llm = LLM(
    model="meta-llama/Llama-3-8B-Instruct",
    tensor_parallel_size=2,        # Split across 2 GPUs
    gpu_memory_utilization=0.90,   # Use 90% of GPU memory
    max_model_len=4096,
    dtype="float16",
)

# Continuous batching handles concurrent requests automatically
sampling_params = SamplingParams(
    temperature=0.7,
    top_p=0.95,
    max_tokens=512,
)

# Single inference
outputs = llm.generate(["Explain MLOps in 3 sentences."], sampling_params)

# Batch inference (all processed efficiently together)
prompts = ["prompt 1", "prompt 2", "prompt 3"]
outputs = llm.generate(prompts, sampling_params)
```

```bash
# Serve as OpenAI-compatible API
python -m vllm.entrypoints.openai.api_server \
    --model meta-llama/Llama-3-8B-Instruct \
    --tensor-parallel-size 2 \
    --port 8000
```

## :moneybag: COST OPTIMIZATION

| Strategy | Savings | Trade-off |
|---|---|---|
| **Spot/preemptible instances** for training | 60-90% | Can be interrupted (use checkpointing) |
| **Auto-scaling** for serving | 30-70% | Cold start latency on scale-up |
| **Model distillation** | 50-80% on inference | Slight accuracy loss, training cost |
| **Prediction caching** | 20-50% | Stale predictions for cached inputs |
| **Batch prediction** (offline) | 60-80% vs real-time | Higher latency (minutes vs milliseconds) |
| **Right-size GPU** | 20-50% | Requires profiling |
| **Quantization (INT8/FP16)** | 50-75% | Minimal accuracy impact |

> [!TIP]
> The biggest cost lever is usually not the GPU -- it is reducing unnecessary inference. Cache predictions for repeated inputs, batch offline predictions, and use simpler models (logistic regression, XGBoost) for cases where deep learning is overkill.

## :factory: CI/CD FOR ML

### GitHub Actions ML Pipeline

```yaml
name: ML Model CI/CD
on:
  push:
    paths: ['models/**', 'training/**', 'features/**']

jobs:
  validate-data:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate training data
        run: python scripts/validate_data.py --suite training_data_suite
      - name: Check feature schema
        run: python scripts/check_feature_schema.py

  train-and-evaluate:
    needs: validate-data
    runs-on: [self-hosted, gpu]
    steps:
      - uses: actions/checkout@v4
      - name: Train model
        run: python training/train.py --config configs/production.yaml
      - name: Evaluate model
        run: python training/evaluate.py --min-accuracy 0.85 --min-f1 0.80
      - name: Register model in MLflow
        run: python scripts/register_model.py --stage staging

  deploy-staging:
    needs: train-and-evaluate
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: kubectl apply -f k8s/staging/model-deployment.yaml
      - name: Run integration tests
        run: python tests/integration/test_prediction_api.py --env staging
      - name: Run shadow mode comparison
        run: python tests/shadow_mode.py --duration 1h --max-divergence 0.05

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production  # Requires manual approval
    steps:
      - name: Promote model to production
        run: python scripts/promote_model.py --stage production
      - name: Deploy canary (10%)
        run: kubectl apply -f k8s/production/canary-deployment.yaml
      - name: Monitor canary metrics
        run: python scripts/monitor_canary.py --duration 2h --rollback-on-error
      - name: Full rollout
        run: kubectl apply -f k8s/production/full-deployment.yaml
```

## :kubernetes: KUBERNETES DEPLOYMENT

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prediction-api
  labels:
    app: prediction-api
    version: v3
spec:
  replicas: 3
  selector:
    matchLabels:
      app: prediction-api
  template:
    metadata:
      labels:
        app: prediction-api
        version: v3
    spec:
      containers:
        - name: prediction-api
          image: registry.internal/ml/prediction-api:v3.2.1
          ports:
            - containerPort: 8000
          resources:
            requests:
              memory: "2Gi"
              cpu: "1"
              nvidia.com/gpu: "1"
            limits:
              memory: "4Gi"
              cpu: "2"
              nvidia.com/gpu: "1"
          env:
            - name: MODEL_NAME
              value: "customer-churn-model"
            - name: MLFLOW_TRACKING_URI
              value: "http://mlflow.internal:5000"
          readinessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 30  # Model loading takes time
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 60
            periodSeconds: 30

---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: prediction-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: prediction-api
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Pods
      pods:
        metric:
          name: prediction_latency_p99
        target:
          type: AverageValue
          averageValue: "500m"  # 500ms
```

## :leftwards_arrow_with_hook: ROLLBACK STRATEGY

| Pattern | How It Works | When to Use |
|---|---|---|
| **Blue/Green** | Two full environments, instant switch | Critical models, zero downtime |
| **Canary** | Gradual traffic shift (10% -> 50% -> 100%) | Most models, standard deployment |
| **Shadow Mode** | New model runs alongside old, no impact on users | High-risk model changes |
| **Champion/Challenger** | A/B test with real traffic, measure business metrics | When accuracy alone is insufficient |
| **Feature flags** | Toggle model version via config, no redeploy | Fast rollback, experimentation |

## :white_check_mark: EXIT CHECKLIST

- [ ] Model serving endpoint responds correctly (single and batch predictions)
- [ ] Model is registered in MLflow with version, metrics, and signature
- [ ] Docker image builds reproducibly with pinned dependencies
- [ ] A/B testing or canary framework is in place for safe rollouts
- [ ] Monitoring alerts configured for latency, error rate, and data drift
- [ ] Auto-scaling configured based on CPU/GPU utilization and request rate
- [ ] Rollback procedure tested and documented (< 5 min to revert)
- [ ] Model registry tracks all versions with promotion gates
- [ ] CI/CD pipeline validates data, trains, evaluates, and deploys automatically
- [ ] GPU optimization applied where applicable (FP16, batching, TensorRT)
- [ ] Cost monitoring in place with alerts on unexpected spend increases
- [ ] Prediction logging captures inputs, outputs, and latency for debugging

*Skill Version: 1.0 | Created: February 2026*
