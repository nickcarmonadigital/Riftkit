---
name: OpenClaw Platform Patterns
description: Architecture conventions for the OpenClaw AI agent platform — agent schemas, provider plugins, channel adapters, Riftkit-to-OpenClaw deployment, and fleet management with PM2/Ansible
triggers:
  - /openclaw
  - /claw-patterns
  - /openclaw-patterns
---

# OpenClaw Platform Patterns Skill

## WHEN TO USE

- Defining or modifying an agent on the OpenClaw platform
- Adding a new LLM provider (Ollama, OpenAI, Anthropic, AgentIQ) via the plugin system
- Connecting a new channel (Discord, Telegram, Slack) through a channel adapter
- Deploying agents from a Riftkit project into the OpenClaw runtime
- Managing a fleet of agents across processes with PM2 or across hosts with Ansible

---

## PROCESS

1. **Define the agent using the OpenClaw schema.** Every agent is a YAML file in `agents/` declaring identity, provider, model, system prompt, tools, and channel bindings:
   ```yaml
   # agents/support-bot.agent.yaml
   name: support-bot
   provider: ollama          # ollama | openai | anthropic | agentiq
   model: llama3:8b
   system_prompt_file: prompts/support-bot/v1.0.0.jinja2
   tools: [knowledge_search, ticket_create]
   channels:
     - { type: discord, guild_id: "123456789" }
     - { type: telegram, bot_token_env: TELEGRAM_SUPPORT_TOKEN }
   ```

2. **Register or switch the LLM provider.** Providers implement a standard interface: `async chat(messages, **kwargs)`, `async embed(texts)`, `async health() -> bool`. Create a module under `providers/` exporting a class with these three methods. The agent YAML `provider` field selects which class to load at runtime.

3. **Wire up channel adapters.** Each channel adapter translates platform-specific events into OpenClaw's internal message format and routes responses back. Adapters live in `channels/` and register via the agent YAML `channels` block. A Discord adapter handles `on_message`, a Telegram adapter handles `Update` objects, a Slack adapter handles `event_callback`.

4. **Deploy from Riftkit to OpenClaw.** After building and testing with Riftkit skills (spec_build, security_audit, e2e_testing), copy `agents/*.agent.yaml`, `prompts/`, and `tools/` into the OpenClaw runtime directory. Register the agent in the fleet config and restart.

5. **Manage the fleet with PM2 (single host) or Ansible (multi-host).** Each agent runs as a PM2 process:
   ```bash
   pm2 start openclaw-runner.js --name support-bot -- --agent agents/support-bot.agent.yaml
   pm2 start openclaw-runner.js --name sales-agent -- --agent agents/sales-agent.agent.yaml
   pm2 save && pm2 startup
   ```
   For multi-host fleets, use an Ansible playbook that syncs agent configs, pulls model updates, and restarts PM2 processes across all nodes via Tailscale.

6. **Validate the deployment.** Hit each agent's health endpoint, send a test message through each bound channel, and confirm logs show clean request/response cycles. Check PM2 status for restart loops.

---

## CHECKLIST

- [ ] Agent YAML schema validated (name, provider, model, channels all present)
- [ ] Provider plugin implements `chat`, `embed`, and `health` interface
- [ ] Channel adapters tested with real messages on each bound platform
- [ ] Prompts and tools copied from Riftkit project to OpenClaw runtime
- [ ] PM2 ecosystem file includes all agents with `--agent` flag
- [ ] Fleet health verified: `pm2 ls` shows all agents online, zero restarts
- [ ] Secrets stored in env vars or `.env` outside synced folders
- [ ] Ansible playbook tested for multi-host sync (if applicable)
- [ ] Rollback plan documented: previous agent YAML versions tagged in git

---

## Related Skills

- [AI Agent Fleet Management](../../3-build/ai_agent_fleet_management/SKILL.md) -- fleet-wide orchestration, load balancing, and scaling patterns
- [LLM Provider Management](../../3-build/llm_provider_management/SKILL.md) -- provider fallback chains, rate limit handling, cost routing

---

*Skill Version: 1.0 | Created: March 2026*
