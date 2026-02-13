---
name: Cost Estimation
description: AI token costs, infrastructure pricing, time estimation, and budget tracking for software projects
---

# Cost Estimation Skill

> **PURPOSE**: Estimate, track, and optimize the real costs of building and running a software project -- from AI tokens to cloud hosting to your own time.

## When to Use

- Starting a new project and need a budget estimate
- Choosing between hosting providers
- Calculating AI API costs for a feature
- Tracking planned vs. actual spend
- Pricing your work for a client
- Maximizing free tiers to keep costs near zero

---

## AI Token Cost Calculator

AI costs are based on tokens (roughly 4 characters = 1 token, or about 0.75 words = 1 token).

### Current Pricing (as of early 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Best For |
|-------|----------------------|------------------------|----------|
| Claude Opus 4 | $15.00 | $75.00 | Complex reasoning, large codebases |
| Claude Sonnet 4 | $3.00 | $15.00 | Everyday coding, good balance |
| Claude Haiku 3.5 | $0.80 | $4.00 | Fast tasks, classification, extraction |
| GPT-4o | $2.50 | $10.00 | General purpose, multimodal |
| GPT-4o Mini | $0.15 | $0.60 | High-volume, low-complexity tasks |
| Gemini 2.0 Flash | $0.10 | $0.40 | Bulk processing, long context |
| Gemini 2.5 Pro | $1.25 | $10.00 | Complex reasoning, code generation |

> Prices change frequently. Always check the provider's pricing page before committing to a budget.

### Quick Cost Estimation

```
Monthly cost = (avg tokens per request) x (requests per day) x 30 x (price per token)

Example: Customer support chatbot
- Average conversation: 2,000 input tokens + 500 output tokens
- 100 conversations per day
- Using Claude Sonnet 4

Input:  2,000 x 100 x 30 = 6,000,000 tokens/month = 6M x $3.00/M  = $18.00
Output:   500 x 100 x 30 = 1,500,000 tokens/month = 1.5M x $15.00/M = $22.50
Total: $40.50/month
```

### Cost Optimization Tips

- Use the cheapest model that produces acceptable quality
- Cache common responses to avoid redundant API calls
- Set `max_tokens` to limit output length
- Use streaming to fail fast on bad responses
- Batch requests where possible (some APIs offer batch discounts)

---

## Infrastructure Cost Estimation

### Hosting Provider Comparison

| Provider | Free Tier | Starter Paid | Best For |
|----------|-----------|-------------|----------|
| **Vercel** | 100GB bandwidth, 100 hrs compute | $20/mo (Pro) | Frontend, Next.js sites |
| **Railway** | $5 free credit/month | ~$5-20/mo | Backend APIs, databases |
| **Render** | 750 hrs free (web services) | $7/mo per service | Full-stack apps |
| **DigitalOcean** | $200 credit (60 days) | $6/mo (droplet) | VPS, full control |
| **AWS** | 12 months free tier | Varies widely | Enterprise, scaling |
| **Supabase** | 500MB DB, 1GB storage | $25/mo (Pro) | PostgreSQL + auth + storage |
| **PlanetScale** | 1 billion row reads/mo | $39/mo (Scaler) | MySQL, branching |
| **Neon** | 0.5GB storage, 190 hrs compute | $19/mo (Launch) | Serverless PostgreSQL |

### Typical Monthly Costs for a SaaS MVP

| Component | Service | Estimated Cost |
|-----------|---------|---------------|
| Frontend hosting | Vercel Free | $0 |
| Backend API | Railway | $5-15 |
| Database (PostgreSQL) | Railway or Supabase | $0-25 |
| Authentication | Supabase Auth or Clerk Free | $0 |
| File storage | Supabase Storage or S3 | $0-5 |
| Email sending | Resend (free tier: 100/day) | $0 |
| Domain name | Namecheap / Cloudflare | $10-15/year |
| SSL certificate | Free (via hosting provider) | $0 |
| **Total MVP** | | **$5-60/month** |

---

## Hidden Costs Checklist

These are costs people forget when budgeting a project.

| Category | Item | Typical Cost |
|----------|------|-------------|
| Domain | Annual registration | $10-15/year |
| Domain | Premium domain purchase | $50-5,000+ |
| Email | Custom email (Google Workspace) | $7/user/month |
| Monitoring | Error tracking (Sentry free tier) | $0-29/month |
| Monitoring | Uptime monitoring (BetterStack) | $0-25/month |
| Analytics | PostHog (free tier: 1M events) | $0 |
| CI/CD | GitHub Actions (2,000 min free) | $0 |
| Security | Dependency scanning | $0 (Snyk free) |
| Legal | Privacy policy generator | $0 (free tools) |
| Legal | Terms of service | $0-500 |
| Backups | Database backup storage | $0-5/month |
| Testing | Browser testing (BrowserStack) | $0-29/month |

> Rule of thumb: Add 20% to your infrastructure estimate for hidden costs.

---

## Time Estimation Techniques

### Three-Point Estimation

For every task, estimate three numbers:

| Estimate | Meaning | When It Happens |
|----------|---------|-----------------|
| **Optimistic (O)** | Everything goes perfectly | 10% of the time |
| **Realistic (M)** | Normal amount of issues | 60% of the time |
| **Pessimistic (P)** | Major problems arise | 30% of the time |

**Formula**: Expected Time = (O + 4M + P) / 6

```
Example: Build a user dashboard
- Optimistic:  3 days (I have done this before, no surprises)
- Realistic:   5 days (some design iteration, a couple bugs)
- Pessimistic: 10 days (API changes, major redesign needed)

Expected = (3 + 4(5) + 10) / 6 = 33 / 6 = 5.5 days
```

### Common Estimation Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting testing time | Add 20-30% for testing |
| Ignoring code review | Add 1 day per major PR |
| Not accounting for meetings | Subtract 1-2 hours per day for meetings |
| Assuming no bugs | They always appear. Add buffer. |
| Estimating in hours, not days | A "6-hour task" is really a full day |

---

## Budget Tracking Template

Track what you planned versus what you actually spent, updated weekly.

```
# Budget Tracker - [Project Name]
Updated: [Date]

## Monthly Recurring Costs
| Item | Planned | Actual | Difference | Notes |
|------|---------|--------|------------|-------|
| Hosting (Railway) | $15 | $12 | -$3 | Under budget |
| Database (Supabase) | $25 | $25 | $0 | On plan |
| AI API (Claude) | $50 | $73 | +$23 | Higher usage than expected |
| Email (Resend) | $0 | $0 | $0 | Still on free tier |
| Domain | $1.25 | $1.25 | $0 | Annual cost / 12 |
| **Total** | **$91.25** | **$111.25** | **+$20** | |

## One-Time Costs
| Item | Planned | Actual | Notes |
|------|---------|--------|-------|
| Domain purchase | $12 | $12 | Done |
| Logo design | $0 | $0 | AI generated |
| SSL cert | $0 | $0 | Free via Vercel |
```

---

## Cost-Benefit Analysis Framework

Before adding any paid service, answer these questions:

```
Service: [Name]
Monthly cost: $[X]

1. PROBLEM: What problem does this solve?
   [Answer]

2. ALTERNATIVE: Can I solve this for free?
   [Answer -- if yes, why not use the free option?]

3. VALUE: How much time/money does this save per month?
   [Answer in hours or dollars]

4. BREAK-EVEN: Does the value exceed the cost?
   [Yes/No -- if no, skip it for now]

5. SCALE: Will this cost grow with users? How?
   [Answer -- e.g., "$0.01 per additional user per month"]
```

### Example

```
Service: Sentry (error tracking)
Monthly cost: $29/month (Team plan)

1. PROBLEM: We spend 3+ hours per week debugging errors users report via email.
2. ALTERNATIVE: Free tier covers 5K events. We are hitting 8K.
3. VALUE: Saves ~12 hours/month of debugging time = ~$600 in developer time.
4. BREAK-EVEN: $29 cost vs $600 saved = clearly worth it.
5. SCALE: Cost grows with error volume, not users. Should decrease as we fix bugs.
```

---

## Pricing Your Own Work

If you are freelancing or running an agency, here is how to price a project.

### Hourly Rate Calculation

```
Target annual income:     $100,000
Working weeks per year:   48 (subtract vacation, sick days)
Billable hours per week:  30 (not 40 -- admin, sales, learning eat time)
Hourly rate:              $100,000 / (48 x 30) = $69/hour
Round up for taxes/overhead: $85-100/hour
```

### Project-Based Pricing

| Project Type | Typical Range | Timeline |
|-------------|--------------|----------|
| Landing page | $500-2,000 | 1-2 weeks |
| Marketing website (5-10 pages) | $2,000-8,000 | 2-4 weeks |
| SaaS MVP | $10,000-50,000 | 1-3 months |
| Full SaaS product | $50,000-200,000+ | 3-12 months |
| Mobile app (React Native) | $15,000-80,000 | 2-6 months |

> Always price based on the value delivered, not just your hours. A login page for a bank is worth more than a login page for a blog.

---

## Free Tier Maximization Guide

You can run a real product for $0-10/month if you stack free tiers.

| Need | Free Option | Limit |
|------|-------------|-------|
| Frontend hosting | Vercel, Netlify, Cloudflare Pages | 100GB bandwidth |
| Backend hosting | Railway ($5 credit), Render (750 hrs) | Limited compute |
| Database | Supabase (500MB), Neon (0.5GB) | Storage limits |
| Auth | Supabase Auth, Clerk (10K MAU) | User limits |
| Email | Resend (100/day), Mailgun (1K/month) | Volume limits |
| File storage | Supabase (1GB), Cloudflare R2 (10GB) | Storage limits |
| Monitoring | Sentry (5K events), BetterStack (free) | Event limits |
| Analytics | PostHog (1M events), Plausible (self-host) | Event limits |
| CI/CD | GitHub Actions (2,000 min/mo) | Minutes |
| AI | Gemini free tier, GPT-4o Mini (low cost) | Rate limits |

> Free tiers are for MVPs and validation. Plan to pay for services once you have paying users.

---

## Skill Complete When

- [ ] AI token costs estimated for any AI-powered features
- [ ] Infrastructure costs mapped for all services (hosting, DB, email, etc.)
- [ ] Hidden costs identified and added to the budget
- [ ] Time estimates use three-point estimation, not gut feel
- [ ] Budget tracker set up with planned vs. actual columns
- [ ] Cost-benefit analysis done before adding any paid service
- [ ] Free tiers maximized during MVP phase

*Skill Version: 1.0 | Created: February 2026*
