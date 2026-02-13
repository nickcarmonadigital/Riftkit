---
name: ML Pipeline
description: Machine learning model training, evaluation, and experiment tracking pipelines
---

# ML Pipeline Skill

**Purpose**: Structured workflow for building reproducible machine learning pipelines -- from data preparation through model training, evaluation, and serialization.

---

## 🎯 TRIGGER COMMANDS

```text
"Build an ML pipeline for [task]"
"Train a model on [dataset]"
"Set up model training for [use case]"
"Create an experiment tracking workflow"
"Fine-tune [model] on [data]"
"Using ml_pipeline skill: [task]"
```

---

## 📁 ML Project Structure

```text
my-ml-project/
├── data/
│   ├── raw/              # Original, immutable data
│   ├── processed/        # Cleaned, transformed data
│   └── splits/           # train/val/test splits
├── notebooks/            # Exploratory analysis (EDA)
├── src/
│   ├── data/             # Data loading and processing
│   │   ├── dataset.py
│   │   └── preprocessing.py
│   ├── features/         # Feature engineering
│   │   └── build_features.py
│   ├── models/           # Model definitions
│   │   ├── train.py
│   │   └── predict.py
│   └── evaluation/       # Metrics and evaluation
│       └── metrics.py
├── models/               # Saved model artifacts
├── configs/              # Hyperparameter configs (YAML)
├── experiments/          # MLflow/W&B experiment logs
├── tests/                # Unit tests for pipeline
├── requirements.txt
├── pyproject.toml
└── dvc.yaml              # DVC pipeline definition
```

---

## 📊 Dataset Management

### Train / Validation / Test Splits

| Split | Purpose | Typical Size |
|-------|---------|-------------|
| **Train** | Model learns from this data | 70-80% |
| **Validation** | Tune hyperparameters, early stopping | 10-15% |
| **Test** | Final, unbiased evaluation (touch ONCE) | 10-15% |

```python
from sklearn.model_selection import train_test_split

# Standard split
X_train, X_temp, y_train, y_temp = train_test_split(
    X, y, test_size=0.3, random_state=42, stratify=y
)
X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, test_size=0.5, random_state=42, stratify=y_temp
)

print(f"Train: {len(X_train)}, Val: {len(X_val)}, Test: {len(X_test)}")
```

> [!WARNING]
> **Always stratify** when dealing with imbalanced datasets. Without stratification, your test set may have zero samples of the minority class, making evaluation meaningless.

### Data Versioning with DVC

```bash
# Initialize DVC in your project
pip install dvc dvc-s3  # or dvc-gcs, dvc-azure
dvc init

# Track a data file
dvc add data/raw/dataset.csv
git add data/raw/dataset.csv.dvc data/raw/.gitignore
git commit -m "Track dataset with DVC"

# Push data to remote storage
dvc remote add -d myremote s3://my-bucket/dvc-store
dvc push
```

> [!TIP]
> Never commit large datasets to Git. Use DVC to version data files and store them in S3/GCS. The `.dvc` file (a small pointer) goes in Git, the actual data goes to your remote.

---

## 🔧 Feature Engineering

### Numerical Features

```python
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler

# StandardScaler: mean=0, std=1 (best for most models)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)  # fit on TRAIN only
X_val_scaled = scaler.transform(X_val)            # transform val/test
X_test_scaled = scaler.transform(X_test)
```

### Categorical Features

```python
from sklearn.preprocessing import OneHotEncoder, LabelEncoder
import pandas as pd

# One-hot encoding (for low cardinality)
encoder = OneHotEncoder(sparse_output=False, handle_unknown="ignore")
X_train_encoded = encoder.fit_transform(X_train[["category", "region"]])

# Label encoding (for tree-based models)
le = LabelEncoder()
X_train["category_encoded"] = le.fit_transform(X_train["category"])
```

### Feature Pipeline

| Feature Type | Techniques | When to Use |
|-------------|-----------|-------------|
| **Numerical** | StandardScaler, MinMaxScaler, log transform | Always scale for linear/neural models |
| **Categorical** | One-hot, label encoding, target encoding | One-hot for low cardinality (<20 values) |
| **Text** | TF-IDF, word embeddings, sentence embeddings | TF-IDF for baselines, embeddings for deep learning |
| **Missing values** | Mean/median impute, KNN impute, indicator column | Add "is_missing" indicator for informative missingness |
| **Datetime** | Extract year/month/day/hour, cyclical encoding | Cyclical encoding for hour-of-day, day-of-week |

> [!WARNING]
> **Data leakage**: Always `fit` preprocessing steps on the training set only, then `transform` validation/test. Fitting on the full dataset leaks test information into training.

---

## 🏋️ Training Pipeline

### scikit-learn Pipeline

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import classification_report

# Define column groups
numeric_features = ["age", "income", "score"]
categorical_features = ["category", "region"]

# Build preprocessing pipeline
preprocessor = ColumnTransformer(
    transformers=[
        ("num", StandardScaler(), numeric_features),
        ("cat", OneHotEncoder(handle_unknown="ignore"), categorical_features),
    ]
)

# Full pipeline: preprocess + model
pipeline = Pipeline([
    ("preprocessor", preprocessor),
    ("classifier", GradientBoostingClassifier(
        n_estimators=200,
        learning_rate=0.1,
        max_depth=5,
        random_state=42,
    )),
])

# Train
pipeline.fit(X_train, y_train)

# Evaluate
y_pred = pipeline.predict(X_val)
print(classification_report(y_val, y_pred))
```

### PyTorch Training Loop

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

class SimpleModel(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super().__init__()
        self.network = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(hidden_dim, hidden_dim // 2),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(hidden_dim // 2, output_dim),
        )

    def forward(self, x):
        return self.network(x)

# Setup
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = SimpleModel(input_dim=128, hidden_dim=256, output_dim=10).to(device)
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=1e-2)
criterion = nn.CrossEntropyLoss()
scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=50)

# Training loop
for epoch in range(50):
    model.train()
    total_loss = 0
    for batch_X, batch_y in train_loader:
        batch_X, batch_y = batch_X.to(device), batch_y.to(device)

        optimizer.zero_grad()
        outputs = model(batch_X)
        loss = criterion(outputs, batch_y)
        loss.backward()
        torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
        optimizer.step()

        total_loss += loss.item()

    scheduler.step()

    # Validation
    model.eval()
    correct, total = 0, 0
    with torch.no_grad():
        for batch_X, batch_y in val_loader:
            batch_X, batch_y = batch_X.to(device), batch_y.to(device)
            outputs = model(batch_X)
            _, predicted = torch.max(outputs, 1)
            total += batch_y.size(0)
            correct += (predicted == batch_y).sum().item()

    val_acc = correct / total
    print(f"Epoch {epoch+1}: Loss={total_loss/len(train_loader):.4f}, Val Acc={val_acc:.4f}")
```

---

## 📈 Experiment Tracking

### MLflow Setup

```python
import mlflow
import mlflow.sklearn

# Set tracking URI (local or remote)
mlflow.set_tracking_uri("http://localhost:5000")  # or "sqlite:///mlflow.db"
mlflow.set_experiment("my-classification-experiment")

with mlflow.start_run(run_name="gradient_boosting_v1"):
    # Log parameters
    mlflow.log_params({
        "n_estimators": 200,
        "learning_rate": 0.1,
        "max_depth": 5,
        "train_size": len(X_train),
    })

    # Train
    pipeline.fit(X_train, y_train)
    y_pred = pipeline.predict(X_val)

    # Log metrics
    mlflow.log_metrics({
        "val_accuracy": accuracy_score(y_val, y_pred),
        "val_f1_weighted": f1_score(y_val, y_pred, average="weighted"),
        "val_precision": precision_score(y_val, y_pred, average="weighted"),
        "val_recall": recall_score(y_val, y_pred, average="weighted"),
    })

    # Log model artifact
    mlflow.sklearn.log_model(pipeline, "model")

    # Log confusion matrix plot
    import matplotlib.pyplot as plt
    from sklearn.metrics import ConfusionMatrixDisplay
    fig, ax = plt.subplots(figsize=(8, 6))
    ConfusionMatrixDisplay.from_predictions(y_val, y_pred, ax=ax)
    mlflow.log_figure(fig, "confusion_matrix.png")
```

### Experiment Tracking Comparison

| Tool | Hosting | Cost | Best For |
|------|---------|------|----------|
| **MLflow** | Self-hosted / Databricks | Free (self-hosted) | Teams wanting full control |
| **W&B** | Cloud | Free tier + paid | Best UI, collaboration features |
| **Neptune** | Cloud | Free tier + paid | Experiment comparison |
| **Comet** | Cloud / Self-hosted | Free tier + paid | Real-time experiment monitoring |

---

## 🎛️ Hyperparameter Tuning

### Optuna (Bayesian Optimization)

```python
import optuna
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.metrics import f1_score

def objective(trial):
    params = {
        "n_estimators": trial.suggest_int("n_estimators", 50, 500),
        "learning_rate": trial.suggest_float("learning_rate", 1e-3, 0.3, log=True),
        "max_depth": trial.suggest_int("max_depth", 3, 10),
        "min_samples_split": trial.suggest_int("min_samples_split", 2, 20),
        "subsample": trial.suggest_float("subsample", 0.5, 1.0),
    }

    model = GradientBoostingClassifier(**params, random_state=42)
    model.fit(X_train_processed, y_train)
    y_pred = model.predict(X_val_processed)

    return f1_score(y_val, y_pred, average="weighted")

# Run optimization
study = optuna.create_study(direction="maximize")
study.optimize(objective, n_trials=100, timeout=3600)  # 100 trials or 1 hour

print(f"Best F1: {study.best_trial.value:.4f}")
print(f"Best params: {study.best_trial.params}")
```

| Method | Speed | Quality | When to Use |
|--------|-------|---------|-------------|
| **Grid Search** | Slow | Exhaustive | Few parameters, small search space |
| **Random Search** | Fast | Good | Many parameters, first exploration |
| **Bayesian (Optuna)** | Medium | Best | Production tuning, iterative refinement |
| **Early Stopping** | Fast | Good | Neural networks, boosting models |

---

## 📏 Evaluation Metrics

### By Task Type

| Task | Metrics | When |
|------|---------|------|
| **Binary Classification** | Accuracy, Precision, Recall, F1, AUC-ROC | Balanced classes: Accuracy. Imbalanced: F1 + AUC-ROC |
| **Multi-class Classification** | Accuracy, Macro/Weighted F1, Confusion Matrix | Weighted F1 for imbalanced, Macro F1 for equal importance |
| **Regression** | MSE, RMSE, MAE, R-squared | RMSE penalizes large errors, MAE for robust measurement |
| **Ranking** | MRR, NDCG, MAP | MRR for first-result quality, NDCG for full ranking |
| **NLP Generation** | BLEU, ROUGE, Perplexity | BLEU for translation, ROUGE for summarization |

### Cross-Validation

```python
from sklearn.model_selection import cross_val_score, StratifiedKFold

cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

scores = cross_val_score(
    pipeline, X_train, y_train,
    cv=cv, scoring="f1_weighted", n_jobs=-1
)

print(f"CV F1: {scores.mean():.4f} +/- {scores.std():.4f}")
```

> [!TIP]
> For time series data, **never use standard k-fold**. Use `TimeSeriesSplit` to prevent leaking future data into training. Each fold must have training data that is strictly before validation data in time.

---

## 🤖 LLM Fine-Tuning

### Hugging Face + LoRA Setup

```python
from transformers import (
    AutoModelForCausalLM, AutoTokenizer,
    TrainingArguments, Trainer
)
from peft import LoraConfig, get_peft_model, TaskType
from datasets import load_dataset

# Load base model
model_name = "meta-llama/Llama-3.1-8B"
tokenizer = AutoTokenizer.from_pretrained(model_name)
tokenizer.pad_token = tokenizer.eos_token

model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    device_map="auto",
    load_in_4bit=True,  # QLoRA: 4-bit quantization
)

# LoRA configuration
lora_config = LoraConfig(
    task_type=TaskType.CAUSAL_LM,
    r=16,                    # Rank
    lora_alpha=32,           # Scaling
    lora_dropout=0.05,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
)

model = get_peft_model(model, lora_config)
model.print_trainable_parameters()  # ~0.5% of total params

# Prepare dataset (instruction format)
dataset = load_dataset("json", data_files="train_data.jsonl")

def format_prompt(example):
    return {
        "text": f"### Instruction:\n{example['instruction']}\n\n"
                f"### Input:\n{example['input']}\n\n"
                f"### Response:\n{example['output']}"
    }

dataset = dataset.map(format_prompt)

# Training arguments
training_args = TrainingArguments(
    output_dir="./results",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-4,
    fp16=True,
    logging_steps=10,
    save_strategy="epoch",
    evaluation_strategy="epoch",
    warmup_ratio=0.03,
    lr_scheduler_type="cosine",
)

# Train
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset["train"],
    eval_dataset=dataset.get("validation"),
    tokenizer=tokenizer,
)
trainer.train()

# Save LoRA adapter
model.save_pretrained("./my-finetuned-adapter")
```

---

## 💾 Model Serialization

| Format | Framework | Cross-Platform | Best For |
|--------|-----------|---------------|----------|
| **pickle/joblib** | scikit-learn | Python only | Quick save/load for sklearn models |
| **ONNX** | Any → ONNX runtime | Yes | Production inference, cross-framework |
| **TorchScript** | PyTorch | Yes (C++/Python) | PyTorch production deployment |
| **SavedModel** | TensorFlow | Yes (TF Serving) | TensorFlow production deployment |
| **safetensors** | Hugging Face | Yes | LLM weights (safe, fast loading) |

```python
# scikit-learn: joblib
import joblib
joblib.dump(pipeline, "models/pipeline_v1.joblib")
loaded = joblib.load("models/pipeline_v1.joblib")

# PyTorch: state dict
torch.save(model.state_dict(), "models/model_v1.pt")
model.load_state_dict(torch.load("models/model_v1.pt"))

# ONNX export
import torch.onnx
dummy_input = torch.randn(1, 128).to(device)
torch.onnx.export(model, dummy_input, "models/model_v1.onnx")
```

---

## ⚠️ Common Pitfalls

| Pitfall | Why It Matters | Prevention |
|---------|---------------|------------|
| **Data leakage** | Model sees test data during training, inflated metrics | Strict train/val/test separation, fit on train only |
| **Overfitting** | Model memorizes training data, fails on new data | Early stopping, regularization, more data |
| **Class imbalance** | Model predicts majority class, ignores minority | SMOTE, class weights, stratified splits |
| **Not versioning data** | Cannot reproduce results | DVC, dataset checksums |
| **Training on test set** | No unbiased evaluation | Touch test set exactly once, at the very end |
| **Wrong metric** | Optimizing for wrong objective | Match metric to business goal (e.g., recall for fraud) |

---

## ✅ EXIT CHECKLIST

- [ ] Data versioned with DVC or equivalent
- [ ] Train/validation/test splits created with stratification
- [ ] No data leakage (preprocessing fit on train only)
- [ ] Feature engineering pipeline reproducible
- [ ] Experiments tracked with MLflow/W&B (params, metrics, artifacts)
- [ ] Hyperparameters tuned with Optuna or equivalent
- [ ] Cross-validation performed (k-fold or time series split)
- [ ] Best model selected based on validation metrics
- [ ] Final evaluation on test set (one-time, unbiased)
- [ ] Evaluation metrics documented and match business objectives
- [ ] Model serialized in production-ready format
- [ ] Training is reproducible (random seeds, versioned code + data)
- [ ] GPU utilization optimized (mixed precision, gradient accumulation)

---

*Skill Version: 1.0 | Created: February 2026*
