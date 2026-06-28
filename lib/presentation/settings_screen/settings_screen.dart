import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/settings_section_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/theme_selector_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _notificationsEnabled = true;
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  bool _dataBackupEnabled = true;
  bool _analyticsEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';
  String _selectedCurrency = 'USD';

  // Language options
  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'sw', 'name': 'Kiswahili'},
  ];

  // Theme options
  final List<String> _themes = ['Light', 'Dark', 'System'];

  // Currency options
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'Euro', 'symbol': '€'},
    {'code': 'GBP', 'name': 'British Pound', 'symbol': '£'},
    {'code': 'KES', 'name': 'Kenyan Shilling', 'symbol': 'KSh'},
    {'code': 'NGN', 'name': 'Nigerian Naira', 'symbol': '₦'},
  ];

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => LanguageSelectorWidget(
        languages: _languages,
        selectedLanguage: _selectedLanguage,
        onLanguageSelected: (language) {
          setState(() {
            _selectedLanguage = language;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $language'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ThemeSelectorWidget(
        themes: _themes,
        selectedTheme: _selectedTheme,
        onThemeSelected: (theme) {
          setState(() {
            _selectedTheme = theme;
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme changed to $theme'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }

  void _showCurrencySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _currencies.map((currency) {
            return RadioListTile<String>(
              title: Text('${currency['name']} (${currency['symbol']})'),
              value: currency['code']!,
              groupValue: _selectedCurrency,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Currency changed to ${currency['name']}'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
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
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Preparing data export...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
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
                  content: const Text('Account deletion process started'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Notifications Section
            SettingsSectionWidget(
              title: 'Notifications',
              icon: 'notifications',
              children: [
                SettingsItemWidget(
                  title: 'Push Notifications',
                  subtitle: 'Receive updates about transactions and account activity',
                  icon: 'notifications_active',
                  isSwitch: true,
                  switchValue: _notificationsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),

            // Security Section
            SettingsSectionWidget(
              title: 'Security',
              icon: 'security',
              children: [
                SettingsItemWidget(
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face recognition',
                  icon: 'fingerprint',
                  isSwitch: true,
                  switchValue: _biometricEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                    });
                  },
                ),
                SettingsItemWidget(
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  icon: 'verified_user',
                  isSwitch: true,
                  switchValue: _twoFactorEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _twoFactorEnabled = value;
                    });
                  },
                ),
              ],
            ),

            // Appearance Section
            SettingsSectionWidget(
              title: 'Appearance',
              icon: 'palette',
              children: [
                SettingsItemWidget(
                  title: 'Theme',
                  subtitle: _selectedTheme,
                  icon: 'brightness_6',
                  onTap: _showThemeSelector,
                ),
                SettingsItemWidget(
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  icon: 'language',
                  onTap: _showLanguageSelector,
                ),
                SettingsItemWidget(
                  title: 'Currency',
                  subtitle: _currencies.firstWhere(
                    (c) => c['code'] == _selectedCurrency,
                    orElse: () => {'name': 'USD'},
                  )['name']!,
                  icon: 'attach_money',
                  onTap: _showCurrencySelector,
                ),
              ],
            ),

            // Data & Privacy Section
            SettingsSectionWidget(
              title: 'Data & Privacy',
              icon: 'privacy_tip',
              children: [
                SettingsItemWidget(
                  title: 'Data Backup',
                  subtitle: 'Automatically backup your data',
                  icon: 'backup',
                  isSwitch: true,
                  switchValue: _dataBackupEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _dataBackupEnabled = value;
                    });
                  },
                ),
                SettingsItemWidget(
                  title: 'Analytics',
                  subtitle: 'Help improve the app by sharing usage data',
                  icon: 'analytics',
                  isSwitch: true,
                  switchValue: _analyticsEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _analyticsEnabled = value;
                    });
                  },
                ),
                SettingsItemWidget(
                  title: 'Export Data',
                  subtitle: 'Download your account data',
                  icon: 'download',
                  onTap: _exportData,
                ),
              ],
            ),

            // Storage Section
            SettingsSectionWidget(
              title: 'Storage',
              icon: 'storage',
              children: [
                SettingsItemWidget(
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  icon: 'clear_all',
                  onTap: _clearCache,
                ),
              ],
            ),

            // About Section
            SettingsSectionWidget(
              title: 'About',
              icon: 'info',
              children: [
                SettingsItemWidget(
                  title: 'Version',
                  subtitle: '1.0.0 (Build 100)',
                  icon: 'info_outline',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('AidChain'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Version: 1.0.0'),
                            Text('Build: 100'),
                            SizedBox(height: 1.h),
                            Text('© 2025 AidChain Foundation'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SettingsItemWidget(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  icon: 'policy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening privacy policy...')),
                    );
                  },
                ),
                SettingsItemWidget(
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  icon: 'description',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening terms of service...')),
                    );
                  },
                ),
              ],
            ),

            // Danger Zone Section
            SettingsSectionWidget(
              title: 'Danger Zone',
              icon: 'warning',
              isDanger: true,
              children: [
                SettingsItemWidget(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  icon: 'delete_forever',
                  isDanger: true,
                  onTap: _deleteAccount,
                ),
              ],
            ),

            SizedBox(height: 10.h), // Bottom padding
          ],
        ),
      ),
    );
  }
}
