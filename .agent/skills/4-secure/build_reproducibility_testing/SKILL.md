---
name: Build Reproducibility Testing
description: Deterministic build validation, artifact hash comparison, hermetic build verification, and SLSA L3 requirements
---

# Build Reproducibility Testing Skill

**Purpose**: Verify that builds are deterministic and reproducible -- the same source code, build environment, and configuration always produce bit-for-bit identical artifacts. This skill validates hermetic build environments, lockfile integrity, Docker build reproducibility, and SLSA Level 3 build requirements to ensure supply chain integrity and auditability.

## TRIGGER COMMANDS

```text
"Reproducible build check"
"Build determinism test"
"Verify build reproducibility"
"SLSA build requirements"
"Hermetic build validation"
```

## When to Use
- Validating that CI/CD produces identical artifacts from the same commit
- Preparing for SLSA Level 3 compliance
- Investigating build drift (artifacts differ across environments)
- Auditing Docker builds for non-determinism (floating tags, unsorted layers)
- Verifying lockfile integrity after dependency changes
- Setting up hermetic build environments that block network access during build

---

## PROCESS

### Step 1: Deterministic Build Validation

Run the same build twice from the same source and compare outputs.

**Basic hash comparison:**

```bash
# Clean build environment
rm -rf dist/ build/ out/

# Build #1
npm run build
sha256sum dist/**/* > /tmp/build1-hashes.txt

# Clean and rebuild
rm -rf dist/ build/ out/
npm run build
sha256sum dist/**/* > /tmp/build2-hashes.txt

# Compare -- any diff means non-deterministic build
diff /tmp/build1-hashes.txt /tmp/build2-hashes.txt
```

**Go projects (built-in reproducibility support):**

```bash
# Go builds are reproducible by default with -trimpath
go build -trimpath -o /tmp/binary1 ./cmd/server
go build -trimpath -o /tmp/binary2 ./cmd/server
sha256sum /tmp/binary1 /tmp/binary2

# Verify with diffoscope for detailed binary diff
diffoscope /tmp/binary1 /tmp/binary2
```

**Rust projects:**

```bash
# Set SOURCE_DATE_EPOCH for timestamp reproducibility
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
cargo build --release --locked
cp target/release/myapp /tmp/build1

cargo clean
cargo build --release --locked
cp target/release/myapp /tmp/build2

sha256sum /tmp/build1 /tmp/build2
```

**CI Workflow for Reproducibility Verification (`.github/workflows/reproducibility.yml`):**

```yaml
name: Build Reproducibility Check
on:
  push:
    branches: [main]
  schedule:
    - cron: '0 4 * * 3'  # Weekly Wednesday 4am

jobs:
  reproducibility:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build attempt 1
        run: |
          npm ci
          npm run build
          find dist -type f -exec sha256sum {} \; | sort > /tmp/build1.txt

      - name: Clean
        run: rm -rf dist/ node_modules/

      - name: Build attempt 2
        run: |
          npm ci
          npm run build
          find dist -type f -exec sha256sum {} \; | sort > /tmp/build2.txt

      - name: Compare builds
        run: |
          if diff /tmp/build1.txt /tmp/build2.txt; then
            echo "PASS: Builds are reproducible"
          else
            echo "FAIL: Builds differ"
            diff /tmp/build1.txt /tmp/build2.txt
            exit 1
          fi
```

### Step 2: Common Sources of Non-Determinism

Identify and eliminate these common causes of build drift:

| Source | Problem | Fix |
|--------|---------|-----|
| Timestamps in artifacts | Build time embedded in output | Set `SOURCE_DATE_EPOCH` from git commit |
| File ordering | `readdir` order varies by filesystem | Sort file lists explicitly |
| Floating dependency versions | `^1.2.3` resolves differently over time | Commit lockfiles, use `npm ci` |
| Embedded paths | Absolute build paths in binaries | Use `-trimpath` (Go), strip paths |
| Non-deterministic minifiers | UglifyJS/Terser output varies | Pin minifier version, set fixed seed |
| Docker `apt-get install` | Package versions float | Pin versions: `curl=7.88.1-10+deb12u5` |
| Docker `COPY . .` ordering | Layer hash depends on file metadata | Use `.dockerignore`, explicit COPY |
| Timezone differences | Time-dependent code paths | Force `TZ=UTC` in build |

**Fix timestamps globally:**

```bash
# Set SOURCE_DATE_EPOCH to last git commit timestamp
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)

# For Node.js builds
export NODE_OPTIONS="--no-warnings"

# For Python builds (setuptools)
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
python -m build
```

### Step 3: Hermetic Build Environment Verification

A hermetic build blocks all network access during the build step. Only pre-fetched dependencies are available.

**Docker-based hermetic build:**

```dockerfile
# Stage 1: Fetch dependencies (network allowed)
FROM node:20-slim AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

# Stage 2: Build (no network)
FROM node:20-slim AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Network disabled via Docker build --network=none
RUN npm run build
```

```bash
# Build with network disabled in build stage
docker build --network=none --target=build -t myapp-hermetic .

# If build succeeds with --network=none, it is hermetic
echo "PASS: Build is hermetic (no network access needed)"
```

**Bazel hermetic builds:**

```python
# WORKSPACE.bazel -- all external deps declared upfront
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_nodejs",
    sha256 = "abc123...",  # Pinned hash
    urls = ["https://github.com/aspect-build/rules_js/releases/..."],
)
```

**Verify no network calls during build:**

```bash
# Use strace to detect network syscalls during build
strace -f -e trace=network -o /tmp/build-network.log npm run build

# Check for connect() calls (indicates network access)
grep -c "connect(" /tmp/build-network.log
# Should be 0 for a hermetic build
```

### Step 4: Lockfile Integrity Verification

```bash
# Node.js -- verify lockfile is in sync
npm ci  # Fails if lockfile doesn't match package.json

# Verify lockfile is committed
git ls-files --error-unmatch package-lock.json

# Detect lockfile tampering (compare hash)
sha256sum package-lock.json > lockfile-hash.txt
git diff --exit-code lockfile-hash.txt

# Go -- verify go.sum integrity
go mod verify
# Output: "all modules verified" if clean

# Rust -- verify Cargo.lock
cargo update --dry-run  # Shows what WOULD change
cargo build --locked     # Fails if Cargo.lock is stale

# Python -- verify pip freeze matches requirements
pip install -r requirements.txt
pip freeze > /tmp/actual.txt
diff <(sort requirements.txt) <(sort /tmp/actual.txt)
```

### Step 5: Reproducible Docker Builds

```dockerfile
# Pin base image by digest, NOT tag
FROM node:20.11.1-slim@sha256:abc123def456...

# Pin package versions explicitly
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl=7.88.1-10+deb12u5 \
    && rm -rf /var/lib/apt/lists/*

# Set SOURCE_DATE_EPOCH for reproducible timestamps
ARG SOURCE_DATE_EPOCH
ENV SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}

# Use deterministic file ordering
COPY --chown=node:node package.json package-lock.json ./
RUN npm ci --ignore-scripts

COPY --chown=node:node . .
RUN npm run build
```

```bash
# Build with BuildKit reproducible output
DOCKER_BUILDKIT=1 docker build \
  --build-arg SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct) \
  -t myapp:$(git rev-parse --short HEAD) .

# Compare image digests across builds
docker inspect --format='{{.Id}}' myapp:abc123
```

### Step 6: SLSA Level 3 Build Requirements Checklist

SLSA (Supply-chain Levels for Software Artifacts) Level 3 requires:

| Requirement | Description | How to Verify |
|-------------|-------------|---------------|
| Build as code | Build definition is version-controlled | `.github/workflows/` in git |
| Ephemeral environment | Build runs in a fresh environment each time | GitHub Actions runners, no self-hosted cache reuse |
| Isolated build | Build cannot be influenced by other builds | `--network=none`, no shared volumes |
| Parameterless | Build is fully determined by source + config | No manual env vars injected at build time |
| Hermetic | No network access during build | Docker `--network=none` or Bazel sandbox |
| Reproducible | Same source produces same artifact | Hash comparison passes (Step 1) |
| Provenance generated | Attestation of who/what/where/when | SLSA GitHub Generator or in-toto |

**Generate SLSA provenance with GitHub Actions:**

```yaml
# In release workflow
- uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v2.0.0
  with:
    base64-subjects: "${{ needs.build.outputs.artifacts-sha256 }}"
```

---

## CHECKLIST

- [ ] Same source produces identical artifact hashes across two consecutive builds
- [ ] `SOURCE_DATE_EPOCH` set from git commit timestamp in CI
- [ ] All lockfiles committed to version control (package-lock.json, go.sum, Cargo.lock)
- [ ] CI uses `npm ci` / `cargo build --locked` / `go build` (not install commands)
- [ ] Docker base images pinned by digest, not tag
- [ ] Docker package installs use explicit version pinning
- [ ] Hermetic build verified (build succeeds with `--network=none`)
- [ ] No floating dependency versions in build configuration
- [ ] `diffoscope` or hash comparison runs in CI on release branches
- [ ] SLSA Level 3 requirements reviewed and gaps documented
- [ ] Build provenance attestation generated for release artifacts
- [ ] File ordering is deterministic (sorted) in all build steps

## OUTPUT: Build Reproducibility Report

```markdown
## Build Reproducibility Report
**Project**: [name]
**Commit**: [sha]
**Date**: [date]

### Determinism Test
- Build 1 hash: [sha256]
- Build 2 hash: [sha256]
- Match: YES/NO

### Hermetic Build
- Network blocked during build: YES/NO
- Build succeeded without network: YES/NO

### Lockfile Integrity
- Lockfile committed: YES/NO
- Lockfile in sync: YES/NO
- Lockfile hash: [sha256]

### Docker Reproducibility
- Base image pinned by digest: YES/NO
- Package versions pinned: YES/NO
- SOURCE_DATE_EPOCH set: YES/NO

### SLSA Level 3 Compliance
- [x/7] requirements met
- Gaps: [list]
```

*Skill Version: 1.0 | Created: March 2026*
