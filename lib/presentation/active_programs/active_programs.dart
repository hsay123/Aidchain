import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class ActivePrograms extends StatefulWidget {
  const ActivePrograms({Key? key}) : super(key: key);

  @override
  State<ActivePrograms> createState() => _ActiveProgramsState();
}

class _ActiveProgramsState extends State<ActivePrograms> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  final List<String> _filterOptions = ['All', 'Active', 'Paused', 'Completed', 'Draft'];
  
  final List<Map<String, dynamic>> _programs = [
    {
      "id": 1,
      "name": "Emergency Food Assistance",
      "status": "Active",
      "beneficiaries": 2450,
      "progress": 0.75,
      "totalFunds": "\$850,000",
      "distributedFunds": "\$637,500",
      "startDate": "2024-01-15",
      "endDate": "2024-12-31",
      "category": "Food Security",
      "description": "Providing emergency food assistance to families affected by natural disasters",
    },
    {
      "id": 2,
      "name": "Education Support Program",
      "status": "Active",
      "beneficiaries": 1200,
      "progress": 0.45,
      "totalFunds": "\$500,000",
      "distributedFunds": "\$225,000",
      "startDate": "2024-02-01",
      "endDate": "2024-11-30",
      "category": "Education",
      "description": "Supporting children's education through direct financial assistance to families",
    },
    {
      "id": 3,
      "name": "Healthcare Access Initiative",
      "status": "Paused",
      "beneficiaries": 890,
      "progress": 0.30,
      "totalFunds": "\$300,000",
      "distributedFunds": "\$90,000",
      "startDate": "2024-03-01",
      "endDate": "2024-10-31",
      "category": "Healthcare",
      "description": "Ensuring healthcare access for underserved communities",
    },
    {
      "id": 4,
      "name": "Small Business Support",
      "status": "Active",
      "beneficiaries": 500,
      "progress": 0.20,
      "totalFunds": "\$750,000",
      "distributedFunds": "\$150,000",
      "startDate": "2024-04-01",
      "endDate": "2025-03-31",
      "category": "Economic Development",
      "description": "Supporting small businesses through micro-loans and grants",
    },
  ];

  List<Map<String, dynamic>> get _filteredPrograms {
    List<Map<String, dynamic>> filtered = _programs;
    
    if (_selectedFilter != 'All') {
      filtered = filtered.where((program) => program['status'] == _selectedFilter).toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((program) => 
        program['name'].toLowerCase().contains(_searchController.text.toLowerCase()) ||
        program['category'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Programs'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createProgram);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(4.w),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search Bar
                TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: Colors.grey[600]!,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 2.h),
                // Filter Chips
                SingleChildScrollView(
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
                          iconName: 'folder_open',
                          color: Colors.grey[400]!,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No programs found',
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Try adjusting your search or filter',
                          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _filteredPrograms.length,
                    itemBuilder: (context, index) {
                      final program = _filteredPrograms[index];
                      return _buildProgramCard(program);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return Card(
      margin: EdgeInsets.only(bottom: 3.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.programManagement);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program['name'],
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          program['category'],
                          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(program['status']),
                ],
              ),
              
              SizedBox(height: 2.h),
              
              // Description
              Text(
                program['description'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 2.h),
              
              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      Text(
                        '${(program['progress'] * 100).toInt()}%',
                        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  LinearProgressIndicator(
                    value: program['progress'],
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 2.h),
              
              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Beneficiaries',
                      program['beneficiaries'].toString(),
                      'people',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Distributed',
                      program['distributedFunds'],
                      'account_balance_wallet',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Total Budget',
                      program['totalFunds'],
                      'account_balance',
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 2.h),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.programAnalytics);
                      },
                      icon: CustomIconWidget(
                        iconName: 'analytics',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: const Text('Analytics'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.programManagement);
                      },
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text('Manage'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = AppTheme.successLight.withValues(alpha: 0.1);
        textColor = AppTheme.successLight;
        break;
      case 'paused':
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange[700]!;
        break;
      case 'completed':
        backgroundColor = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      default:
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey[700]!;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 