---
name: Alpha Telemetry
description: Alpha-specific instrumentation for session-level events, crash reporting, performance baselines, and consent management
---

# Alpha Telemetry Skill

**Purpose**: Implement alpha-specific instrumentation that goes beyond generic error tracking to capture session-level event sequences, crash context, performance baselines per user cohort, and resource consumption metrics. This produces the quantitative data needed for alpha exit criteria evaluation while respecting tester consent preferences.

## TRIGGER COMMANDS

```text
"Alpha telemetry setup"
"Instrument alpha build"
"Alpha performance baseline"
"Set up alpha analytics"
"Using alpha_telemetry skill: instrument [product]"
```

## When to Use
- When setting up monitoring for the first alpha deployment
- When existing error tracking does not provide sufficient session-level context
- When the team needs to establish performance baselines before beta scaling
- When alpha exit criteria require quantitative metrics that are not yet collected

---

## PROCESS

### Step 1: Define Alpha Telemetry Events

Alpha telemetry captures more detail than production analytics because the cohort is small and signal quality matters more than volume efficiency:

```typescript
// alpha-telemetry.types.ts
interface AlphaEvent {
  // Core fields (every event)
  eventId: string;           // UUID
  sessionId: string;         // Session identifier
  userId: string;            // Alpha tester ID
  timestamp: string;         // ISO 8601
  eventType: AlphaEventType;

  // Context (auto-captured)
  pageUrl?: string;
  userAgent?: string;
  screenSize?: string;
  networkType?: string;      // 'wifi' | '4g' | '3g' | 'offline'

  // Event-specific payload
  payload: Record<string, unknown>;
}

type AlphaEventType =
  | 'SESSION_START'
  | 'SESSION_END'
  | 'PAGE_VIEW'
  | 'WORKFLOW_START'
  | 'WORKFLOW_STEP'
  | 'WORKFLOW_COMPLETE'
  | 'WORKFLOW_ABANDON'
  | 'ERROR_CAUGHT'
  | 'ERROR_UNCAUGHT'
  | 'PERFORMANCE_MARK'
  | 'FEEDBACK_SUBMITTED'
  | 'FEATURE_USED';
```

### Step 2: Implement Session-Level Event Collection

```typescript
// alpha-telemetry.service.ts (Frontend)
class AlphaTelemetryClient {
  private sessionId: string;
  private eventBuffer: AlphaEvent[] = [];
  private flushInterval: number;
  private consentGranted: boolean = false;

  constructor(private readonly endpoint: string) {
    this.sessionId = crypto.randomUUID();
    this.flushInterval = window.setInterval(() => this.flush(), 30_000);
    this.setupGlobalHandlers();
  }

  setConsent(granted: boolean): void {
    this.consentGranted = granted;
    if (!granted) {
      this.eventBuffer = [];
    }
  }

  track(eventType: AlphaEventType, payload: Record<string, unknown> = {}): void {
    if (!this.consentGranted) return;

    this.eventBuffer.push({
      eventId: crypto.randomUUID(),
      sessionId: this.sessionId,
      userId: this.getCurrentUserId(),
      timestamp: new Date().toISOString(),
      eventType,
      pageUrl: window.location.pathname,
      userAgent: navigator.userAgent,
      screenSize: `${window.innerWidth}x${window.innerHeight}`,
      payload,
    });

    // Auto-flush if buffer exceeds 50 events
    if (this.eventBuffer.length >= 50) {
      this.flush();
    }
  }

  trackWorkflow(workflowName: string, step: string, metadata?: Record<string, unknown>): void {
    this.track('WORKFLOW_STEP', { workflowName, step, ...metadata });
  }

  trackPerformance(markName: string, durationMs: number): void {
    this.track('PERFORMANCE_MARK', { markName, durationMs });
  }

  private async flush(): Promise<void> {
    if (this.eventBuffer.length === 0) return;

    const events = [...this.eventBuffer];
    this.eventBuffer = [];

    try {
      await fetch(this.endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ events }),
        keepalive: true,
      });
    } catch {
      // Re-queue failed events (up to limit)
      this.eventBuffer.unshift(...events.slice(0, 100));
    }
  }

  private setupGlobalHandlers(): void {
    window.addEventListener('error', (event) => {
      this.track('ERROR_UNCAUGHT', {
        message: event.message,
        filename: event.filename,
        lineno: event.lineno,
        colno: event.colno,
      });
    });

    window.addEventListener('unhandledrejection', (event) => {
      this.track('ERROR_UNCAUGHT', {
        message: String(event.reason),
        type: 'unhandled_promise_rejection',
      });
    });

    window.addEventListener('beforeunload', () => {
      this.track('SESSION_END', {
        sessionDurationMs: performance.now(),
      });
      this.flush();
    });
  }

  private getCurrentUserId(): string {
    // Retrieve from auth context
    return localStorage.getItem('alpha_user_id') ?? 'anonymous';
  }
}
```

### Step 3: Backend Telemetry Ingestion

```typescript
// alpha-telemetry.controller.ts
@Controller('telemetry')
export class AlphaTelemetryController {
  constructor(private readonly telemetry: AlphaTelemetryService) {}

  @Post('events')
  @UseGuards(JwtAuthGuard, AlphaAccessGuard)
  async ingestEvents(
    @Body() body: { events: AlphaEvent[] },
    @CurrentUser() user: { sub: string },
  ): Promise<{ success: true; count: number }> {
    const count = await this.telemetry.ingest(body.events, user.sub);
    return { success: true, count };
  }
}

// alpha-telemetry.service.ts (Backend)
@Injectable()
export class AlphaTelemetryService {
  constructor(private readonly prisma: PrismaService) {}

  async ingest(events: AlphaEvent[], userId: string): Promise<number> {
    // Override userId from auth token (prevent spoofing)
    const sanitized = events.map(e => ({
      ...e,
      userId,
      payload: JSON.stringify(e.payload),
    }));

    const result = await this.prisma.alphaTelemetryEvent.createMany({
      data: sanitized,
      skipDuplicates: true,
    });

    return result.count;
  }

  async getSessionSummary(sessionId: string): Promise<{
    events: number;
    duration: number;
    errors: number;
    workflowsCompleted: number;
  }> {
    const events = await this.prisma.alphaTelemetryEvent.findMany({
      where: { sessionId },
      orderBy: { timestamp: 'asc' },
    });

    return {
      events: events.length,
      duration: events.length > 1
        ? new Date(events[events.length - 1].timestamp).getTime() -
          new Date(events[0].timestamp).getTime()
        : 0,
      errors: events.filter(e =>
        e.eventType === 'ERROR_CAUGHT' || e.eventType === 'ERROR_UNCAUGHT'
      ).length,
      workflowsCompleted: events.filter(e =>
        e.eventType === 'WORKFLOW_COMPLETE'
      ).length,
    };
  }
}
```

### Step 4: Performance Baseline Establishment

Use alpha telemetry to establish baselines that inform beta performance targets:

```markdown
## Performance Baseline Report Template

### API Latency (measured over last 14 days)
| Endpoint | p50 | p95 | p99 | Requests |
|----------|-----|-----|-----|----------|
| GET /api/v1/... | ___ms | ___ms | ___ms | ___ |
| POST /api/v1/... | ___ms | ___ms | ___ms | ___ |

### Frontend Performance (Web Vitals)
| Metric | p50 | p75 | p95 |
|--------|-----|-----|-----|
| LCP | ___s | ___s | ___s |
| FID | ___ms | ___ms | ___ms |
| CLS | ___ | ___ | ___ |

### Resource Consumption
| Resource | Average | Peak | Threshold |
|----------|---------|------|-----------|
| Memory (RSS) | ___MB | ___MB | ___MB |
| CPU usage | ___% | ___% | ___% |
| Database connections | ___ | ___ | ___ |
| Disk usage growth/day | ___MB | ___MB | ___MB |
```

### Step 5: Consent Management

Alpha testers must opt in to telemetry collection:

```typescript
// AlphaConsentBanner.tsx
function AlphaConsentBanner() {
  const [consent, setConsent] = useState<boolean | null>(null);

  const handleConsent = (granted: boolean) => {
    setConsent(granted);
    localStorage.setItem('alpha_telemetry_consent', String(granted));
    window.alphaTelemetry?.setConsent(granted);
  };

  if (consent !== null) return null;

  return (
    <div role="dialog" aria-label="Telemetry consent">
      <h3>Help Us Improve</h3>
      <p>
        As an alpha tester, you can help us by allowing anonymous usage
        telemetry. This includes session events, performance metrics, and
        error reports. No personal content is collected.
      </p>
      <button onClick={() => handleConsent(true)}>Allow Telemetry</button>
      <button onClick={() => handleConsent(false)}>No Thanks</button>
    </div>
  );
}
```

---

## CHECKLIST

- [ ] Alpha telemetry event types defined (session, workflow, error, performance)
- [ ] Frontend telemetry client implemented with event buffering and flush
- [ ] Backend ingestion endpoint secured with JwtAuthGuard + AlphaAccessGuard
- [ ] Global error handlers capture uncaught errors and unhandled rejections
- [ ] Workflow tracking instruments primary and secondary user flows
- [ ] Performance marks capture key operation durations
- [ ] Consent banner shown on first session, telemetry disabled if declined
- [ ] Session summary queries available for exit criteria evaluation
- [ ] Performance baseline report template populated from telemetry data
- [ ] Telemetry data retention policy defined (recommend: delete 30 days after alpha closure)
- [ ] No PII stored in telemetry event payloads

---

*Skill Version: 1.0 | Created: February 2026*
