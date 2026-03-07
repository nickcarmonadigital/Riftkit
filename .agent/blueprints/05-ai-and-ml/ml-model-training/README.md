# Blueprint: ML Model Training

Traditional machine learning model training: tabular data, scikit-learn, XGBoost/LightGBM, experiment tracking, feature engineering, and model deployment. Not deep learning -- use computer-vision or fine-tuning-pipeline for neural networks.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| scikit-learn + pandas | Prototyping, small-medium datasets, classical algorithms |
| XGBoost / LightGBM | Tabular data competitions, production gradient boosting |
| MLflow + scikit-learn | Experiment tracking, model registry, reproducibility |
| Ray + XGBoost | Distributed training, hyperparameter tuning at scale |
| PyCaret | Low-code ML, rapid model comparison, AutoML |
| Feature Store (Feast/Tecton) + XGBoost | Production feature pipelines, real-time inference |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define prediction target, success metric, data availability
- **prd_generator** -- Document feature requirements, latency SLA, accuracy threshold
- **competitive_analysis** -- Benchmark against existing solutions or simple baselines

Key scoping questions:
- What are you predicting? (Classification, regression, ranking, clustering)
- What is the business metric? (Not just accuracy -- revenue impact, cost savings)
- How fresh must predictions be? (Batch daily vs real-time <100ms)
- What data is available at prediction time? (Training features must be available at inference)

### Phase 2: Architecture
- **schema_design** -- Feature store schema, training data tables, prediction output format
- **api_design** -- Prediction API, batch prediction interface, model versioning

Architecture patterns:
- **Batch prediction**: Train offline -> predict on schedule -> store results in DB -> serve from cache
- **Real-time prediction**: Train offline -> deploy model -> inference API -> predict on request
- **Online learning**: Continuous training on new data -> rolling model updates (rare, complex)

### Phase 3: Implementation
- **tdd_workflow** -- Test feature engineering, validate model input/output shapes
- **error_handling** -- Handle missing features, schema drift, model loading failures
- **code_review** -- Review feature engineering for data leakage, metric calculations

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end: raw data -> features -> prediction -> output format
- **security_audit** -- Model fairness audit, PII in features, adversarial input robustness

### Phase 5: Deployment
- **ci_cd_pipeline** -- Automated retraining, model registry promotion, shadow deployment
- **deployment_patterns** -- Model serving (BentoML, Seldon), containerized inference
- **monitoring_setup** -- Prediction drift, feature drift, model performance decay

## Key Domain-Specific Concerns

### Feature Engineering
- This is where 80% of model performance comes from, not algorithm selection
- Start with simple features: counts, ratios, time-since, rolling aggregates
- Handle missing values explicitly: imputation strategy per feature, never silently drop
- Encode categoricals appropriately: one-hot for low cardinality, target encoding for high
- Create interaction features for known domain relationships
- Always compute features identically in training and inference (feature store helps)
- Watch for data leakage: never use future information or the target variable as a feature

### Model Selection Guide

| Task | Start With | Upgrade To |
|------|-----------|------------|
| Binary Classification | Logistic Regression | XGBoost / LightGBM |
| Multi-class Classification | Random Forest | XGBoost / LightGBM |
| Regression | Ridge Regression | XGBoost / LightGBM |
| Ranking | LambdaMART (LightGBM) | -- |
| Anomaly Detection | Isolation Forest | -- |
| Clustering | K-Means | HDBSCAN |
| Time Series | Prophet / statsmodels | LightGBM with lag features |

### Experiment Tracking
- Log every run: hyperparameters, metrics, data version, code version
- Use MLflow, Weights & Biases, or Neptune -- never track in spreadsheets
- Tag experiments with meaningful names, not auto-generated IDs
- Save the full training pipeline as an artifact, not just the model weights
- Compare runs with identical test sets for fair comparison

### Hyperparameter Tuning
- Start with reasonable defaults, then tune systematically
- Use Optuna or Ray Tune for Bayesian optimization (not grid search)
- Tune on validation set, never on test set
- XGBoost key params: learning_rate, max_depth, n_estimators, min_child_weight, subsample
- Always set early stopping to prevent overfitting during tuning

### Evaluation
- Use stratified k-fold cross-validation (5-fold standard, 10-fold for small data)
- Primary metric should match business objective (precision vs recall tradeoff)
- Always compare against a baseline: majority class, mean prediction, or previous model
- Check calibration for classification: predicted probabilities should match observed rates
- Evaluate per-segment: model may perform well overall but fail on a subgroup

### Production Monitoring
- Track prediction distribution drift (KS test, PSI)
- Track feature distribution drift separately from model drift
- Set up automated retraining triggers when drift exceeds threshold
- A/B test new models against the current production model
- Log predictions with timestamps for retrospective analysis

## Getting Started

1. **Define the problem** -- Classification or regression? What metric matters?
2. **Gather and explore data** -- EDA with pandas profiling, understand distributions
3. **Establish a baseline** -- Simple model (logistic regression, mean) as comparison point
4. **Engineer features** -- Domain-driven feature creation, handle missing values
5. **Train initial models** -- Compare 3-4 algorithms with default hyperparameters
6. **Tune the best model** -- Optuna/Ray Tune on validation set
7. **Evaluate rigorously** -- Cross-validation, per-segment analysis, calibration
8. **Set up experiment tracking** -- MLflow or W&B for reproducibility
9. **Build inference pipeline** -- Feature computation + model prediction in one path
10. **Deploy and monitor** -- Serve predictions, track drift, set retraining schedule

## Project Structure

```
src/
  data/
    ingest.py               # Data loading from sources
    features.py             # Feature engineering pipeline
    splits.py               # Train/val/test splitting
    validation.py           # Data quality checks
  models/
    train.py                # Training script
    evaluate.py             # Metrics computation
    tune.py                 # Hyperparameter optimization
    baseline.py             # Baseline model for comparison
  serving/
    predict.py              # Inference pipeline
    api.py                  # FastAPI prediction endpoint
    batch.py                # Batch prediction job
  monitoring/
    drift.py                # Feature and prediction drift
    performance.py          # Model performance tracking
configs/
  experiment.yaml           # Hyperparameters, feature config
  features.yaml             # Feature definitions and types
notebooks/
  01_eda.ipynb              # Exploratory data analysis
  02_feature_exploration.ipynb
  03_model_comparison.ipynb
data/
  raw/                      # Original datasets
  processed/                # Feature-engineered datasets
models/                     # Serialized model artifacts
mlruns/                     # MLflow experiment logs
```
