import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amount_input_widget.dart';
import './widgets/qr_code_display_widget.dart';
import './widgets/step_indicator_widget.dart';
import './widgets/withdrawal_reason_widget.dart';

class QrCodeGenerator extends StatefulWidget {
  const QrCodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrCodeGenerator> createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customReasonController = TextEditingController();

  late AnimationController _slideController;
  late AnimationController _loadingController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String? _selectedReason;
  String? _amountError;
  bool _isGenerating = false;
  bool _showQRCode = false;
  String _generatedTransactionId = '';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "user_id": "BEN_2024_001",
    "name": "Maria Santos",
    "wallet_address":
        "GCKFBEIYTKQTPOQY5XLBVMDSYRPGVGCQZGQOSHPQANPTHQISE2UFBFEQ",
    "available_balance": "1,247.50",
    "program": "Emergency Food Assistance",
    "last_transaction": "2025-08-07 14:30:00",
    "kyc_status": "verified",
    "agent_network_enabled": true,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeIn,
    ));

    _slideController.forward();
  }

  void _validateAmount(String value) {
    setState(() {
      if (value.isEmpty) {
        _amountError = 'Please enter an amount';
      } else {
        final amount = double.tryParse(value);
        final availableBalance =
            double.tryParse(_userData['available_balance'].replaceAll(',', ''));

        if (amount == null || amount <= 0) {
          _amountError = 'Please enter a valid amount';
        } else if (amount > (availableBalance ?? 0)) {
          _amountError = 'Insufficient balance';
        } else if (amount < 1) {
          _amountError = 'Minimum withdrawal amount is \$1.00';
        } else {
          _amountError = null;
        }
      }
    });
  }

  String _generateTransactionId() {
    final random = Random();
    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    final randomSuffix = random.nextInt(9999).toString().padLeft(4, '0');
    return 'AC${timestamp}${randomSuffix}';
  }

  Future<void> _generateQRCode() async {
    if (_amountController.text.isEmpty ||
        _selectedReason == null ||
        _amountError != null) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    if (_selectedReason == 'custom' &&
        _customReasonController.text.trim().isEmpty) {
      _showErrorSnackBar('Please specify the custom reason');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    _loadingController.repeat();

    // Simulate QR code generation process
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _isGenerating = false;
        _generatedTransactionId = _generateTransactionId();
        _showQRCode = true;
      });

      _loadingController.stop();
      _loadingController.reset();

      // Haptic feedback for successful generation
      HapticFeedback.lightImpact();

      _showQRCodeModal();
    }
  }

  void _showQRCodeModal() {
    final reasonText = _selectedReason == 'custom'
        ? _customReasonController.text.trim()
        : _getReasonLabel(_selectedReason!);

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            QrCodeDisplayWidget(
          amount: _amountController.text,
          reason: reasonText,
          transactionId: _generatedTransactionId,
          onClose: () {
            Navigator.of(context).pop();
            _resetForm();
          },
          onShare: _shareQRCode,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        barrierDismissible: false,
        opaque: false,
      ),
    );
  }

  void _shareQRCode() {
    // Simulate share functionality
    HapticFeedback.selectionClick();
    _showSuccessSnackBar('QR code shared successfully');
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _customReasonController.clear();
      _selectedReason = null;
      _amountError = null;
      _showQRCode = false;
      _generatedTransactionId = '';
    });
  }

  String _getReasonLabel(String reason) {
    switch (reason) {
      case 'food':
        return 'Food & Groceries';
      case 'medicine':
        return 'Medicine & Healthcare';
      case 'education':
        return 'Education & School';
      case 'emergency':
        return 'Emergency';
      default:
        return 'Other';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _customReasonController.dispose();
    _slideController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 2.h,
                  left: 4.w,
                  right: 4.w,
                  bottom: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Cash Out Request',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48), // Balance the close button
                      ],
                    ),
                    SizedBox(height: 2.h),
                    StepIndicatorWidget(
                      currentStep: _showQRCode ? 2 : 1,
                      totalSteps: 2,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // User Info Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (_userData['name'] as String)
                                      .split(' ')
                                      .map((e) => e[0])
                                      .join(''),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _userData['name'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _userData['program'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'verified',
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Verified',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Amount Input
                      AmountInputWidget(
                        controller: _amountController,
                        availableBalance: _userData['available_balance'],
                        onChanged: _validateAmount,
                        errorText: _amountError,
                      ),

                      SizedBox(height: 4.h),

                      // Withdrawal Reason
                      WithdrawalReasonWidget(
                        selectedReason: _selectedReason,
                        onReasonChanged: (reason) {
                          setState(() {
                            _selectedReason = reason;
                          });
                        },
                        customReasonController: _customReasonController,
                      ),

                      SizedBox(height: 6.h),

                      // Generate QR Code Button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed: _isGenerating ? null : _generateQRCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isGenerating
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      'Generating QR Code...',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'qr_code',
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Generate QR Code',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Security Notice
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'security',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Security Notice',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'QR codes expire in 30 minutes and can only be used once. Keep your code secure.',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
