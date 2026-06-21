# 📱 TaskTap

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A mobile marketplace app that connects people who need small tasks done with local helpers — built with Flutter. Post a task, find someone nearby, get it done.

## ✨ Highlights

- **Real-Time Task Matching** — Post tasks and get matched with available helpers instantly
- **Role-Based Access** — Separate flows for task requesters and helpers
- **Push Notifications** — Instant alerts for new tasks, acceptances, and status updates
- **Ratings & Reviews** — Build trust within the community
- **In-App Messaging** — Coordinate directly between requester and helper
- **Location-Based Discovery** — Find tasks and helpers nearby

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter |
| Language | Dart |
| State Management | Provider / Riverpod |
| Database | Firebase Firestore |
| Auth | Firebase Auth |
| Storage | Firebase Storage |
| Notifications | Firebase Cloud Messaging |
| Maps | Google Maps SDK |

## 🚀 Quick Start

```bash
git clone https://github.com/whilmarbitoco/tasktap.git
cd tasktap
flutter pub get
flutter run
```

### Prerequisites
- Flutter 3.x
- Dart 3.x
- Firebase project (add `google-services.json` / `GoogleService-Info.plist`)

## 📁 Project Structure

```
lib/
├── models/        # Data classes (User, Task, Review, etc.)
├── services/      # API, database, platform services
├── repositories/  # Business logic layer
├── viewmodels/    # State management (MVVM)
├── views/         # UI screens
└── widgets/       # Reusable components
```

## 👥 Roles

| Requester | Helper |
|-----------|--------|
| Post tasks with budget & deadline | Browse available tasks nearby |
| Review & rate after completion | Accept and complete tasks |
| In-app messaging | Earn ratings & reviews |

## 📄 License

MIT © [Whilmar Bitoco](https://github.com/whilmarbitoco)
