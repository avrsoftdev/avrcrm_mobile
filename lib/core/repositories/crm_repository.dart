import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/audit_service.dart';
import '../services/numbering_service.dart';

class CrmRepository {
  CrmRepository._();
  static final CrmRepository instance = CrmRepository._();

  final _supabase = Supabase.instance.client;
  final AuditService _audit = AuditService.instance;

  /// Real-time stream of non-deleted documents, ordered by updated_at desc.
  Stream<List<Map<String, dynamic>>> watch(String collection) {
    return _supabase
        .from(collection)
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false)
        .map((rows) => rows.where((row) => row['deleted_at'] == null).toList());
  }

  /// Insert a new document and return its id.
  Future<String> create(String collection, Map<String, dynamic> data) async {
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

    final id = response['id'] as String;

    await _audit.log(
      action: 'create',
      module: collection,
      documentId: id,
    );

    return id;
  }

  /// Update an existing document.
  Future<void> update(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final payload = {
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from(collection).update(payload).eq('id', id);

    await _audit.log(
      action: 'update',
      module: collection,
      documentId: id,
    );
  }

  /// Soft-delete a document.
  Future<void> delete(String collection, String id) async {
    await _supabase.from(collection).update({
      'deleted_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', id);

    await _audit.log(
      action: 'delete',
      module: collection,
      documentId: id,
    );
  }

  Future<String> nextNumber(String type) =>
      NumberingService.instance.next(type);
}