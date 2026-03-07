# Blueprint: Computer Vision

Building computer vision applications for image classification, object detection, segmentation, video analysis, and OCR using deep learning frameworks and pre-trained models.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| PyTorch + torchvision | Research, custom architectures, flexibility |
| TensorFlow + Keras | Production pipelines, TFLite mobile deployment |
| Ultralytics YOLOv8/v11 | Object detection, fast prototyping, real-time inference |
| OpenCV + ONNX Runtime | Edge deployment, classical CV, optimized inference |
| Hugging Face Transformers | Vision transformers (ViT, DETR, SAM), zero-shot tasks |
| Roboflow | Dataset management, annotation, model training without code |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define visual task (classify, detect, segment), input/output format
- **prd_generator** -- Document accuracy requirements, latency SLAs, edge cases
- **competitive_analysis** -- Evaluate pre-trained models vs custom training needs

Key scoping questions:
- Is a pre-trained model sufficient or do you need custom training?
- What is the inference latency budget? (Real-time <50ms vs batch)
- Where does inference run? (Cloud GPU, edge device, browser)
- How much labeled data do you have or can you get?

### Phase 2: Architecture
- **schema_design** -- Image/video storage, annotation format (COCO, Pascal VOC)
- **api_design** -- Inference API contract, batch vs streaming, async processing

Architecture patterns:
- **Real-time pipeline**: Camera -> Frame capture -> Preprocessing -> Model -> Postprocessing -> Display/Alert
- **Batch pipeline**: S3 trigger -> Queue -> GPU worker -> Results DB -> Dashboard
- **Edge pipeline**: On-device model (TFLite/ONNX) -> Local inference -> Cloud sync for analytics

### Phase 3: Implementation
- **tdd_workflow** -- Test data augmentation, model output shapes, postprocessing logic
- **error_handling** -- Graceful handling of corrupt images, unsupported formats, OOM errors
- **code_review** -- Review data pipeline, training loop, inference optimization

### Phase 4: Testing and Security
- **integration_testing** -- End-to-end: upload image -> get prediction -> verify format
- **load_testing** -- Concurrent inference requests, GPU memory under load
- **security_audit** -- Adversarial input detection, model extraction prevention

### Phase 5: Deployment
- **ci_cd_pipeline** -- Model registry, versioned artifacts, A/B model deployment
- **deployment_patterns** -- GPU instance with auto-scaling, model serving (Triton, TorchServe)
- **monitoring_setup** -- Inference latency, accuracy drift, GPU utilization

## Key Domain-Specific Concerns

### Dataset Preparation
- Use standard annotation formats: COCO JSON for detection, masks for segmentation
- Split data 80/10/10 (train/val/test) with stratified sampling
- Apply augmentations during training: flips, rotations, color jitter, mixup
- Version your datasets -- use DVC or similar for reproducibility
- Check for class imbalance and address with oversampling or weighted loss

### Model Selection Guide

| Task | Model | Speed | Accuracy |
|------|-------|-------|----------|
| Image Classification | EfficientNet-B0/B4 | Fast | High |
| Object Detection (real-time) | YOLOv8/v11 | Very fast | Good |
| Object Detection (accuracy) | DETR, Co-DETR | Slow | Very high |
| Instance Segmentation | Mask R-CNN, YOLOv8-seg | Medium | High |
| Semantic Segmentation | SegFormer, DeepLabV3+ | Medium | High |
| Zero-shot Detection | Grounding DINO + SAM | Slow | Flexible |
| OCR | PaddleOCR, EasyOCR, Tesseract | Medium | Good |

### Training Best Practices
- Start with a pre-trained backbone -- fine-tune, do not train from scratch
- Use mixed precision (FP16) to cut memory usage and speed up training
- Implement early stopping on validation metric (mAP, accuracy, IoU)
- Log experiments with Weights & Biases or MLflow
- Save checkpoints every N epochs, keep top-K by validation metric

### Inference Optimization
- Export to ONNX for cross-platform deployment
- Use TensorRT for NVIDIA GPU inference (2-5x speedup)
- Quantize to INT8 for edge devices (minor accuracy loss)
- Batch requests when possible -- GPU throughput scales with batch size
- Implement result caching for repeated/similar inputs

### Video Processing
- Process frames at a reduced rate (every Nth frame) unless real-time tracking is needed
- Use object tracking (ByteTrack, DeepSORT) between detection frames
- Buffer frames for temporal smoothing to reduce flickering predictions
- Consider hardware decode (NVDEC) for high-throughput video pipelines

## Getting Started

1. **Define the visual task** -- Classification, detection, segmentation, or OCR
2. **Collect and label data** -- Use Roboflow, Label Studio, or CVAT for annotation
3. **Choose a pre-trained model** -- Start with YOLOv8 (detection) or EfficientNet (classification)
4. **Set up training environment** -- GPU instance, PyTorch, experiment tracker
5. **Fine-tune on your data** -- Transfer learning from pre-trained weights
6. **Evaluate on test set** -- Check precision, recall, mAP, confusion matrix
7. **Optimize for inference** -- Export to ONNX/TensorRT, quantize if needed
8. **Build inference API** -- FastAPI + model serving with GPU support
9. **Add preprocessing pipeline** -- Image resize, normalize, format conversion
10. **Deploy with monitoring** -- Track inference latency, accuracy drift, GPU memory

## Project Structure

```
src/
  data/
    dataset.py            # Dataset class, data loading
    augmentations.py       # Training augmentations
    prepare.py             # Data download, split, format conversion
  models/
    backbone.py            # Model architecture definition
    heads.py               # Task-specific heads (classify, detect)
    losses.py              # Custom loss functions
  training/
    train.py               # Training loop
    evaluate.py            # Evaluation metrics
    config.yaml            # Hyperparameters, paths
  inference/
    predict.py             # Single image inference
    batch.py               # Batch inference pipeline
    video.py               # Video processing pipeline
    postprocess.py         # NMS, filtering, formatting
  api/
    server.py              # FastAPI inference endpoint
    schemas.py             # Request/response models
  export/
    onnx_export.py         # Export to ONNX
    tensorrt_convert.py    # TensorRT optimization
data/
  raw/                     # Original images
  processed/               # Resized, augmented
  annotations/             # Labels in COCO/VOC format
models/                    # Saved model checkpoints
```
