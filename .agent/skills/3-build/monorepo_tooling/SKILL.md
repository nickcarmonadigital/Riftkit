---
name: Monorepo Tooling
description: Monorepo management with Nx, Turborepo, and Bazel covering task orchestration, affected detection, and caching
---

# Monorepo Tooling Skill

**Purpose**: Set up and manage monorepo builds with Nx, Turborepo, or Bazel, including task orchestration, incremental builds, affected-based testing, and remote caching.

---

## TRIGGER COMMANDS

```text
"Set up a monorepo"
"Configure Nx workspace"
"Set up Turborepo"
"Optimize monorepo build times"
"Using monorepo_tooling skill: [task]"
```

---

## Tool Comparison

| Feature | Nx | Turborepo | Bazel |
|---------|-----|-----------|-------|
| Language focus | JS/TS (polyglot via plugins) | JS/TS | Any language |
| Config format | nx.json + project.json | turbo.json | BUILD files |
| Task graph | Project + task graph | Task graph | Action graph |
| Affected detection | Git-based + dep graph | Git-based | Precise file-level |
| Remote cache | Nx Cloud (free tier) | Vercel Remote Cache | Remote Execution + Cache |
| Code generation | Built-in generators | None | Rules + macros |
| Dependency graph viz | Built-in (nx graph) | None built-in | query --output=graph |
| Learning curve | Moderate | Low | High |
| Best for | Full-stack JS/TS teams | Simple JS/TS monorepos | Large polyglot orgs |
| Startup overhead | Low | Very low | High (requires JDK) |

---

## Nx

### Workspace Setup

```bash
# Create new Nx workspace
npx create-nx-workspace@latest myorg --preset=ts
cd myorg

# Add plugins
npm install -D @nx/node @nx/react @nx/jest @nx/eslint

# Generate application
npx nx generate @nx/node:application api-server
npx nx generate @nx/react:application web-app

# Generate library
npx nx generate @nx/node:library shared-utils --directory=libs/shared-utils
npx nx generate @nx/node:library data-access --directory=libs/data-access
```

### Directory Structure

```
myorg/
  apps/
    api-server/
      src/
      project.json
      tsconfig.json
    web-app/
      src/
      project.json
      tsconfig.json
  libs/
    shared-utils/
      src/
      project.json
    data-access/
      src/
      project.json
  nx.json
  tsconfig.base.json
  package.json
```

### nx.json Configuration

```json
{
  "targetDefaults": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["production", "^production"],
      "cache": true
    },
    "test": {
      "inputs": ["default", "^production", "{workspaceRoot}/jest.preset.js"],
      "cache": true
    },
    "lint": {
      "inputs": ["default", "{workspaceRoot}/.eslintrc.json"],
      "cache": true
    }
  },
  "namedInputs": {
    "default": ["{projectRoot}/**/*", "sharedGlobals"],
    "production": [
      "default",
      "!{projectRoot}/**/*.spec.ts",
      "!{projectRoot}/tsconfig.spec.json",
      "!{projectRoot}/jest.config.ts"
    ],
    "sharedGlobals": ["{workspaceRoot}/tsconfig.base.json"]
  },
  "nxCloudAccessToken": "your-nx-cloud-token"
}
```

### project.json

```json
{
  "name": "api-server",
  "sourceRoot": "apps/api-server/src",
  "projectType": "application",
  "targets": {
    "build": {
      "executor": "@nx/node:build",
      "outputs": ["{options.outputPath}"],
      "options": {
        "outputPath": "dist/apps/api-server",
        "main": "apps/api-server/src/main.ts",
        "tsConfig": "apps/api-server/tsconfig.app.json"
      }
    },
    "serve": {
      "executor": "@nx/node:serve",
      "options": {
        "buildTarget": "api-server:build"
      }
    },
    "test": {
      "executor": "@nx/jest:jest",
      "options": {
        "jestConfig": "apps/api-server/jest.config.ts"
      }
    },
    "docker": {
      "executor": "nx:run-commands",
      "options": {
        "command": "docker build -f apps/api-server/Dockerfile -t api-server ."
      },
      "dependsOn": ["build"]
    }
  },
  "tags": ["scope:api", "type:app"]
}
```

### Nx Commands

```bash
# Run tasks
npx nx build api-server
npx nx test api-server
npx nx run-many -t build test lint          # Run multiple targets
npx nx run-many -t build --projects=tag:scope:api  # Filter by tag

# Affected (only changed projects)
npx nx affected -t build                    # Build affected projects
npx nx affected -t test --base=main         # Test against main branch
npx nx affected --graph                     # Visualize affected

# Dependency graph
npx nx graph                                # Interactive dep graph

# Cache
npx nx reset                                # Clear local cache
```

### Module Boundary Enforcement

```json
// .eslintrc.json (root)
{
  "rules": {
    "@nx/enforce-module-boundaries": [
      "error",
      {
        "enforceBuildableLibDependency": true,
        "allow": [],
        "depConstraints": [
          {
            "sourceTag": "type:app",
            "onlyDependOnLibsWithTags": ["type:lib", "type:util"]
          },
          {
            "sourceTag": "scope:api",
            "onlyDependOnLibsWithTags": ["scope:api", "scope:shared"]
          },
          {
            "sourceTag": "scope:web",
            "onlyDependOnLibsWithTags": ["scope:web", "scope:shared"]
          }
        ]
      }
    ]
  }
}
```

---

## Turborepo

### Setup

```bash
# Create new Turborepo
npx create-turbo@latest myorg
cd myorg

# Or add to existing monorepo
npm install turbo --save-dev
```

### Directory Structure

```
myorg/
  apps/
    web/
      package.json
    api/
      package.json
  packages/
    ui/
      package.json
    config-eslint/
      package.json
    config-typescript/
      package.json
  turbo.json
  package.json
```

### turbo.json Configuration

```json
{
  "$schema": "https://turbo.build/schema.json",
  "globalDependencies": ["**/.env.*local"],
  "globalEnv": ["NODE_ENV"],
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "tsconfig.json"],
      "outputs": ["dist/**", ".next/**"],
      "env": ["API_URL"]
    },
    "test": {
      "dependsOn": ["^build"],
      "inputs": ["src/**", "test/**"],
      "outputs": ["coverage/**"],
      "env": ["CI"]
    },
    "lint": {
      "inputs": ["src/**", ".eslintrc.js"],
      "outputs": []
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "deploy": {
      "dependsOn": ["build", "test", "lint"],
      "outputs": []
    }
  }
}
```

### Turborepo Commands

```bash
# Run tasks
turbo build                              # Build all packages
turbo test --filter=api                  # Test only api package
turbo build --filter=web...              # Build web and its dependencies
turbo build --filter=...[HEAD~1]         # Build changed since last commit
turbo lint --filter={./packages/*}       # Lint only packages/

# Remote caching
turbo login                              # Login to Vercel
turbo link                               # Link to remote cache

# Debugging
turbo build --graph                      # Output task graph as DOT
turbo build --dry-run=json               # Show what would run
turbo build --summarize                  # Execution summary
```

### Package Filtering Syntax

| Filter | Meaning |
|--------|---------|
| `--filter=web` | Only the web package |
| `--filter=web...` | web and all its dependencies |
| `--filter=...web` | web and all its dependents |
| `--filter=...[HEAD~1]` | Packages changed since last commit |
| `--filter={./apps/*}` | All packages in apps/ |
| `--filter=!web` | All packages except web |

---

## Bazel

### WORKSPACE Setup

```python
# WORKSPACE
workspace(name = "myorg")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "...",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.31.0/rules_python-0.31.0.tar.gz",
)

http_archive(
    name = "rules_go",
    sha256 = "...",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/v0.46.0/rules_go-v0.46.0.zip"],
)
```

### BUILD File

```python
# services/api/BUILD
load("@rules_go//go:def.bzl", "go_binary", "go_library", "go_test")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_push")

go_library(
    name = "api_lib",
    srcs = glob(["*.go"]),
    importpath = "myorg/services/api",
    deps = [
        "//libs/shared:shared_lib",
        "@com_github_gin_gonic_gin//:gin",
    ],
    visibility = ["//visibility:private"],
)

go_binary(
    name = "api",
    embed = [":api_lib"],
    visibility = ["//visibility:public"],
)

go_test(
    name = "api_test",
    srcs = glob(["*_test.go"]),
    embed = [":api_lib"],
)

oci_image(
    name = "api_image",
    base = "@distroless_base",
    entrypoint = ["/api"],
    tars = [":api_tar"],
)
```

### Bazel Commands

```bash
# Build
bazel build //services/api:api
bazel build //...                         # Build everything

# Test
bazel test //services/api:api_test
bazel test //... --test_output=errors

# Query dependency graph
bazel query 'deps(//services/api:api)' --output=graph

# What depends on a library?
bazel query 'rdeps(//..., //libs/shared:shared_lib)'

# What changed? (requires integration with CI)
bazel query 'kind(".*_test", rdeps(//..., set($(git diff --name-only HEAD~1))))'
```

---

## CI/CD Integration

### GitHub Actions with Nx

```yaml
name: CI
on: [pull_request]

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - uses: nrwl/nx-set-shas@v4

      - run: npx nx affected -t lint test build --parallel=3
```

### GitHub Actions with Turborepo

```yaml
name: CI
on: [pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 2

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - run: npm ci

      - run: npx turbo build test lint --filter=...[HEAD~1]
        env:
          TURBO_TOKEN: ${{ secrets.TURBO_TOKEN }}
          TURBO_TEAM: ${{ vars.TURBO_TEAM }}
```

---

## Remote Caching Architecture

```
Developer A                   Developer B
    |                              |
    v                              v
[Local Cache]                [Local Cache]
    |                              |
    +----------> [Remote Cache] <--+
                 (Nx Cloud /
                  Vercel /
                  Bazel RBE)
                     |
                     v
                 [CI Runner]
                 [Local Cache]
```

### Cache Hit Rate Optimization

| Strategy | Impact | Effort |
|----------|--------|--------|
| Define precise `inputs` | High (avoid false misses) | Low |
| Pin tool versions | Medium (consistent hashes) | Low |
| Exclude test files from build inputs | Medium | Low |
| Remote cache | High (cross-developer sharing) | Medium |
| Distributed execution (Bazel RBE) | Very high | High |

---

## Cross-References

- `3-build/kubernetes_operations` - Deploy monorepo services to K8s
- `5-ship/gitops_workflow` - GitOps for monorepo deployments
- `4-secure/infrastructure_testing` - Test infra code within monorepo

---

## EXIT CHECKLIST

- [ ] Monorepo tool selected based on team size and language requirements
- [ ] Task dependency graph correctly models build order (`dependsOn: ["^build"]`)
- [ ] Inputs and outputs defined for all cacheable tasks
- [ ] Affected/changed detection configured for CI (only test/build what changed)
- [ ] Remote caching enabled and connected (Nx Cloud, Vercel, or custom)
- [ ] Module boundaries enforced (Nx tags or Bazel visibility)
- [ ] CI pipeline uses affected-based filtering
- [ ] Package/project naming convention established
- [ ] Dev task marked as non-cacheable and persistent
- [ ] Dependency graph visualization accessible to team

---

*Skill Version: 1.0 | Created: March 2026*
