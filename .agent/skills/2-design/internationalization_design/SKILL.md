---
name: Internationalization Design
description: Phase 2 i18n architecture decisions covering string externalization, locale-aware data models, RTL layout, and translation workflows
---

# Internationalization Design Skill

**Purpose**: Makes internationalization architecture decisions during Phase 2 to prevent the 3-5x retrofit cost of adding multi-language support after build. Covers string externalization strategy, locale-aware data model design, RTL considerations, locale detection, and translation workflow design.

## TRIGGER COMMANDS

```text
"International markets"
"i18n architecture"
"Multi-language support design"
```

## When to Use
- When the product will serve users in multiple languages or locales
- When date, currency, or number formatting varies by user region
- Before building any UI that displays user-facing text
- When planning market expansion beyond a single locale

---

## PROCESS

### Step 1: Select String Externalization Strategy

Choose the i18n library and message format:

| Framework | Library | Message Format | Pluralization | Pros | Cons |
|-----------|---------|---------------|---------------|------|------|
| React | react-i18next | JSON (flat/nested) | ICU or i18next | Huge ecosystem, lazy loading | Config complexity |
| React | react-intl (FormatJS) | ICU MessageFormat | ICU native | Standard format, strong typing | Smaller community |
| Any | Fluent (Mozilla) | FTL files | Built-in | Expressive, translator-friendly | Smaller ecosystem |
| Backend | i18next (Node) | JSON | ICU or i18next | Shared config with frontend | N/A |

**Decision template**:
```markdown
## String Externalization Decision
- **Frontend**: react-i18next with ICU MessageFormat
- **Backend**: i18next with shared namespace structure
- **File format**: JSON, one file per locale per namespace
- **Namespace strategy**: One namespace per feature module
- **Key naming**: dot-separated, e.g., `auth.login.submitButton`
```

### Step 2: Design Locale-Aware Data Model

Define how locale-sensitive data is stored in the database:

```markdown
## Data Model Decisions

### Timestamps
- Store as UTC (timestamptz in PostgreSQL)
- Convert to user locale on display (frontend Intl.DateTimeFormat)
- Never store locale-formatted strings

### Currency
- Store amount as integer (cents) + currency code (ISO 4217)
- Example: { amount: 1999, currency: "EUR" } = 19.99 EUR
- Format on display with Intl.NumberFormat

### Addresses
- Use flexible schema supporting international formats:
  | Field | Purpose |
  |-------|---------|
  | line1 | Street address |
  | line2 | Apt, suite, unit |
  | city | City/town/village |
  | region | State/province/prefecture |
  | postalCode | ZIP/postal code |
  | country | ISO 3166-1 alpha-2 |

### User Locale Preference
- Store on user profile: `locale` (BCP 47 tag, e.g., "en-US", "ja-JP")
- Store timezone: `timezone` (IANA, e.g., "America/New_York")
- Fallback chain: User preference > Browser `Accept-Language` > Default locale
```

### Step 3: RTL Layout Considerations

If supporting Arabic, Hebrew, or other RTL languages:

```markdown
## RTL Support Plan

| Concern | Strategy |
|---------|----------|
| CSS Direction | Use `dir="rtl"` on `<html>`, CSS logical properties (`margin-inline-start` not `margin-left`) |
| Icons | Mirror directional icons (arrows, navigation) |
| Text alignment | Use `text-align: start` not `text-align: left` |
| Layout | Flexbox with `direction` inherits correctly; audit `position: absolute` |
| Numbers | Digits remain LTR even in RTL context |
| Testing | Pseudo-RTL locale for development testing |

## CSS Logical Properties Cheat Sheet
| Physical (avoid) | Logical (use) |
|-------------------|--------------|
| margin-left | margin-inline-start |
| margin-right | margin-inline-end |
| padding-left | padding-inline-start |
| text-align: left | text-align: start |
| float: left | float: inline-start |
```

### Step 4: Locale Detection and Fallback Strategy

```markdown
## Locale Resolution Chain

1. **Explicit user setting** (stored in profile) -- highest priority
2. **URL parameter** (`?lang=fr`) -- for shared links
3. **Cookie/localStorage** -- returning visitor preference
4. **Accept-Language header** -- browser default
5. **GeoIP lookup** -- initial suggestion only, never force
6. **Application default** (en-US) -- ultimate fallback

## Fallback Strategy for Missing Translations
1. Try requested locale (e.g., `fr-CA`)
2. Fall back to language (e.g., `fr`)
3. Fall back to default locale (`en-US`)
4. Show translation key as last resort (flags missing translations in dev)
```

### Step 5: Translation Workflow Design

```markdown
## Translation Workflow

### Development Flow
1. Developer adds UI text using i18n key: `t('feature.component.label')`
2. Default locale file (en-US.json) updated with key and English string
3. CI extracts keys and detects untranslated strings
4. Export new/changed strings to translation management system

### Translation Management
| Option | When to Use | Integration |
|--------|-------------|-------------|
| Crowdin | Open source, community translations | GitHub sync |
| Phrase | Professional teams, workflow controls | CLI + API |
| Lokalise | Visual editor, screenshot context | CLI + GitHub |
| Manual | < 3 locales, small string count | JSON files in repo |

### Quality Gates
- CI fails if default locale has missing keys
- Pseudo-localization (`[!!Hellow Worldo!!]`) catches hardcoded strings
- Screenshot tests with longest locale catch text overflow
```

---

## OUTPUT

**Path**: `.agent/docs/2-design/internationalization-design.md`

---

## CHECKLIST

- [ ] String externalization library chosen with rationale
- [ ] Message format selected (ICU, i18next, Fluent)
- [ ] Namespace strategy defined (per-feature or per-page)
- [ ] Key naming convention documented
- [ ] Timestamps stored as UTC with display-time conversion
- [ ] Currency stored as cents + ISO 4217 code
- [ ] Address schema supports international formats
- [ ] User locale preference field added to user model
- [ ] Locale fallback chain defined (5 levels)
- [ ] RTL plan documented (if applicable) with CSS logical properties
- [ ] Translation management tool selected
- [ ] CI quality gates defined for missing translations
- [ ] ADR created for i18n library and format decisions

---

*Skill Version: 1.0 | Phase: 2-Design | Priority: P1*
