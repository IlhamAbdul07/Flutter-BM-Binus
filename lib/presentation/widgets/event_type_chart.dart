import 'package:bm_binus/data/models/event_dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EventTypeChart extends StatelessWidget {
  final EventTypeDashboard dashboard;

  const EventTypeChart({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final maxValue = dashboard.typeList.isNotEmpty
        ? dashboard.typeList.map((e) => e.count).reduce((a, b) => a > b ? a : b)
        : 0;
    final maxY = ((maxValue + 4) ~/ 5) * 5; 

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY.toDouble(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = dashboard.typeList[group.x];
              return BarTooltipItem(
                '${data.type}\n${data.count} (${data.percentage.toStringAsFixed(1)}%)',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < dashboard.typeList.length) {
                  final title = dashboard.typeList[value.toInt()].type;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: 80, // atur lebar area teks agar bisa wrap
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3, // batas 3 baris
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300], strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: dashboard.typeList.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.count.toDouble(),
                color: Colors.blue[700],
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
