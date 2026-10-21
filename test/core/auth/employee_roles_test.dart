import 'package:flutter_test/flutter_test.dart';

import 'package:avrcrm/core/auth/employee_roles.dart';
import 'package:avrcrm/core/models/app_user.dart';

AppUser employee({
  String department = 'Sales',
  String roleLabel = 'Sales Executive',
  String tenantId = 'tenant-a',
}) {
  return AppUser(
    id: 'e1',
    name: 'Employee',
    email: 'e@co.com',
    role: AppRole.employee,
    roleLabel: roleLabel,
    department: department,
    tenantId: tenantId,
    dashboard: 'employee',
  );
}

void main() {
  group('employee department modules', () {
    test('sales employees see sales modules only', () {
      final user = employee(department: 'Sales');
      expect(employeeDepartment(user), 'sales');
      final modules = employeeAllowedModules(user);
      expect(modules, contains('leads'));
      expect(modules, contains('opportunities'));
      expect(modules, contains('orders'));
      expect(modules, isNot(contains('user-management')));
      expect(employeeCanAccessModule(user, 'leads'), isTrue);
      expect(employeeCanAccessModule(user, 'user-management'), isFalse);
    });

    test('support employees do not see sales-order shortcuts', () {
      final user = employee(
        department: 'Customer Support',
        roleLabel: 'Support Executive',
      );
      expect(employeeDepartment(user), 'support');
      expect(employeeCanAccessModule(user, 'support'), isTrue);
      expect(employeeCanAccessModule(user, 'sales-orders'), isFalse);
    });

    test('finance employees see invoice modules', () {
      final user = employee(department: 'Finance', roleLabel: 'Accountant');
      expect(employeeDepartment(user), 'finance');
      expect(employeeCanAccessModule(user, 'invoices'), isTrue);
      expect(employeeCanAccessModule(user, 'leads'), isFalse);
    });

    test('unknown department gets restricted fallback modules', () {
      final user = employee(department: 'Astronomy', roleLabel: 'Analyst');
      final config = employeeDepartmentConfig(user);
      expect(config.modules, equals(['activities']));
      expect(employeeCanAccessModule(user, 'leads'), isFalse);
      expect(employeeCanAccessModule(user, 'activities'), isTrue);
    });

    test('non-employees never receive employee module access', () {
      final admin = AppUser(
        id: 'a1',
        name: 'Admin',
        email: 'a@co.com',
        role: AppRole.tenantAdmin,
        roleLabel: 'Tenant Admin',
        tenantId: 'tenant-a',
        dashboard: 'tenant',
      );
      expect(employeeDepartment(admin), isEmpty);
      expect(employeeAllowedModules(admin), isEmpty);
      expect(employeeCanAccessModule(admin, 'leads'), isFalse);
    });
  });
}
