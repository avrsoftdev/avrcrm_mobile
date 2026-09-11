import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import 'add_activity_screen.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final rows = await _supabase
          .from('activities')
          .select()
          .order('date', ascending: false);

      if (!mounted) return;

      setState(() {
        _activities = List<Map<String, dynamic>>.from(rows);
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

  Future<void> _openAddActivity() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddActivityScreen()),
    );

    if (created == true) {
      await _loadActivities();
    }
  }

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'call':
        return Icons.call_outlined;
      case 'meeting':
        return Icons.groups_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'whatsapp':
        return Icons.chat_outlined;
      case 'task':
        return Icons.check_circle_outline;
      case 'note':
        return Icons.sticky_note_2_outlined;
      case 'site visit':
        return Icons.location_on_outlined;
      case 'demo':
        return Icons.play_circle_outline;
      case 'follow-up':
        return Icons.replay_outlined;
      default:
        return Icons.history_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadActivities,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'activities-add-fab',
        onPressed: _openAddActivity,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
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
                'Could not load activities',
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
                onPressed: _loadActivities,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No activities found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openAddActivity,
              child: const Text('Add your first activity'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadActivities,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: _activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final a = _activities[i];
          final type = (a['type'] ?? '').toString();
          final subject = (a['subject'] ?? '').toString();
          final relatedTo = (a['related_to'] ?? '').toString();
          final relatedType = (a['related_type'] ?? '').toString();
          final assignedTo = (a['assigned_to'] ?? '').toString();
          final date = (a['date'] ?? '').toString();
          final time = (a['time'] ?? '').toString();
          final status = (a['status'] ?? '').toString();
          final priority = (a['priority'] ?? '').toString();
          final schedule = [
            if (date.isNotEmpty) date,
            if (time.isNotEmpty) time,
          ].join(' · ');

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : Colors.grey.shade200,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _typeIcon(type),
                    size: 18,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.isEmpty ? 'Untitled Activity' : subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (type.isNotEmpty) type,
                          if (relatedTo.isNotEmpty) relatedTo,
                          if (relatedType.isNotEmpty) relatedType,
                        ].join(' · '),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color,
                        ),
                      ),
                      if (assignedTo.isNotEmpty || schedule.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          [
                            if (assignedTo.isNotEmpty) assignedTo,
                            if (schedule.isNotEmpty) schedule,
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
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (status.isNotEmpty)
                            StatusBadge(status: status, fontSize: 10),
                          if (status.isNotEmpty && priority.isNotEmpty)
                            const SizedBox(width: 6),
                          if (priority.isNotEmpty)
                            StatusBadge(status: priority, fontSize: 10),
                        ],
                      ),
                    ],
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
