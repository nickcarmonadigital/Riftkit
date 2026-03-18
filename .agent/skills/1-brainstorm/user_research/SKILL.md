---
name: user_research
description: Validate assumptions before building — user interviews, usability testing, feedback synthesis, and research-driven prioritization
---

# User Research & Usability Testing Skill

**Purpose**: Validate product assumptions directly with users before committing engineering time. Covers research planning, interview execution, usability testing, feedback synthesis, and translating findings into actionable product decisions.

## TRIGGER COMMANDS

```text
"run user research for [feature]"
"plan a usability test"
"create interview guide for [topic]"
"synthesize user feedback"
"validate this assumption with users"
"Using user_research skill: [research question]"
```

---

## WHEN TO USE

| Situation | Use This Skill |
|-----------|---------------|
| About to build a major feature and unsure if users want it | Yes — before writing any code |
| Prototype or MVP exists but no user feedback yet | Yes — validate before scaling |
| Users churning but you don't know why | Yes — discovery interviews |
| Choosing between two design approaches | Yes — preference testing |
| Post-launch feature getting low adoption | Yes — usability audit |
| Bug fix with clear reproduction steps | No — just fix it |
| Adding a feature the client explicitly requested and specified | No — already validated |

---

## THE RESEARCH PROCESS

### Phase 1: Define the Research Question

Before talking to anyone, answer these:

```markdown
## Research Brief

### What assumption are we testing?
[One clear sentence: "We believe [users] will [behavior] because [reason]"]

### What decision does this inform?
[What will you BUILD or CHANGE based on the answer?]

### What would make us WRONG?
[What evidence would disprove our assumption?]

### Research method:
[ ] Discovery interviews (we don't know what we don't know)
[ ] Usability testing (we have something to test)
[ ] Survey (we need quantitative validation at scale)
[ ] A/B test (we need to compare two live options)
```

**Rule**: If you can't state the assumption in one sentence, you're not ready to research. Narrow it down.

---

### Phase 2: Choose Your Method

| Method | When to Use | Sample Size | Time Investment | Confidence |
|--------|-------------|-------------|-----------------|------------|
| **Discovery Interview** | Don't know what to build | 5-8 users | 30 min each | Directional |
| **Usability Test** | Have a prototype/product | 5 users | 20-45 min each | High for UX issues |
| **Survey** | Need numbers to validate | 50-200+ responses | 5-10 min per respondent | Statistical |
| **Card Sort** | Designing information architecture | 15-30 users | 15 min each | High for IA |
| **A/B Test** | Comparing two live options | 1,000+ per variant | Days-weeks of traffic | Statistical |
| **5-Second Test** | Testing first impressions | 20-30 users | 5 seconds each | Directional |

**The 5-user rule**: Jakob Nielsen's research shows that 5 users catch ~85% of usability problems. You don't need hundreds — you need 5 well-chosen participants.

---

### Phase 3: Discovery Interviews

Use when you're exploring a problem space and don't have a solution yet.

#### Interview Guide Template

```markdown
## Interview Guide: [Topic]

### Warm-up (2 min)
- "Tell me about your role and what you do day-to-day."
- "How long have you been doing [relevant activity]?"

### Current Behavior (10 min)
- "Walk me through the last time you [did the thing we're researching]."
- "What tools or processes did you use?"
- "What was the hardest part?"
- "How did you work around that?"

### Pain Points (10 min)
- "What frustrates you most about [current process]?"
- "If you could change one thing, what would it be?"
- "How much time/money does this problem cost you?"

### Reaction to Concept (5 min)
[Only if you have a concept to test — don't lead the witness]
- "If I told you there was a tool that [concept], what's your reaction?"
- "What would make you trust it?"
- "What would stop you from using it?"

### Wrap-up (3 min)
- "Is there anything I didn't ask that I should have?"
- "Do you know anyone else who faces this problem?"
```

#### Interview Best Practices

| Do | Don't |
|----|-------|
| Ask open-ended questions ("Tell me about...") | Ask leading questions ("Don't you think...?") |
| Follow up with "Why?" at least 3 times | Accept the first answer as the real answer |
| Listen more than you talk (80/20 rule) | Pitch your solution during the interview |
| Record (with permission) so you can focus | Try to take perfect notes live |
| Ask about past behavior ("Last time you...") | Ask about hypothetical future ("Would you...?") |
| Stay silent after asking — let them fill the gap | Fill silence with your own opinions |

#### The "Mom Test" Rules

From Rob Fitzpatrick's *The Mom Test* — rules for getting honest feedback:

1. **Talk about their life, not your idea** — "Tell me about the last time you managed a project" (good) vs "Would you use a project management tool?" (bad)
2. **Ask about specifics in the past, not generics about the future** — "What did you do last Tuesday when that happened?" (good) vs "What would you usually do?" (bad)
3. **Talk less, listen more** — If you're talking more than 20% of the time, you're pitching, not researching
4. **Bad data: compliments, hypotheticals, and generics** — "That sounds cool!" means nothing. "I searched for a solution last week and tried 3 tools" means everything.

---

### Phase 4: Usability Testing

Use when you have a prototype, mockup, or live product to test.

#### Usability Test Script

```markdown
## Usability Test: [Feature/Flow]

### Setup (2 min)
"I'm going to show you [product/prototype] and ask you to complete some tasks.
I'm testing the product, not you — there are no wrong answers.
Please think out loud — tell me what you're looking at, what you expect, and what confuses you."

### Task 1: [Primary task]
"Imagine you need to [goal]. Starting from this screen, show me how you'd do that."

Observe:
- [ ] Did they find the starting point?
- [ ] Did they follow the expected path?
- [ ] Where did they hesitate?
- [ ] Did they complete the task?
- [ ] How long did it take?

### Task 2: [Secondary task]
"Now I'd like you to [second goal]."
[Same observation checklist]

### Task 3: [Edge case or error recovery]
"What would you do if [error scenario]?"
[Same observation checklist]

### Post-Test Questions
- "On a scale of 1-5, how easy was that?" (SUS-style)
- "What was the most confusing part?"
- "What did you expect to happen when you clicked [element]?"
- "How would you describe this product to a friend?"
```

#### Severity Rating for Issues Found

| Severity | Definition | Action |
|----------|-----------|--------|
| **Critical** | User cannot complete the task at all | Fix before launch |
| **Major** | User completes task but with significant difficulty or errors | Fix in current sprint |
| **Minor** | User notices the issue but works around it easily | Fix in next sprint |
| **Cosmetic** | User doesn't notice unless asked, or it's purely aesthetic | Backlog |

---

### Phase 5: Surveys

Use when you need quantitative validation at scale.

#### Survey Design Rules

1. **Keep it under 10 questions** — completion rate drops 15% per additional question after 10
2. **One concept per question** — "Is the app fast and easy to use?" is two questions
3. **Avoid leading language** — "How much do you love feature X?" assumes they love it
4. **Mix question types** — Likert scale (1-5), multiple choice, and 1-2 open text
5. **Put demographic questions last** — they're boring and cause dropoff
6. **Test with 3 people first** — if they misinterpret any question, rewrite it

#### Question Types That Actually Work

| Type | Example | When to Use |
|------|---------|-------------|
| **Likert scale (1-5)** | "How easy was it to [task]?" | Measuring satisfaction/difficulty |
| **Ranking** | "Rank these features by importance" | Prioritization (max 5 items) |
| **Multiple choice** | "Which best describes your role?" | Segmentation |
| **Open text** | "What's the one thing you'd change?" | Discovery (limit to 1-2 per survey) |
| **NPS** | "How likely are you to recommend (0-10)?" | Overall satisfaction benchmark |
| **Task success** | "Were you able to complete [task]? Yes/No" | Usability measurement |

---

### Phase 6: Synthesize Findings

After collecting data, don't just dump raw notes — synthesize into actionable insights.

#### The Synthesis Framework

```markdown
## Research Synthesis: [Research Question]

### Participants
- [N] users interviewed/tested
- Segments: [roles, experience levels, etc.]

### Key Findings (max 5)

**Finding 1: [One-sentence summary]**
- Evidence: [Quotes, observations, data points]
- Confidence: High / Medium / Low
- Impact: [What happens if we ignore this?]

**Finding 2: ...**

### Patterns Observed
| Pattern | # Users | Representative Quote |
|---------|---------|---------------------|
| [Behavior/pain point] | 4/5 | "Exact quote from user" |
| [Behavior/pain point] | 3/5 | "Exact quote from user" |

### Recommendations
| Priority | Recommendation | Finding It Addresses | Effort |
|----------|---------------|---------------------|--------|
| P0 | [What to do] | Finding 1, 3 | [S/M/L] |
| P1 | [What to do] | Finding 2 | [S/M/L] |

### What We Still Don't Know
- [Questions that emerged from this research]
- [Follow-up research needed]
```

#### Synthesis Anti-Patterns

| Anti-Pattern | Problem | Instead Do |
|---|---|---|
| Cherry-picking quotes that support your idea | Confirmation bias | Include ALL findings, even uncomfortable ones |
| "Users want feature X" | Users describe problems, not solutions | "Users struggle with [problem]" |
| Treating 1 loud user as representative | Availability bias | Track patterns across 3+ users |
| Waiting for "enough" data to decide | Analysis paralysis | 5 users is enough for most usability decisions |
| Presenting 50 pages of raw notes | Information overload | Synthesize into max 5 findings + recommendations |

---

### Phase 7: Research-Driven Prioritization

Connect research findings to your backlog using this mapping:

```markdown
## Research → Backlog Mapping

| Finding | User Impact | Frequency | Backlog Item | Priority |
|---------|-----------|-----------|-------------|----------|
| Users can't find settings | Can't configure app | 4/5 users | Redesign settings nav | P0 |
| Export takes too long | Wastes time, workaround exists | 2/5 users | Async export with notification | P1 |
| Want dark mode | Preference, not blocking | 1/5 users | Add dark mode toggle | P2 |
```

**Prioritization formula**:
- **P0**: Blocks core task + affects majority of users → Fix now
- **P1**: Causes friction + affects some users → This sprint
- **P2**: Enhancement request + affects few users → Backlog

---

## USING AI FOR RESEARCH

AI can accelerate (but not replace) user research:

| Task | AI Can Help With | AI Cannot Replace |
|------|-----------------|------------------|
| Interview guide creation | Generate question templates | Reading body language, building rapport |
| Note taking | Transcribe and summarize recordings | Being present in the conversation |
| Synthesis | Identify themes across transcripts | Judging which themes matter most |
| Survey design | Draft questions, check for bias | Understanding your specific user context |
| Competitive analysis | Analyze competitor features at scale | Understanding why users prefer one over another |

**Prompt for AI-assisted synthesis**:
```
Here are transcripts from [N] user interviews about [topic].

Identify:
1. The top 5 recurring themes (with supporting quotes)
2. Any contradictions between users
3. Patterns in user behavior (what they DO vs what they SAY)
4. Recommended next steps ranked by frequency × impact
```

---

## RESEARCH CADENCE

| Project Phase | Research Activity | Time Investment |
|---|---|---|
| **Before building** (brainstorm/design) | Discovery interviews (5 users) | 1-2 days |
| **After prototype** (design/build) | Usability test (5 users) | 1 day |
| **After MVP launch** | NPS survey + follow-up interviews | Half day |
| **Ongoing** | In-app feedback analysis | 1 hour/week |
| **Before major pivot** | Discovery interviews + competitive analysis | 2-3 days |

---

## EXIT CHECKLIST

- [ ] Research question clearly defined (one sentence)
- [ ] Method chosen matches the question type
- [ ] Participants recruited (minimum 5 for qualitative)
- [ ] Interview guide / test script prepared
- [ ] Sessions conducted (recorded with permission)
- [ ] Findings synthesized into max 5 key insights
- [ ] Recommendations mapped to backlog items with priorities
- [ ] Stakeholders briefed on findings
- [ ] Follow-up research questions documented

---

*Skill Version: 1.0 | Created: February 14, 2026*


## Related Skills
- [`assumption_testing`](../assumption_testing/SKILL.md)
