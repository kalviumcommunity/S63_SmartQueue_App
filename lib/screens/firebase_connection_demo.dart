import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';
import '../services/firebase_app.dart';

/// Confirms that Firebase Core initialized and shows basic project metadata.
///
/// Open from the login screen (when Firebase started successfully) or from
/// the welcome screen path documented in README when initialization failed.
class FirebaseConnectionDemoScreen extends StatelessWidget {
  const FirebaseConnectionDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final connected = FirebaseAppService.isInitialized;
    FirebaseApp? app;
    try {
      if (connected) {
        app = Firebase.app();
      }
    } catch (_) {
      // Defensive: should not happen if isInitialized is true
    }

    final options = DefaultFirebaseOptions.android;
    final projectId = app?.options.projectId ?? options.projectId;
    final appId = app?.options.appId ?? options.appId;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Firebase connection'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusHeader(connected: connected),
              const SizedBox(height: 24),
              if (connected) ...[
                _InfoCard(
                  icon: Icons.cloud_done_rounded,
                  title: 'SmartQueue connected to Firebase successfully',
                  subtitle:
                      'Firebase Core is initialized and ready. You can extend the app with Authentication, Firestore, and Storage.',
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _DetailTile(
                  label: 'Project ID',
                  value: projectId,
                ),
                _DetailTile(
                  label: 'App ID',
                  value: appId,
                  dense: true,
                ),
              ] else ...[
                _InfoCard(
                  icon: Icons.cloud_off_rounded,
                  title: 'Firebase not initialized',
                  subtitle:
                      'Check google-services.json, firebase_options.dart, and pubspec assets. See README Firebase section.',
                  color: const Color(0xFFEF4444),
                ),
              ],
              const SizedBox(height: 28),
              const _NextStepsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: connected
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (connected ? const Color(0xFF10B981) : const Color(0xFFEF4444))
                .withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            connected ? Icons.verified_rounded : Icons.error_outline_rounded,
            size: 56,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            connected ? 'Connection successful' : 'Connection unavailable',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            connected
                ? 'Firebase Core is ready before the UI loads.'
                : 'The app fell back to offline welcome mode.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.label,
    required this.value,
    this.dense = false,
  });

  final String label;
  final String value;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: dense ? 11 : 14,
              fontFamily: dense ? 'monospace' : null,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.route_rounded, color: Color(0xFF818CF8), size: 22),
              SizedBox(width: 10),
              Text(
                'Next steps (future work)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _bullet('Enable Email/Password in Firebase Authentication'),
          _bullet('Create Firestore database rules for orders and queue'),
          _bullet('Optional: Firebase Storage for receipts or images'),
        ],
      ),
    );
  }

  static Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF94A3B8))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
