import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SelectionActionBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onBulkEdit;
  final VoidCallback onBulkSuspend;
  final VoidCallback onBulkActivate;
  final VoidCallback onBulkDelete;
  final VoidCallback onExportSelected;

  const SelectionActionBarWidget({
    Key? key,
    required this.selectedCount,
    required this.onClearSelection,
    required this.onBulkEdit,
    required this.onBulkSuspend,
    required this.onBulkActivate,
    required this.onBulkDelete,
    required this.onExportSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              // Close Selection
              IconButton(
                onPressed: onClearSelection,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 24,
                ),
              ),

              SizedBox(width: 2.w),

              // Selected Count
              Text(
                '$selectedCount selected',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Spacer(),

              // Action Buttons
              Row(
                children: [
                  // Edit
                  IconButton(
                    onPressed: onBulkEdit,
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Bulk Edit',
                  ),

                  // Activate
                  IconButton(
                    onPressed: onBulkActivate,
                    icon: CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Activate Selected',
                  ),

                  // Suspend
                  IconButton(
                    onPressed: onBulkSuspend,
                    icon: CustomIconWidget(
                      iconName: 'pause_circle',
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Suspend Selected',
                  ),

                  // Export
                  IconButton(
                    onPressed: onExportSelected,
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: Colors.white,
                      size: 20,
                    ),
                    tooltip: 'Export Selected',
                  ),

                  // More Actions
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          onBulkDelete();
                          break;
                      }
                    },
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: Colors.white,
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Delete Selected',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
