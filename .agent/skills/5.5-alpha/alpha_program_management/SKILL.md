---
name: Alpha Program Management
description: End-to-end alpha program lifecycle including tester recruitment, access gating, feedback loops, and communication
---

# Alpha Program Management Skill

**Purpose**: Establish and manage the full alpha program lifecycle from tester recruitment through program closure. This skill covers access gating via invite-only allowlists, tester onboarding, feedback collection channels, staged rollout verification, and alpha-specific data policies. The goal is to get high-quality signal from a small, trusted cohort before broader beta release.

## TRIGGER COMMANDS

```text
"Set up alpha program"
"Alpha tester onboarding"
"Alpha access management"
"Recruit alpha testers"
"Using alpha_program_management skill: launch alpha for [product]"
```

## When to Use
- When preparing to release a product to its first external users
- When transitioning from internal testing to external alpha testing
- When the team needs structured feedback from a controlled user group
- When building trust with early adopters who will become product champions

---

## PROCESS

### Step 1: Define Alpha Program Parameters

Before recruiting testers, define the program scope:

```markdown
## Alpha Program Charter

### Program Parameters
- **Alpha start date**: YYYY-MM-DD
- **Target cohort size**: 10-25 testers (keep small for signal quality)
- **Expected duration**: 4-8 weeks
- **Access model**: Invite-only allowlist
- **Data policy**: Alpha data preserved through beta (or wiped -- decide now)

### Tester Profile
- **Ideal tester**: [power user / technical user / domain expert]
- **Must have**: Willingness to report bugs, tolerance for instability
- **Nice to have**: Prior alpha/beta testing experience

### Success Metrics
- **Minimum active testers**: 60% of cohort logging in weekly
- **Feedback volume**: At least 2 bug reports per tester per week
- **Core workflow completion**: 80% of testers complete primary workflow
- **NPS score**: Baseline established (no target for alpha)
```

### Step 2: Implement Access Gating

Create an invite-only allowlist system:

```typescript
// alpha-access.service.ts
@Injectable()
export class AlphaAccessService {
  constructor(private readonly prisma: PrismaService) {}

  async isAllowlisted(email: string): Promise<boolean> {
    const entry = await this.prisma.alphaAllowlist.findUnique({
      where: { email: email.toLowerCase() },
    });
    return entry !== null && entry.status === 'ACTIVE';
  }

  async addTester(input: {
    email: string;
    name: string;
    source: string;   // 'internal-referral' | 'waitlist' | 'direct-invite'
    invitedBy: string;
  }): Promise<void> {
    await this.prisma.alphaAllowlist.create({
      data: {
        email: input.email.toLowerCase(),
        name: input.name,
        source: input.source,
        invitedBy: input.invitedBy,
        status: 'ACTIVE',
        invitedAt: new Date(),
      },
    });
  }

  async revokeTester(email: string, reason: string): Promise<void> {
    await this.prisma.alphaAllowlist.update({
      where: { email: email.toLowerCase() },
      data: { status: 'REVOKED', revokedAt: new Date(), revokeReason: reason },
    });
  }
}

// alpha-access.guard.ts
@Injectable()
export class AlphaAccessGuard implements CanActivate {
  constructor(private readonly alphaAccess: AlphaAccessService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user?.email) return false;
    return this.alphaAccess.isAllowlisted(user.email);
  }
}
```

### Step 3: Tester Onboarding Flow

Create a structured onboarding experience:

```markdown
## Alpha Tester Onboarding Checklist

### Welcome Email Contents
- [ ] Thank you for joining the alpha
- [ ] What alpha means (expect instability, data may be wiped)
- [ ] How to access the product (URL, credentials or sign-up link)
- [ ] How to report bugs (link to feedback channel)
- [ ] How to reach the team (Slack channel, email)
- [ ] Expected time commitment (30 min/week)
- [ ] Data policy (will data persist through beta?)
- [ ] NDA or terms of participation (if applicable)

### First Session Guided Tour
- [ ] Account creation walkthrough
- [ ] Core workflow demonstration (the "aha moment")
- [ ] Feedback widget location and usage
- [ ] Known issues list (set expectations)

### Ongoing Communication Cadence
- [ ] Weekly: "What's New" changelog email
- [ ] Bi-weekly: 15-min feedback call (optional, for high-engagement testers)
- [ ] As-needed: Outage notifications (see alpha_incident_communication)
```

### Step 4: Feedback Collection System

Set up multiple feedback channels with different friction levels:

| Channel | Friction | Best For | Tool |
|---------|----------|----------|------|
| In-app widget | Very low | Bug reports, UX friction | Canny, Userback, custom |
| Slack channel | Low | Quick questions, discussion | Slack |
| Structured survey | Medium | NPS, satisfaction, feature priority | Typeform, Google Forms |
| 1:1 call | High | Deep insight, relationship building | Calendly + Zoom |

```typescript
// alpha-feedback.service.ts
@Injectable()
export class AlphaFeedbackService {
  constructor(private readonly prisma: PrismaService) {}

  async submitFeedback(input: {
    userId: string;
    type: 'BUG' | 'FEATURE_REQUEST' | 'UX_FRICTION' | 'PRAISE' | 'OTHER';
    title: string;
    description: string;
    severity?: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
    screenshotUrl?: string;
    sessionId?: string;
    pageUrl?: string;
    userAgent?: string;
  }): Promise<void> {
    await this.prisma.alphaFeedback.create({
      data: {
        ...input,
        status: 'NEW',
        submittedAt: new Date(),
      },
    });
  }

  async getFeedbackSummary(): Promise<{
    total: number;
    byType: Record<string, number>;
    bySeverity: Record<string, number>;
    avgPerTester: number;
  }> {
    // Aggregate feedback metrics for program health reporting
    const feedback = await this.prisma.alphaFeedback.groupBy({
      by: ['type'],
      _count: true,
    });
    const testerCount = await this.prisma.alphaAllowlist.count({
      where: { status: 'ACTIVE' },
    });
    const total = feedback.reduce((sum, f) => sum + f._count, 0);
    return {
      total,
      byType: Object.fromEntries(feedback.map(f => [f.type, f._count])),
      bySeverity: {}, // Similar groupBy on severity
      avgPerTester: testerCount > 0 ? total / testerCount : 0,
    };
  }
}
```

### Step 5: Alpha Program Dashboard

Track program health with key metrics:

```markdown
## Alpha Program Health Dashboard

### Tester Engagement (Weekly)
- Active testers (logged in this week): ___ / ___ total
- Testers who completed core workflow: ___ / ___
- Testers who submitted feedback: ___ / ___

### Feedback Pipeline
- New (untriaged): ___
- Acknowledged: ___
- In progress: ___
- Resolved: ___
- Won't fix: ___

### Stability Indicators
- Crash-free session rate: ___%
- P0 bugs open: ___
- P1 bugs open: ___
- Average response time to reported bugs: ___ hours

### Communication Health
- Changelog updates sent this week: Yes / No
- Outage notifications sent (if any): ___
- Average tester response time to surveys: ___ days
```

### Step 6: Alpha Program Closure

When transitioning to beta, properly close the alpha:

```markdown
## Alpha Program Closure Checklist

- [ ] Thank-you communication sent to all alpha testers
- [ ] Alpha testers auto-enrolled in beta (or given priority access)
- [ ] Alpha feedback triaged: all items either resolved, scheduled, or documented as won't-fix
- [ ] Alpha-specific feature flags cleaned up
- [ ] Alpha access guard removed or updated for beta access model
- [ ] Alpha program retrospective completed
- [ ] Alpha exit criteria evaluated (see alpha_exit_criteria skill)
- [ ] Alpha tester testimonials collected (with permission) for marketing
- [ ] Data policy honored (preserved or wiped as committed)
```

---

## CHECKLIST

- [ ] Alpha Program Charter documented with dates, cohort size, and success metrics
- [ ] Access gating implemented (invite-only allowlist with guard)
- [ ] Tester onboarding email template created and tested
- [ ] Feedback collection channels established (in-app + Slack + surveys)
- [ ] Known issues list published and kept current
- [ ] Weekly changelog communication cadence established
- [ ] Alpha program health dashboard tracks engagement and feedback volume
- [ ] Tester revocation process works (can remove access immediately)
- [ ] Data preservation policy communicated to all testers
- [ ] Alpha closure checklist prepared for transition to beta

---

*Skill Version: 1.0 | Created: February 2026*
