---
name: Computer Vision Pipeline
description: Build CV pipelines for image classification, object detection, segmentation, and OCR with PyTorch, YOLO, and Detectron2
---

# Computer Vision Pipeline Skill

**Purpose**: Guide the design and implementation of computer vision pipelines from data preparation through model training, evaluation, and deployment for classification, detection, segmentation, and OCR tasks.

---

## TRIGGER COMMANDS

```text
"Build an image classification model"
"Set up object detection with YOLO"
"Train a segmentation model"
"Implement an OCR pipeline"
"Using computer_vision_pipeline skill: [task]"
```

---

## Task Selection Matrix

| Task | Output | Models | Typical Accuracy | Use Case |
|------|--------|--------|-----------------|----------|
| Classification | Class label | ResNet, EfficientNet, ViT | 90-99% | Product categorization |
| Object Detection | Bounding boxes + labels | YOLO, DETR, Faster R-CNN | 40-60% mAP | Surveillance, counting |
| Semantic Segmentation | Pixel-level classes | U-Net, DeepLabV3, SegFormer | 70-85% mIoU | Medical imaging |
| Instance Segmentation | Per-object masks | Mask R-CNN, YOLO-Seg, SAM | 35-55% mAP | Robotics, AR |
| Panoptic Segmentation | Stuff + things | Mask2Former | 50-65% PQ | Autonomous driving |
| OCR | Text extraction | EasyOCR, PaddleOCR, Tesseract | 85-99% | Document processing |
| Pose Estimation | Keypoints | YOLO-Pose, MediaPipe | 65-80% mAP | Sports, fitness |

### Decision Flowchart

```
START: What do you need to detect?
  |
  +-- "Is this a [thing]?" (binary/multi-class)
  |     --> Image Classification
  |
  +-- "Where are the [things]?" (boxes)
  |     +-- Real-time needed --> YOLOv8/v11
  |     +-- Maximum accuracy --> DETR / Faster R-CNN
  |
  +-- "What pixels belong to [thing]?" (masks)
  |     +-- Per-class --> Semantic Segmentation (DeepLabV3)
  |     +-- Per-instance --> Instance Segmentation (Mask R-CNN)
  |     +-- Zero-shot --> SAM 2
  |
  +-- "What text is in the image?"
  |     +-- Structured (forms, receipts) --> PaddleOCR
  |     +-- Scene text (signs, photos) --> EasyOCR
  |     +-- PDF/scanned docs --> Tesseract + preprocessing
  |
  +-- "Where are the body parts?"
        --> Pose Estimation (YOLO-Pose, MediaPipe)
```

---

## Data Preparation

### Dataset Format Standards

**Image Classification** (folder structure):

```
dataset/
  +-- train/
  |     +-- cat/
  |     |     +-- img001.jpg
  |     |     +-- img002.jpg
  |     +-- dog/
  |           +-- img001.jpg
  +-- val/
  |     +-- cat/
  |     +-- dog/
  +-- test/
        +-- cat/
        +-- dog/
```

**Object Detection (YOLO format)**:

```
dataset/
  +-- images/
  |     +-- train/
  |     +-- val/
  +-- labels/
  |     +-- train/
  |     |     +-- img001.txt   # class_id cx cy w h (normalized)
  |     +-- val/
  +-- data.yaml
```

```yaml
# data.yaml
path: ./dataset
train: images/train
val: images/val
test: images/test

names:
  0: person
  1: car
  2: bicycle
```

**COCO Format** (detection/segmentation):

```json
{
  "images": [
    {"id": 1, "file_name": "img001.jpg", "width": 640, "height": 480}
  ],
  "annotations": [
    {
      "id": 1,
      "image_id": 1,
      "category_id": 1,
      "bbox": [100, 100, 200, 150],
      "area": 30000,
      "segmentation": [[100, 100, 300, 100, 300, 250, 100, 250]],
      "iscrowd": 0
    }
  ],
  "categories": [
    {"id": 1, "name": "person"}
  ]
}
```

### Data Augmentation

```python
import albumentations as A
from albumentations.pytorch import ToTensorV2

# Classification augmentation pipeline
train_transform = A.Compose([
    A.RandomResizedCrop(height=224, width=224, scale=(0.8, 1.0)),
    A.HorizontalFlip(p=0.5),
    A.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1, p=0.5),
    A.GaussNoise(var_limit=(10, 50), p=0.3),
    A.GaussianBlur(blur_limit=(3, 7), p=0.2),
    A.RandomRotate90(p=0.3),
    A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ToTensorV2(),
])

val_transform = A.Compose([
    A.Resize(height=256, width=256),
    A.CenterCrop(height=224, width=224),
    A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ToTensorV2(),
])

# Detection augmentation (preserves bounding boxes)
detection_transform = A.Compose([
    A.RandomResizedCrop(height=640, width=640, scale=(0.5, 1.0)),
    A.HorizontalFlip(p=0.5),
    A.ColorJitter(brightness=0.2, contrast=0.2, p=0.5),
    A.RandomBrightnessContrast(p=0.3),
    A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ToTensorV2(),
], bbox_params=A.BboxParams(
    format='yolo',
    label_fields=['class_labels'],
    min_visibility=0.3,
))
```

### Augmentation Strategy by Data Size

| Dataset Size | Augmentation Level | Techniques |
|-------------|-------------------|------------|
| < 100 images | Heavy | All transforms + synthetic data (Diffusion) |
| 100-1K | Moderate-Heavy | Geometric + color + noise + mixup |
| 1K-10K | Moderate | Flip, crop, color jitter, rotation |
| 10K-100K | Light | Flip, crop, basic color |
| > 100K | Minimal | Flip only, or none |

---

## Image Classification

### Transfer Learning with torchvision

```python
import torch
import torch.nn as nn
from torchvision import models
from torch.utils.data import DataLoader
from torchvision.datasets import ImageFolder

# Load pre-trained model
model = models.efficientnet_v2_s(weights=models.EfficientNet_V2_S_Weights.DEFAULT)

# Replace classifier head
num_classes = 10
model.classifier = nn.Sequential(
    nn.Dropout(p=0.3),
    nn.Linear(model.classifier[1].in_features, num_classes),
)

# Freeze backbone (optional: fine-tune later)
for param in model.features.parameters():
    param.requires_grad = False

# Data loaders
train_dataset = ImageFolder("dataset/train", transform=train_transform)
val_dataset = ImageFolder("dataset/val", transform=val_transform)
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True, num_workers=4)
val_loader = DataLoader(val_dataset, batch_size=32, num_workers=4)

# Training loop
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = model.to(device)
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3, weight_decay=0.01)
scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=20)
criterion = nn.CrossEntropyLoss(label_smoothing=0.1)

for epoch in range(20):
    model.train()
    running_loss = 0.0
    correct = 0
    total = 0

    for images, labels in train_loader:
        images, labels = images.to(device), labels.to(device)

        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()
        _, predicted = outputs.max(1)
        total += labels.size(0)
        correct += predicted.eq(labels).sum().item()

    scheduler.step()

    # Validation
    model.eval()
    val_correct = 0
    val_total = 0
    with torch.no_grad():
        for images, labels in val_loader:
            images, labels = images.to(device), labels.to(device)
            outputs = model(images)
            _, predicted = outputs.max(1)
            val_total += labels.size(0)
            val_correct += predicted.eq(labels).sum().item()

    print(f"Epoch {epoch+1}: "
          f"Loss={running_loss/len(train_loader):.4f} "
          f"Train Acc={100*correct/total:.1f}% "
          f"Val Acc={100*val_correct/val_total:.1f}%")
```

### Model Selection for Classification

| Model | Params | Top-1 (ImageNet) | Inference (ms) | Best For |
|-------|--------|-----------------|----------------|----------|
| MobileNetV3-Small | 2.5M | 67.4% | 1.5 | Mobile/edge |
| EfficientNet-B0 | 5.3M | 77.1% | 3 | Balanced |
| EfficientNetV2-S | 21.5M | 84.2% | 5 | Quality |
| ResNet-50 | 25.6M | 80.9% | 4 | General |
| ConvNeXt-Small | 50.2M | 83.6% | 8 | Modern CNN |
| ViT-B/16 | 86.6M | 84.5% | 12 | Best quality |
| DINOv2-S | 22M | 81.1% | 6 | Zero-shot/FT |

---

## Object Detection with YOLO

### YOLOv8/v11 Training

```python
from ultralytics import YOLO

# Load pre-trained model
model = YOLO("yolo11n.pt")  # nano: fast, less accurate
# model = YOLO("yolo11s.pt")  # small: balanced
# model = YOLO("yolo11m.pt")  # medium: more accurate
# model = YOLO("yolo11l.pt")  # large: high accuracy
# model = YOLO("yolo11x.pt")  # extra: maximum accuracy

# Train
results = model.train(
    data="dataset/data.yaml",
    epochs=100,
    imgsz=640,
    batch=16,
    patience=20,            # Early stopping
    lr0=0.01,
    lrf=0.01,
    mosaic=1.0,
    mixup=0.1,
    degrees=10.0,
    flipud=0.5,
    fliplr=0.5,
    device=0,               # GPU index
    workers=8,
    project="runs/detect",
    name="my_model",
    save=True,
    save_period=10,
)

# Validate
metrics = model.val()
print(f"mAP50: {metrics.box.map50:.4f}")
print(f"mAP50-95: {metrics.box.map:.4f}")

# Predict
results = model.predict(
    source="test_images/",
    conf=0.25,
    iou=0.45,
    save=True,
    save_txt=True,
)
```

### YOLO Model Comparison

| Model | Params | mAP50-95 | Speed (ms) | FLOPs |
|-------|--------|----------|-----------|-------|
| YOLOv8n | 3.2M | 37.3 | 1.2 | 8.7G |
| YOLOv8s | 11.2M | 44.9 | 2.0 | 28.6G |
| YOLOv8m | 25.9M | 50.2 | 3.5 | 78.9G |
| YOLOv8l | 43.7M | 52.9 | 5.5 | 165G |
| YOLOv11n | 2.6M | 39.5 | 1.5 | 6.5G |
| YOLOv11s | 9.4M | 47.0 | 2.5 | 21.5G |
| YOLOv11m | 20.1M | 51.5 | 4.7 | 68.0G |

### Custom Inference Pipeline

```python
from ultralytics import YOLO
import cv2

model = YOLO("runs/detect/my_model/weights/best.pt")

def detect_objects(image_path: str, conf_threshold: float = 0.25) -> list[dict]:
    """Run detection and return structured results."""
    results = model(image_path, conf=conf_threshold, verbose=False)

    detections = []
    for result in results:
        for box in result.boxes:
            detections.append({
                "class": result.names[int(box.cls)],
                "confidence": float(box.conf),
                "bbox": box.xyxy[0].tolist(),  # [x1, y1, x2, y2]
            })

    return detections

def detect_video(video_path: str, output_path: str):
    """Run detection on video with tracking."""
    cap = cv2.VideoCapture(video_path)
    fps = int(cap.get(cv2.CAP_PROP_FPS))
    w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    writer = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        results = model.track(frame, persist=True, verbose=False)
        annotated = results[0].plot()
        writer.write(annotated)

    cap.release()
    writer.release()
```

---

## Segmentation

### Semantic Segmentation with DeepLabV3

```python
import torch
from torchvision.models.segmentation import deeplabv3_resnet50

model = deeplabv3_resnet50(weights="DeepLabV3_ResNet50_Weights.DEFAULT")
model.classifier[4] = torch.nn.Conv2d(256, num_classes, kernel_size=1)
model = model.to(device)

# Inference
model.eval()
with torch.no_grad():
    output = model(input_tensor)["out"]
    predictions = output.argmax(1)  # [B, H, W]
```

### SAM 2 (Segment Anything)

```python
from sam2.build_sam import build_sam2
from sam2.sam2_image_predictor import SAM2ImagePredictor

predictor = SAM2ImagePredictor(build_sam2("sam2_hiera_large.pt"))

image = cv2.imread("image.jpg")
predictor.set_image(image)

# Point prompt
masks, scores, logits = predictor.predict(
    point_coords=np.array([[500, 375]]),
    point_labels=np.array([1]),  # 1 = foreground, 0 = background
    multimask_output=True,
)

# Box prompt
masks, scores, logits = predictor.predict(
    box=np.array([100, 100, 400, 300]),  # [x1, y1, x2, y2]
    multimask_output=False,
)
```

---

## OCR Pipeline

### EasyOCR

```python
import easyocr

reader = easyocr.Reader(['en'], gpu=True)

def extract_text(image_path: str) -> list[dict]:
    """Extract text with bounding boxes and confidence."""
    results = reader.readtext(image_path)
    return [
        {
            "bbox": result[0],       # [[x1,y1], [x2,y2], [x3,y3], [x4,y4]]
            "text": result[1],
            "confidence": result[2],
        }
        for result in results
    ]
```

### PaddleOCR (Best for Structured Documents)

```python
from paddleocr import PaddleOCR

ocr = PaddleOCR(use_angle_cls=True, lang='en', use_gpu=True)

def extract_structured_text(image_path: str) -> list[dict]:
    """Extract text from forms, receipts, tables."""
    results = ocr.ocr(image_path, cls=True)
    extracted = []
    for line in results[0]:
        bbox, (text, confidence) = line
        extracted.append({
            "bbox": bbox,
            "text": text,
            "confidence": confidence,
        })
    return extracted
```

### OCR Comparison

| Engine | Speed | Accuracy | Languages | GPU | Best For |
|--------|-------|----------|-----------|-----|----------|
| EasyOCR | Medium | Good | 80+ | Yes | Scene text, general |
| PaddleOCR | Fast | Very Good | 80+ | Yes | Structured docs |
| Tesseract | Slow | Fair | 100+ | No | Simple docs, legacy |
| TrOCR | Slow | Excellent | English | Yes | Handwriting |
| DocTR | Medium | Very Good | Multilingual | Yes | Modern alternative |

---

## Evaluation Metrics

| Task | Primary Metric | Secondary | What It Measures |
|------|---------------|-----------|-----------------|
| Classification | Accuracy | F1, AUC-ROC | Correct predictions |
| Detection | mAP@50-95 | mAP@50 | Box quality + class |
| Segmentation | mIoU | Dice, pixel acc | Pixel-level overlap |
| OCR | CER, WER | Accuracy | Character/word errors |

```python
# Detection: compute mAP using torchmetrics
from torchmetrics.detection import MeanAveragePrecision

metric = MeanAveragePrecision(iou_thresholds=[0.5, 0.75])

preds = [{"boxes": pred_boxes, "scores": scores, "labels": pred_labels}]
target = [{"boxes": gt_boxes, "labels": gt_labels}]

metric.update(preds, target)
results = metric.compute()
print(f"mAP@50: {results['map_50']:.4f}")
print(f"mAP@75: {results['map_75']:.4f}")
```

---

## Export and Optimization

### Export to ONNX

```python
import torch

model.eval()
dummy_input = torch.randn(1, 3, 640, 640).to(device)

torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    opset_version=17,
    input_names=["images"],
    output_names=["output"],
    dynamic_axes={
        "images": {0: "batch_size"},
        "output": {0: "batch_size"},
    },
)
```

### YOLO Export

```python
model = YOLO("best.pt")

# Export to various formats
model.export(format="onnx", dynamic=True, simplify=True)
model.export(format="tensorrt", half=True)     # NVIDIA GPU
model.export(format="coreml")                   # Apple devices
model.export(format="tflite", int8=True)        # Mobile/edge
model.export(format="openvino")                 # Intel
```

---

## EXIT CHECKLIST

- [ ] Task type identified (classification, detection, segmentation, OCR)
- [ ] Dataset formatted and split (train/val/test)
- [ ] Augmentation pipeline configured for data size
- [ ] Model selected based on accuracy/speed trade-off
- [ ] Transfer learning applied from pre-trained weights
- [ ] Training completed with monitored metrics
- [ ] Evaluation metrics meet target thresholds
- [ ] Model exported to target format (ONNX, TensorRT, CoreML)
- [ ] Inference pipeline tested on real-world images

---

## Cross-References

- `5-ship/model_serving_deployment` -- Deploying vision models to production
- `3-build/distributed_training` -- Multi-GPU training for large vision models
- `3-build/lora_finetuning_workflow` -- LoRA for vision transformers

---

*Skill Version: 1.0 | Created: March 2026*
