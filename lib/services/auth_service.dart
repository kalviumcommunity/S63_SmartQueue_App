import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  Session? get currentSession => _client.auth.currentSession;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      // Optional: set a redirect URL for email confirmation if needed.
      // emailRedirectTo: 'io.supabase.flutter://login-callback/',
    );

    if (response.user == null) {
      throw AuthException('Signup failed. Please try again.');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

