---
name: game_publishing
description: Publishing and distributing games to Steam, mobile app stores, and other game platforms
---

# Game Publishing Skill

**Purpose**: Guides the complete process of preparing, submitting, and launching games on major distribution platforms including Steam, App Store, Google Play, Epic Games Store, and itch.io.

## :dart: TRIGGER COMMANDS

```text
"publish game"
"submit to Steam"
"app store submission"
"release game on itch.io"
"set up game store page"
"Using game_publishing skill: launch on platform"
```

## :shopping_cart: PLATFORM COMPARISON

| Platform | Target | Revenue Split | Upfront Cost | Review Process | Best For |
|----------|--------|--------------|--------------|----------------|----------|
| **Steam** | PC, Mac, Linux | 70/30 (75/25 after $10M, 80/20 after $50M) | $100 per app | ~2-5 business days | PC games, any genre |
| **App Store** (iOS) | iPhone, iPad, Mac | 70/30 (85/15 for small biz <$1M) | $99/year | 1-7 days (strict) | Mobile, Apple Arcade |
| **Google Play** | Android | 85/15 (first $1M), then 70/30 | $25 one-time | Hours to days | Mobile, broadest reach |
| **Epic Games Store** | PC | 88/12 | By invitation or self-publish | Varies | PC, Unreal Engine games |
| **itch.io** | Web, PC, Mac, Linux | You choose (0-100%) | Free | None | Indie, game jams, experimental |
| **GOG** | PC, Mac, Linux | ~70/30 | By application | Curated | DRM-free, retro, RPGs |
| **Xbox / Game Pass** | Xbox, PC | 70/30 | ID@Xbox program (free) | Certification | Console, Game Pass exposure |
| **PlayStation** | PS4, PS5 | 70/30 | PlayStation Partners (free) | Certification | Console audience |
| **Nintendo eShop** | Switch | 70/30 | Nintendo Developer Portal | Certification (strict) | Family-friendly, indie |

## :steam_locomotive: STEAM SUBMISSION PROCESS

### Step-by-Step Checklist

- [ ] **1. Create Steamworks account** at partner.steamgames.com ($100 per app credit)
- [ ] **2. Create app** in Steamworks partner dashboard, receive App ID
- [ ] **3. Configure store page**:
  - [ ] App name and short description (tagline)
  - [ ] Detailed description (HTML supported, ~2000 chars)
  - [ ] At least 5 screenshots (1280x720 or 1920x1080)
  - [ ] Header capsule image (460x215)
  - [ ] Small capsule (231x87)
  - [ ] Main capsule (616x353)
  - [ ] Hero capsule (3840x1240) -- displayed at top of store page
  - [ ] Library assets (600x900 portrait, 3840x1240 hero, 1920x620 logo)
  - [ ] At least 1 trailer (recommended: 30-60 seconds, MP4)
  - [ ] System requirements (minimum + recommended)
  - [ ] Tags and categories
  - [ ] Content descriptors (violence, language, etc.)
  - [ ] Supported languages
- [ ] **4. Upload build** via SteamPipe (Steamworks CLI or GUI)
- [ ] **5. Set pricing** (Steamworks suggests pricing tiers by region)
- [ ] **6. Configure achievements** (optional but recommended)
- [ ] **7. Submit for review** (2-5 business days)
- [ ] **8. Set release date** and launch

### SteamPipe Build Upload

```bash
# Install SteamCMD
# Download from: https://developer.valvesoftware.com/wiki/SteamCMD

# Create app_build_[appid].vdf
# Example: app_build_1234567.vdf
"AppBuild"
{
  "AppID" "1234567"
  "Desc" "Version 1.0.0 Release Build"
  "ContentRoot" "./build/"
  "BuildOutput" "./output/"
  "Depots"
  {
    "1234568"
    {
      "FileMapping"
      {
        "LocalPath" "*"
        "DepotPath" "."
        "recursive" "1"
      }
    }
  }
}

# Upload via SteamCMD
steamcmd +login your_username +run_app_build app_build_1234567.vdf +quit
```

### Steamworks SDK Integration

```cpp
// Initialize Steamworks (C++)
#include "steam/steam_api.h"

bool InitSteam() {
    if (!SteamAPI_Init()) {
        printf("Steam must be running to play this game.\n");
        return false;
    }
    // Verify app ownership
    if (!SteamApps()->BIsSubscribedApp(YOUR_APP_ID)) {
        printf("App not owned.\n");
        return false;
    }
    return true;
}

// Unlock achievement
void UnlockAchievement(const char* achievementId) {
    SteamUserStats()->SetAchievement(achievementId);
    SteamUserStats()->StoreStats();
}

// Call every frame
void Update() {
    SteamAPI_RunCallbacks();
}
```

```typescript
// Steamworks via greenworks (Node.js / Electron)
import greenworks from 'greenworks';

if (greenworks.init()) {
  console.log('Steam initialized, user:', greenworks.getSteamId().screenName);

  // Unlock achievement
  greenworks.activateAchievement('FIRST_WIN', () => {
    console.log('Achievement unlocked!');
  });
}
```

## :iphone: MOBILE APP SUBMISSION

### Apple App Store

| Requirement | Details |
|------------|---------|
| Developer Account | $99/year (Apple Developer Program) |
| Screenshots | 6.7" (iPhone 15 Pro Max), 6.5" (iPhone 14 Plus), 5.5" (iPhone 8 Plus), 12.9" iPad Pro |
| App Preview | Up to 3 video previews per localization (15-30 seconds) |
| Privacy Labels | Declare all data collection (analytics, tracking, etc.) |
| Age Rating | Complete IARC questionnaire |
| App Review Guidelines | No gambling without license, no explicit content, performance standards |
| Build Upload | Via Xcode or Transporter app |

> [!WARNING]
> Apple App Review can reject for subjective reasons like "minimal functionality" or "not enough native iOS feel." Games using web views may face extra scrutiny. Allow extra time for potential rejections and resubmissions. First-time submissions often take 2-3 rounds.

### Google Play

| Requirement | Details |
|------------|---------|
| Developer Account | $25 one-time registration |
| Screenshots | Phone (min 2), 7-inch tablet, 10-inch tablet |
| Feature Graphic | 1024x500 (displayed prominently in store) |
| Content Rating | IARC self-rating questionnaire |
| Data Safety | Declare data collection, sharing, security practices |
| Release Tracks | Internal (100 testers) -> Closed (invite) -> Open (public beta) -> Production |
| Build Upload | AAB format (not APK) required since 2021 |
| Target API Level | Must target latest Android API within 1 year of release |

```bash
# Build Android App Bundle (Flutter example)
flutter build appbundle --release

# Build AAB (React Native)
cd android && ./gradlew bundleRelease
```

## :camera: STORE PAGE OPTIMIZATION

### Screenshot Best Practices

| Do | Don't |
|----|-------|
| Show actual gameplay | Show main menu or settings |
| Use the most exciting moments | Use boring, early-game screens |
| Add brief caption text overlay | Add walls of text |
| Show variety of content | Repeat similar screenshots |
| Match platform screenshot specs exactly | Upload wrong resolution |

### Trailer Guidelines

- [ ] Hook in the first 5 seconds (show the best moment immediately)
- [ ] Keep total length 30-60 seconds (90s max)
- [ ] Show gameplay, not cutscenes (70%+ gameplay footage)
- [ ] Include game title and platforms at the end
- [ ] Use game audio, not just licensed music
- [ ] End with a call to action ("Wishlist now", "Available now")
- [ ] Upload at 1080p or 4K, 60fps if gameplay is smooth

### Pricing Strategy

| Model | Pros | Cons | Best For |
|-------|------|------|----------|
| **Premium** ($5-60) | Clear revenue, no grind complaints | Higher barrier to entry | Quality indie/AA/AAA |
| **Free-to-Play + IAP** | Massive audience, recurring revenue | Needs careful monetization design | Mobile, live service |
| **Freemium** (free + paid full) | Try before buy, large funnel | Conversion rate ~2-5% | Mobile games |
| **Early Access** ($10-40) | Fund development, build community | Negative reviews if unfinished | PC, community-driven |
| **Subscription** (Game Pass, Apple Arcade) | Guaranteed income | Lower per-player revenue | Deal-based |

> [!TIP]
> On Steam, pricing at $14.99 or $19.99 has the highest revenue-per-player for indie games. Pricing under $5 signals "not a real game" to many buyers. Consider launching at a higher price with a launch discount (10-15%) to reward early supporters and generate sales velocity.

## :trophy: ACHIEVEMENTS AND TROPHIES

### Design Guidelines

| Principle | Good Example | Bad Example |
|-----------|-------------|-------------|
| Celebrate milestones | "Complete Chapter 1" | "Press Start" |
| Reward mastery | "Beat boss without taking damage" | "Die 1000 times" |
| Encourage exploration | "Find all hidden areas" | "Walk 10,000 steps" |
| Reasonable quantity | 20-40 achievements | 1,000 achievements |
| Clear icons | Distinct, readable at small size | Generic or blurry |

```typescript
// Achievement system (generic, works with any platform)
interface Achievement {
  id: string;
  name: string;
  description: string;
  icon: string;
  hidden: boolean;
  unlocked: boolean;
  progress?: { current: number; target: number };
}

class AchievementManager {
  private achievements: Map<string, Achievement> = new Map();
  private platform: 'steam' | 'apple' | 'google' | 'none' = 'none';

  unlock(id: string): void {
    const achievement = this.achievements.get(id);
    if (!achievement || achievement.unlocked) return;

    achievement.unlocked = true;
    this.showNotification(achievement);
    this.syncToPlatform(id);
  }

  updateProgress(id: string, current: number): void {
    const achievement = this.achievements.get(id);
    if (!achievement?.progress || achievement.unlocked) return;

    achievement.progress.current = current;
    if (current >= achievement.progress.target) {
      this.unlock(id);
    }
  }

  private syncToPlatform(id: string): void {
    // Platform-specific SDK calls
    switch (this.platform) {
      case 'steam': /* SteamUserStats.SetAchievement */ break;
      case 'apple': /* GameKit reportAchievements */ break;
      case 'google': /* PlayGames unlockAchievement */ break;
    }
  }

  private showNotification(achievement: Achievement): void {
    // Show in-game toast notification
    console.log(`Achievement Unlocked: ${achievement.name}`);
  }
}
```

## :bar_chart: ANALYTICS

| Platform | Tool | Cost | Key Metrics |
|----------|------|------|-------------|
| Steam | Steamworks Stats | Free | Wishlist conversions, play time, refund rate |
| All | Unity Analytics | Free tier | DAU/MAU, retention, session length |
| Mobile | Firebase Analytics | Free | Installs, events, funnels, cohorts |
| All | GameAnalytics | Free (<100K MAU) | Progression, monetization, errors |
| All | Custom (PostHog/Mixpanel) | Varies | Full control, custom events |

Key metrics to track:

- [ ] **D1/D7/D30 Retention** -- % of players who return after 1/7/30 days
- [ ] **Session Length** -- average play time per session
- [ ] **Funnel Completion** -- % who complete tutorial, reach level 5, etc.
- [ ] **Revenue per User (ARPU)** -- total revenue / total users
- [ ] **Conversion Rate** -- % of free users who pay (F2P)
- [ ] **Refund Rate** -- keep under 5% on Steam to avoid issues

## :earth_americas: LOCALIZATION

| Priority | Languages | Coverage |
|----------|-----------|----------|
| Tier 1 | English, Simplified Chinese, Japanese | ~60% of Steam revenue |
| Tier 2 | German, French, Spanish, Korean, Russian | +20% |
| Tier 3 | Portuguese (BR), Turkish, Polish, Italian | +10% |
| Tier 4 | All others | Remaining 10% |

- [ ] Externalize all text strings into JSON/CSV/PO files
- [ ] Support Unicode and variable text lengths (German is 30% longer than English)
- [ ] Right-to-left (RTL) support if targeting Arabic/Hebrew
- [ ] Test all UI with longest translations (buttons, menus, dialogs)
- [ ] Localize screenshots and store descriptions per platform
- [ ] Cultural sensitivity review (gestures, colors, symbols differ by culture)

## :balance_scale: AGE RATINGS

| System | Region | Required By |
|--------|--------|-------------|
| **IARC** | Global (digital) | Google Play, Nintendo eShop, Microsoft Store |
| **ESRB** | North America | PlayStation, Xbox, Nintendo (physical) |
| **PEGI** | Europe | PlayStation, Xbox, Nintendo (physical) |
| **USK** | Germany | Required for German market |
| **CERO** | Japan | Required for Japanese market |
| **GRAC** | South Korea | Required for Korean market |

> [!TIP]
> Most digital storefronts use IARC, which is a single free questionnaire that generates ratings for multiple systems. You fill it out once and get ESRB, PEGI, USK, GRAC, and ClassInd ratings automatically. Physical retail may require separate applications.

## :scales: LEGAL CONSIDERATIONS

| Issue | Details | Risk |
|-------|---------|------|
| **COPPA** (US) | If children under 13 can play, requires parental consent for data collection | FTC fines up to $50K per violation |
| **Loot Box Laws** | Belgium and Netherlands ban paid random item mechanics | Delisting or fines |
| **GDPR** (EU) | Player data handling, right to deletion, privacy policy | Fines up to 4% global revenue |
| **Refund Policies** | Steam: 2 hours played / 14 days owned. Apple/Google: varies | Mandatory compliance |
| **Music Licensing** | All music must be licensed for commercial use in games | DMCA takedown, lawsuits |
| **Open Source Licenses** | Must comply with licenses of all bundled libraries | Legal action, delisting |
| **Gambling** | Real-money gambling features require licenses per jurisdiction | Criminal penalties |

> [!WARNING]
> If your game includes any random reward mechanic that can be purchased with real money (loot boxes, gacha), research the laws in every country you plan to release in. Belgium has banned paid loot boxes entirely, and several other countries have pending legislation. Consider disclosing drop rates (required in China, Japan, Apple App Store).

## :loudspeaker: COMMUNITY AND POST-LAUNCH

### Pre-Launch Community Building

- [ ] Create Steam store page at least 2 months before launch (wishlist accumulation)
- [ ] Set up Discord server with game channels
- [ ] Post development updates (devlogs) regularly
- [ ] Build an email list for launch announcements
- [ ] Engage with press and content creators (send review keys)

### Post-Launch Cadence

| Timeframe | Action |
|-----------|--------|
| Day 1 | Monitor crash reports, hotfix critical bugs within hours |
| Week 1 | Patch based on common player feedback |
| Month 1 | First content update or quality-of-life patch |
| Quarterly | Major updates, seasonal events, DLC |
| Ongoing | Community engagement, patch notes, roadmap updates |

### Patch Notes Template

```markdown
## v1.2.0 - The Quality of Life Update

### New Features
- Added photo mode
- New accessibility options: colorblind mode, screen reader support

### Balance Changes
- Reduced enemy health in Chapter 3 by 15%
- Increased gold drop rate from chests

### Bug Fixes
- Fixed crash when opening inventory with 100+ items
- Fixed audio cutting out during boss fights

### Known Issues
- Rare save corruption on Linux (investigating)
```

## :white_check_mark: EXIT CHECKLIST

- [ ] Store page complete with all required assets (screenshots, capsules, trailer)
- [ ] Build uploaded to platform and passing validation
- [ ] Screenshots show actual gameplay, 5+ per platform
- [ ] Trailer is 30-60 seconds, hooks in first 5 seconds
- [ ] Age ratings obtained (IARC or platform-specific)
- [ ] Pricing set with regional adjustments
- [ ] Achievements / trophies configured (if applicable)
- [ ] Analytics integrated and sending events
- [ ] Localization complete for Tier 1 languages at minimum
- [ ] Legal compliance verified (COPPA, GDPR, loot box laws)
- [ ] Community channels set up (Discord, social media)
- [ ] Launch day monitoring plan in place (crash reporting, support)
- [ ] Post-launch content roadmap drafted

*Skill Version: 1.0 | Created: February 2026*
