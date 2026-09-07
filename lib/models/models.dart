class Lead {
  final String id;
  final String firstName;
  final String lastName;
  final String company;
  final String email;
  final String phone;
  final String status;
  final String source;
  final String priority;
  final String assignedTo;
  final double value;
  final String createdAt;
  final String? lastActivity;

  Lead({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.email,
    required this.phone,
    required this.status,
    required this.source,
    required this.priority,
    required this.assignedTo,
    required this.value,
    required this.createdAt,
    this.lastActivity,
  });

  String get fullName => '$firstName $lastName';
}

class Customer {
  final String id;
  final String company;
  final String email;
  final String phone;
  final String industry;
  final String type;
  final String status;
  final double revenue;
  final String owner;
  final String createdAt;

  Customer({
    required this.id,
    required this.company,
    required this.email,
    required this.phone,
    required this.industry,
    required this.type,
    required this.status,
    required this.revenue,
    required this.owner,
    required this.createdAt,
  });
}

class Opportunity {
  final String id;
  final String name;
  final String company;
  final String stage;
  final double value;
  final int probability;
  final String closeDate;
  final String owner;
  final String status;

  Opportunity({
    required this.id,
    required this.name,
    required this.company,
    required this.stage,
    required this.value,
    required this.probability,
    required this.closeDate,
    required this.owner,
    required this.status,
  });
}

class Invoice {
  final String id;
  final String customer;
  final double amount;
  final String status;
  final String dueDate;
  final String issuedDate;

  Invoice({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.dueDate,
    required this.issuedDate,
  });
}

class Product {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double price;
  final int stock;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
  });
}

class Ticket {
  final String id;
  final String subject;
  final String customer;
  final String priority;
  final String status;
  final String assignee;
  final String createdAt;

  Ticket({
    required this.id,
    required this.subject,
    required this.customer,
    required this.priority,
    required this.status,
    required this.assignee,
    required this.createdAt,
  });
}

class Employee {
  final String id;
  final String name;
  final String email;
  final String department;
  final String role;
  final String status;
  final String joinDate;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.status,
    required this.joinDate,
  });
}

class ActivityItem {
  final int id;
  final String type;
  final String title;
  final String user;
  final String time;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.user,
    required this.time,
  });
}

class FollowUp {
  final int id;
  final String lead;
  final String company;
  final String type;
  final String time;
  final String priority;

  FollowUp({
    required this.id,
    required this.lead,
    required this.company,
    required this.type,
    required this.time,
    required this.priority,
  });
}
