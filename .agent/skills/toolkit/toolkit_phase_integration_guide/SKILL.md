---
name: Toolkit Phase Integration Guide
description: Definitive reference for which toolkit skills activate at which phase events, with prerequisites, outputs, and preflight checks.
---

# Toolkit Phase Integration Guide Skill

**Purpose**: Toolkit skills are cross-cutting concerns that activate at specific points across the development lifecycle. This skill provides the definitive reference matrix mapping toolkit skills to phase events, defines prerequisites and expected outputs for each activation point, and establishes a preflight check pattern to validate prerequisites before skill execution.

## TRIGGER COMMANDS

```text
"Toolkit setup for [phase]"
"Which toolkit skills for build?"
"Phase toolkit activation"
"Preflight check for [skill]"
"Toolkit integration matrix"
```

## When to Use
- Starting a new phase and need to know which toolkit skills to activate
- Setting up a project and configuring toolkit integrations
- Auditing whether toolkit skills are being used at the right moments
- Before invoking a toolkit skill, to verify prerequisites are met
- Creating a new toolkit skill and defining its phase integration points

---

## PROCESS

### Step 1: Phase Activation Matrix

This matrix defines when each toolkit skill activates. Read rows (phases) to see what toolkit skills to use. Read columns (toolkit skills) to see where a specific tool is relevant.

| Phase | skill_registry | age_to_skill_pipeline | ai_security_hardening | delivery_metrics | cost_aware_llm | ai_tool_orchestration | strategic_compact | content_creation |
|-------|---------------|----------------------|----------------------|-----------------|---------------|----------------------|-------------------|-----------------|
| **0-Context** | Discover skills | -- | Review AI integrations | Baseline metrics | Estimate costs | Select AI tools | Initialize compact | -- |
| **1-Brainstorm** | Find relevant skills | -- | -- | -- | Budget planning | Configure providers | Update compact | -- |
| **2-Plan** | Verify coverage | -- | Threat model AI features | -- | Finalize budget | -- | Update compact | -- |
| **3-Build** | -- | -- | Implement defenses | -- | Monitor usage | Orchestrate calls | -- | -- |
| **4-QA** | -- | -- | Security test AI features | -- | Validate costs | -- | -- | -- |
| **5-Review** | Audit skill gaps | -- | Review AI security posture | Collect deploy data | Cost review | -- | Update compact | -- |
| **6-Deploy** | -- | -- | Production hardening | Record deployment | -- | -- | -- | -- |
| **7-Maintenance** | Usage audit | Convert AGE gaps | Ongoing monitoring | Generate report | Optimize costs | -- | Archive compact | -- |

Legend:
- **--** = Not activated in this phase
- **Text** = Activation event description

### Step 2: Phase-Specific Toolkit Checklists

For each phase, run this checklist to activate applicable toolkit skills:

```markdown
## Phase [N] Toolkit Activation — [Phase Name]

**Date**: [YYYY-MM-DD]
**Project**: [Name]

### Skills to Activate
| # | Toolkit Skill | Activation Event | Prerequisite | Status |
|---|---------------|-----------------|--------------|--------|
| 1 | [skill] | [event from matrix] | [prerequisite] | [ ] |
| 2 | [skill] | [event from matrix] | [prerequisite] | [ ] |

### Preflight Results
- [ ] All prerequisites verified
- [ ] All applicable toolkit skills invoked
- [ ] Outputs documented for downstream phases
```

### Step 3: Preflight Check Pattern

Before invoking any toolkit skill, validate prerequisites:

```markdown
## Preflight Check: [Skill Name]

### Required Inputs
| Input | Source | Present | Valid |
|-------|--------|---------|-------|
| [artifact/file] | [which phase produced it] | [Y/N] | [Y/N] |

### Required State
| Condition | Check | Met |
|-----------|-------|-----|
| [e.g., "monitoring is live"] | [how to verify] | [Y/N] |

### Dependencies
| Dependency Skill | Status | Last Run |
|-----------------|--------|----------|
| [skill name] | [active/not run] | [date] |

### Verdict
- [ ] **CLEAR**: All prerequisites met, proceed with skill
- [ ] **BLOCKED**: Missing prerequisites: [list blockers]
```

### Step 4: Handoff Artifacts by Phase

Each toolkit activation produces outputs consumed by later phases:

| Phase | Toolkit Skill | Output Artifact | Consumed By |
|-------|---------------|-----------------|-------------|
| 0-Context | skill_registry | Skills inventory | All phases (discovery) |
| 0-Context | ai_tool_orchestration | Provider config | Phase 3 (build) |
| 0-Context | delivery_metrics | Baseline metrics | Phase 7 (comparison) |
| 2-Plan | ai_security_hardening | AI threat model | Phase 4 (security test) |
| 2-Plan | cost_aware_llm | Token budget | Phase 3 (enforcement) |
| 5-Review | delivery_metrics | Deploy data | Phase 7 (report) |
| 6-Deploy | ai_security_hardening | Production config | Phase 7 (monitoring) |
| 7-Maintenance | age_to_skill_pipeline | New skills | Next Phase 0 (context) |
| 7-Maintenance | delivery_metrics | DORA report | Next Phase 0 (priorities) |

### Step 5: Adding New Toolkit Skills

When creating a new toolkit skill, define its integration:

```markdown
## Integration Specification: [New Toolkit Skill Name]

### Phase Activations
| Phase | Event | Prerequisites | Output |
|-------|-------|---------------|--------|
| [phase] | [when to activate] | [what must exist] | [what it produces] |

### Preflight Requirements
- [Prerequisite 1]
- [Prerequisite 2]

### Downstream Consumers
- [Phase/Skill that uses this skill's output]
```

Update the Phase Activation Matrix (Step 1) after adding any new toolkit skill.

---

## CHECKLIST

- [ ] Phase Activation Matrix reviewed and current
- [ ] All toolkit skills have defined activation events per phase
- [ ] Preflight check pattern used before every toolkit skill invocation
- [ ] Handoff artifacts documented (what each activation produces)
- [ ] Phase-specific toolkit checklists available for all 8 phases
- [ ] New toolkit skills have integration specifications before merge
- [ ] Matrix updated whenever a toolkit skill is added or modified
- [ ] Team knows to consult this guide at every phase transition

---

*Skill Version: 1.0 | Created: February 2026*
