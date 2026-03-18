---
name: NVIDIA NIM Deployment
description: Deploy pre-built optimized inference containers for LLMs, vision, and embeddings using NVIDIA NIM with TensorRT-LLM optimization, GPU allocation, and Kubernetes scaling
triggers:
  - /nim
  - /nvidia-nim
  - /nim-deployment
---

# NVIDIA NIM Deployment Skill

## WHEN TO USE

- Deploying LLMs, vision models, or embedding models with maximum GPU throughput
- You need pre-optimized TensorRT-LLM containers instead of building your own serving stack
- Replacing cloud API calls (OpenAI, Anthropic) with self-hosted inference for cost or data sovereignty
- Scaling GPU inference across Kubernetes clusters with NVIDIA GPU Operator

---

## PROCESS

1. **Select a NIM container from the catalog** at `build.nvidia.com`. Match your model (Llama 3, Mistral, SDXL, NV-Embed) to the available NIM images. Confirm your GPU meets the minimum VRAM requirement listed on the catalog card.

2. **Pull and configure the NIM container.** Authenticate with `NGC_API_KEY` and pull the image:
   ```bash
   export NGC_API_KEY=<your-key>
   docker pull nvcr.io/nim/meta/llama-3.1-8b-instruct:latest

   docker run --gpus all -p 8000:8000 \
     -e NGC_API_KEY=$NGC_API_KEY \
     nvcr.io/nim/meta/llama-3.1-8b-instruct:latest
   ```

3. **Verify the health endpoint** before routing traffic. NIM exposes OpenAI-compatible endpoints:
   ```bash
   curl -s http://localhost:8000/v1/health/ready   # returns 200 when warm
   curl http://localhost:8000/v1/models             # lists loaded models
   ```

4. **Tune GPU allocation.** Set `NIM_MAX_MODEL_LEN`, `NIM_TENSOR_PARALLEL_SIZE`, and `NIM_GPU_MEMORY_FRACTION` via environment variables. For multi-GPU nodes, increase tensor parallelism to match available GPUs.

5. **Deploy to Kubernetes** with the NVIDIA GPU Operator and NIM Helm chart:
   ```bash
   helm repo add nvidia https://helm.ngc.nvidia.com/nim
   helm install llm-nim nvidia/nim-llm \
     --set model.name=meta/llama-3.1-8b-instruct \
     --set resources.limits."nvidia\.com/gpu"=1 \
     --set autoscaling.enabled=true \
     --set autoscaling.minReplicas=1 \
     --set autoscaling.maxReplicas=4
   ```

6. **Set up monitoring.** NIM exports Prometheus metrics at `/metrics`. Track `nim_request_duration_seconds`, `nim_requests_total`, `nim_gpu_utilization`, and `nim_kv_cache_usage`. Alert on KV cache > 90% or p99 latency exceeding your SLO.

7. **Run cost comparison.** Calculate cost-per-million-tokens for NIM self-hosted vs cloud APIs. Factor in GPU hourly rate, utilization percentage, and amortized setup time. NIM typically breaks even at 50M+ tokens/month on a single A100.

---

## CHECKLIST

- [ ] NGC API key created and stored securely (not in repo)
- [ ] NIM container pulled and starts without errors
- [ ] Health endpoint returns ready before accepting traffic
- [ ] GPU allocation tuned for model size and available hardware
- [ ] TensorRT-LLM optimization profile confirmed (check NIM logs for engine build)
- [ ] Kubernetes deployment with GPU resource limits and HPA configured
- [ ] Prometheus scraping `/metrics` with alerts on latency and cache pressure
- [ ] Load test completed: tokens/sec meets throughput target
- [ ] Cost-per-token calculated and documented vs cloud API baseline
- [ ] Rollback procedure tested: previous NIM image tag pinned and verified

---

## Related Skills

- [Model Serving Deployment](../../5-ship/model_serving_deployment/SKILL.md) -- vLLM, TGI, Triton alternatives and quantization strategies
- [Kubernetes Operations](../../3-build/kubernetes_operations/SKILL.md) -- GPU Operator setup, node selectors, tolerations for GPU workloads

---

*Skill Version: 1.0 | Created: March 2026*
