import 'package:flutter/material.dart';

import '../widgets/primary_button.dart';
import 'firebase_connection_demo.dart';
import 'flutterfire_cli_demo.dart';
import 'responsive_home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isReadyMode = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = _isReadyMode ? colorScheme.primary : colorScheme.tertiary;
    final message = _isReadyMode
        ? 'Ready to manage orders faster.'
        : 'Tap the button to see reactive UI in action.';

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartQueue'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: accentColor.withValues(alpha: 0.35)),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 56,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _isReadyMode ? 'Back to intro' : 'Toggle ready mode',
                  onPressed: () {
                    setState(() {
                      _isReadyMode = !_isReadyMode;
                    });
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ResponsiveHomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.dashboard_rounded),
                  label: const Text('Go to Dashboard'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FirebaseConnectionDemoScreen(),
                      ),
                    );
                  },
                  child: const Text('Firebase connection status'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const FlutterfireCliDemoScreen(),
                      ),
                    );
                  },
                  child: const Text('FlutterFire CLI demo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

