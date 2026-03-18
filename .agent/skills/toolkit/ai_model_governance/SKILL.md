---
name: AI Model Governance
description: Model cards, registry governance, approval workflows, bias auditing, drift monitoring, EU AI Act risk tiers, deprecation lifecycle, and audit trails
triggers:
  - /model-governance
  - /model-cards
  - /ai-governance
---

# AI Model Governance

## WHEN TO USE

- Registering a new model in your model registry (MLflow, Weights & Biases, SageMaker)
- Creating model cards for transparency and compliance documentation
- Setting up approval workflows for model promotion (staging to production)
- Auditing models for bias, fairness, and drift before or after deployment
- Classifying models under EU AI Act risk tiers for regulatory compliance
- Planning model deprecation and sunset lifecycle

---

## PROCESS

1. **Create a model card** (Google format) for every production model:

   ```yaml
   # model-card.yaml
   model_name: "customer-churn-predictor-v2"
   version: "2.1.0"
   owner: "ml-team@company.com"
   created: "2026-03-15"
   framework: "scikit-learn 1.5"
   task: "binary classification"

   intended_use:
     primary: "Predict customer churn probability for retention campaigns"
     out_of_scope: "Credit decisioning, hiring decisions"
     users: "Marketing automation pipeline"

   training_data:
     source: "internal CRM, 2024-01 to 2025-12"
     size: "1.2M records"
     demographics: "US customers, 18-85 age range"
     known_gaps: "Under-represented: rural zip codes, age 65+"

   performance:
     metric: "F1 (weighted)"
     overall: 0.87
     slices:
       - group: "age 18-30" ; score: 0.91
       - group: "age 65+"   ; score: 0.72
       - group: "rural"     ; score: 0.68

   bias_audit:
     method: "Aequitas, demographic parity + equalized odds"
     date: "2026-03-10"
     flagged_disparities: "Rural segment recall 18% lower than urban"

   risk_classification:
     eu_ai_act_tier: "limited"   # minimal | limited | high | unacceptable
     justification: "Marketing optimization, not affecting fundamental rights"
   ```

2. **Register in the model registry** with governance metadata:

   ```python
   import mlflow

   with mlflow.start_run():
       mlflow.log_artifact("model-card.yaml")
       mlflow.sklearn.log_model(model, "model", registered_model_name="churn-predictor")

   client = mlflow.tracking.MlflowClient()
   client.set_registered_model_tag("churn-predictor", "risk_tier", "limited")
   client.set_registered_model_tag("churn-predictor", "bias_audit_date", "2026-03-10")
   client.set_registered_model_tag("churn-predictor", "approved_by", "")
   ```

3. **Implement approval workflows** — no model reaches production without sign-off:

   | Stage | Gate | Approver |
   |-------|------|----------|
   | Development | Unit tests pass, metrics above baseline | ML engineer |
   | Staging | Bias audit clean, model card complete, A/B test results | ML lead |
   | Production | Security review, EU AI Act classification, business sign-off | Model governance board |
   | Deprecation | Replacement model validated, migration plan, sunset notice | ML lead + stakeholders |

4. **Run bias auditing** before every promotion:

   ```python
   from aequitas.group import Group
   from aequitas.bias import Bias

   g = Group()
   xtab, _ = g.get_crosstabs(predictions_df, attr_cols=["age_group", "region"])

   b = Bias()
   bdf = b.get_disparity_predefined_groups(
       xtab,
       original_fairness_dupl=True,
       ref_groups_dict={"age_group": "30-50", "region": "urban"},
       alpha=0.05,
   )
   # Flag any group with disparity ratio outside [0.8, 1.25]
   flagged = bdf[(bdf["fdr_disparity"] < 0.8) | (bdf["fdr_disparity"] > 1.25)]
   ```

5. **Set up drift monitoring governance** — detect when models degrade:

   ```python
   from evidently.report import Report
   from evidently.metric_preset import DataDriftPreset, TargetDriftPreset

   report = Report(metrics=[DataDriftPreset(), TargetDriftPreset()])
   report.run(reference_data=train_df, current_data=production_df)
   report.save_html("drift_report.html")
   # Alert if >30% of features drift or prediction distribution shifts
   ```

6. **Classify under EU AI Act risk tiers**:

   | Tier | Examples | Obligations |
   |------|---------|-------------|
   | Unacceptable | Social scoring, real-time biometric ID in public | Banned |
   | High | Credit scoring, hiring, medical devices, law enforcement | Conformity assessment, logging, human oversight |
   | Limited | Chatbots, emotion recognition, deepfake generation | Transparency obligations (disclose AI use) |
   | Minimal | Spam filters, game AI, recommendation engines | No mandatory obligations (voluntary codes) |

7. **Plan model deprecation lifecycle**:

   ```
   ACTIVE --> DEPRECATED (30-day notice) --> SUNSET (traffic cutoff) --> ARCHIVED (registry-only)
   ```

   - Publish deprecation notice with migration guide
   - Monitor traffic to deprecated endpoint; alert if still called
   - Archive model card and audit trail for regulatory retention (5+ years for high-risk)

---

## CHECKLIST

- [ ] Model card created with intended use, training data, performance slices, bias audit
- [ ] Model registered with governance tags (risk tier, audit date, approver)
- [ ] Approval workflow enforced — staging and production gates require sign-off
- [ ] Bias audit completed with Aequitas or equivalent; disparities documented
- [ ] Drift monitoring deployed (Evidently, NannyML, or custom)
- [ ] EU AI Act risk tier classified with written justification
- [ ] Deprecation policy defined — notice period, migration plan, archive retention
- [ ] Audit trail captures all promotions, rollbacks, and approvals with timestamps

---

## Related Skills

- `responsible_ai_framework` — fairness principles, explainability, and accountability
- `eu_ai_act_compliance` — detailed EU AI Act compliance implementation
- `ai_model_monitoring` — runtime model monitoring for drift and performance
