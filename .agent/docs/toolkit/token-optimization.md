# Token Optimization Guide

Strategies for managing context window usage and reducing LLM costs across the development lifecycle.

## Context Window Management

### Strategic Compaction

Use the `/checkpoint` command before context gets large:
- **When**: Context exceeds ~60% capacity
- **How**: Creates a summary checkpoint, allowing safe compaction
- **Skill**: See `toolkit/strategic_compact/SKILL.md`

### Iterative Retrieval

Instead of loading everything upfront, use progressive context refinement:
1. Start with high-level file structure
2. Drill into specific files as needed
3. Use agents for parallel investigation
- **Skill**: See `toolkit/iterative_retrieval/SKILL.md`

## Model Routing

### Cost-Aware Pipeline

Route tasks to appropriate model tiers:

| Task Type | Recommended Model | Why |
|-----------|------------------|-----|
| Architecture, Security Review | Opus | Requires deep reasoning |
| Code Review, Testing, Building | Sonnet | Balanced capability/cost |
| Documentation Updates | Haiku | Fast, cost-effective |
| Simple Queries | Haiku | Minimal token usage |

- **Skill**: See `toolkit/cost_aware_llm_pipeline/SKILL.md`

### Agent Model Assignment

Each agent is pre-configured with the optimal model:
- See `.agent/agents/README.md` for the full model assignment table

## Token Reduction Techniques

### 1. Selective File Reading
```
# Instead of reading entire files:
Read lines 50-80 of src/auth/service.ts

# Use grep to find relevant sections first:
Search for "handleLogin" in src/auth/
```

### 2. Focused Prompts
- Be specific about what you need
- Reference skills by name instead of pasting content
- Use `/plan` to structure work before executing

### 3. Session Management
- Use `/sessions` to manage session state
- Archive completed work with `/checkpoint`
- Start fresh sessions for unrelated tasks

### 4. Agent Delegation
- Delegate independent tasks to subagents
- Subagents have their own context windows
- Use `/multi-execute` for parallel agent work

## Monitoring

### Session Evaluation
- Use `/eval` to assess session efficiency
- Use `/learn` to extract reusable patterns
- Use `/instinct-status` to review learned behaviors

## Related Skills

- `toolkit/strategic_compact/` — Context window management
- `toolkit/iterative_retrieval/` — Progressive context refinement
- `toolkit/cost_aware_llm_pipeline/` — Model routing and optimization
- `toolkit/ai_tool_orchestration/` — AI tool usage patterns

## Related Commands

- `/checkpoint` — Create session checkpoint
- `/eval` — Evaluate session
- `/learn` — Extract patterns
- `/sessions` — Manage sessions
