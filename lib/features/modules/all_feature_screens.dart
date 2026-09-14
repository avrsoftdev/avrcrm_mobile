import 'functional_module_screen.dart';
import 'package:flutter/material.dart';
const _definitions = <String, FunctionalModuleDefinition>{
  'Crm_Lead_Management': FunctionalModuleDefinition(title: 'Lead Management', table: 'leads', description: 'Lead management records with create, edit, delete, search and status updates.', icon: Icons.person_search_outlined, fields: [ModuleField('id', required: true), ModuleField('first_name', required: true), ModuleField('last_name'), ModuleField('company', required: true), ModuleField('email', required: true), ModuleField('phone'), ModuleField('source'), ModuleField('status'), ModuleField('priority'), ModuleField('assigned_to'), ModuleField('expected_value'), ModuleField('next_follow_up'), ModuleField('notes')], statuses: ['New', 'Contacted', 'Qualified', 'Proposal', 'Negotiation', 'Won', 'Lost']),
  'Crm_Customer_Management': FunctionalModuleDefinition(title: 'Customer Management', table: 'customers', description: 'Manage customers and their commercial information.', icon: Icons.business_outlined, fields: [ModuleField('id', required: true), ModuleField('company', required: true), ModuleField('email', required: true), ModuleField('phone'), ModuleField('industry'), ModuleField('type'), ModuleField('status'), ModuleField('owner'), ModuleField('revenue'), ModuleField('notes')], statuses: ['Prospect', 'Active', 'Inactive', 'Blocked']),
  'Crm_Contact_Management': FunctionalModuleDefinition(title: 'Contact Management', table: 'contacts', description: 'Manage customer contacts, decision makers and contact details.', icon: Icons.contacts_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('company', required: true), ModuleField('customer_id'), ModuleField('designation'), ModuleField('phone'), ModuleField('email', required: true), ModuleField('department'), ModuleField('owner'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'Crm_Follow_up_Management': FunctionalModuleDefinition(title: 'Follow-up Management', table: 'follow_ups', description: 'Schedule and manage follow-ups, reminders and outcomes.', icon: Icons.event_available_outlined, fields: [ModuleField('id', required: true), ModuleField('title', required: true), ModuleField('lead_id'), ModuleField('customer_id'), ModuleField('assigned_to'), ModuleField('follow_up_date'), ModuleField('type'), ModuleField('priority'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Completed', 'Overdue', 'Cancelled']),
  'Crm_Sales_Pipeline': FunctionalModuleDefinition(title: 'Sales Pipeline', table: 'opportunities', description: 'Track pipeline opportunities through sales stages.', icon: Icons.account_tree_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('company', required: true), ModuleField('stage'), ModuleField('value'), ModuleField('probability'), ModuleField('close_date'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['New', 'Qualified', 'Proposal', 'Negotiation', 'Won', 'Lost']),
  'Crm_Deals_Opportunities': FunctionalModuleDefinition(title: 'Deals / Opportunities', table: 'deals', description: 'Manage deals, values, stages, owners and closing actions.', icon: Icons.handshake_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('company', required: true), ModuleField('stage'), ModuleField('value'), ModuleField('probability'), ModuleField('close_date'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'Won', 'Lost', 'Cancelled']),
  'Crm_Sales_Activities': FunctionalModuleDefinition(title: 'Sales Activities', table: 'activities', description: 'Create and manage calls, meetings, tasks and sales activities.', icon: Icons.task_alt_outlined, fields: [ModuleField('id', required: true), ModuleField('type'), ModuleField('title', required: true), ModuleField('related_to'), ModuleField('assigned_to'), ModuleField('activity_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Completed', 'Cancelled']),
  'Crm_CRM_Reports': FunctionalModuleDefinition(title: 'CRM Reports', table: 'crm_reports', description: 'CRM reporting workspace with searchable report records and status tracking.', icon: Icons.analytics_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('report_type'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Published', 'Archived']),
  'SalesAndInvoicing_Quotations': FunctionalModuleDefinition(title: 'Quotations', table: 'quotations', description: 'Create, edit, delete and track customer quotations.', icon: Icons.request_quote_outlined, fields: [ModuleField('id', required: true), ModuleField('quotation_number', required: true), ModuleField('customer'), ModuleField('customer_id'), ModuleField('quotation_date'), ModuleField('valid_until'), ModuleField('subtotal'), ModuleField('tax'), ModuleField('total'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Sent', 'Accepted', 'Rejected', 'Expired']),
  'SalesAndInvoicing_Sales_Orders': FunctionalModuleDefinition(title: 'Sales Orders', table: 'sales_orders', description: 'Manage sales orders from confirmation through completion.', icon: Icons.shopping_cart_checkout_outlined, fields: [ModuleField('id', required: true), ModuleField('order_number', required: true), ModuleField('customer'), ModuleField('customer_id'), ModuleField('order_date'), ModuleField('delivery_date'), ModuleField('subtotal'), ModuleField('tax'), ModuleField('total'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Confirmed', 'Processing', 'Completed', 'Cancelled']),
  'SalesAndInvoicing_Invoices': FunctionalModuleDefinition(title: 'Invoices', table: 'invoices', description: 'Create invoices, update billing records and track invoice status.', icon: Icons.receipt_long_outlined, fields: [ModuleField('id', required: true), ModuleField('invoice_number', required: true), ModuleField('customer'), ModuleField('customer_id'), ModuleField('invoice_date'), ModuleField('due_date'), ModuleField('subtotal'), ModuleField('tax'), ModuleField('total'), ModuleField('amount_paid'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Sent', 'Partially Paid', 'Paid', 'Overdue', 'Cancelled']),
  'SalesAndInvoicing_Payment_Tracking': FunctionalModuleDefinition(title: 'Payment Tracking', table: 'payments', description: 'Record and track customer payments against invoices.', icon: Icons.payments_outlined, fields: [ModuleField('id', required: true), ModuleField('payment_number', required: true), ModuleField('invoice_id'), ModuleField('customer'), ModuleField('payment_date'), ModuleField('amount'), ModuleField('method'), ModuleField('reference'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Received', 'Failed', 'Refunded']),
  'SalesAndInvoicing_Outstanding_Reports': FunctionalModuleDefinition(title: 'Outstanding Reports', table: 'outstanding_reports', description: 'Manage outstanding receivable report snapshots and review status.', icon: Icons.account_balance_wallet_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('customer'), ModuleField('invoice_id'), ModuleField('amount'), ModuleField('due_date'), ModuleField('days_overdue'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'Partially Paid', 'Paid', 'Written Off']),
  'SalesAndInvoicing_Invoice_Templates': FunctionalModuleDefinition(title: 'Invoice Templates', table: 'invoice_templates', description: 'Create and maintain reusable invoice templates.', icon: Icons.description_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_type'), ModuleField('tax_mode'), ModuleField('terms'), ModuleField('footer'), ModuleField('status')], statuses: ['Draft', 'Active', 'Archived']),
  'SalesAndInvoicing_Recurring_Invoices': FunctionalModuleDefinition(title: 'Recurring Invoices', table: 'recurring_invoices', description: 'Configure recurring invoice schedules and billing status.', icon: Icons.repeat_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('customer'), ModuleField('frequency'), ModuleField('start_date'), ModuleField('end_date'), ModuleField('next_run'), ModuleField('amount'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Paused', 'Completed', 'Cancelled']),
  'SalesAndInvoicing_Credit_Debit_Notes': FunctionalModuleDefinition(title: 'Credit/Debit Notes', table: 'credit_debit_notes', description: 'Create and track credit and debit adjustments.', icon: Icons.note_add_outlined, fields: [ModuleField('id', required: true), ModuleField('note_number'), ModuleField('type'), ModuleField('customer'), ModuleField('invoice_id'), ModuleField('date'), ModuleField('amount'), ModuleField('reason'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Issued', 'Applied', 'Cancelled']),
  'SalesAndInvoicing_GST_e_Invoice': FunctionalModuleDefinition(title: 'GST / e-Invoice', table: 'gst_e_invoice', description: 'Track GST and e-invoice preparation, submission status and references.', icon: Icons.receipt_outlined, fields: [ModuleField('id', required: true), ModuleField('invoice_id'), ModuleField('gstin'), ModuleField('document_type'), ModuleField('irn'), ModuleField('ack_number'), ModuleField('ack_date'), ModuleField('status'), ModuleField('error_message'), ModuleField('notes')], statuses: ['Draft', 'Ready', 'Submitted', 'Accepted', 'Rejected']),
  'Purchase_Vendors': FunctionalModuleDefinition(title: 'Vendors', table: 'vendors', description: 'Manage suppliers, contacts, payment terms and vendor status.', icon: Icons.storefront_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('email', required: true), ModuleField('phone'), ModuleField('gstin'), ModuleField('address'), ModuleField('payment_terms'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive', 'Blocked']),
  'Purchase_Purchase_Orders': FunctionalModuleDefinition(title: 'Purchase Orders', table: 'purchase_orders', description: 'Create and track purchase orders to vendors.', icon: Icons.playlist_add_check_outlined, fields: [ModuleField('id', required: true), ModuleField('order_number', required: true), ModuleField('vendor'), ModuleField('vendor_id'), ModuleField('order_date'), ModuleField('expected_date'), ModuleField('subtotal'), ModuleField('tax'), ModuleField('total'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Sent', 'Confirmed', 'Received', 'Cancelled']),
  'Purchase_Purchase_Bills': FunctionalModuleDefinition(title: 'Purchase Bills', table: 'purchase_bills', description: 'Record vendor bills and track payment status.', icon: Icons.request_page_outlined, fields: [ModuleField('id', required: true), ModuleField('bill_number', required: true), ModuleField('vendor'), ModuleField('vendor_id'), ModuleField('bill_date'), ModuleField('due_date'), ModuleField('subtotal'), ModuleField('tax'), ModuleField('total'), ModuleField('amount_paid'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Received', 'Partially Paid', 'Paid', 'Overdue', 'Cancelled']),
  'Purchase_Purchase_Returns': FunctionalModuleDefinition(title: 'Purchase Returns', table: 'purchase_returns', description: 'Manage purchase returns and vendor adjustments.', icon: Icons.assignment_return_outlined, fields: [ModuleField('id', required: true), ModuleField('return_number', required: true), ModuleField('vendor'), ModuleField('purchase_bill_id'), ModuleField('return_date'), ModuleField('reason'), ModuleField('amount'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Requested', 'Approved', 'Completed', 'Rejected']),
  'Purchase_Vendor_Payments': FunctionalModuleDefinition(title: 'Vendor Payments', table: 'vendor_payments', description: 'Record payments made to vendors and reconcile them.', icon: Icons.account_balance_outlined, fields: [ModuleField('id', required: true), ModuleField('payment_number', required: true), ModuleField('vendor'), ModuleField('bill_id'), ModuleField('payment_date'), ModuleField('amount'), ModuleField('method'), ModuleField('reference'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Paid', 'Failed', 'Refunded']),
  'Inventory_Products': FunctionalModuleDefinition(title: 'Products', table: 'products', description: 'Manage product masters, pricing, stock and product status.', icon: Icons.inventory_2_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('sku'), ModuleField('category'), ModuleField('unit'), ModuleField('price'), ModuleField('cost_price'), ModuleField('stock'), ModuleField('reorder_level'), ModuleField('status'), ModuleField('description')], statuses: ['Active', 'Inactive', 'Discontinued']),
  'Inventory_Stock_Management': FunctionalModuleDefinition(title: 'Stock Management', table: 'inventory', description: 'Manage stock balances and inventory records.', icon: Icons.warehouse_outlined, fields: [ModuleField('id', required: true), ModuleField('product_id'), ModuleField('warehouse_id'), ModuleField('quantity'), ModuleField('reserved_quantity'), ModuleField('available_quantity'), ModuleField('reorder_level'), ModuleField('status'), ModuleField('notes')], statuses: ['Available', 'Low Stock', 'Out of Stock', 'Blocked']),
  'Inventory_Stock_In_Out': FunctionalModuleDefinition(title: 'Stock In/Out', table: 'stock_movements', description: 'Record stock receipts, issues and movement references.', icon: Icons.swap_vert_outlined, fields: [ModuleField('id', required: true), ModuleField('product_id'), ModuleField('warehouse_id'), ModuleField('movement_type'), ModuleField('quantity'), ModuleField('movement_date'), ModuleField('reference'), ModuleField('reason'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Posted', 'Cancelled']),
  'Inventory_Stock_Adjustment': FunctionalModuleDefinition(title: 'Stock Adjustment', table: 'stock_adjustments', description: 'Create and approve stock adjustments with reasons.', icon: Icons.tune_outlined, fields: [ModuleField('id', required: true), ModuleField('adjustment_number'), ModuleField('product_id'), ModuleField('warehouse_id'), ModuleField('old_quantity'), ModuleField('new_quantity'), ModuleField('difference'), ModuleField('reason'), ModuleField('adjustment_date'), ModuleField('status')], statuses: ['Draft', 'Approved', 'Posted', 'Rejected']),
  'Inventory_Low_Stock_Alerts': FunctionalModuleDefinition(title: 'Low Stock Alerts', table: 'low_stock_alerts', description: 'Review low-stock alerts and update their resolution status.', icon: Icons.warning_amber_outlined, fields: [ModuleField('id', required: true), ModuleField('product_id'), ModuleField('warehouse_id'), ModuleField('current_stock'), ModuleField('reorder_level'), ModuleField('alert_date'), ModuleField('assigned_to'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'Acknowledged', 'Resolved']),
  'Inventory_Stock_Transfer': FunctionalModuleDefinition(title: 'Stock Transfer', table: 'stock_transfers', description: 'Transfer inventory between warehouses with approval and completion tracking.', icon: Icons.compare_arrows_outlined, fields: [ModuleField('id', required: true), ModuleField('transfer_number', required: true), ModuleField('product_id'), ModuleField('from_warehouse'), ModuleField('to_warehouse'), ModuleField('quantity'), ModuleField('transfer_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Approved', 'In Transit', 'Completed', 'Cancelled']),
  'Inventory_Multiple_Warehouses': FunctionalModuleDefinition(title: 'Multiple Warehouses', table: 'warehouses', description: 'Manage warehouse master data and operational status.', icon: Icons.warehouse_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('code'), ModuleField('address'), ModuleField('manager'), ModuleField('phone'), ModuleField('capacity'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'Inventory_Batch_Management': FunctionalModuleDefinition(title: 'Batch Management', table: 'inventory_batches', description: 'Manage batch numbers, dates, quantities and batch status.', icon: Icons.layers_outlined, fields: [ModuleField('id', required: true), ModuleField('batch_number', required: true), ModuleField('product_id'), ModuleField('warehouse_id'), ModuleField('manufacture_date'), ModuleField('expiry_date'), ModuleField('quantity'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Expired', 'Blocked', 'Consumed']),
  'Inventory_Inventory_Reports': FunctionalModuleDefinition(title: 'Inventory Reports', table: 'inventory_reports', description: 'Maintain inventory report runs and report status.', icon: Icons.bar_chart_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('report_type'), ModuleField('period'), ModuleField('warehouse_id'), ModuleField('generated_by'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Generated', 'Archived']),
  'Production_Production_Module': FunctionalModuleDefinition(title: 'Production Module', table: 'production_records', description: 'Manage production jobs and their lifecycle.', icon: Icons.precision_manufacturing_outlined, fields: [ModuleField('id', required: true), ModuleField('production_number', required: true), ModuleField('product_id'), ModuleField('quantity'), ModuleField('planned_date'), ModuleField('completion_date'), ModuleField('warehouse_id'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Planned', 'In Progress', 'Completed', 'Cancelled']),
  'Production_Bill_of_Materials_BOM': FunctionalModuleDefinition(title: 'Bill of Materials (BOM)', table: 'boms', description: 'Create and maintain bills of materials for finished products.', icon: Icons.account_tree_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('product_id'), ModuleField('version'), ModuleField('quantity'), ModuleField('effective_from'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Production_Production_Orders': FunctionalModuleDefinition(title: 'Production Orders', table: 'production_orders', description: 'Create production orders from planned manufacturing demand.', icon: Icons.assignment_outlined, fields: [ModuleField('id', required: true), ModuleField('order_number', required: true), ModuleField('product_id'), ModuleField('bom_id'), ModuleField('quantity'), ModuleField('planned_date'), ModuleField('due_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Planned', 'Released', 'In Progress', 'Completed', 'Cancelled']),
  'Production_Raw_Material_Management': FunctionalModuleDefinition(title: 'Raw Material Management', table: 'raw_materials', description: 'Manage raw materials, stock requirements and availability.', icon: Icons.category_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('sku'), ModuleField('unit'), ModuleField('stock'), ModuleField('reorder_level'), ModuleField('warehouse_id'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Low Stock', 'Inactive']),
  'Production_Finished_Goods': FunctionalModuleDefinition(title: 'Finished Goods', table: 'finished_goods', description: 'Manage completed goods and finished inventory entries.', icon: Icons.inventory_outlined, fields: [ModuleField('id', required: true), ModuleField('product_id'), ModuleField('production_order_id'), ModuleField('quantity'), ModuleField('warehouse_id'), ModuleField('completion_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Available', 'Reserved', 'Dispatched', 'Blocked']),
  'Production_Work_Orders': FunctionalModuleDefinition(title: 'Work Orders', table: 'work_orders', description: 'Assign and track manufacturing work orders.', icon: Icons.work_history_outlined, fields: [ModuleField('id', required: true), ModuleField('work_order_number'), ModuleField('production_order_id'), ModuleField('work_center'), ModuleField('assigned_to'), ModuleField('planned_hours'), ModuleField('actual_hours'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'In Progress', 'Completed', 'Cancelled']),
  'Production_Production_Planning': FunctionalModuleDefinition(title: 'Production Planning', table: 'production_plans', description: 'Plan production quantities, dates, resources and priorities.', icon: Icons.event_note_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('period'), ModuleField('product_id'), ModuleField('planned_quantity'), ModuleField('priority'), ModuleField('planner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Approved', 'Released', 'Completed', 'Cancelled']),
  'Production_Production_Tracking': FunctionalModuleDefinition(title: 'Production Tracking', table: 'production_tracking', description: 'Track production progress, quantities and exceptions.', icon: Icons.track_changes_outlined, fields: [ModuleField('id', required: true), ModuleField('production_order_id'), ModuleField('operation'), ModuleField('completed_quantity'), ModuleField('rejected_quantity'), ModuleField('tracking_date'), ModuleField('operator'), ModuleField('status'), ModuleField('notes')], statuses: ['Running', 'Completed', 'On Hold', 'Issue']),
  'Production_Production_Reports': FunctionalModuleDefinition(title: 'Production Reports', table: 'production_reports', description: 'Manage production report runs and summaries.', icon: Icons.insights_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('report_type'), ModuleField('period'), ModuleField('production_order_id'), ModuleField('generated_by'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Generated', 'Archived']),
  'HrHrOne_Employee_Management': FunctionalModuleDefinition(title: 'Employee Management', table: 'employees', description: 'Manage employees with create, edit, delete and status updates.', icon: Icons.badge_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('email', required: true), ModuleField('phone'), ModuleField('department'), ModuleField('role'), ModuleField('status'), ModuleField('joining_date'), ModuleField('last_login'), ModuleField('notes')], statuses: ['Active', 'Inactive', 'On Leave']),
  'HrHrOne_Employee_Profiles': FunctionalModuleDefinition(title: 'Employee Profiles', table: 'employee_profiles', description: 'Maintain detailed employee profile records and employment information.', icon: Icons.account_circle_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('name', required: true), ModuleField('email', required: true), ModuleField('phone'), ModuleField('designation'), ModuleField('department'), ModuleField('address'), ModuleField('emergency_contact'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'HrHrOne_Departments': FunctionalModuleDefinition(title: 'Departments', table: 'departments', description: 'Manage departments and department heads.', icon: Icons.domain_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('code'), ModuleField('head'), ModuleField('location'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'HrHrOne_Designations': FunctionalModuleDefinition(title: 'Designations', table: 'designations', description: 'Manage job designations and organizational roles.', icon: Icons.workspace_premium_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('code'), ModuleField('level'), ModuleField('department'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'HrHrOne_Attendance': FunctionalModuleDefinition(title: 'Attendance', table: 'attendance', description: 'Record attendance, check-in/out and attendance status.', icon: Icons.access_time_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('attendance_date'), ModuleField('check_in'), ModuleField('check_out'), ModuleField('work_hours'), ModuleField('status'), ModuleField('remarks')], statuses: ['Present', 'Absent', 'Half Day', 'Leave', 'Holiday']),
  'HrHrOne_Leave_Management': FunctionalModuleDefinition(title: 'Leave Management', table: 'leave_requests', description: 'Create, review and approve employee leave requests.', icon: Icons.beach_access_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('leave_type'), ModuleField('from_date'), ModuleField('to_date'), ModuleField('days'), ModuleField('reason'), ModuleField('approved_by'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Approved', 'Rejected', 'Cancelled']),
  'HrHrOne_Holiday_Management': FunctionalModuleDefinition(title: 'Holiday Management', table: 'holidays', description: 'Maintain company holidays and holiday calendars.', icon: Icons.calendar_month_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('holiday_date'), ModuleField('location'), ModuleField('holiday_type'), ModuleField('status'), ModuleField('notes')], statuses: ['Planned', 'Active', 'Cancelled']),
  'HrHrOne_Payroll': FunctionalModuleDefinition(title: 'Payroll', table: 'payroll', description: 'Manage payroll runs, salary periods and payroll status.', icon: Icons.account_balance_wallet_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('period'), ModuleField('basic_salary'), ModuleField('allowances'), ModuleField('deductions'), ModuleField('net_salary'), ModuleField('payment_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Processed', 'Paid', 'Cancelled']),
  'HrHrOne_Payslips': FunctionalModuleDefinition(title: 'Payslips', table: 'payslips', description: 'Create and manage employee payslip records.', icon: Icons.receipt_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('period'), ModuleField('gross_salary'), ModuleField('deductions'), ModuleField('net_salary'), ModuleField('issued_date'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Issued', 'Paid', 'Cancelled']),
  'HrHrOne_Employee_Documents': FunctionalModuleDefinition(title: 'Employee Documents', table: 'employee_documents', description: 'Store document metadata, expiry dates and verification status.', icon: Icons.folder_shared_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('document_type'), ModuleField('document_number'), ModuleField('issue_date'), ModuleField('expiry_date'), ModuleField('file_url'), ModuleField('status'), ModuleField('notes')], statuses: ['Pending', 'Verified', 'Expired', 'Rejected']),
  'HrHrOne_Performance_Management': FunctionalModuleDefinition(title: 'Performance Management', table: 'performance_reviews', description: 'Manage employee performance reviews and outcomes.', icon: Icons.star_outline_outlined, fields: [ModuleField('id', required: true), ModuleField('employee_id', required: true), ModuleField('review_period'), ModuleField('reviewer'), ModuleField('rating'), ModuleField('goals'), ModuleField('feedback'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Submitted', 'Reviewed', 'Finalized']),
  'HrHrOne_Recruitment': FunctionalModuleDefinition(title: 'Recruitment', table: 'recruitments', description: 'Track job openings, candidates and recruitment stages.', icon: Icons.person_add_alt_1_outlined, fields: [ModuleField('id', required: true), ModuleField('job_title', required: true), ModuleField('department'), ModuleField('candidate_name'), ModuleField('email', required: true), ModuleField('phone'), ModuleField('application_date'), ModuleField('stage'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'Screening', 'Interview', 'Selected', 'Rejected', 'Closed']),
  'Marketing_Campaign_Management': FunctionalModuleDefinition(title: 'Campaign Management', table: 'campaigns', description: 'Create and manage marketing campaigns and their lifecycle.', icon: Icons.campaign_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('campaign_type'), ModuleField('start_date'), ModuleField('end_date'), ModuleField('budget'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Scheduled', 'Running', 'Paused', 'Completed', 'Cancelled']),
  'Marketing_Marketing_Templates': FunctionalModuleDefinition(title: 'Marketing Templates', table: 'templates', description: 'Create reusable marketing content templates.', icon: Icons.article_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('channel'), ModuleField('subject'), ModuleField('content'), ModuleField('owner'), ModuleField('status')], statuses: ['Draft', 'Active', 'Archived']),
  'Marketing_Customer_Segmentation': FunctionalModuleDefinition(title: 'Customer Segmentation', table: 'customer_segments', description: 'Create customer segments using business rules and status.', icon: Icons.groups_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('criteria'), ModuleField('customer_count'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Marketing_Email_Marketing': FunctionalModuleDefinition(title: 'Email Marketing', table: 'email_campaigns', description: 'Manage email campaign sends, audiences and outcomes.', icon: Icons.email_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_id'), ModuleField('segment_id'), ModuleField('scheduled_at'), ModuleField('sent_count'), ModuleField('open_count'), ModuleField('click_count'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Scheduled', 'Sending', 'Completed', 'Cancelled']),
  'Marketing_WhatsApp_Marketing': FunctionalModuleDefinition(title: 'WhatsApp Marketing', table: 'whatsapp_campaigns', description: 'Manage WhatsApp campaign records and delivery status.', icon: Icons.chat_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_id'), ModuleField('segment_id'), ModuleField('scheduled_at'), ModuleField('sent_count'), ModuleField('delivered_count'), ModuleField('read_count'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Scheduled', 'Sending', 'Completed', 'Cancelled']),
  'Marketing_Campaign_Reports': FunctionalModuleDefinition(title: 'Campaign Reports', table: 'campaign_reports', description: 'Maintain campaign report runs and performance snapshots.', icon: Icons.query_stats_outlined, fields: [ModuleField('id', required: true), ModuleField('campaign_id', required: true), ModuleField('report_type'), ModuleField('period'), ModuleField('sent_count'), ModuleField('delivered_count'), ModuleField('response_count'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Generated', 'Archived']),
  'Templates_Invoice_Templates': FunctionalModuleDefinition(title: 'Invoice Templates', table: 'invoice_templates', description: 'Manage reusable invoice document templates.', icon: Icons.description_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_type'), ModuleField('terms'), ModuleField('footer'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Templates_Quotation_Templates': FunctionalModuleDefinition(title: 'Quotation Templates', table: 'quotation_templates', description: 'Manage reusable quotation document templates.', icon: Icons.request_quote_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_type'), ModuleField('terms'), ModuleField('footer'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Templates_Email_Templates': FunctionalModuleDefinition(title: 'Email Templates', table: 'email_templates', description: 'Manage reusable email subjects and message templates.', icon: Icons.mark_email_read_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('subject'), ModuleField('content'), ModuleField('category'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Templates_HR_Templates': FunctionalModuleDefinition(title: 'HR Templates', table: 'hr_templates', description: 'Manage reusable HR letters and document templates.', icon: Icons.assignment_ind_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_type'), ModuleField('content'), ModuleField('department'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'Templates_Custom_Templates': FunctionalModuleDefinition(title: 'Custom Templates', table: 'custom_templates', description: 'Manage organization-specific document templates.', icon: Icons.dashboard_customize_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('template_type'), ModuleField('content'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_Management_Dashboard': FunctionalModuleDefinition(title: 'Management Dashboard', table: 'management_dashboard_records', description: 'Manage dashboard widgets and KPI configuration records.', icon: Icons.dashboard_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('widget_type'), ModuleField('metric'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_Sales_Dashboard': FunctionalModuleDefinition(title: 'Sales Dashboard', table: 'sales_dashboard_records', description: 'Manage sales dashboard configurations and KPI records.', icon: Icons.show_chart_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_CRM_Dashboard': FunctionalModuleDefinition(title: 'CRM Dashboard', table: 'crm_dashboard_records', description: 'Manage CRM dashboard configurations and KPI records.', icon: Icons.dashboard_customize_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_HR_Dashboard': FunctionalModuleDefinition(title: 'HR Dashboard', table: 'hr_dashboard_records', description: 'Manage HR dashboard configurations and KPI records.', icon: Icons.people_outline, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_Inventory_Dashboard': FunctionalModuleDefinition(title: 'Inventory Dashboard', table: 'inventory_dashboard_records', description: 'Manage inventory dashboard configurations and KPI records.', icon: Icons.inventory_2_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('warehouse_id'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_Production_Dashboard': FunctionalModuleDefinition(title: 'Production Dashboard', table: 'production_dashboard_records', description: 'Manage production dashboard configurations and KPI records.', icon: Icons.precision_manufacturing_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('production_order_id'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'ReportsAndDashboards_Custom_Reports': FunctionalModuleDefinition(title: 'Custom Reports', table: 'custom_reports', description: 'Create custom report definitions and manage report status.', icon: Icons.table_chart_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('report_type'), ModuleField('data_source'), ModuleField('filters'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Published', 'Archived']),
  'ReportsAndDashboards_Export_to_Excel_PDF': FunctionalModuleDefinition(title: 'Export to Excel/PDF', table: 'report_exports', description: 'Track report export requests and generated files.', icon: Icons.file_download_outlined, fields: [ModuleField('id', required: true), ModuleField('report_id'), ModuleField('format'), ModuleField('requested_by'), ModuleField('requested_at'), ModuleField('file_url'), ModuleField('status'), ModuleField('notes')], statuses: ['Queued', 'Processing', 'Completed', 'Failed']),
  'MobileAndWeb_Web_Application': FunctionalModuleDefinition(title: 'Web Application', table: 'web_app_releases', description: 'Manage web application release records and status.', icon: Icons.language_outlined, fields: [ModuleField('id', required: true), ModuleField('version'), ModuleField('release_date'), ModuleField('environment'), ModuleField('release_notes'), ModuleField('status')], statuses: ['Planned', 'Testing', 'Released', 'Rolled Back']),
  'MobileAndWeb_Android_Application': FunctionalModuleDefinition(title: 'Android Application', table: 'android_releases', description: 'Manage Android application release records and status.', icon: Icons.android_outlined, fields: [ModuleField('id', required: true), ModuleField('version'), ModuleField('release_date'), ModuleField('build_number'), ModuleField('release_notes'), ModuleField('status')], statuses: ['Planned', 'Testing', 'Released', 'Rolled Back']),
  'MobileAndWeb_Mobile_Dashboard': FunctionalModuleDefinition(title: 'Mobile Dashboard', table: 'mobile_dashboards', description: 'Manage mobile dashboard configuration records.', icon: Icons.phone_android_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('metric'), ModuleField('period'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Archived']),
  'MobileAndWeb_Mobile_Notifications': FunctionalModuleDefinition(title: 'Mobile Notifications', table: 'mobile_notifications', description: 'Create and track mobile notification messages.', icon: Icons.notifications_active_outlined, fields: [ModuleField('id', required: true), ModuleField('title', required: true), ModuleField('message'), ModuleField('recipient'), ModuleField('scheduled_at'), ModuleField('sent_at'), ModuleField('status')], statuses: ['Draft', 'Scheduled', 'Sent', 'Failed']),
  'Security_User_Management': FunctionalModuleDefinition(title: 'User Management', table: 'users', description: 'Manage application users and account status.', icon: Icons.manage_accounts_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('email', required: true), ModuleField('role'), ModuleField('department'), ModuleField('status'), ModuleField('last_login'), ModuleField('notes')], statuses: ['Active', 'Inactive', 'Locked']),
  'Security_Role_Based_Access': FunctionalModuleDefinition(title: 'Role-Based Access', table: 'roles', description: 'Manage roles and permission sets.', icon: Icons.admin_panel_settings_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('description'), ModuleField('permissions'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'Security_Admin_Panel': FunctionalModuleDefinition(title: 'Admin Panel', table: 'admin_settings', description: 'Manage administrator configuration records.', icon: Icons.settings_suggest_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('setting_key'), ModuleField('setting_value'), ModuleField('scope'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive']),
  'Security_Activity_Logs': FunctionalModuleDefinition(title: 'Activity Logs', table: 'audit_logs', description: 'Review and manage application audit log records.', icon: Icons.history_outlined, fields: [ModuleField('id', required: true), ModuleField('action'), ModuleField('module'), ModuleField('document_id'), ModuleField('user_id'), ModuleField('created_at'), ModuleField('details'), ModuleField('status')], statuses: ['Recorded', 'Reviewed', 'Archived']),
  'Security_Approval_Workflows': FunctionalModuleDefinition(title: 'Approval Workflows', table: 'approval_workflows', description: 'Create approval workflows and track workflow status.', icon: Icons.approval_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('module'), ModuleField('approver'), ModuleField('steps'), ModuleField('status'), ModuleField('notes')], statuses: ['Draft', 'Active', 'Paused', 'Archived']),
  'Integrations_API_Access': FunctionalModuleDefinition(title: 'API Access', table: 'api_keys', description: 'Manage API access records, scopes and status.', icon: Icons.api_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('key_hint'), ModuleField('scopes'), ModuleField('expires_at'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Revoked', 'Expired']),
  'Integrations_Third_Party_Integration': FunctionalModuleDefinition(title: 'Third-Party Integration', table: 'integrations', description: 'Manage third-party integration configurations and health.', icon: Icons.extension_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('provider'), ModuleField('configuration'), ModuleField('last_sync'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Connected', 'Disconnected', 'Error', 'Paused']),
  'Integrations_WhatsApp_Integration': FunctionalModuleDefinition(title: 'WhatsApp Integration', table: 'whatsapp_integrations', description: 'Manage WhatsApp integration configuration and connection status.', icon: Icons.chat_bubble_outline_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('provider'), ModuleField('phone_number'), ModuleField('last_sync'), ModuleField('status'), ModuleField('notes')], statuses: ['Connected', 'Disconnected', 'Error']),
  'Integrations_Payment_Gateway': FunctionalModuleDefinition(title: 'Payment Gateway', table: 'payment_gateways', description: 'Manage payment gateway configurations and connection state.', icon: Icons.credit_card_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('provider'), ModuleField('merchant_id'), ModuleField('environment'), ModuleField('last_sync'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Inactive', 'Error']),
  'Integrations_Tally_Integration': FunctionalModuleDefinition(title: 'Tally Integration', table: 'tally_integrations', description: 'Manage Tally integration configurations and synchronization.', icon: Icons.sync_alt_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('company_name'), ModuleField('last_sync'), ModuleField('sync_direction'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Connected', 'Disconnected', 'Error', 'Paused']),
  'Services_Cloud_Hosting': FunctionalModuleDefinition(title: 'Cloud Hosting', table: 'cloud_hosting', description: 'Manage cloud hosting service records, plans and status.', icon: Icons.cloud_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('plan'), ModuleField('region'), ModuleField('start_date'), ModuleField('renewal_date'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Active', 'Suspended', 'Expired']),
  'Services_Data_Backup': FunctionalModuleDefinition(title: 'Data Backup', table: 'data_backups', description: 'Track backup schedules, executions and retention status.', icon: Icons.backup_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('backup_type'), ModuleField('schedule'), ModuleField('last_backup'), ModuleField('retention_days'), ModuleField('storage_location'), ModuleField('status'), ModuleField('notes')], statuses: ['Scheduled', 'Running', 'Completed', 'Failed']),
  'Services_Software_Updates': FunctionalModuleDefinition(title: 'Software Updates', table: 'software_updates', description: 'Track software update releases and deployment status.', icon: Icons.system_update_outlined, fields: [ModuleField('id', required: true), ModuleField('version'), ModuleField('release_date'), ModuleField('environment'), ModuleField('change_summary'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Planned', 'Testing', 'Released', 'Rolled Back']),
  'Services_Standard_Support': FunctionalModuleDefinition(title: 'Standard Support', table: 'support_tickets', description: 'Manage support tickets under standard support service.', icon: Icons.support_agent_outlined, fields: [ModuleField('id', required: true), ModuleField('ticket_number', required: true), ModuleField('subject'), ModuleField('customer'), ModuleField('priority'), ModuleField('assignee'), ModuleField('created_at'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'In Progress', 'Resolved', 'Closed']),
  'Services_Priority_Support': FunctionalModuleDefinition(title: 'Priority Support', table: 'priority_support_tickets', description: 'Manage priority support tickets and escalation status.', icon: Icons.priority_high_outlined, fields: [ModuleField('id', required: true), ModuleField('ticket_number', required: true), ModuleField('subject'), ModuleField('customer'), ModuleField('priority'), ModuleField('assignee'), ModuleField('created_at'), ModuleField('status'), ModuleField('notes')], statuses: ['Open', 'Escalated', 'In Progress', 'Resolved', 'Closed']),
  'Services_Data_Migration': FunctionalModuleDefinition(title: 'Data Migration', table: 'data_migrations', description: 'Track data migration projects, batches and outcomes.', icon: Icons.import_export_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('source_system'), ModuleField('target_system'), ModuleField('record_count'), ModuleField('start_date'), ModuleField('end_date'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Planned', 'Running', 'Completed', 'Failed', 'Cancelled']),
  'Services_Staff_Training': FunctionalModuleDefinition(title: 'Staff Training', table: 'staff_training', description: 'Manage staff training sessions, attendees and completion status.', icon: Icons.school_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('trainer'), ModuleField('department'), ModuleField('training_date'), ModuleField('attendee_count'), ModuleField('owner'), ModuleField('status'), ModuleField('notes')], statuses: ['Planned', 'Scheduled', 'Completed', 'Cancelled']),
  'Services_Implementation': FunctionalModuleDefinition(title: 'Implementation', table: 'implementations', description: 'Track implementation projects, milestones and delivery status.', icon: Icons.rocket_launch_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('customer'), ModuleField('project_manager'), ModuleField('start_date'), ModuleField('target_date'), ModuleField('milestone'), ModuleField('status'), ModuleField('notes')], statuses: ['Planned', 'In Progress', 'On Hold', 'Completed', 'Cancelled']),
  'Services_Customization': FunctionalModuleDefinition(title: 'Customization', table: 'customizations', description: 'Track customer customization requests and delivery status.', icon: Icons.build_outlined, fields: [ModuleField('id', required: true), ModuleField('name', required: true), ModuleField('customer'), ModuleField('request_type'), ModuleField('requested_date'), ModuleField('owner'), ModuleField('estimated_hours'), ModuleField('status'), ModuleField('notes')], statuses: ['Requested', 'Approved', 'In Progress', 'Delivered', 'Rejected']),
};


class CrmLeadManagementScreen extends StatelessWidget {
  const CrmLeadManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Lead_Management']!);
}

class CrmCustomerManagementScreen extends StatelessWidget {
  const CrmCustomerManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Customer_Management']!);
}

class CrmContactManagementScreen extends StatelessWidget {
  const CrmContactManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Contact_Management']!);
}

class CrmFollowUpManagementScreen extends StatelessWidget {
  const CrmFollowUpManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Follow_up_Management']!);
}

class CrmSalesPipelineScreen extends StatelessWidget {
  const CrmSalesPipelineScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Sales_Pipeline']!);
}

class CrmDealsOpportunitiesScreen extends StatelessWidget {
  const CrmDealsOpportunitiesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Deals_Opportunities']!);
}

class CrmSalesActivitiesScreen extends StatelessWidget {
  const CrmSalesActivitiesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_Sales_Activities']!);
}

class CrmCRMReportsScreen extends StatelessWidget {
  const CrmCRMReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Crm_CRM_Reports']!);
}

class SalesAndInvoicingQuotationsScreen extends StatelessWidget {
  const SalesAndInvoicingQuotationsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Quotations']!);
}

class SalesAndInvoicingSalesOrdersScreen extends StatelessWidget {
  const SalesAndInvoicingSalesOrdersScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Sales_Orders']!);
}

class SalesAndInvoicingInvoicesScreen extends StatelessWidget {
  const SalesAndInvoicingInvoicesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Invoices']!);
}

class SalesAndInvoicingPaymentTrackingScreen extends StatelessWidget {
  const SalesAndInvoicingPaymentTrackingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Payment_Tracking']!);
}

class SalesAndInvoicingOutstandingReportsScreen extends StatelessWidget {
  const SalesAndInvoicingOutstandingReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Outstanding_Reports']!);
}

class SalesAndInvoicingInvoiceTemplatesScreen extends StatelessWidget {
  const SalesAndInvoicingInvoiceTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Invoice_Templates']!);
}

class SalesAndInvoicingRecurringInvoicesScreen extends StatelessWidget {
  const SalesAndInvoicingRecurringInvoicesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Recurring_Invoices']!);
}

class SalesAndInvoicingCreditDebitNotesScreen extends StatelessWidget {
  const SalesAndInvoicingCreditDebitNotesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_Credit_Debit_Notes']!);
}

class SalesAndInvoicingGSTEInvoiceScreen extends StatelessWidget {
  const SalesAndInvoicingGSTEInvoiceScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['SalesAndInvoicing_GST_e_Invoice']!);
}

class PurchaseVendorsScreen extends StatelessWidget {
  const PurchaseVendorsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Purchase_Vendors']!);
}

class PurchasePurchaseOrdersScreen extends StatelessWidget {
  const PurchasePurchaseOrdersScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Purchase_Purchase_Orders']!);
}

class PurchasePurchaseBillsScreen extends StatelessWidget {
  const PurchasePurchaseBillsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Purchase_Purchase_Bills']!);
}

class PurchasePurchaseReturnsScreen extends StatelessWidget {
  const PurchasePurchaseReturnsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Purchase_Purchase_Returns']!);
}

class PurchaseVendorPaymentsScreen extends StatelessWidget {
  const PurchaseVendorPaymentsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Purchase_Vendor_Payments']!);
}

class InventoryProductsScreen extends StatelessWidget {
  const InventoryProductsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Products']!);
}

class InventoryStockManagementScreen extends StatelessWidget {
  const InventoryStockManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Stock_Management']!);
}

class InventoryStockInOutScreen extends StatelessWidget {
  const InventoryStockInOutScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Stock_In_Out']!);
}

class InventoryStockAdjustmentScreen extends StatelessWidget {
  const InventoryStockAdjustmentScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Stock_Adjustment']!);
}

class InventoryLowStockAlertsScreen extends StatelessWidget {
  const InventoryLowStockAlertsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Low_Stock_Alerts']!);
}

class InventoryStockTransferScreen extends StatelessWidget {
  const InventoryStockTransferScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Stock_Transfer']!);
}

class InventoryMultipleWarehousesScreen extends StatelessWidget {
  const InventoryMultipleWarehousesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Multiple_Warehouses']!);
}

class InventoryBatchManagementScreen extends StatelessWidget {
  const InventoryBatchManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Batch_Management']!);
}

class InventoryInventoryReportsScreen extends StatelessWidget {
  const InventoryInventoryReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Inventory_Inventory_Reports']!);
}

class ProductionProductionModuleScreen extends StatelessWidget {
  const ProductionProductionModuleScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Production_Module']!);
}

class ProductionBillOfMaterialsBOMScreen extends StatelessWidget {
  const ProductionBillOfMaterialsBOMScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Bill_of_Materials_BOM']!);
}

class ProductionProductionOrdersScreen extends StatelessWidget {
  const ProductionProductionOrdersScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Production_Orders']!);
}

class ProductionRawMaterialManagementScreen extends StatelessWidget {
  const ProductionRawMaterialManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Raw_Material_Management']!);
}

class ProductionFinishedGoodsScreen extends StatelessWidget {
  const ProductionFinishedGoodsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Finished_Goods']!);
}

class ProductionWorkOrdersScreen extends StatelessWidget {
  const ProductionWorkOrdersScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Work_Orders']!);
}

class ProductionProductionPlanningScreen extends StatelessWidget {
  const ProductionProductionPlanningScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Production_Planning']!);
}

class ProductionProductionTrackingScreen extends StatelessWidget {
  const ProductionProductionTrackingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Production_Tracking']!);
}

class ProductionProductionReportsScreen extends StatelessWidget {
  const ProductionProductionReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Production_Production_Reports']!);
}

class HrHrOneEmployeeManagementScreen extends StatelessWidget {
  const HrHrOneEmployeeManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Employee_Management']!);
}

class HrHrOneEmployeeProfilesScreen extends StatelessWidget {
  const HrHrOneEmployeeProfilesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Employee_Profiles']!);
}

class HrHrOneDepartmentsScreen extends StatelessWidget {
  const HrHrOneDepartmentsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Departments']!);
}

class HrHrOneDesignationsScreen extends StatelessWidget {
  const HrHrOneDesignationsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Designations']!);
}

class HrHrOneAttendanceScreen extends StatelessWidget {
  const HrHrOneAttendanceScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Attendance']!);
}

class HrHrOneLeaveManagementScreen extends StatelessWidget {
  const HrHrOneLeaveManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Leave_Management']!);
}

class HrHrOneHolidayManagementScreen extends StatelessWidget {
  const HrHrOneHolidayManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Holiday_Management']!);
}

class HrHrOnePayrollScreen extends StatelessWidget {
  const HrHrOnePayrollScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Payroll']!);
}

class HrHrOnePayslipsScreen extends StatelessWidget {
  const HrHrOnePayslipsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Payslips']!);
}

class HrHrOneEmployeeDocumentsScreen extends StatelessWidget {
  const HrHrOneEmployeeDocumentsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Employee_Documents']!);
}

class HrHrOnePerformanceManagementScreen extends StatelessWidget {
  const HrHrOnePerformanceManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Performance_Management']!);
}

class HrHrOneRecruitmentScreen extends StatelessWidget {
  const HrHrOneRecruitmentScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['HrHrOne_Recruitment']!);
}

class MarketingCampaignManagementScreen extends StatelessWidget {
  const MarketingCampaignManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_Campaign_Management']!);
}

class MarketingMarketingTemplatesScreen extends StatelessWidget {
  const MarketingMarketingTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_Marketing_Templates']!);
}

class MarketingCustomerSegmentationScreen extends StatelessWidget {
  const MarketingCustomerSegmentationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_Customer_Segmentation']!);
}

class MarketingEmailMarketingScreen extends StatelessWidget {
  const MarketingEmailMarketingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_Email_Marketing']!);
}

class MarketingWhatsAppMarketingScreen extends StatelessWidget {
  const MarketingWhatsAppMarketingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_WhatsApp_Marketing']!);
}

class MarketingCampaignReportsScreen extends StatelessWidget {
  const MarketingCampaignReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Marketing_Campaign_Reports']!);
}

class TemplatesInvoiceTemplatesScreen extends StatelessWidget {
  const TemplatesInvoiceTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Templates_Invoice_Templates']!);
}

class TemplatesQuotationTemplatesScreen extends StatelessWidget {
  const TemplatesQuotationTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Templates_Quotation_Templates']!);
}

class TemplatesEmailTemplatesScreen extends StatelessWidget {
  const TemplatesEmailTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Templates_Email_Templates']!);
}

class TemplatesHRTemplatesScreen extends StatelessWidget {
  const TemplatesHRTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Templates_HR_Templates']!);
}

class TemplatesCustomTemplatesScreen extends StatelessWidget {
  const TemplatesCustomTemplatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Templates_Custom_Templates']!);
}

class ReportsAndDashboardsManagementDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsManagementDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Management_Dashboard']!);
}

class ReportsAndDashboardsSalesDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsSalesDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Sales_Dashboard']!);
}

class ReportsAndDashboardsCRMDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsCRMDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_CRM_Dashboard']!);
}

class ReportsAndDashboardsHRDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsHRDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_HR_Dashboard']!);
}

class ReportsAndDashboardsInventoryDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsInventoryDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Inventory_Dashboard']!);
}

class ReportsAndDashboardsProductionDashboardScreen extends StatelessWidget {
  const ReportsAndDashboardsProductionDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Production_Dashboard']!);
}

class ReportsAndDashboardsCustomReportsScreen extends StatelessWidget {
  const ReportsAndDashboardsCustomReportsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Custom_Reports']!);
}

class ReportsAndDashboardsExportToExcelPDFScreen extends StatelessWidget {
  const ReportsAndDashboardsExportToExcelPDFScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['ReportsAndDashboards_Export_to_Excel_PDF']!);
}

class MobileAndWebWebApplicationScreen extends StatelessWidget {
  const MobileAndWebWebApplicationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['MobileAndWeb_Web_Application']!);
}

class MobileAndWebAndroidApplicationScreen extends StatelessWidget {
  const MobileAndWebAndroidApplicationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['MobileAndWeb_Android_Application']!);
}

class MobileAndWebMobileDashboardScreen extends StatelessWidget {
  const MobileAndWebMobileDashboardScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['MobileAndWeb_Mobile_Dashboard']!);
}

class MobileAndWebMobileNotificationsScreen extends StatelessWidget {
  const MobileAndWebMobileNotificationsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['MobileAndWeb_Mobile_Notifications']!);
}

class SecurityUserManagementScreen extends StatelessWidget {
  const SecurityUserManagementScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Security_User_Management']!);
}

class SecurityRoleBasedAccessScreen extends StatelessWidget {
  const SecurityRoleBasedAccessScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Security_Role_Based_Access']!);
}

class SecurityAdminPanelScreen extends StatelessWidget {
  const SecurityAdminPanelScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Security_Admin_Panel']!);
}

class SecurityActivityLogsScreen extends StatelessWidget {
  const SecurityActivityLogsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Security_Activity_Logs']!);
}

class SecurityApprovalWorkflowsScreen extends StatelessWidget {
  const SecurityApprovalWorkflowsScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Security_Approval_Workflows']!);
}

class IntegrationsAPIAccessScreen extends StatelessWidget {
  const IntegrationsAPIAccessScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Integrations_API_Access']!);
}

class IntegrationsThirdPartyIntegrationScreen extends StatelessWidget {
  const IntegrationsThirdPartyIntegrationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Integrations_Third_Party_Integration']!);
}

class IntegrationsWhatsAppIntegrationScreen extends StatelessWidget {
  const IntegrationsWhatsAppIntegrationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Integrations_WhatsApp_Integration']!);
}

class IntegrationsPaymentGatewayScreen extends StatelessWidget {
  const IntegrationsPaymentGatewayScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Integrations_Payment_Gateway']!);
}

class IntegrationsTallyIntegrationScreen extends StatelessWidget {
  const IntegrationsTallyIntegrationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Integrations_Tally_Integration']!);
}

class ServicesCloudHostingScreen extends StatelessWidget {
  const ServicesCloudHostingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Cloud_Hosting']!);
}

class ServicesDataBackupScreen extends StatelessWidget {
  const ServicesDataBackupScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Data_Backup']!);
}

class ServicesSoftwareUpdatesScreen extends StatelessWidget {
  const ServicesSoftwareUpdatesScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Software_Updates']!);
}

class ServicesStandardSupportScreen extends StatelessWidget {
  const ServicesStandardSupportScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Standard_Support']!);
}

class ServicesPrioritySupportScreen extends StatelessWidget {
  const ServicesPrioritySupportScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Priority_Support']!);
}

class ServicesDataMigrationScreen extends StatelessWidget {
  const ServicesDataMigrationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Data_Migration']!);
}

class ServicesStaffTrainingScreen extends StatelessWidget {
  const ServicesStaffTrainingScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Staff_Training']!);
}

class ServicesImplementationScreen extends StatelessWidget {
  const ServicesImplementationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Implementation']!);
}

class ServicesCustomizationScreen extends StatelessWidget {
  const ServicesCustomizationScreen({super.key});
  @override Widget build(BuildContext context) => FunctionalModuleScreen(definition: _definitions['Services_Customization']!);
}

// Compatibility aliases retained for the existing module router naming.
class CrmCrmReportsScreen extends CrmCRMReportsScreen { const CrmCrmReportsScreen({super.key}); }
class SalesAndInvoicingGstEInvoiceScreen extends SalesAndInvoicingGSTEInvoiceScreen { const SalesAndInvoicingGstEInvoiceScreen({super.key}); }
class ProductionBillOfMaterialsBomScreen extends ProductionBillOfMaterialsBOMScreen { const ProductionBillOfMaterialsBomScreen({super.key}); }
class TemplatesHrTemplatesScreen extends TemplatesHRTemplatesScreen { const TemplatesHrTemplatesScreen({super.key}); }
class ReportsAndDashboardsCrmDashboardScreen extends ReportsAndDashboardsCRMDashboardScreen { const ReportsAndDashboardsCrmDashboardScreen({super.key}); }
class ReportsAndDashboardsHrDashboardScreen extends ReportsAndDashboardsHRDashboardScreen { const ReportsAndDashboardsHrDashboardScreen({super.key}); }
class ReportsAndDashboardsExportToExcelPdfScreen extends ReportsAndDashboardsExportToExcelPDFScreen { const ReportsAndDashboardsExportToExcelPdfScreen({super.key}); }
class MarketingWhatsappMarketingScreen extends MarketingWhatsAppMarketingScreen { const MarketingWhatsappMarketingScreen({super.key}); }
class IntegrationsApiAccessScreen extends IntegrationsAPIAccessScreen { const IntegrationsApiAccessScreen({super.key}); }
class IntegrationsWhatsappIntegrationScreen extends IntegrationsWhatsAppIntegrationScreen { const IntegrationsWhatsappIntegrationScreen({super.key}); }
