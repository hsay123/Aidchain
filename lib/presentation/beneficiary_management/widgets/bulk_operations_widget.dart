import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkOperationsWidget extends StatelessWidget {
  final VoidCallback onCsvUpload;
  final VoidCallback onMassWalletCreation;
  final VoidCallback onBatchStatusUpdate;
  final bool isLoading;
  final String? loadingMessage;

  const BulkOperationsWidget({
    Key? key,
    required this.onCsvUpload,
    required this.onMassWalletCreation,
    required this.onBatchStatusUpdate,
    this.isLoading = false,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'batch_prediction',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Bulk Operations',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Loading Indicator
              if (isLoading)
                Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          loadingMessage ?? 'Processing bulk operation...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Operation Buttons
              Column(
                children: [
                  // CSV Upload
                  _buildOperationButton(
                    icon: 'upload_file',
                    title: 'CSV Upload',
                    subtitle: 'Import beneficiaries from CSV file',
                    onTap: isLoading ? null : onCsvUpload,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),

                  SizedBox(height: 2.h),

                  // Mass Wallet Creation
                  _buildOperationButton(
                    icon: 'account_balance_wallet',
                    title: 'Mass Wallet Creation',
                    subtitle: 'Create wallets for selected beneficiaries',
                    onTap: isLoading ? null : onMassWalletCreation,
                    color: AppTheme.lightTheme.primaryColor,
                  ),

                  SizedBox(height: 2.h),

                  // Batch Status Update
                  _buildOperationButton(
                    icon: 'update',
                    title: 'Batch Status Update',
                    subtitle: 'Update status for multiple beneficiaries',
                    onTap: isLoading ? null : onBatchStatusUpdate,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Help Text
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Bulk operations may take several minutes to complete. You will receive a notification when the process is finished.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildOperationButton({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: onTap != null
                  ? color.withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: onTap != null
                      ? color.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: icon,
                    color: onTap != null
                        ? color
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onTap != null
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: onTap != null
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: color,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
