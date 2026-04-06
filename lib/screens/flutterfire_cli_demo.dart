import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../services/firebase_app.dart';

/// Demonstrates that Firebase was wired using FlutterFire-style configuration.
///
/// The [DefaultFirebaseOptions] class in `lib/firebase_options.dart` is normally
/// produced by running `flutterfire configure`. This screen confirms that
/// `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
/// completed successfully at startup.
class FlutterfireCliDemoScreen extends StatelessWidget {
  const FlutterfireCliDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ok = FirebaseAppService.isInitialized;
    FirebaseApp? app;
    try {
      if (ok) app = Firebase.app();
    } catch (_) {}

    final androidOpts = DefaultFirebaseOptions.android;
    final projectId = app?.options.projectId ?? androidOpts.projectId;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('FlutterFire CLI setup'),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SuccessBanner(connected: ok),
              const SizedBox(height: 20),
              if (ok) ...[
                const _CliCommandCard(),
                const SizedBox(height: 16),
                _GeneratedFileCard(projectId: projectId),
                const SizedBox(height: 16),
                const _FutureServicesCard(),
              ] else ...[
                const _FailureHint(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: connected
              ? [const Color(0xFF7C3AED), const Color(0xFF6366F1)]
              : [const Color(0xFFDC2626), const Color(0xFFB91C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (connected ? const Color(0xFF7C3AED) : const Color(0xFFDC2626))
                .withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            connected ? Icons.terminal_rounded : Icons.warning_amber_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            connected
                ? 'FlutterFire-style config is active'
                : 'Firebase did not initialize',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            connected
                ? 'SmartQueue loaded Firebase using lib/firebase_options.dart before the UI.'
                : 'Run flutterfire configure or fix google-services.json, then restart.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Simulated terminal steps (documentation only; commands are not executed here).
class _CliCommandCard extends StatelessWidget {
  const _CliCommandCard();

  @override
  Widget build(BuildContext context) {
    const lines = [
      r'# 1) Firebase CLI (requires Node.js)',
      r'npm install -g firebase-tools',
      r'firebase login',
      r'',
      r'# 2) FlutterFire CLI',
      r'dart pub global activate flutterfire_cli',
      r'',
      r'# 3) From your Flutter project root',
      r'flutterfire configure',
      r'# → pick project, platforms, generates lib/firebase_options.dart',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, color: Color(0xFFA78BFA), size: 20),
              SizedBox(width: 8),
              Text(
                'Typical FlutterFire CLI flow',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            lines.join('\n'),
            style: const TextStyle(
              color: Color(0xFF86EFAC),
              fontSize: 11.5,
              height: 1.45,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratedFileCard extends StatelessWidget {
  const _GeneratedFileCard({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.folder_special_rounded, color: Color(0xFF7C3AED)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Generated configuration',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'flutterfire configure writes (or updates) lib/firebase_options.dart with a DefaultFirebaseOptions class for each selected platform.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _monoRow('lib/firebase_options.dart'),
          const SizedBox(height: 8),
          _monoRow('Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)'),
          const SizedBox(height: 14),
          Text(
            'Project ID (from options): $projectId',
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _monoRow(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
          color: Color(0xFF4338CA),
        ),
      ),
    );
  }
}

class _FutureServicesCard extends StatelessWidget {
  const _FutureServicesCard();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Authentication', Icons.lock_person_rounded, 'Email, phone, OAuth'),
      ('Cloud Firestore', Icons.storage_rounded, 'Realtime documents & queries'),
      ('Analytics', Icons.analytics_rounded, 'Usage and funnels'),
      ('Cloud Messaging', Icons.notifications_active_rounded, 'Push notifications'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC4B5FD).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ready for Firebase products (not enabled in this demo)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C1D95),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Once Core is initialized, you can add packages and enable services in the Firebase Console.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.purple.shade900.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(e.$2, color: const Color(0xFF7C3AED), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.$1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          e.$3,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureHint extends StatelessWidget {
  const _FailureHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fix setup, then re-run',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF991B1B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '1. Ensure you are on a supported platform (this repo targets Android in firebase_options.dart).\n'
            '2. Run flutterfire configure from the project root after firebase login.\n'
            '3. Confirm android/app/google-services.json matches your Firebase Android app.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
