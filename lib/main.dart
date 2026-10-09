import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/auth/auth_provider.dart';
import 'core/backend/app_backend.dart';
import 'core/services/auth_service.dart';
import 'core/services/permission_service.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ocynakjqymhxnqsrvwxv.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jeW5ha2pxeW1oeG5xc3J2d3h2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc2MzkyNDgsImV4cCI6MjEwMzIxNTI0OH0.WuZK2HulohruVG_CHG87mAJV1Eo6FDXbx1dUzTs1qA0',
  );

  final authProvider = AuthProvider();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppBackend>.value(
          value: AppBackend.instance,
        ),
        Provider<AuthService>.value(
          value: AuthService(),
        ),
        Provider<PermissionService>.value(
          value: PermissionService.instance,
        ),
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const AVRCRMApp(),
    ),
  );

  // Restore any existing Supabase session and load the trusted profile.
  await authProvider.initialize();
}
