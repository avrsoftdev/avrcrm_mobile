import 'package:flutter/material.dart';
import '../../../shared/widgets/module_list_screen.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleListScreen(
      title: 'Templates',
      collection: 'templates',
      fields: ['name', 'type', 'subject', 'status'],
    );
  }
}
