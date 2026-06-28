import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SystemSettings extends StatelessWidget {
  const SystemSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Settings')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(iconName: 'settings', color: AppTheme.lightTheme.colorScheme.primary, size: 64),
              SizedBox(height: 3.h),
              Text('System Settings', style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              Text('Configure system parameters and preferences', style: AppTheme.lightTheme.textTheme.bodyMedium),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: () {}, child: const Text('Configure Settings')),
            ],
          ),
        ),
      ),
    );
  }
} 