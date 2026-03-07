---
name: App Store Deployment
description: App store submission for iOS App Store and Google Play including signing, versioning, review process, and Fastlane automation
---

# App Store Deployment Skill

**Purpose**: Guide developers through the complete app store submission process for iOS and Android, covering code signing, versioning, metadata, review guidelines, and CI/CD automation with Fastlane and EAS.

---

## TRIGGER COMMANDS

```text
"Deploy my app to the App Store"
"Set up Fastlane for automated releases"
"Prepare for App Store review"
"Configure code signing for iOS/Android"
"Using app_store_deployment skill: [task]"
```

---

## Release Pipeline Overview

```
Code Merge → Build → Sign → Test → Upload → Review → Release
    │           │       │       │       │        │        │
    │           │       │       │       │        │        └── Phased/Full rollout
    │           │       │       │       │        └── Apple/Google review (1-3 days)
    │           │       │       │       └── TestFlight / Internal track
    │           │       │       └── E2E on real devices
    │           │       └── Certificates + Provisioning / Keystore
    │           └── Release build (optimized, minified)
    └── PR merged to release branch
```

---

## Versioning Strategy

### Semantic Versioning for Mobile

```
MAJOR.MINOR.PATCH (buildNumber)
  │     │     │        │
  │     │     │        └── Auto-incremented per build (1, 2, 3...)
  │     │     └── Bug fixes, patches
  │     └── New features (backward compatible)
  └── Breaking changes, major redesigns
```

### Version Configuration

```json
// React Native: package.json + native configs
{
  "version": "2.1.0"
}
```

```xml
<!-- Android: android/app/build.gradle -->
android {
    defaultConfig {
        versionCode 42        // Build number (always increment)
        versionName "2.1.0"   // Display version
    }
}
```

```xml
<!-- iOS: Info.plist -->
<key>CFBundleShortVersionString</key>
<string>2.1.0</string>
<key>CFBundleVersion</key>
<string>42</string>
```

```yaml
# Flutter: pubspec.yaml
version: 2.1.0+42  # version+buildNumber
```

### Auto-Incrementing Build Numbers

```bash
#!/bin/bash
# scripts/bump-build.sh
CURRENT=$(grep -oP 'versionCode \K\d+' android/app/build.gradle)
NEXT=$((CURRENT + 1))
sed -i "s/versionCode $CURRENT/versionCode $NEXT/" android/app/build.gradle

# iOS (agvtool)
cd ios && agvtool next-version -all
```

---

## iOS Code Signing

### Certificate Types

| Certificate | Purpose | Distribution |
|-------------|---------|-------------|
| Development | Running on test devices | Xcode direct |
| Ad Hoc | Testing on registered devices (100 max) | Manual install |
| App Store | App Store + TestFlight | App Store Connect |
| Enterprise | Internal distribution (no limit) | In-house only |

### Provisioning Profile Flow

```
Apple Developer Account
  └── Certificates
       ├── Development cert (per developer machine)
       └── Distribution cert (shared, for CI)
  └── Identifiers
       └── App ID (com.company.appname)
  └── Profiles
       ├── Development profile (dev cert + device UDIDs)
       ├── Ad Hoc profile (dist cert + device UDIDs)
       └── App Store profile (dist cert, no UDIDs)
```

### Fastlane Match (Recommended)

```ruby
# fastlane/Matchfile
git_url("https://github.com/company/certificates")
storage_mode("git")
type("appstore")
app_identifier("com.company.myapp")
username("ci@company.com")
```

```bash
# Initial setup (run once)
fastlane match init
fastlane match appstore     # Creates App Store cert + profile
fastlane match development  # Creates dev cert + profile

# On CI (read-only)
fastlane match appstore --readonly
```

---

## Android Code Signing

### Keystore Management

```bash
# Generate release keystore (once, store securely)
keytool -genkey -v \
  -keystore my-app-release.keystore \
  -alias my-app \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# NEVER commit the keystore to git
```

```groovy
// android/app/build.gradle
android {
    signingConfigs {
        release {
            storeFile file(System.getenv("KEYSTORE_PATH") ?: "release.keystore")
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias System.getenv("KEY_ALIAS")
            keyPassword System.getenv("KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Play App Signing (Recommended)

Google manages your app signing key. You upload with an upload key.

```
Your Upload Key ──sign──> AAB ──upload──> Google Play
                                              │
                                    Google App Signing Key
                                              │
                                         Signed APKs
                                              │
                                          User Devices
```

---

## Fastlane Automation

### iOS Fastfile

```ruby
# fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    increment_build_number(xcodeproj: "ios/MyApp.xcodeproj")
    match(type: "appstore", readonly: true)
    build_app(
      workspace: "ios/MyApp.xcworkspace",
      scheme: "MyApp",
      export_method: "app-store",
      output_directory: "./build",
    )
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
    )
    slack(message: "iOS beta uploaded to TestFlight")
  end

  desc "Push a new release to App Store"
  lane :release do
    increment_build_number(xcodeproj: "ios/MyApp.xcodeproj")
    match(type: "appstore", readonly: true)
    build_app(
      workspace: "ios/MyApp.xcworkspace",
      scheme: "MyApp",
      export_method: "app-store",
    )
    upload_to_app_store(
      submit_for_review: true,
      automatic_release: false,
      phased_release: true,
      submission_information: {
        add_id_info_uses_idfa: false,
      },
    )
  end

  desc "Capture screenshots for all device sizes"
  lane :screenshots do
    capture_screenshots(scheme: "MyAppUITests")
    frame_screenshots(white: true)
    upload_to_app_store(skip_binary_upload: true)
  end
end
```

### Android Fastfile

```ruby
platform :android do
  desc "Deploy a new beta to Play Store internal track"
  lane :beta do
    gradle(
      task: "bundle",
      build_type: "Release",
      project_dir: "android",
    )
    upload_to_play_store(
      track: "internal",
      aab: "android/app/build/outputs/bundle/release/app-release.aab",
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true,
    )
    slack(message: "Android beta uploaded to Play Store internal track")
  end

  desc "Promote internal to production"
  lane :release do
    upload_to_play_store(
      track: "internal",
      track_promote_to: "production",
      rollout: "0.1",  # 10% staged rollout
    )
  end

  desc "Increase rollout percentage"
  lane :increase_rollout do |options|
    upload_to_play_store(
      track: "production",
      rollout: options[:percentage],
    )
  end
end
```

---

## EAS Build (Expo)

### Configuration

```json
// eas.json
{
  "cli": { "version": ">= 12.0.0" },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "ios": { "simulator": true }
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "resourceClass": "m-medium"
      }
    },
    "production": {
      "autoIncrement": true,
      "ios": {
        "resourceClass": "m-medium"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "ci@company.com",
        "ascAppId": "1234567890",
        "appleTeamId": "TEAM123"
      },
      "android": {
        "serviceAccountKeyPath": "./google-play-key.json",
        "track": "internal"
      }
    }
  }
}
```

```bash
# Build and submit
eas build --platform all --profile production
eas submit --platform all --profile production

# OTA update (no store review needed)
eas update --branch production --message "Fix checkout bug"
```

---

## App Store Review Guidelines (Key Points)

### Common Rejection Reasons

| Reason | Description | Prevention |
|--------|-------------|------------|
| Crashes/bugs | App crashes during review | Test on real devices, handle edge cases |
| Incomplete info | Missing privacy policy, demo account | Pre-fill all metadata |
| Misleading | Screenshots dont match app | Use real screenshots |
| Privacy | Missing usage descriptions | Add all NSUsageDescription keys |
| Payments | Using non-IAP for digital goods | Use StoreKit for digital content |
| Login required | No way to test without account | Provide demo credentials |
| Minimum functionality | App is too simple / web wrapper | Ensure native features |
| Data collection | Not disclosing data practices | Fill App Privacy section |

### iOS Privacy Descriptions (Info.plist)

```xml
<!-- Add ALL that apply -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan QR codes for payment</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Upload photos for your profile picture</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Find stores near your current location</string>
<key>NSFaceIDUsageDescription</key>
<string>Use Face ID to securely log in</string>
<key>NSMicrophoneUsageDescription</key>
<string>Record voice messages in chat</string>
```

### App Store Metadata Checklist

| Field | iOS | Android | Notes |
|-------|-----|---------|-------|
| App name | 30 chars | 30 chars | Must be unique |
| Subtitle | 30 chars | 80 chars (short desc) | Keywords-rich |
| Description | 4000 chars | 4000 chars | First 3 lines matter |
| Keywords | 100 chars | N/A (in description) | No duplicates |
| Screenshots | 6.7" + 5.5" required | Phone + 7"/10" tablet | Min 2, max 10 |
| Privacy policy | Required URL | Required URL | Must be accessible |
| Support URL | Required | Required | Real support page |
| Age rating | Questionnaire | Content rating | Honest answers |
| Category | Primary + secondary | Primary + secondary | Choose carefully |
| App Privacy | Nutrition label | Data safety | Be accurate |

---

## Staged Rollout Strategy

```
Day 1:  1% rollout  → Monitor crash rate, ANR rate
Day 2:  5% rollout  → Check reviews, error reports
Day 3:  10% rollout → Validate key metrics (retention, revenue)
Day 5:  25% rollout → Broader validation
Day 7:  50% rollout → Near-full validation
Day 10: 100% rollout → Full release
```

### Rollout Monitoring Checklist

- [ ] Crash-free rate > 99.5%
- [ ] ANR rate < 0.5% (Android)
- [ ] No increase in support tickets
- [ ] Key metrics (DAU, retention, revenue) within 5% of baseline
- [ ] No critical Play/App Store reviews about new bugs
- [ ] Server-side metrics stable (latency, error rates)

---

## CI/CD Pipeline

### GitHub Actions - Full Release Pipeline

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags: ['v*']

jobs:
  build-ios:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: 3.2 }
      - run: bundle install
      - run: bundle exec fastlane ios beta
        env:
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          MATCH_GIT_URL: ${{ secrets.MATCH_GIT_URL }}
          APP_STORE_CONNECT_API_KEY: ${{ secrets.ASC_API_KEY }}

  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: 17 }
      - uses: ruby/setup-ruby@v1
        with: { ruby-version: 3.2 }
      - run: bundle install
      - run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/release.keystore
      - run: bundle exec fastlane android beta
        env:
          KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
          KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
          KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
          GOOGLE_PLAY_KEY: ${{ secrets.GOOGLE_PLAY_KEY }}
```

---

## Cross-References

- `4-secure/mobile_testing_strategy` - Pre-release testing requirements
- `4-secure/mobile_security_testing` - Security requirements for store compliance
- `3-build/react_native_patterns` - RN-specific build configuration
- `3-build/flutter_development` - Flutter-specific build configuration

---

## EXIT CHECKLIST

- [ ] Version strategy defined (semver + build number)
- [ ] iOS code signing configured (Match or manual)
- [ ] Android keystore created and securely stored
- [ ] Play App Signing enrolled
- [ ] Fastlane or EAS configured for both platforms
- [ ] App Store metadata complete (descriptions, screenshots, privacy)
- [ ] Privacy policy URL live and accessible
- [ ] Demo account credentials prepared for review
- [ ] CI/CD pipeline building and uploading automatically
- [ ] Staged rollout plan documented
- [ ] Monitoring dashboard ready for rollout tracking
- [ ] All NSUsageDescription strings added to Info.plist

---

*Skill Version: 1.0 | Created: March 2026*
