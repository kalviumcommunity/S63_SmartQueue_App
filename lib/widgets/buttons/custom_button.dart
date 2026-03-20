import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// CustomButton - A highly configurable, reusable button widget.
///
/// This is a STATEFUL widget because it manages:
/// - Press animation state
/// - Loading state
/// - Hover/focus states
///
/// Features:
/// - Multiple variants (primary, secondary, outline, text)
/// - Configurable size (small, medium, large)
/// - Optional icon (leading or trailing)
/// - Loading state with spinner
/// - Disabled state
/// - Haptic feedback
/// - Press animation
class CustomButton extends StatefulWidget {
  /// Button text label
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant style
  final ButtonVariant variant;

  /// Button size
  final ButtonSize size;

  /// Optional leading icon
  final IconData? icon;

  /// Optional trailing icon
  final IconData? trailingIcon;

  /// Whether to show loading spinner
  final bool isLoading;

  /// Whether button is disabled
  final bool isDisabled;

  /// Custom background color (overrides variant)
  final Color? backgroundColor;

  /// Custom text/icon color (overrides variant)
  final Color? foregroundColor;

  /// Whether button takes full width
  final bool fullWidth;

  /// Custom border radius
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.fullWidth = false,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  // Animation state
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isDisabled && !widget.isLoading && widget.onPressed != null;
    final colors = _getColors();
    final dimensions = _getDimensions();

    Widget buttonChild = Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: dimensions.iconSize,
            height: dimensions.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, size: dimensions.iconSize, color: colors.foreground),
            SizedBox(width: dimensions.iconSpacing),
          ],
          Text(
            widget.label,
            style: TextStyle(
              color: colors.foreground,
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.trailingIcon != null) ...[
            SizedBox(width: dimensions.iconSpacing),
            Icon(widget.trailingIcon, size: dimensions.iconSize, color: colors.foreground),
          ],
        ],
      ],
    );

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: isEnabled ? _onTapDown : null,
        onTapUp: isEnabled ? _onTapUp : null,
        onTapCancel: isEnabled ? _onTapCancel : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          padding: dimensions.padding,
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? dimensions.borderRadius),
            border: widget.variant == ButtonVariant.outline
                ? Border.all(color: colors.border, width: 1.5)
                : null,
            boxShadow: widget.variant == ButtonVariant.primary && isEnabled
                ? [
                    BoxShadow(
                      color: colors.background.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: buttonChild,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  _ButtonColors _getColors() {
    final isEnabled = !widget.isDisabled && !widget.isLoading;

    if (!isEnabled) {
      return _ButtonColors(
        background: const Color(0xFFE2E8F0),
        foreground: const Color(0xFF94A3B8),
        border: const Color(0xFFE2E8F0),
      );
    }

    switch (widget.variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: widget.backgroundColor ?? const Color(0xFF6366F1),
          foreground: widget.foregroundColor ?? Colors.white,
          border: Colors.transparent,
        );
      case ButtonVariant.secondary:
        return _ButtonColors(
          background: widget.backgroundColor ?? const Color(0xFFEEF2FF),
          foreground: widget.foregroundColor ?? const Color(0xFF6366F1),
          border: Colors.transparent,
        );
      case ButtonVariant.outline:
        return _ButtonColors(
          background: _isPressed ? const Color(0xFFF1F5F9) : Colors.transparent,
          foreground: widget.foregroundColor ?? const Color(0xFF6366F1),
          border: widget.backgroundColor ?? const Color(0xFF6366F1),
        );
      case ButtonVariant.text:
        return _ButtonColors(
          background: _isPressed ? const Color(0xFFF1F5F9) : Colors.transparent,
          foreground: widget.foregroundColor ?? const Color(0xFF6366F1),
          border: Colors.transparent,
        );
      case ButtonVariant.danger:
        return _ButtonColors(
          background: widget.backgroundColor ?? const Color(0xFFEF4444),
          foreground: widget.foregroundColor ?? Colors.white,
          border: Colors.transparent,
        );
      case ButtonVariant.success:
        return _ButtonColors(
          background: widget.backgroundColor ?? const Color(0xFF10B981),
          foreground: widget.foregroundColor ?? Colors.white,
          border: Colors.transparent,
        );
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (widget.size) {
      case ButtonSize.small:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 12,
          iconSize: 14,
          iconSpacing: 6,
          borderRadius: 8,
        );
      case ButtonSize.medium:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          fontSize: 14,
          iconSize: 18,
          iconSpacing: 8,
          borderRadius: 10,
        );
      case ButtonSize.large:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 16,
          iconSize: 20,
          iconSpacing: 10,
          borderRadius: 12,
        );
    }
  }
}

enum ButtonVariant { primary, secondary, outline, text, danger, success }
enum ButtonSize { small, medium, large }

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

class _ButtonDimensions {
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double iconSpacing;
  final double borderRadius;

  _ButtonDimensions({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.iconSpacing,
    required this.borderRadius,
  });
}
