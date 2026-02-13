---
name: Stakeholder Communication
description: Templates and frameworks for keeping stakeholders informed throughout a project
---

# Stakeholder Communication Skill

> **PURPOSE**: Provide ready-to-use templates and processes for communicating project status, blockers, and milestones to any audience.

## When to Use

- Sending weekly status updates to clients or leadership
- Presenting a roadmap or timeline to non-technical people
- Running a sprint review or demo session
- Escalating a blocker that threatens a deadline
- Figuring out who needs to know what (stakeholder mapping)

---

## Stakeholder Mapping (RACI Matrix)

Before you communicate anything, know who cares. Use a RACI matrix to map every stakeholder to a role.

| Letter | Role | What It Means | Example |
|--------|------|---------------|---------|
| **R** | Responsible | Does the work | Developer building the feature |
| **A** | Accountable | Owns the outcome, signs off | Project lead or product owner |
| **C** | Consulted | Gives input before decisions | Designer, subject matter expert |
| **I** | Informed | Gets updates after decisions | CEO, client stakeholder |

### Example RACI for a Feature Launch

| Activity | Dev | PM | Designer | Client | CEO |
|----------|-----|----|----------|--------|-----|
| Build feature | **R** | A | C | I | I |
| Design review | C | A | **R** | C | I |
| Go/no-go decision | C | **R** | C | A | I |
| Launch announcement | C | **R** | I | A | I |

> Fill this out at project kickoff. It prevents "I didn't know about that" surprises later.

---

## Meeting Cadence Recommendations

| Meeting | Frequency | Audience | Duration | Purpose |
|---------|-----------|----------|----------|---------|
| Daily standup | Daily | Dev team | 15 min | Blockers and progress |
| Sprint review | Every 1-2 weeks | Team + client | 30-60 min | Demo completed work |
| Status update email | Weekly | All stakeholders | N/A (async) | Written progress report |
| Roadmap review | Monthly | Client + leadership | 45 min | Big-picture timeline |
| Retrospective | End of sprint | Dev team | 60 min | Improve process |

---

## Weekly Status Update Template

Send this every Friday (or Monday morning). Keep it scannable -- executives read in under 60 seconds.

```
Subject: [Project Name] Weekly Update - Week of [Date]

Hi [Name],

## This Week: Accomplished
- Completed user authentication flow (login, signup, password reset)
- Fixed 3 bugs reported from last demo
- Deployed staging environment for client review

## In Progress
- Building dashboard analytics page (70% complete)
- Integrating payment gateway (waiting on API keys)

## Blocked
- Payment gateway API keys -- requested from [Name] on [Date]
  Impact: Delays checkout feature by ~3 days if not resolved by Wednesday

## Next Week
- Complete dashboard page
- Begin notification system
- Prepare sprint review demo for Friday

Overall Status: ON TRACK / AT RISK / BLOCKED
```

### Tips for Status Updates

- Lead with accomplishments so people see progress
- Be specific about blockers: who, what, when, and impact
- Use "ON TRACK / AT RISK / BLOCKED" so readers get the headline instantly
- Attach screenshots or short recordings when possible

---

## Milestone Communication Template

Use this at major project checkpoints (design complete, MVP ready, launch day).

```
Subject: [Project Name] Milestone Reached: [Milestone Name]

Hi team,

We have reached a key milestone: [Milestone Name].

## What Was Delivered
- [Feature/deliverable 1]
- [Feature/deliverable 2]
- [Feature/deliverable 3]

## What This Means
[One sentence explaining the significance in plain language]
Example: "Users can now sign up, log in, and manage their profile --
the core account experience is complete."

## What Comes Next
- [Next milestone name] -- target date: [Date]
- Key activities: [brief list]

## Action Needed
- [Name]: Please review staging at [URL] by [Date]
- [Name]: Approve design for next phase by [Date]

Thanks,
[Your name]
```

---

## Sprint Review / Demo Format

A sprint review is a live demo of what was built. Structure it so non-technical people can follow.

| Section | Duration | What to Do |
|---------|----------|------------|
| **Context** | 2 min | Remind everyone what the sprint goal was |
| **Demo** | 15-20 min | Show working software, not slides |
| **Feedback** | 10 min | Ask specific questions, take notes |
| **Next Sprint** | 5 min | Preview what comes next |

### Demo Tips

- Demo on staging, not localhost
- Prepare a script so you don't fumble during the demo
- Show the user journey, not individual features
- Have a backup recording in case something breaks live
- End each demo item with: "Any questions about this before I move on?"

---

## Blocker Escalation Process

A blocker is anything that prevents you from making progress. Escalate early -- waiting makes it worse.

### When to Escalate

| Situation | Action |
|-----------|--------|
| Stuck for more than 4 hours | Mention in standup or message PM |
| Waiting on someone for 24+ hours | Send a direct follow-up with deadline |
| Waiting on someone for 48+ hours | Escalate to their manager or your PM |
| Deadline at risk | Immediately notify PM and client |

### Escalation Message Template

```
Subject: BLOCKER: [Short description]

Hi [PM/Manager],

I am blocked on [task name] and need help resolving it.

What I need: [specific thing -- API keys, design decision, access, etc.]
Who I need it from: [Name]
When I first asked: [Date]
Impact if not resolved: [what gets delayed and by how long]

Can you help unblock this? Happy to jump on a quick call.

Thanks,
[Your name]
```

> Never frame blockers as blame. Frame them as "I need help with X so I can deliver Y on time."

---

## Email Templates by Audience

### Executive / CEO (Keep it to 3 sentences)

```
Subject: [Project] Status: On Track for [Date] Launch

[Project] is on track. We completed [milestone] this week and begin
[next phase] Monday. One risk to watch: [brief description of any risk].
```

### Technical Lead / Developer

```
Subject: [Project] Sprint 4 Wrap-up

Merged 12 PRs this sprint. Auth module is complete and passing all tests.
Dashboard has a known performance issue with large datasets (>10k rows) --
will address in Sprint 5 with pagination. Staging: [URL]
```

### Client / Non-Technical Stakeholder

```
Subject: [Project] Your App Update - Week of [Date]

Hi [Name],

Here is what changed in your app this week:
- Users can now reset their password via email
- The dashboard loads 3x faster than last week
- We fixed the issue where notifications were not appearing on mobile

You can try it here: [staging URL]
Please share any feedback by [Date] so we can include it in next week's work.
```

---

## Roadmap Communication

When presenting a timeline to non-technical people, simplify.

### Do This

```
Phase 1 (Jan-Feb):  Foundation -- accounts, login, core database
Phase 2 (Mar):      Features -- dashboard, reports, notifications
Phase 3 (Apr):      Polish -- mobile optimization, performance, testing
Phase 4 (May):      Launch -- go live, monitor, fix issues
```

### Do NOT Do This

```
Sprint 1: Set up NestJS with Prisma ORM, configure PostgreSQL...
Sprint 2: Implement JWT authentication with refresh token rotation...
```

> Non-technical people care about outcomes, not technologies. Translate sprints into plain-language phases.

---

## Skill Complete When

- [ ] RACI matrix created for your project
- [ ] Weekly status update being sent consistently
- [ ] Milestone communications sent at each major checkpoint
- [ ] Sprint reviews follow the Context > Demo > Feedback > Next format
- [ ] Blockers escalated within 24 hours with impact clearly stated
- [ ] Email tone adjusted per audience (executive, technical, client)
- [ ] Roadmap presented in plain language with outcome-focused phases

*Skill Version: 1.0 | Created: February 2026*
