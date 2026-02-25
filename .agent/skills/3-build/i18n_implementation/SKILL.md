---
name: I18n Implementation
description: Implement internationalization with extraction-first development, locale-safe formatting, and React i18next integration.
---

# I18n Implementation Skill

**Purpose**: Implement internationalization decisions from Phase 2 design into working code. Covers the extraction-first development workflow, locale-safe date/number/currency formatting on both frontend and backend, React i18next integration, NestJS locale middleware, and pseudo-localization testing.

## TRIGGER COMMANDS

```text
"Extract strings for translation"
"Implement locale support"
"i18n for [component]"
```

## When to Use
- Building a feature that displays user-facing text
- Application targets multiple locales or languages
- Dates, numbers, or currencies must display in locale-specific formats
- Phase 2 internationalization design is ready for implementation
- Adding locale support to an existing English-only application

---

## PROCESS

### Step 1: Extraction-First Development Workflow

Never hardcode user-facing strings. Extract them from the start.

```text
Development flow:
1. Write component with translation keys (not raw strings)
2. Add keys to en.json as default language
3. Run extraction tool to verify no missing keys
4. Component renders correctly with English keys
5. Translators fill in other locale files later
```

### Step 2: React i18next Setup

```typescript
// i18n/i18n.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import Backend from 'i18next-http-backend';

i18n
  .use(Backend)
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: 'en',
    supportedLngs: ['en', 'es', 'fr', 'de', 'ja'],
    ns: ['common', 'dashboard', 'settings'],
    defaultNS: 'common',
    interpolation: {
      escapeValue: false,  // React already escapes
    },
    detection: {
      order: ['querystring', 'cookie', 'localStorage', 'navigator'],
      caches: ['localStorage', 'cookie'],
    },
    backend: {
      loadPath: '/locales/{{lng}}/{{ns}}.json',
    },
  });

export default i18n;
```

```json
// public/locales/en/common.json
{
  "nav": {
    "home": "Home",
    "settings": "Settings",
    "logout": "Log out"
  },
  "actions": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "confirm_delete": "Are you sure you want to delete {{name}}?"
  },
  "errors": {
    "required_field": "This field is required",
    "network_error": "Unable to connect. Please try again."
  }
}
```

```json
// public/locales/es/common.json
{
  "nav": {
    "home": "Inicio",
    "settings": "Configuracion",
    "logout": "Cerrar sesion"
  },
  "actions": {
    "save": "Guardar",
    "cancel": "Cancelar",
    "delete": "Eliminar",
    "confirm_delete": "Estas seguro de que quieres eliminar {{name}}?"
  }
}
```

### Step 3: Component Integration

```tsx
// components/WorkspaceCard.tsx
import { useTranslation } from 'react-i18next';

export function WorkspaceCard({ workspace }: { workspace: Workspace }) {
  const { t } = useTranslation('dashboard');

  return (
    <div>
      <h3>{workspace.name}</h3>
      <p>{t('workspace.member_count', { count: workspace.memberCount })}</p>
      <button onClick={onDelete}>
        {t('common:actions.delete')}
      </button>
    </div>
  );
}

// Pluralization in locale file:
// "workspace": {
//   "member_count_one": "{{count}} member",
//   "member_count_other": "{{count}} members"
// }
```

### Step 4: Locale-Safe Date/Number/Currency Formatting (Frontend)

```typescript
// utils/formatters.ts
// Use the Intl API -- never format manually

export function formatDate(date: Date | string, locale: string): string {
  return new Intl.DateTimeFormat(locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(new Date(date));
}

export function formatCurrency(amount: number, currency: string, locale: string): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency,
  }).format(amount);
}

export function formatNumber(value: number, locale: string): string {
  return new Intl.NumberFormat(locale).format(value);
}

// Usage:
// formatDate('2025-03-15', 'en-US')  --> "March 15, 2025"
// formatDate('2025-03-15', 'de-DE')  --> "15. Marz 2025"
// formatCurrency(1234.5, 'USD', 'en-US')  --> "$1,234.50"
// formatCurrency(1234.5, 'EUR', 'de-DE')  --> "1.234,50 EUR"
```

### Step 5: NestJS Locale Middleware

```typescript
// middleware/locale.middleware.ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class LocaleMiddleware implements NestMiddleware {
  private readonly supportedLocales = ['en', 'es', 'fr', 'de', 'ja'];
  private readonly defaultLocale = 'en';

  use(req: Request, _res: Response, next: NextFunction) {
    // Priority: query param > header > default
    const locale =
      req.query.locale as string ||
      this.parseAcceptLanguage(req.headers['accept-language']) ||
      this.defaultLocale;

    req['locale'] = this.supportedLocales.includes(locale) ? locale : this.defaultLocale;
    next();
  }

  private parseAcceptLanguage(header?: string): string | null {
    if (!header) return null;
    const primary = header.split(',')[0]?.split('-')[0]?.trim();
    return primary || null;
  }
}
```

```typescript
// Backend formatting service
@Injectable()
export class FormatService {
  formatDate(date: Date, locale: string): string {
    return new Intl.DateTimeFormat(locale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }).format(date);
  }

  formatCurrency(amount: number, currency: string, locale: string): string {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency,
    }).format(amount);
  }
}

// Usage in controller
@Get('summary')
getSummary(@Req() req: Request) {
  const locale = req['locale'];
  const data = this.service.getSummary();
  return {
    revenue: this.format.formatCurrency(data.revenue, 'USD', locale),
    lastUpdated: this.format.formatDate(data.updatedAt, locale),
  };
}
```

### Step 6: Pseudo-Localization Testing

Pseudo-localization catches hardcoded strings and layout issues without real translations.

```typescript
// scripts/pseudo-locale.ts
// Transforms English strings to detect:
// 1. Hardcoded strings (they won't be transformed)
// 2. Truncation issues (pseudo strings are ~30% longer)
// 3. Character encoding issues (uses accented characters)

function pseudoLocalize(str: string): string {
  const charMap: Record<string, string> = {
    a: 'a', b: 'b', c: 'c', d: 'd', e: 'e',
    o: 'o', u: 'u', i: 'i', n: 'n', s: 's',
  };

  // Pad to simulate ~30% text expansion
  const padding = ' [...]'.repeat(Math.ceil(str.length * 0.3 / 6));

  return '[' + str.split('').map(c => charMap[c.toLowerCase()] || c).join('') + padding + ']';
}

// Generate pseudo locale file from en.json
// Run: npx ts-node scripts/pseudo-locale.ts
```

```json
// public/locales/pseudo/common.json (auto-generated)
{
  "nav": {
    "home": "[Home [...]]",
    "settings": "[Settings [...][...]]",
    "logout": "[Log out [...]]"
  }
}
```

### Step 7: CI Validation

```yaml
# .github/workflows/i18n.yml
- name: Check for missing translation keys
  run: |
    npx i18next-parser --config i18next-parser.config.js
    git diff --exit-code public/locales/en/
    # If en.json changed, extraction found missing keys
```

---

## CHECKLIST

- [ ] No hardcoded user-facing strings in components (all use `t()`)
- [ ] i18next configured with language detection and fallback
- [ ] English locale files organized by namespace (common, feature-specific)
- [ ] Pluralization uses i18next `_one` / `_other` suffixes (not code conditionals)
- [ ] Dates, numbers, and currencies use `Intl` API (not manual formatting)
- [ ] NestJS locale middleware extracts locale from Accept-Language header
- [ ] Pseudo-localization test catches layout expansion issues
- [ ] CI extracts keys and fails if locale files are out of sync
- [ ] Translation keys are descriptive (`workspace.member_count`, not `msg_42`)
- [ ] RTL layout tested if Arabic/Hebrew is a target locale
