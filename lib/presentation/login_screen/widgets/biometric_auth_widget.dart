import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricSuccess;
  final Function(String) onBiometricError;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricSuccess,
    required this.onBiometricError,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isBiometricAvailable = false;
  bool _isAuthenticating = false;
  String _biometricType = 'fingerprint';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _checkBiometricAvailability();
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Mock biometric availability check
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isBiometricAvailable = true;
        // Simulate different biometric types based on platform
        _biometricType = Theme.of(context).platform == TargetPlatform.iOS
            ? 'face_id'
            : 'fingerprint';
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!_isBiometricAvailable || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Mock biometric authentication
      await Future.delayed(const Duration(milliseconds: 2000));

      // Simulate success/failure randomly for demo
      final isSuccess = DateTime.now().millisecond % 3 != 0;

      if (isSuccess) {
        HapticFeedback.lightImpact();
        widget.onBiometricSuccess();
      } else {
        HapticFeedback.vibrate();
        widget.onBiometricError(
            'Biometric authentication failed. Please try again.');
      }
    } catch (e) {
      widget
          .onBiometricError('Biometric authentication error: ${e.toString()}');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  String get _biometricIcon {
    switch (_biometricType) {
      case 'face_id':
        return 'face';
      case 'fingerprint':
        return 'fingerprint';
      default:
        return 'security';
    }
  }

  String get _biometricLabel {
    switch (_biometricType) {
      case 'face_id':
        return 'Face ID';
      case 'fingerprint':
        return 'Fingerprint';
      default:
        return 'Biometric';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Column(
        children: [
          // Divider with "OR" text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Biometric Authentication Button
          GestureDetector(
            onTap: _authenticateWithBiometrics,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isAuthenticating ? _scaleAnimation.value : 1.0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isAuthenticating
                          ? AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2)
                          : AppTheme.lightTheme.colorScheme.surface,
                      border: Border.all(
                        color: _isAuthenticating
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isAuthenticating
                        ? Center(
                            child: SizedBox(
                              width: 8.w,
                              height: 8.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: _biometricIcon,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 8.w,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),

          // Biometric Label
          Text(
            _isAuthenticating ? 'Authenticating...' : 'Use $_biometricLabel',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 1.h),

          // Instruction Text
          Text(
            _isAuthenticating
                ? 'Please complete biometric verification'
                : 'Touch the sensor or look at the camera',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
