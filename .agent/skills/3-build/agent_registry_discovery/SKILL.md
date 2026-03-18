---
name: "Agent Registry and Discovery"
description: "Service registry for AI agents — capability advertisement, dynamic routing, health-aware load balancing"
triggers:
  - "/agent-registry"
  - "/agent-discovery"
  - "/agent-routing"
---

# Agent Registry and Discovery

## WHEN TO USE
- Running a fleet of agents that need to find each other
- Implementing dynamic task routing (send task to the right agent)
- Building a capability-based agent lookup system
- Health-aware routing (skip unhealthy agents)

## PROCESS

### 1. Registry Architecture
| Pattern | Implementation | Best For |
|---------|---------------|----------|
| Centralized registry | Redis/Postgres + API | Small-medium fleets (< 50 agents) |
| DNS-SD | mDNS/Consul | LAN-based fleets (Mac Minis on Tailscale) |
| Gossip protocol | SWIM/Serf | Large distributed fleets |
| Static config | JSON/YAML file | Fixed fleet, rarely changes |

### 2. Agent Registration
On startup, each agent registers:
- Agent ID (unique, stable across restarts)
- Capabilities (list of skills/tasks it can handle)
- Endpoint (how to reach it)
- Health check URL
- Current load (busy/available/overloaded)
- Metadata (model, version, cost tier)

### 3. Capability-Based Routing
When a task needs to be assigned:
1. Query registry: "which agents can handle `financial_analysis`?"
2. Filter by health: exclude unhealthy/overloaded agents
3. Rank by: cost tier, current load, latency, specialization score
4. Route to best match
5. If no match: queue the task or escalate to human

### 4. Health Checks
- Heartbeat: each agent pings registry every 30s
- Deep health: registry calls agent's health endpoint every 60s
- Grace period: 3 missed heartbeats before marking unhealthy
- Auto-deregister: remove agents that are down for 10+ minutes

### 5. Dynamic Scaling
- Monitor queue depth per capability
- If queue grows: spin up additional agents for that capability
- If queue empty for 30min: scale down idle agents
- Cost ceiling: never exceed N concurrent agents per capability

## CHECKLIST
- [ ] Registry pattern selected and implemented
- [ ] All agents register on startup with capabilities
- [ ] Health checks running (heartbeat + deep)
- [ ] Capability-based routing working
- [ ] Unhealthy agents excluded from routing
- [ ] Deregistration on agent shutdown (graceful)
- [ ] Monitoring: registry size, routing latency, queue depth

## Related Skills
- [`agent_communication_protocols`](../agent_communication_protocols/SKILL.md)
- [`ai_agent_fleet_management`](../ai_agent_fleet_management/SKILL.md)
