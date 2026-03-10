# riftkit

> **298 Skills** | **19 Agents** | **39 Commands** | **39 Rules** | **61 Docs** | **25 Workflows** | **Zero Fluff**

A battle-tested toolkit for AI-assisted development. Drop the `.agent` folder into any project and supercharge your workflow — now with automated agents, slash commands, coding rules, and hooks from [Everything Claude Code](https://github.com/affaan-m/everything-claude-code).

---

## ⚡ Quick Start

```bash
# Clone and copy to your project
git clone https://github.com/nickcarmonadigital/riftkit.git
cp -r riftkit/.agent ./your-project/
```

Your AI assistant will automatically detect and use these skills.

📖 **New here?** Start with [GETTING_STARTED.md](./GETTING_STARTED.md)

---

## 📚 What's Included

### Skills (298)

| Category | Count | Examples |
|----------|-------|---------|
| **Context** | 23 | `new_project` `project_context` `codebase_health_audit` `architecture_recovery` `risk_register` `stakeholder_map` |
| **Brainstorm** | 14 | `idea_to_spec` `prd_generator` `client_discovery` `competitive_analysis` `user_research` `prioritization_frameworks` |
| **Design** | 24 | `atomic_reverse_architecture` `feature_architecture` `api_contract_design` `c4_architecture_diagrams` `schema_standards` |
| **Build** | 93 | `spec_build` `bug_troubleshoot` `code_review` `api_design` `backend_patterns` `frontend_patterns` `golang_patterns` `python_patterns` `ai_agent_development` `rag_advanced_patterns` |
| **Secure** | 40 | `security_audit` `tdd_workflow` `e2e_testing` `unit_testing` `chaos_engineering` `container_security` `sast_scanning` |
| **Ship** | 23 | `ci_cd_pipeline` `deployment_patterns` `infrastructure_as_code` `db_migrations` `gitops_workflow` `mlops_pipeline` |
| **Alpha Ops** | 10 | `error_tracking` `health_checks` `env_validation` `qa_playbook` `backup_strategy` `alpha_telemetry` |
| **Beta Ops** | 13 | `product_analytics` `feedback_system` `rate_limiting` `feature_flags` `load_testing` `usage_metering_billing` |
| **Handoff** | 14 | `api_reference` `feature_walkthrough` `disaster_recovery` `user_documentation` `monitoring_handoff` |
| **Maintenance** | 13 | `incident_response_operations` `dependency_management` `slo_sla_management` `documentation_standards` |
| **Toolkit** | 31 | `age` `content_creation` `sre_foundations` `responsible_ai_framework` `dora_metrics_tracking` |

### Agents (19)

Specialized AI subagents for automated workflows. See [agents/README.md](./agents/README.md).

| Agent | Model | Phase |
|-------|-------|-------|
| `planner` | Opus | 2-design, 3-build |
| `architect` | Opus | 2-design |
| `brainstorm-agent` | Sonnet | 1-brainstorm |
| `code-reviewer` | Sonnet | 3-build, 4-secure |
| `compliance-agent` | Sonnet | 4-secure |
| `security-reviewer` | Opus | 4-secure |
| `tdd-guide` | Sonnet | 3-build, 4-secure |
| `build-error-resolver` | Sonnet | 3-build |
| `e2e-runner` | Sonnet | 4-secure |
| `framework-router` | Sonnet | All phases |
| `doc-updater` | Haiku | 6-handoff |
| `refactor-cleaner` | Sonnet | 3-build, 7-maintenance |
| `database-reviewer` | Sonnet | 3-build |
| `go-reviewer` | Sonnet | 3-build |
| `go-build-resolver` | Sonnet | 3-build |
| `python-reviewer` | Sonnet | 3-build |
| `security-agent` | Sonnet | 4-secure |
| `ship-agent` | Sonnet | 5-ship |
| `sre-agent` | Sonnet | 7-maintenance |

### Commands (39)

Slash commands for Claude Code automation. See [commands/README.md](./commands/README.md).

Key commands: `/plan` `/tdd` `/code-review` `/build-fix` `/e2e` `/verify` `/checkpoint` `/eval` `/learn` `/evolve` `/orchestrate` `/multi-execute` `/refactor-clean` `/test-coverage`

### Rules (25)

Always-follow coding guidelines by language. See [rules/README.md](./rules/README.md).

- **Common** (9): coding-style, git-workflow, testing, performance, patterns, hooks, agents, security, development-workflow
- **TypeScript** (5) | **Python** (5) | **Go** (5) | **Swift** (5)

### Hooks & Automation

Event-driven automations for Claude Code. See [hooks/README.md](./hooks/README.md).

9 hook scripts: session lifecycle, post-edit formatting, typecheck, console.log detection, compaction suggestions, session evaluation.

→ Full reference: [skills-index.md](./skills-index.md)

### Guides (19)

| Guide | What You Get |
|-------|--------------|
| [**Prompt Library**](./docs/prompt-library.md) | 50+ ready-to-use prompts |
| [**Code Snippets**](./docs/code-snippets.md) | Copy-paste solutions |
| [**Skill Combos**](./docs/skill-combos.md) | Power workflows |
| [**Common Mistakes**](./docs/common-mistakes.md) | Avoid pitfalls |
| [**Project Templates**](./docs/project-templates.md) | Starter structures |
| [**Tech Stack Guide**](./docs/tech-stack-guide.md) | Decision framework |
| [**Development Workflow**](./docs/development-workflow.md) | Complete process map |
| [**Glossary**](./docs/glossary.md) | Quick term reference |

Plus: onboarding templates, compliance guides, proposal templates, and more.

---

## 🚀 Example Usage

```
You: /brain-dump I need a user dashboard with analytics

AI: [Creates structured spec with user stories, tech requirements, and implementation plan]

You: /architecture dashboard

AI: [Generates comprehensive architecture doc with data flow, APIs, and component design]

You: Build it

AI: [Implements the feature following the spec]

You: /walkthrough dashboard

AI: [Creates documentation explaining how it works]
```

---

## 🧩 Skill Format

```markdown
---
name: Skill Name
description: What this skill does
---

# Skill Name

## 🎯 TRIGGER COMMANDS
[Commands to activate]

## When to Use
[Situations where this applies]

## The Process
[Step-by-step instructions]

## ✅ Checklist
[Completion criteria]
```

---

## 📁 Structure

```
.agent/
├── README.md              # You are here
├── GETTING_STARTED.md     # 5-minute setup guide
├── install.sh             # Global installer (copies to ~/.claude/)
├── skills/                # 298 skill folders (organized by phase)
│   ├── 0-context/         #   23 skills
│   ├── 1-brainstorm/      #   14 skills
│   ├── 2-design/          #   24 skills
│   ├── 3-build/           #   93 skills
│   ├── 4-secure/          #   40 skills
│   ├── 5-ship/            #   23 skills
│   └── ...
├── agents/                # 19 specialized AI subagents
├── commands/              # 39 slash commands
├── rules/                 # 25 coding rule files (common + 4 languages)
├── hooks/                 # Event-driven automations
├── contexts/              # Dynamic system prompts (dev/review/research)
├── scripts/               # Node.js utilities (hooks, CI, lib)
├── schemas/               # JSON validation schemas
├── examples/              # 6 CLAUDE.md project templates
├── mcp-configs/           # MCP server integration configs
├── workflows/             # 25 workflow definitions
└── docs/                  # 70+ reference guides + templates
```

---

## 🤝 Contributing

1. Fork the repo
2. Create a skill folder: `.agent/skills/[skill-name]/SKILL.md`
3. Follow the skill format above
4. Submit a PR

---

## 📜 License

MIT License - Use freely.
