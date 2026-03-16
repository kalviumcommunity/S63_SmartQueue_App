/// Supabase configuration. Uses `--dart-define` at runtime, or dev defaults
/// for local testing. For production, use dart-define and do not commit keys.
///
/// flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
class SupabaseConfig {
  static const String _devUrl = 'https://snkcpdaeuirmikpjgioq.supabase.co';
  static const String _devKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNua2NwZGFldWlybWlrcGpnaW9xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2MzU4MzIsImV4cCI6MjA4OTIxMTgzMn0.N4KRIup0FvuW84hY6WnS-1dpSijNkCJbtltN0Q3pH1k';

  static String get url =>
      String.fromEnvironment('SUPABASE_URL', defaultValue: _devUrl);
  static String get anonKey =>
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: _devKey);

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  /// URL to open Supabase SQL Editor for table setup.
  static String get setupSqlEditorUrl {
    final uri = Uri.tryParse(url);
    final ref = uri?.host.split('.').first ?? 'project';
    return 'https://supabase.com/dashboard/project/$ref/sql/new';
  }
}

