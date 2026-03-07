---
description: Cut a release with version bump, changelog generation, artifact signing, and approval gate verification.
---

# Release Command

Manages the full release lifecycle from version bump through signing and approval.

## Instructions

Execute release steps in order:

1. **Pre-Release Validation**
   - Ensure working tree is clean (no uncommitted changes)
   - Verify current branch is main/release branch
   - Run build and test suite (block on failures)
   - Check that all required approvals are in place

2. **Version Bump**
   - Determine version increment: patch (0.0.X), minor (0.X.0), or major (X.0.0)
   - Update version in package.json, pyproject.toml, or equivalent
   - If `--prerelease`, append pre-release suffix (e.g., 1.2.0-rc.1)

3. **Changelog Generation**
   - Collect commits since last release tag
   - Group by type: Features, Bug Fixes, Breaking Changes, Other
   - Generate human-readable changelog entry
   - Prepend to CHANGELOG.md (create if missing)
   - Highlight breaking changes prominently

4. **Artifact Signing** (if `--sign`)
   - Sign release commit with GPG key
   - Generate checksums for build artifacts
   - Create signed git tag

5. **Release Commit and Tag**
   - Create release commit: "release: vX.Y.Z"
   - Create annotated git tag: vX.Y.Z
   - Present summary and WAIT for confirmation before pushing

6. **Approval Gate Check**
   - Verify CI pipeline passed on release commit
   - Check required reviewer approvals
   - Validate compliance sign-offs if configured

## Output

```
RELEASE: vX.Y.Z [READY/BLOCKED]

Version:     X.Y.Z (was: A.B.C)
Type:        [patch/minor/major]
Commits:     X commits since last release
Breaking:    [none/X breaking changes]
Changelog:   [generated/updated]
Signed:      [yes/no]
Tag:         vX.Y.Z [created/pending]
Approvals:   [X/Y required]

Action: Push release? (confirm to push tag + commit)
```

## Arguments

$ARGUMENTS can be:
- `patch` - Patch version bump (default)
- `minor` - Minor version bump
- `major` - Major version bump
- `--prerelease` - Add pre-release suffix (rc.1, beta.1)
- `--sign` - GPG sign the release commit and tag
- `--dry-run` - Preview release without making changes
- `--no-changelog` - Skip changelog generation

## Example Usage

```
/release patch
/release minor --sign
/release major --dry-run
/release minor --prerelease
```

## Mapped Skills

- `release_signing` - GPG signing and artifact verification
- `change_management` - Release process governance
- `code_changelog` - Automated changelog generation
- `deployment_approval_gates` - Approval workflow validation

## Related Commands

- `/deploy` - Deploy the released version
- `/verify` - Run pre-release checks
- `/code-review` - Review changes before release
