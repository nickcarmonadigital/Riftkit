---
name: RLHF Alignment
description: Model alignment with RLHF, DPO, ORPO, KTO including reward modeling, preference data collection, PPO training, and evaluation
---

# RLHF Alignment Skill

**Purpose**: Guide implementation of post-training alignment methods to make language models more helpful, harmless, and honest through reinforcement learning from human feedback and direct preference optimization.

---

## TRIGGER COMMANDS

```text
"Align a model with human preferences"
"Implement DPO training"
"Set up RLHF pipeline with reward model"
"Collect preference data for alignment"
"Using rlhf_alignment skill: [task]"
```

---

## Alignment Method Selection

### Method Comparison

| Method | Needs Reward Model | Stability | Quality | Complexity | Memory |
|--------|-------------------|-----------|---------|------------|--------|
| RLHF (PPO) | Yes | Low | Highest | Very High | Very High |
| DPO | No | High | High | Low | Medium |
| IPO | No | Very High | Good | Low | Medium |
| KTO | No | High | Good | Low | Medium |
| ORPO | No | High | Good | Low | Low |
| SimPO | No | High | Good | Low | Medium |
| SPIN | No | Medium | Good | Medium | Medium |

### Decision Tree

```
START: What alignment method should I use?
  |
  +-- First time aligning a model?
  |     --> DPO (simplest, most documented, good results)
  |
  +-- Have only positive/negative labels (no pairs)?
  |     --> KTO (works without paired preferences)
  |
  +-- Want to combine SFT + alignment in one step?
  |     --> ORPO (no reference model needed, saves memory)
  |
  +-- Need maximum quality, have compute budget?
  |     --> RLHF with PPO (gold standard, but complex)
  |
  +-- Training is unstable with DPO?
  |     --> IPO (adds regularization, more stable)
  |
  +-- Want simplicity with length control?
        --> SimPO (reference-free, length-normalized)
```

### Quality vs Effort Trade-off

```
Quality ^
        |          * RLHF/PPO
        |      * DPO    * SimPO
        |   * ORPO  * KTO
        |  * IPO
        | * SFT only
        +------------------------->
                    Effort/Complexity
```

---

## Preference Data Collection

### Data Format

**Paired Preferences** (for DPO, IPO, SimPO):

```json
{
  "prompt": "Explain quantum entanglement in simple terms.",
  "chosen": "Quantum entanglement is when two particles become connected so that measuring one instantly reveals information about the other, no matter how far apart they are. Think of it like having two magic coins that always land on opposite sides when flipped simultaneously.",
  "rejected": "Quantum entanglement is a quantum mechanical phenomenon in which the quantum states of two or more objects have to be described with reference to each other, even though the individual objects may be spatially separated. This leads to correlations between observable physical properties of the systems."
}
```

**Binary Feedback** (for KTO):

```json
{
  "prompt": "Write a haiku about programming.",
  "completion": "Bugs hide in the code\nDebugging through the long night\nTests finally pass",
  "label": true
}
```

**Ranked Preferences** (for reward modeling):

```json
{
  "prompt": "How do I sort a list in Python?",
  "responses": [
    {"text": "Use sorted() or list.sort(). sorted() returns new list...", "rank": 1},
    {"text": "You can sort using the sort method.", "rank": 2},
    {"text": "Just use a for loop to compare elements.", "rank": 3}
  ]
}
```

### Data Collection Strategies

| Strategy | Cost | Quality | Scale |
|----------|------|---------|-------|
| Expert human annotation | High | Highest | Low (100-1K/day) |
| Crowdsource (Scale AI, Surge) | Medium | Good | Medium (1K-10K/day) |
| LLM-as-Judge (GPT-4 ranking) | Low | Good | High (100K+/day) |
| Self-play / Constitutional | Very Low | Medium | Very High |
| Implicit feedback (click, time) | Very Low | Low-Medium | Very High |

### Quality Guidelines for Annotators

| Criterion | Chosen Should | Rejected Should |
|-----------|--------------|-----------------|
| Helpfulness | Directly answer the question | Be vague or miss the point |
| Accuracy | Be factually correct | Contain subtle errors |
| Safety | Refuse harmful requests appropriately | Comply with harmful requests |
| Clarity | Be well-structured and clear | Be verbose or confusing |
| Specificity | Include relevant details | Be generic |

### LLM-as-Judge for Data Generation

```python
from openai import OpenAI

client = OpenAI()

JUDGE_PROMPT = """You are evaluating two responses to a user prompt.
Determine which response is better based on:
1. Helpfulness and accuracy
2. Clarity and structure
3. Safety and appropriateness

Prompt: {prompt}

Response A: {response_a}

Response B: {response_b}

Which response is better? Answer with ONLY "A" or "B".
If they are roughly equal, pick the one that is more concise."""

def judge_pair(prompt: str, response_a: str, response_b: str) -> str:
    """Use LLM to judge which response is better."""
    result = client.chat.completions.create(
        model="gpt-4o",
        messages=[{
            "role": "user",
            "content": JUDGE_PROMPT.format(
                prompt=prompt,
                response_a=response_a,
                response_b=response_b,
            ),
        }],
        temperature=0,
        max_tokens=1,
    )
    return result.choices[0].message.content.strip()

def generate_preference_data(prompts: list[str], model_a, model_b) -> list[dict]:
    """Generate preference pairs using two models + LLM judge."""
    pairs = []
    for prompt in prompts:
        resp_a = model_a.generate(prompt)
        resp_b = model_b.generate(prompt)
        winner = judge_pair(prompt, resp_a, resp_b)

        pairs.append({
            "prompt": prompt,
            "chosen": resp_a if winner == "A" else resp_b,
            "rejected": resp_b if winner == "A" else resp_a,
        })
    return pairs
```

---

## DPO (Direct Preference Optimization)

### DPO Training with TRL

```python
from trl import DPOTrainer, DPOConfig
from transformers import AutoModelForCausalLM, AutoTokenizer
from datasets import load_dataset
from peft import LoraConfig

# Load model and tokenizer
model_name = "meta-llama/Llama-3.1-8B-Instruct"
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.bfloat16,
    device_map="auto",
    attn_implementation="flash_attention_2",
)
tokenizer = AutoTokenizer.from_pretrained(model_name)
tokenizer.pad_token = tokenizer.eos_token

# Reference model (frozen copy for KL divergence)
ref_model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.bfloat16,
    device_map="auto",
)

# LoRA config for memory efficiency
peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM",
)

# Load preference dataset
dataset = load_dataset("json", data_files="preference_data.jsonl")

# DPO training config
training_args = DPOConfig(
    output_dir="./dpo-output",
    num_train_epochs=1,
    per_device_train_batch_size=2,
    gradient_accumulation_steps=8,
    learning_rate=5e-7,         # DPO needs lower LR than SFT
    lr_scheduler_type="cosine",
    warmup_ratio=0.1,
    bf16=True,
    gradient_checkpointing=True,
    logging_steps=10,
    save_strategy="steps",
    save_steps=100,
    eval_strategy="steps",
    eval_steps=100,
    beta=0.1,                   # KL penalty coefficient
    max_length=1024,
    max_prompt_length=512,
    loss_type="sigmoid",        # "sigmoid" (standard) or "hinge" or "ipo"
    report_to="wandb",
)

# Train
trainer = DPOTrainer(
    model=model,
    ref_model=ref_model,
    args=training_args,
    train_dataset=dataset["train"],
    eval_dataset=dataset.get("validation"),
    tokenizer=tokenizer,
    peft_config=peft_config,
)

trainer.train()
```

### DPO Hyperparameter Guide

| Parameter | Range | Effect | Default |
|-----------|-------|--------|---------|
| `beta` | 0.01 - 0.5 | KL divergence weight. Lower = more divergence from ref | 0.1 |
| `learning_rate` | 1e-7 - 5e-6 | Much lower than SFT to prevent forgetting | 5e-7 |
| `max_length` | 512 - 2048 | Total sequence length (prompt + response) | 1024 |
| `label_smoothing` | 0.0 - 0.3 | Soften preference labels | 0.0 |

> **Critical**: If beta is too high, the model barely changes from the reference. If too low, it overfits to preference data and loses general capability. Start with 0.1 and adjust based on reward margin.

### DPO Loss Variants

| Loss Type | Key Property | When to Use |
|-----------|-------------|-------------|
| `sigmoid` | Standard DPO | Default, start here |
| `hinge` | Margin-based | When you want hard separation |
| `ipo` | Regularized | When sigmoid DPO is unstable |
| `kto_pair` | KTO-style on pairs | Alternative formulation |

---

## RLHF with PPO

### Reward Model Training

```python
from trl import RewardTrainer, RewardConfig
from transformers import AutoModelForSequenceClassification

# Load reward model (classifier head)
reward_model = AutoModelForSequenceClassification.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    num_labels=1,
    torch_dtype=torch.bfloat16,
)

reward_config = RewardConfig(
    output_dir="./reward-model",
    num_train_epochs=1,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=1e-5,
    bf16=True,
    max_length=1024,
    logging_steps=10,
    save_strategy="epoch",
)

reward_trainer = RewardTrainer(
    model=reward_model,
    args=reward_config,
    train_dataset=preference_dataset["train"],
    eval_dataset=preference_dataset["validation"],
    tokenizer=tokenizer,
)

reward_trainer.train()
```

### PPO Training Loop

```python
from trl import PPOTrainer, PPOConfig, AutoModelForCausalLMWithValueHead

# Policy model with value head
policy_model = AutoModelForCausalLMWithValueHead.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    torch_dtype=torch.bfloat16,
    peft_config=peft_config,
)

# Load trained reward model
reward_model = AutoModelForSequenceClassification.from_pretrained(
    "./reward-model",
    torch_dtype=torch.bfloat16,
)
reward_model.eval()

ppo_config = PPOConfig(
    learning_rate=1e-6,
    batch_size=64,
    mini_batch_size=8,
    gradient_accumulation_steps=8,
    ppo_epochs=4,
    kl_penalty="kl",
    init_kl_coef=0.2,
    adap_kl_ctrl=True,
    target_kl=6.0,
    cliprange=0.2,
    cliprange_value=0.2,
    vf_coef=0.1,
)

ppo_trainer = PPOTrainer(
    config=ppo_config,
    model=policy_model,
    ref_model=None,  # Uses initial model as reference
    tokenizer=tokenizer,
    dataset=prompt_dataset,
)

for batch in ppo_trainer.dataloader:
    # Generate responses
    query_tensors = batch["input_ids"]
    response_tensors = ppo_trainer.generate(query_tensors, max_new_tokens=256)

    # Score with reward model
    texts = [tokenizer.decode(r, skip_special_tokens=True) for r in response_tensors]
    rewards = compute_rewards(reward_model, texts)

    # PPO step
    stats = ppo_trainer.step(query_tensors, response_tensors, rewards)
    ppo_trainer.log_stats(stats, batch, rewards)
```

### RLHF Pipeline Architecture

```
+------------------+     +------------------+     +------------------+
| 1. SFT Model     | --> | 2. Reward Model  | --> | 3. PPO Training  |
| (instruction     |     | (preference      |     | (optimize policy |
|  tuned base)     |     |  classifier)     |     |  with RM signal) |
+------------------+     +------------------+     +------------------+
                                                           |
                                                  +--------v--------+
                                                  | 4. Aligned Model|
                                                  | (deploy + eval) |
                                                  +-----------------+
```

---

## ORPO (Odds Ratio Preference Optimization)

```python
from trl import ORPOTrainer, ORPOConfig

# ORPO combines SFT + alignment in one step (no reference model needed)
orpo_config = ORPOConfig(
    output_dir="./orpo-output",
    num_train_epochs=1,
    per_device_train_batch_size=2,
    gradient_accumulation_steps=8,
    learning_rate=5e-6,
    lr_scheduler_type="cosine",
    warmup_ratio=0.1,
    bf16=True,
    gradient_checkpointing=True,
    beta=0.1,              # Preference weight
    max_length=1024,
    max_prompt_length=512,
    logging_steps=10,
)

trainer = ORPOTrainer(
    model=model,
    args=orpo_config,
    train_dataset=dataset["train"],
    tokenizer=tokenizer,
    peft_config=peft_config,
)

trainer.train()
```

---

## KTO (Kahneman-Tversky Optimization)

```python
from trl import KTOTrainer, KTOConfig

# KTO works with binary labels (good/bad) instead of paired preferences
kto_config = KTOConfig(
    output_dir="./kto-output",
    num_train_epochs=1,
    per_device_train_batch_size=2,
    gradient_accumulation_steps=8,
    learning_rate=5e-7,
    bf16=True,
    gradient_checkpointing=True,
    beta=0.1,
    desirable_weight=1.0,      # Weight for positive examples
    undesirable_weight=1.0,    # Weight for negative examples
    max_length=1024,
    max_prompt_length=512,
)

# Dataset format: prompt, completion, label (True/False)
trainer = KTOTrainer(
    model=model,
    ref_model=ref_model,
    args=kto_config,
    train_dataset=kto_dataset["train"],
    tokenizer=tokenizer,
    peft_config=peft_config,
)

trainer.train()
```

---

## Constitutional AI

### Self-Critique Pipeline

```python
PRINCIPLES = [
    "The response should not be harmful, unethical, racist, sexist, or toxic.",
    "The response should be helpful and provide accurate information.",
    "The response should acknowledge uncertainty when appropriate.",
    "The response should not generate illegal or dangerous content.",
]

def constitutional_revision(prompt: str, initial_response: str, llm) -> str:
    """Apply constitutional AI principles to revise a response."""
    revised = initial_response

    for principle in PRINCIPLES:
        critique_prompt = f"""Review this response against the principle:
        Principle: {principle}

        Response: {revised}

        Does the response violate this principle? If so, explain how.
        If not, say "No violation found."
        """
        critique = llm.invoke(critique_prompt).content

        if "no violation" not in critique.lower():
            revision_prompt = f"""Revise this response to comply with the principle.
            Principle: {principle}
            Critique: {critique}
            Original Response: {revised}

            Provide the revised response only:"""
            revised = llm.invoke(revision_prompt).content

    return revised
```

---

## Evaluation

### Alignment Benchmarks

| Benchmark | Measures | Metrics |
|-----------|----------|---------|
| MT-Bench | Multi-turn conversation quality | GPT-4 judge score (1-10) |
| AlpacaEval 2.0 | Instruction following | Win rate vs GPT-4 |
| TruthfulQA | Factual accuracy | MC accuracy, generation score |
| ToxiGen | Toxicity avoidance | Toxicity rate |
| BBQ | Bias detection | Accuracy across demographics |
| HarmBench | Safety robustness | Attack success rate |

### Reward Model Evaluation

```python
def evaluate_reward_model(reward_model, test_pairs: list[dict]) -> dict:
    """Evaluate reward model accuracy on held-out pairs."""
    correct = 0
    total = 0

    for pair in test_pairs:
        chosen_score = reward_model.score(pair["prompt"], pair["chosen"])
        rejected_score = reward_model.score(pair["prompt"], pair["rejected"])

        if chosen_score > rejected_score:
            correct += 1
        total += 1

    return {
        "accuracy": correct / total,
        "total_pairs": total,
    }
```

### Training Diagnostics

| Metric | Healthy Range | Issue If |
|--------|--------------|---------|
| DPO reward margin | Increasing | Flat or decreasing |
| DPO chosen reward | Increasing | Decreasing (forgetting) |
| DPO rejected reward | Stable/decreasing | Increasing |
| PPO KL divergence | 0-10 | > 20 (too far from ref) |
| PPO reward | Increasing | Flat (reward hacking) |
| PPO entropy | Slowly decreasing | Rapid drop (mode collapse) |

---

## Common Pitfalls and Solutions

| Pitfall | Symptom | Solution |
|---------|---------|---------|
| Reward hacking | High reward but bad outputs | Add KL penalty, lower beta |
| Mode collapse | Repetitive outputs | Increase entropy bonus, lower LR |
| Catastrophic forgetting | Loses base capabilities | Lower LR, increase beta, use LoRA |
| Sycophancy | Always agrees with user | Add diversity in preference data |
| Length bias | Prefers longer responses | Normalize by length (SimPO) |
| Label noise | Inconsistent preferences | Filter by annotator agreement |

---

## EXIT CHECKLIST

- [ ] Alignment method selected based on data, compute, and quality requirements
- [ ] Preference data collected and quality-validated
- [ ] Data format matches chosen method (paired, binary, or ranked)
- [ ] Training hyperparameters configured (beta, learning rate, KL penalty)
- [ ] Training monitored for reward margin and KL divergence
- [ ] Aligned model evaluated on safety and helpfulness benchmarks
- [ ] No catastrophic forgetting (base capabilities preserved)
- [ ] Output quality verified by human evaluation on held-out prompts

---

## Cross-References

- `3-build/lora_finetuning_workflow` -- SFT training before alignment
- `4-secure/ai_safety_guardrails` -- Runtime safety after alignment
- `3-build/distributed_training` -- Multi-GPU training for RLHF

---

*Skill Version: 1.0 | Created: March 2026*
