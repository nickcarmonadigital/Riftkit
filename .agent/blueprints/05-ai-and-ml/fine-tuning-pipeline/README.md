# Blueprint: Fine-Tuning Pipeline

Building LLM fine-tuning pipelines: dataset preparation, training (full fine-tune, LoRA, QLoRA), evaluation, and deployment of custom language models.

## Recommended Tech Stacks

| Stack | Best For |
|-------|----------|
| Hugging Face TRL + PEFT | LoRA/QLoRA fine-tuning, broadest model support |
| Axolotl | Config-driven fine-tuning, multi-GPU, many model architectures |
| OpenAI Fine-Tuning API | GPT model fine-tuning, zero infrastructure management |
| Anthropic Fine-Tuning | Claude fine-tuning, enterprise use cases |
| Unsloth | 2x faster LoRA training, reduced memory, consumer GPUs |
| LLaMA Factory | GUI-based fine-tuning, 100+ model support |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define fine-tuning goal (style, domain knowledge, instruction following)
- **prd_generator** -- Document dataset requirements, eval criteria, success metrics
- **competitive_analysis** -- Evaluate if fine-tuning is needed vs prompting vs RAG

When to fine-tune vs alternatives:
- **Prompt engineering**: Try this first. Free, instant, no data needed.
- **RAG**: Better when you need up-to-date or retrievable knowledge.
- **Fine-tuning**: Best for consistent style/format, domain-specific behavior, reducing latency/cost by using smaller models, or teaching patterns that prompting cannot capture.
- **Pre-training**: Only if you have >100GB of domain text and need deep domain understanding.

### Phase 2: Architecture
- **schema_design** -- Training data format (instruction/input/output, chat, completion)
- **api_design** -- Model serving API, version management, fallback to base model

Key architecture decisions:
- **Full fine-tune vs LoRA vs QLoRA**: Full fine-tune gives best quality but needs 4x model size in VRAM. LoRA trains 0.1-1% of parameters with ~95% of full fine-tune quality. QLoRA adds 4-bit quantization to fit on consumer GPUs.
- **Base model selection**: Larger models need less data but more compute. 7-8B models are the sweet spot for most tasks.
- **Data format**: Instruction format for task-following, chat format for conversations, completion for text generation.

### Phase 3: Implementation
- **tdd_workflow** -- Validate dataset format, test training loop on small subset
- **error_handling** -- OOM recovery, checkpoint resume, training divergence detection
- **code_review** -- Review data preprocessing, hyperparameters, eval methodology

### Phase 4: Testing and Security
- **security_audit** -- Training data PII scrubbing, model output safety, license compliance
- **integration_testing** -- Inference pipeline with fine-tuned model, A/B vs base model

### Phase 5: Deployment
- **ci_cd_pipeline** -- Model registry, automated eval gates, rollback to previous version
- **deployment_patterns** -- vLLM / TGI serving, quantized deployment (GPTQ/AWQ)
- **monitoring_setup** -- Generation quality metrics, latency, cost per token

## Key Domain-Specific Concerns

### Dataset Preparation
- Quality over quantity: 1,000 excellent examples beat 100,000 mediocre ones
- Format consistently: pick one template and stick to it across all examples
- Include diverse examples covering the full range of expected inputs
- Add negative examples (what NOT to do) for better boundary learning
- Deduplicate and remove near-duplicates -- they cause overfitting
- Validate with a held-out test set that the model never sees during training

### Dataset Size Guidelines

| Fine-Tune Type | Minimum | Good | Excellent |
|---------------|---------|------|-----------|
| Style/Format | 50 | 200 | 1,000 |
| Domain Task | 500 | 2,000 | 10,000 |
| Instruction Following | 1,000 | 5,000 | 50,000 |
| Chat/Conversation | 1,000 | 10,000 | 100,000 |

### Training Configuration
- Start with low learning rate: 1e-5 (full), 2e-4 (LoRA)
- Use cosine learning rate scheduler with warmup (5-10% of steps)
- Train for 1-3 epochs -- more risks overfitting on small datasets
- LoRA rank: r=8 for simple tasks, r=16-64 for complex tasks
- Target modules: q_proj, v_proj minimum; add k_proj, o_proj, gate_proj for better quality
- Use gradient checkpointing to trade compute for memory
- Monitor eval loss -- stop if it diverges from train loss

### Evaluation
- Automated metrics: perplexity, BLEU/ROUGE (if applicable), task-specific accuracy
- LLM-as-judge: Use a stronger model to rate outputs (Claude/GPT-4 evaluating fine-tuned 7B)
- Human eval: Sample 50-100 outputs for manual quality review
- A/B comparison: Base model vs fine-tuned on identical prompts
- Test on out-of-distribution inputs to check generalization

### Common Pitfalls
- Catastrophic forgetting: Model loses general capabilities. Fix with mixing in general data.
- Overfitting: Train loss drops but eval loss rises. Reduce epochs, increase data, add regularization.
- Data contamination: Test data leaked into training set. Always split before any preprocessing.
- Format mismatch: Training format differs from inference format. Use identical templates.
- License violations: Some base models restrict commercial fine-tuning. Check the license.

## Getting Started

1. **Define the task** -- What should the fine-tuned model do differently from the base model?
2. **Collect seed data** -- Gather 50-100 gold-standard examples of desired input/output
3. **Choose base model** -- Llama 3.1 8B, Mistral 7B, Qwen 2.5 for open-source; GPT-4o-mini, Claude for API
4. **Format dataset** -- Convert to instruction/chat format, validate schema
5. **Split dataset** -- 90/10 train/eval, ensure no contamination
6. **Configure training** -- Set hyperparameters, choose LoRA vs full fine-tune
7. **Train on small subset** -- Verify pipeline works on 10% of data first
8. **Full training run** -- Monitor loss curves, save checkpoints
9. **Evaluate** -- Automated metrics + human review + A/B vs base model
10. **Deploy** -- Serve with vLLM/TGI, quantize for production, monitor quality

## Project Structure

```
data/
  raw/                      # Original source data
  processed/
    train.jsonl             # Training examples
    eval.jsonl              # Evaluation examples
    test.jsonl              # Held-out test set
  templates/
    instruction.jinja       # Prompt template for formatting
scripts/
  prepare_data.py           # Data cleaning, formatting, splitting
  validate_data.py          # Schema validation, quality checks
  dedup.py                  # Deduplication
training/
  train.py                  # Training script
  config.yaml               # Hyperparameters, model config
  merge_lora.py             # Merge LoRA weights into base model
evaluation/
  evaluate.py               # Automated metrics
  llm_judge.py              # LLM-as-judge evaluation
  compare.py                # A/B comparison with base model
  human_eval/
    sample.py               # Sample outputs for human review
    template.md             # Human evaluation rubric
serving/
  server.py                 # vLLM/TGI inference server
  quantize.py               # GPTQ/AWQ quantization
  benchmark.py              # Latency and throughput testing
models/
  checkpoints/              # Training checkpoints
  merged/                   # Final merged model
  quantized/                # Quantized for deployment
```
