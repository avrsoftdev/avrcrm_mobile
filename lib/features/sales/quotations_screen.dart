import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotations = [
      {'id': 'QT-7001', 'customer': 'GreenEnergy Solutions', 'amount': 1850000.0, 'status': 'Sent', 'date': '2026-08-20'},
      {'id': 'QT-7002', 'customer': 'SJVN Ltd', 'amount': 2400000.0, 'status': 'Won', 'date': '2026-08-18'},
      {'id': 'QT-7003', 'customer': 'BuildRight Infra', 'amount': 650000.0, 'status': 'Draft', 'date': '2026-08-25'},
      {'id': 'QT-7004', 'customer': 'TechNova Pvt Ltd', 'amount': 420000.0, 'status': 'Lost', 'date': '2026-07-10'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quotations')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: quotations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final q = quotations[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(q['id'] as String, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 13)),
                    const Spacer(),
                    StatusBadge(status: q['status'] as String),
                  ],
                ),
                const SizedBox(height: 6),
                Text(q['customer'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(Formatters.inr(q['amount'] as double), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const Spacer(),
                    Text(q['date'] as String, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
