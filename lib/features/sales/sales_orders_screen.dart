import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import 'add_sales_order_screen.dart';

class SalesOrdersScreen extends StatefulWidget {
  const SalesOrdersScreen({super.key});

  @override
  State<SalesOrdersScreen> createState() => _SalesOrdersScreenState();
}

class _SalesOrdersScreenState extends State<SalesOrdersScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _search = '';
  String _status = 'All';
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _orders = [];

  static const _statuses = [
    'All',
    'Pending',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _supabase
          .from('sales_orders')
          .select()
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _orders = List<Map<String, dynamic>>.from(rows);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _orders;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((o) {
        final id = (o['id'] ?? '').toString().toLowerCase();
        final customer = (o['customer'] ?? '').toString().toLowerCase();
        final salesperson =
            (o['salesperson'] ?? '').toString().toLowerCase();
        return id.contains(q) ||
            customer.contains(q) ||
            salesperson.contains(q);
      }).toList();
    }
    if (_status != 'All') {
      list = list.where((o) => o['status'] == _status).toList();
    }
    return list;
  }

  Future<void> _openAddOrder() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddSalesOrderScreen()),
    );

    if (created == true) {
      await _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadOrders,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'sales-orders-add-fab-$hashCode',
        onPressed: _openAddOrder,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Search sales orders...',
                prefixIcon: Icon(Icons.search_rounded, size: 20),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final s = _statuses[i];
                final selected = _status == s;
                return GestureDetector(
                  onTap: () => setState(() => _status = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primary
                          : (isDark
                              ? const Color(0xFF1E293B)
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(isDark, filtered)),
        ],
      ),
    );
  }

  Widget _buildBody(bool isDark, List<Map<String, dynamic>> filtered) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Could not load sales orders',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadOrders,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No sales orders found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openAddOrder,
              child: const Text('Add your first sales order'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final o = filtered[i];
          final id = (o['id'] ?? '').toString();
          final customer = (o['customer'] ?? '').toString();
          final status = (o['status'] ?? '').toString();
          final salesperson = (o['salesperson'] ?? '').toString();
          final deliveryDate = (o['delivery_date'] ?? '').toString();
          final paymentTerms = (o['payment_terms'] ?? '').toString();
          final total = (o['total'] as num?)?.toDouble() ??
              (o['price'] as num?)?.toDouble() ??
              0;
          final qty = (o['quantity'] as num?)?.toInt() ?? 0;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    if (status.isNotEmpty) StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  customer.isEmpty ? '—' : customer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      Formatters.inr(total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (qty > 0) ...[
                      const SizedBox(width: 10),
                      Text(
                        'Qty: $qty',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      [
                        if (salesperson.isNotEmpty) salesperson,
                        if (deliveryDate.isNotEmpty) deliveryDate,
                      ].join(' · '),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),
                  ],
                ),
                if (paymentTerms.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    paymentTerms,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
