---
name: refactoring
description: Safe refactoring techniques and code smell detection for TypeScript codebases
---

# Refactoring Skill

**Purpose**: Improve code structure without changing behavior. Detect code smells, apply extract patterns, and refactor safely with tests as your safety net.

## 🎯 TRIGGER COMMANDS

```text
"This code smells, help me refactor"
"Refactor [service/component] for maintainability"
"Split this god service into smaller services"
"Detect code smells in [file]"
"Using refactoring skill"
```

## When to Use

- A service or component is growing too large (>300 lines)
- You notice duplicated code across files
- A change requires modifying many unrelated files
- Code is hard to test because of tight coupling
- Before adding a new feature to messy code

---

## PART 1: CODE SMELLS CATALOG

| # | Smell | Detection | Fix |
|---|-------|-----------|-----|
| 1 | **Long Method** | Function > 30 lines | Extract Method |
| 2 | **God Service** | Class > 300 lines, 10+ methods | Split into focused services |
| 3 | **Duplicate Code** | Same logic in 2+ places | Extract shared function/service |
| 4 | **Primitive Obsession** | Passing raw strings for IDs, emails | Branded types, value objects |
| 5 | **Feature Envy** | Service A constantly accesses B's internals | Move method to B |
| 6 | **Shotgun Surgery** | One change = edit 5+ files | Consolidate related logic |
| 7 | **Dead Code** | Unused imports, unreachable branches | Delete it |
| 8 | **Magic Numbers** | `if (status === 3)` | Extract constants/enums |

---

## PART 2: EXTRACT PATTERNS

### Extract Method

```typescript
// BEFORE — long method
async processOrder(orderId: string) {
  const order = await this.prisma.order.findUnique({ where: { id: orderId } });
  if (!order) throw new NotFoundException();

  // 20 lines of price calculation
  const subtotal = order.items.reduce((sum, item) => sum + item.price * item.qty, 0);
  const tax = subtotal * 0.08;
  const shipping = subtotal > 100 ? 0 : 9.99;
  const total = subtotal + tax + shipping;

  // 15 lines of inventory check
  for (const item of order.items) {
    const product = await this.prisma.product.findUnique({ where: { id: item.productId } });
    if (product.stock < item.qty) throw new BadRequestException(`${product.name} out of stock`);
  }

  // More processing...
}

// AFTER — extracted methods
async processOrder(orderId: string) {
  const order = await this.findOrderOrThrow(orderId);
  const totals = this.calculateTotals(order);
  await this.validateInventory(order.items);
  // More processing...
}

private async findOrderOrThrow(id: string) {
  const order = await this.prisma.order.findUnique({ where: { id } });
  if (!order) throw new NotFoundException();
  return order;
}

private calculateTotals(order: Order) {
  const subtotal = order.items.reduce((sum, item) => sum + item.price * item.qty, 0);
  const tax = subtotal * 0.08;
  const shipping = subtotal > 100 ? 0 : 9.99;
  return { subtotal, tax, shipping, total: subtotal + tax + shipping };
}
```

### Extract Service

```typescript
// BEFORE — God Service
@Injectable()
class UserService {
  async create(dto) { /* user creation */ }
  async sendWelcomeEmail(user) { /* email logic */ }
  async generateReport(userId) { /* report logic */ }
  async uploadAvatar(file) { /* file storage */ }
  async calculateUsage(userId) { /* analytics */ }
}

// AFTER — focused services
@Injectable() class UserService { async create(dto) { ... } }
@Injectable() class EmailService { async sendWelcome(user) { ... } }
@Injectable() class ReportService { async generate(userId) { ... } }
@Injectable() class StorageService { async upload(file) { ... } }
@Injectable() class AnalyticsService { async calculateUsage(userId) { ... } }
```

### Extract Interface

```typescript
// BEFORE — tightly coupled to Stripe
@Injectable()
class PaymentService {
  private stripe = new Stripe(process.env.STRIPE_KEY);
  async charge(amount: number) { return this.stripe.charges.create({ amount }); }
}

// AFTER — depends on interface, implementations are swappable
interface PaymentProcessor {
  charge(amount: number, currency: string): Promise<PaymentResult>;
}

@Injectable()
class StripeProcessor implements PaymentProcessor {
  async charge(amount: number, currency: string) { /* Stripe logic */ }
}

@Injectable()
class PaymentService {
  constructor(@Inject('PAYMENT') private processor: PaymentProcessor) {}
  async charge(amount: number) { return this.processor.charge(amount, 'usd'); }
}
```

---

## PART 3: SAFE REFACTORING PROCESS

```
1. ✅ Ensure tests exist
   - If no tests → write characterization tests first
   - Tests capture CURRENT behavior (even if buggy)

2. 🔄 Make ONE small change
   - One extract method, one rename, one move

3. 🧪 Run tests
   - All tests must still pass
   - If they fail → undo the change and try differently

4. 💾 Commit
   - Small commit with descriptive message
   - `refactor(users): extract email logic to EmailService`

5. 🔁 Repeat
   - Small steps compound into large improvements
   - Never refactor and add features in the same commit
```

### Why Small Commits During Refactoring

- Each commit is a safe checkpoint you can revert to
- If tests break, you know exactly which change caused it
- Code reviews are easier (reviewer sees the logical steps)
- `git bisect` can pinpoint issues to a specific refactoring step

---

## PART 4: STRANGLER FIG PATTERN

Gradually replace legacy code without a big-bang rewrite:

```typescript
// Step 1: Create new implementation alongside old
@Injectable()
class NewUserService {
  async findAll() { /* clean implementation */ }
}

// Step 2: Route through a facade that delegates
@Injectable()
class UserServiceFacade {
  constructor(
    private legacy: LegacyUserService,
    private modern: NewUserService,
    private featureFlags: FeatureFlagsService,
  ) {}

  async findAll() {
    if (await this.featureFlags.isEnabled('new-user-service')) {
      return this.modern.findAll();
    }
    return this.legacy.findAll();
  }
}

// Step 3: Gradually enable for more users (1% → 10% → 100%)
// Step 4: Once 100% on new implementation, remove legacy code and facade
```

---

## PART 5: WHEN NOT TO REFACTOR

| Scenario | Why Not | Instead |
|----------|---------|---------|
| Right before a deadline | Risk of introducing bugs under pressure | Ship first, refactor in next sprint |
| Code you don't understand yet | You might break assumptions | Understand first, refactor later |
| Code that works and won't change | No benefit, wasted effort | Leave it alone |
| Without tests | No safety net | Write tests first |
| For aesthetics only | Personal preference ≠ improvement | Only refactor for measurable maintainability |

---

## PART 6: TECH DEBT TRACKING

```markdown
## Tech Debt Register

| ID | Description | Impact | Effort | Priority | Status |
|----|-------------|--------|--------|----------|--------|
| TD-001 | UserService is 500 lines | Hard to test/modify | M | High | Planned |
| TD-002 | Duplicate validation in 3 controllers | Bug risk (fix one, miss others) | S | Medium | Open |
| TD-003 | No error handling in payment flow | Could crash silently | L | Critical | In Progress |
```

### Boy Scout Rule

"Leave the code better than you found it."

What counts as "better":
- Rename a confusing variable
- Extract a magic number to a constant
- Delete dead code
- Add a missing type annotation

What does NOT count:
- Rewriting a function that works fine
- Changing formatting (that's Prettier's job)
- Redesigning the architecture of a file you're adding one line to

---

---

## Agent Automation

> Use the **refactor-cleaner** agent (`.agent/agents/refactor-cleaner.md`) for automated dead code removal and cleanup.
> Invoke via: `/refactor-clean`

The refactor-cleaner agent can:
- Identify and remove dead code
- Clean up unused imports
- Consolidate duplicate logic
- Simplify complex conditionals

---

## ✅ Exit Checklist

- [ ] Tests exist before refactoring begins
- [ ] Each refactoring step is a separate commit
- [ ] All tests pass after each step
- [ ] No behavior changes mixed with refactoring
- [ ] Code smells addressed are documented
- [ ] Tech debt items tracked for future sprints
- [ ] Dead code removed (unused imports, unreachable branches)
- [ ] Duplicate logic consolidated into shared utilities
