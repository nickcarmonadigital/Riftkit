---
name: Codebase Health Audit
description: Automated quality, security, and dependency baseline scan with severity triage and A-F grading.
---

# Codebase Health Audit

## TRIGGER COMMANDS
- "Run a health audit"
- "How healthy is this codebase"
- "Generate a health report"
- "Baseline the code quality"
- "Give me a codebase report card"
- "Audit this project"

## When to Use
Use this skill when joining a new project and needing to quickly assess its state, before a major release to verify quality gates, or as a periodic checkpoint (monthly/quarterly) to track codebase health over time. This provides a comprehensive, objective snapshot that can be compared across time periods to measure improvement or degradation.

## The Process

### 1. Static Analysis
- Run the appropriate linters for the project's languages: ESLint (JS/TS), Pylint/Ruff (Python), golangci-lint (Go), Clippy (Rust), etc.
- Check for disabled lint rules (eslint-disable, noqa, #[allow]) -- count them and categorize by rule
- Separate warnings from errors: errors are blocking, warnings indicate drift
- Check for consistent formatting: is Prettier/Black/gofmt configured and enforced?
- Verify that static analysis runs in CI and blocks merges on failure
- Count total lint issues and calculate issues-per-1000-lines-of-code as a normalized metric

### 2. Security Scan
- Search for hardcoded secrets: grep for API keys, passwords, tokens, private keys, connection strings
- Check for .env files committed to git or secrets in docker-compose files
- Run dependency vulnerability scanners: `npm audit`, `pip audit`, `cargo audit`, `bundler-audit`
- Check OWASP Top 10 patterns: SQL injection (raw queries), XSS (unsanitized output), CSRF (missing tokens), insecure deserialization
- Verify authentication is applied consistently across all routes/endpoints
- Check for overly permissive CORS, missing rate limiting, and absent input validation
- Verify TLS configuration and secure cookie flags where applicable

### 3. Dependency Health
- Count direct vs transitive dependencies -- a high ratio of transitive deps indicates a fragile supply chain
- Check for unmaintained packages: no commits in 2+ years, archived repos, deprecated notices
- Run a license compatibility audit: identify copyleft licenses (GPL) that may conflict with your project's license
- Check for dependency version pinning: are versions locked or floating?
- Identify duplicate dependencies (different versions of the same package in the tree)
- Measure total dependency weight and identify unnecessarily heavy packages

### 4. Test Health
- Measure test coverage percentage by line, branch, and function
- Identify test anti-patterns:
  - Tests with no assertions (they always pass)
  - Excessive mocking (testing mocks, not code)
  - Hardcoded test data that masks edge cases
  - Flaky test markers (@skip, @flaky, retry decorators)
  - Tests that depend on execution order or shared state
- Check the ratio of unit tests to integration tests to end-to-end tests (healthy: 70/20/10)
- Verify tests run in CI and that failures block merges
- Measure test execution time -- slow test suites get run less often

### 5. Build Health
- Measure clean build time and incremental build time
- Check for unnecessary rebuilds: are cache layers configured correctly?
- Verify CI pipeline exists, is green, and runs on every PR
- Check for build warnings that have been ignored over time
- Verify that build artifacts are reproducible (same input = same output)
- Check Docker image size and layer efficiency if containerized
- Verify that development environment setup is documented and works (can a new dev build in < 30 minutes?)

### 6. Documentation Health
- Check README completeness: does it cover setup, usage, architecture overview, and contribution guide?
- Measure API documentation coverage: are all public endpoints/functions documented?
- Check inline comment ratio: not too few (no context) and not too many (noisy/stale)
- Verify that architectural documentation exists and is current (last updated within 6 months)
- Check for runbooks covering deployment, rollback, and common debugging scenarios
- Verify CHANGELOG or release notes exist and are maintained

### 7. Severity Triage
- Classify all findings into four severity levels:
  - **Critical** (fix before next deploy): security vulnerabilities with known exploits, hardcoded production secrets, broken authentication
  - **High** (fix this sprint): failing tests, outdated dependencies with CVEs, significant coverage gaps in critical paths
  - **Medium** (fix this quarter): code complexity outliers, pattern inconsistencies, documentation gaps
  - **Low** (track): minor lint warnings, cosmetic issues, nice-to-have improvements
- For each finding: document the specific file/line, the issue, and the recommended fix
- Estimate total effort to resolve all Critical and High items

### 8. Health Dashboard
- Generate a single-page health report with a score per category using A-F grading:
  - **A**: Excellent (top 10% of projects)
  - **B**: Good (minor issues, well-maintained)
  - **C**: Adequate (noticeable issues, needs attention)
  - **D**: Poor (significant issues affecting development velocity)
  - **F**: Failing (critical issues requiring immediate intervention)
- Calculate an overall health score as a weighted average (security weighted 2x, tests weighted 1.5x)
- Include trend indicators if previous audits exist (improving, stable, degrading)
- List the top 5 actionable items that would most improve the overall score
- Provide benchmark comparisons where possible (industry standards, team norms)

## Checklist
- [ ] Static analysis run with all issues categorized and counted
- [ ] Security scan completed with no unacknowledged Critical findings
- [ ] All dependencies audited for vulnerabilities, staleness, and license compatibility
- [ ] Test health assessed with coverage numbers and anti-pattern inventory
- [ ] Build pipeline verified as functional with measured build times
- [ ] Documentation completeness evaluated across README, API docs, and runbooks
- [ ] All findings triaged by severity (Critical / High / Medium / Low)
- [ ] Health dashboard generated with A-F grades per category and overall score
- [ ] Top 5 improvement actions identified and prioritized
- [ ] Report is shareable with both technical and non-technical stakeholders
