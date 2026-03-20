import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Statistics Screen - Additional navigation destination.
/// Demonstrates a deeper level in the navigation stack.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Today\'s Orders',
                    '47',
                    '+12%',
                    Icons.shopping_bag_rounded,
                    const Color(0xFF3B82F6),
                    true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Revenue',
                    '\$1,234',
                    '+8%',
                    Icons.attach_money_rounded,
                    const Color(0xFF10B981),
                    true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Avg. Wait Time',
                    '8 min',
                    '-15%',
                    Icons.timer_rounded,
                    const Color(0xFFF59E0B),
                    false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Satisfaction',
                    '4.8',
                    '+5%',
                    Icons.star_rounded,
                    const Color(0xFF8B5CF6),
                    true,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Chart Placeholder
            _buildChartPlaceholder(),
            
            const SizedBox(height: 24),
            
            // Navigation Info
            _buildNavigationInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive 
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 200,
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
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Color(0xFF6366F1)),
              SizedBox(width: 10),
              Text(
                'Weekly Overview',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Mon', 0.6, const Color(0xFF6366F1)),
                _buildBar('Tue', 0.8, const Color(0xFF6366F1)),
                _buildBar('Wed', 0.5, const Color(0xFF6366F1)),
                _buildBar('Thu', 0.9, const Color(0xFF6366F1)),
                _buildBar('Fri', 1.0, const Color(0xFF10B981)),
                _buildBar('Sat', 0.7, const Color(0xFF6366F1)),
                _buildBar('Sun', 0.4, const Color(0xFF6366F1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 80 * height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationInfo(BuildContext context) {
    return Container(
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
              Icon(Icons.layers_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 10),
              Text(
                'Current Navigation Stack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildStackVisualization(),
          
          const SizedBox(height: 20),
          
          // Navigation buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Pop'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF334155),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home_rounded, size: 18),
                  label: const Text('Pop to Home'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStackVisualization() {
    return Column(
      children: [
        _buildStackLevel('Statistics', '/statistics', true, 2),
        _buildStackConnector(),
        _buildStackLevel('Settings (if came from)', '/settings', false, 1),
        _buildStackConnector(),
        _buildStackLevel('Home', '/navigation-home', false, 0),
      ],
    );
  }

  Widget _buildStackLevel(String name, String route, bool isCurrent, int level) {
    final color = isCurrent ? const Color(0xFF10B981) : const Color(0xFF64748B);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent 
            ? const Color(0xFF10B981).withValues(alpha: 0.2)
            : const Color(0xFF334155),
        borderRadius: BorderRadius.circular(8),
        border: isCurrent 
            ? Border.all(color: const Color(0xFF10B981))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$level',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isCurrent ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                fontSize: 13,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Text(
            route,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          if (isCurrent) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF10B981),
              size: 14,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStackConnector() {
    return Container(
      height: 20,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 11),
      child: Container(
        width: 2,
        height: 20,
        color: const Color(0xFF475569),
      ),
    );
  }
}
