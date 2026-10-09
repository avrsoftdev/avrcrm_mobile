import '../models/app_user.dart';
import 'employee_roles.dart';

/// Central authorization helpers aligned with the web CRM policy model.
/// UI hiding alone is not enough — call these before opening modules or
/// performing privileged actions.
class AccessControl {
  AccessControl._();

  static bool isSignedIn(AppUser? user) => user != null && user.active;

  static bool isAdmin(AppUser? user) =>
      user != null && user.active && user.role.isAdmin;

  static bool isEmployee(AppUser? user) =>
      user != null && user.active && user.role.isEmployee;

  /// CRM mobile access: admins and employees only. Customers and unknown roles denied.
  static bool canUseCrm(AppUser? user) =>
      user != null && user.active && user.role.canUseCrm;

  /// Missing tenant must not unlock cross-tenant queries.
  static bool hasValidTenant(AppUser? user) =>
      user != null && user.tenantId.trim().isNotEmpty;

  static bool canAccessModule(AppUser? user, ModuleKey module) {
    if (!canUseCrm(user)) return false;
    if (kAdminOnlyModules.contains(module)) return isAdmin(user);
    if (isAdmin(user)) return true;
    return employeeCanAccessModule(user, module);
  }

  static bool canPerformAdminAction(AppUser? user) => isAdmin(user);

  /// Scopes dashboard/list queries to the authenticated tenant only.
  static String? scopedTenantId(AppUser? user) {
    if (!hasValidTenant(user)) return null;
    return user!.tenantId.trim();
  }

  /// Safe home target after successful CRM sign-in.
  static AuthHomeTarget homeTarget(AppUser? user) {
    if (user == null || !user.active) return AuthHomeTarget.login;
    if (!user.role.canUseCrm) return AuthHomeTarget.denied;
    if (user.role.isEmployee) {
      // Employees without a resolvable department still get the restricted dashboard.
      return AuthHomeTarget.employeeDashboard;
    }
    if (user.role.isAdmin) return AuthHomeTarget.adminHome;
    return AuthHomeTarget.denied;
  }
}

enum AuthHomeTarget {
  login,
  adminHome,
  employeeDashboard,
  denied,
}
