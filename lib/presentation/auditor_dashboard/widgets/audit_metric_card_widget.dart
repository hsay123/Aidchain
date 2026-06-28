import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AuditMetricCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final String trend;
  final String icon;
  final String color;

  const AuditMetricCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.change,
    required this.trend,
    required this.icon,
    required this.color,
  }) : super(key: key);

  Color _getColor(BuildContext context) {
    switch (color) {
      case 'success':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'warning':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'info':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Color _getTrendColor() {
    switch (trend) {
      case 'up':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'down':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTrendIcon() {
    switch (trend) {
      case 'up':
        return 'trending_up';
      case 'down':
        return 'trending_down';
      default:
        return 'trending_flat';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getColor(context);
    final trendColor = _getTrendColor();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: icon,
                    color: cardColor,
                    size: 16,
                  ),
                ),
              ),
              Spacer(),
              CustomIconWidget(
                iconName: _getTrendIcon(),
                color: trendColor,
                size: 16,
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Value
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 0.5.h),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 1.h),

          // Change
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: trendColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              change,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
