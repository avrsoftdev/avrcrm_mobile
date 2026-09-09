import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _companyController = TextEditingController();
  final _primaryContactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _gstController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController(text: 'India');
  final _ordersController = TextEditingController(text: '0');
  final _revenueController = TextEditingController(text: '0');
  final _outstandingController = TextEditingController(text: '0');

  String _industry = 'IT & Software';
  String _type = 'SMB';
  String _status = 'Active';
  String _accountOwner = 'Arjun Mehta';
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

  static const _types = ['Enterprise', 'SMB', 'Startup', 'Government'];

  static const _statuses = ['Active', 'Inactive', 'Prospect', 'Churned'];

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
      text: 'CUST-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _companyController.dispose();
    _primaryContactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _gstController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _ordersController.dispose();
    _revenueController.dispose();
    _outstandingController.dispose();
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

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final company = _companyController.text.trim();
      final now = DateTime.now().toUtc();
      final tenantId = await _resolveTenantId();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'company': company,
        'logo_text': company.length >= 2
            ? company.substring(0, 2).toUpperCase()
            : company.toUpperCase(),
        'primary_contact': _primaryContactController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'industry': _industry,
        'type': _type,
        'country': _countryController.text.trim(),
        'state': _stateController.text.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        'gst_number': _gstController.text.trim(),
        'total_orders': int.tryParse(_ordersController.text.trim()) ?? 0,
        'total_revenue':
            double.tryParse(_revenueController.text.trim()) ?? 0,
        'outstanding_amount':
            double.tryParse(_outstandingController.text.trim()) ?? 0,
        'account_owner': _accountOwner,
        'status': _status,
        'last_interaction':
            now.toIso8601String().substring(0, 10),
        'website': _websiteController.text.trim(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'tenant_id': tenantId,
      };

      await _supabase.from('customers').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$company added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add customer: $e'),
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
          'Add Customer',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Customer Information', Icons.business_outlined),
            _field(
              _idController,
              'Customer ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _companyController,
              'Company',
              Icons.apartment_outlined,
              required: true,
            ),
            _field(
              _primaryContactController,
              'Primary Contact',
              Icons.person_outline,
              required: true,
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
                  child: _dropdown(
                    label: 'Type',
                    value: _type,
                    items: _types,
                    onChanged: (v) {
                      if (v != null) setState(() => _type = v);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
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
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Account Owner',
                    value: _accountOwner,
                    items: _owners,
                    onChanged: (v) {
                      if (v != null) setState(() => _accountOwner = v);
                    },
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _emailController,
                    'Email',
                    Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
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
            _field(
              _countryController,
              'Country',
              Icons.public_outlined,
            ),
            const SizedBox(height: 8),
            _sectionTitle('Commercial', Icons.payments_outlined),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _ordersController,
                    'Total Orders',
                    Icons.shopping_bag_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _revenueController,
                    'Total Revenue',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _field(
              _outstandingController,
              'Outstanding Amount',
              Icons.account_balance_wallet_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveCustomer,
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
                  _saving ? 'Saving...' : 'Add Customer',
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
