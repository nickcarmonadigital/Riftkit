---
name: Visual Hierarchy Mastery
description: Master visual hierarchy, typography, spacing, color theory, shadows, and signifiers to create professional UI designs
---

# Visual Hierarchy Mastery

**Purpose**: Apply core UI/UX design principles — visual hierarchy, typography, spacing, color theory, dark mode, shadows, icons, states, micro interactions, and overlays — to create polished, professional interfaces.

**Source**: Synthesized from Kole Jain's "Every UI/UX Concept Explained in Under 10 Minutes" + industry best practices.

---

## TRIGGER COMMANDS

```text
"Apply visual hierarchy to [page/component]"
"Fix the typography on [page]"
"Improve spacing and layout for [component]"
"Apply color theory to [design]"
"Design dark mode for [feature]"
"Using visual_hierarchy_mastery skill: [target]"
```

---

## WHEN TO USE

- Designing any new UI from scratch
- When a design "works but looks flat" or amateurish
- Before ui_polish, to establish proper foundations
- When a client says "make it look more professional"
- When converting wireframes to high-fidelity designs

---

## 1. AFFORDANCES & SIGNIFIERS

Every UI element must communicate what it does without instructions.

### Key Signifiers
- **Container grouping**: Items inside a shared container are perceived as related
- **Selection states**: Highlighted/active container = currently selected
- **Disabled states**: Grayed out text/elements = inactive, non-clickable
- **Button press states**: Visual feedback on hover, active, pressed
- **Active nav highlights**: Current page/section clearly indicated
- **Hover states**: Color/shadow change on mouseover
- **Tooltips**: Explanatory text on hover for ambiguous icons

### Checklist
```
[ ] Every interactive element has a visible hover state
[ ] Selected items are visually distinct from unselected
[ ] Disabled elements are visually grayed/dimmed
[ ] Related elements are visually grouped (containers, spacing)
[ ] Icons have tooltips when meaning isn't obvious
[ ] Buttons have press/active states
[ ] Navigation shows current location
```

---

## 2. VISUAL HIERARCHY

The art of directing the user's eye to what matters most.

### Three Tools of Hierarchy
1. **Size**: Bigger = more important
2. **Position**: Higher/first = more important
3. **Color**: Bolder/contrasting = more important

### Card Design Pattern (Example)
```
WRONG: All text same size, same weight, same color = spreadsheet

RIGHT:
  [Image — full width, adds color pop, enables scanning]
  Item Name — large, bold, top position
  $Price — top-right, colored (blue), draws eye
  [icon] Origin → Destination [icon] — visual line between locations
  Date/Time — smaller, below, less important
```

### Rules
- Most important content goes near the top
- Bigger and more colorful = more important
- Use contrast (small vs big, colorful vs muted) to create hierarchy
- Images enable instant visual scanning — use whenever possible
- Similar patterns recur: labels, buttons, cards — learn the patterns

### Checklist
```
[ ] Primary content is largest and most prominent
[ ] Secondary content is visually subordinate (smaller, lighter)
[ ] Eye flow follows logical reading order (top-left to bottom-right in LTR)
[ ] Color is used to draw attention to key actions (CTAs, prices, alerts)
[ ] Images are used to break up text and aid scanning
[ ] No two competing elements fight for attention at the same level
```

---

## 3. GRIDS, LAYOUTS & SPACING

### Grid Reality Check
- 12-column grids are **guidelines**, not requirements
- Custom landing pages often don't align to grids at all
- Grids are most useful for **structured, repeating content** (galleries, blogs, dashboards)

### Responsive Grid Guidance
| Device    | Columns | Usage                              |
|-----------|---------|------------------------------------|
| Desktop   | 12      | Full layouts, multi-column content |
| Tablet    | 8       | Responsive collapse                |
| Mobile    | 4       | Single-column stacking             |

### White Space (Most Important)
White space > rigid grids. Let elements breathe.

### The 4-Point Grid System
All spacing values should be multiples of 4px:
```
4px  — tight (icon-to-label)
8px  — compact (within groups)
16px — standard (between elements)
24px — comfortable (between sections within a group)
32px — spacious (between groups/sections)
48px — generous (major section breaks)
64px — hero-level (top-level section separation)
```

Why multiples of 4: You can always split in half and maintain consistency.

### Grouping Principle
- Elements that belong together should have **less space** between them
- Elements that are separate should have **more space** between them
- Example: Headline + subtext = 8px gap. Section to section = 48px gap.

### Checklist
```
[ ] All spacing values are multiples of 4px
[ ] Related elements are grouped with tighter spacing
[ ] Unrelated sections have generous breathing room
[ ] Content never touches container edges (proper padding)
[ ] Responsive behavior degrades gracefully (12 → 8 → 4 columns)
[ ] White space is used intentionally, not just "empty space"
```

---

## 4. TYPOGRAPHY & FONT SIZING

### Font Selection
You almost never need more than ONE font family. Recommended sans-serif fonts:
- Inter, Plus Jakarta Sans, DM Sans, Geist
- Manrope, Space Grotesk, Sora
- Work Sans, Public Sans, Nunito Sans

### The Typography "Hack"
For large heading text:
1. **Letter spacing**: Tighten to -2% to -3%
2. **Line height**: Drop to 110-120%
3. Result: Instantly more professional, tighter headlines

### Font Size Ranges

**Landing Pages / Marketing Sites:**
```
Hero heading:    48-80px (bold, tight letter-spacing)
Section heading: 32-48px
Subheading:      24-32px
Body:            16-18px
Caption/meta:    12-14px
Max 6 font sizes total
```

**Dashboards / Data-Dense UIs:**
```
Page title:      20-24px (rarely larger)
Section header:  16-18px
Body/data:       13-14px
Labels/meta:     11-12px
Range is much narrower due to information density
```

### Body Text Rules
```
Line height: 1.4-1.6 for body text
Font weight: 400 for body, 500-700 for headings
Max width:   60-75 characters per line for readability
```

### Checklist
```
[ ] Using one font family (two max with clear purpose)
[ ] Heading letter-spacing is tightened (-2% to -3%)
[ ] Heading line-height is reduced (110-120%)
[ ] No more than 6 font sizes in the design
[ ] Body text line-height is 1.4-1.6
[ ] Font sizes match context (marketing vs dashboard)
[ ] Text truncation is handled (ellipsis, line clamp)
```

---

## 5. COLOR THEORY

### Starting Point: One Primary Color
1. Pick your brand/primary color
2. Lighten it for backgrounds
3. Darken it for text colors
4. Build out a full color ramp from this seed

### Color Ramp Construction
From your primary, create:
```
50:  Lightest tint (backgrounds, subtle fills)
100: Light tint
200: Soft accent
300: Medium-light
400: Medium
500: Primary (your brand color)
600: Medium-dark
700: Dark accent
800: Deep
900: Darkest shade (text-on-light)
```

### Semantic Colors
Colors with meaning — use intentionally:
| Color  | Meaning                    | Use Cases                          |
|--------|----------------------------|------------------------------------|
| Blue   | Trust, information         | Links, primary CTAs, info alerts   |
| Red    | Danger, urgency            | Errors, delete actions, warnings   |
| Yellow | Warning, caution           | Warning alerts, pending states     |
| Green  | Success, positive          | Success messages, online status    |
| Gray   | Neutral, disabled          | Disabled states, secondary text    |

### Rule
**Use color for purpose, not decoration.** Every color should signify something.

### Checklist
```
[ ] Primary brand color is established
[ ] Color ramp with 50-900 shades exists
[ ] Semantic colors (success, error, warning, info) are defined
[ ] Colors are used purposefully, not decoratively
[ ] Sufficient contrast ratios (WCAG AA: 4.5:1 for text)
[ ] No more than 3-4 distinct hue families in the palette
```

---

## 6. DARK MODE DESIGN

Dark mode is not just "invert the colors." It requires specific adjustments.

### Key Differences from Light Mode

| Aspect     | Light Mode               | Dark Mode                        |
|------------|--------------------------|----------------------------------|
| Borders    | Can be strong/dark       | Must be subtle, low contrast     |
| Depth      | Created with shadows     | Created with surface brightness  |
| Cards      | Same or lighter than bg  | Must be LIGHTER than background  |
| Chips/tags | Bright fills work        | Dim saturation + brightness      |
| Chip text  | Dark text on light fill  | Light text on dim fill           |

### Dark Mode Rules
1. **Lower border contrast** — light borders create too much contrast in dark mode
2. **Cards lighter than background** — this creates depth (no shadows available)
3. **Dim bright colors** — reduce saturation and brightness for chips, badges, accents
4. **Background flexibility** — dark doesn't mean gray/navy only: deep purples, dark reds, dark greens all work

### Surface Elevation (Dark Mode)
```
Background:    #0a0a0a - #121212
Surface 1:     +3-5% lighter (cards, containers)
Surface 2:     +5-8% lighter (popovers, modals)
Surface 3:     +8-12% lighter (tooltips, menus)
```

### Checklist
```
[ ] Borders are subtle and low-contrast
[ ] Cards are lighter than the page background
[ ] Bright accent colors are desaturated/dimmed
[ ] Chip/badge text contrasts with its dimmed background
[ ] Depth is communicated via surface brightness, not shadows
[ ] Background color has character (not just #000 or #1a1a1a)
```

---

## 7. SHADOWS

### Shadow Rules
- **Default shadows are almost always too strong** — reduce opacity and increase blur
- Shadows should NOT be the first thing you notice in a design
- Lower-elevation content (cards) needs subtle shadows
- Higher-elevation content (popovers, modals) needs stronger shadows

### Shadow Recipes
```css
/* Card shadow — subtle */
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08), 0 1px 2px rgba(0, 0, 0, 0.06);

/* Elevated card — medium */
box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0, 0, 0, 0.06);

/* Popover/dropdown — strong */
box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12), 0 4px 10px rgba(0, 0, 0, 0.08);

/* Raised tactile button (inner + outer) */
box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1), inset 0 1px 0 rgba(255, 255, 255, 0.1);
```

### Shadow Hierarchy
```
Flat content:      No shadow or very subtle
Cards:             Light shadow
Dropdowns:         Medium shadow
Modals/dialogs:    Strong shadow
```

### Checklist
```
[ ] Shadows are not the first thing you notice
[ ] Shadow strength matches elevation level
[ ] Opacity is reduced from defaults (usually 0.06-0.12)
[ ] Blur radius is increased for softer appearance
[ ] Dark mode uses surface brightness instead of shadows
```

---

## 8. ICONS & BUTTONS

### Icon Sizing Rule
Match icon size to the line-height of adjacent text:
```
Body text (16px, line-height: 24px) → Icon: 24px
Small text (14px, line-height: 20px) → Icon: 20px
Large heading (24px, line-height: 32px) → Icon: 32px
```

Most icons are **too large** by default. Size them to match text line-height.

### Button Types
| Type      | Style                              | Usage                           |
|-----------|------------------------------------|---------------------------------|
| Primary   | Filled background + contrast text  | Main CTA, submit, save          |
| Secondary | Border only (ghost/outline)        | Secondary action beside primary |
| Ghost     | No border until hover              | Navigation links, sidebar items |
| Icon-only | Icon without text                  | Toolbar actions, close buttons  |

### Button Padding Rule
**Double the height for the width padding:**
```
Height padding: 12px → Width padding: 24px
Height padding: 16px → Width padding: 32px
```

### Button Variants
- With icon + text
- Text only
- Icon only
- Loading state (spinner replaces text/icon)

---

## 9. STATES & FEEDBACK

**Rule: When a user does ANYTHING, there must be a response.**

### Required Button States (minimum 4)
```
1. Default   — resting appearance
2. Hover     — cursor over, slight visual change
3. Active    — pressed/clicked, compressed appearance
4. Disabled  — grayed out, non-interactive
5. Loading   — spinner, indicates processing (optional but recommended)
```

### Required Input States
```
1. Default   — empty, unfocused
2. Focus     — clicked in, visible focus ring/border
3. Filled    — has content, normal appearance
4. Error     — red border + error message below
5. Warning   — yellow/orange border + warning message (optional)
6. Disabled  — grayed out, non-editable
```

### General Feedback Patterns
```
Data fetching     → Loading spinner or skeleton
Action completes  → Success message or toast
Error occurs      → Error message with recovery option
Scroll/swipe      → Micro animations for feedback
Empty state       → Helpful message + CTA
```

### Checklist
```
[ ] Every button has default, hover, active, disabled states
[ ] Every input has default, focus, error states minimum
[ ] Loading states exist for all async operations
[ ] Success/error feedback is shown after actions
[ ] Empty states are handled with helpful messages
```

---

## 10. MICRO INTERACTIONS

Micro interactions are small animations/feedback that confirm user actions and add delight.

### Examples
- Copy button → "Copied!" chip slides up confirming the action
- Add to cart → Item count badge bounces
- Like button → Heart fills with animation
- Toggle switch → Smooth slide with color transition
- Form submit → Button transforms to checkmark

### Spectrum
```
Practical ←————————————————→ Playful
Copied toast    Smooth transitions    Confetti on success
Error shake     Hover lift effects    Animated mascots
```

### Implementation Tips
```css
/* Smooth hover lift */
.card {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

/* Button press feedback */
.button:active {
  transform: scale(0.97);
}

/* Smooth section reveal on scroll */
.reveal {
  opacity: 0;
  transform: translateY(20px);
  transition: all 0.6s ease-out;
}
.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
```

---

## 11. OVERLAYS & GRADIENTS

When placing text over images, you must ensure readability.

### Overlay Techniques (Best to Worst)
1. **Progressive blur** on top of gradient — most modern, premium look
2. **Linear gradient** — image fades smoothly into solid background for text
3. **Full-screen overlay** — works but hides the image too much
4. **No overlay** — ruins both the image and the text

### Gradient Recipe
```css
/* Linear gradient overlay */
background: linear-gradient(
  to bottom,
  transparent 0%,
  rgba(0, 0, 0, 0.7) 100%
);

/* Progressive blur (modern) */
backdrop-filter: blur(20px);
mask-image: linear-gradient(to bottom, transparent, black);
```

---

## EXIT CRITERIA

```
[ ] All interactive elements have proper signifiers (hover, active, disabled)
[ ] Visual hierarchy is clear — eye naturally flows to most important content
[ ] Spacing follows 4px grid with intentional grouping
[ ] Typography uses 1 font, tightened headings, max 6 sizes
[ ] Colors are purposeful with semantic meaning
[ ] Dark mode (if applicable) follows dark mode rules
[ ] Shadows are subtle and match elevation
[ ] Icons match text line-height
[ ] Buttons have all required states
[ ] Micro interactions confirm user actions
[ ] Text overlays on images are readable
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: Kole Jain video + industry best practices*
