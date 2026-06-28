import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_button_widget.dart';
import './widgets/balance_card_widget.dart';
import './widgets/emergency_contact_card_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/recent_transaction_card_widget.dart';

class BeneficiaryDashboard extends StatefulWidget {
  const BeneficiaryDashboard({Key? key}) : super(key: key);

  @override
  State<BeneficiaryDashboard> createState() => _BeneficiaryDashboardState();
}

class _BeneficiaryDashboardState extends State<BeneficiaryDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isConnected = true;
  bool _isWalletSynced = true;
  bool _isRefreshing = false;
  bool _isQRGenerating = false;

  // Mock beneficiary data
  final Map<String, dynamic> beneficiaryData = {
    "id": "BEN-2025-001",
    "name": "Maria Santos",
    "programName": "Emergency Food Assistance Program",
    "availableBalance": 450.75,
    "lockedBalance": 200.00,
    "currency": "\$",
    "contactNumber": "+1-800-AID-HELP",
    "supportEmail": "support@aidchain.org",
    "lastUpdated": DateTime.now().subtract(const Duration(minutes: 15)),
  };

  final List<Map<String, dynamic>> recentTransactions = [
    {
      "id": "TXN-001",
      "type": "received",
      "amount": 150.00,
      "currency": "\$",
      "source": "World Food Programme",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "completed",
      "hash": "0x1a2b3c4d5e6f7890abcdef1234567890",
    },
    {
      "id": "TXN-002",
      "type": "cashout",
      "amount": 75.50,
      "currency": "\$",
      "source": "Local Agent Network",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "status": "completed",
      "hash": "0x9876543210fedcba0987654321abcdef",
    },
    {
      "id": "TXN-003",
      "type": "received",
      "amount": 200.00,
      "currency": "\$",
      "source": "UNICEF Emergency Fund",
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "status": "completed",
      "hash": "0xabcdef1234567890fedcba0987654321",
    },
    {
      "id": "TXN-004",
      "type": "received",
      "amount": 100.25,
      "currency": "\$",
      "source": "Red Cross International",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "status": "pending",
      "hash": "0x567890abcdef1234567890abcdef1234",
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulateNetworkStatus();
  }

  void _simulateNetworkStatus() {
    // Simulate occasional network issues for demo
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isWalletSynced = false;
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Simulate blockchain sync
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _isConnected = true;
          _isWalletSynced = true;
          beneficiaryData['lastUpdated'] = DateTime.now();
        });

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Wallet synced successfully'),
            backgroundColor: AppTheme.successLight,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _handleQRGeneration() async {
    setState(() {
      _isQRGenerating = true;
    });

    // Provide haptic feedback
    HapticFeedback.mediumImpact();

    // Simulate QR generation process
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isQRGenerating = false;
      });

      // Navigate to QR code generator
      Navigator.pushNamed(context, '/qr-code-generator');
    }
  }

  void _handleTransactionTap(Map<String, dynamic> transaction) {
    // Navigate to transaction details
    Navigator.pushNamed(context, '/transaction-history');
  }

  void _handleTransactionLongPress(Map<String, dynamic> transaction) {
    // Show context menu
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.dividerColor,
                borderRadius: BorderRadius.circular(0.25.h),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.primaryColor,
                size: 20.sp,
              ),
              title: Text(
                'Generate Receipt',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _generateReceipt(transaction);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.primaryColor,
                size: 20.sp,
              ),
              title: Text(
                'Verify on Blockchain',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _verifyTransaction(transaction);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _generateReceipt(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt generated for transaction ${transaction['id']}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _verifyTransaction(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verified: ${transaction['hash']}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleEmergencyCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${beneficiaryData['contactNumber']}...'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _handleEmergencyEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening email to ${beneficiaryData['supportEmail']}...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selection
    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/transaction-history');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushNamed(context, '/help');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'AidChain',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        centerTitle: AppTheme.lightTheme.appBarTheme.centerTitle,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to notifications or settings
            },
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          NetworkStatusWidget(
            isConnected: _isConnected,
            isWalletSynced: _isWalletSynced,
            onSyncPressed: _handleRefresh,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.lightTheme.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Welcome message
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Text(
                        'Welcome back, ${beneficiaryData['name']}',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Balance card
                    BalanceCardWidget(
                      availableBalance:
                          beneficiaryData['availableBalance'] as double,
                      lockedBalance: beneficiaryData['lockedBalance'] as double,
                      currency: beneficiaryData['currency'] as String,
                      isOffline: !_isConnected,
                      lastUpdated: beneficiaryData['lastUpdated'] as DateTime?,
                    ),

                    SizedBox(height: 2.h),

                    // Primary actions
                    ActionButtonWidget(
                      title: 'Request Cash Out',
                      iconName: 'qr_code',
                      onPressed: _handleQRGeneration,
                      isPrimary: true,
                      isLoading: _isQRGenerating,
                    ),

                    ActionButtonWidget(
                      title: 'View All Transactions',
                      iconName: 'history',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/transaction-history'),
                      isPrimary: false,
                    ),

                    SizedBox(height: 3.h),

                    // Recent transactions section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_isRefreshing)
                            SizedBox(
                              width: 4.w,
                              height: 4.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Recent transactions list
                    ...recentTransactions.take(3).map(
                          (transaction) => RecentTransactionCardWidget(
                            transaction: transaction,
                            onTap: () => _handleTransactionTap(transaction),
                            onLongPress: () =>
                                _handleTransactionLongPress(transaction),
                          ),
                        ),

                    SizedBox(height: 3.h),

                    // Emergency contact card
                    EmergencyContactCardWidget(
                      programName: beneficiaryData['programName'] as String,
                      contactNumber: beneficiaryData['contactNumber'] as String,
                      supportEmail: beneficiaryData['supportEmail'] as String,
                      onCallPressed: _handleEmergencyCall,
                      onEmailPressed: _handleEmergencyEmail,
                    ),

                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
        elevation:
            AppTheme.lightTheme.bottomNavigationBarTheme.elevation ?? 8.0,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _selectedIndex == 0
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 20.sp,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _selectedIndex == 1
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 20.sp,
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedIndex == 2
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 20.sp,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'help',
              color: _selectedIndex == 3
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 20.sp,
            ),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}
