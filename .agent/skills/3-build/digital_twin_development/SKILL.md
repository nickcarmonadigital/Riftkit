---
name: Digital Twin Development
description: Build real-time virtual replicas of physical systems using NVIDIA Omniverse, Azure Digital Twins, and AWS IoT TwinMaker — sensor integration, simulation, and predictive maintenance.
triggers:
  - /digital-twin
  - /twin
  - /omniverse
---

# Digital Twin Development

## WHEN TO USE

- Creating a virtual replica of a physical asset, process, or environment
- Integrating real-time IoT sensor data with a simulation model
- Running predictive maintenance or what-if scenario analysis
- Visualizing complex systems in 3D for operational monitoring
- Simulating factory layouts, supply chains, or building systems before physical changes

## PROCESS

1. **Define scope** — identify the physical system (single asset, production line, building, city block); clarify fidelity requirements (geometric, behavioral, physics-based).
2. **Model the physical entity** — create 3D geometry in USD (Universal Scene Description) format; use CAD imports, photogrammetry, or procedural generation; tag components with metadata.
3. **Select platform** — NVIDIA Omniverse for high-fidelity physics simulation and rendering, Azure Digital Twins for graph-based modeling with DTDL ontology, AWS IoT TwinMaker for AWS-native IoT integration.
4. **Connect data sources** — ingest real-time telemetry via MQTT, OPC-UA, or IoT Hub; map sensor readings to twin properties; set ingestion frequency (sub-second for control, minutes for monitoring).
5. **Build behavioral models** — implement physics simulations (thermal, structural, fluid), ML-based surrogate models, or rule-based logic; calibrate against historical data.
6. **Enable synchronization** — establish bidirectional data flow; physical-to-virtual for monitoring, virtual-to-physical for control signals; handle latency and conflict resolution.
7. **Implement analytics** — add anomaly detection on sensor streams, remaining useful life (RUL) prediction, and scenario simulation; expose results via dashboards (Grafana, Power BI).
8. **Deploy and maintain** — version the twin model alongside the physical system; update geometry and behavior models as the asset changes; monitor drift between twin predictions and reality.

## CHECKLIST

- [ ] Physical system boundaries and interfaces documented
- [ ] 3D model accurate to required fidelity (geometric tolerance defined)
- [ ] All critical sensors connected and streaming to twin
- [ ] Data latency within acceptable bounds for use case
- [ ] Behavioral model validated against historical ground truth
- [ ] Predictive maintenance alerts tested with known failure scenarios
- [ ] Access control enforced on twin data and control interfaces
- [ ] Twin versioned and update process defined for physical changes

## Related Skills

- `robotics_ros2` — sensor fusion and simulation environments (Gazebo, Isaac Sim)
- `spatial_computing` — 3D visualization and immersive twin interaction
