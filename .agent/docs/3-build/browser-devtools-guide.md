# Browser DevTools Guide

> **DevTools is your debugger, profiler, and inspector — all in one.** Open with `F12` or `Ctrl+Shift+I` (Cmd+Option+I on Mac).

---

## Network Tab

The Network tab shows every HTTP request your app makes.

### Key Actions

```
Filter by type:     Click XHR/Fetch to see only API calls
Search:             Ctrl+F to search in requests
Disable cache:      Check "Disable cache" when DevTools is open
Throttle:           Simulate slow connections (3G, slow 4G)
Copy as cURL:       Right-click request → Copy → Copy as cURL
                    Paste into terminal to replay the exact request
```

### Reading the Waterfall

```
Request Name    Status  Type   Size    Time    Waterfall
─────────────────────────────────────────────────────────
GET /api/users  200     fetch  2.3KB   145ms   ██████
POST /api/auth  401     fetch  0.1KB   23ms    ██
GET /styles.css 200     css    45KB    12ms    █
GET /bundle.js  200     js     340KB   89ms    ████
```

- **Status**: Green (2xx) = success, Red (4xx/5xx) = error
- **Time**: Total time for the request. Hover for breakdown (DNS, connect, wait, download)
- **Size**: Response size. Large sizes = potential optimization target

### Inspecting a Request

Click any request to see:
- **Headers**: Request/response headers (check Authorization, Content-Type)
- **Payload**: Request body (what you sent)
- **Preview**: Response body formatted (JSON/HTML)
- **Response**: Raw response text
- **Timing**: Breakdown of time spent in each phase

---

## Console

### Log Methods

```javascript
console.log('Basic output');
console.warn('Warning — something might be wrong');
console.error('Error — something IS wrong');
console.info('Informational');

// Table — display arrays/objects as a table
console.table([
  { name: 'Alice', role: 'Admin' },
  { name: 'Bob', role: 'User' },
]);

// Group — collapse related logs
console.group('User Authentication');
console.log('Checking token...');
console.log('Token valid');
console.groupEnd();

// Timer — measure execution time
console.time('API call');
await fetch('/api/users');
console.timeEnd('API call'); // Output: "API call: 145ms"

// Count — count how many times this runs
console.count('render'); // render: 1, render: 2, render: 3...

// Assert — log only if condition is false
console.assert(users.length > 0, 'No users found!');
```

### Console Shortcuts

```
$0                  Reference the currently selected element in Elements tab
$_                  Result of the last expression
copy(object)        Copy any object to clipboard as JSON
clear()             Clear the console
```

---

## Elements Tab

### DOM Inspection

- **Select element**: Click the cursor icon (top-left), then click any element on the page
- **Edit HTML**: Double-click any element to edit live
- **Delete element**: Select and press `Delete`
- **Force state**: Right-click element → Force State → `:hover`, `:focus`, `:active`

### CSS Debugging

```
Styles panel:        Shows all CSS rules applied to the selected element
                     Click any value to edit live
                     Check/uncheck rules to toggle them

Computed panel:      Shows the final computed values after all CSS is resolved
                     Useful for understanding cascading/specificity

Box Model:           Visual display of margin → border → padding → content
                     Click any value to edit
```

### CSS Grid/Flexbox Overlays

When you select an element with `display: grid` or `display: flex`:
- A badge appears in the DOM tree
- Click it to show the grid lines / flex boundaries overlay
- Helps visualize layout issues

---

## Application Tab

### Storage Inspection

```
localStorage:        Persistent key-value storage (survives browser close)
                     View, edit, delete entries

sessionStorage:      Same as localStorage but cleared when tab closes

Cookies:             View all cookies for the domain
                     Edit value, expiry, SameSite, httpOnly flags
                     Delete individual cookies

IndexedDB:           Structured database (large data storage)

Cache Storage:        Service Worker caches (PWA)
```

### JWT Decoding Trick

1. Open Application → Local Storage or Cookies
2. Find your JWT token
3. Copy it
4. Go to Console tab
5. Run: `JSON.parse(atob(token.split('.')[1]))`
6. See the decoded payload (user ID, email, expiry)

Or use jwt.io in a browser tab.

---

## Sources Tab

### Breakpoints

```
Line breakpoint:       Click the line number in Sources panel
Conditional:          Right-click line number → "Add conditional breakpoint"
                      Only pauses when condition is true (e.g., userId === 'abc')
DOM breakpoint:        Elements → right-click → Break on subtree/attribute/removal
XHR breakpoint:        Sources → XHR Breakpoints → Add URL pattern
                      Pauses when a fetch/XHR matches the pattern
Event listener:       Sources → Event Listener Breakpoints → check event type
```

### Stepping Through Code

```
F8 / Resume         Continue execution until next breakpoint
F10 / Step Over     Execute current line, go to next (don't enter functions)
F11 / Step Into     Enter the function on current line
Shift+F11 / Out     Finish current function, return to caller
```

### Source Maps

Source maps connect compiled/minified code back to your original source. When configured (Vite/Webpack do this automatically in dev), you can set breakpoints in your actual `.tsx` files instead of the compiled bundle.

---

## Performance Tab

### Recording a Profile

1. Click the Record button (or Ctrl+E)
2. Perform the action you want to measure
3. Click Stop
4. Analyze the flame chart

### Reading Flame Charts

```
Top:     Browser tasks (layout, paint, composite)
Middle:  JavaScript execution (your code)
Bottom:  Function calls (nested = called by parent)

Wide bars = long execution time (potential bottleneck)
```

### Core Web Vitals

| Metric | What It Measures | Good | Needs Improvement | Poor |
|--------|-----------------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | Loading — when main content visible | < 2.5s | 2.5-4s | > 4s |
| **FID** (First Input Delay) | Interactivity — time to respond to first click | < 100ms | 100-300ms | > 300ms |
| **CLS** (Cumulative Layout Shift) | Visual stability — unexpected layout shifts | < 0.1 | 0.1-0.25 | > 0.25 |

Check in: Performance tab → or Lighthouse tab for a full audit.

---

## React DevTools

### Component Tree

- Inspect the React component hierarchy
- Click any component to see its props, state, hooks, and context
- Search for components by name
- Filter by component type

### Profiler

1. Open React DevTools → Profiler tab
2. Click Record
3. Interact with your app
4. Click Stop
5. See which components re-rendered and why

**Highlight updates**: Settings → check "Highlight updates when components render"
- Green flash = re-rendered
- Frequent green flashes = potential performance issue

### Hooks Inspection

Click any component to see its hooks:
```
useState: value and setter
useEffect: dependencies
useMemo: cached value
useRef: current value
useContext: context value
Custom hooks: all internal state
```

---

## 4 Debugging Workflows

### 1. "API Returns Wrong Data"

```
1. Network tab → find the request
2. Check the request URL — is it calling the right endpoint?
3. Check the request body/params — are you sending the right data?
4. Check the response body — what did the server actually return?
5. If response is wrong → debug the backend (check controller → service → Prisma query)
6. If response is right → debug the frontend (how is data being transformed/displayed?)
```

### 2. "Component Re-Renders Too Much"

```
1. React DevTools Profiler → Record → interact → Stop
2. Look at the flame chart — which component renders most?
3. Check WHY it re-renders:
   - Parent re-renders? → React.memo() on the child
   - Props change? → Check if you're creating new objects/arrays on each render
   - Context changes? → Split context or use useMemo
4. Apply fix → Profile again → confirm fewer renders
```

### 3. "Page Loads Slowly"

```
1. Network tab → sort by time → find the slowest requests
   - Slow API call? → Optimize backend query (add indexes, reduce data)
   - Large JS bundle? → Code split, lazy load routes
   - Many requests? → Batch, use React Query caching
2. Performance tab → Record page load
   - Long tasks (>50ms) blocking the main thread?
   - Large layout shifts?
3. Lighthouse tab → run audit → follow recommendations
```

### 4. "CSS Looks Wrong"

```
1. Elements tab → select the broken element
2. Styles panel → see what CSS is applied
3. Check for:
   - Overridden rules (strikethrough = overridden)
   - Missing rules (expected class not applied?)
   - Specificity issues (inline > ID > class > element)
4. Computed panel → see the final values
5. Box model → check margin/padding/border
6. Try fixes live in the Styles panel before editing code
```

---

*Browser DevTools Guide v1.0 | Created: February 13, 2026*
