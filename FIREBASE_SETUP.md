# Firebase Setup Guide for SmartQueue

Follow these steps to configure Firebase in your SmartQueue project.

---

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Create a project** (or use an existing one)
3. Enter a project name (e.g. `smartqueue`)
4. Disable Google Analytics if not needed, or enable it
5. Click **Create project**

---

## Step 2: Add Android App

1. In the project overview, click the **Android** icon (or **Add app** → Android)
2. Enter your Android package name: **`com.example.smartqueue_app`**
   - This must match `applicationId` in `android/app/build.gradle.kts`
3. (Optional) Enter app nickname and Debug signing certificate SHA-1
4. Click **Register app**
5. **Download `google-services.json`** and place it in:
   ```
   android/app/google-services.json
   ```
   - Replace the placeholder file that is there

---

## Step 3: Enable Authentication

1. In Firebase Console, go to **Build** → **Authentication**
2. Click **Get started**
3. Go to the **Sign-in method** tab
4. Click **Email/Password**, enable it, and save

---

## Step 4: Create Firestore Database

1. Go to **Build** → **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development) or **production mode** (with rules)
4. Select a region (e.g. `us-central1`) and **Enable**

---

## Step 5: Firestore Security Rules

1. In Firestore, go to the **Rules** tab
2. Use these rules for development (allows read/write when signed in):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /orders/{orderId} {
      allow read, write: if request.auth != null;
    }
    match /tasks/{taskId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Click **Publish**

---

## Step 6: Run the App

```bash
flutter pub get
flutter run
```

---

## Step 7: (Optional) Add iOS Support

1. In Firebase Console, click **Add app** → **iOS**
2. Enter bundle ID: `com.example.smartqueueApp` (or your iOS bundle ID)
3. Download `GoogleService-Info.plist` and add it to `ios/Runner/`
4. Update `ios/Runner/Info.plist` and `AppDelegate` per Firebase iOS setup docs

---

## Summary of Changes Made

| Before (Supabase) | After (Firebase) |
|-------------------|-----------------|
| Supabase Auth     | Firebase Auth   |
| Supabase (PostgreSQL) | Cloud Firestore |
| `supabase_client.dart` | `firebase_app.dart` |
| `OrderService` → tasks table | `OrderService` → orders collection |
| `AuthService` → Supabase | `AuthService` → Firebase Auth |
