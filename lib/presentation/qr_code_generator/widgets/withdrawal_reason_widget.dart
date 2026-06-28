import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WithdrawalReasonWidget extends StatefulWidget {
  final String? selectedReason;
  final Function(String) onReasonChanged;
  final TextEditingController customReasonController;

  const WithdrawalReasonWidget({
    Key? key,
    required this.selectedReason,
    required this.onReasonChanged,
    required this.customReasonController,
  }) : super(key: key);

  @override
  State<WithdrawalReasonWidget> createState() => _WithdrawalReasonWidgetState();
}

class _WithdrawalReasonWidgetState extends State<WithdrawalReasonWidget> {
  final List<Map<String, dynamic>> predefinedReasons = [
    {
      'value': 'food',
      'label': 'Food & Groceries',
      'icon': 'restaurant',
      'color': Color(0xFF4CAF50),
    },
    {
      'value': 'medicine',
      'label': 'Medicine & Healthcare',
      'icon': 'local_hospital',
      'color': Color(0xFF2196F3),
    },
    {
      'value': 'education',
      'label': 'Education & School',
      'icon': 'school',
      'color': Color(0xFF9C27B0),
    },
    {
      'value': 'emergency',
      'label': 'Emergency',
      'icon': 'warning',
      'color': Color(0xFFFF5722),
    },
    {
      'value': 'custom',
      'label': 'Other (Specify)',
      'icon': 'edit',
      'color': Color(0xFF607D8B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdrawal Reason',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 1.5.h),

        // Predefined Reasons Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 3.2,
          ),
          itemCount: predefinedReasons.length,
          itemBuilder: (context, index) {
            final reason = predefinedReasons[index];
            final isSelected = widget.selectedReason == reason['value'];

            return GestureDetector(
              onTap: () => widget.onReasonChanged(reason['value']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? reason['color'].withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? reason['color']
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: reason['color'].withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: reason['icon'],
                      color: isSelected
                          ? reason['color']
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        reason['label'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? reason['color']
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Custom Reason Input Field
        if (widget.selectedReason == 'custom') ...[
          SizedBox(height: 2.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: TextFormField(
              controller: widget.customReasonController,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Please specify the reason...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
              maxLines: 3,
              maxLength: 100,
            ),
          ),
        ],
      ],
    );
  }
}
