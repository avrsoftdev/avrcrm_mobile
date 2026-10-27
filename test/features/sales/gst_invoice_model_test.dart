import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/features/sales/gst_invoice_model.dart';

void main() {
  final lines = [
    GstInvoiceLine(
      productId: 'product-1',
      product: 'Service',
      description: 'Installation',
      hsnSac: '9987',
      quantity: 2,
      unit: 'Hour',
      rate: 1000,
      discountPercent: 10,
      gstRate: 18,
    ),
    GstInvoiceLine(
      product: 'Part',
      description: 'Part',
      hsnSac: '8501',
      quantity: 1,
      unit: 'Each',
      rate: 500,
      discountPercent: 0,
      gstRate: 5,
    ),
  ];

  test('calculates intra-state GST, charges, paid and balance to paise', () {
    final totals = GstInvoiceTotals.calculate(
      lines: lines,
      interState: false,
      freight: 50,
      adjustment: -0.25,
      paid: 1000,
    );

    expect(totals.subtotal, 2500);
    expect(totals.discount, 200);
    expect(totals.taxable, 2300);
    expect(totals.cgst, 174.5);
    expect(totals.sgst, 174.5);
    expect(totals.igst, 0);
    expect(totals.total, 2698.75);
    expect(totals.paid, 1000);
    expect(totals.balance, 1698.75);
  });

  test('calculates inter-state IGST only', () {
    final totals = GstInvoiceTotals.calculate(
      lines: lines,
      interState: true,
      freight: 0,
      adjustment: 0,
      paid: 3000,
    );

    expect(totals.cgst, 0);
    expect(totals.sgst, 0);
    expect(totals.igst, 349);
    expect(totals.tax, 349);
    expect(totals.balance, -351);
  });

  test('serializes one tax mode and rehydrates line item fields', () {
    final intraState = lines.first.toMap(interState: false);
    expect(intraState['cgst'], 162);
    expect(intraState['sgst'], 162);
    expect(intraState['igst'], 0);

    final interState = lines.first.toMap(interState: true);
    expect(interState['cgst'], 0);
    expect(interState['sgst'], 0);
    expect(interState['igst'], 324);

    final restored = GstInvoiceLine.fromMap(intraState);
    expect(restored.hsnSac, '9987');
    expect(restored.quantity, 2);
    expect(restored.rate, 1000);
    expect(restored.discountPercent, 10);
    expect(restored.gstRate, 18);
  });

  test('formats INR total in words including paise', () {
    expect(inrAmountInWords(1234567.89),
        'Twelve Lakh Thirty Four Thousand Five Hundred Sixty Seven rupees and Eighty Nine paise only');
    expect(inrAmountInWords(0), 'Zero rupees only');
  });
}
