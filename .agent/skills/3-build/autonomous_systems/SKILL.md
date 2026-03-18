---
name: Autonomous Systems
description: Build autonomous vehicles and robotics using perception (cameras, LiDAR, sensor fusion), planning, control (PID, MPC), simulation (CARLA, AirSim), and safety validation with V2X.
triggers:
  - /autonomous
  - /self-driving
  - /autonomous-systems
---

# Autonomous Systems

## WHEN TO USE

- Building perception pipelines with camera, LiDAR, or radar sensor fusion
- Implementing object detection, tracking, and semantic segmentation for driving
- Designing path planning (A*, RRT*, lattice) and behavior planning (state machines, decision trees)
- Implementing vehicle control with PID, Stanley, pure pursuit, or Model Predictive Control (MPC)
- Running closed-loop simulation in CARLA, AirSim, or NVIDIA Drive Sim
- Validating safety with scenario-based testing, SOTIF analysis, or formal verification
- Integrating V2X communication (V2V, V2I) for cooperative perception

## PROCESS

1. **Define the ODD** — specify the Operational Design Domain: road types, weather, speed range, geographic region. This constrains every downstream design decision.
2. **Sensor configuration** — select and place sensors (cameras, LiDAR, radar, ultrasonics). Define extrinsic calibration procedure. Compute coverage map to verify no blind spots.
3. **Perception stack** — implement 3D object detection (PointPillars, CenterPoint for LiDAR; YOLO, BEVFormer for camera). Fuse detections across modalities with an Extended Kalman Filter or learned fusion.
4. **Localization** — combine GPS/INS with LiDAR-based localization (NDT, ICP against HD map) or visual odometry. Target < 10cm lateral accuracy.
5. **Prediction** — forecast other agents' trajectories using motion models (constant velocity, polynomial) or learned predictors (VectorNet, LaneGCN). Output multi-modal trajectory distributions.
6. **Planning** — implement hierarchical planning: route planning (A* on road graph), behavior planning (lane change, merge decisions), motion planning (optimization-based or sampling-based with safety corridors).
7. **Control** — deploy lateral control (Stanley or MPC) and longitudinal control (PID with feedforward). Tune gains in simulation before real hardware. Implement emergency braking as a safety fallback.
8. **Simulation testing** — run thousands of scenarios in CARLA or AirSim: cut-ins, pedestrian crossings, adverse weather. Use NHTSA pre-crash typology. Measure collision rate, comfort metrics, rule violations.
9. **Safety validation** — perform SOTIF analysis (ISO 21448), FMEA on sensor failures, and define minimal risk conditions. Implement a safety monitor that triggers fallback behaviors.

## CHECKLIST

- [ ] ODD documented with clear boundaries and edge cases
- [ ] Sensor calibration validated (reprojection error < 1px, LiDAR-camera alignment verified)
- [ ] Perception metrics meet targets (mAP, tracking MOTA/MOTP)
- [ ] Localization accuracy validated against ground truth (RTK GPS)
- [ ] Planning generates safe, comfortable trajectories (jerk < 2 m/s3)
- [ ] Control tracks reference path within tolerance (< 20cm lateral error)
- [ ] Simulation suite covers NHTSA pre-crash scenarios
- [ ] Safety fallback (MRC) triggers correctly on sensor degradation
- [ ] V2X messages conform to SAE J2735 / ETSI ITS-G5 standards

## Related Skills

- `computational_physics` — vehicle dynamics and tire models for simulation
- `confidential_computing` — protecting proprietary perception models on edge devices
