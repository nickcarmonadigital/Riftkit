---
name: feedback_system
description: In-app bug reporter and feedback collection system with triage workflow
---

# Feedback System Skill

**Purpose**: Add an in-app bug reporter and feedback collection system so users can report bugs, request features, and provide feedback without leaving the application.

## :dart: TRIGGER COMMANDS

```text
"add bug reporter"
"feedback system"
"in-app reporting"
"set up feedback collection"
"Using feedback_system skill: add bug reporter to [project]"
```

## :card_file_box: DATABASE MODEL

### Prisma Schema

```prisma
model Feedback {
  id            String         @id @default(uuid())
  userId        String         @map("user_id")
  orgId         String?        @map("org_id")
  type          FeedbackType
  description   String
  severity      FeedbackSeverity
  pageUrl       String         @map("page_url")
  browserInfo   Json?          @map("browser_info")
  screenshotUrl String?        @map("screenshot_url")
  status        FeedbackStatus @default(NEW)
  assignedTo    String?        @map("assigned_to")
  adminNotes    String?        @map("admin_notes")
  metadata      Json?
  createdAt     DateTime       @default(now()) @map("created_at")
  updatedAt     DateTime       @updatedAt @map("updated_at")
  resolvedAt    DateTime?      @map("resolved_at")

  @@map("feedback")
  @@schema("public")
}

enum FeedbackType {
  BUG
  FEATURE
  FEEDBACK
}

enum FeedbackSeverity {
  P0_CRITICAL
  P1_HIGH
  P2_MEDIUM
  P3_LOW
}

enum FeedbackStatus {
  NEW
  TRIAGED
  IN_PROGRESS
  RESOLVED
  CLOSED
}
```

## :gear: BACKEND API (NestJS)

### Feedback Controller

```typescript
// src/feedback/feedback.controller.ts
import {
  Controller, Post, Get, Patch, Body, Param, Query,
  UseGuards, UseInterceptors, UploadedFile,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/user.decorator';
import { Throttle } from '@nestjs/throttler';
import { FileInterceptor } from '@nestjs/platform-express';
import { FeedbackService } from './feedback.service';
import { CreateFeedbackDto, UpdateFeedbackDto, FeedbackQueryDto } from './feedback.dto';

@Controller('feedback')
@UseGuards(JwtAuthGuard)
export class FeedbackController {
  constructor(private feedbackService: FeedbackService) {}

  @Post()
  @Throttle({ default: { limit: 10, ttl: 3600000 } }) // 10 per hour
  @UseInterceptors(FileInterceptor('screenshot'))
  async create(
    @CurrentUser() user: { sub: string; email: string },
    @Body() dto: CreateFeedbackDto,
    @UploadedFile() screenshot?: Express.Multer.File,
  ) {
    const feedback = await this.feedbackService.create(user.sub, dto, screenshot);
    return { success: true, data: feedback };
  }

  @Get()
  async findAll(@CurrentUser() user: { sub: string }, @Query() query: FeedbackQueryDto) {
    const result = await this.feedbackService.findAll(user.sub, query);
    return { success: true, data: result };
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const feedback = await this.feedbackService.findOne(id);
    return { success: true, data: feedback };
  }

  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateFeedbackDto,
    @CurrentUser() user: { sub: string },
  ) {
    const feedback = await this.feedbackService.update(id, dto, user.sub);
    return { success: true, data: feedback };
  }
}
```

### Feedback Service

```typescript
// src/feedback/feedback.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFeedbackDto, UpdateFeedbackDto, FeedbackQueryDto } from './feedback.dto';
import { FeedbackSeverity, FeedbackStatus } from '@prisma/client';

@Injectable()
export class FeedbackService {
  constructor(
    private prisma: PrismaService,
    // private notificationService: NotificationService,
    // private fileUploadService: FileUploadService,
  ) {}

  async create(userId: string, dto: CreateFeedbackDto, screenshot?: Express.Multer.File) {
    let screenshotUrl: string | undefined;

    if (screenshot) {
      // Upload screenshot to S3/R2 via your file upload service
      // screenshotUrl = await this.fileUploadService.upload(screenshot, 'feedback-screenshots');
    }

    const feedback = await this.prisma.feedback.create({
      data: {
        userId,
        orgId: dto.orgId,
        type: dto.type,
        description: dto.description,
        severity: dto.severity,
        pageUrl: dto.pageUrl,
        browserInfo: dto.browserInfo ?? undefined,
        screenshotUrl,
        status: FeedbackStatus.NEW,
        metadata: dto.metadata ?? undefined,
      },
    });

    // Notify admins for critical/high severity
    if (
      dto.severity === FeedbackSeverity.P0_CRITICAL ||
      dto.severity === FeedbackSeverity.P1_HIGH
    ) {
      await this.notifyCritical(feedback);
    }

    return feedback;
  }

  async findAll(userId: string, query: FeedbackQueryDto) {
    const { type, severity, status, page = 1, limit = 20 } = query;
    const where: any = {};

    if (type) where.type = type;
    if (severity) where.severity = severity;
    if (status) where.status = status;

    const [items, total] = await Promise.all([
      this.prisma.feedback.findMany({
        where,
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.feedback.count({ where }),
    ]);

    return { items, total, page, limit, totalPages: Math.ceil(total / limit) };
  }

  async findOne(id: string) {
    const feedback = await this.prisma.feedback.findUnique({ where: { id } });
    if (!feedback) throw new NotFoundException('Feedback not found');
    return feedback;
  }

  async update(id: string, dto: UpdateFeedbackDto, updatedBy: string) {
    const feedback = await this.prisma.feedback.update({
      where: { id },
      data: {
        ...dto,
        resolvedAt: dto.status === FeedbackStatus.RESOLVED ? new Date() : undefined,
      },
    });
    return feedback;
  }

  private async notifyCritical(feedback: any) {
    // Send Slack notification for P0/P1
    // await this.notificationService.sendSlack({
    //   channel: '#bugs-critical',
    //   text: `[${feedback.severity}] ${feedback.type}: ${feedback.description.slice(0, 200)}`,
    //   url: `${process.env.APP_URL}/admin/feedback/${feedback.id}`,
    // });
  }
}
```

### DTOs

```typescript
// src/feedback/feedback.dto.ts
import { IsEnum, IsString, IsOptional, IsObject, IsInt, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { FeedbackType, FeedbackSeverity, FeedbackStatus } from '@prisma/client';

export class CreateFeedbackDto {
  @IsEnum(FeedbackType)
  type: FeedbackType;

  @IsString()
  description: string;

  @IsEnum(FeedbackSeverity)
  severity: FeedbackSeverity;

  @IsString()
  pageUrl: string;

  @IsOptional()
  @IsString()
  orgId?: string;

  @IsOptional()
  @IsObject()
  browserInfo?: Record<string, any>;

  @IsOptional()
  @IsObject()
  metadata?: Record<string, any>;
}

export class UpdateFeedbackDto {
  @IsOptional()
  @IsEnum(FeedbackStatus)
  status?: FeedbackStatus;

  @IsOptional()
  @IsString()
  assignedTo?: string;

  @IsOptional()
  @IsString()
  adminNotes?: string;
}

export class FeedbackQueryDto {
  @IsOptional()
  @IsEnum(FeedbackType)
  type?: FeedbackType;

  @IsOptional()
  @IsEnum(FeedbackSeverity)
  severity?: FeedbackSeverity;

  @IsOptional()
  @IsEnum(FeedbackStatus)
  status?: FeedbackStatus;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
```

## :art: FRONTEND BUG REPORTER COMPONENT

### Install Screenshot Dependency

```bash
npm install html2canvas
```

### BugReporter Component

```typescript
// src/components/BugReporter.tsx
import React, { useState, useCallback } from 'react';
import html2canvas from 'html2canvas';

type FeedbackType = 'BUG' | 'FEATURE' | 'FEEDBACK';
type Severity = 'P0_CRITICAL' | 'P1_HIGH' | 'P2_MEDIUM' | 'P3_LOW';

interface FeedbackForm {
  type: FeedbackType;
  description: string;
  severity: Severity;
  screenshot: File | null;
}

export function BugReporter() {
  const [isOpen, setIsOpen] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [form, setForm] = useState<FeedbackForm>({
    type: 'BUG',
    description: '',
    severity: 'P2_MEDIUM',
    screenshot: null,
  });

  const captureScreenshot = useCallback(async () => {
    try {
      const canvas = await html2canvas(document.body, {
        ignoreElements: (el) => el.id === 'bug-reporter-modal',
      });
      canvas.toBlob((blob) => {
        if (blob) {
          const file = new File([blob], 'screenshot.png', { type: 'image/png' });
          setForm((prev) => ({ ...prev, screenshot: file }));
        }
      });
    } catch (err) {
      console.error('Screenshot capture failed:', err);
    }
  }, []);

  const collectBrowserInfo = () => ({
    userAgent: navigator.userAgent,
    language: navigator.language,
    platform: navigator.platform,
    screenWidth: window.screen.width,
    screenHeight: window.screen.height,
    viewportWidth: window.innerWidth,
    viewportHeight: window.innerHeight,
    timestamp: new Date().toISOString(),
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    try {
      const formData = new FormData();
      formData.append('type', form.type);
      formData.append('description', form.description);
      formData.append('severity', form.severity);
      formData.append('pageUrl', window.location.href);
      formData.append('browserInfo', JSON.stringify(collectBrowserInfo()));
      if (form.screenshot) formData.append('screenshot', form.screenshot);

      const res = await fetch('/api/feedback', {
        method: 'POST',
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
        body: formData,
      });

      if (!res.ok) throw new Error('Failed to submit feedback');

      setSubmitted(true);
      setTimeout(() => {
        setIsOpen(false);
        setSubmitted(false);
        setForm({ type: 'BUG', description: '', severity: 'P2_MEDIUM', screenshot: null });
      }, 2000);
    } catch (err) {
      console.error('Feedback submission failed:', err);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <>
      {/* Floating trigger button */}
      <button
        onClick={() => setIsOpen(true)}
        className="fixed bottom-6 right-6 z-50 flex h-12 w-12 items-center justify-center
                   rounded-full bg-blue-600 text-white shadow-lg hover:bg-blue-700
                   transition-colors"
        aria-label="Report a bug or send feedback"
      >
        <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      </button>

      {/* Modal */}
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
          <div id="bug-reporter-modal"
               className="w-full max-w-md rounded-lg bg-white p-6 shadow-xl dark:bg-gray-800">
            {submitted ? (
              <div className="text-center py-8">
                <p className="text-lg font-semibold text-green-600">Thank you for your feedback!</p>
                <p className="text-sm text-gray-500 mt-2">We will review it shortly.</p>
              </div>
            ) : (
              <>
                <div className="flex items-center justify-between mb-4">
                  <h2 className="text-lg font-semibold">Send Feedback</h2>
                  <button onClick={() => setIsOpen(false)} className="text-gray-400 hover:text-gray-600">
                    &times;
                  </button>
                </div>

                <form onSubmit={handleSubmit} className="space-y-4">
                  {/* Type selector */}
                  <div className="flex gap-2">
                    {(['BUG', 'FEATURE', 'FEEDBACK'] as FeedbackType[]).map((t) => (
                      <button key={t} type="button"
                              onClick={() => setForm((f) => ({ ...f, type: t }))}
                              className={`flex-1 rounded-md px-3 py-2 text-sm font-medium border
                                ${form.type === t
                                  ? 'border-blue-500 bg-blue-50 text-blue-700'
                                  : 'border-gray-200 text-gray-600 hover:bg-gray-50'}`}>
                        {t === 'BUG' ? 'Bug' : t === 'FEATURE' ? 'Feature Request' : 'Feedback'}
                      </button>
                    ))}
                  </div>

                  {/* Description */}
                  <textarea
                    value={form.description}
                    onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                    placeholder="Describe the issue or suggestion..."
                    rows={4}
                    required
                    className="w-full rounded-md border border-gray-300 p-3 text-sm"
                  />

                  {/* Severity */}
                  <select
                    value={form.severity}
                    onChange={(e) => setForm((f) => ({ ...f, severity: e.target.value as Severity }))}
                    className="w-full rounded-md border border-gray-300 p-2 text-sm"
                  >
                    <option value="P0_CRITICAL">P0 - Critical (app unusable)</option>
                    <option value="P1_HIGH">P1 - High (major feature broken)</option>
                    <option value="P2_MEDIUM">P2 - Medium (workaround exists)</option>
                    <option value="P3_LOW">P3 - Low (minor / cosmetic)</option>
                  </select>

                  {/* Screenshot */}
                  <div className="flex gap-2">
                    <button type="button" onClick={captureScreenshot}
                            className="rounded-md border border-gray-300 px-3 py-2 text-sm hover:bg-gray-50">
                      Capture Screenshot
                    </button>
                    {form.screenshot && (
                      <span className="self-center text-sm text-green-600">Screenshot attached</span>
                    )}
                  </div>

                  <button type="submit" disabled={isSubmitting}
                          className="w-full rounded-md bg-blue-600 py-2 text-sm font-medium text-white
                                     hover:bg-blue-700 disabled:opacity-50">
                    {isSubmitting ? 'Submitting...' : 'Submit'}
                  </button>
                </form>
              </>
            )}
          </div>
        </div>
      )}
    </>
  );
}
```

## :arrows_counterclockwise: STATUS WORKFLOW

```text
NEW  -->  TRIAGED  -->  IN_PROGRESS  -->  RESOLVED  -->  CLOSED
                                 \                        /
                                  ------> CLOSED --------
```

| Status | Description | Who Sets It |
|--------|------------|-------------|
| `NEW` | Just submitted by user | System (automatic) |
| `TRIAGED` | Reviewed and assigned priority | Admin |
| `IN_PROGRESS` | Being worked on | Developer |
| `RESOLVED` | Fix deployed or feature shipped | Developer |
| `CLOSED` | Confirmed resolved or won't fix | Admin |

## :rotating_light: TRIAGE AND NOTIFICATION WORKFLOW

| Severity | Notification | Response SLA |
|----------|-------------|-------------|
| P0 - Critical | Immediate Slack + Email to on-call | 1 hour |
| P1 - High | Immediate Slack to #bugs channel | 4 hours |
| P2 - Medium | Daily digest email | 2 business days |
| P3 - Low | Weekly digest | Best effort |

> [!TIP]
> Create a dedicated Slack channel like `#user-feedback` for all non-critical reports. This keeps visibility high without overwhelming developers with notifications.

## :shield: ADMIN DASHBOARD

The admin dashboard should provide:

| Feature | Description |
|---------|------------|
| Filter bar | Filter by type, severity, status, date range |
| Bulk actions | Assign, change status, close multiple items |
| Severity badges | Color-coded P0 (red), P1 (orange), P2 (yellow), P3 (gray) |
| Assignee column | Shows who is working on it |
| Quick reply | Admin can add internal notes without leaving the list |
| Export | CSV export of filtered feedback |

> [!WARNING]
> Rate limit feedback submissions to **10 per hour per user** to prevent abuse. Display a friendly message when the limit is hit: "You have submitted several reports recently. Please try again later."

## :white_check_mark: EXIT CHECKLIST

- [ ] Prisma `Feedback` model created and migrated
- [ ] `POST /feedback` endpoint with JWT auth and rate limiting (10/hour)
- [ ] `GET /feedback` with filtering by type, severity, status, and pagination
- [ ] `PATCH /feedback/:id` for admin status updates and notes
- [ ] Bug reporter floating button visible on all authenticated pages
- [ ] Report form collects: type, description, severity, screenshot (optional)
- [ ] Page URL and browser info auto-attached to every report
- [ ] Screenshot capture via html2canvas works
- [ ] Manual screenshot file upload supported
- [ ] Status workflow: NEW -> TRIAGED -> IN_PROGRESS -> RESOLVED -> CLOSED
- [ ] P0/P1 reports trigger immediate Slack notification
- [ ] P2/P3 reports included in daily/weekly digest
- [ ] Admin dashboard: view, filter, assign, and triage all feedback
- [ ] Submitted confirmation shown to user after report sent

*Skill Version: 1.0 | Created: February 2026*
