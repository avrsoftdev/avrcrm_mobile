import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sellingPriceController = TextEditingController(text: '0');
  final _costPriceController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '18');
  final _stockController = TextEditingController(text: '0');
  final _unitController = TextEditingController(text: 'Unit');

  String _category = 'General';
  String _status = 'Active';
  bool _saving = false;

  static const _categories = [
    'ERP',
    'CRM',
    'Automation',
    'Inventory',
    'Supply Chain',
    'Project',
    'Retail',
    'Finance',
    'Logistics',
    'General',
  ];

  static const _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    _idController = TextEditingController(text: 'PRD-$stamp');
    _skuController.text = 'SKU-$stamp';
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _taxController.dispose();
    _stockController.dispose();
    _unitController.dispose();
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final name = _nameController.text.trim();
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();
      final imageText = name.length >= 2
          ? name.substring(0, 2).toUpperCase()
          : name.toUpperCase();

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'name': name,
        'sku': _skuController.text.trim(),
        'category': _category,
        'description': _descriptionController.text.trim(),
        'selling_price':
            double.tryParse(_sellingPriceController.text.trim()) ?? 0,
        'cost_price':
            double.tryParse(_costPriceController.text.trim()) ?? 0,
        'tax': double.tryParse(_taxController.text.trim()) ?? 18,
        'stock': int.tryParse(_stockController.text.trim()) ?? 0,
        'unit': _unitController.text.trim().isEmpty
            ? 'Unit'
            : _unitController.text.trim(),
        'status': _status,
        'image_text': imageText.isEmpty ? 'PR' : imageText,
        'created_at': now,
        'updated_at': now,
        'tenant_id': tenantId,
      };

      await _supabase.from('products').insert(payload);

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
          content: Text('Failed to add product: $e'),
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
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Product Information', Icons.inventory_2_outlined),
            _field(
              _idController,
              'Product ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _nameController,
              'Product Name',
              Icons.label_outline,
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _skuController,
                    'SKU',
                    Icons.qr_code_outlined,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: 'Category',
                    value: _category,
                    items: _categories,
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                ),
              ],
            ),
            _field(
              _descriptionController,
              'Description',
              Icons.notes_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            _sectionTitle('Pricing & Stock', Icons.payments_outlined),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _sellingPriceController,
                    'Selling Price',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _costPriceController,
                    'Cost Price',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _taxController,
                    'Tax %',
                    Icons.percent,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _stockController,
                    'Stock',
                    Icons.warehouse_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _unitController,
                    'Unit',
                    Icons.straighten_outlined,
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
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveProduct,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_box_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Product',
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
