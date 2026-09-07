import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/backend/app_backend.dart';
import 'core/services/permission_service.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_PROJECT_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AppBackend>.value(
          value: AppBackend.instance,
        ),

        Provider<PermissionService>.value(
          value: PermissionService.instance,
        ),

        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const AVRCRMApp(),
    ),
  );
}