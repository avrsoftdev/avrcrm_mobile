import 'package:intl/intl.dart';

class Formatters {
  static String inr(double value, {bool short = false}) {
    if (short) {
      if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
      if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
      if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
    }
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(value);
  }
}
