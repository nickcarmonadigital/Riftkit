---
name: Cross-Platform Architecture
description: Choosing cross-platform approach between React Native, Flutter, KMP, and web with shared logic patterns
---

# Cross-Platform Architecture Skill

**Purpose**: Guide teams through selecting the right cross-platform technology and designing architectures that maximize code sharing while maintaining platform-native experiences.

---

## TRIGGER COMMANDS

```text
"Should I use React Native or Flutter?"
"Design a cross-platform mobile architecture"
"How to share code between iOS and Android"
"Evaluate cross-platform frameworks for my project"
"Using cross_platform_architecture skill: [task]"
```

---

## Framework Comparison Matrix

| Factor | React Native | Flutter | KMP (Kotlin Multiplatform) | PWA | Capacitor |
|--------|-------------|---------|---------------------------|-----|-----------|
| Language | TypeScript/JS | Dart | Kotlin | JS/TS | JS/TS |
| UI approach | Native components | Custom rendering | Native UI per platform | Web | Web + native plugins |
| Code sharing | ~85-95% | ~95-99% | ~50-70% (logic only) | 100% | ~90% |
| Performance | Near-native | Near-native | Native | Web-bound | Web + native bridge |
| Team skills needed | React/JS | Dart (new) | Kotlin + Swift | Web | Web |
| App size (base) | ~7-15MB | ~10-20MB | Native | ~0 (browser) | ~3-5MB |
| Hot reload | Yes | Yes (superior) | Partial | Yes | Yes |
| Platform look/feel | Native | Custom (Material/Cupertino) | Fully native | Web | Web-like |
| Ecosystem maturity | Very high | High | Growing | Very high | Moderate |
| Typical team size | 3-8 | 3-8 | 5-15 | 2-5 | 2-5 |
| Best for | Consumer apps | Design-heavy apps | Existing native teams | Content apps | Simple apps |

---

## Decision Framework

### Step 1: Identify Project Requirements

```
+----------------------------------------------------+
|              PROJECT REQUIREMENTS                   |
+----------------------------------------------------+
| 1. Target platforms: iOS / Android / Web / Desktop  |
| 2. UI complexity: Simple / Moderate / Complex       |
| 3. Native API needs: Low / Medium / Heavy           |
| 4. Performance bar: Standard / High / Critical      |
| 5. Team expertise: Web / Mobile / Both              |
| 6. Timeline: MVP (<3mo) / Standard / Long-term      |
| 7. Budget: Startup / Mid / Enterprise               |
| 8. Offline requirements: None / Basic / Heavy       |
+----------------------------------------------------+
```

### Step 2: Decision Tree

```
Do you need iOS + Android?
├── No (web only) → PWA or SPA
└── Yes
    ├── Do you have existing native codebases?
    │   ├── Yes → KMP (share logic, keep native UI)
    │   └── No
    │       ├── Is pixel-perfect custom UI critical?
    │       │   ├── Yes → Flutter
    │       │   └── No
    │       │       ├── Does team know React/TypeScript?
    │       │       │   ├── Yes → React Native
    │       │       │   └── No
    │       │       │       ├── Is it a simple content app?
    │       │       │       │   ├── Yes → Capacitor or PWA
    │       │       │       │   └── No → Flutter
    │       │       └── Do you also need web + desktop?
    │       │           ├── Yes → Flutter (best multi-target)
    │       │           └── No → React Native or Flutter
    └── Do you need desktop too?
        ├── Yes → Flutter or Electron + RN
        └── No → React Native or Flutter
```

### Step 3: Weighted Scoring

| Criterion | Weight | RN Score | Flutter Score | KMP Score | PWA Score |
|-----------|--------|----------|---------------|-----------|-----------|
| Team expertise match | 25% | ? | ? | ? | ? |
| Time to market | 20% | ? | ? | ? | ? |
| Performance needs | 15% | ? | ? | ? | ? |
| Native API access | 15% | ? | ? | ? | ? |
| Long-term maintenance | 15% | ? | ? | ? | ? |
| Hiring/talent pool | 10% | ? | ? | ? | ? |
| **Weighted Total** | 100% | | | | |

Score each 1-5 based on project needs. Multiply by weight.

---

## Shared Logic Architecture

### Clean Architecture for Cross-Platform

```
+----------------------------------------------------------+
|                    PRESENTATION LAYER                     |
|   (Platform-specific UI: React Native / Flutter / Web)   |
+----------------------------------------------------------+
|                    APPLICATION LAYER                      |
|   (Use cases, business logic - SHARED)                   |
+----------------------------------------------------------+
|                      DOMAIN LAYER                        |
|   (Entities, interfaces, value objects - SHARED)         |
+----------------------------------------------------------+
|                  INFRASTRUCTURE LAYER                     |
|   (API clients, storage, platform services - SHARED*)    |
+----------------------------------------------------------+
        * Platform-specific implementations injected
```

### Pattern: Shared Business Logic with Platform UI

```typescript
// shared/domain/entities/Product.ts (shared across all platforms)
export interface Product {
  id: string;
  name: string;
  price: number;
  currency: string;
  images: string[];
  category: ProductCategory;
}

// shared/domain/usecases/GetProductsUseCase.ts
export class GetProductsUseCase {
  constructor(private readonly repo: ProductRepository) {}

  async execute(filters: ProductFilters): Promise<Result<Product[]>> {
    const products = await this.repo.getProducts(filters);
    return products.map(p => this.applyBusinessRules(p));
  }

  private applyBusinessRules(product: Product): Product {
    // Tax calculation, discount logic, etc. - shared across platforms
    return {
      ...product,
      price: this.calculateFinalPrice(product),
    };
  }
}

// shared/domain/ports/ProductRepository.ts (interface)
export interface ProductRepository {
  getProducts(filters: ProductFilters): Promise<Product[]>;
  getProduct(id: string): Promise<Product>;
  searchProducts(query: string): Promise<Product[]>;
}
```

### Monorepo Structure

```
my-app/
  packages/
    shared/                     # Shared business logic
      src/
        domain/
          entities/
          usecases/
          ports/                # Repository interfaces
        infrastructure/
          api/                  # HTTP client, API adapters
          storage/              # Storage abstraction
      package.json
    mobile/                     # React Native app
      src/
        screens/
        components/
        adapters/               # Platform-specific implementations
      package.json
    web/                        # Web app (React/Next.js)
      src/
        pages/
        components/
        adapters/
      package.json
    ui-kit/                     # Shared UI components (if same framework)
      src/
        Button/
        Card/
      package.json
  package.json                  # Workspace root
  turbo.json                    # Turborepo config
```

### Turborepo Configuration

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**", "build/**"]
    },
    "test": {
      "dependsOn": ["^build"]
    },
    "lint": {},
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

---

## KMP Architecture (Kotlin Multiplatform)

### Shared Module Structure

```kotlin
// shared/src/commonMain/kotlin/com/myapp/domain/Product.kt
data class Product(
    val id: String,
    val name: String,
    val price: Double,
    val currency: String,
)

// shared/src/commonMain/kotlin/com/myapp/data/ProductRepository.kt
class ProductRepository(
    private val api: ProductApi,
    private val cache: ProductCache,
) {
    suspend fun getProducts(): List<Product> {
        return try {
            val products = api.fetchProducts()
            cache.save(products)
            products
        } catch (e: Exception) {
            cache.getAll()
        }
    }
}

// shared/src/commonMain/kotlin/com/myapp/data/ProductApi.kt
// Uses Ktor (cross-platform HTTP client)
class ProductApi(private val client: HttpClient) {
    suspend fun fetchProducts(): List<Product> {
        return client.get("https://api.myapp.com/products").body()
    }
}
```

```kotlin
// Platform-specific: expect/actual pattern
// shared/src/commonMain/kotlin/com/myapp/platform/Platform.kt
expect class SecureStorage {
    fun save(key: String, value: String)
    fun read(key: String): String?
}

// shared/src/androidMain/kotlin/.../Platform.kt
actual class SecureStorage(private val context: Context) {
    actual fun save(key: String, value: String) {
        EncryptedSharedPreferences.create(context, ...).edit().putString(key, value).apply()
    }
    actual fun read(key: String): String? {
        return EncryptedSharedPreferences.create(context, ...).getString(key, null)
    }
}

// shared/src/iosMain/kotlin/.../Platform.kt
actual class SecureStorage {
    actual fun save(key: String, value: String) {
        // Use iOS Keychain via interop
    }
    actual fun read(key: String): String? {
        // Read from iOS Keychain
    }
}
```

---

## API Layer Patterns

### Shared API Client

```typescript
// packages/shared/src/infrastructure/api/apiClient.ts
export interface HttpClient {
  get<T>(url: string, config?: RequestConfig): Promise<T>;
  post<T>(url: string, data?: unknown, config?: RequestConfig): Promise<T>;
  put<T>(url: string, data?: unknown, config?: RequestConfig): Promise<T>;
  delete<T>(url: string, config?: RequestConfig): Promise<T>;
}

export interface RequestConfig {
  headers?: Record<string, string>;
  params?: Record<string, string>;
  timeout?: number;
}

// Platform implementations inject their own HTTP client
// Mobile: uses fetch or axios with RN networking
// Web: uses fetch or axios with browser networking
```

### Offline-First Pattern

```typescript
// packages/shared/src/infrastructure/sync/SyncManager.ts
export class SyncManager {
  constructor(
    private readonly localDb: LocalDatabase,
    private readonly remoteApi: RemoteApi,
    private readonly conflictResolver: ConflictResolver,
  ) {}

  async sync(): Promise<SyncResult> {
    const pendingChanges = await this.localDb.getPendingChanges();
    const remoteChanges = await this.remoteApi.getChangesSince(
      await this.localDb.getLastSyncTimestamp()
    );

    const conflicts = this.detectConflicts(pendingChanges, remoteChanges);
    const resolved = await this.conflictResolver.resolve(conflicts);

    await this.localDb.applyChanges(remoteChanges);
    await this.remoteApi.pushChanges(pendingChanges);
    await this.localDb.setLastSyncTimestamp(Date.now());

    return { pushed: pendingChanges.length, pulled: remoteChanges.length, conflicts: resolved.length };
  }
}
```

---

## Platform-Specific Considerations

### Feature Parity Matrix Template

| Feature | iOS | Android | Web | Priority |
|---------|-----|---------|-----|----------|
| Push notifications | APNs | FCM | Web Push | P0 |
| Biometric auth | Face ID / Touch ID | Fingerprint / Face | WebAuthn | P0 |
| Camera access | AVFoundation | Camera2 | MediaStream | P1 |
| File system | App sandbox | Scoped storage | File API | P1 |
| Background tasks | BGTaskScheduler | WorkManager | Service Worker | P2 |
| Deep linking | Universal Links | App Links | URL routing | P0 |
| Payments | StoreKit 2 | Google Play Billing | Stripe | P0 |
| Maps | MapKit | Google Maps | Mapbox/Google | P2 |
| Bluetooth | CoreBluetooth | Android BLE | Web Bluetooth | P3 |

### Platform Abstraction Layer

```typescript
// packages/shared/src/platform/PlatformCapabilities.ts
export interface PlatformCapabilities {
  hasBiometrics(): Promise<boolean>;
  hasCamera(): boolean;
  hasPushNotifications(): boolean;
  hasFileSystem(): boolean;
  hasBackgroundTasks(): boolean;
  getDeviceInfo(): DeviceInfo;
}

// Each platform implements this interface
// This allows shared code to check capabilities before using them
```

---

## When NOT to Go Cross-Platform

Cross-platform is not always the right answer. Choose native when:

- App is heavily GPU/graphics dependent (games, AR/VR)
- Deep OS integration required (system extensions, widgets, complications)
- Team is already split into iOS and Android specialists
- App needs cutting-edge platform APIs on day one
- Performance is the primary differentiator (trading apps, real-time audio)
- Only targeting a single platform

---

## Migration Strategies

### Native to Cross-Platform

1. **Strangler Fig**: New features in cross-platform, old features stay native
2. **Shared Logic First**: Move business logic to KMP, keep native UI
3. **Feature by Feature**: Rewrite one feature at a time in the new framework
4. **Big Bang**: Complete rewrite (risky, but sometimes faster for small apps)

### Recommended Migration Path

```
Phase 1: Share business logic (KMP or shared TS package)
Phase 2: Build new features cross-platform
Phase 3: Migrate existing features incrementally
Phase 4: Retire native-only code
```

---

## Cross-References

- `3-build/react_native_patterns` - Detailed React Native implementation patterns
- `3-build/flutter_development` - Detailed Flutter implementation patterns
- `3-build/progressive_web_app` - PWA as a cross-platform option
- `3-build/design_system_development` - Multi-framework design systems
- `4-secure/mobile_testing_strategy` - Testing across platforms

---

## EXIT CHECKLIST

- [ ] Framework selected with documented rationale and scoring
- [ ] Feature parity matrix created for all target platforms
- [ ] Shared logic layer identified (domain, use cases, API)
- [ ] Platform-specific boundaries clearly defined
- [ ] Monorepo or project structure established
- [ ] Build pipeline supports all target platforms
- [ ] Platform abstraction interfaces defined for native capabilities
- [ ] Offline/sync strategy defined if needed
- [ ] Performance benchmarks set for each platform
- [ ] Migration path documented if moving from existing native apps

---

*Skill Version: 1.0 | Created: March 2026*
