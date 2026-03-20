import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'screens/advanced/login_screen_v2.dart';
import 'screens/advanced/vendor_dashboard_v2.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/firebase_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Enable edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  final firebaseReady = await FirebaseAppService.initialize();
  final themeProvider = ThemeProvider();
  
  runApp(SmartQueueApp(
    firebaseReady: firebaseReady,
    themeProvider: themeProvider,
  ));
}

class SmartQueueApp extends StatefulWidget {
  final bool firebaseReady;
  final ThemeProvider themeProvider;

  const SmartQueueApp({
    super.key,
    required this.firebaseReady,
    required this.themeProvider,
  });

  @override
  State<SmartQueueApp> createState() => _SmartQueueAppState();
}

class _SmartQueueAppState extends State<SmartQueueApp> {
  @override
  void initState() {
    super.initState();
    widget.themeProvider.addListener(_onThemeChange);
  }

  @override
  void dispose() {
    widget.themeProvider.removeListener(_onThemeChange);
    super.dispose();
  }

  void _onThemeChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartQueue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: widget.themeProvider.themeMode,
      home: widget.firebaseReady ? const _AuthGate() : const WelcomeScreen(),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          return const VendorDashboardV2();
        }
        return const LoginScreenV2();
      },
    );
  }
}
