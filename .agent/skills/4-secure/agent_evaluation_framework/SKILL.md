---
name: Agent Evaluation Framework
description: Task completion metrics, tool call accuracy, multi-step trajectory eval, cost-per-task analysis, regression testing, A/B testing configs, and benchmarks (AgentBench, SWE-bench)
triggers:
  - /agent-eval
  - /agent-benchmark
  - /agent-testing
---

# Agent Evaluation Framework Skill

**Purpose**: Systematically measure AI agent performance across task completion, tool usage accuracy, multi-step reasoning, cost efficiency, and regression safety using established benchmarks and custom eval harnesses.

---

## WHEN TO USE

- Evaluating a new agent before production deployment
- Comparing agent performance across LLM providers or prompt versions
- Measuring cost-per-task to optimize spending
- Running regression tests after agent code or prompt changes
- Setting up A/B tests between agent configurations
- Benchmarking against public standards (AgentBench, SWE-bench, GAIA)

---

## PROCESS

### 1. Define Evaluation Dimensions

| Dimension | Metric | How to Measure |
|---|---|---|
| Task completion | Pass rate (%) | Did the agent produce a correct final answer? |
| Tool call accuracy | Precision/recall of tool invocations | Compare tool calls to gold-standard trajectory |
| Trajectory quality | Step efficiency ratio | Actual steps / optimal steps |
| Cost efficiency | $/task, tokens/task | Sum input + output tokens * model pricing |
| Latency | p50/p95 end-to-end time | Wall clock from task start to final answer |
| Safety | Guardrail trigger rate | % of runs that hit safety filters |

### 2. Build an Eval Dataset

```python
# eval_dataset.jsonl — one task per line
{"task_id": "file-edit-001", "instruction": "Add error handling to parse_config()", "expected_tools": ["read_file", "edit_file"], "expected_outcome": "try/except block added", "difficulty": "medium"}
{"task_id": "debug-002", "instruction": "Fix the TypeError in utils.py line 42", "expected_tools": ["read_file", "grep", "edit_file"], "expected_outcome": "TypeError resolved", "difficulty": "hard"}
```

Aim for 50+ tasks across easy/medium/hard. Include edge cases and adversarial inputs.

### 3. Run Trajectory Evaluation

```python
from dataclasses import dataclass

@dataclass
class TrajectoryResult:
    task_id: str
    success: bool
    tool_calls: list[dict]
    expected_tools: list[str]
    total_tokens: int
    latency_ms: float
    cost_usd: float

def eval_trajectory(result: TrajectoryResult) -> dict:
    actual_tools = [tc["name"] for tc in result.tool_calls]
    tool_precision = len(set(actual_tools) & set(result.expected_tools)) / max(len(actual_tools), 1)
    tool_recall = len(set(actual_tools) & set(result.expected_tools)) / max(len(result.expected_tools), 1)
    return {
        "task_id": result.task_id,
        "pass": result.success,
        "tool_precision": round(tool_precision, 3),
        "tool_recall": round(tool_recall, 3),
        "step_count": len(result.tool_calls),
        "cost_usd": result.cost_usd,
        "latency_ms": result.latency_ms,
    }
```

### 4. Benchmark Against Public Standards

| Benchmark | What It Tests | Target Score |
|---|---|---|
| **SWE-bench Verified** | Real GitHub issue resolution | >30% = strong |
| **AgentBench** | Multi-turn tool use across 8 environments | Track percentile |
| **GAIA** | General AI assistant tasks (web, files, reasoning) | >40% Level 1 |
| **HumanEval+** | Code generation correctness | >80% pass@1 |
| **τ-bench** | Tool-augmented task completion | Compare to baseline |

### 5. Configure A/B Testing

```yaml
# agent_ab_config.yaml
experiment_name: "gpt4o-vs-claude-sonnet"
variants:
  control:
    model: "gpt-4o"
    temperature: 0.0
    max_tokens: 4096
  treatment:
    model: "claude-sonnet-4-20250514"
    temperature: 0.0
    max_tokens: 4096
eval_dataset: "eval_dataset.jsonl"
sample_size: 200
metrics: ["pass_rate", "cost_per_task", "p95_latency", "tool_precision"]
significance_level: 0.05
```

### 6. Run Regression Tests

After every agent change (prompt edit, model swap, tool update), re-run the full eval suite:

```bash
# Run eval suite and compare to baseline
python run_evals.py --dataset eval_dataset.jsonl --config agent_config.yaml --baseline results/baseline.json --output results/current.json
python compare_results.py --baseline results/baseline.json --current results/current.json --threshold 0.05
```

Flag any metric that regresses by more than 5% from the baseline.

---

## CHECKLIST

- [ ] Evaluation dimensions defined with concrete metrics for each
- [ ] Eval dataset built with 50+ tasks across difficulty levels
- [ ] Trajectory evaluation implemented (tool precision, recall, step count)
- [ ] Cost tracking wired up (tokens counted, USD calculated per task)
- [ ] Latency measured at p50 and p95
- [ ] At least one public benchmark score recorded (SWE-bench, AgentBench, or GAIA)
- [ ] A/B test config created for model/prompt comparisons
- [ ] Regression test pipeline runs on every agent change
- [ ] Results stored in version-controlled JSON for historical comparison
- [ ] Dashboard or report generated showing pass rate, cost, latency trends

---

## Related Skills

- [LLM Evaluation & Benchmarking](../../4-secure/llm_evaluation_benchmarking/SKILL.md)
- [Eval Harness](../../4-secure/eval_harness/SKILL.md)

---

*Skill Version: 1.0 | Created: March 2026*
