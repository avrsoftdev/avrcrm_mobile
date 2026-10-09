import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/access_control.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/auth/employee_roles.dart';
import '../../core/auth/module_catalog.dart';
import '../../core/theme/app_theme.dart';
import 'department_employee_dashboard_screen.dart';

/// Employee-only shell: department dashboard plus shortcuts limited to
/// permitted modules. Admin HomeShell is never shown for employees.
class EmployeeShell extends StatefulWidget {
  const EmployeeShell({super.key});

  @override
  State<EmployeeShell> createState() => _EmployeeShellState();
}

class _EmployeeShellState extends State<EmployeeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (!AccessControl.isEmployee(user)) {
      return const AccessDeniedScreen(
        message: 'Employee access is required for this workspace.',
      );
    }

    final modules = employeeAllowedModules(user);
    final destinations = <_EmployeeDest>[
      const _EmployeeDest(
        key: 'dashboard',
        label: 'Home',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      ...modules.take(3).map(
            (key) => _EmployeeDest(
              key: key,
              label: moduleTitle(key),
              icon: moduleIcon(key),
              selectedIcon: moduleIcon(key),
            ),
          ),
    ];

    final safeIndex = _index.clamp(0, destinations.length - 1);
    if (safeIndex != _index) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _index = safeIndex);
      });
    }

    final screens = destinations.map((dest) {
      if (dest.key == 'dashboard') {
        return const DepartmentEmployeeDashboardScreen();
      }
      final screen = buildModuleScreen(dest.key);
      return screen ??
          const AccessDeniedScreen(
            message: 'This module is not available on mobile yet.',
          );
    }).toList();

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (i) => setState(() => _index = i),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label.length > 10
                    ? '${d.label.substring(0, 9)}…'
                    : d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EmployeeDest {
  final ModuleKey key;
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _EmployeeDest({
    required this.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class AccessDeniedScreen extends StatelessWidget {
  final String message;

  const AccessDeniedScreen({
    super.key,
    this.message = 'You do not have permission to view this screen.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: AppTheme.destructive.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 16),
              const Text(
                'Access denied',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.read<AuthProvider>().signOut(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
