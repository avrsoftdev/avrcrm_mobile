import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_provider.dart';
import '../customers/add_customer_screen.dart';
import 'quotation_model.dart';

class AddQuotationScreen extends StatefulWidget {
  const AddQuotationScreen({super.key, this.quotation});
  final Map<String, dynamic>? quotation;
  @override
  State<AddQuotationScreen> createState() => _AddQuotationScreenState();
}

class _AddQuotationScreenState extends State<AddQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = Supabase.instance.client;
  final _number = TextEditingController();
  final _date = TextEditingController();
  final _expiry = TextEditingController();
  final _notes = TextEditingController();
  final _terms = TextEditingController();
  final _customerName = TextEditingController();
  final _customerId = TextEditingController();
  final List<_LineDraft> _lines = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _products = [];
  String _status = 'Draft';
  String? _tenant;
  bool _saving = false;
  bool _dirty = false;

  bool get _editing => widget.quotation != null;
  QuotationTotals get _totals =>
      QuotationTotals.fromLines(_lines.map((e) => e.value));

  @override
  void initState() {
    super.initState();
    final q = widget.quotation;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    _number.text = (q?['id'] ?? quotationNumber()).toString();
    _date.text = (q?['date'] ?? today).toString();
    _expiry.text = (q?['valid_until'] ?? '').toString();
    _notes.text = (q?['notes'] ?? '').toString();
    _terms.text = (q?['terms'] ?? '').toString();
    _customerName.text = (q?['customer'] ?? '').toString();
    _customerId.text = (q?['customer_id'] ?? '').toString();
    _status = (q?['status'] ?? 'Draft').toString();
    final raw = q?['items'];
    if (raw is List) {
      for (final item in raw.whereType<Map>()) {
        _lines.add(_LineDraft.fromLine(
            QuotationLine.fromMap(Map<String, dynamic>.from(item))));
      }
    }
    if (_lines.isEmpty) _lines.add(_LineDraft());
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadChoices());
  }

  Future<void> _loadChoices() async {
    _tenant = context.read<AuthProvider>().user?.tenantId.trim();
    if (_tenant == null || _tenant!.isEmpty) return;
    try {
      final results = await Future.wait([
        _db
            .from('customers')
            .select()
            .eq('tenant_id', _tenant!)
            .order('company'),
        _db.from('products').select().eq('tenant_id', _tenant!).order('name'),
      ]);
      if (mounted)
        setState(() {
          _customers = List<Map<String, dynamic>>.from(results[0]);
          _products = List<Map<String, dynamic>>.from(results[1]);
        });
    } catch (_) {
      /* Selection remains available through manual customer/item entry. */
    }
  }

  @override
  void dispose() {
    _number.dispose();
    _date.dispose();
    _expiry.dispose();
    _notes.dispose();
    _terms.dispose();
    _customerName.dispose();
    _customerId.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  Future<bool> _confirmLeave() async {
    if (!_dirty || _saving) return true;
    return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Discard changes?'),
                  content: const Text(
                      'Your unsaved quotation changes will be lost.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Keep editing')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Discard'))
                  ],
                )) ??
        false;
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(controller.text) ?? now;
    final result = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(now.year - 5),
        lastDate: DateTime(now.year + 10));
    if (result != null) {
      controller.text = result.toIso8601String().substring(0, 10);
      _markDirty();
    }
  }

  void _markDirty() {
    _dirty = true;
    if (mounted) setState(() {});
  }

  Future<void> _chooseCustomer() async {
    if (_customers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'No customers are available. Enter the customer name manually.')));
      return;
    }
    final selected = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SafeArea(
                child: ListView(shrinkWrap: true, children: [
              const ListTile(
                  title: Text('Select customer',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              ..._customers.map((customer) => ListTile(
                  title: Text((customer['company'] ??
                          customer['name'] ??
                          'Unnamed customer')
                      .toString()),
                  subtitle: Text(
                      (customer['primary_contact'] ?? customer['email'] ?? '')
                          .toString()),
                  onTap: () => Navigator.pop(context, customer))),
            ])));
    if (selected == null) return;
    _customerName.text =
        (selected['company'] ?? selected['name'] ?? '').toString();
    _customerId.text = (selected['id'] ?? '').toString();
    _markDirty();
  }

  Future<void> _createCustomer() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
    );
    if (created != true || !mounted) return;
    await _loadChoices();
    if (mounted && _customers.isNotEmpty) await _chooseCustomer();
  }

  Future<void> _chooseProduct(int index) async {
    if (_products.isEmpty) return;
    final product = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SafeArea(
                child: ListView(shrinkWrap: true, children: [
              const ListTile(
                  title: Text('Select product or service',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              ..._products.map((p) => ListTile(
                  title: Text(
                      (p['name'] ?? p['product_name'] ?? 'Product').toString()),
                  subtitle:
                      Text('Unit price: ${p['price'] ?? p['unit_price'] ?? 0}'),
                  onTap: () => Navigator.pop(context, p))),
            ])));
    if (product == null) return;
    setState(() {
      _lines[index].description.text =
          (product['name'] ?? product['product_name'] ?? '').toString();
      _lines[index].price.text =
          (product['price'] ?? product['unit_price'] ?? 0).toString();
      _dirty = true;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final lines = _lines.map((e) => e.value).toList();
    if (lines.isEmpty || lines.any((line) => !isValidQuotationLine(line))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Review the line items and correct invalid values.')));
      return;
    }
    if (_tenant == null || _tenant!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Your workspace assignment could not be verified.')));
      return;
    }
    setState(() => _saving = true);
    try {
      final totals = QuotationTotals.fromLines(lines);
      final payload = <String, dynamic>{
        'id': _number.text.trim(),
        'tenant_id': _tenant,
        'customer_id':
            _customerId.text.trim().isEmpty ? null : _customerId.text.trim(),
        'customer': _customerName.text.trim(),
        'date': _date.text.trim(),
        'valid_until': _expiry.text.trim().isEmpty ? null : _expiry.text.trim(),
        'items': lines.map((line) => line.toMap()).toList(),
        'amount': totals.subtotal - totals.discount,
        'discount': totals.discount,
        'tax': totals.tax,
        'total': totals.total,
        'status': _status,
        'salesperson': widget.quotation?['salesperson'] ??
            context.read<AuthProvider>().user?.name ??
            '',
        'notes': _notes.text.trim(),
        'terms': _terms.text.trim(),
        'converted_from_type': widget.quotation?['converted_from_type'],
        'converted_from_id': widget.quotation?['converted_from_id'],
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      if (_editing) {
        await _db
            .from('quotations')
            .update(payload)
            .eq('id', _number.text.trim())
            .eq('tenant_id', _tenant!);
      } else {
        payload['created_at'] = DateTime.now().toUtc().toIso8601String();
        await _db.from('quotations').insert(payload);
      }
      if (!mounted) return;
      _dirty = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_editing
              ? 'Quotation updated.'
              : 'Quotation saved as $_status.')));
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Could not save quotation: $e'),
            backgroundColor: Colors.red.shade700));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _confirmLeave() && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar:
            AppBar(title: Text(_editing ? 'Edit Quotation' : 'New Quotation')),
        body: Form(
            key: _formKey,
            child: ListView(padding: const EdgeInsets.all(16), children: [
              _section('Quotation details'),
              TextFormField(
                  controller: _number,
                  decoration:
                      const InputDecoration(labelText: 'Quotation number'),
                  onChanged: (_) => _markDirty(),
                  validator: _required('Quotation number')),
              const SizedBox(height: 12),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: TextFormField(
                        controller: _customerName,
                        decoration: InputDecoration(
                            labelText: 'Customer',
                            suffixIcon: IconButton(
                                tooltip: 'Choose customer',
                                onPressed: _chooseCustomer,
                                icon: const Icon(Icons.contacts_outlined))),
                        onChanged: (_) => _markDirty(),
                        validator: _required('Customer'))),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Create customer',
                  onPressed: _createCustomer,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _dateInput(_date, 'Issue date')),
                const SizedBox(width: 12),
                Expanded(child: _dateInput(_expiry, 'Valid until'))
              ]),
              DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    'Draft',
                    'Sent',
                    'Viewed',
                    'Accepted',
                    'Rejected',
                    'Expired'
                  ]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _status = value);
                      _markDirty();
                    }
                  }),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: _section('Line items')),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _lines.add(_LineDraft());
                        _dirty = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add item'))
              ]),
              ...List.generate(_lines.length, _buildLine),
              const SizedBox(height: 12),
              _totalsCard(),
              const SizedBox(height: 24),
              _section('Additional information'),
              TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Optional message for the customer'),
                  onChanged: (_) => _markDirty()),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _terms,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(labelText: 'Terms and conditions'),
                  onChanged: (_) => _markDirty()),
              const SizedBox(height: 24),
              FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_outlined),
                  label: Text(_saving
                      ? 'Saving…'
                      : _editing
                          ? 'Save changes'
                          : 'Save quotation')),
              const SizedBox(height: 32),
            ])),
      ));

  Widget _buildLine(int index) {
    final line = _lines[index];
    Widget input(TextEditingController c, String label,
            {bool number = false}) =>
        TextFormField(
            controller: c,
            keyboardType: number
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            decoration: InputDecoration(labelText: label),
            onChanged: (_) => _markDirty(),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return '$label is required';
              if (number) {
                final n = double.tryParse(value);
                if (n == null || !n.isFinite || n < 0)
                  return 'Enter a valid non-negative number';
                if (label == 'Quantity' && n == 0)
                  return 'Quantity must be greater than 0';
                if ((label == 'Discount %' || label == 'Tax %') && n > 100)
                  return 'Cannot exceed 100%';
              }
              return null;
            });
    return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: Text('Item ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                if (_products.isNotEmpty)
                  IconButton(
                      tooltip: 'Choose product',
                      onPressed: () => _chooseProduct(index),
                      icon: const Icon(Icons.inventory_2_outlined)),
                IconButton(
                    tooltip: 'Move up',
                    onPressed: index == 0
                        ? null
                        : () {
                            setState(() {
                              final item = _lines.removeAt(index);
                              _lines.insert(index - 1, item);
                              _dirty = true;
                            });
                          },
                    icon: const Icon(Icons.keyboard_arrow_up)),
                IconButton(
                    tooltip: 'Move down',
                    onPressed: index == _lines.length - 1
                        ? null
                        : () {
                            setState(() {
                              final item = _lines.removeAt(index);
                              _lines.insert(index + 1, item);
                              _dirty = true;
                            });
                          },
                    icon: const Icon(Icons.keyboard_arrow_down)),
                IconButton(
                    tooltip: 'Remove item',
                    onPressed: _lines.length == 1
                        ? null
                        : () {
                            setState(() {
                              _lines.removeAt(index).dispose();
                              _dirty = true;
                            });
                          },
                    icon: const Icon(Icons.delete_outline))
              ]),
              input(line.description, 'Description'),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: input(line.quantity, 'Quantity', number: true)),
                const SizedBox(width: 8),
                Expanded(child: input(line.price, 'Unit price', number: true))
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                    child: input(line.discount, 'Discount %', number: true)),
                const SizedBox(width: 8),
                Expanded(child: input(line.tax, 'Tax %', number: true))
              ]),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      'Line total: ${line.value.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w700))),
            ])));
  }

  Widget _section(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800)));
  Widget _dateInput(TextEditingController c, String label) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
          controller: c,
          readOnly: true,
          onTap: () => _pickDate(c),
          validator: label == 'Issue date' ? _required(label) : null,
          decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.calendar_month_outlined))));
  String? Function(String?) _required(String label) => (value) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;
  Widget _totalsCard() {
    final t = _totals;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _totalRow('Subtotal', t.subtotal),
              _totalRow('Discount', -t.discount),
              _totalRow('Tax', t.tax),
              const Divider(),
              _totalRow('Grand total', t.total, bold: true)
            ])));
  }

  Widget _totalRow(String label, double value, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: TextStyle(fontWeight: bold ? FontWeight.bold : null))),
        Text(value.toStringAsFixed(2),
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null))
      ]));
}

class _LineDraft {
  _LineDraft(
      {String description = '',
      String quantity = '1',
      String price = '0',
      String discount = '0',
      String tax = '18'})
      : description = TextEditingController(text: description),
        quantity = TextEditingController(text: quantity),
        price = TextEditingController(text: price),
        discount = TextEditingController(text: discount),
        tax = TextEditingController(text: tax);
  final TextEditingController description, quantity, price, discount, tax;
  factory _LineDraft.fromLine(QuotationLine line) => _LineDraft(
      description: line.description,
      quantity: line.quantity.toString(),
      price: line.unitPrice.toString(),
      discount: line.discountPercent.toString(),
      tax: line.taxPercent.toString());
  QuotationLine get value => QuotationLine(
      description: description.text,
      quantity: double.tryParse(quantity.text) ?? 0,
      unitPrice: double.tryParse(price.text) ?? 0,
      discountPercent: double.tryParse(discount.text) ?? 0,
      taxPercent: double.tryParse(tax.text) ?? 0);
  void dispose() {
    description.dispose();
    quantity.dispose();
    price.dispose();
    discount.dispose();
    tax.dispose();
  }
}
