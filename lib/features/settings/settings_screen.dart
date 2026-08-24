import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isWide ? 28 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),

                    if (isWide)
                      _buildWideLayout(context)
                    else
                      _buildMobileLayout(context),

                    const SizedBox(height: 24),

                    _buildAppearanceSection(context),

                    const SizedBox(height: 24),

                    _buildLogoutCard(context, colorScheme),

                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        'AVRCRM',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Center(
                      child: Text(
                        'Powered by AVR Softdev Pvt. Ltd.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings & Administration',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage your company, users, permissions, modules and CRM preferences.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSectionCard(
                context,
                title: 'Organization',
                subtitle: 'Company and user administration',
                icon: Icons.business_outlined,
                children: [
                  _buildSettingsTile(
                    context,
                    icon: Icons.business_outlined,
                    title: 'Company Settings',
                    subtitle:
                        'Company profile and configuration',
                    onTap: () {
                      _showComingSoon(context, 'Company Settings');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.people_outline,
                    title: 'Users & Roles',
                    subtitle:
                        'Add users and manage their access',
                    onTap: () {
                      _showComingSoon(context, 'Users & Roles');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Roles & Permissions',
                    subtitle:
                        'Create custom roles and module permissions',
                    onTap: () {
                      _showComingSoon(context, 'Roles & Permissions');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                context,
                title: 'Security',
                subtitle: 'Authentication and access controls',
                icon: Icons.security_outlined,
                children: [
                  _buildSettingsTile(
                    context,
                    icon: Icons.security_outlined,
                    title: 'Security',
                    subtitle:
                        'Authentication and access settings',
                    onTap: () {
                      _showComingSoon(context, 'Security');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Login & Password',
                    subtitle:
                        'Configure password and login policies',
                    onTap: () {
                      _showComingSoon(context, 'Login & Password');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildSectionCard(
                context,
                title: 'CRM Modules',
                subtitle: 'Control access to business modules',
                icon: Icons.dashboard_customize_outlined,
                children: [
                  _buildSettingsTile(
                    context,
                    icon: Icons.campaign_outlined,
                    title: 'Marketing',
                    subtitle:
                        'Campaigns, lists and marketing templates',
                    onTap: () {
                      _showComingSoon(context, 'Marketing Settings');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.badge_outlined,
                    title: 'HR',
                    subtitle:
                        'Employees, recruitment and HR management',
                    onTap: () {
                      _showComingSoon(context, 'HR Settings');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.point_of_sale_outlined,
                    title: 'Sales',
                    subtitle:
                        'Leads, opportunities and quotations',
                    onTap: () {
                      _showComingSoon(context, 'Sales Settings');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.account_balance_outlined,
                    title: 'Finance',
                    subtitle:
                        'Invoices, payments and expenses',
                    onTap: () {
                      _showComingSoon(context, 'Finance Settings');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.inventory_2_outlined,
                    title: 'Inventory',
                    subtitle:
                        'Products, stock and warehouse controls',
                    onTap: () {
                      _showComingSoon(context, 'Inventory Settings');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionCard(
                context,
                title: 'Communication',
                subtitle: 'Notifications and integrations',
                icon: Icons.forum_outlined,
                children: [
                  _buildSettingsTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle:
                        'Email, push and system notifications',
                    onTap: () {
                      _showComingSoon(context, 'Notifications');
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.extension_outlined,
                    title: 'Integrations',
                    subtitle:
                        'Connect third-party services and APIs',
                    onTap: () {
                      _showComingSoon(context, 'Integrations');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildSectionCard(
          context,
          title: 'Organization',
          subtitle: 'Company and user administration',
          icon: Icons.business_outlined,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.business_outlined,
              title: 'Company Settings',
              subtitle: 'Company profile and configuration',
              onTap: () {
                _showComingSoon(context, 'Company Settings');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.people_outline,
              title: 'Users & Roles',
              subtitle: 'Add users and manage their access',
              onTap: () {
                _showComingSoon(context, 'Users & Roles');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.admin_panel_settings_outlined,
              title: 'Roles & Permissions',
              subtitle:
                  'Create custom roles and module permissions',
              onTap: () {
                _showComingSoon(context, 'Roles & Permissions');
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context,
          title: 'CRM Modules',
          subtitle: 'Control access to business modules',
          icon: Icons.dashboard_customize_outlined,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.campaign_outlined,
              title: 'Marketing',
              subtitle:
                  'Campaigns, lists and marketing templates',
              onTap: () {
                _showComingSoon(context, 'Marketing Settings');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.badge_outlined,
              title: 'HR',
              subtitle:
                  'Employees, recruitment and HR management',
              onTap: () {
                _showComingSoon(context, 'HR Settings');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.point_of_sale_outlined,
              title: 'Sales',
              subtitle:
                  'Leads, opportunities and quotations',
              onTap: () {
                _showComingSoon(context, 'Sales Settings');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.account_balance_outlined,
              title: 'Finance',
              subtitle:
                  'Invoices, payments and expenses',
              onTap: () {
                _showComingSoon(context, 'Finance Settings');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Inventory',
              subtitle:
                  'Products, stock and warehouse controls',
              onTap: () {
                _showComingSoon(context, 'Inventory Settings');
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context,
          title: 'Security',
          subtitle: 'Authentication and access controls',
          icon: Icons.security_outlined,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.security_outlined,
              title: 'Security',
              subtitle:
                  'Authentication and access settings',
              onTap: () {
                _showComingSoon(context, 'Security');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.lock_outline,
              title: 'Login & Password',
              subtitle:
                  'Configure password and login policies',
              onTap: () {
                _showComingSoon(context, 'Login & Password');
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          context,
          title: 'Communication',
          subtitle: 'Notifications and integrations',
          icon: Icons.forum_outlined,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle:
                  'Email, push and system notifications',
              onTap: () {
                _showComingSoon(context, 'Notifications');
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.extension_outlined,
              title: 'Integrations',
              subtitle:
                  'Connect third-party services and APIs',
              onTap: () {
                _showComingSoon(context, 'Integrations');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 21,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style:
                        theme.textTheme.bodySmall?.copyWith(
                      color:
                          colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.palette_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appearance',
                        style:
                            theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Customize how AVRCRM looks',
                        style:
                            theme.textTheme.bodySmall?.copyWith(
                          color:
                              colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                secondary: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Dark mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  themeProvider.isDarkMode
                      ? 'Use the light theme'
                      : 'Use the dark theme',
                ),
                value: themeProvider.isDarkMode,
                onChanged: themeProvider.setDarkMode,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.25),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.logout_outlined,
            color: colorScheme.onErrorContainer,
          ),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: colorScheme.error,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: const Text(
          'Sign out from your AVRCRM account',
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: colorScheme.error,
        ),
        onTap: () => _confirmLogout(context),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text(
            'Are you sure you want to sign out from AVRCRM?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      await context.read<AuthService>().signOut();
    }
  }

  void _showComingSoon(
    BuildContext context,
    String title,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title is ready for configuration.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}