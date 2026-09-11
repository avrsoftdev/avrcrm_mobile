import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddSalesOrderScreen extends StatefulWidget {
  const AddSalesOrderScreen({super.key});

  @override
  State<AddSalesOrderScreen> createState() => _AddSalesOrderScreenState();
}

class _AddSalesOrderScreenState extends State<AddSalesOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _customerController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '0');
  final _totalController = TextEditingController(text: '0');
  final _deliveryDateController = TextEditingController();
  final _itemProductController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1');
  final _itemPriceController = TextEditingController(text: '0');

  String _paymentTerms = 'Net 30';
  String _salesperson = 'Arjun Mehta';
  String _status = 'Pending';
  bool _saving = false;
  bool _autoCalc = true;

  static const _paymentTermsOptions = [
    'Net 15',
    'Net 30',
    'Net 45',
    'Net 60',
    '50% Advance',
    '100% Advance',
    'On Delivery',
  ];

  static const _statuses = [
    'Pending',
    'Confirmed',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  static const _salespeople = [
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
      text: 'SO-${DateTime.now().millisecondsSinceEpoch}',
    );
    _quantityController.addListener(_recalc);
    _priceController.addListener(_recalc);
    _discountController.addListener(_recalc);
    _taxController.addListener(_recalc);
  }

  @override
  void dispose() {
    _quantityController.removeListener(_recalc);
    _priceController.removeListener(_recalc);
    _discountController.removeListener(_recalc);
    _taxController.removeListener(_recalc);
    _idController.dispose();
    _customerController.dispose();
    _customerIdController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    _totalController.dispose();
    _deliveryDateController.dispose();
    _itemProductController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  void _recalc() {
    if (!_autoCalc) return;
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final tax = double.tryParse(_taxController.text.trim()) ?? 0;
    final subtotal = qty * price;
    final total = subtotal - discount + tax;
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    _deliveryDateController.text =
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();
      final customerId = _customerIdController.text.trim();
      final deliveryDate = _deliveryDateController.text.trim();
      final product = _itemProductController.text.trim();

      final qty = int.tryParse(_quantityController.text.trim()) ?? 1;
      final price = double.tryParse(_priceController.text.trim()) ?? 0;
      final discount =
          double.tryParse(_discountController.text.trim()) ?? 0;
      final tax = double.tryParse(_taxController.text.trim()) ?? 0;
      final total = double.tryParse(_totalController.text.trim()) ?? 0;

      final items = <Map<String, dynamic>>[];
      if (product.isNotEmpty) {
        items.add({
          'id': 'OI-${DateTime.now().millisecondsSinceEpoch}-1',
          'product': product,
          'quantity':
              int.tryParse(_itemQuantityController.text.trim()) ?? qty,
          'price':
              double.tryParse(_itemPriceController.text.trim()) ?? price,
        });
      } else {
        items.add({
          'id': 'OI-${DateTime.now().millisecondsSinceEpoch}-1',
          'product': 'Line item',
          'quantity': qty,
          'price': price,
        });
      }

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'customer_id': customerId,
        'customer': _customerController.text.trim(),
        'items': items,
        'quantity': qty,
        'price': price,
        'discount': discount,
        'tax': tax,
        'total': total,
        'payment_terms': _paymentTerms,
        'delivery_date': deliveryDate,
        'salesperson': _salesperson,
        'status': _status,
        'converted_from_type': null,
        'converted_from_id': null,
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('sales_orders').insert(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${payload['id']} created successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create sales order: $e'),
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
          'Add Sales Order',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Order Details', Icons.shopping_cart_outlined),
            _field(
              _idController,
              'Order ID',
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
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: 'Payment Terms',
                    value: _paymentTerms,
                    items: _paymentTermsOptions,
                    onChanged: (v) {
                      if (v != null) setState(() => _paymentTerms = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateField(
                    _deliveryDateController,
                    'Delivery Date',
                    Icons.local_shipping_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _sectionTitle('Line Item', Icons.list_alt_outlined),
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
                    'Item Qty',
                    Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _itemPriceController,
                    'Item Price',
                    Icons.currency_rupee,
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
                    _quantityController,
                    'Quantity',
                    Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _priceController,
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
                    _discountController,
                    'Discount',
                    Icons.discount_outlined,
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
            _field(
              _totalController,
              'Total',
              Icons.calculate_outlined,
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto-calculate total'),
              subtitle: const Text('Total = (Qty × Price) − Discount + Tax'),
              value: _autoCalc,
              onChanged: (v) {
                setState(() {
                  _autoCalc = v;
                  if (v) _recalc();
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveOrder,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.shopping_cart_checkout_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Add Sales Order',
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
