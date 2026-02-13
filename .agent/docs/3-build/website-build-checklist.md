# Website Build Checklist

**Document ID**: SMB-WEB-001  
**Purpose**: Comprehensive checklist for building anti-AI-slop websites

---

## Pre-Build Decisions

### 1. Design Archetype Selection

Choose ONE based on client industry/vibe:

| Archetype | Best For | Font Direction | Color Direction |
|-----------|----------|----------------|-----------------|
| ☐ **SaaS/Tech** | Software, agencies | Space Grotesk, Plus Jakarta Sans | Cool neutrals, single accent |
| ☐ **Luxury/Editorial** | High-end services | Playfair Display, Cormorant | Muted earth tones, cream/charcoal |
| ☐ **Brutalist/Dev** | Tech, creative rebels | JetBrains Mono, IBM Plex Mono | High contrast, primary colors |
| ☐ **Playful/Consumer** | Retail, kids, food | Outfit, Nunito, Quicksand | Saturated, multi-color |
| ☐ **Corporate/Enterprise** | B2B, professional | Source Sans 3, Noto Sans | Navy, forest, burgundy |
| ☐ **Creative/Portfolio** | Artists, designers | Syne, Clash Display | Bold or monochrome |

**Selected**: ________________

---

### 2. Job To Be Done

What should the site primarily accomplish?

| Goal | Layout Approach |
|------|-----------------|
| ☐ **Conversion** | Hero → Value Prop → Social Proof → CTA (F-pattern) |
| ☐ **Utility/Dashboard** | Information density, scannable |
| ☐ **Delight/Brand** | Scroll-driven storytelling, immersive |

---

### 3. Typography Selection

**NEVER USE**: Inter, Roboto, Open Sans, Lato, Arial, system-ui (AI slop signatures)

**Selected Fonts**:

- Headings: ________________
- Body: ________________

**Type Scale**: 14/16/20/32/56/72px (strong contrast)

---

### 4. Color Palette

**NEVER USE**: Pure #FFFFFF + generic blue (#3B82F6) or purple

**Direction**:

- ☐ Warm minimal (cream, terracotta, charcoal)
- ☐ Cool tech (slate, cyan accent, near-black)
- ☐ Paper/Editorial (sepia, ink black, red accent)
- ☐ Dark mode (rich blacks #0C0C0C, not washed grays)

**Selected Colors**:

| Role | Hex |
|------|-----|
| Background | #________ |
| Text | #________ |
| Primary Accent | #________ |
| Secondary | #________ |

---

## Build Checklist

### Structure & Layout

| # | Item | Done |
|---|------|------|
| 1 | Use 4px or 8px base grid | ☐ |
| 2 | All spacing in multiples (8, 16, 24, 32, 48, 64, 96, 128) | ☐ |
| 3 | Generous negative space between sections (96px+ desktop) | ☐ |
| 4 | Max content width set (1280px marketing, 1440px dashboards) | ☐ |
| 5 | Asymmetric layout where appropriate (7/5, 8/4 columns) | ☐ |

---

### Typography Implementation

| # | Item | Done |
|---|------|------|
| 1 | Google Fonts imported in `<head>` | ☐ |
| 2 | Font weights loaded (400, 500, 600, 700) | ☐ |
| 3 | Body text 16px+ | ☐ |
| 4 | Line height 1.6+ for body | ☐ |
| 5 | Headlines significantly larger than body | ☐ |

---

### Color Implementation

| # | Item | Done |
|---|------|------|
| 1 | Off-white background (not pure #FFFFFF) | ☐ |
| 2 | Off-black text (not pure #000000) | ☐ |
| 3 | Accent color used sparingly | ☐ |
| 4 | Consistent palette across all pages | ☐ |
| 5 | Contrast ratio 4.5:1 minimum for text | ☐ |

---

### Components

| # | Item | Done |
|---|------|------|
| 1 | Buttons: hover, focus, active, disabled states | ☐ |
| 2 | Cards: consistent border-radius (8px, 12px, or 16px) | ☐ |
| 3 | Forms: visible labels, clear error states | ☐ |
| 4 | Input padding adequate (12-16px) | ☐ |
| 5 | Icons: Lucide via CDN (not emoji) | ☐ |

---

### Interaction & Motion

| # | Item | Done |
|---|------|------|
| 1 | Landing page: staggered reveals, scroll-triggered | ☐ |
| 2 | Transitions: 300-500ms ease-out for reveals | ☐ |
| 3 | Hover states: subtle lift (translateY(-2px)) + shadow | ☐ |
| 4 | Active states: scale(0.98) press effect | ☐ |
| 5 | Micro-interactions: snappy 150ms for UI elements | ☐ |

---

### Accessibility

| # | Item | Done |
|---|------|------|
| 1 | Color contrast 4.5:1 minimum | ☐ |
| 2 | Focus states visible on all interactive elements | ☐ |
| 3 | Semantic HTML (`<button>`, `<nav>`, `<main>`, `<section>`) | ☐ |
| 4 | Alt text on all images | ☐ |
| 5 | Aria-labels on icon-only buttons | ☐ |
| 6 | Keyboard navigable | ☐ |

---

### Responsive

| # | Item | Done |
|---|------|------|
| 1 | Mobile-first approach | ☐ |
| 2 | Tested at 640px (sm) | ☐ |
| 3 | Tested at 768px (md) | ☐ |
| 4 | Tested at 1024px (lg) | ☐ |
| 5 | Tested at 1280px (xl) | ☐ |
| 6 | Touch targets 44px minimum on mobile | ☐ |

---

### Performance

| # | Item | Done |
|---|------|------|
| 1 | Page load < 3 seconds | ☐ |
| 2 | Images optimized (WebP, compressed) | ☐ |
| 3 | Fonts preloaded | ☐ |
| 4 | Minimal JavaScript | ☐ |
| 5 | Lazy loading for below-fold images | ☐ |

---

## Pitfalls to Avoid

| ❌ Don't Do This | ✅ Do This Instead |
|------------------|-------------------|
| Gradient backgrounds (Stripe 2020 style) | Solid colors or subtle gradients |
| Floating blobs/orbs as decoration | Intentional visual elements |
| Default "hero with laptop mockup" | Unique hero that fits the brand |
| Rainbow gradient text | Solid colors, maybe one gradient accent |
| Identical card grids | Visual hierarchy in card sizing |
| Sticky nav that obscures mobile content | Collapsible or minimal mobile nav |

---

## Final QA

| # | Check | Pass |
|---|-------|------|
| 1 | Does it look like AI slop? | ☐ NO |
| 2 | Does it feel premium? | ☐ YES |
| 3 | Does it clearly communicate what the business does? | ☐ YES |
| 4 | Is the CTA obvious? | ☐ YES |
| 5 | Would you be proud to show this in a portfolio? | ☐ YES |

---

*Template Version: 1.0 | Created: January 20, 2026*
