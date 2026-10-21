import '../models/app_user.dart';

/// Mobile module keys permitted for department employees.
/// Adapted from the web CRM `employee-roles.ts` page list to screens that exist
/// in this Flutter app.
typedef ModuleKey = String;

class EmployeeDepartmentConfig {
  final String key;
  final String label;
  final String? dashboardTitle;
  final String summary;
  final String workflowTitle;
  final List<String> workflow;
  final List<ModuleKey> modules;
  final List<String> dataTables;

  const EmployeeDepartmentConfig({
    required this.key,
    required this.label,
    this.dashboardTitle,
    required this.summary,
    required this.workflowTitle,
    required this.workflow,
    required this.modules,
    required this.dataTables,
  });
}

const Map<String, EmployeeDepartmentConfig> kEmployeeDepartments = {
  'sales': EmployeeDepartmentConfig(
    key: 'sales',
    label: 'Sales',
    summary:
        'Your sales workspace for customer follow-ups, opportunities, and order activity.',
    workflowTitle: 'Sales workflow',
    workflow: [
      'Review assigned leads',
      'Update customer activity',
      'Move qualified opportunities forward',
    ],
    modules: [
      'leads',
      'opportunities',
      'customers',
      'contacts',
      'activities',
      'quotations',
      'orders',
      'sales-orders',
      'products',
    ],
    dataTables: ['leads', 'opportunities', 'orders', 'sales_orders'],
  ),
  'support': EmployeeDepartmentConfig(
    key: 'support',
    label: 'Support',
    dashboardTitle: 'Support Dashboard',
    summary:
        'A service workspace centered on customer cases and assigned follow-up work.',
    workflowTitle: 'Case workflow',
    workflow: [
      'Review open customer cases',
      'Work assigned follow-ups',
      'Record customer communications',
    ],
    modules: ['support', 'activities', 'customers', 'contacts'],
    dataTables: ['tickets', 'tasks', 'activities'],
  ),
  'marketing': EmployeeDepartmentConfig(
    key: 'marketing',
    label: 'Marketing',
    dashboardTitle: 'Marketing Dashboard',
    summary:
        'A campaign workspace for audience planning, outreach, and campaign reporting.',
    workflowTitle: 'Campaign workflow',
    workflow: [
      'Review campaign audiences',
      'Coordinate email and SMS outreach',
      'Measure campaign response',
    ],
    modules: ['marketing', 'contacts', 'activities'],
    dataTables: ['leads', 'contacts', 'activities'],
  ),
  'finance': EmployeeDepartmentConfig(
    key: 'finance',
    label: 'Finance',
    dashboardTitle: 'Finance Dashboard',
    summary:
        'A finance workspace for accounting, invoice status, and payment follow-up.',
    workflowTitle: 'Finance workflow',
    workflow: [
      'Review outstanding invoices',
      'Reconcile accounting activity',
      'Track payment follow-up',
    ],
    modules: ['invoices', 'quotations', 'orders', 'sales-orders'],
    dataTables: ['invoices', 'accounting_accounts', 'journal_entries'],
  ),
  'hr': EmployeeDepartmentConfig(
    key: 'hr',
    label: 'HR',
    dashboardTitle: 'HR Dashboard',
    summary:
        'A people operations workspace for employee records, recruitment, and workforce attendance.',
    workflowTitle: 'People workflow',
    workflow: [
      'Review employee records',
      'Progress recruitment activity',
      'Monitor attendance and requests',
    ],
    modules: ['employees', 'activities'],
    dataTables: ['employees', 'employee_attendance', 'employee_leaves'],
  ),
  'production': EmployeeDepartmentConfig(
    key: 'production',
    label: 'Production',
    summary:
        'A production workspace for work orders, planning, materials, and output tracking.',
    workflowTitle: 'Production workflow',
    workflow: [
      'Review production orders',
      'Check material availability',
      'Track work order progress',
    ],
    modules: ['products', 'inventory'],
    dataTables: ['production_orders', 'products', 'sales_orders'],
  ),
  'operations': EmployeeDepartmentConfig(
    key: 'operations',
    label: 'Operations',
    summary:
        'An operations workspace for stock, purchasing, and fulfillment coordination.',
    workflowTitle: 'Operations workflow',
    workflow: [
      'Check stock and warehouse status',
      'Coordinate purchase orders',
      'Resolve fulfillment exceptions',
    ],
    modules: ['inventory', 'products', 'orders', 'sales-orders'],
    dataTables: ['products', 'purchase_orders', 'orders', 'sales_orders'],
  ),
  'procurement': EmployeeDepartmentConfig(
    key: 'procurement',
    label: 'Procurement',
    summary:
        'A procurement workspace for supplier records, purchase orders, and bill coordination.',
    workflowTitle: 'Procurement workflow',
    workflow: [
      'Review purchase requests',
      'Coordinate vendor orders',
      'Track incoming bills and delivery status',
    ],
    modules: ['inventory', 'products'],
    dataTables: ['purchase_orders', 'purchase_bills', 'vendor_payments'],
  ),
  'it': EmployeeDepartmentConfig(
    key: 'it',
    label: 'IT',
    dashboardTitle: 'IT Dashboard',
    summary:
        'An IT workspace for integrations, service status, and platform access.',
    workflowTitle: 'IT operations workflow',
    workflow: [
      'Review integration status',
      'Check service availability',
      'Coordinate platform access requests',
    ],
    modules: ['activities'],
    dataTables: ['integrations'],
  ),
};

const Map<String, String> kTableLabels = {
  'leads': 'Leads',
  'opportunities': 'Opportunities',
  'sales_orders': 'Sales orders',
  'orders': 'Orders',
  'tickets': 'Customer cases',
  'tasks': 'Assigned tasks',
  'activities': 'Activities',
  'contacts': 'Contacts',
  'invoices': 'Invoices',
  'accounting_accounts': 'Accounts',
  'journal_entries': 'Journal entries',
  'integrations': 'Integrations',
  'employees': 'Employees',
  'employee_attendance': 'Attendance records',
  'employee_leaves': 'Leave requests',
  'production_orders': 'Production orders',
  'products': 'Products and stock',
  'purchase_orders': 'Purchase orders',
  'purchase_bills': 'Purchase bills',
  'vendor_payments': 'Vendor payments',
};

String normalizeDepartment(String value) {
  final normalized = value.trim().toLowerCase();
  if (RegExp(r'sales').hasMatch(normalized)) return 'sales';
  if (RegExp(r'support|service').hasMatch(normalized)) return 'support';
  if (RegExp(r'market').hasMatch(normalized)) return 'marketing';
  if (RegExp(r'finance|account|payable|receivable').hasMatch(normalized)) {
    return 'finance';
  }
  if (RegExp(r'human resource|\bhr\b').hasMatch(normalized)) return 'hr';
  if (RegExp(r'production|manufactur').hasMatch(normalized))
    return 'production';
  if (RegExp(r'operation|logistic|warehouse').hasMatch(normalized)) {
    return 'operations';
  }
  if (RegExp(r'procure|purchas').hasMatch(normalized)) return 'procurement';
  if (RegExp(r'\bit\b|information technolog').hasMatch(normalized)) return 'it';
  if (RegExp(r'customer service|customer success').hasMatch(normalized)) {
    return 'support';
  }
  return normalized;
}

/// Returns the normalized department key for an employee, or empty if not an employee.
String employeeDepartment(AppUser? user) {
  if (user == null || user.role != AppRole.employee) return '';
  final legacyRole = RegExp(r'^(employee|team member)$', caseSensitive: false)
          .hasMatch(user.roleLabel.trim())
      ? 'Sales'
      : user.roleLabel;
  return normalizeDepartment(user.department ?? legacyRole);
}

EmployeeDepartmentConfig employeeDepartmentConfig(AppUser? user) {
  final key = employeeDepartment(user);
  final configured = kEmployeeDepartments[key];
  if (configured != null) return configured;

  final roleLabel = user?.roleLabel.trim().isNotEmpty == true
      ? user!.roleLabel.trim()
      : 'Team Member';
  final departmentLabel = user?.department?.trim().isNotEmpty == true
      ? user!.department!.trim()
      : roleLabel;
  final isManager =
      RegExp(r'manager|supervisor|team lead', caseSensitive: false)
          .hasMatch(roleLabel);

  return EmployeeDepartmentConfig(
    key: key.isEmpty ? 'other' : key,
    label: departmentLabel,
    summary: '$roleLabel workspace for department assignments and handoffs.',
    workflowTitle: '$roleLabel workflow',
    workflow: isManager
        ? [
            'Review department workload',
            'Prioritize team assignments',
            'Track completion and handoffs',
          ]
        : [
            'Review your ${roleLabel.toLowerCase()} assignments',
            'Update assigned activity progress',
            'Coordinate department handoffs',
          ],
    // Restrict unknown departments to a safe default — never grant admin modules.
    modules: const ['activities'],
    dataTables: const ['tasks'],
  );
}

bool employeeCanAccessModule(AppUser? user, ModuleKey module) {
  if (user == null || user.role != AppRole.employee) return false;
  if (module == 'dashboard') return true;
  return employeeDepartmentConfig(user).modules.contains(module);
}

List<ModuleKey> employeeAllowedModules(AppUser? user) {
  if (user == null || user.role != AppRole.employee) return const [];
  return List<ModuleKey>.from(employeeDepartmentConfig(user).modules);
}

/// Admin-only modules that employees must never reach via navigation shortcuts.
const Set<ModuleKey> kAdminOnlyModules = {
  'user-management',
  'product-modules',
  'admin-panel',
  'roles',
  'settings-admin',
};
