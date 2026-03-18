---
name: Causal Inference in Production
description: Move beyond correlation with DoWhy, EconML, and CausalML — A/B testing beyond averages, uplift modeling, instrumental variables, regression discontinuity, and causal discovery (PC, NOTEARS).
triggers:
  - /causal-inference
  - /causal
  - /uplift-modeling
---

# Causal Inference in Production

## WHEN TO USE

- Estimating true treatment effects beyond A/B test averages (CATE, HTE)
- Building uplift models to target users who benefit most from an intervention
- Handling observational data where randomized experiments are impossible
- Discovering causal structure from data (causal graphs, DAGs)
- Validating that a feature or policy change actually caused an outcome shift

## PROCESS

1. **Define the causal question** — specify treatment, outcome, and target population; draw a causal DAG encoding domain assumptions about confounders, mediators, and colliders.
2. **Choose identification strategy** — randomized experiment (A/B test), instrumental variables (IV), regression discontinuity (RDD), difference-in-differences (DiD), or propensity score methods depending on data availability.
3. **Select tooling** — DoWhy for end-to-end causal workflow (model, identify, estimate, refute), EconML for heterogeneous treatment effects (DML, CausalForest, DRLearner), CausalML for uplift modeling (T-Learner, S-Learner, X-Learner).
4. **Estimate effects** — fit the chosen estimator; for CATE, use EconML `CausalForestDML` or `LinearDML`; for uplift, use CausalML with cross-validated scoring; report ATE with confidence intervals.
5. **Run refutation tests** — use DoWhy refuters: placebo treatment, random common cause, data subset validation, and sensitivity analysis (E-value, Rosenbaum bounds) to stress-test assumptions.
6. **Discover causal structure** — when DAG is unknown, apply PC algorithm (`causal-learn`), NOTEARS (continuous optimization), or GES; validate discovered edges against domain knowledge.
7. **Deploy to production** — integrate CATE/uplift scores into decisioning systems (targeting, personalization, pricing); log treatment assignments and outcomes for ongoing evaluation.
8. **Monitor and iterate** — track effect stability over time; detect concept drift in treatment effects; re-estimate periodically; run holdout validation groups to confirm real-world impact.

## CHECKLIST

- [ ] Causal DAG reviewed and validated by domain expert
- [ ] Identification assumptions explicitly stated and justified
- [ ] Overlap/positivity condition verified (propensity scores not near 0 or 1)
- [ ] At least 2 refutation tests passed (placebo, random cause)
- [ ] Confidence intervals reported — not just point estimates
- [ ] Uplift model evaluated with AUUC (area under uplift curve) or Qini coefficient
- [ ] Treatment effect heterogeneity explored across key segments
- [ ] Production integration logs treatment, features, and outcomes for retraining

## Related Skills

- `federated_learning` — causal estimation on privacy-preserved distributed data
- `data_mesh_architecture` — governed data products as inputs for causal analysis
