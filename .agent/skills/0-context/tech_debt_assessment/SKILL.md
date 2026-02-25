---
name: Tech Debt Assessment
description: Quantify and prioritize technical debt with business impact scoring and a living debt register.
---

# Tech Debt Assessment

## TRIGGER COMMANDS
- "Assess technical debt"
- "How much tech debt does this project have"
- "Prioritize what to fix first"
- "Create a tech debt register"
- "What's the worst technical debt here"
- "Score the tech debt by business impact"

## When to Use
Use this skill when a project feels slow to develop in, when bugs keep recurring in the same areas, or when leadership asks for a concrete accounting of technical debt. This is essential before planning a modernization effort, during sprint planning when deciding between features and fixes, or when a new team inherits a codebase and needs to understand where the landmines are buried.

## The Process

### 1. Code Complexity Scan
- Measure cyclomatic complexity per function/method -- flag anything above 15 as high, above 25 as critical
- Measure cognitive complexity to identify code that is hard to understand even if cyclomatic complexity is moderate
- Identify function length outliers: functions over 100 lines, files over 500 lines
- Check nesting depth: deeply nested conditionals (4+ levels) indicate logic that should be decomposed
- Look for god classes/modules that have accumulated too many responsibilities over time
- Catalog any functions with more than 5 parameters (likely doing too much)

### 2. Duplication Analysis
- Identify exact copy-paste code blocks across the codebase
- Find near-duplicates: code that does the same thing with minor variations (different variable names, slightly different logic)
- Identify patterns that should be abstracted into shared utilities, base classes, or higher-order functions
- Check for duplicated business logic between frontend and backend (validation rules, calculations)
- Measure the total percentage of duplicated code -- above 10% is a yellow flag, above 20% is red

### 3. Test Coverage Gaps
- Map which critical paths have zero test coverage
- Identify modules or services with no tests at all
- Check for test anti-patterns that give false confidence: tests with no assertions, tests that mock everything, tests that only test the happy path
- Verify that error paths, edge cases, and boundary conditions are tested
- Identify integration test gaps: are the seams between modules tested?
- Flag any mission-critical business logic (payments, auth, data mutations) that lacks thorough testing

### 4. Dependency Staleness
- List all dependencies with their current version vs latest version
- Check for end-of-life (EOL) libraries that no longer receive security patches
- Run vulnerability scanners (npm audit, pip audit, cargo audit, etc.) and catalog known CVEs
- Identify dependencies that are more than 2 major versions behind
- Check for abandoned dependencies: no commits in 2+ years, archived repositories
- Flag dependencies with restrictive or incompatible licenses

### 5. Pattern Violations
- Check for inconsistent error handling: some modules throw, some return error codes, some swallow errors
- Verify logging consistency: are all modules logging at appropriate levels with structured data?
- Audit authentication and authorization patterns: are guards applied consistently? Any unprotected endpoints?
- Check validation patterns: is input validated at the boundary? Are there modules that trust raw input?
- Identify naming convention violations, inconsistent file organization, and deviations from established patterns
- Look for TODO/FIXME/HACK comments and assess their age and severity

### 6. Business Impact Scoring
- For each identified debt item, score the following dimensions:
  - **Effort to Fix**: S (< 1 day), M (1-3 days), L (1-2 weeks), XL (> 2 weeks)
  - **Risk of Not Fixing**: 1 (negligible) to 5 (system failure likely)
  - **Blast Radius**: Isolated (one function), Module (one feature area), System (cross-cutting)
  - **Customer Impact**: None, Degraded (slower/uglier), Broken (feature doesn't work), Data Loss
- Multiply risk by blast radius for a composite severity score
- Tag each item with the business domain it affects (auth, payments, core workflow, admin, etc.)

### 7. Prioritization Matrix
- Calculate a RICE score for each debt item: Reach x Impact x Confidence / Effort
- Group all items into four buckets:
  - **Fix Now**: High severity, low effort (quick wins that reduce risk immediately)
  - **Fix Next Sprint**: High severity, medium effort (important but needs planning)
  - **Track**: Medium severity, any effort (monitor, fix opportunistically)
  - **Accept**: Low severity, high effort (not worth fixing given current constraints)
- Identify clusters: if 5 debt items are all in the same module, fixing that module is a single project
- Flag any items where delay increases the fix cost (debt that compounds)

### 8. Tech Debt Register
- Create a structured document with the following for each item:
  - Unique ID, title, description
  - Category (complexity, duplication, testing, dependencies, patterns, architecture)
  - Severity scores from step 6
  - Priority bucket from step 7
  - Affected files/modules
  - Suggested fix approach
  - Owner (if assigned)
  - Target resolution date (if prioritized)
- Include a summary dashboard: total items by category, total items by priority, trend over time
- Define a review cadence: revisit the register every sprint or every month

## Checklist
- [ ] Code complexity scan completed with all outliers identified and scored
- [ ] Duplication analysis run with percentage and specific instances documented
- [ ] Test coverage gaps mapped for all critical business paths
- [ ] All dependencies checked for staleness, EOL status, and known vulnerabilities
- [ ] Pattern violations cataloged with specific examples
- [ ] Every debt item has a business impact score (effort, risk, blast radius, customer impact)
- [ ] RICE-scored prioritization matrix produced with four priority buckets
- [ ] Tech debt register created as a living document with unique IDs and owners
- [ ] Top 5 "Fix Now" items have concrete action plans
- [ ] Register review cadence established and communicated to the team
