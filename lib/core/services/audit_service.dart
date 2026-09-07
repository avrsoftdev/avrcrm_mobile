import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/app_backend.dart';

class AuditService {
  AuditService._();

  static final AuditService instance =
      AuditService._();

  final SupabaseClient _db =
      Supabase.instance.client;

  Future<void> log({
    required String action,
    required String module,
    String? documentId,
    Map<String, dynamic>? metadata,
  }) async {
    final companyId =
        await AppBackend.instance.requireCompanyId();

    final uid =
        _db.auth.currentUser?.id;

    if (uid == null) return;

    await _db.from('audit_logs').insert({
      'company_id': companyId,
      'user_id': uid,
      'action': action,
      'module': module,
      'document_id': documentId,
      'metadata': metadata ?? {},
    });
  }
}
