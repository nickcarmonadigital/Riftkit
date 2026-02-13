# AI Development System - Master Guide

**Your complete system for working with AI assistants on software development.**

---

## 📁 What You Have

### 2 Living Documents

| File | Purpose |
|------|---------|
| File | Purpose |
|------|---------|
| `0-context/ai-onboarding-starter-template.md` | Single source of truth - onboards any AI to your project |
| `0-context/master-workflow-guide.md` | This file - explains how everything works |

### 11 Workflows (NEW!)

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

See `.agent/workflows/README.md` for details.

### 26 Skills

| Category | Skills |
|----------|--------|
| **Core Development** | `new_project`, `feature_braindump`, `feature_architecture`, `bug_troubleshoot` |
| **Documentation** | `project_context`, `feature_walkthrough`, `code_changelog`, `documentation_framework` |
| **Quality** | `security_audit`, `claude_verification`, `schema_standards` |
| **Planning** | `atomic_reverse_architecture`, `gemini_handoff` |
| **Operations** | `sop_standards`, `wi_standards`, `ssot_structure`, `ssot_update` |
| **Specialized** | `website_build`, `website_launch`, `content_creation`, `video_research`, `ip_protection` |
| **Business** | `client_discovery`, `proposal_generator`, `doc_reorganize`, `content_cascade` |

See `.agent/skills-index.md` for full skill descriptions.

---

## 🎯 How Skills Are Automatically Detected

Your Builder AI automatically detects which skill to use based on **keywords** in your message:

| Your Message Contains | Skill Used |
|----------------------|------------|
| "bug", "broken", "error", "not working", "fix" | `bug_troubleshoot` |
| "new feature", "add", "want to build", "brain dump" | `feature_braindump` |
| "from Gemini", "structured spec", "here's the PRD" | `gemini_handoff` |
| "review", "check this code", "security" | `claude_verification` |
| "new project", "starting fresh", "create new app" | `new_project` |
| "update context", "document what we did" | `project_context` |

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
    ├── docs/
    │   ├── 0-context/             ← Start here (Onboarding & Guide)
    │   ├── 1-brainstorm/          ← Templates for planning
    │   ├── 2-design/              ← Standards & Guides
    │   ├── 3-build/               ← Checklists & Snippets
    │   ├── 4-secure/              ← Audit Reports
    │   ├── 5-ship/                ← Compliance & Launch
    │   ├── 6-handoff/             ← Manuals & Handbooks
    │   └── toolkit/               ← Protocols
    └── skills/
        ├── 0-context/             ← Project setup & context
        ├── 1-brainstorm/          ← Requirements & Planning
        ├── 2-design/              ← Architecture & Schemas
        ├── 3-build/               ← Construction & Code
        ├── 4-secure/              ← Verification & Security
        ├── 5-ship/                ← Delivery
        ├── 6-handoff/             ← Final Docs
        ├── 7-maintenance/         ← Updates & Standards
        └── toolkit/               ← Content & Growth
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
│         ├──→ Start new Gemini chat (Product Architect)                   │
│         ├──→ Start new Claude chat (Code Reviewer)                       │
│         └──→ Start new Builder chat (Cursor/Antigravity/etc)            │
│                                                                          │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                    THE BUILD LOOP                                │   │
│   │                                                                  │   │
│   │   You (Brain Dump)                                               │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   Gemini (Structures using gemini_handoff)                       │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   Builder AI (Builds using feature_braindump)                    │   │
│   │      │                                                           │   │
│   │      ▼                                                           │   │
│   │   Claude (Reviews using claude_verification)                     │   │
│   │      │                                                           │   │
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

1. Brain dump your idea into Gemini
2. Gemini outputs PRD + Tech Spec
3. Use `new_project` skill to set up repository
4. Fill in `ai-onboarding-starter-template.md` with project context
5. Start building features

**Skills Used**: `new_project`, `gemini_handoff`

---

### Scenario 2: Adding New Features

**Situation**: Project exists, you want to add a new feature.

**Steps**:

1. Brain dump feature idea to Gemini (or directly to builder AI)
2. If Gemini: Use `gemini_handoff` format
3. If direct: Use `feature_braindump` format
4. Builder AI builds it
5. Claude reviews code (`claude_verification`)
6. Fix any issues
7. Update your onboarding doc with new feature

**Skills Used**: `feature_braindump`, `gemini_handoff`, `claude_verification`, `project_context`

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
4. Claude reviews fixes (`claude_verification`)
5. Verify fixes work
6. Update onboarding doc status

**Skills Used**: `bug_troubleshoot`, `claude_verification`, `project_context`

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
4. Quick Claude review for security
5. Deploy hotfix immediately
6. Document incident

**Skills Used**: `bug_troubleshoot`, `claude_verification`, `project_context`

---

### Scenario 6: Refactoring

**Situation**: Code works but is messy/duplicated.

**Steps**:

1. Identify what needs refactoring
2. Tell Builder AI: "Refactor [X] to [goal]"
3. Claude reviews refactored code
4. Verify nothing broke
5. Update context if structure changed

**Skills Used**: `claude_verification`, `project_context`

---

### Scenario 7: Security Audit

**Situation**: Proactive security review before launch.

**Steps**:

1. Ask Claude to review:
   - Auth implementation
   - Database security policies
   - Input validation
   - API permissions
2. Create list of findings
3. Builder AI fixes issues
4. Claude re-reviews
5. Document in context

**Skills Used**: `claude_verification`, `documentation_framework`

---

## ⚡ Quick Reference

| I want to... | Use this skill... |
|--------------|-------------------|
| Start new project | `new_project` |
| Add a feature | `feature_braindump` or `gemini_handoff` |
| Fix a bug | `bug_troubleshoot` |
| Review code | `claude_verification` |
| Update docs after changes | `project_context` |
| Find doc templates | `documentation_framework` |
| Start new AI session | Copy from your onboarding doc |

---

## 🚀 The Golden Rule

**After EVERY change (feature or fix), update your onboarding document.**

Say to your Builder AI:
> "Please update the project context with what we just did."

This keeps your single source of truth current for the next session.
