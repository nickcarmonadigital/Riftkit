# AGE 8-Loop Protocol Reference

## Loop Assignments
- **Loops 1-3 (Architect)**: Deconstruct phase from first principles
- **Loops 4-6 (Detective)**: Reverse-think — what MUST exist if this works?
- **Loops 7-8 (Builder)**: Spec solutions for confirmed gaps

## Loop Details

### Loop 1 (Architect)
Read all SKILL.md files in the target phase. Deconstruct what "complete coverage" means using first principles. List every atomic responsibility this phase should own. Think about what a world-class software framework would cover for this phase.

### Loop 2 (Architect)
Read gaps.log from Loop 1. Compare first-principles decomposition against actual skill inventory. Grade each existing skill's depth (surface/adequate/thorough). Document every first-principle that has NO skill covering it.

### Loop 3 (Architect)
Read gaps.log from Loops 1-2. Analyze handoff points with adjacent phases (N-1 and N+1). What falls through the cracks between phases? What does this phase assume was done upstream that no skill ensures?

### Loop 4 (Detective)
Read gaps.log from Loops 1-3. Reverse thinking: "If a project completed this phase perfectly, what MUST have happened?" Work backward from ideal end-state. Note every delta between what existing skills produce and what should exist.

### Loop 5 (Detective)
Read gaps.log from Loops 1-4. "What failure modes exist that no skill addresses?" For each existing skill, what goes wrong when context changes (different stack, team size, compliance regime, scale)?

### Loop 6 (Detective)
Read gaps.log from Loops 1-5. Compare against industry standards (DORA metrics, OWASP, SRE practices, ISO 27001, SOC2, NIST, CIS benchmarks, etc.). What does industry mandate that the framework ignores?

### Loop 7 (Builder)
Read gaps.log from Loops 1-6. For each confirmed gap, spec the solution: new SKILL.md, new agent, new command, or docs. Include: name, phase, trigger commands, 3-sentence scope, and priority (P0=critical, P1=high, P2=medium, P3=low).

### Loop 8 (Builder)
Read gaps.log from Loops 1-7. For each solution from Loop 7: define dependencies between proposed skills, complexity (S=1-2hrs, M=half-day, L=full-day), and whether it needs framework infrastructure (new agent/command/workflow) or is a standalone SKILL.md.

## gaps.log Entry Format

Each loop MUST append entries in this exact format:

```
================================================================
[Loop N] [Role] [Target-ID] YYYY-MM-DDTHH:MM:SSZ
================================================================

## Finding: <Title>

### Gap Type: MISSING_SKILL | SHALLOW_COVERAGE | MISSING_HANDOFF | INDUSTRY_DEVIATION | FAILURE_MODE_UNCOVERED
### Severity: CRITICAL | HIGH | MEDIUM | LOW
### Evidence: <What exists, what doesn't, why it matters>
### Proposed Resolution: <Skill name, phase, trigger, scope>
### Cross-Phase Impact: <How this gap affects other phases>
================================================================
```

## Rules
1. Each loop starts fresh — read ONLY the gaps.log for cross-loop memory
2. Multiple findings per loop are OK — append each as a separate entry
3. Later loops should NOT duplicate earlier findings — read the log first
4. Builder loops (7-8) must reference specific findings from earlier loops
5. Be specific and actionable — vague findings are useless
6. Grade severity honestly — not everything is CRITICAL

## Phase Adjacency Map
- Phase 0 (Context) → Phase 1 (Brainstorm)
- Phase 1 (Brainstorm) → Phase 2 (Design)
- Phase 2 (Design) → Phase 3 (Build)
- Phase 3 (Build) → Phase 4 (Secure)
- Phase 4 (Secure) → Phase 5 (Ship)
- Phase 5 (Ship) → Phase 5.5 (Alpha)
- Phase 5.5 (Alpha) → Phase 5.75 (Beta)
- Phase 5.75 (Beta) → Phase 6 (Handoff)
- Phase 6 (Handoff) → Phase 7 (Maintenance)
- Toolkit: Cross-cuts all phases
