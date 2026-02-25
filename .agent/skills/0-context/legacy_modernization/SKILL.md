---
name: Legacy Modernization
description: Incremental modernization strategies for legacy codebases using strangler fig, branch by abstraction, and parallel runs.
---

# Legacy Modernization

## TRIGGER COMMANDS
- "Modernize this legacy code"
- "Plan a strangler fig migration"
- "How do I rewrite this incrementally"
- "This codebase is outdated, what's the path forward"
- "Migrate away from this legacy system"
- "Plan an incremental rewrite"

## When to Use
Use this skill when a codebase is built on outdated technology that is slowing development, when the team can no longer hire developers who know the legacy stack, or when the system's architecture cannot support new business requirements. This skill is specifically for incremental modernization -- not big-bang rewrites -- because incremental approaches deliver value continuously and dramatically reduce the risk of failure.

## The Process

### 1. Legacy Assessment
- Identify the "legacy boundary": draw a clear line between what is considered legacy and what is already modern
- Catalog outdated patterns: deprecated language features, obsolete frameworks, abandoned libraries
- Measure the scale: how many lines of code, how many modules, how many developers touch it
- Assess the current deployment model: can the legacy code be deployed independently?
- Document the legacy system's current capabilities exhaustively -- you cannot replace what you do not understand
- Identify which parts of the legacy system are actively developed vs frozen vs rotting

### 2. Risk Analysis
- Map all dependencies on legacy code: what other systems call it? What does it call?
- Identify blast radius: if a modernization step breaks something, what is affected?
- Assess data migration risks: does the legacy system have a unique data model that must be preserved?
- Check for undocumented behavior that users depend on ("it's not a bug, it's a feature")
- Evaluate regulatory/compliance constraints: are there audit trails, data retention rules, or certifications tied to the legacy system?
- Score each module's modernization risk as Low/Medium/High/Critical

### 3. Strategy Selection
- Choose the modernization approach based on risk tolerance, team capacity, and system characteristics:
  - **Strangler Fig**: Best for systems with clear entry points (HTTP APIs, message consumers). Route new traffic to new implementation while gradually redirecting old traffic. Zero downtime.
  - **Branch by Abstraction**: Best for tightly coupled internal modules. Introduce an abstraction layer (interface), build new implementation behind it, swap when ready. Allows parallel development.
  - **Parallel Run**: Best for high-risk business logic (payments, calculations). Run old and new implementations side-by-side, compare outputs on every request, switch only when outputs match consistently.
  - **Big Bang Rewrite**: Only appropriate for small, well-tested systems with low risk. Full rewrite deployed all at once. High risk, fast result.
- Document the rationale for the chosen strategy with explicit trade-offs
- It is valid to use different strategies for different parts of the system

### 4. Migration Plan
- Break the modernization into phases, where each phase is independently deployable and valuable
- Define the migration sequence: start with the lowest-risk, highest-value modules
- For each phase:
  - What is being modernized
  - What is the new technology/pattern
  - What is the rollback plan if it fails
  - How long will old and new coexist
  - What tests verify the migration succeeded
- Establish clear milestones and go/no-go criteria for each phase
- Plan for the team to maintain both old and new systems during the transition period

### 5. Compatibility Layer
- Design backward-compatible interfaces that allow old and new systems to coexist
- Implement adapters/anti-corruption layers at the boundary between legacy and modern code
- Ensure the compatibility layer handles data format differences, protocol differences, and semantic differences
- Plan for the compatibility layer to be temporary -- it should be removable once migration is complete
- Test the compatibility layer under production-like load to verify it does not introduce latency or errors

### 6. Feature Parity Verification
- Write characterization tests against the legacy system BEFORE building the new implementation
- Characterization tests capture what the system actually does (not what it should do)
- For each migrated module, verify that the new implementation produces identical outputs for identical inputs
- Document intentional behavioral differences (bug fixes, improved validation) explicitly
- Use shadow testing: send real traffic to both old and new, compare results without affecting users
- Maintain a feature parity checklist that tracks which legacy behaviors have been verified in the new system

### 7. Incremental Cutover
- Use traffic splitting to gradually move users from old to new:
  - 1% -- canary: verify no errors
  - 10% -- early adopter: verify performance characteristics
  - 50% -- half traffic: verify at scale
  - 100% -- full cutover: monitor closely for 1-2 weeks
- Define rollback triggers: error rate > X%, latency > Yms, data inconsistency detected
- Ensure rollback is instant (< 1 minute) and automated if possible
- Monitor both old and new systems during cutover for comparison
- Keep the old system running (but not receiving traffic) for at least 2 weeks after full cutover

### 8. Legacy Decommission
- Only decommission after the new system has been stable in production for the agreed period
- Remove the compatibility layer / adapters
- Archive the legacy code (do not delete -- move to an archive branch or repository)
- Update all documentation to reflect the new system
- Remove legacy infrastructure (servers, databases, CI pipelines) after confirming nothing depends on them
- Conduct a retrospective: what went well, what was harder than expected, what would you do differently

## Checklist
- [ ] Legacy boundary clearly defined with all legacy modules cataloged
- [ ] Risk analysis completed with blast radius and dependency mapping for each module
- [ ] Modernization strategy selected and documented with explicit rationale
- [ ] Migration plan broken into independently deployable phases with rollback plans
- [ ] Compatibility layer designed and tested under production-like conditions
- [ ] Characterization tests written for all legacy behavior before modernization begins
- [ ] Feature parity verified for each migrated module with documented intentional differences
- [ ] Incremental cutover plan in place with traffic splitting percentages and rollback triggers
- [ ] Monitoring configured to compare old and new system behavior during transition
- [ ] Legacy decommission criteria defined (stability period, dependency verification, archive plan)
