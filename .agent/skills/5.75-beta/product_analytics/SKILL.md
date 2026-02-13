---
name: product_analytics
description: PostHog setup for user behavior tracking across backend, frontend, and website
---

# Product Analytics Skill

**Purpose**: Set up PostHog product analytics to track user behavior, measure feature adoption, and build data-driven dashboards across your entire SaaS stack.

## :dart: TRIGGER COMMANDS

```text
"set up analytics"
"add PostHog"
"track user events"
"set up product analytics"
"Using product_analytics skill: configure PostHog for [project]"
```

## :package: POSTHOG PROJECT SETUP

### 1. Create PostHog Project

Sign up at [posthog.com](https://posthog.com) (cloud) or self-host with Docker.

| Setting | Recommended Value |
|---------|------------------|
| Project name | `{app-name}-production` |
| Data region | US or EU (match your user base) |
| Timezone | UTC (normalize all events) |
| Session recording | Enabled (sample 10% initially) |

### 2. Retrieve API Keys

```text
Project API Key:  phc_xxxxxxxxxxxxxxxxxxxxxxxxxxxx  (public, used in frontend)
Personal API Key: phx_xxxxxxxxxxxxxxxxxxxxxxxxxxxx  (private, used in backend)
Host:             https://app.posthog.com  (or your self-hosted URL)
```

> [!WARNING]
> The **Personal API Key** is a secret. Never expose it in frontend code or commit it to version control. Store it in environment variables only.

### 3. Environment Variables

```bash
# .env (backend)
POSTHOG_API_KEY=phx_your_personal_api_key
POSTHOG_HOST=https://app.posthog.com
POSTHOG_PROJECT_API_KEY=phc_your_project_api_key

# .env (frontend)
VITE_POSTHOG_KEY=phc_your_project_api_key
VITE_POSTHOG_HOST=https://app.posthog.com
```

## :hammer_and_wrench: BACKEND INTEGRATION (NestJS)

### Install Dependencies

```bash
npm install posthog-node
```

### PostHogService (Injectable)

```typescript
// src/analytics/posthog.service.ts
import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { PostHog } from 'posthog-node';

@Injectable()
export class PostHogService implements OnModuleDestroy {
  private client: PostHog;

  constructor() {
    this.client = new PostHog(process.env.POSTHOG_API_KEY!, {
      host: process.env.POSTHOG_HOST || 'https://app.posthog.com',
      flushAt: 20,
      flushInterval: 10000,
    });
  }

  capture(distinctId: string, event: string, properties?: Record<string, any>) {
    this.client.capture({
      distinctId,
      event,
      properties: {
        ...properties,
        source: 'backend',
        timestamp: new Date().toISOString(),
      },
    });
  }

  identify(distinctId: string, properties: Record<string, any>) {
    this.client.identify({
      distinctId,
      properties,
    });
  }

  groupIdentify(groupType: string, groupKey: string, properties: Record<string, any>) {
    this.client.groupIdentify({
      groupType,
      groupKey,
      properties,
    });
  }

  async isFeatureEnabled(flag: string, distinctId: string): Promise<boolean> {
    return await this.client.isFeatureEnabled(flag, distinctId) ?? false;
  }

  async onModuleDestroy() {
    await this.client.shutdown();
  }
}
```

### Analytics Module

```typescript
// src/analytics/analytics.module.ts
import { Global, Module } from '@nestjs/common';
import { PostHogService } from './posthog.service';

@Global()
@Module({
  providers: [PostHogService],
  exports: [PostHogService],
})
export class AnalyticsModule {}
```

### Usage in Controllers

```typescript
// Example: tracking a CRM contact creation
@Post()
@UseGuards(JwtAuthGuard)
async createContact(@CurrentUser() user: UserPayload, @Body() dto: CreateContactDto) {
  const contact = await this.contactService.create(user.sub, dto);
  this.postHogService.capture(user.sub, 'contact_created', {
    contact_id: contact.id,
    source: dto.source,
    has_email: !!dto.email,
    has_phone: !!dto.phone,
  });
  return { success: true, data: contact };
}
```

## :art: FRONTEND INTEGRATION (React + Vite)

### Install Dependencies

```bash
npm install posthog-js
```

### PostHogProvider Context

```typescript
// src/providers/PostHogProvider.tsx
import React, { createContext, useContext, useEffect } from 'react';
import posthog from 'posthog-js';

interface PostHogContextType {
  capture: (event: string, properties?: Record<string, any>) => void;
  identify: (userId: string, properties?: Record<string, any>) => void;
  reset: () => void;
  isFeatureEnabled: (flag: string) => boolean;
}

const PostHogContext = createContext<PostHogContextType | null>(null);

export function PostHogProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    posthog.init(import.meta.env.VITE_POSTHOG_KEY, {
      api_host: import.meta.env.VITE_POSTHOG_HOST || 'https://app.posthog.com',
      capture_pageview: true,
      capture_pageleave: true,
      persistence: 'localStorage',
      respect_dnt: true,
      autocapture: false, // prefer explicit events
    });
  }, []);

  const value: PostHogContextType = {
    capture: (event, properties) => posthog.capture(event, { ...properties, source: 'frontend' }),
    identify: (userId, properties) => posthog.identify(userId, properties),
    reset: () => posthog.reset(),
    isFeatureEnabled: (flag) => posthog.isFeatureEnabled(flag) ?? false,
  };

  return <PostHogContext.Provider value={value}>{children}</PostHogContext.Provider>;
}

export function useAnalytics() {
  const ctx = useContext(PostHogContext);
  if (!ctx) throw new Error('useAnalytics must be used within PostHogProvider');
  return ctx;
}
```

### Tracking Hook Usage

```typescript
// src/pages/PipelinePage.tsx
import { useAnalytics } from '@/providers/PostHogProvider';

export function PipelinePage() {
  const { capture } = useAnalytics();

  const handleDealMoved = (dealId: string, fromStage: string, toStage: string) => {
    capture('deal_stage_changed', {
      deal_id: dealId,
      from_stage: fromStage,
      to_stage: toStage,
    });
  };

  const handleFilterApplied = (filters: Record<string, string>) => {
    capture('pipeline_filtered', { filter_count: Object.keys(filters).length });
  };

  // ... component render
}
```

### Identify on Login

```typescript
// src/hooks/useAuth.ts
const { identify } = useAnalytics();

const handleLoginSuccess = (user: AuthUser) => {
  identify(user.id, {
    email: user.email,
    name: user.name,
    plan: user.plan,
    org_id: user.orgId,
    created_at: user.createdAt,
  });

  // Associate user with their organization (group analytics)
  posthog.group('organization', user.orgId, {
    name: user.orgName,
    plan: user.plan,
    member_count: user.orgMemberCount,
  });
};
```

## :globe_with_meridians: NEXT.JS WEBSITE INTEGRATION

```typescript
// app/providers.tsx
'use client';

import posthog from 'posthog-js';
import { PostHogProvider as PHProvider } from 'posthog-js/react';
import { useEffect } from 'react';

export function PostHogWebProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY!, {
      api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST,
      capture_pageview: false, // handled by pageview component below
    });
  }, []);

  return <PHProvider client={posthog}>{children}</PHProvider>;
}
```

```typescript
// app/PostHogPageView.tsx
'use client';

import { usePathname, useSearchParams } from 'next/navigation';
import { useEffect } from 'react';
import { usePostHog } from 'posthog-js/react';

export function PostHogPageView() {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const posthog = usePostHog();

  useEffect(() => {
    if (pathname && posthog) {
      let url = window.origin + pathname;
      if (searchParams.toString()) url += '?' + searchParams.toString();
      posthog.capture('$pageview', { $current_url: url });
    }
  }, [pathname, searchParams, posthog]);

  return null;
}
```

## :label: EVENT TAXONOMY

### Naming Convention

Use **noun_verb** format in `snake_case`. The noun is the object, the verb is the action.

| Event Name | When Fired |
|------------|------------|
| `user_signed_up` | After successful registration |
| `user_logged_in` | After successful authentication |
| `user_logged_out` | After logout |
| `user_invited` | When team invite sent |
| `contact_created` | New CRM contact added |
| `contact_updated` | Contact record edited |
| `deal_created` | New deal in pipeline |
| `deal_stage_changed` | Deal moved to new stage |
| `pipeline_viewed` | Pipeline page loaded |
| `feature_used` | Generic feature engagement |
| `upgrade_started` | User clicks upgrade button |
| `upgrade_completed` | Payment confirmed |
| `page_viewed` | Any page navigation |
| `search_performed` | User uses search |
| `export_downloaded` | Data export completed |
| `ai_prompt_sent` | AI feature invoked |

> [!TIP]
> Avoid vague events like `click` or `action`. Always include the object being acted upon. `button_clicked` is bad; `deal_created` is good.

### Standard Properties for Every Event

```typescript
interface StandardProperties {
  source: 'frontend' | 'backend' | 'website';
  org_id?: string;
  plan?: 'free' | 'pro' | 'enterprise';
  app_version?: string;
}
```

## :triangular_flag_on_post: FEATURE FLAGS

```typescript
// Check feature flag before showing new UI
const showNewDashboard = await postHogService.isFeatureEnabled('new-dashboard-v2', user.sub);

// Frontend usage
const { isFeatureEnabled } = useAnalytics();

return (
  <div>
    {isFeatureEnabled('new-onboarding-flow') ? <NewOnboarding /> : <LegacyOnboarding />}
  </div>
);
```

## :bar_chart: DASHBOARD TEMPLATES

### Activation Funnel

```text
Step 1: user_signed_up
Step 2: user_logged_in (first time)
Step 3: contact_created (first contact)
Step 4: deal_created (first deal)
Step 5: team_member_invited
```

### Retention Dashboard

| Metric | PostHog Insight Type |
|--------|---------------------|
| Daily Active Users | Trends (unique users, daily) |
| Weekly Retention | Retention (first event: user_signed_up) |
| Feature Stickiness | Stickiness (event: feature_used) |
| Power Users | Trends (users with 10+ events/day) |

### Feature Adoption

| Metric | Query |
|--------|-------|
| Adoption Rate | unique users of feature / total active users |
| Time to Adopt | median days from signup to first feature use |
| Usage Frequency | events per user per week |

### Revenue

| Metric | Event |
|--------|-------|
| Upgrades | `upgrade_completed` trend |
| Conversion Rate | `upgrade_completed` / `upgrade_started` |
| Churn Signal | Users inactive > 7 days |

## :shield: PRIVACY AND COMPLIANCE

```typescript
// PostHog init with privacy settings
posthog.init(apiKey, {
  respect_dnt: true,                    // Honor Do Not Track browser setting
  ip: false,                            // Do not capture IP addresses
  persistence: 'localStorage',          // Or 'cookie' for cross-subdomain
  opt_out_capturing_by_default: false,   // Set true for GDPR opt-in requirement
  sanitize_properties: (properties) => {
    // Strip any accidentally included sensitive data
    delete properties['$ip'];
    return properties;
  },
});

// GDPR consent flow
function handleCookieConsent(accepted: boolean) {
  if (accepted) {
    posthog.opt_in_capturing();
  } else {
    posthog.opt_out_capturing();
  }
}
```

### What to NEVER Track

| Category | Examples |
|----------|----------|
| Credentials | Passwords, API keys, tokens, session IDs |
| Financial | Full credit card numbers, bank account numbers |
| Health | Personal health information (PHI) |
| Raw PII | Social security numbers, government IDs |

> [!WARNING]
> If any sensitive field is accidentally included in event properties, PostHog cannot retroactively delete it from all replays and events. Sanitize at the capture layer, not after.

## :white_check_mark: EXIT CHECKLIST

- [ ] PostHog project created and API keys stored in environment variables
- [ ] Backend `PostHogService` is injectable and captures events
- [ ] Frontend `PostHogProvider` wraps app and `useAnalytics` hook works
- [ ] Website (Next.js) tracks pageviews correctly
- [ ] User identified on login with `posthog.identify()` including user properties
- [ ] Group analytics configured for organizations
- [ ] Event taxonomy follows `noun_verb` naming convention
- [ ] Standard SaaS events implemented: signup, login, feature usage, upgrade
- [ ] Feature flags integrated for gradual rollout
- [ ] Dashboards created: activation funnel, retention, feature adoption, revenue
- [ ] Privacy respected: Do Not Track honored, IPs anonymized, GDPR consent handled
- [ ] Sensitive data (passwords, tokens, card numbers) excluded from all events
- [ ] `PostHogService.onModuleDestroy()` flushes events on shutdown

*Skill Version: 1.0 | Created: February 2026*
