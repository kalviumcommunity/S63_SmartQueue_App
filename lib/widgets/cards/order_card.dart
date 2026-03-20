import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OrderCard - A reusable order/queue item card widget.
///
/// This is a STATEFUL widget because it manages:
/// - Swipe-to-action state
/// - Expansion state for details
/// - Animation states
///
/// Use cases:
/// - Order queue items
/// - Task lists
/// - Any list item with status and actions
class OrderCard extends StatefulWidget {
  /// Unique identifier for the order
  final String id;

  /// Main title/description
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Order status
  final OrderStatus status;

  /// Optional timestamp/time info
  final String? time;

  /// Optional price/value
  final String? value;

  /// Optional customer name
  final String? customer;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback for primary action (e.g., start preparing)
  final VoidCallback? onPrimaryAction;

  /// Callback for secondary action (e.g., complete)
  final VoidCallback? onSecondaryAction;

  /// Callback for delete action
  final VoidCallback? onDelete;

  /// Whether to show expandable details
  final bool showDetails;

  /// Additional details to show when expanded
  final List<String>? details;

  const OrderCard({
    super.key,
    required this.id,
    required this.title,
    this.subtitle,
    this.status = OrderStatus.queued,
    this.time,
    this.value,
    this.customer,
    this.onTap,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onDelete,
    this.showDetails = false,
    this.details,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.showDetails) {
            _toggleExpand();
          }
          widget.onTap?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: statusInfo.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        statusInfo.icon,
                        color: statusInfo.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.id,
                                  style: const TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(statusInfo),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Title
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Customer & Time
                          if (widget.customer != null || widget.time != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (widget.customer != null) ...[
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 14,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.customer!,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                                if (widget.customer != null && widget.time != null)
                                  const SizedBox(width: 12),
                                if (widget.time != null) ...[
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.time!,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Value
                    if (widget.value != null) ...[
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.value!,
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.showDetails) ...[
                            const SizedBox(height: 4),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Expandable Details Section
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: _buildExpandedContent(statusInfo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(_StatusInfo statusInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusInfo.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusInfo.label,
        style: TextStyle(
          color: statusInfo.color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExpandedContent(_StatusInfo statusInfo) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: [
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Details List
          if (widget.details != null && widget.details!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.details!.map((detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: statusInfo.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                detail,
                                style: const TextStyle(
                                  color: Color(0xFF1E293B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

          // Action Buttons
          if (widget.onPrimaryAction != null ||
              widget.onSecondaryAction != null ||
              widget.onDelete != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  if (widget.onDelete != null) ...[
                    _buildActionButton(
                      Icons.delete_outline_rounded,
                      'Delete',
                      const Color(0xFFEF4444),
                      widget.onDelete!,
                    ),
                    const SizedBox(width: 10),
                  ],
                  if (widget.onPrimaryAction != null) ...[
                    Expanded(
                      child: _buildActionButton(
                        _getPrimaryActionIcon(),
                        _getPrimaryActionLabel(),
                        statusInfo.color,
                        widget.onPrimaryAction!,
                        filled: true,
                      ),
                    ),
                  ],
                  if (widget.onSecondaryAction != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildActionButton(
                        Icons.check_rounded,
                        'Complete',
                        const Color(0xFF10B981),
                        widget.onSecondaryAction!,
                        filled: true,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap, {
    bool filled = false,
  }) {
    return Material(
      color: filled ? color : color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: filled ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : color,
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

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  _StatusInfo _getStatusInfo() {
    switch (widget.status) {
      case OrderStatus.queued:
        return _StatusInfo(
          label: 'Queued',
          color: const Color(0xFF3B82F6),
          icon: Icons.pending_actions_rounded,
        );
      case OrderStatus.preparing:
        return _StatusInfo(
          label: 'Preparing',
          color: const Color(0xFFF59E0B),
          icon: Icons.restaurant_rounded,
        );
      case OrderStatus.ready:
        return _StatusInfo(
          label: 'Ready',
          color: const Color(0xFF10B981),
          icon: Icons.check_circle_rounded,
        );
      case OrderStatus.completed:
        return _StatusInfo(
          label: 'Completed',
          color: const Color(0xFF8B5CF6),
          icon: Icons.verified_rounded,
        );
      case OrderStatus.cancelled:
        return _StatusInfo(
          label: 'Cancelled',
          color: const Color(0xFFEF4444),
          icon: Icons.cancel_rounded,
        );
    }
  }

  IconData _getPrimaryActionIcon() {
    switch (widget.status) {
      case OrderStatus.queued:
        return Icons.restaurant_rounded;
      case OrderStatus.preparing:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.ready:
        return Icons.local_shipping_rounded;
      default:
        return Icons.refresh_rounded;
    }
  }

  String _getPrimaryActionLabel() {
    switch (widget.status) {
      case OrderStatus.queued:
        return 'Start Preparing';
      case OrderStatus.preparing:
        return 'Mark Ready';
      case OrderStatus.ready:
        return 'Deliver';
      default:
        return 'Reorder';
    }
  }
}

enum OrderStatus { queued, preparing, ready, completed, cancelled }

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  _StatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });
}
