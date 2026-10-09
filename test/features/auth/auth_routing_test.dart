import 'package:flutter_test/flutter_test.dart';

import 'package:avrcrm/core/auth/access_control.dart';
import 'package:avrcrm/core/models/app_user.dart';

/// Focused coverage for sign-out / session-clear behavior at the policy layer.
/// Full Supabase sign-in is covered by AuthProvider integration with the backend;
/// these tests assert that clearing the authenticated user returns the login target
/// and revokes module access.
void main() {
  test('cleared user session routes to login and revokes access', () {
    AppUser? session = AppUser(
      id: 'e1',
      name: 'Priya',
      email: 'priya@co.com',
      role: AppRole.employee,
      roleLabel: 'Sales Executive',
      department: 'Sales',
      tenantId: 'tenant-nexus',
      dashboard: 'employee',
    );

    expect(AccessControl.homeTarget(session), AuthHomeTarget.employeeDashboard);
    expect(AccessControl.canAccessModule(session, 'leads'), isTrue);

    // Sign-out clears the in-memory profile (AuthProvider.signOut).
    session = null;

    expect(AccessControl.homeTarget(session), AuthHomeTarget.login);
    expect(AccessControl.canAccessModule(session, 'leads'), isFalse);
    expect(AccessControl.canPerformAdminAction(session), isFalse);
  });

  test('admin sign-out likewise returns login and drops admin actions', () {
    AppUser? session = AppUser(
      id: 'a1',
      name: 'Admin',
      email: 'admin@co.com',
      role: AppRole.tenantAdmin,
      roleLabel: 'Tenant Admin',
      tenantId: 'tenant-nexus',
      dashboard: 'tenant',
    );

    expect(AccessControl.homeTarget(session), AuthHomeTarget.adminHome);
    expect(AccessControl.canPerformAdminAction(session), isTrue);

    session = null;

    expect(AccessControl.homeTarget(session), AuthHomeTarget.login);
    expect(AccessControl.canPerformAdminAction(session), isFalse);
  });
}
