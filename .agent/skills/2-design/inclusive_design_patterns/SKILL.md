---
name: Inclusive Design Patterns
description: Inclusive design covering cognitive accessibility, multilingual UX, color contrast, motion sensitivity, and universal usability
---

# Inclusive Design Patterns Skill

**Purpose**: Guide teams in designing products that work for the widest range of people, covering cognitive accessibility, multilingual experiences, sensory considerations, and designing for permanent, temporary, and situational disabilities.

---

## TRIGGER COMMANDS

```text
"Design for cognitive accessibility"
"Implement multilingual UX"
"Handle motion sensitivity in the UI"
"Make this design more inclusive"
"Using inclusive_design_patterns skill: [task]"
```

---

## The Inclusive Design Spectrum

Every disability exists on a spectrum: permanent, temporary, and situational.

| Sense | Permanent | Temporary | Situational |
|-------|-----------|-----------|-------------|
| Vision | Blind, low vision | Eye surgery recovery | Bright sunlight glare |
| Motor | Limb difference | Broken arm | Holding a baby |
| Hearing | Deaf | Ear infection | Noisy environment |
| Cognitive | Learning disability | Concussion | Stress, sleep deprivation |
| Speech | Non-verbal | Laryngitis | Heavy accent in foreign country |

> Designing for the permanent case benefits everyone on the spectrum.

---

## Cognitive Accessibility

### Principles

1. **Reduce cognitive load** -- fewer choices, clearer hierarchy
2. **Support memory** -- save progress, show history, provide defaults
3. **Be predictable** -- consistent patterns, no surprises
4. **Allow time** -- no auto-timeouts without warning, generous deadlines
5. **Prevent errors** -- confirmation steps, undo, clear validation

### Content Guidelines

| Principle | Do | Don't |
|-----------|-----|-------|
| Reading level | Write at grade 8 level or below | Use jargon, complex sentences |
| Instructions | One step at a time | Multi-step paragraphs |
| Error messages | "Email must include @" | "Invalid input" |
| Labels | "Save and continue" | "Submit" |
| Numbers | "About 5 minutes" | "Approximately 300 seconds" |
| Progress | "Step 2 of 4" | No progress indication |

### Cognitive Load Patterns

```
PROGRESSIVE DISCLOSURE
Show only what is needed at each step.

Step 1: Basic info
  ┌─────────────────────────────┐
  │ What is your name?          │
  │ [________________]          │
  │                 [Continue]  │
  └─────────────────────────────┘

Step 2: Details (only after step 1)
  ┌─────────────────────────────┐
  │ What is your email?         │
  │ [________________]          │
  │          [Back] [Continue]  │
  └─────────────────────────────┘
```

### Form Patterns for Cognitive Accessibility

```html
<!-- Clear labels, help text, and error prevention -->
<form>
  <div class="form-group">
    <label for="dob">Date of birth</label>
    <div class="input-group">
      <input type="text" id="dob-month" placeholder="MM" maxlength="2"
             aria-label="Month" inputmode="numeric" style="width: 3em" />
      <span aria-hidden="true">/</span>
      <input type="text" id="dob-day" placeholder="DD" maxlength="2"
             aria-label="Day" inputmode="numeric" style="width: 3em" />
      <span aria-hidden="true">/</span>
      <input type="text" id="dob-year" placeholder="YYYY" maxlength="4"
             aria-label="Year" inputmode="numeric" style="width: 5em" />
    </div>
    <p class="help-text" id="dob-help">For example: 03/15/1990</p>
  </div>
</form>
```

---

## Color and Contrast

### Color Palette Design

```
PRIMARY PALETTE (must pass contrast checks)

Background    Text          Ratio    Passes
#FFFFFF       #1F2937       15.4:1   AAA
#F3F4F6       #1F2937       13.5:1   AAA
#1F2937       #FFFFFF       15.4:1   AAA
#2563EB       #FFFFFF        4.6:1   AA

NEVER rely on color alone to convey meaning:

BAD:  ● Red = Error  ● Green = Success
GOOD: ● Red  [X] Error   ● Green  [check] Success
      (color + icon + text)
```

### Color-Blind Safe Patterns

```css
/* Use patterns/icons in addition to color */
.status-error {
  color: #DC2626;
  border-left: 4px solid #DC2626;
}
.status-error::before {
  content: "\26A0"; /* Warning triangle */
  margin-right: 8px;
}

.status-success {
  color: #059669;
  border-left: 4px solid #059669;
}
.status-success::before {
  content: "\2713"; /* Checkmark */
  margin-right: 8px;
}

/* Chart patterns for color-blind users */
.chart-series-1 { stroke-dasharray: none; }      /* Solid */
.chart-series-2 { stroke-dasharray: 8 4; }       /* Dashed */
.chart-series-3 { stroke-dasharray: 2 2; }       /* Dotted */
.chart-series-4 { stroke-dasharray: 12 4 2 4; }  /* Dash-dot */
```

### Dark Mode Considerations

| Element | Light Mode | Dark Mode | Notes |
|---------|-----------|-----------|-------|
| Background | #FFFFFF | #121212 | Not pure black (reduces eye strain) |
| Surface | #F3F4F6 | #1E1E1E | Elevation = lighter shade |
| Primary text | #1F2937 | #E5E7EB | Not pure white |
| Secondary text | #6B7280 | #9CA3AF | Still meets 4.5:1 |
| Borders | #D1D5DB | #374151 | Subtle but visible |
| Errors | #DC2626 | #F87171 | Lighter red for dark bg |
| Links | #2563EB | #60A5FA | Lighter blue for dark bg |

```css
@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: #121212;
    --bg-surface: #1E1E1E;
    --text-primary: #E5E7EB;
    --text-secondary: #9CA3AF;
  }
}
```

---

## Motion Sensitivity

### Reduced Motion

```css
/* Default: subtle animations */
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
}

/* Respect user preference */
@media (prefers-reduced-motion: reduce) {
  .card {
    transition: none;
  }
  .card:hover {
    transform: none;
    /* Keep non-motion feedback */
    box-shadow: 0 0 0 2px #2563EB;
  }

  /* Disable all non-essential animations */
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Motion Guidelines

| Motion Type | Default | Reduced Motion | Notes |
|-------------|---------|----------------|-------|
| Page transitions | Slide/fade (300ms) | Instant cut | Essential for navigation |
| Loading spinners | Rotation | Static dots or progress bar | Keep feedback mechanism |
| Hover effects | Scale/translate | Border/shadow change | Keep feedback, remove motion |
| Auto-playing video | Play | Pause, show poster | Always provide play/pause |
| Parallax scrolling | Enabled | Disabled | Decorative, not essential |
| Carousels | Auto-advance | Manual only | Provide pause control always |
| Success animations | Confetti/bounce | Checkmark (static) | Keep confirmation |

### React Implementation

```tsx
function useReducedMotion(): boolean {
  const [prefersReduced, setPrefersReduced] = useState(false);

  useEffect(() => {
    const mq = window.matchMedia('(prefers-reduced-motion: reduce)');
    setPrefersReduced(mq.matches);

    const handler = (e: MediaQueryListEvent) => setPrefersReduced(e.matches);
    mq.addEventListener('change', handler);
    return () => mq.removeEventListener('change', handler);
  }, []);

  return prefersReduced;
}

// Usage
function AnimatedCard({ children }: { children: React.ReactNode }) {
  const reducedMotion = useReducedMotion();

  return (
    <motion.div
      whileHover={reducedMotion ? {} : { y: -4, scale: 1.02 }}
      transition={reducedMotion ? { duration: 0 } : { duration: 0.3 }}
    >
      {children}
    </motion.div>
  );
}
```

---

## Multilingual UX

### Internationalization Architecture

```typescript
// i18n setup with next-intl or react-intl
// messages/en.json
{
  "auth": {
    "login": "Log in",
    "signup": "Create account",
    "forgotPassword": "Forgot your password?",
    "errors": {
      "invalidEmail": "Please enter a valid email address",
      "passwordTooShort": "Password must be at least {minLength} characters"
    }
  },
  "products": {
    "addToCart": "Add to cart",
    "outOfStock": "Out of stock",
    "price": "{price, number, ::currency/USD}",
    "itemCount": "{count, plural, =0 {No items} one {# item} other {# items}}"
  }
}
```

### RTL (Right-to-Left) Support

```css
/* Use logical properties instead of physical */
/* BAD */
.card {
  margin-left: 16px;
  padding-right: 8px;
  text-align: left;
  border-left: 3px solid blue;
}

/* GOOD */
.card {
  margin-inline-start: 16px;
  padding-inline-end: 8px;
  text-align: start;
  border-inline-start: 3px solid blue;
}
```

| Physical Property | Logical Property |
|-------------------|-----------------|
| `margin-left` | `margin-inline-start` |
| `margin-right` | `margin-inline-end` |
| `padding-left` | `padding-inline-start` |
| `padding-right` | `padding-inline-end` |
| `text-align: left` | `text-align: start` |
| `float: left` | `float: inline-start` |
| `border-left` | `border-inline-start` |
| `left: 0` | `inset-inline-start: 0` |
| `width` | `inline-size` |
| `height` | `block-size` |

### Text Expansion Planning

| Language | Expansion vs English | Example |
|----------|---------------------|---------|
| German | +30% | "Save" = "Speichern" |
| French | +20% | "Delete" = "Supprimer" |
| Finnish | +40% | "Settings" = "Asetukset" |
| Arabic | -20% (but RTL) | Right-to-left layout |
| Chinese | -50% (characters) | Fewer chars, same meaning |
| Japanese | -30% (mixed scripts) | Mixed kanji/hiragana |

```css
/* Accommodate text expansion */
.button {
  /* Use padding, not fixed width */
  padding-inline: 16px;
  min-inline-size: 80px;
  /* Allow wrapping in extreme cases */
  white-space: normal;
  word-break: break-word;
}

/* Prevent truncation of translated text */
.nav-item {
  /* Don't use fixed heights for text containers */
  min-block-size: 40px;
  block-size: auto;
}
```

---

## Typography for Readability

```css
:root {
  /* Base size: 16px minimum */
  font-size: 100%;

  /* Line height: 1.5 for body text */
  --line-height-body: 1.5;
  --line-height-heading: 1.2;

  /* Line length: 45-75 characters ideal */
  --max-line-length: 65ch;

  /* Paragraph spacing: at least 1.5x font size */
  --paragraph-spacing: 1.5em;

  /* Letter spacing: adjustable for dyslexia */
  --letter-spacing-body: 0.01em;

  /* Word spacing: adjustable */
  --word-spacing-body: 0.05em;
}

body {
  font-family: system-ui, -apple-system, sans-serif;
  font-size: 1rem;
  line-height: var(--line-height-body);
  letter-spacing: var(--letter-spacing-body);
  word-spacing: var(--word-spacing-body);
}

p {
  max-inline-size: var(--max-line-length);
  margin-block-end: var(--paragraph-spacing);
}

/* User-adjustable text size */
.text-size-controls button {
  min-inline-size: 44px;
  min-block-size: 44px;
}
```

---

## Touch and Pointer Accessibility

### Target Sizes

```css
/* WCAG 2.5.8: Minimum 24x24px (AA), 44x44px recommended */
button, a, input, select {
  min-block-size: 44px;
  min-inline-size: 44px;
}

/* Spacing between targets: at least 8px */
.button-group > * + * {
  margin-inline-start: 8px;
}

/* Icon-only buttons: ensure touch target */
.icon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-block-size: 44px;
  min-inline-size: 44px;
  padding: 8px;
}
```

---

## Testing Inclusive Design

### Manual Testing Checklist

| Test | How | Pass Criteria |
|------|-----|---------------|
| Screen reader | VoiceOver (Mac/iOS), NVDA (Windows), TalkBack (Android) | All content announced, logical order |
| Keyboard only | Unplug mouse, navigate entire app | All functionality accessible |
| Zoom 200% | Browser zoom to 200% | No content lost, no horizontal scroll |
| Zoom 400% | Browser zoom to 400% | Content reflows, still usable |
| High contrast | Windows High Contrast Mode | All content visible |
| Reduced motion | OS setting | No essential motion, feedback preserved |
| Color only | Grayscale filter | All info conveyed without color |
| RTL | Browser RTL override | Layout mirrors correctly |
| Small screen | 320px viewport width | No horizontal overflow |

### Automated Tools

| Tool | Type | Integration |
|------|------|-------------|
| axe DevTools | Browser extension | Manual testing |
| axe-core | Library | Jest/Vitest |
| Lighthouse | CLI/CI | GitHub Actions |
| Pa11y | CLI | CI pipeline |
| Storybook a11y addon | Storybook plugin | Component dev |
| eslint-plugin-jsx-a11y | ESLint plugin | Every save |

---

## Cross-References

- `3-build/accessibility_implementation` - Technical WCAG implementation
- `3-build/design_system_development` - Inclusive design tokens and components
- `3-build/progressive_web_app` - PWA accessibility
- `3-build/react_native_patterns` - Mobile accessibility patterns

---

## EXIT CHECKLIST

- [ ] Color is never the sole indicator of meaning
- [ ] All text meets contrast requirements (4.5:1 normal, 3:1 large)
- [ ] Motion respects prefers-reduced-motion
- [ ] Touch targets are at least 44x44px
- [ ] Content is written at grade 8 reading level or below
- [ ] Forms use progressive disclosure for complex flows
- [ ] Error messages are specific and actionable
- [ ] Internationalization uses ICU message format for plurals/numbers
- [ ] CSS uses logical properties for RTL support
- [ ] Text containers accommodate 40% expansion for translation
- [ ] Dark mode maintains contrast ratios
- [ ] Typography supports readability (line height, line length, spacing)

---

*Skill Version: 1.0 | Created: March 2026*
