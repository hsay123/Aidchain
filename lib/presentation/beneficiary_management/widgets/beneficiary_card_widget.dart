import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BeneficiaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> beneficiary;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onViewTransactions;
  final VoidCallback? onSuspend;
  final VoidCallback? onGenerateReport;
  final bool isSelected;
  final VoidCallback? onSelectionChanged;

  const BeneficiaryCardWidget({
    Key? key,
    required this.beneficiary,
    this.onTap,
    this.onEdit,
    this.onViewTransactions,
    this.onSuspend,
    this.onGenerateReport,
    this.isSelected = false,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = beneficiary['walletStatus'] ?? 'inactive';
    final Color statusColor = _getStatusColor(status);
    final String lastActivity = beneficiary['lastActivity'] ?? 'Never';
    final String totalFunds = beneficiary['totalFundsReceived'] ?? '\$0.00';
    final bool isVerified = beneficiary['kycVerified'] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: AppTheme.lightTheme.primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onSelectionChanged,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile Photo with improved loading and error handling
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: beneficiary['profilePhoto'] ??
                              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Name and ID
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  beneficiary['name'] ?? 'Unknown',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified)
                                Container(
                                  margin: EdgeInsets.only(left: 2.w),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'verified',
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary,
                                        size: 12,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'KYC',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'ID: ${beneficiary['idNumber'] ?? 'N/A'}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection Checkbox with improved visual feedback
                    if (isSelected || onSelectionChanged != null)
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onSelectionChanged?.call(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Status and Metrics Row
                Row(
                  children: [
                    // Wallet Status with improved styling
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            status.toUpperCase(),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Total Funds
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Received',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          totalFunds,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Last Activity and Location with improved icons
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Last activity: $lastActivity',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Flexible(
                      child: Text(
                        beneficiary['location'] ?? 'Unknown',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Action Buttons with improved functionality
                if (onEdit != null ||
                    onViewTransactions != null ||
                    onSuspend != null ||
                    onGenerateReport != null)
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    child: Row(
                      children: [
                        if (onEdit != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onEdit,
                              icon: CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 16,
                              ),
                              label: Text('Edit'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                side: BorderSide(
                                  color: AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        if (onEdit != null && onViewTransactions != null)
                          SizedBox(width: 2.w),
                        if (onViewTransactions != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onViewTransactions,
                              icon: CustomIconWidget(
                                iconName: 'history',
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                size: 16,
                              ),
                              label: Text('History'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                side: BorderSide(
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                ),
                              ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'suspended':
        return AppTheme.lightTheme.colorScheme.error;
      case 'inactive':
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
