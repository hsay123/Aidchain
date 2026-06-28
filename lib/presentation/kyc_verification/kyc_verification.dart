import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class KycVerification extends StatelessWidget {
  const KycVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(iconName: 'verified_user', color: AppTheme.lightTheme.colorScheme.primary, size: 64),
              SizedBox(height: 3.h),
              Text('KYC Verification Center', style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 2.h),
              Text('Manage beneficiary KYC verification process', style: AppTheme.lightTheme.textTheme.bodyMedium),
              SizedBox(height: 4.h),
              ElevatedButton(onPressed: () {}, child: const Text('Start Verification Process')),
            ],
          ),
        ),
      ),
    );
  }
} 