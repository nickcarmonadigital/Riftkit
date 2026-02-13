---
name: User Story Standards
description: Write clear user stories with acceptance criteria using proven formats and quality checks
---

# User Story Standards Skill

> **PURPOSE**: Turn vague feature ideas into clear, testable user stories that any developer can understand and build from.

## 🎯 When to Use

- You have a feature idea but no clear requirements written down
- A developer asks "what exactly should this do?"
- You need acceptance criteria before starting a sprint
- You want to verify that a story is ready for development

---

## Format 1: Classic User Story

The most widely used format. Answers: who, what, and why.

```
As a [type of user],
I want [an action or feature],
so that [benefit or reason].
```

### Good vs Bad Examples

| Bad Story | Problem | Good Story |
|-----------|---------|------------|
| "Add search" | No user, no reason | "As a shopper, I want to search products by name, so that I can quickly find what I need" |
| "Make it faster" | Vague, not measurable | "As a user, I want the dashboard to load in under 2 seconds, so that I can check my data without waiting" |
| "Users should be able to do stuff with their account" | Way too vague | "As a registered user, I want to update my email address, so that I can receive notifications at my current email" |
| "Build the API" | Technical task, not user value | "As a mobile app, I want to fetch user profiles via API, so that users see their info on any device" |

---

## Format 2: Gherkin (Given/When/Then)

Use Gherkin when you need precise, testable behavior. These double as automated test scripts.

```
Given [a starting condition],
When [an action happens],
Then [the expected result].
```

### Gherkin Examples

**Login feature**:
```
Given I am on the login page,
When I enter a valid email and password and click "Sign In",
Then I am redirected to my dashboard and see a welcome message.

Given I am on the login page,
When I enter an incorrect password and click "Sign In",
Then I see an error message "Invalid email or password" and remain on the login page.
```

**Shopping cart**:
```
Given I have 2 items in my cart,
When I remove 1 item,
Then my cart shows 1 item and the total updates.

Given my cart is empty,
When I click "Checkout",
Then I see a message "Your cart is empty" and a link to continue shopping.
```

---

## Format 3: Jobs-To-Be-Done (JTBD)

JTBD focuses on the underlying motivation, not just the surface action. Use it for discovery and product strategy.

```
When [situation/trigger],
I want to [motivation/action],
so I can [expected outcome].
```

### JTBD Examples

| Situation | Motivation | Outcome |
|-----------|-----------|---------|
| When I finish a project milestone | I want to notify my client automatically | So I can keep them informed without writing emails manually |
| When I onboard a new team member | I want to share a single link with all docs | So I can get them productive in hours, not days |
| When my monthly costs are rising | I want to see a cost breakdown by category | So I can identify which area to cut |

**Tip**: JTBD stories are great for brainstorming. Convert them to Classic or Gherkin format before handing to developers.

---

## Writing Acceptance Criteria

Acceptance criteria define when a story is "done." Every story needs them.

### Rules for Good Acceptance Criteria

| Rule | Example |
|------|---------|
| **Specific** | "Password must be 8+ characters" not "Password should be secure" |
| **Measurable** | "Page loads in under 3 seconds" not "Page should be fast" |
| **Testable** | "Error message appears below the field" not "User knows something went wrong" |
| **Independent** | Each criterion can be verified on its own |

### Acceptance Criteria Template

```
Story: As a user, I want to reset my password.

Acceptance Criteria:
1. User clicks "Forgot Password" on the login page
2. System asks for email address
3. If email exists, system sends a reset link (valid for 1 hour)
4. If email does not exist, system shows the same success message (no user enumeration)
5. Reset link opens a form to enter a new password
6. New password must be at least 8 characters with 1 number
7. After resetting, user is redirected to login with a success message
8. Old password no longer works
```

---

## Story Mapping

Story mapping helps you plan releases by visualizing the user journey.

```
BACKBONE (user journey steps, left to right):
  Sign Up → Browse → Purchase → Receive → Review

WALKING SKELETON (minimum for each step):
  Email signup → List products → Cart + checkout → Email confirmation → Star rating

ITERATION 2 (add depth):
  Social login → Search + filter → Saved payment → Tracking page → Written reviews

ITERATION 3 (add polish):
  Profile page → Recommendations → Wishlist → Returns → Photo reviews
```

**How to read it**: Each row is a release. Row 1 (walking skeleton) is your MVP. Ship it first. Then layer on rows 2, 3, etc.

---

## INVEST Quality Check

Before a story goes to development, check it against INVEST:

| Letter | Criterion | Question to Ask | Red Flag |
|--------|-----------|----------------|----------|
| **I** | Independent | Can this be built without waiting for another story? | "We need story #5 done first" |
| **N** | Negotiable | Can the team discuss how to implement it? | Overly prescriptive ("use React, use this exact API") |
| **V** | Valuable | Does this deliver value to the user or business? | Pure tech debt with no user benefit |
| **E** | Estimable | Can the team estimate how long it takes? | "We've never done anything like this" |
| **S** | Small | Can it be built in one sprint (1-2 weeks)? | "This will take 3 months" |
| **T** | Testable | Can you write a test to verify it works? | "It should feel good to use" |

### INVEST Scoring

Rate each criterion 1-3. A story needs at least 12/18 to be ready.

| Criterion | Score (1-3) | Notes |
|-----------|------------|-------|
| Independent | | |
| Negotiable | | |
| Valuable | | |
| Estimable | | |
| Small | | |
| Testable | | |
| **Total** | /18 | 12+ = ready |

---

## Quick Reference: Which Format When?

| Situation | Format | Why |
|-----------|--------|-----|
| Writing a backlog item | Classic (As a / I want / So that) | Quick, standard, everyone understands it |
| Defining exact behavior | Gherkin (Given / When / Then) | Precise, can become automated tests |
| Early discovery / brainstorming | JTBD (When / I want to / So I can) | Focuses on motivation over implementation |
| Handing to a developer | Classic + Acceptance Criteria | They need both the "what" and the "done" definition |

---

## ✅ Skill Complete When

- [ ] Each feature has a user story in at least one format
- [ ] Every story has acceptance criteria (specific, measurable, testable)
- [ ] Stories pass the INVEST check (12+ score)
- [ ] Stories are small enough to build in one sprint
- [ ] Edge cases and error states are covered in acceptance criteria
