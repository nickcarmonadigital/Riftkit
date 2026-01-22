# AI Development Workflow Framework

> **22 Skills** | **19 Docs** | **Zero Fluff**

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

### Skills (22)

| Category | Skills |
|----------|--------|
| **Development** | `bug_troubleshoot` `claude_verification` `feature_braindump` `feature_architecture` `feature_walkthrough` `gemini_handoff` `new_project` `project_context` |
| **Documentation** | `documentation_framework` `sop_standards` `wi_standards` `schema_standards` `ssot_structure` `ssot_update` |
| **Security** | `security_audit` |
| **Content** | `content_creation` `video_research` `content_cascade` |
| **Client Work** | `website_build` `website_launch` `client_discovery` `proposal_generator` |

→ Full reference: [docs/skills-index.md](./docs/skills-index.md)

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
├── skills/                # 22 skill folders
│   ├── bug_troubleshoot/
│   ├── feature_braindump/
│   └── ...
└── docs/                  # 19 reference guides
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
