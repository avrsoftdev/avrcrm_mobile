import 'package:flutter/material.dart';
import 'module_feature_screen.dart';


class CrmLeadManagementScreen extends StatelessWidget {
  const CrmLeadManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Lead Management',
      description: 'Manage leads, sources, status, ownership, priorities and conversion.',
      icon: Icons.people_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmCustomerManagementScreen extends StatelessWidget {
  const CrmCustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Customer Management',
      description: 'Maintain customer profiles, addresses, GST details, history and outstanding balances.',
      icon: Icons.business_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmContactManagementScreen extends StatelessWidget {
  const CrmContactManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Contact Management',
      description: 'Manage multiple contacts, designations and communication details for every customer.',
      icon: Icons.contacts_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmFollowUpManagementScreen extends StatelessWidget {
  const CrmFollowUpManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Follow-up Management',
      description: 'Plan calls, meetings, tasks, reminders and next actions without missing follow-ups.',
      icon: Icons.event_repeat_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmSalesPipelineScreen extends StatelessWidget {
  const CrmSalesPipelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Sales Pipeline',
      description: 'Visualize opportunities by stage, probability, value and expected closing date.',
      icon: Icons.view_kanban_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmDealsOpportunitiesScreen extends StatelessWidget {
  const CrmDealsOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Deals / Opportunities',
      description: 'Track opportunity value, stage, probability, owner, close date and activities.',
      icon: Icons.handshake_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmSalesActivitiesScreen extends StatelessWidget {
  const CrmSalesActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'Sales Activities',
      description: 'Track calls, meetings, tasks, emails and notes against customers and opportunities.',
      icon: Icons.task_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class CrmCrmReportsScreen extends StatelessWidget {
  const CrmCrmReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'CRM',
      title: 'CRM Reports',
      description: 'Analyze leads, conversion, pipeline, activities, follow-ups and salesperson performance.',
      icon: Icons.analytics_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingQuotationsScreen extends StatelessWidget {
  const SalesAndInvoicingQuotationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Quotations',
      description: 'Create professional quotations with products, discounts, taxes, terms and validity.',
      icon: Icons.request_quote_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingSalesOrdersScreen extends StatelessWidget {
  const SalesAndInvoicingSalesOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Sales Orders',
      description: 'Convert quotations into orders and track order status, quantities and fulfillment.',
      icon: Icons.shopping_cart_checkout_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingInvoicesScreen extends StatelessWidget {
  const SalesAndInvoicingInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Invoices',
      description: 'Create GST-ready invoices, generate PDFs, track due dates and payment status.',
      icon: Icons.receipt_long_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingPaymentTrackingScreen extends StatelessWidget {
  const SalesAndInvoicingPaymentTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Payment Tracking',
      description: 'Record full or partial customer payments with methods, references and history.',
      icon: Icons.payments_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingOutstandingReportsScreen extends StatelessWidget {
  const SalesAndInvoicingOutstandingReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Outstanding Reports',
      description: 'Monitor customer receivables, overdue invoices and aging balances.',
      icon: Icons.account_balance_wallet_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingInvoiceTemplatesScreen extends StatelessWidget {
  const SalesAndInvoicingInvoiceTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Invoice Templates',
      description: 'Create reusable branded invoice layouts with dynamic fields and tax details.',
      icon: Icons.description_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingRecurringInvoicesScreen extends StatelessWidget {
  const SalesAndInvoicingRecurringInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Recurring Invoices',
      description: 'Configure recurring billing schedules and automatic invoice generation.',
      icon: Icons.autorenew_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingCreditDebitNotesScreen extends StatelessWidget {
  const SalesAndInvoicingCreditDebitNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'Credit/Debit Notes',
      description: 'Create invoice adjustments and returns with reasons, amounts and tax adjustments.',
      icon: Icons.note_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SalesAndInvoicingGstEInvoiceScreen extends StatelessWidget {
  const SalesAndInvoicingGstEInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Sales & Invoicing',
      title: 'GST / e-Invoice',
      description: 'Manage GSTIN, HSN/SAC, CGST, SGST, IGST, place of supply and GST invoice data.',
      icon: Icons.receipt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class PurchaseVendorsScreen extends StatelessWidget {
  const PurchaseVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Purchase',
      title: 'Vendors',
      description: 'Manage vendor profiles, contacts, GST details, payment terms, history and balances.',
      icon: Icons.storefront_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class PurchasePurchaseOrdersScreen extends StatelessWidget {
  const PurchasePurchaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Purchase',
      title: 'Purchase Orders',
      description: 'Create and track purchase orders with products, quantities, pricing, taxes and approvals.',
      icon: Icons.assignment_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class PurchasePurchaseBillsScreen extends StatelessWidget {
  const PurchasePurchaseBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Purchase',
      title: 'Purchase Bills',
      description: 'Record vendor bills, due dates, taxes, totals and payment status.',
      icon: Icons.receipt_long_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class PurchasePurchaseReturnsScreen extends StatelessWidget {
  const PurchasePurchaseReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Purchase',
      title: 'Purchase Returns',
      description: 'Process returned goods and maintain vendor adjustments and inventory changes.',
      icon: Icons.assignment_return_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class PurchaseVendorPaymentsScreen extends StatelessWidget {
  const PurchaseVendorPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Purchase',
      title: 'Vendor Payments',
      description: 'Record vendor payments, partial settlements, references and payment history.',
      icon: Icons.payments_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryProductsScreen extends StatelessWidget {
  const InventoryProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Products',
      description: 'Manage product master data, SKU, category, unit, HSN/SAC, pricing and minimum stock.',
      icon: Icons.inventory_2_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryStockManagementScreen extends StatelessWidget {
  const InventoryStockManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Stock Management',
      description: 'View current stock, available stock, valuation and product-wise inventory.',
      icon: Icons.inventory_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryStockInOutScreen extends StatelessWidget {
  const InventoryStockInOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Stock In/Out',
      description: 'Record and review purchase receipts, sales issues and manual stock movements.',
      icon: Icons.swap_vert_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryStockAdjustmentScreen extends StatelessWidget {
  const InventoryStockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Stock Adjustment',
      description: 'Correct stock quantities with reasons, approvals and audit history.',
      icon: Icons.tune_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryLowStockAlertsScreen extends StatelessWidget {
  const InventoryLowStockAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Low Stock Alerts',
      description: 'Monitor minimum stock levels and identify products that need replenishment.',
      icon: Icons.warning_amber_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryStockTransferScreen extends StatelessWidget {
  const InventoryStockTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Stock Transfer',
      description: 'Transfer inventory between warehouses and track transfer status and history.',
      icon: Icons.sync_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryMultipleWarehousesScreen extends StatelessWidget {
  const InventoryMultipleWarehousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Multiple Warehouses',
      description: 'Manage multiple storage locations and warehouse-wise inventory.',
      icon: Icons.warehouse_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryBatchManagementScreen extends StatelessWidget {
  const InventoryBatchManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Batch Management',
      description: 'Track batch numbers, manufacturing dates, expiry dates and batch quantities.',
      icon: Icons.qr_code_2_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class InventoryInventoryReportsScreen extends StatelessWidget {
  const InventoryInventoryReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Inventory',
      title: 'Inventory Reports',
      description: 'Analyze stock summary, movement, valuation, low stock, warehouses and batches.',
      icon: Icons.bar_chart_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionProductionModuleScreen extends StatelessWidget {
  const ProductionProductionModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Production Module',
      description: 'Manage manufacturing operations from material planning through finished goods.',
      icon: Icons.precision_manufacturing_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionBillOfMaterialsBomScreen extends StatelessWidget {
  const ProductionBillOfMaterialsBomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Bill of Materials (BOM)',
      description: 'Define finished products, raw materials, quantities, units and wastage.',
      icon: Icons.list_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionProductionOrdersScreen extends StatelessWidget {
  const ProductionProductionOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Production Orders',
      description: 'Plan production quantities, dates, BOMs, material requirements and status.',
      icon: Icons.assignment_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionRawMaterialManagementScreen extends StatelessWidget {
  const ProductionRawMaterialManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Raw Material Management',
      description: 'Check material availability, shortages, allocation, reservation and consumption.',
      icon: Icons.category_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionFinishedGoodsScreen extends StatelessWidget {
  const ProductionFinishedGoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Finished Goods',
      description: 'Receive completed production into finished-goods inventory with batch support.',
      icon: Icons.inventory_2_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionWorkOrdersScreen extends StatelessWidget {
  const ProductionWorkOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Work Orders',
      description: 'Assign production tasks and track work stages, dates, status and progress.',
      icon: Icons.construction_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionProductionPlanningScreen extends StatelessWidget {
  const ProductionProductionPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Production Planning',
      description: 'Schedule production and identify material requirements and pending work.',
      icon: Icons.event_note_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionProductionTrackingScreen extends StatelessWidget {
  const ProductionProductionTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Production Tracking',
      description: 'Compare planned versus produced quantities, consumption, wastage and status.',
      icon: Icons.track_changes_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ProductionProductionReportsScreen extends StatelessWidget {
  const ProductionProductionReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Production',
      title: 'Production Reports',
      description: 'Report on production orders, materials, finished goods, wastage and efficiency.',
      icon: Icons.analytics_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneEmployeeManagementScreen extends StatelessWidget {
  const HrHrOneEmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Employee Management',
      description: 'Manage employee records, IDs, contact information, joining details and status.',
      icon: Icons.badge_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneEmployeeProfilesScreen extends StatelessWidget {
  const HrHrOneEmployeeProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Employee Profiles',
      description: 'View complete employee information across overview, attendance, leave, payroll and documents.',
      icon: Icons.account_circle_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneDepartmentsScreen extends StatelessWidget {
  const HrHrOneDepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Departments',
      description: 'Create and manage departments, department heads and employee counts.',
      icon: Icons.account_tree_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneDesignationsScreen extends StatelessWidget {
  const HrHrOneDesignationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Designations',
      description: 'Manage job titles, department associations and organizational roles.',
      icon: Icons.work_outline_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneAttendanceScreen extends StatelessWidget {
  const HrHrOneAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Attendance',
      description: 'Track check-in, check-out, present, absent, late and half-day attendance.',
      icon: Icons.schedule_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneLeaveManagementScreen extends StatelessWidget {
  const HrHrOneLeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Leave Management',
      description: 'Manage leave types, balances, requests, approvals and history.',
      icon: Icons.event_busy_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneHolidayManagementScreen extends StatelessWidget {
  const HrHrOneHolidayManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Holiday Management',
      description: 'Maintain company holiday calendars and holiday schedules.',
      icon: Icons.celebration_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOnePayrollScreen extends StatelessWidget {
  const HrHrOnePayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Payroll',
      description: 'Process salaries with earnings, allowances, deductions, pay periods and status.',
      icon: Icons.currency_rupee_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOnePayslipsScreen extends StatelessWidget {
  const HrHrOnePayslipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Payslips',
      description: 'Generate, view, print and download employee payslips.',
      icon: Icons.receipt_long_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneEmployeeDocumentsScreen extends StatelessWidget {
  const HrHrOneEmployeeDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Employee Documents',
      description: 'Securely manage employee documents, document types and upload history.',
      icon: Icons.folder_shared_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOnePerformanceManagementScreen extends StatelessWidget {
  const HrHrOnePerformanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Performance Management',
      description: 'Manage goals, reviews, ratings, feedback and performance history.',
      icon: Icons.trending_up_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class HrHrOneRecruitmentScreen extends StatelessWidget {
  const HrHrOneRecruitmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'HR / HR-One',
      title: 'Recruitment',
      description: 'Manage vacancies, candidates, applications, interviews and hiring stages.',
      icon: Icons.person_search_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingCampaignManagementScreen extends StatelessWidget {
  const MarketingCampaignManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'Campaign Management',
      description: 'Create, schedule and monitor targeted marketing campaigns.',
      icon: Icons.campaign_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingMarketingTemplatesScreen extends StatelessWidget {
  const MarketingMarketingTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'Marketing Templates',
      description: 'Maintain reusable communication templates for marketing campaigns.',
      icon: Icons.text_snippet_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingCustomerSegmentationScreen extends StatelessWidget {
  const MarketingCustomerSegmentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'Customer Segmentation',
      description: 'Build customer segments using profile, activity, purchase and custom criteria.',
      icon: Icons.filter_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingEmailMarketingScreen extends StatelessWidget {
  const MarketingEmailMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'Email Marketing',
      description: 'Create email campaigns, select recipients, schedule messages and track results.',
      icon: Icons.mail_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingWhatsappMarketingScreen extends StatelessWidget {
  const MarketingWhatsappMarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'WhatsApp Marketing',
      description: 'Manage WhatsApp campaign configuration, templates, recipients and delivery status.',
      icon: Icons.chat_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MarketingCampaignReportsScreen extends StatelessWidget {
  const MarketingCampaignReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Marketing',
      title: 'Campaign Reports',
      description: 'Measure campaign delivery, engagement, responses and conversions where supported.',
      icon: Icons.query_stats_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class TemplatesInvoiceTemplatesScreen extends StatelessWidget {
  const TemplatesInvoiceTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Templates',
      title: 'Invoice Templates',
      description: 'Create branded invoice templates with company, customer, item and tax fields.',
      icon: Icons.description_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class TemplatesQuotationTemplatesScreen extends StatelessWidget {
  const TemplatesQuotationTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Templates',
      title: 'Quotation Templates',
      description: 'Create reusable quotation layouts with dynamic product and customer information.',
      icon: Icons.request_quote_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class TemplatesEmailTemplatesScreen extends StatelessWidget {
  const TemplatesEmailTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Templates',
      title: 'Email Templates',
      description: 'Create reusable email messages with dynamic business and customer fields.',
      icon: Icons.mail_outline_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class TemplatesHrTemplatesScreen extends StatelessWidget {
  const TemplatesHrTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Templates',
      title: 'HR Templates',
      description: 'Manage reusable HR letters, forms, notices and employee documents.',
      icon: Icons.article_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class TemplatesCustomTemplatesScreen extends StatelessWidget {
  const TemplatesCustomTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Templates',
      title: 'Custom Templates',
      description: 'Build configurable templates for business-specific documents and communications.',
      icon: Icons.dashboard_customize_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsManagementDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsManagementDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Management Dashboard',
      description: 'Executive overview of revenue, sales, purchases, receivables, inventory, production and HR.',
      icon: Icons.dashboard_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsSalesDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsSalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Sales Dashboard',
      description: 'Monitor revenue, orders, quotations, invoices, payments, conversion and top performers.',
      icon: Icons.insights_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsCrmDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsCrmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'CRM Dashboard',
      description: 'Monitor leads, opportunities, pipeline, follow-ups, activities and conversion.',
      icon: Icons.leaderboard_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsHrDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsHrDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'HR Dashboard',
      description: 'Monitor employees, attendance, leave, payroll and department statistics.',
      icon: Icons.people_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsInventoryDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsInventoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Inventory Dashboard',
      description: 'Monitor product count, stock value, low stock, warehouses and stock movement.',
      icon: Icons.inventory_2_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsProductionDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsProductionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Production Dashboard',
      description: 'Monitor production orders, planned output, completed output and material consumption.',
      icon: Icons.precision_manufacturing_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsCustomReportsScreen extends StatelessWidget {
  const ReportsAndDashboardsCustomReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Custom Reports',
      description: 'Build filtered reports by date, status, customer, employee, product and other criteria.',
      icon: Icons.table_chart_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ReportsAndDashboardsExportToExcelPdfScreen extends StatelessWidget {
  const ReportsAndDashboardsExportToExcelPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Reports & Dashboards',
      title: 'Export to Excel/PDF',
      description: 'Export supported reports and business documents for sharing and offline analysis.',
      icon: Icons.file_download_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MobileAndWebWebApplicationScreen extends StatelessWidget {
  const MobileAndWebWebApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Mobile & Web',
      title: 'Web Application',
      description: 'Responsive browser experience for managing business operations from desktop and tablet.',
      icon: Icons.language_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MobileAndWebAndroidApplicationScreen extends StatelessWidget {
  const MobileAndWebAndroidApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Mobile & Web',
      title: 'Android Application',
      description: 'Mobile-first business management experience for Android users.',
      icon: Icons.android_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MobileAndWebMobileDashboardScreen extends StatelessWidget {
  const MobileAndWebMobileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Mobile & Web',
      title: 'Mobile Dashboard',
      description: 'View important KPIs, alerts and business summaries from a mobile dashboard.',
      icon: Icons.phone_android_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class MobileAndWebMobileNotificationsScreen extends StatelessWidget {
  const MobileAndWebMobileNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Mobile & Web',
      title: 'Mobile Notifications',
      description: 'Receive reminders and alerts for leads, follow-ups, approvals, stock and payments.',
      icon: Icons.notifications_active_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SecurityUserManagementScreen extends StatelessWidget {
  const SecurityUserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Security',
      title: 'User Management',
      description: 'Create, edit, activate and deactivate application users and associate employees.',
      icon: Icons.manage_accounts_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SecurityRoleBasedAccessScreen extends StatelessWidget {
  const SecurityRoleBasedAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Security',
      title: 'Role-Based Access',
      description: 'Control module and action permissions such as view, create, edit, delete and approve.',
      icon: Icons.admin_panel_settings_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SecurityAdminPanelScreen extends StatelessWidget {
  const SecurityAdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Security',
      title: 'Admin Panel',
      description: 'Central administration area for organization, users, settings and controls.',
      icon: Icons.settings_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SecurityActivityLogsScreen extends StatelessWidget {
  const SecurityActivityLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Security',
      title: 'Activity Logs',
      description: 'Audit important actions with user, module, action, document and timestamp information.',
      icon: Icons.history_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class SecurityApprovalWorkflowsScreen extends StatelessWidget {
  const SecurityApprovalWorkflowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Security',
      title: 'Approval Workflows',
      description: 'Configure approval processes for quotations, purchases, payments, leave and other documents.',
      icon: Icons.approval_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class IntegrationsApiAccessScreen extends StatelessWidget {
  const IntegrationsApiAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Integrations',
      title: 'API Access',
      description: 'Provide a secure API foundation for external applications and business integrations.',
      icon: Icons.api_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class IntegrationsThirdPartyIntegrationScreen extends StatelessWidget {
  const IntegrationsThirdPartyIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Integrations',
      title: 'Third-Party Integration',
      description: 'Connect supported external services through configurable integration providers.',
      icon: Icons.hub_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class IntegrationsWhatsappIntegrationScreen extends StatelessWidget {
  const IntegrationsWhatsappIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Integrations',
      title: 'WhatsApp Integration',
      description: 'Connect WhatsApp services for customer communication and marketing workflows.',
      icon: Icons.chat_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class IntegrationsPaymentGatewayScreen extends StatelessWidget {
  const IntegrationsPaymentGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Integrations',
      title: 'Payment Gateway',
      description: 'Connect payment providers for online payment collection and transaction status.',
      icon: Icons.payment_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class IntegrationsTallyIntegrationScreen extends StatelessWidget {
  const IntegrationsTallyIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Integrations',
      title: 'Tally Integration',
      description: 'Provide a Tally synchronization layer for supported accounting data and workflows.',
      icon: Icons.sync_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesCloudHostingScreen extends StatelessWidget {
  const ServicesCloudHostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Cloud Hosting',
      description: 'Provide managed cloud hosting and infrastructure for the application.',
      icon: Icons.cloud_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesDataBackupScreen extends StatelessWidget {
  const ServicesDataBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Data Backup',
      description: 'Protect business information through scheduled backup and recovery processes.',
      icon: Icons.backup_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesSoftwareUpdatesScreen extends StatelessWidget {
  const ServicesSoftwareUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Software Updates',
      description: 'Deliver product improvements, security updates and new capabilities.',
      icon: Icons.system_update_alt_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesStandardSupportScreen extends StatelessWidget {
  const ServicesStandardSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Standard Support',
      description: 'Provide assistance for normal product usage and operational questions.',
      icon: Icons.support_agent_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesPrioritySupportScreen extends StatelessWidget {
  const ServicesPrioritySupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Priority Support',
      description: 'Provide faster assistance for critical issues and business-impacting problems.',
      icon: Icons.support_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesDataMigrationScreen extends StatelessWidget {
  const ServicesDataMigrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Data Migration',
      description: 'Assist with importing existing customer, product, sales, purchase and employee data.',
      icon: Icons.move_up_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesStaffTrainingScreen extends StatelessWidget {
  const ServicesStaffTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Staff Training',
      description: 'Train employees and administrators on business workflows and system usage.',
      icon: Icons.school_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesImplementationScreen extends StatelessWidget {
  const ServicesImplementationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Implementation',
      description: 'Configure and deploy the platform around the organization\'s business processes.',
      icon: Icons.rocket_launch_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}


class ServicesCustomizationScreen extends StatelessWidget {
  const ServicesCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModuleFeatureScreen(
      module: 'Services',
      title: 'Customization',
      description: 'Adapt fields, workflows, reports and modules to specific business requirements.',
      icon: Icons.build_circle_rounded,
      capabilities: const [
        'Create and maintain records using the existing application architecture.',
        'Search, filter and review records with clear status information.',
        'Connect related customers, employees, products or documents where applicable.',
        'Maintain a complete activity/history trail for important changes.',
        'Provide validation, loading, empty and error states.',
      ],
    );
  }
}
