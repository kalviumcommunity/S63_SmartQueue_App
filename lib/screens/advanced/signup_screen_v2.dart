import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

import '../../core/animations/animated_gradient.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/animated_button.dart';
import '../../services/auth_service.dart';
import '../auth_screen.dart';

class SignupScreenV2 extends StatefulWidget {
  const SignupScreenV2({super.key});

  @override
  State<SignupScreenV2> createState() => _SignupScreenV2State();
}

class _SignupScreenV2State extends State<SignupScreenV2>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  double _passwordStrength = 0;
  
  final AuthService _authService = AuthService();
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0;
    
    if (password.length >= 6) strength += 0.2;
    if (password.length >= 8) strength += 0.1;
    if (password.length >= 12) strength += 0.1;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.15;
    
    setState(() => _passwordStrength = strength.clamp(0, 1));
  }

  void _shake() {
    _shakeController.forward().then((_) => _shakeController.reverse());
    HapticFeedback.heavyImpact();
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.3) return Colors.red;
    if (_passwordStrength < 0.6) return Colors.orange;
    if (_passwordStrength < 0.8) return Colors.yellow.shade700;
    return Colors.green;
  }

  String _getStrengthText() {
    if (_passwordStrength < 0.3) return 'Weak';
    if (_passwordStrength < 0.6) return 'Fair';
    if (_passwordStrength < 0.8) return 'Good';
    return 'Strong';
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      _shake();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _authService.signOut();
      
      _confettiController.play();
      HapticFeedback.heavyImpact();
      
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Account created successfully! Please login.',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AuthScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        }
      }
    } catch (error) {
      _shake();
      String message = 'Something went wrong. Please try again.';
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            message = 'This email is already registered. Try logging in.';
            break;
          case 'weak-password':
            message = 'Password is too weak. Use at least 6 characters.';
            break;
          case 'invalid-email':
            message = 'Please enter a valid email address.';
            break;
          default:
            message = error.message ?? message;
        }
      }
      if (mounted) {
        setState(() {
          _errorMessage = message;
          _isLoading = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          MeshGradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height - MediaQuery.of(context).padding.top,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Back Button & Title
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                Navigator.of(context).pop();
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ).animate().fadeIn().slideX(begin: -0.2),
                        
                        const SizedBox(height: 20),
                        
                        // Header
                        Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join SmartQueue today',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.2),
                        
                        const SizedBox(height: 32),
                        
                        // Signup Form
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            final shake = (_shakeAnimation.value * 10 * 
                                (1 - _shakeAnimation.value)).toDouble();
                            return Transform.translate(
                              offset: Offset(shake * ((_shakeAnimation.value * 20).toInt() % 2 == 0 ? 1 : -1), 0),
                              child: child,
                            );
                          },
                          child: GlassCard(
                            blur: 20,
                            opacity: isDark ? 0.1 : 0.7,
                            padding: const EdgeInsets.all(28),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Name Field
                                  _buildTextField(
                                    controller: _nameController,
                                    focusNode: _nameFocus,
                                    label: 'Full Name',
                                    hint: 'Enter your name',
                                    icon: Icons.person_outline,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _emailFocus.requestFocus(),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Enter your name';
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Email Field
                                  _buildTextField(
                                    controller: _emailController,
                                    focusNode: _emailFocus,
                                    label: 'Email',
                                    hint: 'Enter your email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Enter your email';
                                      if (!v.contains('@')) return 'Enter a valid email';
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Password Field
                                  _buildTextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    label: 'Password',
                                    hint: 'Create a password',
                                    icon: Icons.lock_outline,
                                    obscureText: _obscurePassword,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword 
                                            ? Icons.visibility_outlined 
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () {
                                        setState(() => _obscurePassword = !_obscurePassword);
                                        HapticFeedback.selectionClick();
                                      },
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Enter a password';
                                      if (v.length < 6) return 'At least 6 characters';
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
                                  
                                  // Password Strength Indicator
                                  if (_passwordController.text.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: _passwordStrength,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme.onSurface.withValues(alpha: 0.1),
                                              valueColor: AlwaysStoppedAnimation(_getStrengthColor()),
                                              minHeight: 6,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _getStrengthText(),
                                          style: TextStyle(
                                            color: _getStrengthColor(),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ).animate().fadeIn(),
                                  ],
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Confirm Password Field
                                  _buildTextField(
                                    controller: _confirmPasswordController,
                                    focusNode: _confirmPasswordFocus,
                                    label: 'Confirm Password',
                                    hint: 'Confirm your password',
                                    icon: Icons.lock_outline,
                                    obscureText: _obscureConfirmPassword,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _signUp(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword 
                                            ? Icons.visibility_outlined 
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () {
                                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                                        HapticFeedback.selectionClick();
                                      },
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return 'Confirm your password';
                                      if (v != _passwordController.text) return 'Passwords do not match';
                                      return null;
                                    },
                                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                                  
                                  if (_errorMessage != null) ...[
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Theme.of(context).colorScheme.error,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              _errorMessage!,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.error,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).animate().shake().fadeIn(),
                                  ],
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Sign Up Button
                                  AnimatedGradientButton(
                                    text: 'Create Account',
                                    isLoading: _isLoading,
                                    onPressed: _signUp,
                                    gradientColors: const [Color(0xFF10B981), Color(0xFF06B6D4)],
                                    icon: Icons.arrow_forward_rounded,
                                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // Login Link
                                  TextButton(
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      Navigator.of(context).pop();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        children: [
                                          TextSpan(
                                            text: 'Already have an account? ',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Sign In',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animate().fadeIn(delay: 700.ms),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 600.ms)
                            .slideY(begin: 0.2, curve: Curves.easeOutCubic),
                        
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF6366F1),
                Color(0xFF8B5CF6),
                Color(0xFF10B981),
                Color(0xFF06B6D4),
                Color(0xFFF59E0B),
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: validator,
    );
  }
}
