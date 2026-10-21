import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/core/auth/module_catalog.dart';
import 'package:avrcrm/features/modules/product_modules_screen.dart';
import 'package:avrcrm/features/orders/orders_screen.dart';
import 'package:avrcrm/features/sales/sales_orders_screen.dart';

void main() {
  test('Orders routes to the orders table workflow, not Sales Orders', () {
    expect(moduleTitle('orders'), 'Orders');
    expect(buildModuleScreen('orders'), isA<OrdersScreen>());
    expect(
      const ProductModulesScreen()
          .sidebarScreenFor('Sales & Invoicing', 'Orders'),
      isA<OrdersScreen>(),
    );
    expect(buildModuleScreen('sales-orders'), isA<SalesOrdersScreen>());
  });
}
