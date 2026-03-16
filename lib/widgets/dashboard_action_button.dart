import 'package:flutter/material.dart';

import '../utils/responsive.dart';

/// Reusable action button for the vendor dashboard.
class DashboardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const DashboardActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = Responsive.isTablet(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: isTablet ? 22 : 20,
          ),
          label: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: isTablet ? 16 : 14,
            ),
          ),
        ),
      ),
    );
  }
}
