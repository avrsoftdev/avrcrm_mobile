import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModuleListScreen extends StatelessWidget {
  final String title;
  final String collection;
  final List<String> fields;

  const ModuleListScreen({
    super.key,
    required this.title,
    required this.collection,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from(collection)
            .stream(primaryKey: ['id'])
            .order('updated_at', ascending: false)
            .map((rows) =>
                rows.where((row) => row['deleted_at'] == null).toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load $title.\n${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!;
          if (docs.isEmpty) {
            return Center(child: Text('No $title found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final data = docs[index];
              final id = data['id'] as String;

              final primary = data[fields.first]?.toString() ?? 'Unnamed';
              final secondary = fields.length > 1
                  ? data[fields[1]]?.toString() ?? ''
                  : '';

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      primary.isEmpty ? '?' : primary[0].toUpperCase(),
                    ),
                  ),
                  title: Text(primary),
                  subtitle: secondary.isEmpty ? null : Text(secondary),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        await supabase.from(collection).update({
                          'deleted_at': DateTime.now().toIso8601String(),
                          'updated_at': DateTime.now().toIso8601String(),
                        }).eq('id', id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                  onTap: () => _showEditor(
                    context,
                    docId: id,
                    existing: data,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditor(
    BuildContext context, {
    String? docId,
    Map<String, dynamic>? existing,
  }) {
    showDialog(
      context: context,
      builder: (_) => _EditorDialog(
        title: docId == null ? 'Add $title' : 'Edit $title',
        collection: collection,
        fields: fields,
        docId: docId,
        existing: existing,
      ),
    );
  }
}

class _EditorDialog extends StatefulWidget {
  final String title;
  final String collection;
  final List<String> fields;
  final String? docId;
  final Map<String, dynamic>? existing;

  const _EditorDialog({
    required this.title,
    required this.collection,
    required this.fields,
    this.docId,
    this.existing,
  });

  @override
  State<_EditorDialog> createState() => _EditorDialogState();
}

class _EditorDialogState extends State<_EditorDialog> {
  final _supabase = Supabase.instance.client;
  late final Map<String, TextEditingController> controllers;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (final field in widget.fields)
        field: TextEditingController(
          text: widget.existing?[field]?.toString() ?? '',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    setState(() => saving = true);
    try {
      final data = <String, dynamic>{
        for (final field in widget.fields)
          field: controllers[field]!.text.trim(),
      };

      if (widget.docId == null) {
        // Create
        data['created_at'] = DateTime.now().toIso8601String();
        data['updated_at'] = DateTime.now().toIso8601String();
        await _supabase.from(widget.collection).insert(data);
      } else {
        // Update
        data['updated_at'] = DateTime.now().toIso8601String();
        await _supabase
            .from(widget.collection)
            .update(data)
            .eq('id', widget.docId!);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
        setState(() => saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final field in widget.fields) ...[
              TextField(
                controller: controllers[field],
                decoration: InputDecoration(labelText: _pretty(field)),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: saving ? null : save,
          child: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

String _pretty(String value) {
  return value
      .replaceAll('_', ' ')
      .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
      .trim()
      .split(' ')
      .map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}')
      .join(' ');
}