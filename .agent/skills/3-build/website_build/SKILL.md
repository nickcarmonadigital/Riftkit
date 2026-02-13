---
name: Website Build
description: Standards and checklist for building premium, high-converting websites (Anti-AI-Slop)
---

# Website Build Skill

**Purpose**: Build premium websites that look custom-designed and high-value, avoiding the "generic AI" aesthetic.

> **GOLDEN RULE**: If it looks like a default Vercel template or standard AI generation, it fails.

## 🎯 TRIGGER COMMANDS

```text
"Build a website for [client]"
"Create a landing page for [niche]"
"Start the website build phase"
"Review this design"
"Using website_build skill: [project]"
```

---

## 🚫 THE "ANTI-AI-SLOP" LIST

**Never do these things:**

1. **No Default Blue:** Avoid the standard Tailwind blue (`bg-blue-500`). Use curated colors.
2. **No Pure Black/White:** Use `#0F0F0F` or `#F5F5F7` instead of `#000`/`#FFF`.
3. **No "Generic Startup" Art:** Avoid corporate Memphis art or generic 3D hands.
4. **No Default Shadows:** Use multi-layered, subtle shadows (`box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`).
5. **No "Scroll to see more" chevrons:** They look dated.
6. **No Lorem Ipsum:** Use real, sector-specific placeholder text.

---

## 🎨 DESIGN ARCHETYPES

Pick ONE archetype before starting:

### 1. The "SaaS / Tech" (Linear, Raycast style)

- **Backgrounds:** Dark mode default, radial gradients, glassmorphism.
- **Borders:** 1px subtle borders (`border-white/10`).
- **Typography:** Inter, Geist Sans, SF Pro.
- **Accents:** Neon purple, electric blue, glow effects.

### 2. The "Luxury / Editorial" (Realtor, High-end Consulting)

- **Backgrounds:** Warm off-white (`#FDFBF7`), rich dark greens/browns.
- **Typography:** Serif headings (Playfair Display, Cormorant), Sans body.
- **Spacing:** Massive whitespace, large margins.
- **Images:** High quality, full width, emotionally resonant.

### 3. The "Brutalist / Dev" (Agency, Portfolio)

- **Backgrounds:** Stark black/white, grid lines.
- **Typography:** Monospace (JetBrains Mono, Space Mono).
- **Borders:** Thick, hard lines (`border-2 border-black`).
- **Accents:** Acid green, hot pink.

---

## 🏗️ BUILD CHECKLIST

### 1. Setup & Config

```
[ ] Clean Tailwind config (remove unused colors)
[ ] Install `lucide-react` for icons (use stroke-width={1.5})
[ ] Set up `clsx` and `tailwind-merge` for clean classes
[ ] Define global font variables in `globals.css`
```

### 2. Typography System

```
[ ] H1: Mobile 36px+ / Desktop 64px+ (Tracking tighter: -0.02em)
[ ] H2: Mobile 30px / Desktop 48px
[ ] Body: 16px minimum, 18px recommended for readability
[ ] Leading: Relaxed (1.6) for body, tight (1.1) for headings
```

### 3. Core Components (Build these first)

```
[ ] Button: Custom variants (primary, secondary, ghost)
    - Add subtle hover lift (`translate-y-[-1px]`)
    - Add focus rings
[ ] Container: Max-width 1200px/1400px, centered, padded
[ ] Section: Vertical padding 80px+ (don't cramp content)
[ ] Card: Border-radius 12px+, subtle border, soft shadow
```

### 4. Interactions (The "Premium" Feel)

```
[ ] Hover: All interactive elements need hover states
[ ] Active: Scale down (`scale-95`) on click
[ ] Images: Lazy load + fade-in animation
[ ] Scroll: Smooth scroll behavior
```

---

## 📱 RESPONSIVE RULES

1. **Mobile First:** Design for 320px width first.
2. **Padding:** Mobile side padding = 16px or 20px. Desktop = 24px+.
3. **Stacking:** Grid columns become flex-col on mobile.
4. **Touch Targets:** Minimum 44px for all buttons/links.
5. **Hide Complex Elements:** Simplify nav to hamburger menu on mobile.

---

## 🚀 LAUNCH PREP (The "Last 10%")

**Don't ship without checking:**

1. **Meta Tags:** Title, Description, OG Image (Social Share).
2. **Favicon:** SVG favicon works best.
3. **404 Page:** Custom 404, not default.
4. **Analytics:** Connecting Vercel Analytics or Google Analytics.
5. **No Console Errors:** Clean console check.

---

## 🪄 "MAGIC" TOUCHES (Bonus)

*Add 1-2 of these to wow the client:*

- **Gradient Text:** `bg-clip-text text-transparent bg-gradient-to-r...`
- **Glassmorphism:** `backdrop-blur-md bg-white/50`
- **Marquee:** Logo wall scrolling automatically.
- **Spotlight Effect:** Mouse-following hover glow.

---

*Skill Version: 2.0 | Updated: January 26, 2026*
