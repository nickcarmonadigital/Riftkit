# AI Development Workflow Framework

> **100 Skills** | **67 Docs** | **18 Workflows** | **9 Blueprint Categories** | **Zero Fluff**

A battle-tested toolkit for AI-assisted development. Drop the `.agent` folder into any project and supercharge your workflow.

---

## ⚡ Quick Start

```bash
# Clone and copy to your project
git clone https://github.com/YOUR_USERNAME/ai-dev-workflow-framework.git
cp -r ai-dev-workflow-framework/.agent ./your-project/
```

Your AI assistant will automatically detect and use these skills.

📖 **New here?** Start with [GETTING_STARTED.md](./GETTING_STARTED.md)

---

## 📚 What's Included

### Skills (100)

| Category | Skills |
|----------|--------|
| **Context (5)** | `new_project` `project_context` `documentation_framework` `ssot_structure` `codebase_navigation` |
| **Brainstorm (9)** | `client_discovery` `idea_to_spec` `proposal_generator` `smb_launchpad` `prioritization_frameworks` `user_story_standards` `competitive_analysis` `product_metrics` `user_research` |
| **Design (4)** | `atomic_reverse_architecture` `feature_architecture` `deployment_modes` `schema_standards` |
| **Build (34)** | `spec_build` `bug_troubleshoot` `website_build` `observability` `code_review` `ui_polish` `code_changelog` `sprint_planning` `stakeholder_communication` `retrospective` `cost_estimation` `git_workflow` `api_design` `error_handling` `auth_implementation` `docker_development` `environment_setup` `refactoring` `code_review_response` `database_optimization` `notification_systems` + 11 domain-specific |
| **Secure (9)** | `security_audit` `e2e_testing` `ip_protection` `unit_testing` `integration_testing` `accessibility_testing` `performance_testing` + 2 domain |
| **Ship (10)** | `infrastructure_as_code` `db_migrations` `website_launch` `ci_cd_pipeline` `legal_compliance` `seed_data` + 4 domain |
| **Alpha Ops (5)** | `error_tracking` `health_checks` `env_validation` `qa_playbook` `backup_strategy` |
| **Beta Ops (6)** | `product_analytics` `feedback_system` `email_templates` `error_boundaries` `rate_limiting` `feature_flags` |
| **Handoff (6)** | `api_reference` `feature_walkthrough` `doc_reorganize` `user_documentation` `disaster_recovery` `community_management` |
| **Maintenance (5)** | `ssot_update` `documentation_standards` `sop_standards` `wi_standards` `dependency_management` |
| **Toolkit (6)** | `video_research` `content_creation` `content_waterfall` `personal_brand` `ceo_brain` `ai_tool_orchestration` |

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
├── skills/                # 100 skill folders (organized by phase)
│   ├── bug_troubleshoot/
│   ├── git_workflow/
│   └── ...
├── workflows/             # 18 workflow definitions
└── docs/                  # 67 reference guides + templates
    ├── prompt-library.md
    ├── code-snippets.md
    └── ...
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
