import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  String _department = 'Operations';
  String _owner = 'Arjun Mehta';
  bool _isDecisionMaker = false;
  bool _saving = false;

  static const _departments = [
    'Operations',
    'Finance',
    'Management',
    'Procurement',
    'Technology',
    'IT',
    'Sales',
    'Marketing',
    'Support',
    'HR',
    'General',
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
    _idController = TextEditingController(
      text: 'CT-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _companyController.dispose();
    _customerIdController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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

  String _avatarText(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'CT';
    if (parts.length == 1) {
      return parts.first
          .substring(0, parts.first.length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final name = _nameController.text.trim();
      final now = DateTime.now().toUtc();
      final tenantId = await _resolveTenantId();
      final customerId = _customerIdController.text.trim();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'name': name,
        'avatar_text': _avatarText(name),
        'company': _companyController.text.trim(),
        'customer_id': customerId.isEmpty ? null : customerId,
        'designation': _designationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'department': _department,
        'is_decision_maker': _isDecisionMaker,
        'owner': _owner,
        'notes': _notesController.text.trim(),
        'created_at': now.toIso8601String().substring(0, 10),
        'updated_at': now.toIso8601String(),
      };

      await _supabase.from('contacts').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add contact: $e'),
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
          'Add Contact',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Contact Information', Icons.person_outline),
            _field(
              _idController,
              'Contact ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _nameController,
              'Full Name',
              Icons.person_outline,
              required: true,
            ),
            _field(
              _companyController,
              'Company',
              Icons.apartment_outlined,
              required: true,
            ),
            _field(
              _customerIdController,
              'Customer ID',
              Icons.tag_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _designationController,
                    'Designation',
                    Icons.work_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Department',
                    value: _department,
                    items: _departments,
                    onChanged: (v) {
                      if (v != null) setState(() => _department = v);
                    },
                  ),
                ),
              ],
            ),
            _dropdown(
              label: 'Owner',
              value: _owner,
              items: _owners,
              onChanged: (v) {
                if (v != null) setState(() => _owner = v);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Decision Maker'),
              subtitle: const Text('Is this contact a decision maker?'),
              value: _isDecisionMaker,
              onChanged: (v) => setState(() => _isDecisionMaker = v),
            ),
            const SizedBox(height: 8),
            _sectionTitle('Contact Details', Icons.contact_phone_outlined),
            _field(
              _phoneController,
              'Phone',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            _field(
              _emailController,
              'Email',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
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
                onPressed: _saving ? null : _saveContact,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.person_add_alt_1_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Contact',
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
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
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
