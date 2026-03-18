---
name: Spatial Computing
description: Build AR/VR/MR experiences with ARKit, ARCore, WebXR, and visionOS — spatial anchors, hand/eye tracking, multi-user shared spaces, and 3D asset pipelines in Unity and Unreal.
triggers:
  - /spatial
  - /ar-vr
  - /xr
  - /visionos
---

# Spatial Computing

## WHEN TO USE

- Building augmented, virtual, or mixed reality applications
- Implementing spatial anchors, plane detection, or world mapping
- Adding hand tracking, eye tracking, or gesture-based interaction
- Developing for Apple Vision Pro (visionOS), Meta Quest, or HoloLens
- Creating multi-user shared spatial experiences
- Optimizing 3D asset pipelines for real-time XR rendering

## PROCESS

1. **Define the experience** — classify as AR overlay, immersive VR, or passthrough MR; identify target devices and input modalities (hands, controllers, eye gaze, voice).
2. **Choose platform and engine** — Unity (PolySpatial for visionOS, XR Interaction Toolkit) or Unreal (MetaXR plugin); use WebXR for browser-based experiences via Three.js or A-Frame.
3. **Set up spatial understanding** — enable plane detection (ARKit/ARCore), mesh scanning (LiDAR, depth sensors), and scene understanding; configure spatial anchors for persistent placement.
4. **Build interaction system** — implement grab, poke, and gaze-and-commit interactions; add hand tracking (ARKit hand skeleton, Meta Hand Tracking SDK) and eye tracking for foveated input.
5. **Create 3D asset pipeline** — model in Blender/Maya, export as glTF/USDZ; target <100K triangles per object for mobile AR, <500K for tethered VR; use texture atlasing and LOD chains.
6. **Implement multi-user** — use shared spatial anchors (Azure Spatial Anchors, ARCore Cloud Anchors) or networking (Photon, Normcore) for co-located and remote collaboration.
7. **Optimize performance** — target 90fps (VR) or 60fps (AR); use foveated rendering, occlusion culling, single-pass instanced rendering; profile with RenderDoc or Xcode GPU debugger.
8. **Test on device** — validate tracking stability, anchor persistence, thermal throttling, and comfort (IPD, motion sickness mitigation); conduct user testing for ergonomics.

## CHECKLIST

- [ ] Target devices and SDK versions locked
- [ ] Spatial tracking tested in varied lighting and surface conditions
- [ ] Frame rate meets target (90fps VR / 60fps AR) sustained
- [ ] Hand/eye tracking calibrated and tested across users
- [ ] 3D assets within polygon and texture budgets
- [ ] Multi-user sync latency under 100ms for co-located experiences
- [ ] Accessibility considered (voice fallbacks, reticle size, comfort settings)
- [ ] App store requirements met (visionOS guidelines, Meta store policies)

## Related Skills

- `digital_twin_development` — immersive visualization of digital twins
- `robotics_ros2` — spatial perception and sensor fusion overlap
