import 'package:flutter/material.dart';

class HRScreen extends StatefulWidget {
  const HRScreen({super.key});

  @override
  State<HRScreen> createState() => _HRScreenState();
}

class _HRScreenState extends State<HRScreen> {
  String selectedPeriod = 'This Month';

  final List<_Employee> employees = [
    _Employee(
      name: 'Aakash Sharma',
      department: 'Sales',
      designation: 'Sales Manager',
      status: 'Present',
      email: 'aakash@company.com',
    ),
    _Employee(
      name: 'Priya Verma',
      department: 'HR',
      designation: 'HR Executive',
      status: 'Present',
      email: 'priya@company.com',
    ),
    _Employee(
      name: 'Rahul Kumar',
      department: 'Engineering',
      designation: 'Software Engineer',
      status: 'Leave',
      email: 'rahul@company.com',
    ),
    _Employee(
      name: 'Neha Jain',
      department: 'Marketing',
      designation: 'Marketing Executive',
      status: 'Present',
      email: 'neha@company.com',
    ),
    _Employee(
      name: 'Rohit Singh',
      department: 'Finance',
      designation: 'Accountant',
      status: 'Absent',
      email: 'rohit@company.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'HR & Employees',
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: () {
                _showAddEmployeeDialog(context);
              },
              icon: const Icon(Icons.add),
              label:
                  const Text('Add Employee'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              width < 600 ? 16 : 28,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 24),

                _buildKpis(
                  context,
                  width,
                ),

                const SizedBox(height: 24),

                if (width >= 1000)
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child:
                            _buildAttendanceCard(
                          context,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child:
                            _buildRecruitmentCard(
                          context,
                        ),
                      ),
                    ],
                  )
                else ...[
                  _buildAttendanceCard(
                    context,
                  ),
                  const SizedBox(height: 20),
                  _buildRecruitmentCard(
                    context,
                  ),
                ],

                const SizedBox(height: 24),

                _buildEmployeeSection(
                  context,
                ),

                const SizedBox(height: 24),

                _buildHrModules(
                  context,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Human Resources',
                style: theme.textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage employees, attendance, recruitment, payroll and HR operations.',
                style: theme.textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: theme
                      .colorScheme
                      .onSurface
                      .withValues(
                        alpha: 0.55,
                      ),
                ),
              ),
            ],
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedPeriod,
            items: const [
              DropdownMenuItem(
                value: 'This Month',
                child:
                    Text('This Month'),
              ),
              DropdownMenuItem(
                value: 'Last Month',
                child:
                    Text('Last Month'),
              ),
              DropdownMenuItem(
                value: 'This Year',
                child:
                    Text('This Year'),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedPeriod = value;
              });
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // KPI
  // ============================================================

  Widget _buildKpis(
    BuildContext context,
    double width,
  ) {
    int columns;

    if (width >= 1200) {
      columns = 4;
    } else if (width >= 650) {
      columns = 2;
    } else {
      columns = 1;
    }

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio:
          width < 650 ? 3 : 1.8,
      children: [
        _hrKpi(
          context,
          title: 'Total Employees',
          value: '86',
          subtitle: '+4 this month',
          icon: Icons.groups_outlined,
        ),
        _hrKpi(
          context,
          title: 'Present Today',
          value: '78',
          subtitle: '90.7% attendance',
          icon:
              Icons.check_circle_outline,
        ),
        _hrKpi(
          context,
          title: 'On Leave',
          value: '5',
          subtitle: '2 pending approvals',
          icon:
              Icons.event_busy_outlined,
        ),
        _hrKpi(
          context,
          title: 'Open Positions',
          value: '7',
          subtitle: '3 urgent hiring',
          icon: Icons.work_outline,
        ),
      ],
    );
  }

  Widget _hrKpi(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(
                color: theme
                    .colorScheme
                    .primary
                    .withValues(
                      alpha: 0.10,
                    ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Icon(
                icon,
                color: theme
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: theme
                          .colorScheme
                          .onSurface
                          .withValues(
                            alpha: 0.55,
                          ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme
                        .textTheme
                        .labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ATTENDANCE
  // ============================================================

  Widget _buildAttendanceCard(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Overview',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Employee attendance summary',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                      alpha: 0.5,
                    ),
              ),
            ),
            const SizedBox(height: 25),

            _attendanceRow(
              context,
              'Present',
              78,
              0.907,
              Colors.green,
            ),
            _attendanceRow(
              context,
              'On Leave',
              5,
              0.058,
              Colors.orange,
            ),
            _attendanceRow(
              context,
              'Absent',
              3,
              0.035,
              Colors.red,
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _attendanceMini(
                    context,
                    'Avg. Attendance',
                    '90.7%',
                  ),
                ),
                Expanded(
                  child: _attendanceMini(
                    context,
                    'Late Arrivals',
                    '8',
                  ),
                ),
                Expanded(
                  child: _attendanceMini(
                    context,
                    'Early Leaves',
                    '3',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attendanceRow(
    BuildContext context,
    String title,
    int count,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count employees',
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            child:
                LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: color,
              backgroundColor:
                  color.withValues(
                alpha: 0.10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceMini(
    BuildContext context,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              theme.textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme
              .titleMedium
              ?.copyWith(
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECRUITMENT
  // ============================================================

  Widget _buildRecruitmentCard(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Recruitment',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Current hiring pipeline',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurface
                    .withValues(
                      alpha: 0.5,
                    ),
              ),
            ),
            const SizedBox(height: 22),

            _recruitmentRow(
              context,
              'Applications',
              '142',
              0.90,
            ),
            _recruitmentRow(
              context,
              'Shortlisted',
              '48',
              0.55,
            ),
            _recruitmentRow(
              context,
              'Interviews',
              '26',
              0.38,
            ),
            _recruitmentRow(
              context,
              'Selected',
              '9',
              0.18,
            ),

            const SizedBox(height: 10),

            FilledButton.icon(
              onPressed: () {
                _showMessage(
                  context,
                  'Recruitment management will open here.',
                );
              },
              icon: const Icon(
                Icons.person_search,
              ),
              label:
                  const Text('Manage Recruitment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recruitmentRow(
    BuildContext context,
    String title,
    String value,
    double progress,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 15,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: theme
                  .textTheme
                  .bodySmall,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              child:
                  LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor:
                    theme
                        .colorScheme
                        .primary
                        .withValues(
                          alpha: 0.08,
                        ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 30,
            child: Text(
              value,
              textAlign:
                  TextAlign.right,
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPLOYEES
  // ============================================================

  Widget _buildEmployeeSection(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employees',
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Employee directory and current status',
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurface
                              .withValues(
                                alpha: 0.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _showAddEmployeeDialog(
                      context,
                    );
                  },
                  icon:
                      const Icon(Icons.add),
                  label:
                      const Text('Add Employee'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text('Employee'),
                  ),
                  DataColumn(
                    label:
                        Text('Department'),
                  ),
                  DataColumn(
                    label:
                        Text('Designation'),
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                ],
                rows: employees
                    .map(
                      (employee) =>
                          DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  child: Text(
                                    _initials(
                                      employee
                                          .name,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  employee
                                      .name,
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              employee
                                  .department,
                            ),
                          ),
                          DataCell(
                            Text(
                              employee
                                  .designation,
                            ),
                          ),
                          DataCell(
                            _statusChip(
                              context,
                              employee
                                  .status,
                            ),
                          ),
                          DataCell(
                            IconButton(
                              tooltip:
                                  'View employee',
                              onPressed: () {
                                _showEmployee(
                                  context,
                                  employee,
                                );
                              },
                              icon: const Icon(
                                Icons
                                    .arrow_forward_ios,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(
    BuildContext context,
    String status,
  ) {
    Color color;

    switch (status) {
      case 'Present':
        color = Colors.green;
        break;
      case 'Leave':
        color = Colors.orange;
        break;
      case 'Absent':
        color = Colors.red;
        break;
      default:
        color =
            Theme.of(context)
                .colorScheme
                .primary;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  // ============================================================
  // HR MODULES
  // ============================================================

  Widget _buildHrModules(
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    final modules = [
      _HrModule(
        'Employees',
        Icons.groups_outlined,
      ),
      _HrModule(
        'Attendance',
        Icons.fact_check_outlined,
      ),
      _HrModule(
        'Leave Management',
        Icons.event_available_outlined,
      ),
      _HrModule(
        'Recruitment',
        Icons.person_search_outlined,
      ),
      _HrModule(
        'Payroll',
        Icons.payments_outlined,
      ),
      _HrModule(
        'Performance',
        Icons.assessment_outlined,
      ),
      _HrModule(
        'Departments',
        Icons.account_tree_outlined,
      ),
      _HrModule(
        'Documents',
        Icons.folder_shared_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'HR Modules',
          style: theme
              .textTheme
              .titleMedium
              ?.copyWith(
            fontWeight:
                FontWeight.w800,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 95,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (
            context,
            index,
          ) {
            final module =
                modules[index];

            return Card(
              child: InkWell(
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
                onTap: () {
                  _showMessage(
                    context,
                    '${module.title} will open here.',
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration:
                            BoxDecoration(
                          color: theme
                              .colorScheme
                              .primary
                              .withValues(
                                alpha: 0.10,
                              ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            11,
                          ),
                        ),
                        child: Icon(
                          module.icon,
                          color: theme
                              .colorScheme
                              .primary,
                        ),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      Expanded(
                        child: Text(
                          module.title,
                          style: theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // DIALOGS
  // ============================================================

  void _showAddEmployeeDialog(
    BuildContext context,
  ) {
    final nameController =
        TextEditingController();

    final emailController =
        TextEditingController();

    final departmentController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add Employee'),
          content: SizedBox(
            width: 430,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  TextField(
                    controller:
                        nameController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Employee Name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller:
                        emailController,
                    decoration:
                        const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller:
                        departmentController,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Department',
                      prefixIcon: Icon(
                        Icons.business_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);

                _showMessage(
                  context,
                  'Employee saved successfully.',
                );
              },
              child:
                  const Text('Save Employee'),
            ),
          ],
        );
      },
    );
  }

  void _showEmployee(
    BuildContext context,
    _Employee employee,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(employee.name),
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _detail(
                'Email',
                employee.email,
              ),
              _detail(
                'Department',
                employee.department,
              ),
              _detail(
                'Designation',
                employee.designation,
              ),
              _detail(
                'Status',
                employee.status,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detail(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _initials(String name) {
    final parts =
        name.trim().split(
              RegExp(r'\s+'),
            );

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.isNotEmpty
          ? parts.first[0].toUpperCase()
          : 'U';
    }

    return '${parts.first[0]}${parts.last[0]}'
        .toUpperCase();
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class _Employee {
  final String name;
  final String department;
  final String designation;
  final String status;
  final String email;

  const _Employee({
    required this.name,
    required this.department,
    required this.designation,
    required this.status,
    required this.email,
  });
}

class _HrModule {
  final String title;
  final IconData icon;

  const _HrModule(
    this.title,
    this.icon,
  );
}