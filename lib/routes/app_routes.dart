import 'package:flutter/material.dart';

import '../screens/navigation/home_screen.dart';
import '../screens/navigation/order_details_screen.dart';
import '../screens/navigation/queue_screen.dart';
import '../screens/navigation/settings_screen.dart';
import '../screens/navigation/statistics_screen.dart';
import '../screens/navigation/add_order_screen.dart';

/// AppRoutes - Centralized route configuration for the SmartQueue app.
/// 
/// This class defines all named routes and provides the route generator
/// for the application. Using named routes provides several benefits:
/// 
/// 1. **Centralized Configuration**: All routes are defined in one place
/// 2. **Type Safety**: Route names are defined as constants
/// 3. **Easy Refactoring**: Changing a screen only requires updating one location
/// 4. **Deep Linking Ready**: Named routes make deep linking easier to implement
/// 5. **Better Testing**: Routes can be tested independently
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route name constants - use these instead of string literals
  static const String navigationHome = '/navigation-home';
  static const String orderDetails = '/order-details';
  static const String queue = '/queue';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String addOrder = '/add-order';

  /// Initial route when the app starts
  static const String initialRoute = navigationHome;

  /// Map of all routes in the application.
  /// 
  /// This map is used by MaterialApp's `routes` parameter for simple
  /// routes that don't require arguments.
  static Map<String, WidgetBuilder> get routes {
    return {
      navigationHome: (context) => const NavigationHomeScreen(),
      queue: (context) => const QueueScreen(),
      settings: (context) => const SettingsScreen(),
      statistics: (context) => const StatisticsScreen(),
      addOrder: (context) => const AddOrderScreen(),
    };
  }

  /// Route generator for handling routes with arguments.
  /// 
  /// This method is used by MaterialApp's `onGenerateRoute` parameter
  /// and allows us to pass arguments to screens.
  /// 
  /// Usage:
  /// ```dart
  /// MaterialApp(
  ///   onGenerateRoute: AppRoutes.onGenerateRoute,
  ///   initialRoute: AppRoutes.initialRoute,
  /// );
  /// ```
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case navigationHome:
        return MaterialPageRoute(
          builder: (_) => const NavigationHomeScreen(),
          settings: settings,
        );
        
      case orderDetails:
        // OrderDetailsScreen expects order data as arguments
        return MaterialPageRoute(
          builder: (_) => const OrderDetailsScreen(),
          settings: settings,
        );
        
      case queue:
        return MaterialPageRoute(
          builder: (_) => const QueueScreen(),
          settings: settings,
        );
        
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
        
      case statistics:
        return MaterialPageRoute(
          builder: (_) => const StatisticsScreen(),
          settings: settings,
        );
        
      case addOrder:
        return MaterialPageRoute(
          builder: (_) => const AddOrderScreen(),
          settings: settings,
        );
        
      default:
        // Return null for unknown routes - MaterialApp will show error
        return null;
    }
  }

  /// Unknown route handler - shown when navigation fails.
  /// 
  /// This is used by MaterialApp's `onUnknownRoute` parameter.
  static Route<dynamic> onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Route not found: ${routeSettings.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    navigationHome,
                    (route) => false,
                  );
                },
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension methods for easier navigation.
/// 
/// Usage:
/// ```dart
/// context.navigateTo('/order-details', arguments: orderData);
/// context.navigateBack();
/// context.navigateAndReplace('/queue');
/// ```
extension NavigationExtensions on BuildContext {
  /// Navigate to a named route
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }
  
  /// Navigate back to the previous screen
  void navigateBack<T>([T? result]) {
    Navigator.pop<T>(this, result);
  }
  
  /// Replace current screen with a new route
  Future<T?> navigateAndReplace<T>(String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, dynamic>(
      this,
      routeName,
      arguments: arguments,
    );
  }
  
  /// Navigate to route and remove all previous routes
  Future<T?> navigateAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      this,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  /// Pop until reaching a specific route
  void popUntilRoute(String routeName) {
    Navigator.popUntil(this, ModalRoute.withName(routeName));
  }
  
  /// Pop to the first route (home)
  void popToFirst() {
    Navigator.popUntil(this, (route) => route.isFirst);
  }
}
