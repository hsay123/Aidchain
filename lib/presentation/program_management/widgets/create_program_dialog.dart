import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateProgramDialog extends StatefulWidget {
  final Map<String, dynamic>? program;
  final Function(Map<String, dynamic>) onProgramCreated;

  const CreateProgramDialog({
    Key? key,
    this.program,
    required this.onProgramCreated,
  }) : super(key: key);

  @override
  State<CreateProgramDialog> createState() => _CreateProgramDialogState();
}

class _CreateProgramDialogState extends State<CreateProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _targetBeneficiariesController = TextEditingController();
  final _managerController = TextEditingController();
  final _fundingSourceController = TextEditingController();

  String _selectedType = 'Emergency Aid';
  String _selectedStatus = 'Planning';
  String _selectedPriority = 'Medium';
  String _selectedRegion = 'National';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  final List<String> _programTypes = [
    'Emergency Aid',
    'Education',
    'Healthcare',
    'Economic Development',
    'Infrastructure',
    'Food Security',
  ];

  final List<String> _statusOptions = [
    'Planning',
    'Active',
    'Paused',
  ];

  final List<String> _priorityOptions = [
    'Low',
    'Medium',
    'High',
  ];

  final List<String> _regionOptions = [
    'National',
    'Regional',
    'Urban Areas',
    'Rural Areas',
    'Coastal Region',
    'Mountain Region',
  ];

  bool get _isEditing => widget.program != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final program = widget.program!;
    _nameController.text = program['name'] ?? '';
    _descriptionController.text = program['description'] ?? '';
    _budgetController.text = (program['totalBudget'] as double).toStringAsFixed(0);
    _targetBeneficiariesController.text = (program['targetBeneficiaries'] as int).toString();
    _managerController.text = program['manager'] ?? '';
    _fundingSourceController.text = program['fundingSource'] ?? '';
    _selectedType = program['type'] ?? 'Emergency Aid';
    _selectedStatus = program['status'] ?? 'Planning';
    _selectedPriority = program['priority'] ?? 'Medium';
    _selectedRegion = program['region'] ?? 'National';
    _startDate = program['startDate'] ?? DateTime.now();
    _endDate = program['endDate'] ?? DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _targetBeneficiariesController.dispose();
    _managerController.dispose();
    _fundingSourceController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Ensure end date is after start date
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveProgram() {
    if (_formKey.currentState!.validate()) {
      final program = {
        'id': _isEditing 
            ? widget.program!['id'] 
            : 'PROG-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'type': _selectedType,
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'region': _selectedRegion,
        'startDate': _startDate,
        'endDate': _endDate,
        'totalBudget': double.parse(_budgetController.text),
        'distributedAmount': _isEditing 
            ? widget.program!['distributedAmount'] 
            : 0.0,
        'targetBeneficiaries': int.parse(_targetBeneficiariesController.text),
        'beneficiaries': _isEditing 
            ? widget.program!['beneficiaries'] 
            : 0,
        'manager': _managerController.text.trim(),
        'fundingSource': _fundingSourceController.text.trim(),
        'lastUpdated': DateTime.now(),
      };

      widget.onProgramCreated(program);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 90.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: _isEditing ? 'edit' : 'add_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  _isEditing ? 'Edit Program' : 'Create New Program',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Program Name
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Program Name *',
                          hintText: 'Enter program name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Program name is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText: 'Describe the program objectives and scope',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Type and Status Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Program Type *',
                              ),
                              items: _programTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status *',
                              ),
                              items: _statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Priority and Region Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: 'Priority *',
                              ),
                              items: _priorityOptions.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPriority = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedRegion,
                              decoration: const InputDecoration(
                                labelText: 'Region *',
                              ),
                              items: _regionOptions.map((region) {
                                return DropdownMenuItem(
                                  value: region,
                                  child: Text(region),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRegion = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Budget and Target Beneficiaries Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Total Budget *',
                                hintText: '0',
                                prefixText: '\$ ',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Budget is required';
                                }
                                final budget = double.tryParse(value);
                                if (budget == null || budget <= 0) {
                                  return 'Enter valid budget';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: TextFormField(
                              controller: _targetBeneficiariesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Target Beneficiaries *',
                                hintText: '0',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Target is required';
                                }
                                final target = int.tryParse(value);
                                if (target == null || target <= 0) {
                                  return 'Enter valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Dates Row
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Start Date *',
                                ),
                                child: Text(
                                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'End Date *',
                                ),
                                child: Text(
                                  '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Manager
                      TextFormField(
                        controller: _managerController,
                        decoration: const InputDecoration(
                          labelText: 'Program Manager *',
                          hintText: 'Enter manager name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Manager name is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Funding Source
                      TextFormField(
                        controller: _fundingSourceController,
                        decoration: const InputDecoration(
                          labelText: 'Funding Source *',
                          hintText: 'Enter funding organization',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Funding source is required';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProgram,
                    child: Text(_isEditing ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
