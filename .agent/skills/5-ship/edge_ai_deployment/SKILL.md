---
name: edge_ai_deployment
description: Deploy optimized ML models to edge devices using quantization, pruning, distillation, ONNX Runtime, TFLite, and edge orchestration platforms
triggers:
  - /edge-ai
  - /edge-deployment
  - /on-device-ml
---

# Edge AI Deployment

## WHEN TO USE

Use this skill when deploying ML models to resource-constrained devices (Jetson, Coral, mobile, microcontrollers), optimizing model size and latency via quantization/pruning/distillation, setting up edge orchestration with KubeEdge or AWS Greengrass, implementing offline-first inference, or building OTA model update pipelines.

## PROCESS

1. **Profile the target device** — document compute (CPU/GPU/NPU), RAM, storage, power budget, and supported runtimes (ONNX, TFLite, Core ML, TensorRT).

2. **Export the model to an intermediate format** — convert from PyTorch/TF to ONNX as the universal interchange.
   ```python
   import torch
   dummy = torch.randn(1, 3, 224, 224)
   torch.onnx.export(model, dummy, "model.onnx", opset_version=17,
                      input_names=["input"], output_names=["output"],
                      dynamic_axes={"input": {0: "batch"}})
   ```

3. **Apply model optimization** — choose technique based on latency/accuracy tradeoff.
   ```python
   # Post-training quantization with ONNX Runtime
   from onnxruntime.quantization import quantize_dynamic, QuantType
   quantize_dynamic("model.onnx", "model_int8.onnx",
                     weight_type=QuantType.QInt8)

   # TFLite full integer quantization
   converter = tf.lite.TFLiteConverter.from_saved_model("saved_model/")
   converter.optimizations = [tf.lite.Optimize.DEFAULT]
   converter.representative_dataset = representative_data_gen
   converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
   tflite_model = converter.convert()
   ```

4. **Validate accuracy post-optimization** — run the optimized model against a held-out test set, compare to baseline, reject if accuracy drops beyond threshold (typically >1% degradation).

5. **Build the edge inference service** — wrap the model in a lightweight server or embedded loop.
   ```python
   import onnxruntime as ort
   session = ort.InferenceSession("model_int8.onnx",
       providers=["CUDAExecutionProvider", "CPUExecutionProvider"])
   def predict(input_array):
       return session.run(None, {"input": input_array})[0]
   ```

6. **Set up edge orchestration** — deploy via KubeEdge, AWS Greengrass, or Azure IoT Edge for fleet management.
   ```yaml
   # KubeEdge deployment manifest
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: edge-inference
   spec:
     nodeName: edge-node-01
     containers:
       - name: inference
         image: registry/model-service:v1.2
         resources:
           limits: { nvidia.com/gpu: "1", memory: "2Gi" }
   ```

7. **Implement OTA model updates** — version models in a registry, push delta updates to minimize bandwidth, validate checksum on-device before swapping, keep rollback copy.

8. **Add edge-cloud sync** — batch inference results locally, sync to cloud on connectivity, handle conflict resolution for bidirectional data flows.

## CHECKLIST

- [ ] Target device profiled: compute, RAM, storage, runtime support
- [ ] Model exported to ONNX/TFLite/Core ML with verified output parity
- [ ] Quantization applied: INT8 minimum, INT4 if hardware supports it
- [ ] Accuracy regression tested: <1% drop from baseline on test set
- [ ] Latency benchmarked on actual target hardware (not dev machine)
- [ ] Offline inference works without network connectivity
- [ ] OTA update pipeline tested: push, validate, swap, rollback
- [ ] Monitoring in place: inference latency, error rate, device health

## Related Skills

- `model_serving_deployment` — cloud-side model serving and scaling
- `iot_platform` — device connectivity, telemetry, and fleet management
