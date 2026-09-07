import 'package:flutter/material.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';
  String _selectedSource = 'All';
  String _selectedPriority = 'All';

  final List<Map<String, dynamic>> _leads = [
    {
      'name': 'Rajesh Kumar',
      'company': 'ABC Solar Pvt. Ltd.',
      'phone': '+91 9876543210',
      'email': 'rajesh@abcsolar.com',
      'source': 'IndiaMART',
      'status': 'New',
      'priority': 'High',
      'assignedTo': 'Amit Sharma',
      'value': 250000,
      'city': 'Delhi',
      'lastContact': 'Today',
    },
    {
      'name': 'Sanjay Mehta',
      'company': 'Mehta Engineering',
      'phone': '+91 9812345678',
      'email': 'sanjay@mehtaengineering.com',
      'source': 'WhatsApp',
      'status': 'Contacted',
      'priority': 'Medium',
      'assignedTo': 'Rahul Verma',
      'value': 150000,
      'city': 'Noida',
      'lastContact': 'Yesterday',
    },
    {
      'name': 'Priya Singh',
      'company': 'Green Energy Solutions',
      'phone': '+91 9898989898',
      'email': 'priya@greenenergy.com',
      'source': 'Website',
      'status': 'Qualified',
      'priority': 'High',
      'assignedTo': 'Amit Sharma',
      'value': 500000,
      'city': 'Gurugram',
      'lastContact': '2 days ago',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'New':
        return Colors.blue;
      case 'Contacted':
        return Colors.orange;
      case 'Qualified':
        return Colors.green;
      case 'Proposal':
        return Colors.purple;
      case 'Won':
        return Colors.teal;
      case 'Lost':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _sourceIcon(String source) {
    switch (source) {
      case 'WhatsApp':
        return Icons.chat;
      case 'Call':
        return Icons.phone;
      case 'IndiaMART':
        return Icons.storefront;
      case 'TradeIndia':
        return Icons.business;
      case 'Website':
        return Icons.language;
      case 'Facebook':
        return Icons.facebook;
      case 'Instagram':
        return Icons.camera_alt;
      case 'LinkedIn':
        return Icons.work;
      case 'Email':
        return Icons.email;
      case 'Referral':
        return Icons.people;
      default:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leads',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              'Manage and convert your sales opportunities',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () => _showLeadForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Lead'),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          _buildSummary(context),

          _buildFilters(context),

          Expanded(
            child: _buildLeadList(context),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLeadForm(context),
        icon: const Icon(Icons.person_add),
        label: const Text('New Lead'),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        scrollDirection: Axis.horizontal,
        children: [
          _statCard(
            context,
            'Total Leads',
            '248',
            Icons.people_alt_outlined,
            Colors.blue,
          ),
          _statCard(
            context,
            'New',
            '42',
            Icons.fiber_new,
            Colors.indigo,
          ),
          _statCard(
            context,
            'Qualified',
            '67',
            Icons.verified_outlined,
            Colors.green,
          ),
          _statCard(
            context,
            'Follow-ups',
            '18',
            Icons.event_repeat,
            Colors.orange,
          ),
          _statCard(
            context,
            'Pipeline',
            '₹48.6L',
            Icons.currency_rupee,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search leads, company, phone or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 10),

          _dropdown(
            context,
            'Status',
            _selectedStatus,
            [
              'All',
              'New',
              'Contacted',
              'Qualified',
              'Proposal',
              'Won',
              'Lost',
            ],
            (value) {
              setState(() => _selectedStatus = value!);
            },
          ),

          const SizedBox(width: 10),

          _dropdown(
            context,
            'Source',
            _selectedSource,
            [
              'All',
              'Call',
              'WhatsApp',
              'IndiaMART',
              'TradeIndia',
              'Website',
              'Facebook',
              'Instagram',
              'LinkedIn',
              'Email',
              'Referral',
            ],
            (value) {
              setState(() => _selectedSource = value!);
            },
          ),

          const SizedBox(width: 10),

          _dropdown(
            context,
            'Priority',
            _selectedPriority,
            [
              'All',
              'High',
              'Medium',
              'Low',
            ],
            (value) {
              setState(() => _selectedPriority = value!);
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return SizedBox(
      width: 145,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLeadList(BuildContext context) {
    final query = _searchController.text.toLowerCase();

    final filtered = _leads.where((lead) {
      final matchesSearch =
          lead['name'].toString().toLowerCase().contains(query) ||
          lead['company'].toString().toLowerCase().contains(query) ||
          lead['phone'].toString().toLowerCase().contains(query) ||
          lead['email'].toString().toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatus == 'All' ||
          lead['status'] == _selectedStatus;

      final matchesSource =
          _selectedSource == 'All' ||
          lead['source'] == _selectedSource;

      final matchesPriority =
          _selectedPriority == 'All' ||
          lead['priority'] == _selectedPriority;

      return matchesSearch &&
          matchesStatus &&
          matchesSource &&
          matchesPriority;
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text('No leads found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _leadCard(context, filtered[index]);
      },
    );
  }

  Widget _leadCard(
    BuildContext context,
    Map<String, dynamic> lead,
  ) {
    final colors = Theme.of(context).colorScheme;

    final statusColor =
        _statusColor(context, lead['status']);

    final priorityColor =
        _priorityColor(lead['priority']);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colors.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showLeadDetails(context, lead),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor:
                    colors.primaryContainer,
                child: Text(
                  lead['name']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lead['company'],
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(lead['phone']),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(lead['city']),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _sourceIcon(lead['source']),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lead['source'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          lead['assignedTo'],
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _badge(
                      context,
                      lead['status'],
                      statusColor,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 15,
                          color: priorityColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          lead['priority'],
                          style: TextStyle(
                            color: priorityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  IconButton(
                    tooltip: 'Call',
                    icon: const Icon(Icons.phone),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'More',
                    icon: const Icon(Icons.more_vert),
                    onPressed: () =>
                        _showLeadMenu(context, lead),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(
    BuildContext context,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLeadMenu(
    BuildContext context,
    Map<String, dynamic> lead,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Lead'),
                onTap: () {
                  Navigator.pop(context);
                  _showLeadDetails(context, lead);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Lead'),
                onTap: () {
                  Navigator.pop(context);
                  _showLeadForm(
                    context,
                    existingLead: lead,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Reassign Lead'),
                onTap: () {
                  Navigator.pop(context);
                  _showAssignDialog(context, lead);
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Schedule Follow-up'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAssignDialog(
    BuildContext context,
    Map<String, dynamic> lead,
  ) {
    String selected = lead['assignedTo'];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Assign Salesperson'),
          content: DropdownButtonFormField<String>(
            initialValue: selected,
            decoration: const InputDecoration(
              labelText: 'Salesperson',
            ),
            items: [
              'Amit Sharma',
              'Rahul Verma',
              'Neha Gupta',
              'Suresh Kumar',
            ]
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                selected = value;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  lead['assignedTo'] = selected;
                });
                Navigator.pop(context);
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void _showLeadDetails(
    BuildContext context,
    Map<String, dynamic> lead,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        final colors = Theme.of(context).colorScheme;

        return FractionallySizedBox(
          heightFactor: .9,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(
                        lead['name']
                            .toString()
                            .substring(0, 1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead['name'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(lead['company']),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chat),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _sectionTitle('Lead Information'),

                _detailRow(
                  'Lead Source',
                  lead['source'],
                  Icons.source,
                ),
                _detailRow(
                  'Status',
                  lead['status'],
                  Icons.flag,
                ),
                _detailRow(
                  'Priority',
                  lead['priority'],
                  Icons.priority_high,
                ),
                _detailRow(
                  'Assigned To',
                  lead['assignedTo'],
                  Icons.person,
                ),
                _detailRow(
                  'Phone',
                  lead['phone'],
                  Icons.phone,
                ),
                _detailRow(
                  'Email',
                  lead['email'],
                  Icons.email,
                ),
                _detailRow(
                  'Location',
                  lead['city'],
                  Icons.location_on,
                ),
                _detailRow(
                  'Estimated Value',
                  '₹${lead['value']}',
                  Icons.currency_rupee,
                ),

                const SizedBox(height: 20),

                _sectionTitle('Activity'),

                Card(
                  elevation: 0,
                  color: colors.surfaceContainerHighest,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.phone),
                          title: Text('Called customer'),
                          subtitle:
                              Text('Today, 11:30 AM'),
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.chat),
                          title:
                              Text('WhatsApp message sent'),
                          subtitle:
                              Text('Yesterday'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _detailRow(
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showLeadForm(
    BuildContext context, {
    Map<String, dynamic>? existingLead,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 25,
          ),
          child: _LeadForm(
            existingLead: existingLead,
          ),
        );
      },
    );
  }
}

class _LeadForm extends StatefulWidget {
  final Map<String, dynamic>? existingLead;

  const _LeadForm({
    this.existingLead,
  });

  @override
  State<_LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<_LeadForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final designationController = TextEditingController();
  final departmentController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateMobileController =
      TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final valueController = TextEditingController();
  final notesController = TextEditingController();

  String source = 'Call';
  String status = 'New';
  String priority = 'Medium';
  String assignedTo = 'Amit Sharma';

  final sources = [
    'Call',
    'WhatsApp',
    'IndiaMART',
    'TradeIndia',
    'Website',
    'Facebook',
    'Instagram',
    'LinkedIn',
    'Email',
    'Referral',
    'Walk-in',
    'Existing Customer',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final lead = widget.existingLead;

    if (lead != null) {
      nameController.text = lead['name'] ?? '';
      companyController.text = lead['company'] ?? '';
      mobileController.text = lead['phone'] ?? '';
      emailController.text = lead['email'] ?? '';
      cityController.text = lead['city'] ?? '';
      valueController.text =
          lead['value']?.toString() ?? '';

      source = lead['source'] ?? 'Call';
      status = lead['status'] ?? 'New';
      priority = lead['priority'] ?? 'Medium';
      assignedTo =
          lead['assignedTo'] ?? 'Amit Sharma';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    designationController.dispose();
    departmentController.dispose();
    mobileController.dispose();
    alternateMobileController.dispose();
    emailController.dispose();
    websiteController.dispose();
    cityController.dispose();
    addressController.dispose();
    valueController.dispose();
    notesController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.existingLead == null
                        ? 'Create New Lead'
                        : 'Edit Lead',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _heading('Basic Information'),

                      _row([
                        _field(
                          nameController,
                          'Contact Person *',
                          Icons.person,
                          required: true,
                        ),
                        _field(
                          companyController,
                          'Company Name',
                          Icons.business,
                        ),
                      ]),

                      const SizedBox(height: 14),

                      _row([
                        _field(
                          designationController,
                          'Designation',
                          Icons.badge,
                        ),
                        _field(
                          departmentController,
                          'Department',
                          Icons.account_tree,
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _heading('Contact Information'),

                      _row([
                        _field(
                          mobileController,
                          'Mobile Number *',
                          Icons.phone,
                          required: true,
                        ),
                        _field(
                          alternateMobileController,
                          'Alternate / Personal Number',
                          Icons.phone_android,
                        ),
                      ]),

                      const SizedBox(height: 14),

                      _row([
                        _field(
                          emailController,
                          'Email Address',
                          Icons.email,
                        ),
                        _field(
                          websiteController,
                          'Website',
                          Icons.language,
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _heading('Lead Source & Assignment'),

                      _row([
                        DropdownButtonFormField<String>(
                          initialValue: source,
                          decoration: _decoration(
                            'Lead Source',
                            Icons.source,
                          ),
                          items: sources
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                () => source = value,
                              );
                            }
                          },
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: assignedTo,
                          decoration: _decoration(
                            'Assigned Salesperson',
                            Icons.person_pin,
                          ),
                          items: [
                            'Amit Sharma',
                            'Rahul Verma',
                            'Neha Gupta',
                            'Suresh Kumar',
                          ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                () =>
                                    assignedTo = value,
                              );
                            }
                          },
                        ),
                      ]),

                      const SizedBox(height: 14),

                      _row([
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: _decoration(
                            'Lead Status',
                            Icons.flag,
                          ),
                          items: [
                            'New',
                            'Contacted',
                            'Qualified',
                            'Proposal',
                            'Won',
                            'Lost',
                          ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                () => status = value,
                              );
                            }
                          },
                        ),

                        DropdownButtonFormField<String>(
                          initialValue: priority,
                          decoration: _decoration(
                            'Priority',
                            Icons.priority_high,
                          ),
                          items: [
                            'High',
                            'Medium',
                            'Low',
                          ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(
                                () =>
                                    priority = value,
                              );
                            }
                          },
                        ),
                      ]),

                      const SizedBox(height: 24),

                      _heading('Business Information'),

                      _row([
                        _field(
                          valueController,
                          'Estimated Deal Value',
                          Icons.currency_rupee,
                        ),
                        _field(
                          cityController,
                          'City / Office Location',
                          Icons.location_city,
                        ),
                      ]),

                      const SizedBox(height: 14),

                      _field(
                        addressController,
                        'Complete Address',
                        Icons.location_on,
                        fullWidth: true,
                      ),

                      const SizedBox(height: 14),

                      _field(
                        notesController,
                        'Notes / Requirement Details',
                        Icons.notes,
                        maxLines: 4,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _saveLead,
                    icon: const Icon(Icons.save),
                    label: Text(
                      widget.existingLead == null
                          ? 'Create Lead'
                          : 'Update Lead',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
    bool fullWidth = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: required
          ? (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _saveLead() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final lead = {
      'name': nameController.text.trim(),
      'company': companyController.text.trim(),
      'designation':
          designationController.text.trim(),
      'department':
          departmentController.text.trim(),
      'phone': mobileController.text.trim(),
      'alternatePhone':
          alternateMobileController.text.trim(),
      'email': emailController.text.trim(),
      'website': websiteController.text.trim(),
      'source': source,
      'status': status,
      'priority': priority,
      'assignedTo': assignedTo,
      'city': cityController.text.trim(),
      'address': addressController.text.trim(),
      'estimatedValue':
          valueController.text.trim(),
      'notes': notesController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    debugPrint('Lead: $lead');

    Navigator.pop(context);
  }
}