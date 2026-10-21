class OrderDraft {
  const OrderDraft({
    required this.piNumber,
    required this.stage,
    required this.wip,
    required this.orderDate,
    required this.companyName,
    required this.projectName,
    required this.projectTitle,
    required this.deliveryAddress,
    required this.clientName,
    required this.clientContactNumber,
    required this.customerEmailId,
    required this.basicOrderValue,
    required this.orderValueWithGst,
    this.deliveryNeededOn,
    this.assemblyDate,
    this.dispatchDate,
    this.readyStock = false,
    this.advanceReceived,
  });

  final String piNumber;
  final String stage;
  final String wip;
  final String orderDate;
  final String? deliveryNeededOn;
  final String? assemblyDate;
  final String? dispatchDate;
  final bool readyStock;
  final String companyName;
  final String projectName;
  final String projectTitle;
  final String deliveryAddress;
  final String clientName;
  final String clientContactNumber;
  final String customerEmailId;
  final double? advanceReceived;
  final double basicOrderValue;
  final double orderValueWithGst;
}

class OrderValidation {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _amountPattern = RegExp(r'^\d+(?:\.\d+)?$');
  static final RegExp _datePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');

  static String? required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;

  static String? email(String? value) {
    final requiredError = required(value, 'Customer Email ID');
    if (requiredError != null) return requiredError;
    return _emailPattern.hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address';
  }

  static String? amount(String? value, String label, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return optional ? null : '$label is required';
    if (!_amountPattern.hasMatch(text)) return 'Enter a valid amount';
    final parsed = double.tryParse(text);
    if (parsed == null || !parsed.isFinite) return 'Enter a valid amount';
    return null;
  }

  static double? parseOptionalAmount(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    if (amount(text, 'Amount') != null) {
      throw FormatException('Enter a valid amount.');
    }
    return double.parse(text);
  }

  static String? date(String? value, String label, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return optional ? null : '$label is required';

    final match = _datePattern.firstMatch(text);
    if (match == null) return 'Enter a valid date';
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return 'Enter a valid date';
    }
    return null;
  }
}
