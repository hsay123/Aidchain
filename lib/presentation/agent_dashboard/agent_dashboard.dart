import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/agent_stats_widget.dart';
import './widgets/pending_request_widget.dart';
import './widgets/recent_transaction_widget.dart';
import './widgets/quick_action_widget.dart';
import './widgets/location_status_widget.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({Key? key}) : super(key: key);

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOnline = true;
  bool _isRefreshing = false;
  double _cashBalance = 15750.00;
  String _location = "Downtown Branch - Station 1";

  // Mock agent data
  final Map<String, dynamic> _agentData = {
    "id": "AGT-001",
    "name": "John Smith",
    "station": "Downtown Branch - Station 1",
    "region": "Central District",
    "rating": 4.8,
    "totalTransactions": 1247,
    "todayTransactions": 23,
    "cashBalance": 15750.00,
    "maxCashLimit": 25000.00,
    "status": "online",
  };

  final List<Map<String, dynamic>> _pendingRequests = [
    {
      "id": "REQ-2025-001",
      "beneficiaryName": "Maria Santos",
      "beneficiaryId": "BEN-2024-001",
      "amount": 150.00,
      "currency": "\$",
      "requestTime": DateTime.now().subtract(const Duration(minutes: 5)),
      "qrCode": "AC240115001",
      "reason": "Food & Groceries",
      "status": "pending",
      "distance": "0.2 km",
    },
    {
      "id": "REQ-2025-002",
      "beneficiaryName": "Ahmed Hassan",
      "beneficiaryId": "BEN-2024-002",
      "amount": 75.50,
      "currency": "\$",
      "requestTime": DateTime.now().subtract(const Duration(minutes: 12)),
      "qrCode": "AC240115002",
      "reason": "Medicine & Healthcare",
      "status": "pending",
      "distance": "0.5 km",
    },
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "id": "TXN-001",
      "beneficiaryName": "Sarah Johnson",
      "amount": 200.00,
      "currency": "\$",
      "type": "cash_out",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
      "status": "completed",
      "fee": 2.00,
    },
    {
      "id": "TXN-002",
      "beneficiaryName": "David Chen",
      "amount": 125.00,
      "currency": "\$",
      "type": "cash_out",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
      "status": "completed",
      "fee": 1.25,
    },
    {
      "id": "TXN-003",
      "beneficiaryName": "Fatima Al-Zahra",
      "amount": 300.00,
      "currency": "\$",
      "type": "cash_out",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "completed",
      "fee": 3.00,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _toggleOnlineStatus() async {
    setState(() {
      _isOnline = !_isOnline;
      _agentData['status'] = _isOnline ? 'online' : 'offline';
    });

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'You are now online' : 'You are now offline'),
        backgroundColor: _isOnline 
            ? AppTheme.lightTheme.colorScheme.secondary 
            : AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    }
  }

  void _processRequest(Map<String, dynamic> request, bool approve) {
    setState(() {
      _pendingRequests.remove(request);
    });

    if (approve) {
      // Add to recent transactions
      _recentTransactions.insert(0, {
        "id": "TXN-${DateTime.now().millisecondsSinceEpoch}",
        "beneficiaryName": request['beneficiaryName'],
        "amount": request['amount'],
        "currency": request['currency'],
        "type": "cash_out",
        "timestamp": DateTime.now(),
        "status": "completed",
        "fee": (request['amount'] as double) * 0.01, // 1% fee
      });

      // Update cash balance
      setState(() {
        _cashBalance -= (request['amount'] as double);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cash out approved: ${request['currency']}${request['amount']}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request rejected: ${request['id']}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 64,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            const Text('Position the QR code within the frame to scan'),
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
              // Simulate successful scan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('QR Code scanned successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: const Text('Manual Entry'),
          ),
        ],
      ),
    );
  }

  void _addCash() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Cash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount to Add',
                prefixText: '\$ ',
                helperText: 'Enter the cash amount you want to add',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Authorization Code',
                helperText: 'Enter the code from your supervisor',
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
              setState(() {
                _cashBalance += 5000.00; // Simulate adding cash
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cash added successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: const Text('Add Cash'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    backgroundColor: Colors.white,
                    child: CustomIconWidget(
                      iconName: 'support_agent',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _agentData['name'],
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Agent ID: ${_agentData['id']}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    _agentData['station'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerItem('Transaction History', 'history', () {
                    Navigator.pushNamed(context, '/transaction-history');
                  }),
                  _buildDrawerItem('QR Scanner', 'qr_code_scanner', _scanQRCode),
                  _buildDrawerItem('Cash Management', 'attach_money', _addCash),
                  _buildDrawerItem('Reports', 'assessment', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening reports...')),
                    );
                  }),
                  _buildDrawerItem('Profile', 'person', () {
                    Navigator.pushNamed(context, '/profile');
                  }),
                  _buildDrawerItem('Settings', 'settings', () {
                    Navigator.pushNamed(context, '/settings');
                  }),
                  _buildDrawerItem('Help', 'help', () {
                    Navigator.pushNamed(context, '/help');
                  }),
                  Divider(),
                  _buildDrawerItem('Logout', 'logout', () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login-screen',
                      (route) => false,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Agent Dashboard'),
        actions: [
          // Online/Offline Toggle
          Switch(
            value: _isOnline,
            onChanged: (value) => _toggleOnlineStatus(),
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white.withValues(alpha: 0.7),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(width: 2.w),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening notifications...')),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Indicator
              LocationStatusWidget(
                isOnline: _isOnline,
                location: _location,
                cashBalance: _cashBalance,
                maxCashLimit: _agentData['maxCashLimit'],
              ),

              // Agent Stats
              AgentStatsWidget(
                todayTransactions: _agentData['todayTransactions'],
                totalTransactions: _agentData['totalTransactions'],
                rating: _agentData['rating'],
                cashBalance: _cashBalance,
              ),

              SizedBox(height: 2.h),

              // Quick Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Quick Actions',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: QuickActionWidget(
                        title: 'Scan QR',
                        icon: 'qr_code_scanner',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        onTap: _scanQRCode,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: QuickActionWidget(
                        title: 'Add Cash',
                        icon: 'add_circle',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        onTap: _addCash,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: QuickActionWidget(
                        title: 'History',
                        icon: 'history',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        onTap: () => Navigator.pushNamed(context, '/transaction-history'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Pending Requests
              if (_pendingRequests.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    children: [
                      Text(
                        'Pending Requests',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _pendingRequests.length.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),

                ..._pendingRequests.map((request) => PendingRequestWidget(
                      request: request,
                      onApprove: () => _processRequest(request, true),
                      onReject: () => _processRequest(request, false),
                    )),

                SizedBox(height: 3.h),
              ],

              // Recent Transactions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Recent Transactions',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),

              ..._recentTransactions.take(5).map((transaction) => RecentTransactionWidget(
                    transaction: transaction,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening details for ${transaction['id']}')),
                      );
                    },
                  )),

              SizedBox(height: 10.h), // Bottom padding
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQRCode,
        icon: CustomIconWidget(
          iconName: 'qr_code_scanner',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('Scan QR'),
        backgroundColor: _isOnline 
            ? AppTheme.lightTheme.colorScheme.primary 
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
