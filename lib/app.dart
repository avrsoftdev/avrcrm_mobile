import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';

import 'core/theme/theme_provider.dart';

class AVRCRMApp extends StatelessWidget {
  const AVRCRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'AVRCRM',

      debugShowCheckedModeBanner: false,

      // =========================
      // GLOBAL THEMES
      // =========================

      theme: themeProvider.lightTheme,

      darkTheme: themeProvider.darkTheme,

      themeMode: themeProvider.themeMode,

      // =========================
      // INITIAL SCREEN
      // =========================

      home: const LoginScreen(),

      // =========================
      // ROUTES
      // =========================

      routes: {
        '/dashboard': (_) => const DashboardScreen(),
      },
    );
  }
}
