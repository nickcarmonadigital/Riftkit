---
name: Mobile Security Testing
description: Mobile security testing with OWASP MASVS, certificate pinning, secure storage, jailbreak detection, and runtime protection
---

# Mobile Security Testing Skill

**Purpose**: Guide developers through mobile application security testing using OWASP MASVS/MASTG standards, covering certificate pinning, secure data storage, root/jailbreak detection, reverse engineering prevention, and automated security scanning.

---

## TRIGGER COMMANDS

```text
"Secure my mobile application"
"Implement certificate pinning"
"Set up secure storage for mobile"
"Test mobile app security with OWASP"
"Using mobile_security_testing skill: [task]"
```

---

## OWASP MASVS Overview

The Mobile Application Security Verification Standard (MASVS) defines two verification levels.

| Level | Target | Description |
|-------|--------|-------------|
| MASVS-L1 | All apps | Standard security for all mobile apps |
| MASVS-L2 | High-risk apps | Defense-in-depth for apps handling sensitive data |
| MASVS-R | Resilience | Anti-tampering, reverse engineering prevention |

### MASVS Categories

| Category | ID | Focus Area |
|----------|----|-----------|
| Storage | MASVS-STORAGE | Secure data storage |
| Crypto | MASVS-CRYPTO | Cryptographic best practices |
| Auth | MASVS-AUTH | Authentication and authorization |
| Network | MASVS-NETWORK | Secure network communication |
| Platform | MASVS-PLATFORM | Platform interaction security |
| Code | MASVS-CODE | Code quality and security |
| Resilience | MASVS-RESILIENCE | Anti-tampering, anti-reversing |
| Privacy | MASVS-PRIVACY | User privacy protection |

---

## Secure Storage

### Platform Comparison

| Storage Type | iOS | Android | Security Level |
|-------------|-----|---------|----------------|
| Keychain / Keystore | Keychain Services | Android Keystore | Highest (hardware-backed) |
| Encrypted prefs | N/A | EncryptedSharedPreferences | High |
| Encrypted file | Data Protection API | EncryptedFile | High |
| SQLite (encrypted) | SQLCipher | SQLCipher | High |
| UserDefaults / SharedPrefs | UserDefaults (unencrypted) | SharedPreferences (unencrypted) | None |

### React Native Secure Storage

```typescript
// Use react-native-keychain for credentials
import * as Keychain from 'react-native-keychain';

// Store credentials
async function storeCredentials(username: string, token: string) {
  await Keychain.setGenericPassword(username, token, {
    accessible: Keychain.ACCESSIBLE.WHEN_UNLOCKED_THIS_DEVICE_ONLY,
    securityLevel: Keychain.SECURITY_LEVEL.SECURE_HARDWARE,
  });
}

// Retrieve credentials
async function getCredentials() {
  const credentials = await Keychain.getGenericPassword();
  if (credentials) {
    return { username: credentials.username, token: credentials.password };
  }
  return null;
}

// Clear on logout
async function clearCredentials() {
  await Keychain.resetGenericPassword();
}
```

### iOS Keychain (Native Swift)

```swift
import Security

class KeychainManager {
    static func save(key: String, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]

        SecItemDelete(query as CFDictionary)  // Remove existing
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func load(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return status == errSecSuccess ? result as? Data : nil
    }
}
```

### Android Keystore (Native Kotlin)

```kotlin
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.spec.GCMParameterSpec

class SecureStorage(private val context: Context) {
    private val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }

    fun encrypt(alias: String, plaintext: ByteArray): Pair<ByteArray, ByteArray> {
        val keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore"
        )
        keyGenerator.init(
            KeyGenParameterSpec.Builder(alias,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT)
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setUserAuthenticationRequired(false)
                .build()
        )
        val key = keyGenerator.generateKey()

        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, key)

        val iv = cipher.iv
        val encrypted = cipher.doFinal(plaintext)
        return Pair(iv, encrypted)
    }

    fun decrypt(alias: String, iv: ByteArray, encrypted: ByteArray): ByteArray {
        val key = keyStore.getKey(alias, null)
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, key, GCMParameterSpec(128, iv))
        return cipher.doFinal(encrypted)
    }
}
```

### What NOT to Store in Plain Text

| Data Type | Correct Storage | Wrong Storage |
|-----------|----------------|---------------|
| API tokens | Keychain / Keystore | SharedPreferences / UserDefaults |
| Passwords | Never store; use tokens | Anywhere |
| PII (SSN, DOB) | Encrypted database | Plain SQLite |
| Encryption keys | Hardware keystore | Hardcoded in code |
| Session tokens | Keychain / Keystore | AsyncStorage / localStorage |
| OAuth secrets | Never on device | Bundled in app |

---

## Certificate Pinning

### Why Pin Certificates

Without pinning, any CA-issued certificate is trusted. Pinning ensures your app only trusts specific certificates for your API servers, preventing MITM attacks even with compromised CAs.

### React Native (TrustKit)

```typescript
// ios/Podfile
pod 'TrustKit'
```

```swift
// ios/AppDelegate.swift
import TrustKit

TrustKit.initSharedInstance(withConfiguration: [
    kTSKSwizzleNetworkDelegates: false,
    kTSKPinnedDomains: [
        "api.myapp.com": [
            kTSKEnforcePinning: true,
            kTSKPublicKeyHashes: [
                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",  // Primary
                "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=",  // Backup
            ],
            kTSKIncludeSubdomains: true,
        ],
    ],
])
```

### Android Network Security Config

```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.myapp.com</domain>
        <pin-set expiration="2027-01-01">
            <pin digest="SHA-256">AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=</pin>
            <pin digest="SHA-256">BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=</pin>
        </pin-set>
    </domain-config>

    <!-- Block all cleartext traffic -->
    <base-config cleartextTrafficPermitted="false" />
</network-security-config>
```

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

### Pin Generation

```bash
# Get pin hash from a certificate
openssl s_client -servername api.myapp.com -connect api.myapp.com:443 2>/dev/null \
  | openssl x509 -pubkey -noout \
  | openssl pkey -pubin -outform der \
  | openssl dgst -sha256 -binary \
  | openssl enc -base64

# Always pin at least 2: current + backup
# Rotate pins before certificate renewal
```

---

## Root/Jailbreak Detection

### Detection Methods

| Method | iOS | Android | Bypass Difficulty |
|--------|-----|---------|-------------------|
| File system checks | Cydia, apt paths | su binary, Magisk | Easy |
| Directory permissions | Write to /private | Write to /system | Easy |
| Sandbox integrity | Fork check | Mounting checks | Medium |
| API checks | Can open Cydia URL | SafetyNet / Play Integrity | Hard |
| Binary integrity | Code signature check | APK signature | Medium |
| Frida detection | Port check, named pipes | Port check, maps scanning | Medium |

### React Native (jail-monkey)

```typescript
import JailMonkey from 'jail-monkey';

function checkDeviceSecurity(): SecurityReport {
  return {
    isJailBroken: JailMonkey.isJailBroken(),
    canMockLocation: JailMonkey.canMockLocation(),
    isOnExternalStorage: JailMonkey.isOnExternalStorage(),
    isDebugged: JailMonkey.isDebuggedMode(),
    hookDetected: JailMonkey.hookDetected(),
  };
}

// React Native context
function useSecurityGate() {
  const [securityOk, setSecurityOk] = useState(true);

  useEffect(() => {
    const report = checkDeviceSecurity();
    if (report.isJailBroken || report.hookDetected) {
      setSecurityOk(false);
      // Log security event
      analytics.track('security_violation', report);
    }
  }, []);

  return securityOk;
}
```

### Google Play Integrity API (Android)

```kotlin
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest

class PlayIntegrityChecker(private val context: Context) {
    suspend fun checkIntegrity(): IntegrityResult {
        val integrityManager = IntegrityManagerFactory.create(context)

        val nonce = generateNonce()  // Server-generated nonce
        val request = IntegrityTokenRequest.builder()
            .setNonce(nonce)
            .build()

        val response = integrityManager.requestIntegrityToken(request).await()
        val token = response.token()

        // Send token to YOUR server for verification
        // Never verify on-device (can be bypassed)
        return api.verifyIntegrity(token)
    }
}
```

---

## Network Security

### Checklist

| Check | Requirement | Test Method |
|-------|------------|-------------|
| TLS version | TLS 1.2+ only | SSL Labs scan |
| Certificate pinning | Pinned to leaf or intermediate | MITM proxy test |
| Cleartext traffic | Blocked | Network security config |
| Certificate validation | Not disabled in code | Code review |
| Sensitive data in URLs | No tokens/passwords in query params | Traffic inspection |
| Cache control | Sensitive responses not cached | Proxy inspection |
| Request/response logging | No sensitive data in logs | Log review |

### Prevent Sensitive Data in Logs

```typescript
// Axios interceptor to prevent logging sensitive data
api.interceptors.request.use((config) => {
  // Never log authorization headers
  if (__DEV__) {
    const sanitized = { ...config };
    if (sanitized.headers?.Authorization) {
      sanitized.headers = { ...sanitized.headers, Authorization: '[REDACTED]' };
    }
    if (sanitized.data?.password) {
      sanitized.data = { ...sanitized.data, password: '[REDACTED]' };
    }
    console.log('Request:', sanitized.method, sanitized.url);
  }
  return config;
});
```

---

## Code Protection

### Anti-Tampering

```
BUILD-TIME PROTECTIONS
  ├── ProGuard/R8 (Android) - Obfuscation
  ├── Bitcode (iOS) - Server-side optimization
  ├── Code stripping - Remove debug symbols
  └── Hermes bytecode (React Native)

RUNTIME PROTECTIONS
  ├── Integrity checks - Verify app signature
  ├── Debugger detection - ptrace, isDebuggerAttached
  ├── Frida detection - Scan for instrumentation
  └── Hooking detection - Check for Substrate/Xposed
```

### ProGuard Configuration (Android)

```proguard
# proguard-rules.pro
# Keep crash reporting
-keep class com.crashlytics.** { *; }

# Obfuscate everything else
-obfuscationdictionary proguard-dict.txt
-classobfuscationdictionary proguard-dict.txt
-packageobfuscationdictionary proguard-dict.txt

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Prevent reverse engineering of crypto
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }
```

---

## Security Testing Tools

### Static Analysis (SAST)

| Tool | Platform | Type | Integration |
|------|----------|------|-------------|
| MobSF | iOS + Android | SAST + DAST | CLI, CI |
| Semgrep | Source code | SAST | CLI, CI, GitHub |
| Snyk | Dependencies | SCA | CLI, CI, GitHub |
| Checkmarx | Source code | SAST | Enterprise CI |

### Dynamic Analysis (DAST)

| Tool | Platform | Purpose |
|------|----------|---------|
| Burp Suite | Proxy | HTTP traffic inspection |
| mitmproxy | Proxy | Automated traffic analysis |
| Frida | Runtime | Runtime instrumentation |
| Objection | Runtime | Security testing toolkit |
| Drozer | Android | Component testing |

### MobSF Automated Scan

```bash
# Run MobSF locally
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest

# Upload APK/IPA via web UI at http://localhost:8000
# Or use API:
curl -F "file=@app-release.apk" http://localhost:8000/api/v1/upload \
  -H "Authorization: <api-key>"

# Get scan results
curl http://localhost:8000/api/v1/scan \
  -H "Authorization: <api-key>" \
  -d "scan_type=apk&file_name=app-release.apk&hash=<hash>"
```

### CI Security Pipeline

```yaml
# .github/workflows/mobile-security.yml
name: Mobile Security Scan

on:
  push:
    branches: [main]
  pull_request:

jobs:
  dependency-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Snyk dependency scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high

  sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Semgrep SAST
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/react
            p/typescript
            p/owasp-top-ten
            p/secrets

  android-security:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Build release APK
        run: cd android && ./gradlew assembleRelease
      - name: MobSF scan
        run: |
          docker run -d -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
          sleep 10
          # Upload and scan APK
          python scripts/mobsf-scan.py android/app/build/outputs/apk/release/app-release.apk
```

---

## Security Testing Checklist (MASVS-Based)

### MASVS-STORAGE

- [ ] No sensitive data in application logs
- [ ] No sensitive data in backups (android:allowBackup="false")
- [ ] No sensitive data in clipboard
- [ ] No sensitive data in screenshots (FLAG_SECURE on Android)
- [ ] Credentials stored in Keychain/Keystore, not preferences
- [ ] Keyboard cache disabled for sensitive inputs

### MASVS-NETWORK

- [ ] TLS 1.2+ enforced, no fallback
- [ ] Certificate pinning implemented with backup pins
- [ ] No cleartext HTTP traffic allowed
- [ ] Certificate validation not disabled (even in debug)
- [ ] No sensitive data in URL parameters

### MASVS-AUTH

- [ ] Biometric authentication uses platform APIs correctly
- [ ] Session tokens expire and can be revoked
- [ ] Step-up authentication for sensitive operations
- [ ] No hardcoded credentials or API keys in code

### MASVS-PLATFORM

- [ ] Deep link handlers validate input
- [ ] WebView JavaScript interface is restricted
- [ ] No exported components without proper permissions (Android)
- [ ] URL schemes validate caller (iOS)

### MASVS-CODE

- [ ] ProGuard/R8 obfuscation enabled (Android)
- [ ] Debug symbols stripped in release
- [ ] No debug logging in release builds
- [ ] Third-party libraries audited and up to date

### MASVS-RESILIENCE (L2 only)

- [ ] Root/jailbreak detection implemented
- [ ] Debugger detection implemented
- [ ] Tampering detection (signature verification)
- [ ] Frida/hooking detection
- [ ] Emulator detection

---

## Cross-References

- `4-secure/mobile_testing_strategy` - General mobile testing strategy
- `3-build/react_native_patterns` - RN security patterns
- `3-build/flutter_development` - Flutter security patterns
- `5-ship/app_store_deployment` - Security requirements for store approval

---

## EXIT CHECKLIST

- [ ] MASVS level determined (L1 or L2) based on app risk
- [ ] Secure storage implemented using Keychain/Keystore
- [ ] Certificate pinning configured with backup pins
- [ ] Network security config blocks cleartext traffic
- [ ] Root/jailbreak detection implemented (if L2)
- [ ] ProGuard/R8 obfuscation enabled for Android release
- [ ] No hardcoded secrets in source code (verified by Semgrep)
- [ ] Dependency scan passes with no high/critical vulnerabilities
- [ ] MobSF scan passes with acceptable score
- [ ] Security testing automated in CI pipeline
- [ ] Debug logging disabled in release builds
- [ ] Sensitive screens prevent screenshots (FLAG_SECURE)

---

*Skill Version: 1.0 | Created: March 2026*
