import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.business),
            title: Text('Company Settings'),
            subtitle: Text('Company profile and configuration'),
          ),
          const ListTile(
            leading: Icon(Icons.people),
            title: Text('Users & Roles'),
            subtitle: Text('Manage users and permissions'),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Security'),
            subtitle: Text('Authentication and access settings'),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return SwitchListTile.adaptive(
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                ),
                title: const Text('Dark mode'),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
    );
  }
}
