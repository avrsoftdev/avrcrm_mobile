import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'add_invoice_screen.dart';
import 'gst_invoice_model.dart';
import 'invoice_pdf_service.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({
    required this.invoice,
    required this.tenantId,
    super.key,
  });

  final Map<String, dynamic> invoice;
  final String tenantId;

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final _db = Supabase.instance.client;
  late Map<String, dynamic> _invoice;
  bool _loading = false;
  bool _downloading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final row = await _db
          .from('invoices')
          .select()
          .eq('id', _invoice['id'].toString())
          .eq('tenant_id', widget.tenantId)
          .maybeSingle();
      if (row == null) throw StateError('Invoice is no longer available in this workspace.');
      if (mounted) {
        setState(() {
          _invoice = Map<String, dynamic>.from(row);
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _edit() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddInvoiceScreen(invoice: _invoice)),
    );
    if (changed == true) await _reload();
  }

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      final fileName = await InvoicePdfService().downloadInvoice(
        invoiceId: _invoice['id'].toString(),
        tenantId: widget.tenantId,
      );
      if (mounted) _message('$fileName saved successfully.');
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
    final invoice = _invoice;
    final total = _number(invoice, const ['total', 'grand_total', 'amount']);
    final paid = _number(invoice, const ['amount_paid', 'paid', 'paid_amount']);
    final balance = _number(invoice, const ['balance', 'balance_due']) ??
        (total == null ? null : total - (paid ?? 0));
    final interState = _text(invoice, const ['gst_transaction_type'])
        .toLowerCase()
        .contains('inter');
    final items = invoice['items'];

    return Scaffold(
      appBar: AppBar(
        title: Text(_text(invoice, const ['invoice_number', 'id']).ifEmpty('Invoice')),
        actions: [
          IconButton(
            tooltip: 'Edit invoice',
            onPressed: _loading ? null : _edit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _reload, child: const Text('Retry')),
                  ]),
                ))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_text(invoice, const ['invoice_type']).ifEmpty('Tax Invoice'),
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(_text(invoice, const ['customer', 'billing_name']).ifEmpty('Customer')),
                          const SizedBox(height: 12),
                          _detail('Invoice date', _date(_text(invoice, const ['invoice_date', 'date']))),
                          _detail('Due date', _date(_text(invoice, const ['due_date']))),
                          _detail('Status', _text(invoice, const ['status'])),
                          _detail('Payment terms', _text(invoice, const ['payment_terms', 'terms'])),
                          _detail('PO / reference', _text(invoice, const ['po_number', 'reference_number'])),
                          _detail('Place of supply', _text(invoice, const ['place_of_supply'])),
                          _detail('State code', _text(invoice, const ['state_code'])),
                          _detail('GST transaction type', _text(invoice, const ['gst_transaction_type'])),
                          _detail('Supplier', _text(invoice, const ['supplier_legal_name'])),
                          _detail('Supplier GSTIN', _text(invoice, const ['supplier_gstin'])),
                        ]),
                      ),
                    ),
                    _section('Billing address'),
                    _dataCard([
                      _text(invoice, const ['billing_name', 'customer']),
                      _text(invoice, const ['billing_gstin']),
                      _text(invoice, const ['billing_address']),
                      _joined(invoice, const ['billing_city', 'billing_district', 'billing_state', 'billing_pin_code', 'billing_country']),
                      _text(invoice, const ['billing_phone']),
                      _text(invoice, const ['billing_email']),
                    ]),
                    _section('Shipping address'),
                    _dataCard([
                      _text(invoice, const ['shipping_name']),
                      _text(invoice, const ['shipping_gstin']),
                      _text(invoice, const ['shipping_address']),
                      _joined(invoice, const ['shipping_city', 'shipping_state', 'shipping_pin_code', 'shipping_country']),
                    ]),
                    if (_text(invoice, const ['subject']).isNotEmpty) ...[
                      _section('Subject'),
                      _dataCard([_text(invoice, const ['subject'])]),
                    ],
                    _section('Line items'),
                    if (items is List)
                      ...items.whereType<Map>().map((raw) {
                        final item = Map<String, dynamic>.from(raw);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(_text(item, const ['description', 'product']).ifEmpty('Item'),
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                              if (_text(item, const ['hsn_sac', 'hsn', 'sac']).isNotEmpty)
                                Text('HSN/SAC: ${_text(item, const ['hsn_sac', 'hsn', 'sac'])}'),
                              Text('Qty ${_text(item, const ['quantity'])} ${_text(item, const ['unit'])} × ${_money(_number(item, const ['rate', 'price']) ?? 0)}'),
                              Text('Discount ${_money(_number(item, const ['discount_amount']) ?? 0)} · GST ${_text(item, const ['gst_rate', 'gst_percent', 'gst'])}%'),
                              if (interState)
                                Text('IGST: ${_money(_number(item, const ['igst', 'tax_amount']) ?? 0)}')
                              else ...[
                                Text('CGST: ${_money(_number(item, const ['cgst']) ?? ((_number(item, const ['tax_amount']) ?? 0) / 2))}'),
                                Text('SGST: ${_money(_number(item, const ['sgst']) ?? ((_number(item, const ['tax_amount']) ?? 0) / 2))}'),
                              ],
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text('Line total ${_money(_number(item, const ['line_total', 'amount', 'total']) ?? 0)}',
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ]),
                          ),
                        );
                      })
                    else
                      const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('No line items saved.'))),
                    _section('Totals'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: [
                          _totalRow('Subtotal', _number(invoice, const ['subtotal', 'amount'])),
                          _totalRow('Discount', _number(invoice, const ['discount_total', 'discount'])),
                          _totalRow('Taxable amount', _number(invoice, const ['taxable_amount'])),
                          if (interState)
                            _totalRow('IGST', _number(invoice, const ['igst', 'tax']))
                          else ...[
                            _totalRow('CGST', _number(invoice, const ['cgst'])),
                            _totalRow('SGST', _number(invoice, const ['sgst'])),
                          ],
                          _totalRow('Freight', _number(invoice, const ['freight', 'freight_charges'])),
                          _totalRow('Adjustment', _number(invoice, const ['adjustment', 'round_off'])),
                          const Divider(),
                          _totalRow('Total', total, bold: true),
                          _totalRow('Amount paid', paid),
                          _totalRow('Balance due', balance, bold: true),
                          if (total != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Total in words: ${_text(invoice, const ['amount_in_words']).ifEmpty(inrAmountInWords(total))}'),
                            ),
                        ]),
                      ),
                    ),
                    _section('Payment and bank details'),
                    _dataCard([
                      _text(invoice, const ['payment_mode']),
                      _text(invoice, const ['bank_name']),
                      _text(invoice, const ['account_holder']),
                      _text(invoice, const ['account_number']),
                      _text(invoice, const ['ifsc']),
                      _text(invoice, const ['branch']),
                    ]),
                    if (_text(invoice, const ['notes']).isNotEmpty) ...[
                      _section('Notes'),
                      _dataCard([_text(invoice, const ['notes'])]),
                    ],
                    if (_text(invoice, const ['terms']).isNotEmpty) ...[
                      _section('Terms and conditions'),
                      _dataCard([_text(invoice, const ['terms'])]),
                    ],
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _downloading ? null : _download,
                      icon: _downloading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(_downloading ? 'Preparing PDF…' : 'Download PDF'),
                    ),
                  ],
                ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      );

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 130, child: Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))),
          Expanded(child: Text(value.isEmpty ? '—' : value)),
        ]),
      );

  Widget _dataCard(List<String> values) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...values.where((value) => value.trim().isNotEmpty).map(
                  (value) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(value),
                  ),
                ),
            if (values.every((value) => value.trim().isEmpty)) const Text('No details provided.'),
          ]),
        ),
      );

  Widget _totalRow(String label, num? amount, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(child: Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null)),
          Text(amount == null ? '—' : _money(amount), style: bold ? const TextStyle(fontWeight: FontWeight.w700) : null),
        ]),
      );

  String _joined(Map<String, dynamic> row, List<String> keys) =>
      keys.map((key) => _text(row, [key])).where((value) => value.isNotEmpty).join(', ');

  String _date(String value) {
    final date = DateTime.tryParse(value);
    return date == null ? value : DateFormat('dd MMM yyyy').format(date);
  }

  String _money(num value) => NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2).format(value);
}

num? _number(Map<String, dynamic> row, List<String> keys) {
  for (final key in keys) {
    final value = row[key];
    if (value is num) return value;
    if (value != null) {
      final parsed = num.tryParse(value.toString().replaceAll(',', ''));
      if (parsed != null) return parsed;
    }
  }
  return null;
}

String _text(Map<String, dynamic> row, List<String> keys) {
  for (final key in keys) {
    final value = row[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return '';
}

extension _DetailStringFallback on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
