import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/access_control.dart';
import '../auth/auth_provider.dart';
import '../auth/employee_roles.dart';
import '../../features/dashboard/employee_shell.dart';

/// Wraps a screen and blocks navigation when the signed-in user cannot access
/// the module. Prefer this over only hiding menu items.
class RoleAccessGuard extends StatelessWidget {
  final ModuleKey module;
  final Widget child;
  final bool adminOnly;

  const RoleAccessGuard({
    super.key,
    required this.module,
    required this.child,
    this.adminOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final allowed = adminOnly
        ? AccessControl.isAdmin(user)
        : AccessControl.canAccessModule(user, module);

    if (!allowed) {
      return AccessDeniedScreen(
        message: adminOnly
            ? 'This area is restricted to administrators.'
            : 'Your role does not include access to this module.',
      );
    }
    return child;
  }
}
