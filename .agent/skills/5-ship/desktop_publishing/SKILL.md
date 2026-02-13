---
name: desktop_publishing
description: Building, signing, and distributing desktop applications with Electron, Tauri, or similar frameworks
---

# Desktop Publishing Skill

**Purpose**: Guides the full lifecycle of packaging, code signing, and distributing desktop applications across Windows, macOS, and Linux platforms.

## :dart: TRIGGER COMMANDS

```text
"build desktop app"
"package Electron app"
"code sign desktop"
"create installer for Windows/macOS/Linux"
"set up auto-update for desktop app"
"Using desktop_publishing skill: build and distribute"
```

## :hammer_and_wrench: FRAMEWORK SELECTION

| Framework | Language | Bundle Size | Native Access | Auto-Update | Best For |
|-----------|----------|-------------|---------------|-------------|----------|
| **Electron Forge** | JS/TS | ~150MB+ | Full (Node.js) | electron-updater | Rapid prototyping, web team familiarity |
| **Electron Builder** | JS/TS | ~150MB+ | Full (Node.js) | electron-updater | Mature ecosystem, flexible config |
| **Tauri** | Rust + JS/TS | ~5-10MB | Full (Rust) | Built-in updater | Small bundles, security-focused |
| **Neutralinojs** | JS/TS | ~2-5MB | Limited | Manual | Ultra-lightweight, simple apps |
| **Wails** | Go + JS/TS | ~10-15MB | Full (Go) | Manual | Go backend preference |

> [!TIP]
> Tauri produces dramatically smaller bindles (5-10MB vs 150MB+) because it uses the OS webview instead of bundling Chromium. Choose Tauri for new projects unless you need Node.js APIs or mature Electron ecosystem plugins.

## :package: PLATFORM-SPECIFIC BUILD TARGETS

### Windows

| Format | Use Case | Signing | Notes |
|--------|----------|---------|-------|
| `.exe` (NSIS) | Standard installer | Authenticode | Most common, customizable UI |
| `.msi` | Enterprise/IT deployment | Authenticode | Group Policy support, silent install |
| `.appx`/`.msix` | Microsoft Store | Store cert | Sandboxed, auto-update via Store |
| Portable `.exe` | No-install distribution | Authenticode | Single file, no registry changes |

### macOS

| Format | Use Case | Signing | Notes |
|--------|----------|---------|-------|
| `.dmg` | Standard distribution | Developer ID + Notarization | Drag-to-install experience |
| `.pkg` | Complex installs | Developer ID + Notarization | Scripted pre/post-install actions |
| `.app` (zip) | Direct download | Developer ID + Notarization | Simplest format |
| Mac App Store | Store distribution | Mac App Store cert | Sandboxed, review required |

### Linux

| Format | Use Case | Notes |
|--------|----------|-------|
| `.AppImage` | Universal, no-install | Runs on most distros, single file |
| `.deb` | Debian/Ubuntu | apt repository support |
| `.rpm` | Fedora/RHEL | dnf/yum repository support |
| `.snap` | Snap Store | Sandboxed, auto-update |
| `.flatpak` | Flathub | Sandboxed, cross-distro |

## :lock: CODE SIGNING

### Windows (Authenticode)

```bash
# Sign with EV certificate (hardware token)
signtool sign /tr http://timestamp.digicert.com /td sha256 /fd sha256 \
  /a /n "Your Company Name" MyApp-Setup.exe

# Verify signature
signtool verify /pa MyApp-Setup.exe
```

| Certificate Type | Cost | SmartScreen Trust | CI Friendly |
|-----------------|------|-------------------|-------------|
| Standard Code Signing | ~$200/yr | Builds over time | Yes (PFX file) |
| EV Code Signing | ~$400/yr | Immediate | Partial (HSM/token) |
| Azure Trusted Signing | ~$10/mo | Immediate | Yes (cloud-based) |

> [!WARNING]
> Without code signing, Windows SmartScreen will show "Unknown publisher" warnings that can scare away 50%+ of users. EV certificates provide immediate reputation. Azure Trusted Signing is the newest option and is CI-friendly.

### macOS (Developer ID + Notarization)

```bash
# Sign the .app bundle
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --options runtime \
  MyApp.app

# Create DMG
hdiutil create -volname "MyApp" -srcfolder MyApp.app \
  -ov -format UDZO MyApp.dmg

# Sign DMG
codesign --sign "Developer ID Application: Your Name (TEAM_ID)" MyApp.dmg

# Notarize with Apple
xcrun notarytool submit MyApp.dmg \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "@keychain:AC_PASSWORD" \
  --wait

# Staple the notarization ticket
xcrun stapler staple MyApp.dmg
```

> [!WARNING]
> macOS Gatekeeper will quarantine unsigned apps downloaded from the internet. Notarization is required for apps distributed outside the Mac App Store since macOS Catalina.

## :arrows_counterclockwise: AUTO-UPDATE SYSTEMS

### Electron (electron-updater)

```typescript
// main.ts - Auto-update setup
import { autoUpdater } from 'electron-updater';
import { app, BrowserWindow } from 'electron';

autoUpdater.autoDownload = false;
autoUpdater.autoInstallOnAppQuit = true;

autoUpdater.on('update-available', (info) => {
  mainWindow.webContents.send('update-available', info.version);
});

autoUpdater.on('update-downloaded', (info) => {
  mainWindow.webContents.send('update-downloaded', info.version);
});

autoUpdater.on('error', (error) => {
  mainWindow.webContents.send('update-error', error.message);
});

// Check for updates after app ready
app.on('ready', () => {
  setTimeout(() => autoUpdater.checkForUpdates(), 3000);
});

// Trigger install from renderer
ipcMain.handle('install-update', () => {
  autoUpdater.quitAndInstall(false, true);
});
```

### Tauri Updater

```json
// tauri.conf.json
{
  "tauri": {
    "updater": {
      "active": true,
      "dialog": true,
      "endpoints": [
        "https://releases.myapp.com/{{target}}/{{arch}}/{{current_version}}"
      ],
      "pubkey": "YOUR_PUBLIC_KEY_HERE"
    }
  }
}
```

| Update Server | Cost | Delta Updates | CDN | Best For |
|--------------|------|---------------|-----|----------|
| GitHub Releases | Free (public) | No | GitHub CDN | Open source projects |
| S3 + CloudFront | ~$5-20/mo | Manual | Yes | Custom control |
| Hazel (Vercel) | Free tier | No | Vercel CDN | Small Electron apps |
| update.electronjs.org | Free | No | Yes | Open source Electron |
| Tauri built-in | N/A | Yes (native) | Your choice | Tauri apps |

## :gear: BUILD CONFIGURATION

### electron-builder.yml

```yaml
appId: com.yourcompany.yourapp
productName: YourApp
copyright: Copyright (c) 2026 Your Company

directories:
  output: dist
  buildResources: build

files:
  - "dist/**/*"
  - "node_modules/**/*"
  - "package.json"

win:
  target:
    - target: nsis
      arch: [x64, arm64]
  icon: build/icon.ico
  signingHashAlgorithms: [sha256]
  certificateSubjectName: "Your Company Name"

nsis:
  oneClick: false
  allowToChangeInstallationDirectory: true
  installerIcon: build/icon.ico
  uninstallerIcon: build/icon.ico
  installerHeaderIcon: build/icon.ico
  createDesktopShortcut: true
  createStartMenuShortcut: true
  shortcutName: YourApp

mac:
  target:
    - target: dmg
      arch: [x64, arm64]
  icon: build/icon.icns
  hardenedRuntime: true
  gatekeeperAssess: false
  entitlements: build/entitlements.mac.plist
  entitlementsInherit: build/entitlements.mac.plist

dmg:
  background: build/dmg-background.png
  iconSize: 100
  contents:
    - x: 380
      y: 180
      type: link
      path: /Applications
    - x: 130
      y: 180
      type: file

linux:
  target:
    - target: AppImage
      arch: [x64, arm64]
    - target: deb
      arch: [x64]
    - target: snap
      arch: [x64]
  icon: build/icons
  category: Utility

publish:
  provider: github
  owner: your-org
  repo: your-app
```

### Tauri Build Config (tauri.conf.json)

```json
{
  "build": {
    "beforeBuildCommand": "npm run build",
    "beforeDevCommand": "npm run dev",
    "devPath": "http://localhost:5173",
    "distDir": "../dist"
  },
  "package": {
    "productName": "YourApp",
    "version": "1.0.0"
  },
  "tauri": {
    "bundle": {
      "active": true,
      "identifier": "com.yourcompany.yourapp",
      "icon": [
        "icons/32x32.png",
        "icons/128x128.png",
        "icons/128x128@2x.png",
        "icons/icon.icns",
        "icons/icon.ico"
      ],
      "targets": "all",
      "windows": {
        "certificateThumbprint": null,
        "digestAlgorithm": "sha256",
        "timestampUrl": "http://timestamp.digicert.com"
      },
      "macOS": {
        "signingIdentity": null,
        "entitlements": null
      }
    },
    "allowlist": {
      "all": false,
      "shell": { "open": true },
      "dialog": { "all": true },
      "fs": { "all": true, "scope": ["$APP/*"] }
    }
  }
}
```

## :rocket: CI/CD BUILD PIPELINE

```yaml
# .github/workflows/build-desktop.yml
name: Build Desktop App

on:
  push:
    tags: ['v*']

permissions:
  contents: write

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        include:
          - os: windows-latest
            platform: win
          - os: macos-latest
            platform: mac
          - os: ubuntu-latest
            platform: linux

    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - name: Install dependencies
        run: npm ci

      # macOS: Import signing certificate
      - name: Import macOS certificates
        if: matrix.platform == 'mac'
        uses: apple-actions/import-codesign-certs@v2
        with:
          p12-file-base64: ${{ secrets.MAC_CERTS }}
          p12-password: ${{ secrets.MAC_CERTS_PASSWORD }}

      # Windows: Import signing certificate
      - name: Import Windows certificate
        if: matrix.platform == 'win'
        run: |
          echo "${{ secrets.WIN_CERT }}" | base64 -d > cert.pfx

      - name: Build desktop app
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CSC_LINK: ${{ matrix.platform == 'win' && 'cert.pfx' || '' }}
          CSC_KEY_PASSWORD: ${{ secrets.WIN_CERT_PASSWORD }}
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_PASSWORD }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
        run: npm run build:desktop

      - name: Upload artifacts
        uses: actions/upload-artifact@v4
        with:
          name: desktop-${{ matrix.platform }}
          path: |
            dist/*.exe
            dist/*.msi
            dist/*.dmg
            dist/*.AppImage
            dist/*.deb
            dist/*.snap

      - name: Publish to GitHub Releases
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v2
        with:
          files: |
            dist/*.exe
            dist/*.dmg
            dist/*.AppImage
            dist/*.deb
```

## :art: APPLICATION ICONS

| Platform | Sizes Required | Format |
|----------|---------------|--------|
| Windows | 16, 32, 48, 64, 128, 256 | `.ico` (multi-size) |
| macOS | 16, 32, 64, 128, 256, 512, 1024 | `.icns` (multi-size) |
| Linux | 16, 32, 48, 64, 128, 256, 512 | `.png` (individual files) |

```bash
# Generate all icon sizes from a 1024x1024 source PNG
# Using electron-icon-builder
npx electron-icon-builder --input=icon-1024.png --output=build/icons

# Or using Tauri's icon generator
npx tauri icon icon-1024.png
```

## :link: DEEP LINKING / CUSTOM PROTOCOL

```typescript
// Electron - Register custom protocol (main.ts)
if (process.defaultApp) {
  if (process.argv.length >= 2) {
    app.setAsDefaultProtocolClient('myapp', process.execPath, [
      path.resolve(process.argv[1]),
    ]);
  }
} else {
  app.setAsDefaultProtocolClient('myapp');
}

// Handle the protocol URL
app.on('open-url', (event, url) => {
  event.preventDefault();
  // url = "myapp://action/param"
  handleDeepLink(url);
});

// Windows: handle in second-instance event
app.on('second-instance', (event, commandLine) => {
  const url = commandLine.find((arg) => arg.startsWith('myapp://'));
  if (url) handleDeepLink(url);
});
```

## :chart_with_upwards_trend: CRASH REPORTING

```typescript
// Sentry for Electron
import * as Sentry from '@sentry/electron/main';

Sentry.init({
  dsn: 'https://examplePublicKey@o0.ingest.sentry.io/0',
  release: app.getVersion(),
  environment: process.env.NODE_ENV,
});

// In renderer (preload)
import * as Sentry from '@sentry/electron/renderer';
Sentry.init({});
```

## :bar_chart: INSTALLER COMPARISON

| Feature | NSIS | Squirrel | MSI | MSIX |
|---------|------|----------|-----|------|
| Custom UI | Full | None | Limited | None |
| Silent Install | `/S` flag | Default | `/quiet` | Default |
| Auto-Update | Via electron-updater | Built-in | Manual | Store |
| Per-User Install | Yes | Default | Yes | Default |
| Requires Admin | Optional | No | Usually | No |
| Uninstaller | Custom | Auto | Add/Remove | Auto |
| Enterprise Ready | Moderate | No | Yes | Yes |
| File Size Overhead | Small | Small | Small | Small |

## :test_tube: TESTING DESKTOP BUILDS

- [ ] Run Playwright for Electron tests against packaged app
- [ ] Test fresh install on clean VM (no dev tools installed)
- [ ] Test upgrade from previous version (data migration)
- [ ] Test auto-update flow end-to-end
- [ ] Test uninstall cleans up properly
- [ ] Verify code signature on each platform
- [ ] Test deep link protocol handling
- [ ] Test on minimum supported OS versions
- [ ] Test with restrictive firewall / proxy settings
- [ ] Verify crash reports arrive in Sentry

```typescript
// Playwright for Electron testing
import { _electron as electron } from 'playwright';

const app = await electron.launch({ args: ['.'] });
const window = await app.firstWindow();

await expect(window).toHaveTitle(/YourApp/);
await window.click('#start-button');
await expect(window.locator('#status')).toHaveText('Running');

await app.close();
```

## :white_check_mark: EXIT CHECKLIST

- [ ] Builds produce artifacts for all 3 platforms (Windows, macOS, Linux)
- [ ] Windows builds are Authenticode signed
- [ ] macOS builds are Developer ID signed and notarized
- [ ] Installers tested on clean machines (no dev environment)
- [ ] Auto-update mechanism verified end-to-end
- [ ] Application icons render correctly at all sizes
- [ ] Deep linking / custom protocol works
- [ ] Crash reporting active and receiving test events
- [ ] CI/CD pipeline builds and publishes on tag push
- [ ] Delta updates configured (if applicable)
- [ ] Environment-specific URLs set correctly per build target

*Skill Version: 1.0 | Created: February 2026*
