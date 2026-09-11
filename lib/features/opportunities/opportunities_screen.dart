import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import 'add_opportunity_screen.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _search = '';
  String _stage = 'All';
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _opportunities = [];

  static const _stages = [
    'All',
    'New',
    'Contacted',
    'Qualified',
    'Requirement',
    'Proposal Sent',
    'Negotiation',
    'Won',
    'Lost',
  ];

  @override
  void initState() {
    super.initState();
    _loadOpportunities();
  }

  Future<void> _loadOpportunities() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _supabase
          .from('opportunities')
          .select()
          .order('updated_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _opportunities = List<Map<String, dynamic>>.from(rows);
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
    var list = _opportunities;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((o) {
        final deal = (o['deal_name'] ?? '').toString().toLowerCase();
        final customer = (o['customer'] ?? '').toString().toLowerCase();
        final id = (o['id'] ?? '').toString().toLowerCase();
        final assigned = (o['assigned_to'] ?? '').toString().toLowerCase();
        return deal.contains(q) ||
            customer.contains(q) ||
            id.contains(q) ||
            assigned.contains(q);
      }).toList();
    }
    if (_stage != 'All') {
      list = list.where((o) => o['stage'] == _stage).toList();
    }
    return list;
  }

  Future<void> _openAddOpportunity() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddOpportunityScreen()),
    );

    if (created == true) {
      await _loadOpportunities();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunities'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadOpportunities,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'opportunities-add-fab-$hashCode',
        onPressed: _openAddOpportunity,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Search opportunities...',
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
              itemCount: _stages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final s = _stages[i];
                final selected = _stage == s;
                return GestureDetector(
                  onTap: () => setState(() => _stage = s),
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
                'Could not load opportunities',
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
                onPressed: _loadOpportunities,
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
              Icons.handshake_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No opportunities found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openAddOpportunity,
              child: const Text('Add your first opportunity'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOpportunities,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final o = filtered[i];
          final dealName = (o['deal_name'] ?? '').toString();
          final customer = (o['customer'] ?? '').toString();
          final stage = (o['stage'] ?? '').toString();
          final priority = (o['priority'] ?? '').toString();
          final assignedTo = (o['assigned_to'] ?? '').toString();
          final closeDate =
              (o['expected_closing_date'] ?? '').toString();
          final value = (o['value'] as num?)?.toDouble() ?? 0;
          final probability =
              (o['probability'] as num?)?.toInt() ?? 0;

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
                    Expanded(
                      child: Text(
                        dealName.isEmpty ? 'Untitled Deal' : dealName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (stage.isNotEmpty) StatusBadge(status: stage),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  customer.isEmpty ? '—' : customer,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      Formatters.inr(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$probability%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (priority.isNotEmpty)
                      StatusBadge(status: priority, fontSize: 10),
                    const Spacer(),
                    Text(
                      [
                        if (assignedTo.isNotEmpty) assignedTo,
                        if (closeDate.isNotEmpty) closeDate,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
