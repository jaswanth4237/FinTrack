import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyChartData {
  final String month;
  final double income;
  final double expense;

  MonthlyChartData({required this.month, required this.income, required this.expense});
}

class MonthlyBarChart extends StatelessWidget {
  final List<MonthlyChartData> data;

  const MonthlyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(toY: e.value.income, color: Colors.green, width: 8),
              BarChartRodData(toY: e.value.expense, color: Colors.red, width: 8),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  return Text(data[value.toInt()].month, style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
