---
name: Federated Learning
description: Train ML models across decentralized data sources without sharing raw data — FedAvg, secure aggregation, differential privacy using PySyft, Flower, TFF, and NVIDIA FLARE.
triggers:
  - /federated-learning
  - /federated
  - /privacy-preserving-ml
---

# Federated Learning

## WHEN TO USE

- Training models across organizations or devices without centralizing sensitive data
- Meeting GDPR, HIPAA, or other data-residency compliance requirements
- Deploying on-device learning for mobile or edge scenarios
- Combining differential privacy with distributed training
- Building cross-silo (hospital networks, banks) or cross-device (mobile) FL systems

## PROCESS

1. **Assess feasibility** — confirm data is distributed, cannot be centralized, and task benefits from multi-source training; check for label distribution skew (non-IID).
2. **Select framework** — Flower for framework-agnostic flexibility, TensorFlow Federated for TF-native, PySyft for research/privacy focus, NVIDIA FLARE for enterprise/healthcare.
3. **Define the aggregation strategy** — start with FedAvg; consider FedProx for heterogeneous data, FedYogi/FedAdam for adaptive optimization, or scaffold for variance reduction.
4. **Implement client training** — wrap local model training as a client; set local epochs (1-5), batch size, and learning rate; handle variable dataset sizes with weighted averaging.
5. **Add privacy guarantees** — apply record-level differential privacy (Opacus/TF Privacy) with target epsilon (1-10); enable secure aggregation (SecAgg) to hide individual updates from the server.
6. **Configure communication** — compress model updates (top-k sparsification, quantization) to reduce bandwidth; set communication rounds (50-500) based on convergence monitoring.
7. **Orchestrate training** — run server-side aggregation; monitor per-round metrics, client dropout handling, and convergence across heterogeneous participants.
8. **Evaluate globally** — test aggregated model on held-out data from each participant; verify fairness across data distributions; compare against centralized baseline.

## CHECKLIST

- [ ] Data distribution characterized (IID vs non-IID, quantity skew)
- [ ] Privacy budget (epsilon, delta) defined and enforced
- [ ] Secure aggregation enabled for production deployments
- [ ] Client selection strategy handles stragglers and dropouts
- [ ] Communication cost measured and optimized (<10 MB per round target)
- [ ] Global model evaluated per-client for fairness
- [ ] No raw data leaves client boundary — verified via audit
- [ ] Model poisoning defenses in place (norm clipping, robust aggregation)

## Related Skills

- `causal_inference_production` — uplift modeling on federated data
- `data_mesh_architecture` — domain-owned data products feeding FL pipelines
