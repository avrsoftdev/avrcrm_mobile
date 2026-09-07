import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = [
      {'type': 'success', 'title': 'Deal Won', 'msg': 'EduSmart Systems deal closed for ₹2.75L', 'time': '2 hours ago', 'read': false},
      {'type': 'warning', 'title': 'Overdue Invoice', 'msg': 'INV-4003 from BuildRight Infra is overdue', 'time': '5 hours ago', 'read': false},
      {'type': 'info', 'title': 'New Lead Assigned', 'msg': 'Suresh Patel from BuildRight assigned to you', 'time': 'Yesterday', 'read': true},
      {'type': 'success', 'title': 'Quotation Accepted', 'msg': 'QT-7002 for SJVN Ltd has been accepted', 'time': 'Yesterday', 'read': true},
      {'type': 'info', 'title': 'Follow-up Reminder', 'msg': 'Call scheduled with Rajesh Kumar at 3:00 PM', 'time': '2 days ago', 'read': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [TextButton(onPressed: () {}, child: const Text('Mark all read'))],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final n = items[i];
          final type = n['type'] as String;
          final color = type == 'success' ? AppTheme.success : type == 'warning' ? AppTheme.warning : AppTheme.info;
          final icon = type == 'success' ? Icons.check_circle_rounded : type == 'warning' ? Icons.warning_rounded : Icons.info_rounded;
          final read = n['read'] as bool;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: !read ? AppTheme.primary.withOpacity(0.06) : Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(n['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          if (!read) ...[
                            const SizedBox(width: 6),
                            Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(n['msg'] as String, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ],
                  ),
                ),
                Text(n['time'] as String, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          );
        },
      ),
    );
  }
}
