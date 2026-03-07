---
name: Responsible AI Framework
description: Implement responsible AI practices including fairness, bias detection, explainability, transparency, model cards, and regulatory compliance
---

# Responsible AI Framework Skill

**Purpose**: Build AI systems that are fair, transparent, explainable, and compliant with regulatory requirements through systematic bias detection, model documentation, audit trails, and responsible deployment practices.

---

## TRIGGER COMMANDS

```text
"Audit this model for bias and fairness"
"Set up explainability and transparency for the AI system"
"Create model documentation and compliance artifacts"
"Using responsible_ai_framework skill: [task]"
```

---

## Responsible AI Pillars

```
Responsible AI Framework:
+-- Fairness
|   +-- Bias detection in data and models
|   +-- Disparate impact analysis
|   +-- Fairness metrics across groups
|   +-- Mitigation strategies
|
+-- Transparency
|   +-- Model cards and documentation
|   +-- Decision audit trails
|   +-- Data provenance tracking
|   +-- Stakeholder communication
|
+-- Explainability
|   +-- Feature importance (SHAP, LIME)
|   +-- Global vs local explanations
|   +-- Counterfactual explanations
|   +-- Human-readable rationales
|
+-- Accountability
|   +-- Governance processes
|   +-- Regulatory compliance (EU AI Act, NIST AI RMF)
|   +-- Incident response procedures
|   +-- Regular audits and reviews
|
+-- Privacy
|   +-- Data minimization
|   +-- Differential privacy
|   +-- Federated learning
|   +-- Right to explanation
```

---

## Bias Detection and Fairness

### AI Fairness 360 (AIF360)

```bash
pip install aif360
```

```python
from aif360.datasets import BinaryLabelDataset
from aif360.metrics import BinaryLabelDatasetMetric, ClassificationMetric
from aif360.algorithms.preprocessing import Reweighing
import pandas as pd
import numpy as np

# Prepare dataset
df = pd.read_csv("credit_decisions.csv")

# Define protected attributes
dataset = BinaryLabelDataset(
    df=df,
    label_names=["approved"],
    protected_attribute_names=["gender", "race"],
    favorable_label=1,
    unfavorable_label=0,
)

# Define privileged and unprivileged groups
privileged_groups = [{"gender": 1}]  # 1 = male
unprivileged_groups = [{"gender": 0}]  # 0 = female

# Measure dataset bias
metric = BinaryLabelDatasetMetric(
    dataset,
    unprivileged_groups=unprivileged_groups,
    privileged_groups=privileged_groups,
)

print(f"Disparate Impact: {metric.disparate_impact():.3f}")
print(f"Statistical Parity Difference: {metric.statistical_parity_difference():.3f}")
print(f"Mean Difference: {metric.mean_difference():.3f}")

# Interpretation:
# Disparate Impact: ratio of favorable outcomes (1.0 = fair, <0.8 = concerning)
# Statistical Parity: difference in positive rates (0.0 = fair)
```

### Fairness Metrics Reference

| Metric | Formula | Fair Value | Use When |
|--------|---------|------------|----------|
| Disparate Impact | P(Y=1 unprivileged) / P(Y=1 privileged) | 0.8-1.25 | Legal compliance |
| Statistical Parity | P(Y=1 unprivileged) - P(Y=1 privileged) | ~0 | Equal opportunity |
| Equal Opportunity | TPR(unprivileged) - TPR(privileged) | ~0 | Qualified applicants |
| Equalized Odds | TPR + FPR parity across groups | ~0 | Both TP and FP matter |
| Predictive Parity | PPV(unprivileged) - PPV(privileged) | ~0 | Prediction reliability |
| Calibration | P(Y=1 score=s) same across groups | Same curve | Risk scoring |

### Classification Fairness Analysis

```python
from aif360.metrics import ClassificationMetric

def analyze_model_fairness(dataset, predictions, privileged_groups, unprivileged_groups):
    """Comprehensive fairness analysis of model predictions."""
    classified_dataset = dataset.copy()
    classified_dataset.labels = predictions

    metric = ClassificationMetric(
        dataset,
        classified_dataset,
        unprivileged_groups=unprivileged_groups,
        privileged_groups=privileged_groups,
    )

    results = {
        "disparate_impact": metric.disparate_impact(),
        "statistical_parity_difference": metric.statistical_parity_difference(),
        "equal_opportunity_difference": metric.equal_opportunity_difference(),
        "average_odds_difference": metric.average_odds_difference(),
        "theil_index": metric.theil_index(),
        "accuracy_overall": metric.accuracy(),
        "accuracy_privileged": metric.accuracy(privileged=True),
        "accuracy_unprivileged": metric.accuracy(privileged=False),
        "tpr_privileged": metric.true_positive_rate(privileged=True),
        "tpr_unprivileged": metric.true_positive_rate(privileged=False),
        "fpr_privileged": metric.false_positive_rate(privileged=True),
        "fpr_unprivileged": metric.false_positive_rate(privileged=False),
    }

    # Flag issues
    issues = []
    if results["disparate_impact"] < 0.8 or results["disparate_impact"] > 1.25:
        issues.append(f"Disparate impact: {results['disparate_impact']:.3f} (outside 0.8-1.25 range)")
    if abs(results["equal_opportunity_difference"]) > 0.1:
        issues.append(f"Equal opportunity gap: {results['equal_opportunity_difference']:.3f}")
    if abs(results["average_odds_difference"]) > 0.1:
        issues.append(f"Average odds gap: {results['average_odds_difference']:.3f}")

    results["issues"] = issues
    results["fair"] = len(issues) == 0

    return results
```

### Bias Mitigation Strategies

```python
from aif360.algorithms.preprocessing import Reweighing, DisparateImpactRemover
from aif360.algorithms.inprocessing import PrejudiceRemover
from aif360.algorithms.postprocessing import EqOddsPostprocessing, CalibratedEqOddsPostprocessing

# 1. Pre-processing: Reweighing (adjust sample weights)
reweighing = Reweighing(
    unprivileged_groups=unprivileged_groups,
    privileged_groups=privileged_groups,
)
reweighed_dataset = reweighing.fit_transform(training_dataset)
# Use reweighed_dataset.instance_weights in model training

# 2. Pre-processing: Disparate Impact Remover
di_remover = DisparateImpactRemover(repair_level=0.8)
repaired_dataset = di_remover.fit_transform(training_dataset)

# 3. In-processing: Prejudice Remover (regularization during training)
pr_model = PrejudiceRemover(sensitive_attr="gender", eta=1.0)
pr_model.fit(training_dataset)
predictions = pr_model.predict(test_dataset)

# 4. Post-processing: Equalized Odds
eq_odds = EqOddsPostprocessing(
    unprivileged_groups=unprivileged_groups,
    privileged_groups=privileged_groups,
)
eq_odds.fit(validation_dataset, validation_predictions)
fair_predictions = eq_odds.predict(test_predictions)
```

---

## Explainability (SHAP and LIME)

### SHAP (SHapley Additive exPlanations)

```python
import shap
import matplotlib.pyplot as plt

# For tree-based models (fast)
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)

# Global feature importance
shap.summary_plot(shap_values, X_test, feature_names=feature_names)
plt.savefig("shap_summary.png", bbox_inches="tight", dpi=150)

# Single prediction explanation
shap.waterfall_plot(shap.Explanation(
    values=shap_values[0],
    base_values=explainer.expected_value,
    data=X_test.iloc[0],
    feature_names=feature_names,
))
plt.savefig("shap_waterfall.png", bbox_inches="tight", dpi=150)

# Force plot for single prediction
shap.force_plot(
    explainer.expected_value,
    shap_values[0],
    X_test.iloc[0],
    feature_names=feature_names,
    matplotlib=True,
)

# For deep learning models
deep_explainer = shap.DeepExplainer(model, X_train[:100])
shap_values_deep = deep_explainer.shap_values(X_test[:10])

# For any model (model-agnostic, slower)
kernel_explainer = shap.KernelExplainer(model.predict_proba, X_train[:100])
shap_values_kernel = kernel_explainer.shap_values(X_test[:10])
```

### LIME (Local Interpretable Model-agnostic Explanations)

```python
from lime.lime_tabular import LimeTabularExplainer
from lime.lime_text import LimeTextExplainer

# Tabular LIME
lime_explainer = LimeTabularExplainer(
    X_train.values,
    feature_names=feature_names,
    class_names=["not_churned", "churned"],
    mode="classification",
)

# Explain single prediction
explanation = lime_explainer.explain_instance(
    X_test.iloc[0].values,
    model.predict_proba,
    num_features=10,
)

# Get explanation as list
for feature, weight in explanation.as_list():
    print(f"{feature:40s} {weight:+.4f}")

# Save as HTML
explanation.save_to_file("lime_explanation.html")

# Text LIME
text_explainer = LimeTextExplainer(class_names=["negative", "positive"])

text_explanation = text_explainer.explain_instance(
    "This product is absolutely terrible and broke after one day",
    text_classifier.predict_proba,
    num_features=10,
)
text_explanation.save_to_file("text_explanation.html")
```

### Counterfactual Explanations

```python
import dice_ml
from dice_ml import Dice

# Create DiCE explainer
data_interface = dice_ml.Data(
    dataframe=training_df,
    continuous_features=["age", "income", "credit_score"],
    outcome_name="approved",
)

model_interface = dice_ml.Model(model=model, backend="sklearn")

dice_exp = Dice(data_interface, model_interface, method="random")

# Generate counterfactuals for a denied applicant
query = test_df.iloc[0:1]  # Denied applicant
counterfactuals = dice_exp.generate_counterfactuals(
    query,
    total_CFs=5,
    desired_class="opposite",
)

# What would need to change for approval?
counterfactuals.visualize_as_dataframe()
# Example output:
# "If income increased from $45K to $52K and credit score from 650 to 680,
#  the application would be approved."
```

---

## Model Cards

### Model Card Template

```python
MODEL_CARD_TEMPLATE = """
# Model Card: {model_name}

## Model Details
- **Model Name**: {model_name}
- **Version**: {version}
- **Type**: {model_type}
- **Framework**: {framework}
- **Date**: {date}
- **Owner**: {owner}
- **Contact**: {contact}

## Intended Use
- **Primary Use**: {primary_use}
- **Intended Users**: {intended_users}
- **Out-of-Scope Uses**: {out_of_scope}

## Training Data
- **Dataset**: {dataset_name}
- **Size**: {dataset_size}
- **Date Range**: {data_date_range}
- **Preprocessing**: {preprocessing_steps}
- **Known Limitations**: {data_limitations}

## Evaluation Results

### Overall Performance
| Metric | Value | Threshold |
|--------|-------|-----------|
{metrics_table}

### Performance by Subgroup
| Group | Accuracy | F1 | TPR | FPR |
|-------|----------|-----|-----|-----|
{subgroup_table}

### Fairness Metrics
| Metric | Value | Status |
|--------|-------|--------|
{fairness_table}

## Ethical Considerations
{ethical_considerations}

## Limitations and Risks
{limitations}

## Recommendations
{recommendations}

## Version History
{version_history}
"""

def generate_model_card(model_info: dict, eval_results: dict,
                        fairness_results: dict) -> str:
    """Generate a model card from evaluation and fairness results."""
    metrics_rows = "\n".join(
        f"| {name} | {value:.4f} | {threshold} |"
        for name, value, threshold in eval_results["metrics"]
    )

    subgroup_rows = "\n".join(
        f"| {group} | {acc:.3f} | {f1:.3f} | {tpr:.3f} | {fpr:.3f} |"
        for group, acc, f1, tpr, fpr in eval_results["subgroups"]
    )

    fairness_rows = "\n".join(
        f"| {name} | {value:.4f} | {'PASS' if passed else 'FAIL'} |"
        for name, value, passed in fairness_results["metrics"]
    )

    return MODEL_CARD_TEMPLATE.format(
        metrics_table=metrics_rows,
        subgroup_table=subgroup_rows,
        fairness_table=fairness_rows,
        **model_info,
    )
```

### Automated Model Card Generation

```python
from datetime import datetime

def create_model_card(model, X_test, y_test, feature_names,
                      protected_attribute: str, model_info: dict) -> str:
    """Auto-generate model card with evaluation and fairness metrics."""
    from sklearn.metrics import accuracy_score, f1_score, classification_report

    y_pred = model.predict(X_test)

    # Overall metrics
    overall = {
        "accuracy": accuracy_score(y_test, y_pred),
        "f1_weighted": f1_score(y_test, y_pred, average="weighted"),
        "f1_macro": f1_score(y_test, y_pred, average="macro"),
    }

    # Subgroup analysis
    subgroups = {}
    for group_val in X_test[protected_attribute].unique():
        mask = X_test[protected_attribute] == group_val
        subgroups[f"{protected_attribute}={group_val}"] = {
            "accuracy": accuracy_score(y_test[mask], y_pred[mask]),
            "f1": f1_score(y_test[mask], y_pred[mask], average="weighted"),
            "count": mask.sum(),
        }

    # Performance gap
    accuracies = [s["accuracy"] for s in subgroups.values()]
    max_gap = max(accuracies) - min(accuracies)

    card = f"""# Model Card: {model_info['name']}

## Model Details
- Version: {model_info.get('version', '1.0')}
- Type: {type(model).__name__}
- Date: {datetime.now().strftime('%Y-%m-%d')}
- Features: {len(feature_names)}

## Overall Performance
- Accuracy: {overall['accuracy']:.4f}
- F1 (weighted): {overall['f1_weighted']:.4f}
- F1 (macro): {overall['f1_macro']:.4f}

## Subgroup Performance
"""
    for group, metrics in subgroups.items():
        card += f"- {group}: Accuracy={metrics['accuracy']:.4f}, F1={metrics['f1']:.4f} (n={metrics['count']})\n"

    card += f"\n## Fairness\n- Max accuracy gap across groups: {max_gap:.4f}\n"
    card += f"- Status: {'PASS' if max_gap < 0.05 else 'NEEDS REVIEW'}\n"

    return card
```

---

## Regulatory Compliance

### EU AI Act Risk Classification

| Risk Level | Examples | Requirements |
|------------|----------|-------------|
| Unacceptable | Social scoring, real-time biometric ID | Prohibited |
| High Risk | Credit scoring, hiring, medical diagnosis | Conformity assessment, documentation, monitoring |
| Limited Risk | Chatbots, deepfakes | Transparency obligations |
| Minimal Risk | Spam filters, games | No specific requirements |

### Compliance Checklist for High-Risk AI

```yaml
# compliance-checklist.yaml
eu_ai_act:
  risk_management:
    - risk_assessment_completed: true
    - residual_risks_documented: true
    - mitigation_measures_implemented: true

  data_governance:
    - training_data_documented: true
    - data_quality_verified: true
    - bias_in_data_assessed: true
    - data_protection_compliant: true  # GDPR

  technical_documentation:
    - system_description: true
    - model_card_published: true
    - performance_metrics_documented: true
    - limitations_documented: true
    - hardware_requirements_documented: true

  transparency:
    - users_informed_of_ai_use: true
    - explanation_capability: true  # Right to explanation
    - decision_audit_trail: true

  human_oversight:
    - human_in_the_loop_for_critical: true
    - override_capability: true
    - monitoring_by_humans: true

  accuracy_and_robustness:
    - accuracy_benchmarked: true
    - adversarial_robustness_tested: true
    - performance_monitoring_active: true

  post_market_monitoring:
    - incident_reporting_process: true
    - model_monitoring_active: true
    - regular_audit_schedule: true  # Annual minimum

nist_ai_rmf:
  govern:
    - ai_governance_policy: true
    - roles_responsibilities_defined: true
    - risk_tolerance_established: true
  map:
    - context_documented: true
    - stakeholders_identified: true
    - risks_catalogued: true
  measure:
    - metrics_defined: true
    - testing_performed: true
    - third_party_audit: false
  manage:
    - risk_treatment_plan: true
    - incident_response_plan: true
    - continuous_monitoring: true
```

---

## Audit Trail Implementation

```python
import json
from datetime import datetime
from dataclasses import dataclass, asdict
from pathlib import Path

@dataclass
class AuditEntry:
    timestamp: str
    model_name: str
    model_version: str
    input_hash: str  # Hash of input (not raw data for privacy)
    prediction: str
    confidence: float
    explanation: dict
    user_id: str = ""
    decision_overridden: bool = False
    override_reason: str = ""

class AuditTrail:
    """Immutable audit trail for AI decisions."""

    def __init__(self, log_path: str):
        self.log_path = Path(log_path)
        self.log_path.mkdir(parents=True, exist_ok=True)

    def log_decision(self, entry: AuditEntry):
        """Log a single AI decision to the audit trail."""
        date_str = datetime.utcnow().strftime("%Y-%m-%d")
        log_file = self.log_path / f"audit_{date_str}.jsonl"

        with open(log_file, "a") as f:
            f.write(json.dumps(asdict(entry)) + "\n")

    def query(self, start_date: str, end_date: str,
              model_name: str = None) -> list[dict]:
        """Query audit trail for a date range."""
        results = []
        for log_file in sorted(self.log_path.glob("audit_*.jsonl")):
            file_date = log_file.stem.replace("audit_", "")
            if start_date <= file_date <= end_date:
                with open(log_file) as f:
                    for line in f:
                        entry = json.loads(line)
                        if model_name and entry["model_name"] != model_name:
                            continue
                        results.append(entry)
        return results

    def generate_report(self, start_date: str, end_date: str) -> dict:
        """Generate audit summary report."""
        entries = self.query(start_date, end_date)
        if not entries:
            return {"period": f"{start_date} to {end_date}", "total_decisions": 0}

        overrides = [e for e in entries if e["decision_overridden"]]
        confidences = [e["confidence"] for e in entries]

        return {
            "period": f"{start_date} to {end_date}",
            "total_decisions": len(entries),
            "override_rate": len(overrides) / len(entries),
            "avg_confidence": sum(confidences) / len(confidences),
            "low_confidence_decisions": sum(1 for c in confidences if c < 0.7),
            "models_used": list(set(e["model_name"] for e in entries)),
            "override_reasons": [o["override_reason"] for o in overrides],
        }

# Usage
audit = AuditTrail("/var/log/ai-audit")
audit.log_decision(AuditEntry(
    timestamp=datetime.utcnow().isoformat(),
    model_name="credit-scorer",
    model_version="v3.2",
    input_hash="sha256:abc123...",
    prediction="denied",
    confidence=0.87,
    explanation={
        "top_factors": [
            {"feature": "credit_score", "contribution": -0.35},
            {"feature": "debt_to_income", "contribution": -0.22},
            {"feature": "employment_years", "contribution": +0.15},
        ],
    },
    user_id="applicant-456",
))
```

---

## Cross-References

- Related: `4-secure/llm_evaluation_benchmarking` -- Evaluate for bias in LLM outputs
- Related: `5-ship/model_registry_management` -- Model cards in registry
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor fairness metrics in production
- Related: `3-build/synthetic_data_generation` -- Privacy-preserving synthetic data
- Related: `toolkit/ai_cost_optimization` -- Balance fairness with cost constraints

---

## EXIT CHECKLIST

- [ ] Protected attributes identified and documented
- [ ] Bias audit completed on training data and model predictions
- [ ] Fairness metrics computed across all relevant subgroups
- [ ] Disparate impact ratio within 0.8-1.25 range
- [ ] SHAP or LIME explanations available for individual predictions
- [ ] Model card published with performance, fairness, and limitations
- [ ] Counterfactual explanations available for denied outcomes
- [ ] Audit trail logging all AI decisions with explanations
- [ ] Regulatory compliance checklist completed (EU AI Act / NIST AI RMF)
- [ ] Human override mechanism implemented for high-stakes decisions
- [ ] Regular fairness audit schedule established (quarterly minimum)
- [ ] Incident response procedure documented for bias detection

---

*Skill Version: 1.0 | Created: March 2026*
