import 'package:flutter/material.dart';

/// Responsive breakpoints and layout helpers for SmartQueue.
class Responsive {
  static const double _tabletBreakpoint = 600;
  static const double _largeTabletBreakpoint = 900;

  /// True if width indicates a phone (narrow) layout.
  static bool isPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide < _tabletBreakpoint;
  }

  /// True if width indicates a tablet layout.
  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= _tabletBreakpoint;
  }

  /// True if width indicates a large tablet or desktop.
  static bool isLargeTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide >= _largeTabletBreakpoint;
  }

  /// Current orientation.
  static bool isPortrait(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.portrait;
  }

  /// Number of columns for grid based on device size.
  static int gridColumns(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    if (shortestSide >= _largeTabletBreakpoint) return 4;
    if (shortestSide >= _tabletBreakpoint) return 2;
    return 1;
  }

  /// Adaptive padding based on screen size.
  static double padding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= _largeTabletBreakpoint) return 24;
    if (width >= _tabletBreakpoint) return 20;
    return 16;
  }

  /// Adaptive spacing between sections.
  static double sectionSpacing(BuildContext context) {
    return isTablet(context) ? 24 : 16;
  }
}
