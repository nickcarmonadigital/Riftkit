---
name: Release Signing
description: Cryptographic signing of release artifacts including Docker images, npm packages, and GitHub Releases via Sigstore
---

# Release Signing Skill

**Purpose**: Establish cryptographic provenance for every release artifact by signing Docker images with cosign, npm packages with provenance attestations, and GitHub Releases with Sigstore. This ensures consumers can verify that artifacts originated from your CI pipeline and have not been tampered with, which is increasingly required for supply chain security compliance.

## TRIGGER COMMANDS

```text
"Sign release artifacts"
"Add npm provenance"
"Container signing setup"
"Set up Sigstore signing"
"Using release_signing skill: sign [artifact type]"
```

## When to Use
- When publishing Docker images to public or private registries
- When publishing npm packages (public or private)
- When creating GitHub Releases with downloadable binaries
- When compliance requires artifact provenance (SLSA, SOC2, FedRAMP)
- When onboarding enterprise customers who require signed artifacts

---

## PROCESS

### Step 1: Understand the Signing Landscape

| Artifact Type | Signing Tool | Identity Source | Verification Command |
|---------------|-------------|-----------------|---------------------|
| Docker images | cosign (keyless) | GitHub OIDC | `cosign verify` |
| npm packages | npm provenance | GitHub OIDC | `npm audit signatures` |
| GitHub Release binaries | cosign blob-sign | GitHub OIDC | `cosign verify-blob` |
| SBOM attachments | cosign attest | GitHub OIDC | `cosign verify-attestation` |

Keyless signing via Sigstore eliminates key management. The signing identity is your GitHub Actions workflow, verified through OIDC tokens.

### Step 2: Docker Image Signing with Cosign

```yaml
# .github/workflows/release-container.yml
name: Build, Sign & Push Container

on:
  push:
    tags: ['v*']

permissions:
  contents: read
  packages: write
  id-token: write  # Required for keyless signing

jobs:
  build-sign-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install cosign
        uses: sigstore/cosign-installer@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha

      - name: Build and push
        id: build
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}

      - name: Sign the image (keyless)
        run: |
          cosign sign --yes \
            ghcr.io/${{ github.repository }}@${{ steps.build.outputs.digest }}

      - name: Attach SBOM attestation
        run: |
          # Generate SBOM
          syft ghcr.io/${{ github.repository }}@${{ steps.build.outputs.digest }} \
            -o cyclonedx-json > sbom.cdx.json

          # Attach as attestation
          cosign attest --yes \
            --predicate sbom.cdx.json \
            --type cyclonedx \
            ghcr.io/${{ github.repository }}@${{ steps.build.outputs.digest }}
```

Consumers verify with:

```bash
# Verify image signature
cosign verify ghcr.io/your-org/your-app:v1.0.0 \
  --certificate-identity-regexp="https://github.com/your-org/your-app" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"

# Verify SBOM attestation
cosign verify-attestation ghcr.io/your-org/your-app:v1.0.0 \
  --type cyclonedx \
  --certificate-identity-regexp="https://github.com/your-org/your-app" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"
```

### Step 3: npm Provenance

npm provenance is built into npm v9.5+ and requires minimal configuration:

```yaml
# .github/workflows/release-npm.yml
name: Publish npm Package

on:
  push:
    tags: ['v*']

permissions:
  contents: read
  id-token: write  # Required for provenance

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          registry-url: 'https://registry.npmjs.org'

      - run: npm ci

      - run: npm publish --provenance --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

Consumers verify with:

```bash
npm audit signatures
# Output: "audited 1 package ... 1 package has a verified registry signature"
```

### Step 4: GitHub Release Binary Signing

```yaml
# .github/workflows/release-binaries.yml
name: Release Binaries

on:
  push:
    tags: ['v*']

permissions:
  contents: write
  id-token: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install cosign
        uses: sigstore/cosign-installer@v3

      - name: Build binaries
        run: |
          # Example: build for multiple platforms
          GOOS=linux GOARCH=amd64 go build -o dist/app-linux-amd64
          GOOS=darwin GOARCH=arm64 go build -o dist/app-darwin-arm64

      - name: Generate checksums
        run: |
          cd dist
          sha256sum * > checksums.txt

      - name: Sign checksums file
        run: cosign sign-blob --yes dist/checksums.txt --output-signature dist/checksums.txt.sig --output-certificate dist/checksums.txt.cert

      - name: Create GitHub Release
        run: |
          gh release create ${{ github.ref_name }} \
            dist/app-linux-amd64 \
            dist/app-darwin-arm64 \
            dist/checksums.txt \
            dist/checksums.txt.sig \
            dist/checksums.txt.cert \
            --title "${{ github.ref_name }}" \
            --generate-notes
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Consumers verify with:

```bash
cosign verify-blob checksums.txt \
  --signature checksums.txt.sig \
  --certificate checksums.txt.cert \
  --certificate-identity-regexp="https://github.com/your-org/your-app" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com"

sha256sum --check checksums.txt
```

### Step 5: SLSA Provenance (Level 3)

For maximum supply chain trust, add SLSA provenance generation:

```yaml
      - name: Generate SLSA provenance
        uses: slsa-framework/slsa-github-generator/.github/workflows/generator_generic_slsa3.yml@v2.0.0
        with:
          base64-subjects: |
            $(sha256sum dist/* | base64 -w0)
```

---

## CHECKLIST

- [ ] `id-token: write` permission set in all signing workflows
- [ ] Docker images signed with cosign keyless (Sigstore) on every tagged release
- [ ] SBOM generated (CycloneDX or SPDX) and attached as attestation to images
- [ ] npm packages published with `--provenance` flag
- [ ] GitHub Release binaries include checksums.txt with cosign signature
- [ ] Verification commands documented in project README or SECURITY.md
- [ ] CI/CD pipeline does not store or manage signing keys (keyless only)
- [ ] Container registry supports OCI signatures (GHCR, Docker Hub, ECR)
- [ ] Signing workflow only triggers on tag pushes (not branches)
- [ ] SLSA provenance generation enabled for compliance-critical projects

---

*Skill Version: 1.0 | Created: February 2026*
