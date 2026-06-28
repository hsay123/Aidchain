import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgramFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final Map<String, int> programStats;

  const ProgramFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.programStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'name': 'All', 'count': programStats['total'] ?? 0},
      {'name': 'Active', 'count': programStats['active'] ?? 0},
      {'name': 'Paused', 'count': programStats['paused'] ?? 0},
      {'name': 'Planning', 'count': programStats['planning'] ?? 0},
      {'name': 'Completed', 'count': programStats['completed'] ?? 0},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter['name'] == selectedFilter;
          final color = _getFilterColor(filter['name']! as String);

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter['name']! as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.white.withValues(alpha: 0.2) 
                          : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      filter['count'].toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isSelected ? Colors.white : color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter['name']! as String);
                }
              },
              backgroundColor: Colors.transparent,
              selectedColor: color,
              side: BorderSide(
                color: isSelected ? color : color.withValues(alpha: 0.5),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getFilterColor(String filterName) {
    switch (filterName.toLowerCase()) {
      case 'all':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'active':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'paused':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'planning':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
