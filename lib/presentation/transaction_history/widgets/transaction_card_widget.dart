import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onViewReceipt;
  final VoidCallback? onVerifyBlockchain;
  final VoidCallback? onShare;

  const TransactionCardWidget({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onViewReceipt,
    this.onVerifyBlockchain,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIncoming = transaction['type'] == 'incoming';
    final String status = transaction['status'] ?? 'completed';
    final double amount = (transaction['amount'] as num).toDouble();
    final DateTime date = transaction['date'] as DateTime;

    return Dismissible(
      key: Key(transaction['id'].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'receipt',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'verified',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        _showQuickActions(context);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Transaction Type Icon
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: isIncoming
                        ? AppTheme.lightTheme.colorScheme.secondaryContainer
                        : AppTheme.lightTheme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getTransactionIcon(
                          transaction['category'] ?? 'transfer'),
                      color: isIncoming
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              transaction['description'] ?? 'Transaction',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${isIncoming ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: isIncoming
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              isIncoming
                                  ? 'From: ${transaction['source'] ?? 'Unknown'}'
                                  : 'To: ${transaction['destination'] ?? 'Unknown'}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusBadge(status),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor = AppTheme.lightTheme.colorScheme.secondaryContainer;
        textColor = AppTheme.lightTheme.colorScheme.secondary;
        displayText = 'Completed';
        break;
      case 'pending':
        backgroundColor = AppTheme.lightTheme.colorScheme.tertiaryContainer;
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        displayText = 'Pending';
        break;
      case 'failed':
        backgroundColor = AppTheme.lightTheme.colorScheme.errorContainer;
        textColor = AppTheme.lightTheme.colorScheme.error;
        displayText = 'Failed';
        break;
      default:
        backgroundColor =
            AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getTransactionIcon(String category) {
    switch (category.toLowerCase()) {
      case 'aid_disbursement':
        return 'volunteer_activism';
      case 'cash_out':
        return 'account_balance_wallet';
      case 'transfer':
        return 'swap_horiz';
      case 'deposit':
        return 'add_circle';
      case 'withdrawal':
        return 'remove_circle';
      case 'payment':
        return 'payment';
      default:
        return 'receipt_long';
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Receipt'),
              onTap: () {
                Navigator.pop(context);
                onViewReceipt?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Verify on Blockchain'),
              onTap: () {
                Navigator.pop(context);
                onVerifyBlockchain?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Details'),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
