import 'package:supabase_flutter/supabase_flutter.dart';

class NumberingService {
  NumberingService._();
  static final NumberingService instance = NumberingService._();

  final _supabase = Supabase.instance.client;

  Future<String> next(String type) async {
    // Get current company id (adjust this helper to match your auth setup)
    final companyId = await _requireCompanyId();

    final counterKey = '${companyId}_$type';

    // Atomically increment the counter using a Postgres function (recommended)
    // or a simple read-modify-write if you prefer pure client-side.
    final nextValue = await _incrementCounter(counterKey, companyId, type);

    final year = DateTime.now().year;

    final prefix = switch (type) {
      'quote' => 'QT',
      'invoice' => 'INV',
      'order' => 'ORD',
      'payment' => 'PAY',
      'lead' => 'LEAD',
      _ => type.toUpperCase(),
    };

    return '$prefix-$year-${nextValue.toString().padLeft(4, '0')}';
  }

  /// Increment counter safely.
  /// Preferred way: call a Postgres RPC function that does the increment atomically.
  Future<int> _incrementCounter(
    String counterKey,
    String companyId,
    String type,
  ) async {
    // ---------- Option A: Recommended – use RPC ----------
    // Create this function in Supabase SQL editor (see below).
    final result = await _supabase.rpc(
      'increment_counter',
      params: {
        'p_key': counterKey,
        'p_company_id': companyId,
        'p_type': type,
      },
    );

    return (result as num).toInt();

    // ---------- Option B: Pure client-side (less safe under concurrency) ----------
    // final existing = await _supabase
    //     .from('counters')
    //     .select('value')
    //     .eq('id', counterKey)
    //     .maybeSingle();
    //
    // final current = (existing?['value'] as num?)?.toInt() ?? 0;
    // final next = current + 1;
    //
    // await _supabase.from('counters').upsert({
    //   'id': counterKey,
    //   'company_id': companyId,
    //   'type': type,
    //   'value': next,
    //   'updated_at': DateTime.now().toIso8601String(),
    // });
    //
    // return next;
  }

  Future<String> _requireCompanyId() async {
    // Replace with your real company lookup logic
    // Example: from user metadata or a companies table
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final companyId = user.userMetadata?['company_id'] as String?;
    if (companyId == null || companyId.isEmpty) {
      throw Exception('Company ID not found for current user');
    }
    return companyId;
  }
}