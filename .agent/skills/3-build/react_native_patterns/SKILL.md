---
name: React Native Patterns
description: React Native navigation, state management, native modules, performance optimization, and Expo vs bare workflow
---

# React Native Patterns Skill

**Purpose**: Guide developers through production-grade React Native architecture including navigation patterns, state management strategies, native module integration, performance optimization, and choosing between Expo and bare workflows.

---

## TRIGGER COMMANDS

```text
"Help me build a React Native app"
"Set up React Native navigation architecture"
"Optimize React Native performance"
"Should I use Expo or bare workflow?"
"Using react_native_patterns skill: [task]"
```

---

## Expo vs Bare Workflow Decision Matrix

| Factor | Expo Managed | Expo Dev Build | Bare Workflow |
|--------|-------------|----------------|---------------|
| Setup time | Minutes | 15-30 min | 1-2 hours |
| Native module access | Limited (SDK only) | Full (config plugins) | Full |
| OTA updates | Built-in (EAS Update) | Built-in (EAS Update) | Manual (CodePush) |
| Build service | EAS Build | EAS Build | Local / CI |
| App size | Larger (~25MB+) | Moderate | Smallest |
| Ejection needed | For custom native | No | N/A |
| CI/CD complexity | Low | Low | High |
| Custom native code | No | Yes (config plugins) | Yes |
| Recommended for | MVPs, prototypes | Most production apps | Heavy native deps |

### Decision Flow

```
Need custom native modules not in Expo SDK?
  Yes -> Need full native control?
    Yes -> Bare Workflow
    No  -> Expo Dev Build with Config Plugins
  No  -> Expo Managed Workflow
```

### Starting a New Project

```bash
# Expo (recommended default)
npx create-expo-app@latest my-app --template tabs

# Expo with dev build support
npx create-expo-app@latest my-app
npx expo install expo-dev-client

# Bare workflow (only when necessary)
npx react-native@latest init MyApp
```

---

## Navigation Architecture

### Stack + Tab + Drawer Pattern

The standard production navigation setup uses React Navigation with a nested structure.

```typescript
// src/navigation/types.ts
import { NavigatorScreenParams } from '@react-navigation/native';

export type RootStackParamList = {
  Auth: NavigatorScreenParams<AuthStackParamList>;
  Main: NavigatorScreenParams<MainTabParamList>;
  Modal: { id: string };
};

export type AuthStackParamList = {
  Login: undefined;
  Register: { referralCode?: string };
  ForgotPassword: undefined;
};

export type MainTabParamList = {
  Home: undefined;
  Search: { query?: string };
  Profile: { userId: string };
  Settings: undefined;
};

// Type-safe navigation hook
declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}
```

```typescript
// src/navigation/RootNavigator.tsx
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { NavigationContainer } from '@react-navigation/native';
import { RootStackParamList, MainTabParamList } from './types';

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator<MainTabParamList>();

function MainTabs() {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: '#007AFF',
        tabBarLabelStyle: { fontSize: 12 },
      }}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Search" component={SearchScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export function RootNavigator() {
  const { isAuthenticated } = useAuth();

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <>
            <Stack.Screen name="Main" component={MainTabs} />
            <Stack.Group screenOptions={{ presentation: 'modal' }}>
              <Stack.Screen name="Modal" component={ModalScreen} />
            </Stack.Group>
          </>
        ) : (
          <Stack.Screen name="Auth" component={AuthNavigator} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

### Deep Linking Configuration

```typescript
// src/navigation/linking.ts
import { LinkingOptions } from '@react-navigation/native';
import { RootStackParamList } from './types';

export const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://myapp.com'],
  config: {
    screens: {
      Main: {
        screens: {
          Home: 'home',
          Profile: 'profile/:userId',
          Search: 'search',
        },
      },
      Auth: {
        screens: {
          Login: 'login',
          Register: 'register',
        },
      },
      Modal: 'modal/:id',
    },
  },
};
```

---

## State Management

### Zustand (Recommended Default)

Zustand provides the best balance of simplicity, performance, and TypeScript support for React Native.

```typescript
// src/stores/authStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';

interface User {
  id: string;
  email: string;
  displayName: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  setUser: (user: User) => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      isLoading: false,

      login: async (email, password) => {
        set({ isLoading: true });
        try {
          const response = await api.post('/auth/login', { email, password });
          set({
            user: response.data.user,
            token: response.data.token,
            isLoading: false,
          });
        } catch (error) {
          set({ isLoading: false });
          throw error;
        }
      },

      logout: () => {
        set({ user: null, token: null });
      },

      setUser: (user) => set({ user }),
    }),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => AsyncStorage),
      partialize: (state) => ({ user: state.user, token: state.token }),
    }
  )
);
```

### State Management Comparison

| Feature | Zustand | Redux Toolkit | Jotai | React Query |
|---------|---------|---------------|-------|-------------|
| Boilerplate | Minimal | Moderate | Minimal | Moderate |
| Bundle size | ~2KB | ~11KB | ~3KB | ~13KB |
| Learning curve | Low | Medium | Low | Medium |
| DevTools | Yes | Excellent | Limited | Excellent |
| Persistence | Plugin | Plugin | Plugin | Built-in cache |
| Best for | App state | Complex state | Atomic state | Server state |
| TypeScript | Excellent | Good | Excellent | Excellent |

### TanStack Query for Server State

```typescript
// src/hooks/useProducts.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

export function useProducts(categoryId: string) {
  return useQuery({
    queryKey: ['products', categoryId],
    queryFn: () => api.get(`/products?category=${categoryId}`),
    staleTime: 5 * 60 * 1000,
    gcTime: 30 * 60 * 1000,
  });
}

export function useCreateProduct() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateProductDto) => api.post('/products', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['products'] });
    },
  });
}
```

---

## Native Modules

### Turbo Modules (New Architecture)

```typescript
// src/specs/NativeCalculator.ts
import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  add(a: number, b: number): Promise<number>;
  multiply(a: number, b: number): number; // sync
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeCalculator');
```

```kotlin
// android/app/src/main/java/com/myapp/NativeCalculatorModule.kt
package com.myapp

import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = NativeCalculatorModule.NAME)
class NativeCalculatorModule(reactContext: ReactApplicationContext) :
    NativeCalculatorSpec(reactContext) {

    override fun getName() = NAME

    override fun add(a: Double, b: Double, promise: Promise) {
        promise.resolve(a + b)
    }

    override fun multiply(a: Double, b: Double): Double {
        return a * b
    }

    companion object {
        const val NAME = "NativeCalculator"
    }
}
```

### Expo Config Plugin (Preferred for Expo)

```typescript
// plugins/withCustomPermission.ts
import { ConfigPlugin, withAndroidManifest } from '@expo/config-plugins';

const withCustomPermission: ConfigPlugin = (config) => {
  return withAndroidManifest(config, (mod) => {
    const manifest = mod.modResults.manifest;
    const permissions = manifest['uses-permission'] || [];

    permissions.push({
      $: { 'android:name': 'android.permission.BLUETOOTH_CONNECT' },
    });

    manifest['uses-permission'] = permissions;
    return mod;
  });
};

export default withCustomPermission;
```

---

## Performance Optimization

### FlatList Optimization

```typescript
// src/components/OptimizedList.tsx
import { memo, useCallback, useMemo } from 'react';
import { FlatList, ViewToken } from 'react-native';

interface Item {
  id: string;
  title: string;
  imageUrl: string;
}

const ITEM_HEIGHT = 80;

const ListItem = memo(function ListItem({ item }: { item: Item }) {
  return (
    <View style={{ height: ITEM_HEIGHT, flexDirection: 'row', padding: 12 }}>
      <FastImage
        source={{ uri: item.imageUrl }}
        style={{ width: 56, height: 56, borderRadius: 8 }}
      />
      <Text style={{ marginLeft: 12 }}>{item.title}</Text>
    </View>
  );
});

export function OptimizedList({ data }: { data: Item[] }) {
  const keyExtractor = useCallback((item: Item) => item.id, []);
  const renderItem = useCallback(
    ({ item }: { item: Item }) => <ListItem item={item} />,
    []
  );
  const getItemLayout = useCallback(
    (_: unknown, index: number) => ({
      length: ITEM_HEIGHT,
      offset: ITEM_HEIGHT * index,
      index,
    }),
    []
  );

  return (
    <FlatList
      data={data}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}
      removeClippedSubviews
      maxToRenderPerBatch={10}
      windowSize={5}
      initialNumToRender={10}
    />
  );
}
```

### Performance Checklist

| Issue | Solution | Impact |
|-------|----------|--------|
| Unnecessary re-renders | `React.memo`, `useCallback`, `useMemo` | High |
| Large lists | FlatList with `getItemLayout` | High |
| Image loading | `expo-image` or `react-native-fast-image` | High |
| JS thread blocking | Move computation to `InteractionManager` | Medium |
| Animation jank | Reanimated (runs on UI thread) | High |
| Bridge overhead | New Architecture (Turbo Modules / Fabric) | Medium |
| Large bundles | Lazy imports, `React.lazy` | Medium |
| Hermes disabled | Enable Hermes engine | High |

### Reanimated Animations

```typescript
// src/components/AnimatedCard.tsx
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withSpring,
  withTiming,
} from 'react-native-reanimated';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';

export function AnimatedCard({ children }: { children: React.ReactNode }) {
  const scale = useSharedValue(1);
  const translateY = useSharedValue(0);

  const gesture = Gesture.Pan()
    .onUpdate((event) => {
      translateY.value = event.translationY;
    })
    .onEnd(() => {
      translateY.value = withSpring(0);
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { scale: withSpring(scale.value) },
      { translateY: translateY.value },
    ],
  }));

  return (
    <GestureDetector gesture={gesture}>
      <Animated.View style={[styles.card, animatedStyle]}>
        {children}
      </Animated.View>
    </GestureDetector>
  );
}
```

---

## Project Structure

```
src/
  app/                    # App entry, providers
    App.tsx
    Providers.tsx
  navigation/             # All navigation config
    types.ts
    RootNavigator.tsx
    linking.ts
  screens/                # Screen components (1:1 with routes)
    home/
      HomeScreen.tsx
      components/         # Screen-specific components
    auth/
      LoginScreen.tsx
      RegisterScreen.tsx
  components/             # Shared UI components
    Button.tsx
    Card.tsx
    Typography.tsx
  hooks/                  # Custom hooks
    useAuth.ts
    useProducts.ts
  stores/                 # Zustand stores
    authStore.ts
    settingsStore.ts
  services/               # API clients, native bridges
    api.ts
    analytics.ts
  utils/                  # Pure utility functions
    format.ts
    validation.ts
  constants/              # App constants, theme
    theme.ts
    config.ts
  types/                  # Shared TypeScript types
    api.ts
    models.ts
```

---

## Common Patterns

### Safe Area Handling

```typescript
import { SafeAreaProvider, useSafeAreaInsets } from 'react-native-safe-area-context';

function ScreenWrapper({ children }: { children: React.ReactNode }) {
  const insets = useSafeAreaInsets();

  return (
    <View style={{ flex: 1, paddingTop: insets.top, paddingBottom: insets.bottom }}>
      {children}
    </View>
  );
}
```

### Platform-Specific Code

```typescript
import { Platform, StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  shadow: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
    },
    android: {
      elevation: 4,
    },
  }),
});
```

### Error Boundary

```typescript
// src/components/ErrorBoundary.tsx
import React, { Component, ErrorInfo } from 'react';

interface Props {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    // Report to crash analytics
    crashlytics().recordError(error, info.componentStack);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback ?? <ErrorFallback error={this.state.error} />;
    }
    return this.props.children;
  }
}
```

---

## Cross-References

- `2-design/cross_platform_architecture` - For choosing between RN and alternatives
- `4-secure/mobile_testing_strategy` - For testing React Native apps
- `5-ship/app_store_deployment` - For deploying RN apps to stores
- `4-secure/mobile_security_testing` - For RN security best practices
- `3-build/accessibility_implementation` - For accessible RN components

---

## EXIT CHECKLIST

- [ ] Navigation architecture defined with type-safe params
- [ ] State management strategy chosen and implemented
- [ ] FlatList/ScrollView components optimized
- [ ] Animations use Reanimated (not Animated API)
- [ ] Hermes engine enabled
- [ ] Error boundaries wrap critical UI sections
- [ ] Deep linking configured and tested
- [ ] Safe area handling consistent across screens
- [ ] Platform-specific code uses Platform.select or .ios/.android files
- [ ] New Architecture enabled if dependencies support it
- [ ] Bundle size analyzed with `npx react-native-bundle-visualizer`

---

*Skill Version: 1.0 | Created: March 2026*
