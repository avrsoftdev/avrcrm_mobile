import 'package:flutter/material.dart';

import '../../features/activities/activities_screen.dart';
import '../../features/contacts/contacts_screen.dart';
import '../../features/customers/customers_screen.dart';
import '../../features/employees/employees_screen.dart';
import '../../features/inventory/inventory_screen.dart';
import '../../features/leads/leads_screen.dart';
import '../../features/marketing/marketing_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/opportunities/opportunities_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/sales/invoices_screen.dart';
import '../../features/sales/quotations_screen.dart';
import '../../features/sales/sales_orders_screen.dart';
import '../../features/support/support_screen.dart';
import 'employee_roles.dart';

class ModuleMeta {
  final ModuleKey key;
  final String title;
  final IconData icon;

  const ModuleMeta({
    required this.key,
    required this.title,
    required this.icon,
  });
}

const Map<ModuleKey, ModuleMeta> kModuleCatalog = {
  'leads': ModuleMeta(key: 'leads', title: 'Leads', icon: Icons.people_outline),
  'opportunities': ModuleMeta(
    key: 'opportunities',
    title: 'Opportunities',
    icon: Icons.flag_outlined,
  ),
  'customers': ModuleMeta(
    key: 'customers',
    title: 'Customers',
    icon: Icons.business_outlined,
  ),
  'contacts': ModuleMeta(
    key: 'contacts',
    title: 'Contacts',
    icon: Icons.contacts_outlined,
  ),
  'activities': ModuleMeta(
    key: 'activities',
    title: 'Activities',
    icon: Icons.history_rounded,
  ),
  'quotations': ModuleMeta(
    key: 'quotations',
    title: 'Quotations',
    icon: Icons.description_outlined,
  ),
  'orders': ModuleMeta(
    key: 'orders',
    title: 'Orders',
    icon: Icons.shopping_cart_outlined,
  ),
  'sales-orders': ModuleMeta(
    key: 'sales-orders',
    title: 'Sales Orders',
    icon: Icons.shopping_cart_outlined,
  ),
  'products': ModuleMeta(
    key: 'products',
    title: 'Products',
    icon: Icons.inventory_2_outlined,
  ),
  'invoices': ModuleMeta(
    key: 'invoices',
    title: 'Invoices',
    icon: Icons.receipt_long_rounded,
  ),
  'support': ModuleMeta(
    key: 'support',
    title: 'Support',
    icon: Icons.support_agent_rounded,
  ),
  'marketing': ModuleMeta(
    key: 'marketing',
    title: 'Marketing',
    icon: Icons.campaign_outlined,
  ),
  'employees': ModuleMeta(
    key: 'employees',
    title: 'Employees',
    icon: Icons.badge_outlined,
  ),
  'inventory': ModuleMeta(
    key: 'inventory',
    title: 'Inventory',
    icon: Icons.warehouse_outlined,
  ),
  'notifications': ModuleMeta(
    key: 'notifications',
    title: 'Notifications',
    icon: Icons.notifications_outlined,
  ),
};

Widget? buildModuleScreen(ModuleKey key) {
  switch (key) {
    case 'leads':
      return const LeadsScreen();
    case 'opportunities':
      return const OpportunitiesScreen();
    case 'customers':
      return const CustomersScreen();
    case 'contacts':
      return const ContactsScreen();
    case 'activities':
      return const ActivitiesScreen();
    case 'quotations':
      return const QuotationsScreen();
    case 'orders':
      return const OrdersScreen();
    case 'sales-orders':
      return const SalesOrdersScreen();
    case 'products':
      return const ProductsScreen();
    case 'invoices':
      return const InvoicesScreen();
    case 'support':
      return const SupportScreen();
    case 'marketing':
      return const MarketingScreen();
    case 'employees':
      return const EmployeesScreen();
    case 'inventory':
      return const InventoryScreen();
    case 'notifications':
      return const NotificationsScreen();
    default:
      return null;
  }
}

String moduleTitle(ModuleKey key) =>
    kModuleCatalog[key]?.title ??
    key.replaceAll('-', ' ').split(' ').map((part) {
      if (part.isEmpty) return part;
      return '${part[0].toUpperCase()}${part.substring(1)}';
    }).join(' ');

IconData moduleIcon(ModuleKey key) =>
    kModuleCatalog[key]?.icon ?? Icons.apps_outlined;
