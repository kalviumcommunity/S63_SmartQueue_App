import 'package:flutter/material.dart';

/// ResponsiveDesignDemo - Demonstrates responsive UI using MediaQuery and LayoutBuilder.
///
/// This screen shows how a Flutter app adapts dynamically to:
/// - Different screen sizes (mobile, tablet, desktop)
/// - Different orientations (portrait, landscape)
///
/// Techniques demonstrated:
/// 1. MediaQuery - Access device dimensions and properties
/// 2. LayoutBuilder - Build UI based on available space
/// 3. Breakpoint-based layouts
/// 4. Proportional sizing
class ResponsiveDesignDemo extends StatelessWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // ═══════════════════════════════════════════════════════════════════
    // MediaQuery - Get device information
    // ═══════════════════════════════════════════════════════════════════
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;

    // Determine device type based on screen width
    final isTablet = screenWidth >= 600;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header with device info
            _buildHeader(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              orientation: orientation,
              isTablet: isTablet,
              isMobile: isMobile,
            ),

            // Main content using LayoutBuilder
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // ═══════════════════════════════════════════════════════
                  // LayoutBuilder - Build UI based on available constraints
                  // ═══════════════════════════════════════════════════════
                  final availableWidth = constraints.maxWidth;
                  final availableHeight = constraints.maxHeight;

                  // Determine layout based on available width
                  if (availableWidth >= 900) {
                    // Desktop/Large Tablet: Three-column layout
                    return _buildDesktopLayout(
                      availableWidth: availableWidth,
                      availableHeight: availableHeight,
                    );
                  } else if (availableWidth >= 600) {
                    // Tablet: Two-column layout
                    return _buildTabletLayout(
                      availableWidth: availableWidth,
                      availableHeight: availableHeight,
                    );
                  } else {
                    // Mobile: Single-column layout
                    return _buildMobileLayout(
                      availableWidth: availableWidth,
                      availableHeight: availableHeight,
                      screenWidth: screenWidth,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // HEADER - Shows device information
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildHeader({
    required double screenWidth,
    required double screenHeight,
    required Orientation orientation,
    required bool isTablet,
    required bool isMobile,
  }) {
    // Proportional sizing using MediaQuery
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final fontSize = isMobile ? 18.0 : 22.0;
    final subtitleSize = isMobile ? 12.0 : 14.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.clamp(16.0, 40.0),
        vertical: isMobile ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1),
            isTablet ? const Color(0xFF8B5CF6) : const Color(0xFF6366F1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  Icons.devices_rounded,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 10 : 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Responsive Design Demo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isMobile ? 2 : 4),
                    Text(
                      'MediaQuery & LayoutBuilder',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: subtitleSize,
                      ),
                    ),
                  ],
                ),
              ),
              // Device type badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 14,
                  vertical: isMobile ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isTablet ? Icons.tablet_rounded : Icons.phone_android_rounded,
                      size: isMobile ? 14 : 16,
                      color: const Color(0xFF6366F1),
                    ),
                    SizedBox(width: isMobile ? 4 : 6),
                    Text(
                      isTablet ? 'TABLET' : 'MOBILE',
                      style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontSize: isMobile ? 10 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 12 : 16),

          // Device info row
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(
                  'Width',
                  '${screenWidth.toInt()}px',
                  isMobile: isMobile,
                ),
                _buildInfoChip(
                  'Height',
                  '${screenHeight.toInt()}px',
                  isMobile: isMobile,
                ),
                _buildInfoChip(
                  'Orientation',
                  orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
                  isMobile: isMobile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, {required bool isMobile}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isMobile ? 10 : 11,
          ),
        ),
        SizedBox(height: isMobile ? 2 : 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // MOBILE LAYOUT - Single column
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildMobileLayout({
    required double availableWidth,
    required double availableHeight,
    required double screenWidth,
  }) {
    // Proportional padding based on screen width
    final padding = (screenWidth * 0.04).clamp(12.0, 20.0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLayoutIndicator('Mobile Layout', 'Single Column', Icons.view_agenda_rounded),
          SizedBox(height: padding),

          // Stats in 2x2 grid
          Row(
            children: [
              Expanded(child: _buildStatCard('Orders', '24', const Color(0xFF3B82F6), compact: true)),
              SizedBox(width: padding * 0.75),
              Expanded(child: _buildStatCard('Queue', '8', const Color(0xFFF59E0B), compact: true)),
            ],
          ),
          SizedBox(height: padding * 0.75),
          Row(
            children: [
              Expanded(child: _buildStatCard('Ready', '5', const Color(0xFF10B981), compact: true)),
              SizedBox(width: padding * 0.75),
              Expanded(child: _buildStatCard('Revenue', '\$847', const Color(0xFF8B5CF6), compact: true)),
            ],
          ),

          SizedBox(height: padding),

          // Orders section
          _buildSectionTitle('Recent Orders'),
          SizedBox(height: padding * 0.5),
          _buildOrdersList(compact: true),

          SizedBox(height: padding),

          // Quick actions
          _buildSectionTitle('Quick Actions'),
          SizedBox(height: padding * 0.5),
          _buildQuickActionsVertical(),

          SizedBox(height: padding),

          // Info section
          _buildInfoSection(compact: true),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // TABLET LAYOUT - Two columns
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildTabletLayout({
    required double availableWidth,
    required double availableHeight,
  }) {
    const padding = 20.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLayoutIndicator('Tablet Layout', 'Two Columns', Icons.view_column_rounded),
          const SizedBox(height: padding),

          // Stats row
          Row(
            children: [
              Expanded(child: _buildStatCard('Orders', '24', const Color(0xFF3B82F6))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Queue', '8', const Color(0xFFF59E0B))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Ready', '5', const Color(0xFF10B981))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Revenue', '\$847', const Color(0xFF8B5CF6))),
            ],
          ),

          const SizedBox(height: padding),

          // Two-column content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Orders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Recent Orders'),
                    const SizedBox(height: 12),
                    _buildOrdersList(compact: false),
                  ],
                ),
              ),
              const SizedBox(width: padding),
              // Right column - Actions & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Quick Actions'),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(),
                    const SizedBox(height: padding),
                    _buildInfoSection(compact: false),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // DESKTOP LAYOUT - Three columns
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildDesktopLayout({
    required double availableWidth,
    required double availableHeight,
  }) {
    const padding = 24.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLayoutIndicator('Desktop Layout', 'Three Columns', Icons.view_quilt_rounded),
          const SizedBox(height: padding),

          // Stats row - full width
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Orders', '24', const Color(0xFF3B82F6))),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('In Queue', '8', const Color(0xFFF59E0B))),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Ready', '5', const Color(0xFF10B981))),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Revenue', '\$847', const Color(0xFF8B5CF6))),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Avg Wait', '6 min', const Color(0xFFEF4444))),
            ],
          ),

          const SizedBox(height: padding),

          // Three-column layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Orders
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Recent Orders'),
                    const SizedBox(height: 12),
                    _buildOrdersList(compact: false, extended: true),
                  ],
                ),
              ),
              const SizedBox(width: padding),
              // Middle column - Queue
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Queue Status'),
                    const SizedBox(height: 12),
                    _buildQueueStatusPanel(),
                  ],
                ),
              ),
              const SizedBox(width: padding),
              // Right column - Actions & Info
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Quick Actions'),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(),
                    const SizedBox(height: padding),
                    _buildInfoSection(compact: false),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SHARED COMPONENTS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildLayoutIndicator(String layout, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF818CF8), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  layout,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'ACTIVE',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildStatCard(String label, String value, Color color, {bool compact = false}) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Container(
            padding: EdgeInsets.all(compact ? 6 : 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: color,
              size: compact ? 16 : 20,
            ),
          ),
          SizedBox(height: compact ? 10 : 14),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF1E293B),
              fontSize: compact ? 22 : 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: compact ? 11 : 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList({bool compact = false, bool extended = false}) {
    final orders = [
      ('ORD-001', 'Burger & Fries', 'Queued', const Color(0xFF3B82F6)),
      ('ORD-002', 'Pizza Combo', 'Preparing', const Color(0xFFF59E0B)),
      ('ORD-003', 'Salad Bowl', 'Ready', const Color(0xFF10B981)),
      if (extended) ('ORD-004', 'Pasta Special', 'Queued', const Color(0xFF3B82F6)),
      if (extended) ('ORD-005', 'Chicken Wings', 'Preparing', const Color(0xFFF59E0B)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(orders.length, (index) {
          final order = orders[index];
          return Container(
            padding: EdgeInsets.all(compact ? 12 : 16),
            decoration: BoxDecoration(
              border: index < orders.length - 1
                  ? const Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: compact ? 36 : 44,
                  height: compact ? 36 : 44,
                  decoration: BoxDecoration(
                    color: order.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: order.$4,
                    size: compact ? 18 : 22,
                  ),
                ),
                SizedBox(width: compact ? 10 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.$1,
                        style: TextStyle(
                          color: const Color(0xFF1E293B),
                          fontSize: compact ? 13 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        order.$2,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: compact ? 11 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 8 : 10,
                    vertical: compact ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.$3,
                    style: TextStyle(
                      color: order.$4,
                      fontSize: compact ? 10 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickActionsVertical() {
    return Column(
      children: [
        _buildActionButton('New Order', Icons.add_rounded, const Color(0xFF6366F1)),
        const SizedBox(height: 10),
        _buildActionButton('View Queue', Icons.queue_rounded, const Color(0xFF3B82F6)),
        const SizedBox(height: 10),
        _buildActionButton('Reports', Icons.bar_chart_rounded, const Color(0xFF10B981)),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildGridAction('New Order', Icons.add_rounded, const Color(0xFF6366F1))),
              const SizedBox(width: 10),
              Expanded(child: _buildGridAction('Queue', Icons.queue_rounded, const Color(0xFF3B82F6))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildGridAction('Reports', Icons.bar_chart_rounded, const Color(0xFF10B981))),
              const SizedBox(width: 10),
              Expanded(child: _buildGridAction('Settings', Icons.settings_rounded, const Color(0xFF64748B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridAction(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildInfoSection({bool compact = false}) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF6366F1),
                size: compact ? 18 : 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Responsive Info',
                style: TextStyle(
                  color: const Color(0xFF6366F1),
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 10 : 14),
          Text(
            compact
                ? 'This layout adapts to your screen size using MediaQuery and LayoutBuilder.'
                : 'This dashboard automatically adapts to your screen size. MediaQuery provides device dimensions while LayoutBuilder responds to available space.',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueStatusPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildQueueItem('Position 1', 'ORD-001', const Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          _buildQueueItem('Position 2', 'ORD-002', const Color(0xFF3B82F6)),
          const SizedBox(height: 12),
          _buildQueueItem('Position 3', 'ORD-003', const Color(0xFF3B82F6)),
          const SizedBox(height: 12),
          _buildQueueItem('Position 4', 'ORD-004', const Color(0xFF3B82F6)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Avg Wait: 6 min',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(String position, String orderId, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              position.split(' ')[1],
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            orderId,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.more_horiz_rounded,
          color: const Color(0xFF94A3B8),
          size: 18,
        ),
      ],
    );
  }
}
