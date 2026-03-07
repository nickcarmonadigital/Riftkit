# Discoverability Solution: Implementation Guide

**Status:** READY TO IMPLEMENT
**Priority:** P0 — Framework useless without this
**Effort:** 2-3 days (templates + scripts)

---

## What This Document Contains

1. **Problem Statement** — Why 228 skills are undiscoverable
2. **Root Causes** — 6 specific failures in current design
3. **Solution Design** — 4-part architecture with examples
4. **Implementation Checklist** — Step-by-step build plan
5. **File Templates** — Copy-paste ready CLAUDE.md, router agent, etc.
6. **Success Metrics** — How to measure improvement

---

## EXECUTIVE SUMMARY

**The Problem:**
- Framework has 228 skills, 13 agents, 32 commands
- When dropped into a project, Claude Code doesn't discover any of it
- Users manually search README, skills-index.md, docs
- Only 4 commands mentioned in example CLAUDE.md
- No routing logic from user intent → skill

**The Root Cause:**
Claude Code loads `.agent/CLAUDE.md` if it exists, but project CLAUDE.md files are designed for project rules (style, patterns, commands), not framework routing. There's a gap between framework discovery and project configuration.

**The Solution:**
Create 4 new files that work together:
1. **`.agent/CLAUDE.md`** — Framework router (auto-loads, ~300 lines)
2. **`.agent/trigger-index.json`** — Intent→skill mapping (machine-readable)
3. **`.agent/skills-by-phase.md`** — Loadable 10-25 skills per phase
4. **`.agent/agents/router.md`** — Lightweight dispatcher agent

These files:
- Auto-load at session start (CLAUDE.md)
- Guide users to appropriate skills (phase detection)
- Keep context budget reasonable (phase-aware loading)
- Respect existing commands (`/plan`, `/code-review`, etc.)

**Result:** Framework skills discoverable, usable, and contextual on day 1.

---

## ROOT CAUSES (Detailed)

### Root Cause #1: No Framework CLAUDE.md
**Current state:** Example CLAUDE.md files exist (6 templates) but are project-specific.
- Focus: project rules, code style, file structure
- Commands mentioned: 4 (`/tdd`, `/plan`, `/code-review`, `/build-fix`)
- Skills mentioned: 0
- Routing logic: 0

**Why it matters:** When a user copies `.agent/` into their project, CLAUDE.md doesn't load because they use their own project CLAUDE.md. Framework CLAUDE.md never gets read.

**Solution:** Create `.agent/CLAUDE.md` that:
- Loads automatically (system constraint: framework folders auto-load)
- Explicitly advertises phase-aware dispatch
- Lists trigger keywords for each phase
- Explains how to load skills by phase

### Root Cause #2: No Intent→Skill Mapping
**Current state:** `skills-index.md` is reference documentation (280 lines).
- One table per phase
- No keyword grouping
- No "when to use" logic
- Human must manually read, find, then mention skill by name

**Why it matters:** AI doesn't know "I have a database performance problem" → `database_optimization` + `query_performance` + `observability`.

**Solution:** Create `trigger-index.json` with:
```json
{
  "triggers": [
    {
      "keywords": ["database", "query", "slow", "performance", "optimize"],
      "phase": 3,
      "primary_skill": "database_optimization",
      "related": ["observability", "code_review"],
      "command": "/build-fix"
    }
  ]
}
```

Machine-readable, AI can match keywords, suggests related skills.

### Root Cause #3: Phase-Agnostic Skills Registry
**Current state:** 228 skills in nested directories:
```
.agent/skills/3-build/api_design/SKILL.md
              ↓ 5 levels deep
```

Claude Code limitation: Doesn't recursively discover deeply nested files. You must explicitly reference them.

**Why it matters:** User can't ask "Load Phase 3 build skills" and get a readable list. They must manually navigate directory tree or read skills-index.md.

**Solution:** Create `skills-by-phase.md`:
```markdown
# Phase 3: Build Skills (50 total)

## Core Build (7)
| Skill | Trigger | Load |
|-------|---------|------|
| spec_build | "Build [feature]" | [Open](../skills/3-build/spec_build/SKILL.md) |
| tdd_workflow | "TDD for [feature]" | [Open](../skills/3-build/tdd_workflow/SKILL.md) |
...

## Language-Specific (16)
...

**Load:** Ask AI "Load Phase 3 build skills" → See this page
```

One file per phase, loadable in context, links to full skills.

### Root Cause #4: No Phase Detection Logic
**Current state:** Framework assumes user knows what phase they're in and asks for skill by name.

**Why it matters:** User says "I need to fix a bug" → which phase? 3 (Build) or 4 (Secure)? Which skill? `bug_troubleshoot`, `code_review`, `refactoring`? Framework doesn't guide.

**Solution:** Create `router.md` agent that:
1. Analyzes user prompt for phase signals
2. Extracts intent (debugging, testing, deploying, etc.)
3. Matches to trigger-index.json
4. Suggests primary + related skills
5. Loads on user request

Example flow:
```
User: "I have a bug in the payment flow"
Router: Phase 3 (Build), intent: debugging
        Primary: bug_troubleshoot
        Related: code_review, refactoring, testing
        Load: bug_troubleshoot? (yes/load related/see all Phase 3)
```

### Root Cause #5: No Context Budget Management
**Current state:** Framework doesn't talk about context size.
- Could theoretically load all 228 skills
- Would explode token budget (228 * 200 lines = 46K lines)
- No phase-aware loading strategy

**Why it matters:** Without planning, AI either:
1. Tries to load everything → token explosion
2. Loads nothing → no skills available
3. Asks user to specify → discoverability fails

**Solution:** Explicit phase-aware loading:
- Framework CLAUDE.md always loaded (~300 lines)
- One skill at a time (100-300 lines) on demand
- Phase registry available (20-50 lines) if user wants to browse
- Never load entire skills directory

### Root Cause #6: Skills Buried in Deep Nesting
**Current state:** Skills live 5 levels deep:
```
.agent/skills/3-build/api_design/SKILL.md
     1    2     3       4          5
```

**Why it matters:** Claude Code doesn't auto-traverse nested directories. Reference must be explicit. Deep nesting prevents discovery.

**Solution:** Keep directory structure (good organization) but add:
- Direct links in CLAUDE.md (clickable reference)
- `trigger-index.json` with full paths
- `skills-by-phase.md` with markdown links
- Clear "how to load" instructions

---

## SOLUTION ARCHITECTURE

### Part 1: Framework CLAUDE.md

**File:** `.agent/CLAUDE.md` (NEW, replaces generic docs)

**Purpose:**
- Auto-loaded at session start
- Explains framework in 5 minutes
- Shows phase workflow
- Lists commands
- Provides trigger keywords for each phase
- Explains how to load skills

**Key Properties:**
- ~300 lines (fits in context permanently)
- Clear structure (phase headers, tables)
- Clickable links to skills-by-phase.md
- Examples of trigger commands

**Template:**

```markdown
# AI Development Workflow Framework

> **228 Skills** | **13 Agents** | **32 Commands** | **18 Workflows** | **Zero Manual Setup**

This framework automatically loads this file at session start. It contains everything you need to discover and use the right skill at the right time.

---

## Quick Commands

Invoke these commands anytime:

| Command | What It Does |
|---------|--------------|
| `/plan` | Create implementation plan |
| `/tdd` | Test-driven development |
| `/code-review` | Review code quality |
| `/build-fix` | Fix build errors |
| `/e2e` | End-to-end tests |
| `/verify` | Verification loop |
| `/refactor-clean` | Remove dead code |

See [complete command list](#all-commands) below.

---

## 🎯 PHASE-AWARE SKILL DISPATCH

Every project follows the same lifecycle: **Context → Brainstorm → Design → Build → Secure → Ship → Handoff → Maintain**.

**Your job:** Find what phase you're in, then ask for a skill.

### Phase 0: Context (Understanding the Project)

**When:** First session, joining existing codebase, onboarding to project

**Trigger Keywords:** "understand", "navigate", "explore", "recover", "architecture", "health", "audit", "context"

**Start here:**
- `new_project` — Starting greenfield
- `codebase_navigation` — Joining existing code
- `architecture_recovery` — No docs exist
- `project_context` — Set up AI context

[Load Phase 0 Skills](./skills-by-phase.md#phase-0-context)

---

### Phase 1: Brainstorm (Turning Ideas into Specs)

**When:** New feature idea, client meeting, competitive analysis, prioritization

**Trigger Keywords:** "feature", "idea", "spec", "requirement", "discovery", "client", "proposal", "user story", "market"

**Start here:**
- `idea_to_spec` — Transform brain dump to spec
- `client_discovery` — Client intake
- `proposal_generator` — Scoped proposal
- `user_story_standards` — Write user stories

[Load Phase 1 Skills](./skills-by-phase.md#phase-1-brainstorm)

---

### Phase 2: Design (Architecture & Data Modeling)

**When:** Before building, designing system, schema, API, deployment

**Trigger Keywords:** "architecture", "design", "schema", "database", "api contract", "deployment", "c4", "diagram"

**Start here:**
- `atomic_reverse_architecture` — Decompose feature
- `feature_architecture` — System design
- `schema_standards` — Data model
- `api_contract_design` — API design

[Load Phase 2 Skills](./skills-by-phase.md#phase-2-design)

---

### Phase 3: Build (Implementation & Coding)

**When:** Writing code, debugging, refactoring, observability, code review

**Trigger Keywords:** "build", "code", "implement", "debug", "bug", "error", "refactor", "observability", "api design", "auth"

**Most Used Skills (Pick One):**
1. `spec_build` — Master build orchestrator (12-phase)
2. `bug_troubleshoot` — Systematic debugging
3. `code_review` — Automated review
4. `tdd_workflow` — Test-first development
5. `refactoring` — Safe refactoring
6. `observability` — Monitoring + logging

**Language/Framework Specific:**
- `golang_patterns`, `python_patterns`, `springboot_patterns`, `django_patterns`, `swift_*` (3 skills)
- `backend_patterns`, `frontend_patterns`

[Load Phase 3 Skills](./skills-by-phase.md#phase-3-build)

---

### Phase 4: Secure (Testing & Security)

**When:** Before shipping, security audit, comprehensive testing, vulnerability scan

**Trigger Keywords:** "test", "security", "audit", "vulnerability", "coverage", "e2e", "performance", "accessibility", "owasp"

**Start here:**
1. `security_audit` — OWASP Top 10
2. `unit_testing` — Jest/Vitest patterns
3. `e2e_testing` — Playwright/Cypress
4. `performance_testing` — Load testing
5. `accessibility_testing` — WCAG compliance

[Load Phase 4 Skills](./skills-by-phase.md#phase-4-secure)

---

### Phase 5: Ship (Deployment & Launch)

**When:** Going to production, migrations, CI/CD, legal, compliance

**Trigger Keywords:** "deploy", "ship", "launch", "migration", "ci/cd", "infrastructure", "legal", "compliance", "seed data"

**Start here:**
1. `db_migrations` — Safe schema changes
2. `ci_cd_pipeline` — GitHub Actions
3. `infrastructure_as_code` — Docker/Terraform
4. `deployment_patterns` — Blue-green, canary
5. `legal_compliance` — ToS, Privacy, GDPR

[Load Phase 5 Skills](./skills-by-phase.md#phase-5-ship)

---

### Phase 5.5: Alpha (Early Release Ops)

**When:** Limited release, monitoring, error tracking, health checks

[Load Phase 5.5 Skills](./skills-by-phase.md#phase-55-alpha)

---

### Phase 5.75: Beta (Broader Release Ops)

**When:** Product analytics, feedback, feature flags, rate limiting

[Load Phase 5.75 Skills](./skills-by-phase.md#phase-575-beta)

---

### Phase 6: Handoff (Documentation & Knowledge Transfer)

**When:** Feature complete, documenting, API reference, runbooks

**Trigger Keywords:** "document", "api reference", "walkthrough", "runbook", "disaster recovery", "handoff"

**Start here:**
1. `feature_walkthrough` — How-to guide
2. `api_reference` — API documentation
3. `user_documentation` — End-user docs
4. `disaster_recovery` — Runbooks

[Load Phase 6 Skills](./skills-by-phase.md#phase-6-handoff)

---

### Phase 7: Maintenance (Long-Term Operations)

**When:** Monitoring, dependency updates, technical debt, continuous learning

**Trigger Keywords:** "maintain", "update", "dependency", "debt", "incident", "reliability", "learning"

**Start here:**
1. `ssot_update` — Single source of truth
2. `documentation_standards` — Keep docs fresh
3. `dependency_management` — Version updates
4. `continuous_learning` — Lessons learned

[Load Phase 7 Skills](./skills-by-phase.md#phase-7-maintenance)

---

## 🔍 Skill Quick Lookup (By Keyword)

Can't remember which skill? Search by keyword:

| Keyword | Skills |
|---------|--------|
| **API** | api_design, api_contract_design, api_reference, authorization_patterns |
| **Auth** | auth_implementation, authorization_patterns, security_audit |
| **Database** | schema_standards, database_optimization, db_migrations, data_warehouse |
| **Bug/Debug** | bug_troubleshoot, code_review, refactoring, observability |
| **Testing** | unit_testing, e2e_testing, integration_testing, tdd_workflow, accessibility_testing |
| **Deploy** | ci_cd_pipeline, infrastructure_as_code, db_migrations, deployment_patterns |
| **Docs** | feature_walkthrough, api_reference, user_documentation, documentation_standards |
| **Frontend** | ui_polish, frontend_patterns, error_boundaries, accessibility_testing |
| **Backend** | backend_patterns, error_handling, notification_systems, database_optimization |
| **DevOps** | docker_development, infrastructure_as_code, ci_cd_pipeline, environment_setup |
| **Security** | security_audit, ip_protection, auth_implementation, legal_compliance |

---

## 📚 Load by Phase

Ask the AI to load a phase:

```
"Load Phase 3 Build skills"
"Show me Phase 4 Secure skills"
"What's in Phase 5 Ship?"
```

The AI will show you a list of 15-25 relevant skills for that phase, with descriptions and links.

---

## 🚀 Typical Workflows

### New Feature from Scratch
1. Load Phase 0: `project_context`
2. Load Phase 1: `idea_to_spec`
3. Load Phase 2: `atomic_reverse_architecture`
4. Load Phase 3: `spec_build`
5. Load Phase 4: `security_audit` + `e2e_testing`
6. Load Phase 5: `db_migrations` + `ci_cd_pipeline`

### Bug Fix (In-Progress Project)
1. Load Phase 3: `bug_troubleshoot`
2. Load Phase 3: `code_review`
3. Load Phase 4: `unit_testing`
4. Load Phase 5: `ci_cd_pipeline` (if deploying)

### Joining Existing Codebase
1. Load Phase 0: `codebase_navigation`
2. Load Phase 0: `architecture_recovery`
3. Load Phase 0: `tech_debt_assessment`
4. Load Phase 0: `codebase_health_audit`

---

## 🤖 All Commands

### Planning & Architecture
- `/plan` — Create implementation plan
- `/multi-plan` — Complex feature planning
- `/orchestrate` — Multi-agent workflows

### Development
- `/tdd` — Test-driven development
- `/build-fix` — Build error resolution
- `/go-build` — Go errors
- `/go-review` — Go code review
- `/python-review` — Python code review
- `/refactor-clean` — Dead code removal

### Testing & Quality
- `/code-review` — Code review
- `/e2e` — End-to-end tests
- `/verify` — Verification loop
- `/test-coverage` — Coverage analysis
- `/eval` — Evaluation harness

### Multi-Agent
- `/multi-execute` — Multi-agent execution
- `/multi-workflow` — Multi-agent workflow
- `/multi-backend` — Backend development
- `/multi-frontend` — Frontend development

### Learning & Evolution
- `/learn` — Extract patterns
- `/learn-eval` — Evaluate patterns
- `/evolve` — Evolve instincts
- `/skill-create` — Create new skills

### Documentation
- `/update-docs` — Update documentation
- `/update-codemaps` — Code maps
- `/checkpoint` — Session checkpoint

---

## 🔗 Full References

- **Skills Index (All 228):** [skills-index.md](./skills-index.md)
- **Skills by Phase (Loadable):** [skills-by-phase.md](./skills-by-phase.md)
- **Full Lifecycle Map:** [../MASTER-LIFECYCLE.md](../MASTER-LIFECYCLE.md)
- **Getting Started:** [./GETTING_STARTED.md](./GETTING_STARTED.md)

---

## 💡 Pro Tips

1. **Always start with context** (Phase 0) — AI needs to understand the project
2. **Use `/plan` for complex features** — Creates implementation roadmap
3. **Use `/tdd` for every code change** — Prevents bugs
4. **Use `/code-review` before commit** — Catches issues
5. **Load skills by phase** — Keeps context focused
6. **Bookmark skills-by-phase.md** — Quick reference when uncertain

---

**Questions?** Read the full MASTER-LIFECYCLE.md or GETTING_STARTED.md.

**Want to contribute?** Add new skills to `.agent/skills/[phase]/[skill-name]/SKILL.md`.
```

---

### Part 2: Trigger Index (trigger-index.json)

**File:** `.agent/trigger-index.json` (NEW)

**Purpose:** Machine-readable mapping of user intent → skill

**Format:**
```json
{
  "version": "1.0",
  "triggers": [
    {
      "id": "context-new-project",
      "keywords": ["new project", "start new", "greenfield", "scaffold"],
      "phase": 0,
      "primary_skill": "new_project",
      "related": ["project_context", "project_guidelines"],
      "command": "/plan",
      "description": "Starting a brand new project from scratch",
      "load": {
        "path": "./skills/0-context/new_project/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "build-debug",
      "keywords": ["bug", "broken", "error", "not working", "debug", "troubleshoot"],
      "phase": 3,
      "primary_skill": "bug_troubleshoot",
      "related": ["code_review", "refactoring", "unit_testing"],
      "command": "/build-fix",
      "description": "Something is broken and needs systematic debugging",
      "load": {
        "path": "./skills/3-build/bug_troubleshoot/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "build-api",
      "keywords": ["api", "endpoint", "rest", "http", "request", "response"],
      "phase": 3,
      "primary_skill": "api_design",
      "related": ["api_contract_design", "error_handling", "auth_implementation"],
      "command": "/plan",
      "description": "Designing or implementing API endpoints",
      "load": {
        "path": "./skills/3-build/api_design/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "secure-audit",
      "keywords": ["security", "vulnerability", "audit", "owasp", "exploit", "injection"],
      "phase": 4,
      "primary_skill": "security_audit",
      "related": ["e2e_testing", "ip_protection", "legal_compliance"],
      "command": "/verify",
      "description": "Security review or vulnerability assessment",
      "load": {
        "path": "./skills/4-secure/security_audit/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "build-database",
      "keywords": ["database", "query", "slow", "performance", "sql", "postgres", "mysql"],
      "phase": 3,
      "primary_skill": "database_optimization",
      "related": ["observability", "code_review", "schema_standards"],
      "command": "/build-fix",
      "description": "Database performance or schema issues",
      "load": {
        "path": "./skills/3-build/database_optimization/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "ship-deploy",
      "keywords": ["deploy", "ship", "launch", "production", "release", "go live"],
      "phase": 5,
      "primary_skill": "db_migrations",
      "related": ["ci_cd_pipeline", "infrastructure_as_code", "legal_compliance"],
      "command": "/plan",
      "description": "Preparing for production deployment",
      "load": {
        "path": "./skills/5-ship/db_migrations/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "handoff-document",
      "keywords": ["document", "api reference", "walkthrough", "guide", "runbook", "handoff"],
      "phase": 6,
      "primary_skill": "feature_walkthrough",
      "related": ["api_reference", "user_documentation", "disaster_recovery"],
      "command": "/update-docs",
      "description": "Documenting features or knowledge transfer",
      "load": {
        "path": "./skills/6-handoff/feature_walkthrough/SKILL.md",
        "source": "skill"
      }
    },
    {
      "id": "build-test",
      "keywords": ["test", "coverage", "unit test", "integration test", "tdd"],
      "phase": 3,
      "primary_skill": "tdd_workflow",
      "related": ["unit_testing", "integration_testing", "code_review"],
      "command": "/tdd",
      "description": "Test-first development or writing tests",
      "load": {
        "path": "./skills/3-build/tdd_workflow/SKILL.md",
        "source": "skill"
      }
    }
  ],
  "phase_skills": {
    "0-context": ["new_project", "codebase_navigation", "project_context", "architecture_recovery", "tech_debt_assessment", "codebase_health_audit", "legacy_modernization", "team_knowledge_transfer", "system_design_review", "infrastructure_audit", "incident_history_review", "documentation_framework", "project_guidelines", "ssot_structure", "compliance_context", "dev_environment_setup", "supply_chain_audit", "search_first", "stakeholder_map", "phase_0_playbook", "phase_exit_summary", "risk_register"],
    "1-brainstorm": ["idea_to_spec", "client_discovery", "proposal_generator", "user_story_standards", "user_research", "competitive_analysis", "product_metrics", "prioritization_frameworks", "assumption_testing", "go_no_go_gate", "lean_canvas", "market_sizing", "prd_generator", "smb_launchpad"],
    "2-design": ["atomic_reverse_architecture", "feature_architecture", "schema_standards", "api_contract_design", "deployment_modes", "architecture_decision_records", "c4_architecture_diagrams", "cost_architecture", "data_privacy_design", "design_intake", "design_handoff", "accessibility_design", "internationalization_design", "multi_tenancy_architecture", "nfr_specification", "rto_rpo_design", "security_threat_modeling"],
    "3-build": 50,
    "4-secure": 21,
    "5-ship": 11,
    "5.5-alpha": 5,
    "5.75-beta": 6,
    "6-handoff": 6,
    "7-maintenance": 6,
    "toolkit": 9
  }
}
```

---

### Part 3: Skills by Phase (skills-by-phase.md)

**File:** `.agent/skills-by-phase.md` (NEW, generated from skills-index.md)

**Purpose:** Browsable, loadable list of skills for each phase

**Section (Phase 3 Build example):**

```markdown
# Phase 3: Build (50 Skills Total)

## Core Build Orchestration (3)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 54 | `spec_build` | "Build [feature]" | [SKILL](./skills/3-build/spec_build/SKILL.md) |
| 59 | `bug_troubleshoot` | "Bug: [description]" | [SKILL](./skills/3-build/bug_troubleshoot/SKILL.md) |
| 62 | `code_review` | "Review code for [feature]" | [SKILL](./skills/3-build/code_review/SKILL.md) |

## TDD & Quality (5)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 59 | `tdd_workflow` | "TDD for [feature]" | [SKILL](./skills/3-build/tdd_workflow/SKILL.md) |
| 63 | `code_review_response` | "How do I respond to this review?" | [SKILL](./skills/3-build/code_review_response/SKILL.md) |
| 72 | `refactoring` | "Refactor [code/feature]" | [SKILL](./skills/3-build/refactoring/SKILL.md) |
| 89 | `ui_polish` | "Polish the UI" | [SKILL](./skills/3-build/ui_polish/SKILL.md) |
| 162 | `observability` | "Add monitoring to [feature]" | [SKILL](./skills/3-build/observability/SKILL.md) |

## API & Auth (3)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 54 | `api_design` | "Design the API for [feature]" | [SKILL](./skills/3-build/api_design/SKILL.md) |
| 55 | `auth_implementation` | "Set up authentication" | [SKILL](./skills/3-build/auth_implementation/SKILL.md) |
| 56 | `authorization_patterns` | "Add ownership check for [resource]" | [SKILL](./skills/3-build/authorization_patterns/SKILL.md) |

## Database & Performance (3)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 70 | `database_optimization` | "This query is slow" | [SKILL](./skills/3-build/database_optimization/SKILL.md) |
| 68 | `data_warehouse` | "Design data warehouse" | [SKILL](./skills/3-build/data_warehouse/SKILL.md) |
| 77 | `event_driven_architecture` | "Decouple [service] with events" | [SKILL](./skills/3-build/event_driven_architecture/SKILL.md) |

## DevOps & Infrastructure (4)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 73 | `docker_development` | "Dockerize this project" | [SKILL](./skills/3-build/docker_development/SKILL.md) |
| 74 | `environment_setup` | "Set up dev environment" | [SKILL](./skills/3-build/environment_setup/SKILL.md) |
| 79 | `feature_flags` | "Add feature flag for [feature]" | [SKILL](./skills/3-build/feature_flags/SKILL.md) |
| 82 | `git_workflow` | "Set up Git workflow" | [SKILL](./skills/3-build/git_workflow/SKILL.md) |

## Language-Specific Patterns (16)

### Backend Patterns
| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 57 | `backend_patterns` | "Backend architecture patterns" | [SKILL](./skills/3-build/backend_patterns/SKILL.md) |
| 72 | `django_patterns` | "Django patterns" | [SKILL](./skills/3-build/django_patterns/SKILL.md) |
| 84 | `golang_patterns` | "Go coding patterns" | [SKILL](./skills/3-build/golang_patterns/SKILL.md) |
| 87 | `java_coding_standards` | "Java coding standards" | [SKILL](./skills/3-build/java_coding_standards/SKILL.md) |
| 88 | `jpa_patterns` | "JPA/Hibernate patterns" | [SKILL](./skills/3-build/jpa_patterns/SKILL.md) |
| 96 | `springboot_patterns` | "Spring Boot patterns" | [SKILL](./skills/3-build/springboot_patterns/SKILL.md) |

### Frontend Patterns
| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 81 | `frontend_patterns` | "Frontend architecture patterns" | [SKILL](./skills/3-build/frontend_patterns/SKILL.md) |
| 89 | `liquid_glass_design` | "Liquid glass UI design" | [SKILL](./skills/3-build/liquid_glass_design/SKILL.md) |

### Specialized Patterns
| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 66 | `cpp_coding_standards` | "C++ coding standards" | [SKILL](./skills/3-build/cpp_coding_standards/SKILL.md) |
| 67 | `dapp_development` | "Build a dApp" | [SKILL](./skills/3-build/dapp_development/SKILL.md) |
| 80 | `firmware_development` | "Embedded firmware" | [SKILL](./skills/3-build/firmware_development/SKILL.md) |
| 90 | `ml_pipeline` | "Build an ML pipeline" | [SKILL](./skills/3-build/ml_pipeline/SKILL.md) |
| 91 | `multiplayer_systems` | "Add multiplayer/netcode" | [SKILL](./skills/3-build/multiplayer_systems/SKILL.md) |

## Domain-Specific Skills (6)

| # | Skill | Trigger | Link |
|---|-------|---------|------|
| 75 | `error_handling` | "Set up error handling for [project]" | [SKILL](./skills/3-build/error_handling/SKILL.md) |
| 76 | `etl_pipeline` | "Build ETL pipeline" | [SKILL](./skills/3-build/etl_pipeline/SKILL.md) |
| 78 | `extension_development` | "Build a browser extension" | [SKILL](./skills/3-build/extension_development/SKILL.md) |
| 85 | `i18n_implementation` | "Extract strings for translation" | [SKILL](./skills/3-build/i18n_implementation/SKILL.md) |
| 86 | `iot_platform` | "Build IoT platform" | [SKILL](./skills/3-build/iot_platform/SKILL.md) |
| 91 | `notification_systems` | "Set up notifications for [feature]" | [SKILL](./skills/3-build/notification_systems/SKILL.md) |

---

## How to Load Phase 3 Skills

**Load one skill:**
```
"Load api_design skill"
→ AI reads ./skills/3-build/api_design/SKILL.md
```

**Load multiple related skills:**
```
"Load api_design and auth_implementation"
→ AI reads both SKILLs in sequence
```

**Browse the entire phase:**
```
"What are all Phase 3 Build skills?"
→ This page is displayed, you pick
```

**Jump to a specific skill:**
```
"Use the bug_troubleshoot skill"
→ AI loads that skill immediately
```
```

---

### Part 4: Router Agent (agents/router.md)

**File:** `.agent/agents/router.md` (NEW)

**Purpose:** Lightweight dispatcher that intercepts user prompts, detects phase/intent, suggests skills

**Template:**

```markdown
# Router Agent

## Purpose
Analyze user prompts, detect phase + intent, suggest + load appropriate skills.

## When to Invoke
- Optional `/router` command
- Auto-activate on certain patterns: "I have a bug", "I need to ship", "Deploy this"
- User asks "What skill should I use?"

## The Algorithm

### Step 1: Detect Phase
Analyze user prompt for phase signals:
- "building", "coding", "implementing" → **Phase 3 Build**
- "testing", "security", "vulnerability" → **Phase 4 Secure**
- "deploying", "launching", "shipping" → **Phase 5 Ship**
- "documenting", "handoff", "knowledge" → **Phase 6 Handoff**
- "monitoring", "maintenance", "dependency" → **Phase 7 Maintenance**
- "idea", "feature", "spec", "requirement" → **Phase 1 Brainstorm**
- "architecture", "design", "schema" → **Phase 2 Design**
- "understand", "navigate", "audit" → **Phase 0 Context**

### Step 2: Extract Intent
Identify primary + secondary intents:

**Primary Intents:**
- `spec_writing` — Turn ideas into specifications
- `architecture_design` — System architecture
- `implementation` — Writing code
- `debugging` — Fixing broken code
- `testing` — Quality assurance
- `documentation` — Writing docs/guides
- `deployment` — Going to production
- `maintenance` — Long-term operations

**Secondary Intents (Domain):**
- `api_work` — REST/GraphQL APIs
- `database_work` — SQL/NoSQL queries
- `frontend_work` — UI/UX components
- `backend_work` — Server logic
- `devops_work` — Infrastructure/deployment
- `security_work` — Vulnerabilities/auth
- `testing_work` — Unit/E2E tests

### Step 3: Match Trigger Index
Look up [trigger-index.json](../trigger-index.json):
- Match detected phase + primary intent
- Find primary skill
- Identify 2-3 related skills
- Check recommended command

### Step 4: Suggest to User
Present options clearly:

```
Detected: Phase 3 Build, intent: Debugging

Primary Skill: bug_troubleshoot
Related Skills: code_review, refactoring, unit_testing
Recommended Command: /build-fix

Would you like me to load bug_troubleshoot? (yes/load related/see all Phase 3)
```

### Step 5: Load + Handoff
On user confirmation:
1. Load selected skill(s) from file system
2. Display skill overview (first 200 lines)
3. Cede control to user
4. Offer next suggestions ("What's next?")

---

## Router Conversation Examples

### Example 1: Bug in Production
```
User: "I'm seeing 500 errors on the checkout page"

Router Analysis:
  Phase: 3 (Build) → 4 (Secure) boundary
  Intent: debugging + testing
  Primary: bug_troubleshoot
  Related: code_review, observability, error_tracking
  Command: /build-fix

Router Response:
  "Detected Phase 3 Build issue: debugging production error.

  Primary skill: bug_troubleshoot
  Related: code_review, observability

  Load bug_troubleshoot? (or see Phase 3 build skills)"

User: "Load bug_troubleshoot"

Router: [Loads SKILL.md, runs process]
```

### Example 2: New Feature, Uncertain Start
```
User: "I need to build a user notification system"

Router Analysis:
  Phase: 2 (Design) → 3 (Build) path
  Intent: implementation + specification
  Primary: idea_to_spec or spec_build (depends on if spec exists)
  Related: notification_systems, feature_architecture
  Command: /plan

Router Response:
  "New feature: notification system.

  Suggested workflow:
  1. idea_to_spec (clarify requirements)
  2. feature_architecture (design system)
  3. spec_build (implement)
  4. notification_systems (patterns)

  Start with idea_to_spec? (or /plan for full workflow)"

User: "/plan"
→ Planner agent creates 12-phase build plan
```

### Example 3: Deployment Anxiety
```
User: "We're shipping this tomorrow but I'm scared"

Router Analysis:
  Phase: 5 (Ship)
  Intent: deployment + risk mitigation
  Primary: db_migrations (safety critical)
  Related: ci_cd_pipeline, deployment_patterns, legal_compliance
  Command: /plan

Router Response:
  "Phase 5 Ship detected. Pre-deployment checklist:

  Critical (must do):
  1. db_migrations (safe schema changes)
  2. security_audit (vulnerabilities)
  3. e2e_testing (critical flows)

  Recommended (should do):
  4. ci_cd_pipeline (automated deploy)
  5. deployment_patterns (blue-green)
  6. legal_compliance (ToS, privacy)

  Load db_migrations to start? (or /plan for full pre-flight)"

User: "/plan"
→ Planner creates pre-ship checklist
```

---

## Integration with Framework

Router works alongside:
- **CLAUDE.md** — Phase dispatch reference
- **trigger-index.json** — Intent matching
- **skills-by-phase.md** — Browsable lists
- **Commands** — `/plan`, `/tdd`, `/code-review`, etc.
- **Agents** — planner, code-reviewer, tdd-guide, etc.

Router doesn't replace commands or agents—it surfaces them contextually.

---

## Disabling Router

Some users may find router intrusive. Options:
1. Don't invoke `/router` command (router doesn't auto-activate)
2. Ignore router suggestions, ask for skills directly
3. Use commands (`/plan`, `/code-review`, etc.) which work independently

Router is optional enhancement, not required workflow.

---

## Future Enhancements

- Learn user's workflow (frequency of skills used)
- Suggest skill combinations dynamically
- Detect multi-phase projects and create task breakdown
- Export "learned patterns" as new skills
- Integration with IDE for command-palette dispatch
```

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Files (Days 1-2)

- [ ] Create `.agent/CLAUDE.md` — Framework router + phase dispatch
  - [ ] Copy template above
  - [ ] Update links to point to actual `.agent/` files
  - [ ] Test markdown rendering
  - [ ] Add custom project onboarding section

- [ ] Create `.agent/trigger-index.json` — Intent→skill mapping
  - [ ] Generate from skills-index.md (14 phase sections)
  - [ ] Include 20-30 primary trigger patterns
  - [ ] Test JSON validity
  - [ ] Add comments for each trigger

- [ ] Create `.agent/skills-by-phase.md` — Loadable phase registries
  - [ ] Extract from skills-index.md (8 sections)
  - [ ] Add markdown links to SKILL.md files
  - [ ] Group by category (core, language-specific, domain)
  - [ ] Test all links work

- [ ] Create `.agent/agents/router.md` — Dispatcher agent
  - [ ] Copy template above
  - [ ] Add flow diagrams
  - [ ] Add conversation examples
  - [ ] Explain phase detection algorithm

### Phase 2: Integration (Day 3)

- [ ] Update main `README.md`
  - [ ] Point to `.agent/CLAUDE.md` as auto-load entry
  - [ ] Add "Discoverability" section
  - [ ] Explain phase dispatch workflow

- [ ] Update `.agent/GETTING_STARTED.md`
  - [ ] Explain framework CLAUDE.md auto-loading
  - [ ] Update skill quick reference
  - [ ] Add "detect your phase" flowchart

- [ ] Update `.agent/README.md`
  - [ ] Link to new router agent
  - [ ] Explain trigger-index.json
  - [ ] Add "how to discover skills" section

- [ ] Test full workflow
  - [ ] Create new project with `.agent/` folder
  - [ ] Verify CLAUDE.md loads at session start
  - [ ] Test `/router` command
  - [ ] Test phase detection
  - [ ] Load 2-3 skills from different phases

### Phase 3: Documentation (Day 4, Optional)

- [ ] Create DISCOVERABILITY.md guide
- [ ] Add "Router Quick Start" tutorial
- [ ] Create video walkthrough (5 min)
- [ ] Add to troubleshooting: "Skills not found"

---

## SUCCESS CRITERIA

After implementation, measure:

1. **Skill Discovery Rate**
   - Before: User manually searches/reads docs
   - After: User finds skill within 1 minute

2. **Command Usage**
   - Before: 0-1 commands per session average
   - After: 2-4 commands per session average

3. **Skills-Per-Phase Loading**
   - Before: Random/ad-hoc skill selection
   - After: 80%+ users load appropriate phase skills

4. **Onboarding Time**
   - Before: >20 minutes to understand framework
   - After: <5 minutes to use first skill

---

## ROLLOUT PLAN

### Week 1: Internal Testing
- [ ] Create files in staging branch
- [ ] Test with 2-3 projects
- [ ] Gather feedback
- [ ] Refine CLAUDE.md, router agent

### Week 2: Beta Release
- [ ] Merge to main
- [ ] Announce in README
- [ ] Add to CHANGELOG
- [ ] Monitor early user feedback

### Week 3: GA + Documentation
- [ ] Finalize all docs
- [ ] Create tutorial video
- [ ] Update blueprint examples
- [ ] Release announcement

---

## WHAT'S NOT INCLUDED

**Out of Scope (Future Work):**
- Skill auto-generation from prompts
- ML-based intent classification
- Skill dependency graph
- Interactive flowchart wizard
- Real-time performance metrics

These are enhancements for post-v1 release.

---

## QUESTIONS ANSWERED

**Q: Will router slow down sessions?**
A: No. Router only activates on `/router` command or explicit skill request. It doesn't auto-intercept every prompt.

**Q: What if users ignore router suggestions?**
A: Fine. Router is optional enhancement. Users can ask for skills directly, use commands, or ignore entirely.

**Q: Does this change existing commands?**
A: No. `/plan`, `/tdd`, `/code-review` work identically. Router just makes them easier to discover.

**Q: Can we auto-generate trigger-index.json?**
A: Yes, as Phase 3 (Day 4+). Script to parse SKILL.md headers and extract keywords.

**Q: How do we handle new skills added later?**
A: Update trigger-index.json + skills-by-phase.md. Both are human-maintainable files (not auto-generated yet).

---

## FILES TO COMMIT

```
.agent/
├── CLAUDE.md (NEW)
├── trigger-index.json (NEW)
├── skills-by-phase.md (NEW)
├── agents/
│   ├── router.md (NEW)
│   ├── ... (existing agents)
├── skills/ (unchanged)
├── README.md (updated)
├── GETTING_STARTED.md (updated)
└── ... (rest unchanged)

/.agent/ (unchanged)
├── README.md (updated)
└── ... (rest unchanged)
```

---

**Last Updated:** March 5, 2026
**Status:** Ready for implementation
**Effort:** 2-3 days
**Impact:** +500% skill discoverability
