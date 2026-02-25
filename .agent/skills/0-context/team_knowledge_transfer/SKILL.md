---
name: Team Knowledge Transfer
description: Structured protocols for extracting knowledge from outgoing developers or inherited codebases.
---

# Team Knowledge Transfer

## TRIGGER COMMANDS
- "Someone is leaving the team"
- "I inherited this project"
- "Extract knowledge before handoff"
- "Reduce bus factor"
- "Document tribal knowledge"
- "Onboard me to this codebase"
- "Knowledge transfer session"

## When to Use
Use this skill when a key developer is leaving the team and their knowledge needs to be captured before they go, when a team inherits a project from another team with no handoff documentation, or when you realize the bus factor on a critical system is 1. Time is often limited in these situations, so the process is designed to extract the highest-value knowledge first and progressively capture more detail.

## The Process

### 1. Knowledge Map
- Identify what the outgoing developer (or absent original team) uniquely knows:
  - Architecture decisions and their rationale
  - Undocumented workarounds and their reasons
  - Deployment procedures and gotchas
  - Vendor relationships and account access
  - Historical context for confusing code
- Categorize knowledge by urgency: what is needed to keep the system running (Critical), what is needed to develop new features (High), what is nice to have (Medium)
- Identify knowledge that exists only in one person's head vs knowledge that is partially documented elsewhere
- Create a knowledge inventory matrix: topic x who knows it x documentation status

### 2. Structured Interview Protocol
- Conduct interviews using these 5 standard questions (adapt to your context):
  1. **"What would break first if nobody maintained this for 6 months?"** -- reveals the most fragile dependencies and maintenance tasks
  2. **"What's the most fragile part of the system and why?"** -- uncovers architectural weak points and their history
  3. **"What workarounds exist that aren't documented?"** -- surfaces hidden fixes, monkey-patches, and manual interventions
  4. **"What would you do differently if starting over?"** -- captures lessons learned and potential improvement paths
  5. **"Who else knows parts of this system?"** -- maps the remaining knowledge distribution
- Record the answers (with permission) for later reference
- Follow up on vague answers: "Can you show me in the code?" and "When did this last happen?"
- Allocate 60-90 minutes per session, schedule at least 3 sessions spaced across different days

### 3. Decision Archaeology
- Review git blame and PR history for critical files to understand WHY things were built a certain way
- Read old PR descriptions and review comments for context that never made it into documentation
- Check issue trackers for closed bugs that reveal past failure modes and their fixes
- Look for revert commits and their associated discussions -- they reveal decisions that were tried and abandoned
- Interview the developer about specific commits: "I see you changed X to Y in this commit -- what was the context?"
- Document each significant decision as: Decision, Context, Alternatives Considered, Why This Was Chosen

### 4. Runbook Creation
- For each critical system or process, create a runbook covering:
  - **How to deploy**: step-by-step, including environment-specific differences
  - **How to rollback**: what to do when a deployment goes wrong
  - **How to debug common issues**: symptoms, likely causes, resolution steps
  - **How to handle data issues**: corrupted data, migration failures, backup restoration
  - **Emergency contacts**: who to call for infrastructure, third-party services, business decisions
- Test each runbook by having someone other than the author follow it
- Store runbooks in a location that is accessible during incidents (not behind the VPN that might be down)

### 5. Shadow Sessions
- Pair program with the outgoing developer on 3-5 representative tasks:
  - A bug fix in a complex area
  - A feature addition that touches multiple modules
  - A deployment to production
  - A debugging session for a production issue (simulated if necessary)
  - A code review of a non-trivial PR
- The goal is to absorb implicit knowledge: how they navigate the codebase, what they check first, what mental models they use
- Take notes during each session on anything surprising or non-obvious
- Ask "why" frequently: "Why did you check that file first?" and "How did you know to look there?"

### 6. Oral Tradition Capture
- Document the "everyone knows that" rules that exist only in people's heads:
  - "Never deploy on Fridays because the batch job runs Saturday morning"
  - "The staging database is shared with QA, so don't drop tables"
  - "Module X is slow on first call because it lazy-loads a 2GB model"
  - "Customer Y has a special configuration that bypasses the normal flow"
- Check Slack/Teams history for informal knowledge sharing that was never formalized
- Review onboarding notes from previous new hires -- they often captured things that seemed obvious to the team
- Create a "Gotchas" document organized by system area

### 7. Bus Factor Analysis
- For each critical system component, count how many people can:
  - Explain how it works at an architectural level
  - Make code changes to it confidently
  - Deploy it to production
  - Debug it when it breaks at 3am
- Identify single points of failure: components where only one person (or zero, if they already left) can do all four
- Create a redundancy plan: for each single-point-of-failure, assign a backup person and a training plan
- Set a target bus factor of at least 2 for every critical component
- Schedule regular knowledge-sharing sessions (weekly tech talks, rotating on-call, pair programming) to maintain knowledge distribution

### 8. Knowledge Base Compilation
- Organize all extracted knowledge into a searchable, maintained structure:
  - Architecture overview and component descriptions
  - Decision records (ADRs) with context and rationale
  - Runbooks for deployment, debugging, and incident response
  - Gotchas and tribal knowledge document
  - Contact list and escalation paths
  - Glossary of project-specific terms and acronyms
- Store in a location the team actively uses (repo wiki, Notion, Confluence -- not a dusty shared drive)
- Assign an owner for keeping the knowledge base current
- Add "update the knowledge base" as a step in the definition of done for new features

## Checklist
- [ ] Knowledge map created identifying all critical knowledge areas and their documentation status
- [ ] At least 3 structured interview sessions completed with notes captured
- [ ] Decision archaeology performed on the 10 most critical files/modules via git history
- [ ] Runbooks created for deployment, rollback, and debugging of all critical systems
- [ ] At least 3 shadow/pair programming sessions completed with notes
- [ ] Oral tradition and tribal knowledge documented in a searchable format
- [ ] Bus factor calculated for every critical component with a target of 2+
- [ ] Redundancy plan created for all single-point-of-failure knowledge areas
- [ ] Knowledge base compiled, organized, and stored in an accessible location
- [ ] Knowledge base ownership assigned and maintenance cadence established
