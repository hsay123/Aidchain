import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final String icon;
  final List<Widget> children;
  final bool isDanger;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.children,
    this.isDanger = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color sectionColor = isDanger 
        ? AppTheme.lightTheme.colorScheme.error
        : AppTheme.lightTheme.colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
          // Section Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: sectionColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: sectionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: icon,
                      color: sectionColor,
                      size: 18,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: sectionColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Section Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                ...children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  final isLast = index == children.length - 1;

                  return Column(
                    children: [
                      child,
                      if (!isLast)
                        Divider(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          height: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
