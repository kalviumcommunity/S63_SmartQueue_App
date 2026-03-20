import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Add Order Screen - Demonstrates form navigation and data passing.
/// Shows how to navigate back with result data.
class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _orderItemsController = TextEditingController();
  String _selectedPriority = 'Normal';

  @override
  void dispose() {
    _customerNameController.dispose();
    _orderItemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Add New Order'),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            // Simple pop without result
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Fill in the order details. This demonstrates form navigation with data.',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Customer Name Field
              _buildLabel('Customer Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _customerNameController,
                decoration: _buildInputDecoration(
                  hint: 'Enter customer name',
                  icon: Icons.person_outline_rounded,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Order Items Field
              _buildLabel('Order Items'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _orderItemsController,
                maxLines: 3,
                decoration: _buildInputDecoration(
                  hint: 'Enter order items (e.g., 2x Burger, 1x Fries)',
                  icon: Icons.restaurant_menu_rounded,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter order items';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Priority Selection
              _buildLabel('Priority'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildPriorityOption('Normal', const Color(0xFF3B82F6)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPriorityOption('High', const Color(0xFFF59E0B)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPriorityOption('Urgent', const Color(0xFFEF4444)),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Navigation Info
              _buildNavigationInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }

  Widget _buildPriorityOption(String priority, Color color) {
    final isSelected = _selectedPriority == priority;
    
    return Material(
      color: isSelected ? color : color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            _selectedPriority = priority;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              priority,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      
      final orderData = {
        'id': 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'customer': _customerNameController.text,
        'title': _orderItemsController.text,
        'priority': _selectedPriority,
        'status': 'Queued',
        'total': 25.99,
        'time': 'Just now',
      };
      
      // Show success dialog then navigate
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Order Created!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ${orderData['id']} has been added to the queue.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Pop and return the created order data
                Navigator.pop(context, orderData);
              },
              child: const Text('View in Queue'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Navigate to order details
                Navigator.pushReplacementNamed(
                  context,
                  '/order-details',
                  arguments: orderData,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildNavigationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.code_rounded, color: Color(0xFF6366F1)),
              SizedBox(width: 10),
              Text(
                'Navigation with Result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '// Pop with result data',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Navigator.pop(context, orderData);',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '// Receive result on previous screen',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'final result = await Navigator.pushNamed(...);',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
