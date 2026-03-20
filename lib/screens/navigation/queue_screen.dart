import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Queue Screen - Demonstrates navigation stack management.
/// This screen shows the order queue and demonstrates various
/// navigation patterns including push, pop, and replace.
class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  // Sample queue data
  static final List<Map<String, dynamic>> _queueItems = [
    {'id': 'ORD-001', 'title': '2x Burger, 1x Fries', 'status': 'Preparing', 'position': 1},
    {'id': 'ORD-002', 'title': '1x Pizza Margherita', 'status': 'Queued', 'position': 2},
    {'id': 'ORD-003', 'title': '3x Tacos, 1x Nachos', 'status': 'Queued', 'position': 3},
    {'id': 'ORD-004', 'title': '2x Sandwich, 2x Coffee', 'status': 'Queued', 'position': 4},
    {'id': 'ORD-005', 'title': '1x Salad Bowl', 'status': 'Queued', 'position': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Order Queue'),
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            // Standard pop navigation
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF59E0B),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildHeaderStat('In Queue', '5', Icons.queue_rounded),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildHeaderStat('Preparing', '1', Icons.restaurant_rounded),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildHeaderStat('Avg Wait', '12m', Icons.timer_rounded),
                ),
              ],
            ),
          ),

          // Queue List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _queueItems.length + 1,
              itemBuilder: (context, index) {
                if (index == _queueItems.length) {
                  return _buildNavigationInfoCard(context);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildQueueItem(context, _queueItems[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQueueItem(BuildContext context, Map<String, dynamic> item) {
    final isFirst = item['position'] == 1;
    final statusColor = isFirst ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          // Navigate to order details with data
          Navigator.pushNamed(
            context,
            '/order-details',
            arguments: {
              'id': item['id'],
              'title': item['title'],
              'status': item['status'],
              'customer': 'Customer ${item['position']}',
              'total': 25.99,
              'time': '${item['position'] * 3} mins ago',
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFirst 
                  ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
                  : const Color(0xFFE2E8F0),
              width: isFirst ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Position Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '#${item['position']}',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              
              // Order Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item['id'],
                          style: const TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isFirst) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['title'],
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
              
              // Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: const Color(0xFF94A3B8),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
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
              Icon(Icons.navigation_rounded, color: Color(0xFFF59E0B)),
              SizedBox(width: 10),
              Text(
                'Navigation Stack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Current navigation stack:',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          _buildStackItem('Home Screen', '/home', false),
          _buildStackArrow(),
          _buildStackItem('Queue Screen', '/queue', true),
          const SizedBox(height: 16),
          const Text(
            'Tapping an order will push Order Details onto the stack.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackItem(String name, String route, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent 
            ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
            : const Color(0xFF334155),
        borderRadius: BorderRadius.circular(8),
        border: isCurrent 
            ? Border.all(color: const Color(0xFFF59E0B))
            : null,
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.location_on_rounded : Icons.layers_rounded,
            color: isCurrent ? const Color(0xFFF59E0B) : const Color(0xFF64748B),
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            name,
            style: TextStyle(
              color: isCurrent ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            route,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 20),
          Icon(
            Icons.arrow_downward_rounded,
            color: Color(0xFF64748B),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Pop to go back
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFF59E0B)),
                foregroundColor: const Color(0xFFF59E0B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                // Pop until home (clear stack to home)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home_rounded, size: 18),
              label: const Text('Pop to Root'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
