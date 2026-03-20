import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Demo screen demonstrating the difference between Stateless and Stateful widgets.
/// This screen shows how static UI components (Stateless) remain unchanged while
/// dynamic UI components (Stateful) update in response to user interaction.
class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Widget Demo'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stateless Widget Section
              StaticHeaderSection(),
              
              SizedBox(height: 24),
              
              // Stateful Widget Section
              DynamicQueueSection(),
              
              SizedBox(height: 24),
              
              // Comparison Info Card
              ComparisonInfoCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STATELESS WIDGET SECTION
// This widget is static and does not change after being built.
// It demonstrates UI components that remain constant throughout the app lifecycle.
// ============================================================================

/// A Stateless widget that displays static header content.
/// This content never changes regardless of user interaction.
class StaticHeaderSection extends StatelessWidget {
  const StaticHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge indicating this is a Stateless Widget
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'STATELESS WIDGET',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Static Title - Never changes
          const Row(
            children: [
              Icon(
                Icons.storefront_rounded,
                color: Colors.white,
                size: 32,
              ),
              SizedBox(width: 12),
              Text(
                'SmartQueue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Static Subtitle - Never changes
          const Text(
            'Intelligent Order Management System',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Static Info Row - Never changes
          Row(
            children: [
              _buildStaticInfoChip(Icons.speed_rounded, 'Fast'),
              const SizedBox(width: 8),
              _buildStaticInfoChip(Icons.verified_rounded, 'Reliable'),
              const SizedBox(width: 8),
              _buildStaticInfoChip(Icons.cloud_done_rounded, 'Cloud Sync'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Explanation text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This section is built with a Stateless Widget. No matter how many times you interact with the app, this content remains exactly the same.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.4,
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

  Widget _buildStaticInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// STATEFUL WIDGET SECTION
// This widget maintains internal state and updates the UI when state changes.
// It demonstrates dynamic UI components that respond to user interaction.
// ============================================================================

/// A Stateful widget that manages dynamic queue data.
/// The UI updates whenever the user interacts with the buttons.
class DynamicQueueSection extends StatefulWidget {
  const DynamicQueueSection({super.key});

  @override
  State<DynamicQueueSection> createState() => _DynamicQueueSectionState();
}

class _DynamicQueueSectionState extends State<DynamicQueueSection> {
  // State variables - these can change and trigger UI rebuilds
  int _queueCount = 0;
  int _preparingCount = 0;
  int _completedCount = 0;
  String _statusMessage = 'Tap buttons to update the queue';
  Color _statusColor = const Color(0xFF64748B);

  // Method to add a new order to queue
  void _addToQueue() {
    HapticFeedback.mediumImpact();
    setState(() {
      _queueCount++;
      _statusMessage = 'New order added to queue!';
      _statusColor = const Color(0xFF3B82F6);
    });
  }

  // Method to move order to preparing
  void _startPreparing() {
    if (_queueCount > 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _queueCount--;
        _preparingCount++;
        _statusMessage = 'Order moved to preparing!';
        _statusColor = const Color(0xFFF59E0B);
      });
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _statusMessage = 'No orders in queue!';
        _statusColor = const Color(0xFFEF4444);
      });
    }
  }

  // Method to complete an order
  void _completeOrder() {
    if (_preparingCount > 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _preparingCount--;
        _completedCount++;
        _statusMessage = 'Order completed successfully!';
        _statusColor = const Color(0xFF10B981);
      });
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _statusMessage = 'No orders being prepared!';
        _statusColor = const Color(0xFFEF4444);
      });
    }
  }

  // Method to reset all counts
  void _resetAll() {
    HapticFeedback.heavyImpact();
    setState(() {
      _queueCount = 0;
      _preparingCount = 0;
      _completedCount = 0;
      _statusMessage = 'All counters reset to zero';
      _statusColor = const Color(0xFF64748B);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge indicating this is a Stateful Widget
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sync_rounded, color: Color(0xFF10B981), size: 14),
                SizedBox(width: 6),
                Text(
                  'STATEFUL WIDGET',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Section Title
          const Text(
            'Queue Management',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Dynamic Status Message - Changes based on actions
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _statusColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _statusColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Dynamic Counter Cards - Values change on interaction
          Row(
            children: [
              Expanded(
                child: _buildCounterCard(
                  'Queued',
                  _queueCount,
                  const Color(0xFF3B82F6),
                  Icons.pending_actions_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCounterCard(
                  'Preparing',
                  _preparingCount,
                  const Color(0xFFF59E0B),
                  Icons.restaurant_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCounterCard(
                  'Completed',
                  _completedCount,
                  const Color(0xFF10B981),
                  Icons.check_circle_rounded,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Interactive Buttons - Trigger state changes
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Add Order',
                      Icons.add_circle_outline,
                      const Color(0xFF3B82F6),
                      _addToQueue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Start Prep',
                      Icons.play_circle_outline,
                      const Color(0xFFF59E0B),
                      _startPreparing,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'Complete',
                      Icons.check_circle_outline,
                      const Color(0xFF10B981),
                      _completeOrder,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      'Reset All',
                      Icons.refresh_rounded,
                      const Color(0xFFEF4444),
                      _resetAll,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Explanation text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF64748B), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This section is built with a Stateful Widget. Each button tap calls setState(), which triggers a UI rebuild. Notice how the counters, message, and colors update dynamically!',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.4,
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

  Widget _buildCounterCard(String label, int count, Color color, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              count.toString(),
              key: ValueKey<int>(count),
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMPARISON INFO CARD
// A Stateless widget explaining the difference between the two widget types.
// ============================================================================

/// A Stateless widget that displays comparison information.
class ComparisonInfoCard extends StatelessWidget {
  const ComparisonInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.compare_arrows_rounded,
                color: Color(0xFF6366F1),
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Quick Comparison',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Stateless comparison
          _buildComparisonRow(
            'Stateless',
            'No internal state, build() called once',
            const Color(0xFF6366F1),
            Icons.lock_outline,
          ),
          
          const SizedBox(height: 12),
          
          // Stateful comparison
          _buildComparisonRow(
            'Stateful',
            'Maintains state, rebuild on setState()',
            const Color(0xFF10B981),
            Icons.sync_rounded,
          ),
          
          const SizedBox(height: 16),
          
          const Divider(color: Color(0xFFE2E8F0)),
          
          const SizedBox(height: 16),
          
          // Key takeaway
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withValues(alpha: 0.1),
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.tips_and_updates_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Use Stateless for static content, Stateful when UI needs to change based on user interaction or data.',
                    style: TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
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

  Widget _buildComparisonRow(
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
