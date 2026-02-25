# AI Development System - Master Guide

**Your complete system for working with AI assistants on software development.**

---

## 📁 What You Have

### 2 Living Documents

| File | Purpose |
|------|---------|
| `0-context/ai-onboarding-starter-template.md` | Single source of truth - onboards any AI to your project |
| `0-context/master-workflow-guide.md` | This file - explains how everything works |

### 18 Workflows

| Workflow | Purpose |
|----------|---------|
| `/new-project` | Start a brand new project with proper structure |
| `/plan` | Architecture & planning using ARA methodology |
| `/design-review` | Review UI/UX before implementation |
| `/build` | Implement from approved plan |
| `/debug` | Structured troubleshooting |
| `/post-task` | Mandatory documentation after ANY work |
| `/ship` | Pre-deployment security & quality checks |
| `/launch` | Go-live checklist |
| `/audit` | Security/quality review |
| `/handoff` | Session end or AI handoff |

See `.agent/workflows/WORKFLOWS_README.md` for details.

### 13 Agents (Automated Subagents)

Specialized AI agents that automate development tasks. Each has an optimal model and tool set.

| Agent | Model | What It Does | Invoke Via |
|-------|-------|--------------|------------|
| `planner` | Opus | Creates detailed implementation plans | `/plan` |
| `architect` | Opus | Designs system architecture | `/plan` |
| `code-reviewer` | Sonnet | Automated code review with severity scoring | `/code-review` |
| `security-reviewer` | Opus | Deep security analysis | manual |
| `tdd-guide` | Sonnet | Test-driven development coaching | `/tdd` |
| `build-error-resolver` | Sonnet | Diagnoses and fixes build errors | `/build-fix` |
| `e2e-runner` | Sonnet | Executes end-to-end tests | `/e2e` |
| `doc-updater` | Haiku | Updates documentation | `/update-docs` |
| `refactor-cleaner` | Sonnet | Dead code removal, cleanup | `/refactor-clean` |
| `database-reviewer` | Sonnet | Database query and schema review | manual |
| `go-reviewer` | Sonnet | Go code review | `/go-review` |
| `go-build-resolver` | Sonnet | Go build error resolution | `/go-build` |
| `python-reviewer` | Sonnet | Python code review | `/python-review` |

See `.agent/agents/README.md` for full details.

### 32 Slash Commands

Commands for Claude Code automation — planning, testing, reviewing, learning, and multi-agent orchestration.

**Key Commands**: `/plan` `/tdd` `/code-review` `/build-fix` `/e2e` `/verify` `/checkpoint` `/eval` `/learn` `/evolve` `/orchestrate` `/multi-execute` `/refactor-clean` `/test-coverage` `/sessions`

See `.agent/commands/README.md` for the complete list.

### 25 Coding Rules

Always-follow guidelines organized by language:
- **Common** (9): coding-style, git-workflow, testing, performance, patterns, hooks, agents, security, development-workflow
- **TypeScript** (5) | **Python** (5) | **Go** (5) | **Swift** (5)

See `.agent/rules/README.md` for details.

### 9 Hooks & Automation Scripts

Event-driven automations: session lifecycle management, post-edit formatting/typechecking, console.log detection, compaction suggestions, and session evaluation.

See `.agent/hooks/README.md` for details.

### ~130 Skills

| Category | Skills |
|----------|--------|
| **Context (7)** | `new_project`, `project_context`, `documentation_framework`, `ssot_structure`, `codebase_navigation`, `search_first`, `project_guidelines` |
| **Brainstorm (9)** | `client_discovery`, `idea_to_spec`, `proposal_generator`, `smb_launchpad`, `prioritization_frameworks`, `user_story_standards`, `competitive_analysis`, `product_metrics`, `user_research` |
| **Design (4)** | `atomic_reverse_architecture`, `feature_architecture`, `deployment_modes`, `schema_standards` |
| **Build (50)** | `spec_build`, `bug_troubleshoot`, `website_build`, `observability`, `code_review`, `ui_polish`, `code_changelog`, `sprint_planning`, `stakeholder_communication`, `retrospective`, `cost_estimation`, `git_workflow`, `api_design`, `error_handling`, `auth_implementation`, `docker_development`, `environment_setup`, `refactoring`, `code_review_response`, `database_optimization`, `notification_systems` + 13 domain-specific + `backend_patterns`, `frontend_patterns`, `golang_patterns`, `python_patterns`, `cpp_coding_standards`, `java_coding_standards`, `jpa_patterns`, `springboot_patterns`, `django_patterns`, `swift_actor_persistence`, `swift_protocol_di_testing`, `swift_concurrency`, `liquid_glass_design`, `clickhouse_io`, `content_hash_cache`, `regex_vs_llm` |
| **Secure (21)** | `security_audit`, `e2e_testing`, `ip_protection`, `unit_testing`, `integration_testing`, `accessibility_testing`, `performance_testing` + 2 domain + `tdd_workflow`, `verification_loop`, `eval_harness`, `golang_testing`, `python_testing`, `cpp_testing`, `springboot_tdd`, `springboot_verification`, `springboot_security`, `django_security`, `django_tdd`, `django_verification` |
| **Ship (11)** | `infrastructure_as_code`, `db_migrations`, `website_launch`, `ci_cd_pipeline`, `legal_compliance`, `seed_data` + 4 domain + `deployment_patterns` |
| **Alpha Ops (5)** | `error_tracking`, `health_checks`, `env_validation`, `qa_playbook`, `backup_strategy` |
| **Beta Ops (6)** | `product_analytics`, `feedback_system`, `email_templates`, `error_boundaries`, `rate_limiting`, `feature_flags` |
| **Handoff (6)** | `api_reference`, `feature_walkthrough`, `doc_reorganize`, `user_documentation`, `disaster_recovery`, `community_management` |
| **Maintenance (6)** | `ssot_update`, `documentation_standards`, `sop_standards`, `wi_standards`, `dependency_management`, `continuous_learning` |
| **Toolkit (9)** | `video_research`, `content_creation`, `content_waterfall`, `personal_brand`, `ceo_brain`, `ai_tool_orchestration`, `strategic_compact`, `iterative_retrieval`, `cost_aware_llm_pipeline` |

See `.agent/skills-index.md` for full skill descriptions.

---

## 🎯 How Skills Are Automatically Detected

Your Builder AI automatically detects which skill to use based on **keywords** in your message:

| Your Message Contains | Skill / Command Used |
|----------------------|----------------------|
| "bug", "broken", "error", "not working", "fix" | `bug_troubleshoot` or `/build-fix` (agent) |
| "new feature", "add", "want to build", "brain dump" | `idea_to_spec` |
| "plan", "implementation plan", "design" | `/plan` (planner agent) |
| "API", "endpoint", "REST", "route" | `api_design` |
| "auth", "login", "JWT", "OAuth", "permissions" | `auth_implementation` |
| "branch", "commit", "PR", "merge", "rebase" | `git_workflow` |
| "Docker", "container", "compose", "deploy" | `docker_development` or `deployment_patterns` |
| "migration", "schema change", "add column" | `db_migrations` |
| "slow query", "index", "N+1", "optimize" | `database_optimization` (database-reviewer agent) |
| "test", "TDD", "red-green-refactor" | `/tdd` (tdd-guide agent) |
| "test", "Playwright", "e2e", "coverage" | `/e2e` (e2e-runner agent) or `unit_testing` |
| "review", "check this code" | `/code-review` (code-reviewer agent) |
| "security", "audit", "vulnerabilities" | `security_audit` (security-reviewer agent) |
| "refactor", "clean up", "tech debt", "dead code" | `/refactor-clean` (refactor-cleaner agent) |
| "setup", "environment", "ESLint", "config" | `environment_setup` |
| "new project", "starting fresh", "create new app" | `new_project` |
| "update context", "document what we did" | `project_context` |
| "navigate codebase", "understand this project" | `codebase_navigation` or `search_first` |
| "error handling", "exception", "error response" | `error_handling` |
| "monitoring", "logging", "metrics", "alerts" | `observability` |
| "Swagger", "API docs", "OpenAPI" | `api_reference` or `/update-docs` (doc-updater agent) |
| "Go", "golang", "go build" | `golang_patterns` or `/go-review` / `/go-build` |
| "Python", "django", "flask" | `python_patterns` or `/python-review` |
| "Spring Boot", "JPA", "Java" | `springboot_patterns` or `java_coding_standards` |
| "Swift", "SwiftUI", "concurrency" | `swift_concurrency` or `swift_actor_persistence` |
| "token", "context window", "cost" | `strategic_compact` or `cost_aware_llm_pipeline` |

**Pro tip**: To ensure a specific skill is used, reference it directly:
> "Using bug_troubleshoot skill: the login button is broken..."

---

## 🌐 Supported Project Types

This framework is **technology-agnostic** - it works for any software project:

### Web & Apps

| Project Type | Works? | Notes |
|--------------|--------|-------|
| Full-stack apps (React + API) | ✅ | What it was designed for |
| Static websites | ✅ | Simpler - no backend section |
| Marketing sites | ✅ | HTML/CSS/JS, maybe CMS |
| E-commerce | ✅ | Add Stripe/checkout sections |
| WordPress themes | ✅ | Adjust tech stack section |
| Mobile apps | ✅ | Change "pages" to "screens" |
| CLI tools | ✅ | No UI section, focus on commands |
| Desktop apps (Electron/Tauri) | ✅ | Add build/packaging sections |
| Chrome extensions | ✅ | Manifest + popup/content scripts |

### Games

| Platform | Engine | Works? | Notes |
|----------|--------|--------|-------|
| Mobile Games | Unity, Godot, Flutter | ✅ | Replace "pages" with "scenes/levels" |
| Steam/PC Games | Unity, Unreal, Godot | ✅ | Add build/export sections |
| Web Games | Phaser, Three.js | ✅ | Works like web apps |
| Console Games | Unity, Unreal | ✅ | Same workflow, different build targets |

### Trading & Finance

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| Trading Algorithms | Python, C++, Rust | ✅ | Backtesting + live execution modules |
| Trading Bots | Python, Node.js | ✅ | Exchange APIs, risk management |
| TradingView Indicators | Pine Script | ✅ | Script structure, study/strategy modes |
| MT4/MT5 Expert Advisors | MQL4/MQL5 | ✅ | EA structure, signal logic |
| DeFi Protocols | Solidity, Rust | ✅ | Smart contracts + frontend |
| Quantitative Research | Python, R, Julia | ✅ | Jupyter/notebooks workflow |

### Web3 & Blockchain

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| Custom Crypto Token | Solidity | ✅ | ERC-20, BEP-20 token contracts |
| NFT Collection | Solidity | ✅ | ERC-721/1155, minting, metadata |
| NFT Marketplace | Solidity + React | ✅ | Listings, auctions, royalties |
| dApp (Decentralized App) | Solidity + React | ✅ | Wallet connect, contract interaction |
| DAO | Solidity | ✅ | Governance, voting, treasury |
| DeFi Protocol | Solidity, Rust | ✅ | Lending, staking, AMM |
| Blockchain Explorer | Node.js, Python | ✅ | Index chain data, API |
| Wallet | React Native, Flutter | ✅ | Key management, transactions |
| Layer 2 Solutions | Rust, Go | ✅ | Rollups, bridges |
| Smart Contract Auditing | Foundry, Hardhat | ✅ | Testing, fuzzing, security |

### AI & Machine Learning

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| ML Model Training | Python | ✅ | PyTorch, TensorFlow, scikit-learn |
| AI Agent/Chatbot | Python, TypeScript | ✅ | LangChain, OpenAI, local LLMs |
| RAG Application | Python | ✅ | Vector DBs, embeddings |
| Fine-tuning Pipeline | Python | ✅ | LoRA, PEFT, custom datasets |
| Computer Vision | Python | ✅ | OpenCV, YOLO, image classification |
| Voice AI | Python | ✅ | STT, TTS, real-time audio |
| Recommendation System | Python | ✅ | Collaborative filtering, embeddings |
| Data Pipeline | Python, Spark | ✅ | ETL, feature engineering |

### Hardware & IoT

| Project Type | Platform | Works? | Notes |
|--------------|----------|--------|-------|
| Arduino Projects | C/C++ | ✅ | Sensors, actuators, serial |
| Raspberry Pi | Python, C++ | ✅ | GPIO, camera, automation |
| ESP32/ESP8266 | C++, MicroPython | ✅ | WiFi, BLE, sensors |
| Home Automation | Various | ✅ | Home Assistant, MQTT |
| Robotics | Python, C++ | ✅ | ROS, motor control |
| 3D Printer Firmware | C++ | ✅ | Marlin, Klipper configs |
| Drone/UAV | Python, C++ | ✅ | Flight controllers, mission planning |
| Wearables | C++, Swift | ✅ | Watch apps, fitness trackers |

### Automation & DevOps

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| Shell Scripts | Bash, PowerShell | ✅ | Automation, deployment |
| CI/CD Pipelines | YAML | ✅ | GitHub Actions, GitLab CI |
| Infrastructure as Code | HCL, YAML | ✅ | Terraform, Pulumi, Ansible |
| Kubernetes Configs | YAML, Go | ✅ | Helm charts, operators |
| Serverless Functions | Node.js, Python | ✅ | AWS Lambda, Cloudflare Workers |
| Monitoring Dashboards | Grafana, PromQL | ✅ | Metrics, alerts |

### Plugins & Extensions

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| VS Code Extensions | TypeScript | ✅ | Commands, views, language support |
| Chrome Extensions | JavaScript | ✅ | Popup, content scripts, background |
| Figma Plugins | TypeScript | ✅ | Design automation |
| WordPress Plugins | PHP | ✅ | Hooks, shortcodes, admin panels |
| Shopify Apps | Node.js, Ruby | ✅ | Store customization |
| Slack/Discord Bots | Node.js, Python | ✅ | Commands, webhooks, integrations |
| OBS Plugins | C++, Lua | ✅ | Streaming overlays, effects |
| VST/Audio Plugins | C++, JUCE | ✅ | DAW plugins, synthesizers |

### Data & Analytics

| Project Type | Languages | Works? | Notes |
|--------------|-----------|--------|-------|
| Data Dashboards | Python, SQL | ✅ | Streamlit, Dash, Metabase |
| ETL Pipelines | Python, SQL | ✅ | Airflow, dbt, data lakes |
| Reporting Systems | Python, JS | ✅ | PDF generation, charts |
| Scraping/Crawling | Python, Node.js | ✅ | BeautifulSoup, Puppeteer |
| Database Design | SQL | ✅ | Schema, migrations, optimization |

### Trading Dev Template Adaptation

For trading projects, replace "Frontend Pages" with:

```markdown
## Core Modules
| Module | Purpose | Status |
|--------|---------|--------|
| Data Feed | Market data ingestion | ✅ Working |
| Signal Engine | Entry/exit logic | ⚠️ Needs optimization |
| Risk Manager | Position sizing, stops | 🔜 Planned |
| Execution | Order placement | ✅ Working |
| Backtest | Historical simulation | ✅ Working |

## Strategies/Indicators
| Name | Type | Timeframe | Status |
|------|------|-----------|--------|
| RSI Divergence | Indicator | 4H | ✅ |
| MACD Crossover | Strategy | 1D | ⚠️ Drawdown too high |
| Volume Profile | Indicator | Any | 🔜 Planned |
```

### Web3 Dev Template Adaptation

For blockchain projects, replace "Frontend Pages" with:

```markdown
## Smart Contracts
| Contract | Purpose | Status |
|----------|---------|--------|
| Token.sol | ERC-20 token | ✅ Deployed |
| NFT.sol | ERC-721 collection | ⚠️ Testing |
| Staking.sol | Stake for rewards | 🔜 Planned |

## Frontend Integration
| Feature | Status |
|---------|--------|
| Wallet Connect | ✅ Working |
| Mint Function | ⚠️ Gas optimization needed |
| Dashboard | 🔜 Planned |
```

### Game Dev Template Adaptation

For games, replace "Frontend Pages" with:

```markdown
## Game Systems
| System | Purpose | Status |
|--------|---------|--------|
| Player Controller | Movement, input | ✅ Working |
| Combat System | Attacks, damage | ⚠️ Hitboxes broken |
| Inventory | Items, equipment | 🔜 Planned |

## Scenes/Levels
| Scene | Description | Status |
|-------|-------------|--------|
| MainMenu | Title screen | ✅ |
| Level_01 | Tutorial | ✅ |
| Level_02 | Dungeon | ⚠️ Boss AI buggy |
```

**The framework is about the workflow, not the technology.**

**If it's code, Antigravity can build it.** 🚀

---

## 📂 Folder Structure

```
your-project/
└── .agent/
    ├── install.sh             ← Global installer (copies to ~/.claude/)
    ├── agents/                ← 13 specialized AI subagents
    ├── commands/              ← 32 slash commands
    ├── rules/                 ← 25 coding rules (common + 4 languages)
    ├── hooks/                 ← Event-driven automations
    ├── contexts/              ← Dynamic system prompts (dev/review/research)
    ├── scripts/               ← Node.js utilities (hooks, CI, lib)
    ├── schemas/               ← JSON validation schemas
    ├── examples/              ← 6 CLAUDE.md project templates
    ├── mcp-configs/           ← MCP server integration configs
    ├── docs/
    │   ├── 0-context/             ← Start here (Onboarding & Guide)
    │   ├── 1-brainstorm/          ← Templates for planning
    │   ├── 2-design/              ← Standards & Guides
    │   ├── 3-build/               ← Checklists & Snippets
    │   ├── 4-secure/              ← Audit Reports
    │   ├── 5-ship/                ← Compliance & Launch
    │   ├── 6-handoff/             ← Manuals & Handbooks
    │   └── toolkit/               ← Protocols + Token Optimization
    ├── skills/
    │   ├── 0-context/             ← Project setup & context (7)
    │   ├── 1-brainstorm/          ← Requirements & Planning (9)
    │   ├── 2-design/              ← Architecture & Schemas (4)
    │   ├── 3-build/               ← Construction & Code (50)
    │   ├── 4-secure/              ← Verification & Security (21)
    │   ├── 5-ship/                ← Delivery (11)
    │   ├── 6-handoff/             ← Final Docs (6)
    │   ├── 7-maintenance/         ← Updates & Standards (6)
    │   └── toolkit/               ← Content, Growth & Optimization (9)
    └── workflows/             ← 18 workflow definitions
```

---

## 🔄 How It All Connects

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         THE MASTER WORKFLOW                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   📄 ai-onboarding-starter-template.md (Single Source of Truth)          │
│         │                                                                │
│         ├──→ Start new Review AI chat (Product Architect)                 │
│         ├──→ Start new Claude chat (Code Reviewer)                       │
│         └──→ Start new Builder chat (Cursor/Antigravity/etc)            │
│                                                                          │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                    THE BUILD LOOP                                │   │
│   │                                                                  │   │
│   │   You (Brain Dump / Idea)                                        │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   Spec (Structured using idea_to_spec)                           │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   Builder AI (Builds using spec_build / api_design)              │   │
│   │      │  🤖 /tdd (tdd-guide) · /build-fix (build-error-resolver) │   │
│   │      ▼                                                           │   │
│   │   Review (/code-review · /e2e · security-reviewer agent)         │   │
│   │      │  🤖 code-reviewer · e2e-runner · security-reviewer        │   │
│   │      ▼                                                           │   │
│   │   Builder AI (Fixes issues if any)                               │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   UPDATE ai-onboarding-starter-template.md (project_context)     │   │
│   │      │                                                           │   │
│   │      └──→ Loop back for next feature                             │   │
│   │                                                                  │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Scenario Examples

### Scenario 1: New Project

**Situation**: You have an idea for a completely new app.

**Steps**:

1. Brain dump your idea using `idea_to_spec`
2. AI outputs PRD + Tech Spec
3. Use `new_project` skill to set up repository
4. Fill in `ai-onboarding-starter-template.md` with project context
5. Start building features

**Skills Used**: `new_project`, `idea_to_spec`, `environment_setup`

---

### Scenario 2: Adding New Features

**Situation**: Project exists, you want to add a new feature.

**Steps**:

1. Brain dump feature idea using `idea_to_spec`
2. Design architecture with `feature_architecture`
3. Builder AI builds it using `spec_build` or `api_design`
4. Review code (`code_review`, `security_audit`)
5. Write tests (`unit_testing`, `e2e_testing`)
6. Fix any issues
7. Update your onboarding doc with new feature

**Skills Used**: `idea_to_spec`, `feature_architecture`, `spec_build`, `code_review`, `project_context`

---

### Scenario 3: Feature Not Working During Build

**Situation**: You're building a feature and it doesn't work as expected.

**Steps**:

1. Use `bug_troubleshoot` format:
   - EXPECTED: What should happen
   - ACTUAL: What's happening
   - STEPS: How to reproduce
   - ERRORS: Paste error messages
   - CHANGED: What changed recently
2. Builder AI diagnoses and fixes
3. Verify fix works
4. Continue building

**Skills Used**: `bug_troubleshoot`

---

### Scenario 4: Pre-Production Bug Fixing

**Situation**: Feature is built but has bugs before going live.

**Steps**:

1. Make list of all bugs found during testing
2. For each bug, use `bug_troubleshoot` format
3. Builder AI fixes each bug
4. Review fixes (`code_review`)
5. Verify fixes work
6. Update onboarding doc status

**Skills Used**: `bug_troubleshoot`, `code_review`, `project_context`

---

### Scenario 5: Production Bug (Live Users)

**Situation**: Users are actively using the app and experiencing a bug.

**Steps**:

1. **IMMEDIATE**: Assess impact (how many users affected?)
2. Use `bug_troubleshoot` with urgency flag:

   ```
   🚨 PRODUCTION BUG - LIVE USERS AFFECTED
   
   Impact: [X users affected, Y% of traffic]
   Severity: [Critical/High/Medium]
   
   [Then regular bug report format]
   ```

3. Builder AI creates minimal fix (hotfix first, cleanup later)
4. Quick review for security (`security_audit`)
5. Deploy hotfix immediately
6. Document incident

**Skills Used**: `bug_troubleshoot`, `security_audit`, `project_context`

---

### Scenario 6: Refactoring

**Situation**: Code works but is messy/duplicated.

**Steps**:

1. Identify what needs refactoring
2. Use `refactoring` skill to plan the change
3. Builder AI refactors with tests as safety net
4. Review refactored code (`code_review`)
5. Verify nothing broke
6. Update context if structure changed

**Skills Used**: `refactoring`, `code_review`, `project_context`

---

### Scenario 7: Security Audit

**Situation**: Proactive security review before launch.

**Steps**:

1. Use `security_audit` skill to review:
   - Auth implementation (`auth_implementation`)
   - Database security policies
   - Input validation
   - API permissions
2. Create list of findings
3. Builder AI fixes issues
4. Re-review with `code_review`
5. Run `e2e_testing` to verify fixes
6. Document in context

**Skills Used**: `security_audit`, `code_review`, `e2e_testing`, `documentation_framework`

---

## ⚡ Quick Reference

| I want to... | Use this skill / command... |
|--------------|----------------------------|
| Start new project | `new_project` + `environment_setup` |
| Navigate a new codebase | `codebase_navigation` or `search_first` |
| Plan an implementation | `/plan` (planner + architect agents) |
| Add a feature | `idea_to_spec` → `feature_architecture` → `spec_build` |
| Design an API | `api_design` |
| Implement auth | `auth_implementation` |
| Fix a bug | `bug_troubleshoot` or `/build-fix` (agent) |
| Handle errors properly | `error_handling` |
| Review code | `/code-review` (code-reviewer agent) |
| Respond to a code review | `code_review_response` |
| Write tests (TDD) | `/tdd` (tdd-guide agent) |
| Run E2E tests | `/e2e` (e2e-runner agent) |
| Write unit tests | `unit_testing` |
| Set up Docker | `docker_development` + `deployment_patterns` |
| Run a database migration | `db_migrations` |
| Optimize queries | `database_optimization` (database-reviewer agent) |
| Refactor / clean up code | `/refactor-clean` (refactor-cleaner agent) |
| Set up monitoring | `observability` |
| Work with Git / PRs | `git_workflow` |
| Security review | `security_audit` (security-reviewer agent) |
| Deploy to production | `infrastructure_as_code` + `ci_cd_pipeline` |
| Document an API | `api_reference` or `/update-docs` (doc-updater agent) |
| Update docs after changes | `project_context` |
| Review Go code | `/go-review` (go-reviewer agent) |
| Review Python code | `/python-review` (python-reviewer agent) |
| Multi-agent workflow | `/orchestrate` or `/multi-execute` |
| Manage context window | `strategic_compact` or `/checkpoint` |
| Optimize token costs | `cost_aware_llm_pipeline` |
| Learn from session | `/learn` → `/evolve` |
| Start new AI session | Copy from your onboarding doc |

---

## 🚀 The Golden Rule

**After EVERY change (feature or fix), update your onboarding document.**

Say to your Builder AI:
> "Please update the project context with what we just did."

This keeps your single source of truth current for the next session.
