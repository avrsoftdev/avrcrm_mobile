import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'gst_invoice_model.dart';

typedef InvoicePdfSaveCallback = Future<String?> Function({
  required String fileName,
  required Uint8List bytes,
});

class InvoicePdfItem {
  const InvoicePdfItem({
    required this.description,
    required this.hsnSac,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.discount,
    required this.tax,
    required this.amount,
  });

  final String description;
  final String hsnSac;
  final num? quantity;
  final String unit;
  final num? rate;
  final String discount;
  final String tax;
  final num? amount;

  factory InvoicePdfItem.fromMap(
    Map<String, dynamic> data, {
    bool interState = false,
  }) {
    final quantity = _number(data, const ['quantity', 'qty']);
    final rate = _number(data, const ['rate', 'price', 'unit_price']);
    final discountPercent = _number(
      data,
      const ['discount_percent', 'discount_rate', 'discount_pct', 'discount'],
    );
    final discountAmount = _number(data, const ['discount_amount']);
    final taxPercent = _number(
      data,
      const ['gst_percent', 'gst_rate', 'tax_percent', 'tax_rate', 'gst'],
    );
    final taxAmount = _number(data, const ['tax_amount', 'gst_amount']);
    final explicitAmount =
        _number(data, const ['line_total', 'amount', 'total']);

    num? calculatedAmount;
    if (quantity != null && rate != null) {
      final gross = quantity * rate;
      final discount = discountAmount ??
          (discountPercent == null ? 0 : gross * discountPercent / 100);
      final tax = taxAmount ??
          (taxPercent == null ? 0 : (gross - discount) * taxPercent / 100);
      calculatedAmount = gross - discount + tax;
    }

    final discountLabel = [
      if (discountPercent != null) '${_plainNumber(discountPercent)}%',
      if (discountAmount != null) 'INR ${_decimal(discountAmount)}',
    ].join(' / ');

    final cgst = _number(data, const ['cgst']);
    final sgst = _number(data, const ['sgst']);
    final igst = _number(data, const ['igst']);
    final taxLabel = [
      if (taxPercent != null) '${_plainNumber(taxPercent)}%',
      if (interState && igst != null)
        'IGST INR ${_decimal(igst)}'
      else if (!interState && (cgst != null || sgst != null))
        'CGST INR ${_decimal(cgst ?? 0)} + SGST INR ${_decimal(sgst ?? 0)}'
      else if (taxAmount != null)
        'INR ${_decimal(taxAmount)}',
    ].join(' / ');

    return InvoicePdfItem(
      description:
          _text(data, const ['description', 'product', 'name']).ifEmpty('Item'),
      hsnSac: _text(data, const ['hsn_sac', 'hsn', 'sac']),
      quantity: quantity,
      unit: _text(data, const ['unit']),
      rate: rate,
      discount: discountLabel.ifEmpty('-'),
      tax: taxLabel.ifEmpty('-'),
      amount: explicitAmount ?? calculatedAmount,
    );
  }
}

class InvoicePdfData {
  const InvoicePdfData({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.status,
    required this.invoiceDate,
    required this.dueDate,
    required this.paymentTerms,
    required this.poNumber,
    required this.placeOfSupply,
    required this.stateCode,
    required this.transactionType,
    required this.supplierName,
    required this.supplierDetails,
    required this.customerName,
    required this.billingDetails,
    required this.shippingName,
    required this.shippingDetails,
    required this.subject,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.taxable,
    required this.tax,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.freight,
    required this.adjustment,
    required this.total,
    required this.paid,
    required this.balance,
    required this.amountWords,
    required this.paymentMode,
    required this.bankDetails,
    required this.notes,
    required this.terms,
  });

  final String id;
  final String invoiceNumber;
  final String invoiceType;
  final String status;
  final String invoiceDate;
  final String dueDate;
  final String paymentTerms;
  final String poNumber;
  final String placeOfSupply;
  final String stateCode;
  final String transactionType;
  final String supplierName;
  final List<String> supplierDetails;
  final String customerName;
  final List<String> billingDetails;
  final String shippingName;
  final List<String> shippingDetails;
  final String subject;
  final List<InvoicePdfItem> items;
  final num? subtotal;
  final num? discount;
  final num? taxable;
  final num? tax;
  final num? cgst;
  final num? sgst;
  final num? igst;
  final num? freight;
  final num? adjustment;
  final num? total;
  final num? paid;
  final num? balance;
  final String amountWords;
  final String paymentMode;
  final List<String> bankDetails;
  final String notes;
  final String terms;

  factory InvoicePdfData.fromMaps({
    required Map<String, dynamic> invoice,
    Map<String, dynamic>? customer,
  }) {
    final customerValue = invoice['customer'];
    final embeddedCustomer = customerValue is Map
        ? Map<String, dynamic>.from(customerValue)
        : const <String, dynamic>{};
    final details = customer ?? embeddedCustomer;
    final id = _text(invoice, const ['id']);
    final customerName = _text(
      invoice,
      const ['customer_name', 'billing_name'],
    ).ifEmpty(
      _text(details, const ['company', 'name', 'customer_name'])
          .ifEmpty(customerValue is String ? customerValue.trim() : ''),
    );
    final address = _addressText(
      invoice['billing_address'] ??
          invoice['bill_to'] ??
          invoice['address'] ??
          details['billing_address'] ??
          details['address'],
    );
    final location = [
      _text(invoice, const ['billing_city']).ifEmpty(
        _text(details, const ['city']),
      ),
      _text(invoice, const ['billing_district']),
      _text(invoice, const ['billing_state']).ifEmpty(
        _text(details, const ['state']),
      ),
      _text(invoice, const ['billing_postal_code']).ifEmpty(
        _text(details, const ['postal_code', 'zip', 'pincode']),
      ),
      _text(invoice, const ['billing_country']).ifEmpty(
        _text(details, const ['country']),
      ),
    ].where((part) => part.isNotEmpty).join(', ');
    final billingDetails = [
      if (address.isNotEmpty) address,
      if (location.isNotEmpty && location != address) location,
      if (_text(invoice, const ['billing_phone', 'phone', 'mobile'])
          .ifEmpty(_text(details, const ['phone', 'mobile']))
          .isNotEmpty)
        _text(invoice, const ['billing_phone', 'phone', 'mobile']).ifEmpty(
          _text(details, const ['phone', 'mobile']),
        ),
      if (_text(invoice, const ['billing_email', 'email'])
          .ifEmpty(_text(details, const ['email']))
          .isNotEmpty)
        _text(invoice, const ['billing_email', 'email'])
            .ifEmpty(_text(details, const ['email'])),
      if (_text(invoice, const ['billing_gstin', 'gst_number', 'gstin'])
          .ifEmpty(_text(details, const ['gst_number', 'gstin', 'gst_no']))
          .isNotEmpty)
        'GSTIN: ${_text(invoice, const [
              'billing_gstin',
              'gst_number',
              'gstin'
            ]).ifEmpty(_text(details, const [
              'gst_number',
              'gstin',
              'gst_no'
            ]))}',
    ];
    final supplierName = _text(
      invoice,
      const ['supplier_legal_name', 'company_name'],
    );
    final supplierDetails = [
      if (_text(invoice, const ['supplier_gstin']).isNotEmpty)
        'GSTIN: ${_text(invoice, const ['supplier_gstin'])}',
      if (_text(invoice, const ['supplier_address']).isNotEmpty)
        _text(invoice, const ['supplier_address']),
      [
        _text(invoice, const ['supplier_state']),
        _text(invoice, const ['supplier_pin_code']),
      ].where((part) => part.isNotEmpty).join(', '),
      if (_text(invoice, const ['supplier_phone']).isNotEmpty)
        'Phone: ${_text(invoice, const ['supplier_phone'])}',
      if (_text(invoice, const ['supplier_email']).isNotEmpty)
        'Email: ${_text(invoice, const ['supplier_email'])}',
    ].where((part) => part.isNotEmpty).toList(growable: false);
    final shippingName = _text(invoice, const ['shipping_name']);
    final shippingDetails = [
      if (_text(invoice, const ['shipping_gstin']).isNotEmpty)
        'GSTIN: ${_text(invoice, const ['shipping_gstin'])}',
      if (_text(invoice, const ['shipping_address']).isNotEmpty)
        _text(invoice, const ['shipping_address']),
      [
        _text(invoice, const ['shipping_city']),
        _text(invoice, const ['shipping_state']),
        _text(invoice, const ['shipping_pin_code']),
        _text(invoice, const ['shipping_country']),
      ].where((part) => part.isNotEmpty).join(', '),
    ].where((part) => part.isNotEmpty).toList(growable: false);
    final bankDetails = [
      if (_text(invoice, const ['bank_name']).isNotEmpty)
        'Bank: ${_text(invoice, const ['bank_name'])}',
      if (_text(invoice, const ['account_holder']).isNotEmpty)
        'Account holder: ${_text(invoice, const ['account_holder'])}',
      if (_text(invoice, const ['account_number']).isNotEmpty)
        'Account number: ${_text(invoice, const ['account_number'])}',
      if (_text(invoice, const ['ifsc']).isNotEmpty)
        'IFSC: ${_text(invoice, const ['ifsc'])}',
      if (_text(invoice, const ['branch']).isNotEmpty)
        'Branch: ${_text(invoice, const ['branch'])}',
    ];
    final rawItems =
        invoice['items'] ?? invoice['line_items'] ?? invoice['invoice_items'];
    final interState =
        _text(invoice, const ['gst_transaction_type']).toLowerCase().contains('inter');
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((item) => InvoicePdfItem.fromMap(
                  Map<String, dynamic>.from(item),
                  interState: interState,
                ))
            .toList(growable: false)
        : const <InvoicePdfItem>[];

    final subtotal = _number(invoice, const ['subtotal', 'amount']) ??
        _sumAvailable(items.map(_itemBaseAmount));
    final tax = _number(invoice, const ['tax_amount', 'tax', 'gst_amount']) ??
        _sumAvailable(items.map(_itemTaxAmount));
    final paid = _number(invoice, const ['amount_paid', 'paid', 'paid_amount']);
    final total = _number(invoice, const ['total', 'grand_total']) ??
        (subtotal == null || tax == null ? null : subtotal + tax);

    return InvoicePdfData(
      id: id,
      invoiceNumber: _text(invoice, const ['invoice_number'])
          .ifEmpty(id)
          .ifEmpty('invoice'),
      invoiceType: _text(invoice, const ['invoice_type']).ifEmpty('Tax Invoice'),
      status: _text(invoice, const ['status']),
      invoiceDate: _formatDate(
        _text(invoice, const ['invoice_date', 'date']),
      ),
      dueDate: _formatDate(_text(invoice, const ['due_date'])),
      paymentTerms: _text(invoice, const ['payment_terms', 'terms']),
      poNumber: _text(invoice, const ['po_number', 'reference_number']),
      placeOfSupply: _text(invoice, const ['place_of_supply']),
      stateCode: _text(invoice, const ['state_code']),
      transactionType: _text(invoice, const ['gst_transaction_type']),
      supplierName: supplierName,
      supplierDetails: supplierDetails,
      customerName: customerName.ifEmpty('Not provided'),
      billingDetails: billingDetails,
      shippingName: shippingName,
      shippingDetails: shippingDetails,
      subject: _text(invoice, const ['subject', 'description']),
      items: items,
      subtotal: subtotal,
      discount: _number(invoice, const ['discount_total', 'discount']),
      taxable: _number(invoice, const ['taxable_amount']) ??
          (subtotal == null ? null : subtotal - (_number(invoice, const ['discount_total', 'discount']) ?? 0)),
      tax: tax,
      cgst: _number(invoice, const ['cgst']),
      sgst: _number(invoice, const ['sgst']),
      igst: _number(invoice, const ['igst']),
      freight: _number(invoice, const ['freight', 'freight_charges']),
      adjustment: _number(invoice, const ['adjustment', 'round_off']),
      total: total,
      paid: paid,
      balance: _number(invoice, const ['balance', 'balance_due']) ??
          (total == null || paid == null ? null : total - paid),
      amountWords: _text(invoice, const ['amount_in_words'])
          .ifEmpty(total == null ? '' : inrAmountInWords(total)),
      paymentMode: _text(invoice, const ['payment_mode']),
      bankDetails: bankDetails,
      notes: _text(invoice, const ['notes']),
      terms: _text(invoice, const ['terms']),
    );
  }
}

class InvoicePdfSaveCancelledException implements Exception {
  const InvoicePdfSaveCancelledException();

  @override
  String toString() => 'Saving the invoice PDF was cancelled.';
}

class InvoicePdfService {
  InvoicePdfService({
    SupabaseClient? client,
    InvoicePdfSaveCallback? savePdf,
  })  : _client = client ?? Supabase.instance.client,
        _savePdf = savePdf ?? _saveWithPicker;

  final SupabaseClient _client;
  final InvoicePdfSaveCallback _savePdf;

  Future<String> downloadInvoice({
    required String invoiceId,
    required String tenantId,
  }) async {
    final id = invoiceId.trim();
    final tenant = tenantId.trim();
    if (_client.auth.currentSession == null) {
      throw StateError('Sign in to save an invoice PDF.');
    }
    if (id.isEmpty || tenant.isEmpty) {
      throw StateError('Invoice or workspace information is missing.');
    }

    final row = await _client
        .from('invoices')
        .select()
        .eq('id', id)
        .eq('tenant_id', tenant)
        .maybeSingle();
    if (row == null) {
      throw StateError('This invoice was not found in your workspace.');
    }

    Map<String, dynamic>? customer;
    final customerId = _text(row, const ['customer_id']);
    if (customerId.isNotEmpty) {
      customer = await _client
          .from('customers')
          .select()
          .eq('id', customerId)
          .eq('tenant_id', tenant)
          .maybeSingle();
    }

    final data = InvoicePdfData.fromMaps(
      invoice: Map<String, dynamic>.from(row),
      customer: customer == null ? null : Map<String, dynamic>.from(customer),
    );
    return generateAndSaveInvoicePdf(data, savePdf: _savePdf);
  }

  static Future<String?> _saveWithPicker({
    required String fileName,
    required Uint8List bytes,
  }) {
    return FilePicker.saveFile(
      fileName: fileName,
      bytes: bytes,
    );
  }
}

String invoicePdfFileName(String invoiceNumber, [String invoiceId = '']) {
  final source = invoiceNumber.trim().isEmpty ? invoiceId : invoiceNumber;
  final safe = source
      .trim()
      .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '-')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^[.-]+|[.-]+$'), '');
  final base = safe.isEmpty ? 'invoice' : safe;
  return '$base.pdf';
}

Future<String> generateAndSaveInvoicePdf(
  InvoicePdfData invoice, {
  required InvoicePdfSaveCallback savePdf,
}) async {
  final bytes = await generateInvoicePdf(invoice);
  final fileName = invoicePdfFileName(invoice.invoiceNumber, invoice.id);
  final savedPath = await savePdf(fileName: fileName, bytes: bytes);
  if (savedPath == null || savedPath.trim().isEmpty) {
    throw const InvoicePdfSaveCancelledException();
  }
  return fileName;
}

Future<Uint8List> generateInvoicePdf(InvoicePdfData invoice) async {
  final document = pw.Document();
  final currency = NumberFormat.decimalPattern('en_IN');

  String money(num? value) =>
      value == null ? '-' : 'INR ${currency.format(value)}';
  String value(String value) => value.trim().isEmpty ? '-' : value.trim();
  pw.Widget sectionTitle(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );
  pw.Widget detailsBox(String title, String name, List<String> details) =>
      pw.Container(
        padding: const pw.EdgeInsets.all(9),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            sectionTitle(title),
            pw.Text(
              value(name),
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...details.map(
              (detail) => pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text(detail, style: const pw.TextStyle(fontSize: 8)),
              ),
            ),
          ],
        ),
      );

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(30, 30, 30, 34),
      header: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Text(
          'TAX INVOICE',
          style: pw.TextStyle(
            color: PdfColors.blueGrey700,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
      footer: (context) => pw.Container(
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.only(top: 8),
        child: pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
        ),
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (invoice.supplierName.isNotEmpty)
                  pw.Text(
                    invoice.supplierName,
                    style: pw.TextStyle(
                      color: PdfColors.blue900,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ...invoice.supplierDetails.map(
                  (detail) => pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Text(detail, style: const pw.TextStyle(fontSize: 8)),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  invoice.invoiceType.toUpperCase(),
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  invoice.invoiceNumber,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Status: ${value(invoice.status)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.SizedBox(height: 4),
                pw.Text('Invoice date: ${value(invoice.invoiceDate)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Due date: ${value(invoice.dueDate)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Payment terms: ${value(invoice.paymentTerms)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text('PO / reference: ${value(invoice.poNumber)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Place of supply: ${value(invoice.placeOfSupply)}',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text('State code: ${value(invoice.stateCode)}',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 9),
        pw.Divider(color: PdfColors.blueGrey300),
        pw.SizedBox(height: 7),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: detailsBox('Bill to', invoice.customerName, invoice.billingDetails),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: detailsBox(
                'Ship to',
                invoice.shippingName.isEmpty
                    ? invoice.customerName
                    : invoice.shippingName,
                invoice.shippingDetails.isEmpty
                    ? invoice.billingDetails
                    : invoice.shippingDetails,
              ),
            ),
          ],
        ),
        if (invoice.subject.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(8),
            decoration: const pw.BoxDecoration(color: PdfColors.grey100),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionTitle('Subject'),
                pw.Text(invoice.subject, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ],
        pw.SizedBox(height: 9),
        if (invoice.items.isEmpty)
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(color: PdfColors.grey100),
            child: pw.Text('No line items recorded for this invoice.'),
          )
        else
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            headerCount: 1,
            columnWidths: const {
              0: pw.FlexColumnWidth(3.1),
              1: pw.FlexColumnWidth(0.9),
              2: pw.FlexColumnWidth(1.0),
              3: pw.FlexColumnWidth(1.15),
              4: pw.FlexColumnWidth(1.0),
              5: pw.FlexColumnWidth(1.4),
              6: pw.FlexColumnWidth(1.45),
            },
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey50),
            headerStyle: pw.TextStyle(
              color: PdfColors.blueGrey900,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 7),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(4),
            headers: const [
              'Item / Description',
              'HSN/SAC',
              'Qty / Unit',
              'Rate',
              'Discount',
              'GST',
              'Line total',
            ],
            data: invoice.items
                .map(
                  (item) => [
                    item.description,
                    value(item.hsnSac),
                    item.quantity == null
                        ? '-'
                        : '${_plainNumber(item.quantity!)} ${item.unit}'.trim(),
                    money(item.rate),
                    item.discount,
                    item.tax,
                    money(item.amount),
                  ],
                )
                .toList(growable: false),
          ),
        pw.SizedBox(height: 9),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.SizedBox(
            width: 260,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
              ),
              child: pw.Column(
                children: [
                  _totalRow('Subtotal', money(invoice.subtotal)),
                  _totalRow('Discount', money(invoice.discount)),
                  _totalRow('Taxable amount', money(invoice.taxable)),
                  if (invoice.transactionType.toLowerCase().contains('inter'))
                    _totalRow('IGST', money(invoice.igst ?? invoice.tax))
                  else if (invoice.cgst != null || invoice.sgst != null) ...[
                    _totalRow('CGST', money(invoice.cgst)),
                    _totalRow('SGST', money(invoice.sgst)),
                  ] else
                    _totalRow('Tax / GST', money(invoice.tax)),
                  _totalRow('Freight', money(invoice.freight)),
                  _totalRow('Adjustment / round-off', money(invoice.adjustment)),
                  pw.Divider(color: PdfColors.blueGrey400),
                  _totalRow('Total', money(invoice.total), bold: true),
                  _totalRow('Amount paid', money(invoice.paid)),
                  _totalRow('Balance due', money(invoice.balance), bold: true),
                ],
              ),
            ),
          ),
        ),
        if (invoice.amountWords.isNotEmpty) ...[
          pw.SizedBox(height: 7),
          pw.Text(
            'Total in words: ${invoice.amountWords}',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ],
        if (invoice.paymentMode.isNotEmpty) ...[
          pw.SizedBox(height: 6),
          pw.Text('Payment mode: ${invoice.paymentMode}',
              style: const pw.TextStyle(fontSize: 8)),
        ],
        if (invoice.bankDetails.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          sectionTitle('Bank details'),
          ...invoice.bankDetails.map(
            (detail) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(detail, style: const pw.TextStyle(fontSize: 8)),
            ),
          ),
        ],
        if (invoice.notes.isNotEmpty) ...[
          pw.SizedBox(height: 9),
          _pdfTextSection('NOTES', invoice.notes),
        ],
        if (invoice.terms.isNotEmpty) ...[
          pw.SizedBox(height: 7),
          _pdfTextSection('TERMS AND CONDITIONS', invoice.terms),
        ],
      ],
    ),
  );

  return document.save();
}

pw.Widget _totalRow(String label, String amount, {bool bold = false}) {
  final style = pw.TextStyle(
    fontSize: 9,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: style),
        pw.Text(amount, style: style),
      ],
    ),
  );
}

pw.Widget _pdfTextSection(String title, String text) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.blueGrey700,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    ],
  );
}

String _text(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value != null && value is! Map && value is! List) {
      final text = value.toString().trim();
      if (text.isNotEmpty) return text;
    }
  }
  return '';
}

num? _number(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value.replaceAll(',', '').trim());
      if (parsed != null) return parsed;
    }
  }
  return null;
}

String _addressText(Object? value) {
  if (value is String) return value.trim();
  if (value is Map) {
    final address = Map<String, dynamic>.from(value);
    return [
      _text(address, const ['line1', 'address_line1', 'street', 'address']),
      _text(address, const ['line2', 'address_line2']),
    ].where((part) => part.isNotEmpty).join(', ');
  }
  return '';
}

String _formatDate(String raw) {
  if (raw.isEmpty) return '';
  final parsed = DateTime.tryParse(raw);
  return parsed == null ? raw : DateFormat('dd MMM yyyy').format(parsed);
}

num? _sumAvailable(Iterable<num?> values) {
  final available = values.whereType<num>().toList(growable: false);
  if (available.isEmpty) return null;
  return available.fold<num>(0, (sum, value) => sum + value);
}

num? _itemBaseAmount(InvoicePdfItem item) {
  if (item.quantity == null || item.rate == null) return null;
  final gross = item.quantity! * item.rate!;
  final discountPercent = num.tryParse(
    RegExp(r'^([\d.]+)%').firstMatch(item.discount)?.group(1) ?? '',
  );
  final discountAmount = num.tryParse(
    RegExp(r'INR ([\d.]+)').firstMatch(item.discount)?.group(1) ?? '',
  );
  return gross - (discountAmount ?? gross * (discountPercent ?? 0) / 100);
}

num? _itemTaxAmount(InvoicePdfItem item) {
  if (item.quantity == null || item.rate == null) return null;
  final amount = item.quantity! * item.rate!;
  final discountPercent = num.tryParse(
    RegExp(r'^([\d.]+)%').firstMatch(item.discount)?.group(1) ?? '',
  );
  final discountAmount = num.tryParse(
    RegExp(r'INR ([\d.]+)').firstMatch(item.discount)?.group(1) ?? '',
  );
  final taxPercent = num.tryParse(
    RegExp(r'^([\d.]+)%').firstMatch(item.tax)?.group(1) ?? '',
  );
  final taxAmount = num.tryParse(
    RegExp(r'INR ([\d.]+)').firstMatch(item.tax)?.group(1) ?? '',
  );
  return taxAmount ??
      (taxPercent == null
          ? null
          : (amount -
                  (discountAmount ?? amount * (discountPercent ?? 0) / 100)) *
              taxPercent /
              100);
}

String _plainNumber(num value) => value.toString();

String _decimal(num value) => value.toStringAsFixed(2);

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
