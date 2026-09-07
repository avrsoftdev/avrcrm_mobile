import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';

class OpportunitiesScreen extends StatelessWidget {
  const OpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stages = ['Discovery', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won'];

    return Scaffold(
      appBar: AppBar(title: const Text('Opportunities')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: stages.length,
        itemBuilder: (_, si) {
          final stage = stages[si];
          final items = MockData.opportunities.where((o) => o.stage == stage || (stage == 'Closed Won' && o.status == 'Won')).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Row(
                  children: [
                    Text(stage, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('${items.length}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              ...items.map((opp) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opp.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(opp.company, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(Formatters.inr(opp.value), style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 14)),
                          const Spacer(),
                          Text('${opp.probability}%', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          StatusBadge(status: opp.status),
                          const Spacer(),
                          Text('${opp.owner} · ${opp.closeDate}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Center(child: Text('No opportunities', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color))),
                ),
            ],
          );
        },
      ),
    );
  }
}
