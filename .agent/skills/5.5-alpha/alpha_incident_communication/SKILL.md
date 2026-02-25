---
name: Alpha Incident Communication
description: Incident communication protocol for alpha's small, high-trust tester cohort with templates and channels
---

# Alpha Incident Communication Skill

**Purpose**: Establish an incident communication protocol tailored to alpha's small, high-trust cohort. Unlike production incident communication (which targets thousands of anonymous users via status pages), alpha communication is direct, personal, and transparent. The goal is to maintain tester trust during instability periods and turn incidents into opportunities for deeper tester engagement.

## TRIGGER COMMANDS

```text
"Alpha incident communication"
"Notify alpha testers of outage"
"Alpha status update"
"Alpha incident template"
"Using alpha_incident_communication skill: notify about [incident]"
```

## When to Use
- When an outage or degradation affects alpha testers
- When a planned maintenance window will cause downtime
- When a data issue is discovered that affects alpha tester data
- When a security incident affects the alpha environment
- When setting up the communication framework before alpha launch

---

## PROCESS

### Step 1: Define Communication Channels

Alpha communication is more direct than production status pages:

| Channel | Speed | Best For | Setup |
|---------|-------|----------|-------|
| Slack channel | Instant | Real-time updates, conversation | `#alpha-testers` channel |
| Email list | Minutes | Formal notices, post-mortems | Mailing list or BCC group |
| In-app banner | Immediate | Active users during outage | Dismissible banner component |
| Status page (simple) | Minutes | Current status reference | Static page or GitHub Pages |

Recommended setup: Slack for real-time + Email for formal records + In-app banner for active sessions.

### Step 2: Incident Severity Classification

| Severity | Definition | Communication SLA | Channels |
|----------|-----------|-------------------|----------|
| SEV-1 | Service completely down | 15 minutes | Slack + Email + In-app |
| SEV-2 | Major feature broken | 30 minutes | Slack + In-app |
| SEV-3 | Minor feature degraded | 1 hour | Slack |
| Planned | Scheduled maintenance | 24 hours advance | Email + Slack |

### Step 3: Communication Templates

#### Initial Incident Notification (Slack)

```markdown
## Alpha Status Update

**Status**: Investigating an issue
**Impact**: [describe what testers will experience]
**Started**: [time UTC]

We're aware of [brief description of the issue]. If you're currently
using the app, you may notice [specific symptoms].

We're investigating and will post updates here. No action needed
from you right now.
```

#### Update During Incident (Slack)

```markdown
## Alpha Status Update

**Status**: Identified / Fix in progress
**Impact**: [unchanged / reduced]
**Duration so far**: [X minutes/hours]

We've identified the cause: [brief, honest explanation].
We're [what you're doing to fix it]. Expected resolution: [ETA or "unknown"].

Thank you for your patience. Your data is [safe / being verified].
```

#### Resolution Notification (Slack + Email)

```markdown
## Alpha Status: Resolved

**Issue**: [brief description]
**Duration**: [start time] to [end time] ([total duration])
**Impact**: [what testers experienced]
**Resolution**: [what fixed it]

The issue is now resolved. Everything should be working normally.
If you notice anything unusual, please let us know in this channel.

We'll share a more detailed post-mortem within [48 hours].
```

#### Post-Mortem Shared with Testers (Email)

```markdown
Subject: Post-Mortem: [Incident title] - [Date]

Hi [tester name / Alpha testers],

As promised, here's our post-mortem on the [incident description]
that affected you on [date].

**What happened**: [2-3 sentences, honest and non-technical]

**What we've done to prevent recurrence**:
1. [Action taken 1]
2. [Action taken 2]
3. [Action taken 3]

**What this means for you**: [any action needed, data impact, etc.]

We value your trust as an alpha tester. Incidents like this are
exactly why we run an alpha program -- to find and fix issues before
a wider release. Your patience makes the product better for everyone.

If you have questions, reply to this email or reach out in #alpha-testers.

-- [Your name]
```

#### Planned Maintenance Notice (Email, 24h advance)

```markdown
Subject: Planned Maintenance: [Date] [Time Range] UTC

Hi Alpha Testers,

We'll be performing maintenance on [date] from [start] to [end] UTC
(approximately [duration]).

**What to expect**: [service unavailable / degraded performance / brief interruptions]

**Why**: [brief explanation -- be transparent about what you're improving]

**What you need to do**: Save any work in progress before [start time].
The app will be back to normal by [end time].

If the maintenance window changes, we'll update you in #alpha-testers.

-- [Your name]
```

### Step 4: In-App Incident Banner

```typescript
// AlphaStatusBanner.tsx
import { useEffect, useState } from 'react';

interface StatusInfo {
  active: boolean;
  severity: 'info' | 'warning' | 'error';
  message: string;
  updatedAt: string;
}

function AlphaStatusBanner() {
  const [status, setStatus] = useState<StatusInfo | null>(null);

  useEffect(() => {
    const checkStatus = async () => {
      try {
        const res = await fetch('/api/alpha/status');
        if (res.ok) {
          const data = await res.json();
          if (data.active) setStatus(data);
        }
      } catch {
        // Silently fail -- don't add noise during outages
      }
    };

    checkStatus();
    const interval = setInterval(checkStatus, 60_000);
    return () => clearInterval(interval);
  }, []);

  if (!status?.active) return null;

  const colors = {
    info: 'bg-blue-50 border-blue-200 text-blue-800',
    warning: 'bg-yellow-50 border-yellow-200 text-yellow-800',
    error: 'bg-red-50 border-red-200 text-red-800',
  };

  return (
    <div role="alert" className={`p-3 border-b ${colors[status.severity]}`}>
      <p className="text-sm font-medium">{status.message}</p>
      <p className="text-xs mt-1 opacity-75">
        Updated: {new Date(status.updatedAt).toLocaleString()}
      </p>
    </div>
  );
}
```

### Step 5: Incident Communication Runbook

```markdown
## Alpha Incident Communication Runbook

### On Incident Detection
1. Post initial notification in #alpha-testers Slack (within SLA)
2. If SEV-1 or SEV-2: send email to alpha tester list
3. Update in-app status banner via admin endpoint
4. Acknowledge any direct tester reports within 10 minutes

### During Incident
5. Post updates every 30 minutes (or when status changes)
6. Respond to tester questions in Slack within 15 minutes
7. If data is affected, state explicitly whether data is safe

### On Resolution
8. Post resolution message in Slack
9. Clear in-app status banner
10. Send resolution email within 1 hour of resolution
11. Schedule post-mortem within 48 hours

### Post-Incident
12. Write post-mortem (use template above)
13. Share post-mortem with alpha testers via email
14. Update known issues list if relevant
15. Thank testers who reported the issue
```

---

## CHECKLIST

- [ ] Slack channel `#alpha-testers` created and all testers invited
- [ ] Alpha tester email distribution list configured
- [ ] In-app status banner component implemented
- [ ] Admin endpoint for updating in-app status exists
- [ ] Incident severity levels defined with communication SLAs
- [ ] Communication templates prepared for each incident phase
- [ ] Planned maintenance template prepared with 24h advance notice
- [ ] Post-mortem sharing process documented (within 48h)
- [ ] Incident communication runbook accessible to on-call engineers
- [ ] Tester-reported issues acknowledged within 10 minutes during incidents

---

*Skill Version: 1.0 | Created: February 2026*
