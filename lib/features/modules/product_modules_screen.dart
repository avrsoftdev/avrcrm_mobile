
import 'package:flutter/material.dart';
import 'all_feature_screens.dart';

class ProductModulesScreen extends StatelessWidget {
  const ProductModulesScreen({super.key});

  /// Resolves CRM sidebar labels to existing module screens while preserving
  /// the All Products & Modules catalog.
  Widget? sidebarScreenFor(String section, String item) {
    final target = switch ('$section::$item') {
      'Finance::Invoices' => ('Sales & Invoicing', 'Invoices'),
      'Finance::Payment Tracking' => ('Sales & Invoicing', 'Payment Tracking'),
      'Finance::Outstanding' => ('Sales & Invoicing', 'Outstanding Reports'),
      'Finance::Recurring Invoices' => ('Sales & Invoicing', 'Recurring Invoices'),
      'Finance::Credit / Debit Notes' => ('Sales & Invoicing', 'Credit/Debit Notes'),
      'Finance::GST / e-Invoice' => ('Sales & Invoicing', 'GST / e-Invoice'),
      'CRM::Dashboard' => ('Reports & Dashboards', 'CRM Dashboard'),
      'CRM::Leads' => ('CRM', 'Lead Management'),
      'CRM::Opportunities' => ('CRM', 'Deals / Opportunities'),
      'CRM::Customers' => ('CRM', 'Customer Management'),
      'CRM::Contacts' => ('CRM', 'Contact Management'),
      'CRM::Activities' => ('CRM', 'Sales Activities'),
      'Sales & Invoicing::Quotations' => ('Sales & Invoicing', 'Quotations'),
      'Sales & Invoicing::Sales Orders' => ('Sales & Invoicing', 'Sales Orders'),
      'Sales & Invoicing::Orders' => ('Sales & Invoicing', 'Sales Orders'),
      'Purchase::Vendors' => ('Purchase', 'Vendors'),
      'Purchase::Purchase Orders' => ('Purchase', 'Purchase Orders'),
      'Inventory & Production::Products' => ('Inventory', 'Products'),
      'Inventory & Production::Inventory' => ('Inventory', 'Stock Management'),
      'Inventory & Production::Production' => ('Production', 'Production Module'),
      'HR & Marketing::HR & Employees' => ('HR / HR-One', 'Employee Management'),
      'HR & Marketing::Attendance' => ('HR / HR-One', 'Attendance'),
      'HR & Marketing::Recruitment' => ('HR / HR-One', 'Recruitment'),
      'HR & Marketing::Templates' => ('Templates', 'Custom Templates'),
      'HR & Marketing::SMS Campaigns' => ('Marketing', 'Campaign Management'),
      'HR & Marketing::Email Campaigns' => ('Marketing', 'Email Marketing'),
      'HR & Marketing::Marketing' => ('Marketing', 'Campaign Management'),
      'HR & Marketing::Communication' => ('Marketing', 'WhatsApp Marketing'),
      'Insights & Platform::Reports' => ('Reports & Dashboards', 'Custom Reports'),
      'Insights & Platform::Sales Dashboard' => ('Reports & Dashboards', 'Sales Dashboard'),
      'Insights & Platform::Integrations' => ('Integrations', 'Third-Party Integration'),
      'Insights & Platform::Android App' => ('Mobile & Web', 'Android Application'),
      'Insights & Platform::Services' => ('Services', 'Cloud Hosting'),
      'System::Notifications' => ('Mobile & Web', 'Mobile Notifications'),
      'System::Activity Logs' => ('Security', 'Activity Logs'),
      'System::Approvals' => ('Security', 'Approval Workflows'),
      'System::Settings' => ('Security', 'Admin Panel'),
      _ => null,
    };
    return target == null ? null : _screenFor(target.$1, target.$2);
  }

  static const _modules = <Map<String, dynamic>>[
    {'name': 'CRM', 'icon': Icons.people_alt_rounded, 'features': [
      'Lead Management','Customer Management','Contact Management','Follow-up Management',
      'Sales Pipeline','Deals / Opportunities','Sales Activities','CRM Reports'
    ]},
    {'name': 'Sales & Invoicing', 'icon': Icons.receipt_long_rounded, 'features': [
      'Quotations','Sales Orders','Invoices','Payment Tracking','Outstanding Reports',
      'Invoice Templates','Recurring Invoices','Credit/Debit Notes','GST / e-Invoice'
    ]},
    {'name': 'Purchase', 'icon': Icons.shopping_bag_rounded, 'features': [
      'Vendors','Purchase Orders','Purchase Bills','Purchase Returns','Vendor Payments'
    ]},
    {'name': 'Inventory', 'icon': Icons.inventory_2_rounded, 'features': [
      'Products','Stock Management','Stock In/Out','Stock Adjustment','Low Stock Alerts',
      'Stock Transfer','Multiple Warehouses','Batch Management','Inventory Reports'
    ]},
    {'name': 'Production', 'icon': Icons.precision_manufacturing_rounded, 'features': [
      'Production Module','Bill of Materials (BOM)','Production Orders','Raw Material Management',
      'Finished Goods','Work Orders','Production Planning','Production Tracking','Production Reports'
    ]},
    {'name': 'HR / HR-One', 'icon': Icons.badge_rounded, 'features': [
      'Employee Management','Employee Profiles','Departments','Designations','Attendance',
      'Leave Management','Holiday Management','Payroll','Payslips','Employee Documents',
      'Performance Management','Recruitment'
    ]},
    {'name': 'Marketing', 'icon': Icons.campaign_rounded, 'features': [
      'Campaign Management','Marketing Templates','Customer Segmentation','Email Marketing',
      'WhatsApp Marketing','Campaign Reports'
    ]},
    {'name': 'Templates', 'icon': Icons.dashboard_customize_rounded, 'features': [
      'Invoice Templates','Quotation Templates','Email Templates','HR Templates','Custom Templates'
    ]},
    {'name': 'Reports & Dashboards', 'icon': Icons.analytics_rounded, 'features': [
      'Management Dashboard','Sales Dashboard','CRM Dashboard','HR Dashboard','Inventory Dashboard',
      'Production Dashboard','Custom Reports','Export to Excel/PDF'
    ]},
    {'name': 'Mobile & Web', 'icon': Icons.devices_rounded, 'features': [
      'Web Application','Android Application','Mobile Dashboard','Mobile Notifications'
    ]},
    {'name': 'Security', 'icon': Icons.security_rounded, 'features': [
      'User Management','Role-Based Access','Admin Panel','Activity Logs','Approval Workflows'
    ]},
    {'name': 'Integrations', 'icon': Icons.integration_instructions_rounded, 'features': [
      'API Access','Third-Party Integration','WhatsApp Integration','Payment Gateway','Tally Integration'
    ]},
    {'name': 'Services', 'icon': Icons.support_agent_rounded, 'features': [
      'Cloud Hosting','Data Backup','Software Updates','Standard Support','Priority Support',
      'Data Migration','Staff Training','Implementation','Customization'
    ]},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Products & Modules')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Complete Business Platform',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Access CRM, sales, inventory, production, HR, marketing, reports and administration from one place.',
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          for (final module in _modules)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: Icon(module['icon'] as IconData, color: theme.colorScheme.primary),
                title: Text(module['name'] as String, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${(module['features'] as List).length} features'),
                children: [
                  for (final feature in module['features'] as List<String>)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      title: Text(feature),
                      onTap: () => _openFeature(context, module['name'] as String, feature),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _openFeature(BuildContext context, String module, String feature) {
    final screen = _screenFor(module, feature);
    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$feature screen is available in the module registry.')),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget? _screenFor(String module, String feature) {
    final key = '$module::$feature';
    switch (key) {
      case 'CRM::Lead Management': return const CrmLeadManagementScreen();
      case 'CRM::Customer Management': return const CrmCustomerManagementScreen();
      case 'CRM::Contact Management': return const CrmContactManagementScreen();
      case 'CRM::Follow-up Management': return const CrmFollowUpManagementScreen();
      case 'CRM::Sales Pipeline': return const CrmSalesPipelineScreen();
      case 'CRM::Deals / Opportunities': return const CrmDealsOpportunitiesScreen();
      case 'CRM::Sales Activities': return const CrmSalesActivitiesScreen();
      case 'CRM::CRM Reports': return const CrmCrmReportsScreen();
      case 'Sales & Invoicing::Quotations': return const SalesAndInvoicingQuotationsScreen();
      case 'Sales & Invoicing::Sales Orders': return const SalesAndInvoicingSalesOrdersScreen();
      case 'Sales & Invoicing::Invoices': return const SalesAndInvoicingInvoicesScreen();
      case 'Sales & Invoicing::Payment Tracking': return const SalesAndInvoicingPaymentTrackingScreen();
      case 'Sales & Invoicing::Outstanding Reports': return const SalesAndInvoicingOutstandingReportsScreen();
      case 'Sales & Invoicing::Invoice Templates': return const SalesAndInvoicingInvoiceTemplatesScreen();
      case 'Sales & Invoicing::Recurring Invoices': return const SalesAndInvoicingRecurringInvoicesScreen();
      case 'Sales & Invoicing::Credit/Debit Notes': return const SalesAndInvoicingCreditDebitNotesScreen();
      case 'Sales & Invoicing::GST / e-Invoice': return const SalesAndInvoicingGstEInvoiceScreen();
      case 'Purchase::Vendors': return const PurchaseVendorsScreen();
      case 'Purchase::Purchase Orders': return const PurchasePurchaseOrdersScreen();
      case 'Purchase::Purchase Bills': return const PurchasePurchaseBillsScreen();
      case 'Purchase::Purchase Returns': return const PurchasePurchaseReturnsScreen();
      case 'Purchase::Vendor Payments': return const PurchaseVendorPaymentsScreen();
      case 'Inventory::Products': return const InventoryProductsScreen();
      case 'Inventory::Stock Management': return const InventoryStockManagementScreen();
      case 'Inventory::Stock In/Out': return const InventoryStockInOutScreen();
      case 'Inventory::Stock Adjustment': return const InventoryStockAdjustmentScreen();
      case 'Inventory::Low Stock Alerts': return const InventoryLowStockAlertsScreen();
      case 'Inventory::Stock Transfer': return const InventoryStockTransferScreen();
      case 'Inventory::Multiple Warehouses': return const InventoryMultipleWarehousesScreen();
      case 'Inventory::Batch Management': return const InventoryBatchManagementScreen();
      case 'Inventory::Inventory Reports': return const InventoryInventoryReportsScreen();
      case 'Production::Production Module': return const ProductionProductionModuleScreen();
      case 'Production::Bill of Materials (BOM)': return const ProductionBillOfMaterialsBomScreen();
      case 'Production::Production Orders': return const ProductionProductionOrdersScreen();
      case 'Production::Raw Material Management': return const ProductionRawMaterialManagementScreen();
      case 'Production::Finished Goods': return const ProductionFinishedGoodsScreen();
      case 'Production::Work Orders': return const ProductionWorkOrdersScreen();
      case 'Production::Production Planning': return const ProductionProductionPlanningScreen();
      case 'Production::Production Tracking': return const ProductionProductionTrackingScreen();
      case 'Production::Production Reports': return const ProductionProductionReportsScreen();
      case 'HR / HR-One::Employee Management': return const HrHrOneEmployeeManagementScreen();
      case 'HR / HR-One::Employee Profiles': return const HrHrOneEmployeeProfilesScreen();
      case 'HR / HR-One::Departments': return const HrHrOneDepartmentsScreen();
      case 'HR / HR-One::Designations': return const HrHrOneDesignationsScreen();
      case 'HR / HR-One::Attendance': return const HrHrOneAttendanceScreen();
      case 'HR / HR-One::Leave Management': return const HrHrOneLeaveManagementScreen();
      case 'HR / HR-One::Holiday Management': return const HrHrOneHolidayManagementScreen();
      case 'HR / HR-One::Payroll': return const HrHrOnePayrollScreen();
      case 'HR / HR-One::Payslips': return const HrHrOnePayslipsScreen();
      case 'HR / HR-One::Employee Documents': return const HrHrOneEmployeeDocumentsScreen();
      case 'HR / HR-One::Performance Management': return const HrHrOnePerformanceManagementScreen();
      case 'HR / HR-One::Recruitment': return const HrHrOneRecruitmentScreen();
      case 'Marketing::Campaign Management': return const MarketingCampaignManagementScreen();
      case 'Marketing::Marketing Templates': return const MarketingMarketingTemplatesScreen();
      case 'Marketing::Customer Segmentation': return const MarketingCustomerSegmentationScreen();
      case 'Marketing::Email Marketing': return const MarketingEmailMarketingScreen();
      case 'Marketing::WhatsApp Marketing': return const MarketingWhatsappMarketingScreen();
      case 'Marketing::Campaign Reports': return const MarketingCampaignReportsScreen();
      case 'Templates::Invoice Templates': return const TemplatesInvoiceTemplatesScreen();
      case 'Templates::Quotation Templates': return const TemplatesQuotationTemplatesScreen();
      case 'Templates::Email Templates': return const TemplatesEmailTemplatesScreen();
      case 'Templates::HR Templates': return const TemplatesHrTemplatesScreen();
      case 'Templates::Custom Templates': return const TemplatesCustomTemplatesScreen();
      case 'Reports & Dashboards::Management Dashboard': return const ReportsAndDashboardsManagementDashboardScreen();
      case 'Reports & Dashboards::Sales Dashboard': return const ReportsAndDashboardsSalesDashboardScreen();
      case 'Reports & Dashboards::CRM Dashboard': return const ReportsAndDashboardsCrmDashboardScreen();
      case 'Reports & Dashboards::HR Dashboard': return const ReportsAndDashboardsHrDashboardScreen();
      case 'Reports & Dashboards::Inventory Dashboard': return const ReportsAndDashboardsInventoryDashboardScreen();
      case 'Reports & Dashboards::Production Dashboard': return const ReportsAndDashboardsProductionDashboardScreen();
      case 'Reports & Dashboards::Custom Reports': return const ReportsAndDashboardsCustomReportsScreen();
      case 'Reports & Dashboards::Export to Excel/PDF': return const ReportsAndDashboardsExportToExcelPdfScreen();
      case 'Mobile & Web::Web Application': return const MobileAndWebWebApplicationScreen();
      case 'Mobile & Web::Android Application': return const MobileAndWebAndroidApplicationScreen();
      case 'Mobile & Web::Mobile Dashboard': return const MobileAndWebMobileDashboardScreen();
      case 'Mobile & Web::Mobile Notifications': return const MobileAndWebMobileNotificationsScreen();
      case 'Security::User Management': return const SecurityUserManagementScreen();
      case 'Security::Role-Based Access': return const SecurityRoleBasedAccessScreen();
      case 'Security::Admin Panel': return const SecurityAdminPanelScreen();
      case 'Security::Activity Logs': return const SecurityActivityLogsScreen();
      case 'Security::Approval Workflows': return const SecurityApprovalWorkflowsScreen();
      case 'Integrations::API Access': return const IntegrationsApiAccessScreen();
      case 'Integrations::Third-Party Integration': return const IntegrationsThirdPartyIntegrationScreen();
      case 'Integrations::WhatsApp Integration': return const IntegrationsWhatsappIntegrationScreen();
      case 'Integrations::Payment Gateway': return const IntegrationsPaymentGatewayScreen();
      case 'Integrations::Tally Integration': return const IntegrationsTallyIntegrationScreen();
      case 'Services::Cloud Hosting': return const ServicesCloudHostingScreen();
      case 'Services::Data Backup': return const ServicesDataBackupScreen();
      case 'Services::Software Updates': return const ServicesSoftwareUpdatesScreen();
      case 'Services::Standard Support': return const ServicesStandardSupportScreen();
      case 'Services::Priority Support': return const ServicesPrioritySupportScreen();
      case 'Services::Data Migration': return const ServicesDataMigrationScreen();
      case 'Services::Staff Training': return const ServicesStaffTrainingScreen();
      case 'Services::Implementation': return const ServicesImplementationScreen();
      case 'Services::Customization': return const ServicesCustomizationScreen();
      default:
        return null;
    }
  }
}
