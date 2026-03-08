# riftkit

> **298 Skills** | **19 Agents** | **39 Commands** | **25 Rules** | **70+ Docs** | **25 Workflows** | **Zero Fluff**

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

### Skills (~130)

| Category | Skills |
|----------|--------|
| **Context (7)** | `new_project` `project_context` `documentation_framework` `ssot_structure` `codebase_navigation` `search_first` `project_guidelines` |
| **Brainstorm (9)** | `client_discovery` `idea_to_spec` `proposal_generator` `smb_launchpad` `prioritization_frameworks` `user_story_standards` `competitive_analysis` `product_metrics` `user_research` |
| **Design (4)** | `atomic_reverse_architecture` `feature_architecture` `deployment_modes` `schema_standards` |
| **Build (50)** | `spec_build` `bug_troubleshoot` `website_build` `observability` `code_review` `ui_polish` `code_changelog` `sprint_planning` `stakeholder_communication` `retrospective` `cost_estimation` `git_workflow` `api_design` `error_handling` `auth_implementation` `docker_development` `environment_setup` `refactoring` `code_review_response` `database_optimization` `notification_systems` + 11 domain-specific + `backend_patterns` `frontend_patterns` `golang_patterns` `python_patterns` `cpp_coding_standards` `java_coding_standards` `jpa_patterns` `springboot_patterns` `django_patterns` `swift_actor_persistence` `swift_protocol_di_testing` `swift_concurrency` `liquid_glass_design` `clickhouse_io` `content_hash_cache` `regex_vs_llm` |
| **Secure (21)** | `security_audit` `e2e_testing` `ip_protection` `unit_testing` `integration_testing` `accessibility_testing` `performance_testing` + 2 domain + `tdd_workflow` `verification_loop` `eval_harness` `golang_testing` `python_testing` `cpp_testing` `springboot_tdd` `springboot_verification` `springboot_security` `django_security` `django_tdd` `django_verification` |
| **Ship (11)** | `infrastructure_as_code` `db_migrations` `website_launch` `ci_cd_pipeline` `legal_compliance` `seed_data` + 4 domain + `deployment_patterns` |
| **Alpha Ops (5)** | `error_tracking` `health_checks` `env_validation` `qa_playbook` `backup_strategy` |
| **Beta Ops (6)** | `product_analytics` `feedback_system` `email_templates` `error_boundaries` `rate_limiting` `feature_flags` |
| **Handoff (6)** | `api_reference` `feature_walkthrough` `doc_reorganize` `user_documentation` `disaster_recovery` `community_management` |
| **Maintenance (6)** | `ssot_update` `documentation_standards` `sop_standards` `wi_standards` `dependency_management` `continuous_learning` |
| **Toolkit (9)** | `video_research` `content_creation` `content_waterfall` `personal_brand` `ceo_brain` `ai_tool_orchestration` `strategic_compact` `iterative_retrieval` `cost_aware_llm_pipeline` |

### Agents (19)

Specialized AI subagents for automated workflows. See [agents/README.md](./agents/README.md).

| Agent | Model | Phase |
|-------|-------|-------|
| `planner` | Opus | 2-design, 3-build |
| `architect` | Opus | 2-design |
| `code-reviewer` | Sonnet | 3-build, 4-secure |
| `security-reviewer` | Opus | 4-secure |
| `tdd-guide` | Sonnet | 3-build, 4-secure |
| `build-error-resolver` | Sonnet | 3-build |
| `e2e-runner` | Sonnet | 4-secure |
| `doc-updater` | Haiku | 6-handoff |
| `refactor-cleaner` | Sonnet | 3-build, 7-maintenance |
| `database-reviewer` | Sonnet | 3-build |
| `go-reviewer` | Sonnet | 3-build |
| `go-build-resolver` | Sonnet | 3-build |
| `python-reviewer` | Sonnet | 3-build |

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
│   ├── 0-context/         #   7 skills
│   ├── 3-build/           #   50 skills
│   ├── 4-secure/          #   21 skills
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
├── workflows/             # 18 workflow definitions
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
