---
name: UI/UX Component Ecosystem
description: Complete reference map of the UI component ecosystem — design systems, Figma kits, drag-and-drop builders, and mobile frameworks
---

# UI/UX Component Ecosystem

**Purpose**: Comprehensive reference for the complete UI/UX tooling ecosystem beyond component libraries — covering enterprise design systems, Figma UI kits, drag-and-drop builders, mobile frameworks, and supporting tools.

---

## TRIGGER COMMANDS

```text
"What design system should I use for [project]?"
"Find a Figma UI kit for [purpose]"
"Compare mobile frameworks for [requirements]"
"What no-code builder works for [use case]?"
"Using ui_ux_component_ecosystem skill: [need]"
```

---

## WHEN TO USE

- Evaluating enterprise design systems for adoption
- Need a Figma UI kit for design handoff
- Choosing between mobile development frameworks
- Evaluating no-code/low-code builders for a project
- Building a design-to-development pipeline

---

## ENTERPRISE DESIGN SYSTEMS

These are battle-tested design systems from major companies. Use as foundations or references.

| System              | Owner       | Framework Support         | Open Source |
|---------------------|-------------|---------------------------|------------|
| **Material Design 3** | Google    | Flutter, Web, Android     | Yes        |
| **Fluent UI**       | Microsoft   | React, all platforms      | Yes (MIT)  |
| **Carbon Design**   | IBM         | React, Vue, Svelte, Angular, Web Components | Yes |
| **React Spectrum**  | Adobe       | React                     | Yes        |
| **Polaris**         | Shopify     | React                     | Yes        |
| **Lightning Design**| Salesforce  | Web Components, React     | Yes        |
| **Primer**          | GitHub      | React, CSS                | Yes        |
| **Paste**           | Twilio      | React                     | Yes        |
| **Base Web**        | Uber        | React                     | Yes (MIT)  |
| **Ring UI**         | JetBrains   | React                     | Yes        |
| **Orbit**           | Kiwi.com    | React                     | Yes        |

### When to Use Enterprise Design Systems
```
Building for that ecosystem    → Use their design system (Shopify → Polaris)
Enterprise internal tools      → Carbon, Fluent, or Lightning
Need a proven foundation       → Material Design 3
Want accessibility guarantees  → React Spectrum (Adobe)
GitHub-like UI                 → Primer
```

---

## FIGMA UI KITS

### Premium Kits
| Kit              | Focus                    | Components | Price     |
|------------------|--------------------------|------------|-----------|
| **Untitled UI**  | Full design system       | 10,000+    | Freemium  |
| **Glow UI**      | SaaS/dashboards          | Large      | Paid      |
| **Beyond UI**    | Landing pages            | Large      | Paid      |
| **AlignUI**      | Dashboard + data viz     | Large      | Paid      |
| **shadcn/ui Figma** | 1:1 code match        | Matches lib| Paid      |
| **Frames X**     | Parametric variants      | Large      | Paid      |

### Free Kits
| Kit                     | Source     |
|-------------------------|------------|
| **Ant Design Figma**    | Official   |
| **Material Design 3**   | Official Google |
| **iOS/Apple HIG Kit**   | Official Apple  |
| **Figma Community Kits**| 4,770+ free kits |

### Selection Guide
```
Need code-design parity → shadcn/ui Figma
Building dashboards     → AlignUI or Glow UI
Landing pages           → Beyond UI
Full design system      → Untitled UI
Free + good quality     → Material Design 3 Kit
```

---

## MOBILE UI FRAMEWORKS

### Cross-Platform

| Framework         | Language        | Platforms          | Market Share |
|-------------------|-----------------|--------------------|-------------|
| **Flutter**       | Dart            | iOS, Android, Web, Desktop | 46% |
| **React Native**  | TypeScript/JS   | iOS, Android       | Large       |
| **Kotlin Multiplatform** | Kotlin   | iOS, Android, Desktop, Web | Growing |
| **Ionic**         | HTML/CSS/JS     | iOS, Android, PWA  | Established |
| **.NET MAUI**     | C#              | iOS, Android, Windows, macOS | Niche |

### React Native UI Libraries
| Library          | Description                         |
|------------------|-------------------------------------|
| **Tamagui**      | Universal components (RN + Web)     |
| **NativeWind**   | Tailwind CSS for React Native       |
| **Gluestack UI** | Universal components (RN + Web)     |
| **React Native Paper** | Material Design for RN        |

### Native-Only
| Framework         | Platform      | Language |
|-------------------|---------------|----------|
| **SwiftUI**       | Apple (all)   | Swift    |
| **Jetpack Compose** | Android     | Kotlin   |

### Quick Decision
```
Cross-platform + beautiful UI     → Flutter
Cross-platform + JS ecosystem     → React Native + Expo
Cross-platform + Kotlin expertise  → Kotlin Multiplatform
Web developers going mobile        → Ionic or React Native
Apple only                          → SwiftUI
Android only                        → Jetpack Compose
```

---

## DRAG-AND-DROP / NO-CODE BUILDERS

### For Websites
| Builder          | Best For                     | Code Export | Price     |
|------------------|------------------------------|-------------|-----------|
| **Webflow**      | Designer-controlled sites    | HTML/CSS/JS | Freemium  |
| **Framer**       | Marketing sites, prototypes  | React       | Freemium  |
| **Squarespace**  | Simple business sites        | No          | Paid      |

### For Web Apps
| Builder          | Best For                     | Code Export | Price     |
|------------------|------------------------------|-------------|-----------|
| **WeWeb**        | Production web apps          | Vue.js      | Freemium  |
| **Budibase**     | Internal CRUD apps           | Open source | Free + Paid |
| **Appsmith**     | Internal tools with JS       | Open source | Free + Paid |
| **Retool**       | Internal tools, admin panels | No          | Freemium  |
| **Tooljet**      | Internal tools + dashboards  | Open source | Free + Paid |

### For Mobile Apps
| Builder          | Best For                     | Code Export | Price     |
|------------------|------------------------------|-------------|-----------|
| **FlutterFlow**  | Mobile apps with Flutter     | Dart/Flutter| Freemium  |
| **Adalo**        | Mobile apps for non-devs     | Native publish | Paid   |

### For React (Embeddable)
| Builder          | Best For                     | Price     |
|------------------|------------------------------|-----------|
| **Puck**         | Visual page editor for React | Free      |

### Quick Decision
```
Marketing website (designer-led)  → Webflow or Framer
Production web app                → WeWeb
Internal business tools           → Retool or Appsmith
Mobile app with code export       → FlutterFlow
Open source internal tools        → Budibase or Tooljet
```

---

## SUPPORTING TOOLS

### Component Development
| Tool             | Purpose                              |
|------------------|--------------------------------------|
| **Storybook**    | Isolated component development + docs|
| **Chromatic**    | Visual regression testing            |

### State Management
| Tool             | Framework  | Best For                   |
|------------------|------------|----------------------------|
| **Zustand**      | React      | Lightweight global state   |
| **TanStack Query** | Multi   | Server state / data fetching |
| **Jotai**        | React      | Atomic state management    |

### Validation
| Tool             | Purpose                              |
|------------------|--------------------------------------|
| **Zod**          | TypeScript-first schema validation   |

### Specialty Components
| Tool             | Purpose                              |
|------------------|--------------------------------------|
| **cmdk**         | Command palette (cmd+k)             |
| **Sonner**       | Toast notifications                  |
| **Vaul**         | Mobile-friendly drawer               |
| **React Email**  | Email template components            |

---

## DESIGN-TO-CODE PIPELINE

### Recommended Workflow
```
1. DESIGN    → Figma + UI Kit (or Stitch 2.0 for AI-generated)
2. TOKENS    → Style Dictionary / Tailwind config
3. COMPONENT → shadcn/ui + Radix (or framework equivalent)
4. DEVELOP   → Storybook for isolated dev
5. TEST      → Chromatic for visual regression
6. DOCUMENT  → Storybook docs mode
7. SHIP      → Component library npm package
```

### AI-Augmented Pipeline
```
1. INSPIRE   → Dribbble, Awwwards, Mobbin references
2. GENERATE  → Google Stitch 2.0 or v0 (Vercel)
3. REFINE    → Figma with UI kit
4. BUILD     → Claude Code with CLAUDE.md design rules
5. POLISH    → Motion, hover states, micro interactions
6. SHIP      → Vercel / Netlify / custom
```

---

## EXIT CRITERIA

```
[ ] Design system or component library selected
[ ] Figma kit identified (if design handoff needed)
[ ] Mobile framework chosen (if mobile is in scope)
[ ] Builder tool evaluated (if no-code is viable)
[ ] Supporting tools identified (state, validation, specialty)
[ ] Design-to-code pipeline is defined
[ ] All tools are compatible with chosen stack
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: Comprehensive web research + industry analysis*
