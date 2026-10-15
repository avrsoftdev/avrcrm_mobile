import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'quotation_model.dart';

String quotationPdfFileName(String number) {
  final safe = number
      .trim()
      .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '-')
      .replaceAll(RegExp(r'\s+'), '-');
  return 'Quotation-${safe.isEmpty ? 'quote' : safe}.pdf';
}

Future<Uint8List> buildQuotationPdf(Map<String, dynamic> quote,
    {Map<String, dynamic>? customer}) async {
  final pdf = pw.Document();
  final currency = NumberFormat.decimalPattern('en_IN');
  String money(num n) => 'INR ${currency.format(n)}';
  final rawItems = quote['items'];
  final lines = rawItems is List
      ? rawItems
          .whereType<Map>()
          .map((e) => QuotationLine.fromMap(Map<String, dynamic>.from(e)))
          .toList()
      : <QuotationLine>[];
  final totals = QuotationTotals.fromLines(lines);
  final name = (quote['customer'] ??
          customer?['company'] ??
          customer?['name'] ??
          'Customer details unavailable')
      .toString();
  final address = [
    customer?['address'],
    customer?['city'],
    customer?['state'],
    customer?['postal_code'],
    customer?['country']
  ].where((x) => x != null && x.toString().trim().isNotEmpty).join(', ');
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      header: (_) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('AVRCRM  |  QUOTATION',
              style: pw.TextStyle(
                  color: PdfColors.blueGrey700,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold))),
      footer: (ctx) => pw.Center(
          child: pw.Text('Page ${ctx.pageNumber} of ${ctx.pagesCount}',
              style:
                  const pw.TextStyle(fontSize: 8, color: PdfColors.grey600))),
      build: (_) => [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('QUOTATION',
                            style: pw.TextStyle(
                                fontSize: 26,
                                color: PdfColors.blue900,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Text((quote['id'] ?? '').toString(),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                      ]),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Status: ${quote['status'] ?? 'Draft'}'),
                        pw.Text('Issue date: ${quote['date'] ?? '-'}'),
                        pw.Text('Valid until: ${quote['valid_until'] ?? '-'}')
                      ]),
                ]),
            pw.SizedBox(height: 14),
            pw.Divider(color: PdfColors.blueGrey300),
            pw.SizedBox(height: 12),
            pw.Text('PREPARED FOR',
                style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.blueGrey700,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            if (address.isNotEmpty)
              pw.Text(address, style: const pw.TextStyle(fontSize: 9)),
            if ((customer?['email'] ?? '').toString().isNotEmpty)
              pw.Text(customer!['email'].toString(),
                  style: const pw.TextStyle(fontSize: 9)),
            if ((customer?['phone'] ?? '').toString().isNotEmpty)
              pw.Text(customer!['phone'].toString(),
                  style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 20),
            if (lines.isEmpty)
              pw.Text('No line items recorded.')
            else
              pw.TableHelper.fromTextArray(
                  headers: const [
                    'Description',
                    'Qty',
                    'Unit price',
                    'Discount',
                    'Tax',
                    'Amount'
                  ],
                  data: lines
                      .map((l) => [
                            l.description,
                            l.quantity.toString(),
                            money(l.unitPrice),
                            '${l.discountPercent}%',
                            '${l.taxPercent}%',
                            money(l.total)
                          ])
                      .toList(),
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  headerDecoration:
                      const pw.BoxDecoration(color: PdfColors.blueGrey50),
                  headerStyle:
                      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 8),
                  cellPadding: const pw.EdgeInsets.all(6),
                  columnWidths: {0: const pw.FlexColumnWidth(3)}),
            pw.SizedBox(height: 16),
            pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                    width: 220,
                    child: pw.Column(children: [
                      _pdfTotal('Subtotal', money(totals.subtotal)),
                      _pdfTotal('Discount', '- ${money(totals.discount)}'),
                      _pdfTotal('Tax', money(totals.tax)),
                      pw.Divider(),
                      _pdfTotal('Total', money(totals.total), bold: true)
                    ]))),
            if ((quote['notes'] ?? '').toString().trim().isNotEmpty) ...[
              pw.SizedBox(height: 20),
              _pdfSection('NOTES', quote['notes'].toString())
            ],
            if ((quote['terms'] ?? '').toString().trim().isNotEmpty) ...[
              pw.SizedBox(height: 14),
              _pdfSection('TERMS AND CONDITIONS', quote['terms'].toString())
            ],
          ]));
  return pdf.save();
}

pw.Widget _pdfTotal(String label, String value, {bool bold = false}) =>
    pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3),
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label,
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight:
                          bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
              pw.Text(value,
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight:
                          bold ? pw.FontWeight.bold : pw.FontWeight.normal))
            ]));
pw.Widget _pdfSection(String title, String text) =>
    pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title,
          style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey700)),
      pw.SizedBox(height: 5),
      pw.Text(text, style: const pw.TextStyle(fontSize: 9))
    ]);

Future<String> saveQuotationPdf(Map<String, dynamic> quote,
    {Map<String, dynamic>? customer}) async {
  final name = quotationPdfFileName((quote['id'] ?? '').toString());
  final bytes = await buildQuotationPdf(quote, customer: customer);
  final path = await FilePicker.saveFile(fileName: name, bytes: bytes);
  if (path == null || path.trim().isEmpty)
    throw StateError('Saving the quotation PDF was cancelled.');
  return name;
}

Future<void> shareQuotationPdf(Map<String, dynamic> quote,
    {Map<String, dynamic>? customer}) async {
  final bytes = await buildQuotationPdf(quote, customer: customer);
  await Printing.sharePdf(
      bytes: bytes,
      filename: quotationPdfFileName((quote['id'] ?? '').toString()));
}
