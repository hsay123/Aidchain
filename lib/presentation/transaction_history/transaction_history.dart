import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/export_bottom_sheet_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/monthly_group_header_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/transaction_card_widget.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  List<String> _activeFilters = [];
  Map<String, bool> _expandedMonths = {};
  bool _isLoading = false;
  bool _isOffline = false;

  // Mock transaction data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      "id": "TXN001",
      "amount": 500.00,
      "type": "incoming",
      "category": "aid_disbursement",
      "description": "Emergency Aid Distribution",
      "source": "World Food Programme",
      "destination": "Beneficiary Wallet",
      "status": "completed",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "hash": "0x1a2b3c4d5e6f7890abcdef1234567890",
      "blockNumber": 12345678,
      "gasUsed": "21000",
      "confirmations": 15,
    },
    {
      "id": "TXN002",
      "amount": 150.00,
      "type": "outgoing",
      "category": "cash_out",
      "description": "Cash Withdrawal at Agent",
      "source": "Beneficiary Wallet",
      "destination": "Agent Network #A001",
      "status": "completed",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "hash": "0x2b3c4d5e6f7890abcdef1234567890ab",
      "blockNumber": 12345650,
      "gasUsed": "25000",
      "confirmations": 25,
    },
    {
      "id": "TXN003",
      "amount": 75.50,
      "type": "outgoing",
      "category": "payment",
      "description": "Medical Supplies Purchase",
      "source": "Beneficiary Wallet",
      "destination": "Healthcare Provider",
      "status": "pending",
      "date": DateTime.now().subtract(const Duration(hours: 6)),
      "hash": "0x3c4d5e6f7890abcdef1234567890abcd",
      "blockNumber": null,
      "gasUsed": null,
      "confirmations": 0,
    },
    {
      "id": "TXN004",
      "amount": 200.00,
      "type": "incoming",
      "category": "transfer",
      "description": "Family Support Transfer",
      "source": "Donor Organization",
      "destination": "Beneficiary Wallet",
      "status": "failed",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "hash": "0x4d5e6f7890abcdef1234567890abcdef",
      "blockNumber": null,
      "gasUsed": null,
      "confirmations": 0,
    },
    {
      "id": "TXN005",
      "amount": 300.00,
      "type": "incoming",
      "category": "aid_disbursement",
      "description": "Monthly Food Allowance",
      "source": "UNICEF",
      "destination": "Beneficiary Wallet",
      "status": "completed",
      "date": DateTime.now().subtract(const Duration(days: 15)),
      "hash": "0x5e6f7890abcdef1234567890abcdef12",
      "blockNumber": 12345600,
      "gasUsed": "22000",
      "confirmations": 50,
    },
    {
      "id": "TXN006",
      "amount": 100.00,
      "type": "outgoing",
      "category": "withdrawal",
      "description": "Education Fund Withdrawal",
      "source": "Beneficiary Wallet",
      "destination": "School Payment System",
      "status": "completed",
      "date": DateTime.now().subtract(const Duration(days: 30)),
      "hash": "0x6f7890abcdef1234567890abcdef1234",
      "blockNumber": 12345550,
      "gasUsed": "23000",
      "confirmations": 100,
    },
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];
  Map<String, List<Map<String, dynamic>>> _groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _filteredTransactions = List.from(_allTransactions);
    _groupTransactionsByMonth();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreTransactions();
    }
  }

  void _loadMoreTransactions() {
    if (!_isLoading) {
      setState(() => _isLoading = true);

      // Simulate loading more transactions
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  void _groupTransactionsByMonth() {
    _groupedTransactions.clear();

    for (var transaction in _filteredTransactions) {
      final DateTime date = transaction['date'] as DateTime;
      final String monthYear = '${_getMonthName(date.month)} ${date.year}';

      if (!_groupedTransactions.containsKey(monthYear)) {
        _groupedTransactions[monthYear] = [];
        _expandedMonths[monthYear] = true; // Default to expanded
      }
      _groupedTransactions[monthYear]!.add(transaction);
    }

    // Sort transactions within each month by date (newest first)
    _groupedTransactions.forEach((key, value) {
      value.sort(
          (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFilterToggle(String filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
      _applyFilters();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _applyFilters();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _applyFilters();
    });
  }

  void _applyFilters() {
    _filteredTransactions = _allTransactions.where((transaction) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch =
            (transaction['id'] as String).toLowerCase().contains(searchLower) ||
                (transaction['description'] as String)
                    .toLowerCase()
                    .contains(searchLower) ||
                transaction['amount'].toString().contains(searchLower);

        if (!matchesSearch) return false;
      }

      // Date filters
      final DateTime transactionDate = transaction['date'] as DateTime;
      final DateTime now = DateTime.now();

      if (_activeFilters.contains('today')) {
        if (!_isSameDay(transactionDate, now)) return false;
      }

      if (_activeFilters.contains('week')) {
        final DateTime weekStart =
            now.subtract(Duration(days: now.weekday - 1));
        if (transactionDate.isBefore(weekStart)) return false;
      }

      if (_activeFilters.contains('month')) {
        if (transactionDate.month != now.month ||
            transactionDate.year != now.year) {
          return false;
        }
      }

      // Type filters
      if (_activeFilters.contains('incoming') &&
          transaction['type'] != 'incoming') {
        return false;
      }

      if (_activeFilters.contains('outgoing') &&
          transaction['type'] != 'outgoing') {
        return false;
      }

      // Status filters
      if (_activeFilters.contains('completed') &&
          transaction['status'] != 'completed') {
        return false;
      }

      if (_activeFilters.contains('pending') &&
          transaction['status'] != 'pending') {
        return false;
      }

      if (_activeFilters.contains('failed') &&
          transaction['status'] != 'failed') {
        return false;
      }

      return true;
    }).toList();

    _groupTransactionsByMonth();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _toggleMonthExpansion(String monthYear) {
    setState(() {
      _expandedMonths[monthYear] = !(_expandedMonths[monthYear] ?? false);
    });
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildTransactionDetailsSheet(transaction),
    );
  }

  Widget _buildTransactionDetailsSheet(Map<String, dynamic> transaction) {
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt_long',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Transaction Details',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Transaction Details
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDetailRow('Transaction ID', transaction['id']),
                  _buildDetailRow('Amount',
                      '\$${(transaction['amount'] as num).toStringAsFixed(2)}'),
                  _buildDetailRow(
                      'Type',
                      transaction['type'] == 'incoming'
                          ? 'Incoming'
                          : 'Outgoing'),
                  _buildDetailRow(
                      'Category', _formatCategory(transaction['category'])),
                  _buildDetailRow('Description', transaction['description']),
                  _buildDetailRow('Source', transaction['source']),
                  _buildDetailRow('Destination', transaction['destination']),
                  _buildDetailRow('Status', transaction['status']),
                  _buildDetailRow('Date', _formatDateTime(transaction['date'])),
                  if (transaction['hash'] != null) ...[
                    _buildDetailRow('Transaction Hash', transaction['hash'],
                        isHash: true),
                    if (transaction['blockNumber'] != null)
                      _buildDetailRow('Block Number',
                          transaction['blockNumber'].toString()),
                    if (transaction['gasUsed'] != null)
                      _buildDetailRow('Gas Used', transaction['gasUsed']),
                    _buildDetailRow('Confirmations',
                        transaction['confirmations'].toString()),
                  ],
                ],
              ),
            ),
          ),

          // Action Buttons
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareTransaction(transaction),
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: const Text('Share'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _verifyOnBlockchain(transaction),
                  icon: CustomIconWidget(
                    iconName: 'verified',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text('Verify'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHash = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
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
              isHash
                  ? '${value.substring(0, 10)}...${value.substring(value.length - 8)}'
                  : value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: isHash ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _shareTransaction(Map<String, dynamic> transaction) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction details shared successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _verifyOnBlockchain(Map<String, dynamic> transaction) {
    Navigator.pop(context);
    if (transaction['hash'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening blockchain explorer...'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction not yet confirmed on blockchain'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  void _showExportSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ExportBottomSheetWidget(
        onExport: _exportTransactions,
      ),
    );
  }

  void _exportTransactions(
      DateTime startDate, DateTime endDate, String format) {
    final filteredForExport = _allTransactions.where((transaction) {
      final DateTime transactionDate = transaction['date'] as DateTime;
      return transactionDate
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Exporting ${filteredForExport.length} transactions as $format...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  Future<void> _refreshTransactions() async {
    setState(() => _isLoading = true);

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showExportSheet,
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            searchQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          // Filter Chips
          FilterChipsWidget(
            activeFilters: _activeFilters,
            onFilterToggle: _onFilterToggle,
            onClearAll: _clearAllFilters,
          ),

          // Offline Indicator
          if (_isOffline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'cloud_off',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Showing cached transactions - offline mode',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),

          // Transaction List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? EmptyStateWidget(
                    title: _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                        ? 'No transactions found'
                        : 'No transactions yet',
                    subtitle: _searchQuery.isNotEmpty ||
                            _activeFilters.isNotEmpty
                        ? 'Try adjusting your search or filters'
                        : 'Your transaction history will appear here once you start making transactions',
                    actionText:
                        _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                            ? 'Clear Filters'
                            : 'Refresh',
                    onAction:
                        _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                            ? () {
                                setState(() {
                                  _searchQuery = '';
                                  _activeFilters.clear();
                                  _applyFilters();
                                });
                              }
                            : _refreshTransactions,
                  )
                : RefreshIndicator(
                    onRefresh: _refreshTransactions,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          _groupedTransactions.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _groupedTransactions.length) {
                          return Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          );
                        }

                        final String monthYear =
                            _groupedTransactions.keys.elementAt(index);
                        final List<Map<String, dynamic>> monthTransactions =
                            _groupedTransactions[monthYear]!;
                        final bool isExpanded =
                            _expandedMonths[monthYear] ?? false;

                        final double totalAmount =
                            monthTransactions.fold(0.0, (sum, transaction) {
                          final double amount =
                              (transaction['amount'] as num).toDouble();
                          return sum +
                              (transaction['type'] == 'incoming'
                                  ? amount
                                  : -amount);
                        });

                        return Column(
                          children: [
                            MonthlyGroupHeaderWidget(
                              monthYear: monthYear,
                              transactionCount: monthTransactions.length,
                              totalAmount: totalAmount,
                              isExpanded: isExpanded,
                              onToggle: () => _toggleMonthExpansion(monthYear),
                            ),
                            if (isExpanded)
                              ...monthTransactions
                                  .map((transaction) => TransactionCardWidget(
                                        transaction: transaction,
                                        onTap: () => _showTransactionDetails(
                                            transaction),
                                        onViewReceipt: () =>
                                            _shareTransaction(transaction),
                                        onVerifyBlockchain: () =>
                                            _verifyOnBlockchain(transaction),
                                        onShare: () =>
                                            _shareTransaction(transaction),
                                      ))
                                  .toList(),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
