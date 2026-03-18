---
name: "Agent Communication Protocols"
description: "Standardized protocols for agent-to-agent communication — A2A, ACP, MCP integration, message schemas, and authentication"
triggers:
  - "/agent-protocols"
  - "/a2a"
  - "/agent-communication"
  - "/agent-messaging"
---

# Agent Communication Protocols

## WHEN TO USE
- Building multi-agent systems where agents need to talk to each other
- Integrating with Google A2A, OpenAI Agent Protocol, or Agent Communication Protocol (ACP)
- Designing message formats for agent-to-agent communication
- Implementing authentication between agents in a fleet

## PROCESS

### 1. Protocol Selection
| Protocol | Best For | Status |
|----------|----------|--------|
| Google A2A | Cross-platform agent discovery + communication | Production (2025) |
| Agent Communication Protocol (ACP) | Lightweight HTTP-based agent messaging | Emerging standard |
| Model Context Protocol (MCP) | Tool/resource sharing between LLMs | Production (Anthropic) |
| Custom gRPC/REST | Internal fleet with full control | Always available |

### 2. Agent Card / Capability Advertisement
Every agent publishes a capability card (JSON-LD or JSON):
```json
{
  "agent_id": "cfo-agent-mini-07",
  "capabilities": ["financial_analysis", "budget_review", "cost_optimization"],
  "accepts": ["task_request", "data_query"],
  "auth": "bearer_token",
  "endpoint": "https://100.x.y.z:8080/agent/v1"
}
```
- Register cards in a central registry or use DNS-SD for discovery
- Include version, rate limits, and SLA in the card

### 3. Message Schema
Standardize all agent-to-agent messages:
```json
{
  "id": "msg-uuid",
  "from": "ceo-agent",
  "to": "cfo-agent",
  "type": "task_request",
  "payload": { "task": "Review Q1 budget", "deadline": "2h" },
  "reply_to": "msg-parent-uuid",
  "timestamp": "2026-03-18T12:00:00Z",
  "priority": "high"
}
```
- Use correlation IDs for request-response tracking
- Include priority for queue ordering
- Support async (fire-and-forget) and sync (request-response) patterns

### 4. Authentication Between Agents
- Each agent has its own API key or JWT
- Mutual TLS for high-security fleet communication
- Token exchange: Agent A requests scoped token from auth service, passes to Agent B
- Never hardcode inter-agent credentials — use secret manager or env vars

### 5. Error Handling
- Define standard error responses (timeout, capability_not_found, auth_failed, rate_limited)
- Implement retry with exponential backoff for transient failures
- Dead letter queue for messages that fail after max retries
- Circuit breaker: if target agent fails 3x, stop sending for cooldown period

### 6. Observability
- Log all inter-agent messages with correlation IDs
- Track latency per agent pair
- Alert on: message delivery failures, response time degradation, auth failures
- Dashboard: agent communication graph showing who talks to whom

## CHECKLIST
- [ ] Protocol selected based on requirements
- [ ] Agent capability cards defined and published
- [ ] Message schema standardized across fleet
- [ ] Authentication implemented (not hardcoded)
- [ ] Error handling with retry and circuit breaker
- [ ] Correlation IDs on all messages
- [ ] Monitoring and alerting active
- [ ] Dead letter queue for failed messages

## Related Skills
- [`ai_agent_development`](../ai_agent_development/SKILL.md)
- [`ai_agent_fleet_management`](../ai_agent_fleet_management/SKILL.md)
- [`agent_conflict_resolution`](../agent_conflict_resolution/SKILL.md)
