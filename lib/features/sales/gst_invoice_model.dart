class GstInvoiceLine {
  const GstInvoiceLine({
    this.productId,
    required this.product,
    required this.description,
    required this.hsnSac,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.discountPercent,
    required this.gstRate,
  });

  final String? productId;
  final String product;
  final String description;
  final String hsnSac;
  final double quantity;
  final String unit;
  final double rate;
  final double discountPercent;
  final double gstRate;

  double get gross => _money(quantity * rate);
  double get discount => _money(gross * discountPercent / 100);
  double get taxable => _money(gross - discount);
  double get tax => _money(taxable * gstRate / 100);
  double get total => _money(taxable + tax);

  Map<String, dynamic> toMap({required bool interState}) => {
        if (productId != null && productId!.isNotEmpty)
          'product_id': productId,
        'product': product,
        'description': description,
        'hsn_sac': hsnSac,
        'quantity': quantity,
        'unit': unit,
        'rate': rate,
        'price': rate,
        'discount_percent': discountPercent,
        'discount_amount': discount,
        'gst_rate': gstRate,
        'gst_percent': gstRate,
        'taxable_amount': taxable,
        'cgst': interState ? 0 : _money(tax / 2),
        'sgst': interState ? 0 : _money(tax - _money(tax / 2)),
        'igst': interState ? tax : 0,
        'tax_amount': tax,
        'line_total': total,
        'amount': total,
      };

  factory GstInvoiceLine.fromMap(Map<String, dynamic> map) {
    final quantity = _number(map['quantity'] ?? map['qty'], 1);
    final rate = _number(map['rate'] ?? map['price'] ?? map['unit_price'], 0);
    final discountAmount = _number(map['discount_amount'], -1);
    final discountPercent = _number(
      map['discount_percent'] ??
          map['discount_rate'] ??
          map['discount_pct'] ??
          map['discount'],
      0,
    );
    final discount = discountAmount >= 0
        ? discountAmount
        : _money(quantity * rate * discountPercent / 100);

    return GstInvoiceLine(
      productId: map['product_id']?.toString(),
      product: _text(map, const ['product', 'name']),
      description:
          _text(map, const ['description', 'product', 'name']).ifEmpty('Item'),
      hsnSac: _text(map, const ['hsn_sac', 'hsn', 'sac']),
      quantity: quantity,
      unit: _text(map, const ['unit']).ifEmpty('Unit'),
      rate: rate,
      discountPercent: discountAmount >= 0 && quantity * rate != 0
          ? discount * 100 / (quantity * rate)
          : discountPercent,
      gstRate: _number(
        map['gst_rate'] ??
            map['gst_percent'] ??
            map['gst'] ??
            map['tax_rate'] ??
            map['tax_percent'],
        0,
      ),
    );
  }
}

class GstInvoiceTotals {
  const GstInvoiceTotals({
    required this.subtotal,
    required this.discount,
    required this.taxable,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.freight,
    required this.adjustment,
    required this.total,
    required this.paid,
    required this.balance,
  });

  final double subtotal;
  final double discount;
  final double taxable;
  final double cgst;
  final double sgst;
  final double igst;
  final double freight;
  final double adjustment;
  final double total;
  final double paid;
  final double balance;
  double get tax => _money(cgst + sgst + igst);

  factory GstInvoiceTotals.calculate({
    required List<GstInvoiceLine> lines,
    required bool interState,
    required double freight,
    required double adjustment,
    required double paid,
  }) {
    final subtotal = _money(
      lines.fold<double>(0, (sum, line) => sum + line.gross),
    );
    final discount = _money(
      lines.fold<double>(0, (sum, line) => sum + line.discount),
    );
    final taxable = _money(subtotal - discount);
    final lineTax = _money(
      lines.fold<double>(0, (sum, line) => sum + line.tax),
    );
    final cgst = interState
        ? 0.0
        : _money(lines.fold<double>(
            0,
            (sum, line) => sum + _money(line.tax / 2),
          ));
    final sgst = interState
        ? 0.0
        : _money(lines.fold<double>(
            0,
            (sum, line) => sum + _money(line.tax - _money(line.tax / 2)),
          ));
    final igst = interState ? lineTax : 0.0;
    final normalizedFreight = _money(freight);
    final normalizedAdjustment = _money(adjustment);
    final normalizedPaid = _money(paid);
    final total = _money(
      taxable + lineTax + normalizedFreight + normalizedAdjustment,
    );

    return GstInvoiceTotals(
      subtotal: subtotal,
      discount: discount,
      taxable: taxable,
      cgst: cgst,
      sgst: sgst,
      igst: igst,
      freight: normalizedFreight,
      adjustment: normalizedAdjustment,
      total: total,
      paid: normalizedPaid,
      balance: _money(total - normalizedPaid),
    );
  }
}

String inrAmountInWords(num amount) {
  final paise = ((amount.abs() * 100).round() % 100);
  final rupees = amount.abs().floor();
  final rupeeWords = _indianNumberWords(rupees);
  final prefix = amount < 0 ? 'Minus ' : '';
  return '$prefix${rupeeWords.isEmpty ? 'Zero' : rupeeWords} rupees'
      '${paise == 0 ? ' only' : ' and ${_indianNumberWords(paise)} paise only'}';
}

String _indianNumberWords(int value) {
  const ones = [
    '',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];
  const tens = [
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety'
  ];
  if (value == 0) return 'Zero';

  String underThousand(int number) {
    final parts = <String>[];
    if (number >= 100) {
      parts.add('${ones[number ~/ 100]} Hundred');
      number %= 100;
    }
    if (number >= 20) {
      parts.add(tens[number ~/ 10]);
      number %= 10;
    }
    if (number > 0) parts.add(ones[number]);
    return parts.join(' ');
  }

  final groups = <String>[];
  var remaining = value;
  for (final entry in const [
    (10000000, 'Crore'),
    (100000, 'Lakh'),
    (1000, 'Thousand')
  ]) {
    if (remaining >= entry.$1) {
      groups.add('${underThousand(remaining ~/ entry.$1)} ${entry.$2}');
      remaining %= entry.$1;
    }
  }
  if (remaining > 0) groups.add(underThousand(remaining));
  return groups.join(' ');
}

double _money(num value) => (value * 100).roundToDouble() / 100;

double _number(Object? value, double fallback) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString().replaceAll(',', '').trim() ?? '') ??
      fallback;
}

String _text(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return '';
}

extension _InvoiceStringFallback on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
