import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AgentStatsWidget extends StatelessWidget {
  final int todayTransactions;
  final int totalTransactions;
  final double rating;
  final double cashBalance;

  const AgentStatsWidget({
    Key? key,
    required this.todayTransactions,
    required this.totalTransactions,
    required this.rating,
    required this.cashBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
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
                'Performance Stats',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Stats Grid
          Row(
            children: [
              // Today's Transactions
              Expanded(
                child: _buildStatCard(
                  'Today',
                  todayTransactions.toString(),
                  'transactions',
                  AppTheme.lightTheme.colorScheme.secondary,
                  'trending_up',
                ),
              ),
              SizedBox(width: 2.w),
              
              // Total Transactions
              Expanded(
                child: _buildStatCard(
                  'Total',
                  _formatNumber(totalTransactions),
                  'completed',
                  AppTheme.lightTheme.colorScheme.primary,
                  'done_all',
                ),
              ),
            ],
          ),

          SizedBox(height: 2.w),

          Row(
            children: [
              // Rating
              Expanded(
                child: _buildStatCard(
                  'Rating',
                  rating.toStringAsFixed(1),
                  '⭐ stars',
                  AppTheme.lightTheme.colorScheme.tertiary,
                  'star',
                ),
              ),
              SizedBox(width: 2.w),
              
              // Cash Balance
              Expanded(
                child: _buildStatCard(
                  'Cash',
                  '\$${_formatCurrency(cashBalance)}',
                  'available',
                  AppTheme.lightTheme.colorScheme.secondary,
                  'account_balance_wallet',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    String icon,
  ) {
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
          // Icon and Title
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Value
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),

          // Subtitle
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
