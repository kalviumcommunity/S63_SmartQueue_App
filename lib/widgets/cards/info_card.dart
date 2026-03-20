import 'package:flutter/material.dart';

/// InfoCard - A reusable card widget for displaying information.
///
/// This is a STATELESS widget because:
/// - It only displays data passed to it
/// - It has no internal mutable state
/// - All interactivity is handled via callbacks
///
/// Features:
/// - Configurable title, subtitle, and value
/// - Optional icon with customizable color
/// - Optional trailing widget
/// - Support for tap actions
/// - Multiple variants (default, highlighted, outlined)
/// - Consistent styling across the app
class InfoCard extends StatelessWidget {
  /// Main title text
  final String title;

  /// Optional subtitle/description
  final String? subtitle;

  /// Optional value to display prominently
  final String? value;

  /// Optional leading icon
  final IconData? icon;

  /// Icon color (defaults to primary)
  final Color? iconColor;

  /// Background color of icon container
  final Color? iconBackgroundColor;

  /// Card variant style
  final CardVariant variant;

  /// Optional trailing widget (e.g., button, badge)
  final Widget? trailing;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom border color for outlined variant
  final Color? borderColor;

  /// Whether to show shadow
  final bool showShadow;

  /// Custom padding
  final EdgeInsets? padding;

  /// Custom border radius
  final double borderRadius;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.variant = CardVariant.defaultCard,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.showShadow = true,
    this.padding,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getBackgroundColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: _getBorder(),
            boxShadow: showShadow && variant != CardVariant.outlined
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Leading Icon
              if (icon != null) ...[
                _buildIconContainer(),
                const SizedBox(width: 14),
              ],

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: _getTitleColor(),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (value != null)
                          Text(
                            value!,
                            style: TextStyle(
                              color: _getValueColor(),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    // Subtitle
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: _getSubtitleColor(),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing Widget
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: _getSubtitleColor(),
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    final effectiveIconColor = iconColor ?? _getIconColor();
    final effectiveBgColor = iconBackgroundColor ?? effectiveIconColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: effectiveIconColor,
        size: 22,
      ),
    );
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case CardVariant.defaultCard:
        return Colors.white;
      case CardVariant.highlighted:
        return const Color(0xFF6366F1);
      case CardVariant.outlined:
        return Colors.white;
      case CardVariant.subtle:
        return const Color(0xFFF8FAFC);
    }
  }

  Border? _getBorder() {
    if (variant == CardVariant.outlined) {
      return Border.all(
        color: borderColor ?? const Color(0xFFE2E8F0),
        width: 1,
      );
    }
    return null;
  }

  Color _getTitleColor() {
    switch (variant) {
      case CardVariant.highlighted:
        return Colors.white;
      default:
        return const Color(0xFF1E293B);
    }
  }

  Color _getSubtitleColor() {
    switch (variant) {
      case CardVariant.highlighted:
        return Colors.white.withValues(alpha: 0.8);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getValueColor() {
    switch (variant) {
      case CardVariant.highlighted:
        return Colors.white;
      default:
        return const Color(0xFF1E293B);
    }
  }

  Color _getIconColor() {
    switch (variant) {
      case CardVariant.highlighted:
        return Colors.white;
      default:
        return const Color(0xFF6366F1);
    }
  }
}

enum CardVariant { defaultCard, highlighted, outlined, subtle }
