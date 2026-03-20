import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'routes/app_routes.dart';

/// Navigation Demo Application Entry Point.
/// 
/// This file demonstrates how to set up a Flutter app with named routes
/// and centralized route configuration. Run this file to see the
/// navigation demo in action.
/// 
/// To run this demo:
/// ```bash
/// flutter run -t lib/navigation_demo_app.dart
/// ```
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay styles for a polished look
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const NavigationDemoApp());
}

/// The main application widget demonstrating Flutter Navigation.
/// 
/// Key concepts demonstrated:
/// 1. **Named Routes**: All navigation uses route names instead of direct widget references
/// 2. **Centralized Configuration**: Routes are defined in AppRoutes class
/// 3. **Route Generator**: onGenerateRoute handles dynamic routes with arguments
/// 4. **Unknown Route Handler**: onUnknownRoute provides fallback for invalid routes
class NavigationDemoApp extends StatelessWidget {
  const NavigationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartQueue Navigation Demo',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
      ),
      
      // ═══════════════════════════════════════════════════════════════
      // NAVIGATION CONFIGURATION
      // ═══════════════════════════════════════════════════════════════
      
      /// Initial route when app starts
      /// This is the first screen users see
      initialRoute: AppRoutes.initialRoute,
      
      /// Static routes map for simple screens
      /// Use this for routes that don't need arguments
      routes: AppRoutes.routes,
      
      /// Dynamic route generator for screens with arguments
      /// This handles routes that need data passed to them
      onGenerateRoute: AppRoutes.onGenerateRoute,
      
      /// Fallback for unknown routes
      /// Shows error page if navigation fails
      onUnknownRoute: AppRoutes.onUnknownRoute,
      
      // ═══════════════════════════════════════════════════════════════
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════════════════
 * NAVIGATION CONCEPTS REFERENCE
 * ═══════════════════════════════════════════════════════════════════════════
 * 
 * 1. NAVIGATOR STACK
 *    - Flutter maintains a stack of routes (screens)
 *    - New screens are pushed onto the stack
 *    - Going back pops screens from the stack
 *    
 *    Stack visualization:
 *    ┌─────────────────┐
 *    │ Current Screen  │  ← Top of stack (visible)
 *    ├─────────────────┤
 *    │ Previous Screen │
 *    ├─────────────────┤
 *    │ Home Screen     │  ← Bottom of stack
 *    └─────────────────┘
 * 
 * 2. NAVIGATION METHODS
 * 
 *    Push (Add new screen):
 *    Navigator.pushNamed(context, '/route');
 *    Navigator.pushNamed(context, '/route', arguments: data);
 *    
 *    Pop (Go back):
 *    Navigator.pop(context);
 *    Navigator.pop(context, result);  // Return data
 *    
 *    Replace current screen:
 *    Navigator.pushReplacementNamed(context, '/route');
 *    
 *    Clear stack and push:
 *    Navigator.pushNamedAndRemoveUntil(context, '/route', (r) => false);
 *    
 *    Pop to specific screen:
 *    Navigator.popUntil(context, ModalRoute.withName('/route'));
 *    Navigator.popUntil(context, (route) => route.isFirst);
 * 
 * 3. RECEIVING ARGUMENTS
 *    
 *    In the destination screen:
 *    final args = ModalRoute.of(context)?.settings.arguments;
 * 
 * 4. RECEIVING RESULTS
 *    
 *    When pushing:
 *    final result = await Navigator.pushNamed(context, '/route');
 *    
 *    When popping:
 *    Navigator.pop(context, resultData);
 * 
 * ═══════════════════════════════════════════════════════════════════════════
 */
