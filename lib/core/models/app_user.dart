enum AppRole {
  superAdmin,
  tenantAdmin,
  employee,
  customer,
  unknown,
}

extension AppRoleX on AppRole {
  String get wireValue {
    switch (this) {
      case AppRole.superAdmin:
        return 'super_admin';
      case AppRole.tenantAdmin:
        return 'tenant_admin';
      case AppRole.employee:
        return 'employee';
      case AppRole.customer:
        return 'customer';
      case AppRole.unknown:
        return 'unknown';
    }
  }

  bool get isAdmin =>
      this == AppRole.superAdmin || this == AppRole.tenantAdmin;

  bool get isEmployee => this == AppRole.employee;

  bool get canUseCrm => isAdmin || isEmployee;
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? loginId;
  final AppRole role;
  final String roleLabel;
  final String? department;
  final String tenantId;
  final String? tenantName;
  final String dashboard;
  final bool active;
  final Map<String, dynamic> permissions;

  /// Legacy alias used by older callers that expected `companyId`.
  String get companyId => tenantId;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.loginId,
    required this.role,
    required this.roleLabel,
    this.department,
    required this.tenantId,
    this.tenantName,
    required this.dashboard,
    this.active = true,
    this.permissions = const {},
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return mapProfileToAppUser({'id': id, ...data});
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? loginId,
    AppRole? role,
    String? roleLabel,
    String? department,
    String? tenantId,
    String? tenantName,
    String? dashboard,
    bool? active,
    Map<String, dynamic>? permissions,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      loginId: loginId ?? this.loginId,
      role: role ?? this.role,
      roleLabel: roleLabel ?? this.roleLabel,
      department: department ?? this.department,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      dashboard: dashboard ?? this.dashboard,
      active: active ?? this.active,
      permissions: permissions ?? this.permissions,
    );
  }
}

String resolveRoleLabel(AppRole role, {String? explicit}) {
  final trimmed = explicit?.trim();
  if (trimmed != null && trimmed.isNotEmpty) return trimmed;
  switch (role) {
    case AppRole.customer:
      return 'Customer';
    case AppRole.employee:
      return 'Employee';
    case AppRole.superAdmin:
      return 'Super Admin';
    case AppRole.tenantAdmin:
      return 'Tenant Admin';
    case AppRole.unknown:
      return 'Unknown';
  }
}

/// Normalizes backend role strings. Unknown values do **not** become admin.
AppRole normalizeAppRole(Object? value) {
  final raw = value?.toString().trim().toLowerCase() ?? '';
  switch (raw) {
    case 'employee':
      return AppRole.employee;
    case 'super_admin':
    case 'superadmin':
      return AppRole.superAdmin;
    case 'tenant_admin':
    case 'admin':
      return AppRole.tenantAdmin;
    case 'customer':
      return AppRole.customer;
    default:
      return AppRole.unknown;
  }
}

String _profileText(Map<String, dynamic> profile, String key) {
  final value = profile[key];
  return value is String ? value : (value?.toString() ?? '');
}

AppUser mapProfileToAppUser(
  Map<String, dynamic> profile, {
  String? authEmail,
  String? authId,
}) {
  final role = normalizeAppRole(
    profile['role'] ?? profile['app_role'],
  );
  final explicitLabel = _profileText(profile, 'role_label').isNotEmpty
      ? _profileText(profile, 'role_label')
      : _profileText(profile, 'roleLabel');
  final dashboardRaw = _profileText(profile, 'dashboard');
  final dashboard = dashboardRaw == 'employee' || role == AppRole.employee
      ? 'employee'
      : 'tenant';

  final name = _profileText(profile, 'full_name').isNotEmpty
      ? _profileText(profile, 'full_name')
      : (_profileText(profile, 'fullName').isNotEmpty
          ? _profileText(profile, 'fullName')
          : (_profileText(profile, 'name').isNotEmpty
              ? _profileText(profile, 'name')
              : (authEmail?.split('@').first ?? 'CRM User')));

  final email = _profileText(profile, 'email').isNotEmpty
      ? _profileText(profile, 'email')
      : (authEmail ?? '');

  final tenantId = _profileText(profile, 'tenant_id').isNotEmpty
      ? _profileText(profile, 'tenant_id')
      : (_profileText(profile, 'tenantId').isNotEmpty
          ? _profileText(profile, 'tenantId')
          : (_profileText(profile, 'company_id').isNotEmpty
              ? _profileText(profile, 'company_id')
              : (_profileText(profile, 'companyId').isNotEmpty
                  ? _profileText(profile, 'companyId')
                  : '')));

  final permissionsRaw = profile['permissions'];
  final permissions = permissionsRaw is Map
      ? Map<String, dynamic>.from(permissionsRaw)
      : <String, dynamic>{};

  final activeRaw = profile['active'] ?? profile['status'];
  final active = activeRaw == null
      ? true
      : activeRaw == true ||
          activeRaw.toString().toLowerCase() == 'active' ||
          activeRaw.toString().toLowerCase() == 'true';

  return AppUser(
    id: _profileText(profile, 'id').isNotEmpty
        ? _profileText(profile, 'id')
        : (authId ?? ''),
    name: name,
    email: email,
    loginId: _profileText(profile, 'login_id').isNotEmpty
        ? _profileText(profile, 'login_id')
        : (_profileText(profile, 'loginId').isNotEmpty
            ? _profileText(profile, 'loginId')
            : null),
    role: role,
    roleLabel: resolveRoleLabel(role, explicit: explicitLabel),
    department: _profileText(profile, 'department').isNotEmpty
        ? _profileText(profile, 'department')
        : null,
    tenantId: tenantId,
    tenantName: _profileText(profile, 'tenant_name').isNotEmpty
        ? _profileText(profile, 'tenant_name')
        : (_profileText(profile, 'tenantName').isNotEmpty
            ? _profileText(profile, 'tenantName')
            : null),
    dashboard: dashboard,
    active: active,
    permissions: permissions,
  );
}

AppUser mapAuthMetadataToAppUser({
  required String id,
  String? email,
  Map<String, dynamic>? metadata,
}) {
  final meta = metadata ?? const <String, dynamic>{};
  return mapProfileToAppUser(
    {
      'id': id,
      'email': email,
      'full_name': meta['full_name'] ?? meta['name'],
      'login_id': meta['login_id'],
      'role': meta['role'],
      'role_label': meta['role_label'],
      'department': meta['department'],
      'tenant_id': meta['tenant_id'] ?? meta['company_id'],
      'tenant_name': meta['tenant_name'],
      'dashboard': meta['dashboard'],
      'permissions': meta['permissions'],
      'active': meta['active'],
    },
    authEmail: email,
    authId: id,
  );
}
