import 'package:flutter/material.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final List<Map<String, dynamic>> invoices = [];

  String selectedStatus = 'All';

  final List<String> statuses = [
    'All',
    'Draft',
    'Sent',
    'Partially Paid',
    'Paid',
    'Overdue',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.receipt_long_rounded),
            SizedBox(width: 10),
            Text(
              'Invoices',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Export',
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const InvoiceFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
      ),

      body: Column(
        children: [
          _buildSummaryCards(context),

          const SizedBox(height: 12),

          _buildFilterBar(context),

          const SizedBox(height: 8),

          Expanded(
            child: invoices.isEmpty
                ? _buildEmptyState(context)
                : _buildInvoiceList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        scrollDirection: Axis.horizontal,
        children: [
          _summaryCard(
            context,
            'Total Invoices',
            '0',
            Icons.receipt_long,
          ),
          _summaryCard(
            context,
            'Total Amount',
            '₹0.00',
            Icons.currency_rupee,
          ),
          _summaryCard(
            context,
            'Paid',
            '₹0.00',
            Icons.check_circle_outline,
          ),
          _summaryCard(
            context,
            'Outstanding',
            '₹0.00',
            Icons.pending_actions,
          ),
          _summaryCard(
            context,
            'Overdue',
            '₹0.00',
            Icons.warning_amber_rounded,
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final status = statuses[index];
          final selected = selectedStatus == status;

          return ChoiceChip(
            label: Text(status),
            selected: selected,
            onSelected: (_) {
              setState(() {
                selectedStatus = status;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: theme.colorScheme.primary.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 20),
            Text(
              'No invoices yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first GST invoice and manage billing, '
              'payments, shipping and e-way bills from AVRCRM.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 25),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InvoiceFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: invoices.length,
      itemBuilder: (_, index) {
        final invoice = invoices[index];

        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.receipt_long),
            ),
            title: Text(invoice['invoiceNumber'] ?? ''),
            subtitle: Text(invoice['customer'] ?? ''),
            trailing: Text(
              '₹${invoice['amount'] ?? '0'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}


// ============================================================
// INVOICE FORM
// ============================================================

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final invoiceNumberController =
      TextEditingController(text: 'INV-0001');

  final referenceController = TextEditingController();

  final supplierNameController = TextEditingController();
  final supplierGstinController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierStateController = TextEditingController();
  final supplierPincodeController = TextEditingController();

  final billNameController = TextEditingController();
  final billGstinController = TextEditingController();
  final billAddressController = TextEditingController();
  final billStateController = TextEditingController();
  final billPincodeController = TextEditingController();
  final billPhoneController = TextEditingController();
  final billEmailController = TextEditingController();

  final shipNameController = TextEditingController();
  final shipGstinController = TextEditingController();
  final shipAddressController = TextEditingController();
  final shipStateController = TextEditingController();
  final shipPincodeController = TextEditingController();
  final shipPhoneController = TextEditingController();

  final ewayController = TextEditingController();
  final transporterController = TextEditingController();
  final vehicleController = TextEditingController();
  final lrNumberController = TextEditingController();

  final notesController = TextEditingController();
  final termsController = TextEditingController();

  String invoiceType = 'Tax Invoice';
  String paymentTerms = 'Due on Receipt';
  String placeOfSupply = 'Delhi';
  String paymentMode = 'Bank Transfer';

  DateTime invoiceDate = DateTime.now();
  DateTime? dueDate;

  final List<InvoiceItem> items = [
    InvoiceItem(),
  ];

  @override
  void dispose() {
    invoiceNumberController.dispose();
    referenceController.dispose();
    supplierNameController.dispose();
    supplierGstinController.dispose();
    supplierAddressController.dispose();
    supplierStateController.dispose();
    supplierPincodeController.dispose();
    billNameController.dispose();
    billGstinController.dispose();
    billAddressController.dispose();
    billStateController.dispose();
    billPincodeController.dispose();
    billPhoneController.dispose();
    billEmailController.dispose();
    shipNameController.dispose();
    shipGstinController.dispose();
    shipAddressController.dispose();
    shipStateController.dispose();
    shipPincodeController.dispose();
    shipPhoneController.dispose();
    ewayController.dispose();
    transporterController.dispose();
    vehicleController.dispose();
    lrNumberController.dispose();
    notesController.dispose();
    termsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Invoice',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: _saveDraft,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Draft'),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _saveInvoice,
            icon: const Icon(Icons.check),
            label: const Text('Create Invoice'),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1200,
              ),
              child: Column(
                children: [
                  _section(
                    context,
                    'Invoice Information',
                    Icons.receipt_long,
                    _invoiceInformation(),
                  ),

                  _section(
                    context,
                    'Supplier / Company Details',
                    Icons.business,
                    _supplierDetails(),
                  ),

                  _section(
                    context,
                    'Bill To',
                    Icons.person_outline,
                    _billToDetails(),
                  ),

                  _section(
                    context,
                    'Ship To',
                    Icons.local_shipping_outlined,
                    _shipToDetails(),
                  ),

                  _section(
                    context,
                    'Products / Services',
                    Icons.inventory_2_outlined,
                    _productsSection(),
                  ),

                  _section(
                    context,
                    'Shipping & Transport',
                    Icons.local_shipping,
                    _shippingSection(),
                  ),

                  _section(
                    context,
                    'E-Way Bill',
                    Icons.confirmation_number_outlined,
                    _ewayBillSection(),
                  ),

                  _section(
                    context,
                    'Payment Information',
                    Icons.account_balance_wallet_outlined,
                    _paymentSection(),
                  ),

                  _section(
                    context,
                    'Notes & Terms',
                    Icons.notes,
                    _notesSection(),
                  ),

                  _invoiceTotal(),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _saveInvoice,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Create Invoice'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(
    BuildContext context,
    String title,
    IconData icon,
    Widget child,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }

  Widget _invoiceInformation() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _field(
          'Invoice Number',
          invoiceNumberController,
          width: 280,
          required: true,
        ),
        _field(
          'Reference / PO Number',
          referenceController,
          width: 280,
        ),
        _dropdown(
          'Invoice Type',
          invoiceType,
          [
            'Tax Invoice',
            'Bill of Supply',
            'Debit Note',
            'Credit Note',
            'Proforma Invoice',
          ],
          (value) => setState(() => invoiceType = value!),
        ),
        _dropdown(
          'Payment Terms',
          paymentTerms,
          [
            'Due on Receipt',
            '7 Days',
            '15 Days',
            '30 Days',
            '45 Days',
            '60 Days',
            '90 Days',
          ],
          (value) => setState(() => paymentTerms = value!),
        ),
        _dropdown(
          'Place of Supply',
          placeOfSupply,
          [
            'Delhi',
            'Uttar Pradesh',
            'Haryana',
            'Rajasthan',
            'Maharashtra',
            'Gujarat',
            'Other',
          ],
          (value) => setState(() => placeOfSupply = value!),
        ),
        _dateField(
          'Invoice Date',
          invoiceDate,
          (date) => setState(() => invoiceDate = date),
        ),
        _dateField(
          'Due Date',
          dueDate,
          (date) => setState(() => dueDate = date),
        ),
      ],
    );
  }

  Widget _supplierDetails() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _field(
          'Company / Legal Name',
          supplierNameController,
          width: 380,
          required: true,
        ),
        _field(
          'GSTIN',
          supplierGstinController,
          width: 280,
        ),
        _field(
          'State',
          supplierStateController,
          width: 240,
        ),
        _field(
          'PIN Code',
          supplierPincodeController,
          width: 200,
        ),
        _field(
          'Registered Address',
          supplierAddressController,
          width: 650,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _billToDetails() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _field(
          'Customer / Company Name',
          billNameController,
          width: 380,
          required: true,
        ),
        _field(
          'GSTIN',
          billGstinController,
          width: 280,
        ),
        _field(
          'Mobile Number',
          billPhoneController,
          width: 240,
        ),
        _field(
          'Email',
          billEmailController,
          width: 300,
        ),
        _field(
          'State',
          billStateController,
          width: 240,
        ),
        _field(
          'PIN Code',
          billPincodeController,
          width: 180,
        ),
        _field(
          'Billing Address',
          billAddressController,
          width: 650,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _shipToDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Shipping address same as Billing address'),
          value: false,
          onChanged: (_) {},
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _field(
              'Ship To Name',
              shipNameController,
              width: 380,
            ),
            _field(
              'GSTIN',
              shipGstinController,
              width: 280,
            ),
            _field(
              'Mobile',
              shipPhoneController,
              width: 240,
            ),
            _field(
              'State',
              shipStateController,
              width: 240,
            ),
            _field(
              'PIN Code',
              shipPincodeController,
              width: 180,
            ),
            _field(
              'Shipping Address',
              shipAddressController,
              width: 650,
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _productsSection() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 22,
            columns: const [
              DataColumn(label: Text('Product / Service')),
              DataColumn(label: Text('HSN / SAC')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Unit')),
              DataColumn(label: Text('Rate')),
              DataColumn(label: Text('Discount %')),
              DataColumn(label: Text('GST %')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('')),
            ],
            rows: List.generate(
              items.length,
              (index) => DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Product',
                        ),
                        onChanged: (value) {
                          items[index].product = value;
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'HSN/SAC',
                        ),
                        onChanged: (value) {
                          items[index].hsn = value;
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '1',
                        ),
                        onChanged: (value) {
                          items[index].quantity =
                              double.tryParse(value) ?? 1;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Nos',
                        ),
                        onChanged: (value) {
                          items[index].unit = value;
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0.00',
                        ),
                        onChanged: (value) {
                          items[index].rate =
                              double.tryParse(value) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                        ),
                        onChanged: (value) {
                          items[index].discount =
                              double.tryParse(value) ?? 0;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '18',
                        ),
                        onChanged: (value) {
                          items[index].gst =
                              double.tryParse(value) ?? 18;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '₹${items[index].amount.toStringAsFixed(2)}',
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: items.length == 1
                          ? null
                          : () {
                              setState(() {
                                items.removeAt(index);
                              });
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                items.add(InvoiceItem());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Product / Service'),
          ),
        ),
      ],
    );
  }

  Widget _shippingSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _field(
          'Transporter Name',
          transporterController,
          width: 300,
        ),
        _field(
          'Vehicle Number',
          vehicleController,
          width: 220,
        ),
        _field(
          'LR / GR Number',
          lrNumberController,
          width: 220,
        ),
      ],
    );
  }

  Widget _ewayBillSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _field(
          'E-Way Bill Number',
          ewayController,
          width: 300,
        ),
        _dateField(
          'E-Way Bill Date',
          null,
          (_) {},
        ),
        _dropdown(
          'E-Way Bill Status',
          'Not Generated',
          [
            'Not Generated',
            'Generated',
            'Cancelled',
            'Expired',
          ],
          (_) {},
        ),
      ],
    );
  }

  Widget _paymentSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _dropdown(
          'Payment Mode',
          paymentMode,
          [
            'Bank Transfer',
            'UPI',
            'Cash',
            'Cheque',
            'Card',
            'Other',
          ],
          (value) => setState(() => paymentMode = value!),
        ),
        _field(
          'Bank Name',
          TextEditingController(),
          width: 260,
        ),
        _field(
          'Account Number',
          TextEditingController(),
          width: 260,
        ),
        _field(
          'IFSC Code',
          TextEditingController(),
          width: 200,
        ),
      ],
    );
  }

  Widget _notesSection() {
    return Column(
      children: [
        _field(
          'Notes',
          notesController,
          width: double.infinity,
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _field(
          'Terms & Conditions',
          termsController,
          width: double.infinity,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _invoiceTotal() {
    double subtotal = 0;
    double gst = 0;

    for (final item in items) {
      subtotal += item.amount;
      gst += item.gstAmount;
    }

    final total = subtotal + gst;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          children: [
            _totalRow('Subtotal', subtotal),
            _totalRow('GST', gst),
            const Divider(height: 25),
            _totalRow(
              'Grand Total',
              total,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(
    String label,
    double value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight:
                  bold ? FontWeight.w900 : FontWeight.w600,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    double width = 260,
    int maxLines = 1,
    bool required = false,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> values,
    ValueChanged<String?> onChanged,
  ) {
    return SizedBox(
      width: 260,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: values
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _dateField(
    String label,
    DateTime? value,
    ValueChanged<DateTime> onChanged,
  ) {
    return SizedBox(
      width: 240,
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            initialDate: value ?? DateTime.now(),
          );

          if (date != null) {
            onChanged(date);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(
            value == null
                ? 'Select Date'
                : '${value.day}/${value.month}/${value.year}',
          ),
        ),
      ),
    );
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice saved as draft'),
      ),
    );
  }

  void _saveInvoice() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice created successfully'),
      ),
    );
  }
}


// ============================================================
// INVOICE ITEM MODEL
// ============================================================

class InvoiceItem {
  String product = '';
  String hsn = '';
  String unit = 'Nos';

  double quantity = 1;
  double rate = 0;
  double discount = 0;
  double gst = 18;

  double get grossAmount => quantity * rate;

  double get discountAmount =>
      grossAmount * discount / 100;

  double get amount =>
      grossAmount - discountAmount;

  double get gstAmount =>
      amount * gst / 100;
}