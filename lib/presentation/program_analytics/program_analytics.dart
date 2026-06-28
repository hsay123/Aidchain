import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/app_export.dart';

class ProgramAnalytics extends StatefulWidget {
  const ProgramAnalytics({Key? key}) : super(key: key);

  @override
  State<ProgramAnalytics> createState() => _ProgramAnalyticsState();
}

class _ProgramAnalyticsState extends State<ProgramAnalytics> {
  String _selectedPeriod = '30 days';
  String _selectedProgram = 'All Programs';
  
  final List<String> _periods = ['7 days', '30 days', '90 days', '1 year'];
  final List<String> _programs = ['All Programs', 'Emergency Food Assistance', 'Education Support Program', 'Healthcare Access Initiative'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Analytics'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading analytics report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            _buildFiltersSection(),
            SizedBox(height: 3.h),
            
            // Key Metrics
            _buildKeyMetricsSection(),
            SizedBox(height: 3.h),
            
            // Distribution Chart
            _buildDistributionChart(),
            SizedBox(height: 3.h),
            
            // Beneficiary Trends
            _buildBeneficiaryTrends(),
            SizedBox(height: 3.h),
            
            // Program Performance
            _buildProgramPerformance(),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedProgram,
                    decoration: const InputDecoration(
                      labelText: 'Program',
                      border: OutlineInputBorder(),
                    ),
                    items: _programs.map((program) => DropdownMenuItem(
                      value: program,
                      child: Text(program),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProgram = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriod,
                    decoration: const InputDecoration(
                      labelText: 'Period',
                      border: OutlineInputBorder(),
                    ),
                    items: _periods.map((period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Distributed', '\$1.2M', 'account_balance_wallet', AppTheme.successLight)),
            SizedBox(width: 3.w),
            Expanded(child: _buildMetricCard('Beneficiaries Served', '4,950', 'people', AppTheme.lightTheme.colorScheme.primary)),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Active Programs', '12', 'folder_open', Colors.orange)),
            SizedBox(width: 3.w),
            Expanded(child: _buildMetricCard('Success Rate', '94.2%', 'trending_up', AppTheme.successLight)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String iconName, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: color,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fund Distribution by Category',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 30.h,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      title: '40%',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: '25%',
                      color: AppTheme.successLight,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: '20%',
                      color: Colors.orange,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 15,
                      title: '15%',
                      color: Colors.purple,
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final items = [
      {'color': AppTheme.lightTheme.colorScheme.primary, 'label': 'Food Security', 'value': '\$480K'},
      {'color': AppTheme.successLight, 'label': 'Education', 'value': '\$300K'},
      {'color': Colors.orange, 'label': 'Healthcare', 'value': '\$240K'},
      {'color': Colors.purple, 'label': 'Economic Dev.', 'value': '\$180K'},
    ];

    return Column(
      children: items.map((item) => Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                color: item['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                item['label'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            Text(
              item['value'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildBeneficiaryTrends() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beneficiary Enrollment Trends',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 25.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 100),
                        FlSpot(1, 250),
                        FlSpot(2, 400),
                        FlSpot(3, 600),
                        FlSpot(4, 800),
                        FlSpot(5, 950),
                        FlSpot(6, 1200),
                      ],
                      isCurved: true,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramPerformance() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Program Performance Comparison',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildPerformanceItem('Emergency Food Assistance', 0.85, AppTheme.successLight),
            _buildPerformanceItem('Education Support Program', 0.72, AppTheme.lightTheme.colorScheme.primary),
            _buildPerformanceItem('Healthcare Access Initiative', 0.68, Colors.orange),
            _buildPerformanceItem('Small Business Support', 0.45, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String name, double progress, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
} 