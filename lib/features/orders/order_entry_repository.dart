import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'order_draft.dart';

class OrderAttachment {
  const OrderAttachment({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

abstract interface class OrderEntryBackend {
  Future<List<Map<String, dynamic>>> fetchOrderConfigurations(String kind);

  Future<void> uploadOrderDocument(String path, OrderAttachment file);

  Future<void> insertOrder(Map<String, dynamic> payload);

  Future<void> removeOrderDocuments(List<String> paths);
}

class SupabaseOrderEntryBackend implements OrderEntryBackend {
  SupabaseOrderEntryBackend(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchOrderConfigurations(
    String kind,
  ) async {
    final rows =
        await _client.from('order_configurations').select().eq('kind', kind);
    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<void> uploadOrderDocument(String path, OrderAttachment file) async {
    await _client.storage
        .from('order-documents')
        .uploadBinary(path, file.bytes, fileOptions: const FileOptions());
  }

  @override
  Future<void> insertOrder(Map<String, dynamic> payload) async {
    await _client.from('orders').insert(payload);
  }

  @override
  Future<void> removeOrderDocuments(List<String> paths) async {
    await _client.storage.from('order-documents').remove(paths);
  }
}

class OrderEntryRepository {
  OrderEntryRepository({
    required OrderEntryBackend backend,
    DateTime Function()? clock,
  })  : _backend = backend,
        _clock = clock ?? DateTime.now;

  final OrderEntryBackend _backend;
  final DateTime Function() _clock;

  Future<List<String>> loadActiveOptions(String kind) async {
    final rows = await _backend.fetchOrderConfigurations(kind);
    final options = <({String value, int order})>[];

    for (final row in rows) {
      if (!_isActive(row, kind)) continue;
      final value = _configurationValue(row);
      if (value == null) {
        throw FormatException(
          'An active $kind order configuration has no display value.',
        );
      }
      final orderValue = row['sort_order'] ?? row['display_order'];
      options.add((
        value: value,
        order: orderValue is num ? orderValue.toInt() : 0,
      ));
    }

    options.sort((a, b) {
      final byOrder = a.order.compareTo(b.order);
      return byOrder != 0 ? byOrder : a.value.compareTo(b.value);
    });
    return options.map((option) => option.value).toSet().toList();
  }

  Future<void> submit({
    required OrderDraft draft,
    required String tenantId,
    required String userId,
    OrderAttachment? piDocument,
    OrderAttachment? bomQuotationDocument,
    OrderAttachment? drawingDocument,
  }) async {
    if (tenantId.trim().isEmpty || userId.trim().isEmpty) {
      throw StateError('Your signed-in account could not be verified.');
    }

    final uploadedPaths = <String>[];
    final timestamp = _clock().toUtc().toIso8601String();
    final files = <({String column, OrderAttachment? file})>[
      (column: 'pi_upload_path', file: piDocument),
      (
        column: 'bom_quotation_upload_path',
        file: bomQuotationDocument,
      ),
      (column: 'drawing_upload_path', file: drawingDocument),
    ];

    final payload = <String, dynamic>{
      'pi_number': draft.piNumber.trim(),
      'stage': draft.stage,
      'wip': draft.wip,
      'order_date': draft.orderDate,
      'delivery_needed_on': draft.deliveryNeededOn,
      'assembly_date': draft.assemblyDate,
      'dispatch_date': draft.dispatchDate,
      'ready_stock': draft.readyStock,
      'company_name': draft.companyName.trim(),
      'project_name': draft.projectName.trim(),
      'project_title': draft.projectTitle.trim(),
      'delivery_address': draft.deliveryAddress.trim(),
      'client_name': draft.clientName.trim(),
      'client_contact_number': draft.clientContactNumber.trim(),
      'customer_email_id': draft.customerEmailId.trim(),
      'advance_received': draft.advanceReceived,
      'basic_order_value': draft.basicOrderValue,
      'order_value_with_gst': draft.orderValueWithGst,
      'tenant_id': tenantId.trim(),
      'created_by': userId.trim(),
      'created_at': timestamp,
      'updated_at': timestamp,
    };

    try {
      for (var index = 0; index < files.length; index++) {
        final entry = files[index];
        final file = entry.file;
        if (file == null) continue;
        final path = _documentPath(tenantId, index, file.name);
        await _backend.uploadOrderDocument(path, file);
        uploadedPaths.add(path);
        payload[entry.column] = path;
      }
      await _backend.insertOrder(payload);
    } catch (error) {
      if (uploadedPaths.isNotEmpty) {
        try {
          await _backend.removeOrderDocuments(uploadedPaths);
        } catch (cleanupError) {
          throw StateError(
            'Order save failed: $error. Uploaded document cleanup also '
            'failed: $cleanupError',
          );
        }
      }
      rethrow;
    }
  }

  bool _isActive(Map<String, dynamic> row, String kind) {
    final active = row['is_active'] ?? row['active'];
    if (active is bool) return active;
    if (active != null) {
      final value = active.toString().toLowerCase();
      if (value == 'true' || value == 'active') return true;
      if (value == 'false' || value == 'inactive') return false;
    }

    final status = row['status']?.toString().trim().toLowerCase();
    if (status == 'active') return true;
    if (status == 'inactive' || status == 'disabled') return false;
    throw FormatException(
      'The $kind configuration does not expose an active status.',
    );
  }

  String? _configurationValue(Map<String, dynamic> row) {
    for (final key in const [
      'value',
      'label',
      'name',
      'configuration_value',
      'display_value',
      'display_name',
      'option_value',
      'title',
    ]) {
      final value = row[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  String _documentPath(String tenantId, int index, String fileName) {
    final safeName = fileName
        .trim()
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final uniquePart = '${_clock().toUtc().microsecondsSinceEpoch}_$index';
    return '${tenantId.trim()}/$uniquePart-${safeName.isEmpty ? 'document' : safeName}';
  }
}
