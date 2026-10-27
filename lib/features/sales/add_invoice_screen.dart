
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_provider.dart';
import 'gst_invoice_model.dart';
import 'invoice_pdf_service.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key, this.invoice});

  final Map<String, dynamic>? invoice;

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = Supabase.instance.client;
  final Map<String, TextEditingController> _fields = {};
  final List<_InvoiceLineDraft> _lines = [];
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _products = [];
  String? _tenantId;
  String? _customerId;
  String _invoiceType = 'Tax Invoice';
  String _transactionType = 'Intra-state';
  String _paymentMode = 'Bank Transfer';
  String _status = 'Draft';
  bool _sameShipping = true;
  bool _loading = true;
  bool _saving = false;
  bool _downloading = false;
  String? _loadError;

  bool get _editing => widget.invoice != null;
  bool get _interState => _transactionType == 'Inter-state';

  static const _supplierKeys = [
    'supplier_legal_name',
    'supplier_gstin',
    'supplier_address',
    'supplier_state',
    'supplier_pin_code',
    'supplier_phone',
    'supplier_email',
  ];
  static const _billingKeys = [
    'billing_name',
    'billing_gstin',
    'billing_phone',
    'billing_email',
    'billing_address',
    'billing_city',
    'billing_district',
    'billing_state',
    'billing_pin_code',
    'billing_country',
  ];
  static const _shippingKeys = [
    'shipping_name',
    'shipping_gstin',
    'shipping_address',
    'shipping_city',
    'shipping_state',
    'shipping_pin_code',
    'shipping_country',
  ];
  static const _bankKeys = [
    'bank_name',
    'account_holder',
    'account_number',
    'ifsc',
    'branch',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final invoice = widget.invoice;
    final number = _value(invoice, const ['invoice_number', 'id'])
        .ifEmpty('INV-${now.millisecondsSinceEpoch}');
    _put('invoice_number', number);
    _put('invoice_type',
        _value(invoice, const ['invoice_type']).ifEmpty('Tax Invoice'));
    _put('invoice_date',
        _value(invoice, const ['invoice_date', 'date']).ifEmpty(today));
    _put('due_date', _value(invoice, const ['due_date']));
    _put('payment_terms', _value(invoice, const ['payment_terms', 'terms']));
    _put('po_number', _value(invoice, const ['po_number', 'reference_number']));
    _put('place_of_supply', _value(invoice, const ['place_of_supply']));
    _put('state_code', _value(invoice, const ['state_code']));
    _put('subject', _value(invoice, const ['subject', 'description']));
    _put('freight',
        _value(invoice, const ['freight', 'freight_charges'], fallback: '0'));
    _put('adjustment',
        _value(invoice, const ['adjustment', 'round_off'], fallback: '0'));
    _put('amount_paid',
        _value(invoice, const ['amount_paid', 'paid'], fallback: '0'));
    _put('notes', _value(invoice, const ['notes']));
    _put('terms', _value(invoice, const ['terms']));
    _put('customer', _value(invoice, const ['customer', 'billing_name']));
    _customerId = _value(invoice, const ['customer_id']).ifEmpty(null);
    _invoiceType = _fieldText(invoice, 'invoice_type').ifEmpty('Tax Invoice');
    _transactionType = _value(invoice, const ['gst_transaction_type'])
            .toLowerCase()
            .contains('inter')
        ? 'Inter-state'
        : 'Intra-state';
    _paymentMode =
        _value(invoice, const ['payment_mode']).ifEmpty('Bank Transfer');
    _status = _value(invoice, const ['status']).ifEmpty('Draft');
    _sameShipping = invoice == null || invoice['same_as_billing'] == true;
    for (final key in [
      ..._supplierKeys,
      ..._billingKeys,
      ..._shippingKeys,
      ..._bankKeys
    ]) {
      _put(key, _value(invoice, [key]));
    }
    _put('supplier_legal_name',
        _value(invoice, const ['supplier_legal_name', 'company_name']));
    _put('billing_name', _value(invoice, const ['billing_name', 'customer']));
    final rawItems = invoice?['items'];
    if (rawItems is List) {
      for (final raw in rawItems.whereType<Map>()) {
        _lines.add(_InvoiceLineDraft.fromMap(Map<String, dynamic>.from(raw)));
      }
    }
    if (_lines.isEmpty) _lines.add(_InvoiceLineDraft());
    _tenantId = context.read<AuthProvider>().user?.tenantId.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  String _fieldText(Map<String, dynamic>? row, String key) =>
      row?[key]?.toString() ?? '';

  void _put(String key, String value) {
    _fields[key] = TextEditingController(text: value);
  }

  TextEditingController _controller(String key) =>
      _fields.putIfAbsent(key, TextEditingController.new);

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    final tenant = _tenantId;
    if (tenant == null || tenant.isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Your workspace assignment could not be verified.';
        });
      }
      return;
    }
    try {
      final results = await Future.wait<dynamic>([
        _db.from('customers').select().eq('tenant_id', tenant).order('company'),
        _db.from('products').select().eq('tenant_id', tenant).order('name'),
        _db
            .from('profiles')
            .select()
            .eq('id', _db.auth.currentUser!.id)
            .maybeSingle(),
      ]);
      final customers = List<Map<String, dynamic>>.from(results[0] as List);
      final products = List<Map<String, dynamic>>.from(results[1] as List);
      final profile = results[2] as Map<String, dynamic>?;
      if (widget.invoice == null && profile != null) {
        _populateSupplier(profile);
      }
      if (mounted) {
        setState(() {
          _customers = customers;
          _products = products;
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadError = 'Could not load tenant customers/products: $error';
        });
      }
    }
  }

  void _populateSupplier(Map<String, dynamic> profile) {
    void setIfEmpty(String key, List<String> aliases) {
      if (_controller(key).text.trim().isNotEmpty) return;
      for (final alias in aliases) {
        final value = profile[alias]?.toString().trim() ?? '';
        if (value.isNotEmpty) {
          _controller(key).text = value;
          return;
        }
      }
    }

    setIfEmpty('supplier_legal_name',
        ['legal_name', 'company_name', 'tenant_name', 'full_name']);
    setIfEmpty('supplier_gstin', ['gstin', 'gst_number', 'gst_no']);
    setIfEmpty('supplier_address', ['registered_address', 'address']);
    setIfEmpty('supplier_state', ['business_state', 'state']);
    setIfEmpty('supplier_pin_code', ['pin_code', 'pincode', 'postal_code']);
    setIfEmpty('supplier_phone', ['business_phone', 'phone']);
    setIfEmpty('supplier_email', ['business_email', 'email']);
    setIfEmpty('bank_name', ['bank_name']);
    setIfEmpty('account_holder', ['account_holder', 'bank_account_holder']);
    setIfEmpty('account_number', ['account_number', 'bank_account_number']);
    setIfEmpty('ifsc', ['ifsc', 'ifsc_code']);
    setIfEmpty('branch', ['bank_branch', 'branch']);
  }

  List<GstInvoiceLine> get _invoiceLines =>
      _lines.map((line) => line.value).toList();

  GstInvoiceTotals get _totals => GstInvoiceTotals.calculate(
        lines: _invoiceLines,
        interState: _interState,
        freight: _number('freight'),
        adjustment: _number('adjustment'),
        paid: _number('amount_paid'),
      );

  double _number(String key) =>
      double.tryParse(_controller(key).text.trim()) ?? 0;

  Future<void> _pickDate(String key) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_controller(key).text) ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 20),
    );
    if (date == null) return;
    _controller(key).text = DateFormat('yyyy-MM-dd').format(date);
    setState(() {});
  }

  Future<void> _selectCustomer() async {
    final customer = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .75,
          child: _customers.isEmpty
              ? const Center(
                  child: Text('No customers found in this workspace.'))
              : ListView(
                  children: [
                    const ListTile(title: Text('Select customer')),
                    ..._customers.map(
                      (row) => ListTile(
                        title: Text(_value(row, const ['company', 'name'])
                            .ifEmpty('Unnamed customer')),
                        subtitle: Text(_value(row, const ['email', 'phone'])),
                        onTap: () => Navigator.pop(context, row),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
    if (customer == null) return;
    _customerId = customer['id']?.toString();
    _controller('customer').text = _value(customer, const ['company', 'name']);
    _controller('billing_name').text =
        _value(customer, const ['company', 'name']);
    _controller('billing_gstin').text =
        _value(customer, const ['gst_number', 'gstin', 'gst_no']);
    _controller('billing_phone').text =
        _value(customer, const ['phone', 'mobile']);
    _controller('billing_email').text = _value(customer, const ['email']);
    _controller('billing_address').text =
        _value(customer, const ['address', 'billing_address']);
    _controller('billing_city').text = _value(customer, const ['city']);
    _controller('billing_district').text = _value(customer, const ['district']);
    _controller('billing_state').text = _value(customer, const ['state']);
    _controller('billing_pin_code').text =
        _value(customer, const ['pin_code', 'pincode', 'postal_code', 'zip']);
    _controller('billing_country').text =
        _value(customer, const ['country']).ifEmpty('India');
    if (_sameShipping) _copyBillingToShipping();
    setState(() {});
  }

  Future<void> _selectProduct(int index) async {
    final product = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .75,
          child: _products.isEmpty
              ? const Center(
                  child: Text('No products found in this workspace.'))
              : ListView(
                  children: [
                    const ListTile(title: Text('Select product or service')),
                    ..._products.map(
                      (row) => ListTile(
                        title:
                            Text(_value(row, const ['name', 'product_name'])),
                        subtitle: Text(
                          'Rate: ${_value(row, const [
                                'selling_price',
                                'price',
                                'unit_price'
                              ], fallback: '0')}',
                        ),
                        onTap: () => Navigator.pop(context, row),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
    if (product == null) return;
    final line = _lines[index];
    line.productId = product['id']?.toString();
    line.product.text = _value(product, const ['name', 'product_name']);
    line.description.text =
        _value(product, const ['description', 'name', 'product_name']);
    line.hsnSac.text = _value(product, const ['hsn_sac', 'hsn', 'sac']);
    line.unit.text = _value(product, const ['unit']).ifEmpty('Unit');
    line.rate.text = _value(
        product, const ['selling_price', 'price', 'unit_price'],
        fallback: '0');
    line.gstRate.text = _value(
        product, const ['gst_rate', 'gst_percent', 'tax'],
        fallback: '0');
    setState(() {});
  }

  void _copyBillingToShipping() {
    final copy = <String, String>{
      'shipping_name': 'billing_name',
      'shipping_gstin': 'billing_gstin',
      'shipping_address': 'billing_address',
      'shipping_city': 'billing_city',
      'shipping_state': 'billing_state',
      'shipping_pin_code': 'billing_pin_code',
      'shipping_country': 'billing_country',
    };
    for (final entry in copy.entries) {
      _controller(entry.key).text = _controller(entry.value).text;
    }
  }

  void _billingChanged(String key) {
    if (!_sameShipping) return;
    _copyBillingToShipping();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (_saving || !_formKey.currentState!.validate()) return;
    final tenant = _tenantId;
    final userId = _db.auth.currentUser?.id;
    if (tenant == null || tenant.isEmpty || userId == null) {
      _message('Sign in with a valid workspace to save invoices.', error: true);
      return;
    }
    final lines = _invoiceLines;
    if (lines.isEmpty ||
        lines.any((line) =>
            line.description.trim().isEmpty ||
            line.quantity <= 0 ||
            line.rate < 0 ||
            line.discountPercent < 0 ||
            line.discountPercent > 100 ||
            line.gstRate < 0)) {
      _message(
          'Review line items: quantity must be positive and discount/GST rates valid.',
          error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final totals = _totals;
      final now = DateTime.now().toUtc().toIso8601String();
      final number = _controller('invoice_number').text.trim();
      final oldId = widget.invoice?['id']?.toString();
      final payload = <String, dynamic>{
        'id': oldId ?? number,
        'invoice_number': number,
        'tenant_id': tenant,
        'customer_id': _customerId,
        'customer': _controller('customer').text.trim(),
        'invoice_type': _invoiceType,
        'invoice_date': _controller('invoice_date').text.trim(),
        'date': _controller('invoice_date').text.trim(),
        'due_date': _controller('due_date').text.trim().isEmpty
            ? null
            : _controller('due_date').text.trim(),
        'payment_terms': _controller('payment_terms').text.trim(),
        'po_number': _controller('po_number').text.trim(),
        'place_of_supply': _controller('place_of_supply').text.trim(),
        'state_code': _controller('state_code').text.trim(),
        'gst_transaction_type': _transactionType,
        'supplier_legal_name': _controller('supplier_legal_name').text.trim(),
        'supplier_gstin': _controller('supplier_gstin').text.trim(),
        'supplier_address': _controller('supplier_address').text.trim(),
        'supplier_state': _controller('supplier_state').text.trim(),
        'supplier_pin_code': _controller('supplier_pin_code').text.trim(),
        'supplier_phone': _controller('supplier_phone').text.trim(),
        'supplier_email': _controller('supplier_email').text.trim(),
        'billing_name': _controller('billing_name').text.trim(),
        'billing_gstin': _controller('billing_gstin').text.trim(),
        'billing_phone': _controller('billing_phone').text.trim(),
        'billing_email': _controller('billing_email').text.trim(),
        'billing_address': _controller('billing_address').text.trim(),
        'billing_city': _controller('billing_city').text.trim(),
        'billing_district': _controller('billing_district').text.trim(),
        'billing_state': _controller('billing_state').text.trim(),
        'billing_pin_code': _controller('billing_pin_code').text.trim(),
        'billing_country': _controller('billing_country').text.trim(),
        'same_as_billing': _sameShipping,
        'shipping_name': _controller('shipping_name').text.trim(),
        'shipping_gstin': _controller('shipping_gstin').text.trim(),
        'shipping_address': _controller('shipping_address').text.trim(),
        'shipping_city': _controller('shipping_city').text.trim(),
        'shipping_state': _controller('shipping_state').text.trim(),
        'shipping_pin_code': _controller('shipping_pin_code').text.trim(),
        'shipping_country': _controller('shipping_country').text.trim(),
        'subject': _controller('subject').text.trim(),
        'items':
            lines.map((line) => line.toMap(interState: _interState)).toList(),
        'subtotal': totals.subtotal,
        'amount': totals.subtotal,
        'discount_total': totals.discount,
        'taxable_amount': totals.taxable,
        'cgst': totals.cgst,
        'sgst': totals.sgst,
        'igst': totals.igst,
        'tax': totals.tax,
        'freight': totals.freight,
        'adjustment': totals.adjustment,
        'total': totals.total,
        'amount_in_words': inrAmountInWords(totals.total),
        'payment_mode': _paymentMode,
        'amount_paid': totals.paid,
        'paid': totals.paid,
        'balance': totals.balance,
        'status': _status,
        'bank_name': _controller('bank_name').text.trim(),
        'account_holder': _controller('account_holder').text.trim(),
        'account_number': _controller('account_number').text.trim(),
        'ifsc': _controller('ifsc').text.trim(),
        'branch': _controller('branch').text.trim(),
        'notes': _controller('notes').text.trim(),
        'terms': _controller('terms').text.trim(),
        'updated_at': now,
      };
      if (_editing) {
        await _db
            .from('invoices')
            .update(payload)
            .eq('id', oldId!)
            .eq('tenant_id', tenant);
      } else {
        payload['created_at'] = now;
        payload['created_by'] = userId;
        await _db.from('invoices').insert(payload);
      }
      if (!mounted) return;
      _message(_editing ? 'Invoice updated.' : 'Invoice saved.');
      if (_editing) {
        Navigator.pop(context, true);
      } else {
        final download = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invoice saved'),
            content:
                Text('$number was saved successfully. Download its PDF now?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Done')),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Download PDF'),
              ),
            ],
          ),
        );
        if (download == true) {
          await _downloadPdf(oldId ?? number);
        }
        if (mounted) Navigator.pop(context, true);
      }
    } catch (error) {
      if (mounted) _message('Failed to save invoice: $error', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _downloadPdf(String id) async {
    final tenant = _tenantId;
    if (tenant == null || tenant.isEmpty || _downloading) return;
    setState(() => _downloading = true);
    try {
      final name = await InvoicePdfService()
          .downloadInvoice(invoiceId: id, tenantId: tenant);
      if (mounted) _message('$name saved successfully.');
    } on InvoicePdfSaveCancelledException {
      if (mounted) _message('Saving the invoice PDF was cancelled.');
    } catch (error) {
      if (mounted) _message('Could not save invoice PDF: $error', error: true);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _message(String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? Colors.red.shade700 : null,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final totals = _totals;
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Edit Invoice' : 'Create Invoice')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                children: [
                  if (_loadError != null)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_loadError!),
                      ),
                    ),
                  _section('Invoice details', Icons.receipt_long_outlined),
                  _textField('invoice_number', 'Invoice number',
                      required: true),
                  _choice(
                    'Invoice type',
                    _invoiceType,
                    const [
                      'Tax Invoice',
                      'Bill of Supply',
                      'Export Invoice',
                      'Credit Note',
                      'Debit Note'
                    ],
                    (value) => setState(() => _invoiceType = value),
                  ),
                  _dateField('invoice_date', 'Invoice date', required: true),
                  _dateField('due_date', 'Due date'),
                  _textField('payment_terms', 'Payment terms'),
                  _textField('po_number', 'PO / reference number'),
                  _textField('place_of_supply', 'Place of supply'),
                  _textField('state_code', 'State code'),
                  _choice(
                    'GST transaction type',
                    _transactionType,
                    const ['Intra-state', 'Inter-state'],
                    (value) => setState(() => _transactionType = value),
                  ),
                  _section('Supplier', Icons.store_outlined),
                  _textField('supplier_legal_name', 'Supplier legal name'),
                  _textField('supplier_gstin', 'Supplier GSTIN'),
                  _textField('supplier_address', 'Registered address',
                      maxLines: 2),
                  _textField('supplier_state', 'State'),
                  _textField('supplier_pin_code', 'PIN code',
                      keyboard: TextInputType.number),
                  _textField('supplier_phone', 'Phone',
                      keyboard: TextInputType.phone),
                  _textField('supplier_email', 'Email',
                      keyboard: TextInputType.emailAddress),
                  _section('Customer / billing address', Icons.person_outline),
                  OutlinedButton.icon(
                    onPressed: _selectCustomer,
                    icon: const Icon(Icons.search),
                    label: const Text('Select a customer from this workspace'),
                  ),
                  _textField('customer', 'Customer name', required: true),
                  _textField('billing_name', 'Billing name'),
                  _textField('billing_gstin', 'Customer GSTIN'),
                  _textField('billing_phone', 'Phone',
                      keyboard: TextInputType.phone),
                  _textField('billing_email', 'Email',
                      keyboard: TextInputType.emailAddress),
                  _textField('billing_address', 'Billing address', maxLines: 2),
                  _textField('billing_city', 'City'),
                  _textField('billing_district', 'District'),
                  _textField('billing_state', 'State'),
                  _textField('billing_pin_code', 'PIN code',
                      keyboard: TextInputType.number),
                  _textField('billing_country', 'Country'),
                  _section('Shipping address', Icons.local_shipping_outlined),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Same as billing address'),
                    value: _sameShipping,
                    onChanged: (value) {
                      setState(() {
                        _sameShipping = value;
                        if (value) _copyBillingToShipping();
                      });
                    },
                  ),
                  if (!_sameShipping) ...[
                    _textField('shipping_name', 'Shipping name'),
                    _textField('shipping_gstin', 'Shipping GSTIN'),
                    _textField('shipping_address', 'Shipping address',
                        maxLines: 2),
                    _textField('shipping_city', 'City'),
                    _textField('shipping_state', 'State'),
                    _textField('shipping_pin_code', 'PIN code',
                        keyboard: TextInputType.number),
                    _textField('shipping_country', 'Country'),
                  ],
                  _section('Subject', Icons.subject_outlined),
                  _textField('subject', 'Invoice subject / description',
                      maxLines: 3),
                  _section('Line items', Icons.list_alt_outlined),
                  ..._lines
                      .asMap()
                      .entries
                      .map((entry) => _lineCard(entry.key, entry.value)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _lines.add(_InvoiceLineDraft())),
                      icon: const Icon(Icons.add),
                      label: const Text('Add line item'),
                    ),
                  ),
                  _section('Charges and totals', Icons.calculate_outlined),
                  _textField(
                    'freight',
                    'Freight / transportation charges',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _nonNegativeNumber,
                  ),
                  _textField(
                    'adjustment',
                    'Adjustment / round-off',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _validNumber,
                  ),
                  _totalsPanel(totals),
                  _section('Payment', Icons.payments_outlined),
                  _choice(
                    'Payment mode',
                    _paymentMode,
                    const [
                      'Bank Transfer',
                      'Cash',
                      'UPI',
                      'Cheque',
                      'Card',
                      'Other'
                    ],
                    (value) => setState(() => _paymentMode = value),
                  ),
                  _textField(
                    'amount_paid',
                    'Amount paid',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _nonNegativeNumber,
                  ),
                  _choice(
                      'Status',
                      _status,
                      const [
                        'Draft',
                        'Sent',
                        'Pending',
                        'Partial',
                        'Paid',
                        'Overdue'
                      ],
                      (value) => setState(() => _status = value)),
                  _section('Bank details', Icons.account_balance_outlined),
                  _textField('bank_name', 'Bank name'),
                  _textField('account_holder', 'Account holder'),
                  _textField('account_number', 'Account number',
                      keyboard: TextInputType.number),
                  _textField('ifsc', 'IFSC'),
                  _textField('branch', 'Branch'),
                  _section('Notes and terms', Icons.notes_outlined),
                  _textField('notes', 'Notes', maxLines: 3),
                  _textField('terms', 'Terms and conditions', maxLines: 4),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: Text(_saving
                        ? 'Saving invoice…'
                        : _editing
                            ? 'Save changes'
                            : 'Save invoice'),
                  ),
                  if (_editing) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _downloading
                          ? null
                          : () =>
                              _downloadPdf(widget.invoice!['id'].toString()),
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(
                          _downloading ? 'Preparing PDF…' : 'Download PDF'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _section(String title, IconData icon) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Row(children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700))),
        ]),
      );

  Widget _textField(
    String key,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: _controller(key),
          keyboardType: keyboard,
          maxLines: maxLines,
          onChanged: (_) {
            if (_billingKeys.contains(key)) _billingChanged(key);
            setState(() {});
          },
          validator: validator ??
              (required
                  ? (value) => value == null || value.trim().isEmpty
                      ? '$label is required'
                      : null
                  : null),
          decoration: InputDecoration(labelText: label),
        ),
      );

  Widget _dateField(String key, String label, {bool required = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: _controller(key),
          readOnly: true,
          onTap: () => _pickDate(key),
          validator: required
              ? (value) => value == null || value.trim().isEmpty
                  ? '$label is required'
                  : null
              : null,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
        ),
      );

  Widget _choice(String label, String value, List<String> choices,
          ValueChanged<String> onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DropdownButtonFormField<String>(
          initialValue: choices.contains(value) ? value : choices.first,
          decoration: InputDecoration(labelText: label),
          items: choices
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
        ),
      );

  Widget _lineCard(int index, _InvoiceLineDraft line) {
    Widget field(TextEditingController controller, String label,
            {TextInputType? keyboard, String? Function(String?)? validator}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboard,
            onChanged: (_) => setState(() {}),
            validator: validator,
            decoration: InputDecoration(labelText: label, isDense: true),
          ),
        );
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Text('Item ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w700))),
            IconButton(
              tooltip: 'Select product',
              onPressed: () => _selectProduct(index),
              icon: const Icon(Icons.inventory_2_outlined),
            ),
            if (_lines.length > 1)
              IconButton(
                tooltip: 'Remove item',
                onPressed: () => setState(() {
                  _lines.removeAt(index).dispose();
                }),
                icon: const Icon(Icons.delete_outline),
              ),
          ]),
          field(line.product, 'Product / service'),
          field(line.description, 'Description',
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Description is required'
                  : null),
          field(line.hsnSac, 'HSN / SAC'),
          Row(children: [
            Expanded(
                child: field(line.quantity, 'Quantity',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _positiveNumber)),
            const SizedBox(width: 8),
            Expanded(child: field(line.unit, 'Unit')),
          ]),
          Row(children: [
            Expanded(
                child: field(line.rate, 'Rate',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _nonNegativeNumber)),
            const SizedBox(width: 8),
            Expanded(
                child: field(line.discount, 'Discount %',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _percent)),
          ]),
          Row(children: [
            Expanded(
                child: field(line.gstRate, 'GST rate %',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: _nonNegativeNumber)),
            const SizedBox(width: 8),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Tax ${_money(line.value.tax)} · Total ${_money(line.value.total)}',
                        textAlign: TextAlign.end))),
          ]),
        ]),
      ),
    );
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || number <= 0
        ? 'Enter a quantity greater than 0'
        : null;
  }

  String? _nonNegativeNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || number < 0 ? 'Enter a valid amount' : null;
  }

  String? _validNumber(String? value) {
    return double.tryParse(value?.trim() ?? '') == null
        ? 'Enter a valid amount'
        : null;
  }

  String? _percent(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || number < 0 || number > 100
        ? 'Enter a rate from 0 to 100'
        : null;
  }

  Widget _totalsPanel(GstInvoiceTotals totals) {
    final rows = <(String, double)>[
      ('Subtotal', totals.subtotal),
      ('Discount', -totals.discount),
      ('Taxable amount', totals.taxable),
      if (_interState)
        ('IGST', totals.igst)
      else ...[
        ('CGST', totals.cgst),
        ('SGST', totals.sgst),
      ],
      ('Freight', totals.freight),
      ('Adjustment', totals.adjustment),
      ('Total', totals.total),
      ('Amount paid', totals.paid),
      ('Balance due', totals.balance),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Expanded(
                      child: Text(row.$1,
                          style: row.$1 == 'Total' || row.$1 == 'Balance due'
                              ? const TextStyle(fontWeight: FontWeight.w700)
                              : null)),
                  Text(_money(row.$2),
                      style: row.$1 == 'Total' || row.$1 == 'Balance due'
                          ? const TextStyle(fontWeight: FontWeight.w700)
                          : null),
                ]),
              )),
          const Divider(),
          Text('Amount in words: ${inrAmountInWords(totals.total)}',
              style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }

  String _money(num value) =>
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2)
          .format(value);
}

class _InvoiceLineDraft {
  _InvoiceLineDraft({
    this.productId,
    String product = '',
    String description = '',
    String hsnSac = '',
    String quantity = '1',
    String unit = 'Unit',
    String rate = '0',
    String discount = '0',
    String gstRate = '0',
  })  : product = TextEditingController(text: product),
        description = TextEditingController(text: description),
        hsnSac = TextEditingController(text: hsnSac),
        quantity = TextEditingController(text: quantity),
        unit = TextEditingController(text: unit),
        rate = TextEditingController(text: rate),
        discount = TextEditingController(text: discount),
        gstRate = TextEditingController(text: gstRate);

  String? productId;
  final TextEditingController product;
  final TextEditingController description;
  final TextEditingController hsnSac;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController rate;
  final TextEditingController discount;
  final TextEditingController gstRate;

  factory _InvoiceLineDraft.fromMap(Map<String, dynamic> map) {
    final line = GstInvoiceLine.fromMap(map);
    return _InvoiceLineDraft(
      productId: line.productId,
      product: line.product,
      description: line.description,
      hsnSac: line.hsnSac,
      quantity: line.quantity.toString(),
      unit: line.unit,
      rate: line.rate.toString(),
      discount: line.discountPercent.toString(),
      gstRate: line.gstRate.toString(),
    );
  }

  GstInvoiceLine get value => GstInvoiceLine(
        productId: productId,
        product: product.text.trim(),
        description: description.text.trim(),
        hsnSac: hsnSac.text.trim(),
        quantity: double.tryParse(quantity.text.trim()) ?? 0,
        unit: unit.text.trim().ifEmpty('Unit'),
        rate: double.tryParse(rate.text.trim()) ?? 0,
        discountPercent: double.tryParse(discount.text.trim()) ?? 0,
        gstRate: double.tryParse(gstRate.text.trim()) ?? 0,
      );

  void dispose() {
    product.dispose();
    description.dispose();
    hsnSac.dispose();
    quantity.dispose();
    unit.dispose();
    rate.dispose();
    discount.dispose();
    gstRate.dispose();
  }
}

String _value(Map<String, dynamic>? row, List<String> keys,
    {String fallback = ''}) {
  if (row == null) return fallback;
  for (final key in keys) {
    final value = row[key];
    if (value != null && value.toString().trim().isNotEmpty)
      return value.toString().trim();
  }
  return fallback;
}

extension _InvoiceEditorString on String {
  String ifEmpty(String? fallback) => isEmpty ? (fallback ?? '') : this;
}
