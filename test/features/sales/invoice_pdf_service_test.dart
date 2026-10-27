import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:avrcrm/features/sales/invoice_pdf_service.dart';

void main() {
  group('InvoicePdfData', () {
    test('maps an invoice with multiple real line items and billing details',
        () {
      final data = InvoicePdfData.fromMaps(
        invoice: {
          'id': 'db-invoice-1',
          'invoice_number': 'INV/2026/0042',
          'status': 'Partially Paid',
          'invoice_date': '2026-09-20',
          'due_date': '2026-10-20',
          'customer_id': 'customer-1',
          'subtotal': 1800,
          'tax': 324,
          'total': 2124,
          'amount_paid': 500,
          'balance': 1624,
          'notes': 'Deliver to the main office.',
          'terms': 'Payment due within 30 days.',
          'invoice_type': 'Tax Invoice',
          'gst_transaction_type': 'Intra-state',
          'supplier_legal_name': 'Example Supplier Pvt Ltd',
          'supplier_gstin': '27AAAAA1111A1Z1',
          'supplier_address': '21 Supplier Road',
          'supplier_state': 'Maharashtra',
          'supplier_pin_code': '411002',
          'supplier_phone': '0201234567',
          'supplier_email': 'billing@supplier.example',
          'shipping_name': 'Solar Works Warehouse',
          'shipping_address': '5 Warehouse Lane',
          'shipping_city': 'Pune',
          'shipping_state': 'Maharashtra',
          'shipping_pin_code': '411002',
          'shipping_country': 'India',
          'subject': 'Supply and installation of solar panels',
          'po_number': 'PO-18',
          'place_of_supply': 'Maharashtra',
          'state_code': '27',
          'payment_mode': 'Bank Transfer',
          'bank_name': 'Example Bank',
          'account_holder': 'Example Supplier Pvt Ltd',
          'account_number': '1234567890',
          'ifsc': 'EXAM0000001',
          'branch': 'Pune',
          'freight': 50,
          'adjustment': -0.25,
          'discount_total': 200,
          'taxable_amount': 1600,
          'cgst': 162,
          'sgst': 162,
          'amount_in_words': 'Two Thousand One Hundred Twenty Four rupees only',
          'items': [
            {
              'product': 'Panel A',
              'hsn_sac': '8541',
              'unit': 'Each',
              'quantity': 2,
              'price': 500,
              'discount': 10,
              'gst': 18,
              'cgst': 81,
              'sgst': 81,
            },
            {
              'description': 'Installation',
              'quantity': 1,
              'rate': 1000,
              'discount_amount': 100,
              'tax_amount': 144,
              'line_total': 1044,
            },
          ],
        },
        customer: {
          'company': 'Solar Works',
          'address': '12 Market Road',
          'city': 'Pune',
          'state': 'Maharashtra',
          'postal_code': '411001',
          'phone': '1234567890',
          'email': 'billing@example.com',
          'gst_number': '27ABCDE1234F1Z5',
        },
      );

      expect(data.id, 'db-invoice-1');
      expect(data.invoiceNumber, 'INV/2026/0042');
      expect(data.status, 'Partially Paid');
      expect(data.invoiceDate, '20 Sep 2026');
      expect(data.dueDate, '20 Oct 2026');
      expect(data.customerName, 'Solar Works');
      expect(data.billingDetails, contains('12 Market Road'));
      expect(data.billingDetails, contains('Pune, Maharashtra, 411001'));
      expect(data.billingDetails, contains('GSTIN: 27ABCDE1234F1Z5'));
      expect(data.items, hasLength(2));
      expect(data.items.first.discount, '10%');
      expect(data.items.first.tax, '18% / CGST INR 81.00 + SGST INR 81.00');
      expect(data.items.first.amount, 1062);
      expect(data.items[1].amount, 1044);
      expect(data.subtotal, 1800);
      expect(data.tax, 324);
      expect(data.total, 2124);
      expect(data.paid, 500);
      expect(data.balance, 1624);
      expect(data.notes, 'Deliver to the main office.');
      expect(data.paymentTerms, 'Payment due within 30 days.');
      expect(data.invoiceType, 'Tax Invoice');
      expect(data.transactionType, 'Intra-state');
      expect(data.supplierName, 'Example Supplier Pvt Ltd');
      expect(data.supplierDetails, contains('GSTIN: 27AAAAA1111A1Z1'));
      expect(data.shippingName, 'Solar Works Warehouse');
      expect(data.shippingDetails, contains('5 Warehouse Lane'));
      expect(data.subject, 'Supply and installation of solar panels');
      expect(data.items.first.hsnSac, '8541');
      expect(data.items.first.unit, 'Each');
      expect(data.cgst, 162);
      expect(data.sgst, 162);
      expect(data.freight, 50);
      expect(data.adjustment, -0.25);
      expect(
          data.amountWords, 'Two Thousand One Hundred Twenty Four rupees only');
      expect(data.paymentMode, 'Bank Transfer');
      expect(data.bankDetails, contains('IFSC: EXAM0000001'));
    });

    test('derives available totals from item quantities, discounts and tax',
        () {
      final data = InvoicePdfData.fromMaps(
        invoice: {
          'id': 'derived-total',
          'items': [
            {
              'product': 'Equipment',
              'quantity': 2,
              'rate': 100,
              'discount_percent': 10,
              'gst_percent': 18,
            },
          ],
        },
      );

      expect(data.subtotal, 180);
      expect(data.tax, 32.4);
      expect(data.total, 212.4);
    });

    test('handles missing optional invoice/customer data and empty items',
        () async {
      final data = InvoicePdfData.fromMaps(
        invoice: {'id': 'db-only-id', 'items': []},
      );

      expect(data.invoiceNumber, 'db-only-id');
      expect(data.customerName, 'Not provided');
      expect(data.billingDetails, isEmpty);
      expect(data.items, isEmpty);
      expect(data.invoiceDate, isEmpty);
      expect(data.total, isNull);
      expect(data.notes, isEmpty);
      expect(data.paymentTerms, isEmpty);
      final bytes = await generateInvoicePdf(data);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });

  test('creates a multipage-capable PDF with multiple line items', () async {
    final items = List.generate(
      80,
      (index) => InvoicePdfItem.fromMap({
        'description': 'Product $index',
        'quantity': 2,
        'price': 125.50,
        'discount_percent': 5,
        'gst_percent': 18,
      }),
    );
    final data = InvoicePdfData.fromMaps(
      invoice: {
        'id': 'invoice-db-id',
        'invoice_number': 'INV-80-ITEMS',
        'items': items
            .map((item) => {
                  'description': item.description,
                  'quantity': item.quantity,
                  'rate': item.rate,
                  'discount_percent': 5,
                  'gst_percent': 18,
                })
            .toList(),
      },
    );

    final bytes = await generateInvoicePdf(data);

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    final pageObjects =
        RegExp(r'/Type\s*/Page\b').allMatches(latin1.decode(bytes)).length;
    expect(pageObjects, greaterThan(1));
  });

  test('sanitizes invoice numbers into safe PDF filenames', () {
    expect(invoicePdfFileName(' INV/2026:0042 '), 'INV-2026-0042.pdf');
    expect(invoicePdfFileName('', 'db/id 7'), 'db-id-7.pdf');
    expect(invoicePdfFileName('', ''), 'invoice.pdf');
  });

  test('save callback receives generated bytes and cancellation is not success',
      () async {
    final data = InvoicePdfData.fromMaps(
      invoice: {
        'id': 'db-42',
        'invoice_number': 'INV-42',
        'items': [
          {'product': 'Item', 'quantity': 1, 'price': 20},
        ],
      },
    );
    Uint8List? savedBytes;
    final fileName = await generateAndSaveInvoicePdf(
      data,
      savePdf: ({required fileName, required bytes}) async {
        expect(fileName, 'INV-42.pdf');
        savedBytes = bytes;
        return 'document-picker-result';
      },
    );

    expect(fileName, 'INV-42.pdf');
    expect(savedBytes, isNotNull);
    expect(String.fromCharCodes(savedBytes!.take(5)), '%PDF-');

    await expectLater(
      generateAndSaveInvoicePdf(
        data,
        savePdf: ({required fileName, required bytes}) async => null,
      ),
      throwsA(isA<InvoicePdfSaveCancelledException>()),
    );
  });
}
