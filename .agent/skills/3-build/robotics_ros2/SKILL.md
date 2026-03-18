---
name: Robotics & ROS 2
description: Build robotic systems with ROS 2 — node architecture, Nav2 navigation, MoveIt manipulation, SLAM, sensor fusion, Gazebo/Isaac Sim simulation, and real-time control with ISO 13849 safety.
triggers:
  - /ros2
  - /robotics
  - /robot
---

# Robotics & ROS 2

## WHEN TO USE

- Developing autonomous robot software (mobile robots, arms, drones)
- Implementing navigation, path planning, or SLAM
- Integrating sensors (LiDAR, cameras, IMU, encoders) with fusion pipelines
- Simulating robots in Gazebo or NVIDIA Isaac Sim before hardware deployment
- Building real-time control loops with safety compliance (ISO 13849)

## PROCESS

1. **Define the robot system** — specify kinematics (differential drive, holonomic, 6-DOF arm), sensors, actuators, and operating environment; document payload and safety requirements.
2. **Set up ROS 2 workspace** — install ROS 2 Jazzy/Rolling; create packages with `ros2 pkg create`; structure as component nodes using `rclcpp` or `rclpy` with lifecycle management.
3. **Implement perception** — fuse sensor data using `robot_localization` (EKF/UKF); run SLAM (slam_toolbox, RTAB-Map) for mapping; process point clouds with PCL or camera feeds with OpenCV.
4. **Configure navigation** — set up Nav2 stack: `bt_navigator` for behavior trees, `controller_server` (DWB, MPPI), `planner_server` (NavFn, Smac), costmap layers (obstacle, inflation, voxel).
5. **Add manipulation** — use MoveIt 2 for motion planning (OMPL, Pilz); define URDF/SRDF, collision objects, and grasp pipelines; integrate with perception for pick-and-place.
6. **Simulate first** — build robot model in URDF/SDF; test in Gazebo Harmonic or Isaac Sim; validate sensor plugins, physics, and controller behavior before hardware.
7. **Deploy to hardware** — use `ros2_control` with hardware interface plugins; configure real-time kernel (PREEMPT_RT) for control loops <1ms; implement watchdog and e-stop nodes.
8. **Ensure safety** — implement safety-rated monitored stop, speed limiting, and workspace restriction per ISO 13849; add diagnostics aggregation and health monitoring.

## CHECKLIST

- [ ] URDF/SDF validated in simulation — transforms, joints, inertias correct
- [ ] Sensor topics publishing at expected rates (verify with `ros2 topic hz`)
- [ ] Localization accuracy within operational requirements (<5cm for indoor nav)
- [ ] Navigation tested in simulation with dynamic obstacles
- [ ] Real-time control loop jitter measured and within bounds
- [ ] E-stop and safety behaviors tested (hardware-in-the-loop)
- [ ] Launch files parameterized for sim vs hardware via `use_sim_time`
- [ ] All nodes have lifecycle management and graceful shutdown

## Related Skills

- `digital_twin_development` — simulation environments and virtual commissioning
- `spatial_computing` — spatial perception and 3D mapping overlap
