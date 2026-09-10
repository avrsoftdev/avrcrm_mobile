import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddQuotationScreen extends StatefulWidget {
  const AddQuotationScreen({super.key});

  @override
  State<AddQuotationScreen> createState() => _AddQuotationScreenState();
}

class _AddQuotationScreenState extends State<AddQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _customerIdController = TextEditingController();
  final _customerController = TextEditingController();
  final _dateController = TextEditingController();
  final _validUntilController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _totalController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  final _termsController = TextEditingController();
  final _itemProductController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1');
  final _itemPriceController = TextEditingController(text: '0');
  final _itemDiscountController = TextEditingController(text: '0');
  final _itemTaxController = TextEditingController(text: '18');

  String _salesperson = 'Arjun Mehta';
  String _status = 'Draft';
  bool _saving = false;
  bool _autoTotal = true;

  static const _salespeople = [
    'Arjun Mehta',
    'Priya Sharma',
    'Rahul Verma',
    'Vikram Joshi',
    'Rohan Kapoor',
    'Meera Reddy',
  ];

  static const _statuses = [
    'Draft',
    'Sent',
    'Viewed',
    'Accepted',
    'Rejected',
    'Expired',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
    _idController = TextEditingController(
      text: 'QT-${DateTime.now().millisecondsSinceEpoch}',
    );
    _dateController.text = today;
    _amountController.addListener(_recalcTotal);
    _taxController.addListener(_recalcTotal);
    _discountController.addListener(_recalcTotal);
  }

  @override
  void dispose() {
    _amountController.removeListener(_recalcTotal);
    _taxController.removeListener(_recalcTotal);
    _discountController.removeListener(_recalcTotal);
    _idController.dispose();
    _customerIdController.dispose();
    _customerController.dispose();
    _dateController.dispose();
    _validUntilController.dispose();
    _amountController.dispose();
    _taxController.dispose();
    _discountController.dispose();
    _totalController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    _itemProductController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    _itemDiscountController.dispose();
    _itemTaxController.dispose();
    super.dispose();
  }

  void _recalcTotal() {
    if (!_autoTotal) return;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final tax = double.tryParse(_taxController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final total = amount + tax - discount;
    _totalController.text = total.toStringAsFixed(2);
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
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    controller.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveQuotation() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();
      final customerId = _customerIdController.text.trim();
      final validUntil = _validUntilController.text.trim();
      final product = _itemProductController.text.trim();

      final items = <Map<String, dynamic>>[];
      if (product.isNotEmpty) {
        items.add({
          'id': 'QI-${DateTime.now().millisecondsSinceEpoch}',
          'product': product,
          'quantity':
              int.tryParse(_itemQuantityController.text.trim()) ?? 1,
          'price':
              double.tryParse(_itemPriceController.text.trim()) ?? 0,
          'discount':
              double.tryParse(_itemDiscountController.text.trim()) ?? 0,
          'tax': double.tryParse(_itemTaxController.text.trim()) ?? 18,
        });
      }

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'customer_id': customerId.isEmpty ? null : customerId,
        'customer': _customerController.text.trim(),
        'date': _dateController.text.trim(),
        'valid_until': validUntil.isEmpty ? null : validUntil,
        'items': items,
        'amount': double.tryParse(_amountController.text.trim()) ?? 0,
        'tax': double.tryParse(_taxController.text.trim()) ?? 0,
        'discount':
            double.tryParse(_discountController.text.trim()) ?? 0,
        'total': double.tryParse(_totalController.text.trim()) ?? 0,
        'salesperson': _salesperson,
        'status': _status,
        'notes': _notesController.text.trim(),
        'terms': _termsController.text.trim(),
        'converted_from_type': null,
        'converted_from_id': null,
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('quotations').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${payload['id']} added successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add quotation: $e'),
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
          'Add Quotation',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Quotation Details', Icons.description_outlined),
            _field(
              _idController,
              'Quote ID',
              Icons.badge_outlined,
              required: true,
            ),
            _field(
              _customerController,
              'Customer',
              Icons.business_outlined,
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
                  child: _dateField(
                    _dateController,
                    'Date',
                    Icons.event_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateField(
                    _validUntilController,
                    'Valid Until',
                    Icons.event_available_outlined,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Salesperson',
                    value: _salesperson,
                    items: _salespeople,
                    onChanged: (v) {
                      if (v != null) setState(() => _salesperson = v);
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
            const SizedBox(height: 8),
            _sectionTitle('Line Item (optional)', Icons.list_alt_outlined),
            _field(
              _itemProductController,
              'Product',
              Icons.inventory_2_outlined,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _itemQuantityController,
                    'Quantity',
                    Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _itemPriceController,
                    'Price',
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
                    _itemDiscountController,
                    'Item Discount %',
                    Icons.discount_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _itemTaxController,
                    'Item Tax %',
                    Icons.percent,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Amounts', Icons.payments_outlined),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _amountController,
                    'Amount',
                    Icons.currency_rupee,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _taxController,
                    'Tax',
                    Icons.receipt_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    _discountController,
                    'Discount',
                    Icons.discount_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _totalController,
                    'Total',
                    Icons.calculate_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto-calculate total'),
              subtitle: const Text('Total = Amount + Tax − Discount'),
              value: _autoTotal,
              onChanged: (v) {
                setState(() {
                  _autoTotal = v;
                  if (v) _recalcTotal();
                });
              },
            ),
            const SizedBox(height: 8),
            _sectionTitle('Notes & Terms', Icons.notes_outlined),
            _field(
              _notesController,
              'Notes',
              Icons.sticky_note_2_outlined,
              maxLines: 3,
            ),
            _field(
              _termsController,
              'Terms',
              Icons.gavel_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveQuotation,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.description_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Quotation',
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
