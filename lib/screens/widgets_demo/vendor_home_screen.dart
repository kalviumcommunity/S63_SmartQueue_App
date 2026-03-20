import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

/// VendorHomeScreen - Demonstrates reusable widgets in a real-world context.
///
/// This screen shows the same widgets (CustomButton, StatCard, InfoCard, OrderCard)
/// being used with different configurations compared to WidgetsShowcaseScreen.
class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  // Sample data for demonstration
  final List<_OrderData> _orders = [
    _OrderData(
      id: 'ORD-101',
      title: '2x Cappuccino, 1x Croissant',
      customer: 'Emma Wilson',
      time: 'Just now',
      value: '\$18.50',
      status: OrderStatus.queued,
    ),
    _OrderData(
      id: 'ORD-102',
      title: '1x Breakfast Combo',
      customer: 'Michael Brown',
      time: '3 min ago',
      value: '\$24.99',
      status: OrderStatus.preparing,
    ),
    _OrderData(
      id: 'ORD-103',
      title: '3x Iced Latte',
      customer: 'Sofia Garcia',
      time: '7 min ago',
      value: '\$15.00',
      status: OrderStatus.ready,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stats Row - Using StatCard widgets
                    _buildStatsSection(),

                    const SizedBox(height: 24),

                    // Quick Actions - Using CustomButton widgets
                    _buildQuickActions(),

                    const SizedBox(height: 24),

                    // Store Info - Using InfoCard widgets
                    _buildStoreInfo(),

                    const SizedBox(height: 24),

                    // Recent Orders - Using OrderCard widgets
                    _buildRecentOrders(),

                    const SizedBox(height: 24),

                    // Bottom Action Button
                    CustomButton(
                      label: 'View Full Dashboard',
                      trailingIcon: Icons.dashboard_rounded,
                      variant: ButtonVariant.secondary,
                      fullWidth: true,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.storefront_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning!',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'SmartQueue Cafe',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Using CustomButton with icon only (secondary variant)
          CustomButton(
            label: '',
            icon: Icons.notifications_outlined,
            size: ButtonSize.small,
            variant: ButtonVariant.outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Overview',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        // Using StatCard widgets in a 2x2 grid
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Total Orders',
                value: '156',
                icon: Icons.receipt_long_rounded,
                color: const Color(0xFF6366F1),
                trend: 8.2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Revenue',
                value: '\$2,847',
                icon: Icons.attach_money_rounded,
                color: const Color(0xFF10B981),
                trend: 15.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Avg. Wait',
                value: '6 min',
                icon: Icons.timer_rounded,
                color: const Color(0xFFF59E0B),
                trend: -12.5,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Rating',
                value: '4.9',
                icon: Icons.star_rounded,
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        // Using CustomButton widgets with different variants
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'New Order',
                icon: Icons.add_rounded,
                variant: ButtonVariant.primary,
                onPressed: () => _showSnackBar('Creating new order'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                label: 'View Queue',
                icon: Icons.queue_rounded,
                variant: ButtonVariant.outline,
                onPressed: () => _showSnackBar('Opening queue'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Menu',
                icon: Icons.restaurant_menu_rounded,
                variant: ButtonVariant.secondary,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                label: 'Reports',
                icon: Icons.bar_chart_rounded,
                variant: ButtonVariant.secondary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Store Status',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        // Using InfoCard widgets with different configurations
        InfoCard(
          title: 'Store Hours',
          subtitle: 'Open today: 7:00 AM - 10:00 PM',
          icon: Icons.access_time_rounded,
          iconColor: const Color(0xFF10B981),
          variant: CardVariant.outlined,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OPEN',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        InfoCard(
          title: 'Queue Capacity',
          subtitle: '12 active orders in queue',
          icon: Icons.people_alt_rounded,
          iconColor: const Color(0xFFF59E0B),
          value: '75%',
          onTap: () {},
        ),
        const SizedBox(height: 10),
        const InfoCard(
          title: 'Staff Today',
          subtitle: '4 team members on shift',
          icon: Icons.badge_rounded,
          iconColor: Color(0xFF6366F1),
          variant: CardVariant.subtle,
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Using CustomButton with text variant
            CustomButton(
              label: 'See All',
              size: ButtonSize.small,
              variant: ButtonVariant.text,
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Using OrderCard widgets
        ...List.generate(_orders.length, (index) {
          final order = _orders[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < _orders.length - 1 ? 10 : 0),
            child: OrderCard(
              id: order.id,
              title: order.title,
              status: order.status,
              customer: order.customer,
              time: order.time,
              value: order.value,
              onPrimaryAction: () => _handleOrderAction(order),
              onTap: () => _showSnackBar('Viewing ${order.id}'),
            ),
          );
        }),
      ],
    );
  }

  void _handleOrderAction(_OrderData order) {
    setState(() {
      final index = _orders.indexOf(order);
      if (order.status == OrderStatus.queued) {
        _orders[index] = order.copyWith(status: OrderStatus.preparing);
        _showSnackBar('Started preparing ${order.id}');
      } else if (order.status == OrderStatus.preparing) {
        _orders[index] = order.copyWith(status: OrderStatus.ready);
        _showSnackBar('${order.id} is ready!');
      } else if (order.status == OrderStatus.ready) {
        _orders[index] = order.copyWith(status: OrderStatus.completed);
        _showSnackBar('${order.id} completed');
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _OrderData {
  final String id;
  final String title;
  final String customer;
  final String time;
  final String value;
  final OrderStatus status;

  _OrderData({
    required this.id,
    required this.title,
    required this.customer,
    required this.time,
    required this.value,
    required this.status,
  });

  _OrderData copyWith({
    String? id,
    String? title,
    String? customer,
    String? time,
    String? value,
    OrderStatus? status,
  }) {
    return _OrderData(
      id: id ?? this.id,
      title: title ?? this.title,
      customer: customer ?? this.customer,
      time: time ?? this.time,
      value: value ?? this.value,
      status: status ?? this.status,
    );
  }
}
