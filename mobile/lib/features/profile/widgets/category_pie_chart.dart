import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryChartData {
  final String categoryName;
  final double total;
  final String color;

  CategoryChartData({required this.categoryName, required this.total, required this.color});
}

class CategoryPieChart extends StatelessWidget {
  final List<CategoryChartData> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: data.map((d) {
          final color = Color(int.parse(d.color.replaceAll('#', '0xFF')));
          return PieChartSectionData(
            value: d.total,
            title: '${d.total.round()}',
            color: color,
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }
}
