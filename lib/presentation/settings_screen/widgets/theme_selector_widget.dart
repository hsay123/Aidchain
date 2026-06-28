import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ThemeSelectorWidget extends StatelessWidget {
  final List<String> themes;
  final String selectedTheme;
  final ValueChanged<String> onThemeSelected;

  const ThemeSelectorWidget({
    Key? key,
    required this.themes,
    required this.selectedTheme,
    required this.onThemeSelected,
  }) : super(key: key);

  String _getThemeIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return 'light_mode';
      case 'dark':
        return 'dark_mode';
      case 'system':
        return 'brightness_auto';
      default:
        return 'brightness_6';
    }
  }

  String _getThemeDescription(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return 'Always use light theme';
      case 'dark':
        return 'Always use dark theme';
      case 'system':
        return 'Follow system theme';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          SizedBox(height: 3.h),

          // Title
          Row(
            children: [
              CustomIconWidget(
                iconName: 'palette',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Select Theme',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Theme Options
          ...themes.map((theme) {
            final isSelected = theme == selectedTheme;

            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                    : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                leading: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getThemeIcon(theme),
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  theme,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  _getThemeDescription(theme),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      )
                    : null,
                onTap: () => onThemeSelected(theme),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
