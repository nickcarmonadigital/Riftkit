# Getting Started

Get productive with this framework in **5 minutes**.

---

## Step 1: Add to Your Project

Copy the `.agent` folder to your project root:

```bash
# If you cloned this repo
cp -r .agent /path/to/your/project/

# Or just download and drag-drop
```

Your project should look like:

```
your-project/
├── .agent/           ← Add this
│   ├── skills/
│   └── docs/
├── src/
├── package.json
└── ...
```

---

## Step 2: Understand the Structure

### Skills (339 Reusable Workflows)

Each skill is a step-by-step instruction set:

```
.agent/skills/
├── 1-brainstorm/idea_to_spec/SKILL.md   ← Convert ideas to specs
├── 3-build/bug_troubleshoot/SKILL.md    ← Structured debugging
├── 4-secure/security_audit/SKILL.md     ← Security checklist
├── 4-secure/tdd_workflow/SKILL.md       ← Test-driven development
├── 3-build/golang_patterns/SKILL.md     ← Go best practices
└── ... (339 total, organized by lifecycle phase)
```

### Agents (19 AI Subagents)

Specialized agents that automate development tasks:

```
.agent/agents/
├── planner.md           ← Implementation planning (Opus)
├── code-reviewer.md     ← Automated code review (Sonnet)
├── security-reviewer.md ← Security analysis (Opus)
├── tdd-guide.md         ← Test-driven development (Sonnet)
└── ... (19 total)
```

### Commands (44 Slash Commands)

Invoke agents and workflows from Claude Code:

```
.agent/commands/
├── plan.md              ← /plan — Create implementation plan
├── tdd.md               ← /tdd — Test-driven development
├── code-review.md       ← /code-review — Automated review
├── build-fix.md         ← /build-fix — Fix build errors
└── ... (44 total)
```

### Rules (45 Coding Guidelines)

Always-follow rules organized by language:

```
.agent/rules/
├── common/              ← 9 language-agnostic rules
├── typescript/          ← 5 TypeScript rules
├── python/              ← 5 Python rules
├── golang/              ← 5 Go rules
├── swift/               ← 5 Swift rules
├── java/                ← 5 Java rules
└── rust/                ← 5 Rust rules
```

### Docs (70+ Templates & References)

Ready-to-use templates and reference guides:

```
.agent/docs/
├── 0-context/full-stack-developer-foundation.md  ← WHY everything matters
├── 0-context/enterprise-development-guide.md     ← Enterprise patterns
├── toolkit/token-optimization.md                 ← Token management
└── ... (70+ total)
```

---

## Step 3: Use Your First Skill

### Option A: Reference in Prompt

```
"I want to build a notification system. Use the idea_to_spec skill
to help me structure this idea."
```

### Option B: Read the Skill First (Recommended)

1. Open `.agent/skills/1-brainstorm/idea_to_spec/SKILL.md`
2. Read the trigger commands and process
3. Follow the steps with your AI

### Option C: Use Trigger Commands

Each skill has trigger commands. Examples:

| Skill | Trigger |
|-------|---------|
| `idea_to_spec` | "I have an idea for..." |
| `bug_troubleshoot` | "I have a bug where..." |
| `security_audit` | "Security audit for [feature]" |
| `git_workflow` | "Create a PR for..." |
| `project_context` | "Update the project context" |

---

## Step 4: Set Up Your First Session

For best results, start sessions with context:

```
"I'm working on [PROJECT NAME]. Here's the current state:

Tech Stack: React + NestJS + PostgreSQL
Current Feature: Building user dashboard
Status: Basic layout done, need to add charts

Use the project_context skill pattern to help me continue."
```

💡 **Pro Tip**: Create your own `ai-onboarding-template.md` using the template in docs. Paste it at the start of each session.

---

## Most Used Skills

### For Professional Developers

| When... | Use... |
|---------|--------|
| First day on a codebase | `codebase_navigation` |
| Starting a feature | `idea_to_spec` → `feature_architecture` |
| Writing code | `api_design`, `auth_implementation`, `error_handling` |
| Debugging | `bug_troubleshoot` |
| Committing / PRs | `git_workflow`, `code_review_response` |
| Before shipping | `security_audit`, `e2e_testing` |
| Setting up environments | `environment_setup`, `docker_development` |
| Database changes | `db_migrations`, `database_optimization` |
| After building | `feature_walkthrough`, `api_reference` |
| Improving code | `refactoring`, `observability` |

### For AI Agent Developers

| When... | Use... |
|---------|--------|
| Building an agent | `ai_agent_development`, `agent_memory_systems` |
| Multi-agent systems | `agent_communication_protocols`, `agent_conflict_resolution` |
| Managing agent fleet | `ai_agent_fleet_management`, `llm_provider_management` |
| Voice AI | `voice_ai_patterns`, `websocket_patterns` |
| Agent security | `ai_red_teaming`, `prompt_injection_hardening`, `nemo_guardrails` |
| Agent evaluation | `agent_evaluation_framework` |
| OpenClaw platform | `openclaw_platform_patterns` |
| Prompt management | `prompt_ops`, `prompt_engineering` |
| NVIDIA deployment | `nvidia_nim_deployment`, `edge_ai_deployment` |

### For Quant / Trading Developers

| When... | Use... |
|---------|--------|
| Strategy research | `quantitative_trading_strategies` |
| ML signals | `ml_trading_signals` |
| Validating strategy | `backtesting_methodology` |
| Risk management | `portfolio_risk_management` |
| HFT infrastructure | `hft_infrastructure` |

### For Solo Developers

| When... | Use... |
|---------|--------|
| Starting a feature | `idea_to_spec` |
| Debugging | `bug_troubleshoot` |
| Before shipping | `security_audit` |
| After building | `feature_walkthrough` |

### For Client Work

| When... | Use... |
|---------|--------|
| First call | `client_discovery` |
| Sending quote | `proposal_generator` |
| Building site | `website_build` |
| Going live | `website_launch` |

### For Content Creators

| When... | Use... |
|---------|--------|
| Researching | `video_research` |
| Writing scripts | `content_creation` |
| Repurposing | `content_waterfall` |

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                    SKILL QUICK REFERENCE                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  BUILDING                          DOCUMENTING                   │
│  ─────────                         ─────────────                 │
│  idea_to_spec                      feature_architecture          │
│  new_project                       feature_walkthrough           │
│  api_design                        api_reference                 │
│  auth_implementation               sop_standards                 │
│  error_handling                    schema_standards              │
│                                                                  │
│  FIXING & QUALITY                  SECURITY & TESTING            │
│  ─────────────────                 ───────────────────           │
│  bug_troubleshoot                  security_audit                │
│  refactoring                       e2e_testing                   │
│  code_review_response              unit_testing                  │
│                                                                  │
│  DEVOPS                            CONTENT                       │
│  ───────                           ─────────                     │
│  git_workflow                      content_creation              │
│  docker_development                video_research                │
│  environment_setup                 content_waterfall               │
│  db_migrations                                                   │
│  infrastructure_as_code                                          │
│                                                                  │
│  CLIENT WORK                       OBSERVABILITY                 │
│  ────────────                      ──────────────                │
│  client_discovery                  observability                 │
│  proposal_generator                database_optimization         │
│  website_build                     error_tracking                │
│  website_launch                    health_checks                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Install Globally (Optional)

To use agents, commands, rules, and hooks in **any** project:

```bash
# Run the install script
cd your-project/.agent
chmod +x install.sh
./install.sh
```

This copies agents, commands, rules, hooks, and scripts to `~/.claude/` for global access. You can also copy individual components:

```bash
# Just agents and commands
cp -r .agent/agents/*.md ~/.claude/agents/
cp -r .agent/commands/*.md ~/.claude/commands/
```

---

## Next Steps

1. ✅ Read [full-stack-developer-foundation.md](./docs/0-context/full-stack-developer-foundation.md) to understand the WHY
2. ✅ Explore the [skills-index.md](./skills-index.md) for the full list of 339 skills
3. ✅ Try `idea_to_spec` on your next feature idea
4. ✅ Try `/plan` and `/tdd` slash commands
5. ✅ Set up `project_context` for your codebase
6. ✅ Use `codebase_navigation` when joining an existing project
7. ✅ Run `security_audit` before your next deploy
8. ✅ Explore [agents](./agents/README.md) and [commands](./commands/README.md) for automation

---

---

## Need Help?

- 📖 Check the skill's SKILL.md for detailed instructions
- 🎥 Watch the tutorial video for that skill
- 💬 Open an issue on GitHub

---

*Happy building! 🚀*
