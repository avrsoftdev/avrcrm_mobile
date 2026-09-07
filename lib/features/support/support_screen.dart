import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Support Tickets')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: MockData.tickets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final t = MockData.tickets[i];
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.support_agent_rounded, color: AppTheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.subject, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text('${t.id} · ${t.customer}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    StatusBadge(status: t.priority),
                    const SizedBox(width: 6),
                    StatusBadge(status: t.status),
                    const Spacer(),
                    Text('${t.assignee} · ${t.createdAt}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
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
