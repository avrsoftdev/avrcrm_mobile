import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_user.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  final SupabaseClient _db = Supabase.instance.client;

  Map<String, dynamic> _permissions = {};
  AppRole _role = AppRole.unknown;

  AppRole get appRole => _role;

  /// Legacy string role for older callers.
  String get role => _role.wireValue;

  Map<String, dynamic> get permissions => Map.unmodifiable(_permissions);

  Future<void> load() async {
    final user = _db.auth.currentUser;
    if (user == null) {
      _role = AppRole.unknown;
      _permissions = {};
      return;
    }

    Map<String, dynamic>? data;
    try {
      data = await _db
          .from('profiles')
          .select('role, permissions')
          .eq('id', user.id)
          .maybeSingle();
    } catch (_) {
      data = null;
    }

    if (data == null) {
      try {
        data = await _db
            .from('users')
            .select('role, permissions')
            .eq('id', user.id)
            .maybeSingle();
      } catch (_) {
        data = null;
      }
    }

    if (data == null) {
      _role = AppRole.unknown;
      _permissions = {};
      return;
    }

    _role = normalizeAppRole(data['role']);
    final permissions = data['permissions'];
    _permissions = permissions is Map
        ? Map<String, dynamic>.from(permissions)
        : {};
  }

  bool can(String module, String action) {
    // Employees are view-scoped via department modules; deny privileged actions.
    if (_role == AppRole.employee) {
      return action == 'view';
    }

    if (_role == AppRole.superAdmin || _role == AppRole.tenantAdmin) {
      return true;
    }

    // Deny unknown/customer by default — never grant broader access.
    if (_role == AppRole.unknown || _role == AppRole.customer) {
      return false;
    }

    final modulePermissions = _permissions[module];
    if (modulePermissions is Map) {
      return modulePermissions[action] == true;
    }

    return false;
  }

  void clear() {
    _role = AppRole.unknown;
    _permissions = {};
  }
}
