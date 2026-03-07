---
name: Documentation as Code
description: Docs-as-code workflows with Docusaurus, MkDocs, OpenAPI documentation, versioned docs, and CI for documentation
---

# Documentation as Code Skill

**Purpose**: Implement documentation-as-code practices using static site generators, API documentation tools, versioning strategies, and CI pipelines that keep documentation accurate and up-to-date.

---

## TRIGGER COMMANDS

```text
"Set up documentation for our project"
"Configure Docusaurus for our docs"
"Generate API documentation from OpenAPI"
"Set up versioned documentation"
"Using documentation_as_code skill: [task]"
```

---

## Documentation Tool Comparison

| Feature | Docusaurus | MkDocs (Material) | Starlight (Astro) | GitBook |
|---------|-----------|-------------------|-------------------|---------|
| Language | React/MDX | Python/Markdown | Astro/MDX | SaaS |
| Search | Algolia/local | Built-in | Pagefind | Built-in |
| Versioning | Built-in | mike plugin | Manual | Built-in |
| i18n | Built-in | Plugin | Built-in | Paid |
| Blog | Built-in | Plugin | Plugin | No |
| API docs | Plugin | Plugin | Plugin | Partial |
| Hosting | Static | Static | Static | Hosted |
| Customization | High (React) | Medium (Jinja2) | High (Astro) | Low |
| Build speed | Medium | Fast | Fast | N/A |
| Best for | Product docs | Technical docs | Dev docs | Non-technical |

---

## Docusaurus Setup

### Project Structure

```
docs-site/
  docs/
    intro.md
    getting-started/
      installation.md
      quickstart.md
      configuration.md
    guides/
      authentication.md
      deployment.md
    api/
      overview.md
      endpoints/
        users.md
        products.md
    reference/
      configuration.md
      cli.md
  blog/
    2026-03-01-release-notes.md
  src/
    components/
      ApiEndpoint.tsx
      CodeExample.tsx
    css/
      custom.css
    pages/
      index.tsx
  static/
    img/
  docusaurus.config.ts
  sidebars.ts
```

### Configuration

```typescript
// docusaurus.config.ts
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'My Project Docs',
  tagline: 'Documentation for My Project',
  url: 'https://docs.myproject.com',
  baseUrl: '/',
  organizationName: 'my-org',
  projectName: 'my-project',

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/my-org/my-project/edit/main/docs-site/',
          showLastUpdateTime: true,
          showLastUpdateAuthor: true,
          versions: {
            current: {
              label: 'Next',
              path: 'next',
            },
          },
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/my-org/my-project/edit/main/docs-site/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'My Project',
      items: [
        { type: 'docSidebar', sidebarId: 'docs', label: 'Docs', position: 'left' },
        { to: '/blog', label: 'Blog', position: 'left' },
        { type: 'docsVersionDropdown', position: 'right' },
        { href: 'https://github.com/my-org/my-project', label: 'GitHub', position: 'right' },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        { title: 'Docs', items: [{ label: 'Getting Started', to: '/docs/getting-started/installation' }] },
        { title: 'Community', items: [{ label: 'Discord', href: 'https://discord.gg/myproject' }] },
      ],
    },
    algolia: {
      appId: 'YOUR_APP_ID',
      apiKey: 'YOUR_SEARCH_API_KEY',
      indexName: 'my-project',
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
```

### Sidebars

```typescript
// sidebars.ts
import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docs: [
    'intro',
    {
      type: 'category',
      label: 'Getting Started',
      items: [
        'getting-started/installation',
        'getting-started/quickstart',
        'getting-started/configuration',
      ],
      collapsed: false,
    },
    {
      type: 'category',
      label: 'Guides',
      items: [
        'guides/authentication',
        'guides/deployment',
      ],
    },
    {
      type: 'category',
      label: 'API Reference',
      link: { type: 'doc', id: 'api/overview' },
      items: [
        'api/endpoints/users',
        'api/endpoints/products',
      ],
    },
    {
      type: 'category',
      label: 'Reference',
      items: [
        'reference/configuration',
        'reference/cli',
      ],
    },
  ],
};

export default sidebars;
```

---

## MkDocs Material Setup

### Configuration

```yaml
# mkdocs.yml
site_name: My Project
site_url: https://docs.myproject.com
repo_url: https://github.com/my-org/my-project
repo_name: my-org/my-project

theme:
  name: material
  features:
    - navigation.instant
    - navigation.tracking
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.suggest
    - search.highlight
    - content.code.copy
    - content.code.annotate
    - content.tabs.link
  palette:
    - scheme: default
      primary: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      primary: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode

plugins:
  - search
  - git-revision-date-localized:
      enable_creation_date: true
  - minify:
      minify_html: true

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - pymdownx.tabbed:
      alternate_style: true
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - attr_list
  - md_in_html
  - toc:
      permalink: true

nav:
  - Home: index.md
  - Getting Started:
    - Installation: getting-started/installation.md
    - Quickstart: getting-started/quickstart.md
  - Guides:
    - Authentication: guides/authentication.md
    - Deployment: guides/deployment.md
  - API Reference:
    - Overview: api/overview.md
    - Users: api/users.md
    - Products: api/products.md
  - Reference:
    - Configuration: reference/configuration.md
    - CLI: reference/cli.md
```

---

## OpenAPI Documentation

### Spec-First API Design

```yaml
# openapi.yaml
openapi: 3.1.0
info:
  title: My Project API
  version: 2.1.0
  description: |
    API for My Project. All endpoints require authentication unless noted.
  contact:
    email: api-support@myproject.com

servers:
  - url: https://api.myproject.com/v2
    description: Production
  - url: https://api.staging.myproject.com/v2
    description: Staging

security:
  - BearerAuth: []

paths:
  /users:
    get:
      operationId: listUsers
      summary: List all users
      tags: [Users]
      parameters:
        - name: page
          in: query
          schema: { type: integer, default: 1, minimum: 1 }
        - name: limit
          in: query
          schema: { type: integer, default: 20, minimum: 1, maximum: 100 }
        - name: search
          in: query
          schema: { type: string }
          description: Search users by name or email
      responses:
        '200':
          description: Paginated list of users
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items: { $ref: '#/components/schemas/User' }
                  pagination:
                    $ref: '#/components/schemas/Pagination'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      operationId: createUser
      summary: Create a new user
      tags: [Users]
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/CreateUserRequest' }
      responses:
        '201':
          description: User created
          content:
            application/json:
              schema:
                type: object
                properties:
                  data: { $ref: '#/components/schemas/User' }
        '400':
          $ref: '#/components/responses/ValidationError'
        '409':
          description: User with this email already exists

components:
  schemas:
    User:
      type: object
      required: [id, email, name, createdAt]
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
        role:
          type: string
          enum: [admin, user, viewer]
        createdAt:
          type: string
          format: date-time

    CreateUserRequest:
      type: object
      required: [email, name]
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        role:
          type: string
          enum: [admin, user, viewer]
          default: user

    Pagination:
      type: object
      properties:
        page: { type: integer }
        limit: { type: integer }
        total: { type: integer }
        totalPages: { type: integer }

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  responses:
    Unauthorized:
      description: Authentication required
      content:
        application/json:
          schema:
            type: object
            properties:
              error: { type: string, example: "Unauthorized" }
    ValidationError:
      description: Request validation failed
      content:
        application/json:
          schema:
            type: object
            properties:
              error: { type: string }
              details:
                type: array
                items:
                  type: object
                  properties:
                    field: { type: string }
                    message: { type: string }
```

### Generate Docs from OpenAPI

```bash
# Redoc (static HTML)
npx @redocly/cli build-docs openapi.yaml -o docs/api/index.html

# Swagger UI (interactive)
npx swagger-ui-express  # serve alongside API

# TypeScript types from spec
npx openapi-typescript openapi.yaml -o src/types/api.d.ts

# Validate spec
npx @redocly/cli lint openapi.yaml
```

---

## Versioned Documentation

### Docusaurus Versioning

```bash
# Create a version snapshot
npx docusaurus docs:version 2.0

# This creates:
# versioned_docs/version-2.0/  (copy of docs/)
# versioned_sidebars/version-2.0-sidebars.json
# versions.json (updated)

# Directory structure after versioning:
# docs/              → "Next" (unreleased)
# versioned_docs/
#   version-2.0/     → v2.0 (current stable)
#   version-1.0/     → v1.0 (legacy)
```

### MkDocs Versioning (mike)

```bash
# Install mike
pip install mike

# Deploy a version
mike deploy 2.0 latest --push
mike deploy 1.0 --push

# Set default version
mike set-default latest --push

# List versions
mike list
```

---

## CI/CD for Documentation

### GitHub Actions Pipeline

```yaml
# .github/workflows/docs.yml
name: Documentation

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'
      - 'docs-site/**'
      - 'openapi.yaml'
  pull_request:
    paths:
      - 'docs/**'
      - 'docs-site/**'
      - 'openapi.yaml'

jobs:
  lint-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check links
        uses: lycheeverse/lychee-action@v1
        with:
          args: --verbose --no-progress 'docs/**/*.md'
          fail: true

      - name: Lint markdown
        run: npx markdownlint-cli2 "docs/**/*.md"

      - name: Validate OpenAPI
        run: npx @redocly/cli lint openapi.yaml

  build-docs:
    runs-on: ubuntu-latest
    needs: lint-docs
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: cd docs-site && npm ci && npm run build

      - name: Upload artifact
        if: github.ref == 'refs/heads/main'
        uses: actions/upload-pages-artifact@v3
        with:
          path: docs-site/build

  deploy-docs:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    needs: build-docs
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Markdown Linting

```jsonc
// .markdownlint.jsonc
{
  "default": true,
  "MD013": false,  // Line length (too strict for docs)
  "MD033": false,  // Inline HTML (needed for MDX/admonitions)
  "MD041": false,  // First line heading (frontmatter)
  "MD024": { "siblings_only": true }  // Duplicate headings (OK in different sections)
}
```

---

## Documentation Types

| Type | Audience | Purpose | Example |
|------|----------|---------|---------|
| Tutorial | New users | Learning-oriented | "Build your first app" |
| How-to Guide | Working developers | Task-oriented | "How to configure SSO" |
| Reference | Experienced devs | Information-oriented | API endpoints, config options |
| Explanation | Anyone curious | Understanding-oriented | "Why we use event sourcing" |

### Template: How-to Guide

```markdown
---
title: How to Configure SSO
sidebar_position: 3
---

# How to Configure SSO

This guide walks you through setting up Single Sign-On with your identity provider.

## Prerequisites

- Admin access to your identity provider (Okta, Auth0, Azure AD)
- My Project Enterprise plan or higher

## Steps

### 1. Create an application in your IdP

Navigate to your identity provider and create a new SAML 2.0 application.

### 2. Configure the callback URL

Set the ACS URL to:

```text
https://your-domain.myproject.com/auth/saml/callback
```

### 3. Add the IdP metadata

```bash
mytools sso configure --metadata-url https://your-idp.com/metadata.xml
```

### 4. Test the connection

```bash
mytools sso test
```

## Troubleshooting

**"Invalid signature" error**: Ensure your IdP certificate has not expired.

**Users not being created**: Check that the SAML response includes email and name attributes.
```

---

## Cross-References

- `toolkit/developer_experience_tooling` - Developer tooling and CLI tools
- `3-build/internal_developer_portal` - Service catalog and TechDocs
- `3-build/design_system_development` - Component documentation with Storybook

---

## EXIT CHECKLIST

- [ ] Documentation framework selected and configured
- [ ] Site structure follows the four documentation types (tutorial, how-to, reference, explanation)
- [ ] Sidebar navigation is logical and complete
- [ ] Search configured (Algolia, Pagefind, or built-in)
- [ ] API docs generated from OpenAPI spec
- [ ] OpenAPI spec validated in CI
- [ ] Markdown linting configured
- [ ] Broken link checking in CI
- [ ] Documentation deploys automatically on merge to main
- [ ] Versioning strategy defined for breaking changes
- [ ] Edit links point to correct GitHub path
- [ ] Last updated timestamps shown on pages

---

*Skill Version: 1.0 | Created: March 2026*
