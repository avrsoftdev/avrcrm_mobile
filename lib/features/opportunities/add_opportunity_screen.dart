import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddOpportunityScreen extends StatefulWidget {
  const AddOpportunityScreen({super.key});

  @override
  State<AddOpportunityScreen> createState() => _AddOpportunityScreenState();
}

class _AddOpportunityScreenState extends State<AddOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _dealNameController = TextEditingController();
  final _customerController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _leadIdController = TextEditingController();
  final _valueController = TextEditingController(text: '0');
  final _probabilityController = TextEditingController(text: '20');
  final _closingDateController = TextEditingController();

  String _stage = 'New';
  String _priority = 'Medium';
  String _assignedTo = 'Arjun Mehta';
  bool _saving = false;

  static const _stages = [
    'New',
    'Contacted',
    'Qualified',
    'Requirement',
    'Proposal Sent',
    'Negotiation',
    'Won',
    'Lost',
  ];

  static const _priorities = ['High', 'Medium', 'Low'];

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
    _idController = TextEditingController(
      text: 'OPP-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _dealNameController.dispose();
    _customerController.dispose();
    _customerIdController.dispose();
    _leadIdController.dispose();
    _valueController.dispose();
    _probabilityController.dispose();
    _closingDateController.dispose();
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
    _closingDateController.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveOpportunity() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc();
      final tenantId = await _resolveTenantId();
      final customerId = _customerIdController.text.trim();
      final leadId = _leadIdController.text.trim();
      final closingDate = _closingDateController.text.trim();
      final dealName = _dealNameController.text.trim();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'deal_name': dealName,
        'customer': _customerController.text.trim(),
        'customer_id': customerId.isEmpty ? '' : customerId,
        'lead_id': leadId.isEmpty ? null : leadId,
        'value': double.tryParse(_valueController.text.trim()) ?? 0,
        'probability':
            int.tryParse(_probabilityController.text.trim()) ?? 20,
        'stage': _stage,
        'expected_closing_date':
            closingDate.isEmpty ? null : closingDate,
        'assigned_to': _assignedTo,
        'priority': _priority,
        'converted_from_type': null,
        'converted_from_id': null,
        'created_at': now.toIso8601String().substring(0, 10),
        'updated_at': now.toIso8601String(),
      };

      await _supabase.from('opportunities').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$dealName added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add opportunity: $e'),
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
          'Add Opportunity',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle(
              'Opportunity Information',
              Icons.handshake_outlined,
            ),
            _field(
              _idController,
              'Opportunity ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _dealNameController,
              'Deal Name',
              Icons.title,
              required: true,
            ),
            _field(
              _customerController,
              'Customer',
              Icons.business_outlined,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _customerIdController,
                    'Customer ID',
                    Icons.tag_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _leadIdController,
                    'Lead ID',
                    Icons.person_search_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Pipeline', Icons.trending_up),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Stage',
                    value: _stage,
                    items: _stages,
                    onChanged: (v) {
                      if (v != null) setState(() => _stage = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
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
              ],
            ),
            _dropdown(
              label: 'Assigned To',
              value: _assignedTo,
              items: _owners,
              onChanged: (v) {
                if (v != null) setState(() => _assignedTo = v);
              },
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _valueController,
                    'Value',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _probabilityController,
                    'Probability %',
                    Icons.percent,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _dateField(
              _closingDateController,
              'Expected Closing Date',
              Icons.event_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveOpportunity,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.handshake_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Opportunity',
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
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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

  Widget _dateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            onPressed: _pickDate,
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
