import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

/// WidgetsShowcaseScreen - Demonstrates all custom reusable widgets.
///
/// This screen shows how the same widgets can be reused with
/// different configurations across different contexts.
class WidgetsShowcaseScreen extends StatefulWidget {
  const WidgetsShowcaseScreen({super.key});

  @override
  State<WidgetsShowcaseScreen> createState() => _WidgetsShowcaseScreenState();
}

class _WidgetsShowcaseScreenState extends State<WidgetsShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  int _queueCount = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildButtonsTab(),
                  _buildCardsTab(),
                  _buildCombinedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.widgets_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Widgets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Reusable UI Components',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF6366F1),
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: const Color(0xFF6366F1),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Buttons'),
          Tab(text: 'Cards'),
          Tab(text: 'Combined'),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // BUTTONS TAB
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildButtonsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Button Variants'),
          const SizedBox(height: 16),

          // Primary Button
          CustomButton(
            label: 'Primary Button',
            icon: Icons.add_rounded,
            onPressed: () => _showSnackBar('Primary button pressed'),
          ),
          const SizedBox(height: 12),

          // Secondary Button
          CustomButton(
            label: 'Secondary Button',
            variant: ButtonVariant.secondary,
            icon: Icons.edit_rounded,
            onPressed: () => _showSnackBar('Secondary button pressed'),
          ),
          const SizedBox(height: 12),

          // Outline Button
          CustomButton(
            label: 'Outline Button',
            variant: ButtonVariant.outline,
            icon: Icons.visibility_rounded,
            onPressed: () => _showSnackBar('Outline button pressed'),
          ),
          const SizedBox(height: 12),

          // Success Button
          CustomButton(
            label: 'Success Action',
            variant: ButtonVariant.success,
            icon: Icons.check_rounded,
            onPressed: () => _showSnackBar('Success!'),
          ),
          const SizedBox(height: 12),

          // Danger Button
          CustomButton(
            label: 'Delete Item',
            variant: ButtonVariant.danger,
            icon: Icons.delete_rounded,
            onPressed: () => _showSnackBar('Danger action'),
          ),

          const SizedBox(height: 32),
          _buildSectionTitle('Button Sizes'),
          const SizedBox(height: 16),

          // Small Button
          Center(
            child: CustomButton(
              label: 'Small',
              size: ButtonSize.small,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),

          // Medium Button
          Center(
            child: CustomButton(
              label: 'Medium (Default)',
              size: ButtonSize.medium,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),

          // Large Button
          Center(
            child: CustomButton(
              label: 'Large',
              size: ButtonSize.large,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 32),
          _buildSectionTitle('Button States'),
          const SizedBox(height: 16),

          // Loading Button
          CustomButton(
            label: 'Loading State',
            isLoading: _isLoading,
            fullWidth: true,
            onPressed: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(seconds: 2));
              setState(() => _isLoading = false);
              _showSnackBar('Loading complete!');
            },
          ),
          const SizedBox(height: 12),

          // Disabled Button
          const CustomButton(
            label: 'Disabled Button',
            isDisabled: true,
            fullWidth: true,
          ),
          const SizedBox(height: 12),

          // No Handler Button
          const CustomButton(
            label: 'No onPressed Handler',
            fullWidth: true,
          ),

          const SizedBox(height: 32),
          _buildSectionTitle('With Icons'),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Leading',
                  icon: Icons.arrow_back_rounded,
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: 'Trailing',
                  trailingIcon: Icons.arrow_forward_rounded,
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          _buildCodeInfoCard(
            'CustomButton',
            'Stateful widget with press animation, loading state, and multiple variants',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // CARDS TAB
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCardsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('InfoCard Variants'),
          const SizedBox(height: 16),

          // Default InfoCard
          InfoCard(
            title: 'Order Settings',
            subtitle: 'Configure order preferences and notifications',
            icon: Icons.settings_rounded,
            onTap: () => _showSnackBar('Settings tapped'),
          ),
          const SizedBox(height: 12),

          // InfoCard with value
          InfoCard(
            title: 'Today\'s Revenue',
            subtitle: 'Total earnings from completed orders',
            value: '\$1,234',
            icon: Icons.attach_money_rounded,
            iconColor: const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),

          // Highlighted InfoCard
          const InfoCard(
            title: 'Premium Feature',
            subtitle: 'Unlock advanced analytics and reports',
            icon: Icons.star_rounded,
            variant: CardVariant.highlighted,
          ),
          const SizedBox(height: 12),

          // Outlined InfoCard
          InfoCard(
            title: 'Queue Status',
            subtitle: 'Currently serving customers',
            icon: Icons.people_rounded,
            variant: CardVariant.outlined,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          _buildSectionTitle('StatCard Examples'),
          const SizedBox(height: 16),

          // Row of StatCards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Queued',
                  value: '$_queueCount',
                  icon: Icons.pending_actions_rounded,
                  color: const Color(0xFF3B82F6),
                  trend: 12.5,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Preparing',
                  value: '3',
                  icon: Icons.restaurant_rounded,
                  color: const Color(0xFFF59E0B),
                  trend: -5.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // StatCard with progress
          StatCard(
            label: 'Daily Goal',
            value: '47/50',
            icon: Icons.flag_rounded,
            color: const Color(0xFF10B981),
            progress: 0.94,
          ),

          const SizedBox(height: 32),
          _buildSectionTitle('OrderCard Examples'),
          const SizedBox(height: 16),

          // Queued Order
          OrderCard(
            id: 'ORD-001',
            title: '2x Burger, 1x Fries, 1x Coke',
            status: OrderStatus.queued,
            customer: 'John Doe',
            time: '2 min ago',
            value: '\$24.99',
            showDetails: true,
            details: ['1x Double Cheese Burger', '1x Classic Burger', '1x Large Fries', '1x Coca Cola'],
            onPrimaryAction: () => _showSnackBar('Started preparing'),
          ),
          const SizedBox(height: 12),

          // Preparing Order
          OrderCard(
            id: 'ORD-002',
            title: '1x Pizza Margherita, 2x Garlic Bread',
            status: OrderStatus.preparing,
            customer: 'Jane Smith',
            time: '5 min ago',
            value: '\$32.50',
            onPrimaryAction: () => _showSnackBar('Marked as ready'),
          ),
          const SizedBox(height: 12),

          // Ready Order
          OrderCard(
            id: 'ORD-003',
            title: '3x Tacos, 1x Nachos',
            status: OrderStatus.ready,
            customer: 'Mike Johnson',
            time: '8 min ago',
            value: '\$28.75',
            onSecondaryAction: () => _showSnackBar('Order completed'),
          ),

          const SizedBox(height: 20),
          _buildCodeInfoCard(
            'InfoCard, StatCard, OrderCard',
            'Stateless cards for info display, Stateful OrderCard with expandable details',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // COMBINED TAB
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCombinedTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('Dashboard Example'),
          const SizedBox(height: 16),

          // Stats Row using StatCards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Queue',
                  value: '$_queueCount',
                  icon: Icons.queue_rounded,
                  color: const Color(0xFF3B82F6),
                  isCompact: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Ready',
                  value: '2',
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF10B981),
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  label: 'Done',
                  value: '35',
                  icon: Icons.verified_rounded,
                  color: const Color(0xFF8B5CF6),
                  isCompact: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons using CustomButton
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Add Order',
                  icon: Icons.add_rounded,
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    setState(() => _queueCount++);
                    _showSnackBar('Order added to queue');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  label: 'View Queue',
                  icon: Icons.list_alt_rounded,
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Info Section using InfoCard
          InfoCard(
            title: 'Quick Stats',
            subtitle: 'Average wait time: 8 minutes',
            icon: Icons.timer_rounded,
            iconColor: const Color(0xFFF59E0B),
            trailing: CustomButton(
              label: 'Details',
              size: ButtonSize.small,
              variant: ButtonVariant.secondary,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 20),
          _buildSectionTitle('Recent Orders'),
          const SizedBox(height: 12),

          // Orders using OrderCard
          OrderCard(
            id: 'ORD-004',
            title: '2x Hot Dog, 2x Fries',
            status: OrderStatus.queued,
            customer: 'Chris Wilson',
            time: '1 min ago',
            value: '\$18.50',
            onPrimaryAction: () => _showSnackBar('Started preparing ORD-004'),
          ),
          const SizedBox(height: 12),

          OrderCard(
            id: 'ORD-005',
            title: '1x Combo Meal',
            status: OrderStatus.preparing,
            customer: 'Sarah Davis',
            time: '4 min ago',
            value: '\$22.99',
            onPrimaryAction: () => _showSnackBar('ORD-005 marked ready'),
          ),

          const SizedBox(height: 24),

          // Bottom Action
          CustomButton(
            label: 'View All Orders',
            trailingIcon: Icons.arrow_forward_rounded,
            variant: ButtonVariant.secondary,
            fullWidth: true,
            onPressed: () {},
          ),

          const SizedBox(height: 20),
          _buildReusabilityInfoCard(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCodeInfoCard(String widgets, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_rounded, color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 10),
              Text(
                widgets,
                style: const TextStyle(
                  color: Color(0xFF818CF8),
                  fontSize: 12,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReusabilityInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: Color(0xFF6366F1), size: 18),
              SizedBox(width: 10),
              Text(
                'Widget Reusability',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'This dashboard uses the same widgets (CustomButton, StatCard, InfoCard, OrderCard) as the individual tabs, but configured differently for this context.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Same code, different configurations\n'
            '• Consistent design across screens\n'
            '• Easy to maintain and update',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
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
