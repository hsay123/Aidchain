import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_info_card_widget.dart';
import './widgets/profile_menu_item_widget.dart';
import './widgets/security_settings_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data - in real app this would come from user service
  final Map<String, dynamic> _userData = {
    "id": "BEN_2024_001",
    "name": "Maria Santos",
    "email": "maria.santos@example.com",
    "phone": "+1 (555) 123-4567",
    "role": "beneficiary",
    "program": "Emergency Food Assistance Program",
    "registrationDate": "January 15, 2025",
    "kycStatus": "verified",
    "walletAddress": "GCKFBEIYTKQTPOQY5XLBVMDSYRPGVGCQZGQOSHPQANPTHQISE2UFBFEQ",
    "profilePhoto": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "location": "North Region",
    "emergencyContact": "+1 (555) 987-6543",
    "preferredLanguage": "English",
    "notificationsEnabled": true,
    "biometricEnabled": true,
    "twoFactorEnabled": false,
  };

  bool _isEditing = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = _userData['name'] ?? '';
    _phoneController.text = _userData['phone'] ?? '';
    _emergencyContactController.text = _userData['emergencyContact'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
        _userData['name'] = _nameController.text;
        _userData['phone'] = _phoneController.text;
        _userData['emergencyContact'] = _emergencyContactController.text;
      });

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    _initializeControllers();
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Password changed successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _copyWalletAddress() {
    Clipboard.setData(ClipboardData(text: _userData['walletAddress']));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Wallet address copied to clipboard'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing) ...[
            TextButton(
              onPressed: _cancelEdit,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: _isLoading ? null : _saveProfile,
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ] else
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              icon: CustomIconWidget(
                iconName: 'edit',
                color: Colors.white,
                size: 24,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userData: _userData,
              onPhotoTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo update feature coming soon'),
                  ),
                );
              },
            ),

            SizedBox(height: 2.h),

            // Profile Information Cards
            if (_isEditing) ...[
              // Editable form
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: _emergencyContactController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact',
                        prefixIcon: Icon(Icons.emergency),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Display mode
              ProfileInfoCardWidget(
                title: 'Personal Information',
                items: [
                  {'label': 'Full Name', 'value': _userData['name']},
                  {'label': 'Email', 'value': _userData['email']},
                  {'label': 'Phone', 'value': _userData['phone']},
                  {'label': 'Role', 'value': _userData['role'].toString().toUpperCase()},
                  {'label': 'Location', 'value': _userData['location']},
                ],
              ),

              ProfileInfoCardWidget(
                title: 'Program Information',
                items: [
                  {'label': 'Program', 'value': _userData['program']},
                  {'label': 'Registration Date', 'value': _userData['registrationDate']},
                  {'label': 'KYC Status', 'value': _userData['kycStatus'], 'isStatus': true},
                ],
              ),

              ProfileInfoCardWidget(
                title: 'Blockchain Information',
                items: [
                  {
                    'label': 'Wallet Address',
                    'value': '${_userData['walletAddress'].substring(0, 10)}...${_userData['walletAddress'].substring(_userData['walletAddress'].length - 8)}',
                    'isWallet': true,
                    'onTap': _copyWalletAddress,
                  },
                ],
              ),
            ],

            SizedBox(height: 2.h),

            // Security Settings
            if (!_isEditing)
              SecuritySettingsWidget(
                biometricEnabled: _userData['biometricEnabled'],
                twoFactorEnabled: _userData['twoFactorEnabled'],
                notificationsEnabled: _userData['notificationsEnabled'],
                onBiometricChanged: (value) {
                  setState(() {
                    _userData['biometricEnabled'] = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Biometric authentication enabled' : 'Biometric authentication disabled',
                      ),
                    ),
                  );
                },
                onTwoFactorChanged: (value) {
                  setState(() {
                    _userData['twoFactorEnabled'] = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Two-factor authentication enabled' : 'Two-factor authentication disabled',
                      ),
                    ),
                  );
                },
                onNotificationsChanged: (value) {
                  setState(() {
                    _userData['notificationsEnabled'] = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Notifications enabled' : 'Notifications disabled',
                      ),
                    ),
                  );
                },
              ),

            SizedBox(height: 2.h),

            // Menu Items
            if (!_isEditing) ...[
              ProfileMenuItemWidget(
                icon: 'settings',
                title: 'Settings',
                onTap: _navigateToSettings,
              ),
              
              ProfileMenuItemWidget(
                icon: 'help',
                title: 'Help & Support',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),

              ProfileMenuItemWidget(
                icon: 'lock',
                title: 'Change Password',
                onTap: _showChangePasswordDialog,
              ),

              ProfileMenuItemWidget(
                icon: 'history',
                title: 'Transaction History',
                onTap: () => Navigator.pushNamed(context, '/transaction-history'),
              ),

              ProfileMenuItemWidget(
                icon: 'logout',
                title: 'Logout',
                isDestructive: true,
                onTap: _showLogoutDialog,
              ),
            ],

            SizedBox(height: 10.h), // Bottom padding
          ],
        ),
      ),
    );
  }
}
