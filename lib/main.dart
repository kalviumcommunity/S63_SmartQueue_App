import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/vendor_dashboard_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabaseReady = await SupabaseService.initializeIfConfigured();
  runApp(SmartQueueApp(supabaseReady: supabaseReady));
}

class SmartQueueApp extends StatelessWidget {
  final bool supabaseReady;

  const SmartQueueApp({super.key, required this.supabaseReady});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: supabaseReady ? _AuthGate() : const WelcomeScreen(),
    );
  }
}

/// Shows login when not authenticated, dashboard when authenticated.
/// Session persistence is handled automatically by Supabase.
class _AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<AuthState>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = authService.currentSession;
        if (session != null) {
          return const VendorDashboardScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
