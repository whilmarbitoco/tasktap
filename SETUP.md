# 🔥 Firebase Setup Guide

## 📋 Prerequisites
1. Firebase project created
2. `google-services.json` placed in `android/app/`
3. Authentication enabled in Firebase Console

## 🔧 Configuration Steps

### 1. Update Environment Variables
Copy `.env.example` to `.env` and update with your Firebase values:

```bash
# Get these from Firebase Console > Project Settings > General
FIREBASE_API_KEY=AIzaSyC...
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:android:abc123

# Get this from Firebase Console > Authentication > Sign-in method > Google
GOOGLE_WEB_CLIENT_ID=123456789-abc123.apps.googleusercontent.com
```

### 2. Where to Find Values

**Firebase Console > Project Settings > General:**
- API Key: Web API Key
- Project ID: Project ID
- Sender ID: Project Number
- App ID: From your Android app

**Google Web Client ID:**
- Firebase Console > Authentication > Sign-in method
- Click Google > Web SDK configuration
- Copy Web client ID

### 3. Enable Authentication
1. Go to Firebase Console > Authentication
2. Click "Get started"
3. Sign-in method tab
4. Enable "Email/Password"
5. Enable "Google" and add support email

### 4. Run the App
```bash
flutter pub get
flutter clean
flutter run
```

## 🚨 Troubleshooting
- If you see a red error screen, check your `.env` file
- Ensure all values don't contain "your_" placeholder text
- Verify `google-services.json` is in the correct location