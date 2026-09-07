import '../models/models.dart';

class MockData {
  static const currentUser = {
    'name': 'Aakash Sharma',
    'email': 'aakash@avrcrm.in',
    'role': 'Admin',
    'avatar': 'AS',
  };

  static final leads = [
    Lead(id: 'LD-1001', firstName: 'Rajesh', lastName: 'Kumar', company: 'TechNova Pvt Ltd', email: 'rajesh@technova.in', phone: '+91 98765 43210', status: 'Qualified', source: 'Website', priority: 'High', assignedTo: 'Arjun Mehta', value: 450000, createdAt: '2026-08-12', lastActivity: 'Call completed'),
    Lead(id: 'LD-1002', firstName: 'Anita', lastName: 'Desai', company: 'GreenEnergy Solutions', email: 'anita@greenenergy.com', phone: '+91 87654 32109', status: 'Proposal', source: 'Referral', priority: 'High', assignedTo: 'Priya Sharma', value: 1200000, createdAt: '2026-08-10', lastActivity: 'Quotation sent'),
    Lead(id: 'LD-1003', firstName: 'Suresh', lastName: 'Patel', company: 'BuildRight Infra', email: 'suresh@buildright.in', phone: '+91 76543 21098', status: 'New', source: 'LinkedIn', priority: 'Medium', assignedTo: 'Rahul Verma', value: 320000, createdAt: '2026-08-15', lastActivity: 'Lead created'),
    Lead(id: 'LD-1004', firstName: 'Meera', lastName: 'Iyer', company: 'HealthPlus Clinics', email: 'meera@healthplus.com', phone: '+91 65432 10987', status: 'Contacted', source: 'Cold Call', priority: 'Medium', assignedTo: 'Sneha Patel', value: 180000, createdAt: '2026-08-14', lastActivity: 'Email sent'),
    Lead(id: 'LD-1005', firstName: 'Vikram', lastName: 'Singh', company: 'AutoMotive India', email: 'vikram@automotive.in', phone: '+91 54321 09876', status: 'Negotiation', source: 'Trade Show', priority: 'High', assignedTo: 'Arjun Mehta', value: 850000, createdAt: '2026-08-08', lastActivity: 'Meeting scheduled'),
    Lead(id: 'LD-1006', firstName: 'Pooja', lastName: 'Reddy', company: 'EduSmart Systems', email: 'pooja@edusmart.com', phone: '+91 43210 98765', status: 'Won', source: 'Website', priority: 'Low', assignedTo: 'Priya Sharma', value: 275000, createdAt: '2026-08-05', lastActivity: 'Deal won'),
    Lead(id: 'LD-1007', firstName: 'Amit', lastName: 'Joshi', company: 'FinServe Ltd', email: 'amit@finserve.in', phone: '+91 32109 87654', status: 'Lost', source: 'Referral', priority: 'Medium', assignedTo: 'Rahul Verma', value: 520000, createdAt: '2026-08-01', lastActivity: 'Deal lost'),
    Lead(id: 'LD-1008', firstName: 'Neha', lastName: 'Gupta', company: 'RetailMax Stores', email: 'neha@retailmax.com', phone: '+91 21098 76543', status: 'Qualified', source: 'Google Ads', priority: 'High', assignedTo: 'Sneha Patel', value: 390000, createdAt: '2026-08-13', lastActivity: 'Demo done'),
  ];

  static final customers = [
    Customer(id: 'CUS-2001', company: 'TechNova Pvt Ltd', email: 'accounts@technova.in', phone: '+91 98765 43210', industry: 'IT & Software', type: 'Enterprise', status: 'Active', revenue: 2450000, owner: 'Arjun Mehta', createdAt: '2025-11-12'),
    Customer(id: 'CUS-2002', company: 'GreenEnergy Solutions', email: 'billing@greenenergy.com', phone: '+91 87654 32109', industry: 'Renewable Energy', type: 'Enterprise', status: 'Active', revenue: 3800000, owner: 'Priya Sharma', createdAt: '2025-09-20'),
    Customer(id: 'CUS-2003', company: 'BuildRight Infra', email: 'finance@buildright.in', phone: '+91 76543 21098', industry: 'Construction', type: 'SMB', status: 'Active', revenue: 980000, owner: 'Rahul Verma', createdAt: '2026-01-15'),
    Customer(id: 'CUS-2004', company: 'HealthPlus Clinics', email: 'admin@healthplus.com', phone: '+91 65432 10987', industry: 'Healthcare', type: 'SMB', status: 'Prospect', revenue: 0, owner: 'Sneha Patel', createdAt: '2026-07-22'),
    Customer(id: 'CUS-2005', company: 'AutoMotive India', email: 'procurement@automotive.in', phone: '+91 54321 09876', industry: 'Automotive', type: 'Enterprise', status: 'Active', revenue: 1560000, owner: 'Arjun Mehta', createdAt: '2025-06-08'),
    Customer(id: 'CUS-2006', company: 'EduSmart Systems', email: 'accounts@edusmart.com', phone: '+91 43210 98765', industry: 'Education', type: 'Startup', status: 'Active', revenue: 420000, owner: 'Priya Sharma', createdAt: '2026-03-10'),
  ];

  static final opportunities = [
    Opportunity(id: 'OPP-3001', name: 'DG-PV Sync System - NSSTA', company: 'SJVN Ltd', stage: 'Proposal', value: 1850000, probability: 70, closeDate: '2026-09-30', owner: 'Arjun Mehta', status: 'Open'),
    Opportunity(id: 'OPP-3002', name: 'Solar Inverter Package', company: 'GreenEnergy Solutions', stage: 'Negotiation', value: 2400000, probability: 85, closeDate: '2026-09-15', owner: 'Priya Sharma', status: 'Open'),
    Opportunity(id: 'OPP-3003', name: 'Industrial UPS Solution', company: 'BuildRight Infra', stage: 'Qualification', value: 650000, probability: 40, closeDate: '2026-10-20', owner: 'Rahul Verma', status: 'Open'),
    Opportunity(id: 'OPP-3004', name: 'Smart Metering Project', company: 'TechNova Pvt Ltd', stage: 'Closed Won', value: 920000, probability: 100, closeDate: '2026-08-20', owner: 'Arjun Mehta', status: 'Won'),
    Opportunity(id: 'OPP-3005', name: 'Battery Storage System', company: 'AutoMotive India', stage: 'Discovery', value: 1100000, probability: 25, closeDate: '2026-11-10', owner: 'Sneha Patel', status: 'Open'),
  ];

  static final invoices = [
    Invoice(id: 'INV-4001', customer: 'TechNova Pvt Ltd', amount: 485000, status: 'Paid', dueDate: '2026-08-15', issuedDate: '2026-07-15'),
    Invoice(id: 'INV-4002', customer: 'GreenEnergy Solutions', amount: 920000, status: 'Sent', dueDate: '2026-09-10', issuedDate: '2026-08-10'),
    Invoice(id: 'INV-4003', customer: 'BuildRight Infra', amount: 175000, status: 'Overdue', dueDate: '2026-08-01', issuedDate: '2026-07-01'),
    Invoice(id: 'INV-4004', customer: 'AutoMotive India', amount: 340000, status: 'Draft', dueDate: '2026-09-20', issuedDate: '2026-08-25'),
    Invoice(id: 'INV-4005', customer: 'EduSmart Systems', amount: 125000, status: 'Paid', dueDate: '2026-08-05', issuedDate: '2026-07-05'),
  ];

  static final products = [
    Product(id: 'PRD-5001', name: '110 kW Solar Inverter', sku: 'INV-110KW', category: 'Inverters', price: 185000, stock: 24, status: 'Active'),
    Product(id: 'PRD-5002', name: '60 kW Solar Inverter', sku: 'INV-60KW', category: 'Inverters', price: 98000, stock: 41, status: 'Active'),
    Product(id: 'PRD-5003', name: 'DG-PV Sync Controller', sku: 'CTRL-DGPV', category: 'Controllers', price: 45000, stock: 18, status: 'Active'),
    Product(id: 'PRD-5004', name: 'M2M IoT Modem', sku: 'MDM-M2M', category: 'Connectivity', price: 4200, stock: 56, status: 'Active'),
    Product(id: 'PRD-5005', name: '400 kVA DG Set', sku: 'DG-400KVA', category: 'Generators', price: 1250000, stock: 3, status: 'Active'),
    Product(id: 'PRD-5006', name: '160 kVA DG Set', sku: 'DG-160KVA', category: 'Generators', price: 580000, stock: 5, status: 'Active'),
  ];

  static final tickets = [
    Ticket(id: 'TKT-6001', subject: 'DG Sync not triggering at Greater Noida', customer: 'SJVN Ltd', priority: 'Critical', status: 'In Progress', assignee: 'Rahul Verma', createdAt: '2026-08-28'),
    Ticket(id: 'TKT-6002', subject: 'Inverter communication error', customer: 'GreenEnergy Solutions', priority: 'High', status: 'Open', assignee: 'Arjun Mehta', createdAt: '2026-08-30'),
    Ticket(id: 'TKT-6003', subject: 'Request for SIM registration help', customer: 'BuildRight Infra', priority: 'Medium', status: 'Resolved', assignee: 'Sneha Patel', createdAt: '2026-08-25'),
    Ticket(id: 'TKT-6004', subject: 'Portal login credentials missing', customer: 'TechNova Pvt Ltd', priority: 'Low', status: 'Closed', assignee: 'Priya Sharma', createdAt: '2026-08-20'),
  ];

  static final employees = [
    Employee(id: 'EMP-1001', name: 'Arjun Mehta', email: 'arjun@avrcrm.in', department: 'Sales', role: 'Sales Manager', status: 'Active', joinDate: '2023-04-12'),
    Employee(id: 'EMP-1002', name: 'Priya Sharma', email: 'priya@avrcrm.in', department: 'Sales', role: 'Sales Executive', status: 'Active', joinDate: '2024-01-15'),
    Employee(id: 'EMP-1003', name: 'Rahul Verma', email: 'rahul@avrcrm.in', department: 'Support', role: 'Support Manager', status: 'Active', joinDate: '2023-08-20'),
    Employee(id: 'EMP-1004', name: 'Sneha Patel', email: 'sneha@avrcrm.in', department: 'Sales', role: 'Sales Executive', status: 'On Leave', joinDate: '2024-06-01'),
    Employee(id: 'EMP-1005', name: 'Vikram Singh', email: 'vikram@avrcrm.in', department: 'Marketing', role: 'Marketing Manager', status: 'Active', joinDate: '2023-11-10'),
  ];

  static final activities = [
    ActivityItem(id: 1, type: 'Deal Won', title: 'EduSmart Systems – ₹2.75L', user: 'Priya Sharma', time: '2 hours ago'),
    ActivityItem(id: 2, type: 'Quotation Sent', title: 'GreenEnergy – Solar Package', user: 'Priya Sharma', time: '5 hours ago'),
    ActivityItem(id: 3, type: 'Lead Created', title: 'BuildRight Infra', user: 'Rahul Verma', time: 'Yesterday'),
    ActivityItem(id: 4, type: 'Meeting Scheduled', title: 'AutoMotive India', user: 'Arjun Mehta', time: 'Yesterday'),
    ActivityItem(id: 5, type: 'Call Completed', title: 'TechNova – Follow-up', user: 'Arjun Mehta', time: '2 days ago'),
  ];

  static final followUps = [
    FollowUp(id: 1, lead: 'Rajesh Kumar', company: 'TechNova', type: 'Call', time: 'Today, 3:00 PM', priority: 'High'),
    FollowUp(id: 2, lead: 'Anita Desai', company: 'GreenEnergy', type: 'Meeting', time: 'Tomorrow, 11:00 AM', priority: 'High'),
    FollowUp(id: 3, lead: 'Suresh Patel', company: 'BuildRight', type: 'Email', time: 'Aug 18, 10:00 AM', priority: 'Medium'),
    FollowUp(id: 4, lead: 'Vikram Singh', company: 'AutoMotive', type: 'Site Visit', time: 'Aug 20, 2:00 PM', priority: 'High'),
  ];

  static final salesMonthly = [
    {'period': 'Jan', 'revenue': 1850000.0},
    {'period': 'Feb', 'revenue': 2100000.0},
    {'period': 'Mar', 'revenue': 1950000.0},
    {'period': 'Apr', 'revenue': 2400000.0},
    {'period': 'May', 'revenue': 2250000.0},
    {'period': 'Jun', 'revenue': 2600000.0},
    {'period': 'Jul', 'revenue': 2450000.0},
    {'period': 'Aug', 'revenue': 2850000.0},
  ];

  static final leadSources = [
    {'name': 'Website', 'value': 35.0},
    {'name': 'Referral', 'value': 25.0},
    {'name': 'LinkedIn', 'value': 18.0},
    {'name': 'Cold Call', 'value': 12.0},
    {'name': 'Trade Show', 'value': 10.0},
  ];
}
