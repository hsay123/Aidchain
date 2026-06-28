import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class ComplianceReports extends StatelessWidget {
  const ComplianceReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compliance Reports')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(iconName: 'rule', color: AppTheme.lightTheme.colorScheme.primary, size: 64),
              SizedBox(height: 3.h),
              Text('Compliance Reports', style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              Text('Monitor compliance and regulatory requirements', style: AppTheme.lightTheme.textTheme.bodyMedium),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: () {}, child: const Text('View Compliance Status')),
            ],
          ),
        ),
      ),
    );
  }
} 