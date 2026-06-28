import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class PendingApprovals extends StatefulWidget {
  const PendingApprovals({Key? key}) : super(key: key);

  @override
  State<PendingApprovals> createState() => _PendingApprovalsState();
}

class _PendingApprovalsState extends State<PendingApprovals> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Emergency Fund', 'Program Budget', 'Beneficiary Addition', 'Document Verification'];
  
  List<Map<String, dynamic>> _pendingApprovals = [
    {
      "id": 1,
      "type": "Emergency Fund Request",
      "beneficiary": "Maria Rodriguez",
      "amount": "\$2,500",
      "timestamp": "30 minutes ago",
      "reason": "Medical emergency - hospitalization required",
      "priority": "High",
      "status": "Pending",
      "submittedBy": "Agent John Smith",
      "documents": ["medical_certificate.pdf", "hospital_bill.pdf"],
    },
    {
      "id": 2,
      "type": "Program Budget Increase",
      "beneficiary": "Education Support Program",
      "amount": "\$50,000",
      "timestamp": "2 hours ago",
      "reason": "Additional beneficiaries enrolled beyond initial capacity",
      "priority": "Medium",
      "status": "Pending",
      "submittedBy": "Program Manager Alice Brown",
      "documents": ["enrollment_report.xlsx", "budget_analysis.pdf"],
    },
    {
      "id": 3,
      "type": "Beneficiary Addition",
      "beneficiary": "James Thompson",
      "amount": "\$1,200",
      "timestamp": "4 hours ago",
      "reason": "New family qualified for assistance after verification",
      "priority": "Low",
      "status": "Pending",
      "submittedBy": "Field Officer Sarah Wilson",
      "documents": ["kyc_verification.pdf", "income_certificate.pdf"],
    },
    {
      "id": 4,
      "type": "Document Verification",
      "beneficiary": "Linda Garcia",
      "amount": "\$800",
      "timestamp": "6 hours ago",
      "reason": "Updated documentation submitted for re-verification",
      "priority": "Medium",
      "status": "Pending",
      "submittedBy": "Agent Mike Johnson",
      "documents": ["updated_id.pdf", "address_proof.pdf"],
    },
  ];

  List<Map<String, dynamic>> get _filteredApprovals {
    if (_selectedFilter == 'All') return _pendingApprovals;
    return _pendingApprovals.where((approval) => 
      approval['type'].toString().contains(_selectedFilter)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approvals'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {},
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
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: EdgeInsets.all(4.w),
            color: Colors.grey[50],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) => Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: AppTheme.lightTheme.colorScheme.primaryContainer,
                    checkmarkColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                )).toList(),
              ),
            ),
          ),
          
          // Approvals List
          Expanded(
            child: _filteredApprovals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'pending_actions',
                          color: Colors.grey[400]!,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No pending approvals',
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _filteredApprovals.length,
                    itemBuilder: (context, index) {
                      final approval = _filteredApprovals[index];
                      return _buildApprovalCard(approval);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _bulkApprove();
        },
        icon: CustomIconWidget(
          iconName: 'done_all',
          color: Colors.white,
          size: 20,
        ),
        label: const Text('Bulk Approve'),
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> approval) {
    return Card(
      margin: EdgeInsets.only(bottom: 3.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        approval['type'],
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        approval['beneficiary'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildPriorityChip(approval['priority']),
                    SizedBox(height: 1.h),
                    Text(
                      approval['amount'],
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 2.h),
            
            // Reason
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                approval['reason'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            
            SizedBox(height: 2.h),
            
            // Details Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Submitted by:',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        approval['submittedBy'],
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Submitted:',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      approval['timestamp'],
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Documents
            if (approval['documents'] != null && approval['documents'].isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(
                'Attached Documents:',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: (approval['documents'] as List).map((doc) => 
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'description',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          doc,
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                ).toList(),
              ),
            ],
            
            SizedBox(height: 3.h),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewDetails(approval),
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    label: const Text('View Details'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectApproval(approval),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.errorLight,
                      size: 16,
                    ),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorLight,
                      side: BorderSide(color: AppTheme.errorLight),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveRequest(approval),
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = AppTheme.errorLight;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey[600]!;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> approval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approval['type']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Beneficiary: ${approval['beneficiary']}'),
            Text('Amount: ${approval['amount']}'),
            Text('Reason: ${approval['reason']}'),
            Text('Submitted by: ${approval['submittedBy']}'),
            Text('Time: ${approval['timestamp']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
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

  void _rejectApproval(Map<String, dynamic> approval) {
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

  void _bulkApprove() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Approve'),
        content: Text('Are you sure you want to approve all ${_filteredApprovals.length} pending requests?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _pendingApprovals.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All requests approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Approve All'),
          ),
        ],
      ),
    );
  }
} 