import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 1; i <= totalSteps; i++) ...[
            _buildStepCircle(i),
            if (i < totalSteps) _buildStepConnector(i),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step) {
    final isActive = step <= currentStep;
    final isCompleted = step < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 16,
              )
            : Text(
                step.toString(),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isActive
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector(int step) {
    final isCompleted = step < currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12.w,
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
