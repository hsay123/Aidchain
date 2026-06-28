import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class CreateProgram extends StatefulWidget {
  const CreateProgram({Key? key}) : super(key: key);

  @override
  State<CreateProgram> createState() => _CreateProgramState();
}

class _CreateProgramState extends State<CreateProgram> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _targetBeneficiariesController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  
  String _selectedCategory = 'Food Security';
  String _selectedCurrency = 'USD';
  DateTime? _startDate;
  DateTime? _endDate;
  
  final List<String> _categories = [
    'Food Security',
    'Education',
    'Healthcare',
    'Economic Development',
    'Emergency Relief',
    'Housing',
    'Water & Sanitation',
    'Environmental',
  ];
  
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY'];
  
  final List<Map<String, dynamic>> _eligibilityCriteria = [];
  final List<Map<String, dynamic>> _requiredDocuments = [];
  
  final List<String> _steps = [
    'Basic Information',
    'Budget & Timeline',
    'Eligibility & Documents',
    'Review & Submit',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Program'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8.h),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Progress indicator
                Row(
                  children: List.generate(_steps.length, (index) {
                    final isActive = index <= _currentStep;
                    final isCompleted = index < _currentStep;
                    
                    return Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppTheme.successLight
                                  : isActive
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : Colors.grey[300],
                            ),
                            child: Center(
                              child: isCompleted
                                  ? CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: isActive ? Colors.white : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          if (index < _steps.length - 1)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: index < _currentStep
                                    ? AppTheme.successLight
                                    : Colors.grey[300],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 2.h),
                Text(
                  _steps[_currentStep],
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBasicInformationStep(),
            _buildBudgetTimelineStep(),
            _buildEligibilityDocumentsStep(),
            _buildReviewSubmitStep(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  child: const Text('Previous'),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _currentStep == _steps.length - 1 ? _submitProgram : _nextStep,
                child: Text(_currentStep == _steps.length - 1 ? 'Create Program' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInformationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Program Details',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Program Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Program Name *',
              hintText: 'Enter a descriptive program name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Program name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),
          
          // Category
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category *',
              border: OutlineInputBorder(),
            ),
            items: _categories.map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          SizedBox(height: 3.h),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description *',
              hintText: 'Describe the program objectives and activities',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
          SizedBox(height: 3.h),
          
          // Target Beneficiaries
          TextFormField(
            controller: _targetBeneficiariesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Beneficiaries *',
              hintText: 'Expected number of beneficiaries',
              border: OutlineInputBorder(),
              suffixText: 'people',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Target beneficiaries is required';
              }
              if (int.tryParse(value) == null || int.parse(value) <= 0) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetTimelineStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget & Timeline',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Budget
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _selectedCurrency,
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                  ),
                  items: _currencies.map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Budget *',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Budget is required';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          
          // Start Date
          InkWell(
            onTap: () => _selectDate(context, true),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: Colors.grey[600]!,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _startDate != null
                          ? 'Start Date: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : 'Select Start Date *',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: _startDate != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          
          // End Date
          InkWell(
            onTap: () => _selectDate(context, false),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: Colors.grey[600]!,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      _endDate != null
                          ? 'End Date: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : 'Select End Date *',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: _endDate != null ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 3.h),
          
          if (_startDate != null && _endDate != null)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Program Duration: ${_endDate!.difference(_startDate!).inDays} days',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEligibilityDocumentsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eligibility & Documents',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Eligibility Criteria
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eligibility Criteria',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addEligibilityCriteria,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text('Add'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          if (_eligibilityCriteria.isEmpty)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('No eligibility criteria added yet'),
            )
          else
            ..._eligibilityCriteria.asMap().entries.map((entry) {
              final index = entry.key;
              final criteria = entry.value;
              return Card(
                child: ListTile(
                  title: Text(criteria['title']),
                  subtitle: Text(criteria['description']),
                  trailing: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.errorLight,
                      size: 20,
                    ),
                    onPressed: () => _removeEligibilityCriteria(index),
                  ),
                ),
              );
            }).toList(),
          
          SizedBox(height: 4.h),
          
          // Required Documents
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Required Documents',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addRequiredDocument,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text('Add'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          
          if (_requiredDocuments.isEmpty)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('No required documents added yet'),
            )
          else
            ..._requiredDocuments.asMap().entries.map((entry) {
              final index = entry.key;
              final document = entry.value;
              return Card(
                child: ListTile(
                  title: Text(document['name']),
                  subtitle: Text(document['description']),
                  trailing: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.errorLight,
                      size: 20,
                    ),
                    onPressed: () => _removeRequiredDocument(index),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewSubmitStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          
          // Program Summary
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Program Summary',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildSummaryRow('Name', _nameController.text),
                  _buildSummaryRow('Category', _selectedCategory),
                  _buildSummaryRow('Description', _descriptionController.text),
                  _buildSummaryRow('Target Beneficiaries', _targetBeneficiariesController.text),
                  _buildSummaryRow('Budget', '$_selectedCurrency ${_budgetController.text}'),
                  if (_startDate != null)
                    _buildSummaryRow('Start Date', '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
                  if (_endDate != null)
                    _buildSummaryRow('End Date', '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
                  _buildSummaryRow('Eligibility Criteria', '${_eligibilityCriteria.length} items'),
                  _buildSummaryRow('Required Documents', '${_requiredDocuments.length} items'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState!.validate();
      case 1:
        if (_startDate == null || _endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select start and end dates')),
          );
          return false;
        }
        return _formKey.currentState!.validate();
      default:
        return true;
    }
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          if (_startDate != null && picked.isAfter(_startDate!)) {
            _endDate = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End date must be after start date')),
            );
          }
        }
      });
    }
  }

  void _addEligibilityCriteria() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController();
        final descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Add Eligibility Criteria'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Criteria Title'),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
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
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  setState(() {
                    _eligibilityCriteria.add({
                      'title': titleController.text,
                      'description': descriptionController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeEligibilityCriteria(int index) {
    setState(() {
      _eligibilityCriteria.removeAt(index);
    });
  }

  void _addRequiredDocument() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final descriptionController = TextEditingController();
        
        return AlertDialog(
          title: const Text('Add Required Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Document Name'),
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
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
                if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  setState(() {
                    _requiredDocuments.add({
                      'name': nameController.text,
                      'description': descriptionController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeRequiredDocument(int index) {
    setState(() {
      _requiredDocuments.removeAt(index);
    });
  }

  void _submitProgram() {
    if (_validateCurrentStep()) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              const Text('Success'),
            ],
          ),
          content: const Text('Program created successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _targetBeneficiariesController.dispose();
    _durationController.dispose();
    _pageController.dispose();
    super.dispose();
  }
} 