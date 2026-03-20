import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: shadows ?? [
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.white.withValues(alpha: opacity * 0.8),
                        Colors.white.withValues(alpha: opacity * 0.4),
                      ]
                    : [
                        Colors.white.withValues(alpha: opacity * 3),
                        Colors.white.withValues(alpha: opacity * 2),
                      ],
              ),
              borderRadius: borderRadius,
              border: Border.all(
                color: borderColor ?? 
                    (isDark 
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.8)),
                width: borderWidth,
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double depth;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool isPressed;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.depth = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.margin,
    this.color,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color ?? 
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9));
    
    final lightShadow = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;
    final darkShadow = isDark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.15);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: margin,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: borderRadius,
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: darkShadow,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: lightShadow,
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: lightShadow,
                  offset: Offset(-depth, -depth),
                  blurRadius: depth * 2,
                ),
                BoxShadow(
                  color: darkShadow,
                  offset: Offset(depth, depth),
                  blurRadius: depth * 2,
                ),
              ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class AnimatedPressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final List<BoxShadow>? shadows;
  final Duration animationDuration;
  final double pressScale;

  const AnimatedPressableCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.margin,
    this.color,
    this.shadows,
    this.animationDuration = const Duration(milliseconds: 150),
    this.pressScale = 0.97,
  });

  @override
  State<AnimatedPressableCard> createState() => _AnimatedPressableCardState();
}

class _AnimatedPressableCardState extends State<AnimatedPressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = widget.color ??
        (isDark ? const Color(0xFF1E293B) : Colors.white);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: widget.margin,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: widget.borderRadius,
                boxShadow: widget.shadows?.map((shadow) {
                      return BoxShadow(
                        color: shadow.color,
                        offset: shadow.offset * _elevationAnimation.value,
                        blurRadius: shadow.blurRadius * _elevationAnimation.value,
                        spreadRadius: shadow.spreadRadius * _elevationAnimation.value,
                      );
                    }).toList() ??
                    [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.08),
                        offset: Offset(0, 8 * _elevationAnimation.value),
                        blurRadius: 24 * _elevationAnimation.value,
                      ),
                    ],
              ),
              padding: widget.padding,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
