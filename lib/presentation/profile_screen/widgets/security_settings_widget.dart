import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecuritySettingsWidget extends StatelessWidget {
  final bool biometricEnabled;
  final bool twoFactorEnabled;
  final bool notificationsEnabled;
  final ValueChanged<bool> onBiometricChanged;
  final ValueChanged<bool> onTwoFactorChanged;
  final ValueChanged<bool> onNotificationsChanged;

  const SecuritySettingsWidget({
    Key? key,
    required this.biometricEnabled,
    required this.twoFactorEnabled,
    required this.notificationsEnabled,
    required this.onBiometricChanged,
    required this.onTwoFactorChanged,
    required this.onNotificationsChanged,
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
          // Section Title
          Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Security & Preferences',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Biometric Authentication
          _buildSettingItem(
            context,
            icon: 'fingerprint',
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or face recognition to login',
            value: biometricEnabled,
            onChanged: onBiometricChanged,
          ),

          _buildDivider(),

          // Two-Factor Authentication
          _buildSettingItem(
            context,
            icon: 'security',
            title: 'Two-Factor Authentication',
            subtitle: 'Add an extra layer of security to your account',
            value: twoFactorEnabled,
            onChanged: onTwoFactorChanged,
          ),

          _buildDivider(),

          // Notifications
          _buildSettingItem(
            context,
            icon: 'notifications',
            title: 'Push Notifications',
            subtitle: 'Receive updates about transactions and account activity',
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        // Icon
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ),

        SizedBox(width: 3.w),

        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Switch
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Divider(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        height: 1,
      ),
    );
  }
}
