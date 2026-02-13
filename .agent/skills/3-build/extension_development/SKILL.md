---
name: Extension Development
description: Building browser extensions and IDE plugins for Chrome, Firefox, Safari, and VS Code
---

# Extension Development Skill

**Purpose**: Structured workflow for building, testing, and publishing browser extensions (Chrome, Firefox, Safari) and IDE plugins (VS Code, JetBrains) with proper architecture, security, and store submission.

---

## 🎯 TRIGGER COMMANDS

```text
"Build a browser extension for [use case]"
"Create a VS Code extension for [feature]"
"Chrome plugin for [functionality]"
"Firefox add-on development for [task]"
"Using extension_development skill: [task]"
```

---

## 🔄 Platform Comparison

| Platform | Manifest/Config | Language | Market Size | Store Fee | Review Time |
|----------|----------------|----------|-------------|-----------|-------------|
| **Chrome Extensions** | Manifest V3 | JS/TS | ~3B users | $5 one-time | 1-3 days |
| **Firefox Add-ons** | WebExtensions (MV3 compatible) | JS/TS | ~180M users | Free | 1-5 days |
| **Safari Extensions** | Xcode + Web Extension API | JS/TS + Swift wrapper | ~1B users | $99/yr (Apple Dev) | 1-7 days |
| **VS Code Extensions** | package.json | TypeScript | ~35M users | Free | < 1 day |
| **JetBrains Plugins** | plugin.xml | Kotlin/Java | ~12M users | Free | 1-3 days |

> [!TIP]
> Chrome and Firefox share the WebExtensions API. Build for Chrome Manifest V3 first, then port to Firefox with minimal changes. This covers 90%+ of browser extension users.

---

## 🌐 Chrome Extension Architecture (Manifest V3)

### Project Structure

```
my-extension/
├── manifest.json          # Extension configuration
├── src/
│   ├── background.ts      # Service worker (event-driven)
│   ├── content.ts         # Injected into web pages
│   ├── popup/
│   │   ├── popup.html     # Toolbar popup UI
│   │   ├── popup.ts       # Popup logic
│   │   └── popup.css      # Popup styles
│   ├── options/
│   │   ├── options.html   # Settings page
│   │   └── options.ts     # Settings logic
│   └── utils/
│       ├── storage.ts     # Storage helpers
│       └── messaging.ts   # Message passing helpers
├── icons/
│   ├── icon-16.png
│   ├── icon-48.png
│   └── icon-128.png
├── _locales/              # i18n (optional)
│   └── en/messages.json
├── tsconfig.json
├── webpack.config.js      # Or vite.config.ts, rollup, etc.
└── package.json
```

### Manifest V3 Example

```json
{
  "manifest_version": 3,
  "name": "My Extension",
  "version": "1.0.0",
  "description": "A concise description of what this extension does",
  "permissions": [
    "storage",
    "activeTab",
    "contextMenus"
  ],
  "optional_permissions": [
    "tabs",
    "bookmarks"
  ],
  "host_permissions": [
    "https://api.example.com/*"
  ],
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  "content_scripts": [
    {
      "matches": ["https://*.example.com/*"],
      "js": ["content.js"],
      "css": ["content.css"],
      "run_at": "document_idle"
    }
  ],
  "action": {
    "default_popup": "popup/popup.html",
    "default_icon": {
      "16": "icons/icon-16.png",
      "48": "icons/icon-48.png",
      "128": "icons/icon-128.png"
    }
  },
  "options_ui": {
    "page": "options/options.html",
    "open_in_tab": true
  },
  "icons": {
    "16": "icons/icon-16.png",
    "48": "icons/icon-48.png",
    "128": "icons/icon-128.png"
  },
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
}
```

---

## 🔑 Key Chrome APIs

| API | Permission | Purpose | Example |
|-----|-----------|---------|---------|
| `chrome.storage.sync` | `storage` | Sync settings across devices (100KB limit) | User preferences |
| `chrome.storage.local` | `storage` | Local-only storage (5MB limit) | Cached data |
| `chrome.tabs` | `tabs` | Query and manipulate browser tabs | Get active tab URL |
| `chrome.runtime` | None | Message passing, lifecycle events | Background-popup comms |
| `chrome.scripting` | `scripting` | Inject scripts into pages | Dynamic content scripts |
| `chrome.action` | None | Toolbar icon, badge, popup | Badge notification count |
| `chrome.contextMenus` | `contextMenus` | Right-click menu items | "Save to my app" |
| `chrome.alarms` | `alarms` | Periodic background tasks | Check for updates |
| `chrome.notifications` | `notifications` | Desktop notifications | Alert user |
| `chrome.sidePanel` | `sidePanel` | Side panel UI (MV3) | Persistent sidebar |

---

## 📨 Message Passing Architecture

```
┌──────────────┐   chrome.runtime    ┌────────────────┐
│ Content       │ ◄──────────────── ▶ │ Background      │
│ Script        │   sendMessage /     │ Service Worker  │
│ (web page)    │   onMessage         │ (event-driven)  │
└──────────────┘                      └──────┬─────────┘
                                             │
                                      chrome.runtime
                                      sendMessage /
                                      onMessage
                                             │
                                      ┌──────▼─────────┐
                                      │ Popup / Options │
                                      │ (extension UI)  │
                                      └────────────────┘
```

### Content Script with Message Passing

```typescript
// content.ts — Injected into web pages
interface PageData {
  title: string;
  url: string;
  selectedText: string;
}

// Listen for messages from background/popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'GET_PAGE_DATA') {
    const data: PageData = {
      title: document.title,
      url: window.location.href,
      selectedText: window.getSelection()?.toString() || '',
    };
    sendResponse({ success: true, data });
  }

  if (message.type === 'HIGHLIGHT_TEXT') {
    const elements = document.querySelectorAll(message.selector);
    elements.forEach((el) => {
      (el as HTMLElement).style.backgroundColor = '#ffeb3b';
    });
    sendResponse({ success: true, count: elements.length });
  }

  // Return true to indicate async response
  return true;
});

// Send data to background when something happens on the page
document.addEventListener('click', (event) => {
  const target = event.target as HTMLElement;
  if (target.matches('a[href]')) {
    chrome.runtime.sendMessage({
      type: 'LINK_CLICKED',
      url: (target as HTMLAnchorElement).href,
    });
  }
});
```

### Background Service Worker

```typescript
// background.ts — Event-driven service worker (MV3)

// Install event: runs once on extension install/update
chrome.runtime.onInstalled.addListener((details) => {
  if (details.reason === 'install') {
    // Set default settings
    chrome.storage.sync.set({
      enabled: true,
      theme: 'light',
      notifications: true,
    });

    // Create context menu items
    chrome.contextMenus.create({
      id: 'save-selection',
      title: 'Save "%s" to My Extension',
      contexts: ['selection'],
    });
  }
});

// Handle messages from content scripts and popup
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'LINK_CLICKED') {
    console.log(`Link clicked in tab ${sender.tab?.id}: ${message.url}`);
  }

  if (message.type === 'FETCH_DATA') {
    // Background can make cross-origin requests (with host_permissions)
    fetch(message.url)
      .then((res) => res.json())
      .then((data) => sendResponse({ success: true, data }))
      .catch((err) => sendResponse({ success: false, error: err.message }));
    return true; // async response
  }
});

// Context menu click handler
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === 'save-selection' && info.selectionText) {
    chrome.storage.local.get(['savedItems'], (result) => {
      const items = result.savedItems || [];
      items.push({
        text: info.selectionText,
        url: tab?.url,
        timestamp: Date.now(),
      });
      chrome.storage.local.set({ savedItems: items });
    });
  }
});

// Periodic task using alarms API (replaces setInterval in MV3)
chrome.alarms.create('sync-data', { periodInMinutes: 30 });
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === 'sync-data') {
    // Perform periodic sync
    console.log('Running periodic data sync...');
  }
});
```

---

## 🔀 Manifest V3 Migration Guide

| Manifest V2 | Manifest V3 | Notes |
|-------------|-------------|-------|
| `background.scripts` / `background.page` | `background.service_worker` | No persistent background; event-driven only |
| `chrome.webRequest.onBeforeRequest` (blocking) | `chrome.declarativeNetRequest` | Rules-based, declared in manifest |
| Callbacks everywhere | Promises (+ async/await) | All Chrome APIs return promises in MV3 |
| `chrome.browserAction` | `chrome.action` | Unified API for toolbar button |
| Unlimited background runtime | Service worker lifecycle | Suspended after ~30s idle; use alarms for periodic work |
| `eval()` allowed (with CSP) | `eval()` prohibited | Use `chrome.scripting.executeScript` instead |

> [!WARNING]
> Manifest V2 extensions are no longer accepted on the Chrome Web Store as of 2024. All new extensions must use Manifest V3. Existing V2 extensions are being phased out.

---

## 💻 VS Code Extension Development

### Project Setup

```bash
# Install Yeoman and VS Code Extension Generator
npm install -g yo generator-code

# Generate extension project
yo code
# Choose: New Extension (TypeScript)
# Fill in: name, identifier, description

# Project structure created:
# my-extension/
# ├── src/extension.ts    # Main entry point
# ├── package.json        # Extension manifest
# ├── tsconfig.json
# └── .vscode/
#     ├── launch.json     # F5 to debug
#     └── tasks.json      # Build tasks
```

### Extension Entry Point

```typescript
// src/extension.ts
import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
  console.log('Extension "my-extension" is now active');

  // Register a command
  const disposable = vscode.commands.registerCommand(
    'my-extension.helloWorld',
    () => {
      vscode.window.showInformationMessage('Hello from My Extension!');
    }
  );
  context.subscriptions.push(disposable);

  // Register a text editor command
  const formatCommand = vscode.commands.registerTextEditorCommand(
    'my-extension.formatSelection',
    (editor, edit) => {
      const selection = editor.selection;
      const text = editor.document.getText(selection);
      edit.replace(selection, text.toUpperCase());
    }
  );
  context.subscriptions.push(formatCommand);

  // Register a completion provider
  const completionProvider = vscode.languages.registerCompletionItemProvider(
    { scheme: 'file', language: 'typescript' },
    {
      provideCompletionItems(document, position) {
        const items: vscode.CompletionItem[] = [];
        const snippet = new vscode.CompletionItem('mySnippet');
        snippet.insertText = new vscode.SnippetString(
          'console.log("${1:message}", ${2:value});'
        );
        snippet.documentation = new vscode.MarkdownString('Insert a log statement');
        items.push(snippet);
        return items;
      },
    },
    '.' // Trigger character
  );
  context.subscriptions.push(completionProvider);

  // Status bar item
  const statusBar = vscode.window.createStatusBarItem(
    vscode.StatusBarAlignment.Right,
    100
  );
  statusBar.text = '$(zap) My Extension';
  statusBar.command = 'my-extension.helloWorld';
  statusBar.show();
  context.subscriptions.push(statusBar);
}

export function deactivate() {
  // Cleanup when extension is deactivated
}
```

### VS Code package.json (Extension Manifest)

```json
{
  "name": "my-extension",
  "displayName": "My Extension",
  "description": "A helpful VS Code extension",
  "version": "1.0.0",
  "engines": { "vscode": "^1.85.0" },
  "categories": ["Other"],
  "activationEvents": [
    "onLanguage:typescript",
    "onCommand:my-extension.helloWorld"
  ],
  "main": "./out/extension.js",
  "contributes": {
    "commands": [
      {
        "command": "my-extension.helloWorld",
        "title": "Hello World",
        "category": "My Extension"
      },
      {
        "command": "my-extension.formatSelection",
        "title": "Format Selection",
        "category": "My Extension"
      }
    ],
    "keybindings": [
      {
        "command": "my-extension.formatSelection",
        "key": "ctrl+shift+u",
        "mac": "cmd+shift+u",
        "when": "editorTextFocus && editorHasSelection"
      }
    ],
    "menus": {
      "editor/context": [
        {
          "command": "my-extension.formatSelection",
          "when": "editorHasSelection",
          "group": "1_modification"
        }
      ]
    },
    "configuration": {
      "title": "My Extension",
      "properties": {
        "myExtension.enableFeature": {
          "type": "boolean",
          "default": true,
          "description": "Enable the main feature"
        },
        "myExtension.maxItems": {
          "type": "number",
          "default": 10,
          "description": "Maximum number of items to display"
        }
      }
    }
  }
}
```

### VS Code Webview Panel

```typescript
// src/webviewPanel.ts
import * as vscode from 'vscode';

export class MyWebviewPanel {
  public static currentPanel: MyWebviewPanel | undefined;
  private readonly panel: vscode.WebviewPanel;
  private disposables: vscode.Disposable[] = [];

  public static createOrShow(extensionUri: vscode.Uri) {
    const column = vscode.window.activeTextEditor
      ? vscode.window.activeTextEditor.viewColumn
      : undefined;

    if (MyWebviewPanel.currentPanel) {
      MyWebviewPanel.currentPanel.panel.reveal(column);
      return;
    }

    const panel = vscode.window.createWebviewPanel(
      'myWebview',
      'My Webview',
      column || vscode.ViewColumn.One,
      {
        enableScripts: true,
        retainContextWhenHidden: true,
        localResourceRoots: [vscode.Uri.joinPath(extensionUri, 'media')],
      }
    );

    MyWebviewPanel.currentPanel = new MyWebviewPanel(panel, extensionUri);
  }

  private constructor(panel: vscode.WebviewPanel, extensionUri: vscode.Uri) {
    this.panel = panel;
    this.panel.webview.html = this.getHtmlContent();

    // Handle messages from webview
    this.panel.webview.onDidReceiveMessage(
      (message) => {
        switch (message.command) {
          case 'alert':
            vscode.window.showInformationMessage(message.text);
            break;
          case 'getData':
            // Send data back to webview
            this.panel.webview.postMessage({
              command: 'receiveData',
              data: { items: ['one', 'two', 'three'] },
            });
            break;
        }
      },
      null,
      this.disposables
    );

    this.panel.onDidDispose(() => this.dispose(), null, this.disposables);
  }

  private getHtmlContent(): string {
    return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Security-Policy"
    content="default-src 'none'; style-src 'unsafe-inline'; script-src 'nonce-abc123';">
  <style>
    body { font-family: var(--vscode-font-family); color: var(--vscode-foreground); }
    button { background: var(--vscode-button-background); color: var(--vscode-button-foreground);
             border: none; padding: 6px 14px; cursor: pointer; }
  </style>
</head>
<body>
  <h1>My Webview Panel</h1>
  <button id="btn">Click Me</button>
  <div id="output"></div>
  <script nonce="abc123">
    const vscode = acquireVsCodeApi();
    document.getElementById('btn').addEventListener('click', () => {
      vscode.postMessage({ command: 'getData' });
    });
    window.addEventListener('message', (event) => {
      const message = event.data;
      if (message.command === 'receiveData') {
        document.getElementById('output').textContent = JSON.stringify(message.data);
      }
    });
  </script>
</body>
</html>`;
  }

  public dispose() {
    MyWebviewPanel.currentPanel = undefined;
    this.panel.dispose();
    while (this.disposables.length) {
      const d = this.disposables.pop();
      if (d) d.dispose();
    }
  }
}
```

---

## 🔒 Security Best Practices

| Practice | Why | How |
|----------|-----|-----|
| **Minimal permissions** | Reduces attack surface, improves trust | Only request permissions you actively use |
| **Content Security Policy** | Prevents XSS in extension pages | Set strict CSP in manifest |
| **No `eval()`** | Code injection risk | Use `chrome.scripting.executeScript` for dynamic code |
| **Sanitize user input** | Prevent DOM injection | Use `textContent` not `innerHTML`, or sanitize with DOMPurify |
| **HTTPS only** | Prevent MITM attacks | Use `https://` in host_permissions, never `http://` |
| **No inline scripts** | CSP compliance | Use separate JS files, never inline `<script>` |
| **Validate messages** | Prevent spoofing | Check `sender.id` matches your extension ID |

> [!WARNING]
> Chrome Web Store **will reject** extensions that request overly broad permissions without justification. The review team checks each permission against your extension's described functionality. Every permission requires a justification in your store listing.

---

## 🧪 Testing Extensions

### Chrome Extension Testing with Puppeteer

```typescript
import puppeteer from 'puppeteer';
import path from 'path';

describe('Chrome Extension', () => {
  let browser: puppeteer.Browser;

  beforeAll(async () => {
    const extensionPath = path.resolve(__dirname, '../dist');
    browser = await puppeteer.launch({
      headless: false,  // Extensions require headed mode
      args: [
        `--disable-extensions-except=${extensionPath}`,
        `--load-extension=${extensionPath}`,
      ],
    });
  });

  afterAll(async () => {
    await browser.close();
  });

  it('should show popup when toolbar icon is clicked', async () => {
    // Find the extension's background service worker target
    const targets = await browser.targets();
    const extensionTarget = targets.find(
      (t) => t.type() === 'service_worker' && t.url().includes('chrome-extension://')
    );
    const extensionId = extensionTarget?.url().split('/')[2];

    // Open popup page directly
    const page = await browser.newPage();
    await page.goto(`chrome-extension://${extensionId}/popup/popup.html`);

    const title = await page.$eval('h1', (el) => el.textContent);
    expect(title).toBe('My Extension');
  });
});
```

### VS Code Extension Testing

```typescript
// src/test/suite/extension.test.ts
import * as assert from 'assert';
import * as vscode from 'vscode';

suite('Extension Test Suite', () => {
  vscode.window.showInformationMessage('Start all tests.');

  test('Extension should be present', () => {
    assert.ok(vscode.extensions.getExtension('publisher.my-extension'));
  });

  test('Should activate extension', async () => {
    const ext = vscode.extensions.getExtension('publisher.my-extension')!;
    await ext.activate();
    assert.strictEqual(ext.isActive, true);
  });

  test('Command should be registered', async () => {
    const commands = await vscode.commands.getCommands(true);
    assert.ok(commands.includes('my-extension.helloWorld'));
  });

  test('Command should execute without error', async () => {
    await assert.doesNotReject(
      vscode.commands.executeCommand('my-extension.helloWorld')
    );
  });
});
```

---

## 🏪 Store Submission Process

### Chrome Web Store

| Step | Action | Details |
|------|--------|---------|
| **1** | Create developer account | $5 one-time fee at chrome.google.com/webstore/devconsole |
| **2** | Prepare assets | 128x128 icon, 1280x800 screenshots (min 1), 440x280 promo tile |
| **3** | Write listing | Description, category, language, privacy practices |
| **4** | Zip extension directory | `cd dist && zip -r ../extension.zip .` |
| **5** | Upload and submit | Upload ZIP, fill forms, submit for review |
| **6** | Wait for review | 1-3 business days (can be longer for new accounts) |

### VS Code Marketplace

```bash
# Install publishing tool
npm install -g @vscode/vsce

# Package extension
vsce package
# Creates: my-extension-1.0.0.vsix

# Publish (requires Personal Access Token from dev.azure.com)
vsce publish
# Or publish specific version:
vsce publish minor  # bumps version then publishes
```

### Publishing Checklist

- [ ] Screenshots show real functionality (not mockups)
- [ ] Description is clear and accurate (no keyword stuffing)
- [ ] Privacy policy URL provided (required for Chrome if using any data)
- [ ] Each permission has a justification paragraph
- [ ] Version number follows semver
- [ ] Tested on clean browser/editor profile (no leftover dev state)
- [ ] Icons are correct sizes and look good on light and dark backgrounds

---

## 💰 Monetization Models

| Model | Implementation | Tools |
|-------|---------------|-------|
| **Freemium** | Free base features, paid premium | License key verification, server-side check |
| **One-time purchase** | Pay once, unlock full version | Gumroad, LemonSqueezy, Paddle |
| **Subscription** | Monthly/annual payment | Server-side verification, Stripe |
| **Donations** | Voluntary support | GitHub Sponsors, Buy Me a Coffee, Ko-fi |
| **Sponsorship** | Company sponsors development | Direct negotiation, Open Collective |

> [!TIP]
> For browser extensions, the simplest monetization is a license key checked against your server. Issue keys on purchase (via Gumroad/LemonSqueezy), and verify them in your background service worker.

---

## ✅ EXIT CHECKLIST

- [ ] Manifest permissions are minimal (only what is actively used)
- [ ] Content Security Policy is strict (no `eval()`, no inline scripts)
- [ ] All user input is sanitized before DOM insertion
- [ ] Message passing validates sender identity
- [ ] All features work correctly across target platforms
- [ ] Store listing complete with screenshots, description, privacy policy
- [ ] Permission justifications written for every requested permission
- [ ] Tests pass (automated and manual on clean profile)
- [ ] Extension loads without errors in developer mode
- [ ] Performance is acceptable (popup opens fast, content scripts don't slow pages)
- [ ] Submitted for store review

---

*Skill Version: 1.0 | Created: February 2026*
