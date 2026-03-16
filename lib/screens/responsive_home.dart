import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../widgets/dashboard_action_button.dart';
import '../widgets/order_card.dart';

/// Main dashboard screen for SmartQueue vendors. Adapts layout for phones
/// and tablets in both portrait and landscape orientations.
class ResponsiveHomeScreen extends StatelessWidget {
  const ResponsiveHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.padding(context);
    final sectionSpacing = Responsive.sectionSpacing(context);
    final columns = Responsive.gridColumns(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _DashboardHeader(
                padding: padding,
                sectionSpacing: sectionSpacing,
              ),
            ),
            // Order cards content
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: _childAspectRatio(context),
                  crossAxisSpacing: sectionSpacing,
                  mainAxisSpacing: sectionSpacing,
                ),
                delegate: SliverChildListDelegate(
                  _buildSampleOrders(context),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: sectionSpacing * 2)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionArea(
        padding: padding,
      ),
    );
  }

  double _childAspectRatio(BuildContext context) {
    if (Responsive.isTablet(context)) {
      return Responsive.isPortrait(context) ? 2.2 : 2.8;
    }
    return 3.0;
  }

  List<Widget> _buildSampleOrders(BuildContext context) {
    return [
      OrderCard(
        title: 'Order #101',
        subtitle: '2x Burger, 1x Fries',
        status: 'Preparing',
        icon: Icons.restaurant,
        statusColor: Colors.orange,
      ),
      OrderCard(
        title: 'Order #102',
        subtitle: '3x Tacos, 2x Soda',
        status: 'Ready',
        icon: Icons.check_circle_outline,
        statusColor: Colors.green,
      ),
      OrderCard(
        title: 'Order #103',
        subtitle: '1x Wrap, 1x Salad',
        status: 'Queued',
        icon: Icons.schedule,
        statusColor: Colors.blue,
      ),
      OrderCard(
        title: 'Order #104',
        subtitle: '4x Hot Dog, 3x Drink',
        status: 'Preparing',
        icon: Icons.receipt_long_rounded,
        statusColor: Colors.orange,
      ),
    ];
  }
}

class _DashboardHeader extends StatelessWidget {
  final double padding;
  final double sectionSpacing;

  const _DashboardHeader({
    required this.padding,
    required this.sectionSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SmartQueue',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Vendor Dashboard',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomActionArea extends StatelessWidget {
  final double padding;

  const _BottomActionArea({required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 16, padding, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          DashboardActionButton(
            label: 'Add Order',
            icon: Icons.add_circle_outline,
            onPressed: () {},
          ),
          DashboardActionButton(
            label: 'View Queue',
            icon: Icons.queue_play_next_rounded,
            onPressed: () {},
          ),
          DashboardActionButton(
            label: 'Menu',
            icon: Icons.restaurant_menu_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
