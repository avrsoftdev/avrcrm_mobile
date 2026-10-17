import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/auth/access_control.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../support/support_screen.dart';
import '../modules/product_modules_screen.dart';
import '../settings/user_management_screen.dart';
import '../../core/widgets/role_access_guard.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdmin = AccessControl.isAdmin(user);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                  child: Text(
                    _initials(user?.name ?? 'U'),
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Signed-in user',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        [
                          user?.roleLabel ?? 'Unknown role',
                          if (user?.email != null && user!.email.isNotEmpty)
                            user.email,
                        ].join(' · '),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (isAdmin) ...[
            _sectionLabel(context, 'CRM Website'),
            for (final section in _sidebarSections.entries)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                  ),
                ),
                child: ExpansionTile(
                  leading: Icon(section.value.$1, color: AppTheme.primary),
                  title: Text(section.key,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  children: [
                    for (final item in section.value.$2)
                      ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.only(left: 56, right: 16),
                        title: Text(item, style: const TextStyle(fontSize: 13)),
                        trailing:
                            const Icon(Icons.chevron_right_rounded, size: 19),
                        onTap: () =>
                            _openSidebarItem(context, section.key, item),
                      ),
                  ],
                ),
              ),
            _sectionLabel(context, 'Modules'),
            _menuTile(
              context,
              Icons.apps_rounded,
              'All Products & Modules',
              () => _push(
                context,
                const RoleAccessGuard(
                  module: 'product-modules',
                  adminOnly: true,
                  child: ProductModulesScreen(),
                ),
              ),
            ),
            _menuTile(
              context,
              Icons.manage_accounts_outlined,
              'Users & Roles',
              () => _push(
                context,
                const RoleAccessGuard(
                  module: 'user-management',
                  adminOnly: true,
                  child: UserManagementScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          _sectionLabel(context, 'Preferences'),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
              ),
            ),
            child: SwitchListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: AppTheme.primary,
              ),
              value: themeProvider.themeMode == ThemeMode.dark ||
                  (themeProvider.themeMode == ThemeMode.system && isDark),
              onChanged: (_) => themeProvider.toggle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _sectionLabel(context, 'Account'),
          _menuTile(
            context,
            Icons.logout_rounded,
            'Sign Out',
            () async {
              await context.read<AuthProvider>().signOut();
            },
            color: AppTheme.destructive,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppTheme.primary, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: color == null
            ? const Icon(Icons.chevron_right_rounded, size: 20)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _openSidebarItem(BuildContext context, String section, String item) {
    if (section == 'Insights & Platform' && item == 'Support') {
      _push(context, const SupportScreen());
      return;
    }
    final screen = const ProductModulesScreen().sidebarScreenFor(section, item);
    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$item is coming soon.')),
      );
      return;
    }
    _push(context, screen);
  }

  static const _sidebarSections = <String, (IconData, List<String>)>{
    'Finance': (
      Icons.account_balance_wallet_outlined,
      [
        'Accounting',
        'Invoices',
        'Payment Tracking',
        'Outstanding',
        'Recurring Invoices',
        'Credit / Debit Notes',
        'GST / e-Invoice',
      ]
    ),
    'CRM': (
      Icons.people_alt_outlined,
      [
        'Dashboard',
        'Sales Tracking',
        'Leads',
        'Opportunities',
        'Customers',
        'Contacts',
        'Activities',
      ]
    ),
    'Sales & Invoicing': (
      Icons.receipt_long_outlined,
      [
        'Quotations',
        'Sales Orders',
        'Orders',
      ]
    ),
    'Purchase': (
      Icons.shopping_bag_outlined,
      [
        'Purchase Hub',
        'Vendors',
        'Purchase Orders',
      ]
    ),
    'Inventory & Production': (
      Icons.inventory_2_outlined,
      [
        'Products',
        'Inventory',
        'Production',
      ]
    ),
    'HR & Marketing': (
      Icons.campaign_outlined,
      [
        'HR & Employees',
        'Attendance',
        'Recruitment',
        'Templates',
        'SMS Campaigns',
        'Email Campaigns',
        'Marketing',
        'Communication',
      ]
    ),
    'Insights & Platform': (
      Icons.insights_outlined,
      [
        'Reports',
        'Sales Dashboard',
        'Automation',
        'Integrations',
        'Android App',
        'Support',
        'Services',
      ]
    ),
    'System': (
      Icons.settings_outlined,
      [
        'Notifications',
        'Activity Logs',
        'Approvals',
        'Settings',
      ]
    ),
  };
}
