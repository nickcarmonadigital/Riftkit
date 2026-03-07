---
name: AI Model Monitoring
description: Monitor ML models in production for data drift, concept drift, performance degradation, and automated retraining triggers
---

# AI Model Monitoring Skill

**Purpose**: Detect and respond to model degradation in production through systematic monitoring of data drift, concept drift, prediction quality, and operational metrics with automated alerting and retraining triggers.

---

## TRIGGER COMMANDS

```text
"Set up monitoring for this deployed ML model"
"Detect data drift and concept drift in production"
"Configure alerts and retraining triggers for model degradation"
"Using ai_model_monitoring skill: [task]"
```

---

## Monitoring Architecture

```
+------------------+     +------------------+     +------------------+
|   Production     |     |   Monitoring     |     |   Response       |
|   Traffic        |     |   Pipeline       |     |   Actions        |
+--------+---------+     +--------+---------+     +--------+---------+
         |                        |                        |
    +----v----+              +----v----+              +----v----+
    | Feature |              | Drift   |              | Alert   |
    | Logging |              | Detect  |              | Manager |
    +----+----+              +----+----+              +----+----+
         |                        |                        |
    +----v----+              +----v----+              +----v----+
    | Predict |              | Perf    |              | Retrain |
    | Logging |              | Monitor |              | Trigger |
    +----+----+              +----+----+              +----+----+
         |                        |                        |
    +----v----+              +----v----+              +----v----+
    | Ground  |              | Report  |              | Shadow  |
    | Truth   |              | Generate|              | Deploy  |
    +---------+              +---------+              +---------+
```

---

## Types of Model Degradation

| Type | What Changes | Detection Speed | Example |
|------|-------------|----------------|---------|
| Data drift | Input feature distributions | Fast (hours) | User demographics shift |
| Concept drift | Relationship between features and target | Slow (days-weeks) | Customer behavior changes |
| Prediction drift | Output distribution changes | Fast (hours) | Model predicts more positives |
| Performance degradation | Accuracy/F1 drops | Depends on ground truth lag | Model accuracy drops 5% |
| Data quality issues | Missing values, outliers, schema | Fast (minutes) | New categorical value appears |
| Upstream data changes | Source schema or pipeline breaks | Fast (minutes) | Feature column renamed |

### Drift Detection Decision Tree

```
Model performance dropped?
  |
  +-- YES: Ground truth available?
  |     +-- YES --> Measure actual performance, compare to baseline
  |     +-- NO  --> Check prediction distribution shift (proxy)
  |
  +-- NO (or unknown): Check input data
        +-- Feature distributions shifted? --> Data drift
        +-- New categories or value ranges? --> Data quality
        +-- Missing features? --> Upstream pipeline issue
        +-- Everything looks normal --> Concept drift (subtle)
```

---

## Evidently AI Implementation

### Installation and Setup

```bash
pip install evidently
```

### Data Drift Detection

```python
import pandas as pd
from evidently.report import Report
from evidently.metric_preset import DataDriftPreset, DataQualityPreset
from evidently.metrics import (
    DataDriftTable,
    DatasetDriftMetric,
    ColumnDriftMetric,
)

# Reference data (training or baseline period)
reference_data = pd.read_parquet("data/reference.parquet")

# Current production data (recent window)
current_data = pd.read_parquet("data/production_latest.parquet")

# Generate drift report
drift_report = Report(metrics=[
    DatasetDriftMetric(),
    DataDriftTable(),
])

drift_report.run(
    reference_data=reference_data,
    current_data=current_data,
)

# Get results programmatically
results = drift_report.as_dict()
dataset_drift = results["metrics"][0]["result"]
print(f"Dataset drift detected: {dataset_drift['dataset_drift']}")
print(f"Drifted features: {dataset_drift['number_of_drifted_columns']}/{dataset_drift['number_of_columns']}")
print(f"Share of drifted: {dataset_drift['share_of_drifted_columns']:.2%}")

# Save HTML report
drift_report.save_html("reports/drift_report.html")

# Individual column drift
for col_name, col_result in results["metrics"][1]["result"]["drift_by_columns"].items():
    if col_result["drift_detected"]:
        print(f"  DRIFT: {col_name} (p-value: {col_result['p_value']:.4f}, "
              f"method: {col_result['stattest_name']})")
```

### Performance Monitoring with Evidently

```python
from evidently.report import Report
from evidently.metric_preset import ClassificationPreset
from evidently.metrics import (
    ClassificationQualityMetric,
    ClassificationClassBalance,
    ClassificationConfusionMatrix,
)

# When ground truth is available
reference_with_labels = reference_data.copy()
reference_with_labels["prediction"] = baseline_model.predict(reference_data[features])

current_with_labels = current_data.copy()
current_with_labels["prediction"] = prod_model.predict(current_data[features])

performance_report = Report(metrics=[
    ClassificationQualityMetric(),
    ClassificationClassBalance(),
    ClassificationConfusionMatrix(),
])

performance_report.run(
    reference_data=reference_with_labels,
    current_data=current_with_labels,
    column_mapping={
        "target": "actual_label",
        "prediction": "prediction",
    },
)
performance_report.save_html("reports/performance_report.html")
```

### Evidently Monitoring Dashboard (Continuous)

```python
from evidently.ui.workspace import Workspace
from evidently.ui.dashboards import DashboardConfig, PanelValue, ReportFilter
from evidently.renderers.html_widgets import WidgetSize

# Create workspace for continuous monitoring
ws = Workspace.create("monitoring_workspace")

# Add project
project = ws.create_project("churn-model-prod")

# Configure dashboard panels
project.dashboard = DashboardConfig(
    name="Churn Model Monitoring",
    panels=[
        PanelValue(
            title="Dataset Drift Score",
            field_path="DatasetDriftMetric.share_of_drifted_columns",
            size=WidgetSize.HALF,
        ),
        PanelValue(
            title="F1 Score",
            field_path="ClassificationQualityMetric.current.f1",
            size=WidgetSize.HALF,
        ),
    ],
)

# Add snapshots periodically (e.g., hourly cron)
def add_monitoring_snapshot(reference_data, current_data, project):
    report = Report(metrics=[
        DatasetDriftMetric(),
        ClassificationQualityMetric(),
    ])
    report.run(reference_data=reference_data, current_data=current_data)
    ws.add_report(project.id, report)
```

---

## WhyLabs Integration

### Setup and Profiling

```python
# pip install whylogs
import whylogs as why
from whylogs.api.writer.whylabs import WhyLabsWriter

# Configure WhyLabs
import os
os.environ["WHYLABS_DEFAULT_ORG_ID"] = "org-xxxxx"
os.environ["WHYLABS_API_KEY"] = "your-api-key"
os.environ["WHYLABS_DEFAULT_DATASET_ID"] = "model-churn-prod"

# Profile reference data
reference_profile = why.log(reference_data).profile()
reference_profile.set_dataset_timestamp(reference_timestamp)

# Profile production data
production_profile = why.log(production_data).profile()
production_profile.set_dataset_timestamp(production_timestamp)

# Upload to WhyLabs
writer = WhyLabsWriter()
writer.write(production_profile)

# Log individual predictions
result = why.log(
    pd.DataFrame({
        "feature_1": [value_1],
        "feature_2": [value_2],
        "prediction": [pred],
        "confidence": [conf],
    })
)
```

### Custom Monitors

```python
import whylogs as why
from whylogs.core.constraints import ConstraintsBuilder
from whylogs.core.constraints.factories import (
    greater_than_number,
    smaller_than_number,
    no_missing_values,
    is_in_range,
)

# Define data quality constraints
builder = ConstraintsBuilder(reference_profile)
builder.add_constraint(no_missing_values("customer_age"))
builder.add_constraint(is_in_range("customer_age", lower=18, upper=120))
builder.add_constraint(greater_than_number("transaction_amount", 0))
builder.add_constraint(smaller_than_number("prediction_confidence", 1.01))

constraints = builder.build()

# Validate production data against constraints
report = constraints.generate_constraints_report(production_profile)
for constraint_name, result in report.items():
    status = "PASS" if result else "FAIL"
    print(f"  [{status}] {constraint_name}")
```

---

## Custom Monitoring Implementation

### Statistical Drift Detection

```python
import numpy as np
from scipy import stats
from dataclasses import dataclass

@dataclass
class DriftResult:
    feature_name: str
    test_name: str
    statistic: float
    p_value: float
    drift_detected: bool
    threshold: float

def detect_drift_ks(reference: np.ndarray, current: np.ndarray,
                    feature_name: str, threshold: float = 0.05) -> DriftResult:
    """Kolmogorov-Smirnov test for numerical feature drift."""
    stat, p_value = stats.ks_2samp(reference, current)
    return DriftResult(
        feature_name=feature_name,
        test_name="Kolmogorov-Smirnov",
        statistic=stat,
        p_value=p_value,
        drift_detected=p_value < threshold,
        threshold=threshold,
    )

def detect_drift_psi(reference: np.ndarray, current: np.ndarray,
                     feature_name: str, bins: int = 10,
                     threshold: float = 0.2) -> DriftResult:
    """Population Stability Index for drift detection."""
    # Create bins from reference distribution
    breakpoints = np.percentile(reference, np.linspace(0, 100, bins + 1))
    breakpoints[0] = -np.inf
    breakpoints[-1] = np.inf

    ref_counts = np.histogram(reference, bins=breakpoints)[0]
    cur_counts = np.histogram(current, bins=breakpoints)[0]

    # Avoid zeros
    ref_pct = (ref_counts + 1) / (len(reference) + bins)
    cur_pct = (cur_counts + 1) / (len(current) + bins)

    psi = np.sum((cur_pct - ref_pct) * np.log(cur_pct / ref_pct))

    return DriftResult(
        feature_name=feature_name,
        test_name="PSI",
        statistic=psi,
        p_value=-1,  # PSI doesn't have p-value
        drift_detected=psi > threshold,
        threshold=threshold,
    )

def detect_drift_chi2(reference: np.ndarray, current: np.ndarray,
                      feature_name: str, threshold: float = 0.05) -> DriftResult:
    """Chi-squared test for categorical feature drift."""
    ref_counts = pd.Series(reference).value_counts()
    cur_counts = pd.Series(current).value_counts()

    # Align categories
    all_categories = set(ref_counts.index) | set(cur_counts.index)
    ref_aligned = np.array([ref_counts.get(c, 0) for c in all_categories])
    cur_aligned = np.array([cur_counts.get(c, 0) for c in all_categories])

    stat, p_value = stats.chisquare(cur_aligned, f_exp=ref_aligned * cur_aligned.sum() / ref_aligned.sum())

    return DriftResult(
        feature_name=feature_name,
        test_name="Chi-Squared",
        statistic=stat,
        p_value=p_value,
        drift_detected=p_value < threshold,
        threshold=threshold,
    )

class DriftMonitor:
    """Monitor a set of features for drift."""

    def __init__(self, reference_data: pd.DataFrame, numerical_features: list[str],
                 categorical_features: list[str]):
        self.reference = reference_data
        self.numerical = numerical_features
        self.categorical = categorical_features

    def check(self, current_data: pd.DataFrame) -> list[DriftResult]:
        results = []
        for feat in self.numerical:
            results.append(detect_drift_psi(
                self.reference[feat].values,
                current_data[feat].values,
                feature_name=feat,
            ))
        for feat in self.categorical:
            results.append(detect_drift_chi2(
                self.reference[feat].values,
                current_data[feat].values,
                feature_name=feat,
            ))
        return results

    def summary(self, results: list[DriftResult]) -> dict:
        drifted = [r for r in results if r.drift_detected]
        return {
            "total_features": len(results),
            "drifted_features": len(drifted),
            "drift_rate": len(drifted) / len(results) if results else 0,
            "drifted_names": [r.feature_name for r in drifted],
            "details": [
                {"feature": r.feature_name, "test": r.test_name,
                 "statistic": r.statistic, "p_value": r.p_value,
                 "drift": r.drift_detected}
                for r in results
            ],
        }
```

### Prediction Monitoring

```python
import numpy as np
from collections import deque
from datetime import datetime

class PredictionMonitor:
    """Monitor prediction distributions and model confidence over time."""

    def __init__(self, window_size: int = 1000, alert_threshold: float = 0.1):
        self.window_size = window_size
        self.alert_threshold = alert_threshold
        self.predictions = deque(maxlen=window_size)
        self.confidences = deque(maxlen=window_size)
        self.baseline_positive_rate = None
        self.baseline_avg_confidence = None

    def set_baseline(self, predictions: np.ndarray, confidences: np.ndarray):
        self.baseline_positive_rate = predictions.mean()
        self.baseline_avg_confidence = confidences.mean()

    def log_prediction(self, prediction: int, confidence: float):
        self.predictions.append(prediction)
        self.confidences.append(confidence)

    def check_alerts(self) -> list[dict]:
        if len(self.predictions) < self.window_size // 2:
            return []

        alerts = []
        current_preds = np.array(self.predictions)
        current_confs = np.array(self.confidences)

        # Positive rate shift
        current_positive_rate = current_preds.mean()
        rate_diff = abs(current_positive_rate - self.baseline_positive_rate)
        if rate_diff > self.alert_threshold:
            alerts.append({
                "type": "prediction_distribution_shift",
                "severity": "high" if rate_diff > 2 * self.alert_threshold else "medium",
                "message": f"Positive rate shifted from {self.baseline_positive_rate:.3f} "
                           f"to {current_positive_rate:.3f} (delta: {rate_diff:.3f})",
                "timestamp": datetime.utcnow().isoformat(),
            })

        # Confidence drop
        current_avg_conf = current_confs.mean()
        conf_diff = self.baseline_avg_confidence - current_avg_conf
        if conf_diff > 0.05:
            alerts.append({
                "type": "confidence_degradation",
                "severity": "high" if conf_diff > 0.1 else "medium",
                "message": f"Average confidence dropped from {self.baseline_avg_confidence:.3f} "
                           f"to {current_avg_conf:.3f} (delta: {conf_diff:.3f})",
                "timestamp": datetime.utcnow().isoformat(),
            })

        # Low confidence spike
        low_conf_rate = (current_confs < 0.5).mean()
        if low_conf_rate > 0.2:
            alerts.append({
                "type": "low_confidence_spike",
                "severity": "high",
                "message": f"{low_conf_rate:.1%} of predictions have confidence < 0.5",
                "timestamp": datetime.utcnow().isoformat(),
            })

        return alerts
```

---

## Alerting and Retraining Triggers

### Alert Configuration

```yaml
# monitoring-config.yaml
model_name: churn-classifier
version: 3

drift_monitoring:
  schedule: "0 */6 * * *"  # Every 6 hours
  window_size: 10000
  reference_dataset: "s3://data/reference/churn_reference.parquet"
  thresholds:
    dataset_drift_share: 0.3  # Alert if >30% features drift
    psi_threshold: 0.2
    ks_p_value: 0.01

performance_monitoring:
  schedule: "0 0 * * *"  # Daily
  ground_truth_lag_hours: 24
  thresholds:
    f1_score_min: 0.82
    accuracy_min: 0.88
    f1_drop_from_baseline: 0.03

prediction_monitoring:
  schedule: "*/30 * * * *"  # Every 30 minutes
  thresholds:
    positive_rate_shift: 0.1
    avg_confidence_drop: 0.05
    low_confidence_rate: 0.2

alerts:
  channels:
    - type: slack
      webhook: "${SLACK_WEBHOOK_URL}"
      severity: ["high", "critical"]
    - type: pagerduty
      routing_key: "${PD_ROUTING_KEY}"
      severity: ["critical"]
    - type: email
      recipients: ["ml-team@company.com"]
      severity: ["medium", "high", "critical"]

retraining_triggers:
  auto_retrain:
    enabled: true
    conditions:
      - "f1_score < 0.80 for 3 consecutive checks"
      - "dataset_drift_share > 0.5"
    pipeline: "arn:aws:sagemaker:pipeline/churn-retrain"
  manual_review:
    conditions:
      - "f1_score < 0.85 for 2 consecutive checks"
      - "dataset_drift_share > 0.3"
    notify: "ml-lead@company.com"
```

### Retraining Trigger Logic

```python
from datetime import datetime, timedelta

class RetrainingTrigger:
    def __init__(self, config: dict):
        self.config = config
        self.check_history: list[dict] = []

    def evaluate(self, current_metrics: dict) -> dict:
        """Evaluate if retraining should be triggered."""
        self.check_history.append({
            "timestamp": datetime.utcnow(),
            "metrics": current_metrics,
        })

        # Keep last 30 days of history
        cutoff = datetime.utcnow() - timedelta(days=30)
        self.check_history = [
            c for c in self.check_history if c["timestamp"] > cutoff
        ]

        triggers = []

        # Check auto-retrain conditions
        auto_config = self.config.get("auto_retrain", {})
        if auto_config.get("enabled"):
            # Consecutive F1 drops
            recent = self.check_history[-3:]
            if len(recent) >= 3:
                all_below = all(
                    c["metrics"].get("f1_score", 1.0) < 0.80 for c in recent
                )
                if all_below:
                    triggers.append({
                        "type": "auto_retrain",
                        "reason": "F1 below 0.80 for 3 consecutive checks",
                        "action": "trigger_pipeline",
                        "pipeline": auto_config.get("pipeline"),
                    })

            # Severe drift
            if current_metrics.get("dataset_drift_share", 0) > 0.5:
                triggers.append({
                    "type": "auto_retrain",
                    "reason": "Dataset drift share exceeds 50%",
                    "action": "trigger_pipeline",
                    "pipeline": auto_config.get("pipeline"),
                })

        # Check manual review conditions
        manual_config = self.config.get("manual_review", {})
        recent_2 = self.check_history[-2:]
        if len(recent_2) >= 2:
            all_below_85 = all(
                c["metrics"].get("f1_score", 1.0) < 0.85 for c in recent_2
            )
            if all_below_85:
                triggers.append({
                    "type": "manual_review",
                    "reason": "F1 below 0.85 for 2 consecutive checks",
                    "action": "notify",
                    "notify": manual_config.get("notify"),
                })

        return {
            "triggered": len(triggers) > 0,
            "triggers": triggers,
            "current_metrics": current_metrics,
            "timestamp": datetime.utcnow().isoformat(),
        }
```

---

## A/B Analysis for Model Comparison

```python
import numpy as np
from scipy import stats

def analyze_ab_test(control_conversions: np.ndarray,
                    treatment_conversions: np.ndarray,
                    confidence_level: float = 0.95) -> dict:
    """Analyze A/B test results between two model versions."""
    n_control = len(control_conversions)
    n_treatment = len(treatment_conversions)

    rate_control = control_conversions.mean()
    rate_treatment = treatment_conversions.mean()

    # Two-proportion z-test
    pooled_rate = (control_conversions.sum() + treatment_conversions.sum()) / (n_control + n_treatment)
    se = np.sqrt(pooled_rate * (1 - pooled_rate) * (1/n_control + 1/n_treatment))
    z_stat = (rate_treatment - rate_control) / se
    p_value = 2 * (1 - stats.norm.cdf(abs(z_stat)))

    # Confidence interval for difference
    se_diff = np.sqrt(
        rate_control * (1 - rate_control) / n_control +
        rate_treatment * (1 - rate_treatment) / n_treatment
    )
    z_crit = stats.norm.ppf(1 - (1 - confidence_level) / 2)
    ci_lower = (rate_treatment - rate_control) - z_crit * se_diff
    ci_upper = (rate_treatment - rate_control) + z_crit * se_diff

    # Relative lift
    relative_lift = (rate_treatment - rate_control) / rate_control if rate_control > 0 else float("inf")

    return {
        "control_rate": rate_control,
        "treatment_rate": rate_treatment,
        "absolute_difference": rate_treatment - rate_control,
        "relative_lift": relative_lift,
        "p_value": p_value,
        "significant": p_value < (1 - confidence_level),
        "confidence_interval": (ci_lower, ci_upper),
        "n_control": n_control,
        "n_treatment": n_treatment,
        "recommendation": (
            "Deploy treatment" if p_value < 0.05 and relative_lift > 0
            else "Keep control" if p_value < 0.05
            else "Inconclusive - need more data"
        ),
    }
```

---

## Monitoring Cron Job

```python
#!/usr/bin/env python3
"""Production model monitoring cron job."""

import pandas as pd
import json
import requests
from datetime import datetime, timedelta

def run_monitoring_cycle():
    # 1. Load reference and current data
    reference = pd.read_parquet("s3://data/reference/baseline.parquet")
    current = pd.read_parquet("s3://data/production/last_24h.parquet")

    # 2. Run drift detection
    monitor = DriftMonitor(reference, numerical_features, categorical_features)
    drift_results = monitor.check(current)
    drift_summary = monitor.summary(drift_results)

    # 3. Check performance (if ground truth available)
    perf_metrics = {}
    if "actual_label" in current.columns:
        perf_metrics = {
            "f1_score": f1_score(current["actual_label"], current["prediction"], average="weighted"),
            "accuracy": accuracy_score(current["actual_label"], current["prediction"]),
        }

    # 4. Combine metrics
    all_metrics = {**drift_summary, **perf_metrics}

    # 5. Evaluate retraining triggers
    trigger = RetrainingTrigger(config)
    trigger_result = trigger.evaluate(all_metrics)

    # 6. Send alerts if needed
    if trigger_result["triggered"]:
        for t in trigger_result["triggers"]:
            send_alert(t)

    # 7. Log to monitoring dashboard
    log_metrics_to_dashboard(all_metrics)

    return all_metrics

if __name__ == "__main__":
    run_monitoring_cycle()
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track baseline metrics during training
- Related: `5-ship/model_registry_management` -- Trigger rollbacks when monitoring detects issues
- Related: `5-ship/mlops_pipeline` -- Integrate monitoring into automated pipelines
- Related: `2-design/feature_store_design` -- Monitor feature pipelines feeding the model
- Related: `toolkit/ai_cost_optimization` -- Monitor inference costs alongside performance

---

## EXIT CHECKLIST

- [ ] Reference dataset established from training data or baseline period
- [ ] Data drift monitoring configured for all input features
- [ ] Performance monitoring set up with ground truth pipeline
- [ ] Prediction distribution monitoring active (positive rate, confidence)
- [ ] Data quality constraints defined and validated
- [ ] Alert channels configured (Slack, PagerDuty, email)
- [ ] Retraining triggers defined with clear thresholds
- [ ] Rollback procedure documented and tested
- [ ] Monitoring dashboard deployed and accessible to team
- [ ] Monitoring cron job scheduled and tested
- [ ] A/B test analysis framework ready for model comparisons

---

*Skill Version: 1.0 | Created: March 2026*
