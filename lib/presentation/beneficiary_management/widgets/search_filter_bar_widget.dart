import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final String searchHint;
  final TextEditingController? searchController;

  const SearchFilterBarWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterTap,
    this.hasActiveFilters = false,
    this.searchHint = 'Search by name, ID, location...',
    this.searchController,
  }) : super(key: key);

  @override
  State<SearchFilterBarWidget> createState() => _SearchFilterBarWidgetState();
}

class _SearchFilterBarWidgetState extends State<SearchFilterBarWidget> {
  late TextEditingController _internalController;
  final FocusNode _searchFocusNode = FocusNode();
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    // Use provided controller or create internal one
    if (widget.searchController != null) {
      _internalController = widget.searchController!;
    } else {
      _internalController = TextEditingController();
      _isInternalController = true;
    }

    _searchFocusNode.addListener(() {
      setState(() {}); // Refresh to update border color
    });
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _internalController.dispose();
    }
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _internalController.clear();
    widget.onSearchChanged('');
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _searchFocusNode.hasFocus
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: _searchFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _internalController,
                focusNode: _searchFocusNode,
                onChanged: widget.onSearchChanged,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _internalController.text.isNotEmpty
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Filter Button
          Container(
            height: 6.h,
            width: 6.h,
            decoration: BoxDecoration(
              color: widget.hasActiveFilters
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.hasActiveFilters
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onFilterTap,
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'tune',
                      color: widget.hasActiveFilters
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    if (widget.hasActiveFilters)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
