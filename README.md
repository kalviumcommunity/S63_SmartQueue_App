## Supabase Integration Overview

This Flutter application has been transformed into a real-time, Supabase-powered app that demonstrates:

- Email/password authentication using Supabase Auth
- Real-time task updates from a PostgreSQL `tasks` table
- Clean, modular architecture suitable for scaling

### Why Supabase instead of Firebase

- **SQL Database (PostgreSQL)**: Supabase uses PostgreSQL, which provides powerful relational data modeling, joins, and SQL tooling. This is often a better fit for production systems than a purely document-based store.
- **Integrated Auth + Database**: Auth and database are tightly integrated with row-level security (RLS), making it straightforward to enforce per-user access rules.
- **First-class real-time**: Supabase streams database changes over websockets, making it easy to build reactive UIs without custom sync logic.
- **Open source & self-hostable**: Supabase can be self-hosted or used as a managed service, giving flexibility over cost and deployment.

### How Supabase is connected to Flutter

1. **Dependency**  
   The `supabase_flutter` package is added in `pubspec.yaml`:

   ```yaml
   dependencies:
     supabase_flutter: ^2.6.0
   ```

2. **Configuration**  
   The Supabase project URL and anon key are defined in `lib/config/supabase_config.dart`:

   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'https://YOUR-PROJECT-URL.supabase.co';
     static const String supabaseAnonKey = 'YOUR-ANON-KEY';
   }
   ```

   Replace these placeholders with your actual Supabase project URL and anon key from the Supabase dashboard.

3. **Initialization on app start**  
   In `lib/services/supabase_client.dart`, a small wrapper initializes Supabase:

   ```dart
   class SupabaseService {
     static SupabaseClient get client => Supabase.instance.client;

     static Future<void> initialize() async {
       await Supabase.initialize(
         url: SupabaseConfig.supabaseUrl,
         anonKey: SupabaseConfig.supabaseAnonKey,
       );
     }
   }
   ```

   The `main` function ensures Supabase is ready before `runApp` in `lib/main.dart`:

   ```dart
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await SupabaseService.initialize();
     runApp(const SmartQueueApp());
   }
   ```

### How authentication is handled

- **Service layer**: `lib/services/auth_service.dart` wraps Supabase Auth and exposes:
  - `signUp(email, password)`
  - `signIn(email, password)`
  - `signOut()`
  - `authStateChanges` (stream of auth state changes)
  - `currentSession`

- **UI flow**:
  - `SmartQueueApp` (`lib/main.dart`) listens to `authStateChanges`. If there is **no** active session, it shows `AuthScreen`. If there **is** a session, it shows `TaskScreen`.
  - `AuthScreen` (`lib/screens/auth_screen.dart`) provides:
    - Email/password text fields
    - Toggle between **Login** and **Sign Up**
    - Error messages when auth fails (e.g., invalid credentials, network errors)
    - Loading indicators during requests

- **Session persistence**:
  - The Supabase Flutter SDK automatically persists and restores sessions. When the app restarts, `currentSession` will be non-null if the user was previously logged in and the session is still valid.

### Database and real-time synchronization

- **Assumed table**: A PostgreSQL table named `tasks` exists in Supabase, with at least:
  - `id` (primary key, integer)
  - `title` (text)
  - `created_at` (timestamp with time zone, default `now()`)
  - `user_id` (UUID, references `auth.users.id`, optional but recommended)

- **Model**: `lib/models/task.dart` defines a `Task` model with helpers to:
  - Parse from a Supabase row (`fromMap`)
  - Build maps for insert operations (`toInsertMap`)

- **Service layer**: `lib/services/task_service.dart` encapsulates database logic:
  - `addTask(String title)` inserts a new task associated with the authenticated `user_id`
  - `tasksStream()` returns a `Stream<List<Task>>` using:

    ```dart
    _client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .order('created_at')
    ```

    This stream emits an updated list whenever rows are inserted/updated/deleted, giving **real-time** behavior.

  - `fetchTasks()` can be used for one-time loads if needed.

- **Real-time UI**:
  - `TaskScreen` (`lib/screens/task_screen.dart`) uses a `StreamBuilder<List<Task>>` around `tasksStream()` to rebuild the task list automatically whenever Supabase emits changes.
  - No manual refresh is needed—the list updates in real time as new tasks are inserted.

### UI demonstration

- **Authentication UI (`AuthScreen`)**:
  - Email and password form with validation
  - Toggle between Login and Sign Up modes
  - Error messages displayed in a friendly way
  - Loading spinners during network calls

- **Tasks UI (`TaskScreen`)**:
  - `TaskInput` (`lib/widgets/task_input.dart`):
    - Text field to enter a task title
    - Button to submit
    - Inline error messages if task creation fails
  - `TaskList` (`lib/widgets/task_list.dart`):
    - `ListView` displaying tasks
    - Shows creation time and message when there are no tasks
  - Logout button in the AppBar to sign the user out.

### Project structure and maintainability

- **Config**
  - `lib/config/supabase_config.dart` – central place for Supabase URL and key.
- **Services**
  - `lib/services/supabase_client.dart` – initialization and client access.
  - `lib/services/auth_service.dart` – authentication API wrapper.
  - `lib/services/task_service.dart` – database and real-time tasks logic.
- **Models**
  - `lib/models/task.dart` – `Task` data structure and mapping helpers.
- **Screens**
  - `lib/screens/auth_screen.dart` – login/signup screen.
  - `lib/screens/task_screen.dart` – authenticated task list with real-time updates.
- **Widgets**
  - `lib/widgets/task_input.dart` – reusable input + submit widget.
  - `lib/widgets/task_list.dart` – reusable tasks list widget.

This separation keeps concerns clear, makes the codebase easier to extend (for example, adding more tables or features), and aligns with clean architecture principles in Flutter.
