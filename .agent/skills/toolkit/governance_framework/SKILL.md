---
name: Governance Framework
description: Team-scale configuration guide with three tiers (Solo, SMB, Enterprise) defining phase gate rigor, approval roles, audit trails, and multi-developer coordination patterns.
---

# Governance Framework Skill

**Purpose**: Configure the framework's governance rigor based on team size and organizational needs. Defines three tiers -- Solo/Startup, SMB/Agency, and Enterprise -- each with appropriate phase gate strictness, approval workflows, audit trail requirements, and coordination patterns. Prevents both under-governance (chaos) and over-governance (bureaucratic paralysis).

## TRIGGER COMMANDS

```text
"Configure for [team size]"
"Set up approval roles"
"Enterprise governance setup"
"What governance tier are we?"
"Adjust gate rigor for [solo/smb/enterprise]"
```

## When to Use
- Initializing a new project and need to set governance level
- Scaling from a solo project to a team project
- Preparing for enterprise compliance requirements (SOC 2, ISO 27001)
- Experiencing friction from gates that are too strict or too loose
- Onboarding new team members who need to understand approval flows

---

## PROCESS

### Step 1: Determine Governance Tier

Assess the project and team to select the appropriate tier.

**Tier Selection Matrix:**

| Factor | Solo/Startup | SMB/Agency | Enterprise |
|--------|-------------|------------|-----------|
| Team size | 1-3 developers | 4-20 developers | 20+ developers |
| Customer type | Early adopters | SMB customers | Enterprise/regulated |
| Compliance needs | Minimal | SOC 2 Type I | SOC 2 Type II, HIPAA, FedRAMP |
| Release cadence | Multiple/day | Daily-weekly | Scheduled windows |
| Audit requirements | None | Basic | Formal with evidence |
| Budget for tooling | Minimal | Moderate | Comprehensive |

### Step 2: Configure Phase Gate Rigor

Each tier adjusts the strictness of phase gates defined in phase_gate_contracts.

**Solo/Startup Tier:**

| Gate | Enforcement | Approval |
|------|------------|----------|
| G0-1 Context -> Brainstorm | Advisory (checklist only) | Self-approval |
| G1-2 Brainstorm -> Design | Advisory | Self-approval |
| G2-3 Design -> Build | Lightweight (key artifacts required) | Self-approval |
| G3-4 Build -> Secure | Lightweight (basic security check) | Self-approval |
| G4-5 Secure -> Ship | Required (tests pass, no critical CVEs) | Self-approval |
| G5+ Ship onward | Required (deployment verification) | Self-approval |

**Skippable for Solo**: Formal postmortems, change advisory boards, multi-approver gates.
**Non-skippable for Solo**: Security basics, test verification, deployment checks.

**SMB/Agency Tier:**

| Gate | Enforcement | Approval |
|------|------------|----------|
| G0-1 Context -> Brainstorm | Lightweight | Tech lead review |
| G1-2 Brainstorm -> Design | Required (PRD exists) | Product + tech lead |
| G2-3 Design -> Build | Required (ADRs, threat model) | Tech lead sign-off |
| G3-4 Build -> Secure | Required (coverage %, linting) | PR-based peer review |
| G4-5 Secure -> Ship | Required (full security scan) | Tech lead + security review |
| G5+ Ship onward | Required (all verification) | Tech lead + product owner |

**Additional for SMB**: PR-based approvals, lightweight change log, quarterly security review.

**Enterprise Tier:**

| Gate | Enforcement | Approval |
|------|------------|----------|
| G0-1 Context -> Brainstorm | Required (full context package) | Project sponsor |
| G1-2 Brainstorm -> Design | Required (PRD + business case) | Product council |
| G2-3 Design -> Build | Required (full design package) | Architecture review board |
| G3-4 Build -> Secure | Required (coverage, SAST, peer review) | Tech lead + security team |
| G4-5 Secure -> Ship | Required (pen test, compliance check) | CISO/Security + CAB |
| G5+ Ship onward | Required (all verification + change record) | CAB + release manager |

**Additional for Enterprise**: Change Advisory Board, formal audit trails, RBAC for gate approvals, multi-repo coordination, scheduled release windows.

### Step 3: Define Approval Roles

Map organizational roles to gate approval responsibilities.

**Role Definitions:**

| Role | Solo | SMB | Enterprise |
|------|------|-----|-----------|
| Developer | Self (all roles) | Feature implementation | Feature implementation |
| Tech Lead | Self | Gate approvals, ADR decisions | Technical gate approvals |
| Product Owner | Self | Feature prioritization, exit criteria | Business gate approvals |
| Security Reviewer | Self (basic checks) | Rotating peer review | Dedicated security team |
| Release Manager | Self | Tech lead doubles | Dedicated role |
| CAB Member | N/A | N/A | Cross-functional board |
| Incident Commander | Self | On-call lead | Dedicated rotation |

### Step 4: Configure Audit Trail

Set up appropriate evidence collection for the governance tier.

**Solo/Startup Audit Trail:**
- Git commit history (natural artifact)
- `.agent/project-state.json` (project state)
- Gate check reports in `.agent/docs/gate-decisions/` (lightweight)

**SMB/Agency Audit Trail:**
- All Solo artifacts, plus:
- PR review records (GitHub/GitLab)
- Deployment logs with approval records
- Incident postmortems
- Quarterly security scan results

**Enterprise Audit Trail:**
- All SMB artifacts, plus:
- Formal change records (GitHub Issues with audit template)
- CAB meeting minutes and decisions
- Compliance evidence packages (per compliance_program skill)
- Access control audit logs
- Third-party assessment results (pen test, SOC 2 audit)
- Training and certification records

### Step 5: Multi-Developer Coordination

Patterns for teams larger than one developer.

**Branch Strategy by Tier:**

| Tier | Strategy | Rationale |
|------|----------|-----------|
| Solo | Trunk-based (commit to main) | Speed, no coordination overhead |
| SMB | Short-lived feature branches + PR | Peer review without bottleneck |
| Enterprise | GitFlow or trunk-based + feature flags | Scheduled releases, audit trail |

**Communication Patterns:**

| Tier | Standups | Phase Reviews | Retrospectives |
|------|----------|--------------|----------------|
| Solo | N/A | Self-review at gates | Journal/notes |
| SMB | Async (Slack/written) | Weekly with team | Bi-weekly |
| Enterprise | Daily sync | Formal gate reviews | Sprint-end |

### Step 6: Tier Migration

When a project outgrows its tier, migrate governance settings.

**Migration Triggers:**
- Solo -> SMB: Adding 4th developer, first paying customer, first compliance requirement
- SMB -> Enterprise: Regulatory audit requirement, 20+ developers, enterprise customer mandate

**Migration Process:**
1. Update `team_scale` in `.agent/project-state.json`
2. Review all active phase gates for new approval requirements
3. Set up any newly required tooling (audit logging, change management)
4. Brief team on new governance expectations
5. Run a trial gate check under new tier rules

---

## CHECKLIST

- [ ] Governance tier selected based on team/project assessment
- [ ] Phase gate rigor configured for selected tier
- [ ] Approval roles mapped to team members
- [ ] Audit trail level established and tooling configured
- [ ] Branch strategy selected and communicated
- [ ] Communication cadence established
- [ ] Team scale recorded in project-state.json
- [ ] Team briefed on governance expectations
- [ ] Migration triggers documented for future tier changes
- [ ] Governance configuration reviewed quarterly

---

*Skill Version: 1.0 | Cross-Phase: All (infrastructure) | Priority: P2*
