---
name: Flutter Development
description: Flutter widget architecture, state management with Riverpod and BLoC, platform channels, and Dart patterns
---

# Flutter Development Skill

**Purpose**: Guide developers through production Flutter architecture including widget composition, state management selection and implementation, platform channel integration, and idiomatic Dart patterns.

---

## TRIGGER COMMANDS

```text
"Help me build a Flutter app"
"Set up Flutter state management"
"Implement platform channels in Flutter"
"Flutter widget architecture advice"
"Using flutter_development skill: [task]"
```

---

## Widget Architecture

### Composition Over Inheritance

Flutter widgets follow a strict composition model. Never extend StatelessWidget/StatefulWidget for reuse -- compose instead.

```dart
// GOOD: Composition
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label, style: theme.textTheme.labelLarge),
    );
  }
}
```

### Widget Tree Structure

```
MaterialApp
  └── Router (GoRouter)
       └── ShellRoute (scaffold + nav bar)
            ├── HomePage
            │    └── CustomScrollView
            │         ├── SliverAppBar
            │         └── SliverList.builder
            ├── SearchPage
            └── ProfilePage
```

### Key Widget Categories

| Category | Widgets | Use Case |
|----------|---------|----------|
| Layout | `Column`, `Row`, `Stack`, `Flex` | Arranging children |
| Scrolling | `ListView.builder`, `CustomScrollView`, `Slivers` | Scrollable content |
| Input | `TextField`, `Form`, `FormField` | User input |
| Feedback | `SnackBar`, `Dialog`, `BottomSheet` | User feedback |
| Adaptive | `Platform.isIOS ? CupertinoX : MaterialX` | Cross-platform UI |
| Animation | `AnimatedContainer`, `Hero`, `AnimatedBuilder` | Motion |

---

## State Management

### State Management Decision Matrix

| Feature | Riverpod | BLoC | Provider | GetX |
|---------|----------|------|----------|------|
| Compile-safe | Yes | Partial | No | No |
| Testability | Excellent | Excellent | Good | Poor |
| Boilerplate | Low | High | Low | Lowest |
| Learning curve | Medium | High | Low | Low |
| Code generation | Optional | Optional | No | No |
| DevTools | Yes | Yes (bloc_inspector) | Yes | Limited |
| Recommended | Yes | Yes (enterprise) | Legacy | No |

### Riverpod (Recommended)

```dart
// lib/features/auth/providers/auth_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() async {
    final token = await ref.watch(secureStorageProvider).read('token');
    if (token == null) return null;
    return ref.watch(authRepositoryProvider).getUser(token);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final result = await authRepo.login(email, password);
      await ref.read(secureStorageProvider).write('token', result.token);
      return result.user;
    });
  }

  Future<void> logout() async {
    await ref.read(secureStorageProvider).delete('token');
    state = const AsyncData(null);
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(dio: ref.watch(dioProvider));
}
```

```dart
// Usage in widget
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) => user != null ? const HomePage() : const LoginForm(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

### BLoC Pattern (Enterprise)

```dart
// lib/features/products/bloc/product_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_bloc.freezed.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(const ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      await event.map(
        load: (e) => _onLoad(e, emit),
        refresh: (e) => _onRefresh(e, emit),
        loadMore: (e) => _onLoadMore(e, emit),
      );
    });
  }

  Future<void> _onLoad(_Load event, Emitter<ProductState> emit) async {
    emit(const ProductState.loading());
    try {
      final products = await _repository.getProducts(page: 1);
      emit(ProductState.loaded(products: products, page: 1, hasMore: products.length >= 20));
    } catch (e, st) {
      emit(ProductState.error(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<ProductState> emit) async {
    final current = state;
    if (current is! _Loaded || !current.hasMore) return;

    final nextPage = current.page + 1;
    try {
      final more = await _repository.getProducts(page: nextPage);
      emit(current.copyWith(
        products: [...current.products, ...more],
        page: nextPage,
        hasMore: more.length >= 20,
      ));
    } catch (e) {
      // Keep current state, show snackbar
    }
  }
}
```

```dart
// product_event.dart
part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.load() = _Load;
  const factory ProductEvent.refresh() = _Refresh;
  const factory ProductEvent.loadMore() = _LoadMore;
}

// product_state.dart
part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = _Initial;
  const factory ProductState.loading() = _Loading;
  const factory ProductState.loaded({
    required List<Product> products,
    required int page,
    required bool hasMore,
  }) = _Loaded;
  const factory ProductState.error({required String message}) = _Error;
}
```

---

## Platform Channels

### Method Channel (Dart Side)

```dart
// lib/services/native_battery.dart
import 'dart:io';
import 'package:flutter/services.dart';

class NativeBattery {
  static const _channel = MethodChannel('com.myapp/battery');

  Future<int> getBatteryLevel() async {
    try {
      final int level = await _channel.invokeMethod('getBatteryLevel');
      return level;
    } on PlatformException catch (e) {
      throw BatteryException('Failed to get battery level: ${e.message}');
    }
  }

  Stream<int> batteryLevelStream() {
    const eventChannel = EventChannel('com.myapp/battery_events');
    return eventChannel.receiveBroadcastStream().map((event) => event as int);
  }
}
```

### Method Channel (Android/Kotlin)

```kotlin
// android/app/src/main/kotlin/.../MainActivity.kt
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.myapp/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val batteryLevel = getBatteryLevel()
                        if (batteryLevel != -1) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
```

### Method Channel (iOS/Swift)

```swift
// ios/Runner/AppDelegate.swift
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.myapp/battery",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "getBatteryLevel":
                let device = UIDevice.current
                device.isBatteryMonitoringEnabled = true
                let level = Int(device.batteryLevel * 100)
                result(level)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

---

## Navigation with GoRouter

```dart
// lib/router/app_router.dart
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).valueOrNull != null;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');

    if (!isLoggedIn && !isAuthRoute) return '/auth/login';
    if (isLoggedIn && isAuthRoute) return '/';
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'product/:id',
              builder: (context, state) => ProductPage(
                id: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchPage(
            query: state.uri.queryParameters['q'],
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
```

---

## Dart Patterns

### Sealed Classes (Union Types)

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, {this.error});
}

// Usage
Future<Result<User>> getUser(String id) async {
  try {
    final response = await dio.get('/users/$id');
    return Success(User.fromJson(response.data));
  } catch (e) {
    return Failure('Failed to fetch user', error: e);
  }
}

// Pattern matching
final result = await getUser('123');
switch (result) {
  case Success(:final data):
    print('Got user: ${data.name}');
  case Failure(:final message):
    print('Error: $message');
}
```

### Extension Methods

```dart
extension StringX on String {
  String get capitalized => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  bool get isValidEmail => RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
```

---

## Project Structure

```
lib/
  app/
    app.dart                 # MaterialApp / GoRouter setup
    theme.dart               # ThemeData definitions
  features/                  # Feature-first organization
    auth/
      providers/             # Riverpod providers
      widgets/               # Feature-specific widgets
      pages/                 # Full page widgets
      models/                # Feature DTOs
      repositories/          # Data access
    products/
      ...
  shared/
    widgets/                 # Reusable UI components
    extensions/              # Dart extensions
    utils/                   # Pure utility functions
    constants/               # App-wide constants
    models/                  # Shared data models
  services/                  # Platform channels, native bridges
  l10n/                      # Localization (ARB files)
```

---

## Performance

### Build Optimization

```dart
// Use const constructors whenever possible
const SizedBox(height: 16);
const EdgeInsets.all(16);
const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

// Use const widgets
class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1);
  }
}
```

### ListView Best Practices

```dart
// GOOD: Use .builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
);

// GOOD: Use .separated when you need dividers
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => const Divider(),
  itemBuilder: (context, index) => ItemTile(item: items[index]),
);

// BAD: Never put ListView inside Column without bounds
// Use Expanded or SliverList instead
```

### Image Caching

```dart
// Use cached_network_image for network images
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => const ShimmerPlaceholder(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  memCacheHeight: 200,  // Resize in memory
  memCacheWidth: 200,
);
```

---

## Cross-References

- `2-design/cross_platform_architecture` - Choosing Flutter vs alternatives
- `4-secure/mobile_testing_strategy` - Testing Flutter apps (widget tests, integration tests)
- `5-ship/app_store_deployment` - Deploying Flutter apps to stores
- `3-build/design_system_development` - Building design systems for Flutter
- `4-secure/mobile_security_testing` - Flutter security best practices

---

## EXIT CHECKLIST

- [ ] State management strategy selected and implemented
- [ ] GoRouter configured with type-safe routes and guards
- [ ] Feature-first project structure established
- [ ] Platform channels implemented with proper error handling
- [ ] const constructors used everywhere possible
- [ ] ListView.builder used for dynamic lists (never ListView with children array)
- [ ] Image caching configured for network images
- [ ] Theme system set up with Material 3
- [ ] Sealed classes used for result types and states
- [ ] Code generation running (build_runner for Riverpod/Freezed)
- [ ] Localization set up with ARB files

---

*Skill Version: 1.0 | Created: March 2026*
