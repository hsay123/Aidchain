import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(iconName: 'manage_accounts', color: AppTheme.lightTheme.colorScheme.primary, size: 64),
              SizedBox(height: 3.h),
              Text('User Management', style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              Text('Manage users, roles, and permissions', style: AppTheme.lightTheme.textTheme.bodyMedium),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: () {}, child: const Text('Manage Users')),
            ],
          ),
        ),
      ),
    );
  }
} 