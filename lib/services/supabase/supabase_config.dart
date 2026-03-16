/// Supabase configuration loaded at build time via `--dart-define`.
///
/// Example:
/// flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class SupabaseConfig {
  static const String url = String.fromEnvironment('https://snkcpdaeuirmikpjgioq.supabase.co');
  static const String anonKey = String.fromEnvironment('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNua2NwZGFldWlybWlrcGpnaW9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2MzU4MzIsImV4cCI6MjA4OTIxMTgzMn0.N4KRIup0FvuW84hY6WnS-1dpSijNkCJbtltN0Q3pH1k');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}

