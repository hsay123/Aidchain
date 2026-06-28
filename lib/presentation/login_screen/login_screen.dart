import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_selector_widget.dart';
import './widgets/two_factor_auth_modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'beneficiary';
  bool _isLoading = false;
  bool _showBiometric = false;
  String _errorMessage = '';

  // Mock user credentials for different roles
  final Map<String, Map<String, dynamic>> _mockCredentials = {
    'admin': {
      'email': 'admin@aidchain.org',
      'password': 'Admin123!',
      'requiresTwoFactor': true,
    },
    'beneficiary': {
      'email': 'beneficiary@example.com',
      'password': 'Beneficiary123!',
      'requiresTwoFactor': false,
    },
    'auditor': {
      'email': 'auditor@aidchain.org',
      'password': 'Auditor123!',
      'requiresTwoFactor': true,
    },
    'agent': {
      'email': 'agent@aidchain.org',
      'password': 'Agent123!',
      'requiresTwoFactor': false,
    },
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate blockchain wallet verification delay
      await Future.delayed(const Duration(milliseconds: 2000));

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final roleCredentials = _mockCredentials[_selectedRole];

      // Validate credentials
      if (email != roleCredentials?['email'] ||
          password != roleCredentials?['password']) {
        throw Exception(
            'Invalid email or password. Please check your credentials.');
      }

      // Check if two-factor authentication is required
      if (roleCredentials?['requiresTwoFactor'] == true) {
        _showTwoFactorModal();
      } else {
        _handleSuccessfulLogin();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      HapticFeedback.vibrate();

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showTwoFactorModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TwoFactorAuthModal(
        userRole: _selectedRole,
        onSuccess: () {
          Navigator.pop(context);
          _handleSuccessfulLogin();
        },
        onCancel: () {
          Navigator.pop(context);
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );
  }

  void _handleSuccessfulLogin() {
    HapticFeedback.lightImpact();

    // Show biometric setup for first-time users
    setState(() {
      _showBiometric = true;
    });

    // Navigate to role-specific dashboard after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _navigateToRoleDashboard();
    });
  }

  void _navigateToRoleDashboard() {
    String route;
    switch (_selectedRole) {
      case 'admin':
        route = '/admin-dashboard';
        break;
      case 'beneficiary':
        route = '/beneficiary-dashboard';
        break;
      case 'auditor':
        route = '/auditor-dashboard';
        break;
      case 'agent':
        route = '/agent-dashboard';
        break;
      default:
        route = '/beneficiary-dashboard';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  void _handleBiometricSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Biometric authentication enabled successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
    _navigateToRoleDashboard();
  }

  void _handleBiometricError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          'Password reset instructions will be sent to your registered email address.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset email sent successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo and Title
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'account_balance',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16.w,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Text(
                      'AidChain',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                    ),
                    SizedBox(height: 1.h),

                    Text(
                      'Transparent Aid Distribution',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(height: 5.h),

                    // Role Selector
                    RoleSelectorWidget(
                      selectedRole: _selectedRole,
                      onRoleSelected: (role) {
                        setState(() {
                          _selectedRole = role;
                          _errorMessage = '';
                        });
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Login Form
                    LoginFormWidget(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isLoading: _isLoading,
                      onLogin: _handleLogin,
                      onForgotPassword: _handleForgotPassword,
                    ),
                    SizedBox(height: 2.h),

                    // Biometric Authentication (shown after successful login)
                    if (_showBiometric)
                      BiometricAuthWidget(
                        onBiometricSuccess: _handleBiometricSuccess,
                        onBiometricError: _handleBiometricError,
                      ),

                    SizedBox(height: 4.h),

                    // Mock Credentials Info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Demo Credentials',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Admin: admin@aidchain.org / Admin123!\n'
                            'Beneficiary: beneficiary@example.com / Beneficiary123!\n'
                            'Auditor: auditor@aidchain.org / Auditor123!\n'
                            'Agent: agent@aidchain.org / Agent123!',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontFamily: 'monospace',
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
          ),
        ),
      ),
    );
  }
}
