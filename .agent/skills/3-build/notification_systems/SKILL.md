---
name: notification_systems
description: Design and implement multi-channel notification systems — email, SMS, push, in-app, and webhooks with preference management and delivery reliability
---

# Notification Systems Skill

**Purpose**: Design and build notification infrastructure that delivers the right message through the right channel at the right time. Covers email, SMS, push notifications, in-app notifications, and webhooks — with preference management, delivery reliability, and abuse prevention.

## TRIGGER COMMANDS

```text
"set up notifications for [feature]"
"add email notifications"
"design the notification system"
"add push notifications"
"build in-app notification center"
"Using notification_systems skill: [notification type]"
```

---

## WHEN TO USE

| Situation | Use This Skill |
|-----------|---------------|
| Users need to know something happened (new message, status change, etc.) | Yes |
| System needs to alert admins about errors or thresholds | Yes |
| Transactional emails (welcome, password reset, receipts) | Yes |
| Marketing emails and campaigns | Partially — covers infrastructure, not content strategy |
| Simple console.log for debugging | No — use `observability` skill |

---

## ARCHITECTURE OVERVIEW

### The Notification Pipeline

Every notification system follows the same flow regardless of channel:

```
Event Occurs → Should We Notify? → Who Gets It? → Which Channel? → Format → Queue → Deliver → Track
```

**In NestJS terms:**

```
Service emits event → NotificationService checks preferences
  → Resolves recipients → Selects channel(s)
  → Formats content with template → Queues via Bull/Redis
  → Provider sends → Delivery tracked in database
```

### Channel Selection Matrix

| Channel | Urgency | Reach | User Must Act? | Cost | Best For |
|---------|---------|-------|----------------|------|----------|
| **In-App** | Low-Med | Only when app is open | Optional | Free | Activity feeds, updates |
| **Email** | Low-Med | Universal | Optional | $0.001/email | Transactional, digests |
| **Push (Web)** | Medium | If permission granted | Optional | Free | Time-sensitive updates |
| **Push (Mobile)** | Medium-High | If permission granted | Optional | Free | Real-time alerts |
| **SMS** | High | Universal (phone required) | Usually yes | $0.01-0.05/msg | 2FA, critical alerts |
| **Webhook** | Varies | Developer integrations | System-level | Free | API consumers, automation |

**Rule of thumb**: Start with in-app + email. Add other channels only when you have a specific use case.

---

## IMPLEMENTATION BY CHANNEL

### 1. Email Notifications

#### Provider Comparison

| Provider | Free Tier | Best For | NestJS Integration |
|----------|-----------|----------|-------------------|
| **Resend** | 3,000/month | Modern apps, React Email | `@nestjs-modules/mailer` or direct SDK |
| **SendGrid** | 100/day | Established apps, templates | `@sendgrid/mail` |
| **AWS SES** | 62,000/month (from EC2) | High volume, cost-sensitive | `@aws-sdk/client-ses` |
| **Postmark** | 100/month | Transactional only, best deliverability | `postmark` SDK |

#### NestJS Email Service Pattern

```typescript
// notification/email.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class EmailService {
  constructor(private config: ConfigService) {}

  async send(options: {
    to: string;
    subject: string;
    template: string;
    context: Record<string, any>;
  }) {
    // 1. Resolve template
    const html = await this.renderTemplate(options.template, options.context);

    // 2. Send via provider
    await this.provider.send({
      from: this.config.get('EMAIL_FROM'),
      to: options.to,
      subject: options.subject,
      html,
    });

    // 3. Log for tracking
    await this.logDelivery(options.to, options.template, 'sent');
  }

  private async renderTemplate(name: string, context: Record<string, any>) {
    // Use React Email, Handlebars, or MJML for templates
    // Template files live in: src/notification/templates/
  }
}
```

#### Essential Email Templates

Every SaaS needs these (use `email_templates` skill for detailed implementation):

| Template | Trigger | Priority |
|----------|---------|----------|
| Welcome / Verify Email | User signs up | Day 1 |
| Password Reset | User requests reset | Day 1 |
| Invitation | User invites team member | Day 1 |
| Activity Notification | Configurable events | Week 1 |
| Weekly Digest | Scheduled (cron) | Month 1 |
| Payment Receipt | Successful charge | When billing exists |
| Payment Failed | Charge fails | When billing exists |
| Account Deactivation Warning | Before auto-deactivation | When relevant |

#### Email Deliverability Checklist

- [ ] SPF record configured for sending domain
- [ ] DKIM signing enabled
- [ ] DMARC policy set
- [ ] Unsubscribe link in every non-transactional email (CAN-SPAM / GDPR)
- [ ] Bounce handling — remove hard bounces from send list
- [ ] Complaint handling — auto-unsubscribe on spam reports
- [ ] Sending domain is NOT your primary domain (use `mail.yourdomain.com`)

---

### 2. In-App Notifications

#### Database Schema (Prisma)

```prisma
model Notification {
  id          String   @id @default(uuid())
  userId      String
  type        String   // "task_assigned", "comment_added", etc.
  title       String
  body        String?
  data        Json?    // Arbitrary payload (link, entity IDs, etc.)
  read        Boolean  @default(false)
  readAt      DateTime?
  createdAt   DateTime @default(now())

  user        User     @relation(fields: [userId], references: [id])

  @@index([userId, read, createdAt])
  @@map("notifications")
}
```

#### NestJS Controller Pattern

```typescript
// notification/notification.controller.ts
@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationController {
  constructor(private notificationService: NotificationService) {}

  @Get()
  async list(@CurrentUser() user, @Query() query: ListNotificationsDto) {
    return this.notificationService.listForUser(user.sub, query);
  }

  @Get('unread-count')
  async unreadCount(@CurrentUser() user) {
    return { count: await this.notificationService.countUnread(user.sub) };
  }

  @Patch(':id/read')
  async markRead(@CurrentUser() user, @Param('id') id: string) {
    return this.notificationService.markRead(user.sub, id);
  }

  @Patch('read-all')
  async markAllRead(@CurrentUser() user) {
    return this.notificationService.markAllRead(user.sub);
  }
}
```

#### Real-Time Delivery (WebSocket)

For instant notifications without polling:

```typescript
// notification/notification.gateway.ts
@WebSocketGateway({ namespace: '/notifications' })
export class NotificationGateway {
  @WebSocketServer() server: Server;

  // Called by NotificationService after creating a notification
  sendToUser(userId: string, notification: Notification) {
    this.server.to(`user:${userId}`).emit('notification', notification);
  }

  handleConnection(client: Socket) {
    // Authenticate via JWT in handshake
    // Join room: client.join(`user:${userId}`)
  }
}
```

#### Frontend Notification Center (React)

```typescript
// Key components needed:
// 1. NotificationBell — icon with unread badge count
// 2. NotificationDropdown — list of recent notifications
// 3. NotificationItem — single notification with read/unread state
// 4. useNotifications hook — fetches, marks read, real-time updates

// Polling fallback (if not using WebSockets):
const { data } = useQuery({
  queryKey: ['notifications', 'unread-count'],
  queryFn: () => api.get('/notifications/unread-count'),
  refetchInterval: 30_000, // Poll every 30 seconds
});
```

---

### 3. Push Notifications

#### Web Push (Browser)

```typescript
// Uses the Web Push API + service worker
// Provider: Firebase Cloud Messaging (free) or self-hosted with web-push npm package

// Backend: Store push subscriptions per user
model PushSubscription {
  id        String @id @default(uuid())
  userId    String
  endpoint  String
  p256dh    String // Public key
  auth      String // Auth secret
  createdAt DateTime @default(now())

  user      User @relation(fields: [userId], references: [id])
  @@map("push_subscriptions")
}
```

#### Mobile Push

| Platform | Service | When to Use |
|----------|---------|-------------|
| iOS + Android | Firebase Cloud Messaging (FCM) | React Native, Flutter, or native apps |
| iOS only | Apple Push Notification Service (APNs) | Native iOS apps |
| Cross-platform | OneSignal | Simpler setup, free tier, analytics included |

---

### 4. SMS Notifications

**Only use SMS for high-urgency or legally required notifications.** SMS is expensive and intrusive.

| Provider | Cost/SMS | Best For |
|----------|----------|----------|
| **Twilio** | ~$0.0079 | Most apps, great API |
| **AWS SNS** | ~$0.00645 | Already on AWS |
| **MessageBird** | ~$0.006 | International focus |

#### When SMS is Appropriate

- Two-factor authentication (2FA)
- Critical account alerts (payment failed, security breach)
- Time-sensitive actions (appointment reminders, delivery updates)
- Legal/compliance requirements

#### When SMS is NOT Appropriate

- Marketing messages (without explicit consent)
- Activity notifications (use in-app or push instead)
- Anything that can wait more than 1 hour

---

### 5. Webhook Notifications

For developer/API consumers who want to be notified of events programmatically.

#### Webhook Design Pattern

```typescript
// webhook/webhook.service.ts
@Injectable()
export class WebhookService {
  async deliver(event: {
    type: string;        // "invoice.paid", "user.created"
    data: any;           // Event payload
    webhookUrl: string;  // Customer's endpoint
    secret: string;      // For signature verification
  }) {
    const payload = JSON.stringify({
      id: uuid(),
      type: event.type,
      data: event.data,
      timestamp: new Date().toISOString(),
    });

    const signature = this.sign(payload, event.secret);

    // Queue for reliable delivery
    await this.queue.add('webhook-deliver', {
      url: event.webhookUrl,
      payload,
      signature,
      attempts: 0,
      maxAttempts: 5,
    });
  }

  private sign(payload: string, secret: string): string {
    return crypto.createHmac('sha256', secret).update(payload).digest('hex');
  }
}
```

#### Webhook Retry Strategy

| Attempt | Delay | Total Wait |
|---------|-------|------------|
| 1 | Immediate | 0 |
| 2 | 1 minute | 1 min |
| 3 | 5 minutes | 6 min |
| 4 | 30 minutes | 36 min |
| 5 | 2 hours | ~2.5 hours |
| After 5 | Mark as failed, notify admin | — |

---

## PREFERENCE MANAGEMENT

Users must control what they receive. This is both good UX and legally required (GDPR, CAN-SPAM).

### Preference Schema

```prisma
model NotificationPreference {
  id        String  @id @default(uuid())
  userId    String
  channel   String  // "email", "push", "sms", "in_app"
  category  String  // "marketing", "activity", "security", "digest"
  enabled   Boolean @default(true)

  user      User    @relation(fields: [userId], references: [id])

  @@unique([userId, channel, category])
  @@map("notification_preferences")
}
```

### Default Preferences (Sensible Defaults)

| Category | In-App | Email | Push | SMS |
|----------|--------|-------|------|-----|
| **Security** (password change, new login) | Always on | Always on | Off | Off |
| **Activity** (task assigned, comment) | On | On | Off | Off |
| **Digest** (weekly summary) | Off | On | Off | Off |
| **Marketing** (product updates, tips) | Off | Off | Off | Off |

**Rules**:
- Security notifications cannot be disabled (they're for account protection)
- Default to OFF for anything interruptive (push, SMS)
- Default to ON for non-interruptive (in-app, email activity)
- Provide a one-click "mute all" option

---

## NOTIFICATION SERVICE ARCHITECTURE

### Central Notification Service

```typescript
// notification/notification.service.ts
@Injectable()
export class NotificationService {
  constructor(
    private emailService: EmailService,
    private pushService: PushService,
    private prefService: NotificationPreferenceService,
    private prisma: PrismaService,
    private gateway: NotificationGateway,
  ) {}

  async notify(event: {
    type: string;
    recipientId: string;
    title: string;
    body: string;
    data?: Record<string, any>;
  }) {
    // 1. Check preferences
    const prefs = await this.prefService.getForUser(event.recipientId);
    const category = this.categorize(event.type);

    // 2. Always create in-app notification
    const notification = await this.prisma.notification.create({
      data: {
        userId: event.recipientId,
        type: event.type,
        title: event.title,
        body: event.body,
        data: event.data,
      },
    });

    // 3. Send real-time via WebSocket
    this.gateway.sendToUser(event.recipientId, notification);

    // 4. Send to other channels based on preferences
    if (prefs.email[category]) {
      await this.emailService.send({
        to: event.recipientId,
        subject: event.title,
        template: event.type,
        context: event.data,
      });
    }

    if (prefs.push[category]) {
      await this.pushService.send(event.recipientId, {
        title: event.title,
        body: event.body,
        data: event.data,
      });
    }

    return notification;
  }

  private categorize(type: string): string {
    const map = {
      'password_changed': 'security',
      'new_login': 'security',
      'task_assigned': 'activity',
      'comment_added': 'activity',
      'weekly_digest': 'digest',
      'product_update': 'marketing',
    };
    return map[type] || 'activity';
  }
}
```

---

## COMMON NOTIFICATION PATTERNS

### 1. Notification Batching / Digest

Don't send 10 separate emails for 10 comments. Batch them.

```typescript
// Instead of: "User A commented" × 10 emails
// Send: "10 new comments on your tasks" × 1 email

// Implementation: Queue notifications, flush every N minutes or N items
// Use a scheduled job (cron) for digest emails (daily/weekly)
```

### 2. Notification Deduplication

Prevent duplicate notifications for the same event:

```typescript
// Before creating notification, check:
const existing = await prisma.notification.findFirst({
  where: {
    userId: recipientId,
    type: eventType,
    data: { path: ['entityId'], equals: entityId },
    createdAt: { gte: fiveMinutesAgo },
  },
});
if (existing) return; // Skip duplicate
```

### 3. Quiet Hours

Respect users' time zones and sleep schedules:

```typescript
// Check user's timezone before sending push/SMS
// If between 22:00-08:00 user local time, queue for morning delivery
// Email and in-app are fine anytime
```

### 4. Notification Escalation

If a notification isn't acted on, escalate to a more urgent channel:

```
In-app notification created →
  If unread after 1 hour → Send email →
    If no action after 24 hours → Send push notification →
      If critical and no action after 48 hours → SMS
```

---

## ABUSE PREVENTION

| Protection | Implementation |
|---|---|
| Rate limiting per user | Max 50 notifications/hour per user (configurable) |
| Rate limiting per channel | Max 5 SMS/day per user, max 20 push/day |
| Bounce management | Auto-disable email after 3 hard bounces |
| Complaint handling | Auto-unsubscribe on spam report |
| Unsubscribe compliance | One-click unsubscribe in every email (RFC 8058) |
| Content validation | Sanitize all user-generated content in notifications |

---

## TESTING NOTIFICATIONS

```typescript
// In tests, use a mock/in-memory notification service
// that captures sent notifications for assertion:

const sent = notificationService.getSentNotifications();
expect(sent).toContainEqual(
  expect.objectContaining({
    type: 'task_assigned',
    recipientId: user.id,
  }),
);

// In development, use a local email catcher:
// - MailHog (Docker: mailhog/mailhog, UI on :8025)
// - Mailtrap (cloud-based, free tier)
```

---

## EXIT CHECKLIST

- [ ] Notification types defined (what events trigger notifications)
- [ ] Channels selected (start with in-app + email minimum)
- [ ] Database schema created (notifications + preferences)
- [ ] Central NotificationService handles all dispatching
- [ ] User preference management (settings UI + API)
- [ ] Email deliverability configured (SPF, DKIM, DMARC)
- [ ] Templates created for all transactional emails
- [ ] Unsubscribe mechanism working (legal compliance)
- [ ] Real-time delivery working (WebSocket or polling fallback)
- [ ] Notification batching for high-frequency events
- [ ] Rate limiting to prevent abuse
- [ ] Tested with mock provider in test environment

---

*Skill Version: 1.0 | Created: February 14, 2026*
