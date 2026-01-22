# Prompt Library

A collection of **ready-to-use prompts** for common development tasks. Copy, paste, customize.

---

## 🚀 Project Kickoff Prompts

### New Project Setup

```
I'm starting a new project called [PROJECT NAME].

Tech stack: [FRONTEND] + [BACKEND] + [DATABASE]
Purpose: [ONE LINE DESCRIPTION]

Help me set up the initial project structure with:
1. Proper folder organization
2. Essential configuration files
3. Development environment setup
4. Basic README

Use the new_project skill approach.
```

### Session Context Loader

```
I'm continuing work on [PROJECT NAME].

Current state:
- Tech: [STACK]
- Last session: [WHAT WE DID]
- Current task: [WHAT WE'RE DOING NOW]
- Blockers: [ANY ISSUES]

Key files:
- [FILE PATH] - [PURPOSE]
- [FILE PATH] - [PURPOSE]

Let's continue where we left off.
```

---

## 🛠️ Feature Development Prompts

### Feature Brain Dump

```
I want to build: [FEATURE NAME]

Here's my messy brain dump:
[PASTE YOUR SCATTERED THOUGHTS HERE]

Help me turn this into a structured spec with:
1. User stories
2. Technical requirements  
3. API endpoints needed
4. Database changes
5. Implementation steps

Use the feature_braindump skill.
```

### Architecture Documentation

```
We just built [FEATURE NAME].

Key components:
- [COMPONENT 1]: [PURPOSE]
- [COMPONENT 2]: [PURPOSE]

Files involved:
- [FILE PATHS]

Create an architecture document that explains:
1. How it works (data flow)
2. Key decisions we made
3. How to modify it in the future

Use the feature_architecture skill format.
```

---

## 🐛 Debugging Prompts

### Bug Report

```
BUG: [ONE LINE DESCRIPTION]

Steps to reproduce:
1. [STEP 1]
2. [STEP 2]
3. [STEP 3]

Expected: [WHAT SHOULD HAPPEN]
Actual: [WHAT ACTUALLY HAPPENS]

Environment:
- Browser/OS: [DETAILS]
- Version: [DETAILS]

Error message (if any):
```

[PASTE ERROR]

```

Help me debug this systematically.
```

### Performance Issue

```
PERFORMANCE ISSUE: [DESCRIPTION]

Symptoms:
- [SYMPTOM 1]
- [SYMPTOM 2]

When it happens:
- [TRIGGER CONDITION]

Relevant code:
```[LANGUAGE]
[PASTE CODE]
```

Help me identify bottlenecks and optimize.

```

---

## 🔐 Security Prompts

### Security Audit Request

```

I need a security audit for [FEATURE/PROJECT].

What it does:
[BRIEF DESCRIPTION]

Technologies:

- [AUTH METHOD]
- [DATABASE]
- [PAYMENT PROCESSING IF ANY]

Sensitive data handled:

- [DATA TYPE 1]
- [DATA TYPE 2]

Run through the security_audit skill checklist and identify vulnerabilities.

```

### Auth Implementation Review

```

Review this authentication implementation:

```[LANGUAGE]
[PASTE AUTH CODE]
```

Check for:

1. Proper password hashing
2. Session security
3. Token handling
4. Common auth vulnerabilities
5. Best practices I'm missing

```

---

## 📝 Code Review Prompts

### General Code Review

```

Review this code for:

1. Bugs and edge cases
2. Performance issues
3. Security vulnerabilities
4. Code style/readability
5. Best practices

```[LANGUAGE]
[PASTE CODE]
```

Be specific about what to change and why.

```

### PR Review Simulation

```

Act as a senior developer reviewing this PR.

Context: [WHAT THE CODE DOES]

Changes:

```diff
[PASTE DIFF OR CHANGED CODE]
```

Give feedback like you would in a real code review:

- What's good
- What needs changing
- Questions you'd ask
- Suggestions for improvement

```

---

## 🌐 Website/Frontend Prompts

### Landing Page Build

```

Build a landing page for [PRODUCT/SERVICE].

Target audience: [WHO]
Main value prop: [WHAT THEY GET]
CTA: [WHAT YOU WANT THEM TO DO]
Vibe: [DESIGN STYLE - e.g., "SaaS/Tech", "Luxury", "Playful"]

Use the website_build skill anti-AI-slop standards:

- NO Inter/Roboto fonts
- NO pure white background
- Strong visual hierarchy
- Mobile responsive

```

### Component Creation

```

Create a [COMPONENT TYPE] component.

Requirements:

- [REQUIREMENT 1]
- [REQUIREMENT 2]
- [REQUIREMENT 3]

Should include:

- Hover/active states
- Loading state
- Error state
- Mobile responsive

Style: [DESIGN DIRECTION]
Framework: [REACT/VUE/SVELTE/etc.]

```

---

## 💼 Client Work Prompts

### Discovery Call Prep

```

I have a discovery call with a potential client.

Their business: [TYPE]
What they mentioned: [INITIAL REQUEST]

Generate questions to ask using the client_discovery skill template.
Focus on understanding:

1. Their current state
2. Their goals
3. Budget/timeline fit
4. Red flags to watch for

```

### Proposal Draft

```

Create a proposal for:

Client: [NAME]
Project type: [WEBSITE/APP/etc.]
Scope: [WHAT THEY NEED]
Timeline: [THEIR DEADLINE]
Budget: [$X - $Y]

Key pain points from discovery:

- [PAIN 1]
- [PAIN 2]

Use the proposal_generator skill format with 2-3 pricing options.

```

---

## 📊 Database Prompts

### Schema Design

```

Design a database schema for [FEATURE/APP].

Entities:

Relationships:

- [RELATIONSHIP 1]
- [RELATIONSHIP 2]

Requirements:

- [SPECIFIC NEED]

Use the schema_standards skill format with proper types and constraints.

```

### Query Optimization

```

Optimize this query:

```sql
[PASTE QUERY]
```

Current execution time: [TIME]
Table sizes: [ROW COUNTS]

Suggest:

1. Index recommendations
2. Query restructuring
3. Alternative approaches

```

---

## 🎯 Pro Tips

1. **Be specific** - The more context you give, the better the output
2. **Include examples** - Show what you want, not just describe it
3. **Set constraints** - Tell the AI what NOT to do
4. **Iterate** - First output is a starting point, refine from there
5. **Use skills** - Reference the `.agent/skills/` for structured workflows

---

*Copy. Paste. Customize. Build.*
