---
name: Project State Persistence
description: Persistent project health artifact updated at each phase exit, capturing current phase, metrics, compliance status, and completion checklists across sessions.
---

# Project State Persistence Skill

**Purpose**: Solve the "framework has no memory across sessions" problem by maintaining a structured JSON artifact that captures project health, current phase, audit history, and completion status. Updated at each phase exit and queryable at any time to provide an instant project dashboard.

## TRIGGER COMMANDS

```text
"/project-status"
"What phase are we in?"
"Project health dashboard"
"Update project state"
"Initialize project state"
```

## When to Use
- Starting a new project (initialize the state file)
- Completing a phase gate (update state with gate decision)
- Beginning a new session and need to understand project context
- Preparing a project health report for stakeholders
- Diagnosing why a phase transition is blocked

---

## PROCESS

### Step 1: Initialize Project State

Create the project state file from the template at `.agent/docs/project-state-template.json`.

```bash
# Copy template to active state file
cp .agent/docs/project-state-template.json .agent/project-state.json
```

**Required Initial Fields:**
- Project name and description
- Team scale (solo / startup / smb / enterprise)
- Start date
- Current phase (typically "0-context")
- Compliance frameworks (from compliance_program skill, if applicable)

### Step 2: Update at Phase Exit

When a phase gate is passed, update the project state with gate results.

**Phase Completion Update:**
1. Record gate decision (APPROVED/CONDITIONAL/BLOCKED)
2. Update current phase to the next phase
3. Record key artifacts produced
4. Capture quality metrics (test coverage, audit scores)
5. Timestamp the transition

**Update Process:**
```
1. Read current .agent/project-state.json
2. Update "current_phase" to new phase
3. Add entry to "phase_history" array
4. Update "metrics" with latest values
5. Update "last_updated" timestamp
6. Write back to .agent/project-state.json
```

### Step 3: Query Project Status

Read the state file to produce an instant dashboard.

**Dashboard Output Format:**

```markdown
# Project Status: [Project Name]
## Last Updated: [Timestamp]

### Current Phase: [Phase Name] ([Phase Number])
### Team Scale: [Solo/Startup/SMB/Enterprise]
### Days in Current Phase: [N]

### Phase History
| Phase | Status | Entry Date | Exit Date | Days |
|-------|--------|------------|-----------|------|
| 0-Context | Completed | 2026-01-15 | 2026-01-20 | 5 |
| 1-Brainstorm | Completed | 2026-01-20 | 2026-01-28 | 8 |
| 2-Design | In Progress | 2026-01-28 | -- | 3 |

### Health Metrics
| Metric | Value | Trend | Status |
|--------|-------|-------|--------|
| Test Coverage | 82% | +3% | Good |
| Open P0 Bugs | 0 | -- | Good |
| Security Audit | Passed | -- | Good |
| Dependency Health | 2 high CVEs | +2 | Warning |
| DORA: Deploy Freq | 3/week | -- | High |

### Compliance Status
| Framework | Status | Last Audit |
|-----------|--------|------------|
| SOC 2 | On Track | 2026-01-25 |
| GDPR | Compliant | 2026-01-20 |

### Blocking Issues
- [None / List of blocking items with owners]

### Next Gate: G[X]-[Y]
- [Key criteria and current readiness]
```

### Step 4: Maintain State Integrity

The state file is the single source of truth for project status across sessions.

**Integrity Rules:**
1. Only update through the defined process (never manual edits without validation)
2. Phase transitions must be backed by a gate check report
3. Metrics must come from automated sources where possible
4. Timestamps are always UTC ISO 8601
5. The file is committed to version control with each update

**Conflict Resolution:**
- If multiple agents or sessions modify state concurrently, last-write-wins with a merge log
- Critical fields (current_phase, phase_history) should be validated before write
- The `last_updated` and `updated_by` fields provide audit trail

### Step 5: Integrate with Other Skills

The project state file is read by and updated by multiple skills:

| Skill | Interaction |
|-------|------------|
| phase_gate_contracts | Writes gate decisions, updates current_phase |
| compliance_program | Updates compliance_status section |
| dora_metrics_tracking | Updates DORA metrics section |
| observability_maturity_model | Updates observability_level |
| governance_framework | Reads team_scale for gate rigor |

---

## STATE FILE LOCATION

- **Active state**: `.agent/project-state.json`
- **Template**: `.agent/docs/project-state-template.json`
- **Schema reference**: See template for all fields and types

---

## CHECKLIST

- [ ] Project state file initialized from template
- [ ] Project name, team scale, and start date set
- [ ] Current phase accurately reflects project status
- [ ] Phase history records all completed transitions
- [ ] Quality metrics populated from automated sources
- [ ] Compliance status updated (if applicable frameworks identified)
- [ ] State file committed to version control
- [ ] Dashboard output verified for accuracy
- [ ] Integration with phase_gate_contracts confirmed
- [ ] Team briefed on state update process

---

*Skill Version: 1.0 | Cross-Phase: All (infrastructure) | Priority: P0*
