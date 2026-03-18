---
name: "LLM Provider Management"
description: "Managing multiple LLM providers — routing, failover, cost optimization, rate limiting, and model selection"
triggers:
  - "/llm-providers"
  - "/provider-management"
  - "/model-routing"
---

# LLM Provider Management

## WHEN TO USE
- Using multiple LLM providers (Anthropic, OpenAI, Ollama, Gemini)
- Implementing provider failover and load balancing
- Optimizing cost across different models and providers
- Managing API keys, rate limits, and quotas

## PROCESS

### 1. Provider Inventory
- List all providers with: models available, pricing, rate limits, latency
- Classify by capability tier: flagship (best quality), mid (balanced), fast (cheapest)
- Track API key per provider, per environment

### 2. Routing Strategy
| Request Type | Route To | Why |
|---|---|---|
| Complex reasoning | Claude Opus / GPT-4o | Best quality |
| Code generation | Claude Sonnet / GPT-4o-mini | Good + fast |
| Simple extraction | Ollama (local) / Gemini Flash | Free/cheap |
| High-volume batch | Cheapest available | Cost |

### 3. Failover
- Primary to Secondary to Tertiary chain per request type
- Detect failures: timeout (>30s), 5xx errors, rate limit (429)
- On failure: retry once, then failover to next provider
- Circuit breaker: if provider fails 3x in 5min, skip for 10min

### 4. Cost Control
- Track spend per provider per day/week/month
- Set alerts at 50%, 80%, 100% of budget
- Auto-downgrade to cheaper model when budget is tight
- Audit: are expensive models being used for simple tasks?

### 5. Rate Limit Management
- Track remaining quota per provider (from response headers)
- Queue requests when approaching limits
- Spread load across providers to avoid hitting any single limit
- Implement request priority: critical > normal > background

## CHECKLIST
- [ ] All providers inventoried with pricing and limits
- [ ] Routing strategy defined per request type
- [ ] Failover chain configured and tested
- [ ] Circuit breaker implemented
- [ ] Per-provider cost tracking active
- [ ] Budget alerts configured
- [ ] Rate limit awareness implemented

## Related Skills
- [`ai_agent_development`](../ai_agent_development/SKILL.md)
- [`cost_aware_llm_pipeline`](../../toolkit/cost_aware_llm_pipeline/SKILL.md)
