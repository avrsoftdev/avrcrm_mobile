import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  String _search = '';
  String _status = 'All';

  List<Lead> get _filtered {
    var list = MockData.leads;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((l) => l.fullName.toLowerCase().contains(q) || l.company.toLowerCase().contains(q) || l.email.toLowerCase().contains(q)).toList();
    }
    if (_status != 'All') list = list.where((l) => l.status == _status).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statuses = ['All', 'New', 'Contacted', 'Qualified', 'Proposal', 'Negotiation', 'Won', 'Lost'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search leads...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final s = statuses[i];
                final selected = _status == s;
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : (isDark ? const Color(0xFF1E293B) : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final lead = _filtered[i];
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
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.primary.withOpacity(0.12),
                            child: Text(
                              lead.firstName[0] + lead.lastName[0],
                              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lead.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text(lead.company, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)),
                              ],
                            ),
                          ),
                          StatusBadge(status: lead.status),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          StatusBadge(status: lead.priority, fontSize: 10),
                          const SizedBox(width: 8),
                          Text(lead.source, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                          const Spacer(),
                          Text(Formatters.inr(lead.value), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('${lead.assignedTo} · ${lead.createdAt}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
