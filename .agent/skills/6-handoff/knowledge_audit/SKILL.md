---
name: Knowledge Audit
description: Capture undocumented tribal knowledge before team transitions using a 5-step audit process with stranger test verification
---

# Knowledge Audit Skill

**Purpose**: Extract and document the undocumented tribal knowledge that lives only in people's heads before a team transition, handoff, or key person departure. This skill runs a 5-step audit process covering ADR extraction, configuration registry discovery, gotchas documentation, credential inventory, and lessons learned. It concludes with a "stranger test" where someone unfamiliar attempts setup using only the documentation.

## TRIGGER COMMANDS

```text
"Run knowledge audit"
"Capture tribal knowledge"
"Document what's undocumented"
"Prepare for team handoff"
"Using knowledge_audit skill: audit [project]"
```

## When to Use

- A key team member is leaving or transitioning to another project
- Handing off a project to a different team or client
- Onboarding a new team member and realizing documentation gaps
- Beginning Phase 6 (this skill runs first in the handoff sequence)

---

## PROCESS

### Step 1: ADR Extraction (Architecture Decision Records)

Recover the "why" behind architectural choices from git history, chat archives, and interviews.

**Sources to Mine**:

| Source | What to Extract | How |
|--------|----------------|-----|
| Git commit messages | Major refactors, technology choices | `git log --all --oneline --grep="refactor\|migrate\|replace\|upgrade"` |
| Pull request descriptions | Design rationale, trade-off discussions | Search PRs with 10+ comments |
| Slack/Teams archives | Technical debates that led to decisions | Search for architectural keywords |
| Meeting notes | Design review decisions | Review last 6 months of meeting notes |
| Team interviews | Unwritten context, "we tried X but..." | 30-minute 1:1 with each team member |

**ADR Template** (for each recovered decision):

```markdown
# ADR-[NNN]: [Decision Title]

**Date**: [When the decision was made, approximate if unknown]
**Status**: Accepted
**Context**: [What problem were we solving? What constraints existed?]
**Decision**: [What did we decide?]
**Alternatives Considered**:
- [Option A]: Rejected because [reason]
- [Option B]: Rejected because [reason]
**Consequences**:
- Positive: [benefits]
- Negative: [trade-offs we accepted]
**Notes**: [Recovered from: git commit abc123 / Slack thread / interview with [Name]]
```

**Interview Questions for Knowledge Extraction**:

```text
1. What would break if we changed [component X]?
2. Are there any manual steps required that are not in the docs?
3. What is the most fragile part of this system?
4. What workarounds are in place that should eventually be fixed?
5. What did we try that did NOT work? Why?
6. Are there any timing dependencies or ordering constraints?
7. What secrets or API keys would a new developer need that are not in .env.example?
8. What external services have rate limits or quotas we've hit before?
```

### Step 2: Configuration Registry Discovery

Document every configuration value, where it lives, and what happens if it is wrong.

```markdown
# Configuration Registry

| Config Key | Location | Current Value | Default | Impact if Wrong |
|-----------|----------|---------------|---------|-----------------|
| DATABASE_URL | .env | postgres://... | None | App fails to start |
| STRIPE_WEBHOOK_SECRET | .env | whsec_... | None | Payments not processed |
| MAX_UPLOAD_SIZE | config.ts | 10MB | 5MB | Large file uploads rejected |
| CRON_SCHEDULE | docker-compose | 0 */6 * * * | None | Analytics not aggregated |
| CDN_CACHE_TTL | vercel.json | 3600 | 0 | Stale content served |

## Non-Obvious Configuration

- [Service X] requires `NODE_OPTIONS=--max-old-space-size=4096` or OOMs on large imports
- Redis `maxmemory-policy` MUST be `allkeys-lru` (default `noeviction` causes write failures)
- PostgreSQL `work_mem` tuned to 256MB for reporting queries (default 4MB causes disk spills)
```

### Step 3: Gotchas Documentation

Document the things that surprise new developers. These are the highest-value items for handoff.

**Gotchas Template**:

```markdown
# Known Gotchas and Pitfalls

## Build and Development
- [ ] `npm install` fails on M1 Macs without Rosetta for [dependency]
- [ ] Hot reload breaks when editing [specific file pattern] -- restart required
- [ ] Tests must run in sequence (not parallel) due to shared database state

## Deployment
- [ ] Deploy to staging BEFORE production -- the migration runner hits staging DB first
- [ ] CloudFront cache must be invalidated manually after [specific change type]
- [ ] Docker build takes 15+ minutes on first run due to [large dependency]

## Data
- [ ] The `users.metadata` column contains legacy JSON that does not match the current TypeScript type
- [ ] Soft-deleted records in `orders` table still appear in aggregate queries
- [ ] Migration #47 is not reversible -- it drops a column with no backup

## Third-Party Services
- [ ] Stripe webhook retries up to 3 times -- handler MUST be idempotent
- [ ] SendGrid rate limit is 600 emails/minute -- bulk sends need throttling
- [ ] OpenAI API returns 429 above 60 RPM on our current tier
```

### Step 4: Credential Inventory

Create a complete inventory of every secret, key, and certificate the project uses.

```markdown
# Credential Inventory

| Credential | Service | Owner | Rotation Schedule | Expiry | Location |
|-----------|---------|-------|-------------------|--------|----------|
| DATABASE_URL | Supabase | [Name] | Quarterly | N/A | .env, Railway env vars |
| STRIPE_SECRET_KEY | Stripe | [Name] | Annually | N/A | .env, Railway env vars |
| SSL_CERTIFICATE | Cloudflare | [Name] | Auto-renewed | 2026-12-01 | Cloudflare dashboard |
| SMTP_PASSWORD | SendGrid | [Name] | Never rotated | N/A | .env |
| JWT_SECRET | Internal | [Name] | Never rotated | N/A | .env |
| OAUTH_CLIENT_SECRET | Google | [Name] | Annually | 2026-06-15 | Google Cloud Console |

## Emergency Access
- [ ] At least 2 people have access to every critical credential
- [ ] Password manager shared vault contains all API keys
- [ ] Break-glass procedure documented for [hosting provider] if primary admin unavailable
```

### Step 5: Lessons Learned Compilation

Document what worked and what did not during the project lifecycle.

```markdown
# Lessons Learned

## What Worked Well
- [Technical decision that paid off and why]
- [Process that improved velocity]
- [Tool choice that saved time]

## What We Would Do Differently
- [Decision we would reverse with hindsight]
- [Process that created friction]
- [Technical debt we would have avoided]

## Open Questions
- [Unresolved technical question that the next team should investigate]
- [Performance issue that was deferred]
- [Feature request that was deprioritized but keeps coming up]
```

### Step 6: The Stranger Test

The single most valuable verification step. Have someone unfamiliar with the project attempt a full setup using only the documentation produced in Steps 1-5.

**Stranger Test Protocol**:

```text
1. Recruit a developer NOT on the project team
2. Give them ONLY the documentation (no verbal guidance)
3. Task: Clone the repo, set up local dev, run tests, deploy to staging
4. Time limit: 4 hours
5. Record every point where they get stuck
6. Every stuck point = documentation gap to fix

Success criteria:
- Clone to running local dev: < 30 minutes
- Clone to passing tests: < 1 hour
- Clone to staging deploy: < 2 hours

If any step takes longer, the documentation needs improvement.
```

---

## CHECKLIST

- [ ] ADRs extracted from git, PRs, chat archives, and team interviews
- [ ] Configuration registry documents every config value with impact analysis
- [ ] Gotchas documented for build, deployment, data, and third-party services
- [ ] Credential inventory complete with owners and rotation schedules
- [ ] At least 2 people have access to every critical credential
- [ ] Lessons learned compiled (what worked, what to change, open questions)
- [ ] Stranger test conducted with a developer outside the project team
- [ ] All documentation gaps identified by stranger test have been fixed
- [ ] All artifacts stored in a durable, accessible location (not just Slack)
- [ ] Knowledge audit report handed to `access_handoff` skill

---

*Skill Version: 1.0 | Created: February 2026*
