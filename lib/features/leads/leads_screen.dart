import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import 'add_lead_screen.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _search = '';
  String _status = 'All';
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _leads = [];

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _supabase
          .from('leads')
          .select()
          .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _leads = List<Map<String, dynamic>>.from(rows);
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
    var list = _leads;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((l) {
        final first = (l['first_name'] ?? '').toString().toLowerCase();
        final last = (l['last_name'] ?? '').toString().toLowerCase();
        final company = (l['company'] ?? '').toString().toLowerCase();
        final email = (l['email'] ?? '').toString().toLowerCase();
        final phone = (l['phone'] ?? '').toString().toLowerCase();
        final id = (l['id'] ?? '').toString().toLowerCase();
        return first.contains(q) ||
            last.contains(q) ||
            '$first $last'.contains(q) ||
            company.contains(q) ||
            email.contains(q) ||
            phone.contains(q) ||
            id.contains(q);
      }).toList();
    }
    if (_status != 'All') {
      list = list.where((l) => l['status'] == _status).toList();
    }
    return list;
  }

  Future<void> _openAddLead() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddLeadScreen()),
    );

    if (created == true) {
      await _loadLeads();
    }
  }

  String _initials(Map<String, dynamic> lead) {
    final first = (lead['first_name'] ?? '').toString().trim();
    final last = (lead['last_name'] ?? '').toString().trim();
    final a = first.isNotEmpty ? first[0] : '';
    final b = last.isNotEmpty ? last[0] : '';
    final value = '$a$b'.toUpperCase();
    return value.isEmpty ? '?' : value;
  }

  String _fullName(Map<String, dynamic> lead) {
    final first = (lead['first_name'] ?? '').toString().trim();
    final last = (lead['last_name'] ?? '').toString().trim();
    final name = '$first $last'.trim();
    return name.isEmpty ? 'Unnamed Lead' : name;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statuses = [
      'All',
      'New',
      'Contacted',
      'Qualified',
      'Proposal',
      'Negotiation',
      'Won',
      'Lost',
    ];
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadLeads,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'leads-add-fab',
        onPressed: _openAddLead,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText: 'Search leads...',
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
              itemCount: statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final s = statuses[i];
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
                        color: selected
                            ? Colors.white
                            : Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color,
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
                'Could not load leads',
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
                onPressed: _loadLeads,
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
              Icons.person_search_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No leads found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openAddLead,
              child: const Text('Add your first lead'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLeads,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final lead = filtered[i];
          final company = (lead['company'] ?? '').toString();
          final status = (lead['status'] ?? '').toString();
          final priority = (lead['priority'] ?? '').toString();
          final source = (lead['source'] ?? '').toString();
          final assignedTo = (lead['assigned_to'] ?? '').toString();
          final createdAt = (lead['created_at'] ?? '').toString();
          final value =
              (lead['expected_value'] as num?)?.toDouble() ?? 0;
          final createdLabel = createdAt.length >= 10
              ? createdAt.substring(0, 10)
              : createdAt;

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
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          AppTheme.primary.withOpacity(0.12),
                      child: Text(
                        _initials(lead),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fullName(lead),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            company.isEmpty ? '—' : company,
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
                    ),
                    if (status.isNotEmpty) StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (priority.isNotEmpty)
                      StatusBadge(status: priority, fontSize: 10),
                    if (priority.isNotEmpty) const SizedBox(width: 8),
                    Text(
                      source,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.inr(value),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    if (assignedTo.isNotEmpty) assignedTo,
                    if (createdLabel.isNotEmpty) createdLabel,
                  ].join(' · '),
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
