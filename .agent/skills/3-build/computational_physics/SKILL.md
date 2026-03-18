---
name: Computational Physics
description: Simulate physical systems using PDE/ODE solvers, FEniCS, OpenFOAM, PyBullet, and JAX for GPU-accelerated physics including fluid dynamics, molecular dynamics, and N-body problems.
triggers:
  - /physics-sim
  - /computational-physics
  - /simulation
---

# Computational Physics

## WHEN TO USE

- Solving PDEs (heat, wave, Navier-Stokes) or ODE systems with FEniCS, SciPy, or custom solvers
- Running CFD simulations with OpenFOAM or Lattice Boltzmann methods
- Building rigid-body or soft-body simulations with PyBullet, MuJoCo, or Taichi
- Accelerating physics kernels on GPU via JAX, CuPy, or Taichi
- Molecular dynamics with LAMMPS, OpenMM, or custom force fields
- N-body gravitational or electrostatic simulations
- Visualizing simulation output with ParaView, Matplotlib, or PyVista

## PROCESS

1. **Model the physics** — write down governing equations (PDEs/ODEs), boundary conditions, initial conditions, and physical constants. Identify dimensionless parameters (Reynolds, Mach, Knudsen).
2. **Choose discretization** — select finite element (FEniCS, deal.II), finite volume (OpenFOAM), finite difference, or spectral methods based on geometry complexity and accuracy needs.
3. **Set up the mesh** — generate mesh with Gmsh, CGAL, or OpenFOAM's `blockMesh`/`snappyHexMesh`. Refine near boundaries, shocks, or regions of interest.
4. **Implement the solver** — for FEniCS: define `FunctionSpace`, variational form, and `solve()`. For OpenFOAM: configure `controlDict`, `fvSchemes`, `fvSolution`. For custom: implement timestepping (RK4, Verlet, symplectic).
5. **GPU acceleration** — port hot loops to JAX (`jax.jit`, `jax.vmap`), Taichi (`@ti.kernel`), or CuPy. Use `jax.lax.scan` for time evolution loops.
6. **Validate** — compare against analytical solutions (manufactured solutions method), experimental data, or established benchmark cases (lid-driven cavity, Taylor-Green vortex).
7. **Optimize performance** — profile with `cProfile`, `nsys`, or JAX's `jax.profiler`. Tune mesh resolution, timestep (CFL condition), and solver tolerances.
8. **Visualize results** — export to VTK/XDMF for ParaView, or use PyVista/Matplotlib for in-script visualization. Generate animations for time-dependent data.
9. **Post-process** — compute derived quantities (vorticity, stress tensors, energy spectra). Run convergence studies on mesh size and timestep.

## CHECKLIST

- [ ] Governing equations and boundary conditions fully specified
- [ ] Mesh quality checked (aspect ratio, skewness, orthogonality)
- [ ] CFL condition satisfied for explicit schemes
- [ ] Solver convergence verified (residuals below tolerance)
- [ ] Conservation laws validated (mass, energy, momentum)
- [ ] Results compared against analytical or benchmark solutions
- [ ] Grid independence study performed
- [ ] Visualization pipeline working and outputs saved

## Related Skills

- `quantum_machine_learning` — quantum simulation of molecular systems
- `autonomous_systems` — physics-based simulation for vehicle dynamics
