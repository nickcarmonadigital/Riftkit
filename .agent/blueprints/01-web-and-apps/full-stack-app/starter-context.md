# Project Context - Full Stack Web App

**BLUEPRINT: WEB APP (SaaS/Platform)**

## 📋 PART 1: PROJECT OVERVIEW

```markdown
# PROJECT: [Your Project Name]

## What It Is
[1-2 sentence description of the SaaS/App]

## Tech Stack (Recommended)
- **Frontend**: Next.js (App Router) + Tailwind CSS
- **Backend**: Next.js Server Actions OR NestJS
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **Payments**: Stripe

## Architecture
- **Type**: Multi-tenant SaaS / Single-user Tool
- **Hosting**: Vercel

## Key Features
1. [Feature 1]
2. [Feature 2]
```

## 🧠 ARA CHECKLIST (Web App Specific)

### Atom 1: User Identity

- [ ] How do users sign up? (Email/Social)
- [ ] Do we need organizations/teams?
- [ ] What data is private vs public?

### Atom 2: Data Persistence

- [ ] What is the core data entity? (e.g., "Project", "Invoice")
- [ ] Who owns the data?

### Atom 3: Monetization (If SaaS)

- [ ] Subscription model? (Monthly/Yearly)
- [ ] Usage-based pricing?
- [ ] Free tier limits?

### Atom 4: UI/UX

- [ ] Dark mode required?
- [ ] Mobile responsive critical?
