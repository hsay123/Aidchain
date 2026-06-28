import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isWalletSynced;
  final VoidCallback? onSyncPressed;

  const NetworkStatusWidget({
    Key? key,
    required this.isConnected,
    required this.isWalletSynced,
    this.onSyncPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getStatusIcon(),
            color: _getStatusColor(),
            size: 14.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              _getStatusText(),
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(),
              ),
            ),
          ),
          if (!isConnected || !isWalletSynced)
            GestureDetector(
              onTap: onSyncPressed,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: _getStatusColor(),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      color: _getStatusColor(),
                      size: 12.sp,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Sync',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!isConnected) {
      return AppTheme.errorLight;
    } else if (!isWalletSynced) {
      return AppTheme.warningLight;
    } else {
      return AppTheme.successLight;
    }
  }

  String _getStatusIcon() {
    if (!isConnected) {
      return 'wifi_off';
    } else if (!isWalletSynced) {
      return 'sync_problem';
    } else {
      return 'wifi';
    }
  }

  String _getStatusText() {
    if (!isConnected) {
      return 'No internet connection - Using cached data';
    } else if (!isWalletSynced) {
      return 'Wallet sync pending - Tap to refresh';
    } else {
      return 'Connected - Wallet synced';
    }
  }
}
