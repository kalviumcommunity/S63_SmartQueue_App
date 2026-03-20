import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Demo screen for demonstrating Flutter development tools:
/// - Hot Reload: Instant UI updates while preserving state
/// - Debug Console: Logging and error tracking
/// - Flutter DevTools: Widget inspection, performance monitoring
///
/// This screen provides interactive examples to understand these tools.
class DevToolsDemo extends StatefulWidget {
  const DevToolsDemo({super.key});

  @override
  State<DevToolsDemo> createState() => _DevToolsDemoState();
}

class _DevToolsDemoState extends State<DevToolsDemo> {
  // State variables for demonstrating Hot Reload preservation
  int _counter = 0;
  String _message = 'Welcome to SmartQueue!';
  Color _themeColor = const Color(0xFF6366F1);
  bool _isExpanded = false;
  
  // List to track actions for debug console demo
  final List<String> _actionLog = [];

  @override
  void initState() {
    super.initState();
    _logDebug('DevToolsDemo initialized');
    _logDebug('Initial counter value: $_counter');
  }

  /// Logs a debug message to the console
  /// This demonstrates how to use debug logging effectively
  void _logDebug(String message) {
    // Using debugPrint for better output handling
    debugPrint('[SmartQueue Debug] $message');
    
    // Add to visual log
    setState(() {
      _actionLog.add('${DateTime.now().toString().substring(11, 19)} - $message');
      if (_actionLog.length > 10) {
        _actionLog.removeAt(0);
      }
    });
  }

  /// Logs detailed information about widget state
  void _logWidgetInfo() {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('[SmartQueue] Widget State Information:');
    debugPrint('  ├─ Counter: $_counter');
    debugPrint('  ├─ Message: $_message');
    debugPrint('  ├─ Theme Color: $_themeColor');
    debugPrint('  ├─ Is Expanded: $_isExpanded');
    debugPrint('  └─ Action Log Count: ${_actionLog.length}');
    debugPrint('═══════════════════════════════════════════');
  }

  /// Increments counter and logs the action
  void _incrementCounter() {
    HapticFeedback.lightImpact();
    setState(() {
      _counter++;
    });
    _logDebug('Counter incremented to $_counter');
    
    // Demonstrate different log levels
    if (_counter % 5 == 0) {
      debugPrint('[SmartQueue INFO] Milestone reached: $_counter orders!');
    }
    if (_counter >= 10) {
      debugPrint('[SmartQueue WARNING] High order count: $_counter');
    }
  }

  /// Decrements counter with validation
  void _decrementCounter() {
    HapticFeedback.lightImpact();
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
      _logDebug('Counter decremented to $_counter');
    } else {
      _logDebug('Cannot decrement: counter is already 0');
      debugPrint('[SmartQueue ERROR] Attempted to decrement below zero');
    }
  }

  /// Changes the theme color
  void _cycleThemeColor() {
    HapticFeedback.mediumImpact();
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Purple
    ];
    
    final currentIndex = colors.indexOf(_themeColor);
    final nextIndex = (currentIndex + 1) % colors.length;
    
    setState(() {
      _themeColor = colors[nextIndex];
    });
    
    _logDebug('Theme color changed to index $nextIndex');
    debugPrint('[SmartQueue] Color value: ${_themeColor.value.toRadixString(16)}');
  }

  /// Updates the message text
  void _updateMessage() {
    HapticFeedback.lightImpact();
    final messages = [
      'Welcome to SmartQueue!',
      'Ready to take orders',
      'Queue is active',
      'Processing orders...',
      'All systems operational',
    ];
    
    final currentIndex = messages.indexOf(_message);
    final nextIndex = (currentIndex + 1) % messages.length;
    
    setState(() {
      _message = messages[nextIndex];
    });
    
    _logDebug('Message updated: $_message');
  }

  /// Toggles the expanded state
  void _toggleExpanded() {
    HapticFeedback.selectionClick();
    setState(() {
      _isExpanded = !_isExpanded;
    });
    _logDebug('Panel ${_isExpanded ? "expanded" : "collapsed"}');
  }

  /// Simulates an error for debugging demonstration
  void _simulateError() {
    HapticFeedback.heavyImpact();
    _logDebug('Simulating error condition...');
    
    try {
      // Intentional error simulation
      throw Exception('Simulated error for debugging demonstration');
    } catch (e, stackTrace) {
      debugPrint('[SmartQueue ERROR] ${e.toString()}');
      debugPrint('[SmartQueue STACK] ${stackTrace.toString().split('\n').take(3).join('\n')}');
      _logDebug('Error caught and logged to console');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.bug_report, color: Colors.white),
                SizedBox(width: 12),
                Text('Error logged to Debug Console'),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  /// Logs performance timing information
  void _logPerformance() {
    HapticFeedback.lightImpact();
    final stopwatch = Stopwatch()..start();
    
    // Simulate some work
    int sum = 0;
    for (int i = 0; i < 100000; i++) {
      sum += i;
    }
    
    stopwatch.stop();
    
    debugPrint('[SmartQueue PERF] Computation completed');
    debugPrint('[SmartQueue PERF] Result: $sum');
    debugPrint('[SmartQueue PERF] Time: ${stopwatch.elapsedMicroseconds}μs');
    
    _logDebug('Performance test: ${stopwatch.elapsedMicroseconds}μs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Dev Tools Demo'),
        backgroundColor: _themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _logWidgetInfo,
            tooltip: 'Log Widget Info',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hot Reload Demo Section
              _buildHotReloadSection(),
              
              const SizedBox(height: 20),
              
              // Interactive Counter Section
              _buildCounterSection(),
              
              const SizedBox(height: 20),
              
              // Debug Console Demo Section
              _buildDebugConsoleSection(),
              
              const SizedBox(height: 20),
              
              // DevTools Info Section
              _buildDevToolsSection(),
              
              const SizedBox(height: 20),
              
              // Action Log Section
              _buildActionLogSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotReloadSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_themeColor, _themeColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flash_on_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'HOT RELOAD DEMO',
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
          
          // Dynamic Message - Change this text and Hot Reload!
          Text(
            _message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Instructions
          const Text(
            'Try changing the text above in code, then press Ctrl+S (or Cmd+S) to Hot Reload. The counter below will preserve its value!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Change Message',
                  Icons.edit_rounded,
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white,
                  _updateMessage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Change Color',
                  Icons.palette_rounded,
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white,
                  _cycleThemeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection() {
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
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_rounded, color: Color(0xFF64748B)),
              SizedBox(width: 10),
              Text(
                'State Preservation Demo',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'This counter value persists through Hot Reload but resets on Hot Restart.',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Counter Display
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            decoration: BoxDecoration(
              color: _themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _themeColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Order Count',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    _counter.toString(),
                    key: ValueKey<int>(_counter),
                    style: TextStyle(
                      color: _themeColor,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Counter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircleButton(
                Icons.remove_rounded,
                _decrementCounter,
                const Color(0xFFEF4444),
              ),
              const SizedBox(width: 24),
              _buildCircleButton(
                Icons.add_rounded,
                _incrementCounter,
                const Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebugConsoleSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const Row(
            children: [
              Icon(Icons.terminal_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 10),
              Text(
                'Debug Console Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Tap buttons below to see different log outputs in the Debug Console.',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Debug Action Buttons
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildDebugButton(
                'Log Info',
                Icons.info_outline,
                const Color(0xFF3B82F6),
                () {
                  _logDebug('Information log message');
                  debugPrint('[SmartQueue INFO] This is an informational message');
                },
              ),
              _buildDebugButton(
                'Log Warning',
                Icons.warning_amber_rounded,
                const Color(0xFFF59E0B),
                () {
                  _logDebug('Warning log message');
                  debugPrint('[SmartQueue WARNING] This is a warning message');
                },
              ),
              _buildDebugButton(
                'Log Error',
                Icons.error_outline,
                const Color(0xFFEF4444),
                _simulateError,
              ),
              _buildDebugButton(
                'Log Perf',
                Icons.speed_rounded,
                const Color(0xFF8B5CF6),
                _logPerformance,
              ),
              _buildDebugButton(
                'Widget Info',
                Icons.widgets_outlined,
                const Color(0xFF06B6D4),
                _logWidgetInfo,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Console Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Debug Console Preview',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '> [SmartQueue Debug] Counter incremented to 5\n'
                  '> [SmartQueue INFO] Milestone reached: 5 orders!\n'
                  '> [SmartQueue PERF] Time: 234μs',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontFamily: 'monospace',
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevToolsSection() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.developer_mode_rounded,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter DevTools',
                        style: TextStyle(
                          color: Color(0xFF1E293B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tap to expand features',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    _buildDevToolFeature(
                      'Widget Inspector',
                      'Visualize and explore the widget tree structure',
                      Icons.account_tree_rounded,
                      const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 12),
                    _buildDevToolFeature(
                      'Performance',
                      'Monitor frame rendering and UI performance',
                      Icons.speed_rounded,
                      const Color(0xFF10B981),
                    ),
                    const SizedBox(height: 12),
                    _buildDevToolFeature(
                      'Memory',
                      'Analyze memory usage and detect leaks',
                      Icons.memory_rounded,
                      const Color(0xFFF59E0B),
                    ),
                    const SizedBox(height: 12),
                    _buildDevToolFeature(
                      'Network',
                      'Inspect API calls and network traffic',
                      Icons.wifi_rounded,
                      const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.launch_rounded, color: Color(0xFF64748B), size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Launch DevTools: Run "flutter pub global activate devtools" then "dart devtools"',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: _isExpanded 
                  ? CrossFadeState.showSecond 
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionLogSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                  Icon(Icons.history_rounded, color: Color(0xFF64748B)),
                  SizedBox(width: 10),
                  Text(
                    'Action Log',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${_actionLog.length} entries',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (_actionLog.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Interact with the demo to see logs appear here',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ...List.generate(
              _actionLog.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: _themeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _actionLog[_actionLog.length - 1 - index],
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color bgColor,
    Color fgColor,
    VoidCallback onPressed,
  ) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fgColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: fgColor,
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

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed, Color color) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildDebugButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
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
        ),
      ),
    );
  }

  Widget _buildDevToolFeature(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
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
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
