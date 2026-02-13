---
name: integration_testing
description: Supertest API integration tests for NestJS endpoints with auth and org-scoping
---

# Integration Testing Skill

**Purpose**: Write end-to-end API integration tests using Supertest against a real NestJS application with a test database, verifying authentication, authorization, response shapes, and multi-tenancy scoping.

## 🎯 TRIGGER COMMANDS

```text
"write API tests for this endpoint"
"integration tests for [module]"
"test endpoints"
"write supertest tests"
"test the API routes"
"Using integration_testing skill: test [controller/module]"
```

## 🏗️ Test Environment Setup

### NestJS Test Module Bootstrap

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { PrismaService } from '../src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';

describe('DocumentController (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  let jwtService: JwtService;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();

    // Apply the same pipes as main.ts
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );

    await app.init();

    prisma = app.get(PrismaService);
    jwtService = app.get(JwtService);
  });

  afterAll(async () => {
    await app.close();
  });
});
```

### Test Database Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| Database | Separate test DB | `zenith_test` or `DATABASE_URL` override |
| Migrations | Run before suite | `npx prisma migrate deploy` |
| Seeding | Per-test or per-suite | Depends on isolation needs |
| Cleanup | After each test | Transaction rollback or truncation |
| Env file | `.env.test` | Never use production credentials |

> [!WARNING]
> Never run integration tests against a production or staging database. Always use a dedicated test database. Set `DATABASE_URL` in `.env.test` pointing to the test instance.

```typescript
// jest-e2e.config.ts
export default {
  moduleFileExtensions: ['js', 'json', 'ts'],
  rootDir: '.',
  testEnvironment: 'node',
  testRegex: '.e2e-spec.ts$',
  transform: { '^.+\\.(t|j)s$': 'ts-jest' },
  setupFiles: ['./test/setup-env.ts'], // loads .env.test
};
```

## 🔑 Auth Token Generation for Tests

```typescript
// test/helpers/auth.helper.ts
import { PrismaService } from '../../src/prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

export interface TestUser {
  id: string;
  email: string;
  orgId: string;
  token: string;
}

export async function createTestUser(
  prisma: PrismaService,
  jwtService: JwtService,
  overrides: Partial<{ email: string; orgId: string }> = {},
): Promise<TestUser> {
  const org = await prisma.organization.create({
    data: {
      name: 'Test Org',
      slug: `test-org-${Date.now()}`,
    },
  });

  const user = await prisma.user.create({
    data: {
      email: overrides.email ?? `test-${Date.now()}@example.com`,
      password: await bcrypt.hash('TestPass123!', 10),
      orgId: overrides.orgId ?? org.id,
    },
  });

  const token = jwtService.sign({
    sub: user.id,
    email: user.email,
  });

  return { id: user.id, email: user.email, orgId: user.orgId, token };
}

export async function cleanupTestUser(
  prisma: PrismaService,
  userId: string,
): Promise<void> {
  await prisma.user.delete({ where: { id: userId } });
}
```

## 🧪 Supertest Request Patterns

### Authenticated GET Request

```typescript
describe('GET /api/documents', () => {
  let testUser: TestUser;

  beforeEach(async () => {
    testUser = await createTestUser(prisma, jwtService);
  });

  afterEach(async () => {
    await prisma.document.deleteMany({ where: { orgId: testUser.orgId } });
    await cleanupTestUser(prisma, testUser.id);
  });

  it('should return documents for authenticated user', async () => {
    // Seed test data
    await prisma.document.create({
      data: {
        title: 'Test Document',
        content: 'Hello world',
        orgId: testUser.orgId,
        createdById: testUser.id,
      },
    });

    const response = await request(app.getHttpServer())
      .get('/api/documents')
      .set('Authorization', `Bearer ${testUser.token}`)
      .expect(200);

    expect(response.body).toMatchObject({
      success: true,
      data: expect.arrayContaining([
        expect.objectContaining({
          title: 'Test Document',
          orgId: testUser.orgId,
        }),
      ]),
    });
  });

  it('should return 401 without auth token', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/documents')
      .expect(401);

    expect(response.body).toMatchObject({
      statusCode: 401,
      message: 'Unauthorized',
    });
  });

  it('should return empty array when no documents exist', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/documents')
      .set('Authorization', `Bearer ${testUser.token}`)
      .expect(200);

    expect(response.body).toEqual({
      success: true,
      data: [],
    });
  });
});
```

### POST with Validation

```typescript
describe('POST /api/documents', () => {
  let testUser: TestUser;

  beforeEach(async () => {
    testUser = await createTestUser(prisma, jwtService);
  });

  afterEach(async () => {
    await prisma.document.deleteMany({ where: { orgId: testUser.orgId } });
    await cleanupTestUser(prisma, testUser.id);
  });

  it('should create a document with valid input', async () => {
    const payload = {
      title: 'New Document',
      content: 'This is the content',
    };

    const response = await request(app.getHttpServer())
      .post('/api/documents')
      .set('Authorization', `Bearer ${testUser.token}`)
      .send(payload)
      .expect(201);

    expect(response.body).toMatchObject({
      success: true,
      data: expect.objectContaining({
        id: expect.any(String),
        title: 'New Document',
        content: 'This is the content',
        orgId: testUser.orgId,
      }),
    });

    // Verify persistence
    const doc = await prisma.document.findUnique({
      where: { id: response.body.data.id },
    });
    expect(doc).not.toBeNull();
    expect(doc!.title).toBe('New Document');
  });

  it('should return 422 when title is missing', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/documents')
      .set('Authorization', `Bearer ${testUser.token}`)
      .send({ content: 'No title provided' })
      .expect(422);

    expect(response.body.message).toContain('title');
  });

  it('should strip unknown fields (whitelist)', async () => {
    const response = await request(app.getHttpServer())
      .post('/api/documents')
      .set('Authorization', `Bearer ${testUser.token}`)
      .send({
        title: 'Doc',
        content: 'Body',
        maliciousField: 'DROP TABLE;',
      })
      .expect(400); // forbidNonWhitelisted throws 400

    expect(response.body.message).toContain('maliciousField');
  });
});
```

### PUT and DELETE

```typescript
describe('PUT /api/documents/:id', () => {
  let testUser: TestUser;
  let docId: string;

  beforeEach(async () => {
    testUser = await createTestUser(prisma, jwtService);
    const doc = await prisma.document.create({
      data: { title: 'Original', content: 'Body', orgId: testUser.orgId, createdById: testUser.id },
    });
    docId = doc.id;
  });

  afterEach(async () => {
    await prisma.document.deleteMany({ where: { orgId: testUser.orgId } });
    await cleanupTestUser(prisma, testUser.id);
  });

  it('should update the document', async () => {
    const response = await request(app.getHttpServer())
      .put(`/api/documents/${docId}`)
      .set('Authorization', `Bearer ${testUser.token}`)
      .send({ title: 'Updated Title' })
      .expect(200);

    expect(response.body.data.title).toBe('Updated Title');
  });

  it('should return 404 for non-existent document', async () => {
    await request(app.getHttpServer())
      .put('/api/documents/non-existent-uuid')
      .set('Authorization', `Bearer ${testUser.token}`)
      .send({ title: 'Nope' })
      .expect(404);
  });
});

describe('DELETE /api/documents/:id', () => {
  let testUser: TestUser;
  let docId: string;

  beforeEach(async () => {
    testUser = await createTestUser(prisma, jwtService);
    const doc = await prisma.document.create({
      data: { title: 'To Delete', content: 'Bye', orgId: testUser.orgId, createdById: testUser.id },
    });
    docId = doc.id;
  });

  afterEach(async () => {
    await prisma.document.deleteMany({ where: { orgId: testUser.orgId } });
    await cleanupTestUser(prisma, testUser.id);
  });

  it('should delete the document and return 200', async () => {
    await request(app.getHttpServer())
      .delete(`/api/documents/${docId}`)
      .set('Authorization', `Bearer ${testUser.token}`)
      .expect(200);

    const deleted = await prisma.document.findUnique({ where: { id: docId } });
    expect(deleted).toBeNull();
  });
});
```

## 🏢 Multi-Tenancy / Org-Scoping Tests

> [!TIP]
> Multi-tenancy tests are the most important integration tests for a SaaS platform. They verify that one organization can never access another organization's data.

```typescript
describe('Org-scoping isolation', () => {
  let userA: TestUser;
  let userB: TestUser;
  let docFromOrgA: string;

  beforeEach(async () => {
    userA = await createTestUser(prisma, jwtService, { email: 'a@orga.com' });
    userB = await createTestUser(prisma, jwtService, { email: 'b@orgb.com' });

    const doc = await prisma.document.create({
      data: {
        title: 'Org A Secret',
        content: 'Confidential data',
        orgId: userA.orgId,
        createdById: userA.id,
      },
    });
    docFromOrgA = doc.id;
  });

  afterEach(async () => {
    await prisma.document.deleteMany({ where: { orgId: { in: [userA.orgId, userB.orgId] } } });
    await cleanupTestUser(prisma, userA.id);
    await cleanupTestUser(prisma, userB.id);
  });

  it('should NOT allow Org B user to read Org A documents', async () => {
    const response = await request(app.getHttpServer())
      .get(`/api/documents/${docFromOrgA}`)
      .set('Authorization', `Bearer ${userB.token}`)
      .expect(404); // not 403 — don't reveal existence

    expect(response.body.success).toBeUndefined();
  });

  it('should NOT include Org A documents in Org B listing', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/documents')
      .set('Authorization', `Bearer ${userB.token}`)
      .expect(200);

    const titles = response.body.data.map((d: any) => d.title);
    expect(titles).not.toContain('Org A Secret');
  });

  it('should NOT allow Org B user to update Org A document', async () => {
    await request(app.getHttpServer())
      .put(`/api/documents/${docFromOrgA}`)
      .set('Authorization', `Bearer ${userB.token}`)
      .send({ title: 'Hacked' })
      .expect(404);

    // Verify document unchanged
    const doc = await prisma.document.findUnique({ where: { id: docFromOrgA } });
    expect(doc!.title).toBe('Org A Secret');
  });

  it('should NOT allow Org B user to delete Org A document', async () => {
    await request(app.getHttpServer())
      .delete(`/api/documents/${docFromOrgA}`)
      .set('Authorization', `Bearer ${userB.token}`)
      .expect(404);

    const doc = await prisma.document.findUnique({ where: { id: docFromOrgA } });
    expect(doc).not.toBeNull();
  });
});
```

## 📋 Error Response Testing

| Status Code | Scenario | Verify |
|-------------|----------|--------|
| `401` | No token / expired token | `message: 'Unauthorized'` |
| `403` | Valid token, insufficient role | `message` explains required permission |
| `404` | Resource not found / org-scoped miss | No data leak about existence |
| `400` | Unknown fields (forbidNonWhitelisted) | `message` lists bad field |
| `422` | Validation failure (missing/invalid) | `message` array with field errors |
| `409` | Duplicate unique constraint | Prisma P2002 mapped to ConflictException |
| `500` | Unhandled server error | Generic message, no stack trace in prod |

```typescript
describe('Error responses', () => {
  it('should return 401 with expired token', async () => {
    const expiredToken = jwtService.sign(
      { sub: 'user-id', email: 'test@test.com' },
      { expiresIn: '0s' },
    );

    await request(app.getHttpServer())
      .get('/api/documents')
      .set('Authorization', `Bearer ${expiredToken}`)
      .expect(401);
  });

  it('should return 401 with malformed token', async () => {
    await request(app.getHttpServer())
      .get('/api/documents')
      .set('Authorization', 'Bearer not.a.real.jwt')
      .expect(401);
  });
});
```

## 💳 Webhook Testing (Stripe Example)

```typescript
import Stripe from 'stripe';
import * as crypto from 'crypto';

describe('POST /api/webhooks/stripe', () => {
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET!;

  function generateStripeSignature(payload: string, secret: string): string {
    const timestamp = Math.floor(Date.now() / 1000);
    const signedPayload = `${timestamp}.${payload}`;
    const signature = crypto
      .createHmac('sha256', secret)
      .update(signedPayload)
      .digest('hex');
    return `t=${timestamp},v1=${signature}`;
  }

  it('should process checkout.session.completed event', async () => {
    const event = {
      id: 'evt_test_123',
      type: 'checkout.session.completed',
      data: {
        object: {
          id: 'cs_test_123',
          customer: 'cus_test_123',
          subscription: 'sub_test_123',
          metadata: { orgId: 'org-uuid-1' },
        },
      },
    };

    const payload = JSON.stringify(event);
    const signature = generateStripeSignature(payload, webhookSecret);

    await request(app.getHttpServer())
      .post('/api/webhooks/stripe')
      .set('stripe-signature', signature)
      .set('Content-Type', 'application/json')
      .send(payload)
      .expect(200);
  });

  it('should reject webhook with invalid signature', async () => {
    await request(app.getHttpServer())
      .post('/api/webhooks/stripe')
      .set('stripe-signature', 'invalid_signature')
      .set('Content-Type', 'application/json')
      .send('{}')
      .expect(400);
  });
});
```

## 🧹 Database Cleanup Strategies

| Strategy | Pros | Cons |
|----------|------|------|
| Transaction rollback | Fast, automatic | Complex setup, some operations can't be rolled back |
| `deleteMany` in afterEach | Simple, explicit | Must track created records |
| Truncate all tables | Clean slate | Slow, resets sequences |
| Test database per suite | Full isolation | Resource-heavy |

> [!TIP]
> For most NestJS integration tests, using `deleteMany` in `afterEach` scoped to the test user's `orgId` provides the best balance of isolation and speed.

```typescript
// Utility for full cleanup between test suites
async function truncateAllTables(prisma: PrismaService): Promise<void> {
  const tables = await prisma.$queryRaw<{ tablename: string }[]>`
    SELECT tablename FROM pg_tables WHERE schemaname = 'public'
  `;

  for (const { tablename } of tables) {
    if (tablename === '_prisma_migrations') continue;
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE "public"."${tablename}" CASCADE`);
  }
}
```

## ✅ EXIT CHECKLIST

- [ ] All CRUD endpoints tested (GET, POST, PUT, DELETE)
- [ ] Authentication verified (401 without token, 401 with expired token)
- [ ] Authorization verified (403 for insufficient roles)
- [ ] Org-scoping verified (cannot read/write/delete across orgs)
- [ ] Response shapes match `{ success: true, data: ... }` pattern
- [ ] Validation errors return correct status codes and field messages
- [ ] Database cleanup runs after each test (no state leakage)
- [ ] Test database is separate from development/production
- [ ] Webhook signature verification tested (valid and invalid)
- [ ] No hardcoded IDs or tokens (generated fresh per test)
- [ ] Tests pass in CI environment (no localhost dependencies)
- [ ] Test suite completes in under 60 seconds

*Skill Version: 1.0 | Created: February 2026*
