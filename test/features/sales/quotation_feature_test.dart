import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/features/sales/quotation_model.dart';
import 'package:avrcrm/features/sales/quotation_pdf_service.dart';

void main() {
  test('calculates discounted line and aggregate quotation totals', () {
    const line = QuotationLine(
        description: 'Panel',
        quantity: 2,
        unitPrice: 100,
        discountPercent: 10,
        taxPercent: 18);
    expect(line.gross, 200);
    expect(line.discount, 20);
    expect(line.tax, 32.4);
    expect(line.total, 212.4);
    final totals = QuotationTotals.fromLines([
      line,
      const QuotationLine(
          description: 'Install', quantity: 1, unitPrice: 50, taxPercent: 5)
    ]);
    expect(totals.subtotal, 250);
    expect(totals.discount, 20);
    expect(totals.tax, 34.9);
    expect(totals.total, 264.9);
  });

  test('rejects invalid quantities, discounts and missing descriptions', () {
    expect(
        isValidQuotationLine(
            const QuotationLine(description: 'X', quantity: 1, unitPrice: 1)),
        isTrue);
    expect(
        isValidQuotationLine(
            const QuotationLine(description: '', quantity: 1, unitPrice: 1)),
        isFalse);
    expect(
        isValidQuotationLine(
            const QuotationLine(description: 'X', quantity: 0, unitPrice: 1)),
        isFalse);
    expect(
        isValidQuotationLine(const QuotationLine(
            description: 'X', quantity: 1, unitPrice: 1, discountPercent: 101)),
        isFalse);
  });

  test('builds a quotation PDF with terms and multiple long items', () async {
    final quote = {
      'id': 'QT-2026-123',
      'customer': 'Solar Works',
      'date': '2026-10-14',
      'valid_until': '2026-10-30',
      'status': 'Draft',
      'notes': 'Thank you for your enquiry.',
      'terms': 'Valid for fifteen days.',
      'items': List.generate(
          50,
          (i) => {
                'description': 'Product $i ${'long description ' * 5}',
                'quantity': 2,
                'price': 120,
                'discount_percent': 5,
                'tax_percent': 18
              }),
    };
    final bytes = await buildQuotationPdf(quote);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(RegExp(r'/Type\s*/Page\b').allMatches(latin1.decode(bytes)).length,
        greaterThan(1));
  });

  test('uses stable safe quotation filenames', () {
    expect(quotationPdfFileName(' QT/2026:42 '), 'Quotation-QT-2026-42.pdf');
    expect(quotationPdfFileName(''), 'Quotation-quote.pdf');
  });
}
