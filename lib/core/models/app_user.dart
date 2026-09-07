class AppUser {
  final String id;
  final String name;
  final String email;
  final String companyId;
  final String role;
  final bool active;
  final Map<String, dynamic> permissions;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.companyId,
    required this.role,
    required this.active,
    required this.permissions,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      companyId: data['companyId']?.toString() ?? '',
      role: data['role']?.toString() ?? 'staff',
      active: data['active'] != false,
      permissions: Map<String, dynamic>.from(data['permissions'] is Map ? data['permissions'] as Map : {}),
    );
  }
}
