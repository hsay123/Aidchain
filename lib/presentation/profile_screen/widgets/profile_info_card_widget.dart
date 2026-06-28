import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const ProfileInfoCardWidget({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
          // Card Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          
          SizedBox(height: 2.h),

          // Information Items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                _buildInfoRow(
                  context,
                  item['label'] as String,
                  item['value'] as String,
                  isStatus: item['isStatus'] as bool? ?? false,
                  isWallet: item['isWallet'] as bool? ?? false,
                  onTap: item['onTap'] as VoidCallback?,
                ),
                if (!isLast) ...[
                  SizedBox(height: 2.h),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  SizedBox(height: 2.h),
                ],
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
    bool isWallet = false,
    VoidCallback? onTap,
  }) {
    Widget valueWidget = Text(
      value,
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        fontFamily: isWallet ? 'monospace' : null,
      ),
    );

    if (isStatus) {
      valueWidget = Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: value.toLowerCase() == 'verified'
              ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: value.toLowerCase() == 'verified' ? 'verified' : 'pending',
              color: value.toLowerCase() == 'verified'
                  ? AppTheme.lightTheme.colorScheme.secondary
                  : AppTheme.lightTheme.colorScheme.tertiary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              value.toUpperCase(),
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: value.toLowerCase() == 'verified'
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    if (isWallet) {
      valueWidget = GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: valueWidget),
      ],
    );
  }
}
