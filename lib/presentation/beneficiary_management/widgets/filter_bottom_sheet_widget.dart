import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _enrollmentStatuses = [
    'All',
    'Active',
    'Pending',
    'Suspended',
    'Inactive'
  ];
  final List<String> _kycStatuses = ['All', 'Verified', 'Pending', 'Rejected'];
  final List<String> _balanceRanges = [
    'All',
    '\$0 - \$100',
    '\$100 - \$500',
    '\$500 - \$1000',
    '\$1000+'
  ];
  final List<String> _regions = [
    'All',
    'North Region',
    'South Region',
    'East Region',
    'West Region',
    'Central Region'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    // Ensure default values are set
    _filters['enrollmentStatus'] ??= 'All';
    _filters['kycStatus'] ??= 'All';
    _filters['balanceRange'] ??= 'All';
    _filters['region'] ??= 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Beneficiaries',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Filter Options
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enrollment Status
                  _buildFilterSection(
                    'Enrollment Status',
                    _enrollmentStatuses,
                    _filters['enrollmentStatus'] ?? 'All',
                    (value) =>
                        setState(() => _filters['enrollmentStatus'] = value),
                  ),

                  SizedBox(height: 3.h),

                  // KYC Verification
                  _buildFilterSection(
                    'KYC Verification',
                    _kycStatuses,
                    _filters['kycStatus'] ?? 'All',
                    (value) => setState(() => _filters['kycStatus'] = value),
                  ),

                  SizedBox(height: 3.h),

                  // Wallet Balance
                  _buildFilterSection(
                    'Wallet Balance',
                    _balanceRanges,
                    _filters['balanceRange'] ?? 'All',
                    (value) => setState(() => _filters['balanceRange'] = value),
                  ),

                  SizedBox(height: 3.h),

                  // Geographic Region
                  _buildFilterSection(
                    'Geographic Region',
                    _regions,
                    _filters['region'] ?? 'All',
                    (value) => setState(() => _filters['region'] = value),
                  ),

                  SizedBox(height: 3.h),

                  // Date Range
                  _buildDateRangeSection(),

                  SizedBox(height: 10.h), // Space for bottom buttons
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final bool isSelected = option == selectedValue;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onChanged(option),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              checkmarkColor: AppTheme.lightTheme.primaryColor,
              labelStyle: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration Date Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'start'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                label: Text(
                  _filters['startDate'] ?? 'Start Date',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _filters['startDate'] != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                  alignment: Alignment.centerLeft,
                  side: BorderSide(
                    color: _filters['startDate'] != null
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectDate(context, 'end'),
                icon: CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                label: Text(
                  _filters['endDate'] ?? 'End Date',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _filters['endDate'] != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                  alignment: Alignment.centerLeft,
                  side: BorderSide(
                    color: _filters['endDate'] != null
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_filters['startDate'] != null || _filters['endDate'] != null)
          Container(
            margin: EdgeInsets.only(top: 1.h),
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _filters['startDate'] = null;
                  _filters['endDate'] = null;
                });
              },
              icon: CustomIconWidget(
                iconName: 'clear',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 16,
              ),
              label: Text(
                'Clear Date Range',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _filters['${type}Date'] =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'enrollmentStatus': 'All',
        'kycStatus': 'All',
        'balanceRange': 'All',
        'region': 'All',
        'startDate': null,
        'endDate': null,
      };
    });
  }

  void _applyFilters() {
    // Validate date range
    if (_filters['startDate'] != null && _filters['endDate'] != null) {
      final startParts = (_filters['startDate'] as String).split('/');
      final endParts = (_filters['endDate'] as String).split('/');

      final startDate = DateTime(
        int.parse(startParts[2]),
        int.parse(startParts[1]),
        int.parse(startParts[0]),
      );
      final endDate = DateTime(
        int.parse(endParts[2]),
        int.parse(endParts[1]),
        int.parse(endParts[0]),
      );

      if (startDate.isAfter(endDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Start date must be before end date'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
        return;
      }
    }

    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
