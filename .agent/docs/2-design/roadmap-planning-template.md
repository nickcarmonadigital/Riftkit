# Roadmap Planning Template

> **Align what you're building with why you're building it — across weeks, months, and quarters.**

This template covers strategic roadmap planning for solo developers, small teams, and client projects. It bridges the gap between sprint-level planning (`sprint_planning` skill) and long-term product vision.

---

## When to Use This

| Situation | Use This Template |
|-----------|------------------|
| Starting a new project and need to plan the first 3 months | Yes |
| Client asking "when will feature X be ready?" | Yes |
| Need to decide what to build next vs what to defer | Yes |
| Multiple stakeholders pulling in different directions | Yes |
| Planning a single sprint's tasks | No — use `sprint_planning` skill |
| Bug triage or incident response | No — use `bug_troubleshoot` skill |

---

## Roadmap Format: Now / Next / Later

This is the most practical roadmap format for AI-assisted development. It avoids false precision (exact dates for work months away) while maintaining strategic direction.

```markdown
## [Product Name] Roadmap
**Last Updated**: [Date]
**Owner**: [Name]
**Review Cadence**: Bi-weekly

---

### NOW (Current Sprint / This Week-Two Weeks)
> Committed work. These are happening.

| Feature / Task | Status | Owner | Target |
|---|---|---|---|
| [Feature A] — [brief description] | In Progress | [Name] | [Date] |
| [Feature B] — [brief description] | Not Started | [Name] | [Date] |
| [Bug fix / tech debt item] | In Progress | [Name] | [Date] |

**Sprint Goal**: [One sentence describing what "done" looks like for this cycle]

---

### NEXT (2-6 Weeks Out)
> Planned and designed but not yet started. May shift based on NOW outcomes.

| Feature / Task | Why Now | Dependencies | Est. Effort |
|---|---|---|---|
| [Feature C] | [Business reason] | Requires Feature A | [S/M/L] |
| [Feature D] | [User research finding] | None | [S/M/L] |
| [Infrastructure improvement] | [Technical reason] | None | [S/M/L] |

**Key Decision Points**:
- [ ] [Decision needed before starting Feature C]
- [ ] [Dependency to resolve before Feature D]

---

### LATER (1-3 Months Out)
> Directional. Will be refined as we learn from NOW and NEXT.

| Theme | Features | Why It Matters | Confidence |
|---|---|---|---|
| [Theme 1: e.g., "Collaboration"] | [Feature E, F] | [Business justification] | Medium |
| [Theme 2: e.g., "Performance"] | [Feature G, H] | [Technical justification] | Low |
| [Theme 3: e.g., "Monetization"] | [Feature I, J] | [Revenue justification] | Medium |

**Open Questions**:
- [What do we need to learn before committing to Theme 1?]
- [What market signals would change our priorities?]

---

### NOT DOING (Explicitly Parked)
> Conscious decisions about what we're NOT building. This prevents scope creep.

| Idea | Why Not Now | Revisit When |
|---|---|---|
| [Feature X] | [Reason: not enough users, too expensive, etc.] | [Trigger: "when we hit 1k users"] |
| [Feature Y] | [Reason] | [Trigger] |
```

---

## Quarterly Roadmap (For Longer Planning)

Use this when you need a 3-6 month view, typically for client projects or product planning.

```markdown
## [Product Name] — Quarterly Roadmap

### Q[N] [Year] — Theme: "[Quarter Theme]"

**Quarter Goal**: [One sentence — what does success look like at the end of this quarter?]

**Key Results**:
1. [Measurable outcome — e.g., "Launch MVP to 50 beta users"]
2. [Measurable outcome — e.g., "Reduce page load to <2s"]
3. [Measurable outcome — e.g., "Pass security audit with zero critical findings"]

| Month | Focus Area | Key Deliverables | Risk |
|---|---|---|---|
| Month 1 | [e.g., Core features] | [Feature A, B launched] | [Identified risk] |
| Month 2 | [e.g., Polish + testing] | [E2E tests, a11y audit] | [Identified risk] |
| Month 3 | [e.g., Launch prep] | [Beta release, docs] | [Identified risk] |

**Dependencies**:
- [ ] [External dependency — e.g., "Client provides test accounts by Week 2"]
- [ ] [Technical dependency — e.g., "Database migration must complete before Feature B"]

**Budget Implications**:
- Infrastructure: $[amount]/month
- Third-party services: $[amount]/month
- AI/API costs: $[amount]/month (use `cost_estimation` skill)
```

---

## Milestone Tracking

For each major milestone, define clear completion criteria:

```markdown
## Milestone: [Name]

**Target Date**: [Date]
**Status**: 🔴 At Risk / 🟡 On Track / 🟢 Complete

### Definition of Done
- [ ] [Specific, verifiable criteria]
- [ ] [Specific, verifiable criteria]
- [ ] [Specific, verifiable criteria]

### What Could Delay This
| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| [Risk 1] | High/Med/Low | High/Med/Low | [What we'll do if it happens] |
| [Risk 2] | High/Med/Low | High/Med/Low | [What we'll do if it happens] |

### Dependencies
- **Blocked by**: [What must happen first]
- **Blocks**: [What can't start until this is done]
```

---

## Roadmap for Client Projects

When building for a client, the roadmap serves as a communication and expectation management tool.

```markdown
## Client Roadmap: [Project Name]

### Phase 1: Foundation (Weeks 1-2)
- [ ] Project setup & architecture (`/new-project` + `/2-design`)
- [ ] Database schema & API design
- [ ] Auth system implementation
- **Client Checkpoint**: Architecture review meeting

### Phase 2: Core Features (Weeks 3-6)
- [ ] [Feature A] — [description]
- [ ] [Feature B] — [description]
- [ ] [Feature C] — [description]
- **Client Checkpoint**: Demo of core features

### Phase 3: Polish & Security (Weeks 7-8)
- [ ] UI polish & responsive design
- [ ] Security audit (`/4-secure`)
- [ ] Performance optimization
- **Client Checkpoint**: Staging environment access

### Phase 4: Launch & Handoff (Weeks 9-10)
- [ ] Deployment (`/5-ship`)
- [ ] Documentation & training (`/6-handoff`)
- [ ] 2-week support buffer
- **Client Checkpoint**: Go-live decision meeting

### Change Request Policy
Any feature not in the original scope:
1. Document the request
2. Estimate impact on timeline and budget
3. Client approves in writing before work begins
4. Update this roadmap with the change
```

---

## Prioritization Integration

Connect your roadmap to prioritization frameworks (use `prioritization_frameworks` skill):

| Roadmap Slot | Prioritization Method | Best For |
|---|---|---|
| **NOW** | Sprint capacity — fits or doesn't | Committed work, no re-prioritization |
| **NEXT** | RICE scoring (Reach × Impact × Confidence / Effort) | Choosing between competing features |
| **LATER** | MoSCoW (Must/Should/Could/Won't) | Strategic alignment, theme-level |
| **NOT DOING** | Explicit trade-off documentation | Preventing scope creep |

---

## Roadmap Review Process

| Cadence | Activity | Participants | Output |
|---|---|---|---|
| **Weekly** | Update NOW status, flag blockers | Dev team | Updated task statuses |
| **Bi-weekly** | Review NEXT priorities, adjust based on learnings | Team + stakeholders | Roadmap adjustments |
| **Monthly** | Review LATER themes, validate direction | Team + leadership | Quarterly plan updates |
| **Quarterly** | Full roadmap refresh, retrospective on accuracy | All stakeholders | New quarterly plan |

### Review Questions

Ask these at every roadmap review:

1. **What did we learn in the last cycle that changes our priorities?**
2. **Is anything in NEXT blocked by something not in NOW?**
3. **Has any LATER item become urgent enough to move to NEXT?**
4. **Is anything in NOW no longer the highest priority?** (Be honest — sunk cost isn't a reason to continue)
5. **What should move to NOT DOING?** (Saying no is a feature, not a bug)

---

## Using AI for Roadmap Planning

| Task | Prompt |
|---|---|
| Generate a roadmap from a PRD | "Based on this PRD, create a Now/Next/Later roadmap with effort estimates for a solo developer." |
| Identify dependencies | "Analyze these features and identify which ones block others. Create a dependency graph." |
| Estimate timelines | "Given [team size] and [tech stack], estimate how long each feature would take. Flag any that seem risky." |
| Risk analysis | "What are the top 5 risks for this roadmap? For each, suggest a mitigation strategy." |
| Scope negotiation | "The client wants [all features] in [timeline]. What's realistic? Suggest what to cut or defer." |

---

## Anti-Patterns

| Anti-Pattern | Problem | Instead |
|---|---|---|
| Date-based roadmap for uncertain work | Creates false expectations, breeds distrust when missed | Use Now/Next/Later format |
| No "NOT DOING" section | Scope creeps silently | Explicitly park deferred items |
| Never updating the roadmap | Becomes fiction, team ignores it | Review bi-weekly minimum |
| Everything is "high priority" | Nothing is prioritized | Force-rank: if everything is P0, nothing is |
| Roadmap without milestones | No checkpoints to celebrate or course-correct | Define milestones with clear "done" criteria |
| Building what's easy instead of what matters | Progress without impact | Prioritize by user impact, not dev effort |

---

*Created: February 14, 2026*
*Part of the AI Development Workflow Framework v6.0*
*Related skills: sprint_planning, prioritization_frameworks, stakeholder_communication, cost_estimation*
