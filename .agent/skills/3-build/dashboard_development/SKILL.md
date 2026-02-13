---
name: Dashboard Development
description: Building data dashboards, analytics interfaces, and business intelligence visualizations
---

# Dashboard Development Skill

**Purpose**: Structured workflow for designing, building, and optimizing data dashboards and business intelligence interfaces with proper chart selection, performance, and accessibility.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a dashboard for [data/domain]"
"Create an analytics dashboard for [metrics]"
"Data visualization for [dataset]"
"KPI dashboard for [business area]"
"Using dashboard_development skill: [task]"
```

---

## 📊 Dashboard Types

| Type | Update Frequency | Audience | Focus | Example |
|------|-----------------|----------|-------|---------|
| **Operational** | Real-time / near-real-time | Ops teams, engineers | Current state, alerts | Server monitoring, order tracking |
| **Analytical** | Hourly / daily | Analysts, product managers | Trends, exploration | User behavior, cohort analysis |
| **Strategic** | Weekly / monthly | Executives, leadership | KPIs, high-level trends | Revenue, growth, OKR progress |

> [!TIP]
> Identify your dashboard type before building. Operational dashboards need WebSocket or short polling. Strategic dashboards can refresh on page load. Building real-time when daily is sufficient wastes engineering effort.

---

## 🛠️ Tool Selection

### Off-the-Shelf BI Tools

| Tool | License | Best For | Data Connection | Customization |
|------|---------|----------|-----------------|---------------|
| **Metabase** | Open source (AGPL) | SQL-based exploration, quick setup | Direct DB, REST API | Medium (limited) |
| **Grafana** | Open source (AGPL) | Time-series metrics, alerting | Prometheus, InfluxDB, SQL | High (plugins) |
| **Apache Superset** | Open source (Apache 2.0) | Full BI, SQL Lab, dashboards | SQLAlchemy (50+ DBs) | High (custom viz) |
| **Looker** | Commercial (Google) | LookML modeling, governed analytics | BigQuery, SQL DBs | High (LookML) |
| **Tableau** | Commercial | Drag-and-drop, executive dashboards | Everything | Medium |
| **Power BI** | Commercial (Microsoft) | Microsoft ecosystem, Excel users | Everything | Medium |
| **Retool** | Commercial | Internal tools, CRUD dashboards | APIs, DBs | Very High |

### Custom Dashboard Charting Libraries

| Library | Framework | Strengths | Bundle Size | Learning Curve |
|---------|-----------|-----------|-------------|---------------|
| **Recharts** | React | Simple API, composable, good defaults | ~45KB | Low |
| **Chart.js** | Framework-agnostic | Lightweight, 8 chart types, canvas-based | ~65KB | Low |
| **D3.js** | Framework-agnostic | Total control, any visualization possible | ~85KB | Very High |
| **Nivo** | React | Beautiful defaults, many chart types, D3-based | ~varies | Medium |
| **Tremor** | React | Dashboard-specific components, Tailwind-based | ~varies | Low |
| **ECharts** | Framework-agnostic | Enterprise-grade, huge chart library, WebGL | ~300KB+ | Medium |
| **Victory** | React/React Native | Cross-platform, good animations | ~50KB | Medium |
| **Visx** | React | Low-level D3 + React primitives | ~varies | High |

> [!TIP]
> **Recharts** for most React dashboards (simple, composable, sufficient for 90% of use cases). **ECharts** for complex enterprise dashboards with many chart types. **D3.js** only when you need fully custom visualizations that no library provides.

---

## 🎨 Dashboard Design Principles

### Layout Rules

| Rule | Why | Implementation |
|------|-----|----------------|
| **Most important metric at top-left** | Eyes scan F-pattern (left to right, top to bottom) | Place primary KPI in top-left card |
| **5-7 metrics per view** | Cognitive overload beyond 7 items | Group into tabs or drill-down pages |
| **Consistent color coding** | Reduces cognitive load | Green = good, red = bad, across all charts |
| **Meaningful defaults** | Users should see value immediately | Default date range = last 30 days, not "all time" |
| **Drill-down capability** | Summary first, detail on demand | Click chart segment to filter/navigate |
| **Proper date range selector** | Context for every number | Always visible, persistent across charts |
| **White space** | Prevents visual clutter | 16-24px gaps between cards, consistent padding |

### Chart Selection Guide

| Data Question | Chart Type | When to Use | When NOT to Use |
|--------------|------------|-------------|-----------------|
| **Trend over time** | Line chart | Continuous time-series data | Fewer than 5 data points |
| **Compare categories** | Bar chart (vertical) | Discrete categories, rankings | More than 15 categories |
| **Composition** | Pie / Donut chart | Parts of a whole, max 5 slices | More than 5 categories (use bar) |
| **Volume over time** | Area chart | Show magnitude of trends | Overlapping series (hard to read) |
| **Correlation** | Scatter plot | Relationship between 2 variables | Categorical data |
| **Distribution** | Histogram / Heatmap | Frequency, density patterns | Small datasets |
| **Single metric** | KPI card | One number with context | When trend matters more |
| **Detailed records** | Data table | Exact values, sortable, searchable | Overview/summary views |
| **Progress** | Gauge / Progress bar | Percentage toward goal | Multiple metrics |
| **Flow/Conversion** | Funnel chart | Step-by-step dropoff rates | Non-sequential data |

> [!WARNING]
> Pie charts with more than 5 slices are nearly impossible to read. Use a horizontal bar chart instead. Also, never use 3D charts -- they distort perception and add no information.

---

## 🃏 KPI Card Component

Every KPI card needs these five elements:

| Element | Purpose | Example |
|---------|---------|---------|
| **Title** | What metric this is | "Monthly Revenue" |
| **Current Value** | The number | "$142,500" |
| **Comparison** | Context (vs last period or target) | "+12.3% vs last month" |
| **Trend Direction** | Visual indicator | Up arrow (green) or down arrow (red) |
| **Time Period** | When this data is from | "Jan 2026" |

```tsx
// KPI Card Component (React + Tailwind)
import React from 'react';

interface KpiCardProps {
  title: string;
  value: string;
  change: number;       // percentage change
  changeLabel: string;  // "vs last month"
  period: string;
  invertColor?: boolean; // true if decrease is good (e.g., error rate)
}

export function KpiCard({ title, value, change, changeLabel, period, invertColor = false }: KpiCardProps) {
  const isPositive = invertColor ? change <= 0 : change >= 0;
  const colorClass = isPositive ? 'text-green-600' : 'text-red-600';
  const bgColorClass = isPositive ? 'bg-green-50' : 'bg-red-50';
  const arrow = change >= 0 ? '\u2191' : '\u2193'; // up/down arrows

  return (
    <div className="rounded-lg border bg-white p-6 shadow-sm">
      <div className="flex items-center justify-between">
        <p className="text-sm font-medium text-gray-500">{title}</p>
        <span className="text-xs text-gray-400">{period}</span>
      </div>
      <p className="mt-2 text-3xl font-bold text-gray-900">{value}</p>
      <div className="mt-2 flex items-center gap-2">
        <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${bgColorClass} ${colorClass}`}>
          {arrow} {Math.abs(change).toFixed(1)}%
        </span>
        <span className="text-xs text-gray-500">{changeLabel}</span>
      </div>
    </div>
  );
}

// Usage
<KpiCard
  title="Monthly Revenue"
  value="$142,500"
  change={12.3}
  changeLabel="vs last month"
  period="Jan 2026"
/>
<KpiCard
  title="Error Rate"
  value="0.42%"
  change={-18.5}
  changeLabel="vs last week"
  period="Week 5"
  invertColor={true}  // decrease is good
/>
```

---

## 📈 Line Chart with Recharts

```tsx
import React from 'react';
import {
  LineChart, Line, XAxis, YAxis, CartesianGrid,
  Tooltip, Legend, ResponsiveContainer,
} from 'recharts';

interface DataPoint {
  date: string;
  revenue: number;
  expenses: number;
}

const data: DataPoint[] = [
  { date: 'Jan', revenue: 42000, expenses: 28000 },
  { date: 'Feb', revenue: 48000, expenses: 30000 },
  { date: 'Mar', revenue: 55000, expenses: 32000 },
  { date: 'Apr', revenue: 52000, expenses: 31000 },
  { date: 'May', revenue: 61000, expenses: 35000 },
  { date: 'Jun', revenue: 67000, expenses: 37000 },
];

const formatCurrency = (value: number) =>
  new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(value);

export function RevenueChart() {
  return (
    <div className="rounded-lg border bg-white p-6">
      <h3 className="mb-4 text-lg font-semibold text-gray-900">Revenue vs Expenses</h3>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data} margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis dataKey="date" tick={{ fontSize: 12 }} />
          <YAxis tickFormatter={formatCurrency} tick={{ fontSize: 12 }} />
          <Tooltip formatter={(value: number) => formatCurrency(value)} />
          <Legend />
          <Line
            type="monotone"
            dataKey="revenue"
            stroke="#2563eb"
            strokeWidth={2}
            dot={{ r: 4 }}
            activeDot={{ r: 6 }}
            name="Revenue"
          />
          <Line
            type="monotone"
            dataKey="expenses"
            stroke="#dc2626"
            strokeWidth={2}
            dot={{ r: 4 }}
            name="Expenses"
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
```

---

## 📅 Date Range Filter Component

```tsx
import React, { useState } from 'react';

type Preset = '7d' | '30d' | '90d' | '12m' | 'ytd' | 'custom';

interface DateRangeFilterProps {
  onChange: (start: Date, end: Date, preset: Preset) => void;
}

const presets: { key: Preset; label: string; getDates: () => [Date, Date] }[] = [
  {
    key: '7d',
    label: 'Last 7 days',
    getDates: () => {
      const end = new Date();
      const start = new Date();
      start.setDate(end.getDate() - 7);
      return [start, end];
    },
  },
  {
    key: '30d',
    label: 'Last 30 days',
    getDates: () => {
      const end = new Date();
      const start = new Date();
      start.setDate(end.getDate() - 30);
      return [start, end];
    },
  },
  {
    key: '90d',
    label: 'Last 90 days',
    getDates: () => {
      const end = new Date();
      const start = new Date();
      start.setDate(end.getDate() - 90);
      return [start, end];
    },
  },
  {
    key: '12m',
    label: 'Last 12 months',
    getDates: () => {
      const end = new Date();
      const start = new Date();
      start.setFullYear(end.getFullYear() - 1);
      return [start, end];
    },
  },
  {
    key: 'ytd',
    label: 'Year to date',
    getDates: () => {
      const end = new Date();
      const start = new Date(end.getFullYear(), 0, 1);
      return [start, end];
    },
  },
];

export function DateRangeFilter({ onChange }: DateRangeFilterProps) {
  const [active, setActive] = useState<Preset>('30d');

  const handleClick = (preset: typeof presets[number]) => {
    setActive(preset.key);
    const [start, end] = preset.getDates();
    onChange(start, end, preset.key);
  };

  return (
    <div className="flex gap-1 rounded-lg border bg-gray-50 p-1">
      {presets.map((preset) => (
        <button
          key={preset.key}
          onClick={() => handleClick(preset)}
          className={`rounded-md px-3 py-1.5 text-sm font-medium transition-colors ${
            active === preset.key
              ? 'bg-white text-gray-900 shadow-sm'
              : 'text-gray-500 hover:text-gray-700'
          }`}
        >
          {preset.label}
        </button>
      ))}
    </div>
  );
}
```

---

## 🔄 Real-Time Dashboard with WebSocket

```tsx
import React, { useEffect, useRef, useState, useCallback } from 'react';

interface MetricUpdate {
  metric: string;
  value: number;
  timestamp: number;
}

export function useRealtimeMetrics(wsUrl: string) {
  const [metrics, setMetrics] = useState<Record<string, MetricUpdate>>({});
  const [connected, setConnected] = useState(false);
  const wsRef = useRef<WebSocket | null>(null);
  const reconnectTimer = useRef<NodeJS.Timeout>();

  const connect = useCallback(() => {
    const ws = new WebSocket(wsUrl);
    wsRef.current = ws;

    ws.onopen = () => {
      setConnected(true);
      console.log('WebSocket connected');
    };

    ws.onmessage = (event) => {
      const update: MetricUpdate = JSON.parse(event.data);
      setMetrics((prev) => ({
        ...prev,
        [update.metric]: update,
      }));
    };

    ws.onclose = () => {
      setConnected(false);
      // Reconnect after 3 seconds
      reconnectTimer.current = setTimeout(connect, 3000);
    };

    ws.onerror = () => {
      ws.close();
    };
  }, [wsUrl]);

  useEffect(() => {
    connect();
    return () => {
      wsRef.current?.close();
      if (reconnectTimer.current) clearTimeout(reconnectTimer.current);
    };
  }, [connect]);

  return { metrics, connected };
}

// Usage in dashboard component
function RealtimeDashboard() {
  const { metrics, connected } = useRealtimeMetrics('wss://api.example.com/ws/metrics');

  return (
    <div>
      <div className="flex items-center gap-2 mb-4">
        <div className={`h-2 w-2 rounded-full ${connected ? 'bg-green-500' : 'bg-red-500'}`} />
        <span className="text-sm text-gray-500">
          {connected ? 'Live' : 'Reconnecting...'}
        </span>
      </div>
      <div className="grid grid-cols-4 gap-4">
        {Object.values(metrics).map((m) => (
          <KpiCard
            key={m.metric}
            title={m.metric}
            value={m.value.toLocaleString()}
            change={0}
            changeLabel="live"
            period="Now"
          />
        ))}
      </div>
    </div>
  );
}
```

---

## 🗄️ Data Backend Patterns

| Pattern | Complexity | Scalability | Latency | Best For |
|---------|-----------|-------------|---------|----------|
| **Direct DB queries** | Low | Low (DB load) | Medium | Prototyping, small datasets |
| **Materialized views** | Medium | Medium | Low | Pre-aggregated metrics, PostgreSQL |
| **Caching layer (Redis)** | Medium | High | Very Low | Frequently accessed dashboards |
| **Dedicated analytics API** | High | High | Low | Multi-dashboard platforms |
| **OLAP cube (ClickHouse)** | High | Very High | Very Low | Billions of rows, ad-hoc queries |

```sql
-- PostgreSQL materialized view for dashboard metrics
CREATE MATERIALIZED VIEW daily_metrics AS
SELECT
  date_trunc('day', created_at) AS day,
  COUNT(*)                       AS total_orders,
  SUM(amount)                    AS total_revenue,
  AVG(amount)                    AS avg_order_value,
  COUNT(DISTINCT user_id)        AS unique_customers
FROM orders
WHERE status = 'completed'
GROUP BY date_trunc('day', created_at)
ORDER BY day DESC;

-- Refresh on schedule (e.g., via cron or pg_cron)
REFRESH MATERIALIZED VIEW CONCURRENTLY daily_metrics;

-- Create index for fast lookups
CREATE UNIQUE INDEX idx_daily_metrics_day ON daily_metrics (day);
```

---

## 📱 Responsive Dashboard Design

| Screen Size | Layout Strategy | Chart Adaptation |
|------------|----------------|------------------|
| **Desktop (1200px+)** | 3-4 column grid, full charts | Full interactive charts |
| **Tablet (768-1199px)** | 2 column grid, stacked | Simplified tooltips |
| **Mobile (< 768px)** | Single column, cards | Mini charts or KPI cards only |

```tsx
// Dashboard grid layout with react-grid-layout
import React from 'react';
import { Responsive, WidthProvider } from 'react-grid-layout';
import 'react-grid-layout/css/styles.css';

const ResponsiveGrid = WidthProvider(Responsive);

const layouts = {
  lg: [
    { i: 'kpi-1', x: 0, y: 0, w: 3, h: 2 },
    { i: 'kpi-2', x: 3, y: 0, w: 3, h: 2 },
    { i: 'kpi-3', x: 6, y: 0, w: 3, h: 2 },
    { i: 'kpi-4', x: 9, y: 0, w: 3, h: 2 },
    { i: 'chart-main', x: 0, y: 2, w: 8, h: 5 },
    { i: 'chart-side', x: 8, y: 2, w: 4, h: 5 },
    { i: 'table', x: 0, y: 7, w: 12, h: 5 },
  ],
  md: [
    { i: 'kpi-1', x: 0, y: 0, w: 3, h: 2 },
    { i: 'kpi-2', x: 3, y: 0, w: 3, h: 2 },
    { i: 'kpi-3', x: 0, y: 2, w: 3, h: 2 },
    { i: 'kpi-4', x: 3, y: 2, w: 3, h: 2 },
    { i: 'chart-main', x: 0, y: 4, w: 6, h: 5 },
    { i: 'chart-side', x: 0, y: 9, w: 6, h: 5 },
    { i: 'table', x: 0, y: 14, w: 6, h: 5 },
  ],
};

export function DashboardLayout() {
  return (
    <ResponsiveGrid
      className="layout"
      layouts={layouts}
      breakpoints={{ lg: 1200, md: 768, sm: 480 }}
      cols={{ lg: 12, md: 6, sm: 1 }}
      rowHeight={60}
      isDraggable={false}
      isResizable={false}
    >
      <div key="kpi-1"><KpiCard title="Revenue" value="$142K" change={12.3} changeLabel="vs last month" period="Jan 2026" /></div>
      <div key="kpi-2"><KpiCard title="Users" value="8,421" change={5.7} changeLabel="vs last month" period="Jan 2026" /></div>
      <div key="kpi-3"><KpiCard title="Conversion" value="3.2%" change={-1.1} changeLabel="vs last month" period="Jan 2026" /></div>
      <div key="kpi-4"><KpiCard title="Churn" value="2.1%" change={-0.3} changeLabel="vs last month" period="Jan 2026" invertColor /></div>
      <div key="chart-main"><RevenueChart /></div>
      <div key="chart-side">{/* Side chart component */}</div>
      <div key="table">{/* Data table component */}</div>
    </ResponsiveGrid>
  );
}
```

---

## 🏎️ Performance Optimization

| Technique | Impact | Implementation |
|-----------|--------|----------------|
| **Lazy load charts** | Faster initial render | `React.lazy()` + `Suspense` for charts below fold |
| **Skeleton screens** | Perceived performance | Show gray placeholders while data loads |
| **Cache API responses** | Fewer network requests | `react-query` / `SWR` with stale-while-revalidate |
| **Paginate tables** | DOM size reduction | Server-side pagination for 100+ rows |
| **Debounce filters** | Fewer API calls | 300ms debounce on filter input changes |
| **Virtualize lists** | Render only visible rows | `react-virtual` / `react-window` for long tables |
| **Memoize charts** | Prevent unnecessary re-renders | `React.memo()` with proper comparison |
| **Web Workers** | Offload computation | Parse large datasets off main thread |

---

## ♿ Accessibility in Dashboards

| Requirement | Implementation | Why |
|-------------|---------------|-----|
| **Chart descriptions** | `aria-label` on chart container with text summary | Screen readers cannot interpret visual charts |
| **Data table alternative** | Provide table view toggle for every chart | Tabular data is accessible by default |
| **Keyboard navigation** | Tab through filters, Enter to activate | Not everyone uses a mouse |
| **Color-blind friendly** | Use patterns/shapes + labels, not just color | 8% of men have color vision deficiency |
| **Focus indicators** | Visible focus rings on all interactive elements | Keyboard users need to see where they are |
| **Reduced motion** | Respect `prefers-reduced-motion` | Animations can cause vestibular issues |

> [!TIP]
> Test with a screen reader (VoiceOver on Mac, NVDA on Windows). If a blind user cannot understand the dashboard's key metrics from screen reader output alone, add more descriptive labels and a data table fallback.

---

## ❌ Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| **Too many metrics** | Information overload, nothing stands out | Limit to 5-7 per view, use tabs |
| **Pie charts with 8+ slices** | Unreadable, tiny slices | Use horizontal bar chart |
| **Y-axis not starting at 0** | Exaggerates small differences | Start bar charts at 0 (line charts can vary) |
| **No context for numbers** | "$50K" means nothing alone | Add comparison: "+12% vs last month" |
| **Missing time period** | Ambiguous data | Always label what time range is shown |
| **Auto-refresh without indicator** | User confusion when numbers change | Show "Last updated: X" and refresh indicator |
| **No empty state** | Broken-looking dashboard with no data | Show helpful message: "No data for this period" |

---

## ✅ EXIT CHECKLIST

- [ ] Key metrics visible without scrolling (above the fold)
- [ ] All charts load in under 2 seconds
- [ ] Filters work correctly and persist across navigation
- [ ] Responsive layout works on tablet (768px) and mobile (375px)
- [ ] Accessible: aria-labels on charts, keyboard navigable, color-blind safe
- [ ] Data refreshes properly (WebSocket, polling, or on-demand)
- [ ] Export functionality works (CSV for tables, PNG for charts)
- [ ] Empty states handled gracefully for all components
- [ ] Error states show user-friendly messages (not raw errors)
- [ ] Date range selector defaults are meaningful
- [ ] Performance: memoized charts, debounced filters, paginated tables

---

*Skill Version: 1.0 | Created: February 2026*
