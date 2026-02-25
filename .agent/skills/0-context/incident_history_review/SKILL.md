---
name: Incident History Review
description: Analyze past incidents, post-mortems, and on-call runbooks to understand failure modes and improve resilience.
---

# Incident History Review

## TRIGGER COMMANDS
- "Review incident history"
- "What has broken before"
- "Analyze past outages"
- "Find recurring failures"
- "Improve system resilience"
- "What are our failure patterns"
- "Post-mortem analysis"

## When to Use
Use this skill when a system keeps experiencing similar failures and the team needs to break the cycle, when taking over a system and needing to understand its failure modes before being on-call, or when leadership asks why incidents keep happening and what it will take to improve reliability. This is a retrospective analysis that turns past pain into future prevention.

## The Process

### 1. Incident Catalog
- Collect all past incidents from every available source:
  - Monitoring alerts and alert history (PagerDuty, OpsGenie, Datadog)
  - Error tracking platforms (Sentry, Bugsnag, Rollbar)
  - Support tickets escalated from customers
  - Git revert commits and hotfix branches (search for "revert", "hotfix", "emergency")
  - Slack/Teams incident channels and war room transcripts
  - Existing post-mortem documents
  - Status page history (Statuspage, Cachet)
- For each incident, record:
  - Date and duration
  - Severity (Sev1-Sev4)
  - Brief description of what happened
  - Affected component(s)
  - Number of affected users (if known)
  - Whether a post-mortem was written
- Create a timeline: plot all incidents chronologically to visualize patterns and trends

### 2. Pattern Analysis
- Categorize each incident by root cause type:
  - **Deploy**: bad code push, configuration change, infrastructure change
  - **Dependency**: third-party service outage, API change, certificate expiration
  - **Data**: data corruption, migration failure, unexpected data volume
  - **Load**: traffic spike, resource exhaustion, cascading failure
  - **Security**: breach, DDoS, credential compromise
  - **Human**: manual error, miscommunication, process failure
- Cross-reference with affected component to build a heat map: which components fail most often?
- Analyze temporal patterns: are incidents more common on deploy days? End of month? Specific times?
- Measure detection time (time from failure to alert) and resolution time (time from alert to fix) for each incident
- Calculate Mean Time to Detect (MTTD) and Mean Time to Resolve (MTTR) by category

### 3. Recurring Failure Identification
- Group incidents that share the same root cause, even if symptoms differed
- Identify "whack-a-mole" patterns: the same underlying issue manifesting in different ways
- Look for incidents where the fix was a workaround rather than a root cause resolution
- Check for incidents that were "resolved" but the action items were never completed
- Flag any failure that has occurred 3+ times -- this indicates a systemic issue, not bad luck
- For each recurring failure, trace the chain: Why does this keep happening? What structural condition allows it?

### 4. Post-Mortem Review
- For each significant incident (Sev1-Sev2), verify a post-mortem exists and contains:
  - **What happened**: clear timeline of events
  - **Why it happened**: root cause analysis (5 Whys or equivalent)
  - **What was the fix**: immediate resolution and permanent fix
  - **Was the fix permanent**: did it address the root cause or just the symptom?
  - **Action items**: what was supposed to prevent recurrence
  - **Action item status**: were they completed? If not, why not?
- For incidents without post-mortems, write retroactive ones using available data
- Look for patterns in action item abandonment: are items too large? Wrong owner? Deprioritized?
- Assess post-mortem quality: blameless? Focused on systems, not people? Actionable recommendations?

### 5. Blast Radius Mapping
- For each incident, document the blast radius:
  - Number of affected users or percentage of traffic
  - Revenue impact (if measurable)
  - Duration of user-facing impact
  - Downstream effects on other systems or teams
- Rank incidents by total impact (users x duration x severity)
- Identify which components, when they fail, cause the widest blast radius
- Map containment effectiveness: which incidents were contained to a single component vs cascading across the system?
- Identify missing circuit breakers, bulkheads, or isolation mechanisms

### 6. Detection Gap Analysis
- Identify incidents that were reported by users before monitoring detected them
- For each user-reported incident, determine: was monitoring in place? Did it fire? Was it the wrong threshold?
- Catalog monitoring blind spots: what failure modes have no monitoring at all?
- Check for "silent failures": errors that occur but do not trigger alerts (swallowed exceptions, degraded performance below alert threshold)
- Review alert effectiveness: what percentage of alerts correspond to real incidents vs noise?
- Identify missing synthetic monitoring: are critical user journeys continuously tested?
- Check for missing business metric monitoring: revenue drops, conversion rate changes, order volume anomalies

### 7. Runbook Completeness
- For each known failure mode, check if a runbook exists
- Evaluate each runbook:
  - Is it up to date (last updated within 6 months)?
  - Is it specific enough to follow under stress at 3am?
  - Does it include rollback procedures?
  - Has it been tested by someone other than the author?
  - Does it include escalation paths for when the runbook does not resolve the issue?
- Identify failure modes with no runbook at all
- Check that runbooks are accessible during incidents (not hosted on the infrastructure that might be down)
- Verify that runbooks reference current tools, commands, and URLs (not outdated ones)

### 8. Resilience Recommendations
- Produce a prioritized list of improvements based on the analysis:
  - **Prevention**: changes that stop failures from happening (better testing, input validation, capacity planning)
  - **Detection**: changes that catch failures faster (new monitors, better alerting, synthetic checks)
  - **Recovery**: changes that reduce time to resolve (runbooks, automation, rollback mechanisms)
  - **Containment**: changes that limit blast radius (circuit breakers, bulkheads, graceful degradation)
- Score each recommendation by:
  - **Impact**: how many incidents would it have prevented or shortened? (1-5)
  - **Effort**: how much work to implement? (S/M/L/XL)
  - **Confidence**: how sure are we this will work? (Low/Medium/High)
- Identify the top 3 investments that would most improve system reliability
- Propose a reliability improvement roadmap with quarterly milestones
- Recommend process improvements: incident response training, game days, chaos engineering, post-mortem follow-through

## Checklist
- [ ] All incidents collected from monitoring, error tracking, support tickets, and git history
- [ ] Incidents categorized by root cause type with a heat map of affected components
- [ ] MTTD and MTTR calculated per category with trends over time
- [ ] Recurring failures identified with root cause chains documented
- [ ] Post-mortems reviewed (or retroactively written) for all Sev1-Sev2 incidents
- [ ] Action item completion rate measured and abandonment patterns identified
- [ ] Blast radius mapped for each incident with highest-impact failures ranked
- [ ] Detection gaps identified with specific monitoring improvements recommended
- [ ] Runbook completeness assessed for every known failure mode
- [ ] Prioritized resilience recommendation list produced with impact/effort scoring
- [ ] Top 3 reliability investments identified with a quarterly improvement roadmap
