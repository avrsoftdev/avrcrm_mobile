import 'package:supabase_flutter/supabase_flutter.dart';

class AppBackend {
  AppBackend._();

  static final AppBackend instance = AppBackend._();

  final SupabaseClient db = Supabase.instance.client;

  String? _companyId;

  String? get companyId => _companyId;

  String? get uid => db.auth.currentUser?.id;

  bool get isSignedIn => db.auth.currentUser != null;

  User? get currentUser => db.auth.currentUser;

  Future<void> initialize() async {
    final user = db.auth.currentUser;

    if (user == null) {
      _companyId = null;
      return;
    }

    try {
      final profile = await db
          .from('users')
          .select('company_id')
          .eq('id', user.id)
          .maybeSingle();

      _companyId = profile?['company_id']?.toString();
    } catch (_) {
      _companyId = null;
    }
  }

  Future<String> requireCompanyId() async {
    if (_companyId == null) {
      await initialize();
    }

    final value = _companyId;

    if (value == null || value.isEmpty) {
      throw StateError(
        'No company is assigned to the signed-in user.',
      );
    }

    return value;
  }

  Future<List<Map<String, dynamic>>> getAll(
    String table, {
    int? limit,
  }) async {
    final company = await requireCompanyId();

    dynamic query = db
        .from(table)
        .select()
        .eq('company_id', company)
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    if (limit != null) {
      query = query.limit(limit);
    }

    final result = await query;

    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>?> getById(
    String table,
    String id,
  ) async {
    final company = await requireCompanyId();

    final result = await db
        .from(table)
        .select()
        .eq('id', id)
        .eq('company_id', company)
        .eq('is_deleted', false)
        .maybeSingle();

    return result;
  }

  Future<String> create(
    String table,
    Map<String, dynamic> data, {
    String? documentId,
  }) async {
    final company = await requireCompanyId();

    final userId = uid;

    if (userId == null) {
      throw StateError('User is not signed in.');
    }

    final payload = <String, dynamic>{
      ...data,
      'company_id': company,
      'created_by': data['created_by'] ?? userId,
      'updated_by': userId,
      'is_deleted': data['is_deleted'] ?? false,
    };

    if (documentId != null) {
      payload['id'] = documentId;
    }

    final result = await db
        .from(table)
        .insert(payload)
        .select('id')
        .single();

    return result['id'].toString();
  }

  Future<void> update(
    String table,
    String id,
    Map<String, dynamic> data,
  ) async {
    final company = await requireCompanyId();

    final userId = uid;

    if (userId == null) {
      throw StateError('User is not signed in.');
    }

    await db
        .from(table)
        .update({
          ...data,
          'company_id': company,
          'updated_by': userId,
        })
        .eq('id', id)
        .eq('company_id', company);
  }

  Future<void> softDelete(
    String table,
    String id,
  ) async {
    await update(
      table,
      id,
      {
        'is_deleted': true,
      },
    );
  }

  Future<void> deletePermanently(
    String table,
    String id,
  ) async {
    final company = await requireCompanyId();

    await db
        .from(table)
        .delete()
        .eq('id', id)
        .eq('company_id', company);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = false,
  }) async {
    final company = await requireCompanyId();

    dynamic request = db
        .from(table)
        .select()
        .eq('company_id', company)
        .eq('is_deleted', false);

    if (filters != null) {
      for (final entry in filters.entries) {
        request = request.eq(entry.key, entry.value);
      }
    }

    if (orderBy != null) {
      request = request.order(
        orderBy,
        ascending: ascending,
      );
    }

    final result = await request;

    return List<Map<String, dynamic>>.from(result);
  }
}