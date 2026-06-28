import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BalanceCardWidget extends StatelessWidget {
  final double availableBalance;
  final double lockedBalance;
  final String currency;
  final bool isOffline;
  final DateTime? lastUpdated;

  const BalanceCardWidget({
    Key? key,
    required this.availableBalance,
    required this.lockedBalance,
    required this.currency,
    this.isOffline = false,
    this.lastUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalBalance = availableBalance + lockedBalance;
    final availablePercentage =
        totalBalance > 0 ? (availableBalance / totalBalance) : 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor,
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14.sp,
                ),
              ),
              if (isOffline)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: AppTheme.warningLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: AppTheme.warningLight,
                        size: 12.sp,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Offline',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '$currency ${availableBalance.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          if (lockedBalance > 0) ...[
            Text(
              'Locked: $currency ${lockedBalance.toStringAsFixed(2)}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              height: 1.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: availablePercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.successLight,
                    borderRadius: BorderRadius.circular(0.5.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              '${(availablePercentage * 100).toInt()}% Available',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11.sp,
              ),
            ),
          ],
          if (isOffline && lastUpdated != null) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 12.sp,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Last updated: ${_formatLastUpdated(lastUpdated!)}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
