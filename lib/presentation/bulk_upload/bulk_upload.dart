import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class BulkUpload extends StatefulWidget {
  const BulkUpload({Key? key}) : super(key: key);

  @override
  State<BulkUpload> createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  bool _isUploading = false;
  String? _selectedFileName;
  int _uploadProgress = 0;
  List<Map<String, dynamic>> _uploadResults = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Upload Beneficiaries'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Upload Instructions',
                          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '1. Download the template file\n'
                      '2. Fill in beneficiary information\n'
                      '3. Save as CSV or Excel file\n'
                      '4. Upload the completed file\n'
                      '5. Review and confirm uploads',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            
            // Download Template
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1: Download Template',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Downloading CSV template...')),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'file_download',
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text('Download CSV Template'),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Downloading Excel template...')),
                              );
                            },
                            icon: CustomIconWidget(
                              iconName: 'file_download',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            label: const Text('Download Excel Template'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
            
            // Upload File
            Card(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 2: Upload Completed File',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    
                    if (_selectedFileName == null)
                      InkWell(
                        onTap: _selectFile,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              CustomIconWidget(
                                iconName: 'cloud_upload',
                                color: Colors.grey[400]!,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Click to select file',
                                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Supports CSV and Excel files',
                                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'description',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _selectedFileName!,
                                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFileName = null;
                                });
                              },
                              icon: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    if (_selectedFileName != null) ...[
                      SizedBox(height: 3.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _startUpload,
                          child: _isUploading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('Processing... $_uploadProgress%'),
                                  ],
                                )
                              : const Text('Process Upload'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Upload Results
            if (_uploadResults.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Results',
                        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      
                      // Summary
                      Row(
                        children: [
                          Expanded(
                            child: _buildResultCard(
                              'Successful',
                              '${_uploadResults.where((r) => r['status'] == 'success').length}',
                              AppTheme.successLight,
                              'check_circle',
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildResultCard(
                              'Failed',
                              '${_uploadResults.where((r) => r['status'] == 'error').length}',
                              AppTheme.errorLight,
                              'error',
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: _buildResultCard(
                              'Total',
                              '${_uploadResults.length}',
                              AppTheme.lightTheme.colorScheme.primary,
                              'people',
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 3.h),
                      
                      // Detailed Results
                      ...(_uploadResults.take(5).map((result) => _buildResultItem(result))),
                      
                      if (_uploadResults.length > 5)
                        TextButton(
                          onPressed: () {
                            // Show full results
                          },
                          child: Text('View all ${_uploadResults.length} results'),
                        ),
                      
                      SizedBox(height: 2.h),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Download error report
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Downloading error report...')),
                                );
                              },
                              icon: CustomIconWidget(
                                iconName: 'file_download',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                              label: const Text('Download Report'),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _uploadResults.clear();
                                  _selectedFileName = null;
                                });
                              },
                              icon: CustomIconWidget(
                                iconName: 'refresh',
                                color: Colors.white,
                                size: 16,
                              ),
                              label: const Text('Upload Another'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value, Color color, String iconName) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    final isSuccess = result['status'] == 'success';
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isSuccess ? 'check_circle' : 'error',
            color: isSuccess ? AppTheme.successLight : AppTheme.errorLight,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['name'] ?? 'Unknown',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isSuccess)
                  Text(
                    result['error'] ?? 'Unknown error',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorLight,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectFile() {
    // Simulate file selection
    setState(() {
      _selectedFileName = 'beneficiaries_upload.csv';
    });
  }

  void _startUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _uploadProgress = i;
      });
    }

    // Simulate processing results
    setState(() {
      _isUploading = false;
      _uploadResults = [
        {'name': 'John Doe', 'status': 'success'},
        {'name': 'Jane Smith', 'status': 'success'},
        {'name': 'Bob Johnson', 'status': 'error', 'error': 'Invalid phone number'},
        {'name': 'Alice Brown', 'status': 'success'},
        {'name': 'Charlie Wilson', 'status': 'error', 'error': 'Duplicate ID'},
        {'name': 'Diana Davis', 'status': 'success'},
      ];
    });
  }
} 