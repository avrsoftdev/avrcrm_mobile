import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock_data.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: MockData.products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final p = MockData.products[i];
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.inventory_2_rounded, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('${p.sku} · ${p.category}', style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(Formatters.inr(p.price), style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 13)),
                          const SizedBox(width: 12),
                          Text('Stock: ${p.stock}', style: TextStyle(fontSize: 11, color: p.stock < 10 ? AppTheme.destructive : Theme.of(context).textTheme.bodySmall?.color)),
                        ],
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: p.status),
              ],
            ),
          );
        },
      ),
    );
  }
}
