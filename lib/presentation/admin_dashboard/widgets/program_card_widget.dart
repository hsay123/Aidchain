import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgramCardWidget extends StatelessWidget {
  final Map<String, dynamic> program;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onGenerateReport;
  final VoidCallback? onPauseProgram;

  const ProgramCardWidget({
    Key? key,
    required this.program,
    this.onTap,
    this.onViewDetails,
    this.onGenerateReport,
    this.onPauseProgram,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String programName =
        (program['name'] as String?) ?? 'Unknown Program';
    final String status = (program['status'] as String?) ?? 'Active';
    final int beneficiaries = (program['beneficiaries'] as int?) ?? 0;
    final double progress = ((program['progress'] as num?) ?? 0.0).toDouble();
    final String totalFunds = (program['totalFunds'] as String?) ?? '\$0';
    final String distributedFunds =
        (program['distributedFunds'] as String?) ?? '\$0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    programName,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: status == 'Active'
                        ? AppTheme.successLight.withValues(alpha: 0.1)
                        : AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: status == 'Active'
                          ? AppTheme.successLight
                          : AppTheme.warningLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beneficiaries',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        beneficiaries.toString(),
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distributed',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        distributedFunds,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Budget',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        totalFunds,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    label: Text(
                      'View Details',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onGenerateReport,
                    icon: CustomIconWidget(
                      iconName: 'assessment',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    label: Text(
                      'Report',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
