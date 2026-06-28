import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class AuditTrail extends StatelessWidget {
  const AuditTrail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Trail')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(iconName: 'fact_check', color: AppTheme.lightTheme.colorScheme.primary, size: 64),
              SizedBox(height: 3.h),
              Text('Audit Trail', style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              Text('View complete transaction audit trail and logs', style: AppTheme.lightTheme.textTheme.bodyMedium),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: () {}, child: const Text('View Audit Logs')),
            ],
          ),
        ),
      ),
    );
  }
} 