import 'package:flutter/material.dart';

/// StatCard - A reusable statistics card widget.
///
/// This is a STATELESS widget for displaying:
/// - Numeric statistics with labels
/// - Trend indicators (up/down)
/// - Progress bars
///
/// Use cases:
/// - Dashboard statistics
/// - Queue counters
/// - Performance metrics
class StatCard extends StatelessWidget {
  /// Main label for the statistic
  final String label;

  /// The primary value to display
  final String value;

  /// Optional icon
  final IconData? icon;

  /// Icon/accent color
  final Color color;

  /// Optional trend percentage (positive = up, negative = down)
  final double? trend;

  /// Optional progress value (0.0 to 1.0)
  final double? progress;

  /// Whether the card is compact
  final bool isCompact;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color = const Color(0xFF6366F1),
    this.trend,
    this.progress,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isCompact ? 14 : 18),
          decoration: BoxDecoration(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (icon != null)
                    Container(
                      padding: EdgeInsets.all(isCompact ? 8 : 10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: isCompact ? 18 : 22,
                      ),
                    ),
                  if (trend != null) _buildTrendIndicator(),
                ],
              ),

              SizedBox(height: isCompact ? 12 : 16),

              // Value
              Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF1E293B),
                  fontSize: isCompact ? 24 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Label
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: isCompact ? 11 : 13,
                ),
              ),

              // Progress Bar (optional)
              if (progress != null) ...[
                const SizedBox(height: 12),
                _buildProgressBar(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendIndicator() {
    final isPositive = trend! >= 0;
    final trendColor = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: trendColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${trend!.toStringAsFixed(1)}%',
            style: TextStyle(
              color: trendColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 10,
              ),
            ),
            Text(
              '${(progress! * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress!.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
