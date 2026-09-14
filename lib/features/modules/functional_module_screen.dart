import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModuleField {
  const ModuleField(this.name, {this.label, this.required = false, this.multiline = false});
  final String name;
  final String? label;
  final bool required;
  final bool multiline;
  String get displayLabel => label ?? _title(name);

  static String _title(String value) => value
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class FunctionalModuleDefinition {
  const FunctionalModuleDefinition({
    required this.title,
    required this.table,
    required this.description,
    required this.icon,
    required this.fields,
    this.statusField = 'status',
    this.statuses = const ['Draft', 'Active', 'Completed', 'Cancelled'],
  });

  final String title;
  final String table;
  final String description;
  final IconData icon;
  final List<ModuleField> fields;
  final String? statusField;
  final List<String> statuses;
}

class FunctionalModuleScreen extends StatefulWidget {
  const FunctionalModuleScreen({super.key, required this.definition});
  final FunctionalModuleDefinition definition;

  @override
  State<FunctionalModuleScreen> createState() => _FunctionalModuleScreenState();
}

class _FunctionalModuleScreenState extends State<FunctionalModuleScreen> {
  final _supabase = Supabase.instance.client;
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _rows = [];
  bool _loading = true;
  String? _error;
  String _status = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _supabase.from(widget.definition.table).select();
      if (!mounted) return;
      setState(() {
        _rows = List<Map<String, dynamic>>.from(result);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return _rows.where((row) {
      final matchesSearch = query.isEmpty || row.values.any((value) => value.toString().toLowerCase().contains(query));
      final matchesStatus = _status == 'All' || widget.definition.statusField == null || row[widget.definition.statusField] == _status;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _create() async {
    final saved = await showDialog<bool>(context: context, builder: (_) => _RecordDialog(definition: widget.definition));
    if (saved == true) _load();
  }

  Future<void> _edit(Map<String, dynamic> row) async {
    final saved = await showDialog<bool>(context: context, builder: (_) => _RecordDialog(definition: widget.definition, initial: row));
    if (saved == true) _load();
  }

  Future<void> _delete(Map<String, dynamic> row) async {
    final id = row['id'];
    if (id == null) {
      _toast('This record has no id field.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete record?'),
        content: Text('Delete this ${widget.definition.title.toLowerCase()} record permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _supabase.from(widget.definition.table).delete().eq('id', id);
      _toast('Record deleted');
      _load();
    } catch (e) {
      _toast('Delete failed: $e', error: true);
    }
  }

  Future<void> _changeStatus(Map<String, dynamic> row) async {
    final field = widget.definition.statusField;
    final id = row['id'];
    if (field == null || id == null) return;
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Update status'),
        children: widget.definition.statuses.map((s) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, s),
          child: Text(s),
        )).toList(),
      ),
    );
    if (selected == null) return;
    try {
      await _supabase.from(widget.definition.table).update({field: selected, 'updated_at': DateTime.now().toIso8601String()}).eq('id', id);
      _load();
    } catch (e) {
      _toast('Status update failed: $e', error: true);
    }
  }

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: error ? Colors.red.shade700 : null));
  }

  String _primaryValue(Map<String, dynamic> row) {
    for (final key in ['name', 'title', 'subject', 'company', 'customer', 'vendor', 'employee_name', 'product_name', 'invoice_number', 'quotation_number', 'order_number', 'id']) {
      final value = row[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return 'Record';
  }

  String _secondaryValue(Map<String, dynamic> row) {
    final parts = <String>[];
    for (final key in ['email', 'phone', 'company', 'status', 'amount', 'total', 'department', 'category', 'due_date']) {
      final value = row[key]?.toString().trim();
      if (value != null && value.isNotEmpty && !parts.contains(value)) parts.add(value);
      if (parts.length == 3) break;
    }
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final statuses = <String>['All', ...widget.definition.statuses];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.definition.title),
        actions: [IconButton(onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh_rounded))],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: _create, icon: const Icon(Icons.add), label: Text('New')),
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.definition.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            TextField(controller: _searchController, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Search records...', prefixIcon: Icon(Icons.search_rounded))),
            const SizedBox(height: 10),
            SizedBox(height: 34, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: statuses.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (_, i) {
              final s = statuses[i];
              return ChoiceChip(label: Text(s), selected: _status == s, onSelected: (_) => setState(() => _status = s));
            })),
          ]),
        ),
        Expanded(child: _buildList(filtered)),
      ]),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> rows) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cloud_off_rounded, size: 42), const SizedBox(height: 12), Text('Unable to load ${widget.definition.title}'), const SizedBox(height: 8), Text(_error!, textAlign: TextAlign.center), const SizedBox(height: 16), FilledButton(onPressed: _load, child: const Text('Retry'))])));
    if (rows.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(widget.definition.icon, size: 54), const SizedBox(height: 12), const Text('No records found'), const SizedBox(height: 14), FilledButton.icon(onPressed: _create, icon: const Icon(Icons.add), label: Text('Create ${widget.definition.title.replaceAll(RegExp(r' Management$'), '')}'))]));
    return RefreshIndicator(onRefresh: _load, child: ListView.separated(padding: const EdgeInsets.fromLTRB(16, 4, 16, 100), itemCount: rows.length, separatorBuilder: (_, __) => const SizedBox(height: 8), itemBuilder: (_, i) {
      final row = rows[i];
      final status = widget.definition.statusField == null ? null : row[widget.definition.statusField]?.toString();
      return Card(child: ListTile(
        leading: CircleAvatar(child: Icon(widget.definition.icon, size: 20)),
        title: Text(_primaryValue(row), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(_secondaryValue(row), maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: PopupMenuButton<String>(onSelected: (action) { if (action == 'edit') _edit(row); if (action == 'delete') _delete(row); if (action == 'status') _changeStatus(row); if (action == 'view') _view(row); }, itemBuilder: (_) => [const PopupMenuItem(value: 'view', child: Text('View details')), const PopupMenuItem(value: 'edit', child: Text('Edit')), if (widget.definition.statusField != null) const PopupMenuItem(value: 'status', child: Text('Update status')), const PopupMenuItem(value: 'delete', child: Text('Delete'))]),
        isThreeLine: status != null,
        onTap: () => _view(row),
      ));
    }));
  }

  void _view(Map<String, dynamic> row) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _primaryValue(row),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                ...row.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            ModuleField._title(entry.key),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Text(entry.value?.toString() ?? '—')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordDialog extends StatefulWidget {
  const _RecordDialog({required this.definition, this.initial});
  final FunctionalModuleDefinition definition;
  final Map<String, dynamic>? initial;

  @override
  State<_RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<_RecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final Map<String, TextEditingController> _controllers = {};
  bool _saving = false;

  static const _tenantTables = {
    'leads','customers','contacts','follow_ups','opportunities','deals','activities',
    'quotations','sales_orders','invoices','payments','products','employees',
  };

  @override
  void initState() {
    super.initState();
    for (final field in widget.definition.fields) {
      final initial = widget.initial?[field.name]?.toString();
      final generated = field.name == 'id' && initial == null ? 'REC-${DateTime.now().millisecondsSinceEpoch}' : '';
      _controllers[field.name] = TextEditingController(text: initial ?? generated);
    }
  }

  @override
  void dispose() { for (final c in _controllers.values) { c.dispose(); } super.dispose(); }

  dynamic _typedValue(String name, String value) {
    final lower = name.toLowerCase();
    if (lower == 'id' || lower.contains('date') || lower.contains('time') || lower.endsWith('_at') || lower.contains('url') || lower.contains('email') || lower.contains('phone') || lower.contains('gstin') || lower.contains('status') || lower.contains('type') || lower.contains('name') || lower.contains('notes') || lower.contains('description') || lower.contains('content') || lower.contains('address') || lower.contains('reason') || lower.contains('reference') || lower.contains('owner') || lower.contains('department') || lower.contains('role') || lower.contains('category') || lower.contains('method') || lower.contains('frequency') || lower.contains('priority') || lower.contains('scope') || lower.contains('provider') || lower.contains('environment') || lower.contains('format') || lower.contains('criteria') || lower.contains('permissions') || lower.contains('configuration') || lower.contains('direction')) {
      return value;
    }
    if (lower.contains('count') || lower == 'days' || lower.contains('quantity') || lower.contains('stock') || lower.contains('hours') || lower.contains('level')) {
      return int.tryParse(value) ?? value;
    }
    if (lower.contains('amount') || lower.contains('total') || lower.contains('price') || lower.contains('salary') || lower.contains('revenue') || lower.contains('value') || lower.contains('budget') || lower.contains('rate') || lower.contains('probability')) {
      return double.tryParse(value) ?? value;
    }
    return value;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final payload = <String, dynamic>{};
      for (final field in widget.definition.fields) {
        final value = _controllers[field.name]!.text.trim();
        payload[field.name] = value.isEmpty ? null : _typedValue(field.name, value);
      }
      if (_tenantTables.contains(widget.definition.table)) {
        final user = _supabase.auth.currentUser;
        if (user != null) {
          try {
            final profile = await _supabase.from('profiles').select('tenant_id').eq('id', user.id).maybeSingle();
            final tenantId = profile?['tenant_id']?.toString();
            if (tenantId != null && tenantId.isNotEmpty) payload['tenant_id'] = tenantId;
          } catch (_) {}
        }
      }
      payload['updated_at'] = DateTime.now().toIso8601String();
      if (widget.initial == null) payload['created_at'] = DateTime.now().toIso8601String();
      final id = widget.initial?['id'];
      if (id == null) {
        await _supabase.from(widget.definition.table).insert(payload);
      } else {
        await _supabase.from(widget.definition.table).update(payload).eq('id', id);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red.shade700));
    } finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;
    return AlertDialog(
      title: Text(editing ? 'Edit ${widget.definition.title}' : 'Create ${widget.definition.title}'),
      content: SizedBox(width: 560, child: Form(key: _formKey, child: SingleChildScrollView(child: Column(children: widget.definition.fields.map((field) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: _controllers[field.name], maxLines: field.multiline ? 4 : 1, validator: field.required ? (v) => (v == null || v.trim().isEmpty) ? '${field.displayLabel} is required' : null : null, decoration: InputDecoration(labelText: field.displayLabel, border: const OutlineInputBorder())))).toList())))),
      actions: [TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancel')), FilledButton.icon(onPressed: _saving ? null : _save, icon: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined), label: Text(_saving ? 'Saving...' : 'Save'))],
    );
  }
}
