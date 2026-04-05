---
name: UX Writing & Microcopy
description: Write clear, actionable microcopy for every interface touchpoint — buttons, errors, empty states, tooltips, loading states, confirmations, forms, and notifications
---

# UX Writing & Microcopy

**Purpose**: Every word in your interface is a UX decision. This skill provides prescriptive rules, character limits, tone calibration, and pattern templates for all microcopy touchpoints so users never feel confused, blamed, or abandoned.

---

## TRIGGER COMMANDS

```text
"Write better microcopy for [page/component]"
"Fix the error messages in [feature]"
"Audit the UX copy on [page]"
"Write empty state copy for [feature]"
"Improve the button labels on [screen]"
"Using ux_writing_microcopy skill: [target]"
```

---

## WHEN TO USE

- Building any new feature with user-facing text
- Error messages are confusing, generic, or blame the user
- Users don't understand what to do next
- Empty states show blank screens with no guidance
- CTAs aren't converting or are ambiguous
- Onboarding text is too long, too vague, or too technical

---

## 1. VOICE & TONE FRAMEWORK

Voice is constant. Tone shifts by context.

### Brand Voice Matrix

| Dimension     | We Are           | We Are NOT       |
|---------------|------------------|------------------|
| Clarity       | Clear, direct    | Jargon-filled    |
| Warmth        | Helpful, human   | Condescending    |
| Confidence    | Assured, calm    | Arrogant, pushy  |
| Energy        | Encouraging      | Overly casual    |
| Honesty       | Transparent      | Vague, evasive   |

### Tone by Context

| Context            | Tone               | Example                                                  |
|--------------------|---------------------|----------------------------------------------------------|
| Success            | Warm, celebratory   | "Great work! Your profile is all set."                   |
| Error              | Calm, helpful       | "That didn't work. Here's what to try."                  |
| Onboarding         | Encouraging, clear  | "Let's get you set up. This takes about 2 minutes."      |
| Destructive action | Serious, precise    | "This will permanently delete your account and all data." |
| Empty state        | Friendly, guiding   | "No messages yet. Start a conversation to see them here." |
| Loading / waiting  | Reassuring, specific| "Analyzing your data... this usually takes 10 seconds."   |
| Payment / billing  | Professional, exact | "You'll be charged $29/month starting May 1."            |

### Formality Spectrum

```
Formal ←————————————————————————————→ Casual
Banking    Healthcare    SaaS    Consumer    Social
"Submit"   "Confirm"    "Save"  "Got it"    "Yep!"
```

**Rule**: Match the formality to your audience's expectations and the stakes of the action. Higher stakes = more formal.

---

## 2. BUTTON & CTA LABELS

### Rules

```
1. Always verb-first: [Verb] + [Object]
2. Specific over generic: "Save changes" not "Submit"
3. Match user expectation: the label must predict the outcome
4. Primary button = specific action, Secondary = escape/cancel
5. Destructive actions name the consequence: "Delete project" not "Delete"
6. Character limit: 2-5 words, max 25 characters
7. Sentence case, not Title Case or ALL CAPS
8. Never use "Click here" — ever
```

### Button Label Examples

| Bad              | Good                  | Why                                      |
|------------------|-----------------------|------------------------------------------|
| Submit           | Create account        | Specific about what happens              |
| OK               | Save changes          | Names the action                         |
| Yes              | Delete project        | Names the consequence                    |
| Next             | Continue to payment   | Tells user where they're going           |
| Click here       | Download report       | Describes the outcome                    |
| Cancel           | Keep editing          | Positive framing for secondary action    |
| Learn more       | See pricing details   | Specific about destination               |
| Go               | Search recipes        | Object makes action clear                |

### CTA Hierarchy

```
Primary CTA:     Filled, high contrast, verb + object     → "Start free trial"
Secondary CTA:   Outlined/ghost, lower contrast           → "See pricing"
Tertiary CTA:    Text link, understated                   → "Learn more about plans"
```

### Anti-patterns

```
[ ] "Submit" / "OK" / "Yes" / "No" as button labels
[ ] Two primary CTAs competing for attention
[ ] Vague labels that don't predict the outcome
[ ] ALL CAPS buttons (reads as shouting)
[ ] Icon-only buttons without tooltip or aria-label
```

---

## 3. ERROR MESSAGES

### Anatomy of a Good Error Message

```
[What happened] + [Why it happened] + [What to do next]
```

Every error message MUST have all three parts.

### Tone Rules for Errors

```
1. Never blame the user: "Invalid input" → "That format isn't recognized"
2. Never show error codes to end users: "Error 422" → explain in plain language
3. Never use "Oops" — it trivializes the user's frustration
4. Be specific: "Something went wrong" → "We couldn't save your file because the server is temporarily unavailable"
5. Always provide a recovery path: retry, alternative action, or support link
```

### Error Message Examples

| Bad                          | Good                                                                 |
|------------------------------|----------------------------------------------------------------------|
| Error 422                    | That email is already registered. Try signing in instead.            |
| Invalid input                | Password needs at least 8 characters. You're at 5.                   |
| Something went wrong         | We couldn't connect to the server. Check your connection and try again. |
| Failed                       | Your payment didn't go through. Please check your card details or try a different card. |
| Invalid email                | That doesn't look like an email address. Make sure it includes @ and a domain. |
| Request failed               | We couldn't load your dashboard. This is usually temporary — refresh to try again. |

### Error Placement

```
Inline errors:     Directly below the field, in red, visible without scrolling
Toast errors:      For system/network errors not tied to a specific field
Page-level errors: For form submissions with multiple issues — list all at top
Modal errors:      Only for critical, blocking errors that need acknowledgment
```

### Validation Timing

```
Email field:   Validate on blur (when user leaves the field)
Password:      Validate in real-time (show requirements as met/unmet)
Required:      Validate on submit attempt, not on blur of empty field
Format:        Validate on blur with specific format guidance
```

---

## 4. EMPTY STATES

### Empty State Types

| Type          | User Situation                  | Goal                            |
|---------------|--------------------------------|---------------------------------|
| First-use     | Brand new user, no data yet    | Guide to first action           |
| No results    | Search/filter returned nothing | Suggest alternatives            |
| Cleared       | User completed/cleared items   | Celebrate or suggest next steps |
| Error empty   | Failed to load content         | Explain and offer recovery      |
| Permissions   | User can't access content      | Explain why and how to get access |

### Empty State Template

```
[Optional illustration or icon]
Headline:     Short, specific to the state (max 8 words)
Description:  1-2 sentences explaining why it's empty and what to do
CTA button:   Primary action to resolve the empty state
```

### Examples by Type

```
FIRST-USE:
  Headline:    "No projects yet"
  Description: "Create your first project to start building."
  CTA:         "Create project"

NO RESULTS:
  Headline:    "No results for 'pyhton'"
  Description: "Did you mean 'python'? Try a different search or browse all topics."
  CTA:         "Browse all topics"

CLEARED:
  Headline:    "All caught up!"
  Description: "You've handled all your notifications. Nice work."
  CTA:         None needed (or "View archive")

ERROR EMPTY:
  Headline:    "Couldn't load your files"
  Description: "Something went wrong on our end. This is usually temporary."
  CTA:         "Try again"

PERMISSIONS:
  Headline:    "You don't have access to this project"
  Description: "Ask the project owner to invite you, or switch to a project you own."
  CTA:         "Request access"
```

### Anti-patterns

```
[ ] Blank screen with no text at all
[ ] "No data" as the only text
[ ] Empty state with no CTA
[ ] Generic illustration that doesn't match the context
[ ] First-use empty state that makes the user feel behind
```

---

## 5. TOOLTIPS & HELP TEXT

### When to Use Tooltips

```
USE when:
- Icon meaning isn't obvious
- A setting has implications that aren't clear from the label
- A field accepts a specific format
- An action has consequences the user might not expect

DON'T use when:
- Information is critical (mobile users can't hover)
- The label itself should be clearer (fix the label instead)
- Content is longer than 15 words (use help text or a help page)
- Replacing proper documentation
```

### Tooltip Rules

```
Length:       Max 15 words (ideally 5-10)
Content:     Explain WHY, not just WHAT
Position:    Above the element, centered, with arrow pointing down
Trigger:     Hover on desktop, long-press on mobile
Delay:       200-300ms before showing, 100ms before hiding
```

### Help Text vs Tooltips

| Type         | Placement           | Visibility | Use For                        |
|--------------|---------------------|------------|--------------------------------|
| Tooltip      | On hover/focus      | Temporary  | Icon explanations, quick hints |
| Inline help  | Below field, always | Persistent | Format requirements, context   |
| Info icon    | Next to label       | On click   | Longer explanations            |

### Examples

```
TOOLTIP:     "Pin this message to the top of the channel"
INLINE HELP: "We'll use this email to send your receipt"
INFO ICON:   "Your API key identifies your application. Keep it secret — don't share it publicly or commit it to version control."
```

---

## 6. LOADING & PROGRESS STATES

### Decision Tree

```
Loading time < 1 second:   → No loading indicator needed
Loading time 1-3 seconds:  → Skeleton screen or spinner
Loading time 3-10 seconds: → Progress bar with specific message
Loading time 10+ seconds:  → Progress bar with stage updates + estimated time
```

### Loading Copy Rules

```
1. Be specific about WHAT is loading: "Analyzing your data..." not "Loading..."
2. For multi-step processes, update the message at each stage
3. For 10s+ waits, show estimated time remaining
4. Never say "Please wait" — it's passive and unhelpful
5. Use progressive language: "Almost there..." near the end
```

### Loading Copy by Duration

| Duration   | UI Pattern      | Copy Example                                          |
|------------|-----------------|-------------------------------------------------------|
| < 1s       | None            | (No indicator needed)                                 |
| 1-3s       | Skeleton/Spinner| "Loading your dashboard..."                           |
| 3-10s      | Progress bar    | "Setting up your workspace... this takes a moment"    |
| 10-30s     | Staged progress | "Step 2 of 4: Importing your contacts..."             |
| 30s+       | Background task | "We'll email you when your export is ready"           |

### Skeleton vs Spinner

```
USE SKELETON when: Content layout is predictable (lists, cards, feeds)
USE SPINNER when:  Content layout is unknown or varies
USE PROGRESS BAR when: Duration is known or estimable
USE BACKGROUND TASK when: Process takes 30s+ (don't trap the user)
```

---

## 7. CONFIRMATION & SUCCESS MESSAGES

### Destructive vs Non-Destructive Actions

| Action Type     | Confirmation Required? | Button Style          | Copy Tone      |
|-----------------|------------------------|-----------------------|----------------|
| Irreversible    | Yes, always            | Red primary button    | Serious, exact |
| Reversible      | No (use undo toast)    | Standard button       | Calm, brief    |
| High-stakes     | Yes, with details      | Require text input    | Detailed       |
| Bulk actions    | Yes, with count        | Standard confirmation | Clear count    |

### Confirmation Dialog Template

```
Title:   "[Verb] [Object]?" — "Delete 'Project Alpha'?"
Body:    What will happen + what can't be undone
         "This will permanently remove the project and all 47 files. This can't be undone."
Buttons: [Keep project]  [Delete project]
         Secondary first (left), Destructive last (right, red)
```

### Success Message Template

```
Formula: [What succeeded] + [What happens next] + [Optional link to result]

Examples:
  "Project created! You can find it in your dashboard."
  "Payment received. You'll get a receipt at nick@example.com."
  "Settings saved. Changes take effect immediately."
  "Message sent to 12 recipients."
```

### Anti-patterns

```
[ ] "Are you sure?" as confirmation title (vague)
[ ] "Yes" / "No" as confirmation buttons (ambiguous)
[ ] "Success!" with no context about what succeeded
[ ] No confirmation for irreversible actions
[ ] Confirmation for every minor action (confirmation fatigue)
```

---

## 8. FORM LABELS & PLACEHOLDERS

### Label Rules

```
1. Every input MUST have a visible label above it — no exceptions
2. Labels should be 1-3 words: "Full name", "Email address", "Company"
3. Use sentence case: "Email address" not "Email Address"
4. Required fields: mark optional fields with "(optional)" — don't mark required ones
5. Group related fields with a section heading
6. Label position: always above the field, left-aligned
```

### Placeholder Rules

```
1. NEVER use placeholder as the only label (it disappears on focus)
2. Placeholders show FORMAT, not field description
3. Use "e.g." prefix for examples: "e.g. jane@company.com"
4. Keep placeholder text lighter/grayed — it's secondary
5. Placeholder is optional — skip it if the label is clear enough
```

### Placeholder Examples

| Label          | Bad Placeholder      | Good Placeholder         |
|----------------|----------------------|--------------------------|
| Full name      | "Enter your name"    | "e.g. Jane Smith"        |
| Phone number   | "Phone"              | "e.g. (555) 123-4567"   |
| Website        | "URL"                | "e.g. https://example.com"|
| Company        | "Enter company name" | (none needed)            |

### Help Text Patterns

```
BELOW FIELD:     "We'll use this to send your receipt" (explains WHY)
BELOW FIELD:     "Must be at least 8 characters" (states requirement)
BELOW FIELD:     "You can change this later in settings" (reduces anxiety)
NEVER:           "Required" (use visual indicator, not text)
```

### Anti-patterns

```
[ ] Placeholder as the only label
[ ] Labels that describe the input type: "Text field" or "Dropdown"
[ ] Red asterisks on every required field (mark optional instead)
[ ] Help text that restates the label: "Enter your email" under "Email"
[ ] Labels that change position on focus (floating labels are unreliable for accessibility)
```

---

## EXIT CRITERIA

```
[ ] Every button uses verb + object (not "Submit" or "OK")
[ ] Every button is under 25 characters
[ ] Every error message has: what happened + why + what to do next
[ ] No error messages blame the user or show raw error codes
[ ] Every empty state has: headline + description + CTA
[ ] Empty states are typed correctly (first-use, no-results, cleared, error)
[ ] Tooltips are under 15 words and explain WHY
[ ] Critical info is NOT hidden in tooltips (mobile can't hover)
[ ] Loading messages are specific to what's loading
[ ] Loading UI matches duration (skeleton, spinner, progress, background)
[ ] Destructive actions have confirmation with specific consequence named
[ ] Success messages confirm what happened + what's next
[ ] Every form input has a visible label above it (not placeholder-only)
[ ] Placeholders show format examples, not field descriptions
[ ] Terminology is consistent across the entire product
[ ] Tone matches context (warm for success, calm for errors, serious for destructive)
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: UX writing best practices, NNGroup research, Material Design guidelines*
