# AIVerse

A Flutter-based AI tools directory app with payments, notifications, and admin panel.

## Features

- Browse and search 17+ curated AI tools
- Tool submission with admin approval workflow
- Stripe test payments with saved card management
- AIVerse Premium subscriptions (Plus/Pro) with 7-day free trial
- In-app notifications (submit, approve, reject updates)
- Dark/Light/System theme support
- Bookmarks, reviews, and user profiles
- Responsive UI with purple gradient branding

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter, Riverpod, Hive, Google Fonts |
| Backend | Node.js, Express, JWT Auth |
| Payments | Stripe (test mode) |
| Storage | In-memory (backend), Hive (frontend) |

## Project Structure

```
ai_tools_verse/
├── frontend/          # Flutter app
│   ├── lib/
│   │   ├── constants/     # Colors, themes
│   │   ├── models/        # Data models (Hive + JSON)
│   │   ├── providers/     # Riverpod state management
│   │   ├── screens/       # UI screens
│   │   ├── services/      # API, storage, mock data
│   │   └── widgets/       # Reusable widgets
│   └── pubspec.yaml
├── backend/           # Express API
│   ├── routes/        # API endpoints
│   ├── data/          # In-memory data (tools, users)
│   ├── middleware/     # Auth, admin middleware
│   └── server.js
└── docs/              # PRD and implementation docs
```

## Getting Started

### Backend

```bash
cd backend
npm install
node server.js
```

Server runs on `http://localhost:3000`

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

### Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@aiverse.com | admin123 |
| User | user@aiverse.com | user123 |

## API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | /v1/auth/signin | No | Login |
| POST | /v1/auth/signup | No | Register |
| GET | /v1/tools | No | List approved tools |
| POST | /v1/tools/submit | Yes | Submit new tool |
| PUT | /v1/tools/:id/approve | Admin | Approve tool |
| PUT | /v1/tools/:id/reject | Admin | Reject tool |
| GET | /v1/notifications | Yes | Get notifications |
| POST | /v1/payments/create-intent | Yes | Create Stripe payment |

## Stripe Test Card

| Field | Value |
|-------|-------|
| Card | 4242 4242 4242 4242 |
| Expiry | 12/30 |
| CVC | 123 |

## License

Practice project — not for production use.
