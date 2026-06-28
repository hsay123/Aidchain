import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String iconName;
  final String? buttonIcon;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.iconName = 'people',
    this.buttonIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine button icon based on button text if not explicitly provided
    String finalButtonIcon = buttonIcon ?? _getButtonIcon(buttonText);

    return Center(
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Button
            ElevatedButton.icon(
              onPressed: onButtonPressed,
              icon: CustomIconWidget(
                iconName: finalButtonIcon,
                color: Colors.white,
                size: 20,
              ),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Help Text
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Quick Start Tips',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• Import beneficiaries from CSV files for bulk operations\n'
                    '• Add individual beneficiaries with complete KYC information\n'
                    '• Create blockchain wallets automatically during registration\n'
                    '• Set up program enrollment and fund distribution rules',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonIcon(String buttonText) {
    final text = buttonText.toLowerCase();

    if (text.contains('add')) return 'add';
    if (text.contains('clear')) return 'clear';
    if (text.contains('refresh')) return 'refresh';
    if (text.contains('reload')) return 'refresh';
    if (text.contains('reset')) return 'restart_alt';
    if (text.contains('search')) return 'search';
    if (text.contains('filter')) return 'filter_alt';
    if (text.contains('import')) return 'upload_file';
    if (text.contains('export')) return 'download';
    if (text.contains('sync')) return 'sync';

    // Default fallback
    return 'add';
  }
}
