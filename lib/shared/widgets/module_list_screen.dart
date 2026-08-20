import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditor(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text('No $title found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data();
              final primary = data[fields.first]?.toString() ?? 'Unnamed';
              final secondary = fields.length > 1
                  ? data[fields[1]]?.toString() ?? ''
                  : '';
              return Card(
                child: ListTile(
                  title: Text(primary),
                  subtitle: Text(secondary),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'delete') {
                        await FirebaseFirestore.instance
                            .collection(collection)
                            .doc(docs[i].id)
                            .delete();
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                  onTap: () => _showEditor(
                    context,
                    docId: docs[i].id,
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
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    setState(() => saving = true);
    final data = {
      for (final field in widget.fields)
        field: controllers[field]!.text.trim(),
    };
    final ref = FirebaseFirestore.instance.collection(widget.collection);
    if (widget.docId == null) {
      await ref.add({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.doc(widget.docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    if (mounted) Navigator.pop(context);
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
                decoration: InputDecoration(
                  labelText: _pretty(field),
                ),
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

  String _pretty(String value) {
    return value
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m.group(1)}')
        .replaceFirst(value[0], value[0].toUpperCase());
  }
}
