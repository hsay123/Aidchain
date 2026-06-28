import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgramStatsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> programs;
  final Map<String, int> stats;

  const ProgramStatsWidget({
    Key? key,
    required this.programs,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalBudget = programs.fold<double>(
      0.0, 
      (sum, program) => sum + (program['totalBudget'] as double),
    );
    
    final distributedAmount = programs.fold<double>(
      0.0, 
      (sum, program) => sum + (program['distributedAmount'] as double),
    );

    final totalBeneficiaries = programs.fold<int>(
      0, 
      (sum, program) => sum + (program['beneficiaries'] as int),
    );

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
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'analytics',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Program Overview',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 2.w,
            childAspectRatio: 2,
            children: [
              _buildStatCard(
                'Total Programs',
                stats['total'].toString(),
                'folder',
                AppTheme.lightTheme.colorScheme.primary,
              ),
              _buildStatCard(
                'Active Programs',
                stats['active'].toString(),
                'play_circle',
                AppTheme.lightTheme.colorScheme.secondary,
              ),
              _buildStatCard(
                'Total Budget',
                _formatCurrency(totalBudget),
                'attach_money',
                AppTheme.lightTheme.colorScheme.tertiary,
              ),
              _buildStatCard(
                'Beneficiaries',
                _formatNumber(totalBeneficiaries),
                'people',
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Distribution Progress
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Distribution Progress',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distributed: ${_formatCurrency(distributedAmount)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      '${totalBudget > 0 ? ((distributedAmount / totalBudget) * 100).toInt() : 0}%',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                LinearProgressIndicator(
                  value: totalBudget > 0 ? (distributedAmount / totalBudget) : 0,
                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Total Budget: ${_formatCurrency(totalBudget)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 16,
              ),
              Spacer(),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
