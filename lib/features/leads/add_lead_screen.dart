import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddLeadScreen extends StatefulWidget {
  const AddLeadScreen({super.key});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _gstController = TextEditingController();
  final _companySizeController = TextEditingController();
  final _annualRevenueController = TextEditingController();
  final _interestedProductController = TextEditingController();
  final _expectedValueController = TextEditingController(text: '0');
  final _expectedClosingController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');
  final _pincodeController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _nextFollowUpController = TextEditingController();

  String _industry = 'IT & Software';
  String _source = 'Website';
  String _status = 'New';
  String _priority = 'Medium';
  String _assignedTo = 'Arjun Mehta';
  bool _saving = false;

  static const _industries = [
    'Manufacturing',
    'IT & Software',
    'Engineering',
    'Construction',
    'Healthcare',
    'Education',
    'Retail',
    'Logistics',
    'Finance',
    'Automotive',
  ];

  static const _sources = [
    'Website',
    'Referral',
    'Google Ads',
    'Social Media',
    'WhatsApp',
    'Direct',
    'Other',
  ];

  static const _statuses = [
    'New',
    'Contacted',
    'Qualified',
    'Proposal',
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
      text: 'LD-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _gstController.dispose();
    _companySizeController.dispose();
    _annualRevenueController.dispose();
    _interestedProductController.dispose();
    _expectedValueController.dispose();
    _expectedClosingController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _nextFollowUpController.dispose();
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

  String? _nullableDate(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    return value;
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    controller.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveLead() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc();
      final tenantId = await _resolveTenantId();
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      final alternatePhone = _alternatePhoneController.text.trim();
      final expectedClosing =
          _nullableDate(_expectedClosingController.text);
      final nextFollowUp = _nullableDate(_nextFollowUpController.text);

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'company': _companyController.text.trim(),
        'designation': _designationController.text.trim(),
        'phone': _phoneController.text.trim(),
        'alternate_phone':
            alternatePhone.isEmpty ? null : alternatePhone,
        'email': _emailController.text.trim(),
        'industry': _industry,
        'company_size': _companySizeController.text.trim(),
        'website': _websiteController.text.trim(),
        'gst_number': _gstController.text.trim(),
        'annual_revenue': _annualRevenueController.text.trim(),
        'source': _source,
        'status': _status,
        'priority': _priority,
        'assigned_to': _assignedTo,
        'interested_product':
            _interestedProductController.text.trim(),
        'expected_value':
            double.tryParse(_expectedValueController.text.trim()) ??
                0,
        'expected_closing_date': expectedClosing,
        'country': _countryController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'notes': _notesController.text.trim(),
        'tags': tags,
        'last_contact': null,
        'next_follow_up': nextFollowUp,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'tenant_id': tenantId,
        'converted_to_type': null,
        'converted_to_id': null,
      };

      await _supabase.from('leads').insert(payload);

      if (!mounted) return;

      final name =
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
              .trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            name.isEmpty
                ? 'Lead added successfully'
                : '$name added successfully',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add lead: $e'),
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
          'Add Lead',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Lead Information', Icons.person_outline),
            _field(
              _idController,
              'Lead ID',
              Icons.badge_outlined,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _firstNameController,
                    'First Name',
                    Icons.person_outline,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _lastNameController,
                    'Last Name',
                    Icons.person_outline,
                  ),
                ),
              ],
            ),
            _field(
              _companyController,
              'Company',
              Icons.apartment_outlined,
              required: true,
            ),
            _field(
              _designationController,
              'Designation',
              Icons.work_outline,
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Industry',
                    value: _industry,
                    items: _industries,
                    onChanged: (v) {
                      if (v != null) setState(() => _industry = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _companySizeController,
                    'Company Size',
                    Icons.groups_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Contact Details', Icons.contact_phone_outlined),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _phoneController,
                    'Phone',
                    Icons.phone_outlined,
                    required: true,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _alternatePhoneController,
                    'Alternate Phone',
                    Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            _field(
              _emailController,
              'Email',
              Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            _field(
              _websiteController,
              'Website',
              Icons.language_outlined,
            ),
            _field(
              _gstController,
              'GST Number',
              Icons.receipt_long_outlined,
            ),
            const SizedBox(height: 8),
            _sectionTitle('Lead Classification', Icons.category_outlined),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Source',
                    value: _source,
                    items: _sources,
                    onChanged: (v) {
                      if (v != null) setState(() => _source = v);
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
            _sectionTitle('Opportunity Details', Icons.trending_up),
            _field(
              _interestedProductController,
              'Interested Product',
              Icons.inventory_2_outlined,
            ),
            _field(
              _annualRevenueController,
              'Annual Revenue',
              Icons.account_balance_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _expectedValueController,
                    'Expected Value',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateField(
                    _expectedClosingController,
                    'Expected Closing',
                    Icons.event_outlined,
                  ),
                ),
              ],
            ),
            _dateField(
              _nextFollowUpController,
              'Next Follow-up',
              Icons.event_available_outlined,
            ),
            const SizedBox(height: 8),
            _sectionTitle('Location', Icons.location_on_outlined),
            _field(
              _addressController,
              'Address',
              Icons.home_outlined,
              maxLines: 2,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _cityController,
                    'City',
                    Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _stateController,
                    'State',
                    Icons.map_outlined,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _countryController,
                    'Country',
                    Icons.public_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _pincodeController,
                    'Pincode',
                    Icons.pin_drop_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Notes', Icons.notes_outlined),
            _field(
              _tagsController,
              'Tags (comma separated)',
              Icons.label_outline,
            ),
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
                onPressed: _saving ? null : _saveLead,
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
                  _saving ? 'Saving...' : 'Add Lead',
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
          Icon(
            icon,
            size: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
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
