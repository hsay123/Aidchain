import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/app_export.dart';
import './widgets/audit_metric_card_widget.dart';
import './widgets/compliance_status_widget.dart';
import './widgets/recent_audit_item_widget.dart';
import './widgets/audit_chart_widget.dart';
import './widgets/risk_alert_widget.dart';

class AuditorDashboard extends StatefulWidget {
  const AuditorDashboard({Key? key}) : super(key: key);

  @override
  State<AuditorDashboard> createState() => _AuditorDashboardState();
}

class _AuditorDashboardState extends State<AuditorDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRefreshing = false;
  int _selectedTimeRange = 0; // 0: Week, 1: Month, 2: Quarter
  
  // Mock audit data
  final List<Map<String, dynamic>> _auditMetrics = [
    {
      "title": "Total Audits",
      "value": "156",
      "change": "+12",
      "trend": "up",
      "icon": "assessment",
      "color": "primary",
    },
    {
      "title": "Compliance Score",
      "value": "94.5%",
      "change": "+2.1%",
      "trend": "up",
      "icon": "verified",
      "color": "success",
    },
    {
      "title": "Risk Incidents",
      "value": "3",
      "change": "-2",
      "trend": "down",
      "icon": "warning",
      "color": "warning",
    },
    {
      "title": "Active Reviews",
      "value": "23",
      "change": "+5",
      "trend": "up",
      "icon": "rate_review",
      "color": "info",
    },
  ];

  final List<Map<String, dynamic>> _recentAudits = [
    {
      "id": "AUD-2025-001",
      "program": "Emergency Food Assistance",
      "type": "Financial Audit",
      "status": "completed",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "auditor": "Jane Smith",
      "score": 96.5,
      "findings": 2,
    },
    {
      "id": "AUD-2025-002",
      "program": "Education Support Program",
      "type": "Compliance Review",
      "status": "in_progress",
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "auditor": "John Doe",
      "score": null,
      "findings": 1,
    },
    {
      "id": "AUD-2025-003",
      "program": "Healthcare Access Initiative",
      "type": "Risk Assessment",
      "status": "pending",
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "auditor": "Maria Garcia",
      "score": null,
      "findings": 0,
    },
  ];

  final List<Map<String, dynamic>> _riskAlerts = [
    {
      "id": "RISK-001",
      "title": "Unusual Transaction Pattern",
      "description": "Multiple large withdrawals detected in Region A",
      "severity": "high",
      "program": "Emergency Food Assistance",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": "RISK-002",
      "title": "KYC Documentation Gap",
      "description": "15 beneficiaries missing updated documentation",
      "severity": "medium",
      "program": "Education Support Program",
      "date": DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  @override
  void initState() {
    super.initState();
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

  void _onTimeRangeChanged(int index) {
    setState(() {
      _selectedTimeRange = index;
    });
  }

  void _viewAuditDetails(Map<String, dynamic> audit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildAuditDetailsSheet(audit),
    );
  }

  Widget _buildAuditDetailsSheet(Map<String, dynamic> audit) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            'Audit Details',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Audit Information
          _buildDetailRow('Audit ID', audit['id']),
          _buildDetailRow('Program', audit['program']),
          _buildDetailRow('Type', audit['type']),
          _buildDetailRow('Status', audit['status']),
          _buildDetailRow('Auditor', audit['auditor']),
          if (audit['score'] != null)
            _buildDetailRow('Score', '${audit['score']}%'),
          _buildDetailRow('Findings', '${audit['findings']}'),

          SizedBox(height: 3.h),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Generating report for ${audit['id']}')),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: const Text('Generate Report'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/transaction-history');
                  },
                  icon: CustomIconWidget(
                    iconName: 'history',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text('View Transactions'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
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
                      iconName: 'fact_check',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Auditor Dashboard',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Compliance & Risk Management',
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
                  _buildDrawerItem('Audit Reports', 'assessment', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening audit reports...')),
                    );
                  }),
                  _buildDrawerItem('Compliance Dashboard', 'verified', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening compliance dashboard...')),
                    );
                  }),
                  _buildDrawerItem('Risk Management', 'security', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening risk management...')),
                    );
                  }),
                  _buildDrawerItem('Transaction History', 'history', () {
                    Navigator.pushNamed(context, '/transaction-history');
                  }),
                  _buildDrawerItem('Settings', 'settings', () {
                    Navigator.pushNamed(context, '/settings');
                  }),
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
        title: const Text('Auditor Dashboard'),
        actions: [
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
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening search...')),
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
              // Refresh indicator
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
                        'Updating audit data...',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 2.h),

              // Risk Alerts
              if (_riskAlerts.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Risk Alerts',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                ..._riskAlerts.map((alert) => RiskAlertWidget(
                      alert: alert,
                      onDismiss: () {
                        setState(() {
                          _riskAlerts.remove(alert);
                        });
                      },
                      onViewDetails: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Investigating ${alert['id']}')),
                        );
                      },
                    )),
                SizedBox(height: 2.h),
              ],

              // Metrics Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Audit Metrics',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),

              // Metrics Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.w,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _auditMetrics.length,
                  itemBuilder: (context, index) {
                    final metric = _auditMetrics[index];
                    return AuditMetricCardWidget(
                      title: metric['title'],
                      value: metric['value'],
                      change: metric['change'],
                      trend: metric['trend'],
                      icon: metric['icon'],
                      color: metric['color'],
                    );
                  },
                ),
              ),

              SizedBox(height: 3.h),

              // Compliance Status
              ComplianceStatusWidget(
                overallScore: 94.5,
                categories: [
                  {'name': 'Financial', 'score': 96.2},
                  {'name': 'Operational', 'score': 93.8},
                  {'name': 'Regulatory', 'score': 92.5},
                ],
              ),

              SizedBox(height: 3.h),

              // Audit Chart
              AuditChartWidget(
                selectedTimeRange: _selectedTimeRange,
                onTimeRangeChanged: _onTimeRangeChanged,
              ),

              SizedBox(height: 3.h),

              // Recent Audits
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Recent Audits',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 1.h),

              ..._recentAudits.map((audit) => RecentAuditItemWidget(
                    audit: audit,
                    onTap: () => _viewAuditDetails(audit),
                  )),

              SizedBox(height: 10.h), // Bottom padding
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Starting new audit...')),
          );
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('New Audit'),
      ),
    );
  }
}
