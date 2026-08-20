import 'package:flutter/material.dart';
import '../../../shared/widgets/module_list_screen.dart';

class ListsScreen extends StatelessWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModuleListScreen(
      title: 'Marketing Lists',
      collection: 'marketing_lists',
      fields: ['name', 'description', 'status'],
    );
  }
}
