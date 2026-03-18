---
name: "AI Agent Fleet Management"
description: "Managing multiple AI agent instances across machines — provisioning, monitoring, coordination, and cost control"
triggers:
  - "/fleet"
  - "/agent-fleet"
  - "/fleet-management"
---

# AI Agent Fleet Management

## WHEN TO USE
- Managing multiple AI agent instances (e.g., Mac Mini fleet, VPS cluster)
- Provisioning and configuring agents across machines
- Monitoring agent health, cost, and output quality
- Coordinating work across multiple autonomous agents

## PROCESS

### 1. Fleet Architecture
- Define agent roles and responsibilities (C-suite model, specialist model, etc.)
- Map agents to machines (1:1 or N:1)
- Choose orchestration: Ansible, PM2 ecosystem, Docker Swarm, or manual
- Define communication channels between agents

### 2. Provisioning
- Automate machine setup (Ansible playbooks, shell scripts)
- Per-agent configuration: API keys, model selection, system prompts, tool access
- Version control all agent configs (SOUL.md, CLAUDE.md, .env templates)
- One API key per agent for cost tracking — never share keys

### 3. Monitoring
- Health checks: is each agent responsive?
- Cost tracking: per-agent API spend (daily, weekly, monthly)
- Output quality: sample and review agent outputs regularly
- Alert on: agent down, spend spike, error rate increase

### 4. Human-in-the-Loop
- Define review gates: what requires human approval before action?
- Notification routing: which agent outputs go to which human?
- Escalation paths: what happens when an agent is stuck or wrong?
- Review queue prioritization: which agents need attention first?

### 5. Coordination
- Prevent conflicting actions (two agents editing the same resource)
- Shared context: how do agents access each other's outputs?
- Task routing: how does work get assigned to the right agent?
- Deadlock prevention: what if Agent A waits for Agent B and vice versa?

### 6. Cost Control
- Set per-agent daily/weekly spend limits
- Circuit breaker: auto-pause agents that exceed thresholds
- Model tiering: use cheaper models for simple tasks
- Audit: monthly cost review per agent role

## CHECKLIST
- [ ] Agent roles and machine mapping defined
- [ ] Provisioning automated (not manual setup)
- [ ] Each agent has its own API key
- [ ] Health monitoring active for all agents
- [ ] Cost tracking per agent
- [ ] Human review gates defined
- [ ] Coordination rules prevent conflicts
- [ ] Spend limits with circuit breakers

## Related Skills
- [`ai_agent_development`](../ai_agent_development/SKILL.md)
- [`ai_cost_optimization`](../../toolkit/ai_cost_optimization/SKILL.md)
