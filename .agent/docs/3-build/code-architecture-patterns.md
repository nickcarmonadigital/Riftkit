# Code Architecture Patterns

> **Architecture is about making your codebase easy to change.** Good patterns make adding features straightforward. Bad patterns make every change a surgery.

---

## SOLID Principles with NestJS

### S — Single Responsibility

Each class/service has ONE reason to change.

```typescript
// BAD — UserService does too many things
@Injectable()
class UserService {
  async createUser(dto) { ... }
  async sendWelcomeEmail(user) { ... }     // Email is NOT user logic
  async generateInvoice(user) { ... }      // Billing is NOT user logic
  async uploadAvatar(user, file) { ... }   // File storage is NOT user logic
}

// GOOD — each service has one responsibility
@Injectable()
class UserService { async create(dto) { ... } }

@Injectable()
class EmailService { async sendWelcome(user) { ... } }

@Injectable()
class BillingService { async generateInvoice(user) { ... } }

@Injectable()
class StorageService { async upload(file) { ... } }
```

### O — Open/Closed

Open for extension, closed for modification. Add new behavior without changing existing code.

```typescript
// BAD — must modify this function every time you add a provider
function getAIResponse(provider: string, prompt: string) {
  if (provider === 'openai') { /* OpenAI code */ }
  else if (provider === 'claude') { /* Claude code */ }
  else if (provider === 'gemini') { /* Gemini code */ }
  // Every new provider = modify this function
}

// GOOD — Strategy pattern: add new providers without touching existing code
interface AIProvider {
  generate(prompt: string): Promise<string>;
}

@Injectable()
class OpenAIProvider implements AIProvider {
  async generate(prompt: string) { /* OpenAI implementation */ }
}

@Injectable()
class ClaudeProvider implements AIProvider {
  async generate(prompt: string) { /* Claude implementation */ }
}

// Adding Gemini = new class. Existing code untouched.
```

### L — Liskov Substitution

Any implementation of an interface should work wherever the interface is expected.

```typescript
// If your code works with NotificationService, it should work with ANY implementation
interface NotificationService {
  send(userId: string, message: string): Promise<void>;
}

class EmailNotification implements NotificationService {
  async send(userId: string, message: string) { /* send email */ }
}

class SlackNotification implements NotificationService {
  async send(userId: string, message: string) { /* send Slack DM */ }
}

class SmsNotification implements NotificationService {
  async send(userId: string, message: string) { /* send SMS */ }
}

// Any of these can be swapped in without changing the calling code
```

### I — Interface Segregation

Don't force a class to implement methods it doesn't need.

```typescript
// BAD — one giant interface
interface Repository {
  findAll(): Promise<any[]>;
  findOne(id: string): Promise<any>;
  create(data: any): Promise<any>;
  update(id: string, data: any): Promise<any>;
  delete(id: string): Promise<void>;
  search(query: string): Promise<any[]>;
  aggregate(pipeline: any): Promise<any>;
  export(format: string): Promise<Buffer>;
}

// GOOD — split by need
interface Readable<T> {
  findAll(): Promise<T[]>;
  findOne(id: string): Promise<T>;
}

interface Writable<T> {
  create(data: Partial<T>): Promise<T>;
  update(id: string, data: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
}

interface Searchable<T> {
  search(query: string): Promise<T[]>;
}

// A read-only service only implements Readable
class AnalyticsService implements Readable<AnalyticsEntry> { ... }

// A full CRUD service implements both
class UserService implements Readable<User>, Writable<User> { ... }
```

### D — Dependency Inversion

Depend on abstractions, not concrete implementations.

```typescript
// BAD — depends on concrete class
@Injectable()
class OrderService {
  private stripe = new StripeClient(); // Tightly coupled to Stripe
}

// GOOD — depends on abstraction
interface PaymentProcessor {
  charge(amount: number, currency: string): Promise<PaymentResult>;
}

@Injectable()
class OrderService {
  constructor(
    @Inject('PAYMENT_PROCESSOR')
    private payment: PaymentProcessor, // Works with ANY processor
  ) {}
}

// NestJS module wires it up
@Module({
  providers: [
    OrderService,
    { provide: 'PAYMENT_PROCESSOR', useClass: StripeProcessor },
    // Switch to: { provide: 'PAYMENT_PROCESSOR', useClass: PayPalProcessor }
  ],
})
```

---

## NestJS Dependency Injection Deep Dive

### How NestJS DI Works

```
1. You declare @Injectable() on a class
2. You register it as a provider in a module
3. NestJS creates a single instance (singleton by default)
4. When another class needs it (in constructor), NestJS injects it
```

### Provider Types

```typescript
@Module({
  providers: [
    // Standard class provider (most common)
    UserService,

    // useClass — provide interface implementation
    { provide: 'CACHE_MANAGER', useClass: RedisCacheService },

    // useFactory — dynamic creation with dependencies
    {
      provide: 'DATABASE_CONNECTION',
      useFactory: async (config: ConfigService) => {
        return createConnection(config.get('DATABASE_URL'));
      },
      inject: [ConfigService],
    },

    // useValue — provide a static value
    { provide: 'APP_CONFIG', useValue: { maxRetries: 3, timeout: 5000 } },
  ],
})
```

### Injection Scopes

```typescript
// DEFAULT — singleton (one instance for the entire app)
@Injectable() // scope: Scope.DEFAULT is implicit
class UserService {}

// REQUEST — new instance per HTTP request (when you need request context)
@Injectable({ scope: Scope.REQUEST })
class RequestScopedService {}

// TRANSIENT — new instance every time it's injected
@Injectable({ scope: Scope.TRANSIENT })
class TransientService {}
```

**Rule**: Use DEFAULT (singleton) unless you have a specific reason not to. REQUEST scope has a performance cost because NestJS must create a new instance for every request.

---

## Design Patterns with TypeScript

### Factory Pattern

```typescript
// AIProviderFactory — create the right provider based on config
@Injectable()
export class AIProviderFactory {
  constructor(
    private openai: OpenAIProvider,
    private claude: ClaudeProvider,
    private gemini: GeminiProvider,
  ) {}

  create(providerName: string): AIProvider {
    switch (providerName) {
      case 'openai': return this.openai;
      case 'claude': return this.claude;
      case 'gemini': return this.gemini;
      default: throw new Error(`Unknown provider: ${providerName}`);
    }
  }
}
```

### Repository Pattern

```typescript
// Abstract repository — interface for data access
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}

// Concrete implementation with Prisma
@Injectable()
class PrismaUserRepository implements UserRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({ where: { email } });
  }

  async save(user: Partial<User>): Promise<User> {
    return this.prisma.user.upsert({
      where: { id: user.id ?? '' },
      create: user as any,
      update: user,
    });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.user.delete({ where: { id } });
  }
}
```

### Strategy Pattern

```typescript
// Different notification strategies
interface NotificationStrategy {
  send(to: string, message: string): Promise<void>;
}

@Injectable()
class EmailStrategy implements NotificationStrategy {
  async send(to: string, message: string) {
    await this.mailer.send({ to, subject: 'Notification', body: message });
  }
}

@Injectable()
class SlackStrategy implements NotificationStrategy {
  async send(to: string, message: string) {
    await this.slack.postMessage({ channel: to, text: message });
  }
}

// The service uses whichever strategy is configured
@Injectable()
class NotificationService {
  constructor(
    @Inject('NOTIFICATION_STRATEGY')
    private strategy: NotificationStrategy,
  ) {}

  async notify(userId: string, message: string) {
    const user = await this.getUser(userId);
    await this.strategy.send(user.contactInfo, message);
  }
}
```

### Observer Pattern (NestJS EventEmitter2)

```typescript
// Emit events — decouple "what happened" from "what to do about it"
@Injectable()
class UserService {
  constructor(private eventEmitter: EventEmitter2) {}

  async create(dto: CreateUserDto): Promise<User> {
    const user = await this.prisma.user.create({ data: dto });
    this.eventEmitter.emit('user.created', user); // Fire and forget
    return user;
  }
}

// Listen for events — separate concerns
@Injectable()
class WelcomeEmailListener {
  @OnEvent('user.created')
  async handleUserCreated(user: User) {
    await this.emailService.sendWelcome(user);
  }
}

@Injectable()
class AnalyticsListener {
  @OnEvent('user.created')
  async handleUserCreated(user: User) {
    await this.analytics.track('user_signup', { userId: user.id });
  }
}
```

---

## Clean Architecture Mapping to NestJS

```
Clean Architecture Layer    →    NestJS Equivalent
─────────────────────────────────────────────────
Entities (Domain)           →    Prisma models + domain types
Use Cases (Application)     →    Services (@Injectable)
Interface Adapters          →    Controllers, Guards, Pipes, Interceptors
Frameworks & Drivers        →    NestJS framework, Prisma, Express
```

**The Dependency Rule**: Dependencies point INWARD. Controllers depend on Services. Services depend on Prisma. But Prisma does NOT depend on Controllers.

---

## Anti-Patterns Catalog

| Anti-Pattern | Symptom | Fix |
|-------------|---------|-----|
| **God Service** | 500+ line service doing everything | Split by domain responsibility |
| **Anemic Domain Model** | Services with all logic, models are just data bags | Move validation/business rules closer to the data |
| **Shotgun Surgery** | One feature change requires editing 10+ files | Consolidate related logic into cohesive modules |
| **Feature Envy** | Service A constantly accesses Service B's internals | Move the method to Service B or expose a proper API |
| **Service Locator** | Manually getting dependencies instead of injection | Use NestJS DI (constructor injection) |
| **Circular Dependency** | A depends on B, B depends on A | Use events, extract shared interface, or restructure |

---

## Decision Matrix

| Scenario | Pattern | Why |
|----------|---------|-----|
| Multiple implementations of the same concept | Strategy | Swap implementations without changing consumers |
| Creating objects based on runtime config | Factory | Centralize creation logic, add new types easily |
| Data access abstraction | Repository | Swap database without changing business logic |
| Reacting to events without coupling | Observer/Events | Decouple "what happened" from "what to do" |
| Wrapping external libraries | Adapter | Isolate your code from third-party API changes |
| Adding behavior to requests/responses | Decorator/Interceptor | Cross-cutting concerns without modifying handlers |

---

*Code Architecture Patterns v1.0 | Created: February 13, 2026*
