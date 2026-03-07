---
name: Model Serving Deployment
description: Deploy and serve ML models with TorchServe, TGI, vLLM, Triton, and BentoML including quantization and scaling strategies
---

# Model Serving Deployment Skill

**Purpose**: Guide deployment of trained models into production-grade serving infrastructure with optimal latency, throughput, and cost efficiency.

---

## TRIGGER COMMANDS

```text
"Deploy a model for inference"
"Set up vLLM serving for my model"
"Choose a model serving framework"
"Quantize and deploy a language model"
"Using model_serving_deployment skill: [task]"
```

---

## Serving Framework Selection Matrix

| Framework | Model Types | Batching | Quantization | Multi-Model | GPU Required | Best For |
|-----------|-------------|----------|--------------|-------------|-------------|----------|
| vLLM | LLM only | Continuous | AWQ, GPTQ, FP8 | Yes | Yes | High-throughput LLM |
| TGI | LLM only | Continuous | GPTQ, AWQ, EETQ | No | Yes | Simple LLM deploy |
| Triton | Any | Dynamic | TensorRT, ONNX | Yes | Optional | Multi-framework |
| TorchServe | PyTorch | Dynamic | Torch quantize | Yes | Optional | PyTorch ecosystem |
| BentoML | Any | Adaptive | Via runtime | Yes | Optional | ML platform teams |
| ONNX Runtime | Any ONNX | Static | INT8, FP16 | Yes | Optional | Cross-platform |
| Ollama | LLM (GGUF) | None | GGUF quants | Yes | Optional | Local/dev |
| llama.cpp | LLM (GGUF) | Parallel | GGUF quants | No | Optional | Edge/CPU |

### Decision Tree

```
START: What are you serving?
  |
  +-- Large Language Model (>1B params)
  |     |
  |     +-- Need highest throughput?
  |     |     --> vLLM (PagedAttention, continuous batching)
  |     |
  |     +-- Simple deployment, managed features?
  |     |     --> TGI (built-in streaming, token limits)
  |     |
  |     +-- CPU or edge deployment?
  |     |     --> llama.cpp / Ollama (GGUF format)
  |     |
  |     +-- Multi-model with non-LLM too?
  |           --> Triton Inference Server
  |
  +-- Vision / Classification / Detection
  |     |
  |     +-- Need TensorRT optimization?
  |     |     --> Triton
  |     +-- PyTorch-native?
  |     |     --> TorchServe
  |     +-- Cross-platform?
  |           --> ONNX Runtime
  |
  +-- Multi-model pipeline (LLM + embeddings + reranker)
        --> Triton or BentoML
```

---

## vLLM Deployment

### Basic Setup

```bash
pip install vllm

# Serve with OpenAI-compatible API
vllm serve meta-llama/Llama-3.1-8B-Instruct \
  --host 0.0.0.0 \
  --port 8000 \
  --tensor-parallel-size 1 \
  --max-model-len 4096 \
  --gpu-memory-utilization 0.90 \
  --dtype bfloat16
```

### Production Docker Deployment

```dockerfile
FROM vllm/vllm-openai:latest

ENV MODEL_NAME="meta-llama/Llama-3.1-8B-Instruct"
ENV TENSOR_PARALLEL_SIZE=1
ENV MAX_MODEL_LEN=4096

EXPOSE 8000

CMD ["python", "-m", "vllm.entrypoints.openai.api_server", \
     "--model", "${MODEL_NAME}", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--tensor-parallel-size", "${TENSOR_PARALLEL_SIZE}", \
     "--max-model-len", "${MAX_MODEL_LEN}", \
     "--gpu-memory-utilization", "0.90"]
```

```yaml
# docker-compose.yml
services:
  vllm:
    image: vllm/vllm-openai:latest
    ports:
      - "8000:8000"
    volumes:
      - model-cache:/root/.cache/huggingface
    environment:
      - HUGGING_FACE_HUB_TOKEN=${HF_TOKEN}
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    command: >
      --model meta-llama/Llama-3.1-8B-Instruct
      --host 0.0.0.0
      --port 8000
      --tensor-parallel-size 1
      --max-model-len 4096
      --gpu-memory-utilization 0.90
      --enable-prefix-caching
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 120s

volumes:
  model-cache:
```

### vLLM with Quantized Models

```bash
# AWQ quantized model
vllm serve TheBloke/Llama-3-8B-Instruct-AWQ \
  --quantization awq \
  --max-model-len 4096

# GPTQ quantized model
vllm serve TheBloke/Llama-3-8B-Instruct-GPTQ \
  --quantization gptq \
  --max-model-len 4096

# FP8 quantization (H100/Ada)
vllm serve meta-llama/Llama-3.1-8B-Instruct \
  --quantization fp8 \
  --max-model-len 4096
```

### vLLM Performance Tuning

| Parameter | Default | Tuning Guidance |
|-----------|---------|----------------|
| `--gpu-memory-utilization` | 0.90 | Increase to 0.95 for max throughput |
| `--max-num-seqs` | 256 | Reduce for lower latency per request |
| `--max-num-batched-tokens` | auto | Set to max_model_len * max_num_seqs |
| `--enable-prefix-caching` | off | Enable for repeated system prompts |
| `--enable-chunked-prefill` | off | Enable for mixed short/long inputs |
| `--tensor-parallel-size` | 1 | Match GPU count |
| `--pipeline-parallel-size` | 1 | Use for models too large for TP |

---

## Text Generation Inference (TGI)

```bash
# Docker deployment
docker run --gpus all -p 8080:80 \
  -v model-cache:/data \
  -e HUGGING_FACE_HUB_TOKEN=$HF_TOKEN \
  ghcr.io/huggingface/text-generation-inference:latest \
  --model-id meta-llama/Llama-3.1-8B-Instruct \
  --max-input-tokens 2048 \
  --max-total-tokens 4096 \
  --max-batch-prefill-tokens 4096 \
  --quantize awq \
  --num-shard 1
```

### TGI Client Usage

```python
from huggingface_hub import InferenceClient

client = InferenceClient("http://localhost:8080")

# Streaming
for token in client.text_generation(
    "Explain quantum computing",
    max_new_tokens=512,
    temperature=0.7,
    stream=True,
):
    print(token, end="")

# Non-streaming
response = client.text_generation(
    "Explain quantum computing",
    max_new_tokens=512,
    details=True,
)
print(f"Generated: {response.generated_text}")
print(f"Tokens: {response.details.generated_tokens}")
```

---

## Triton Inference Server

### Model Repository Structure

```
model_repository/
  +-- llm/
  |   +-- config.pbtxt
  |   +-- 1/
  |       +-- model.py
  +-- embeddings/
  |   +-- config.pbtxt
  |   +-- 1/
  |       +-- model.onnx
  +-- reranker/
      +-- config.pbtxt
      +-- 1/
          +-- model.plan    # TensorRT engine
```

### Triton Config for ONNX Model

```protobuf
# config.pbtxt
name: "embeddings"
platform: "onnxruntime_onnx"
max_batch_size: 64

input [
  {
    name: "input_ids"
    data_type: TYPE_INT64
    dims: [-1]
  },
  {
    name: "attention_mask"
    data_type: TYPE_INT64
    dims: [-1]
  }
]

output [
  {
    name: "embeddings"
    data_type: TYPE_FP32
    dims: [-1]
  }
]

instance_group [
  {
    count: 2
    kind: KIND_GPU
    gpus: [0]
  }
]

dynamic_batching {
  preferred_batch_size: [8, 16, 32]
  max_queue_delay_microseconds: 100000
}
```

### Triton Launch

```bash
docker run --gpus all -p 8000:8000 -p 8001:8001 -p 8002:8002 \
  -v $(pwd)/model_repository:/models \
  nvcr.io/nvidia/tritonserver:24.01-py3 \
  tritonserver --model-repository=/models \
  --model-control-mode=poll \
  --repository-poll-secs=30
```

---

## Quantization Strategies

### Quantization Comparison

| Method | Bits | Quality Loss | Speed Gain | Framework Support |
|--------|------|-------------|------------|-------------------|
| FP16 | 16 | None | 1.5-2x | All |
| BF16 | 16 | Negligible | 1.5-2x | All modern |
| FP8 (E4M3) | 8 | <1% | 2-3x | vLLM, TensorRT |
| INT8 (W8A8) | 8 | 1-2% | 2-3x | TensorRT, ONNX |
| GPTQ | 4 | 2-4% | 3-4x | vLLM, TGI |
| AWQ | 4 | 1-3% | 3-4x | vLLM, TGI |
| GGUF Q4_K_M | 4 | 3-5% | 4-5x (CPU) | llama.cpp, Ollama |
| GGUF Q2_K | 2 | 8-15% | 6-8x (CPU) | llama.cpp |

### Quantize with AutoAWQ

```python
from awq import AutoAWQForCausalLM
from transformers import AutoTokenizer

model_path = "meta-llama/Llama-3.1-8B-Instruct"
quant_path = "./llama3-8b-awq"

model = AutoAWQForCausalLM.from_pretrained(model_path)
tokenizer = AutoTokenizer.from_pretrained(model_path)

quant_config = {
    "zero_point": True,
    "q_group_size": 128,
    "w_bit": 4,
    "version": "GEMM",
}

model.quantize(tokenizer, quant_config=quant_config)
model.save_quantized(quant_path)
tokenizer.save_pretrained(quant_path)
```

### Quantize with AutoGPTQ

```python
from auto_gptq import AutoGPTQForCausalLM, BaseQuantizeConfig
from transformers import AutoTokenizer

model_path = "meta-llama/Llama-3.1-8B-Instruct"
quant_path = "./llama3-8b-gptq"

tokenizer = AutoTokenizer.from_pretrained(model_path)

quantize_config = BaseQuantizeConfig(
    bits=4,
    group_size=128,
    damp_percent=0.1,
    desc_act=True,
    model_file_base_name="model",
)

model = AutoGPTQForCausalLM.from_pretrained(model_path, quantize_config)

# Calibration dataset (use representative samples)
calibration_data = [
    tokenizer(text, return_tensors="pt")
    for text in calibration_texts[:128]
]

model.quantize(calibration_data)
model.save_quantized(quant_path, use_safetensors=True)
```

---

## Scaling and Load Balancing

### Horizontal Scaling Architecture

```
                    +------------------+
                    |   Load Balancer  |
                    |  (nginx/envoy)   |
                    +--------+---------+
                             |
              +--------------+--------------+
              |              |              |
        +-----v----+  +-----v----+  +-----v----+
        | vLLM #1  |  | vLLM #2  |  | vLLM #3  |
        | GPU 0    |  | GPU 1    |  | GPU 2    |
        +----------+  +----------+  +----------+
```

### Nginx Load Balancer Config

```nginx
upstream vllm_cluster {
    least_conn;
    server vllm-1:8000 max_fails=3 fail_timeout=30s;
    server vllm-2:8000 max_fails=3 fail_timeout=30s;
    server vllm-3:8000 max_fails=3 fail_timeout=30s;
}

server {
    listen 80;

    location /v1/ {
        proxy_pass http://vllm_cluster;
        proxy_set_header Host $host;
        proxy_read_timeout 300s;
        proxy_buffering off;      # Required for streaming
        chunked_transfer_encoding on;
    }

    location /health {
        proxy_pass http://vllm_cluster/health;
    }
}
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vllm-server
spec:
  replicas: 3
  selector:
    matchLabels:
      app: vllm
  template:
    metadata:
      labels:
        app: vllm
    spec:
      containers:
        - name: vllm
          image: vllm/vllm-openai:latest
          args:
            - "--model"
            - "meta-llama/Llama-3.1-8B-Instruct"
            - "--host"
            - "0.0.0.0"
            - "--port"
            - "8000"
            - "--gpu-memory-utilization"
            - "0.90"
          ports:
            - containerPort: 8000
          resources:
            limits:
              nvidia.com/gpu: 1
            requests:
              nvidia.com/gpu: 1
              memory: "16Gi"
              cpu: "4"
          readinessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 120
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /health
              port: 8000
            initialDelaySeconds: 180
            periodSeconds: 30
          env:
            - name: HUGGING_FACE_HUB_TOKEN
              valueFrom:
                secretKeyRef:
                  name: hf-secret
                  key: token
      tolerations:
        - key: nvidia.com/gpu
          operator: Exists
          effect: NoSchedule
---
apiVersion: v1
kind: Service
metadata:
  name: vllm-service
spec:
  selector:
    app: vllm
  ports:
    - port: 80
      targetPort: 8000
  type: ClusterIP
```

---

## Health Checks and Monitoring

### Health Check Script

```python
import httpx
import time

def check_model_health(base_url: str) -> dict:
    """Comprehensive model serving health check."""
    results = {"healthy": True, "checks": {}}

    # Basic health endpoint
    try:
        r = httpx.get(f"{base_url}/health", timeout=5)
        results["checks"]["health"] = r.status_code == 200
    except httpx.RequestError:
        results["checks"]["health"] = False
        results["healthy"] = False
        return results

    # Latency check with simple prompt
    try:
        start = time.time()
        r = httpx.post(
            f"{base_url}/v1/completions",
            json={
                "model": "default",
                "prompt": "Hello",
                "max_tokens": 1,
            },
            timeout=30,
        )
        latency_ms = (time.time() - start) * 1000
        results["checks"]["latency_ms"] = round(latency_ms, 1)
        results["checks"]["latency_ok"] = latency_ms < 5000
    except httpx.RequestError as e:
        results["checks"]["latency_ok"] = False
        results["checks"]["latency_error"] = str(e)

    # Model info
    try:
        r = httpx.get(f"{base_url}/v1/models", timeout=5)
        models = r.json().get("data", [])
        results["checks"]["models_loaded"] = len(models)
    except httpx.RequestError:
        results["checks"]["models_loaded"] = 0

    results["healthy"] = all(
        v for k, v in results["checks"].items()
        if k.endswith("_ok") or k == "health"
    )
    return results
```

### Prometheus Metrics

```yaml
# prometheus.yml scrape config for vLLM
scrape_configs:
  - job_name: 'vllm'
    metrics_path: '/metrics'
    static_configs:
      - targets: ['vllm-1:8000', 'vllm-2:8000']
    scrape_interval: 15s
```

Key metrics to monitor:

| Metric | Description | Alert Threshold |
|--------|-------------|----------------|
| `vllm:num_requests_running` | Active requests | > max_num_seqs |
| `vllm:num_requests_waiting` | Queued requests | > 100 |
| `vllm:gpu_cache_usage_perc` | KV cache usage | > 95% |
| `vllm:avg_generation_throughput` | Tokens/sec | < baseline * 0.5 |
| `vllm:request_latency` | E2E latency | p99 > 10s |

---

## Cost Optimization

| Strategy | Savings | Trade-off |
|----------|---------|-----------|
| AWQ/GPTQ quantization | 50-70% GPU memory | 1-3% quality loss |
| Spot/preemptible instances | 60-80% compute cost | Interruption risk |
| Request batching | 2-4x throughput | Added latency |
| Prefix caching | 20-40% compute | Memory overhead |
| Model distillation | 50-80% compute | Training cost upfront |
| Right-sizing GPU | 20-50% cost | Capacity planning |

---

## EXIT CHECKLIST

- [ ] Serving framework selected based on model type and requirements
- [ ] Model quantized to optimal precision for target hardware
- [ ] Deployment containerized with health checks
- [ ] Load balancing configured for horizontal scaling
- [ ] Monitoring and alerting set up (latency, throughput, errors)
- [ ] Cost optimization strategies applied
- [ ] Autoscaling policies defined
- [ ] Rollback procedure documented and tested

---

## Cross-References

- `3-build/lora_finetuning_workflow` -- Fine-tuning models before deployment
- `3-build/rag_advanced_patterns` -- Serving models as part of RAG pipelines
- `3-build/distributed_training` -- Multi-GPU model parallelism concepts apply to serving

---

*Skill Version: 1.0 | Created: March 2026*
