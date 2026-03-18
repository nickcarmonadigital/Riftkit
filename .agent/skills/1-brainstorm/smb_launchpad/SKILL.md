---
name: SMB Launchpad
description: Complete service delivery workflow for SMB website + consulting clients
triggers:
  - "/smb-launchpad"
  - "/smb"
  - "/smb-project"
  - "/client-project"
---

# SMB Launchpad Skill

> **CRITICAL**: This is the MASTER skill for the SMB Launchpad service. Use this when delivering website + consulting packages to small business clients.

## 🎯 Purpose

Execute the full SMB Launchpad service delivery from lead intake to handoff, generating immediate cash flow while building case studies.

## When to Use

- New SMB client inquiry received
- Starting a website build project
- Delivering consulting + website package
- Building proof-of-concept projects for portfolio

## 📋 Related Documents

Before starting, ensure these documents are in `.agent/docs/`:

| Document | Purpose |
|----------|---------|
| [smb-discovery-template.md](../docs/1-brainstorm/smb-discovery-template.md) | Client intake questions |
| [project-workflow-checklist.md](../docs/toolkit/project-workflow-checklist.md) | Full project phases |
| [proposal-template.md](../docs/1-brainstorm/proposal-template.md) | Quote/proposal format |
| [website-build-checklist.md](../docs/3-build/website-build-checklist.md) | Website build standards |
| [niche-compliance-quick-ref.md](../docs/0-context/niche-compliance-quick-ref.md) | Industry compliance notes |
| [brand-smart-friend.md](../docs/2-design/brand-smart-friend.md) | Voice/tone guidelines |
| [frontend-architect-standards.md](../docs/2-design/frontend-architect-standards.md) | Anti-AI-slop design |

## 📦 The SMB Launchpad Package

```
┌─────────────────────────────────────────────────────────────────┐
│                   SMB LAUNCHPAD PACKAGE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DELIVERABLES:                                                   │
│  ✅ Custom website (anti-AI-slop design)                        │
│  ✅ Discovery session (understand their business)               │
│  ✅ 1-3 automations (booking, follow-up, reviews)               │
│  ✅ Brand quick-start (colors, fonts, voice)                    │
│  ✅ Handoff training (recorded)                                 │
│                                                                  │
│  PRICING OPTIONS:                                                │
│  • Free / Outcome-Based: Build portfolio + proof                │
│  • $1,500 - $3,000: Standard package                            │
│  • +$99-199/mo: Ongoing support retainer                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Full Workflow

### Phase 1: INTAKE (Day 0)

```
[ ] Receive lead inquiry
[ ] Quick qualify: budget, timeline, fit
[ ] Schedule discovery call
[ ] Send calendar invite
[ ] Add to CRM/tracker
```

### Phase 2: DISCOVERY (Days 1-2)

**Use**: [smb-discovery-template.md](../docs/1-brainstorm/smb-discovery-template.md)

```
[ ] Run discovery call (15-30 min)
[ ] Complete discovery template
[ ] Research 2-3 competitors
[ ] Check niche compliance requirements
[ ] Determine deliverables scope
[ ] Send follow-up summary email
```

### Phase 3: PROPOSAL (Days 2-3)

**Use**: [proposal-template.md](../docs/1-brainstorm/proposal-template.md)

```
[ ] Create proposal from template
[ ] Define deliverables clearly
[ ] Set timeline with milestones
[ ] Calculate pricing (use pricing matrix)
[ ] Send proposal
[ ] Follow up in 48 hours if no response
[ ] Handle objections/negotiate if needed
[ ] Get signed agreement
[ ] Collect deposit (if applicable)
```

### Phase 4: BUILD (Days 4-10)

**Use**: [website-build-checklist.md](../docs/3-build/website-build-checklist.md) + [frontend-architect-standards.md](../docs/2-design/frontend-architect-standards.md)

```
SETUP:
[ ] Create project folder
[ ] Set up development environment
[ ] Collect brand assets (logo, colors, photos)
[ ] Get access to existing accounts

DESIGN:
[ ] Choose design archetype
[ ] Select typography (NO Inter, Roboto, Arial!)
[ ] Define color palette (NO pure white + blue!)
[ ] Create homepage mockup
[ ] Get client approval on direction

DEVELOPMENT:
[ ] Build homepage
[ ] Build additional pages
[ ] Implement contact form
[ ] Implement booking (if applicable)
[ ] Set up integrations
[ ] Mobile responsive testing
[ ] Cross-browser testing
```

### Phase 5: REVIEW (Days 11-12)

```
[ ] Internal QA check
[ ] Send preview link to client
[ ] Client review meeting
[ ] Collect feedback (max 2 revision rounds)
[ ] Implement revisions
[ ] Get final approval
```

### Phase 6: LAUNCH (Days 13-14)

**Use**: [website_launch skill](../skills/website_launch/SKILL.md)

```
[ ] Connect domain
[ ] SSL certificate active
[ ] Deploy to production
[ ] Test all links and forms
[ ] Set up analytics
[ ] Submit to Google Search Console
[ ] Take "after" screenshots
[ ] Announce launch to client
```

### Phase 7: HANDOFF (Day 14+)

```
[ ] Create handoff document (logins, how-tos)
[ ] Record training session
[ ] Collect final payment
[ ] Request testimonial
[ ] Request Google review
[ ] Take case study screenshots
[ ] Schedule 30-day check-in
[ ] Propose retainer (if applicable)
```

## 💰 Pricing Matrix

| Package | Includes | Price |
|---------|----------|-------|
| **Starter** | 1-3 page website, contact form | $1,500 |
| **Standard** | 5+ pages, booking, 1 integration | $2,500 |
| **Premium** | Full setup, 3+ integrations, training | $3,500 |
| **Retainer** | Monthly updates, support | $99-199/mo |

## 🎯 Target Niches (Start Here)

| Priority | Niche | Typical Needs |
|----------|-------|---------------|
| 🥇 | Salons/Barbershops | Website + booking + reviews |
| 🥇 | Personal Trainers | Website + booking + client portal |
| 🥈 | Restaurants | Website + menu + reservations |
| 🥈 | Photographers | Portfolio + booking + gallery |
| 🥉 | Cleaning Services | Website + quote form + scheduling |

## ✅ Definition of Done

Project is complete when:

- [ ] Website live on client's domain
- [ ] All forms working and tested
- [ ] Client trained on updates
- [ ] Final payment collected
- [ ] Testimonial requested
- [ ] Case study materials captured

## 📊 Success Metrics

Track for each project:

| Metric | Target |
|--------|--------|
| Discovery → Proposal | < 48 hours |
| Proposal → Signed | < 7 days |
| Signed → Launched | < 14 days |
| Client Satisfaction | 9+/10 |
| Testimonial Captured | 100% |

---

*Skill Version: 1.0 | Created: January 20, 2026*
