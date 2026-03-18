---
name: Quantum Computing Fundamentals
description: Build and simulate quantum circuits using Qiskit, Cirq, and PennyLane — covers qubit types, gates, measurement, and key algorithms (Grover, Shor, VQE, QAOA) on simulators and real hardware.
triggers:
  - /quantum
  - /quantum-computing
  - /qiskit
---

# Quantum Computing Fundamentals

## WHEN TO USE

- Designing or simulating quantum circuits for algorithmic exploration
- Evaluating quantum advantage for a specific computational problem
- Prototyping on simulators before submitting to IBM Quantum or AWS Braket
- Implementing Grover search, Shor factoring, VQE, or QAOA circuits
- Comparing gate-model frameworks (Qiskit vs Cirq vs PennyLane)

## PROCESS

1. **Define the problem** — classify as search, optimization, simulation, or cryptographic; determine if quantum speedup is plausible.
2. **Select framework** — use Qiskit for IBM hardware access, Cirq for Google-ecosystem work, PennyLane for variational/hybrid ML workflows.
3. **Design the circuit** — choose qubit encoding (computational basis, amplitude, angle), apply single-qubit (H, X, Rz) and multi-qubit (CNOT, CZ, Toffoli) gates.
4. **Simulate locally** — run on `qiskit.Aer`, `cirq.Simulator`, or `default.qubit` with 1000+ shots; inspect statevector and measurement histograms.
5. **Apply error mitigation** — add measurement error mitigation (M3, Twirled Readout), zero-noise extrapolation, or dynamical decoupling for real hardware runs.
6. **Submit to hardware** — target IBM Quantum (127+ qubit Eagle/Heron processors) via `qiskit-ibm-runtime` or AWS Braket (IonQ, Rigetti, IQM).
7. **Analyze results** — compare ideal simulation vs noisy hardware output; compute fidelity, success probability, and circuit depth overhead.
8. **Iterate** — reduce gate depth via transpilation (`optimization_level=3`), gate cancellation, or algorithmic restructuring.

## CHECKLIST

- [ ] Problem mapped to quantum-native formulation
- [ ] Circuit depth within hardware coherence limits (T1/T2)
- [ ] Simulator results validate expected output distribution
- [ ] Transpilation targeting actual backend topology
- [ ] Error mitigation strategy selected and applied
- [ ] Shot count sufficient for statistical confidence (>4000 for <1% sampling error)
- [ ] Results compared against classical baseline
- [ ] Circuit and results version-controlled

## Related Skills

- `quantum_optimization_algorithms` — QAOA, VQE, and annealing deep-dives
- `federated_learning` — privacy-preserving quantum-classical hybrid workflows
