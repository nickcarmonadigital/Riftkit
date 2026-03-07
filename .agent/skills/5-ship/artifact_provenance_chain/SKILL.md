---
name: Artifact Provenance Chain
description: SLSA provenance attestation, Sigstore/cosign signing, SBOM generation, and supply chain trust verification
---

# Artifact Provenance Chain Skill

**Purpose**: Establish a cryptographically verifiable chain of trust from source code to deployed artifact. This skill covers SLSA provenance attestation generation, Sigstore/cosign signing workflows, SBOM generation and attachment, container image signing, package signing, and supply chain trust chain visualization. Every artifact shipped to production should carry proof of its origin, build process, and integrity.

## TRIGGER COMMANDS

```text
"Sign artifact"
"Generate provenance"
"SBOM generation"
"Cosign sign image"
"Artifact attestation"
"Supply chain provenance"
```

## When to Use
- Shipping container images that need cryptographic signing
- Generating SLSA provenance attestations for release artifacts
- Creating and attaching SBOMs to releases (customer/compliance requirement)
- Setting up Sigstore keyless signing in CI/CD
- Publishing npm/PyPI packages with signing
- Building a complete trust chain from commit to deployment
- Preparing for SLSA Level 2/3 compliance

---

## PROCESS

### Step 1: SLSA Provenance Attestation Generation

SLSA provenance records WHO built the artifact, WHAT source it came from, HOW it was built, and WHEN.

**GitHub Actions -- SLSA Generic Generator:**

```yaml
name: Release with SLSA Provenance
on:
  push:
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      artifacts-sha256: ${{ steps.hash.outputs.sha256 }}
    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: npm ci && npm run build

      - name: Package artifact
        run: tar -czf myapp-${{ github.ref_name }}.tar.gz dist/

      - name: Generate hash
        id: hash
        run: |
          sha256=$(sha256sum myapp-${{ github.ref_name }}.tar.gz | base64 -w0)
          echo "sha256=$sha256" >> "$GITHUB_OUTPUT"

      - uses: actions/upload-artifact@v4
        with:
          name: release-artifact
          path: myapp-${{ github.ref_name }}.tar.gz

  provenance:
    needs: [build]
    permissions:
      actions: read
      id-token: write
      contents: write
    uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v2.0.0
    with:
      base64-subjects: "${{ needs.build.outputs.artifacts-sha256 }}"
      upload-assets: true
```

**Verify SLSA provenance locally:**

```bash
# Install SLSA verifier
go install github.com/slsa-framework/slsa-verifier/v2/cli/slsa-verifier@latest

# Verify artifact provenance
slsa-verifier verify-artifact myapp-v1.0.0.tar.gz \
  --provenance-path myapp-v1.0.0.tar.gz.intoto.jsonl \
  --source-uri github.com/myorg/myapp \
  --source-tag v1.0.0
```

### Step 2: Sigstore/Cosign Signing Workflow

Sigstore provides keyless signing -- no long-lived keys to manage. Identity comes from OIDC (GitHub Actions, Google, Microsoft).

**Install cosign:**

```bash
# Install cosign
go install github.com/sigstore/cosign/v2/cmd/cosign@latest

# Or via package manager
brew install cosign        # macOS
apt-get install cosign     # Debian/Ubuntu
```

**Keyless signing (CI/CD -- recommended):**

```bash
# Sign a container image (keyless, uses OIDC identity)
cosign sign --yes ghcr.io/myorg/myapp@sha256:abc123...

# Sign with annotations
cosign sign --yes \
  -a "repo=myorg/myapp" \
  -a "workflow=release" \
  -a "ref=$GITHUB_REF" \
  ghcr.io/myorg/myapp@sha256:abc123...

# Verify signature
cosign verify \
  --certificate-identity-regexp="https://github.com/myorg/myapp/.github/workflows/*" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/myorg/myapp@sha256:abc123...
```

**Key-based signing (air-gapped environments):**

```bash
# Generate keypair
cosign generate-key-pair
# Creates cosign.key (private) and cosign.pub (public)

# Sign with key
cosign sign --key cosign.key ghcr.io/myorg/myapp@sha256:abc123...

# Verify with public key
cosign verify --key cosign.pub ghcr.io/myorg/myapp@sha256:abc123...
```

**GitHub Actions cosign integration:**

```yaml
- name: Install cosign
  uses: sigstore/cosign-installer@v3

- name: Sign container image
  env:
    COSIGN_EXPERIMENTAL: "true"
  run: |
    cosign sign --yes \
      ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
```

### Step 3: SBOM Generation and Attachment

Generate Software Bill of Materials in industry-standard formats.

**CycloneDX SBOM:**

```bash
# Node.js
npx @cyclonedx/cyclonedx-npm --output-file sbom-cyclonedx.json --spec-version 1.5

# Python
pip install cyclonedx-bom
cyclonedx-py environment --output-format json --outfile sbom-cyclonedx.json

# Go
go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@latest
cyclonedx-gomod mod -json -output sbom-cyclonedx.json

# Container image (Trivy)
trivy image --format cyclonedx --output sbom-cyclonedx.json myapp:latest
```

**SPDX SBOM:**

```bash
# Container image via Trivy
trivy image --format spdx-json --output sbom-spdx.json myapp:latest

# Source code via Syft
syft dir:. -o spdx-json=sbom-spdx.json
```

**Attach SBOM to container image (cosign):**

```bash
# Attach CycloneDX SBOM as attestation
cosign attest --yes \
  --predicate sbom-cyclonedx.json \
  --type cyclonedx \
  ghcr.io/myorg/myapp@sha256:abc123...

# Verify SBOM attestation
cosign verify-attestation \
  --type cyclonedx \
  --certificate-identity-regexp="https://github.com/myorg/myapp/*" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/myorg/myapp@sha256:abc123...
```

**Attach SBOM to GitHub Release:**

```yaml
- name: Generate SBOM
  run: |
    npx @cyclonedx/cyclonedx-npm --output-file sbom-cyclonedx.json
    trivy fs --format spdx-json --output sbom-spdx.json .

- name: Upload to Release
  uses: softprops/action-gh-release@v2
  with:
    files: |
      sbom-cyclonedx.json
      sbom-spdx.json
```

### Step 4: Provenance Verification in Deployment Pipeline

Block deployments that lack valid provenance or signatures.

**Kubernetes admission controller (Sigstore Policy Controller):**

```yaml
# Install policy-controller
helm repo add sigstore https://sigstore.github.io/helm-charts
helm install policy-controller sigstore/policy-controller \
  -n cosign-system --create-namespace

# ClusterImagePolicy -- require signatures
apiVersion: policy.sigstore.dev/v1beta1
kind: ClusterImagePolicy
metadata:
  name: require-signed-images
spec:
  images:
    - glob: "ghcr.io/myorg/**"
  authorities:
    - keyless:
        identities:
          - issuer: https://token.actions.githubusercontent.com
            subjectRegExp: https://github.com/myorg/.*/.github/workflows/.*
```

**Pre-deployment verification script:**

```bash
#!/bin/bash
set -euo pipefail

IMAGE="$1"

echo "Verifying signature..."
cosign verify \
  --certificate-identity-regexp="https://github.com/myorg/.*/\.github/workflows/.*" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  "$IMAGE" || { echo "FAIL: Signature verification failed"; exit 1; }

echo "Verifying SBOM attestation..."
cosign verify-attestation --type cyclonedx \
  --certificate-identity-regexp="https://github.com/myorg/.*" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  "$IMAGE" || { echo "FAIL: SBOM attestation missing"; exit 1; }

echo "PASS: All provenance checks passed"
```

### Step 5: Container Image Signing and Verification

**Full container signing workflow in CI:**

```yaml
name: Build, Sign, and Push Container
on:
  push:
    tags: ['v*']

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-sign-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write  # Required for keyless signing

    steps:
      - uses: actions/checkout@v4
      - uses: sigstore/cosign-installer@v3
      - uses: docker/setup-buildx-action@v3

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        id: build
        uses: docker/build-push-action@v6
        with:
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.ref_name }}

      - name: Sign image
        run: cosign sign --yes ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}

      - name: Generate and attach SBOM
        run: |
          trivy image --format cyclonedx --output sbom.json \
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
          cosign attest --yes --predicate sbom.json --type cyclonedx \
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}@${{ steps.build.outputs.digest }}
```

### Step 6: npm/PyPI Package Signing

**npm provenance (built-in since npm 9.5+):**

```yaml
# In GitHub Actions
- name: Publish with provenance
  run: npm publish --provenance --access public
  env:
    NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

**PyPI trusted publishing (keyless via OIDC):**

```yaml
# .github/workflows/publish.yml
jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write  # Required for trusted publishing
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Build
        run: python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        # No password needed -- uses OIDC trusted publishing
```

### Step 7: GitHub Actions Artifact Attestation

```yaml
# Built-in GitHub artifact attestation (GA since 2024)
- name: Generate artifact attestation
  uses: actions/attest-build-provenance@v1
  with:
    subject-path: dist/myapp-${{ github.ref_name }}.tar.gz

# Verify locally
gh attestation verify myapp-v1.0.0.tar.gz --repo myorg/myapp
```

### Step 8: Supply Chain Trust Chain Visualization

Document the complete chain of trust from source to deployment:

```
Source Code (Git)
    |
    v  [git commit signed with GPG/SSH key]
CI Build (GitHub Actions)
    |
    v  [SLSA provenance generated, build logs retained]
Artifact (Container Image / Binary / Package)
    |
    v  [cosign signature + SBOM attestation attached]
Registry (GHCR / npm / PyPI)
    |
    v  [signature verified by admission controller]
Deployment (Kubernetes / Server)
    |
    v  [runtime verification via policy controller]
Production
```

**Trust chain audit query:**

```bash
# 1. Verify git commit signature
git verify-commit HEAD

# 2. Check SLSA provenance
slsa-verifier verify-artifact artifact.tar.gz \
  --provenance-path artifact.intoto.jsonl \
  --source-uri github.com/myorg/myapp

# 3. Verify container signature
cosign verify --certificate-identity-regexp="..." image@digest

# 4. Verify SBOM attestation
cosign verify-attestation --type cyclonedx image@digest

# 5. Check deployment policy
kubectl get clusterimagepolicy -o yaml
```

---

## CHECKLIST

- [ ] SLSA provenance attestation generated for all release artifacts
- [ ] Cosign keyless signing configured in CI (OIDC-based, no long-lived keys)
- [ ] Container images signed at push time (by digest, not tag)
- [ ] CycloneDX SBOM generated and attached to container images as attestation
- [ ] SPDX SBOM generated for compliance (attached to GitHub Releases)
- [ ] npm packages published with `--provenance` flag
- [ ] PyPI packages use trusted publishing (OIDC, no API tokens)
- [ ] Kubernetes admission controller blocks unsigned images
- [ ] Pre-deployment verification script validates signature + SBOM before deploy
- [ ] GitHub artifact attestation enabled for binary releases
- [ ] Git commits signed (GPG or SSH signing)
- [ ] Trust chain documented from source to production
- [ ] SLSA verifier runs in deployment pipeline
- [ ] Provenance verification failures block deployment (not just warn)

## OUTPUT: Artifact Provenance Verification Checklist

```markdown
## Artifact Provenance Report
**Artifact**: [name]
**Version**: [version]
**Digest**: [sha256]

### Provenance Chain
| Step | Status | Evidence |
|------|--------|----------|
| Git commit signed | YES/NO | GPG key / SSH signature |
| SLSA provenance | YES/NO | .intoto.jsonl attached |
| Cosign signature | YES/NO | Rekor transparency log entry |
| SBOM (CycloneDX) | YES/NO | Attestation on registry |
| SBOM (SPDX) | YES/NO | Attached to GitHub Release |
| Deployment verified | YES/NO | Policy controller enforced |

### Verification Commands
cosign verify --certificate-identity-regexp="..." [image]
slsa-verifier verify-artifact [artifact] --provenance-path [provenance]
gh attestation verify [artifact] --repo [repo]
```

*Skill Version: 1.0 | Created: March 2026*
