import 'package:flutter_test/flutter_test.dart';

import 'package:avrcrm/core/auth/access_control.dart';
import 'package:avrcrm/core/models/app_user.dart';

AppUser buildUser({
  required AppRole role,
  String tenantId = 'tenant-a',
  String? department,
  bool active = true,
}) {
  return AppUser(
    id: 'id',
    name: 'User',
    email: 'u@co.com',
    role: role,
    roleLabel: resolveRoleLabel(role),
    department: department,
    tenantId: tenantId,
    dashboard: role == AppRole.employee ? 'employee' : 'tenant',
    active: active,
  );
}

void main() {
  group('AccessControl routing', () {
    test('routes employees to employee dashboard', () {
      final user = buildUser(role: AppRole.employee, department: 'Sales');
      expect(AccessControl.homeTarget(user), AuthHomeTarget.employeeDashboard);
    });

    test('routes tenant and super admins to admin home', () {
      expect(
        AccessControl.homeTarget(buildUser(role: AppRole.tenantAdmin)),
        AuthHomeTarget.adminHome,
      );
      expect(
        AccessControl.homeTarget(buildUser(role: AppRole.superAdmin)),
        AuthHomeTarget.adminHome,
      );
    });

    test('denies customer and unknown roles', () {
      expect(
        AccessControl.homeTarget(buildUser(role: AppRole.customer)),
        AuthHomeTarget.denied,
      );
      expect(
        AccessControl.homeTarget(buildUser(role: AppRole.unknown)),
        AuthHomeTarget.denied,
      );
      expect(AccessControl.homeTarget(null), AuthHomeTarget.login);
    });

    test('inactive users are treated as signed out for routing', () {
      final user = buildUser(role: AppRole.employee, active: false);
      expect(AccessControl.homeTarget(user), AuthHomeTarget.login);
      expect(AccessControl.canUseCrm(user), isFalse);
    });
  });

  group('AccessControl module authorization', () {
    test('admins can access admin-only modules; employees cannot', () {
      final admin = buildUser(role: AppRole.tenantAdmin);
      final employee = buildUser(role: AppRole.employee, department: 'Sales');

      expect(AccessControl.canAccessModule(admin, 'user-management'), isTrue);
      expect(
        AccessControl.canAccessModule(employee, 'user-management'),
        isFalse,
      );
      expect(AccessControl.canAccessModule(employee, 'leads'), isTrue);
      expect(AccessControl.canAccessModule(employee, 'product-modules'), isFalse);
    });

    test('tenant scoping requires a non-empty tenant id', () {
      final scoped = buildUser(role: AppRole.employee, tenantId: 'tenant-x');
      final missing = buildUser(role: AppRole.employee, tenantId: '  ');

      expect(AccessControl.hasValidTenant(scoped), isTrue);
      expect(AccessControl.scopedTenantId(scoped), 'tenant-x');
      expect(AccessControl.hasValidTenant(missing), isFalse);
      expect(AccessControl.scopedTenantId(missing), isNull);
    });
  });
}
