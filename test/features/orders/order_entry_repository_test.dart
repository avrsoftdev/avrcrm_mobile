import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/features/orders/order_draft.dart';
import 'package:avrcrm/features/orders/order_entry_repository.dart';

void main() {
  group('OrderEntryRepository', () {
    test('loads only active configuration values in configured order',
        () async {
      final backend = _FakeOrderEntryBackend()
        ..configurations['stage'] = [
          {'label': 'In Production', 'is_active': true, 'sort_order': 2},
          {'label': 'Draft', 'is_active': true, 'sort_order': 1},
          {'label': 'Archived', 'is_active': false, 'sort_order': 0},
        ];
      final repository = OrderEntryRepository(backend: backend);

      expect(
        await repository.loadActiveOptions('stage'),
        ['Draft', 'In Production'],
      );
    });

    test('inserts the order using the orders schema, identity and upload paths',
        () async {
      final backend = _FakeOrderEntryBackend();
      final repository = OrderEntryRepository(
        backend: backend,
        clock: () => DateTime.utc(2026, 10, 19, 4, 32),
      );

      await repository.submit(
        draft: _validDraft(),
        tenantId: 'tenant-123',
        userId: 'user-456',
        piDocument: _file('pi.pdf'),
        bomQuotationDocument: _file('bom.xlsx'),
        drawingDocument: _file('drawing.dwg'),
      );

      expect(backend.insertedPayload, isNotNull);
      final payload = backend.insertedPayload!;
      expect(payload['pi_number'], 'PI-123');
      expect(payload['stage'], 'Confirmed');
      expect(payload['wip'], 'Ready');
      expect(payload['order_date'], '2026-10-19');
      expect(payload['tenant_id'], 'tenant-123');
      expect(payload['created_by'], 'user-456');
      expect(payload['created_at'], '2026-10-19T04:32:00.000Z');
      expect(payload['advance_received'], 2500.0);
      expect(payload['basic_order_value'], 10000.0);
      expect(payload['order_value_with_gst'], 11800.0);
      expect(payload['pi_upload_path'], startsWith('tenant-123/'));
      expect(payload['bom_quotation_upload_path'], startsWith('tenant-123/'));
      expect(payload['drawing_upload_path'], startsWith('tenant-123/'));
      expect(backend.uploadedFiles, hasLength(3));
      expect(backend.removedPaths, isEmpty);
    });

    test('cleans uploaded documents and reports the insert failure', () async {
      final backend = _FakeOrderEntryBackend()
        ..insertError = StateError('RLS denied order insert');
      final repository = OrderEntryRepository(
        backend: backend,
        clock: () => DateTime.utc(2026, 10, 19),
      );

      await expectLater(
        repository.submit(
          draft: _validDraft(),
          tenantId: 'tenant-123',
          userId: 'user-456',
          piDocument: _file('pi.pdf'),
        ),
        throwsA(isA<StateError>()),
      );

      expect(backend.insertedPayload, isNotNull);
      expect(backend.uploadedFiles, hasLength(1));
      expect(backend.removedPaths, backend.uploadedFiles.keys);
    });

    test('rejects missing identity before uploading or inserting', () async {
      final backend = _FakeOrderEntryBackend();
      final repository = OrderEntryRepository(backend: backend);

      await expectLater(
        repository.submit(
          draft: _validDraft(),
          tenantId: '',
          userId: 'user-456',
          piDocument: _file('pi.pdf'),
        ),
        throwsA(isA<StateError>()),
      );

      expect(backend.uploadedFiles, isEmpty);
      expect(backend.insertedPayload, isNull);
    });
  });
}

OrderDraft _validDraft() => const OrderDraft(
      piNumber: 'PI-123',
      stage: 'Confirmed',
      wip: 'Ready',
      orderDate: '2026-10-19',
      companyName: 'Example Company',
      projectName: 'Solar Project',
      projectTitle: 'North Site',
      deliveryAddress: '42 Example Road',
      clientName: 'Example Client',
      clientContactNumber: '+911234567890',
      customerEmailId: 'client@example.com',
      advanceReceived: 2500,
      basicOrderValue: 10000,
      orderValueWithGst: 11800,
    );

OrderAttachment _file(String name) => OrderAttachment(
      name: name,
      bytes: Uint8List.fromList([1, 2, 3]),
    );

class _FakeOrderEntryBackend implements OrderEntryBackend {
  final Map<String, List<Map<String, dynamic>>> configurations = {};
  final Map<String, OrderAttachment> uploadedFiles = {};
  List<String> removedPaths = [];
  Map<String, dynamic>? insertedPayload;
  Object? insertError;

  @override
  Future<List<Map<String, dynamic>>> fetchOrderConfigurations(
    String kind,
  ) async =>
      configurations[kind] ?? const [];

  @override
  Future<void> uploadOrderDocument(String path, OrderAttachment file) async {
    uploadedFiles[path] = file;
  }

  @override
  Future<void> insertOrder(Map<String, dynamic> payload) async {
    insertedPayload = Map<String, dynamic>.from(payload);
    final error = insertError;
    if (error != null) throw error;
  }

  @override
  Future<void> removeOrderDocuments(List<String> paths) async {
    removedPaths = List<String>.from(paths);
  }
}
