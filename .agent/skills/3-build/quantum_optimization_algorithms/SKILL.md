---
name: Quantum Optimization Algorithms
description: Implement QAOA, VQE, and quantum annealing for combinatorial and continuous optimization — QUBO formulation, D-Wave hybrid solvers, and quantum-vs-classical benchmarking.
triggers:
  - /quantum-optimization
  - /qaoa
  - /quantum-annealing
---

# Quantum Optimization Algorithms

## WHEN TO USE

- Solving combinatorial optimization (TSP, MaxCut, graph coloring, portfolio optimization)
- Formulating problems as QUBO or Ising Hamiltonians
- Running QAOA or VQE on gate-model hardware or simulators
- Submitting problems to D-Wave quantum annealers or hybrid solvers
- Benchmarking quantum solvers against classical (Gurobi, CPLEX, simulated annealing)

## PROCESS

1. **Formulate the problem** — express objective and constraints as a QUBO matrix or Ising Hamiltonian; use penalty terms for constraint encoding.
2. **Choose solver approach** — QAOA/VQE for gate-model (Qiskit, PennyLane), quantum annealing for D-Wave (`dwave-ocean-sdk`), or hybrid (`LeapHybridCQMSampler`).
3. **Build the cost Hamiltonian** — for QAOA, construct the mixer and cost operators; set initial `p` (circuit depth) to 1-3 and scale up.
4. **Select classical optimizer** — COBYLA or SPSA for noisy hardware; L-BFGS-B or ADAM for simulators; set max iterations and convergence thresholds.
5. **Run and sample** — execute with sufficient shots (8192+); for D-Wave, set `num_reads=1000` and `annealing_time` between 20-200 microseconds.
6. **Post-process solutions** — decode binary strings to original variables, verify constraint satisfaction, rank by objective value.
7. **Benchmark** — compare solution quality (approximation ratio), time-to-solution, and scaling behavior against classical solvers on identical instances.
8. **Scale up** — increase problem size; use graph decomposition, warm-starting, or recursive QAOA for larger instances.

## CHECKLIST

- [ ] QUBO/Ising formulation verified on small instances (exact solver)
- [ ] Penalty weights tuned so constraints are satisfied in top solutions
- [ ] Classical optimizer converges within budget
- [ ] Approximation ratio computed against known optimum or best classical
- [ ] D-Wave chain strength set appropriately (auto-scale or manual)
- [ ] Results reproducible across multiple runs
- [ ] Scaling analysis documented (problem size vs solution quality vs time)

## Related Skills

- `quantum_computing_fundamentals` — circuit design and hardware basics
- `data_mesh_architecture` — domain-oriented data feeds for optimization inputs
