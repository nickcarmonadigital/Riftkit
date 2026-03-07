---
name: AI Cost Optimization
description: Optimize AI infrastructure costs including GPU selection, token tracking, model distillation, caching, and provider comparison
---

# AI Cost Optimization Skill

**Purpose**: Systematically reduce AI infrastructure and inference costs through GPU selection, token cost tracking, model distillation, caching strategies, quantization, provider comparison, and budgeting practices.

---

## TRIGGER COMMANDS

```text
"Optimize AI infrastructure costs for this project"
"Track and reduce LLM API token costs"
"Compare cloud providers and GPU options for ML workloads"
"Using ai_cost_optimization skill: [task]"
```

---

## Cost Optimization Strategy Map

```
AI Cost Optimization Levers:
+-- Infrastructure
|   +-- GPU selection (right-sizing)
|   +-- Spot/preemptible instances
|   +-- Auto-scaling policies
|   +-- Region optimization
|
+-- Model Optimization
|   +-- Quantization (INT8, INT4, GPTQ, AWQ)
|   +-- Distillation (large -> small model)
|   +-- Pruning
|   +-- Architecture selection
|
+-- Inference Optimization
|   +-- Caching (semantic, exact match)
|   +-- Batching (dynamic, static)
|   +-- Token management
|   +-- Prompt optimization
|
+-- Provider Strategy
|   +-- Multi-provider routing
|   +-- Reserved capacity vs on-demand
|   +-- Open-source vs API
|   +-- Batch vs real-time API
```

---

## LLM API Cost Comparison

### Major Provider Pricing (per 1M tokens, as of March 2026)

| Provider | Model | Input | Output | Context | Notes |
|----------|-------|-------|--------|---------|-------|
| OpenAI | GPT-4o | $2.50 | $10.00 | 128K | Best general purpose |
| OpenAI | GPT-4o-mini | $0.15 | $0.60 | 128K | Best budget option |
| OpenAI | o3-mini | $1.10 | $4.40 | 200K | Reasoning model |
| Anthropic | Claude Sonnet 4 | $3.00 | $15.00 | 200K | Best for code |
| Anthropic | Claude Haiku 3.5 | $0.80 | $4.00 | 200K | Fast + affordable |
| Google | Gemini 2.0 Flash | $0.10 | $0.40 | 1M | Cheapest major model |
| Google | Gemini 2.5 Pro | $1.25 | $10.00 | 1M | Large context |
| Mistral | Mistral Large | $2.00 | $6.00 | 128K | EU-hosted option |
| DeepSeek | DeepSeek V3 | $0.27 | $1.10 | 128K | Cheapest capable model |
| Groq | Llama 3.3 70B | $0.59 | $0.79 | 128K | Fastest inference |

### Cost Per Task Estimates

| Task | Tokens (avg) | Cheapest Option | Cost per 1K tasks |
|------|-------------|-----------------|-------------------|
| Classification | 200 in / 10 out | GPT-4o-mini | $0.04 |
| Summarization | 2000 in / 300 out | Gemini Flash | $0.32 |
| Code generation | 500 in / 500 out | DeepSeek V3 | $0.69 |
| RAG QA | 3000 in / 200 out | GPT-4o-mini | $0.57 |
| Complex reasoning | 1000 in / 1000 out | o3-mini | $5.50 |

---

## Token Cost Tracking

### Token Counter and Cost Tracker

```python
import tiktoken
from datetime import datetime
from collections import defaultdict
from dataclasses import dataclass, field

@dataclass
class TokenUsage:
    input_tokens: int = 0
    output_tokens: int = 0
    cached_tokens: int = 0
    requests: int = 0
    cost: float = 0.0

class CostTracker:
    """Track LLM API costs across models and use cases."""

    PRICING = {
        "gpt-4o": {"input": 2.50, "output": 10.00},
        "gpt-4o-mini": {"input": 0.15, "output": 0.60},
        "claude-sonnet-4": {"input": 3.00, "output": 15.00},
        "claude-haiku-3.5": {"input": 0.80, "output": 4.00},
        "gemini-2.0-flash": {"input": 0.10, "output": 0.40},
        "deepseek-v3": {"input": 0.27, "output": 1.10},
    }

    def __init__(self):
        self.usage: dict[str, dict[str, TokenUsage]] = defaultdict(
            lambda: defaultdict(TokenUsage)
        )
        self.daily_budget: float = 0
        self.monthly_budget: float = 0

    def log(self, model: str, input_tokens: int, output_tokens: int,
            use_case: str = "default", cached_tokens: int = 0):
        """Log a single API call."""
        pricing = self.PRICING.get(model, {"input": 0, "output": 0})
        billable_input = input_tokens - cached_tokens
        cost = (billable_input * pricing["input"] + output_tokens * pricing["output"]) / 1_000_000

        usage = self.usage[model][use_case]
        usage.input_tokens += input_tokens
        usage.output_tokens += output_tokens
        usage.cached_tokens += cached_tokens
        usage.requests += 1
        usage.cost += cost

    def get_total_cost(self) -> float:
        return sum(
            usage.cost
            for model_usage in self.usage.values()
            for usage in model_usage.values()
        )

    def get_report(self) -> dict:
        report = {"models": {}, "use_cases": {}, "total_cost": 0}

        for model, use_cases in self.usage.items():
            model_total = TokenUsage()
            for use_case, usage in use_cases.items():
                model_total.input_tokens += usage.input_tokens
                model_total.output_tokens += usage.output_tokens
                model_total.cost += usage.cost
                model_total.requests += usage.requests

                if use_case not in report["use_cases"]:
                    report["use_cases"][use_case] = {"cost": 0, "requests": 0}
                report["use_cases"][use_case]["cost"] += usage.cost
                report["use_cases"][use_case]["requests"] += usage.requests

            report["models"][model] = {
                "input_tokens": model_total.input_tokens,
                "output_tokens": model_total.output_tokens,
                "requests": model_total.requests,
                "cost": round(model_total.cost, 4),
            }

        report["total_cost"] = round(self.get_total_cost(), 4)
        return report

    def check_budget(self) -> dict:
        total = self.get_total_cost()
        return {
            "current_spend": total,
            "daily_budget": self.daily_budget,
            "monthly_budget": self.monthly_budget,
            "daily_remaining": max(0, self.daily_budget - total),
            "over_budget": total > self.daily_budget if self.daily_budget else False,
        }

# Usage
tracker = CostTracker()
tracker.daily_budget = 50.00
tracker.monthly_budget = 1000.00

# Log API calls
tracker.log("gpt-4o-mini", input_tokens=1500, output_tokens=200, use_case="classification")
tracker.log("gpt-4o", input_tokens=3000, output_tokens=500, use_case="summarization")

print(tracker.get_report())
```

### OpenAI Usage Tracking Wrapper

```python
from openai import OpenAI

class TrackedOpenAI:
    """OpenAI client wrapper with automatic cost tracking."""

    def __init__(self, tracker: CostTracker):
        self.client = OpenAI()
        self.tracker = tracker

    def chat(self, model: str, messages: list, use_case: str = "default", **kwargs):
        response = self.client.chat.completions.create(
            model=model,
            messages=messages,
            **kwargs,
        )

        usage = response.usage
        self.tracker.log(
            model=model,
            input_tokens=usage.prompt_tokens,
            output_tokens=usage.completion_tokens,
            use_case=use_case,
            cached_tokens=getattr(usage, "prompt_tokens_details", {}).get("cached_tokens", 0)
                if hasattr(usage, "prompt_tokens_details") else 0,
        )

        budget = self.tracker.check_budget()
        if budget["over_budget"]:
            print(f"WARNING: Over daily budget! Spent ${budget['current_spend']:.2f}/{budget['daily_budget']:.2f}")

        return response
```

---

## GPU Selection Guide

### GPU Comparison for ML Workloads

| GPU | VRAM | FP16 TFLOPS | Cost/hr (cloud) | Best For |
|-----|------|-------------|-----------------|----------|
| T4 | 16GB | 65 | $0.35-0.76 | Inference, small training |
| A10G | 24GB | 125 | $1.00-1.50 | Medium models, inference |
| L4 | 24GB | 121 | $0.70-1.20 | Inference (energy efficient) |
| A100 40GB | 40GB | 312 | $3.00-4.00 | Large model training |
| A100 80GB | 80GB | 312 | $4.00-6.00 | Very large models |
| H100 | 80GB | 990 | $8.00-12.00 | Frontier model training |

### GPU Selection Decision Tree

```
Model size?
+-- <7B params
|   +-- Inference only: T4 or L4
|   +-- Fine-tuning: A10G (QLoRA) or A100 40GB (full)
+-- 7B-13B params
|   +-- Inference: A10G or L4 (quantized)
|   +-- Fine-tuning: A100 40GB (QLoRA) or A100 80GB (full)
+-- 13B-70B params
|   +-- Inference: A100 40GB (quantized) or multi-GPU
|   +-- Fine-tuning: Multi A100 80GB
+-- >70B params
|   +-- Inference: Multi A100/H100
|   +-- Fine-tuning: Multi H100 cluster
```

### Spot Instance Strategy

```python
# spot_strategy.py
"""Strategy for using spot/preemptible instances for ML training."""

SPOT_CONFIG = {
    "training": {
        "use_spot": True,
        "max_spot_price_ratio": 0.5,  # Max 50% of on-demand
        "checkpoint_frequency_minutes": 15,
        "fallback_to_on_demand": True,
        "fallback_timeout_minutes": 30,
        "regions_priority": ["us-east-1", "us-west-2", "eu-west-1"],
    },
    "inference": {
        "use_spot": False,  # Too risky for serving
        "use_reserved": True,
        "reserved_ratio": 0.7,  # 70% reserved, 30% on-demand
    },
    "batch_processing": {
        "use_spot": True,
        "max_spot_price_ratio": 0.3,  # Aggressive savings
        "retry_on_interruption": True,
        "max_retries": 3,
    },
}

# Estimated savings
# Training with spot: 60-90% cost reduction
# Batch processing with spot: 70-90% cost reduction
# Reserved instances: 30-60% vs on-demand
```

---

## Model Quantization ROI

### Quantization Comparison

| Technique | Size Reduction | Speed Gain | Quality Loss | Implementation |
|-----------|---------------|------------|--------------|----------------|
| FP16 | 2x | 1.5-2x | Negligible | `torch.float16` |
| INT8 (LLM.int8) | 4x | 1-1.5x | Minimal | `bitsandbytes` |
| INT4 (QLoRA) | 8x | 1-1.3x | Small | `bitsandbytes` |
| GPTQ | 4-8x | 2-3x | Small | `auto-gptq` |
| AWQ | 4x | 2-3x | Small | `autoawq` |
| GGUF (llama.cpp) | 4-8x | CPU viable | Small-moderate | `llama-cpp-python` |

### Quantization Implementation

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
import torch

# INT8 quantization
model_8bit = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3-8B",
    quantization_config=BitsAndBytesConfig(load_in_8bit=True),
    device_map="auto",
)

# INT4 quantization (for QLoRA fine-tuning)
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    bnb_4bit_use_double_quant=True,
)
model_4bit = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3-8B",
    quantization_config=bnb_config,
    device_map="auto",
)

# GPTQ quantization
from transformers import GPTQConfig

gptq_config = GPTQConfig(bits=4, dataset="wikitext2", tokenizer=tokenizer)
model_gptq = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3-8B",
    quantization_config=gptq_config,
    device_map="auto",
)

# Memory comparison
def get_model_size_mb(model):
    param_bytes = sum(p.nelement() * p.element_size() for p in model.parameters())
    buffer_bytes = sum(b.nelement() * b.element_size() for b in model.buffers())
    return (param_bytes + buffer_bytes) / (1024 * 1024)

print(f"FP16: {get_model_size_mb(model_fp16):.0f} MB")
print(f"INT8: {get_model_size_mb(model_8bit):.0f} MB")
print(f"INT4: {get_model_size_mb(model_4bit):.0f} MB")
```

---

## Caching Strategies

### Semantic Cache for LLM Calls

```python
import hashlib
import json
import numpy as np
from datetime import datetime, timedelta

class SemanticCache:
    """Cache LLM responses using semantic similarity for near-duplicate queries."""

    def __init__(self, embedding_model, similarity_threshold: float = 0.95,
                 ttl_hours: int = 24, max_entries: int = 10000):
        self.embedding_model = embedding_model
        self.threshold = similarity_threshold
        self.ttl = timedelta(hours=ttl_hours)
        self.max_entries = max_entries
        self.cache: list[dict] = []

    def _get_embedding(self, text: str) -> np.ndarray:
        return self.embedding_model.encode(text)

    def get(self, query: str) -> str | None:
        query_embedding = self._get_embedding(query)
        now = datetime.utcnow()

        best_match = None
        best_score = 0

        for entry in self.cache:
            if now - entry["timestamp"] > self.ttl:
                continue
            similarity = np.dot(query_embedding, entry["embedding"]) / (
                np.linalg.norm(query_embedding) * np.linalg.norm(entry["embedding"])
            )
            if similarity > self.threshold and similarity > best_score:
                best_score = similarity
                best_match = entry

        if best_match:
            best_match["hits"] += 1
            return best_match["response"]
        return None

    def set(self, query: str, response: str):
        if len(self.cache) >= self.max_entries:
            # Evict least recently used
            self.cache.sort(key=lambda x: x["timestamp"])
            self.cache = self.cache[len(self.cache) // 4:]

        self.cache.append({
            "query": query,
            "embedding": self._get_embedding(query),
            "response": response,
            "timestamp": datetime.utcnow(),
            "hits": 0,
        })

    def stats(self) -> dict:
        total_hits = sum(e["hits"] for e in self.cache)
        return {
            "entries": len(self.cache),
            "total_hits": total_hits,
            "estimated_savings": total_hits * 0.003,  # Avg cost per call
        }
```

### Exact Match Cache with Redis

```python
import redis
import hashlib
import json

class ExactCache:
    """Cache LLM responses by exact prompt hash."""

    def __init__(self, redis_url: str = "redis://localhost:6379", ttl_seconds: int = 86400):
        self.redis = redis.from_url(redis_url)
        self.ttl = ttl_seconds
        self.hits = 0
        self.misses = 0

    def _hash_key(self, model: str, messages: list, temperature: float) -> str:
        content = json.dumps({"model": model, "messages": messages, "temp": temperature}, sort_keys=True)
        return f"llm_cache:{hashlib.sha256(content.encode()).hexdigest()}"

    def get(self, model: str, messages: list, temperature: float) -> dict | None:
        key = self._hash_key(model, messages, temperature)
        result = self.redis.get(key)
        if result:
            self.hits += 1
            return json.loads(result)
        self.misses += 1
        return None

    def set(self, model: str, messages: list, temperature: float, response: dict):
        # Only cache deterministic calls
        if temperature > 0:
            return
        key = self._hash_key(model, messages, temperature)
        self.redis.setex(key, self.ttl, json.dumps(response))

    @property
    def hit_rate(self) -> float:
        total = self.hits + self.misses
        return self.hits / total if total > 0 else 0
```

---

## Batch vs Real-Time Processing

| Aspect | Real-Time API | Batch API | Self-Hosted |
|--------|--------------|-----------|-------------|
| Latency | 1-30s | Hours | 0.1-10s |
| Cost per token | Full price | 50% discount | Infrastructure only |
| Best for | User-facing | Bulk processing | High volume |
| Min volume | Any | 1000+ requests | 10K+ requests/day |
| Setup complexity | None | Minimal | High |

### Batch Processing with OpenAI

```python
import json
from openai import OpenAI

client = OpenAI()

# Prepare batch file
requests = []
for i, text in enumerate(texts_to_process):
    requests.append({
        "custom_id": f"request-{i}",
        "method": "POST",
        "url": "/v1/chat/completions",
        "body": {
            "model": "gpt-4o-mini",
            "messages": [{"role": "user", "content": f"Classify: {text}"}],
            "max_tokens": 50,
        },
    })

# Write JSONL file
with open("batch_input.jsonl", "w") as f:
    for req in requests:
        f.write(json.dumps(req) + "\n")

# Upload and create batch
batch_file = client.files.create(file=open("batch_input.jsonl", "rb"), purpose="batch")
batch = client.batches.create(
    input_file_id=batch_file.id,
    endpoint="/v1/chat/completions",
    completion_window="24h",
)
print(f"Batch ID: {batch.id}")
# 50% cost savings vs real-time API
```

---

## Budget Planning Template

```yaml
# ai-budget.yaml
project: customer-churn-system
period: monthly

training:
  gpu_hours_estimated: 100
  instance_type: A100-40GB
  unit_cost: 3.50
  spot_discount: 0.6
  estimated_cost: 140.00  # 100 * 3.50 * 0.4

inference:
  requests_per_day: 50000
  avg_input_tokens: 800
  avg_output_tokens: 150
  model: gpt-4o-mini
  input_cost_per_1m: 0.15
  output_cost_per_1m: 0.60
  monthly_input_tokens: 1200000000  # 50K * 800 * 30
  monthly_output_tokens: 225000000  # 50K * 150 * 30
  estimated_cost: 315.00  # (1200 * 0.15) + (225 * 0.60)

caching:
  expected_hit_rate: 0.30
  inference_savings: 94.50  # 315 * 0.30

infrastructure:
  feature_store: 50.00
  monitoring: 25.00
  storage: 30.00

total_estimated: 466.50
with_caching: 372.00
monthly_budget: 500.00
buffer_pct: 7  # (500 - 466.50) / 500
```

---

## Cross-References

- Related: `3-build/experiment_tracking` -- Track compute costs per experiment
- Related: `5-ship/mlops_pipeline` -- Optimize pipeline infrastructure costs
- Related: `5.5-alpha/ai_model_monitoring` -- Monitor inference costs in production
- Related: `5-ship/model_registry_management` -- Choose cost-effective models for deployment
- Related: `toolkit/responsible_ai_framework` -- Balance cost optimization with fairness

---

## EXIT CHECKLIST

- [ ] Token cost tracking implemented for all LLM API calls
- [ ] GPU instances right-sized for workload (not over-provisioned)
- [ ] Spot/preemptible instances used for training and batch jobs
- [ ] Caching layer implemented (semantic or exact match)
- [ ] Quantization evaluated for inference models
- [ ] Batch API used for non-real-time workloads
- [ ] Multi-provider routing configured for cost optimization
- [ ] Monthly budget set with alerts at 80% and 100% thresholds
- [ ] Cost per task/request tracked and reported
- [ ] Model distillation evaluated for high-volume use cases

---

*Skill Version: 1.0 | Created: March 2026*
