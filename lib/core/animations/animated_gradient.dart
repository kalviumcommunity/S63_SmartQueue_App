import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final double intensity;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFA855F7),
      Color(0xFF6366F1),
    ],
    this.duration = const Duration(seconds: 8),
    this.intensity = 0.3,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(value * 2 * math.pi),
                math.sin(value * 2 * math.pi),
              ),
              end: Alignment(
                math.cos((value + 0.5) * 2 * math.pi),
                math.sin((value + 0.5) * 2 * math.pi),
              ),
              colors: widget.colors.map((c) => c.withValues(alpha: widget.intensity)).toList(),
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class MeshGradientBackground extends StatefulWidget {
  final Widget child;

  const MeshGradientBackground({super.key, required this.child});

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_controller1, _controller2, _controller3]),
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshGradientPainter(
            progress1: _controller1.value,
            progress2: _controller2.value,
            progress3: _controller3.value,
            isDark: isDark,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _MeshGradientPainter extends CustomPainter {
  final double progress1;
  final double progress2;
  final double progress3;
  final bool isDark;

  _MeshGradientPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = baseColor);

    final blob1Center = Offset(
      size.width * (0.3 + 0.2 * math.sin(progress1 * 2 * math.pi)),
      size.height * (0.2 + 0.15 * math.cos(progress1 * 2 * math.pi)),
    );
    
    final blob2Center = Offset(
      size.width * (0.7 + 0.2 * math.cos(progress2 * 2 * math.pi)),
      size.height * (0.6 + 0.2 * math.sin(progress2 * 2 * math.pi)),
    );
    
    final blob3Center = Offset(
      size.width * (0.5 + 0.25 * math.sin(progress3 * 2 * math.pi)),
      size.height * (0.8 + 0.1 * math.cos(progress3 * 2 * math.pi)),
    );

    _drawBlob(
      canvas,
      blob1Center,
      size.width * 0.6,
      isDark ? const Color(0xFF6366F1).withValues(alpha: 0.15) : const Color(0xFF6366F1).withValues(alpha: 0.08),
    );
    
    _drawBlob(
      canvas,
      blob2Center,
      size.width * 0.5,
      isDark ? const Color(0xFF8B5CF6).withValues(alpha: 0.12) : const Color(0xFF8B5CF6).withValues(alpha: 0.06),
    );
    
    _drawBlob(
      canvas,
      blob3Center,
      size.width * 0.7,
      isDark ? const Color(0xFF06B6D4).withValues(alpha: 0.1) : const Color(0xFF06B6D4).withValues(alpha: 0.05),
    );
  }

  void _drawBlob(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_MeshGradientPainter oldDelegate) {
    return oldDelegate.progress1 != progress1 ||
        oldDelegate.progress2 != progress2 ||
        oldDelegate.progress3 != progress3 ||
        oldDelegate.isDark != isDark;
  }
}
