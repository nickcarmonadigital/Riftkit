---
name: Sprint Planning
description: Plan, estimate, and run 1-2 week sprints with story points, standups, and reviews
---

# Sprint Planning Skill

> **PURPOSE**: Break your product backlog into focused 1-2 week sprints so you ship consistently instead of drowning in an endless to-do list.

## 🎯 When to Use

- You are starting development and need to plan your first sprint
- You need to estimate how long features will take
- You want a lightweight process for tracking progress weekly
- You are a solo developer who wants structure without heavy process

---

## What Is a Sprint?

A sprint is a fixed time window (usually 1-2 weeks) where you commit to building a small set of features. At the end, you demo what you built and plan the next sprint.

```
Sprint Cycle:
Plan (1 hr) → Build (1-2 weeks) → Review (30 min) → Retro (30 min) → Repeat
```

---

## Step 1: Break Features into Stories

Take each feature from your backlog and break it into small, buildable pieces.

### Example: Breaking Down "User Authentication"

| Epic (Big Feature) | Stories (Buildable Pieces) |
|-------------------|--------------------------|
| User Authentication | 1. Email/password signup form |
| | 2. Login form with validation |
| | 3. Password reset via email |
| | 4. JWT token management |
| | 5. Protected route middleware |
| | 6. Logout and session cleanup |

**Rule of thumb**: If a story takes more than 3 days, break it down further.

---

## Step 2: Estimate with T-Shirt Sizing

T-shirt sizing is the simplest estimation method. It tells you relative effort, not exact hours.

| Size | Effort | Description | Example |
|------|--------|-------------|---------|
| **XS** | A few hours | Simple change, you have done it before | Change a button label, add a CSS style |
| **S** | Half a day to 1 day | Straightforward, minimal unknowns | Add a new form field, basic CRUD endpoint |
| **M** | 2-3 days | Some complexity, a few unknowns | Build a search feature, add file uploads |
| **L** | 4-5 days (full sprint week) | Significant complexity or new territory | Payment integration, complex dashboard |
| **XL** | More than 1 week | Too big -- must break down further | "Build the entire admin panel" |

### Converting to Story Points (Optional)

If you want numbers for tracking velocity:

| T-Shirt | Story Points |
|---------|-------------|
| XS | 1 |
| S | 2 |
| M | 5 |
| L | 8 |
| XL | 13 (break this down!) |

### Estimation Tips

- Estimate as a team if possible (avoids one person's blind spots)
- Compare stories to each other: "Is this bigger or smaller than Story X?"
- Include testing time in your estimate, not just coding
- When unsure, round up -- optimistic estimates are the #1 planning mistake

---

## Step 3: Plan the Sprint

### Sprint Capacity

Figure out how much work fits in one sprint.

**For a solo developer (1-2 week sprint)**:
```
Available days: 10 (2 weeks) or 5 (1 week)
Minus meetings/overhead: -1 day
Minus unexpected issues: -1 day
Actual build days: 8 (2-week) or 3 (1-week)
Story points capacity: ~20 (2-week) or ~8 (1-week)
```

**For a team of 3 developers (2-week sprint)**:
```
Available person-days: 30 (3 people x 10 days)
Minus meetings/overhead: -3 days
Minus unexpected issues: -3 days
Actual build days: 24
Story points capacity: ~60
```

### Sprint Planning Template

```
Sprint #: ___
Duration: [start date] to [end date]
Sprint Goal: [One sentence describing what you will accomplish]

COMMITTED STORIES:
| # | Story | Size | Points | Owner |
|---|-------|------|--------|-------|
| 1 |       |      |        |       |
| 2 |       |      |        |       |
| 3 |       |      |        |       |

Total points committed: ___
Capacity: ___
Buffer remaining: ___
```

### Example: Sprint 1 for a Task Manager App

```
Sprint #: 1
Duration: Feb 10 - Feb 21
Sprint Goal: Users can sign up, log in, and create their first task

COMMITTED STORIES:
| # | Story | Size | Points | Owner |
|---|-------|------|--------|-------|
| 1 | Email/password signup form | S | 2 | Alex |
| 2 | Login form with validation | S | 2 | Alex |
| 3 | JWT token management | M | 5 | Alex |
| 4 | Create task (title + description) | S | 2 | Jamie |
| 5 | List all tasks for a user | S | 2 | Jamie |
| 6 | Database schema + migrations | M | 5 | Jamie |

Total points committed: 18
Capacity: 20
Buffer remaining: 2 points
```

---

## Step 4: Daily Standups

A standup is a 15-minute daily check-in. Everyone answers three questions.

### Standup Format

```
1. DONE: What did I finish yesterday?
2. DOING: What am I working on today?
3. BLOCKED: Is anything stopping me?
```

### Example Standup Update

```
DONE: Finished the signup form, tests passing
DOING: Starting login form and validation today
BLOCKED: Need API endpoint spec for password reset -- waiting on Jamie
```

### Standup Rules

| Do | Do Not |
|----|--------|
| Keep it under 15 minutes | Turn it into a problem-solving session |
| Focus on blockers | Give detailed technical explanations |
| Stand up (literally) to keep it short | Wait until standup to raise urgent blockers |
| Write it in Slack if async works better | Skip it because "nothing changed" |

### Solo Developer Standup

Even solo developers benefit from a daily check-in. Write 3 lines in a log file or project notes each morning:

```
## Feb 10
- DONE: Auth endpoints complete
- DOING: Frontend login form
- BLOCKED: None

## Feb 11
- DONE: Login form done, found a bug in token refresh
- DOING: Fix token refresh, start task CRUD
- BLOCKED: None
```

---

## Step 5: Track Velocity

Velocity is how many story points you actually complete per sprint. After 2-3 sprints, it becomes your best planning tool.

### Velocity Tracker

| Sprint | Planned Points | Completed Points | Notes |
|--------|---------------|-----------------|-------|
| Sprint 1 | 18 | 15 | Underestimated auth complexity |
| Sprint 2 | 15 | 16 | Getting faster with the codebase |
| Sprint 3 | 16 | 17 | Smooth sprint |
| **Average** | | **16** | Use this for future planning |

**How to use velocity**: If your average velocity is 16 points per sprint, do not plan more than 16 points next sprint. Resist the temptation to "stretch."

---

## Step 6: Sprint Review

At the end of each sprint, demo what you built. Even if the audience is just yourself.

### Sprint Review Format (30 minutes)

```
1. SPRINT GOAL RECAP (2 min)
   - What we set out to do: _______________
   - Did we achieve it? Yes / Partially / No

2. DEMO (15 min)
   - Show each completed story working in the app
   - Get feedback from stakeholders or users

3. METRICS (5 min)
   - Stories completed: ___ / ___ planned
   - Points completed: ___ / ___ planned
   - Bugs found: ___
   - Carryover to next sprint: ___

4. WHAT WE LEARNED (5 min)
   - Surprises: _______________
   - Risks for next sprint: _______________

5. NEXT SPRINT PREVIEW (3 min)
   - Top priority for next sprint: _______________
```

---

## Step 7: Sprint Retrospective

After the review, run a quick retro to improve your process.

### Retro Format (30 minutes)

| Column | Question | Examples |
|--------|---------|---------|
| **Keep** | What went well? | "Breaking stories smaller helped" |
| **Stop** | What should we stop doing? | "Stop skipping daily standups" |
| **Start** | What should we try next sprint? | "Start writing tests before coding" |

### One Action Item Rule

Pick exactly ONE improvement to try next sprint. Not three. Not five. One. Make it specific and measurable.

```
Bad: "Write better code"
Good: "Every story gets at least one test before merging"
```

---

## Backlog Grooming

Once per week (or before sprint planning), spend 30 minutes cleaning the backlog.

### Grooming Checklist

- [ ] Remove stories that are no longer relevant
- [ ] Break down any story larger than L (8 points)
- [ ] Add acceptance criteria to stories coming up next sprint
- [ ] Re-prioritize based on recent learnings
- [ ] Ensure the top 10 stories are estimated and ready

---

## Solo Developer Adaptations

| Team Practice | Solo Adaptation |
|--------------|----------------|
| Sprint planning meeting | 30-minute planning session with yourself, write it down |
| Daily standup | 3-line daily log in your notes |
| Sprint review/demo | Record a quick screen capture or write a changelog |
| Retrospective | 5-minute journal entry: keep/stop/start |
| Pair estimation | Compare to previous stories you have completed |
| Backlog grooming | Review and re-order your task list weekly |

---

## ✅ Skill Complete When

- [ ] Backlog stories are broken down small enough (S or M size)
- [ ] Stories are estimated using T-shirt sizing or story points
- [ ] Sprint goal defined in one sentence
- [ ] Sprint capacity calculated and not overcommitted
- [ ] Daily standup format established (even if solo)
- [ ] First sprint review and retro completed
- [ ] Velocity tracked for at least 2 sprints
