---
name: Mobile Testing Strategy
description: Mobile testing approaches including unit, widget, integration, E2E with Detox and Maestro, device farms, and CI integration
---

# Mobile Testing Strategy Skill

**Purpose**: Define comprehensive mobile testing strategies spanning unit tests, widget/component tests, integration tests, and end-to-end automation using tools like Detox and Maestro, including device farm and CI configuration.

---

## TRIGGER COMMANDS

```text
"Set up mobile testing for my app"
"Configure E2E tests with Detox or Maestro"
"Set up a device farm for testing"
"Mobile CI/CD testing pipeline"
"Using mobile_testing_strategy skill: [task]"
```

---

## Testing Pyramid for Mobile

```
            /\
           /  \        E2E Tests (Detox/Maestro)
          / 5% \       - Critical user journeys
         /------\      - Smoke tests on real devices
        /        \
       /  15-20%  \    Integration Tests
      /            \   - Screen-level, API integration
     /--------------\  - Navigation flows
    /                \
   /    70-80%        \ Unit Tests
  /                    \ - Business logic, utils
 /______________________\ - State management, reducers
```

### Test Type Responsibilities

| Test Type | Scope | Speed | Reliability | Runs On |
|-----------|-------|-------|-------------|---------|
| Unit | Functions, classes | <1ms each | 99%+ | CI (all PRs) |
| Widget/Component | Single component | 5-50ms each | 98%+ | CI (all PRs) |
| Integration | Feature flows | 100-500ms each | 95%+ | CI (all PRs) |
| E2E | Full app | 10-60s each | 85-95% | CI (nightly + pre-release) |
| Manual QA | Exploratory | Minutes | N/A | Pre-release |

---

## Unit Testing

### React Native (Jest)

```typescript
// src/utils/__tests__/formatCurrency.test.ts
import { formatCurrency } from '../formatCurrency';

describe('formatCurrency', () => {
  it('formats USD with two decimals', () => {
    expect(formatCurrency(1234.5, 'USD')).toBe('$1,234.50');
  });

  it('handles zero', () => {
    expect(formatCurrency(0, 'USD')).toBe('$0.00');
  });

  it('handles negative values', () => {
    expect(formatCurrency(-50, 'USD')).toBe('-$50.00');
  });

  it('formats EUR with euro symbol', () => {
    expect(formatCurrency(1234.5, 'EUR')).toBe('\u20AC1,234.50');
  });
});
```

### Testing Zustand Stores

```typescript
// src/stores/__tests__/cartStore.test.ts
import { useCartStore } from '../cartStore';

describe('cartStore', () => {
  beforeEach(() => {
    useCartStore.setState({ items: [], total: 0 });
  });

  it('adds item to cart', () => {
    const { addItem } = useCartStore.getState();

    addItem({ id: '1', name: 'Widget', price: 9.99, quantity: 1 });

    const state = useCartStore.getState();
    expect(state.items).toHaveLength(1);
    expect(state.total).toBe(9.99);
  });

  it('increments quantity for duplicate items', () => {
    const { addItem } = useCartStore.getState();
    const item = { id: '1', name: 'Widget', price: 9.99, quantity: 1 };

    addItem(item);
    addItem(item);

    const state = useCartStore.getState();
    expect(state.items).toHaveLength(1);
    expect(state.items[0].quantity).toBe(2);
    expect(state.total).toBe(19.98);
  });

  it('removes item from cart', () => {
    const { addItem, removeItem } = useCartStore.getState();
    addItem({ id: '1', name: 'Widget', price: 9.99, quantity: 1 });

    removeItem('1');

    expect(useCartStore.getState().items).toHaveLength(0);
  });
});
```

### Flutter (dart test)

```dart
// test/domain/usecases/calculate_discount_test.dart
import 'package:test/test.dart';
import 'package:my_app/domain/usecases/calculate_discount.dart';

void main() {
  late CalculateDiscount calculateDiscount;

  setUp(() {
    calculateDiscount = CalculateDiscount();
  });

  group('CalculateDiscount', () => {
    test('applies percentage discount', () {
      final result = calculateDiscount(
        price: 100.0,
        discount: Discount.percentage(20),
      );
      expect(result, equals(80.0));
    });

    test('applies fixed discount', () {
      final result = calculateDiscount(
        price: 100.0,
        discount: Discount.fixed(15.0),
      );
      expect(result, equals(85.0));
    });

    test('never returns negative', () {
      final result = calculateDiscount(
        price: 10.0,
        discount: Discount.fixed(50.0),
      );
      expect(result, equals(0.0));
    });

    test('handles zero price', () {
      final result = calculateDiscount(
        price: 0.0,
        discount: Discount.percentage(50),
      );
      expect(result, equals(0.0));
    });
  });
}
```

---

## Widget / Component Testing

### React Native (React Native Testing Library)

```typescript
// src/components/__tests__/LoginForm.test.tsx
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import { LoginForm } from '../LoginForm';

describe('LoginForm', () => {
  const mockOnSubmit = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders email and password fields', () => {
    const { getByPlaceholderText } = render(
      <LoginForm onSubmit={mockOnSubmit} />
    );

    expect(getByPlaceholderText('Email')).toBeTruthy();
    expect(getByPlaceholderText('Password')).toBeTruthy();
  });

  it('shows validation errors on empty submit', async () => {
    const { getByText, getByTestId } = render(
      <LoginForm onSubmit={mockOnSubmit} />
    );

    fireEvent.press(getByTestId('submit-button'));

    await waitFor(() => {
      expect(getByText('Email is required')).toBeTruthy();
      expect(getByText('Password is required')).toBeTruthy();
    });
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('calls onSubmit with valid data', async () => {
    const { getByPlaceholderText, getByTestId } = render(
      <LoginForm onSubmit={mockOnSubmit} />
    );

    fireEvent.changeText(getByPlaceholderText('Email'), 'test@example.com');
    fireEvent.changeText(getByPlaceholderText('Password'), 'password123');
    fireEvent.press(getByTestId('submit-button'));

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      });
    });
  });

  it('disables button while loading', () => {
    const { getByTestId } = render(
      <LoginForm onSubmit={mockOnSubmit} isLoading />
    );

    const button = getByTestId('submit-button');
    expect(button.props.accessibilityState?.disabled).toBe(true);
  });
});
```

### Flutter Widget Tests

```dart
// test/widgets/product_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/product_card.dart';

void main() {
  final testProduct = Product(
    id: '1',
    name: 'Test Product',
    price: 29.99,
    imageUrl: 'https://example.com/image.jpg',
  );

  testWidgets('displays product name and price', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ProductCard(product: testProduct)),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$29.99'), findsOneWidget);
  });

  testWidgets('calls onTap when pressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ProductCard(
          product: testProduct,
          onTap: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(ProductCard));
    expect(tapped, isTrue);
  });

  testWidgets('shows sale badge when on sale', (tester) async {
    final saleProduct = testProduct.copyWith(salePrice: 19.99);
    await tester.pumpWidget(
      MaterialApp(home: ProductCard(product: saleProduct)),
    );

    expect(find.text('SALE'), findsOneWidget);
    expect(find.text('\$19.99'), findsOneWidget);
  });
}
```

---

## E2E Testing

### Detox (React Native)

```javascript
// e2e/login.test.js
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp({ newInstance: true });
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should login with valid credentials', async () => {
    await element(by.id('email-input')).typeText('test@example.com');
    await element(by.id('password-input')).typeText('password123');
    await element(by.id('login-button')).tap();

    await waitFor(element(by.id('home-screen')))
      .toBeVisible()
      .withTimeout(5000);
  });

  it('should show error for invalid credentials', async () => {
    await element(by.id('email-input')).typeText('wrong@example.com');
    await element(by.id('password-input')).typeText('wrong');
    await element(by.id('login-button')).tap();

    await waitFor(element(by.text('Invalid email or password')))
      .toBeVisible()
      .withTimeout(3000);
  });

  it('should navigate to forgot password', async () => {
    await element(by.id('forgot-password-link')).tap();

    await waitFor(element(by.id('forgot-password-screen')))
      .toBeVisible()
      .withTimeout(3000);
  });
});
```

### Detox Configuration

```javascript
// .detoxrc.js
module.exports = {
  testRunner: {
    args: {
      config: 'e2e/jest.config.js',
      _: ['e2e'],
    },
  },
  apps: {
    'ios.debug': {
      type: 'ios.app',
      binaryPath: 'ios/build/Build/Products/Debug-iphonesimulator/MyApp.app',
      build: 'xcodebuild -workspace ios/MyApp.xcworkspace -scheme MyApp -configuration Debug -sdk iphonesimulator -derivedDataPath ios/build',
    },
    'android.debug': {
      type: 'android.apk',
      binaryPath: 'android/app/build/outputs/apk/debug/app-debug.apk',
      build: 'cd android && ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug',
      reversePorts: [8081],
    },
  },
  devices: {
    simulator: {
      type: 'ios.simulator',
      device: { type: 'iPhone 15' },
    },
    emulator: {
      type: 'android.emulator',
      device: { avdName: 'Pixel_7_API_34' },
    },
  },
  configurations: {
    'ios.sim.debug': { device: 'simulator', app: 'ios.debug' },
    'android.emu.debug': { device: 'emulator', app: 'android.debug' },
  },
};
```

### Maestro (Cross-Platform, Recommended for Simplicity)

```yaml
# .maestro/flows/login.yaml
appId: com.myapp
---
- launchApp
- tapOn: "Email"
- inputText: "test@example.com"
- tapOn: "Password"
- inputText: "password123"
- tapOn: "Log In"
- assertVisible: "Welcome back"

# .maestro/flows/add-to-cart.yaml
appId: com.myapp
---
- launchApp
- tapOn: "Search"
- inputText: "Bluetooth Speaker"
- tapOn: "Search"
- assertVisible: "Bluetooth Speaker"
- tapOn: "Add to Cart"
- assertVisible: "Added to cart"
- tapOn: "Cart"
- assertVisible: "Bluetooth Speaker"
- assertVisible: "$49.99"
```

### Maestro vs Detox Comparison

| Feature | Maestro | Detox |
|---------|---------|-------|
| Setup complexity | Very low (YAML) | High (native build) |
| Language | YAML | JavaScript |
| Cross-platform | iOS + Android + Flutter + RN | RN (iOS + Android) |
| Flakiness | Low | Medium |
| Speed | Moderate | Fast |
| CI integration | maestro cloud | Manual setup |
| Visual testing | Built-in screenshots | Third-party |
| Community | Growing | Established |
| Best for | Most teams | RN-heavy teams |

---

## Device Farm Testing

### Cloud Device Farm Options

| Service | Platforms | Real Devices | Pricing Model | CI Integration |
|---------|-----------|-------------|---------------|----------------|
| AWS Device Farm | iOS, Android | Yes | Pay per minute | Good |
| Firebase Test Lab | iOS, Android | Yes | Free tier + pay | Excellent |
| BrowserStack | iOS, Android | Yes | Subscription | Good |
| Sauce Labs | iOS, Android | Yes | Subscription | Good |
| Maestro Cloud | iOS, Android | Yes | Per flow run | Native |

### Firebase Test Lab Configuration

```yaml
# .github/workflows/device-tests.yml
name: Device Farm Tests

on:
  schedule:
    - cron: '0 2 * * *'  # Nightly
  workflow_dispatch:

jobs:
  android-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build debug APK
        run: cd android && ./gradlew assembleDebug

      - name: Build test APK
        run: cd android && ./gradlew assembleAndroidTest

      - uses: google-github-actions/auth@v2
        with:
          credentials_json: ${{ secrets.GCP_SA_KEY }}

      - name: Run on Firebase Test Lab
        run: |
          gcloud firebase test android run \
            --type instrumentation \
            --app android/app/build/outputs/apk/debug/app-debug.apk \
            --test android/app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
            --device model=Pixel7,version=34 \
            --device model=SamsungGalaxyS23,version=33 \
            --timeout 10m \
            --results-dir test-results
```

---

## CI/CD Integration

### GitHub Actions Mobile Testing Pipeline

```yaml
# .github/workflows/mobile-tests.yml
name: Mobile Tests

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm test -- --coverage
      - uses: codecov/codecov-action@v4

  component-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm run test:components

  e2e-ios:
    runs-on: macos-14
    needs: [unit-tests, component-tests]
    if: github.event_name == 'push'  # Only on merge to main
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npx detox build --configuration ios.sim.release
      - run: npx detox test --configuration ios.sim.release --cleanup

  e2e-android:
    runs-on: ubuntu-latest
    needs: [unit-tests, component-tests]
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 34
          arch: x86_64
          script: |
            npx detox build --configuration android.emu.release
            npx detox test --configuration android.emu.release --cleanup
```

---

## Test Coverage Targets

| Layer | Target | Hard Minimum |
|-------|--------|-------------|
| Business logic (shared) | 90%+ | 80% |
| State management | 85%+ | 75% |
| UI components | 70%+ | 60% |
| Navigation flows | 60%+ | 40% |
| E2E critical paths | 100% of P0 flows | 100% of P0 flows |

---

## Cross-References

- `3-build/react_native_patterns` - RN-specific testing patterns
- `3-build/flutter_development` - Flutter widget testing
- `5-ship/app_store_deployment` - Pre-release testing requirements
- `4-secure/mobile_security_testing` - Security-focused testing

---

## EXIT CHECKLIST

- [ ] Testing pyramid defined with coverage targets per layer
- [ ] Unit test framework configured (Jest/dart test)
- [ ] Component/widget test patterns established
- [ ] E2E framework selected and configured (Detox or Maestro)
- [ ] Critical user journeys identified and automated
- [ ] CI pipeline runs unit + component tests on every PR
- [ ] E2E tests run nightly or pre-release
- [ ] Device farm configured for real-device testing
- [ ] Test data management strategy defined
- [ ] Flaky test policy documented (quarantine, fix SLA)

---

*Skill Version: 1.0 | Created: March 2026*
