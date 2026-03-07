---
name: Progressive Web App
description: PWA development with service workers, web app manifest, offline support, push notifications, and installability
---

# Progressive Web App Skill

**Purpose**: Guide developers through building production progressive web apps including service worker strategies, web app manifest configuration, offline-first architecture, push notifications, and installability requirements.

---

## TRIGGER COMMANDS

```text
"Convert my web app to a PWA"
"Set up service workers for offline support"
"Implement push notifications in a PWA"
"Make my web app installable"
"Using progressive_web_app skill: [task]"
```

---

## PWA Capabilities Checklist

| Capability | Technology | Browser Support |
|-----------|------------|-----------------|
| Installable | Web App Manifest | Chrome, Edge, Safari, Firefox |
| Offline support | Service Workers + Cache API | All modern browsers |
| Push notifications | Push API + Notifications API | Chrome, Edge, Firefox (not Safari iOS) |
| Background sync | Background Sync API | Chrome, Edge |
| File handling | File Handling API | Chrome, Edge |
| Share target | Web Share Target API | Chrome, Edge, Safari |
| Periodic sync | Periodic Background Sync API | Chrome, Edge |
| Badging | Badging API | Chrome, Edge |
| Shortcuts | Web App Manifest shortcuts | Chrome, Edge, Safari |

---

## Web App Manifest

```json
{
  "name": "My Progressive App",
  "short_name": "MyApp",
  "description": "A full-featured progressive web application",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "orientation": "any",
  "theme_color": "#2563EB",
  "background_color": "#FFFFFF",
  "categories": ["productivity", "utilities"],
  "icons": [
    {
      "src": "/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "any"
    },
    {
      "src": "/icons/icon-maskable-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ],
  "screenshots": [
    {
      "src": "/screenshots/desktop.png",
      "sizes": "1280x720",
      "type": "image/png",
      "form_factor": "wide",
      "label": "Desktop view"
    },
    {
      "src": "/screenshots/mobile.png",
      "sizes": "390x844",
      "type": "image/png",
      "form_factor": "narrow",
      "label": "Mobile view"
    }
  ],
  "shortcuts": [
    {
      "name": "New Document",
      "short_name": "New",
      "url": "/new",
      "icons": [{ "src": "/icons/new-doc.png", "sizes": "96x96" }]
    },
    {
      "name": "Recent Files",
      "short_name": "Recent",
      "url": "/recent"
    }
  ],
  "share_target": {
    "action": "/share",
    "method": "POST",
    "enctype": "multipart/form-data",
    "params": {
      "title": "title",
      "text": "text",
      "url": "url",
      "files": [
        {
          "name": "media",
          "accept": ["image/*", "video/*"]
        }
      ]
    }
  }
}
```

### HTML Head Tags

```html
<head>
  <link rel="manifest" href="/manifest.json" />
  <meta name="theme-color" content="#2563EB" />
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="default" />
  <meta name="apple-mobile-web-app-title" content="MyApp" />
  <link rel="apple-touch-icon" href="/icons/icon-192.png" />
</head>
```

---

## Service Workers

### Registration

```typescript
// src/sw-register.ts
export async function registerServiceWorker() {
  if (!('serviceWorker' in navigator)) return;

  try {
    const registration = await navigator.serviceWorker.register('/sw.js', {
      scope: '/',
    });

    registration.addEventListener('updatefound', () => {
      const newWorker = registration.installing;
      if (!newWorker) return;

      newWorker.addEventListener('statechange', () => {
        if (newWorker.state === 'activated' && navigator.serviceWorker.controller) {
          // New version available - prompt user to refresh
          showUpdateBanner();
        }
      });
    });
  } catch (error) {
    console.error('SW registration failed:', error);
  }
}
```

### Caching Strategies

| Strategy | Use Case | Freshness | Offline |
|----------|----------|-----------|---------|
| Cache First | Static assets, fonts, images | Low | Yes |
| Network First | API calls, dynamic content | High | Fallback |
| Stale While Revalidate | Semi-dynamic (user profile) | Medium | Yes |
| Network Only | Real-time data, auth | Highest | No |
| Cache Only | App shell, versioned assets | Immutable | Yes |

### Service Worker Implementation

```typescript
// public/sw.js
const CACHE_NAME = 'myapp-v1';
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/styles.css',
  '/app.js',
  '/offline.html',
];

// Install: cache static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS))
  );
  self.skipWaiting();
});

// Activate: clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      )
    )
  );
  self.clients.claim();
});

// Fetch: apply caching strategies
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // API calls: Network First
  if (url.pathname.startsWith('/api/')) {
    event.respondWith(networkFirst(request));
    return;
  }

  // Static assets: Cache First
  if (request.destination === 'image' || request.destination === 'font') {
    event.respondWith(cacheFirst(request));
    return;
  }

  // HTML pages: Stale While Revalidate
  if (request.mode === 'navigate') {
    event.respondWith(staleWhileRevalidate(request));
    return;
  }

  // Default: Network First
  event.respondWith(networkFirst(request));
});

async function cacheFirst(request) {
  const cached = await caches.match(request);
  if (cached) return cached;

  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, response.clone());
    }
    return response;
  } catch {
    return new Response('', { status: 408 });
  }
}

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    if (response.ok) {
      const cache = await caches.open(CACHE_NAME);
      cache.put(request, response.clone());
    }
    return response;
  } catch {
    const cached = await caches.match(request);
    return cached || caches.match('/offline.html');
  }
}

async function staleWhileRevalidate(request) {
  const cache = await caches.open(CACHE_NAME);
  const cached = await cache.match(request);

  const networkPromise = fetch(request).then((response) => {
    if (response.ok) {
      cache.put(request, response.clone());
    }
    return response;
  });

  return cached || networkPromise;
}
```

### Workbox (Recommended for Production)

```typescript
// src/sw.ts (using Workbox)
import { precacheAndRoute } from 'workbox-precaching';
import { registerRoute } from 'workbox-routing';
import {
  CacheFirst,
  NetworkFirst,
  StaleWhileRevalidate,
} from 'workbox-strategies';
import { ExpirationPlugin } from 'workbox-expiration';
import { CacheableResponsePlugin } from 'workbox-cacheable-response';

// Precache app shell (injected by build tool)
precacheAndRoute(self.__WB_MANIFEST);

// Images: Cache First, 30 day expiry
registerRoute(
  ({ request }) => request.destination === 'image',
  new CacheFirst({
    cacheName: 'images',
    plugins: [
      new CacheableResponsePlugin({ statuses: [0, 200] }),
      new ExpirationPlugin({ maxEntries: 100, maxAgeSeconds: 30 * 24 * 60 * 60 }),
    ],
  })
);

// API calls: Network First, 24h cache fallback
registerRoute(
  ({ url }) => url.pathname.startsWith('/api/'),
  new NetworkFirst({
    cacheName: 'api-cache',
    plugins: [
      new ExpirationPlugin({ maxEntries: 50, maxAgeSeconds: 24 * 60 * 60 }),
    ],
    networkTimeoutSeconds: 3,
  })
);

// Google Fonts: Stale While Revalidate
registerRoute(
  ({ url }) => url.origin === 'https://fonts.googleapis.com',
  new StaleWhileRevalidate({ cacheName: 'google-fonts-stylesheets' })
);
```

### Vite PWA Plugin

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    VitePWA({
      registerType: 'prompt',
      includeAssets: ['favicon.ico', 'robots.txt', 'icons/*.png'],
      manifest: {
        name: 'My Progressive App',
        short_name: 'MyApp',
        theme_color: '#2563EB',
        icons: [
          { src: '/icons/icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: '/icons/icon-512.png', sizes: '512x512', type: 'image/png' },
        ],
      },
      workbox: {
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/api\.myapp\.com\/.*/i,
            handler: 'NetworkFirst',
            options: {
              cacheName: 'api-cache',
              expiration: { maxEntries: 50, maxAgeSeconds: 86400 },
            },
          },
        ],
      },
    }),
  ],
});
```

---

## Push Notifications

### Request Permission and Subscribe

```typescript
// src/notifications.ts
async function subscribeToPush(): Promise<PushSubscription | null> {
  const permission = await Notification.requestPermission();
  if (permission !== 'granted') return null;

  const registration = await navigator.serviceWorker.ready;

  const subscription = await registration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY),
  });

  // Send subscription to your server
  await fetch('/api/push/subscribe', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(subscription),
  });

  return subscription;
}

function urlBase64ToUint8Array(base64String: string): Uint8Array {
  const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
  const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  const rawData = atob(base64);
  return Uint8Array.from(rawData, (char) => char.charCodeAt(0));
}
```

### Handle Push in Service Worker

```typescript
// In service worker
self.addEventListener('push', (event) => {
  const data = event.data?.json() ?? {};

  const options = {
    body: data.body || 'New notification',
    icon: '/icons/icon-192.png',
    badge: '/icons/badge-72.png',
    tag: data.tag || 'default',
    data: { url: data.url || '/' },
    actions: data.actions || [],
  };

  event.waitUntil(
    self.registration.showNotification(data.title || 'MyApp', options)
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data.url;

  event.waitUntil(
    clients.matchAll({ type: 'window' }).then((windowClients) => {
      // Focus existing window or open new one
      for (const client of windowClients) {
        if (client.url === url && 'focus' in client) {
          return client.focus();
        }
      }
      return clients.openWindow(url);
    })
  );
});
```

### Server-Side Push (Node.js)

```typescript
// server/push.ts
import webpush from 'web-push';

webpush.setVapidDetails(
  'mailto:admin@myapp.com',
  process.env.VAPID_PUBLIC_KEY!,
  process.env.VAPID_PRIVATE_KEY!
);

async function sendPush(subscription: PushSubscription, payload: object) {
  try {
    await webpush.sendNotification(
      subscription,
      JSON.stringify(payload)
    );
  } catch (error: any) {
    if (error.statusCode === 410) {
      // Subscription expired - remove from database
      await removeSubscription(subscription.endpoint);
    }
  }
}
```

---

## Offline-First Data Patterns

### IndexedDB for Offline Data

```typescript
// src/db.ts
import { openDB, DBSchema } from 'idb';

interface MyDB extends DBSchema {
  documents: {
    key: string;
    value: {
      id: string;
      title: string;
      content: string;
      updatedAt: number;
      synced: boolean;
    };
    indexes: { 'by-synced': boolean };
  };
}

const dbPromise = openDB<MyDB>('myapp-db', 1, {
  upgrade(db) {
    const store = db.createObjectStore('documents', { keyPath: 'id' });
    store.createIndex('by-synced', 'synced');
  },
});

export async function saveDocument(doc: MyDB['documents']['value']) {
  const db = await dbPromise;
  await db.put('documents', { ...doc, synced: false, updatedAt: Date.now() });
}

export async function getUnsyncedDocuments() {
  const db = await dbPromise;
  return db.getAllFromIndex('documents', 'by-synced', false);
}

export async function syncDocuments() {
  const unsynced = await getUnsyncedDocuments();
  for (const doc of unsynced) {
    try {
      await fetch('/api/documents', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(doc),
      });
      const db = await dbPromise;
      await db.put('documents', { ...doc, synced: true });
    } catch {
      // Will retry on next sync
    }
  }
}
```

---

## Installability Requirements

| Requirement | Details |
|-------------|---------|
| HTTPS | Required (except localhost) |
| Service worker | Must be registered with fetch handler |
| Web app manifest | name/short_name, start_url, display, icons (192 + 512) |
| User engagement | Chrome: user interacts with domain for 30+ seconds |

### Install Prompt Handling

```typescript
// src/install.ts
let deferredPrompt: BeforeInstallPromptEvent | null = null;

window.addEventListener('beforeinstallprompt', (e) => {
  e.preventDefault();
  deferredPrompt = e as BeforeInstallPromptEvent;
  showInstallButton();
});

async function handleInstallClick() {
  if (!deferredPrompt) return;

  deferredPrompt.prompt();
  const { outcome } = await deferredPrompt.userChoice;

  if (outcome === 'accepted') {
    hideInstallButton();
  }
  deferredPrompt = null;
}

window.addEventListener('appinstalled', () => {
  hideInstallButton();
  // Track installation analytics
});
```

---

## PWA Testing

### Lighthouse PWA Audit

```bash
# CLI
npx lighthouse https://myapp.com --only-categories=pwa --output=json

# CI
npx lhci autorun --collect.url=https://myapp.com --assert.preset=lighthouse:recommended
```

### Key Metrics

| Metric | Target | Tool |
|--------|--------|------|
| Lighthouse PWA score | 100 | Lighthouse |
| Time to Interactive | <3.5s | Lighthouse |
| First Contentful Paint | <1.8s | Lighthouse |
| Offline capability | All critical paths | Manual test |
| Install prompt | Shows on engagement | Manual test |
| Push delivery rate | >95% | Server metrics |

---

## Cross-References

- `3-build/accessibility_implementation` - Accessible PWA patterns
- `2-design/inclusive_design_patterns` - Offline-first as inclusive design
- `2-design/cross_platform_architecture` - PWA vs native app decision
- `4-secure/mobile_security_testing` - PWA security considerations

---

## EXIT CHECKLIST

- [ ] Web app manifest complete with icons, screenshots, shortcuts
- [ ] Service worker registered with appropriate caching strategies
- [ ] Offline fallback page exists for failed navigations
- [ ] App is installable (passes Lighthouse PWA audit)
- [ ] Push notifications implemented (if needed)
- [ ] IndexedDB used for offline data persistence
- [ ] Background sync for offline mutations
- [ ] Update prompt shown when new version available
- [ ] HTTPS enforced in production
- [ ] Apple-specific meta tags added for iOS
- [ ] Lighthouse PWA score is 100
- [ ] Tested offline on real devices (not just DevTools)

---

*Skill Version: 1.0 | Created: March 2026*
