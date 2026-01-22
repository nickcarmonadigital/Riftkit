---
name: Website Build
description: Anti-AI-slop website creation standards and checklist
---

# Website Build Skill

> **CRITICAL**: Never create AI slop. Every website must look premium, intentional, and unique.

## 🎯 Purpose

Build websites that stand out from generic AI-generated designs by following intentional design principles.

## When to Use

- Building client websites
- Creating portfolio/demo projects
- Building marketing sites
- Any web project that needs to look premium

---

## ❌ What AI Slop Looks Like

NEVER do these:

| AI Slop Indicator | Why It's Bad |
|-------------------|--------------|
| Pure #FFFFFF background + #3B82F6 blue | Every AI tool uses this |
| Inter, Roboto, Open Sans, Lato fonts | Default AI font choices |
| Floating gradient blobs/orbs | Overused decoration |
| Generic laptop mockup in hero | Seen a million times |
| Rainbow gradient text | Cheap gimmick |
| Identical card grids | No visual hierarchy |
| "Synergy", "leverage", "paradigm" copy | Corporate jargon |

## ✅ What Premium Looks Like

DO these instead:

| Premium Design | How to Achieve |
|----------------|----------------|
| Intentional color palette | Pick warm, cool, or editorial direction |
| Distinctive typography | Space Grotesk, Plus Jakarta Sans, Outfit |
| Off-white backgrounds | #FAFAFA, #F5F5F4, #FBF9F7 |
| Generous whitespace | 96px+ between sections |
| Subtle interactions | translateY(-2px) + shadow on hover |
| Asymmetric layouts | 7/5 or 8/4 column splits |
| Unique hero concept | Fits the specific brand |

## 🎨 Design Archetypes

Choose ONE per project:

### 1. SaaS/Tech

- **Vibe**: Clean, systematic, trust-building
- **Fonts**: Space Grotesk, Plus Jakarta Sans, Geist
- **Colors**: Cool neutrals, single accent

### 2. Luxury/Editorial

- **Vibe**: High contrast, refined, unhurried
- **Fonts**: Playfair Display, Cormorant, Fraunces
- **Colors**: Muted earth tones, cream/charcoal

### 3. Brutalist/Dev

- **Vibe**: Raw, intentional ugliness, monospace
- **Fonts**: JetBrains Mono, IBM Plex Mono
- **Colors**: High contrast, primary colors

### 4. Playful/Consumer

- **Vibe**: Rounded, bouncy, approachable
- **Fonts**: Outfit, Nunito, Quicksand
- **Colors**: Saturated, multi-color palettes

### 5. Corporate/Enterprise

- **Vibe**: Conservative, authoritative, accessible
- **Fonts**: Source Sans 3, Noto Sans
- **Colors**: Navy, forest, burgundy anchors

### 6. Creative/Portfolio

- **Vibe**: Experimental, asymmetric, memorable
- **Fonts**: Syne, Clash Display, Cabinet Grotesk
- **Colors**: Bold or monochrome extremes

## 🔧 Technical Requirements

### Typography Setup

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=[FONT]:wght@400;500;600;700&display=swap" rel="stylesheet">
```

### Color Palette Template

```css
:root {
  /* Backgrounds - NEVER pure white */
  --bg-primary: #FAFAFA;      /* or #F5F5F4, #FBF9F7 */
  --bg-dark: #0A0A0A;         /* Rich black, not washed gray */
  
  /* Text - NEVER pure black */
  --text-primary: #171717;
  --text-secondary: #525252;
  
  /* Accent - ONE intentional color */
  --accent: #your-color;
}
```

### Hover Effects

```css
.interactive-element {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.interactive-element:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
}
.interactive-element:active {
  transform: translateY(0) scale(0.98);
}
```

## ✅ Pre-Launch Checklist

```
DESIGN:
[ ] Archetype selected and applied consistently
[ ] Typography is NOT Inter/Roboto/Arial
[ ] Colors are NOT pure white + generic blue
[ ] Strong visual hierarchy exists
[ ] Generous whitespace between sections

TECHNICAL:
[ ] Page load < 3 seconds
[ ] Mobile responsive (tested on real device)
[ ] All images optimized (WebP, compressed)
[ ] Focus states visible on all interactive elements
[ ] Semantic HTML used

QUALITY:
[ ] CTA is obvious and above fold
[ ] Copy is clear (5th grade reading level)
[ ] No placeholder content
[ ] Would you put this in your portfolio?
```

## 📝 AI Agent Instructions

When asked to build a website:

1. **Ask** which archetype fits the client
2. **Select** typography from the approved list
3. **Create** an intentional color palette
4. **Always** use off-white backgrounds
5. **Never** use default AI styling
6. **Test** on mobile before presenting
