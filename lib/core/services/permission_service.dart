import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance =
      PermissionService._();

  final SupabaseClient _db =
      Supabase.instance.client;

  Map<String, dynamic> _permissions = {};

  String _role = 'staff';

  String get role => _role;

  Map<String, dynamic> get permissions =>
      Map.unmodifiable(_permissions);

  Future<void> load() async {
    final user = _db.auth.currentUser;

    if (user == null) return;

    final data = await _db
        .from('users')
        .select('role, permissions')
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return;

    _role = data['role']?.toString() ?? 'staff';

    final permissions = data['permissions'];

    _permissions = permissions is Map
        ? Map<String, dynamic>.from(permissions)
        : {};
  }

  bool can(
    String module,
    String action,
  ) {
    if (_role == 'admin' ||
        _role == 'super_admin') {
      return true;
    }

    final modulePermissions =
        _permissions[module];

    if (modulePermissions is Map) {
      return modulePermissions[action] == true;
    }

    return false;
  }
}