---
name: Incident Response Operations
description: Active incident lifecycle management from detection through post-mortem with on-call rotation, escalation trees, and SLA breach tracking.
---

# Incident Response Operations Skill

**Purpose**: Manages the full incident lifecycle: detect, triage, mitigate, resolve, and learn. This skill provides severity classification rubrics, blameless post-mortem templates, and action-item tracking to ensure production incidents are handled consistently and lessons are captured for continuous improvement.

## TRIGGER COMMANDS

```text
"Run incident response"
"Conduct post-mortem"
"Incident triage for [event]"
"Start incident for [service/event]"
"Post-mortem template for [incident]"
```

## When to Use
- An alert fires or a user reports a production issue
- After an incident resolves and a post-mortem is needed
- Setting up or reviewing on-call rotation and escalation policies
- Tracking SLA breach status during or after an incident

---

## PROCESS

### Step 1: Detection and Declaration

When an alert fires or an issue is reported, declare the incident immediately.

```markdown
## Incident Declaration

**Incident ID**: INC-[YYYY-MM-DD]-[SEQ]
**Declared**: [ISO timestamp]
**Declared By**: [Name]
**Initial Signal**: [Alert name / user report / monitoring dashboard]
**Affected Service(s)**: [service names]
**Customer Impact**: [Yes/No — describe if Yes]
```

Notification channels to activate:
- [ ] Dedicated incident Slack/Teams channel created
- [ ] On-call engineer paged
- [ ] Incident commander assigned

### Step 2: Triage and Severity Classification

Classify severity using this rubric:

| Severity | Criteria | Response Time | Update Cadence |
|----------|----------|---------------|----------------|
| **SEV-1 (Critical)** | Full outage, data loss, security breach | Immediate (< 15 min) | Every 15 min |
| **SEV-2 (Major)** | Degraded for >50% users, core feature down | < 30 min | Every 30 min |
| **SEV-3 (Minor)** | Degraded for <50% users, workaround exists | < 2 hours | Every 2 hours |
| **SEV-4 (Low)** | Cosmetic, non-impacting, internal tooling | Next business day | Daily |

Assign roles:
- **Incident Commander (IC)**: Coordinates response, makes decisions, communicates status
- **Technical Lead**: Investigates root cause and implements fix
- **Communications Lead**: Updates stakeholders, status page, customers

### Step 3: Mitigation (Reduce Impact NOW)

Priority is restoring user experience, not finding root cause.

| Mitigation Action | When to Use |
|-------------------|-------------|
| **Rollback deployment** | Issue started after a deploy |
| **Feature flag toggle** | Isolate specific feature |
| **Scale up infrastructure** | Capacity-related degradation |
| **Redirect traffic** | Regional or AZ-specific failure |
| **Enable maintenance page** | Full outage with no quick fix |
| **Database failover** | Primary DB unresponsive |

Document every action taken with timestamps:
```
[HH:MM] ACTION: [description] — BY: [name] — RESULT: [outcome]
```

### Step 4: Resolution

Once service is restored:
- [ ] Verify monitoring confirms recovery (metrics back to baseline)
- [ ] Confirm with affected users/teams that service is functional
- [ ] Remove any temporary mitigations (maintenance pages, traffic redirects)
- [ ] Document the root cause fix applied

### Step 5: Blameless Post-Mortem

Conduct within 48 hours of resolution. Use this template:

```markdown
# Post-Mortem: INC-[ID]

**Date**: [YYYY-MM-DD]
**Duration**: [start] to [end] ([total hours])
**Severity**: SEV-[1-4]
**Author**: [Name]
**Attendees**: [Names]

## Summary
[2-3 sentences: what happened, who was affected, how it was resolved]

## Timeline
| Time (UTC) | Event |
|------------|-------|
| HH:MM | Alert fired / issue reported |
| HH:MM | Incident declared, IC assigned |
| HH:MM | Root cause identified |
| HH:MM | Mitigation applied |
| HH:MM | Service fully restored |
| HH:MM | Incident closed |

## Impact
- **Users affected**: [count or percentage]
- **Revenue impact**: [estimated $ or "none"]
- **SLA impact**: [minutes of downtime against SLA budget]
- **Data impact**: [any data loss or corruption]

## Root Cause
[Detailed technical explanation. What broke and why.]

## Contributing Factors
- [Factor 1: e.g., missing monitoring on X]
- [Factor 2: e.g., deploy without canary]
- [Factor 3: e.g., insufficient load testing]

## What Went Well
- [e.g., Alert fired within 2 minutes]
- [e.g., Rollback was clean]

## What Could Be Improved
- [e.g., Runbook was outdated]
- [e.g., Escalation took 20 minutes]

## Action Items
| ID | Action | Owner | Due Date | Status |
|----|--------|-------|----------|--------|
| 1 | [action] | [name] | [date] | Open |
| 2 | [action] | [name] | [date] | Open |
```

### Step 6: Escalation Tree and On-Call Management

Define and maintain the escalation tree:

```
Level 0: Automated alert -> On-call engineer (PagerDuty/Opsgenie)
Level 1: On-call engineer -> Team lead (if no progress in 15 min)
Level 2: Team lead -> Engineering manager (if SEV-1 or no progress in 30 min)
Level 3: Engineering manager -> VP/CTO (if customer/revenue impact escalating)
```

On-call rotation cadence:
- **Rotation**: Weekly, handoff on Monday at 10:00 AM local
- **Handoff checklist**: Open incidents, known issues, upcoming deploys, runbook updates
- **Compensation**: Per company policy (time-off, pay differential)

---

## CHECKLIST

- [ ] Incident declared with ID, severity, and commander assigned
- [ ] Severity classified using the rubric (SEV-1 through SEV-4)
- [ ] Mitigation prioritized over root cause investigation
- [ ] All actions timestamped in the incident channel
- [ ] Service recovery verified through monitoring
- [ ] Blameless post-mortem conducted within 48 hours
- [ ] Action items assigned with owners and due dates
- [ ] Post-mortem document stored in team knowledge base
- [ ] Escalation tree reviewed and up to date
- [ ] On-call rotation schedule current for next 4 weeks

---

*Skill Version: 1.0 | Created: February 2026*
