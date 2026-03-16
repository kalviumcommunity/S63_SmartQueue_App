# SmartQueue

**SmartQueue** is a Flutter mobile app designed to help street food vendors manage orders efficiently. It provides a clean, scalable foundation for building an order management system with real-time capabilities.

---

## Flutter Folder Structure

```
lib/
├── main.dart                 # App entry point and root widget
├── models/                   # Data structures
│   └── task.dart
├── screens/                  # UI pages
│   ├── auth_screen.dart
│   ├── task_screen.dart
│   └── welcome_screen.dart   # Launch screen
├── services/                 # Backend and API integrations
│   ├── auth_service.dart
│   ├── supabase_client.dart
│   ├── supabase/             # Supabase configuration
│   │   └── supabase_config.dart
│   └── task_service.dart
└── widgets/                 # Reusable UI components
    ├── primary_button.dart
    ├── task_input.dart
    └── task_list.dart
```

---

## Directory Descriptions

| Directory  | Purpose |
|-----------|---------|
| **screens** | Full-page UI screens (Welcome, Auth, Task list). Each screen is a self-contained widget. |
| **widgets** | Reusable UI components such as buttons, inputs, and lists. Kept small and composable. |
| **models** | Plain data structures and mapping logic (e.g. `Task`, `fromMap`, `toInsertMap`). |
| **services** | Backend/API logic. Handles Supabase initialization, auth, and database operations. Business logic stays here, separate from UI. |

---

## Setup Instructions

### 1. Install Flutter

- Download Flutter: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Add Flutter to your `PATH`
- Run `flutter doctor` to verify the setup

### 2. Get Dependencies

```bash
cd S63_SmartQueue_App
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

The app launches into the **Welcome Screen** by default. No backend configuration is required for the welcome flow.

### 4. Optional: Supabase Backend

To enable auth and real-time tasks, configure Supabase and run with your project credentials:

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR-ANON-KEY
```

Replace `YOUR-PROJECT` and `YOUR-ANON-KEY` with values from your [Supabase dashboard](https://supabase.com/dashboard).

---

## Flutter & Dart Concepts Used

- **Widgets** – Composable UI building blocks (StatelessWidget, StatefulWidget)
- **State** – `setState()` for reactive UI updates when the button is pressed
- **Layout** – Scaffold, AppBar, Center, Column, Padding, ConstrainedBox
- **Material Design** – ThemeData, ColorScheme, Material 3
- **Animations** – AnimatedContainer, AnimatedDefaultTextStyle for smooth transitions
- **Modular structure** – Separation of screens, widgets, models, and services
- **Package imports** – Clean imports using `package:smartqueue_app/...` style

---

## Backend: Supabase (not Firebase)

This project uses **Supabase** as the backend service instead of Firebase:

- **PostgreSQL database** – Relational data, SQL, joins
- **Auth** – Email/password sign up and sign in
- **Real-time** – Live updates over WebSockets
- **Self-hostable** – Can run on your own infrastructure

Supabase configuration lives in `lib/services/supabase/supabase_config.dart` and is provided via `--dart-define` for secure, environment-specific setup.

---

## How to Make Android Appear in "flutter run"

Flutter only shows Android when an **emulator is running** or a **phone is connected**. Your SDK is already installed — you just need to start the emulator.

### Option 1: Android Studio (recommended)

1. Open **Android Studio**
2. Click **Device Manager** (phone icon in the toolbar) or **Tools → Device Manager**
3. Find your virtual device (e.g. **Medium_Phone_API_36.1**) and click the **▶ Play** button
4. Wait until the emulator shows the Android home screen (~1–2 minutes)
5. Run `flutter run` — your emulator will appear in the device list

### Option 2: Command line

**Bash / Git Bash:**
```bash
bash fix_emulator.sh
```

**Command Prompt (cmd):**
```cmd
fix_emulator.bat
```

**PowerShell:**
```powershell
.\fix_emulator.bat
```

Wait for the emulator to fully boot, then run `flutter run`.

### Option 3: Physical Android phone

1. On your phone: **Settings → About phone** → tap **Build number** 7 times to enable Developer options
2. **Settings → Developer options** → enable **USB debugging**
3. Connect the phone via USB
4. Run `flutter run` — the device will appear in the list

---

## Troubleshooting: "Can't find service: activity/package" on Emulator

If `flutter run` fails with **"cmd: Can't find service: activity"** or **"cmd: Can't find service: package"**, the emulator is in a bad state. Use **Android Studio → Device Manager → ⋮ → Cold Boot Now** on your AVD, or run `fix_emulator.sh` / `fix_emulator.bat` and wait for a full boot.
