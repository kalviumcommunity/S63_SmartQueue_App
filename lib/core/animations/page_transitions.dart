import 'package:flutter/material.dart';

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
        );
}

class FadeScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeInCubic,
            );

            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SharedAxisDirection direction;

  SharedAxisPageRoute({
    required this.page,
    this.direction = SharedAxisDirection.horizontal,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            final offsetTween = direction == SharedAxisDirection.horizontal
                ? Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
                : Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero);

            return SlideTransition(
              position: offsetTween.animate(curvedAnimation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}

enum SharedAxisDirection { horizontal, vertical }

class CircularRevealPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Offset? centerOffset;

  CircularRevealPageRoute({
    required this.page,
    this.centerOffset,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return AnimatedBuilder(
              animation: curvedAnimation,
              builder: (context, _) {
                return ClipPath(
                  clipper: _CircularRevealClipper(
                    fraction: curvedAnimation.value,
                    centerOffset: centerOffset,
                  ),
                  child: child,
                );
              },
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}

class _CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset? centerOffset;

  _CircularRevealClipper({
    required this.fraction,
    this.centerOffset,
  });

  @override
  Path getClip(Size size) {
    final center = centerOffset ?? Offset(size.width / 2, size.height / 2);
    final maxRadius = _calcMaxRadius(size, center);
    
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: maxRadius * fraction,
        ),
      );
  }

  double _calcMaxRadius(Size size, Offset center) {
    final dx = [center.dx, size.width - center.dx].reduce((a, b) => a > b ? a : b);
    final dy = [center.dy, size.height - center.dy].reduce((a, b) => a > b ? a : b);
    return (dx * dx + dy * dy).sqrt() as double;
  }

  @override
  bool shouldReclip(_CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}

extension _NumExtension on num {
  double sqrt() => this == 0 ? 0 : (this as double) > 0 ? (this as double).toDouble().sqrt() : 0;
}

extension DoubleExt on double {
  double sqrt() {
    if (this < 0) return 0;
    double x = this;
    double y = 1;
    const e = 0.000001;
    while (x - y > e) {
      x = (x + y) / 2;
      y = this / x;
    }
    return x;
  }
}
