# Blueprint: Mobile App

A mobile application for iOS, Android, or both. This blueprint covers cross-platform and native approaches, offline-first architecture, push notifications, and app store submission.

## Recommended Tech Stacks

| Stack | Language | Best For |
|-------|----------|----------|
| React Native | TypeScript | Teams with React experience, code sharing with web |
| Flutter | Dart | High-performance UI, custom animations, both platforms |
| Swift / SwiftUI | Swift | iOS-only, best native experience, Apple ecosystem |
| Kotlin / Jetpack Compose | Kotlin | Android-only, best native experience, Google ecosystem |
| Expo | TypeScript | Rapid prototyping, managed workflow, OTA updates |

## Phase-by-Phase Skill Recommendations

### Phase 1: Ideation and Planning
- **idea_to_spec** -- Define app purpose, platform targets, offline requirements
- **prd_generator** -- Document screens, navigation flows, platform-specific features
- **user_research** -- Mobile-specific UX research (thumb zones, gesture patterns)
- **competitive_analysis** -- App store research, rating analysis, feature gaps

### Phase 2: Architecture
- **schema_design** -- Local database (SQLite/Realm) + remote API sync
- **api_design** -- Mobile-optimized API (batch endpoints, pagination, partial responses)
- **auth_architecture** -- Biometric auth, secure token storage (Keychain/Keystore)
- **caching_strategy** -- Offline-first data layer, conflict resolution

### Phase 3: Implementation
- **tdd_workflow** -- Unit tests for business logic, component snapshot tests
- **code_review** -- Review navigation, state management, platform-specific code
- **validation_patterns** -- Form validation, input formatting

### Phase 4: Testing and Security
- **integration_testing** -- Device testing matrix (screen sizes, OS versions)
- **security_audit** -- Mobile-specific: certificate pinning, secure storage, root detection
- **load_testing** -- API performance under mobile network conditions

### Phase 5: Deployment
- **ci_cd_pipeline** -- Fastlane, EAS Build, or platform-specific CI
- **deployment_patterns** -- Staged rollout (1% -> 10% -> 50% -> 100%)
- **release_signing** -- Code signing certificates, provisioning profiles

### Phase 6-7: Release and Operations
- **monitoring_setup** -- Crash reporting (Crashlytics, Sentry), analytics
- **incident_response** -- Hot-fix via OTA update vs full store release

## Key Domain-Specific Concerns

### Offline-First Architecture
- Design for unreliable connectivity as the default state
- Local database (SQLite, WatermelonDB, Realm) for all critical data
- Queue mutations when offline, sync when connected
- Conflict resolution strategy: last-write-wins, merge, or manual
- Show stale data with "last updated" indicator rather than empty screens

### Push Notifications
- Use Firebase Cloud Messaging (FCM) for Android, APNs for iOS
- Request permission at a meaningful moment (not on first launch)
- Support notification channels/categories for user control
- Handle deep linking from notification tap
- Silent pushes for background data sync

### Navigation
- Follow platform conventions: tab bar (iOS), bottom navigation (Android)
- Support deep linking for every screen (`myapp://profile/123`)
- Handle back navigation correctly on Android
- Persist navigation state for app resume

### App Store Submission
| Requirement | iOS (App Store) | Android (Google Play) |
|-------------|-----------------|----------------------|
| Review time | 1-3 days | Hours to 3 days |
| Screenshots | 6.7", 6.5", 5.5" required | Phone + tablet |
| Privacy | Privacy nutrition labels | Data safety form |
| Signing | Certificates + provisioning | Keystore + signing config |
| Updates | Full review for native code | Staged rollout available |
| Payments | IAP required (30% fee) | IAP or external (regional) |

### Performance
- Target 60fps for all animations and scrolls
- Lazy load images with placeholder/skeleton screens
- Minimize bundle size (tree shaking, code splitting)
- Profile startup time -- aim for <2s cold start
- Monitor memory usage -- mobile devices are constrained

### Security
- Store tokens in Keychain (iOS) / EncryptedSharedPreferences (Android)
- Certificate pinning for API communication
- Obfuscate release builds (ProGuard/R8 for Android)
- Never store sensitive data in AsyncStorage/SharedPreferences unencrypted
- Implement biometric authentication for sensitive actions

## Getting Started

1. **Choose platform strategy** -- Cross-platform (React Native/Flutter) vs native
2. **Design navigation map** -- All screens and transitions on paper first
3. **Set up project** -- `npx react-native init` / `flutter create` / Xcode project
4. **Implement auth flow** -- Login, registration, token storage, biometrics
5. **Build navigation shell** -- Tab bar, stack navigators, deep link config
6. **Create data layer** -- API client, local database, sync logic
7. **Build screens incrementally** -- One feature flow at a time, test on device
8. **Add push notifications** -- FCM/APNs setup, permission request, deep linking
9. **Test on real devices** -- Multiple screen sizes, OS versions, network conditions
10. **Submit to stores** -- Screenshots, descriptions, privacy forms, review

## Project Structure (React Native Example)

```
src/
  app/
    App.tsx              # Root component, providers
    navigation/          # React Navigation config
  features/
    auth/
      screens/           # Login, Register, ForgotPassword
      hooks/             # useAuth, useBiometrics
      api/               # Auth API calls
    home/
    profile/
    [feature]/
  shared/
    components/          # Reusable UI components
    hooks/               # Shared hooks
    services/
      api.ts             # API client (Axios/fetch)
      storage.ts         # Secure storage wrapper
      sync.ts            # Offline sync engine
    theme/               # Colors, typography, spacing
  types/
android/                 # Native Android config
ios/                     # Native iOS config
```
