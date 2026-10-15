import 'dart:math' as math;

/// Quote arithmetic shared by the editor, details screen and PDF document.
class QuotationLine {
  const QuotationLine({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.discountPercent = 0,
    this.taxPercent = 0,
  });

  final String description;
  final double quantity;
  final double unitPrice;
  final double discountPercent;
  final double taxPercent;

  double get gross => quantity * unitPrice;
  double get discount => gross * discountPercent / 100;
  double get taxable => gross - discount;
  double get tax => taxable * taxPercent / 100;
  double get total => taxable + tax;

  Map<String, dynamic> toMap() => {
        'description': description,
        'quantity': quantity,
        'price': unitPrice,
        'discount_percent': discountPercent,
        'tax_percent': taxPercent,
        'discount_amount': discount,
        'tax_amount': tax,
        'line_total': total,
      };

  factory QuotationLine.fromMap(Map<String, dynamic> map) {
    double number(List<String> keys, [double fallback = 0]) {
      for (final key in keys) {
        final value = map[key];
        if (value is num) return value.toDouble();
        if (value != null) {
          final parsed = double.tryParse(value.toString());
          if (parsed != null) return parsed;
        }
      }
      return fallback;
    }

    return QuotationLine(
      description: (map['description'] ?? map['product'] ?? '').toString(),
      quantity: number(const ['quantity', 'qty'], 1),
      unitPrice: number(const ['price', 'rate', 'unit_price']),
      discountPercent:
          number(const ['discount_percent', 'discount_rate', 'discount']),
      taxPercent:
          number(const ['tax_percent', 'gst_percent', 'tax_rate', 'gst']),
    );
  }
}

class QuotationTotals {
  const QuotationTotals(
      {required this.subtotal,
      required this.discount,
      required this.tax,
      required this.total});
  final double subtotal;
  final double discount;
  final double tax;
  final double total;

  factory QuotationTotals.fromLines(Iterable<QuotationLine> lines) {
    var subtotal = 0.0;
    var discount = 0.0;
    var tax = 0.0;
    for (final line in lines) {
      subtotal += line.gross;
      discount += line.discount;
      tax += line.tax;
    }
    return QuotationTotals(
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        total: subtotal - discount + tax);
  }
}

bool isValidQuotationLine(QuotationLine line) =>
    line.description.trim().isNotEmpty &&
    line.quantity.isFinite &&
    line.quantity > 0 &&
    line.unitPrice.isFinite &&
    line.unitPrice >= 0 &&
    line.discountPercent.isFinite &&
    line.discountPercent >= 0 &&
    line.discountPercent <= 100 &&
    line.taxPercent.isFinite &&
    line.taxPercent >= 0 &&
    line.taxPercent <= 100;

String quotationNumber() {
  final now = DateTime.now();
  final suffix =
      (now.microsecondsSinceEpoch % math.pow(10, 8)).toString().padLeft(8, '0');
  return 'QT-${now.year}-$suffix';
}
