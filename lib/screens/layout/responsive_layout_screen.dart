import 'package:flutter/material.dart';

/// ResponsiveLayoutScreen - Demonstrates responsive UI design using
/// Container, Row, and Column widgets.
///
/// This screen showcases:
/// - Adaptive layouts that respond to screen size
/// - Proper use of Container for styling and constraints
/// - Row for horizontal arrangements
/// - Column for vertical arrangements
/// - Flexible and Expanded widgets for proportional sizing
class ResponsiveLayoutScreen extends StatelessWidget {
  const ResponsiveLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine layout based on screen width
            final isWideScreen = constraints.maxWidth > 600;
            final isTablet = constraints.maxWidth > 900;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ═══════════════════════════════════════════════════
                  // HEADER SECTION
                  // Uses: Container for styling, Row for horizontal layout
                  // ═══════════════════════════════════════════════════
                  _buildHeader(context, isWideScreen),

                  // ═══════════════════════════════════════════════════
                  // MAIN CONTENT AREA
                  // ═══════════════════════════════════════════════════
                  Padding(
                    padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Quick Stats Section
                        // Adapts: Row on wide screens, Column on narrow
                        _buildQuickStatsSection(isWideScreen),

                        SizedBox(height: isWideScreen ? 24 : 16),

                        // Main Dashboard Panels
                        // Adapts: Side-by-side on tablet, stacked on phone
                        _buildMainPanels(isWideScreen, isTablet),

                        SizedBox(height: isWideScreen ? 24 : 16),

                        // Recent Activity & Quick Actions
                        // Adapts: Row on tablet, Column on phone
                        _buildBottomSection(isWideScreen, isTablet),

                        const SizedBox(height: 24),

                        // Layout Info Card (Educational)
                        _buildLayoutInfoCard(constraints),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// HEADER SECTION
  /// Demonstrates: Container with gradient, Row for horizontal arrangement
  Widget _buildHeader(BuildContext context, bool isWideScreen) {
    return Container(
      // Container: Provides decoration, padding, and constraints
      padding: EdgeInsets.all(isWideScreen ? 28.0 : 20.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Arranges logo, title, and actions horizontally
          Row(
            children: [
              // Logo Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Title Section - Expanded to take remaining space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SmartQueue Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isWideScreen ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Responsive Layout Demo',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isWideScreen ? 14 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Icons - Wrapped in Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderIcon(Icons.notifications_outlined),
                  if (isWideScreen) ...[
                    const SizedBox(width: 8),
                    _buildHeaderIcon(Icons.settings_outlined),
                  ],
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Screen Size Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isWideScreen ? Icons.tablet_rounded : Icons.phone_android_rounded,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  isWideScreen ? 'Wide Screen Layout' : 'Compact Layout',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  /// QUICK STATS SECTION
  /// Demonstrates: Row with Expanded children on wide screens,
  /// Column with full-width children on narrow screens
  Widget _buildQuickStatsSection(bool isWideScreen) {
    final stats = [
      {'label': 'Orders Today', 'value': '47', 'icon': Icons.receipt_long_rounded, 'color': const Color(0xFF3B82F6)},
      {'label': 'In Queue', 'value': '12', 'icon': Icons.pending_actions_rounded, 'color': const Color(0xFFF59E0B)},
      {'label': 'Completed', 'value': '35', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
      {'label': 'Revenue', 'value': '\$1,234', 'icon': Icons.attach_money_rounded, 'color': const Color(0xFF8B5CF6)},
    ];

    if (isWideScreen) {
      // Wide Screen: Use Row with Expanded for equal distribution
      return Row(
        children: stats.map((stat) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: stats.indexOf(stat) < stats.length - 1 ? 12 : 0,
              ),
              child: _buildStatCard(
                label: stat['label'] as String,
                value: stat['value'] as String,
                icon: stat['icon'] as IconData,
                color: stat['color'] as Color,
                isCompact: false,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Narrow Screen: Use Column with Row pairs for 2x2 grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: stats[0]['label'] as String,
                  value: stats[0]['value'] as String,
                  icon: stats[0]['icon'] as IconData,
                  color: stats[0]['color'] as Color,
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  label: stats[1]['label'] as String,
                  value: stats[1]['value'] as String,
                  icon: stats[1]['icon'] as IconData,
                  color: stats[1]['color'] as Color,
                  isCompact: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: stats[2]['label'] as String,
                  value: stats[2]['value'] as String,
                  icon: stats[2]['icon'] as IconData,
                  color: stats[2]['color'] as Color,
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  label: stats[3]['label'] as String,
                  value: stats[3]['value'] as String,
                  icon: stats[3]['icon'] as IconData,
                  color: stats[3]['color'] as Color,
                  isCompact: true,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isCompact,
  }) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 8 : 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: isCompact ? 18 : 22),
              ),
              Icon(
                Icons.trending_up_rounded,
                color: const Color(0xFF10B981),
                size: isCompact ? 16 : 20,
              ),
            ],
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF1E293B),
              fontSize: isCompact ? 22 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: isCompact ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }

  /// MAIN PANELS SECTION
  /// Demonstrates: Adaptive Row/Column based on screen size
  Widget _buildMainPanels(bool isWideScreen, bool isTablet) {
    if (isTablet) {
      // Tablet: Side-by-side panels with Row
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel - Takes 60% of width
          Expanded(
            flex: 6,
            child: _buildOrdersPanel(),
          ),
          const SizedBox(width: 20),
          // Right Panel - Takes 40% of width
          Expanded(
            flex: 4,
            child: _buildQueuePanel(),
          ),
        ],
      );
    } else {
      // Phone: Stacked panels with Column
      return Column(
        children: [
          _buildOrdersPanel(),
          const SizedBox(height: 16),
          _buildQueuePanel(),
        ],
      );
    }
  }

  Widget _buildOrdersPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel Header - Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFF6366F1),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Recent Orders',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Order Items - Column of Rows
          ...List.generate(3, (index) => _buildOrderItem(index)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(int index) {
    final orders = [
      {'id': 'ORD-001', 'items': '2x Burger, 1x Fries', 'status': 'Preparing', 'color': const Color(0xFFF59E0B)},
      {'id': 'ORD-002', 'items': '1x Pizza, 2x Soda', 'status': 'Ready', 'color': const Color(0xFF10B981)},
      {'id': 'ORD-003', 'items': '3x Tacos', 'status': 'Queued', 'color': const Color(0xFF3B82F6)},
    ];
    final order = orders[index];

    return Container(
      margin: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      // Row: Horizontal arrangement of order details
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (order['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.fastfood_rounded,
              color: order['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Expanded: Takes remaining horizontal space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['id'] as String,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  order['items'] as String,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (order['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              order['status'] as String,
              style: TextStyle(
                color: order['color'] as Color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueuePanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.queue_rounded,
                  color: Color(0xFFF59E0B),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Queue Status',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Queue Progress Bars - Column of items
          _buildQueueProgress('Queued', 5, 12, const Color(0xFF3B82F6)),
          const SizedBox(height: 14),
          _buildQueueProgress('Preparing', 3, 12, const Color(0xFFF59E0B)),
          const SizedBox(height: 14),
          _buildQueueProgress('Ready', 4, 12, const Color(0xFF10B981)),
          
          const SizedBox(height: 20),
          
          // Average Wait Time
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Avg. Wait Time',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                const Text(
                  '8 min',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueProgress(String label, int current, int total, Color color) {
    final progress = current / total;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 13,
              ),
            ),
            Text(
              '$current orders',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress Bar using Container with Row
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (progress * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Expanded(
                flex: ((1 - progress) * 100).toInt(),
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// BOTTOM SECTION
  /// Demonstrates: Adaptive layout for secondary panels
  Widget _buildBottomSection(bool isWideScreen, bool isTablet) {
    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildQuickActionsPanel(),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildMenuHighlightsPanel(),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildQuickActionsPanel(),
          const SizedBox(height: 16),
          _buildMenuHighlightsPanel(),
        ],
      );
    }
  }

  Widget _buildQuickActionsPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
          const SizedBox(height: 16),
          // Action Buttons - Row of items
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  Icons.add_rounded,
                  'New Order',
                  const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  Icons.qr_code_scanner_rounded,
                  'Scan',
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  Icons.print_rounded,
                  'Print',
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHighlightsPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Menu Items - Row arrangement
          Row(
            children: [
              Expanded(child: _buildMenuItem('Burger', '127', '🍔')),
              const SizedBox(width: 10),
              Expanded(child: _buildMenuItem('Pizza', '98', '🍕')),
              const SizedBox(width: 10),
              Expanded(child: _buildMenuItem('Tacos', '85', '🌮')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String name, String count, String emoji) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '$count sold',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  /// LAYOUT INFO CARD
  /// Educational section explaining the layout techniques used
  Widget _buildLayoutInfoCard(BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 10),
              Text(
                'Layout Widgets Used',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Screen Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.aspect_ratio_rounded, color: Color(0xFF94A3B8), size: 18),
                const SizedBox(width: 10),
                Text(
                  'Screen Width: ${constraints.maxWidth.toStringAsFixed(0)}px',
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: constraints.maxWidth > 600 
                        ? const Color(0xFF10B981).withValues(alpha: 0.2)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    constraints.maxWidth > 900 
                        ? 'Tablet' 
                        : constraints.maxWidth > 600 
                            ? 'Wide' 
                            : 'Phone',
                    style: TextStyle(
                      color: constraints.maxWidth > 600 
                          ? const Color(0xFF10B981)
                          : const Color(0xFF3B82F6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Widget Examples
          _buildCodeExample('Container', 'Styling, padding, decoration, constraints'),
          const SizedBox(height: 8),
          _buildCodeExample('Row', 'Horizontal arrangement of children'),
          const SizedBox(height: 8),
          _buildCodeExample('Column', 'Vertical arrangement of children'),
          const SizedBox(height: 8),
          _buildCodeExample('Expanded', 'Fills remaining space in Row/Column'),
          const SizedBox(height: 8),
          _buildCodeExample('LayoutBuilder', 'Provides parent constraints for responsive design'),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String widget, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget,
            style: const TextStyle(
              color: Color(0xFF818CF8),
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
