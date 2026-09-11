import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _subjectController = TextEditingController();
  final _relatedToController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController(text: '10:00');
  final _notesController = TextEditingController();

  String _type = 'Call';
  String _relatedType = 'Lead';
  String _assignedTo = 'Arjun Mehta';
  String _priority = 'Medium';
  String _status = 'Scheduled';
  bool _saving = false;

  static const _types = [
    'Call',
    'Meeting',
    'Email',
    'WhatsApp',
    'Task',
    'Note',
    'Site Visit',
    'Demo',
    'Follow-up',
  ];

  static const _relatedTypes = ['Lead', 'Customer', 'Opportunity'];

  static const _priorities = ['High', 'Medium', 'Low'];

  static const _statuses = [
    'Scheduled',
    'In Progress',
    'Completed',
    'Cancelled',
  ];

  static const _owners = [
    'Arjun Mehta',
    'Priya Sharma',
    'Rahul Verma',
    'Vikram Joshi',
    'Rohan Kapoor',
    'Meera Reddy',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _idController = TextEditingController(
      text: 'AC-${DateTime.now().millisecondsSinceEpoch}',
    );
    _dateController.text =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _idController.dispose();
    _subjectController.dispose();
    _relatedToController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<String> _resolveTenantId() async {
    const fallback = 'tenant-default';
    final user = _supabase.auth.currentUser;
    if (user == null) return fallback;

    try {
      final profile = await _supabase
          .from('profiles')
          .select('tenant_id')
          .eq('id', user.id)
          .maybeSingle();

      final fromProfile = profile?['tenant_id']?.toString().trim();
      if (fromProfile != null && fromProfile.isNotEmpty) {
        return fromProfile;
      }

      final fromMeta = user.userMetadata?['tenant_id']?.toString().trim();
      if (fromMeta != null && fromMeta.isNotEmpty) {
        return fromMeta;
      }
    } catch (_) {}

    return fallback;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    _dateController.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime() async {
    final parts = _timeController.text.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 10,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null) return;
    _timeController.text =
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'type': _type,
        'subject': _subjectController.text.trim(),
        'related_to': _relatedToController.text.trim(),
        'related_type': _relatedType,
        'assigned_to': _assignedTo,
        'date': _dateController.text.trim(),
        'time': _timeController.text.trim(),
        'priority': _priority,
        'status': _status,
        'notes': _notesController.text.trim(),
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('activities').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${payload['subject']} added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add activity: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Activity',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Activity Details', Icons.event_note_outlined),
            _field(
              _idController,
              'Activity ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _subjectController,
              'Subject',
              Icons.title,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Type',
                    value: _type,
                    items: _types,
                    onChanged: (v) {
                      if (v != null) setState(() => _type = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Status',
                    value: _status,
                    items: _statuses,
                    onChanged: (v) {
                      if (v != null) setState(() => _status = v);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Priority',
                    value: _priority,
                    items: _priorities,
                    onChanged: (v) {
                      if (v != null) setState(() => _priority = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Assigned To',
                    value: _assignedTo,
                    items: _owners,
                    onChanged: (v) {
                      if (v != null) setState(() => _assignedTo = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Related To', Icons.link_outlined),
            _field(
              _relatedToController,
              'Related To',
              Icons.business_outlined,
              required: true,
            ),
            _dropdown(
              label: 'Related Type',
              value: _relatedType,
              items: _relatedTypes,
              onChanged: (v) {
                if (v != null) setState(() => _relatedType = v);
              },
            ),
            const SizedBox(height: 8),
            _sectionTitle('Schedule', Icons.schedule_outlined),
            Row(
              children: [
                Expanded(
                  child: _pickerField(
                    _dateController,
                    'Date',
                    Icons.event_outlined,
                    _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _pickerField(
                    _timeController,
                    'Time',
                    Icons.access_time,
                    _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Notes', Icons.notes_outlined),
            _field(
              _notesController,
              'Notes',
              Icons.sticky_note_2_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveActivity,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_task_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Activity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
        ),
      ),
    );
  }

  Widget _pickerField(
    TextEditingController controller,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(icon, size: 18),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          prefixIcon: const Icon(Icons.tune),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
