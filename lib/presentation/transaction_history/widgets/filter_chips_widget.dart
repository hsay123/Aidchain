import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<String> activeFilters;
  final Function(String) onFilterToggle;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    Key? key,
    required this.activeFilters,
    required this.onFilterToggle,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filterOptions = [
      {'label': 'Today', 'value': 'today', 'icon': 'today'},
      {'label': 'This Week', 'value': 'week', 'icon': 'date_range'},
      {'label': 'This Month', 'value': 'month', 'icon': 'calendar_month'},
      {'label': 'Incoming', 'value': 'incoming', 'icon': 'arrow_downward'},
      {'label': 'Outgoing', 'value': 'outgoing', 'icon': 'arrow_upward'},
      {'label': 'Completed', 'value': 'completed', 'icon': 'check_circle'},
      {'label': 'Pending', 'value': 'pending', 'icon': 'schedule'},
      {'label': 'Failed', 'value': 'failed', 'icon': 'error'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              activeFilters.isNotEmpty
                  ? GestureDetector(
                      onTap: onClearAll,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Clear All',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                final bool isActive = activeFilters.contains(filter['value']);
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    selected: isActive,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: filter['icon'],
                          color: isActive
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          filter['label'],
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isActive
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    selectedColor: AppTheme.lightTheme.colorScheme.primary,
                    side: BorderSide(
                      color: isActive
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                    onSelected: (selected) => onFilterToggle(filter['value']),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }).toList(),
            ),
          ),
          activeFilters.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'filter_list',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${activeFilters.length} filter${activeFilters.length > 1 ? 's' : ''} active',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
