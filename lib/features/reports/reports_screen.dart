import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/kpi_card.dart';
import '../../data/mock_data.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: const [
              KpiCard(label: 'Revenue', value: '₹2.85Cr', change: '18.7%', icon: Icons.currency_rupee_rounded),
              KpiCard(label: 'New Leads', value: '48', change: '12%', icon: Icons.people_rounded, iconBg: AppTheme.info),
              KpiCard(label: 'Win Rate', value: '38%', change: '4.2%', icon: Icons.flag_rounded, iconBg: AppTheme.success),
              KpiCard(label: 'Avg Deal', value: '₹9.2L', change: '6.1%', icon: Icons.trending_up_rounded, iconBg: AppTheme.warning),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Revenue', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 3000000,
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                          final labels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A'];
                          final i = v.toInt();
                          return i >= 0 && i < labels.length ? Padding(padding: const EdgeInsets.only(top: 6), child: Text(labels[i], style: const TextStyle(fontSize: 10))) : const SizedBox();
                        })),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: MockData.salesMonthly.asMap().entries.map((e) {
                        return BarChartGroupData(x: e.key, barRods: [
                          BarChartRodData(toY: e.value['revenue'] as double, color: AppTheme.primary, width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                        ]);
                      }).toList(),
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
}
