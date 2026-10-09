import 'package:flutter_test/flutter_test.dart';

import 'package:avrcrm/core/models/app_user.dart';

void main() {
  group('normalizeAppRole', () {
    test('maps trusted backend role strings', () {
      expect(normalizeAppRole('employee'), AppRole.employee);
      expect(normalizeAppRole('tenant_admin'), AppRole.tenantAdmin);
      expect(normalizeAppRole('admin'), AppRole.tenantAdmin);
      expect(normalizeAppRole('super_admin'), AppRole.superAdmin);
      expect(normalizeAppRole('customer'), AppRole.customer);
    });

    test('does not elevate unknown or missing roles', () {
      expect(normalizeAppRole(null), AppRole.unknown);
      expect(normalizeAppRole(''), AppRole.unknown);
      expect(normalizeAppRole('staff'), AppRole.unknown);
      expect(normalizeAppRole('hacker'), AppRole.unknown);
    });
  });

  group('mapProfileToAppUser', () {
    test('reads department and role from profiles payload', () {
      final user = mapProfileToAppUser({
        'id': 'u1',
        'full_name': 'Priya Sharma',
        'email': 'priya@example.com',
        'login_id': 'EMP-1001',
        'role': 'employee',
        'role_label': 'Sales Executive',
        'department': 'Sales',
        'tenant_id': 'tenant-nexus',
        'tenant_name': 'Nexus',
      });

      expect(user.role, AppRole.employee);
      expect(user.department, 'Sales');
      expect(user.roleLabel, 'Sales Executive');
      expect(user.tenantId, 'tenant-nexus');
      expect(user.dashboard, 'employee');
      expect(user.loginId, 'EMP-1001');
    });

    test('falls back company_id to tenantId without inventing admin role', () {
      final user = mapProfileToAppUser({
        'id': 'u2',
        'email': 'a@b.com',
        'role': 'not-a-role',
        'company_id': 'co-1',
      });

      expect(user.role, AppRole.unknown);
      expect(user.tenantId, 'co-1');
      expect(user.role.canUseCrm, isFalse);
    });

    test('maps auth metadata the same way as profiles', () {
      final user = mapAuthMetadataToAppUser(
        id: 'auth-1',
        email: 'emp@co.com',
        metadata: {
          'role': 'employee',
          'role_label': 'Support Executive',
          'department': 'Support',
          'tenant_id': 't-1',
        },
      );

      expect(user.role, AppRole.employee);
      expect(user.department, 'Support');
      expect(user.tenantId, 't-1');
    });
  });
}
