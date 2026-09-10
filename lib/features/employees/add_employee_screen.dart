import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _joiningDateController = TextEditingController();
  final _lastLoginController = TextEditingController();

  String _department = 'Sales';
  String _role = 'Sales Executive';
  String _status = 'Active';
  bool _saving = false;

  static const _departments = [
    'Sales',
    'Support',
    'Marketing',
    'Finance',
    'HR',
    'Operations',
  ];

  static const _roles = [
    'Sales Manager',
    'Sales Executive',
    'Marketing Manager',
    'Support Manager',
    'Support Executive',
    'Accountant',
    'Admin',
  ];

  static const _statuses = ['Active', 'Inactive', 'On Leave'];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final date =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    _idController = TextEditingController(
      text: 'EMP-${DateTime.now().millisecondsSinceEpoch}',
    );
    _joiningDateController.text = date;
    _lastLoginController.text = date;
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _joiningDateController.dispose();
    _lastLoginController.dispose();
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

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    controller.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  String _avatarText(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'EM';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final name = _nameController.text.trim();
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();
      final joiningDate = _joiningDateController.text.trim();
      final lastLogin = _lastLoginController.text.trim();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'name': name,
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'department': _department,
        'role': _role,
        'status': _status,
        'joining_date': joiningDate.isEmpty ? null : joiningDate,
        'last_login': lastLogin.isEmpty ? null : lastLogin,
        'avatar_text': _avatarText(name),
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('employees').insert(payload);

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
          content: Text('Failed to add employee: $e'),
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
          'Add Employee',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Employee Information', Icons.badge_outlined),
            _field(
              _idController,
              'Employee ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _nameController,
              'Full Name',
              Icons.person_outline,
              required: true,
            ),
            Row(
              children: [
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
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Role',
                    value: _role,
                    items: _roles,
                    onChanged: (v) {
                      if (v != null) setState(() => _role = v);
                    },
                  ),
                ),
              ],
            ),
            _dropdown(
              label: 'Status',
              value: _status,
              items: _statuses,
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: 8),
            _sectionTitle('Contact Details', Icons.contact_phone_outlined),
            _field(
              _emailController,
              'Email',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            _field(
              _phoneController,
              'Phone',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            _sectionTitle('Dates', Icons.event_outlined),
            _dateField(
              _joiningDateController,
              'Joining Date',
              Icons.event_available_outlined,
            ),
            _dateField(
              _lastLoginController,
              'Last Login',
              Icons.login_outlined,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveEmployee,
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
                  _saving ? 'Saving...' : 'Add Employee',
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
        onTap: () => _pickDate(controller),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            onPressed: () => _pickDate(controller),
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
