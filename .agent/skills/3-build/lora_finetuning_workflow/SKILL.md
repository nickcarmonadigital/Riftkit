---
name: LoRA Fine-Tuning Workflow
description: End-to-end LoRA/QLoRA/PEFT fine-tuning workflows with dataset preparation, hyperparameter tuning, adapter merging, and evaluation
---

# LoRA Fine-Tuning Workflow Skill

**Purpose**: Guide practitioners through the complete lifecycle of parameter-efficient fine-tuning, from dataset curation through adapter merging and deployment-ready evaluation.

---

## TRIGGER COMMANDS

```text
"Fine-tune a model with LoRA"
"Set up QLoRA training for my dataset"
"Prepare a dataset for instruction tuning"
"Merge LoRA adapters into base model"
"Using lora_finetuning_workflow skill: [task]"
```

---

## Method Selection Matrix

| Method | Trainable Params | VRAM (7B) | VRAM (70B) | Quality vs Full FT | Best For |
|--------|-----------------|-----------|------------|--------------------|---------|
| Full Fine-Tune | 100% | 56 GB+ | 560 GB+ | Baseline | Unlimited budget |
| LoRA | 0.1-1% | 16 GB | 160 GB | 95-98% | Single-GPU training |
| QLoRA | 0.1-1% | 6-8 GB | 48-64 GB | 93-97% | Consumer GPUs |
| DoRA | 0.1-1% | 18 GB | 180 GB | 96-99% | When quality matters |
| IA3 | 0.01% | 5 GB | 40 GB | 85-92% | Extreme efficiency |
| Prefix Tuning | 0.1% | 8 GB | 80 GB | 88-94% | Task-specific prompts |

### Decision Flowchart

```
START: What GPU do you have?
  |
  +-- <= 8 GB VRAM (RTX 3060, etc.)
  |     --> QLoRA 4-bit + gradient checkpointing
  |     --> Max model: 7B params
  |
  +-- 16-24 GB VRAM (RTX 4090, A5000)
  |     --> LoRA 16-bit or QLoRA for larger models
  |     --> Max model: 13B (LoRA) or 34B (QLoRA)
  |
  +-- 40-80 GB VRAM (A100, H100)
  |     --> LoRA 16-bit or full fine-tune for small models
  |     --> Max model: 70B (LoRA) or 13B (full FT)
  |
  +-- Multi-GPU (2x+ A100/H100)
        --> Full fine-tune or LoRA with FSDP
        --> Any model size
```

---

## Dataset Preparation

### Format Standards

**Alpaca Format** (instruction tuning):

```json
{
  "instruction": "Summarize the following article about climate change.",
  "input": "Global temperatures have risen by 1.1 degrees Celsius...",
  "output": "The article discusses the 1.1C rise in global temperatures..."
}
```

**ShareGPT Format** (conversation tuning):

```json
{
  "conversations": [
    {"from": "human", "value": "What is photosynthesis?"},
    {"from": "gpt", "value": "Photosynthesis is the process by which plants..."},
    {"from": "human", "value": "How efficient is it?"},
    {"from": "gpt", "value": "Natural photosynthesis converts about 3-6%..."}
  ]
}
```

**Chat Template Format** (model-native):

```json
{
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Explain quantum computing."},
    {"role": "assistant", "content": "Quantum computing leverages..."}
  ]
}
```

### Dataset Quality Checklist

```python
import json
from collections import Counter

def audit_dataset(path: str) -> dict:
    """Audit a JSONL dataset for common quality issues."""
    issues = {
        "empty_outputs": 0,
        "duplicates": 0,
        "too_short": 0,      # < 10 tokens
        "too_long": 0,       # > max_seq_length
        "encoding_errors": 0,
    }
    seen_hashes = set()
    lengths = []

    with open(path) as f:
        for i, line in enumerate(f):
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                issues["encoding_errors"] += 1
                continue

            output = row.get("output", row.get("response", ""))
            if not output.strip():
                issues["empty_outputs"] += 1

            row_hash = hash(json.dumps(row, sort_keys=True))
            if row_hash in seen_hashes:
                issues["duplicates"] += 1
            seen_hashes.add(row_hash)

            token_est = len(output.split())
            lengths.append(token_est)
            if token_est < 10:
                issues["too_short"] += 1
            if token_est > 2048:
                issues["too_long"] += 1

    issues["total_samples"] = len(lengths)
    issues["avg_length"] = sum(lengths) / max(len(lengths), 1)
    issues["median_length"] = sorted(lengths)[len(lengths) // 2] if lengths else 0
    return issues
```

### Dataset Sizing Guidelines

| Task Type | Minimum Samples | Recommended | Diminishing Returns |
|-----------|----------------|-------------|---------------------|
| Classification | 100 | 500-1,000 | 5,000+ |
| Summarization | 500 | 2,000-5,000 | 20,000+ |
| Code Generation | 1,000 | 5,000-10,000 | 50,000+ |
| Chat/Instruct | 1,000 | 10,000-50,000 | 100,000+ |
| Domain Adaptation | 5,000 | 20,000-100,000 | 500,000+ |

---

## Training Configuration

### Hyperparameter Reference

```python
from peft import LoraConfig, get_peft_model, TaskType
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    BitsAndBytesConfig,
)
from trl import SFTTrainer
import torch

# --- QLoRA 4-bit quantization ---
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    bnb_4bit_use_double_quant=True,
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    quantization_config=bnb_config,
    device_map="auto",
    attn_implementation="flash_attention_2",
    torch_dtype=torch.bfloat16,
)

tokenizer = AutoTokenizer.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    padding_side="right",
)
tokenizer.pad_token = tokenizer.eos_token

# --- LoRA configuration ---
lora_config = LoraConfig(
    r=64,                          # Rank: 8-256, higher = more capacity
    lora_alpha=128,                # Alpha: typically 2x rank
    target_modules=[               # Modules to apply LoRA to
        "q_proj", "k_proj", "v_proj", "o_proj",
        "gate_proj", "up_proj", "down_proj",
    ],
    lora_dropout=0.05,
    bias="none",
    task_type=TaskType.CAUSAL_LM,
    use_rslora=True,               # Rank-stabilized LoRA
)

model = get_peft_model(model, lora_config)
model.print_trainable_parameters()
# Typical output: trainable params: 83,886,080 || all params: 8,113,954,816 || 1.03%
```

### Rank Selection Guide

| Rank (r) | Trainable Params (7B) | Use Case | Quality |
|----------|----------------------|----------|---------|
| 8 | ~3M | Simple classification, style transfer | Good |
| 16 | ~7M | General instruction tuning | Better |
| 32 | ~13M | Complex reasoning tasks | Good+ |
| 64 | ~27M | Multi-task, code generation | Very Good |
| 128 | ~54M | Near full fine-tune quality | Excellent |
| 256 | ~107M | Maximum adaptation | Near-Full FT |

> **Rule of thumb**: Start with r=16 for most tasks. If training loss plateaus early, increase rank. If overfitting, decrease rank or add dropout.

### Training Arguments

```python
training_args = TrainingArguments(
    output_dir="./outputs/lora-llama3-8b",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,     # Effective batch = 4 * 4 = 16
    learning_rate=2e-4,                # QLoRA sweet spot: 1e-4 to 3e-4
    lr_scheduler_type="cosine",
    warmup_ratio=0.03,
    weight_decay=0.01,
    bf16=True,
    gradient_checkpointing=True,
    gradient_checkpointing_kwargs={"use_reentrant": False},
    logging_steps=10,
    save_strategy="steps",
    save_steps=100,
    eval_strategy="steps",
    eval_steps=100,
    save_total_limit=3,
    load_best_model_at_end=True,
    metric_for_best_model="eval_loss",
    report_to="wandb",
    optim="paged_adamw_8bit",          # Memory-efficient optimizer
    max_grad_norm=0.3,
    group_by_length=True,              # Group similar lengths for efficiency
    dataloader_num_workers=4,
    seed=42,
)

trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
    tokenizer=tokenizer,
    max_seq_length=2048,
    packing=True,                      # Pack short sequences together
    dataset_text_field="text",
)

trainer.train()
```

---

## Framework-Specific Workflows

### Unsloth (2-4x Faster Training)

```python
from unsloth import FastLanguageModel

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Meta-Llama-3.1-8B-Instruct-bnb-4bit",
    max_seq_length=2048,
    load_in_4bit=True,
    dtype=None,  # Auto-detect
)

model = FastLanguageModel.get_peft_model(
    model,
    r=64,
    lora_alpha=128,
    target_modules=[
        "q_proj", "k_proj", "v_proj", "o_proj",
        "gate_proj", "up_proj", "down_proj",
    ],
    lora_dropout=0,        # Unsloth optimized: 0 dropout
    bias="none",
    use_gradient_checkpointing="unsloth",  # 30% less VRAM
    use_rslora=True,
)
```

### Axolotl (YAML-Driven Training)

```yaml
# axolotl_config.yml
base_model: meta-llama/Llama-3.1-8B-Instruct
model_type: LlamaForCausalLM

load_in_4bit: true
adapter: qlora
lora_r: 64
lora_alpha: 128
lora_dropout: 0.05
lora_target_modules:
  - q_proj
  - k_proj
  - v_proj
  - o_proj
  - gate_proj
  - up_proj
  - down_proj

datasets:
  - path: my_dataset.jsonl
    type: alpaca
    split: train

val_set_size: 0.05
sequence_len: 2048
sample_packing: true

gradient_accumulation_steps: 4
micro_batch_size: 4
num_epochs: 3
learning_rate: 2e-4
lr_scheduler: cosine
warmup_ratio: 0.03
optimizer: paged_adamw_8bit

bf16: auto
flash_attention: true
gradient_checkpointing: true

output_dir: ./outputs/axolotl-run
logging_steps: 10
save_strategy: steps
save_steps: 100
eval_steps: 100

wandb_project: my-finetune
wandb_run_id: axolotl-llama3-8b
```

```bash
# Launch training with Axolotl
accelerate launch -m axolotl.cli.train axolotl_config.yml

# Or with multi-GPU
accelerate launch --multi_gpu --num_processes 4 \
  -m axolotl.cli.train axolotl_config.yml
```

---

## Evaluation and Validation

### Training Diagnostics

```python
import matplotlib.pyplot as plt

def plot_training_curves(trainer):
    """Plot loss curves from trainer history."""
    history = trainer.state.log_history

    train_loss = [(h["step"], h["loss"]) for h in history if "loss" in h]
    eval_loss = [(h["step"], h["eval_loss"]) for h in history if "eval_loss" in h]

    fig, ax = plt.subplots(1, 1, figsize=(10, 6))
    ax.plot(*zip(*train_loss), label="Train Loss", alpha=0.7)
    ax.plot(*zip(*eval_loss), label="Eval Loss", marker="o")
    ax.set_xlabel("Step")
    ax.set_ylabel("Loss")
    ax.legend()
    ax.set_title("Training Curves")
    fig.savefig("training_curves.png", dpi=150)
```

### Common Training Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Loss spikes repeatedly | Learning rate too high | Reduce LR to 5e-5, increase warmup |
| Loss plateaus at high value | Rank too low | Increase r to 64+ |
| Eval loss increases after epoch 1 | Overfitting | Reduce epochs, add dropout, use more data |
| NaN/Inf loss | Dtype mismatch or bad data | Check bf16 support, audit dataset |
| Very slow convergence | Learning rate too low | Increase LR, check batch size |
| Model repeats itself | Bad training data or too many epochs | Deduplicate data, reduce epochs |

### Benchmark Evaluation

```python
import lm_eval

results = lm_eval.simple_evaluate(
    model="hf",
    model_args="pretrained=./merged-model,dtype=bfloat16",
    tasks=["mmlu", "hellaswag", "arc_challenge", "truthfulqa_mc2"],
    batch_size=8,
    num_fewshot=5,
)

for task, metrics in results["results"].items():
    print(f"{task}: {metrics.get('acc_norm,none', metrics.get('acc,none', 'N/A')):.4f}")
```

---

## Adapter Merging and Export

### Merge LoRA into Base Model

```python
from peft import PeftModel
from transformers import AutoModelForCausalLM, AutoTokenizer

# Load base model at full precision
base_model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    torch_dtype=torch.bfloat16,
    device_map="cpu",  # Merge on CPU to avoid OOM
)

# Load adapter
model = PeftModel.from_pretrained(base_model, "./outputs/lora-llama3-8b/checkpoint-best")

# Merge and unload
merged_model = model.merge_and_unload()

# Save merged model
merged_model.save_pretrained("./merged-model")
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")
tokenizer.save_pretrained("./merged-model")
```

### Export to GGUF (for llama.cpp / Ollama)

```bash
# Clone llama.cpp if needed
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp

# Convert to GGUF
python convert_hf_to_gguf.py ../merged-model --outtype bf16 --outfile model-bf16.gguf

# Quantize to Q4_K_M (good quality/size balance)
./build/bin/llama-quantize model-bf16.gguf model-Q4_K_M.gguf Q4_K_M

# Quantize to Q5_K_M (higher quality)
./build/bin/llama-quantize model-bf16.gguf model-Q5_K_M.gguf Q5_K_M
```

### GGUF Quantization Comparison

| Quant Type | Size (7B) | Quality | Speed | Best For |
|------------|----------|---------|-------|----------|
| Q2_K | 2.7 GB | Poor | Fastest | Testing only |
| Q3_K_M | 3.3 GB | Fair | Fast | Tight memory constraints |
| Q4_K_M | 4.1 GB | Good | Fast | General use |
| Q5_K_M | 4.8 GB | Very Good | Medium | Quality-focused |
| Q6_K | 5.5 GB | Excellent | Slower | Near-lossless |
| Q8_0 | 7.2 GB | Near-Perfect | Slowest | Evaluation |
| BF16 | 14.4 GB | Lossless | GPU only | Serving with vLLM |

---

## Multi-Adapter Strategies

### Adapter Stacking

```python
from peft import PeftModel

# Load base with first adapter
model = PeftModel.from_pretrained(base_model, "./adapter-domain")
model.load_adapter("./adapter-style", adapter_name="style")

# Switch between adapters
model.set_adapter("default")  # Domain adapter
model.set_adapter("style")    # Style adapter

# Combine adapters with weighted merge
model.add_weighted_adapter(
    adapters=["default", "style"],
    weights=[0.7, 0.3],
    adapter_name="combined",
)
model.set_adapter("combined")
```

### Adapter Composition Table

| Strategy | Use Case | Complexity |
|----------|----------|------------|
| Single adapter | One task | Low |
| Sequential merge | Domain then style | Medium |
| Weighted merge | Blend capabilities | Medium |
| Adapter switching | Multi-task serving | High |
| MoLoRA (mixture) | Dynamic routing | Very High |

---

## Production Checklist

### Pre-Training

- [ ] Dataset audited: no PII, duplicates removed, quality validated
- [ ] Base model license allows fine-tuning and commercial use
- [ ] Training compute estimated and budget approved
- [ ] Evaluation benchmarks selected and baseline measured
- [ ] Experiment tracking configured (W&B, MLflow, or TensorBoard)

### During Training

- [ ] Loss curves monitored for divergence or overfitting
- [ ] Checkpoints saved at regular intervals
- [ ] Evaluation metrics computed at each checkpoint
- [ ] GPU utilization above 80% (check with nvidia-smi)
- [ ] Gradient norms within expected range (0.1-1.0)

### Post-Training

- [ ] Best checkpoint selected by eval metric
- [ ] Adapter merged into base model successfully
- [ ] Merged model produces coherent outputs on test prompts
- [ ] Benchmark scores compared against baseline
- [ ] Model exported to target format (HF, GGUF, ONNX)
- [ ] Model card written with training details and limitations

---

## Cross-References

- `3-build/distributed_training` -- Multi-GPU and multi-node training setups
- `5-ship/model_serving_deployment` -- Deploying fine-tuned models
- `4-secure/rlhf_alignment` -- Post-training alignment with RLHF/DPO
- `2-design/embedding_pipeline_design` -- Fine-tuning embedding models

---

## EXIT CHECKLIST

- [ ] Dataset prepared in correct format (Alpaca, ShareGPT, or chat template)
- [ ] Dataset quality audited (deduped, validated, sized appropriately)
- [ ] LoRA/QLoRA method selected based on GPU constraints
- [ ] Hyperparameters configured (rank, alpha, learning rate, batch size)
- [ ] Training completed with monitored loss curves
- [ ] Best checkpoint evaluated against baselines
- [ ] Adapter merged and exported to target format
- [ ] Model card and training documentation complete

---

*Skill Version: 1.0 | Created: March 2026*
