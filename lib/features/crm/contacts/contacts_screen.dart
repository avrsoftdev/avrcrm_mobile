import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final DatabaseReference _contactsRef =
      FirebaseDatabase.instance.ref('contacts');

  final TextEditingController _searchController = TextEditingController();

  String _search = '';
  String _statusFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openContactForm([Map<String, dynamic>? contact]) async {
    await showDialog(
      context: context,
      builder: (_) => ContactFormDialog(contact: contact),
    );
  }

  Future<void> _uploadCsv() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result.isEmpty) {
        return;
      }

      final selectedFile = result.first;

      if (selectedFile.path == null) {
        _showMessage('Unable to read the selected file.');
        return;
      }

      final file = File(selectedFile.path!);
      final content = await file.readAsString();

      final rows = const LineSplitter().convert(content);

      if (rows.isEmpty) {
        _showMessage('CSV file is empty.');
        return;
      }

      final headers = _parseCsvLine(rows.first)
          .map((e) => e.trim().toLowerCase())
          .toList();

      int imported = 0;

      for (int i = 1; i < rows.length; i++) {
        if (rows[i].trim().isEmpty) continue;

        final values = _parseCsvLine(rows[i]);

        final data = <String, dynamic>{};

        for (int j = 0; j < headers.length; j++) {
          data[headers[j]] = j < values.length ? values[j].trim() : '';
        }

        if ((data['name'] ?? '').toString().trim().isEmpty) {
          continue;
        }

        data['status'] = data['status']?.toString().isNotEmpty == true
            ? data['status']
            : 'Active';

        data['createdAt'] = DateTime.now().millisecondsSinceEpoch;

        await _contactsRef.push().set(data);

        imported++;
      }

      if (!mounted) return;

      _showMessage('$imported contacts imported successfully.');
    } catch (e) {
      _showMessage('CSV import failed: $e');
    }
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();

    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        insideQuotes = !insideQuotes;
      } else if (char == ',' && !insideQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString());

    return result;
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteContact(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: const Text(
            'Are you sure you want to delete this contact?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _contactsRef.child(id).remove();
      _showMessage('Contact deleted.');
    }
  }

  List<MapEntry<String, Map<String, dynamic>>> _filterContacts(
    Map<dynamic, dynamic>? data,
  ) {
    if (data == null) return [];

    final contacts = <MapEntry<String, Map<String, dynamic>>>[];

    for (final entry in data.entries) {
      final value = entry.value;

      if (value is! Map) continue;

      final contact = Map<String, dynamic>.from(value);

      final name = (contact['name'] ?? '').toString().toLowerCase();
      final company = (contact['company'] ?? '').toString().toLowerCase();
      final mobile = (contact['mobile'] ?? '').toString().toLowerCase();
      final email = (contact['email'] ?? '').toString().toLowerCase();

      final matchesSearch = _search.isEmpty ||
          name.contains(_search) ||
          company.contains(_search) ||
          mobile.contains(_search) ||
          email.contains(_search);

      final status =
          (contact['status'] ?? 'Active').toString();

      final matchesStatus =
          _statusFilter == 'All' || status == _statusFilter;

      if (matchesSearch && matchesStatus) {
        contacts.add(
          MapEntry(
            entry.key.toString(),
            contact,
          ),
        );
      }
    }

    contacts.sort(
      (a, b) {
        final aName = (a.value['name'] ?? '').toString();
        final bName = (b.value['name'] ?? '').toString();

        return aName.compareTo(bName);
      },
    );

    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacts',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Manage your customers and business contacts',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Import CSV',
            onPressed: _uploadCsv,
            icon: const Icon(Icons.upload_file_rounded),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => _openContactForm(),
              icon: const Icon(Icons.add),
              label: const Text('Add Contact'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopSection(theme),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _contactsRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load contacts.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final rawData = snapshot.data?.snapshot.value;

                final contacts = rawData is Map
                    ? _filterContacts(rawData)
                    : <MapEntry<String, Map<String, dynamic>>>[];

                if (contacts.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          30,
                        ),
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final item = contacts[index];

                          return _ContactCard(
                            id: item.key,
                            contact: item.value,
                            onEdit: () => _openContactForm(item.value
                              ..['_id'] = item.key),
                            onDelete: () => _deleteContact(item.key),
                          );
                        },
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        30,
                      ),
                      child: _buildDesktopTable(
                        contacts,
                        theme,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _search = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Search name, company, mobile or email...',
                    prefixIcon:
                        const Icon(Icons.search_rounded),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();

                              setState(() {
                                _search = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<String>(
                  initialValue: _statusFilter,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: 'Active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _statusFilter = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.cloud_done_rounded,
                label: 'Realtime Database',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.upload_file_rounded,
                label: 'CSV Import',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.people_alt_rounded,
                label: 'Customer Management',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'No contacts found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a contact or import your contacts from a CSV file.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () => _openContactForm(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Contact'),
                ),
                OutlinedButton.icon(
                  onPressed: _uploadCsv,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Import CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(
    List<MapEntry<String, Map<String, dynamic>>> contacts,
    ThemeData theme,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: DataTable(
        headingRowHeight: 56,
        dataRowMinHeight: 68,
        dataRowMaxHeight: 78,
        columns: const [
          DataColumn(label: Text('Contact')),
          DataColumn(label: Text('Company')),
          DataColumn(label: Text('Designation')),
          DataColumn(label: Text('Mobile')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('')),
        ],
        rows: contacts.map((item) {
          final contact = item.value;

          return DataRow(
            cells: [
              DataCell(
                _ContactIdentity(
                  contact: contact,
                ),
              ),
              DataCell(
                Text(
                  contact['company']?.toString() ?? '-',
                ),
              ),
              DataCell(
                Text(
                  contact['designation']?.toString() ?? '-',
                ),
              ),
              DataCell(
                Text(
                  contact['mobile']?.toString() ?? '-',
                ),
              ),
              DataCell(
                Text(
                  contact['email']?.toString() ?? '-',
                ),
              ),
              DataCell(
                _StatusBadge(
                  status:
                      contact['status']?.toString() ?? 'Active',
                ),
              ),
              DataCell(
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      final copy =
                          Map<String, dynamic>.from(contact);
                      copy['_id'] = item.key;
                      _openContactForm(copy);
                    } else if (value == 'delete') {
                      _deleteContact(item.key);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ContactFormDialog extends StatefulWidget {
  final Map<String, dynamic>? contact;

  const ContactFormDialog({
    super.key,
    this.contact,
  });

  @override
  State<ContactFormDialog> createState() =>
      _ContactFormDialogState();
}

class _ContactFormDialogState
    extends State<ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _company = TextEditingController();
  final _designation = TextEditingController();
  final _department = TextEditingController();
  final _mobile = TextEditingController();
  final _personalPhone = TextEditingController();
  final _officePhone = TextEditingController();
  final _email = TextEditingController();
  final _website = TextEditingController();
  final _officeLocation = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController();
  final _pincode = TextEditingController();
  final _notes = TextEditingController();
  final _assignedTo = TextEditingController();

  String _status = 'Active';

  final DatabaseReference _contactsRef =
      FirebaseDatabase.instance.ref('contacts');

  @override
  void initState() {
    super.initState();

    final c = widget.contact;

    if (c != null) {
      _name.text = _value(c, 'name');
      _company.text = _value(c, 'company');
      _designation.text = _value(c, 'designation');
      _department.text = _value(c, 'department');
      _mobile.text = _value(c, 'mobile');
      _personalPhone.text = _value(c, 'personalPhone');
      _officePhone.text = _value(c, 'officePhone');
      _email.text = _value(c, 'email');
      _website.text = _value(c, 'website');
      _officeLocation.text = _value(c, 'officeLocation');
      _address.text = _value(c, 'address');
      _city.text = _value(c, 'city');
      _state.text = _value(c, 'state');
      _country.text = _value(c, 'country');
      _pincode.text = _value(c, 'pincode');
      _notes.text = _value(c, 'notes');
      _assignedTo.text = _value(c, 'assignedTo');

      _status = _value(c, 'status').isEmpty
          ? 'Active'
          : _value(c, 'status');
    }
  }

  String _value(Map<String, dynamic> map, String key) {
    return map[key]?.toString() ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _company.dispose();
    _designation.dispose();
    _department.dispose();
    _mobile.dispose();
    _personalPhone.dispose();
    _officePhone.dispose();
    _email.dispose();
    _website.dispose();
    _officeLocation.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _country.dispose();
    _pincode.dispose();
    _notes.dispose();
    _assignedTo.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = <String, dynamic>{
      'name': _name.text.trim(),
      'company': _company.text.trim(),
      'designation': _designation.text.trim(),
      'department': _department.text.trim(),
      'mobile': _mobile.text.trim(),
      'personalPhone': _personalPhone.text.trim(),
      'officePhone': _officePhone.text.trim(),
      'email': _email.text.trim(),
      'website': _website.text.trim(),
      'officeLocation': _officeLocation.text.trim(),
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': _state.text.trim(),
      'country': _country.text.trim(),
      'pincode': _pincode.text.trim(),
      'notes': _notes.text.trim(),
      'assignedTo': _assignedTo.text.trim(),
      'status': _status,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };

    final existingId = widget.contact?['_id']?.toString();

    if (existingId != null && existingId.isNotEmpty) {
      await _contactsRef.child(existingId).update(data);
    } else {
      data['createdAt'] =
          DateTime.now().millisecondsSinceEpoch;

      await _contactsRef.push().set(data);
    }

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          existingId != null
              ? 'Contact updated successfully.'
              : 'Contact created successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 950,
          maxHeight: 850,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(isEditing),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _section(
                        title: 'Basic Information',
                        icon: Icons.person_outline,
                        children: [
                          _field(
                            _name,
                            'Full Name',
                            Icons.person,
                            required: true,
                          ),
                          _field(
                            _company,
                            'Company',
                            Icons.business,
                          ),
                          _field(
                            _designation,
                            'Designation',
                            Icons.badge_outlined,
                          ),
                          _field(
                            _department,
                            'Department',
                            Icons.account_tree_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _section(
                        title: 'Contact Information',
                        icon: Icons.contact_phone_outlined,
                        children: [
                          _field(
                            _mobile,
                            'Mobile Number',
                            Icons.phone_android,
                          ),
                          _field(
                            _personalPhone,
                            'Personal Number',
                            Icons.phone,
                          ),
                          _field(
                            _officePhone,
                            'Office Number',
                            Icons.business_center,
                          ),
                          _field(
                            _email,
                            'Email ID',
                            Icons.email_outlined,
                          ),
                          _field(
                            _website,
                            'Website',
                            Icons.language,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _section(
                        title: 'Location',
                        icon: Icons.location_on_outlined,
                        children: [
                          _field(
                            _officeLocation,
                            'Office Location',
                            Icons.location_city,
                          ),
                          _field(
                            _address,
                            'Address',
                            Icons.home_outlined,
                            maxLines: 2,
                          ),
                          _field(
                            _city,
                            'City',
                            Icons.location_city,
                          ),
                          _field(
                            _state,
                            'State',
                            Icons.map_outlined,
                          ),
                          _field(
                            _country,
                            'Country',
                            Icons.public,
                          ),
                          _field(
                            _pincode,
                            'PIN Code',
                            Icons.pin_drop_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _section(
                        title: 'CRM Information',
                        icon: Icons.business_center_outlined,
                        children: [
                          _field(
                            _assignedTo,
                            'Assigned Sales Person',
                            Icons.person_pin,
                          ),
                          DropdownButtonFormField<String>(
                            initialValue: _status,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              prefixIcon:
                                  Icon(Icons.flag_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Active',
                                child: Text('Active'),
                              ),
                              DropdownMenuItem(
                                value: 'Inactive',
                                child: Text('Inactive'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _status = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _section(
                        title: 'Notes',
                        icon: Icons.notes_outlined,
                        children: [
                          _field(
                            _notes,
                            'Additional Notes',
                            Icons.notes,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEditing) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context)
                .dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            child: Icon(
              isEditing
                  ? Icons.edit_outlined
                  : Icons.person_add_alt_1,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              isEditing
                  ? 'Edit Contact'
                  : 'Add New Contact',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(
              isEditing ? 'Update Contact' : 'Save Contact',
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final columns = width > 700 ? 2 : 1;

              final itemWidth =
                  (width - ((columns - 1) * 14)) /
                      columns;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: children
                    .map(
                      (child) => SizedBox(
                        width: itemWidth,
                        child: child,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: required
          ? (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return '$label is required';
              }

              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ContactCard({
    required this.id,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        contact['name']?.toString() ?? 'Unknown';

    final company =
        contact['company']?.toString() ?? '';

    final designation =
        contact['designation']?.toString() ?? '';

    final mobile =
        contact['mobile']?.toString() ?? '';

    final email =
        contact['email']?.toString() ?? '';

    final status =
        contact['status']?.toString() ?? 'Active';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _Avatar(name: name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (designation.isNotEmpty)
                        Text(designation),
                      if (company.isNotEmpty)
                        Text(
                          company,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else {
                      onDelete();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            if (mobile.isNotEmpty)
              _ContactLine(
                icon: Icons.phone_android,
                text: mobile,
              ),
            if (email.isNotEmpty)
              _ContactLine(
                icon: Icons.email_outlined,
                text: email,
              ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: _StatusBadge(status: status),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactIdentity extends StatelessWidget {
  final Map<String, dynamic> contact;

  const _ContactIdentity({
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(
          name: contact['name']?.toString() ?? '',
        ),
        const SizedBox(width: 10),
        Text(
          contact['name']?.toString() ?? '-',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar({
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isEmpty
        ? '?'
        : name.trim()[0].toUpperCase();

    return CircleAvatar(
      child: Text(
        letter,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive
              ? Colors.green.shade700
              : Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}