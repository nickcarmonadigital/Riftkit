---
name: UI Polish
description: Debug and polish user interfaces for professional, production-ready quality
---

# UI Polish Skill

**Purpose**: Transform functional UIs into polished, professional interfaces ready for production.

---

## 🎯 TRIGGER COMMANDS

```text
"Polish the UI for [feature/page]"
"Fix UI bugs on [page]"
"Make [component] look better"
"UI review for [feature]"
"Using ui_polish skill: [target]"
```

---

## 🔍 WHEN TO USE

- After Phase 7 (Implementation) of a spec build
- When users report visual issues
- Before demo or launch
- When UI "works but looks off"
- During Phase 10 of the 12-phase spec build

---

## 📋 UI POLISH CHECKLIST

### 1. Layout & Spacing

```
[ ] Consistent spacing between elements (use 4px/8px grid)
[ ] Proper margins around containers
[ ] Content doesn't touch edges
[ ] Visual hierarchy is clear
[ ] No unexpected overflow (horizontal scrollbars)
[ ] Alignment is consistent (left, center, right intentional)
```

### 2. Typography

```
[ ] Font sizes follow scale (12, 14, 16, 18, 24, 32...)
[ ] Line heights are readable (1.4-1.6 for body)
[ ] Headings have proper weight contrast
[ ] Text truncation handled with ellipsis
[ ] No orphaned words on separate lines (when possible)
```

### 3. Colors & Contrast

```
[ ] Sufficient contrast for accessibility (WCAG AA)
[ ] Consistent use of brand colors
[ ] No pure black (#000) or pure white (#FFF)
[ ] Hover/focus states are visible
[ ] Disabled states are distinguishable
```

### 4. Interactive Elements

```
[ ] Buttons have hover states
[ ] Buttons have active/pressed states
[ ] Focus rings visible for accessibility
[ ] Clickable areas are large enough (44x44px minimum)
[ ] Loading states present during async operations
[ ] Disabled buttons look different from enabled
```

### 5. Form Elements

```
[ ] Input fields have clear borders/backgrounds
[ ] Placeholder text is visible but subtle
[ ] Error states are red/obvious
[ ] Success states are green/positive
[ ] Required field indicators present
[ ] Validation messages are clear
```

### 6. Responsive Design

```
[ ] Works on 320px width (mobile)
[ ] Works on 768px width (tablet)
[ ] Works on 1024px+ width (desktop)
[ ] No horizontal scroll at any breakpoint
[ ] Touch targets adequate on mobile
[ ] Text readable without zooming on mobile
```

### 7. Empty & Error States

```
[ ] Empty states have helpful messaging
[ ] Error pages are styled consistently
[ ] 404 page exists and is helpful
[ ] Loading skeletons or spinners present
[ ] Error boundaries prevent blank screens
```

### 8. Modals & Overlays

```
[ ] Modals center properly
[ ] Background dimming present
[ ] Click outside to close works
[ ] Escape key closes modal
[ ] Modals don't overflow on small screens
[ ] Z-index is correct (no overlap issues)
```

### 9. Tooltips & Help Text

```
[ ] Info icons have tooltips
[ ] Tooltips don't clip outside viewport
[ ] Tooltip positioning is smart (flips if near edge)
[ ] Help text is concise and useful
[ ] Tooltips appear on hover AND focus
```

### 10. Animations & Transitions

```
[ ] Transitions are smooth (200-300ms typical)
[ ] No jarring jumps or flashes
[ ] Reduced motion respected (prefers-reduced-motion)
[ ] Loading spinners spin smoothly
[ ] Page transitions are consistent
```

---

## 🐛 COMMON UI BUGS & FIXES

### Horizontal Overflow

```
SYMPTOM: Horizontal scrollbar appears
CAUSES:
- Element wider than container
- Fixed widths exceeding viewport
- Absolute positioned element outside bounds
- Long unbroken text (URLs, long words)

FIXES:
- Add overflow-x-hidden to container
- Use max-width: 100%
- Add word-break: break-word
- Check for negative margins
```

### Tooltip Clipping

```
SYMPTOM: Tooltip cut off by container edge
CAUSES:
- Parent has overflow: hidden
- Tooltip positioned relative to wrong container
- Z-index not high enough

FIXES:
- Position relative to viewport, not container
- Use portals/createPortal for React
- Increase z-index (use z-[200] or higher)
- Add position-aware logic (flip if near edge)
```

### Z-Index Wars

```
SYMPTOM: Elements overlapping incorrectly
CAUSES:
- Random z-index values
- Stacking context issues
- No z-index scale defined

FIXES:
- Define z-index scale (10, 20, 30, 40, 50)
- Check parent stacking contexts
- Use isolation: isolate when needed
```

### Modal/Popup Issues

```
SYMPTOM: Modal content scrolls body instead
CAUSES:
- Body scroll not locked
- Modal not fixed positioned

FIXES:
- Add body { overflow: hidden } when modal open
- Use fixed positioning for modal backdrop
- Trap focus inside modal
```

### Button State Missing

```
SYMPTOM: Button doesn't respond visually to click
CAUSES:
- No :hover or :active styles
- Transition too slow
- State overridden by other styles

FIXES:
- Add hover:bg-color-darker
- Add active:scale-95 or active:bg-color-darkest
- Check CSS specificity
```

---

## 🎨 QUICK POLISH PATTERNS

### Card Hover Effect

```css
.card {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
}
```

### Button States

```css
.button {
  transition: all 0.15s ease;
}
.button:hover {
  background-color: var(--color-primary-dark);
}
.button:active {
  transform: scale(0.98);
}
.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
```

### Smart Tooltip Positioning

```tsx
const position = buttonNearRightEdge ? 'left' : 'right';
const positionClasses = position === 'left' ? 'left-0' : 'right-0';
```

### Loading Skeleton

```css
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

## 📊 UI POLISH OUTPUT FORMAT

When reporting UI polish work:

```markdown
## UI Polish Report: [Feature/Page Name]

### Issues Fixed
| Issue | Location | Fix Applied |
|-------|----------|-------------|
| Horizontal overflow | SetupModal | Added overflow-hidden, max-w-full |
| Tooltip clipping | InfoTooltip | Added position prop, compact mode |
| Missing hover states | All buttons | Added hover:bg-* classes |

### Responsive Checks
- [x] Mobile (320px)
- [x] Tablet (768px)
- [x] Desktop (1024px+)

### Before/After
[Screenshots if applicable]

### Remaining Issues
- [ ] [Any issues deferred or needing more work]
```

---

## ✅ EXIT CRITERIA

UI Polish is **COMPLETE** when:

- [ ] All checklist items verified
- [ ] No horizontal overflow on any breakpoint
- [ ] All interactive elements have visible states
- [ ] Loading and error states present
- [ ] Tooltips and modals don't clip
- [ ] Responsive design verified on mobile, tablet, desktop
- [ ] No console errors related to UI

---

*Skill Version: 1.0 | Created: January 26, 2026*
