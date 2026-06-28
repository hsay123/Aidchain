import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PendingRequestWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const PendingRequestWidget({
    Key? key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Color _getReasonColor(String reason) {
    switch (reason.toLowerCase()) {
      case 'food & groceries':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'medicine & healthcare':
        return AppTheme.lightTheme.colorScheme.error;
      case 'education & school':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'emergency':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getReasonIcon(String reason) {
    switch (reason.toLowerCase()) {
      case 'food & groceries':
        return 'restaurant';
      case 'medicine & healthcare':
        return 'medical_services';
      case 'education & school':
        return 'school';
      case 'emergency':
        return 'emergency';
      default:
        return 'help';
    }
  }

  @override
  Widget build(BuildContext context) {
    final reasonColor = _getReasonColor(request['reason']);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Beneficiary Avatar
                    CircleAvatar(
                      radius: 6.w,
                      backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
                      child: Text(
                        request['beneficiaryName']
                            .toString()
                            .split(' ')
                            .map((e) => e[0])
                            .join('')
                            .toUpperCase(),
                        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Beneficiary Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['beneficiaryName'],
                            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'ID: ${request['beneficiaryId']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${request['currency']}${request['amount']}',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Request Details
                Row(
                  children: [
                    // Reason
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: reasonColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: _getReasonIcon(request['reason']),
                              color: reasonColor,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                request['reason'],
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: reasonColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Additional Info
                Row(
                  children: [
                    // QR Code
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'qr_code',
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            request['qrCode'],
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Distance
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          request['distance'],
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 3.w),

                    // Time
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _formatTime(request['requestTime']),
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Reject Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.lightTheme.colorScheme.error),
                      foregroundColor: AppTheme.lightTheme.colorScheme.error,
                    ),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 16,
                    ),
                    label: const Text('Reject'),
                  ),
                ),

                SizedBox(width: 2.w),

                // Approve Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text('Approve'),
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
