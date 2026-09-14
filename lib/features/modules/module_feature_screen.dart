
import 'package:flutter/material.dart';

class ModuleFeatureScreen extends StatelessWidget {
  final String module;
  final String title;
  final String description;
  final IconData icon;
  final List<String> capabilities;

  const ModuleFeatureScreen({
    super.key,
    required this.module,
    required this.title,
    required this.description,
    required this.icon,
    required this.capabilities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: 'Help',
            onPressed: () => _showHelp(context),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return ListView(
            padding: EdgeInsets.all(wide ? 28 : 16),
            children: [
              Container(
                padding: EdgeInsets.all(wide ? 28 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.primary.withValues(alpha: isDark ? .22 : .10),
                      scheme.primary.withValues(alpha: .03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: scheme.primary.withValues(alpha: .12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: scheme.primary.withValues(alpha: .12),
                      child: Icon(icon, color: scheme.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(module.toUpperCase(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              )),
                          const SizedBox(height: 5),
                          Text(title,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              )),
                          const SizedBox(height: 8),
                          Text(description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: .68),
                                height: 1.45,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionCard(
                context,
                title: 'Key Capabilities',
                child: wide
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 3.8,
                        ),
                        itemCount: capabilities.length,
                        itemBuilder: (_, i) => _capabilityTile(context, capabilities[i], i),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < capabilities.length; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: i == capabilities.length - 1 ? 0 : 10),
                              child: _capabilityTile(context, capabilities[i], i),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                context,
                title: 'Workflow',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _workflowChip(context, 'Create'),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.primary),
                    _workflowChip(context, 'Review'),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.primary),
                    _workflowChip(context, 'Process'),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.primary),
                    _workflowChip(context, 'Report'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                context,
                title: 'Actions',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _showAction(context, 'New $title'),
                      icon: const Icon(Icons.add_rounded),
                      label: Text('New $title'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showAction(context, 'Reports'),
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('View Reports'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionCard(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _capabilityTile(BuildContext context, String text, int index) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withValues(alpha: .09)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: scheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _workflowChip(BuildContext context, String text) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.circle, size: 8, color: scheme.primary),
      label: Text(text),
      side: BorderSide(color: scheme.primary.withValues(alpha: .15)),
    );
  }

  void _showAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action is ready to connect to the existing data workflow.')),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}
