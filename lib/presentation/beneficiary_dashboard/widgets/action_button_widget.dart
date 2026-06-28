import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonWidget extends StatelessWidget {
  final String title;
  final String iconName;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;

  const ActionButtonWidget({
    Key? key,
    required this.title,
    required this.iconName,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppTheme.lightTheme.primaryColor
              : AppTheme.lightTheme.colorScheme.surface,
          foregroundColor:
              isPrimary ? Colors.white : AppTheme.lightTheme.primaryColor,
          elevation: isPrimary ? 4 : 2,
          shadowColor: isPrimary
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3)
              : AppTheme.shadowLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 1.5,
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isPrimary ? Colors.white : AppTheme.lightTheme.primaryColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: iconName,
                    color: isPrimary
                        ? Colors.white
                        : AppTheme.lightTheme.primaryColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isPrimary
                          ? Colors.white
                          : AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
