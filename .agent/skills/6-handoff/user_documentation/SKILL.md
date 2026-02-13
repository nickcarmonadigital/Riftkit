---
name: User Documentation & Help Center
description: Standards and templates for creating user-facing documentation, in-app help, and contextual guidance
---

# User Documentation & Help Center Skill

**Purpose**: Users who can't figure out your product will leave. This skill provides the complete framework for creating help centers, user guides, and in-app contextual help that keeps users self-sufficient.

> [!WARNING]
> **Documentation Debt is Product Debt**: Every feature shipped without docs is a support ticket waiting to happen. Document as you ship, not after.

---

## 🎯 TRIGGER COMMANDS

```text
"Create help center for [project]"
"Write user documentation for [feature]"
"Write user guides for [module]"
"Add in-app help to [component]"
"Using user_documentation skill: document [feature/project]"
```

---

## 📚 DOCUMENTATION TYPES

| Type | Purpose | Format | When to Use |
|------|---------|--------|-------------|
| **Getting Started Guide** | First 5 minutes of the product | Step-by-step walkthrough | Every product needs one |
| **Feature Guides** | Deep dive on one feature | Task-oriented how-to | Each major feature |
| **FAQ** | Quick answers to common questions | Q&A format | After 10+ support tickets on same topic |
| **Troubleshooting** | Fix common problems | Problem → Solution table | Known issues and edge cases |
| **Release Notes** | What changed and why | Changelog format | Every release |
| **API Documentation** | Machine-readable specs | OpenAPI/Swagger (see `api_reference` skill) | If you expose an API |

> [!TIP]
> **Task-Oriented, Not Feature-Oriented**: Write "How to invite a team member" not "The Team Management Panel". Users think in goals, not UI components.

---

## 🏗️ HELP CENTER OPTIONS

### Option 1: In-App Help Panel

Best for SaaS products where users need help without leaving the app.

| Pros | Cons |
|------|------|
| Zero context switching | Limited space for long articles |
| Can be contextual (show relevant help) | Requires frontend work |
| Higher engagement | Must maintain alongside UI changes |

### Option 2: External Documentation Site

Best for developer tools, complex products, or products with large doc sets.

| Platform | Best For | Pricing | Notes |
|----------|----------|---------|-------|
| **Docusaurus** | Developer docs, open source | Free (self-hosted) | React-based, versioning built-in, MDX support |
| **GitBook** | Team knowledge bases | Free tier available | WYSIWYG editor, Git sync |
| **Mintlify** | API-heavy products | Paid | Beautiful defaults, OpenAPI integration |
| **Nextra** | Next.js projects | Free (self-hosted) | MDX, lightweight |

### Option 3: Hybrid (Recommended)

Use both: an in-app help panel for contextual tips and quick answers, plus an external docs site for comprehensive guides.

---

## 💡 IN-APP CONTEXTUAL HELP

### Tooltip System

Place `?` icons next to complex UI elements that link to relevant help content.

```tsx
// components/ui/HelpTooltip.tsx
import { useState } from 'react';

interface HelpTooltipProps {
  content: string;
  learnMoreUrl?: string;
}

export function HelpTooltip({ content, learnMoreUrl }: HelpTooltipProps) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="relative inline-block">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="ml-1 inline-flex h-4 w-4 items-center justify-center
                   rounded-full bg-gray-200 text-xs text-gray-600
                   hover:bg-gray-300 transition-colors"
        aria-label="Help"
      >
        ?
      </button>

      {isOpen && (
        <div className="absolute z-50 mt-2 w-64 rounded-lg border
                        border-gray-200 bg-white p-3 shadow-lg text-sm">
          <p className="text-gray-700">{content}</p>
          {learnMoreUrl && (
            <a
              href={learnMoreUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-2 inline-block text-blue-600 hover:underline text-xs"
            >
              Learn more
            </a>
          )}
          <button
            onClick={() => setIsOpen(false)}
            className="absolute top-1 right-2 text-gray-400 hover:text-gray-600"
          >
            x
          </button>
        </div>
      )}
    </div>
  );
}
```

**Usage**:

```tsx
<label className="flex items-center gap-1">
  API Key
  <HelpTooltip
    content="Your API key authenticates requests. Keep it secret."
    learnMoreUrl="/docs/authentication"
  />
</label>
```

### Help Panel Component

A slide-out panel for in-app documentation browsing.

```tsx
// components/help/HelpPanel.tsx
import { useState, useEffect } from 'react';

interface HelpArticle {
  id: string;
  title: string;
  content: string;
  category: string;
  tags: string[];
}

interface HelpPanelProps {
  isOpen: boolean;
  onClose: () => void;
  contextKey?: string; // Current page/feature identifier
  articles: HelpArticle[];
}

export function HelpPanel({ isOpen, onClose, contextKey, articles }: HelpPanelProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedArticle, setSelectedArticle] = useState<HelpArticle | null>(null);

  // Filter articles by context and search
  const filtered = articles.filter((article) => {
    const matchesSearch =
      !searchQuery ||
      article.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      article.content.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesContext =
      !contextKey || article.tags.includes(contextKey);
    return matchesSearch && (searchQuery ? true : matchesContext);
  });

  if (!isOpen) return null;

  return (
    <div className="fixed right-0 top-0 h-full w-96 bg-white shadow-2xl
                    border-l border-gray-200 z-50 flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between border-b p-4">
        <h2 className="text-lg font-semibold">Help Center</h2>
        <button onClick={onClose} className="text-gray-500 hover:text-gray-700">
          Close
        </button>
      </div>

      {/* Search */}
      <div className="p-4 border-b">
        <input
          type="text"
          placeholder="Search help articles..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full rounded-md border border-gray-300 px-3 py-2
                     text-sm focus:border-blue-500 focus:outline-none"
        />
      </div>

      {/* Articles List or Article Detail */}
      <div className="flex-1 overflow-y-auto p-4">
        {selectedArticle ? (
          <div>
            <button
              onClick={() => setSelectedArticle(null)}
              className="mb-3 text-sm text-blue-600 hover:underline"
            >
              Back to articles
            </button>
            <h3 className="text-lg font-semibold mb-2">{selectedArticle.title}</h3>
            <div className="prose prose-sm">{selectedArticle.content}</div>
          </div>
        ) : (
          <ul className="space-y-2">
            {filtered.map((article) => (
              <li key={article.id}>
                <button
                  onClick={() => setSelectedArticle(article)}
                  className="w-full text-left rounded-md p-3 hover:bg-gray-50
                             border border-gray-100 transition-colors"
                >
                  <span className="font-medium text-sm">{article.title}</span>
                  <span className="block text-xs text-gray-500 mt-1">
                    {article.category}
                  </span>
                </button>
              </li>
            ))}
            {filtered.length === 0 && (
              <p className="text-sm text-gray-500 text-center py-4">
                No articles found. Try a different search term.
              </p>
            )}
          </ul>
        )}
      </div>

      {/* Footer with feedback */}
      <div className="border-t p-4 text-center text-xs text-gray-500">
        Can't find what you need?{' '}
        <a href="/support" className="text-blue-600 hover:underline">
          Contact support
        </a>
      </div>
    </div>
  );
}
```

### Onboarding Tours

Use guided tours for first-time users. Libraries: `react-joyride`, `shepherd.js`, or `introjs`.

```tsx
// hooks/useOnboardingTour.ts
import { useState, useEffect } from 'react';

interface TourStep {
  target: string;       // CSS selector
  title: string;
  content: string;
  placement?: 'top' | 'bottom' | 'left' | 'right';
}

const DASHBOARD_TOUR: TourStep[] = [
  {
    target: '[data-tour="sidebar"]',
    title: 'Navigation',
    content: 'Use the sidebar to switch between modules.',
    placement: 'right',
  },
  {
    target: '[data-tour="quick-actions"]',
    title: 'Quick Actions',
    content: 'Create new items quickly from this toolbar.',
    placement: 'bottom',
  },
  {
    target: '[data-tour="help-button"]',
    title: 'Need Help?',
    content: 'Click here anytime to open the help panel.',
    placement: 'left',
  },
];

export function useOnboardingTour(tourId: string) {
  const storageKey = `tour_completed_${tourId}`;
  const [hasCompleted, setHasCompleted] = useState(() => {
    return localStorage.getItem(storageKey) === 'true';
  });

  const completeTour = () => {
    localStorage.setItem(storageKey, 'true');
    setHasCompleted(true);
  };

  const resetTour = () => {
    localStorage.removeItem(storageKey);
    setHasCompleted(false);
  };

  return { hasCompleted, completeTour, resetTour, steps: DASHBOARD_TOUR };
}
```

---

## ✍️ WRITING STYLE GUIDE

### Core Principles

| Principle | Do | Don't |
|-----------|-----|-------|
| **Plain language** | "Click the Save button" | "Actuate the persistence mechanism" |
| **Short sentences** | Max 20 words per sentence | Long compound sentences with multiple clauses |
| **Active voice** | "You can export data by..." | "Data can be exported by..." |
| **Task-oriented** | "How to invite a team member" | "Team Management Features" |
| **Second person** | "You will see a confirmation" | "The user will see a confirmation" |
| **Present tense** | "The dialog opens" | "The dialog will open" |

### Formatting Rules

1. **Use numbered steps** for sequential actions
2. **Use bullet lists** for non-sequential items
3. **Bold UI elements**: Click **Settings** > **Profile**
4. **Use code formatting** for values the user types: Enter `admin@example.com`
5. **One action per step** -- never combine two clicks in one step
6. **State expected outcomes** after each step: "A green checkmark appears."

### Words to Avoid

| Avoid | Use Instead |
|-------|-------------|
| Simply / Just / Easy | (remove it entirely) |
| Obviously / Clearly | (remove it entirely) |
| Please note that | (start with the note directly) |
| In order to | To |
| Utilize | Use |
| Navigate to | Go to |
| Prior to | Before |

> [!WARNING]
> **Never write "simply" or "just"** in user docs. If the user needed docs, it is not simple to them.

---

## 📄 HELP ARTICLE STRUCTURE

Every help article follows this template:

### Help Article Template

```markdown
# How to [Do the Thing]

> One-sentence description of what this guide covers and when you'd use it.

## Prerequisites

- [ ] You have [required permission/role]
- [ ] You have [prerequisite feature] set up ([link to that guide])

## Steps

### 1. [First action]

Go to **Module** > **Section**.

![Screenshot description](./images/step-1-screenshot.png)

### 2. [Second action]

Click **Button Name**. A confirmation dialog appears.

### 3. [Third action]

Enter the required information:

| Field | Description | Example |
|-------|-------------|---------|
| **Name** | Display name for the item | "Q1 Campaign" |
| **Status** | Initial status | Active |

Click **Save**.

## Expected Result

You should see [specific outcome]. The new item appears in [location].

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Button is grayed out | You need Admin role. Ask your workspace owner. |
| Error: "Name already exists" | Choose a unique name or archive the existing one. |

## Related Articles

- [How to edit an existing item](./edit-item.md)
- [How to set up permissions](./permissions.md)
```

---

## 🗂️ INFORMATION ARCHITECTURE

### Group by User Goal, Not by App Section

```text
BAD (feature-oriented):
  ├── Dashboard
  ├── Settings Panel
  ├── User Management
  └── Reports Module

GOOD (goal-oriented):
  ├── Getting Started
  │   ├── Create your account
  │   ├── Set up your workspace
  │   └── Invite your team
  ├── Managing Your Team
  │   ├── How to invite members
  │   ├── How to assign roles
  │   └── How to remove members
  ├── Working with Reports
  │   ├── How to create a report
  │   ├── How to schedule reports
  │   └── How to export to PDF
  └── Troubleshooting
      ├── Login issues
      ├── Permission errors
      └── Data sync problems
```

### Navigation Hierarchy

| Level | Example | Rule |
|-------|---------|------|
| **Category** | "Getting Started" | Max 6-8 categories |
| **Section** | "Managing Your Team" | Max 5-8 articles per section |
| **Article** | "How to invite members" | Max 500 words, one task per article |

---

## 🔍 SEARCH FUNCTIONALITY

Full-text search is non-negotiable. Users will search before they browse.

### Implementation Options

| Tool | Best For | Notes |
|------|----------|-------|
| **Algolia DocSearch** | External docs sites | Free for open source, fast |
| **Fuse.js** | In-app help panels | Client-side fuzzy search, zero dependencies |
| **Pagefind** | Static sites (Docusaurus) | Build-time index, extremely fast |
| **Typesense** | Self-hosted search | Open source, typo-tolerant |

### Search Quality Checklist

- [ ] Search indexes article titles, body text, and tags
- [ ] Typo tolerance enabled (user types "setings" finds "Settings")
- [ ] Results ranked by relevance, not alphabetically
- [ ] Search analytics tracked (see what users search for but don't find)
- [ ] "No results" page suggests popular articles or contact support

---

## 🎬 VIDEO VS TEXT

| Scenario | Format | Why |
|----------|--------|-----|
| Complex multi-step workflow (5+ steps) | Video | Easier to follow along |
| Initial product overview | Video | Sets mental model quickly |
| Quick reference ("what does X mean?") | Text | Scannable, searchable |
| Troubleshooting | Text | Users can ctrl+F the error message |
| Configuration/settings | Text + screenshots | Users need exact field names |
| API usage | Text + code blocks | Users copy-paste code |

> [!TIP]
> **Keep videos under 3 minutes.** If longer, split into a series. Always provide a text alternative for accessibility and searchability.

---

## 🔄 VERSIONING & MAINTENANCE

### Keep Docs in Sync with Releases

| Release Phase | Documentation Action |
|---------------|---------------------|
| Feature spec approved | Draft help article stub |
| Feature in development | Write first draft with dev screenshots |
| Feature in QA | Review and update screenshots |
| Feature shipped | Publish help article, update changelog |
| Feature changed | Update existing article, add "Updated" badge |
| Feature deprecated | Add deprecation notice, link to replacement |

### Version Tagging Strategy

```text
docs/
  ├── v2.0/           # Current version
  │   ├── getting-started.md
  │   └── features/
  ├── v1.0/           # Previous version (archived)
  │   ├── getting-started.md
  │   └── features/
  └── changelog.md    # All versions
```

---

## 📊 FEEDBACK LOOP

### "Was This Helpful?" Widget

Add to every help article. Track ratings to find docs that need improvement.

```tsx
// components/help/ArticleFeedback.tsx
import { useState } from 'react';

interface ArticleFeedbackProps {
  articleId: string;
  onSubmit: (articleId: string, helpful: boolean, comment?: string) => void;
}

export function ArticleFeedback({ articleId, onSubmit }: ArticleFeedbackProps) {
  const [submitted, setSubmitted] = useState(false);
  const [showComment, setShowComment] = useState(false);
  const [comment, setComment] = useState('');

  const handleVote = (helpful: boolean) => {
    if (helpful) {
      onSubmit(articleId, true);
      setSubmitted(true);
    } else {
      setShowComment(true);
    }
  };

  const handleCommentSubmit = () => {
    onSubmit(articleId, false, comment);
    setSubmitted(true);
  };

  if (submitted) {
    return (
      <div className="mt-8 rounded-md bg-gray-50 p-4 text-center text-sm text-gray-600">
        Thanks for your feedback!
      </div>
    );
  }

  return (
    <div className="mt-8 rounded-md border border-gray-200 p-4">
      <p className="text-sm font-medium text-gray-700 text-center">
        Was this article helpful?
      </p>
      <div className="mt-2 flex justify-center gap-3">
        <button
          onClick={() => handleVote(true)}
          className="rounded-md bg-green-50 px-4 py-2 text-sm text-green-700
                     hover:bg-green-100 border border-green-200"
        >
          Yes
        </button>
        <button
          onClick={() => handleVote(false)}
          className="rounded-md bg-red-50 px-4 py-2 text-sm text-red-700
                     hover:bg-red-100 border border-red-200"
        >
          No
        </button>
      </div>
      {showComment && (
        <div className="mt-3">
          <textarea
            value={comment}
            onChange={(e) => setComment(e.target.value)}
            placeholder="What was missing or unclear?"
            className="w-full rounded-md border border-gray-300 p-2 text-sm"
            rows={3}
          />
          <button
            onClick={handleCommentSubmit}
            className="mt-2 rounded-md bg-blue-600 px-4 py-2 text-sm text-white
                       hover:bg-blue-700"
          >
            Submit feedback
          </button>
        </div>
      )}
    </div>
  );
}
```

### Metrics to Track

| Metric | What It Tells You | Action Threshold |
|--------|-------------------|------------------|
| Helpful rating < 60% | Article is confusing or incomplete | Rewrite the article |
| Search with no results | Missing documentation topic | Create a new article |
| High bounce rate on article | Title is misleading or content doesn't match | Revise title and intro |
| Support tickets on documented topic | Users can't find the article | Improve search, add links |

---

## 🌐 INTERNATIONALIZATION (i18n) READINESS

Even if you are not translating now, structure your docs to support it later.

### Structure for Future Translation

```text
docs/
  ├── en/                    # English (default)
  │   ├── getting-started.md
  │   └── features/
  ├── es/                    # Spanish (future)
  │   ├── getting-started.md
  │   └── features/
  └── locales.json           # Language registry
```

### i18n Checklist

- [ ] All docs stored in a language-specific directory (`/en/`, `/es/`)
- [ ] No hardcoded strings in help panel UI components (use i18n keys)
- [ ] Screenshots are separate files (easy to replace per language)
- [ ] Date formats use locale-aware formatting
- [ ] Cultural references avoided (metaphors, idioms may not translate)
- [ ] Right-to-left (RTL) layout considered for Arabic/Hebrew

---

## ✅ EXIT CHECKLIST

- [ ] Getting started guide exists and covers first-use experience
- [ ] Top 10 features have documented "How to" articles
- [ ] Every help article follows the standard template (title, prerequisites, steps, expected result, troubleshooting, related)
- [ ] Search works across all documentation (typo-tolerant)
- [ ] "Was this helpful?" feedback mechanism on every article
- [ ] Information architecture is goal-oriented, not feature-oriented
- [ ] In-app contextual help added to complex UI elements
- [ ] Screenshots are current and match the live product
- [ ] Documentation versioning strategy defined
- [ ] Feedback metrics are tracked and reviewed monthly

---

*Skill Version: 1.0 | Created: February 2026*
