import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ShipmentStatsScreen extends StatefulWidget {
  const ShipmentStatsScreen({super.key});

  @override
  State<ShipmentStatsScreen> createState() => _ShipmentStatsScreenState();
}

class _ShipmentStatsScreenState extends State<ShipmentStatsScreen> {
  List<double> dataPoints = [];

  @override
  void initState() {
    super.initState();
    generateRandomStats();
  }

  void generateRandomStats() {
    final random = Random();
    // وليكن 6 شهور مثلاً
    dataPoints = List.generate(6, (_) => random.nextInt(15) + 5.0); // 5-20
  }

  @override
  Widget build(BuildContext context) {
    final List<String> months = ['ينا', 'فبر', 'مارس', 'أبر', 'ماي', 'يونيو'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("إحصائيات وتقارير"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                generateRandomStats();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BarChart(
          BarChartData(
            barGroups: List.generate(dataPoints.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: dataPoints[index],
                    color: Colors.green,
                    width: 16,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: true),
            maxY: 25,
          ),
        ),
      ),
    );
  }
}
