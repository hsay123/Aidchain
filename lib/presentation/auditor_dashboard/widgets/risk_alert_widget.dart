import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RiskAlertWidget extends StatelessWidget {
  final Map<String, dynamic> alert;
  final VoidCallback onDismiss;
  final VoidCallback onViewDetails;

  const RiskAlertWidget({
    Key? key,
    required this.alert,
    required this.onDismiss,
    required this.onViewDetails,
  }) : super(key: key);

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'error';
      case 'medium':
        return 'warning';
      case 'low':
        return 'info';
      default:
        return 'help';
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(alert['severity']);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: severityColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Alert Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Severity Icon
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: severityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getSeverityIcon(alert['severity']),
                      color: severityColor,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Alert Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Severity Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert['title'],
                              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: severityColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: severityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert['severity'].toString().toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                                color: severityColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Description
                      Text(
                        alert['description'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Program and Time
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'folder',
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              alert['program'],
                              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'access_time',
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _formatTime(alert['date']),
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Dismiss Button
                IconButton(
                  onPressed: onDismiss,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                  constraints: BoxConstraints(minWidth: 8.w, minHeight: 8.w),
                  padding: EdgeInsets.all(1.w),
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 3.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: severityColor),
                      foregroundColor: severityColor,
                    ),
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: severityColor,
                      size: 16,
                    ),
                    label: const Text('Investigate'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Creating action plan for ${alert['id']}'),
                          backgroundColor: severityColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: severityColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: CustomIconWidget(
                      iconName: 'assignment',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text('Action Plan'),
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
