import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/program_card_widget.dart';
import './widgets/program_stats_widget.dart';
import './widgets/create_program_dialog.dart';
import './widgets/program_filter_widget.dart';

class ProgramManagement extends StatefulWidget {
  const ProgramManagement({Key? key}) : super(key: key);

  @override
  State<ProgramManagement> createState() => _ProgramManagementState();
}

class _ProgramManagementState extends State<ProgramManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;

  // Mock program data
  List<Map<String, dynamic>> _allPrograms = [
    {
      "id": "PROG-001",
      "name": "Emergency Food Assistance",
      "description": "Providing emergency food assistance to families affected by natural disasters and economic hardship",
      "status": "Active",
      "type": "Emergency Aid",
      "startDate": DateTime(2024, 1, 15),
      "endDate": DateTime(2025, 12, 31),
      "totalBudget": 850000.0,
      "distributedAmount": 637500.0,
      "beneficiaries": 2450,
      "targetBeneficiaries": 3000,
      "region": "National",
      "manager": "Sarah Johnson",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 2)),
      "priority": "High",
      "fundingSource": "World Food Programme",
    },
    {
      "id": "PROG-002",
      "name": "Education Support Program",
      "description": "Supporting children's education through direct financial assistance to families",
      "status": "Active",
      "type": "Education",
      "startDate": DateTime(2024, 3, 1),
      "endDate": DateTime(2025, 6, 30),
      "totalBudget": 500000.0,
      "distributedAmount": 225000.0,
      "beneficiaries": 1200,
      "targetBeneficiaries": 2000,
      "region": "Rural Areas",
      "manager": "Ahmed Hassan",
      "lastUpdated": DateTime.now().subtract(const Duration(days: 1)),
      "priority": "Medium",
      "fundingSource": "UNICEF",
    },
    {
      "id": "PROG-003",
      "name": "Healthcare Access Initiative",
      "description": "Ensuring healthcare access for underserved communities through medical vouchers",
      "status": "Paused",
      "type": "Healthcare",
      "startDate": DateTime(2024, 2, 1),
      "endDate": DateTime(2025, 8, 31),
      "totalBudget": 300000.0,
      "distributedAmount": 90000.0,
      "beneficiaries": 890,
      "targetBeneficiaries": 1500,
      "region": "Urban Slums",
      "manager": "Maria Santos",
      "lastUpdated": DateTime.now().subtract(const Duration(days: 5)),
      "priority": "High",
      "fundingSource": "WHO",
    },
    {
      "id": "PROG-004",
      "name": "Women Empowerment Fund",
      "description": "Providing microfinance and business support to women entrepreneurs",
      "status": "Planning",
      "type": "Economic Development",
      "startDate": DateTime(2025, 4, 1),
      "endDate": DateTime(2026, 3, 31),
      "totalBudget": 750000.0,
      "distributedAmount": 0.0,
      "beneficiaries": 0,
      "targetBeneficiaries": 2500,
      "region": "Rural Areas",
      "manager": "Fatima Al-Zahra",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 12)),
      "priority": "Medium",
      "fundingSource": "UN Women",
    },
    {
      "id": "PROG-005",
      "name": "Disaster Relief Emergency Fund",
      "description": "Rapid response fund for natural disaster victims",
      "status": "Completed",
      "type": "Emergency Aid",
      "startDate": DateTime(2023, 6, 1),
      "endDate": DateTime(2024, 5, 31),
      "totalBudget": 1200000.0,
      "distributedAmount": 1200000.0,
      "beneficiaries": 5000,
      "targetBeneficiaries": 5000,
      "region": "Coastal Region",
      "manager": "David Chen",
      "lastUpdated": DateTime.now().subtract(const Duration(days: 30)),
      "priority": "High",
      "fundingSource": "Red Cross",
    },
  ];

  List<Map<String, dynamic>> get _filteredPrograms {
    var filtered = _allPrograms.where((program) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        if (!program['name'].toString().toLowerCase().contains(searchLower) &&
            !program['description'].toString().toLowerCase().contains(searchLower) &&
            !program['id'].toString().toLowerCase().contains(searchLower)) {
          return false;
        }
      }

      // Status filter
      if (_selectedFilter != 'All' && program['status'] != _selectedFilter) {
        return false;
      }

      return true;
    }).toList();

    // Sort by priority and last updated
    filtered.sort((a, b) {
      final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      final aPriority = priorityOrder[a['priority']] ?? 3;
      final bPriority = priorityOrder[b['priority']] ?? 3;
      
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      
      return (b['lastUpdated'] as DateTime).compareTo(a['lastUpdated'] as DateTime);
    });

    return filtered;
  }

  Map<String, int> get _programStats {
    return {
      'total': _allPrograms.length,
      'active': _allPrograms.where((p) => p['status'] == 'Active').length,
      'paused': _allPrograms.where((p) => p['status'] == 'Paused').length,
      'planning': _allPrograms.where((p) => p['status'] == 'Planning').length,
      'completed': _allPrograms.where((p) => p['status'] == 'Completed').length,
    };
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPrograms() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Programs updated successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    }
  }

  void _showCreateProgramDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateProgramDialog(
        onProgramCreated: (program) {
          setState(() {
            _allPrograms.insert(0, program);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Program "${program['name']}" created successfully'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }

  void _editProgram(Map<String, dynamic> program) {
    showDialog(
      context: context,
      builder: (context) => CreateProgramDialog(
        program: program,
        onProgramCreated: (updatedProgram) {
          setState(() {
            final index = _allPrograms.indexWhere((p) => p['id'] == program['id']);
            if (index != -1) {
              _allPrograms[index] = updatedProgram;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Program "${updatedProgram['name']}" updated successfully'),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            ),
          );
        },
      ),
    );
  }

  void _toggleProgramStatus(Map<String, dynamic> program) {
    setState(() {
      if (program['status'] == 'Active') {
        program['status'] = 'Paused';
      } else if (program['status'] == 'Paused') {
        program['status'] = 'Active';
      }
      program['lastUpdated'] = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Program status changed to ${program['status']}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _deleteProgram(Map<String, dynamic> program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Program'),
        content: Text('Are you sure you want to delete "${program['name']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allPrograms.remove(program);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Program "${program['name']}" deleted'),
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
        title: const Text('Program Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Programs', icon: Icon(Icons.folder)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          indicatorColor: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: _refreshPrograms,
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
                    iconName: 'refresh',
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Programs Tab
          _buildProgramsTab(),
          
          // Analytics Tab
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateProgramDialog,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
        label: const Text('New Program'),
      ),
    );
  }

  Widget _buildProgramsTab() {
    return Column(
      children: [
        // Search and Filter
        Container(
          padding: EdgeInsets.all(4.w),
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search programs...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
              
              SizedBox(height: 2.h),
              
              // Filter Chips
              ProgramFilterWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                programStats: _programStats,
              ),
            ],
          ),
        ),

        // Programs List
        Expanded(
          child: _filteredPrograms.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: _searchQuery.isNotEmpty || _selectedFilter != 'All' 
                            ? 'search_off' 
                            : 'folder_open',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 64,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _searchQuery.isNotEmpty || _selectedFilter != 'All'
                            ? 'No programs found'
                            : 'No programs created yet',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _searchQuery.isNotEmpty || _selectedFilter != 'All'
                            ? 'Try adjusting your search or filters'
                            : 'Create your first aid distribution program',
                        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_searchQuery.isEmpty && _selectedFilter == 'All') ...[
                        SizedBox(height: 3.h),
                        ElevatedButton.icon(
                          onPressed: _showCreateProgramDialog,
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: Colors.white,
                            size: 20,
                          ),
                          label: const Text('Create Program'),
                        ),
                      ],
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshPrograms,
                  child: ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _filteredPrograms.length,
                    itemBuilder: (context, index) {
                      final program = _filteredPrograms[index];
                      return ProgramCardWidget(
                        program: program,
                        onEdit: () => _editProgram(program),
                        onToggleStatus: () => _toggleProgramStatus(program),
                        onDelete: () => _deleteProgram(program),
                        onViewDetails: () {
                          Navigator.pushNamed(context, '/transaction-history');
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Program Statistics
          ProgramStatsWidget(
            programs: _allPrograms,
            stats: _programStats,
          ),

          SizedBox(height: 3.h),

          // Coming Soon Placeholder
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Advanced Analytics',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Detailed program analytics, performance metrics, and impact reports coming soon.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
