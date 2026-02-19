---
name: git_workflow
description: Professional Git workflows including branching, commits, PRs, and recovery
---

# Git Workflow Skill

**Purpose**: Standardize Git practices for professional development — from branch naming to PR workflow to recovering from mistakes.

## 🎯 TRIGGER COMMANDS

```text
"Set up Git workflow for this project"
"How should I name my branches?"
"Help me write a commit message"
"Fix a Git mistake"
"Create a PR"
"Resolve merge conflicts"
"Using git_workflow skill"
```

## When to Use

- Setting up Git conventions for a new project
- Creating feature branches and PRs
- Writing commit messages
- Resolving merge conflicts
- Recovering from Git mistakes (wrong branch, bad commit, lost work)

---

## PART 1: BRANCH NAMING

### Convention

```
<type>/<ticket>-<short-description>

feature/JIRA-123-user-dashboard
fix/JIRA-456-login-timeout
hotfix/JIRA-789-payment-crash
chore/JIRA-101-update-deps
refactor/JIRA-202-auth-module
```

### Types

| Prefix | When to Use |
|--------|------------|
| `feature/` | New functionality |
| `fix/` | Bug fix |
| `hotfix/` | Urgent production fix (branch from `main`) |
| `chore/` | Dependencies, configs, non-code changes |
| `refactor/` | Code restructuring (no behavior change) |
| `docs/` | Documentation only |
| `test/` | Adding or fixing tests |

---

## PART 2: CONVENTIONAL COMMITS

### Format

```
<type>(<scope>): <description>

feat(auth): add refresh token rotation
fix(dashboard): correct chart timezone display
chore(deps): update prisma to v5.10
refactor(users): extract email service from user service
docs(api): add swagger decorations to user controller
test(auth): add login integration tests
perf(queries): add index on projects.userId
ci(actions): add Playwright E2E to CI pipeline
```

### Types

| Type | When | Semver |
|------|------|--------|
| `feat` | New feature | MINOR |
| `fix` | Bug fix | PATCH |
| `chore` | Maintenance, deps | — |
| `refactor` | Restructure, no behavior change | — |
| `docs` | Documentation | — |
| `test` | Tests | — |
| `perf` | Performance improvement | PATCH |
| `ci` | CI/CD changes | — |
| `style` | Formatting, whitespace | — |

### Breaking Changes

```
feat(api)!: change user response format

BREAKING CHANGE: The /api/users endpoint now returns { data: User[] }
instead of User[]. All API consumers must update.
```

---

## PART 3: PR WORKFLOW

### Creating a PR

```bash
# 1. Create branch from up-to-date main
git checkout main && git pull
git checkout -b feature/JIRA-123-user-dashboard

# 2. Make commits (small, focused)
git add src/dashboard/
git commit -m "feat(dashboard): add usage chart component"

git add src/dashboard/
git commit -m "feat(dashboard): add date filter for charts"

# 3. Push branch
git push -u origin feature/JIRA-123-user-dashboard

# 4. Create PR (GitHub CLI)
gh pr create --title "feat: add user dashboard analytics" --body "..."
```

### PR Description Template

```markdown
## What
Add user dashboard with usage analytics charts.

## Why
Users need to track their API usage and storage consumption.
Resolves JIRA-123.

## How
- Added DashboardService with aggregation queries
- Created Chart components using Recharts
- Added date range filter with URL state persistence

## Testing
- [ ] Unit tests for DashboardService (5 tests)
- [ ] E2E test for dashboard page load
- [ ] Manual testing with different date ranges

## Screenshots
[Before/After screenshots for UI changes]
```

### PR Size Guidelines

| Size | Lines Changed | Review Time | Quality |
|------|--------------|-------------|---------|
| Small | < 200 | 15 min | Best — easy to review thoroughly |
| Medium | 200-400 | 30-60 min | Good — still reviewable |
| Large | 400-800 | 1-2 hours | Risky — consider splitting |
| Huge | 800+ | Hours | BAD — split into smaller PRs |

---

## PART 4: REBASING VS MERGING

### When to Rebase

```bash
# Update your feature branch with latest main
git checkout feature/my-feature
git fetch origin
git rebase origin/main

# If conflicts occur during rebase:
# 1. Fix conflicts in files
# 2. git add <fixed-files>
# 3. git rebase --continue
# 4. Repeat until done

# Force push (safe — it's YOUR branch)
git push --force-with-lease
```

### When to Merge

```bash
# Merge main into your branch (creates merge commit)
git checkout feature/my-feature
git merge origin/main
```

| | Rebase | Merge |
|---|--------|-------|
| History | Clean, linear | Preserves branch history |
| Use when | Updating your feature branch | Merging feature into main |
| Conflicts | Resolve per-commit | Resolve once |
| Force push | Required after rebase | Not needed |

**Rule**: Rebase your branch onto main. Merge your branch into main (via PR).

---

## PART 5: CONFLICT RESOLUTION

```
<<<<<<< HEAD (your changes)
const greeting = 'Hello, World!';
=======
const greeting = 'Hi there!';
>>>>>>> feature/other-branch (their changes)
```

Steps:
1. Open the file with conflicts
2. Decide which change to keep (or combine both)
3. Remove the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Test the merged result
5. `git add <file>` and continue (`git rebase --continue` or `git merge --continue`)

---

## PART 6: GIT STASH

```bash
# Save current changes temporarily
git stash                           # Stash tracked changes
git stash -u                        # Include untracked files
git stash save "work in progress"   # Named stash

# List stashes
git stash list
# stash@{0}: On feature/x: work in progress
# stash@{1}: WIP on main

# Restore stashed changes
git stash pop                       # Apply and remove from stash
git stash apply stash@{1}           # Apply specific stash (keep in list)

# Delete stash
git stash drop stash@{0}            # Remove specific stash
git stash clear                     # Remove ALL stashes
```

---

## PART 7: GIT BISECT

Find the exact commit that introduced a bug:

```bash
git bisect start
git bisect bad                      # Current commit is broken
git bisect good v1.0.0              # This tag/commit was working

# Git checks out a middle commit
# Test if the bug exists, then:
git bisect good                     # Bug not present here
# or
git bisect bad                      # Bug IS present here

# Git narrows down, repeat until:
# "abc123 is the first bad commit"

git bisect reset                    # Return to original branch
```

---

## PART 8: HUSKY + LINT-STAGED

### Setup

```bash
# Install
npm install -D husky lint-staged @commitlint/cli @commitlint/config-conventional

# Initialize Husky
npx husky init

# Pre-commit hook (runs lint-staged)
echo "npx lint-staged" > .husky/pre-commit

# Commit message hook (validates format)
echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg
```

### Configuration

```json
// package.json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
};
```

---

## PART 9: RECOVERY SCENARIOS

### Undo Last Commit (Keep Changes)

```bash
git reset --soft HEAD~1     # Undo commit, keep files staged
git reset --mixed HEAD~1    # Undo commit, keep files unstaged (default)
git reset --hard HEAD~1     # Undo commit AND discard all changes (DANGEROUS)
```

### Recover Deleted Branch

```bash
git reflog                  # Find the commit hash of deleted branch
git checkout -b recovered-branch abc123  # Recreate branch at that commit
```

### Cherry-Pick a Commit

```bash
git cherry-pick abc123      # Copy one commit to current branch
```

### Revert a Merge (Safe for Shared Branches)

```bash
git revert -m 1 <merge-commit-hash>   # Creates a new commit that undoes the merge
```

### Fix Last Commit Message

```bash
git commit --amend -m "fix: correct commit message"
# Only if you haven't pushed yet!
```

### Unstage Files

```bash
git reset HEAD file.ts      # Unstage specific file
git reset HEAD              # Unstage everything
```

---

## PART 10: .gitignore

```gitignore
# Dependencies
node_modules/

# Build output
dist/
build/
.next/

# Environment variables (NEVER commit)
.env
.env.local
.env.production

# IDE
.vscode/settings.json
.idea/

# OS
.DS_Store
Thumbs.db

# Prisma
prisma/*.db

# Logs
*.log
npm-debug.log*

# Test coverage
coverage/
```

---

## ✅ Exit Checklist

- [ ] Branch naming convention documented and followed
- [ ] Conventional Commits enforced (commitlint configured)
- [ ] PR template created with What/Why/How/Testing sections
- [ ] Husky + lint-staged configured
- [ ] .gitignore includes all necessary patterns
- [ ] Team knows the rebase vs merge convention
- [ ] CODEOWNERS file created (if applicable)
