import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/app_export.dart';

class AuditChartWidget extends StatelessWidget {
  final int selectedTimeRange;
  final ValueChanged<int> onTimeRangeChanged;

  const AuditChartWidget({
    Key? key,
    required this.selectedTimeRange,
    required this.onTimeRangeChanged,
  }) : super(key: key);

  List<String> get _timeRangeLabels => ['Week', 'Month', 'Quarter'];

  List<FlSpot> get _chartData {
    // Mock data based on selected time range
    switch (selectedTimeRange) {
      case 0: // Week
        return [
          FlSpot(0, 8),
          FlSpot(1, 12),
          FlSpot(2, 6),
          FlSpot(3, 15),
          FlSpot(4, 10),
          FlSpot(5, 18),
          FlSpot(6, 14),
        ];
      case 1: // Month
        return [
          FlSpot(0, 45),
          FlSpot(1, 52),
          FlSpot(2, 38),
          FlSpot(3, 61),
          FlSpot(4, 48),
          FlSpot(5, 55),
          FlSpot(6, 42),
          FlSpot(7, 58),
          FlSpot(8, 49),
          FlSpot(9, 63),
          FlSpot(10, 51),
          FlSpot(11, 56),
        ];
      case 2: // Quarter
        return [
          FlSpot(0, 156),
          FlSpot(1, 189),
          FlSpot(2, 145),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Time Range Selector
          Row(
            children: [
              CustomIconWidget(
                iconName: 'show_chart',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Audit Trends',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _timeRangeLabels.asMap().entries.map((entry) {
                    final index = entry.key;
                    final label = entry.value;
                    final isSelected = index == selectedTimeRange;

                    return GestureDetector(
                      onTap: () => onTimeRangeChanged(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          label,
                          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Chart
          SizedBox(
            height: 30.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: selectedTimeRange == 0 ? 5 : (selectedTimeRange == 1 ? 20 : 50),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        String text = '';
                        switch (selectedTimeRange) {
                          case 0: // Week
                            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            if (value.toInt() < days.length) {
                              text = days[value.toInt()];
                            }
                            break;
                          case 1: // Month
                            text = '${(value.toInt() + 1)}';
                            break;
                          case 2: // Quarter
                            final quarters = ['Q1', 'Q2', 'Q3'];
                            if (value.toInt() < quarters.length) {
                              text = quarters[value.toInt()];
                            }
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            text,
                            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: selectedTimeRange == 0 ? 5 : (selectedTimeRange == 1 ? 20 : 50),
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: _chartData.length - 1.0,
                minY: 0,
                maxY: _chartData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: _chartData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.secondary,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
                          AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Chart Legend
          Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'Completed Audits',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
