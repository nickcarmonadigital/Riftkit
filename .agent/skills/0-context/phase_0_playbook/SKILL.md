---
name: Phase 0 Playbook
description: Meta-skill that determines the correct Phase 0 skill sequence based on project scenario
---

# Phase 0 Playbook Skill

**Purpose**: Serve as the entry point for Phase 0 by identifying which project archetype you are working with and prescribing the correct sequence of Phase 0 skills. This prevents wasted effort by ensuring you run the right discovery skills in the right order based on whether you are starting fresh, inheriting a codebase, doing archaeology, or taking over operations.

## TRIGGER COMMANDS

```text
"I'm starting Phase 0"
"Joining a project, where to start"
"Phase 0 entry"
```

## When to Use
- You are beginning work on any project and need to understand the current state
- A new team member (human or AI) needs to know which Phase 0 skills to run
- You want to ensure no critical discovery step is skipped before moving to Phase 1

---

## PROCESS

### Step 1: Identify the Project Archetype

Ask these questions to classify the project:

| Question | If Yes... |
|----------|-----------|
| Is there an existing codebase? | Not Greenfield |
| Is the original team available? | Not Archaeological |
| Are you responsible for production? | Operational Takeover |
| Is this starting from scratch? | Greenfield |

**Four Archetypes**:

1. **Greenfield** -- No existing code. Starting from zero.
2. **Inherit** -- Existing codebase with team handoff available.
3. **Archaeological** -- Existing codebase, original team gone, limited docs.
4. **Operational Takeover** -- Existing codebase already in production; you own uptime now.

### Step 2: Follow the Prescribed Skill Sequence

#### Archetype 1: Greenfield

| Order | Skill | Est. Time | Purpose |
|-------|-------|-----------|---------|
| 1 | `dev_environment_setup` | 30 min | Initialize repo and tooling |
| 2 | `stakeholder_map` | 30 min | Identify decision-makers and constraints |
| 3 | `new_project` | 45 min | Scaffold project structure |
| 4 | `project_context` | 20 min | Create living context document |
| 5 | `compliance_context` | 30 min | Identify regulatory obligations |
| 6 | `phase_exit_summary` | 15 min | Produce Phase 0 exit brief |

#### Archetype 2: Inherit

| Order | Skill | Est. Time | Purpose |
|-------|-------|-----------|---------|
| 1 | `dev_environment_setup` | 45 min | Get the codebase running |
| 2 | `stakeholder_map` | 30 min | Map decision-makers |
| 3 | `team_knowledge_transfer` | 60 min | Capture tribal knowledge |
| 4 | `codebase_navigation` | 30 min | Understand project layout |
| 5 | `codebase_health_audit` | 45 min | Assess code quality and debt |
| 6 | `infrastructure_audit` | 30 min | Review deployment and infra |
| 7 | `risk_register` | 30 min | Consolidate discovered risks |
| 8 | `phase_exit_summary` | 15 min | Produce Phase 0 exit brief |

#### Archetype 3: Archaeological

| Order | Skill | Est. Time | Purpose |
|-------|-------|-----------|---------|
| 1 | `dev_environment_setup` | 60 min | Get legacy code running (expect issues) |
| 2 | `codebase_navigation` | 45 min | Map the unknown territory |
| 3 | `architecture_recovery` | 60 min | Reverse-engineer architecture |
| 4 | `codebase_health_audit` | 45 min | Find vulnerabilities and debt |
| 5 | `supply_chain_audit` | 30 min | Check dependency security |
| 6 | `tech_debt_assessment` | 45 min | Quantify modernization effort |
| 7 | `risk_register` | 30 min | Consolidate all risks |
| 8 | `phase_exit_summary` | 15 min | Produce Phase 0 exit brief |

#### Archetype 4: Operational Takeover

| Order | Skill | Est. Time | Purpose |
|-------|-------|-----------|---------|
| 1 | `infrastructure_audit` | 45 min | Understand what is running in prod |
| 2 | `incident_history_review` | 30 min | Learn from past failures |
| 3 | `dev_environment_setup` | 45 min | Get local environment running |
| 4 | `codebase_navigation` | 30 min | Map the codebase |
| 5 | `codebase_health_audit` | 45 min | Assess code quality |
| 6 | `compliance_context` | 30 min | Identify regulatory exposure |
| 7 | `supply_chain_audit` | 30 min | Audit dependency chain |
| 8 | `risk_register` | 30 min | Consolidate all risks |
| 9 | `phase_exit_summary` | 15 min | Produce Phase 0 exit brief |

### Step 3: Track Progress

As each skill completes, record its output artifact:

```markdown
## Phase 0 Progress Tracker

| Skill | Status | Artifact | Notes |
|-------|--------|----------|-------|
| dev_environment_setup | Done | .setup-timer.tmp | 22 min to green build |
| stakeholder_map | Done | stakeholder-map.md | 3 stakeholders identified |
| ... | ... | ... | ... |
```

### Step 4: Gate to Phase 1

Phase 1 CANNOT begin until:
- All required skills for the archetype are completed
- `phase_exit_summary` has been produced
- No CRITICAL risks remain unacknowledged in the risk register

---

## CHECKLIST

- [ ] Project archetype identified (Greenfield / Inherit / Archaeological / Operational Takeover)
- [ ] Skill sequence selected from the matching archetype table
- [ ] Each skill in the sequence executed in order
- [ ] Output artifacts collected for each completed skill
- [ ] Progress tracker updated after each skill
- [ ] Phase exit summary produced
- [ ] Phase 1 readiness confirmed

---

*Skill Version: 1.0 | Phase: 0-Context | Priority: P0*
