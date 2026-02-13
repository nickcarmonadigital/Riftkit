---
name: Retrospective
description: Sprint retrospective formats, root cause analysis, and continuous improvement frameworks
---

# Retrospective Skill

> **PURPOSE**: Run effective retrospectives that turn team experience into concrete improvements, whether you are a team of ten or a solo developer.

## When to Use

- At the end of every sprint (every 1-2 weeks)
- After a production incident or outage
- After a major milestone or launch
- When the same problems keep happening
- As a solo developer reflecting on your own process

---

## Sprint Retrospective Format (60 Minutes)

| Phase | Duration | Activity |
|-------|----------|----------|
| **Check-in** | 5 min | One word describing the sprint (each person) |
| **Gather data** | 15 min | Everyone writes sticky notes for each category |
| **Group and vote** | 10 min | Cluster similar items, dot-vote on top 3 |
| **Discuss** | 20 min | Deep-dive the top-voted items |
| **Action items** | 10 min | Assign owners and deadlines for improvements |

### Ground Rules

- No blame. Focus on the process, not the person.
- Everyone speaks. Quiet voices often have the best insights.
- What is said in retro stays in retro (psychological safety).
- Every retro must produce at least one action item with an owner.

---

## Framework 1: Start / Stop / Continue

The simplest and most popular retrospective format. Each person answers three questions.

| Category | Question | Example |
|----------|----------|---------|
| **Start** | What should we begin doing? | "Start writing tests before merging PRs" |
| **Stop** | What should we stop doing? | "Stop scheduling meetings during focus blocks" |
| **Continue** | What is working well? | "Continue daily standups -- they are keeping us aligned" |

### How to Run It

1. Give everyone 5 minutes to write items on sticky notes (or a shared doc)
2. Go around the room -- each person shares one item at a time
3. Group similar items together
4. Vote on the top 3 items to act on
5. Assign an owner and deadline for each action item

### Real Example

```
START:
- Writing a one-line summary in every PR description
- Doing 15-minute pair debugging before escalating

STOP:
- Merging without at least one review
- Skipping standup on Fridays

CONTINUE:
- Using feature branches for every change
- Friday demos with the client (great feedback loop)
```

---

## Framework 2: Went Well / Did Not Go Well / Action Items

A variation that focuses more directly on outcomes.

```
WENT WELL:
- Shipped the auth module 2 days ahead of schedule
- Zero bugs reported from last sprint's features
- New team member onboarded smoothly

DID NOT GO WELL:
- Deployment took 4 hours due to migration issues
- Unclear requirements on the dashboard feature caused rework
- Missed the Friday deadline because of scope creep

ACTION ITEMS:
| Action | Owner | Deadline | Status |
|--------|-------|----------|--------|
| Create deployment checklist | Alex | Next Monday | Open |
| Require written acceptance criteria before starting work | Jordan | Immediately | Open |
| Add scope freeze after sprint planning | PM | Next sprint | Open |
```

---

## Framework 3: Five Whys Root Cause Analysis

When a problem keeps happening, do not just fix the symptom. Ask "why" five times to find the root cause.

### Real Example Walkthrough

**Problem**: The deployment failed on Friday and took 4 hours to fix.

| Level | Question | Answer |
|-------|----------|--------|
| Why 1 | Why did the deployment fail? | A database migration had a syntax error |
| Why 2 | Why was there a syntax error? | The migration was written by hand in a rush |
| Why 3 | Why was it rushed? | It was added at the last minute before deploy |
| Why 4 | Why was it last-minute? | The feature requirements changed on Thursday |
| Why 5 | Why did requirements change late? | The client gave feedback that was not captured in the spec |

**Root Cause**: Client feedback is not being captured in the spec before development begins.

**Fix**: Add a "client sign-off" step to the spec before any feature enters a sprint.

> You do not always need exactly five whys. Stop when you reach something you can actually change.

---

## Post-Mortem Template (For Incidents)

Use this after a production outage, data loss, security incident, or any event that impacted users.

```
# Post-Mortem: [Incident Title]
Date: [Date of incident]
Severity: [Critical / High / Medium / Low]
Duration: [How long users were affected]
Author: [Who is writing this]

## Summary
[2-3 sentences describing what happened and the impact]
Example: "The production database ran out of disk space at 2:14 PM EST,
causing all API requests to return 500 errors for 47 minutes.
Approximately 1,200 users were affected."

## Timeline
| Time | Event |
|------|-------|
| 2:14 PM | First error alerts triggered |
| 2:18 PM | On-call engineer acknowledged alert |
| 2:25 PM | Root cause identified: disk full |
| 2:40 PM | Temporary fix: cleared old logs, freed 20GB |
| 3:01 PM | All services restored and verified |

## Root Cause
[What actually caused the incident]
Example: "Log rotation was not configured. Application logs grew to
95GB over 3 months, consuming all available disk space."

## What Went Well
- Alert fired within 1 minute of the issue
- On-call engineer responded in 4 minutes
- Communication to stakeholders was clear and timely

## What Went Poorly
- No disk space monitoring or alerts
- No log rotation configured
- Runbook for this scenario did not exist

## Action Items
| Action | Owner | Deadline | Priority |
|--------|-------|----------|----------|
| Configure log rotation (max 1GB, 7 days) | DevOps | 2 days | Critical |
| Add disk space alert at 80% threshold | DevOps | 2 days | Critical |
| Create runbook for disk space incidents | PM | 1 week | High |
| Review all server disk allocations | DevOps | 1 week | Medium |

## Lessons Learned
[1-2 sentences about the takeaway]
"We need monitoring on infrastructure basics, not just application health."
```

> A post-mortem is blameless. Write "log rotation was not configured," not "Alex forgot to set up log rotation."

---

## Solo Developer Retrospective (Journal Format)

If you work alone, you still benefit from reflecting. Do this every Friday in 10 minutes.

```
# Weekly Retro - [Date]

## Wins This Week
- [What went right]
- [What you shipped]
- [What you learned]

## Frustrations
- [What slowed you down]
- [What was confusing or annoying]
- [Where you spent too much time]

## One Thing to Change Next Week
[Pick ONE specific change. Not three. One.]

Example: "I will write a 2-sentence plan before starting any task
instead of jumping straight into code."
```

---

## Action Item Tracking

Action items from retros are useless if nobody follows up. Track them.

| Action | Owner | Deadline | Status | Sprint |
|--------|-------|----------|--------|--------|
| Add PR description template | Alex | Feb 14 | Done | Sprint 5 |
| Set up error monitoring | Jordan | Feb 14 | In Progress | Sprint 5 |
| Create deployment checklist | Alex | Feb 21 | Open | Sprint 6 |

### Rules for Action Items

- Every item has ONE owner (not "the team")
- Every item has a deadline (not "sometime")
- Review last retro's action items at the START of the next retro
- If an action item carries over twice, either do it or drop it

---

## Common Anti-Patterns (What NOT to Do)

| Anti-Pattern | Why It is Bad | Fix |
|-------------|---------------|-----|
| **Blame game** | People stop being honest | Use blameless language: "the process failed" not "you failed" |
| **No action items** | Nothing changes, retros feel pointless | Require at least 1 action item per retro |
| **Same complaints every time** | Previous action items were not followed up | Review last retro's items first |
| **Only negatives** | Team morale drops | Always include "what went well" |
| **Skipping retros** | Problems compound silently | Make retros non-negotiable, even if short |
| **Manager dominates** | Team stays silent | Manager speaks last, not first |
| **Too many action items** | None get done | Max 3 action items per retro |

---

## Skill Complete When

- [ ] Sprint retrospective scheduled at a regular cadence
- [ ] At least one framework chosen (Start/Stop/Continue or Went Well/Did Not Go Well)
- [ ] Every retro produces 1-3 action items with owners and deadlines
- [ ] Previous retro action items reviewed at the start of each retro
- [ ] Post-mortem template used after any incident
- [ ] Five Whys used for recurring problems
- [ ] Solo developers using the weekly journal format

*Skill Version: 1.0 | Created: February 2026*
