import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase/supabase_config.dart';

class SupabaseService {
  static bool _initialized = false;

  static SupabaseClient get client {
    if (!_initialized) {
      throw StateError(
        'Supabase is not initialized. Configure SUPABASE_URL and SUPABASE_ANON_KEY '
        'and call SupabaseService.initializeIfConfigured() before using services.',
      );
    }
    return Supabase.instance.client;
  }

  /// Initializes Supabase only when configuration is provided.
  ///
  /// Returns `true` when Supabase was initialized, otherwise `false`.
  static Future<bool> initializeIfConfigured() async {
    if (_initialized) return true;
    if (!SupabaseConfig.isConfigured) return false;

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _initialized = true;
    return true;
  }
}

