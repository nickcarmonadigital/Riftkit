# ATOM v2 Enhancement Report -- Riftkit Framework

> Generated: 2026-03-10 | Post-PR#1 analysis | 3 parallel ATOM agents

---

## Executive Summary

After fixing 21 structural gaps in PR #1, three parallel ATOM v2 agents analyzed Riftkit across:
1. **Remaining structural integrity issues** -- 75+ problems found
2. **Missing domain skills** -- 40 proposed skills (14 MUST-HAVE)
3. **UX and adoption barriers** -- 17 issues blocking new user success

**Top 3 systemic findings:**
- **52 broken workflow `view_file` paths** across 16 files (same class as PR #1 but in different files)
- **AI-native blindspot** -- the framework runs inside Claude Code but has no skills for Claude Code hooks, MCP development, or AI coding assistant integration
- **First-time user experience is broken** -- example commands in README don't exist, no 2-minute quickstart, competing entry points confuse users

---

## PART 1: Remaining Structural Issues (75+ problems)

### 1.1 CRITICAL -- 52 Broken Workflow Paths (16 files)

Same root cause as PR #1: skill paths missing correct phase prefixes. These were in files not caught in the first pass.

| Workflow File | Broken Refs |
|---|---|
| `workflows/compliance-audit.md` | 7 |
| `workflows/0-context.md` | 6 |
| `workflows/3-build.md` | 5 |
| `workflows/migration-upgrade.md` | 5 |
| `workflows/onboarding-new-dev.md` | 5 |
| `workflows/hotfix-critical.md` | 3 |
| `workflows/incident-response.md` | 3 |
| `workflows/2-design.md` | 2 |
| `workflows/4-secure.md` | 2 |
| `workflows/5-ship.md` | 2 |
| `workflows/security-hardening.md` | 2 |
| `workflows/toolkit/debug.md` | 2 |
| `workflows/toolkit/design-review.md` | 2 |
| `workflows/toolkit/launch.md` | 2 |
| `workflows/toolkit/new-project.md` | 2 |
| `workflows/performance-optimization.md` | 1 |

**Most common wrong-phase patterns:**
- `3-build/` skills referenced as `4-secure/` (code_review, compliance_as_code, authorization_patterns, etc.)
- `0-context/` skills referenced as `4-secure/` (regulated_industry_context, risk_register)
- `4-secure/` skills referenced as `3-build/` (tdd_workflow, integration_testing, e2e_testing)
- `toolkit/` skills referenced as `4-secure/` (compliance_program)

**Also:** `workflows/3-build.md` line 129 references `workflows/post-task.md` but it's at `workflows/toolkit/post-task.md`.

### 1.2 HIGH -- Broken Doc Template References

`workflows/0-context.md` lines 29-31 reference 3 docs that don't exist:
- `.agent/docs/0-context/session-handoff-prompt.md`
- `.agent/docs/0-context/implementation-plan.md`
- `.agent/docs/0-context/feature-registry.md`

### 1.3 HIGH -- Root README.md Severely Stale

`/home/user/Riftkit/README.md` has wrong counts everywhere:

| Category | README Says | Actual |
|---|---|---|
| Context | 15 | 23 |
| Brainstorm | 9 | 14 |
| Design | 4 | 24 |
| Build | 50 | 93 |
| Secure | 21 | 40 |
| Ship | 11 | 23 |
| Alpha/Beta | 11 | 23 |
| Handoff | 6 | 14 |
| Maintenance | 6 | 13 |
| Toolkit | 9 | 31 |
| Rules | 25 (claimed) | 39 |
| Hooks | 9 (claimed) | 6 |
| Workflows | 18 (claimed) | 25 |
| Docs | 70+ (claimed) | 60 |

Also missing Java and Rust language tracks from the rules description.

### 1.4 HIGH -- `rules/common/agents.md` Lists Only 9 of 19 Agents

Missing 10 agents from the routing rule: brainstorm-agent, compliance-agent, database-reviewer, framework-router, go-build-resolver, go-reviewer, python-reviewer, security-agent, ship-agent, sre-agent.

This means **these agents won't be considered for task routing**.

### 1.5 HIGH -- `skills-index.md` Covers 24 of 298 Skills (8%)

Header claims "Complete reference of all available skills" but only indexes 24.

### 1.6 MEDIUM -- GETTING_STARTED.md Issues

- Claims "25 Coding Guidelines" (actual: 39 rules)
- Lists only 5 language tracks (missing Java, Rust)
- Shows skill paths without phase prefixes (broken paths)
- References `content_cascade` (should be `content_waterfall`)

### 1.7 MEDIUM -- Phantom Commands

`skills-trigger-index.md` and `CLAUDE.md` reference 5 commands with no files:
- `/adversarial-audit`, `/age`, `/atom`, `/discovery`, `/gap-analysis`

### 1.8 MEDIUM -- `claw.md` References Non-Existent `claw.js`

The `/claw` command references `scripts/claw.js` and `npm run claw` but no such script exists.

---

## PART 2: Missing Domain Skills (40 proposed)

### MUST-HAVE (14 skills)

| # | Skill | Phase | Why |
|---|---|---|---|
| 1 | `ai_coding_assistant_integration` | 3-build | Cursor rules, Copilot, Claude Code conventions -- the framework is AI-native but doesn't teach AI tool config |
| 2 | `structured_output_patterns` | 3-build | JSON schemas, function calling, tool use, Pydantic validation -- dominates 2025-2026 AI integration |
| 3 | `edge_computing_patterns` | 3-build | Cloudflare Workers, Vercel Edge, Lambda@Edge -- dominant modern deployment, zero coverage |
| 4 | `llm_observability` | 3-build | Langfuse, LangSmith, Arize -- AI systems need specialized telemetry beyond general observability |
| 5 | `mcp_server_development` | 3-build | MCP server patterns, tool definitions, resources -- `mcp-configs/` dir exists but no skill |
| 6 | `pre_commit_quality_gates` | 4-secure | Husky, lint-staged, pre-commit framework -- foundational quality gate with no coverage |
| 7 | `api_contract_testing` | 4-secure | Pact, Schemathesis -- `api_contract_design` covers design but not CI verification |
| 8 | `release_automation` | 5-ship | semantic-release, changesets, conventional commits -- automates the release pipeline |
| 9 | `automated_dependency_updates` | 7-maintenance | Dependabot, Renovate configuration -- `dependency_management` is manual, this automates |
| 10 | `claude_code_hooks` | toolkit | Hook patterns, `.claude/` config, session management -- framework runs in Claude Code but can't teach hook dev |
| 11 | `mcp_integration_patterns` | toolkit | MCP client config, multi-server orchestration -- consumption side of MCP |
| 12 | `alpha_rollback_procedures` | 5.5-alpha | Automated rollback triggers, data reversal -- alpha-specific constraints |
| 13 | `incident_postmortem` | 7-maintenance | Blameless postmortems, 5-whys, action tracking -- response exists but learning loop doesn't |
| 14 | `migration_playbooks` | 7-maintenance | Monolith-to-micro, framework upgrades, cloud migrations -- no large-scale migration skill |

### SHOULD-HAVE (18 skills)

| # | Skill | Phase | Why |
|---|---|---|---|
| 15 | `server_components_patterns` | 3-build | RSC, Next.js App Router, Islands, HTMX -- post-SPA paradigm shift |
| 16 | `modern_runtime_patterns` | 3-build | Bun, Deno 2.x, effect-ts, tRPC |
| 17 | `prompt_caching_optimization` | 3-build | Anthropic/OpenAI caching, semantic caching layers |
| 18 | `typescript_patterns` | 3-build | Discriminated unions, branded types -- Go/Python/Java/C++/Swift have skills, TS doesn't |
| 19 | `terraform_state_management` | 3-build | State locking, remote backends, drift detection |
| 20 | `graphql_patterns` | 3-build | Schema design, federation, subscriptions -- REST is covered, GraphQL isn't |
| 21 | `websocket_realtime_patterns` | 3-build | WebSocket, SSE, WebTransport -- general real-time beyond gaming |
| 22 | `database_selection_guide` | 2-design | Decision framework for choosing databases |
| 23 | `testing_strategy_design` | 2-design | Test pyramid planning -- Phase 4 executes but Phase 2 doesn't plan |
| 24 | `schema_drift_detection` | 4-secure | ORM vs actual schema validation in CI |
| 25 | `github_actions_patterns` | 5-ship | Reusable workflows, matrix strategies, composite actions |
| 26 | `alpha_data_seeding` | 5.5-alpha | Production-like data for alpha, anonymization |
| 27 | `alpha_performance_baseline` | 5.5-alpha | Performance baselines, regression detection |
| 28 | `deprecation_management` | 7-maintenance | API sunset timelines, consumer notification |
| 29 | `cost_optimization_operations` | 7-maintenance | Runtime cloud cost reviews, right-sizing |
| 30 | `runbook_automation` | 7-maintenance | Manual runbooks to auto-remediation |
| 31 | `build_vs_buy_analysis` | 1-brainstorm | TCO analysis, vendor evaluation |
| 32 | `technical_spike` | 1-brainstorm | Time-boxed investigation framework |
| 33 | `technical_writing_standards` | toolkit | Writing standards per audience type |
| 34 | `adr_lifecycle_management` | 7-maintenance | ADR supersession tracking, periodic review |

### NICE-TO-HAVE (8 skills)

| # | Skill | Phase |
|---|---|---|
| 35 | `rust_patterns` | 3-build |
| 36 | `nextjs_patterns` | 3-build |
| 37 | `local_first_patterns` | 3-build |
| 38 | `api_versioning_strategies` | 2-design |
| 39 | `ci_notification_patterns` | 5-ship |
| 40 | `onboarding_generator` | toolkit |

---

## PART 3: UX and Adoption Barriers (17 issues)

### Critical -- Blocking Adoption

| # | Issue | Fix |
|---|---|---|
| 1 | README.md example commands (`/brain-dump`, `/architecture`, `/walkthrough`) **don't exist** | Replace with real commands (`/plan`, `/tdd`, `/build-fix`) |
| 2 | No true 2-minute quickstart with a runnable example | Add "Copy folder. Run `/plan`. See it work." |
| 3 | Skill/Agent/Command relationship never explained | Add "How It Fits Together" section |
| 4 | Contributing docs show wrong skill path (missing phase prefix) | Fix to `.agent/skills/{phase}/{name}/SKILL.md` |

### High Priority

| # | Issue | Fix |
|---|---|---|
| 5 | "298 skills" as opening line is intimidating | Lead with "Start here" (3 things), push catalog to reference |
| 6 | GETTING_STARTED.md offers 3 options with no recommendation | Give ONE recommended path |
| 7 | Command files have inconsistent structure | Create command template, retrofit |
| 8 | No docs/ README or table of contents | Add `docs/README.md` with categorized listing |
| 9 | `skills-index.md` name misleading (covers 8%) | Rename to `skills-quick-reference.md` or expand |
| 10 | docs/ vs skills/ boundary unclear | Add note: "docs = templates, skills = process guidance" |

### Medium Priority

| # | Issue | Fix |
|---|---|---|
| 11 | Duplicate skills with no disambiguation (feature_flags x2) | Add disambiguation notes |
| 12 | Global install vs project-local not explained | Document both modes clearly |
| 13 | Stale counts in WORKFLOWS_README.md | Update |
| 14 | `content_cascade` vs `content_waterfall` naming mismatch | Align naming |
| 15 | No skill template file for contributors | Create `.agent/templates/SKILL_TEMPLATE.md` |
| 16 | No quality gate docs for skill contributions | Document minimum requirements |
| 17 | Common Tasks table shows `--` for command-less tasks | Change to "Use skill directly" |

---

## PART 4: Strategic Observations

### 1. The AI-Native Blindspot
Riftkit has strong ML/LLM skills (RAG, fine-tuning, agents, vector DBs) but is weak on "AI as development tool" -- no skills for AI coding assistants, MCP, Claude Code hooks, or structured outputs. **The framework runs inside Claude Code but can't teach users how to build for Claude Code.**

### 2. TypeScript Gap
Go, Python, Java, C++, Swift, Dart all have dedicated pattern skills. TypeScript -- the most-used language in AI-assisted development -- does not.

### 3. Phase 7 is Dangerously Thin
Systems spend 80%+ of lifecycle in maintenance, yet Phase 7 has only 13 skills. Postmortems, migration playbooks, deprecation, cost optimization, and runbook automation are daily concerns for mature systems.

### 4. Testing Design Gap
Phase 4 has 40 testing execution skills but Phase 2 has no testing strategy design skill. Teams jump from architecture to writing tests without planning what to test.

### 5. Competing Discovery Mechanisms
5 different places to find skills (CLAUDE.md, README.md, GETTING_STARTED.md, skills-index.md, skill-combos.md) with conflicting information. Need a single source of truth.

---

## Recommended Action Plan

### Wave 1: Fix Remaining Structural Issues (same class as PR #1)
1. Fix 52 broken workflow paths across 16 files
2. Update README.md counts to match reality
3. Update `rules/common/agents.md` with all 19 agents
4. Fix GETTING_STARTED.md paths and counts
5. Fix README.md example commands
6. Create stub templates for missing doc references

### Wave 2: UX Quick Wins
7. Add "How Skills/Agents/Commands Fit Together" to CLAUDE.md
8. Simplify GETTING_STARTED.md to one recommended path
9. Fix contributing guide skill path format
10. Add docs/README.md index

### Wave 3: MUST-HAVE Skills (14 new skills)
11. Create the 14 MUST-HAVE skills listed above
12. Update CLAUDE.md tables with new skills
13. Update framework-router.md counts

### Wave 4: SHOULD-HAVE Skills + Polish (18 skills + UX)
14. Create 18 SHOULD-HAVE skills
15. Create command template and retrofit inconsistent commands
16. Rename/expand skills-index.md
17. Add disambiguation notes for overlapping skills

### Wave 5: NICE-TO-HAVE Skills (8 skills)
18. Create remaining 8 NICE-TO-HAVE skills

---

*Report generated by 3 parallel ATOM v2 agents analyzing structural integrity, domain coverage, and UX/adoption.*
