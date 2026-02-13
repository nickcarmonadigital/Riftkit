# AI Development Workflow Framework

> **A complete system for building software with AI coding assistants.**

Stop prompting from scratch every session. This framework gives you **22 reusable skills** and **9 documentation templates** that work with any AI coding tool (Claude, Cursor, Copilot, etc.).

---

## 🚀 Quick Start

1. **Clone/Download** this repo
2. **Copy** the `.agent` folder to your project root
3. **Start using skills** - just reference them in your AI prompts

```bash
# Example: Use the /1-brainstorm command
"/1-brainstorm: I want to build a user authentication system..."
```

👉 **[Read the full Getting Started guide](.agent/GETTING_STARTED.md)**
👉 **[View the Client Project Lifecycle Guide](CLIENT_LIFECYCLE_GUIDE.md)** - *Perfect for end-to-end client work*

---

## 📦 What's Included

### 11 Core Commands (Agentic Workflow)

These commands orchestrate the AI through a complete project lifecycle.

| Command | Description | Underlying Skills |
|---------|-------------|-------------------|
| `/0-context`| Start/Resume a session | project_context |
| `/1-brainstorm` | Planning a feature from vision doc | atomic_reverse_architecture, feature_braindump |
| `/2-design` | Architectural planning | atomic_reverse_architecture |
| `/3-build` | Implementing a planned feature | feature_architecture, code_changelog |
| `/4-secure` | Security or quality review | security_audit |
| `/5-ship` | Preparing for deployment | security_audit, website_launch |
| `/6-handoff` | Client Handoff (Exit Package) | gemini_handoff |
| `/7-maintenance` | Long-term maintenance | dependency_audit |
| `/debug` | Fixing bugs or issues | toolkit/debug.md |
| `/new-project` | Starting a brand new project | toolkit/new-project.md |
| `/post-task` | After completing ANY work | toolkit/post-task.md |

### 22 Skills (Reusable Workflows)

| Category | Skills |
|----------|--------|
| **Development** | `feature_braindump`, `feature_architecture`, `feature_walkthrough`, `bug_troubleshoot`, `claude_verification`, `gemini_handoff`, `new_project`, `project_context` |
| **Documentation** | `documentation_framework`, `sop_standards`, `wi_standards`, `schema_standards`, `ssot_structure`, `ssot_update` |
| **Security** | `security_audit` (OWASP, auth, AI risks, e-commerce, booking) |
| **Content** | `content_creation`, `video_research`, `content_cascade` |
| **Client Work** | `website_build`, `website_launch`, `client_discovery`, `proposal_generator` |

### 9 Documentation Templates

- Development workflow guides
- Project checklists
- Client proposal template
- Client discovery template
- AI context template
- Website build checklist
- And more...

---

## 🎯 Why This Framework?

### The Problem

Every time you start an AI coding session, you:

- Re-explain your project structure
- Repeat the same instructions
- Get inconsistent results
- Lose context between sessions

### The Solution

This framework gives you **standardized skills** that:

- ✅ Work the same way every time
- ✅ Follow proven workflows
- ✅ Include checklists so nothing gets missed
- ✅ Build documentation as you code

---

## 📁 Structure

```
your-project/
├── .agent/
│   ├── README.md
│   ├── GETTING_STARTED.md
│   ├── skills-index.md
│   ├── skills/
│   │   ├── feature_braindump/SKILL.md
│   │   ├── security_audit/SKILL.md
│   │   └── ... (22 skills)
│   └── docs/
│       ├── development-workflow.md
│       ├── proposal-template.md
│       └── ... (9 docs)
└── [your project files]
```

---

## 💡 Example Workflows

### Building a New Feature

```text
1. "Using feature_braindump: I want to add a booking system..."
   → AI creates structured spec

2. Build the feature with your AI assistant

3. "Using feature_architecture: Document what we just built"
   → AI creates architecture doc

4. "Using security_audit: Check this feature"
   → AI runs security checklist
```

### Fixing a Bug

```text
1. "Using bug_troubleshoot: The login form isn't submitting..."
   → AI asks structured questions

2. Fix the bug together

3. "Using project_context: Update with what we fixed"
   → Context stays current for next session
```

---

## 🎬 Learn More

**Watch the tutorials**: [Link to your YouTube channel]

This framework was created during live coding sessions where I build real projects from scratch. Watch the process, follow along, and use this framework to build your own.

---

## 🤝 Contributing

Found a bug? Want to add a skill? PRs welcome!

1. Fork the repo
2. Create your feature branch
3. Submit a pull request

---

## 📄 License

MIT License - Use freely in your projects. See [LICENSE](LICENSE) for details.

---

## ⭐ Support

If this framework helped you, consider:

- ⭐ Starring this repo
- 🎥 Subscribing to the [YouTube channel]
- 📣 Sharing with other developers

---

*Built with AI, for builders who use AI.*
