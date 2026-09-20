# AIVerse Mobile App — Product Requirements Document

**Platform:** Flutter (iOS & Android)
**Theme:** Dark Mode Only
**Version:** 1.0 | July 2026

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Goals & Objectives](#2-goals--objectives)
3. [Design Theme](#3-design-theme)
4. [Information Architecture & Navigation](#4-information-architecture--navigation)
5. [Screens & Features](#5-screens--features)
6. [Non-Functional Requirements](#6-non-functional-requirements)
7. [Suggested Tech Stack](#7-suggested-tech-stack)
8. [Future Enhancements](#8-future-enhancements-post-v10)

---

## 1. Introduction

### 1.1 Purpose

This document defines the product requirements for the AIVerse mobile application, a companion app to the existing AIVerse web platform. AIVerse is a directory and discovery platform for AI tools, allowing users to search, browse, compare, and bookmark AI products across multiple categories.

### 1.2 Product Overview

AIVerse mobile brings the full tool-discovery experience of the web platform to iOS and Android, built with Flutter for a single shared codebase. The app will let users browse trending and featured AI tools, explore tools by category, search across 1,000+ listed tools, view detailed tool profiles, save favorites, and submit new tools for listing.

### 1.3 Target Audience

- **Developers and engineers** looking for AI coding/productivity tools
- **Designers and content creators** exploring AI image/video/music tools
- **Marketers and founders** researching AI tools for their business
- **General tech enthusiasts** who want to stay current with new AI launches

### 1.4 Platform & Scope

- Built using **Flutter** — single codebase for iOS and Android
- **Dark theme only** for v1.0 — no light theme toggle in this release
- Consumes the **same backend/API** as the AIVerse web app (tools, categories, ratings, bookmarks, auth)

---

## 2. Goals & Objectives

- Provide a **fast, native-feeling** way to discover AI tools on mobile
- Maintain **full visual and brand consistency** with the AIVerse web platform
- Enable **quick searching and filtering** of 1,000+ tools with minimal taps
- Allow users to **save/bookmark tools** and revisit them offline-friendly
- Support **tool submission** directly from mobile
- Keep the experience **lightweight** — fast load times, minimal onboarding friction

---

## 3. Design Theme

### 3.1 Theme Concept

The app ships with a **single, permanent Dark Theme** — no light mode and no theme-switcher in Settings for this version. The visual language mirrors the AIVerse web app: a near-black background with soft purple-to-pink gradients used for accents, primary actions, and the logo mark. Cards use a slightly raised dark surface with a subtle 1px border to separate content without heavy shadows.

### 3.2 Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#0D0A14` | App scaffold background (all screens) |
| Surface | `#161225` | Cards, list tiles |
| Surface Light | `#1C1730` | Input fields, chips, nav bar icons bg |
| Border | `#3C3489` | Card & input outlines (0.5–1px) |
| Purple Primary | `#7F77DD` | Primary buttons, active states, links |
| Purple Dark | `#534AB7` | Gradient end, pressed states |
| Pink Accent | `#D4537E` | Logo gradient, highlight accents |
| Text Primary | `#FFFFFF` | Headings, titles |
| Text Secondary | `#888780` | Descriptions, subtitles |
| Text Muted | `#5F5E5A` | Meta text, placeholders, inactive icons |
| Success / Freemium | `#0F6E56` / `#9FE1CB` | Freemium badge text/background |
| Warning / Paid | `#633806` / `#FAC775` | Paid badge text/background |

### 3.3 Typography

- **Font family:** Inter (via Google Fonts package)
- **Headings:** weight 500–600, sizes 18–26sp
- **Body text:** weight 400, sizes 12–14sp
- **Meta / caption text:** weight 400, size 10–11sp, muted color

### 3.4 Component Style

- **Corner radius:** 14–16px for cards and inputs, 20px for pill chips, 22px for large icons
- No heavy drop shadows — depth communicated through subtle borders and layered dark tones
- Primary CTAs use the **purple gradient fill**; secondary buttons use outline style with border color
- Category and tool icons use **solid gradient-tinted circular/rounded badges** with initials or icon glyphs

---

## 4. Information Architecture & Navigation

The app uses a **bottom tab bar** as the primary navigation pattern, with stack-based navigation within each tab for detail screens.

### 4.1 Bottom Navigation Tabs

| Tab | Purpose |
|-----|---------|
| **Home** | Trending, featured, latest tools |
| **Categories** | Browse all categories and their tools |
| **Saved** | Bookmarked tools |
| **Profile** | Account, settings, submit tool, about |

### 4.2 Navigation Flow (High Level)

```
Splash Screen
    ↓
Home Screen (auto-navigate after load)
    ↓
┌─────────────────────────────────────────────────┐
│  Home → Search Screen (tap search bar)          │
│  Home → Tool Detail Screen (tap tool card)      │
│  Home → Profile Screen (tap menu/profile icon)  │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  Categories → Category Tools Listing Screen     │
│  Categories → Tool Detail Screen                │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  Profile → Submit Tool Screen                   │
│  Profile → Login / Sign in Screen               │
└─────────────────────────────────────────────────┘
```

---

## 5. Screens & Features

### 5.1 Splash Screen

**Purpose:** Brief branded loading screen shown on app launch while initial data/session is being prepared.

**Key Elements:**
- Full-screen dark background with subtle radial purple glow centered top
- Centered gradient logo mark (purple → pink rounded square with sparkle icon)
- App name "AIVerse" below the logo
- One-line tagline: "Discover the best AI tools for every task"
- Animated loading dots indicator below tagline
- Footer micro-copy: "Made for builders, by builders"

**User Actions:**
- No interactive actions — auto-navigates to Home after session/data check completes (~1.5–2s or until ready)

**Implementation Notes:**
- Should be implemented with `flutter_native_splash` for a seamless native-to-Flutter transition, avoiding a flash of white/blank screen

---

### 5.2 Home Screen

**Purpose:** Main landing screen after launch. Surfaces trending, featured, and category entry points so users discover tools with minimal effort.

**Key Elements:**
- Top bar: logo + app name, menu/profile icon
- Headline: "Discover the best AI tools" with highlighted keyword
- Search bar (tappable, navigates to Search Screen)
- Horizontal filter chips: All / Trending / Featured / New
- "What's hot this week" section — vertical list of tool cards (icon, name, badge, description, rating, views)
- "Featured AI tools" section (editor's picks)
- Quick-access category shortcuts (optional horizontal scroll)
- Pull-to-refresh support

**User Actions:**
- Tap search bar → Search Screen
- Tap filter chip → filters the visible list
- Tap tool card → Tool Detail Screen
- Tap menu/profile icon → Profile Screen or side drawer

**Implementation Notes:**
- Lists should paginate/lazy-load — avoid loading all 1,000+ tools at once

---

### 5.3 Categories Screen

**Purpose:** Lets users browse all AI tool categories in a grid, mirroring the web app's "Find tools by category" section.

**Key Elements:**
- Grid of category cards (2 columns): icon badge, category name, short description, tool count
- Categories include:
  - AI Image Generators
  - AI Video Tools
  - AI Music Tools
  - AI Writing Tools
  - AI Coding Tools
  - AI Voice Generators
  - AI Logo Makers
  - AI Presentation Tools
  - AI Productivity Tools
  - *(extensible list)*
- Search-within-categories field at top (optional)

**User Actions:**
- Tap a category card → Category Tools Listing Screen filtered to that category

---

### 5.4 Category Tools Listing Screen

**Purpose:** Shows all tools belonging to a single selected category.

**Key Elements:**
- Header with category name, icon, and tool count
- Sort/filter row (e.g. Popular, Newest, Top Rated, Free/Paid)
- Vertical list of tool cards, same style as Home
- Empty state if a category has no tools yet

**User Actions:**
- Tap sort/filter → reorder or filter the list
- Tap tool card → Tool Detail Screen
- Back button → returns to Categories Screen

---

### 5.5 Search Screen

**Purpose:** Dedicated full-text search across all listed tools, reached from the Home search bar.

**Key Elements:**
- Auto-focused search input at top with back button
- Recent searches (chips or list) shown when input is empty
- Popular/suggested tags below recent searches
- Live results list as user types (debounced)
- Filter/sort controls above results (category, pricing type, rating)
- Empty state for no matches, with suggestion to browse categories instead

**User Actions:**
- Type query → live-filtered results
- Tap a recent search or suggested tag → runs that search
- Tap result → Tool Detail Screen

---

### 5.6 Tool Detail Screen

**Purpose:** Full profile of a single AI tool — the core conversion screen where users decide to visit/save a tool.

**Key Elements:**
- Large icon/logo badge, tool name, verified badge (if applicable)
- Rating (stars + numeric), view count, pricing badge (Free / Freemium / Paid)
- Full description (expandable if long)
- Tag list (e.g. #chatbot, #writing, #research)
- Screenshots/preview gallery (optional, horizontal scroll)
- Primary CTA button: "Visit Website" (opens in-app browser or external browser)
- Secondary action: Bookmark/Save icon (top right or near CTA)
- Share button
- "Similar tools" section at the bottom (horizontal scroll of related tool cards)

**User Actions:**
- Tap "Visit Website" → opens tool's external site
- Tap bookmark icon → adds/removes from Saved
- Tap share icon → opens native share sheet
- Tap a similar tool card → navigates to that tool's Detail Screen

**Implementation Notes:**
- Bookmark state should sync with backend if the user is logged in
- Allow local-only saving for guests with a prompt to sign in to sync across devices

---

### 5.7 Saved / Bookmarks Screen

**Purpose:** Central place for a user's bookmarked tools.

**Key Elements:**
- List of saved tool cards, same visual style as Home
- Sort options (recently added, alphabetical, by category)
- Swipe-to-remove or explicit remove icon on each card
- Empty state with CTA to browse tools when nothing is saved

**User Actions:**
- Tap card → Tool Detail Screen
- Swipe or tap remove → removes from Saved (with undo snackbar)

**Implementation Notes:**
- Requires login for cloud sync
- Allow local-only saving for guests with a prompt to sign in for backup

---

### 5.8 Submit Tool Screen

**Purpose:** Form allowing users to submit a new AI tool for review/listing, mirroring the web app's "Submit tool" flow.

**Key Elements:**
- Form fields:
  - Tool name (required)
  - Website URL (required)
  - Category (dropdown/multi-select, required)
  - Short description (required)
  - Tags
  - Pricing type (Free/Freemium/Paid, required)
  - Logo upload (optional)
- Submission guidelines note at top
- Submit button (disabled until required fields are valid)
- Confirmation state after successful submission ("Under review")

**User Actions:**
- Fill form fields → validates inline
- Tap Submit → sends to backend for moderation queue

**Implementation Notes:**
- Requires the user to be signed in before submitting

---

### 5.9 Profile / Settings Screen

**Purpose:** Account management and app settings hub.

**Key Elements:**
- User avatar, name, email (or "Sign in" prompt if guest)
- Menu list:
  - My Submissions
  - Saved Tools (shortcut)
  - Notifications
  - About AIVerse
  - Terms & Privacy
  - Contact/Support
  - Rate the app
  - Log out
- App version number at the bottom

**User Actions:**
- Tap "Sign in" → Login/Sign in Screen
- Tap any menu item → respective screen or external link
- Tap Log out → clears session, returns to guest state

**Implementation Notes:**
- No theme toggle is included here per v1.0 scope (dark theme only)

---

### 5.10 Login / Sign in Screen

**Purpose:** Authentication entry point, required for bookmark sync, submissions, and personalization.

**Key Elements:**
- AIVerse logo mark at top
- Email + password fields, or social sign-in buttons (Google/Apple)
- "Continue as guest" option
- Link to Sign Up for new users
- Forgot password link

**User Actions:**
- Enter credentials → Sign in
- Tap social button → OAuth flow
- Tap "Continue as guest" → returns to Home without auth

---

## 6. Non-Functional Requirements

| Requirement | Specification |
|-------------|---------------|
| **Performance** | Initial screen render under 2 seconds on mid-range devices |
| **Offline Behavior** | Previously loaded Home/Saved lists cached locally and viewable offline (read-only) |
| **Accessibility** | Minimum tap target 44x44pt, adequate color contrast against dark backgrounds |
| **Consistency** | Visual parity with the AIVerse web app's dark purple theme across all screens |
| **Scalability** | Lists must paginate/lazy-load given 1,000+ tools in the directory |
| **Platform Support** | Latest two major iOS versions and Android 10+ |

---

## 7. Suggested Tech Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter (single codebase, iOS + Android) |
| **State Management** | Riverpod or Bloc |
| **Fonts** | Google Fonts package (Inter) |
| **Networking** | Dio / http package consuming the existing AIVerse REST API |
| **Local Storage** | Hive or shared_preferences for guest bookmarks and cache |
| **Splash** | flutter_native_splash package |
| **Auth** | Firebase Auth or existing AIVerse backend auth (email + Google/Apple OAuth) |

---

## 8. Future Enhancements (Post v1.0)

- [ ] Light theme option with system-based auto-switching
- [ ] Push notifications for new tool launches and weekly digests
- [ ] In-app tool comparison view (side-by-side)
- [ ] User reviews/ratings submission from within the app
- [ ] Personalized recommendations based on saved/viewed tools

---

## Appendix A: Existing Project Structure

The Flutter project has been initialized with the following relevant files:

```
lib/
├── constants/
│   └── app_colors.dart          # Color palette implementation
├── screens/
│   └── splash_screen.dart       # Splash screen implementation
└── main.dart                    # App entry point with routing
```

**Implemented Features:**
- ✅ Color palette constants matching the design spec
- ✅ Splash screen with gradient logo and loading indicator
- ✅ Google Fonts (Inter) integration
- ✅ Basic MaterialApp setup with routing

**Pending Implementation:**
- [ ] Home Screen
- [ ] Categories Screen
- [ ] Search Screen
- [ ] Tool Detail Screen
- [ ] Saved/Bookmarks Screen
- [ ] Profile/Settings Screen
- [ ] Login/Sign in Screen
- [ ] Submit Tool Screen
- [ ] Bottom navigation bar
- [ ] API integration
- [ ] State management setup

---

*Document Version: 1.0*
*Last Updated: July 2026*
