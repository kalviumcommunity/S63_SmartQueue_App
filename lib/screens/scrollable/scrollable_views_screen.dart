import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ScrollableViewsScreen - Demonstrates ListView and GridView widgets.
///
/// This screen showcases:
/// - ListView.builder for efficient vertical lists
/// - ListView horizontal scrolling
/// - GridView with fixed column count
/// - Combining multiple scrollable widgets in one screen
/// - Performance optimization with builder patterns
class ScrollableViewsScreen extends StatefulWidget {
  const ScrollableViewsScreen({super.key});

  @override
  State<ScrollableViewsScreen> createState() => _ScrollableViewsScreenState();
}

class _ScrollableViewsScreenState extends State<ScrollableViewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;

  // Sample data for menu categories (GridView)
  final List<Map<String, dynamic>> _menuCategories = [
    {'name': 'Burgers', 'icon': Icons.lunch_dining_rounded, 'color': const Color(0xFFEF4444), 'count': 12},
    {'name': 'Pizza', 'icon': Icons.local_pizza_rounded, 'color': const Color(0xFFF59E0B), 'count': 8},
    {'name': 'Tacos', 'icon': Icons.restaurant_rounded, 'color': const Color(0xFF10B981), 'count': 10},
    {'name': 'Drinks', 'icon': Icons.local_cafe_rounded, 'color': const Color(0xFF3B82F6), 'count': 15},
    {'name': 'Desserts', 'icon': Icons.cake_rounded, 'color': const Color(0xFF8B5CF6), 'count': 6},
    {'name': 'Salads', 'icon': Icons.eco_rounded, 'color': const Color(0xFF14B8A6), 'count': 7},
    {'name': 'Sides', 'icon': Icons.fastfood_rounded, 'color': const Color(0xFFEC4899), 'count': 9},
    {'name': 'Combos', 'icon': Icons.widgets_rounded, 'color': const Color(0xFF6366F1), 'count': 5},
  ];

  // Sample data for orders (ListView)
  final List<Map<String, dynamic>> _orders = [
    {'id': 'ORD-001', 'items': '2x Burger, 1x Fries, 1x Coke', 'customer': 'John Doe', 'status': 'Preparing', 'time': '2 min ago', 'total': 24.99},
    {'id': 'ORD-002', 'items': '1x Pizza Margherita, 2x Garlic Bread', 'customer': 'Jane Smith', 'status': 'Queued', 'time': '5 min ago', 'total': 32.50},
    {'id': 'ORD-003', 'items': '3x Tacos, 1x Nachos, 2x Soda', 'customer': 'Mike Johnson', 'status': 'Ready', 'time': '8 min ago', 'total': 28.75},
    {'id': 'ORD-004', 'items': '1x Salad Bowl, 1x Smoothie', 'customer': 'Emily Brown', 'status': 'Preparing', 'time': '10 min ago', 'total': 18.50},
    {'id': 'ORD-005', 'items': '2x Hot Dog, 2x Fries, 2x Shake', 'customer': 'Chris Wilson', 'status': 'Queued', 'time': '12 min ago', 'total': 35.00},
    {'id': 'ORD-006', 'items': '1x Combo Meal, 1x Dessert', 'customer': 'Sarah Davis', 'status': 'Completed', 'time': '15 min ago', 'total': 22.99},
    {'id': 'ORD-007', 'items': '4x Chicken Wings, 2x Dips', 'customer': 'Tom Garcia', 'status': 'Preparing', 'time': '18 min ago', 'total': 19.99},
    {'id': 'ORD-008', 'items': '1x Family Pizza, 4x Drinks', 'customer': 'Lisa Martinez', 'status': 'Ready', 'time': '20 min ago', 'total': 45.00},
    {'id': 'ORD-009', 'items': '2x Breakfast Burrito', 'customer': 'Kevin Lee', 'status': 'Queued', 'time': '22 min ago', 'total': 16.50},
    {'id': 'ORD-010', 'items': '1x Veggie Wrap, 1x Juice', 'customer': 'Amy White', 'status': 'Completed', 'time': '25 min ago', 'total': 14.99},
  ];

  // Sample data for featured items (Horizontal ListView)
  final List<Map<String, dynamic>> _featuredItems = [
    {'name': 'Double Cheese Burger', 'price': 12.99, 'image': '🍔', 'rating': 4.8},
    {'name': 'Pepperoni Pizza', 'price': 18.99, 'image': '🍕', 'rating': 4.9},
    {'name': 'Chicken Tacos', 'price': 9.99, 'image': '🌮', 'rating': 4.7},
    {'name': 'Caesar Salad', 'price': 8.99, 'image': '🥗', 'rating': 4.5},
    {'name': 'Chocolate Shake', 'price': 5.99, 'image': '🥤', 'rating': 4.6},
    {'name': 'Apple Pie', 'price': 6.99, 'image': '🥧', 'rating': 4.8},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            // Header
            _buildHeader(),

            // Tab Bar
            _buildTabBar(),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Combined ListView & GridView Demo
                  _buildCombinedScrollView(),

                  // Tab 2: Separate ListView Demo
                  _buildListViewDemo(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.view_list_rounded,
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
                      'Scrollable Views',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ListView & GridView Demo',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${_orders.length} Orders',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
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
          Tab(
            icon: Icon(Icons.grid_view_rounded, size: 20),
            text: 'Combined View',
          ),
          Tab(
            icon: Icon(Icons.list_rounded, size: 20),
            text: 'ListView Only',
          ),
        ],
      ),
    );
  }

  /// Combined ScrollView with ListView and GridView
  /// Uses CustomScrollView with Slivers to combine multiple scrollables
  Widget _buildCombinedScrollView() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Section Header: Featured Items
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            'Featured Items',
            Icons.star_rounded,
            const Color(0xFFF59E0B),
          ),
        ),

        // Horizontal ListView for Featured Items
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: _featuredItems.length,
              itemBuilder: (context, index) {
                return _buildFeaturedItemCard(_featuredItems[index], index);
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Section Header: Menu Categories
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            'Menu Categories',
            Icons.category_rounded,
            const Color(0xFF6366F1),
          ),
        ),

        // GridView for Categories using SliverGrid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildCategoryCard(_menuCategories[index], index);
              },
              childCount: _menuCategories.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Section Header: Recent Orders
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            'Recent Orders',
            Icons.receipt_long_rounded,
            const Color(0xFF10B981),
          ),
        ),

        // ListView for Orders using SliverList
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _orders.length - 1 ? 12 : 20,
                  ),
                  child: _buildOrderCard(_orders[index], index),
                );
              },
              childCount: _orders.length,
            ),
          ),
        ),

        // Info Card at the bottom
        SliverToBoxAdapter(
          child: _buildScrollableInfoCard(),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  /// ListView-only demo tab
  Widget _buildListViewDemo() {
    return Column(
      children: [
        // Filter chips - Horizontal ListView
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final filters = ['All', 'Queued', 'Preparing', 'Ready', 'Completed'];
                final isSelected = index == 0;
                return Padding(
                  padding: EdgeInsets.only(right: index < 4 ? 8 : 0),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filters[index]),
                    onSelected: (_) {},
                    selectedColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    checkmarkColor: const Color(0xFF6366F1),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const Divider(height: 1),

        // Main ListView with orders
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < _orders.length - 1 ? 12 : 0,
                ),
                child: _buildDetailedOrderCard(_orders[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  /// Featured Item Card for Horizontal ListView
  Widget _buildFeaturedItemCard(Map<String, dynamic> item, int index) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: index < _featuredItems.length - 1 ? 12 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => HapticFeedback.lightImpact(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    item['image'],
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                const Spacer(),
                Text(
                  item['name'],
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item['price']}',
                      style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item['rating']}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Category Card for GridView
  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    final isSelected = index == _selectedCategoryIndex;
    final color = category['color'] as Color;

    return Material(
      color: isSelected ? color : Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: isSelected ? 4 : 0,
      shadowColor: color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedCategoryIndex = index);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isSelected ? null : Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: isSelected ? Colors.white : color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category['name'],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${category['count']} items',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : const Color(0xFF94A3B8),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Order Card for ListView
  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    final status = order['status'] as String;
    Color statusColor;
    switch (status) {
      case 'Ready':
        statusColor = const Color(0xFF10B981);
        break;
      case 'Preparing':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'Completed':
        statusColor = const Color(0xFF8B5CF6);
        break;
      default:
        statusColor = const Color(0xFF3B82F6);
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => HapticFeedback.lightImpact(),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order['id'],
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['items'],
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${order['total']}',
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['time'],
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Detailed Order Card for ListView-only tab
  Widget _buildDetailedOrderCard(Map<String, dynamic> order, int index) {
    final status = order['status'] as String;
    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'Ready':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'Preparing':
        statusColor = const Color(0xFFF59E0B);
        statusIcon = Icons.restaurant_rounded;
        break;
      case 'Completed':
        statusColor = const Color(0xFF8B5CF6);
        statusIcon = Icons.verified_rounded;
        break;
      default:
        statusColor = const Color(0xFF3B82F6);
        statusIcon = Icons.pending_actions_rounded;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: () => HapticFeedback.lightImpact(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              order['id'],
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 14,
                              color: const Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order['customer'],
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: const Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order['time'],
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${order['total']}',
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order['items'],
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Educational Info Card explaining scrollable concepts
  Widget _buildScrollableInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 10),
              Text(
                'Scrollable Widgets Used',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildCodeInfo('ListView.builder', 'Efficient list with lazy loading'),
          const SizedBox(height: 8),
          _buildCodeInfo('GridView', 'Grid layout with fixed columns'),
          const SizedBox(height: 8),
          _buildCodeInfo('CustomScrollView', 'Combines multiple scrollables'),
          const SizedBox(height: 8),
          _buildCodeInfo('SliverList/SliverGrid', 'Sliver-based scrolling widgets'),
          const SizedBox(height: 8),
          _buildCodeInfo('BouncingScrollPhysics', 'iOS-style bounce effect'),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF334155),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFF59E0B),
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Builder patterns only create visible items, improving performance for large lists.',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInfo(String widget, String description) {
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
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
