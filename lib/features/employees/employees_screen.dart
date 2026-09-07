import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: MockData.employees.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final e = MockData.employees[i];
          final initials = e.name.split(' ').map((n) => n[0]).join();
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primary.withOpacity(0.12),
                  child: Text(initials, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${e.role} · ${e.department}', style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                      Text(e.email, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ],
                  ),
                ),
                StatusBadge(status: e.status),
              ],
            ),
          );
        },
      ),
    );
  }
}
