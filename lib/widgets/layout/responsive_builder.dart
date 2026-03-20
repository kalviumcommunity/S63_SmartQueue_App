import 'package:flutter/material.dart';

/// Screen size breakpoints for responsive design.
class ScreenBreakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Enum representing device type based on screen width.
enum DeviceType { phone, tablet, desktop }

/// Extension to easily determine device type from screen width.
extension DeviceTypeExtension on double {
  DeviceType get deviceType {
    if (this < ScreenBreakpoints.phone) return DeviceType.phone;
    if (this < ScreenBreakpoints.tablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  bool get isPhone => this < ScreenBreakpoints.phone;
  bool get isTablet => this >= ScreenBreakpoints.phone && this < ScreenBreakpoints.tablet;
  bool get isDesktop => this >= ScreenBreakpoints.tablet;
  bool get isWideScreen => this >= ScreenBreakpoints.phone;
}

/// ResponsiveBuilder - A widget that builds different layouts based on screen size.
///
/// This widget uses LayoutBuilder to determine the available width and
/// builds the appropriate layout for phone, tablet, or desktop.
///
/// Example usage:
/// ```dart
/// ResponsiveBuilder(
///   phone: (context, constraints) => PhoneLayout(),
///   tablet: (context, constraints) => TabletLayout(),
///   desktop: (context, constraints) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for phone-sized screens (< 600px)
  final Widget Function(BuildContext context, BoxConstraints constraints) phone;

  /// Builder for tablet-sized screens (600px - 900px)
  /// Falls back to phone if not provided.
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;

  /// Builder for desktop-sized screens (> 900px)
  /// Falls back to tablet, then phone if not provided.
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= ScreenBreakpoints.tablet) {
          return (desktop ?? tablet ?? phone)(context, constraints);
        } else if (width >= ScreenBreakpoints.phone) {
          return (tablet ?? phone)(context, constraints);
        } else {
          return phone(context, constraints);
        }
      },
    );
  }
}

/// ResponsiveValue - Returns different values based on screen size.
///
/// Example usage:
/// ```dart
/// ResponsiveValue<double>(
///   context: context,
///   phone: 16.0,
///   tablet: 24.0,
///   desktop: 32.0,
/// ).value
/// ```
class ResponsiveValue<T> {
  final BuildContext context;
  final T phone;
  final T? tablet;
  final T? desktop;

  ResponsiveValue({
    required this.context,
    required this.phone,
    this.tablet,
    this.desktop,
  });

  T get value {
    final width = MediaQuery.of(context).size.width;

    if (width >= ScreenBreakpoints.tablet) {
      return desktop ?? tablet ?? phone;
    } else if (width >= ScreenBreakpoints.phone) {
      return tablet ?? phone;
    }
    return phone;
  }
}

/// ResponsivePadding - Provides responsive padding values.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? phonePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.phonePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  static const EdgeInsets defaultPhone = EdgeInsets.all(16);
  static const EdgeInsets defaultTablet = EdgeInsets.all(24);
  static const EdgeInsets defaultDesktop = EdgeInsets.all(32);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      phone: (context, constraints) => Padding(
        padding: phonePadding ?? defaultPhone,
        child: child,
      ),
      tablet: (context, constraints) => Padding(
        padding: tabletPadding ?? defaultTablet,
        child: child,
      ),
      desktop: (context, constraints) => Padding(
        padding: desktopPadding ?? defaultDesktop,
        child: child,
      ),
    );
  }
}

/// ResponsiveRowColumn - Switches between Row and Column based on screen size.
///
/// On wider screens (tablet+), children are arranged horizontally.
/// On narrower screens (phone), children are arranged vertically.
class ResponsiveRowColumn extends StatelessWidget {
  /// Children widgets to arrange.
  final List<Widget> children;

  /// Spacing between children.
  final double spacing;

  /// Whether to use Row on wide screens (default: true).
  final bool rowOnWideScreen;

  /// Cross axis alignment for Row mode.
  final CrossAxisAlignment rowCrossAxisAlignment;

  /// Main axis alignment for Row mode.
  final MainAxisAlignment rowMainAxisAlignment;

  /// Cross axis alignment for Column mode.
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// Main axis alignment for Column mode.
  final MainAxisAlignment columnMainAxisAlignment;

  /// Breakpoint for switching between Row and Column.
  final double breakpoint;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.spacing = 16,
    this.rowOnWideScreen = true,
    this.rowCrossAxisAlignment = CrossAxisAlignment.start,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRow = rowOnWideScreen && constraints.maxWidth >= breakpoint;

        if (useRow) {
          // Build Row with Expanded children
          return Row(
            crossAxisAlignment: rowCrossAxisAlignment,
            mainAxisAlignment: rowMainAxisAlignment,
            children: _buildChildrenWithSpacing(isRow: true),
          );
        } else {
          // Build Column with full-width children
          return Column(
            crossAxisAlignment: columnCrossAxisAlignment,
            mainAxisAlignment: columnMainAxisAlignment,
            children: _buildChildrenWithSpacing(isRow: false),
          );
        }
      },
    );
  }

  List<Widget> _buildChildrenWithSpacing({required bool isRow}) {
    final List<Widget> spacedChildren = [];

    for (int i = 0; i < children.length; i++) {
      if (isRow) {
        spacedChildren.add(Expanded(child: children[i]));
      } else {
        spacedChildren.add(children[i]);
      }

      // Add spacing between items (not after the last one)
      if (i < children.length - 1) {
        spacedChildren.add(
          isRow ? SizedBox(width: spacing) : SizedBox(height: spacing),
        );
      }
    }

    return spacedChildren;
  }
}

/// ResponsiveGrid - Creates a responsive grid layout.
///
/// Adjusts column count based on screen width.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int phoneColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.phoneColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns;

        if (width >= ScreenBreakpoints.tablet) {
          columns = desktopColumns;
        } else if (width >= ScreenBreakpoints.phone) {
          columns = tabletColumns;
        } else {
          columns = phoneColumns;
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            final itemWidth = (width - (spacing * (columns - 1))) / columns;
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
