---
name: Navigation & Search UX
description: Design navigation structures, search interfaces, filtering, sorting, breadcrumbs, and pagination systems that help users find what they need without thinking
---

# Navigation & Search UX

**Purpose**: 30-50% of users on content-heavy sites use search as their primary navigation method. This skill covers every aspect of wayfinding — navigation patterns, search UX, autocomplete, filtering, sorting, breadcrumbs, and pagination — with prescriptive rules for each.

---

## TRIGGER COMMANDS

```text
"Design navigation for [product]"
"Improve search UX on [site]"
"Users can't find things on [page]"
"Add filtering to [feature]"
"Should we use pagination or infinite scroll for [list]?"
"Using navigation_search_ux skill: [target]"
```

---

## WHEN TO USE

- Designing navigation for a new product
- Users report they can't find things
- Search exists but returns poor results or has no autocomplete
- Lists have grown beyond 20+ items without filtering
- Mobile navigation needs a rethink
- Breadcrumbs are missing from deep hierarchies

---

## 1. NAVIGATION PATTERNS

### Pattern Selection Matrix

| Pattern            | Best For                    | Max Items | Avoid When                   |
|--------------------|-----------------------------|-----------|------------------------------|
| **Top nav bar**    | Marketing sites, SaaS apps  | 5-7       | Too many sections to fit     |
| **Mega menu**      | eCommerce, content-heavy    | 20+ organized | Simple sites with few pages |
| **Sidebar**        | Dashboards, admin, docs     | 15-20 grouped | Consumer marketing sites   |
| **Tab bar (bottom)**| Mobile apps                | 3-5       | Desktop, 6+ items            |
| **Breadcrumbs**    | Deep hierarchies, eCommerce | N/A       | Flat sites (1-2 levels)      |
| **Hamburger menu** | Mobile overflow, secondary  | Any       | Primary desktop navigation   |
| **Command palette**| Power users, dev tools      | Any       | Consumer products            |

### Top Nav Bar Rules

```
Items:          5-7 max at top level
Logo:           Left-aligned, links to home — always
Active state:   Current section visually highlighted (bold, underline, or color)
Dropdowns:      Show on hover with 200ms delay, close on mouse-leave with 300ms delay
Sticky:         Stick to top on scroll for sites with long pages
Mobile:         Collapse to hamburger at breakpoint (typically 768px)
CTA:            Right-most item is the primary CTA (Sign up, Get started)
```

### Sidebar Nav Rules

```
Width:          200-280px (collapsible to 48-64px icon-only)
Grouping:       Use section headers to group related items (max 5 groups)
Nesting:        Max 2 levels of nesting (parent → child, never grandchild)
Active state:   Background highlight + bold text on current item
Collapse:       Allow user to collapse sidebar for more content space
Icons:          Every top-level item has an icon (aids scanning in collapsed mode)
Overflow:       Scrollable section if items exceed viewport height
```

### Bottom Tab Bar Rules (Mobile)

```
Items:          3-5 tabs only — never more than 5
Labels:         Always show text labels under icons (icon-only is ambiguous)
Active tab:     Filled icon + colored label, inactive = outline icon + gray label
Center tab:     Optional FAB (floating action button) for primary action
Thumb reach:    Bottom placement = natural thumb zone
Badge:          Notification dots for unread counts (max "99+")
```

### Anti-patterns

```
[ ] Hamburger as primary desktop nav — hides discoverability, reduces engagement 20-30%
[ ] More than 7 top-level items — overwhelms scanning
[ ] Labels that don't match page titles — breaks user trust
[ ] Dropdowns that close on cursor movement between trigger and menu
[ ] No visual indicator of current page — users feel lost
[ ] Different nav structure on different pages — destroys consistency
[ ] Navigation that scrolls away with no sticky option
```

---

## 2. NAVIGATION HIERARCHY

### Four Navigation Layers

| Layer              | Purpose                           | Location                      | Examples                          |
|--------------------|-----------------------------------|-------------------------------|-----------------------------------|
| **Primary nav**    | Main product sections             | Top bar or sidebar            | Dashboard, Projects, Settings     |
| **Secondary nav**  | Sub-sections within a section     | Sub-nav bar, sidebar children | Project list, Project settings    |
| **Utility nav**    | Account and system functions      | Top-right corner              | Profile, Notifications, Help      |
| **Footer nav**     | Legal, secondary links, discovery | Page footer                   | Privacy, Terms, Status, Careers   |

### Primary Nav Guidelines

```
Contains:      The 5-7 most important sections of your product
Label style:   Noun-based ("Projects", "Dashboard") or action-based ("Create", "Analyze")
Consistency:   Identical on every page — never changes
Highlight:     Current section is always visually active
```

### Utility Nav Guidelines

```
Position:      Top-right (desktop), accessible from hamburger (mobile)
Contains:      User avatar/profile, notifications bell, help/support, settings
Order:         Search → Notifications → Help → Profile (left to right)
Notification:  Red badge with unread count, dismiss on view
```

### Footer Nav Guidelines

```
Contains:      Legal links, company info, social links, status page, sitemap
Purpose:       Catch-all for important-but-not-primary pages
Columns:       Organized into 3-5 columns with headers
Links:         Plain text, no icons needed
Copyright:     Bottom row with year and company name
```

---

## 3. SEARCH UX

### Search Box Design

```
Position:       Always visible in header (NOT hidden behind an icon on desktop)
Width:          Minimum 30 characters visible (expand on focus to 50+)
Placeholder:    "Search [domain]..." — be specific: "Search docs" not "Search"
Icon:           Magnifying glass LEFT of input (standard affordance)
Shortcut:       Cmd+K / Ctrl+K for keyboard users — show hint near search box
Clear button:   X button appears inside the field when text is entered
Submit:         Enter key triggers search (no separate search button needed)
```

### When to Make Search Prominent

```
< 20 items total:     Search optional, browsing is fine
20-100 items:         Search visible but secondary to navigation
100-1000 items:       Search prominent, equal to navigation
1000+ items:          Search DOMINANT — it's the primary navigation method
```

### Minimum Viable Search Features

```
MUST have:
  [ ] Visible search input in header
  [ ] Keyword matching in titles and content
  [ ] Results page with title + snippet + metadata
  [ ] Zero results state with recovery paths

SHOULD have:
  [ ] Autocomplete suggestions (5-8 results)
  [ ] Typo tolerance / fuzzy matching
  [ ] Recent searches on focus
  [ ] Keyboard navigation (arrow keys, Enter, Escape)

NICE to have:
  [ ] Search analytics (what users search for)
  [ ] Faceted filtering on results
  [ ] Promoted/featured results
  [ ] Search within results (refinement)
```

---

## 4. AUTOCOMPLETE & SUGGESTIONS

### Behavior Specification

```
Trigger:         After 2 characters typed (not on first character — too noisy)
Debounce:        250-350ms after last keystroke before querying
Max results:     5-8 suggestions (more is overwhelming, fewer feels empty)
Highlight:       Bold the matching portion of each suggestion
Categories:      Group by type if mixed: Products | Docs | People | Settings
Loading:         Show subtle spinner after 500ms if results haven't loaded
Empty:           "No suggestions for '[query]'" with link to full search
```

### Suggestion Types (Priority Order)

```
1. Exact matches:     Items that start with the typed query
2. Contains matches:  Items that contain the query anywhere
3. Recent searches:   User's own recent queries (show on empty focus)
4. Popular searches:  Trending queries from all users (cold start)
5. Category matches:  Matching categories or sections, not just items
```

### Keyboard Navigation

```
Arrow Down:    Move to next suggestion (from input → first result)
Arrow Up:      Move to previous suggestion (from first result → input)
Enter:         Select highlighted suggestion OR submit typed query
Escape:        Close suggestions, keep typed text
Tab:           Accept top suggestion (optional, not standard)
```

### Result Formatting

```
Each suggestion line:
  [Icon/Type]  [Title with bold match]  [Secondary text: category or path]

Example:
  [Doc icon]   **Authen**tication Guide    Docs > Security
  [API icon]   **Authen**ticate endpoint   API Reference
  [User icon]  Sarah **Authen**berg        Team members
```

### Anti-patterns

```
[ ] Autocomplete triggers on first character (too noisy, irrelevant results)
[ ] No debounce — fires a request on every keystroke
[ ] Results don't highlight the matching text
[ ] No keyboard navigation — mouse-only interaction
[ ] Suggestions cover the search input — user can't see what they typed
[ ] Suggestions persist after clicking away
[ ] More than 10 suggestions — becomes a scrollable list, not quick suggestions
```

---

## 5. FILTERING & FACETED SEARCH

### When to Add Filters

```
< 20 items:      No filters needed — scanning is faster
20-50 items:     1-3 basic filters (category, status, date)
50-200 items:    3-5 filters with faceted counts
200+ items:      Full faceted search with multiple filter types
```

### Filter Types

| Type            | UI Control       | Best For                          | Example                    |
|-----------------|------------------|-----------------------------------|----------------------------|
| **Single select**| Radio / dropdown| Mutually exclusive categories     | Status: Active / Archived  |
| **Multi select** | Checkboxes      | Non-exclusive categories          | Tags: Design, Dev, Marketing|
| **Range**       | Slider / inputs  | Numeric values                    | Price: $10 - $50           |
| **Date range**  | Date picker pair | Time-based content                | Created: Jan 1 - Mar 31   |
| **Toggle**      | Switch           | Boolean attributes                | Show archived: on/off      |
| **Text search** | Search input     | Filtering within a specific field | Filter by name             |

### Filter Layout

```
DESKTOP:
  Position:       Left sidebar (240-280px wide)
  Default:        Show 3-5 most-used filters expanded
  Overflow:       "Show more filters" accordion for the rest
  Active:         Show active filters as removable chips ABOVE the results
  Count:          Show matching result count per filter option
  Real-time:      Update results instantly as filters change — no "Apply" button
  Reset:          "Clear all filters" link always visible when any filter is active

MOBILE:
  Position:       Full-screen filter drawer triggered by "Filter" button
  Apply button:   Required on mobile (real-time updates are jarring on small screens)
  Active count:   "Filter (3)" badge showing number of active filters
  Quick filters:  Horizontal scrolling chips above results for top 3-4 filters
```

### Active Filter Display

```
Show as removable chips above the results list:
  [Category: Design ×]  [Status: Active ×]  [Date: Last 7 days ×]  [Clear all]

Each chip:
  Shows the filter name + value
  Has a visible × to remove that single filter
  Removing updates results instantly
```

### Anti-patterns

```
[ ] Showing all 20+ filter options expanded at once — overwhelming
[ ] Filters that can produce zero results with no warning
[ ] No way to see or remove active filters (users lose track)
[ ] Requiring an "Apply" button on desktop (slows exploration)
[ ] Filters that reset when navigating away and coming back
[ ] No result count per filter option (users guess blindly)
```

---

## 6. SORTING

### Default Sort by Content Type

| Content Type        | Default Sort      | Rationale                              |
|---------------------|-------------------|----------------------------------------|
| Search results      | Relevance         | Most likely to match user intent       |
| News / blog         | Newest first      | Freshness matters most                 |
| Products            | Featured/Popular  | Best sellers drive revenue             |
| Tasks / tickets     | Priority then date| Urgency matters most                   |
| Files / documents   | Last modified     | Recent work is most relevant           |
| People / directory  | Alphabetical      | Predictable scanning                   |
| Transactions        | Most recent first | Users check latest activity            |

### Sort UI Rules

```
Position:       Top-right of the list, next to result count
Format:         "Sort by: [Dropdown]" with clear current selection
Options:        3-7 sort options max (more is rarely useful)
Direction:      Include ascending/descending toggle for numeric sorts
Persistence:    Remember the user's sort preference across sessions
URL param:      Encode sort in URL so it's shareable: ?sort=price_asc
```

### Sort + Filter Interaction

```
1. Filters narrow the dataset first
2. Sort orders the filtered results
3. Changing a filter does NOT reset the sort
4. Changing sort does NOT reset filters
5. "Clear all" resets both filters AND sort to defaults
6. Show result count: "47 results sorted by Price (low to high)"
```

---

## 7. BREADCRUMBS & WAYFINDING

### When to Use Breadcrumbs

```
USE when:
  - Site has 3+ levels of hierarchy
  - Users navigate deep into nested content
  - Users need to jump back to parent sections
  - eCommerce with category > subcategory > product

DON'T use when:
  - Site is flat (1-2 levels only)
  - User flow is linear (wizard/checkout — use step indicators instead)
  - Single-page applications with no hierarchy
```

### Breadcrumb Types

| Type          | Shows                          | Best For                    |
|---------------|--------------------------------|-----------------------------|
| **Location**  | Where user IS in the hierarchy | eCommerce, documentation    |
| **Path**      | How user GOT there             | Complex search + browse flows|
| **Attribute** | Current filters/selections     | Faceted navigation          |

### Breadcrumb Rules

```
Separator:       > or / between levels (> is more common)
Current page:    Shown as plain text (not a link) — last item
All others:      Clickable links
Home:            Always the first item (use "Home" or house icon)
Truncation:      For 4+ levels, show: Home > ... > Parent > Current
Position:        Top of content area, below header, above page title
Font size:       Smaller than body text (12-14px) — secondary navigation
```

### Step Indicators (Linear Flows)

```
Use INSTEAD of breadcrumbs for linear multi-step flows:

  Step 1        Step 2        Step 3        Step 4
  Details    → Shipping   → Payment     → Review
  [complete]   [complete]   [current]     [upcoming]

Rules:
  Completed steps:  Checkmark, clickable to go back
  Current step:     Bold/highlighted, not clickable
  Upcoming steps:   Gray, not clickable
  Step count:       "Step 3 of 4" shown alongside
  Max steps:        7 visible steps — more than 7 means the flow is too complex
```

---

## 8. PAGINATION VS INFINITE SCROLL VS LOAD MORE

### Decision Matrix

| Content Type            | Pattern              | Rationale                                |
|-------------------------|----------------------|------------------------------------------|
| Social feed             | Infinite scroll      | Browsing, no specific target             |
| Search results          | Load more button     | User controls pace, can reach footer     |
| eCommerce catalog       | Pagination           | Users want to bookmark page 3, compare   |
| Blog / articles         | Load more button     | Lightweight browsing with footer access  |
| Dashboard tables        | Pagination           | Users need specific rows, want page size |
| Image gallery           | Infinite scroll      | Visual browsing, no specific target      |
| Documentation search    | Pagination           | Users need stable references             |
| Activity log / history  | Load more button     | Chronological browsing with footer       |

### Pagination Rules

```
Position:        Below the list, centered
Items per page:  10, 25, 50, 100 (let user choose)
Default:         25 items for tables, 12-20 for cards
Current page:    Highlighted, not clickable
Page range:      Show: < 1 2 3 ... 8 9 10 > (truncate middle for large sets)
Keyboard:        Left/Right arrows for prev/next page
URL:             Encode page in URL: ?page=3 (shareable, bookmarkable)
Result count:    "Showing 26-50 of 847 results"
```

### Infinite Scroll Rules

```
Loading trigger:  Load next batch when user scrolls within 200px of bottom
Batch size:       20-50 items per load
Loading state:    Skeleton items or spinner at bottom during load
End state:        "You've reached the end" message (don't load indefinitely)
Back button:      Preserve scroll position when user navigates away and returns
Performance:      Virtualize the list — don't keep 10,000 DOM nodes in memory
Footer problem:   Users can never reach the footer — move footer links to nav
```

### Load More Button Rules

```
Position:        Centered below the list
Label:           "Load more [items]" with count: "Load 25 more results"
Loading state:   Button shows spinner, disabled during load
Remaining count: "Load more (325 remaining)"
URL:             Optionally encode offset: ?offset=50
Advantage:       User controls pace + footer is always reachable
```

### Anti-patterns

```
[ ] Infinite scroll with no end indicator — users feel trapped
[ ] Pagination without page size options on data tables
[ ] Losing scroll position on back-button navigation
[ ] No result count shown — user can't gauge scope
[ ] Infinite scroll that breaks the back button
[ ] Load more that reloads the entire page instead of appending
[ ] Numbered pagination on mobile (tap targets too small)
```

---

## EXIT CRITERIA

```
[ ] Navigation pattern matches product type (top bar, sidebar, bottom tabs)
[ ] Max 7 items at top navigation level
[ ] Current page/section is visually indicated with active state
[ ] Navigation is consistent across all pages
[ ] All four nav layers addressed (primary, secondary, utility, footer)
[ ] Search is visible in the header (not hidden behind icon on desktop)
[ ] Autocomplete appears after 2 characters with 250-350ms debounce
[ ] Autocomplete shows 5-8 suggestions with bold match highlighting
[ ] Zero results state has recovery paths (suggestions, spelling, browse link)
[ ] Filters available for lists with 20+ items
[ ] Active filters shown as removable chips with clear-all option
[ ] Default sort is appropriate for content type
[ ] Sort and filter don't reset each other
[ ] Breadcrumbs present for hierarchies with 3+ levels
[ ] Linear flows use step indicators instead of breadcrumbs
[ ] Pagination pattern matches content type (scroll, load more, or pages)
[ ] Mobile nav is thumb-reachable (bottom tab bar, 3-5 items)
[ ] Keyboard navigation works throughout (Tab, Enter, Escape, Cmd+K)
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: NNGroup search UX research, Baymard Institute eCommerce UX, Material Design navigation guidelines*
