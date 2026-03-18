---
name: Quantum Machine Learning
description: Build hybrid quantum-classical ML models using variational circuits, quantum kernels, and NISQ-compatible architectures with PennyLane and PyTorch.
triggers:
  - /qml
  - /quantum-ml
  - /quantum-machine-learning
---

# Quantum Machine Learning

## WHEN TO USE

- Designing variational quantum eigensolvers (VQE) or quantum approximate optimization (QAOA)
- Building hybrid quantum-classical neural networks with PennyLane + PyTorch/JAX
- Implementing quantum kernel methods for classification or regression
- Diagnosing barren plateau issues in parameterized quantum circuits
- Encoding classical data into quantum feature maps (angle, amplitude, IQP)
- Evaluating whether a problem benefits from quantum advantage on NISQ hardware

## PROCESS

1. **Define the problem class** — determine if the task suits variational, kernel-based, or quantum reservoir approaches. Check qubit count constraints for target backend (IBM Quantum, IonQ, simulators).
2. **Select encoding strategy** — choose a quantum feature map: angle encoding for low-dimensional data, amplitude encoding for higher dimensions, or IQP embedding for kernel methods.
3. **Design the ansatz** — build the parameterized circuit using `qml.StronglyEntanglingLayers`, `qml.BasicEntanglerLayers`, or a hardware-efficient ansatz. Keep depth shallow to avoid decoherence.
4. **Integrate classical optimizer** — wrap the quantum circuit as a `qml.QNode` with a PyTorch or JAX interface. Use Adam, SPSA, or Rotosolve for parameter updates.
5. **Mitigate barren plateaus** — apply layerwise training, local cost functions, or parameter initialization strategies (e.g., identity block initialization). Monitor gradient variance.
6. **Evaluate quantum kernels** — if using kernel methods, compute the quantum kernel matrix via `qml.kernels.square_kernel_matrix` and feed into classical SVM or GP.
7. **Benchmark against classical** — compare against equivalent classical models on the same data. Measure accuracy, training time, and circuit evaluation count.
8. **Profile for hardware** — transpile circuits to target gate sets using Qiskit transpiler or PennyLane device mapping. Apply measurement error mitigation and zero-noise extrapolation.
9. **Deploy or simulate** — run on `default.qubit` for development, `lightning.qubit` for fast simulation, or connect to real backends via `qml.device("qiskit.ibmq")`.

## CHECKLIST

- [ ] Problem is well-suited for quantum (high-dimensional kernel, combinatorial optimization)
- [ ] Feature map chosen matches data dimensionality and circuit depth budget
- [ ] Ansatz expressibility tested — not over- or under-parameterized
- [ ] Gradient variance monitored for barren plateau detection
- [ ] Classical baseline comparison completed
- [ ] Circuit depth within NISQ coherence limits for target backend
- [ ] Measurement shots configured (1024+ for variance reduction)
- [ ] Error mitigation strategy applied (readout correction, ZNE)
- [ ] Results reproducible with fixed random seeds

## Related Skills

- `computational_physics` — quantum simulation of physical systems
- `zero_knowledge_applications` — quantum-resistant cryptographic proofs
