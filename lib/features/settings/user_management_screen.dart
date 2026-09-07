import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  static const roles = <String>[
    'admin',
    'sales',
    'marketing',
    'finance',
    'inventory',
    'hr',
    'staff',
  ];

  static const modules = <String>[
    'contacts',
    'leads',
    'deals',
    'quotes',
    'invoices',
    'payments',
    'inventory',
    'campaigns',
    'marketing_lists',
    'templates',
    'hr',
    'settings',
  ];

  final SupabaseClient _supabase = Supabase.instance.client;

  String? _companyId;
  bool _loadingCompany = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No logged-in user found.');
      }

      final profile = await _supabase
          .from('profiles')
          .select('company_id')
          .eq('id', user.id)
          .single();

      if (!mounted) return;
      setState(() {
        _companyId = profile['company_id']?.toString();
        _loadingCompany = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loadingCompany = false;
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _usersStream() {
    final companyId = _companyId;
    if (companyId == null) {
      return const Stream<List<Map<String, dynamic>>>.empty();
    }

    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('company_id', companyId)
        .order('name', ascending: true);
  }

  Future<void> _createUser() async {
    final result = await showDialog<_NewUser>(
      context: context,
      builder: (_) => const _NewUserDialog(),
    );

    if (result == null) return;

    try {
      final response = await _supabase.functions.invoke(
        'manage-user',
        body: {
          'action': 'create',
          'name': result.name,
          'email': result.email,
          'role': result.role,
          'permissions': result.permissions,
        },
      );

      if (response.status < 200 || response.status >= 300) {
        throw Exception(response.data?.toString() ?? 'User creation failed.');
      }

      final data = response.data;
      final link = data is Map ? data['passwordSetupLink']?.toString() : null;

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('User created'),
          content: SelectableText(
            link == null || link.isEmpty
                ? 'User created successfully.'
                : 'Send this password setup link to the user:\n\n$link',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) _message('Could not create user: ${_cleanError(e)}');
    }
  }

  Future<void> _toggle(String uid, bool active) async {
    try {
      final response = await _supabase.functions.invoke(
        'manage-user',
        body: {
          'action': 'update',
          'uid': uid,
          'active': active,
        },
      );

      if (response.status < 200 || response.status >= 300) {
        throw Exception(response.data?.toString() ?? 'Update failed.');
      }
    } catch (e) {
      if (mounted) _message('Update failed: ${_cleanError(e)}');
    }
  }

  Future<void> _showPermissions(
    String uid,
    Map<String, dynamic> data,
  ) async {
    final existing = Map<String, dynamic>.from(
      data['permissions'] is Map ? data['permissions'] as Map : const {},
    );

    final selected = <String, Set<String>>{};

    for (final module in modules) {
      final moduleMap = existing[module];
      selected[module] = moduleMap is Map
          ? moduleMap.entries
              .where((entry) => entry.value == true)
              .map((entry) => entry.key.toString())
              .toSet()
          : <String>{};
    }

    const actions = <String>['view', 'create', 'edit', 'delete', 'export'];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Permissions — ${data['name'] ?? ''}'),
              content: SizedBox(
                width: 760,
                height: 520,
                child: ListView(
                  children: [
                    for (final module in modules)
                      Card(
                        child: ExpansionTile(
                          title: Text(
                            module.replaceAll('_', ' ').toUpperCase(),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  for (final action in actions)
                                    SizedBox(
                                      width: 135,
                                      child: CheckboxListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        value: selected[module]!.contains(action),
                                        title: Text(action),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            if (value == true) {
                                              selected[module]!.add(action);
                                            } else {
                                              selected[module]!.remove(action);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final permissions = {
                      for (final module in modules)
                        module: {
                          for (final action in actions)
                            action: selected[module]!.contains(action),
                        },
                    };

                    try {
                      final response = await _supabase.functions.invoke(
                        'manage-user',
                        body: {
                          'action': 'update',
                          'uid': uid,
                          'permissions': permissions,
                        },
                      );

                      if (response.status < 200 || response.status >= 300) {
                        throw Exception(
                          response.data?.toString() ?? 'Save failed.',
                        );
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }
                    } catch (e) {
                      if (dialogContext.mounted) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(content: Text('Save failed: ${_cleanError(e)}')),
                        );
                      }
                    }
                  },
                  child: const Text('Save Permissions'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCompany) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null || _companyId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Users & Roles')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load your company profile.\n${_loadError ?? ''}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users & Roles',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _createUser,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Add User'),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _usersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load users.\n${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          if (users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];
              final active = user['active'] != false;
              final role = user['role']?.toString() ?? 'staff';
              final name = user['name']?.toString() ?? 'Unnamed';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${user['email'] ?? ''}\nRole: ${role.toUpperCase()}',
                  ),
                  isThreeLine: true,
                  trailing: Switch.adaptive(
                    value: active,
                    onChanged: (value) => _toggle(
                      user['id'].toString(),
                      value,
                    ),
                  ),
                  onTap: () => _showPermissions(
                    user['id'].toString(),
                    user,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NewUser {
  final String name;
  final String email;
  final String role;
  final Map<String, dynamic> permissions;

  const _NewUser(
    this.name,
    this.email,
    this.role,
    this.permissions,
  );
}

class _NewUserDialog extends StatefulWidget {
  const _NewUserDialog();

  @override
  State<_NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<_NewUserDialog> {
  final name = TextEditingController();
  final email = TextEditingController();
  String role = 'sales';

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'sales', child: Text('Sales')),
                DropdownMenuItem(value: 'marketing', child: Text('Marketing')),
                DropdownMenuItem(value: 'finance', child: Text('Finance')),
                DropdownMenuItem(value: 'inventory', child: Text('Inventory')),
                DropdownMenuItem(value: 'hr', child: Text('HR')),
                DropdownMenuItem(value: 'staff', child: Text('Staff')),
              ],
              onChanged: (value) {
                setState(() => role = value ?? 'staff');
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isEmpty || email.text.trim().isEmpty) {
              return;
            }

            Navigator.pop(
              context,
              _NewUser(
                name.text.trim(),
                email.text.trim(),
                role,
                const {},
              ),
            );
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
