import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _search = '';
  String _status = 'All';

  List<Customer> get _filtered {
    var list = MockData.customers;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((c) => c.company.toLowerCase().contains(q) || c.email.toLowerCase().contains(q)).toList();
    }
    if (_status != 'All') list = list.where((c) => c.status == _status).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statuses = ['All', 'Active', 'Inactive', 'Prospect'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined))],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'customers-add-fab',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(hintText: 'Search customers...', prefixIcon: Icon(Icons.search_rounded, size: 20), contentPadding: EdgeInsets.symmetric(vertical: 10)),
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
                    child: Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : null)),
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
                final c = _filtered[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.company, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            Text('${c.industry} · ${c.type}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                            const SizedBox(height: 4),
                            Text(Formatters.inr(c.revenue), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primary)),
                          ],
                        ),
                      ),
                      StatusBadge(status: c.status),
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
