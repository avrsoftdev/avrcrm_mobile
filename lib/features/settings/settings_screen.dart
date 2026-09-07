import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../products/products_screen.dart';
import '../support/support_screen.dart';
import '../employees/employees_screen.dart';
import '../sales/invoices_screen.dart';
import '../sales/quotations_screen.dart';
import '../marketing/marketing_screen.dart';
import '../reports/reports_screen.dart';
import '../activities/activities_screen.dart';
import '../notifications/notifications_screen.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primary.withOpacity(0.15),
                  child: const Text('AS', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aakash Sharma', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      Text('Admin · aakash@avrcrm.in', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _sectionLabel(context, 'Modules'),
          _menuTile(context, Icons.receipt_long_rounded, 'Invoices', () => _push(context, const InvoicesScreen())),
          _menuTile(context, Icons.description_outlined, 'Quotations', () => _push(context, const QuotationsScreen())),
          _menuTile(context, Icons.inventory_2_outlined, 'Products', () => _push(context, const ProductsScreen())),
          _menuTile(context, Icons.campaign_outlined, 'Marketing', () => _push(context, const MarketingScreen())),
          _menuTile(context, Icons.support_agent_rounded, 'Support', () => _push(context, const SupportScreen())),
          _menuTile(context, Icons.people_outline, 'Employees', () => _push(context, const EmployeesScreen())),
          _menuTile(context, Icons.bar_chart_rounded, 'Reports', () => _push(context, const ReportsScreen())),
          _menuTile(context, Icons.history_rounded, 'Activities', () => _push(context, const ActivitiesScreen())),
          _menuTile(context, Icons.notifications_outlined, 'Notifications', () => _push(context, const NotificationsScreen())),

          const SizedBox(height: 16),
          _sectionLabel(context, 'Preferences'),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
            ),
            child: SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppTheme.primary),
              value: themeProvider.themeMode == ThemeMode.dark || (themeProvider.themeMode == ThemeMode.system && isDark),
              onChanged: (_) => themeProvider.toggle(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          const SizedBox(height: 16),
          _sectionLabel(context, 'Account'),
          _menuTile(context, Icons.logout_rounded, 'Sign Out', () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          }, color: AppTheme.destructive),
        ],
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: Theme.of(context).textTheme.bodySmall?.color)),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppTheme.primary, size: 22),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        trailing: color == null ? const Icon(Icons.chevron_right_rounded, size: 20) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}
