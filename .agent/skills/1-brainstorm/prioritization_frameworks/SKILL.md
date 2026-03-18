---
name: Prioritization Frameworks
description: Score and rank features using RICE, MoSCoW, and Kano to build the right things first
triggers:
  - "/prioritization"
  - "/prioritization-frameworks"
  - "/rice"
  - "/moscow"
  - "/rank-features"
---

# Prioritization Frameworks Skill

> **PURPOSE**: Help you decide which features to build first using proven scoring methods, so you stop guessing and start shipping what matters most.

## 🎯 When to Use

- You have more ideas than time and need to pick what to build next
- Stakeholders disagree on priorities and you need an objective framework
- You are planning a new product and need to sequence the feature backlog
- You want to validate that your current roadmap order makes sense

---

## Framework 1: RICE Scoring

RICE gives every feature a single score so you can rank them objectively.

**Formula**: `RICE Score = (Reach x Impact x Confidence) / Effort`

| Factor | What It Means | How to Score |
|--------|--------------|-------------|
| **Reach** | How many users will this affect per quarter? | Estimate a number (e.g., 500 users) |
| **Impact** | How much will it move the needle per user? | 3 = massive, 2 = high, 1 = medium, 0.5 = low, 0.25 = minimal |
| **Confidence** | How sure are you about these estimates? | 100% = high, 80% = medium, 50% = low |
| **Effort** | How many person-weeks to build? | Estimate in person-weeks (e.g., 4) |

### RICE Example: Scoring 3 Features

| Feature | Reach | Impact | Confidence | Effort | RICE Score |
|---------|-------|--------|------------|--------|-----------|
| Email notifications | 2000 | 2 | 80% | 3 weeks | (2000 x 2 x 0.8) / 3 = **1067** |
| Dark mode | 800 | 1 | 100% | 2 weeks | (800 x 1 x 1.0) / 2 = **400** |
| Admin dashboard | 50 | 3 | 50% | 8 weeks | (50 x 3 x 0.5) / 8 = **9.4** |

**Result**: Build email notifications first -- highest score by far.

---

## Framework 2: MoSCoW Method

MoSCoW sorts features into four buckets. Use it when you need a quick, team-friendly conversation rather than precise math.

| Category | Meaning | Rule of Thumb |
|----------|---------|--------------|
| **Must Have** | Product fails without it | Non-negotiable for launch |
| **Should Have** | Important but not critical | Include if time permits |
| **Could Have** | Nice to have | Only if everything else is done |
| **Won't Have** | Not now | Explicitly off the table this cycle |

### MoSCoW Example: MVP for a Task Manager App

| Feature | Category | Reason |
|---------|----------|--------|
| Create/edit tasks | Must Have | Core purpose of the app |
| User authentication | Must Have | Users need accounts |
| Due date reminders | Should Have | Very useful but app works without it |
| Drag-and-drop reorder | Could Have | Polish feature, not essential |
| Calendar integration | Won't Have | Save for v2 |

**Tip**: Must Haves should be about 60% of your total effort. If everything is a "Must Have," you have not prioritized.

---

## Framework 3: Kano Model

Kano classifies features by how they affect user satisfaction. It helps you find features that create delight versus features that just prevent complaints.

| Category | User Expectation | Effect When Present | Effect When Missing |
|----------|-----------------|--------------------|--------------------|
| **Basic** (Must-be) | Users assume it exists | No extra satisfaction | Frustration and complaints |
| **Performance** (Linear) | Users explicitly want it | More = happier | Less = less happy |
| **Excitement** (Delighter) | Users do not expect it | Surprise and delight | No negative effect |

### Kano Example: Hotel Booking App

| Feature | Category | Why |
|---------|----------|-----|
| Search by date and location | Basic | Users will leave if this is missing |
| Filter by price, rating, amenities | Performance | More filters = happier users |
| "Surprise me" random destination picker | Excitement | Unexpected and fun |
| Page loads in under 2 seconds | Basic | Slow = instant uninstall |
| Loyalty points tracker | Performance | More visible points = more engagement |

**Strategy**: Cover all Basics first. Compete on Performance. Win hearts with at least one Excitement feature.

---

## Choosing the Right Framework

| Situation | Use This | Why |
|-----------|----------|-----|
| You have 10+ features to rank | RICE | Gives precise numeric ranking |
| Quick team alignment on what's in/out | MoSCoW | Fast, no math needed |
| Planning user experience and delight | Kano | Focuses on satisfaction, not just business value |
| Presenting to executives | RICE | Numbers are persuasive |
| Sprint planning with dev team | MoSCoW | Easy to discuss in a meeting |
| Designing a new product category | Kano | Identifies table-stakes vs differentiators |

---

## Combined Decision Matrix Template

For important decisions, combine frameworks into one view:

| Feature | RICE Score | MoSCoW | Kano Type | Final Priority |
|---------|-----------|--------|-----------|---------------|
| User login | 1200 | Must | Basic | P0 - Build first |
| Search filters | 900 | Should | Performance | P1 - Build second |
| Social sharing | 300 | Could | Excitement | P2 - Build if time |
| Custom themes | 50 | Won't | Excitement | P3 - Next quarter |

### Priority Levels

| Level | Meaning |
|-------|---------|
| P0 | Must ship this cycle, no exceptions |
| P1 | Should ship this cycle, high value |
| P2 | Ship if capacity allows |
| P3 | Backlog for future cycle |

---

## Common Mistakes to Avoid

| Mistake | Why It Hurts | What to Do Instead |
|---------|-------------|-------------------|
| Everything is P0 | Nothing is actually prioritized | Limit P0 to 3-5 items max |
| Skipping effort estimates | Low-value expensive features sneak in | Always factor in cost to build |
| Only using gut feeling | Loudest voice wins, not best idea | Use a scoring framework |
| Never re-prioritizing | Priorities change as you learn | Re-score every 2-4 weeks |
| Ignoring Basic/Kano features | Users churn from missing basics | Cover table stakes before adding delight |

---

## ✅ Skill Complete When

- [ ] Features listed and described
- [ ] At least one framework applied (RICE, MoSCoW, or Kano)
- [ ] Each feature has a priority level (P0-P3)
- [ ] Team agrees on the top 3-5 items to build next
- [ ] Backlog is ordered by priority, not by when the idea was added
