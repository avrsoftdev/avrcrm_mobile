import 'package:supabase_flutter/supabase_flutter.dart';

class ModuleRepository {
  ModuleRepository(this.collection);

  final String collection;
  final _supabase = Supabase.instance.client;

  /// Real-time stream of non-deleted documents.
  Stream<List<Map<String, dynamic>>> watch() {
    return _supabase
        .from(collection)
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false)
        .map((rows) => rows.where((row) => row['deleted_at'] == null).toList());
  }

  /// Create a new document and return its id.
  Future<String> create(Map<String, dynamic> data) async {
    final payload = {
      ...data,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from(collection)
        .insert(payload)
        .select('id')
        .single();

    return response['id'] as String;
  }

  /// Update an existing document.
  Future<void> update(String id, Map<String, dynamic> data) async {
    final payload = {
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from(collection).update(payload).eq('id', id);
  }

  /// Soft-delete a document.
  Future<void> delete(String id) async {
    await _supabase.from(collection).update({
      'deleted_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }
}

class TemplateRepository extends ModuleRepository {
  TemplateRepository() : super('templates');

  static const categories = [
    'Invoice',
    'Quote',
    'Order',
    'Campaign',
    'Email',
    'Marketing',
    'Inventory',
    'HR',
    'CRM',
    'Payment',
  ];

  Future<void> seedDefaults() async {
    // Check if any templates already exist
    final existing = await _supabase
        .from('templates')
        .select('id')
        .isFilter('deleted_at', null)
        .limit(1);

    if (existing.isNotEmpty) return;

    for (var i = 1; i <= 100; i++) {
      final category = categories[(i - 1) % categories.length];

      await create({
        'name': '$category Template ${i.toString().padLeft(3, '0')}',
        'type': category.toLowerCase(),
        'category': category,
        'subject': '$category — {{customer_name}}',
        'content': _content(category),
        'status': 'Active',
        'isFavorite': i <= 10,
        'variables': [
          'customer_name',
          'company_name',
          'invoice_number',
          'quote_number',
          'amount',
          'date',
        ],
      });
    }
  }

  String _content(String category) => switch (category) {
        'Invoice' =>
          'Dear {{customer_name}},\n\nPlease find invoice {{invoice_number}} for {{amount}}.\n\nRegards,\n{{company_name}}',
        'Quote' =>
          'Dear {{customer_name}},\n\nPlease find quotation {{quote_number}} for your requirements.\n\nRegards,\n{{company_name}}',
        'Order' =>
          'Order confirmation for {{customer_name}}. Order reference: {{order_number}}.',
        'Campaign' =>
          'Hello {{customer_name}},\n\nWe have an update from {{company_name}} for you.',
        'Email' =>
          'Hello {{customer_name}},\n\nThank you for contacting {{company_name}}.',
        'Marketing' => 'Discover the latest solutions from {{company_name}}.',
        'Inventory' =>
          'Inventory alert for {{product_name}}. Current quantity: {{quantity}}.',
        'HR' =>
          'Dear {{employee_name}},\n\nThis is an official communication from {{company_name}}.',
        'CRM' => 'Follow-up regarding your enquiry with {{company_name}}.',
        _ =>
          'Payment acknowledgement for {{customer_name}}. Amount: {{amount}}.',
      };
}