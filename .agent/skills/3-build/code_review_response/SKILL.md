---
name: code_review_response
description: How to receive, respond to, and learn from code reviews as a junior developer
---

# Code Review Response Skill

**Purpose**: Navigate code reviews professionally — receive feedback constructively, respond appropriately, and accelerate your growth through review patterns.

## 🎯 TRIGGER COMMANDS

```text
"How do I respond to this code review?"
"Help me handle review feedback"
"Prepare my PR for review"
"I got tough feedback on my PR"
"Using code_review_response skill"
```

## When to Use

- You received code review feedback and aren't sure how to respond
- You want to prepare a PR for review (self-review checklist)
- You're learning how to give reviews yourself
- You're dealing with a difficult or harsh review

---

## PART 1: MINDSET

**Core principles**:
1. Reviews are about the **code**, not about **you**
2. Every review is a **learning opportunity** — even if the feedback stings
3. Senior developers get reviewed too — it's not a sign of weakness
4. The reviewer is investing their time to help you — appreciate it
5. Your ego is not your code. Bad code is fixable. Defensiveness is harder to fix.

---

## PART 2: FEEDBACK TYPES

| Type | Example | How to Respond |
|------|---------|---------------|
| **Blocking** (Must fix) | "This has a SQL injection vulnerability" | Fix it. "Good catch, fixed in abc123" |
| **Suggestion** (Optional) | "Consider using a guard instead of inline check" | Apply or explain: "Great idea, updated" OR "I chose inline because..." |
| **Question** (Needs answer) | "Why did you choose cursor pagination here?" | Explain your reasoning clearly |
| **Nit** (Minor style) | "Nit: prefer `const` over `let` here" | Fix without argument. Not worth debating. |
| **Praise** | "Nice use of the strategy pattern here!" | "Thanks! I learned it from the auth module" |

---

## PART 3: RESPONSE PATTERNS

### Fix Applied
```
Reviewer: "This should validate the UUID format before querying"

You: "Good catch, added ParseUUIDPipe. Fixed in abc123."
```

### Thoughtful Pushback
```
Reviewer: "Extract this into a shared utility"

You: "I considered that, but this logic is specific to the dashboard
module and unlikely to be reused. The shared utility approach would
add abstraction without clear benefit. Would you still prefer extraction?"
```

### Learning Moment
```
Reviewer: "Use findUniqueOrThrow instead of findUnique + manual null check"

You: "I wasn't aware of findUniqueOrThrow — that's much cleaner. Updated.
I'll use this pattern going forward."
```

### Asking for Clarification
```
Reviewer: "This approach won't scale"

You: "Could you elaborate on the specific concern? Is it the N+1 query
pattern, or the data structure? I want to understand so I can improve."
```

### Disagreement (Respectful)
```
Reviewer: "Use a class-based approach instead of functional"

You: "I see the tradeoff. I went with functional because:
1. This component has no internal state
2. The team's existing components follow this pattern
3. It's easier to test as a pure function

Happy to discuss if you see benefits I'm missing."
```

---

## PART 4: WHEN TO PUSH BACK

Push back when:
- You have domain context the reviewer lacks
- The suggestion would introduce a regression
- The change is out of scope for this PR
- The team convention supports your approach

**How** to push back:
1. Acknowledge the reviewer's perspective first
2. Explain your reasoning with specifics
3. Ask for their input: "What do you think?"
4. Accept their decision gracefully if they insist

---

## PART 5: PR ETIQUETTE CHECKLIST

### Before Requesting Review

```
Self-Review:
[ ] I've read my own diff line by line
[ ] I've removed debug code (console.log, TODO comments)
[ ] I haven't left commented-out code
[ ] Variable/function names are clear

Quality:
[ ] Tests pass locally
[ ] Linter passes
[ ] No TypeScript errors
[ ] I've tested the happy path AND error paths manually

PR Description:
[ ] Title follows convention (feat/fix/chore)
[ ] What/Why/How sections filled out
[ ] Screenshots for UI changes
[ ] Testing instructions included

Size:
[ ] PR is under 400 lines (ideally under 200)
[ ] If larger, I've explained why it can't be split
```

### After Receiving Feedback

```
[ ] Read ALL comments before responding to any
[ ] Address every comment (even nits)
[ ] Don't resolve others' comments — let the reviewer resolve them
[ ] Leave a summary comment: "Addressed all feedback. Ready for re-review."
[ ] Re-request review
```

---

## PART 6: LEARNING FROM PATTERNS

### Keep a Review Lessons List

```markdown
## Code Review Lessons

### From PR #42 (2026-02-13)
- **Lesson**: Use `findUniqueOrThrow` instead of manual null checks
- **Applied**: Going forward in all Prisma queries

### From PR #38 (2026-02-10)
- **Lesson**: Always use `ParseUUIDPipe` on ID parameters
- **Applied**: Updated api_design skill with this pattern

### From PR #35 (2026-02-07)
- **Lesson**: Prefer explicit select over include for performance
- **Applied**: Dashboard queries now use select for list views
```

### Recurring Feedback Patterns

If you get the same feedback on 3+ PRs, that's a gap in your knowledge:
1. Note the pattern
2. Study it (read docs, ask the reviewer for resources)
3. Proactively apply it in future PRs
4. Mention it in standup: "I noticed I keep missing X, so I've started doing Y"

---

## PART 7: GROWING INTO A REVIEWER

### When to Start Reviewing

After ~2 months on a team, start reviewing other PRs:
- Other junior developers' PRs
- Small/simple PRs in areas you know
- Documentation and test PRs

### How to Give Good Reviews

```
BE SPECIFIC:
❌ "This name is bad"
✅ "Consider renaming `data` to `userProjects` to clarify what this contains"

BE KIND:
❌ "Why would you do this?"
✅ "I think there's a simpler approach — what if we..."

PRAISE GOOD WORK:
❌ (silence on good code)
✅ "Clean separation of concerns here — this will be easy to test"

EXPLAIN WHY:
❌ "Use an index here"
✅ "This query filters on `userId` which could be slow on large tables.
    Adding @@index([userId]) in the Prisma schema would help."

PREFIX YOUR INTENT:
✅ "Blocking: This exposes user passwords in the response"
✅ "Suggestion: Consider extracting this to a shared hook"
✅ "Nit: Missing trailing comma"
✅ "Question: Why cursor pagination instead of offset here?"
```

---

## ✅ Exit Checklist

- [ ] PR self-reviewed before requesting review
- [ ] All reviewer comments addressed
- [ ] Feedback responded to appropriately (fixed, explained, or discussed)
- [ ] Lessons learned documented
- [ ] Summary comment posted before re-requesting review
- [ ] No unresolved conversations remaining
