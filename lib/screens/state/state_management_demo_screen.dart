import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// StateManagementDemoScreen - Demonstrates local UI state management
/// using Stateful widgets and setState().
///
/// This screen showcases:
/// - StatefulWidget lifecycle
/// - setState() for triggering UI rebuilds
/// - Conditional UI based on state values
/// - Multiple state variables working together
/// - Real-world queue management scenario
class StateManagementDemoScreen extends StatefulWidget {
  const StateManagementDemoScreen({super.key});

  @override
  State<StateManagementDemoScreen> createState() => _StateManagementDemoScreenState();
}

class _StateManagementDemoScreenState extends State<StateManagementDemoScreen>
    with SingleTickerProviderStateMixin {
  // ═══════════════════════════════════════════════════════════════════
  // STATE VARIABLES
  // These values can change during the widget's lifetime
  // ═══════════════════════════════════════════════════════════════════

  // Queue counters
  int _queuedOrders = 0;
  int _preparingOrders = 0;
  int _completedOrders = 0;

  // UI state
  bool _isRushHour = false;
  String _statusMessage = 'Ready to receive orders';
  Color _statusColor = const Color(0xFF10B981);

  // History for demonstrating state changes
  final List<String> _actionHistory = [];

  // Animation controller for visual feedback
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Threshold values for conditional UI
  static const int _rushHourThreshold = 5;
  static const int _maxQueueSize = 15;

  @override
  void initState() {
    super.initState();
    // Initialize animations
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Log initial state
    _addToHistory('Demo initialized');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The build method is called every time setState() is invoked
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: SafeArea(
        child: Column(
          children: [
            // Header with status indicator
            _buildHeader(),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status Banner (conditional UI)
                    _buildStatusBanner(),

                    const SizedBox(height: 20),

                    // Queue Stats Cards
                    _buildQueueStats(),

                    const SizedBox(height: 20),

                    // Control Buttons
                    _buildControlPanel(),

                    const SizedBox(height: 20),

                    // Quick Actions
                    _buildQuickActions(),

                    const SizedBox(height: 20),

                    // State Explanation Card
                    _buildStateExplanation(),

                    const SizedBox(height: 20),

                    // Action History
                    _buildActionHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // BUILD METHODS
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isRushHour
              ? [const Color(0xFFEF4444), const Color(0xFFF97316)]
              : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _isRushHour ? Icons.local_fire_department : Icons.speed_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'State Management Demo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Orders: ${_getTotalOrders()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Rush Hour Indicator
              if (_isRushHour)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.whatshot_rounded,
                        color: Colors.red.shade600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'RUSH',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
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

  Widget _buildStatusBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _statusColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Build #${_actionHistory.length}',
            style: TextStyle(
              color: _statusColor.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Queued',
            _queuedOrders,
            Icons.pending_actions_rounded,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Preparing',
            _preparingOrders,
            Icons.restaurant_rounded,
            const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            _completedOrders,
            Icons.check_circle_rounded,
            const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    final isHighlighted = label == 'Queued' && value >= _rushHourThreshold;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? color : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? color.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isHighlighted ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.white.withValues(alpha: 0.25)
                  : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isHighlighted ? Colors.white : color,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$value',
              key: ValueKey(value),
              style: TextStyle(
                color: isHighlighted ? Colors.white : const Color(0xFF1E293B),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isHighlighted
                  ? Colors.white.withValues(alpha: 0.9)
                  : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              Icon(Icons.tune_rounded, color: Color(0xFF6366F1), size: 20),
              SizedBox(width: 10),
              Text(
                'Queue Controls',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Queued Orders Control
          _buildCounterControl(
            'Queued Orders',
            _queuedOrders,
            const Color(0xFF3B82F6),
            onIncrement: _addToQueue,
            onDecrement: _removeFromQueue,
            canIncrement: _queuedOrders < _maxQueueSize,
            canDecrement: _queuedOrders > 0,
          ),
          const SizedBox(height: 16),

          // Preparing Orders Control
          _buildCounterControl(
            'Preparing Orders',
            _preparingOrders,
            const Color(0xFFF59E0B),
            onIncrement: _startPreparing,
            onDecrement: _cancelPreparing,
            canIncrement: _queuedOrders > 0,
            canDecrement: _preparingOrders > 0,
          ),
          const SizedBox(height: 16),

          // Complete Order Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _preparingOrders > 0 ? _completeOrder : null,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: const Text('Complete Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                disabledForegroundColor: const Color(0xFF94A3B8),
                padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildCounterControl(
    String label,
    int value,
    Color color, {
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required bool canIncrement,
    required bool canDecrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$value',
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Decrement Button
        _buildCircularButton(
          Icons.remove_rounded,
          color,
          canDecrement ? onDecrement : null,
        ),
        const SizedBox(width: 10),
        // Increment Button
        _buildCircularButton(
          Icons.add_rounded,
          color,
          canIncrement ? onIncrement : null,
        ),
      ],
    );
  }

  Widget _buildCircularButton(IconData icon, Color color, VoidCallback? onPressed) {
    final isEnabled = onPressed != null;
    return Material(
      color: isEnabled ? color : const Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            HapticFeedback.lightImpact();
            onPressed();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled ? Colors.white : const Color(0xFF94A3B8),
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            'Rush Hour',
            _isRushHour ? Icons.flash_off_rounded : Icons.flash_on_rounded,
            _isRushHour ? const Color(0xFF64748B) : const Color(0xFFEF4444),
            _toggleRushHour,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            'Reset All',
            Icons.refresh_rounded,
            const Color(0xFF6366F1),
            _resetAll,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
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

  Widget _buildStateExplanation() {
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
              Icon(Icons.code_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 10),
              Text(
                'How setState() Works',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildCodeExample(
            '1. State Change',
            '_queuedOrders = ${_queuedOrders}',
          ),
          const SizedBox(height: 8),
          _buildCodeExample(
            '2. setState() Call',
            'setState(() { _queuedOrders++; })',
          ),
          const SizedBox(height: 8),
          _buildCodeExample(
            '3. Build Triggered',
            'build() called → UI updates',
          ),

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
                Expanded(
                  child: Text(
                    'setState() marks widget as "dirty" and schedules a rebuild. Only modified state triggers UI updates.',
                    style: const TextStyle(
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

  Widget _buildCodeExample(String label, String code) {
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
            label,
            style: const TextStyle(
              color: Color(0xFF818CF8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            code,
            style: const TextStyle(
              color: Color(0xFF10B981),
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionHistory() {
    if (_actionHistory.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.history_rounded, color: Color(0xFF64748B), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'State Change History',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${_actionHistory.length} changes',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_actionHistory.reversed.take(5).toList().asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key < 4 ? 8 : 0),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: entry.key == 0
                          ? const Color(0xFF10B981)
                          : const Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: entry.key == 0
                            ? const Color(0xFF1E293B)
                            : const Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: entry.key == 0 ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
          if (_actionHistory.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '+ ${_actionHistory.length - 5} more actions',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // STATE MODIFICATION METHODS
  // All state changes MUST use setState() to trigger UI rebuilds
  // ═══════════════════════════════════════════════════════════════════

  void _addToQueue() {
    setState(() {
      _queuedOrders++;
      _updateStatus();
      _addToHistory('Added order to queue → Queued: $_queuedOrders');
    });
  }

  void _removeFromQueue() {
    setState(() {
      if (_queuedOrders > 0) {
        _queuedOrders--;
        _updateStatus();
        _addToHistory('Removed order from queue → Queued: $_queuedOrders');
      }
    });
  }

  void _startPreparing() {
    setState(() {
      if (_queuedOrders > 0) {
        _queuedOrders--;
        _preparingOrders++;
        _updateStatus();
        _addToHistory('Started preparing order → Preparing: $_preparingOrders');
      }
    });
  }

  void _cancelPreparing() {
    setState(() {
      if (_preparingOrders > 0) {
        _preparingOrders--;
        _queuedOrders++;
        _updateStatus();
        _addToHistory('Cancelled preparation → Back to queue');
      }
    });
  }

  void _completeOrder() {
    setState(() {
      if (_preparingOrders > 0) {
        _preparingOrders--;
        _completedOrders++;
        _updateStatus();
        _addToHistory('Completed order → Total completed: $_completedOrders');
      }
    });
  }

  void _toggleRushHour() {
    setState(() {
      _isRushHour = !_isRushHour;
      _updateStatus();
      _addToHistory(_isRushHour ? 'Rush hour activated!' : 'Rush hour deactivated');

      if (_isRushHour) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  void _resetAll() {
    setState(() {
      _queuedOrders = 0;
      _preparingOrders = 0;
      _completedOrders = 0;
      _isRushHour = false;
      _statusMessage = 'Ready to receive orders';
      _statusColor = const Color(0xFF10B981);
      _actionHistory.clear();
      _addToHistory('All counters reset');
      _pulseController.stop();
      _pulseController.reset();
    });
  }

  // ═══════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════

  void _updateStatus() {
    // Conditional logic based on state values
    if (_queuedOrders >= _maxQueueSize) {
      _statusMessage = 'Queue is full! Complete some orders.';
      _statusColor = const Color(0xFFEF4444);
    } else if (_queuedOrders >= _rushHourThreshold) {
      _statusMessage = 'High demand! ${_queuedOrders} orders waiting.';
      _statusColor = const Color(0xFFF59E0B);
      if (!_isRushHour) {
        _isRushHour = true;
        _pulseController.repeat(reverse: true);
      }
    } else if (_preparingOrders > 0) {
      _statusMessage = 'Preparing $_preparingOrders order(s)...';
      _statusColor = const Color(0xFFF59E0B);
    } else if (_queuedOrders > 0) {
      _statusMessage = '$_queuedOrders order(s) in queue';
      _statusColor = const Color(0xFF3B82F6);
    } else {
      _statusMessage = 'Ready to receive orders';
      _statusColor = const Color(0xFF10B981);
      if (_isRushHour && _queuedOrders < _rushHourThreshold) {
        _isRushHour = false;
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  int _getTotalOrders() {
    return _queuedOrders + _preparingOrders + _completedOrders;
  }

  Color _getBackgroundColor() {
    // Background changes based on state (conditional UI)
    if (_isRushHour) {
      return const Color(0xFFFEF2F2);
    } else if (_queuedOrders >= _rushHourThreshold) {
      return const Color(0xFFFFFBEB);
    }
    return const Color(0xFFF8FAFC);
  }

  void _addToHistory(String action) {
    _actionHistory.add(action);
  }
}
