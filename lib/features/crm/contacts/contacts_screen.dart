import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedStatus = 'All';
  bool _importing = false;

  final List<String> _statuses = <String>[
    'All',
    'Active',
    'Inactive',
    'Lead',
    'Customer',
    'Prospect',
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> _contactsStream() {
    return _supabase
        .from('contacts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (rows) => rows
              .where((row) => row['deleted_at'] == null)
              .map((row) => Map<String, dynamic>.from(row))
              .toList(),
        );
  }

  List<Map<String, dynamic>> _filterContacts(
    List<Map<String, dynamic>> contacts,
  ) {
    return contacts.where((contact) {
      final String name =
          (contact['name'] ?? '').toString().toLowerCase();
      final String company =
          (contact['company'] ?? '').toString().toLowerCase();
      final String email =
          (contact['email'] ?? '').toString().toLowerCase();
      final String mobile =
          (contact['mobile'] ?? '').toString().toLowerCase();
      final String designation =
          (contact['designation'] ?? '').toString().toLowerCase();
      final String department =
          (contact['department'] ?? '').toString().toLowerCase();
      final String status =
          (contact['status'] ?? '').toString();

      final bool matchesSearch =
          _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          company.contains(_searchQuery) ||
          email.contains(_searchQuery) ||
          mobile.contains(_searchQuery) ||
          designation.contains(_searchQuery) ||
          department.contains(_searchQuery);

      final bool matchesStatus =
          _selectedStatus == 'All' || status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

 Future<void> _importContacts() async {
  if (_importing) return;

  try {
    setState(() {
      _importing = true;
    });

    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['csv'],
    );

    if (files.isEmpty) {
      return;
    }

    final PlatformFile file = files.first;

    final String? filePath = file.path;

    if (filePath == null || filePath.isEmpty) {
      throw Exception(
        'Unable to access the selected CSV file.',
      );
    }

    final File selectedFile = File(filePath);

    if (!await selectedFile.exists()) {
      throw Exception(
        'The selected CSV file could not be found.',
      );
    }

    final List<int> bytes = await selectedFile.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception(
        'The selected CSV file is empty.',
      );
    }

    final String content = utf8.decode(
      bytes,
      allowMalformed: true,
    );

    final List<List<String>> rows = _parseCsv(content);

    if (rows.isEmpty) {
      throw Exception(
        'The CSV file is empty.',
      );
    }

    final List<String> headers = rows.first
        .map(
          (header) => header.trim().toLowerCase(),
        )
        .toList();

    if (headers.isEmpty) {
      throw Exception(
        'The CSV file does not contain valid headers.',
      );
    }

    final List<Map<String, dynamic>> data =
        <Map<String, dynamic>>[];

    for (int i = 1; i < rows.length; i++) {
      final List<String> row = rows[i];

      if (row.every(
        (value) => value.trim().isEmpty,
      )) {
        continue;
      }

      String getValue(List<String> names) {
        for (final String name in names) {
          final int index =
              headers.indexOf(name.toLowerCase());

          if (index >= 0 && index < row.length) {
            final String value = row[index].trim();

            if (value.isNotEmpty) {
              return value;
            }
          }
        }

        return '';
      }

      final String name = getValue(
        <String>[
          'name',
          'full name',
          'fullname',
          'contact name',
        ],
      );

      if (name.isEmpty) {
        continue;
      }

      final String importedStatus = getValue(
        <String>['status'],
      );

      data.add(
        <String, dynamic>{
          'name': name,
          'company': getValue(
            <String>[
              'company',
              'company name',
              'organisation',
              'organization',
            ],
          ),
          'designation': getValue(
            <String>[
              'designation',
              'job title',
              'title',
              'position',
            ],
          ),
          'department': getValue(
            <String>[
              'department',
              'dept',
            ],
          ),
          'mobile': getValue(
            <String>[
              'mobile',
              'phone',
              'phone number',
              'mobile number',
            ],
          ),
          'email': getValue(
            <String>[
              'email',
              'email address',
            ],
          ),
          'website': getValue(
            <String>[
              'website',
              'web',
              'url',
            ],
          ),
          'address': getValue(
            <String>[
              'address',
              'street',
            ],
          ),
          'city': getValue(
            <String>['city'],
          ),
          'state': getValue(
            <String>[
              'state',
              'province',
            ],
          ),
          'country': getValue(
            <String>['country'],
          ),
          'notes': getValue(
            <String>[
              'notes',
              'note',
              'remarks',
            ],
          ),
          'status': importedStatus.isEmpty
              ? 'Active'
              : importedStatus,
          'created_at':
              DateTime.now().toIso8601String(),
        },
      );
    }

    if (data.isEmpty) {
      throw Exception(
        'No valid contacts were found in the CSV file.',
      );
    }

    await _supabase
        .from('contacts')
        .insert(data);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${data.length} contact'
          '${data.length == 1 ? '' : 's'} '
          'imported successfully.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Import failed: $e',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        _importing = false;
      });
    }
  }
}

  List<List<String>> _parseCsv(String content) {
    final List<List<String>> rows =
        <List<String>>[];

    final List<String> currentRow =
        <String>[];

    final StringBuffer currentField =
        StringBuffer();

    bool insideQuotes = false;

    for (int i = 0; i < content.length; i++) {
      final String char = content[i];

      if (char == '"') {
        if (insideQuotes &&
            i + 1 < content.length &&
            content[i + 1] == '"') {
          currentField.write('"');
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char == ',' && !insideQuotes) {
        currentRow.add(
          currentField.toString(),
        );

        currentField.clear();
      } else if (
          (char == '\n' || char == '\r') &&
          !insideQuotes) {
        if (char == '\r' &&
            i + 1 < content.length &&
            content[i + 1] == '\n') {
          i++;
        }

        currentRow.add(
          currentField.toString(),
        );

        rows.add(
          List<String>.from(currentRow),
        );

        currentRow.clear();
        currentField.clear();
      } else {
        currentField.write(char);
      }
    }

    if (currentField.isNotEmpty ||
        currentRow.isNotEmpty) {
      currentRow.add(
        currentField.toString(),
      );

      rows.add(
        List<String>.from(currentRow),
      );
    }

    return rows;
  }

  Future<void> _showContactDialog({
    Map<String, dynamic>? contact,
  }) async {
    final bool editing = contact != null;

    final GlobalKey<FormState> formKey =
        GlobalKey<FormState>();

    final TextEditingController nameController =
        TextEditingController(
      text: contact?['name']?.toString() ?? '',
    );

    final TextEditingController companyController =
        TextEditingController(
      text: contact?['company']?.toString() ?? '',
    );

    final TextEditingController designationController =
        TextEditingController(
      text: contact?['designation']?.toString() ?? '',
    );

    final TextEditingController departmentController =
        TextEditingController(
      text: contact?['department']?.toString() ?? '',
    );

    final TextEditingController mobileController =
        TextEditingController(
      text: contact?['mobile']?.toString() ?? '',
    );

    final TextEditingController emailController =
        TextEditingController(
      text: contact?['email']?.toString() ?? '',
    );

    final TextEditingController websiteController =
        TextEditingController(
      text: contact?['website']?.toString() ?? '',
    );

    final TextEditingController addressController =
        TextEditingController(
      text: contact?['address']?.toString() ?? '',
    );

    final TextEditingController cityController =
        TextEditingController(
      text: contact?['city']?.toString() ?? '',
    );

    final TextEditingController stateController =
        TextEditingController(
      text: contact?['state']?.toString() ?? '',
    );

    final TextEditingController countryController =
        TextEditingController(
      text: contact?['country']?.toString() ?? '',
    );

    final TextEditingController notesController =
        TextEditingController(
      text: contact?['notes']?.toString() ?? '',
    );

    String selectedStatus =
        contact?['status']?.toString() ?? 'Active';

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setDialogState,
          ) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.10),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Icon(
                      editing
                          ? Icons.edit_outlined
                          : Icons.person_add_alt_1,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    editing
                        ? 'Edit Contact'
                        : 'Add Contact',
                  ),
                ],
              ),
              content: SizedBox(
                width: 650,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _sectionTitle(
                          context,
                          'Basic Information',
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                controller: nameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                required: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                controller:
                                    companyController,
                                label: 'Company',
                                icon: Icons.business_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                controller:
                                    designationController,
                                label: 'Designation',
                                icon: Icons.badge_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                controller:
                                    departmentController,
                                label: 'Department',
                                icon:
                                    Icons.account_tree_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle(
                          context,
                          'Contact Information',
                          Icons.contact_phone_outlined,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                controller:
                                    mobileController,
                                label: 'Mobile',
                                icon:
                                    Icons.phone_outlined,
                                keyboardType:
                                    TextInputType.phone,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                controller:
                                    emailController,
                                label: 'Email',
                                icon:
                                    Icons.email_outlined,
                                keyboardType:
                                    TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          controller: websiteController,
                          label: 'Website',
                          icon:
                              Icons.language_outlined,
                          keyboardType:
                              TextInputType.url,
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle(
                          context,
                          'Address',
                          Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          controller: addressController,
                          label: 'Address',
                          icon:
                              Icons.home_outlined,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _textField(
                                controller: cityController,
                                label: 'City',
                                icon:
                                    Icons.location_city_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _textField(
                                controller: stateController,
                                label: 'State',
                                icon:
                                    Icons.map_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          controller: countryController,
                          label: 'Country',
                          icon:
                              Icons.public_outlined,
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle(
                          context,
                          'CRM Information',
                          Icons.insights_outlined,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: selectedStatus,
                          decoration:
                              _inputDecoration(
                            context,
                            'Status',
                            Icons.flag_outlined,
                          ),
                          items: _statuses
                              .where(
                                (String status) =>
                                    status != 'All',
                              )
                              .map(
                                (String status) {
                                  return DropdownMenuItem<
                                      String>(
                                    value: status,
                                    child: Text(status),
                                  );
                                },
                              )
                              .toList(),
                          onChanged: (
                            String? value,
                          ) {
                            if (value == null) return;

                            setDialogState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _textField(
                          controller: notesController,
                          label: 'Notes',
                          icon:
                              Icons.notes_outlined,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    if (!formKey.currentState!
                        .validate()) {
                      return;
                    }

                    try {
                      final Map<String, dynamic> data =
                          <String, dynamic>{
                        'name':
                            nameController.text.trim(),
                        'company':
                            companyController.text.trim(),
                        'designation':
                            designationController.text
                                .trim(),
                        'department':
                            departmentController.text
                                .trim(),
                        'mobile':
                            mobileController.text.trim(),
                        'email':
                            emailController.text.trim(),
                        'website':
                            websiteController.text.trim(),
                        'address':
                            addressController.text.trim(),
                        'city':
                            cityController.text.trim(),
                        'state':
                            stateController.text.trim(),
                        'country':
                            countryController.text
                                .trim(),
                        'notes':
                            notesController.text.trim(),
                        'status': selectedStatus,
                      };

                      if (editing) {
                        await _supabase
                            .from('contacts')
                            .update(data)
                            .eq(
                              'id',
                              contact['id'],
                            );
                      } else {
                        data['created_at'] =
                            DateTime.now()
                                .toIso8601String();

                        await _supabase
                            .from('contacts')
                            .insert(data);
                      }

                      if (!dialogContext.mounted) {
                        return;
                      }

                      Navigator.of(dialogContext).pop();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            editing
                                ? 'Contact updated successfully.'
                                : 'Contact created successfully.',
                          ),
                          behavior:
                              SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      if (!dialogContext.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'Unable to save contact: $e',
                          ),
                          behavior:
                              SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    editing
                        ? Icons.save_outlined
                        : Icons.add,
                  ),
                  label: Text(
                    editing ? 'Save Changes' : 'Add Contact',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    companyController.dispose();
    designationController.dispose();
    departmentController.dispose();
    mobileController.dispose();
    emailController.dispose();
    websiteController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    notesController.dispose();
  }

  Future<void> _deleteContact(
    Map<String, dynamic> contact,
  ) async {
    final String name =
        contact['name']?.toString() ?? 'this contact';

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text(
            'Are you sure you want to delete $name?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context)
                        .colorScheme
                        .error,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _supabase
          .from('contacts')
          .update({
            'deleted_at':
                DateTime.now().toIso8601String(),
          })
          .eq(
            'id',
            contact['id'],
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Contact deleted successfully.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to delete contact: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showContactDetails(
    Map<String, dynamic> contact,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        final String name =
            contact['name']?.toString() ?? 'Unknown';

        final String company =
            contact['company']?.toString() ?? '';

        final String status =
            contact['status']?.toString() ?? 'Active';

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _avatar(
                        name,
                        size: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                            ),
                            if (company.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.only(
                                  top: 4,
                                ),
                                child: Text(
                                  company,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _statusChip(
                        context,
                        status,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _detailItem(
                    context,
                    Icons.badge_outlined,
                    'Designation',
                    contact['designation'],
                  ),
                  _detailItem(
                    context,
                    Icons.account_tree_outlined,
                    'Department',
                    contact['department'],
                  ),
                  _detailItem(
                    context,
                    Icons.phone_outlined,
                    'Mobile',
                    contact['mobile'],
                  ),
                  _detailItem(
                    context,
                    Icons.email_outlined,
                    'Email',
                    contact['email'],
                  ),
                  _detailItem(
                    context,
                    Icons.language_outlined,
                    'Website',
                    contact['website'],
                  ),
                  _detailItem(
                    context,
                    Icons.home_outlined,
                    'Address',
                    contact['address'],
                  ),
                  _detailItem(
                    context,
                    Icons.location_city_outlined,
                    'City',
                    contact['city'],
                  ),
                  _detailItem(
                    context,
                    Icons.map_outlined,
                    'State',
                    contact['state'],
                  ),
                  _detailItem(
                    context,
                    Icons.public_outlined,
                    'Country',
                    contact['country'],
                  ),
                  _detailItem(
                    context,
                    Icons.notes_outlined,
                    'Notes',
                    contact['notes'],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();

                            _showContactDialog(
                              contact: contact,
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                          ),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          style:
                              FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context)
                                    .colorScheme
                                    .error,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();

                            _deleteContact(contact);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context)
              .dividerColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Builder(
      builder: (BuildContext context) {
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: _inputDecoration(
            context,
            label,
            icon,
          ),
          validator: required
              ? (String? value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return '$label is required';
                  }

                  return null;
                }
              : null,
        );
      },
    );
  }

  Widget _detailItem(
    BuildContext context,
    IconData icon,
    String title,
    dynamic value,
  ) {
    final String text =
        value?.toString().trim() ?? '';

    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                        fontWeight:
                            FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(
    String name, {
    double size = 48,
  }) {
    final String initial =
        name.trim().isEmpty
            ? '?'
            : name.trim()[0].toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.12),
      ),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
      ),
    );
  }

  Widget _statusChip(
    BuildContext context,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusColor(
          context,
          status,
        ).withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _statusColor(
            context,
            status,
          ),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _statusColor(
    BuildContext context,
    String status,
  ) {
    final ColorScheme scheme =
        Theme.of(context).colorScheme;

    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade700;

      case 'inactive':
        return Colors.grey.shade700;

      case 'lead':
        return scheme.primary;

      case 'customer':
        return Colors.teal.shade700;

      case 'prospect':
        return Colors.orange.shade700;

      default:
        return scheme.primary;
    }
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context)
                .dividerColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.10),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight:
                              FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(
    BuildContext context,
    Map<String, dynamic> contact,
  ) {
    final String name =
        contact['name']?.toString() ??
            'Unknown';

    final String company =
        contact['company']?.toString() ?? '';

    final String designation =
        contact['designation']?.toString() ?? '';

    final String email =
        contact['email']?.toString() ?? '';

    final String mobile =
        contact['mobile']?.toString() ?? '';

    final String status =
        contact['status']?.toString() ??
            'Active';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
        side: BorderSide(
          color: Theme.of(context)
              .dividerColor,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(18),
        onTap: () {
          _showContactDetails(contact);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _avatar(name),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                          ),
                        ),
                        _statusChip(
                          context,
                          status,
                        ),
                      ],
                    ),
                    if (company.isNotEmpty ||
                        designation.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 4,
                        ),
                        child: Text(
                          [
                            if (designation.isNotEmpty)
                              designation,
                            if (company.isNotEmpty)
                              company,
                          ].join(' • '),
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ),
                    if (email.isNotEmpty ||
                        mobile.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 6,
                          children: [
                            if (email.isNotEmpty)
                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons
                                        .email_outlined,
                                    size: 15,
                                    color:
                                        Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    email,
                                    style: Theme.of(
                                            context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            if (mobile.isNotEmpty)
                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons
                                        .phone_outlined,
                                    size: 15,
                                    color:
                                        Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    mobile,
                                    style: Theme.of(
                                            context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String action) {
                  if (action == 'edit') {
                    _showContactDialog(
                      contact: contact,
                    );
                  } else if (action == 'delete') {
                    _deleteContact(contact);
                  }
                },
                itemBuilder:
                    (BuildContext context) {
                  return const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(
                          Icons.edit_outlined,
                        ),
                        title: Text('Edit'),
                        contentPadding:
                            EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                        ),
                        title: Text('Delete'),
                        contentPadding:
                            EdgeInsets.zero,
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacts',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8),
            child: OutlinedButton.icon(
              onPressed:
                  _importing ? null : _importContacts,
              icon: _importing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.upload_file_outlined,
                    ),
              label: Text(
                _importing
                    ? 'Importing...'
                    : 'Import CSV',
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _contactsStream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>>
              snapshot,
        ) {
          if (snapshot.hasError) {
            return _errorState(
              context,
              snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Map<String, dynamic>> contacts =
              snapshot.data ??
                  <Map<String, dynamic>>[];

          final List<Map<String, dynamic>>
              filteredContacts =
              _filterContacts(contacts);

          final int activeCount =
              contacts.where(
            (contact) =>
                contact['status'] == 'Active',
          ).length;

          final int leadCount =
              contacts.where(
            (contact) =>
                contact['status'] == 'Lead',
          ).length;

          final int customerCount =
              contacts.where(
            (contact) =>
                contact['status'] == 'Customer',
          ).length;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: CustomScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        if (constraints.maxWidth <
                            700) {
                          return Column(
                            children: [
                              _statCard(
                                context,
                                'Total',
                                contacts.length
                                    .toString(),
                                Icons
                                    .contacts_outlined,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _statCard(
                                context,
                                'Active',
                                activeCount
                                    .toString(),
                                Icons
                                    .check_circle_outline,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _statCard(
                                context,
                                'Leads',
                                leadCount
                                    .toString(),
                                Icons
                                    .trending_up,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _statCard(
                                context,
                                'Customers',
                                customerCount
                                    .toString(),
                                Icons
                                    .star_outline,
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            _statCard(
                              context,
                              'Total',
                              contacts.length
                                  .toString(),
                              Icons.contacts_outlined,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            _statCard(
                              context,
                              'Active',
                              activeCount.toString(),
                              Icons
                                  .check_circle_outline,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            _statCard(
                              context,
                              'Leads',
                              leadCount.toString(),
                              Icons.trending_up,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            _statCard(
                              context,
                              'Customers',
                              customerCount
                                  .toString(),
                              Icons.star_outline,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints constraints,
                      ) {
                        final Widget search =
                            TextField(
                          controller:
                              _searchController,
                          decoration:
                              InputDecoration(
                            hintText:
                                'Search contacts...',
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            suffixIcon:
                                _searchQuery
                                        .isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController
                                              .clear();
                                        },
                                        icon:
                                            const Icon(
                                          Icons
                                              .clear,
                                        ),
                                      )
                                    : null,
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(14),
                            ),
                          ),
                        );

                        final Widget filter =
                            DropdownButtonFormField<
                                String>(
                          initialValue:
                              _selectedStatus,
                          decoration:
                              InputDecoration(
                            labelText: 'Status',
                            prefixIcon:
                                const Icon(
                              Icons.filter_list,
                            ),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(14),
                            ),
                          ),
                          items: _statuses
                              .map(
                                (
                                  String status,
                                ) =>
                                    DropdownMenuItem<
                                        String>(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: (
                            String? value,
                          ) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              _selectedStatus =
                                  value;
                            });
                          },
                        );

                        if (constraints.maxWidth <
                            650) {
                          return Column(
                            children: [
                              search,
                              const SizedBox(
                                height: 12,
                              ),
                              filter,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: search,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            SizedBox(
                              width: 220,
                              child: filter,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (filteredContacts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _emptyState(
                      context,
                      contacts.isEmpty,
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      100,
                    ),
                    sliver: SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          BuildContext context,
                          int index,
                        ) {
                          return _contactCard(
                            context,
                            filteredContacts[index],
                          );
                        },
                        childCount:
                            filteredContacts.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showContactDialog();
        },
        icon: const Icon(
          Icons.person_add_alt_1,
        ),
        label: const Text(
          'Add Contact',
        ),
      ),
    );
  }

  Widget _emptyState(
    BuildContext context,
    bool noContacts,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                noContacts
                    ? Icons.contacts_outlined
                    : Icons.search_off_outlined,
                size: 48,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              noContacts
                  ? 'No contacts yet'
                  : 'No matching contacts',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              noContacts
                  ? 'Add your first contact to get started.'
                  : 'Try changing your search or status filter.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            if (noContacts) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  _showContactDialog();
                },
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Add Contact',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _errorState(
    BuildContext context,
    String error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 54,
              color: Theme.of(context)
                  .colorScheme
                  .error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load contacts',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}