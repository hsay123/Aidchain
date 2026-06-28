import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/approval_notification_widget.dart';
import './widgets/fraud_alert_banner_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/program_card_widget.dart';
import './widgets/quick_action_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _fraudAlerts = [];
  List<Map<String, dynamic>> _pendingApprovals = [];

  // Mock data for dashboard metrics
  final List<Map<String, dynamic>> _dashboardMetrics = [
    {
      "title": "Active Programs",
      "value": "12",
      "subtitle": "Currently running",
      "trend": "+2 this month",
      "isPositiveTrend": true,
    },
    {
      "title": "Total Beneficiaries",
      "value": "8,547",
      "subtitle": "Across all programs",
      "trend": "+15% growth",
      "isPositiveTrend": true,
    },
    {
      "title": "Funds Distributed",
      "value": "\$2.4M",
      "subtitle": "This quarter",
      "trend": "+8.2% vs last quarter",
      "isPositiveTrend": true,
    },
    {
      "title": "Pending Approvals",
      "value": "23",
      "subtitle": "Awaiting review",
      "trend": "-5 since yesterday",
      "isPositiveTrend": true,
    },
  ];

  // Mock data for active programs
  final List<Map<String, dynamic>> _activePrograms = [
    {
      "id": 1,
      "name": "Emergency Food Assistance",
      "status": "Active",
      "beneficiaries": 2450,
      "progress": 0.75,
      "totalFunds": "\$850,000",
      "distributedFunds": "\$637,500",
      "description":
          "Providing emergency food assistance to families affected by natural disasters",
    },
    {
      "id": 2,
      "name": "Education Support Program",
      "status": "Active",
      "beneficiaries": 1200,
      "progress": 0.45,
      "totalFunds": "\$500,000",
      "distributedFunds": "\$225,000",
      "description":
          "Supporting children's education through direct financial assistance to families",
    },
    {
      "id": 3,
      "name": "Healthcare Access Initiative",
      "status": "Paused",
      "beneficiaries": 890,
      "progress": 0.30,
      "totalFunds": "\$300,000",
      "distributedFunds": "\$90,000",
      "description": "Ensuring healthcare access for underserved communities",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  void _initializeDashboard() {
    // Initialize fraud alerts
    _fraudAlerts = [
      {
        "id": 1,
        "severity": "high",
        "title": "Duplicate Beneficiary Detected",
        "description":
            "Same identity found in multiple programs with different addresses",
        "timestamp": "2 hours ago",
      },
      {
        "id": 2,
        "severity": "medium",
        "title": "Unusual Transaction Pattern",
        "description":
            "Multiple large withdrawals from same location within 1 hour",
        "timestamp": "5 hours ago",
      },
    ];

    // Initialize pending approvals
    _pendingApprovals = [
      {
        "id": 1,
        "type": "Emergency Fund Request",
        "beneficiary": "Maria Rodriguez",
        "amount": "\$2,500",
        "timestamp": "30 minutes ago",
        "reason": "Medical emergency - hospitalization required",
      },
      {
        "id": 2,
        "type": "Program Budget Increase",
        "beneficiary": "Education Support Program",
        "amount": "\$50,000",
        "timestamp": "2 hours ago",
        "reason": "Additional beneficiaries enrolled",
      },
      {
        "id": 3,
        "type": "Beneficiary Addition",
        "beneficiary": "James Thompson",
        "amount": "\$1,200",
        "timestamp": "4 hours ago",
        "reason": "New family qualified for assistance",
      },
    ];
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Update blockchain sync status and refresh data
    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard updated successfully'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _dismissFraudAlert(int alertId) {
    setState(() {
      _fraudAlerts.removeWhere((alert) => (alert['id'] as int) == alertId);
    });
  }

  void _viewFraudAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          (alert['title'] as String?) ?? 'Fraud Alert',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Severity: ${(alert['severity'] as String?) ?? 'Unknown'}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              (alert['description'] as String?) ?? 'No description available',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Detected: ${(alert['timestamp'] as String?) ?? 'Unknown time'}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to detailed fraud investigation
            },
            child: const Text('Investigate'),
          ),
        ],
      ),
    );
  }

  void _approveRequest(Map<String, dynamic> approval) {
    setState(() {
      _pendingApprovals.removeWhere((item) => item['id'] == approval['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Approved: ${approval['type']}'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rejectRequest(Map<String, dynamic> approval) {
    setState(() {
      _pendingApprovals.removeWhere((item) => item['id'] == approval['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected: ${approval['type']}'),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildNavigationDrawer() {
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
                      iconName: 'admin_panel_settings',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Admin Dashboard',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'AidChain Management',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: [
                  _buildDrawerSection('Programs', [
                    _buildDrawerItem('Active Programs', 'folder_open', () {
                      Navigator.pushNamed(context, AppRoutes.activePrograms);
                    }),
                    _buildDrawerItem('Create Program', 'add_circle', () {
                      Navigator.pushNamed(context, AppRoutes.createProgram);
                    }),
                    _buildDrawerItem('Program Analytics', 'analytics', () {
                      Navigator.pushNamed(context, AppRoutes.programAnalytics);
                    }),
                  ]),
                  _buildDrawerSection('Beneficiaries', [
                    _buildDrawerItem('Manage Beneficiaries', 'people', () {
                      Navigator.pushNamed(context, '/beneficiary-management');
                    }),
                    _buildDrawerItem('Bulk Upload', 'upload_file', () {
                      Navigator.pushNamed(context, AppRoutes.bulkUpload);
                    }),
                    _buildDrawerItem(
                        'KYC Verification', 'verified_user', () {
                      Navigator.pushNamed(context, AppRoutes.kycVerification);
                    }),
                  ]),
                  _buildDrawerSection('Transactions', [
                    _buildDrawerItem('Transaction History', 'history', () {
                      Navigator.pushNamed(context, '/transaction-history');
                    }),
                    _buildDrawerItem(
                        'Pending Approvals', 'pending_actions', () {
                      Navigator.pushNamed(context, AppRoutes.pendingApprovals);
                    }),
                    _buildDrawerItem('Audit Trail', 'fact_check', () {
                      Navigator.pushNamed(context, AppRoutes.auditTrail);
                    }),
                  ]),
                  _buildDrawerSection('Reports', [
                    _buildDrawerItem('Financial Reports', 'assessment', () {
                      Navigator.pushNamed(context, AppRoutes.financialReports);
                    }),
                    _buildDrawerItem('Compliance Reports', 'rule', () {
                      Navigator.pushNamed(context, AppRoutes.complianceReports);
                    }),
                    _buildDrawerItem('Fraud Detection', 'security', () {
                      Navigator.pushNamed(context, AppRoutes.fraudDetection);
                    }),
                  ]),
                  _buildDrawerSection('Settings', [
                    _buildDrawerItem('System Settings', 'settings', () {
                      Navigator.pushNamed(context, AppRoutes.systemSettings);
                    }),
                    _buildDrawerItem(
                        'User Management', 'manage_accounts', () {
                      Navigator.pushNamed(context, AppRoutes.userManagement);
                    }),
                    _buildDrawerItem('Logout', 'logout', () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login-screen',
                        (route) => false,
                      );
                    }),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items,
        SizedBox(height: 1.h),
      ],
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

  Widget _buildQuickActionsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              QuickActionWidget(
                title: 'Bulk Upload',
                iconName: 'upload_file',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.bulkUpload);
                },
              ),
              QuickActionWidget(
                title: 'Approval Queue',
                iconName: 'pending_actions',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.pendingApprovals);
                },
              ),
              QuickActionWidget(
                title: 'Fraud Alerts',
                iconName: 'security',
                backgroundColor: AppTheme.errorLight.withValues(alpha: 0.1),
                iconColor: AppTheme.errorLight,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.fraudDetection);
                },
              ),
              QuickActionWidget(
                title: 'Reports',
                iconName: 'assessment',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.financialReports);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'menu',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  // Show notifications
                },
              ),
              if (_pendingApprovals.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _pendingApprovals.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/qr-code-generator');
            },
          ),
        ],
      ),
      drawer: _buildNavigationDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blockchain sync status indicator
              if (_isRefreshing)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.w),
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 4.w,
                        height: 4.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Syncing with blockchain...',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Fraud alerts
              if (_fraudAlerts.isNotEmpty)
                ...(_fraudAlerts.map((alert) => FraudAlertBannerWidget(
                      alert: alert,
                      onDismiss: () => _dismissFraudAlert(alert['id'] as int),
                      onViewDetails: () => _viewFraudAlertDetails(alert),
                    ))),

              // Dashboard metrics
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  'Overview',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Metrics cards
              ...(_dashboardMetrics.map((metric) => MetricCardWidget(
                    title: metric['title'] as String,
                    value: metric['value'] as String,
                    subtitle: metric['subtitle'] as String,
                    trend: metric['trend'] as String,
                    isPositiveTrend: metric['isPositiveTrend'] as bool,
                    onTap: () {
                      // Navigate to detailed view
                    },
                  ))),

              // Quick actions
              _buildQuickActionsSection(),

              // Pending approvals notification
              if (_pendingApprovals.isNotEmpty)
                ApprovalNotificationWidget(
                  pendingApprovals: _pendingApprovals,
                  onViewAll: () {
                    // Navigate to full approval queue
                  },
                  onApprove: _approveRequest,
                  onReject: _rejectRequest,
                ),

              // Active programs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Text(
                  'Active Programs',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Program cards
              ...(_activePrograms.map((program) => ProgramCardWidget(
                    program: program,
                    onTap: () {
                      // Navigate to program details
                    },
                    onViewDetails: () {
                      // Navigate to detailed program view
                    },
                    onGenerateReport: () {
                      // Generate program report
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Generating report for ${program['name']}...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onPauseProgram: () {
                      // Pause/resume program
                      setState(() {
                        final index = _activePrograms
                            .indexWhere((p) => p['id'] == program['id']);
                        if (index != -1) {
                          _activePrograms[index]['status'] =
                              _activePrograms[index]['status'] == 'Active'
                                  ? 'Paused'
                                  : 'Active';
                        }
                      });
                    },
                  ))),

              SizedBox(height: 10.h), // Bottom spacing for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createProgram);
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('New Program'),
      ),
    );
  }
}
