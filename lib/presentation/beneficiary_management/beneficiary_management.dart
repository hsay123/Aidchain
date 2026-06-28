import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/beneficiary_card_widget.dart';
import './widgets/bulk_operations_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_filter_bar_widget.dart';
import './widgets/selection_action_bar_widget.dart';

class BeneficiaryManagement extends StatefulWidget {
  const BeneficiaryManagement({Key? key}) : super(key: key);

  @override
  State<BeneficiaryManagement> createState() => _BeneficiaryManagementState();
}

class _BeneficiaryManagementState extends State<BeneficiaryManagement> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allBeneficiaries = [];
  List<Map<String, dynamic>> _filteredBeneficiaries = [];
  Set<String> _selectedBeneficiaries = {};
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _isSelectionMode = false;
  bool _isBulkOperationLoading = false;
  String? _bulkOperationMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
    _scrollController.addListener(_onScroll);
    // Connect search controller to search functionality
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadBeneficiaries() {
    setState(() {
      _isLoading = true;
    });

    // Mock beneficiary data
    _allBeneficiaries = [
      {
        "id": "BEN001",
        "name": "Maria Rodriguez",
        "idNumber": "ID123456789",
        "profilePhoto":
            "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "active",
        "lastActivity": "2 hours ago",
        "totalFundsReceived": "\$1,250.00",
        "kycVerified": true,
        "location": "North Region",
        "enrollmentStatus": "Active",
        "registrationDate": "15/01/2025",
        "walletBalance": "\$125.50",
        "program": "Emergency Aid Program"
      },
      {
        "id": "BEN002",
        "name": "Ahmed Hassan",
        "idNumber": "ID987654321",
        "profilePhoto":
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "pending",
        "lastActivity": "1 day ago",
        "totalFundsReceived": "\$850.00",
        "kycVerified": false,
        "location": "East Region",
        "enrollmentStatus": "Pending",
        "registrationDate": "12/01/2025",
        "walletBalance": "\$0.00",
        "program": "Food Security Program"
      },
      {
        "id": "BEN003",
        "name": "Sarah Johnson",
        "idNumber": "ID456789123",
        "profilePhoto":
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "active",
        "lastActivity": "30 minutes ago",
        "totalFundsReceived": "\$2,100.00",
        "kycVerified": true,
        "location": "South Region",
        "enrollmentStatus": "Active",
        "registrationDate": "10/01/2025",
        "walletBalance": "\$350.75",
        "program": "Education Support Program"
      },
      {
        "id": "BEN004",
        "name": "David Chen",
        "idNumber": "ID789123456",
        "profilePhoto":
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "suspended",
        "lastActivity": "1 week ago",
        "totalFundsReceived": "\$500.00",
        "kycVerified": true,
        "location": "West Region",
        "enrollmentStatus": "Suspended",
        "registrationDate": "08/01/2025",
        "walletBalance": "\$50.00",
        "program": "Healthcare Aid Program"
      },
      {
        "id": "BEN005",
        "name": "Fatima Al-Zahra",
        "idNumber": "ID321654987",
        "profilePhoto":
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "active",
        "lastActivity": "4 hours ago",
        "totalFundsReceived": "\$1,800.00",
        "kycVerified": true,
        "location": "Central Region",
        "enrollmentStatus": "Active",
        "registrationDate": "05/01/2025",
        "walletBalance": "\$275.25",
        "program": "Women Empowerment Program"
      },
      {
        "id": "BEN006",
        "name": "John Smith",
        "idNumber": "ID654987321",
        "profilePhoto":
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
        "walletStatus": "inactive",
        "lastActivity": "Never",
        "totalFundsReceived": "\$0.00",
        "kycVerified": false,
        "location": "North Region",
        "enrollmentStatus": "Inactive",
        "registrationDate": "03/01/2025",
        "walletBalance": "\$0.00",
        "program": "Rural Development Program"
      },
    ];

    setState(() {
      _isLoading = false;
      _filteredBeneficiaries = List.from(_allBeneficiaries);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more beneficiaries (pagination)
      _loadMoreBeneficiaries();
    }
  }

  void _loadMoreBeneficiaries() {
    // Simulate loading more data
    // In real app, this would fetch next page from API
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    List<Map<String, dynamic>> filtered = List.from(_allBeneficiaries);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((beneficiary) {
        final name = (beneficiary['name'] as String? ?? '').toLowerCase();
        final id = (beneficiary['idNumber'] as String? ?? '').toLowerCase();
        final location =
            (beneficiary['location'] as String? ?? '').toLowerCase();
        final program = (beneficiary['program'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            id.contains(query) ||
            location.contains(query) ||
            program.contains(query);
      }).toList();
    }

    // Apply active filters
    if (_activeFilters.isNotEmpty) {
      if (_activeFilters['enrollmentStatus'] != null &&
          _activeFilters['enrollmentStatus'] != 'All') {
        filtered = filtered
            .where((b) =>
                b['enrollmentStatus'] == _activeFilters['enrollmentStatus'])
            .toList();
      }

      if (_activeFilters['kycStatus'] != null &&
          _activeFilters['kycStatus'] != 'All') {
        bool kycVerified = _activeFilters['kycStatus'] == 'Verified';
        filtered = filtered
            .where((b) => (b['kycVerified'] as bool? ?? false) == kycVerified)
            .toList();
      }

      if (_activeFilters['region'] != null &&
          _activeFilters['region'] != 'All') {
        filtered = filtered
            .where((b) => b['location'] == _activeFilters['region'])
            .toList();
      }
    }

    setState(() {
      _filteredBeneficiaries = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFiltersAndSearch();
          });
        },
      ),
    );
  }

  void _onBeneficiaryTap(Map<String, dynamic> beneficiary) {
    if (_isSelectionMode) {
      _toggleSelection(beneficiary['id']);
    } else {
      // Navigate to beneficiary detail screen
      Navigator.pushNamed(context, '/beneficiary-dashboard');
    }
  }

  void _onBeneficiaryLongPress(Map<String, dynamic> beneficiary) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedBeneficiaries.add(beneficiary['id']);
      });
    }
  }

  void _toggleSelection(String beneficiaryId) {
    setState(() {
      if (_selectedBeneficiaries.contains(beneficiaryId)) {
        _selectedBeneficiaries.remove(beneficiaryId);
        if (_selectedBeneficiaries.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedBeneficiaries.add(beneficiaryId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedBeneficiaries.clear();
      _isSelectionMode = false;
    });
  }

  // Bulk Operations with proper file picker
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _loadBeneficiaries();
  }

  // Bulk Operations
  void _onCsvUpload() async {
    setState(() {
      _isBulkOperationLoading = true;
      _bulkOperationMessage = 'Opening file picker...';
    });

    try {
      // Import file_picker package functionality
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        _bulkOperationMessage = 'Processing CSV file...';
      });

      // Simulate CSV processing
      await Future.delayed(Duration(seconds: 3));

      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('CSV file processed successfully. 25 beneficiaries added.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: Duration(seconds: 4),
        ),
      );

      // Reload beneficiaries to show new data
      _loadBeneficiaries();
    } catch (e) {
      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload CSV file. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _onMassWalletCreation() async {
    // Show confirmation dialog first
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Wallets'),
        content: Text(
            'This will create blockchain wallets for all beneficiaries without active wallets. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Create'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isBulkOperationLoading = true;
      _bulkOperationMessage = 'Creating blockchain wallets...';
    });

    try {
      await Future.delayed(Duration(seconds: 4));

      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Blockchain wallets created successfully for 15 beneficiaries.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: Duration(seconds: 4),
        ),
      );

      // Reload beneficiaries to show updated wallet status
      _loadBeneficiaries();
    } catch (e) {
      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create wallets. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _onBatchStatusUpdate() async {
    // Show status selection dialog
    final String? selectedStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check_circle,
                  color: AppTheme.lightTheme.colorScheme.secondary),
              title: Text('Active'),
              onTap: () => Navigator.pop(context, 'Active'),
            ),
            ListTile(
              leading: Icon(Icons.pause_circle,
                  color: AppTheme.lightTheme.colorScheme.tertiary),
              title: Text('Suspended'),
              onTap: () => Navigator.pop(context, 'Suspended'),
            ),
            ListTile(
              leading: Icon(Icons.pending,
                  color: AppTheme.lightTheme.colorScheme.outline),
              title: Text('Pending'),
              onTap: () => Navigator.pop(context, 'Pending'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedStatus == null) return;

    setState(() {
      _isBulkOperationLoading = true;
      _bulkOperationMessage =
          'Updating beneficiary statuses to $selectedStatus...';
    });

    try {
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Status updated to $selectedStatus for selected beneficiaries.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: Duration(seconds: 4),
        ),
      );

      // Reload beneficiaries to show updated status
      _loadBeneficiaries();
    } catch (e) {
      setState(() {
        _isBulkOperationLoading = false;
        _bulkOperationMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update statuses. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  void _onExportSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Exporting ${_selectedBeneficiaries.length} beneficiaries...')),
    );
  }

  void _onBulkEdit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Bulk editing ${_selectedBeneficiaries.length} beneficiaries...')),
    );
  }

  void _onBulkSuspend() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Suspending ${_selectedBeneficiaries.length} beneficiaries...')),
    );
  }

  void _onBulkActivate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Activating ${_selectedBeneficiaries.length} beneficiaries...')),
    );
  }

  void _onBulkDelete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Deleting ${_selectedBeneficiaries.length} beneficiaries...')),
    );
  }

  void _addBeneficiary() {
    // Navigate to add beneficiary screen
    Navigator.pushNamed(context, '/beneficiary-dashboard').then((_) {
      // Refresh the list when returning from add beneficiary screen
      _loadBeneficiaries();
    });
  }

  bool get _hasActiveFilters {
    return _activeFilters.values
        .any((value) => value != null && value != 'All');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Beneficiary Management'),
        actions: [
          if (!_isSelectionMode) ...[
            IconButton(
              onPressed: _showFilterBottomSheet,
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'tune',
                    color: Colors.white,
                    size: 24,
                  ),
                  if (_hasActiveFilters)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'export_all':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Exporting all beneficiaries to CSV...')),
                    );
                    // Simulate export process
                    await Future.delayed(Duration(seconds: 2));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Export completed successfully!'),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    );
                    break;
                  case 'import_csv':
                    _onCsvUpload();
                    break;
                  case 'sync_wallets':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Syncing wallet statuses...')),
                    );
                    await Future.delayed(Duration(seconds: 2));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wallet sync completed!'),
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    );
                    _loadBeneficiaries(); // Refresh data after sync
                    break;
                }
              },
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: Colors.white,
                size: 24,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'export_all',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text('Export All'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'import_csv',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'upload_file',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text('Import CSV'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'sync_wallets',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'sync',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text('Sync Wallets'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search and Filter Bar
              if (!_isSelectionMode)
                SearchFilterBarWidget(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  onFilterTap: _showFilterBottomSheet,
                  hasActiveFilters: _hasActiveFilters,
                ),

              // Bulk Operations Section
              if (!_isSelectionMode && _filteredBeneficiaries.isNotEmpty)
                BulkOperationsWidget(
                  onCsvUpload: _onCsvUpload,
                  onMassWalletCreation: _onMassWalletCreation,
                  onBatchStatusUpdate: _onBatchStatusUpdate,
                  isLoading: _isBulkOperationLoading,
                  loadingMessage: _bulkOperationMessage,
                ),

              // Beneficiaries List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      )
                    : _filteredBeneficiaries.isEmpty
                        ? EmptyStateWidget(
                            title: _searchQuery.isNotEmpty || _hasActiveFilters
                                ? 'No Results Found'
                                : 'No Beneficiaries Yet',
                            subtitle: _searchQuery.isNotEmpty ||
                                    _hasActiveFilters
                                ? 'Try adjusting your search or filters to find beneficiaries.'
                                : 'Start by adding beneficiaries to your aid distribution program.',
                            buttonText:
                                _searchQuery.isNotEmpty || _hasActiveFilters
                                    ? 'Clear Filters'
                                    : 'Add Beneficiary',
                            onButtonPressed:
                                _searchQuery.isNotEmpty || _hasActiveFilters
                                    ? () {
                                        setState(() {
                                          _searchQuery = '';
                                          _activeFilters.clear();
                                          _searchController.clear();
                                          _applyFiltersAndSearch();
                                        });
                                      }
                                    : _addBeneficiary,
                            iconName:
                                _searchQuery.isNotEmpty || _hasActiveFilters
                                    ? 'search_off'
                                    : 'people',
                          )
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            color: AppTheme.lightTheme.primaryColor,
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _filteredBeneficiaries.length,
                              itemBuilder: (context, index) {
                                final beneficiary =
                                    _filteredBeneficiaries[index];
                                final isSelected = _selectedBeneficiaries
                                    .contains(beneficiary['id']);

                                return BeneficiaryCardWidget(
                                  beneficiary: beneficiary,
                                  isSelected: isSelected,
                                  onTap: () => _onBeneficiaryTap(beneficiary),
                                  onSelectionChanged: _isSelectionMode
                                      ? () =>
                                          _toggleSelection(beneficiary['id'])
                                      : () =>
                                          _onBeneficiaryLongPress(beneficiary),
                                  onEdit: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Edit ${beneficiary['name']}')),
                                    );
                                  },
                                  onViewTransactions: () {
                                    Navigator.pushNamed(
                                        context, '/transaction-history');
                                  },
                                  onSuspend: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${beneficiary['name']} suspended')),
                                    );
                                  },
                                  onGenerateReport: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Generating report for ${beneficiary['name']}')),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),

          // Selection Action Bar
          if (_isSelectionMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SelectionActionBarWidget(
                selectedCount: _selectedBeneficiaries.length,
                onClearSelection: _clearSelection,
                onBulkEdit: _onBulkEdit,
                onBulkSuspend: _onBulkSuspend,
                onBulkActivate: _onBulkActivate,
                onBulkDelete: _onBulkDelete,
                onExportSelected: _onExportSelected,
              ),
            ),
        ],
      ),
      floatingActionButton:
          !_isSelectionMode && _filteredBeneficiaries.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: _addBeneficiary,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 24,
                  ),
                  label: Text('Add Beneficiary'),
                )
              : null,
    );
  }
}