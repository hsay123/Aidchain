import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ApprovalNotificationWidget extends StatelessWidget {
  final List<Map<String, dynamic>> pendingApprovals;
  final VoidCallback? onViewAll;
  final Function(Map<String, dynamic>)? onApprove;
  final Function(Map<String, dynamic>)? onReject;

  const ApprovalNotificationWidget({
    Key? key,
    required this.pendingApprovals,
    this.onViewAll,
    this.onApprove,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pendingApprovals.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'pending_actions',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Pending Approvals (${pendingApprovals.length})',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                pendingApprovals.length > 3 ? 3 : pendingApprovals.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightTheme.dividerColor,
            ),
            itemBuilder: (context, index) {
              final approval = pendingApprovals[index];
              final String requestType =
                  (approval['type'] as String?) ?? 'Fund Request';
              final String beneficiary =
                  (approval['beneficiary'] as String?) ?? 'Unknown';
              final String amount = (approval['amount'] as String?) ?? '\$0';
              final String timestamp =
                  (approval['timestamp'] as String?) ?? 'Just now';

              return Container(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                requestType,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Beneficiary: $beneficiary',
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Amount: $amount',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                timestamp,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Column(
                          children: [
                            SizedBox(
                              width: 20.w,
                              child: ElevatedButton(
                                onPressed: () => onApprove?.call(approval),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.successLight,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.5.h),
                                ),
                                child: Text(
                                  'Approve',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            SizedBox(
                              width: 20.w,
                              child: OutlinedButton(
                                onPressed: () => onReject?.call(approval),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppTheme.errorLight),
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.5.h),
                                ),
                                child: Text(
                                  'Reject',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.errorLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
