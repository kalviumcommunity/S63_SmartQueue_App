import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// AnimationDemoScreen - Demonstrates Flutter animations and transitions.
///
/// This screen showcases:
/// 1. Implicit Animations - AnimatedContainer, AnimatedOpacity, etc.
/// 2. Explicit Animations - AnimationController, Tween, Transform
/// 3. Page Transitions - Custom route animations
class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen>
    with TickerProviderStateMixin {
  // ═══════════════════════════════════════════════════════════════════
  // IMPLICIT ANIMATION STATE
  // ═══════════════════════════════════════════════════════════════════
  bool _isExpanded = false;
  bool _isVisible = true;
  double _containerSize = 100;
  Color _containerColor = const Color(0xFF6366F1);
  BorderRadius _containerRadius = BorderRadius.circular(16);
  int _selectedIndex = 0;

  // ═══════════════════════════════════════════════════════════════════
  // EXPLICIT ANIMATION CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation - continuous 360° rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Pulse animation - scale up and down
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Bounce animation - single bounce effect
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Implicit Animations
                    _buildSectionTitle('Implicit Animations'),
                    const SizedBox(height: 12),
                    _buildImplicitAnimationsSection(),

                    const SizedBox(height: 28),

                    // Section 2: AnimatedSwitcher
                    _buildSectionTitle('AnimatedSwitcher'),
                    const SizedBox(height: 12),
                    _buildAnimatedSwitcherSection(),

                    const SizedBox(height: 28),

                    // Section 3: Explicit Animations
                    _buildSectionTitle('Explicit Animations'),
                    const SizedBox(height: 12),
                    _buildExplicitAnimationsSection(),

                    const SizedBox(height: 28),

                    // Section 4: Staggered Animations
                    _buildSectionTitle('Staggered Animation'),
                    const SizedBox(height: 12),
                    _buildStaggeredAnimationSection(),

                    const SizedBox(height: 28),

                    // Section 5: Page Transitions
                    _buildSectionTitle('Page Transitions'),
                    const SizedBox(height: 12),
                    _buildPageTransitionsSection(),

                    const SizedBox(height: 28),

                    // Info Card
                    _buildAnimationInfoCard(),
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
  // HEADER
  // ═══════════════════════════════════════════════════════════════════

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
          // Animated icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.animation_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Animation Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Implicit & Explicit Animations',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // IMPLICIT ANIMATIONS SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildImplicitAnimationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          // AnimatedContainer demo
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AnimatedContainer',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap button to animate size, color, and shape',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _toggleContainer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Animate'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // The animated container
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _containerSize,
              height: _containerSize,
              decoration: BoxDecoration(
                color: _containerColor,
                borderRadius: _containerRadius,
                boxShadow: [
                  BoxShadow(
                    color: _containerColor.withValues(alpha: 0.4),
                    blurRadius: _isExpanded ? 20 : 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  _isExpanded ? Icons.check_rounded : Icons.touch_app_rounded,
                  color: Colors.white,
                  size: _isExpanded ? 48 : 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // AnimatedOpacity demo
          Row(
            children: [
              Expanded(
                child: const Text(
                  'AnimatedOpacity',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _isVisible,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  setState(() => _isVisible = value);
                },
                activeColor: const Color(0xFF6366F1),
              ),
            ],
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _isVisible ? 1.0 : 0.0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'I fade in and out! 👋',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleContainer() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isExpanded = !_isExpanded;
      _containerSize = _isExpanded ? 150 : 100;
      _containerColor = _isExpanded
          ? const Color(0xFF10B981)
          : const Color(0xFF6366F1);
      _containerRadius = _isExpanded
          ? BorderRadius.circular(75)
          : BorderRadius.circular(16);
    });
  }

  // ═══════════════════════════════════════════════════════════════════
  // ANIMATED SWITCHER SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAnimatedSwitcherSection() {
    final items = ['Orders', 'Queue', 'Ready', 'Done'];
    final icons = [
      Icons.receipt_long_rounded,
      Icons.queue_rounded,
      Icons.check_circle_rounded,
      Icons.verified_rounded,
    ];
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          // Tab buttons
          Row(
            children: List.generate(items.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors[index]
                          : colors[index].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        items[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : colors[index],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // Animated content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(_selectedIndex),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors[_selectedIndex].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[_selectedIndex],
                    color: colors[_selectedIndex],
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${items[_selectedIndex]} View',
                    style: TextStyle(
                      color: colors[_selectedIndex],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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

  // ═══════════════════════════════════════════════════════════════════
  // EXPLICIT ANIMATIONS SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildExplicitAnimationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          const Text(
            'Controlled Animations',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Using AnimationController & Tween',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rotation animation
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.sync_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rotation',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Pulse animation
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Pulse',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Bounce animation (triggered)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      _bounceController.forward(from: 0);
                    },
                    child: AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + (_bounceAnimation.value * 0.3),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.touch_app_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap Me',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // STAGGERED ANIMATION SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildStaggeredAnimationSection() {
    return const _StaggeredAnimationDemo();
  }

  // ═══════════════════════════════════════════════════════════════════
  // PAGE TRANSITIONS SECTION
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPageTransitionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          const Text(
            'Custom Page Transitions',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTransitionButton(
                  'Slide',
                  Icons.swap_horiz_rounded,
                  const Color(0xFF3B82F6),
                  () => _navigateWithTransition(TransitionType.slide),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTransitionButton(
                  'Fade',
                  Icons.blur_on_rounded,
                  const Color(0xFF10B981),
                  () => _navigateWithTransition(TransitionType.fade),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTransitionButton(
                  'Scale',
                  Icons.zoom_out_map_rounded,
                  const Color(0xFFF59E0B),
                  () => _navigateWithTransition(TransitionType.scale),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTransitionButton(
                  'Rotation',
                  Icons.rotate_right_rounded,
                  const Color(0xFF8B5CF6),
                  () => _navigateWithTransition(TransitionType.rotation),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransitionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
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

  void _navigateWithTransition(TransitionType type) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return _TransitionDemoPage(transitionType: type);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          switch (type) {
            case TransitionType.slide:
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            case TransitionType.fade:
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            case TransitionType.scale:
              return ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            case TransitionType.rotation:
              return RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
          }
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // INFO CARD
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildAnimationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 10),
              Text(
                'Animation Types',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Implicit', 'AnimatedContainer, AnimatedOpacity'),
          const SizedBox(height: 8),
          _buildInfoRow('Explicit', 'AnimationController + Tween'),
          const SizedBox(height: 8),
          _buildInfoRow('Transitions', 'PageRouteBuilder'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String description) {
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
              fontSize: 11,
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
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// STAGGERED ANIMATION WIDGET
// ═══════════════════════════════════════════════════════════════════

class _StaggeredAnimationDemo extends StatefulWidget {
  const _StaggeredAnimationDemo();

  @override
  State<_StaggeredAnimationDemo> createState() => _StaggeredAnimationDemoState();
}

class _StaggeredAnimationDemoState extends State<_StaggeredAnimationDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAnimation() {
    HapticFeedback.mediumImpact();
    setState(() => _isAnimating = true);
    _controller.forward(from: 0).then((_) {
      setState(() => _isAnimating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Cards Animation',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: _isAnimating ? null : _playAnimation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(_isAnimating ? 'Playing...' : 'Play'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) {
            final startInterval = index * 0.2;
            final endInterval = startInterval + 0.4;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final animationValue = Interval(
                  startInterval,
                  endInterval.clamp(0.0, 1.0),
                  curve: Curves.easeOutBack,
                ).transform(_controller.value);

                return Transform.translate(
                  offset: Offset(50 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: _buildOrderCard(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderCard(int index) {
    final orders = [
      ('ORD-001', 'Burger Combo', const Color(0xFF3B82F6)),
      ('ORD-002', 'Pizza Special', const Color(0xFFF59E0B)),
      ('ORD-003', 'Salad Bowl', const Color(0xFF10B981)),
    ];

    return Container(
      margin: EdgeInsets.only(bottom: index < 2 ? 10 : 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: orders[index].$3.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: orders[index].$3.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: orders[index].$3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orders[index].$1,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  orders[index].$2,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: orders[index].$3),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// TRANSITION DEMO PAGE
// ═══════════════════════════════════════════════════════════════════

enum TransitionType { slide, fade, scale, rotation }

class _TransitionDemoPage extends StatelessWidget {
  final TransitionType transitionType;

  const _TransitionDemoPage({required this.transitionType});

  @override
  Widget build(BuildContext context) {
    final colors = {
      TransitionType.slide: const Color(0xFF3B82F6),
      TransitionType.fade: const Color(0xFF10B981),
      TransitionType.scale: const Color(0xFFF59E0B),
      TransitionType.rotation: const Color(0xFF8B5CF6),
    };

    final names = {
      TransitionType.slide: 'Slide',
      TransitionType.fade: 'Fade',
      TransitionType.scale: 'Scale',
      TransitionType.rotation: 'Rotation',
    };

    return Scaffold(
      backgroundColor: colors[transitionType],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.animation_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${names[transitionType]} Transition',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This page was animated with\na ${names[transitionType]!.toLowerCase()} transition',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: colors[transitionType],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
