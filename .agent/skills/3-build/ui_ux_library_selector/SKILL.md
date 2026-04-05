---
name: UI/UX Library Selector
description: Choose the right UI component library, CSS framework, animation library, icons, and tools for any project based on requirements
---

# UI/UX Library Selector

**Purpose**: Select the optimal UI/UX libraries and tools for any project based on framework, design requirements, performance needs, and team expertise. Covers 200+ libraries across 18 categories.

---

## TRIGGER COMMANDS

```text
"What UI library should I use for [project]?"
"Pick a component library for [framework]"
"Best animation library for [use case]"
"Using ui_ux_library_selector skill: [requirements]"
"Compare [library A] vs [library B]"
```

---

## WHEN TO USE

- Starting a new frontend project
- Evaluating component libraries for an existing project
- Client asks for specific design capabilities
- Need to add animation, charting, icons, or other UI capabilities
- Choosing between multiple options for the same need

---

## DECISION FRAMEWORK

### Step 1: Identify Your Framework
```
React → See React Libraries section
Vue → See Vue Libraries section
Svelte → See Svelte Libraries section
Framework-agnostic → See CSS Frameworks + Headless sections
Multiple frameworks → See Headless Libraries section
```

### Step 2: Identify Your Needs
```
[ ] Component library (buttons, forms, modals, etc.)
[ ] CSS framework / utility classes
[ ] Animation / motion
[ ] Icons
[ ] Charts / data visualization
[ ] Data tables / grids
[ ] Form management
[ ] Design system foundation
[ ] 3D / WebGL
[ ] AI-powered generation
```

### Step 3: Identify Your Constraints
```
Design control:  Need full control → Headless/unstyled
                 Want pre-styled → Opinionated library
Bundle size:     Minimal → Tree-shakeable, headless
Accessibility:   Critical → Radix, React Aria, Ariakit
Design system:   Material → MUI
                 Custom → shadcn/ui, Mantine
                 Enterprise → Ant Design
```

---

## REACT COMPONENT LIBRARIES

### Top Picks by Use Case

| Use Case                    | Best Pick        | Runner-Up          |
|-----------------------------|------------------|--------------------|
| Modern startup/SaaS         | **shadcn/ui**    | Mantine            |
| Enterprise dashboard        | **Ant Design**   | MUI                |
| Material Design needed      | **MUI**          | -                  |
| Maximum customization       | **shadcn/ui**    | Headless UI + custom |
| Rapid prototyping           | **Mantine**      | Chakra UI          |
| Landing pages / marketing   | **Aceternity UI**| Magic UI           |
| Full-featured + hooks       | **Mantine**      | Chakra UI          |
| Adobe ecosystem             | **React Spectrum**| -                 |
| Tailwind-native             | **HeroUI**       | shadcn/ui          |

### Detailed Comparison

**shadcn/ui** (104K+ stars)
- Copy-paste components built on Radix + Tailwind
- You own the code — no dependency lock-in
- Best for: Custom designs, full control, Tailwind projects
- Trade-off: More setup work, no automatic updates

**MUI / Material UI** (97K+ stars)
- Google Material Design for React
- MUI X for advanced data grids, date pickers (paid)
- Best for: Material Design adherence, large teams
- Trade-off: Heavy bundle, opinionated styling

**Ant Design**
- Enterprise-grade: complex forms, data tables, admin panels
- Best for: B2B dashboards, enterprise applications
- Trade-off: Very opinionated styling, hard to customize

**Mantine** (38K+ stars)
- 120+ components, 100+ hooks, rich text, dates, notifications built-in
- Best for: Feature-rich apps needing everything out of the box
- Trade-off: Dropped Emotion for CSS Modules in v7 (migration needed)

**Chakra UI**
- Accessible, themeable, intuitive style props
- Built-in dark mode
- Best for: Quick prototyping, accessible-first projects
- Trade-off: Smaller ecosystem than MUI/Ant

---

## HEADLESS / UNSTYLED LIBRARIES

Use these when you want full design control with accessibility built-in.

| Library         | Framework     | Best For                              |
|-----------------|---------------|---------------------------------------|
| **Radix UI**    | React         | Low-level accessible primitives       |
| **Headless UI** | React, Vue    | Tailwind-styled accessible components |
| **React Aria**  | React         | Adobe-grade accessibility hooks       |
| **Ariakit**     | React         | Actively maintained headless components|
| **Ark UI**      | React/Vue/Svelte | Cross-framework headless          |
| **Reka UI**     | Vue           | Radix-equivalent for Vue              |
| **Bits UI**     | Svelte        | Headless primitives for Svelte        |
| **Melt UI**     | Svelte        | Accessible builders for Svelte        |

---

## CSS FRAMEWORKS

| Framework       | Approach          | Best For                    | Bundle |
|-----------------|-------------------|-----------------------------|--------|
| **Tailwind CSS** | Utility-first    | Everything modern           | Small (purged) |
| **UnoCSS**       | Atomic, instant  | Faster Tailwind alternative | Tiny   |
| **Bootstrap**    | Component-based  | Rapid prototyping, legacy   | Medium |
| **Bulma**        | Flexbox, pure CSS| No-JS requirements          | Small  |
| **Pico.css**     | Classless        | Minimal HTML, docs, prototypes | Tiny |

---

## TAILWIND-FIRST COMPONENT LIBRARIES

| Library         | Key Feature                      | Price        |
|-----------------|----------------------------------|--------------|
| **DaisyUI**     | Component classes, 35 themes, no JS | Free (MIT) |
| **Tailwind Plus**| Official premium by Tailwind Labs | **Paid**    |
| **Flowbite**    | Components with JS interactivity | Free + Pro   |
| **Preline**     | Full component library + plugins | Free + Pro   |
| **HyperUI**     | Free copy-paste components       | Free         |

---

## VUE LIBRARIES

| Library         | Best For                          | Stars |
|-----------------|-----------------------------------|-------|
| **Vuetify**     | Material Design for Vue           | 80+ components |
| **PrimeVue**    | 90+ components, unstyled mode     | Tailwind support |
| **Element Plus**| TypeScript-first Vue 3            | 27K+ stars |
| **Quasar**      | Full framework: SPA/SSR/PWA/mobile| 27K+ stars |
| **Nuxt UI**     | Tailwind + Reka for Nuxt          | SSR/SSG native |
| **Naive UI**    | TypeScript, Vue 3                 | 16K+ stars |

---

## SVELTE LIBRARIES

| Library              | Best For                        |
|----------------------|---------------------------------|
| **Skeleton**         | Design system on Tailwind       |
| **shadcn-svelte**    | shadcn/ui port for Svelte       |
| **Flowbite Svelte**  | 60+ Tailwind components         |
| **Melt UI**          | Headless accessible builders    |
| **Bits UI**          | Headless primitives             |
| **Carbon Svelte**    | IBM Carbon Design               |

---

## ANIMATION LIBRARIES

| Library              | Type              | Best For                        | Bundle |
|----------------------|-------------------|---------------------------------|--------|
| **Motion** (Framer)  | Declarative React | Spring animations, layout transitions | Medium |
| **GSAP**             | Imperative JS     | Complex timelines, ScrollTrigger| Medium |
| **Lenis**            | Scroll only       | Smooth momentum scrolling       | Small  |
| **anime.js**         | Lightweight JS    | Simple animations               | Tiny   |
| **AutoAnimate**      | Auto/magic        | One-line transition animations  | Tiny   |
| **Lottie**           | After Effects     | Complex vector animations       | Medium |
| **Rive**             | State machines    | Interactive vector animations   | Medium |
| **React Spring**     | Spring physics    | React spring-based animations   | Medium |

### Quick Decision
```
Simple hover/transitions → CSS transitions (no library needed)
React layout animations → Motion (Framer Motion)
Complex scroll animations → GSAP + ScrollTrigger
Smooth scrolling → Lenis
After Effects animations → Lottie
Interactive animations → Rive
One-line magic → AutoAnimate
```

---

## ICON LIBRARIES

| Library           | Icons   | Style                    | Best For              |
|-------------------|---------|--------------------------|-----------------------|
| **Lucide**        | 1,500+  | Line                     | Tailwind/shadcn projects |
| **Phosphor**      | 9,000+  | 6 weights                | Maximum variety       |
| **Heroicons**     | 450+    | Outline, Solid, Mini     | Tailwind projects     |
| **Tabler Icons**  | 5,300+  | Line                     | Large icon needs      |
| **React Icons**   | All     | Aggregator               | Access all libraries  |
| **Font Awesome**  | 30,000+ | Multiple                 | Legacy, comprehensive |
| **Simple Icons**  | 3,100+  | Brand logos              | Brand/social icons    |

### Quick Decision
```
Tailwind project → Lucide or Heroicons
Need lots of variety → Phosphor (9K+ icons, 6 weights)
Need brand logos → Simple Icons
Access everything → React Icons (aggregator)
```

---

## CHARTS & DATA VISUALIZATION

| Library            | Type           | Best For                        |
|--------------------|----------------|---------------------------------|
| **Recharts**       | Declarative React SVG | Standard React charts     |
| **Chart.js**       | Canvas-based   | Simple, flexible charts         |
| **Apache ECharts** | High-performance| Large datasets                  |
| **D3.js**          | Low-level SVG  | Fully custom visualizations     |
| **Nivo**           | React + D3     | Rich dataviz components         |
| **Tremor**         | Dashboard-focused | KPIs + analytics dashboards  |
| **AG Charts**      | AG Grid companion| Paired with AG Grid           |
| **Highcharts**     | Enterprise     | Accessible, feature-rich (paid) |

### Quick Decision
```
Simple React charts → Recharts
Dashboard KPIs → Tremor
Custom/artistic viz → D3.js
Large datasets → Apache ECharts
Enterprise needs → Highcharts (paid)
```

---

## DATA TABLES & GRIDS

| Library             | Type            | Best For                    | Price    |
|---------------------|-----------------|-----------------------------| ---------|
| **TanStack Table**  | Headless logic  | Full control over UI        | Free     |
| **AG Grid**         | Full-featured   | Excel-like enterprise grid  | Free + Paid |
| **MUI X Data Grid** | Material-styled | MUI ecosystem               | Free + Paid |
| **Glide Data Grid** | Canvas-rendered | High performance            | Free     |

---

## FORM LIBRARIES

| Library             | Framework | Best For                         |
|---------------------|-----------|----------------------------------|
| **React Hook Form** | React     | Performance, minimal re-renders  |
| **TanStack Form**   | Multi     | Type-safe, cross-framework       |
| **Formik**          | React     | Declarative, established         |
| **FormKit**         | Vue       | Full form framework              |
| **Superforms**      | Svelte    | SvelteKit forms                  |

---

## 3D / WebGL

| Library               | Best For                          |
|-----------------------|-----------------------------------|
| **Three.js**          | General 3D on the web             |
| **React Three Fiber** | Three.js in React                 |
| **Babylon.js**        | Full 3D engine (Microsoft)        |
| **Spline**            | Visual 3D design tool for web     |
| **A-Frame**           | WebXR/VR                          |

---

## AI-POWERED UI GENERATION

| Tool              | Output                    | Price       |
|-------------------|---------------------------|-------------|
| **v0** (Vercel)   | React + Tailwind + shadcn | Free + Paid |
| **Google Stitch**  | Figma-like designs + code | Free        |
| **Lovable**       | Full-stack app            | Free + Paid |
| **Bolt**          | Full-stack in browser     | Free + Paid |
| **Builder.io**    | Figma-to-code with AI     | Free + Paid |

---

## RECOMMENDED STACKS

### Startup SaaS (Fast Ship)
```
shadcn/ui + Tailwind + Next.js + Lucide + Motion + Recharts
```

### Enterprise Dashboard
```
Ant Design + AG Grid + Apache ECharts + React Hook Form
```

### Marketing / Landing Page
```
Tailwind + Aceternity UI + GSAP + Lenis + Lucide
```

### Design System from Scratch
```
Radix UI + Tailwind + Storybook + Lucide + Motion
```

### Vue Project
```
Nuxt UI + Tailwind + Heroicons + Chart.js
```

### Mobile (React Native)
```
Tamagui + NativeWind + React Native Reanimated + Phosphor
```

---

## EXIT CRITERIA

```
[ ] Framework identified (React/Vue/Svelte/vanilla)
[ ] Component library selected with clear rationale
[ ] CSS approach decided (Tailwind/CSS-in-JS/vanilla)
[ ] Animation strategy chosen (if needed)
[ ] Icon library selected
[ ] Charting library selected (if needed)
[ ] Form library selected (if needed)
[ ] All selections are compatible with each other
[ ] Bundle size impact is acceptable
[ ] Accessibility requirements are met by selections
```

---

*Version: 1.0 | Created: 2026-04-05 | Source: Comprehensive web research across 200+ libraries*
