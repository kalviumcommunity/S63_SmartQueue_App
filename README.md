# SmartQueue

**SmartQueue** is a Flutter mobile app that helps street food vendors manage orders efficiently and reduce long queues. It provides authentication, cloud database storage, and real-time order updates using Supabase as the backend.

---

## Flutter Folder Structure

```
lib/
├── main.dart                     # App entry point, auth gate
├── models/                       # Data structures
│   ├── order.dart                # Order model for vendor queue
│   └── task.dart
├── screens/                      # UI pages
│   ├── auth_screen.dart
│   ├── login_screen.dart         # Sign-in screen
│   ├── signup_screen.dart        # Account creation
│   ├── vendor_dashboard_screen.dart  # Main dashboard (auth required)
│   ├── responsive_home.dart      # Responsive demo dashboard
│   ├── task_screen.dart
│   └── welcome_screen.dart       # Launch screen (when Supabase not configured)
├── services/                     # Backend and API integrations
│   ├── auth_service.dart         # Supabase authentication
│   ├── order_service.dart        # Order CRUD and real-time
│   ├── supabase_client.dart
│   ├── supabase/
│   │   └── supabase_config.dart
│   └── task_service.dart
├── utils/
│   └── responsive.dart
└── widgets/
    ├── dashboard_action_button.dart
    ├── order_card.dart
    ├── primary_button.dart
    ├── task_input.dart
    └── task_list.dart
```

---

## Supabase Authentication Integration

SmartQueue uses **Supabase Auth** for user sign-in and sign-up:

- **Login** (`lib/screens/login_screen.dart`) – Email and password fields, validates credentials, redirects to dashboard on success.
- **Sign Up** (`lib/screens/signup_screen.dart`) – Creates new accounts, redirects to dashboard after signup.
- **Session persistence** – Supabase SDK stores the session locally. Users stay logged in after closing and reopening the app.
- **Auth gate** – `main.dart` uses `StreamBuilder<AuthState>` to show `LoginScreen` when logged out and `VendorDashboardScreen` when logged in.

The `AuthService` (`lib/services/auth_service.dart`) wraps Supabase Auth and exposes `signIn`, `signUp`, `signOut`, `currentSession`, and `authStateChanges`.

---

## Database CRUD Functionality

Orders are stored in a Supabase PostgreSQL table. The `OrderService` (`lib/services/order_service.dart`) provides:

| Operation | Method | Description |
|-----------|--------|-------------|
| **Create** | `addOrder(title, status)` | Inserts a new order with optional status (default: Queued) |
| **Read** | `fetchOrders()` | Fetches all orders for the current user |
| **Update** | `updateOrder(order)` | Updates title and/or status of an existing order |
| **Delete** | `deleteOrder(id)` | Removes an order by id |

Row Level Security (RLS) ensures users only access their own orders. The `Order` model (`lib/models/order.dart`) maps between Dart objects and Supabase rows.

---

## Real-Time Data Updates

Orders use Supabase Realtime so the UI updates automatically when data changes:

- `OrderService.ordersStream()` returns a `Stream<List<Order>>` that listens to the `orders` table.
- The vendor dashboard uses `StreamBuilder<List<Order>>` to rebuild when orders are added, updated, or deleted.
- No manual refresh is needed; changes from other devices or the Supabase dashboard appear immediately.

Enable Realtime for the `orders` table in **Supabase Dashboard → Database → Replication** by adding it to the `supabase_realtime` publication.

---

## Setup Instructions

### 1. Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed and on `PATH`
- A [Supabase](https://supabase.com) project

### 2. Create the Tasks Table

In your Supabase project, open **SQL Editor** and run the contents of `supabase/migrations/000_create_tasks_table.sql`. Or tap **Open Supabase SQL Editor** from the in-app error screen, then paste and run:

```sql
CREATE TABLE IF NOT EXISTS public.tasks (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Queued',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all for tasks" ON public.tasks;
CREATE POLICY "Allow all for tasks" ON public.tasks FOR ALL USING (true) WITH CHECK (true);
```

### 3. Configure Supabase Credentials

Copy your project URL and anon key from **Supabase Dashboard → Settings → API**. Either:

- Use the default config in `lib/services/supabase/supabase_config.dart` (for local dev), or  
- Run with `--dart-define`:

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR-PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR-ANON-KEY
```

### 4. Run the App

```bash
cd S63_SmartQueue_App
flutter pub get
flutter run
```

- If Supabase is configured: You see the **Login** screen. Sign up or log in, then you are taken to the **Vendor Dashboard**.
- If Supabase is not configured: You see the **Welcome** screen. Tap **Go to Dashboard** for the responsive demo (no backend).

---

## Project Architecture

| Layer | Responsibility |
|-------|----------------|
| **screens** | Full-page UI: login, signup, dashboard, welcome |
| **widgets** | Reusable components (OrderCard, buttons, etc.) |
| **models** | Data structures (Order, Task) and JSON mapping |
| **services** | Supabase auth, order CRUD, real-time streams |
| **utils** | Shared helpers (e.g. responsive breakpoints) |

UI logic is separated from backend logic; services handle all Supabase interaction.

---

## Supabase vs Traditional Backend Development

Supabase simplifies building cloud-connected apps:

1. **Auth** – Email/password, OAuth, and magic links without a custom auth server.
2. **Database** – PostgreSQL with real-time subscriptions instead of REST polling.
3. **RLS** – Row-level security replaces many custom authorization checks.
4. **SDK** – Flutter package with streams and type-safe queries.

This reduces the need for custom APIs, server deployment, and manual sync logic. **This project does not use Firebase** — all backend features are implemented with Supabase.

---

## Responsive Design

The dashboard and related screens use `lib/utils/responsive.dart` to adapt layout for phones and tablets. See the responsive design section in earlier documentation for details on breakpoints and layout behavior.

---

## Android Emulator

To run on Android, start an emulator first (e.g. via Android Studio Device Manager), then run `flutter run`. If you see "Can't find service: activity/package", use `bash fix_emulator.sh` or cold boot the emulator.
