---
name: Seed Data
description: Database seeding patterns for demo data, testing fixtures, and development environments using Prisma and faker.js
---

# Seed Data Skill

**Purpose**: Create reliable, idempotent database seed scripts that populate your application with realistic demo data for development, testing, and product demos -- without ever risking production data.

> [!WARNING]
> **Never run reset/truncate scripts against a production database.** Seed scripts should be environment-aware and refuse destructive operations outside of development. One wrong `DATABASE_URL` can destroy real user data.

---

## 🎯 TRIGGER COMMANDS

```text
"Create seed data"
"Demo data"
"Seed the database"
"Set up development fixtures"
"Add sample data for testing"
"Using seed_data skill: seed [feature/entity]"
```

---

## 🏗️ PRISMA SEED SETUP

### 1. Configure package.json

```json
{
  "prisma": {
    "seed": "ts-node --compiler-options {\"module\":\"CommonJS\"} prisma/seed.ts"
  }
}
```

### 2. Install Dependencies

```bash
npm install -D ts-node @faker-js/faker
npm install bcrypt
npm install -D @types/bcrypt
```

### 3. Run the Seed

```bash
# Seed the database
npx prisma db seed

# Reset and re-seed (dev only -- drops all data first)
npx prisma migrate reset
```

> [!TIP]
> `prisma migrate reset` runs all migrations from scratch and then executes the seed script automatically. Use this during development to get a clean slate.

---

## 🔁 IDEMPOTENT SEEDING PATTERN

The most critical rule: **seed scripts must be safe to run multiple times.** Use `upsert` instead of `create` so re-running the script updates existing records instead of throwing duplicate errors.

```typescript
// prisma/seed.ts -- Core pattern
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // Always use upsert for idempotency
  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},  // Don't overwrite if exists
    create: {
      email: 'admin@example.com',
      name: 'Admin User',
      passwordHash: await hashPassword('admin123'),
      role: 'ADMIN',
    },
  });

  console.log(`Admin user: ${adminUser.id}`);
  console.log('Seeding complete.');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

---

## 📊 SEED DATA CATEGORIES

Plan your seed data in layers. Each layer builds on the previous one:

| Layer | What | Examples | Depends On |
|-------|------|----------|------------|
| 1. System | Roles, permissions, config | Admin role, default settings | Nothing |
| 2. Organization | Tenants, workspaces | Demo Company, Test Org | Nothing |
| 3. Users | Accounts, profiles | Admin, demo users | Organization |
| 4. Core Entities | Primary business objects | Contacts, projects, tasks | Users, Org |
| 5. Relationships | Links between entities | Team members, assignments | Core Entities |
| 6. Activity | Historical data | Comments, logs, events | Core Entities |
| 7. Feature-Specific | Data for specific features | Billing products, AI training data | Varies |

### Referential Integrity Order

```text
Organizations → Users → Projects → Tasks → Comments
                  ↓
              Contacts → Deals → Activities
                  ↓
              Teams → TeamMembers
```

> [!WARNING]
> Always create parent records before children. If you create a `Contact` that references an `organizationId`, the organization must exist first. Prisma will throw a foreign key constraint error otherwise.

---

## 🌍 ENVIRONMENT-AWARE SEEDING

```typescript
// prisma/seed.ts -- Environment check
type SeedEnvironment = 'development' | 'staging' | 'test' | 'production';

function getSeedEnvironment(): SeedEnvironment {
  const env = process.env.NODE_ENV || 'development';
  return env as SeedEnvironment;
}

async function main() {
  const env = getSeedEnvironment();
  console.log(`Seeding for environment: ${env}`);

  // Always seed: admin user, system config
  await seedSystemData();

  if (env === 'development' || env === 'test') {
    // Development/test: full demo data
    await seedDemoOrganization();
    await seedDemoUsers();
    await seedSampleContacts(50);
    await seedSampleProjects(10);
    await seedSampleTasks(100);
  }

  if (env === 'staging') {
    // Staging: minimal but realistic data
    await seedDemoOrganization();
    await seedDemoUsers();
    await seedSampleContacts(10);
    await seedSampleProjects(3);
  }

  if (env === 'production') {
    // Production: ONLY system configuration, never demo data
    console.log('Production mode: only system data seeded.');
  }
}
```

| Environment | What Gets Seeded | Volume |
|-------------|-----------------|--------|
| `development` | Everything | High (50+ contacts, 100+ tasks) |
| `test` | Everything | High (same as dev, for pagination testing) |
| `staging` | Admin + minimal demo | Low (10 contacts, 3 projects) |
| `production` | System config only | None (no demo data) |

---

## 🎭 GENERATING REALISTIC FAKE DATA

```typescript
// prisma/helpers/fake-data.ts
import { faker } from '@faker-js/faker';

// Set a seed for reproducible data across runs
faker.seed(42);

export function fakeContact() {
  const firstName = faker.person.firstName();
  const lastName = faker.person.lastName();
  const company = faker.company.name();

  return {
    firstName,
    lastName,
    email: faker.internet.email({ firstName, lastName }).toLowerCase(),
    phone: faker.phone.number(),
    company,
    jobTitle: faker.person.jobTitle(),
    address: faker.location.streetAddress(),
    city: faker.location.city(),
    state: faker.location.state(),
    zip: faker.location.zipCode(),
    notes: faker.lorem.sentence(),
  };
}

export function fakeProject() {
  return {
    name: `${faker.commerce.productAdjective()} ${faker.commerce.product()} ${faker.helpers.arrayElement(['Redesign', 'Migration', 'Launch', 'Integration', 'Optimization'])}`,
    description: faker.lorem.paragraph(),
    status: faker.helpers.arrayElement(['PLANNING', 'IN_PROGRESS', 'REVIEW', 'COMPLETED']),
    priority: faker.helpers.arrayElement(['LOW', 'MEDIUM', 'HIGH', 'URGENT']),
    startDate: faker.date.recent({ days: 30 }),
    dueDate: faker.date.soon({ days: 60 }),
  };
}

export function fakeTask(projectId: string, assigneeId: string) {
  return {
    title: faker.hacker.phrase(),
    description: faker.lorem.sentences(2),
    status: faker.helpers.arrayElement(['TODO', 'IN_PROGRESS', 'IN_REVIEW', 'DONE']),
    priority: faker.helpers.arrayElement(['LOW', 'MEDIUM', 'HIGH']),
    projectId,
    assigneeId,
    dueDate: faker.date.soon({ days: 14 }),
    estimatedHours: faker.number.float({ min: 0.5, max: 40, fractionDigits: 1 }),
  };
}

export function fakeDeal(contactId: string) {
  return {
    name: `${faker.company.name()} — ${faker.helpers.arrayElement(['Enterprise', 'Pro', 'Starter'])} Plan`,
    value: faker.number.int({ min: 500, max: 50000 }),
    currency: 'USD',
    stage: faker.helpers.arrayElement(['LEAD', 'QUALIFIED', 'PROPOSAL', 'NEGOTIATION', 'CLOSED_WON', 'CLOSED_LOST']),
    contactId,
    expectedCloseDate: faker.date.soon({ days: 90 }),
    probability: faker.number.int({ min: 10, max: 100 }),
  };
}
```

> [!TIP]
> Use `faker.seed(42)` to get the same data on every run. This makes your seed script deterministic -- the same "random" names, emails, and values every time. Great for debugging and consistent screenshots.

---

## 🔐 PASSWORD HASHING IN SEED DATA

```typescript
// prisma/helpers/auth.ts
import * as bcrypt from 'bcrypt';

const SALT_ROUNDS = 12;

export async function hashPassword(plaintext: string): Promise<string> {
  return bcrypt.hash(plaintext, SALT_ROUNDS);
}

// Pre-computed hashes for common dev passwords (saves time during seeding)
// These are bcrypt hashes of the plaintext values shown in comments
export const DEV_PASSWORDS = {
  admin: '$2b$12$LJ3m4ys3Lk0TSwMCkV8eNeRUEh/r.x0yXE/U0v1C7Xz.PLACEHOLDER',  // admin123
  demo: '$2b$12$LJ3m4ys3Lk0TSwMCkV8eNeRUEh/r.x0yXE/U0v1C7Xz.PLACEHOLDER',   // demo123
  test: '$2b$12$LJ3m4ys3Lk0TSwMCkV8eNeRUEh/r.x0yXE/U0v1C7Xz.PLACEHOLDER',   // test123
};
```

> [!WARNING]
> Never use these demo passwords in production. The seed script should skip user creation entirely in production mode. If you must create an admin in production, use a strong generated password from a secrets manager.

---

## 📦 FULL SEED SCRIPT EXAMPLE

```typescript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client';
import { faker } from '@faker-js/faker';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

faker.seed(42);

// ─── HELPERS ──────────────────────────────────────────────
async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, 12);
}

// ─── SYSTEM DATA ──────────────────────────────────────────
async function seedSystemData() {
  console.log('  Seeding system configuration...');

  // Add any system-level config, roles, permissions, etc.
  // Example: default settings
  await prisma.systemSetting.upsert({
    where: { key: 'app_name' },
    update: {},
    create: { key: 'app_name', value: 'Zenith OS' },
  });

  await prisma.systemSetting.upsert({
    where: { key: 'default_timezone' },
    update: {},
    create: { key: 'default_timezone', value: 'America/New_York' },
  });
}

// ─── ORGANIZATION ─────────────────────────────────────────
async function seedDemoOrganization() {
  console.log('  Seeding demo organization...');

  const org = await prisma.organization.upsert({
    where: { slug: 'demo-company' },
    update: {},
    create: {
      name: 'Demo Company',
      slug: 'demo-company',
      domain: 'demo.example.com',
      plan: 'PROFESSIONAL',
      maxUsers: 25,
    },
  });

  return org;
}

// ─── USERS ────────────────────────────────────────────────
async function seedDemoUsers(organizationId: string) {
  console.log('  Seeding demo users...');

  const adminHash = await hashPassword('admin123');
  const demoHash = await hashPassword('demo123');

  const admin = await prisma.user.upsert({
    where: { email: 'admin@demo.example.com' },
    update: {},
    create: {
      email: 'admin@demo.example.com',
      name: 'Sarah Admin',
      passwordHash: adminHash,
      role: 'ADMIN',
      organizationId,
      emailVerified: true,
    },
  });

  const demoUser = await prisma.user.upsert({
    where: { email: 'user@demo.example.com' },
    update: {},
    create: {
      email: 'user@demo.example.com',
      name: 'Alex Demo',
      passwordHash: demoHash,
      role: 'MEMBER',
      organizationId,
      emailVerified: true,
    },
  });

  // Create 5 additional team members
  const teamMembers = [];
  for (let i = 0; i < 5; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const email = `${firstName.toLowerCase()}.${lastName.toLowerCase()}@demo.example.com`;

    const member = await prisma.user.upsert({
      where: { email },
      update: {},
      create: {
        email,
        name: `${firstName} ${lastName}`,
        passwordHash: demoHash,
        role: 'MEMBER',
        organizationId,
        emailVerified: true,
      },
    });
    teamMembers.push(member);
  }

  return { admin, demoUser, teamMembers };
}

// ─── CONTACTS ─────────────────────────────────────────────
async function seedSampleContacts(
  organizationId: string,
  createdById: string,
  count: number,
) {
  console.log(`  Seeding ${count} contacts...`);

  const contacts = [];
  for (let i = 0; i < count; i++) {
    const firstName = faker.person.firstName();
    const lastName = faker.person.lastName();
    const email = faker.internet.email({ firstName, lastName }).toLowerCase();

    const contact = await prisma.contact.upsert({
      where: {
        organizationId_email: { organizationId, email },
      },
      update: {},
      create: {
        firstName,
        lastName,
        email,
        phone: faker.phone.number(),
        company: faker.company.name(),
        jobTitle: faker.person.jobTitle(),
        status: faker.helpers.arrayElement(['LEAD', 'PROSPECT', 'CUSTOMER', 'CHURNED']),
        source: faker.helpers.arrayElement(['WEBSITE', 'REFERRAL', 'COLD_OUTREACH', 'SOCIAL']),
        organizationId,
        createdById,
      },
    });
    contacts.push(contact);
  }

  return contacts;
}

// ─── PROJECTS & TASKS ─────────────────────────────────────
async function seedSampleProjects(
  organizationId: string,
  userIds: string[],
  count: number,
) {
  console.log(`  Seeding ${count} projects with tasks...`);

  for (let i = 0; i < count; i++) {
    const projectName = `${faker.commerce.productAdjective()} ${faker.commerce.product()} ${faker.helpers.arrayElement(['Redesign', 'Migration', 'Launch'])}`;

    const project = await prisma.project.upsert({
      where: {
        organizationId_name: { organizationId, name: projectName },
      },
      update: {},
      create: {
        name: projectName,
        description: faker.lorem.paragraph(),
        status: faker.helpers.arrayElement(['PLANNING', 'IN_PROGRESS', 'REVIEW', 'COMPLETED']),
        priority: faker.helpers.arrayElement(['LOW', 'MEDIUM', 'HIGH', 'URGENT']),
        startDate: faker.date.recent({ days: 30 }),
        dueDate: faker.date.soon({ days: 60 }),
        organizationId,
        ownerId: faker.helpers.arrayElement(userIds),
      },
    });

    // Add 5-15 tasks per project
    const taskCount = faker.number.int({ min: 5, max: 15 });
    for (let j = 0; j < taskCount; j++) {
      await prisma.task.create({
        data: {
          title: faker.hacker.phrase(),
          description: faker.lorem.sentences(2),
          status: faker.helpers.arrayElement(['TODO', 'IN_PROGRESS', 'IN_REVIEW', 'DONE']),
          priority: faker.helpers.arrayElement(['LOW', 'MEDIUM', 'HIGH']),
          projectId: project.id,
          assigneeId: faker.helpers.arrayElement(userIds),
          dueDate: faker.date.soon({ days: 14 }),
          estimatedHours: faker.number.float({ min: 0.5, max: 16, fractionDigits: 1 }),
        },
      });
    }
  }
}

// ─── MAIN ─────────────────────────────────────────────────
async function main() {
  const env = process.env.NODE_ENV || 'development';
  console.log(`\nSeeding database (${env})...\n`);

  // Layer 1: System data (all environments)
  await seedSystemData();

  if (env === 'production') {
    console.log('\nProduction mode: only system data seeded.');
    return;
  }

  // Layer 2: Organization
  const org = await seedDemoOrganization();

  // Layer 3: Users
  const { admin, demoUser, teamMembers } = await seedDemoUsers(org.id);
  const allUserIds = [admin.id, demoUser.id, ...teamMembers.map((m) => m.id)];

  // Layer 4: Core entities
  const contacts = await seedSampleContacts(org.id, admin.id, env === 'staging' ? 10 : 50);

  // Layer 5: Projects & tasks
  await seedSampleProjects(org.id, allUserIds, env === 'staging' ? 3 : 10);

  console.log('\nSeeding complete!');
  console.log('─────────────────────────────────────');
  console.log(`  Admin login:  admin@demo.example.com / admin123`);
  console.log(`  Demo login:   user@demo.example.com / demo123`);
  console.log(`  Organization: Demo Company`);
  console.log(`  Contacts:     ${contacts.length}`);
  console.log('─────────────────────────────────────\n');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

---

## 💳 FEATURE-SPECIFIC SEED DATA

### Billing / Stripe Test Products

```typescript
async function seedBillingData() {
  console.log('  Seeding billing plans...');

  const plans = [
    { name: 'Free', stripePriceId: 'price_free', monthlyPrice: 0, maxUsers: 3 },
    { name: 'Starter', stripePriceId: 'price_starter_test', monthlyPrice: 29, maxUsers: 10 },
    { name: 'Professional', stripePriceId: 'price_pro_test', monthlyPrice: 79, maxUsers: 25 },
    { name: 'Enterprise', stripePriceId: 'price_enterprise_test', monthlyPrice: 199, maxUsers: -1 },
  ];

  for (const plan of plans) {
    await prisma.billingPlan.upsert({
      where: { name: plan.name },
      update: {},
      create: plan,
    });
  }
}
```

### AI Features (Mock Responses)

```typescript
async function seedAITrainingData() {
  console.log('  Seeding AI training examples...');

  const examples = [
    {
      prompt: 'Summarize last quarter performance',
      response: 'Q4 showed 23% revenue growth with 150 new customers...',
      category: 'BUSINESS_INTELLIGENCE',
    },
    {
      prompt: 'Draft follow-up email for prospect',
      response: 'Hi [Name], It was great speaking with you about...',
      category: 'EMAIL_GENERATION',
    },
    {
      prompt: 'Analyze customer churn risk',
      response: 'Based on usage patterns, 3 accounts show high churn risk...',
      category: 'ANALYTICS',
    },
  ];

  for (const example of examples) {
    await prisma.aiTrainingExample.upsert({
      where: {
        category_prompt: { category: example.category, prompt: example.prompt },
      },
      update: {},
      create: example,
    });
  }
}
```

---

## 🗑️ RESET SCRIPT (DEVELOPMENT ONLY)

```typescript
// prisma/reset.ts -- DANGER: Destroys all data
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function reset() {
  const env = process.env.NODE_ENV || 'development';

  // SAFETY: Refuse to run in production or staging
  if (env === 'production' || env === 'staging') {
    console.error('REFUSING to reset database in', env);
    console.error('This script is for development use only.');
    process.exit(1);
  }

  console.log('Resetting database...');

  // Delete in reverse dependency order (children before parents)
  const tableNames = [
    'task',
    'project',
    'deal',
    'activity',
    'contact',
    'team_member',
    'team',
    'user',
    'organization',
    'system_setting',
    'ai_training_example',
    'billing_plan',
  ];

  for (const table of tableNames) {
    try {
      await prisma.$executeRawUnsafe(`TRUNCATE TABLE "${table}" CASCADE;`);
      console.log(`  Truncated: ${table}`);
    } catch (e) {
      console.warn(`  Skipped: ${table} (may not exist)`);
    }
  }

  console.log('Database reset complete. Run `npx prisma db seed` to re-seed.');
}

reset()
  .catch((e) => {
    console.error('Reset failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

Add to `package.json` scripts:

```json
{
  "scripts": {
    "db:seed": "npx prisma db seed",
    "db:reset": "NODE_ENV=development ts-node prisma/reset.ts && npx prisma db seed"
  }
}
```

> [!WARNING]
> The reset script uses `TRUNCATE ... CASCADE` which permanently deletes all data in the specified tables and any tables that reference them via foreign keys. Triple-check your `DATABASE_URL` before running.

---

## 📐 SEED DATA VOLUME GUIDELINES

| Entity | Development | Staging | Production |
|--------|-------------|---------|------------|
| Organizations | 1-2 | 1 | 0 |
| Users | 7-10 | 3 | 1 (admin only) |
| Contacts | 50-100 | 10 | 0 |
| Projects | 10-15 | 3 | 0 |
| Tasks | 100-200 | 15 | 0 |
| Deals | 20-30 | 5 | 0 |
| Comments/Activity | 200-500 | 20 | 0 |

> [!TIP]
> Aim for enough data to test pagination (50+ items for lists that paginate at 25) and search (varied names/companies), but not so much that seeding takes more than 30 seconds. If seeding is slow, batch your creates with `createMany` instead of individual `upsert` loops.

### Performance: Batching with createMany

```typescript
// Fast bulk insert (not idempotent -- use for test environments only)
async function seedContactsBulk(organizationId: string, createdById: string, count: number) {
  const contacts = Array.from({ length: count }, () => ({
    firstName: faker.person.firstName(),
    lastName: faker.person.lastName(),
    email: faker.internet.email().toLowerCase(),
    phone: faker.phone.number(),
    company: faker.company.name(),
    jobTitle: faker.person.jobTitle(),
    status: faker.helpers.arrayElement(['LEAD', 'PROSPECT', 'CUSTOMER']),
    organizationId,
    createdById,
  }));

  await prisma.contact.createMany({
    data: contacts,
    skipDuplicates: true,  // Skip if email already exists
  });
}
```

---

## ✅ EXIT CHECKLIST

- [ ] `prisma/seed.ts` created and runs without errors
- [ ] `package.json` has `prisma.seed` configuration
- [ ] Seed script is idempotent (safe to run multiple times via `upsert`)
- [ ] Admin user created with known credentials for development
- [ ] Demo organization created with realistic name
- [ ] Sample contacts cover search and pagination testing (50+ in dev)
- [ ] Sample projects and tasks created with varied statuses
- [ ] Referential integrity maintained (orgs before users before entities)
- [ ] Environment-aware: full data in dev, minimal in staging, none in production
- [ ] Passwords properly hashed with bcrypt (not stored in plaintext)
- [ ] `faker.seed()` set for deterministic/reproducible data
- [ ] Reset script exists with production safety guard
- [ ] Feature-specific seed data covers billing plans, AI examples
- [ ] Seed completes in under 30 seconds
- [ ] Login credentials printed to console after seeding

---

*Skill Version: 1.0 | Created: February 2026*
