import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  late final TextEditingController _idController;
  final _customerController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _dateController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  final _taxController = TextEditingController(text: '0');
  final _totalController = TextEditingController(text: '0');
  final _paidController = TextEditingController(text: '0');
  final _balanceController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  final _termsController = TextEditingController();
  final _itemProductController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1');
  final _itemPriceController = TextEditingController(text: '0');

  String _status = 'Draft';
  bool _saving = false;
  bool _autoCalc = true;

  static const _statuses = [
    'Draft',
    'Sent',
    'Pending',
    'Partial',
    'Paid',
    'Overdue',
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
      text: 'INV-${DateTime.now().millisecondsSinceEpoch}',
    );
    _dateController.text = today;
    _invoiceDateController.text = today;
    _amountController.addListener(_recalc);
    _taxController.addListener(_recalc);
    _paidController.addListener(_recalc);
  }

  @override
  void dispose() {
    _amountController.removeListener(_recalc);
    _taxController.removeListener(_recalc);
    _paidController.removeListener(_recalc);
    _idController.dispose();
    _customerController.dispose();
    _customerIdController.dispose();
    _dateController.dispose();
    _invoiceDateController.dispose();
    _dueDateController.dispose();
    _amountController.dispose();
    _taxController.dispose();
    _totalController.dispose();
    _paidController.dispose();
    _balanceController.dispose();
    _notesController.dispose();
    _termsController.dispose();
    _itemProductController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  void _recalc() {
    if (!_autoCalc) return;
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final tax = double.tryParse(_taxController.text.trim()) ?? 0;
    final paid = double.tryParse(_paidController.text.trim()) ?? 0;
    final total = amount + tax;
    _totalController.text = total.toStringAsFixed(2);
    _balanceController.text = (total - paid).toStringAsFixed(2);
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

  Future<void> _saveInvoice() async {
    if (!_formKey.currentState!.validate() || _saving) return;

    setState(() => _saving = true);

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final tenantId = await _resolveTenantId();
      final customerId = _customerIdController.text.trim();
      final dueDate = _dueDateController.text.trim();
      final invoiceDate = _invoiceDateController.text.trim();
      final product = _itemProductController.text.trim();

      final items = <Map<String, dynamic>>[];
      if (product.isNotEmpty) {
        items.add({
          'id': 'II-${DateTime.now().millisecondsSinceEpoch}',
          'product': product,
          'quantity':
              int.tryParse(_itemQuantityController.text.trim()) ?? 1,
          'price':
              double.tryParse(_itemPriceController.text.trim()) ?? 0,
        });
      }

      final payload = <String, dynamic>{
        'id': _idController.text.trim(),
        'tenant_id': tenantId,
        'customer_id': customerId.isEmpty ? null : customerId,
        'customer': _customerController.text.trim(),
        'invoice_date': invoiceDate.isEmpty ? null : invoiceDate,
        'due_date': dueDate.isEmpty ? null : dueDate,
        'date': _dateController.text.trim(),
        'amount': double.tryParse(_amountController.text.trim()) ?? 0,
        'tax': double.tryParse(_taxController.text.trim()) ?? 0,
        'total': double.tryParse(_totalController.text.trim()) ?? 0,
        'paid': double.tryParse(_paidController.text.trim()) ?? 0,
        'balance':
            double.tryParse(_balanceController.text.trim()) ?? 0,
        'status': _status,
        'items': items,
        'notes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        'terms': _termsController.text.trim().isEmpty
            ? null
            : _termsController.text.trim(),
        'converted_from_type': null,
        'converted_from_id': null,
        'created_at': now,
        'updated_at': now,
      };

      await _supabase.from('invoices').insert(payload);

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
          content: Text('Failed to create invoice: $e'),
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
          'Create Invoice',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Invoice Details', Icons.receipt_long_outlined),
            _field(
              _idController,
              'Invoice ID',
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
                    _invoiceDateController,
                    'Invoice Date',
                    Icons.event_available_outlined,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    _dueDateController,
                    'Due Date',
                    Icons.event_busy_outlined,
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
                    _totalController,
                    'Total',
                    Icons.calculate_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    _paidController,
                    'Paid',
                    Icons.payments_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _field(
              _balanceController,
              'Balance',
              Icons.account_balance_wallet_outlined,
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Auto-calculate totals'),
              subtitle: const Text('Total = Amount + Tax; Balance = Total − Paid'),
              value: _autoCalc,
              onChanged: (v) {
                setState(() {
                  _autoCalc = v;
                  if (v) _recalc();
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
                onPressed: _saving ? null : _saveInvoice,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.receipt_long_outlined),
                label: Text(
                  _saving ? 'Saving...' : 'Create Invoice',
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
