import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/features/orders/order_draft.dart';

void main() {
  group('OrderValidation', () {
    test('requires valid email addresses', () {
      expect(OrderValidation.email('client@example.com'), isNull);
      expect(OrderValidation.email(''), 'Customer Email ID is required');
      expect(OrderValidation.email('client@invalid'),
          'Enter a valid email address');
      expect(OrderValidation.email('client example.com'),
          'Enter a valid email address');
    });

    test('accepts only non-negative numeric amounts', () {
      expect(OrderValidation.amount('0', 'Order Value'), isNull);
      expect(OrderValidation.amount('123.45', 'Order Value'), isNull);
      expect(OrderValidation.amount('', 'Advance', optional: true), isNull);
      expect(
          OrderValidation.amount('', 'Order Value'), 'Order Value is required');
      expect(
          OrderValidation.amount('-1', 'Order Value'), 'Enter a valid amount');
      expect(
          OrderValidation.amount('1e3', 'Order Value'), 'Enter a valid amount');
      expect(OrderValidation.amount('12.3.4', 'Order Value'),
          'Enter a valid amount');
    });

    test('rejects impossible dates and permits an omitted optional date', () {
      expect(OrderValidation.date('2026-10-19', 'Order Date'), isNull);
      expect(OrderValidation.date('2026-02-29', 'Order Date'),
          'Enter a valid date');
      expect(OrderValidation.date('2026-13-01', 'Order Date'),
          'Enter a valid date');
      expect(OrderValidation.date('', 'Dispatch Date', optional: true), isNull);
      expect(OrderValidation.date('', 'Order Date'), 'Order Date is required');
    });
  });
}
