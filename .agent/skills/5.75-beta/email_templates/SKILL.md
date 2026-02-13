---
name: email_templates
description: Branded transactional email templates with Resend and React Email
---

# Email Templates Skill

**Purpose**: Create a complete set of branded transactional email templates using React Email and Resend, covering every essential email a SaaS application needs from signup to account deletion.

## :dart: TRIGGER COMMANDS

```text
"create email templates"
"branded emails"
"transactional emails"
"set up email system"
"Using email_templates skill: create transactional emails for [project]"
```

## :package: EMAIL PROVIDER SETUP

### Recommended: Resend

| Provider | Pros | Cons |
|----------|------|------|
| **Resend** (recommended) | Modern API, React Email native, generous free tier | Newer service |
| SendGrid | Battle-tested, large scale | Complex API, heavy SDK |
| AWS SES | Cheapest at scale, reliable | Complex setup, raw API |
| Postmark | Best deliverability | Higher cost |

### Install Dependencies

```bash
# Email sending
npm install resend

# Template building
npm install @react-email/components react-email
```

### Environment Variables

```bash
# .env
RESEND_API_KEY=re_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
EMAIL_FROM="Zenith <noreply@yourdomain.com>"
EMAIL_REPLY_TO="support@yourdomain.com"
APP_NAME="Zenith"
APP_URL="https://app.yourdomain.com"
```

> [!WARNING]
> You must verify your sending domain in Resend before sending emails. Unverified domains can only send to the account owner's email address.

## :gear: BACKEND EMAIL SERVICE (NestJS)

### EmailService

```typescript
// src/email/email.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { Resend } from 'resend';

interface SendEmailOptions {
  to: string | string[];
  subject: string;
  html: string;
  text: string;
  replyTo?: string;
  tags?: { name: string; value: string }[];
}

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private resend: Resend;
  private from: string;

  constructor() {
    this.resend = new Resend(process.env.RESEND_API_KEY);
    this.from = process.env.EMAIL_FROM || 'App <noreply@example.com>';
  }

  async send(options: SendEmailOptions): Promise<{ id: string } | null> {
    try {
      const { data, error } = await this.resend.emails.send({
        from: this.from,
        to: Array.isArray(options.to) ? options.to : [options.to],
        subject: options.subject,
        html: options.html,
        text: options.text,
        reply_to: options.replyTo || process.env.EMAIL_REPLY_TO,
        tags: options.tags,
      });

      if (error) {
        this.logger.error(`Email send failed: ${error.message}`, error);
        return null;
      }

      this.logger.log(`Email sent: ${data?.id} to ${options.to}`);
      return data;
    } catch (err) {
      this.logger.error('Email send exception', err);
      return null;
    }
  }

  async sendWelcome(to: string, userName: string) {
    return this.send({
      to,
      subject: `Welcome to ${process.env.APP_NAME}!`,
      html: this.buildWelcomeHtml(userName),
      text: this.buildWelcomeText(userName),
      tags: [{ name: 'category', value: 'welcome' }],
    });
  }

  async sendTeamInvitation(to: string, inviterName: string, orgName: string, inviteUrl: string) {
    return this.send({
      to,
      subject: `${inviterName} invited you to join ${orgName}`,
      html: this.buildInvitationHtml(inviterName, orgName, inviteUrl),
      text: this.buildInvitationText(inviterName, orgName, inviteUrl),
      tags: [{ name: 'category', value: 'invitation' }],
    });
  }

  async sendPasswordReset(to: string, resetUrl: string) {
    return this.send({
      to,
      subject: 'Reset your password',
      html: this.buildPasswordResetHtml(resetUrl),
      text: this.buildPasswordResetText(resetUrl),
      tags: [{ name: 'category', value: 'password-reset' }],
    });
  }

  async sendPaymentReceipt(
    to: string,
    receiptData: { amount: string; planName: string; date: string; invoiceUrl: string },
  ) {
    return this.send({
      to,
      subject: `Payment receipt - ${receiptData.amount}`,
      html: this.buildPaymentReceiptHtml(receiptData),
      text: this.buildPaymentReceiptText(receiptData),
      tags: [{ name: 'category', value: 'receipt' }],
    });
  }

  async sendPlanChange(to: string, fromPlan: string, toPlan: string, effectiveDate: string) {
    const direction = toPlan > fromPlan ? 'upgraded' : 'changed';
    return this.send({
      to,
      subject: `Your plan has been ${direction}`,
      html: this.buildPlanChangeHtml(fromPlan, toPlan, effectiveDate),
      text: this.buildPlanChangeText(fromPlan, toPlan, effectiveDate),
      tags: [{ name: 'category', value: 'plan-change' }],
    });
  }

  async sendUsageWarning(to: string, resource: string, currentUsage: number, limit: number) {
    const percentage = Math.round((currentUsage / limit) * 100);
    return this.send({
      to,
      subject: `Usage alert: ${resource} at ${percentage}%`,
      html: this.buildUsageWarningHtml(resource, currentUsage, limit, percentage),
      text: this.buildUsageWarningText(resource, currentUsage, limit, percentage),
      tags: [{ name: 'category', value: 'usage-warning' }],
    });
  }

  async sendTrialExpiring(to: string, userName: string, daysLeft: number, upgradeUrl: string) {
    return this.send({
      to,
      subject: `Your trial expires in ${daysLeft} day${daysLeft === 1 ? '' : 's'}`,
      html: this.buildTrialExpiringHtml(userName, daysLeft, upgradeUrl),
      text: this.buildTrialExpiringText(userName, daysLeft, upgradeUrl),
      tags: [{ name: 'category', value: 'trial-expiring' }],
    });
  }

  async sendAccountDeletion(to: string, userName: string) {
    return this.send({
      to,
      subject: 'Your account has been deleted',
      html: this.buildAccountDeletionHtml(userName),
      text: this.buildAccountDeletionText(userName),
      tags: [{ name: 'category', value: 'account-deletion' }],
    });
  }

  // --- Private template builders (simplified; use React Email for production) ---

  private layout(content: string): string {
    const appName = process.env.APP_NAME || 'App';
    const appUrl = process.env.APP_URL || 'https://app.example.com';
    return `
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f4f4f5;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <div style="max-width:600px;margin:0 auto;padding:40px 20px;">
    <div style="text-align:center;margin-bottom:32px;">
      <a href="${appUrl}" style="color:#18181b;text-decoration:none;font-size:24px;font-weight:700;">${appName}</a>
    </div>
    <div style="background:#ffffff;border-radius:8px;padding:40px;border:1px solid #e4e4e7;">
      ${content}
    </div>
    <div style="text-align:center;margin-top:32px;color:#71717a;font-size:12px;">
      <p>${appName} | <a href="${appUrl}" style="color:#71717a;">Visit App</a></p>
      <p><a href="${appUrl}/settings/notifications" style="color:#71717a;">Unsubscribe</a> from these emails</p>
    </div>
  </div>
</body>
</html>`;
  }

  private button(text: string, url: string): string {
    return `<div style="text-align:center;margin:32px 0;">
      <a href="${url}" style="background:#2563eb;color:#ffffff;padding:12px 32px;border-radius:6px;text-decoration:none;font-weight:600;font-size:14px;display:inline-block;">${text}</a>
    </div>`;
  }

  private buildWelcomeHtml(userName: string): string {
    const appUrl = process.env.APP_URL || 'https://app.example.com';
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Welcome, ${userName}!</h1>
      <p style="color:#3f3f46;line-height:1.6;">Thanks for signing up. Here are a few things to get started:</p>
      <ul style="color:#3f3f46;line-height:2;">
        <li>Set up your profile</li>
        <li>Create your first project</li>
        <li>Invite your team</li>
      </ul>
      ${this.button('Go to Dashboard', `${appUrl}/dashboard`)}
      <p style="color:#71717a;font-size:13px;">If you have any questions, reply to this email. We are here to help.</p>
    `);
  }

  private buildWelcomeText(userName: string): string {
    return `Welcome, ${userName}!\n\nThanks for signing up. Get started:\n- Set up your profile\n- Create your first project\n- Invite your team\n\nGo to Dashboard: ${process.env.APP_URL}/dashboard\n\nQuestions? Reply to this email.`;
  }

  private buildInvitationHtml(inviterName: string, orgName: string, inviteUrl: string): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">You have been invited!</h1>
      <p style="color:#3f3f46;line-height:1.6;"><strong>${inviterName}</strong> invited you to join <strong>${orgName}</strong>.</p>
      <p style="color:#3f3f46;line-height:1.6;">Click the button below to accept and create your account.</p>
      ${this.button('Accept Invitation', inviteUrl)}
      <p style="color:#71717a;font-size:13px;">This invitation expires in 7 days. If you did not expect this, you can safely ignore this email.</p>
    `);
  }

  private buildInvitationText(inviterName: string, orgName: string, inviteUrl: string): string {
    return `You have been invited!\n\n${inviterName} invited you to join ${orgName}.\n\nAccept: ${inviteUrl}\n\nThis invitation expires in 7 days.`;
  }

  private buildPasswordResetHtml(resetUrl: string): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Reset your password</h1>
      <p style="color:#3f3f46;line-height:1.6;">We received a request to reset your password. Click the button below to choose a new one.</p>
      ${this.button('Reset Password', resetUrl)}
      <p style="color:#71717a;font-size:13px;">This link expires in 1 hour. If you did not request this, you can safely ignore this email.</p>
    `);
  }

  private buildPasswordResetText(resetUrl: string): string {
    return `Reset your password\n\nClick here: ${resetUrl}\n\nThis link expires in 1 hour. If you did not request this, ignore this email.`;
  }

  private buildPaymentReceiptHtml(data: { amount: string; planName: string; date: string; invoiceUrl: string }): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Payment Receipt</h1>
      <table style="width:100%;border-collapse:collapse;margin:16px 0;">
        <tr><td style="padding:8px 0;color:#71717a;">Plan</td><td style="padding:8px 0;text-align:right;color:#18181b;font-weight:600;">${data.planName}</td></tr>
        <tr><td style="padding:8px 0;color:#71717a;">Amount</td><td style="padding:8px 0;text-align:right;color:#18181b;font-weight:600;">${data.amount}</td></tr>
        <tr><td style="padding:8px 0;color:#71717a;">Date</td><td style="padding:8px 0;text-align:right;color:#18181b;">${data.date}</td></tr>
      </table>
      ${this.button('View Invoice', data.invoiceUrl)}
    `);
  }

  private buildPaymentReceiptText(data: { amount: string; planName: string; date: string; invoiceUrl: string }): string {
    return `Payment Receipt\n\nPlan: ${data.planName}\nAmount: ${data.amount}\nDate: ${data.date}\n\nView Invoice: ${data.invoiceUrl}`;
  }

  private buildPlanChangeHtml(fromPlan: string, toPlan: string, effectiveDate: string): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Plan Updated</h1>
      <p style="color:#3f3f46;line-height:1.6;">Your plan has been changed:</p>
      <table style="width:100%;border-collapse:collapse;margin:16px 0;">
        <tr><td style="padding:8px 0;color:#71717a;">Previous plan</td><td style="padding:8px 0;text-align:right;color:#18181b;">${fromPlan}</td></tr>
        <tr><td style="padding:8px 0;color:#71717a;">New plan</td><td style="padding:8px 0;text-align:right;color:#18181b;font-weight:600;">${toPlan}</td></tr>
        <tr><td style="padding:8px 0;color:#71717a;">Effective</td><td style="padding:8px 0;text-align:right;color:#18181b;">${effectiveDate}</td></tr>
      </table>
      ${this.button('View Plan Details', `${process.env.APP_URL}/settings/billing`)}
    `);
  }

  private buildPlanChangeText(fromPlan: string, toPlan: string, effectiveDate: string): string {
    return `Plan Updated\n\nPrevious: ${fromPlan}\nNew: ${toPlan}\nEffective: ${effectiveDate}\n\nView details: ${process.env.APP_URL}/settings/billing`;
  }

  private buildUsageWarningHtml(resource: string, current: number, limit: number, pct: number): string {
    const barColor = pct >= 90 ? '#ef4444' : pct >= 75 ? '#f59e0b' : '#3b82f6';
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Usage Alert</h1>
      <p style="color:#3f3f46;line-height:1.6;">Your <strong>${resource}</strong> usage is at <strong>${pct}%</strong> of your plan limit.</p>
      <div style="background:#f4f4f5;border-radius:4px;height:12px;margin:16px 0;">
        <div style="background:${barColor};border-radius:4px;height:12px;width:${Math.min(pct, 100)}%;"></div>
      </div>
      <p style="color:#71717a;font-size:13px;">${current.toLocaleString()} / ${limit.toLocaleString()} used</p>
      ${this.button('Upgrade Plan', `${process.env.APP_URL}/settings/billing`)}
    `);
  }

  private buildUsageWarningText(resource: string, current: number, limit: number, pct: number): string {
    return `Usage Alert\n\nYour ${resource} is at ${pct}% (${current}/${limit}).\n\nUpgrade: ${process.env.APP_URL}/settings/billing`;
  }

  private buildTrialExpiringHtml(userName: string, daysLeft: number, upgradeUrl: string): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Your trial is ending soon</h1>
      <p style="color:#3f3f46;line-height:1.6;">Hi ${userName}, your free trial expires in <strong>${daysLeft} day${daysLeft === 1 ? '' : 's'}</strong>.</p>
      <p style="color:#3f3f46;line-height:1.6;">Upgrade now to keep all your data and continue using all features.</p>
      ${this.button('Upgrade Now', upgradeUrl)}
      <p style="color:#71717a;font-size:13px;">After your trial ends, your account will be downgraded to the free plan. No data will be deleted.</p>
    `);
  }

  private buildTrialExpiringText(userName: string, daysLeft: number, upgradeUrl: string): string {
    return `Hi ${userName}, your trial expires in ${daysLeft} day(s).\n\nUpgrade: ${upgradeUrl}\n\nAfter trial, you will be on the free plan. No data deleted.`;
  }

  private buildAccountDeletionHtml(userName: string): string {
    return this.layout(`
      <h1 style="font-size:20px;color:#18181b;margin:0 0 16px;">Account Deleted</h1>
      <p style="color:#3f3f46;line-height:1.6;">Hi ${userName}, your account and all associated data have been permanently deleted as requested.</p>
      <p style="color:#3f3f46;line-height:1.6;">If this was a mistake, please contact support within 30 days at <a href="mailto:${process.env.EMAIL_REPLY_TO}" style="color:#2563eb;">${process.env.EMAIL_REPLY_TO}</a>.</p>
      <p style="color:#71717a;font-size:13px;">This is the last email you will receive from us. We are sorry to see you go.</p>
    `);
  }

  private buildAccountDeletionText(userName: string): string {
    return `Account Deleted\n\nHi ${userName}, your account has been permanently deleted.\n\nIf this was a mistake, contact ${process.env.EMAIL_REPLY_TO} within 30 days.`;
  }
}
```

### Email Module

```typescript
// src/email/email.module.ts
import { Global, Module } from '@nestjs/common';
import { EmailService } from './email.service';

@Global()
@Module({
  providers: [EmailService],
  exports: [EmailService],
})
export class EmailModule {}
```

## :art: REACT EMAIL TEMPLATES (Alternative Approach)

> [!TIP]
> For complex templates, use React Email (`react.email`) to build templates in JSX with full component reuse and preview support. The inline HTML approach above works for simple cases.

### Welcome Email in React Email

```typescript
// emails/WelcomeEmail.tsx
import {
  Html, Head, Body, Container, Section, Text, Button,
  Heading, Hr, Img, Preview, Tailwind,
} from '@react-email/components';

interface WelcomeEmailProps {
  userName: string;
  dashboardUrl: string;
}

export default function WelcomeEmail({ userName, dashboardUrl }: WelcomeEmailProps) {
  return (
    <Html>
      <Head />
      <Preview>Welcome to Zenith - get started in minutes</Preview>
      <Tailwind>
        <Body className="bg-zinc-100 font-sans">
          <Container className="mx-auto max-w-[600px] py-10">
            <Section className="rounded-lg bg-white p-10 shadow">
              <Heading className="text-xl font-bold text-zinc-900">
                Welcome, {userName}!
              </Heading>
              <Text className="text-zinc-600 leading-relaxed">
                Thanks for signing up. Here is how to get started:
              </Text>
              <ul className="text-zinc-600 leading-8">
                <li>Set up your profile</li>
                <li>Create your first project</li>
                <li>Invite your team</li>
              </ul>
              <Button
                href={dashboardUrl}
                className="rounded-md bg-blue-600 px-8 py-3 text-sm font-semibold text-white"
              >
                Go to Dashboard
              </Button>
              <Hr className="my-6 border-zinc-200" />
              <Text className="text-xs text-zinc-400">
                Questions? Reply to this email.
              </Text>
            </Section>
          </Container>
        </Body>
      </Tailwind>
    </Html>
  );
}
```

### Render and Send

```typescript
import { render } from '@react-email/render';
import WelcomeEmail from '../emails/WelcomeEmail';

const html = await render(WelcomeEmail({ userName: 'Alice', dashboardUrl: 'https://app.example.com/dashboard' }));
const text = await render(WelcomeEmail({ userName: 'Alice', dashboardUrl: 'https://app.example.com/dashboard' }), { plainText: true });

await emailService.send({ to: 'alice@example.com', subject: 'Welcome!', html, text });
```

## :envelope: ESSENTIAL TEMPLATE CHECKLIST

| # | Template | Trigger | Priority |
|---|----------|---------|----------|
| 1 | Welcome | After signup | Required |
| 2 | Team Invitation | Org invite sent | Required |
| 3 | Password Reset | Reset requested | Required |
| 4 | Payment Receipt | Stripe webhook `invoice.paid` | Required |
| 5 | Plan Change | Upgrade or downgrade | Required |
| 6 | Usage Warning | Usage exceeds 75%, 90% | Recommended |
| 7 | Trial Expiring | 7 days, 3 days, 1 day before | Recommended |
| 8 | Account Deletion | Account deleted | Required |

## :globe_with_meridians: EMAIL DELIVERABILITY

### Required DNS Records

| Record | Type | Purpose |
|--------|------|---------|
| SPF | TXT | Authorize sending servers |
| DKIM | TXT | Cryptographic email signing |
| DMARC | TXT | Policy for failed SPF/DKIM |
| Return-Path | CNAME | Bounce handling |

```text
# Example DNS records for Resend
v=spf1 include:amazonses.com ~all
resend._domainkey  CNAME  resend._domainkey.yourdomain.com
_dmarc  TXT  "v=DMARC1; p=quarantine; rua=mailto:dmarc@yourdomain.com"
```

> [!WARNING]
> Without SPF, DKIM, and DMARC records properly configured, your emails will likely land in spam folders. Set these up before going to production.

## :shield: COMPLIANCE

### CAN-SPAM Requirements

- [ ] Include physical mailing address in footer (or registered agent)
- [ ] Unsubscribe link in every marketing email
- [ ] Honor unsubscribe requests within 10 business days
- [ ] Accurate "From" and "Subject" lines
- [ ] Transactional emails (password reset, receipts) are exempt from unsubscribe requirement

### GDPR Considerations

- [ ] Only send emails the user has consented to
- [ ] Store email consent timestamp
- [ ] Provide one-click unsubscribe header (`List-Unsubscribe`)
- [ ] Delete email history on account deletion request

## :test_tube: TESTING EMAILS

```typescript
// Preview emails in development
// package.json
{
  "scripts": {
    "email:dev": "email dev --dir emails --port 3030"
  }
}

// Send test email
async function sendTestEmail() {
  await emailService.send({
    to: 'developer@yourdomain.com',
    subject: '[TEST] Welcome Email',
    html: buildWelcomeHtml('Test User'),
    text: buildWelcomeText('Test User'),
    tags: [{ name: 'environment', value: 'test' }],
  });
}
```

### Cross-Client Testing Checklist

| Client | Test |
|--------|------|
| Gmail (web) | Layout, images, dark mode |
| Outlook (desktop) | Table rendering, button fallback |
| Apple Mail | Responsive, retina images |
| Gmail (mobile) | Responsive layout, tap targets |
| Outlook (mobile) | Responsive, font rendering |

## :white_check_mark: EXIT CHECKLIST

- [ ] Resend API key configured and domain verified
- [ ] `EmailService` injectable with `send()` method and all template methods
- [ ] All 8 essential email templates created (welcome through account deletion)
- [ ] Every HTML email has a plain text fallback
- [ ] Brand consistency: logo, colors, typography match the app
- [ ] Responsive layout: works on mobile and desktop email clients
- [ ] Unsubscribe link present in all non-transactional emails
- [ ] SPF, DKIM, and DMARC DNS records configured for sending domain
- [ ] Email preview/dev server works (`email:dev` script)
- [ ] Tested across Gmail, Outlook, and Apple Mail
- [ ] CAN-SPAM and GDPR compliance verified
- [ ] Variables/templating works: user names, plan names, amounts render correctly
- [ ] Rate-sensitive emails (password reset, trial expiring) have correct expiry info

*Skill Version: 1.0 | Created: February 2026*
