---
name: Distributed Training
description: Distributed training with DDP, FSDP, DeepSpeed covering multi-GPU, multi-node, parallelism strategies, and fault tolerance
---

# Distributed Training Skill

**Purpose**: Guide implementation of distributed training across multiple GPUs and nodes using PyTorch DDP, FSDP, DeepSpeed, and related technologies for training models that exceed single-GPU capacity.

---

## TRIGGER COMMANDS

```text
"Set up multi-GPU training"
"Configure DeepSpeed for my model"
"Train across multiple nodes"
"Use FSDP for large model training"
"Using distributed_training skill: [task]"
```

---

## Parallelism Strategy Selection

### Strategy Comparison

| Strategy | What It Splits | GPU Memory | Communication | Complexity | Best For |
|----------|---------------|------------|---------------|------------|----------|
| Data Parallel (DDP) | Data batches | Model on each GPU | Gradient all-reduce | Low | Model fits in 1 GPU |
| FSDP | Model params + data | Sharded across GPUs | Param all-gather | Medium | Large models |
| DeepSpeed ZeRO-1 | Optimizer states | Reduced per GPU | Optimizer scatter | Low | First step |
| DeepSpeed ZeRO-2 | + Gradients | More reduced | Gradient scatter | Low-Medium | Mid-size models |
| DeepSpeed ZeRO-3 | + Parameters | Minimal per GPU | Param all-gather | Medium | Very large models |
| Tensor Parallel | Layer weights | Split per layer | Activation transfer | High | Huge layers |
| Pipeline Parallel | Model layers | Stages per GPU | Activation transfer | High | Deep models |
| Expert Parallel | MoE experts | Experts per GPU | Token routing | Very High | MoE models |

### Decision Matrix

```
START: How large is your model?
  |
  +-- Fits on 1 GPU (< GPU memory * 0.7)
  |     --> DDP (simplest, fastest)
  |
  +-- Fits on 1 GPU but OOM during training
  |     +-- Try gradient checkpointing first
  |     +-- Then try DeepSpeed ZeRO-1 (optimizer offload)
  |     +-- Then try mixed precision (BF16)
  |
  +-- Does NOT fit on 1 GPU
  |     +-- 2-8 GPUs available
  |     |     --> FSDP or DeepSpeed ZeRO-3
  |     |
  |     +-- 8+ GPUs, single node
  |     |     --> FSDP + tensor parallel
  |     |
  |     +-- Multi-node cluster
  |           --> DeepSpeed ZeRO-3 + pipeline parallel
  |
  +-- 100B+ parameter model
        --> Megatron-LM (tensor + pipeline + data parallel)
```

### Memory Estimation

```
Model Memory (BF16):
  Parameters * 2 bytes = Model size
  7B params * 2 = 14 GB

Training Memory (per GPU, full fine-tune):
  Model weights:     params * 2 bytes    (BF16)
  Gradients:         params * 2 bytes    (BF16)
  Optimizer (AdamW): params * 8 bytes    (FP32 states)
  Activations:       varies (use gradient checkpointing)

  Total (no sharding): params * 12 bytes + activations
  7B model: ~84 GB + activations = needs 2x A100-80GB minimum

With ZeRO-3 (N GPUs):
  Per GPU: (params * 12 / N) + activations
  7B on 4 GPUs: ~21 GB + activations per GPU
```

---

## PyTorch DDP (Data Distributed Parallel)

### Basic DDP Training Script

```python
import os
import torch
import torch.nn as nn
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import DataLoader, DistributedSampler

def setup(rank, world_size):
    """Initialize distributed process group."""
    os.environ["MASTER_ADDR"] = os.environ.get("MASTER_ADDR", "localhost")
    os.environ["MASTER_PORT"] = os.environ.get("MASTER_PORT", "29500")
    dist.init_process_group("nccl", rank=rank, world_size=world_size)
    torch.cuda.set_device(rank)

def cleanup():
    dist.destroy_process_group()

def train(rank, world_size, args):
    setup(rank, world_size)

    # Create model and wrap with DDP
    model = MyModel().to(rank)
    model = DDP(model, device_ids=[rank])

    # Distributed sampler ensures each GPU gets different data
    train_dataset = MyDataset(args.data_path)
    sampler = DistributedSampler(
        train_dataset,
        num_replicas=world_size,
        rank=rank,
        shuffle=True,
    )
    dataloader = DataLoader(
        train_dataset,
        batch_size=args.batch_size,
        sampler=sampler,
        num_workers=4,
        pin_memory=True,
    )

    optimizer = torch.optim.AdamW(model.parameters(), lr=args.lr)
    scaler = torch.amp.GradScaler("cuda")

    for epoch in range(args.epochs):
        sampler.set_epoch(epoch)  # Ensure different shuffling each epoch
        model.train()

        for batch in dataloader:
            inputs = batch["input"].to(rank)
            labels = batch["label"].to(rank)

            optimizer.zero_grad()

            with torch.amp.autocast("cuda", dtype=torch.bfloat16):
                outputs = model(inputs)
                loss = nn.functional.cross_entropy(outputs, labels)

            scaler.scale(loss).backward()
            scaler.step(optimizer)
            scaler.update()

        # Save checkpoint only on rank 0
        if rank == 0:
            torch.save({
                "epoch": epoch,
                "model_state_dict": model.module.state_dict(),
                "optimizer_state_dict": optimizer.state_dict(),
            }, f"checkpoint_epoch_{epoch}.pt")

    cleanup()

if __name__ == "__main__":
    world_size = torch.cuda.device_count()
    torch.multiprocessing.spawn(train, args=(world_size, args), nprocs=world_size)
```

### Launch with torchrun

```bash
# Single node, 4 GPUs
torchrun --nproc_per_node=4 train.py

# Multi-node (run on each node)
# Node 0 (master):
torchrun --nproc_per_node=4 --nnodes=2 --node_rank=0 \
  --master_addr=192.168.1.1 --master_port=29500 train.py

# Node 1:
torchrun --nproc_per_node=4 --nnodes=2 --node_rank=1 \
  --master_addr=192.168.1.1 --master_port=29500 train.py
```

---

## FSDP (Fully Sharded Data Parallel)

### FSDP Configuration

```python
import torch
from torch.distributed.fsdp import (
    FullyShardedDataParallel as FSDP,
    MixedPrecision,
    ShardingStrategy,
    BackwardPrefetch,
    CPUOffload,
)
from torch.distributed.fsdp.wrap import (
    transformer_auto_wrap_policy,
    size_based_auto_wrap_policy,
)
from transformers import LlamaForCausalLM, LlamaDecoderLayer

def get_fsdp_config():
    """Configure FSDP for LLM training."""

    # Mixed precision policy
    mixed_precision = MixedPrecision(
        param_dtype=torch.bfloat16,
        reduce_dtype=torch.bfloat16,
        buffer_dtype=torch.bfloat16,
    )

    # Auto-wrap policy: wrap each transformer layer separately
    auto_wrap_policy = transformer_auto_wrap_policy(
        transformer_layer_cls={LlamaDecoderLayer},
    )

    return {
        "auto_wrap_policy": auto_wrap_policy,
        "mixed_precision": mixed_precision,
        "sharding_strategy": ShardingStrategy.FULL_SHARD,
        "backward_prefetch": BackwardPrefetch.BACKWARD_PRE,
        "cpu_offload": CPUOffload(offload_params=False),
        "device_id": torch.cuda.current_device(),
        "use_orig_params": True,
        "limit_all_gathers": True,
    }

# Wrap model with FSDP
model = LlamaForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B",
    torch_dtype=torch.bfloat16,
)
model = FSDP(model, **get_fsdp_config())
```

### FSDP Sharding Strategies

| Strategy | Memory Savings | Communication | Use When |
|----------|---------------|---------------|----------|
| FULL_SHARD | Maximum | High (all-gather + reduce-scatter) | Model doesn't fit in 1 GPU |
| SHARD_GRAD_OP | Moderate | Medium (reduce-scatter only) | Model fits but tight on memory |
| NO_SHARD | None (= DDP) | Low (all-reduce only) | Model fits comfortably |
| HYBRID_SHARD | Good | Medium (shard within node) | Multi-node with fast intra-node |

### FSDP Checkpointing

```python
from torch.distributed.fsdp import StateDictType, FullStateDictConfig

def save_fsdp_checkpoint(model, optimizer, path, rank):
    """Save consolidated FSDP checkpoint."""
    full_state_config = FullStateDictConfig(offload_to_cpu=True, rank0_only=True)

    with FSDP.state_dict_type(model, StateDictType.FULL_STATE_DICT, full_state_config):
        state_dict = model.state_dict()
        optim_state = FSDP.optim_state_dict(model, optimizer)

    if rank == 0:
        torch.save({
            "model": state_dict,
            "optimizer": optim_state,
        }, path)

    dist.barrier()
```

---

## DeepSpeed

### DeepSpeed ZeRO Configurations

**ZeRO Stage 1** (optimizer partitioning):

```json
{
  "bf16": {"enabled": true},
  "zero_optimization": {
    "stage": 1,
    "overlap_comm": true,
    "reduce_bucket_size": 5e8
  },
  "gradient_accumulation_steps": 4,
  "train_micro_batch_size_per_gpu": 4,
  "gradient_clipping": 1.0,
  "optimizer": {
    "type": "AdamW",
    "params": {
      "lr": 2e-4,
      "weight_decay": 0.01,
      "betas": [0.9, 0.999]
    }
  },
  "scheduler": {
    "type": "WarmupCosineDecay",
    "params": {
      "warmup_num_steps": 100,
      "total_num_steps": 10000
    }
  }
}
```

**ZeRO Stage 3** (full sharding + offload):

```json
{
  "bf16": {"enabled": true},
  "zero_optimization": {
    "stage": 3,
    "overlap_comm": true,
    "contiguous_gradients": true,
    "reduce_bucket_size": 5e8,
    "stage3_prefetch_bucket_size": 5e8,
    "stage3_param_persistence_threshold": 1e6,
    "sub_group_size": 1e12,
    "stage3_gather_16bit_weights_on_model_save": true,
    "offload_optimizer": {
      "device": "cpu",
      "pin_memory": true
    },
    "offload_param": {
      "device": "cpu",
      "pin_memory": true
    }
  },
  "gradient_accumulation_steps": 8,
  "train_micro_batch_size_per_gpu": 2,
  "gradient_clipping": 1.0,
  "optimizer": {
    "type": "AdamW",
    "params": {
      "lr": 2e-4,
      "weight_decay": 0.01
    }
  }
}
```

### DeepSpeed with HuggingFace Trainer

```python
from transformers import Trainer, TrainingArguments

training_args = TrainingArguments(
    output_dir="./outputs",
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    num_train_epochs=3,
    learning_rate=2e-4,
    bf16=True,
    deepspeed="ds_config_zero3.json",
    gradient_checkpointing=True,
    save_strategy="steps",
    save_steps=500,
    logging_steps=10,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
)

trainer.train()
```

```bash
# Launch DeepSpeed training
deepspeed --num_gpus=4 train.py --deepspeed ds_config_zero3.json

# Multi-node with hostfile
# hostfile:
# node1 slots=4
# node2 slots=4
deepspeed --hostfile=hostfile train.py --deepspeed ds_config_zero3.json
```

### ZeRO Stage Comparison

| Feature | ZeRO-1 | ZeRO-2 | ZeRO-3 |
|---------|--------|--------|--------|
| Optimizer state sharding | Yes | Yes | Yes |
| Gradient sharding | No | Yes | Yes |
| Parameter sharding | No | No | Yes |
| Memory per GPU (7B, 4 GPUs) | ~42 GB | ~28 GB | ~21 GB |
| Communication overhead | Low | Medium | High |
| CPU offload support | No | No | Yes |
| NVMe offload support | No | No | Yes |

---

## Gradient Accumulation and Mixed Precision

### Effective Batch Size Calculation

```
Effective Batch Size = per_device_batch * gradient_accumulation * num_gpus

Example:
  per_device_batch = 4
  gradient_accumulation = 8
  num_gpus = 4
  Effective = 4 * 8 * 4 = 128
```

### Mixed Precision Training

```python
# PyTorch native AMP
scaler = torch.amp.GradScaler("cuda")

for batch in dataloader:
    optimizer.zero_grad()

    with torch.amp.autocast("cuda", dtype=torch.bfloat16):
        outputs = model(batch["input"])
        loss = criterion(outputs, batch["label"])

    scaler.scale(loss).backward()

    # Gradient clipping with scaler
    scaler.unscale_(optimizer)
    torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)

    scaler.step(optimizer)
    scaler.update()
```

### Precision Comparison

| Precision | Memory | Speed | Stability | GPU Support |
|-----------|--------|-------|-----------|-------------|
| FP32 | Baseline | 1x | Best | All |
| TF32 | Same | 1.5x | Very Good | Ampere+ |
| BF16 | 50% | 2x | Good | Ampere+ |
| FP16 | 50% | 2x | Needs scaler | All modern |
| FP8 | 25% | 3x | Requires tuning | Hopper+ |

> **Best practice**: Use BF16 on Ampere+ GPUs (A100, H100, RTX 30xx+). Use FP16 with GradScaler on older GPUs. BF16 avoids most overflow/underflow issues that FP16 encounters.

---

## Fault Tolerance

### Elastic Training with torchrun

```bash
# Elastic launch: min 2, max 4 GPUs, auto-restart on failure
torchrun \
  --nproc_per_node=4 \
  --nnodes=1:4 \
  --rdzv_backend=c10d \
  --rdzv_endpoint=master:29500 \
  --max_restarts=3 \
  train.py
```

### Checkpoint Recovery

```python
def load_checkpoint(model, optimizer, checkpoint_path):
    """Load checkpoint with graceful handling."""
    if not os.path.exists(checkpoint_path):
        return 0  # Start from epoch 0

    checkpoint = torch.load(checkpoint_path, map_location="cpu", weights_only=True)
    model.load_state_dict(checkpoint["model"])
    optimizer.load_state_dict(checkpoint["optimizer"])

    return checkpoint.get("epoch", 0) + 1

def save_checkpoint(model, optimizer, epoch, path, rank=0):
    """Save checkpoint on rank 0 only."""
    if rank != 0:
        return

    torch.save({
        "epoch": epoch,
        "model": model.module.state_dict() if hasattr(model, "module") else model.state_dict(),
        "optimizer": optimizer.state_dict(),
    }, path)
```

---

## Multi-Node Networking

### NCCL Environment Variables

```bash
# Essential for multi-node
export NCCL_DEBUG=INFO
export NCCL_IB_DISABLE=0          # Enable InfiniBand (if available)
export NCCL_NET_GDR_LEVEL=2       # GPU Direct RDMA
export NCCL_SOCKET_IFNAME=eth0    # Network interface

# Performance tuning
export NCCL_ALGO=Ring              # Ring allreduce (default)
export NCCL_NSOCKS_PERTHREAD=4
export NCCL_SOCKET_NTHREADS=2
```

### Network Bandwidth Requirements

| Parallelism | Bandwidth Needed | Latency Sensitivity |
|------------|-----------------|---------------------|
| DDP (data) | Moderate (gradient sync) | Low |
| FSDP | High (param all-gather) | Medium |
| Tensor Parallel | Very High (every layer) | High |
| Pipeline Parallel | Low (activation transfer) | Medium |

> **Rule of thumb**: DDP works well over 10 GbE. FSDP and tensor parallel need 100 GbE or InfiniBand for efficiency. Pipeline parallel is the most network-friendly for multi-node.

---

## Accelerate Configuration

```yaml
# accelerate_config.yaml
compute_environment: LOCAL_MACHINE
distributed_type: FSDP
fsdp_config:
  fsdp_auto_wrap_policy: TRANSFORMER_BASED_WRAP
  fsdp_backward_prefetch: BACKWARD_PRE
  fsdp_sharding_strategy: FULL_SHARD
  fsdp_state_dict_type: SHARDED_STATE_DICT
  fsdp_transformer_layer_cls_to_wrap: LlamaDecoderLayer
machine_rank: 0
main_training_function: main
mixed_precision: bf16
num_machines: 1
num_processes: 4
```

```bash
accelerate launch --config_file accelerate_config.yaml train.py
```

---

## Performance Monitoring

### Key Metrics to Track

| Metric | Good Value | Issue If |
|--------|-----------|---------|
| GPU utilization | > 80% | < 60% = data loading bottleneck |
| GPU memory | 70-90% | > 95% = OOM risk |
| Samples/sec/GPU | Stable | Dropping = communication bottleneck |
| Gradient norm | 0.1-10 | > 100 = instability |
| Loss scale (FP16) | > 1 | 1 = underflow issues |

```bash
# Monitor GPU utilization
watch -n 1 nvidia-smi

# Detailed profiling
nsys profile -o trace torchrun --nproc_per_node=4 train.py
```

---

## EXIT CHECKLIST

- [ ] Parallelism strategy selected based on model size and hardware
- [ ] Memory estimated and GPU allocation confirmed
- [ ] Distributed training script tested on single node first
- [ ] Mixed precision enabled (BF16 preferred on Ampere+)
- [ ] Gradient accumulation configured for target effective batch size
- [ ] Checkpointing saves on rank 0, loads across all ranks
- [ ] Fault tolerance configured (elastic launch, checkpoint recovery)
- [ ] Communication overhead acceptable (monitor samples/sec)
- [ ] Multi-node networking validated (if applicable)

---

## Cross-References

- `3-build/lora_finetuning_workflow` -- Memory-efficient alternative to full distributed training
- `5-ship/model_serving_deployment` -- Deploying distributed-trained models
- `3-build/computer_vision_pipeline` -- Distributed training for vision models

---

*Skill Version: 1.0 | Created: March 2026*
