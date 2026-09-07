import 'package:flutter/material.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final List<Map<String, dynamic>> _payments = [
    {
      'reference': 'PAY-2026-0012',
      'customer': 'ABC Solar Pvt. Ltd.',
      'invoice': 'INV-2026-0045',
      'amount': 125000.0,
      'mode': 'NEFT',
      'status': 'Received',
      'date': '17 Aug 2026',
      'utr': 'HDFC2026081700123',
    },
    {
      'reference': 'PAY-2026-0011',
      'customer': 'XYZ Engineering',
      'invoice': 'INV-2026-0038',
      'amount': 75000.0,
      'mode': 'RTGS',
      'status': 'Received',
      'date': '15 Aug 2026',
      'utr': 'SBIN2026081500789',
    },
    {
      'reference': 'PAY-2026-0010',
      'customer': 'Green Energy Solutions',
      'invoice': 'INV-2026-0031',
      'amount': 42000.0,
      'mode': 'UPI',
      'status': 'Pending Reconciliation',
      'date': '14 Aug 2026',
      'utr': 'UPI-458921',
    },
  ];

  final Color primaryBlue = const Color(0xFF1565C0);
  final Color darkBlue = const Color(0xFF0D47A1);

  String _search = '';
  String _statusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredPayments = _payments.where((payment) {
      final query = _search.toLowerCase();

      final matchesSearch =
          payment['reference'].toString().toLowerCase().contains(query) ||
          payment['customer'].toString().toLowerCase().contains(query) ||
          payment['invoice'].toString().toLowerCase().contains(query) ||
          payment['utr'].toString().toLowerCase().contains(query);

      final matchesStatus =
          _statusFilter == 'All' ||
          payment['status'].toString() == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Export',
            onPressed: () {
              _showMessage('Export functionality will be connected to CSV/Excel.');
            },
            icon: const Icon(Icons.download_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCards(isDark),
          _buildToolbar(isDark),
          Expanded(
            child: filteredPayments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: filteredPayments.length,
                    itemBuilder: (context, index) {
                      return _buildPaymentCard(
                        filteredPayments[index],
                        isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PaymentFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Record Payment'),
      ),
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return SizedBox(
      height: 145,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        children: [
          _summaryCard(
            'Total Received',
            '₹2,42,000',
            Icons.account_balance_wallet_outlined,
            const Color(0xFF1565C0),
            isDark,
          ),
          _summaryCard(
            'This Month',
            '₹1,84,500',
            Icons.calendar_month_outlined,
            const Color(0xFF00897B),
            isDark,
          ),
          _summaryCard(
            'Pending',
            '₹68,500',
            Icons.pending_actions_outlined,
            const Color(0xFFEF6C00),
            isDark,
          ),
          _summaryCard(
            'TDS Deducted',
            '₹12,400',
            Icons.receipt_long_outlined,
            const Color(0xFF6A1B9A),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18202B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search payment, customer, invoice or UTR...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF18202B)
                    : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            initialValue: _statusFilter,
            onSelected: (value) {
              setState(() {
                _statusFilter = value;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'All', child: Text('All Payments')),
              PopupMenuItem(value: 'Received', child: Text('Received')),
              PopupMenuItem(
                value: 'Pending Reconciliation',
                child: Text('Pending Reconciliation'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  const SizedBox(width: 8),
                  Text(_statusFilter),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    Map<String, dynamic> payment,
    bool isDark,
  ) {
    final status = payment['status'].toString();

    final statusColor = status == 'Received'
        ? Colors.green
        : Colors.orange;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentDetailsScreen(payment: payment),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryBlue.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.payments_outlined,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment['reference'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          payment['customer'],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${payment['amount'].toStringAsFixed(0)}',
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.withValues(alpha: 0.15),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  _infoItem(
                    Icons.receipt_long_outlined,
                    'Invoice',
                    payment['invoice'],
                  ),
                  _infoItem(
                    Icons.calendar_today_outlined,
                    'Date',
                    payment['date'],
                  ),
                  _infoItem(
                    Icons.account_balance_outlined,
                    'Mode',
                    payment['mode'],
                  ),
                  _infoItem(
                    Icons.numbers_outlined,
                    'UTR',
                    payment['utr'],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentDetailsScreen(payment: payment),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    label: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: primaryBlue,
        ),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payments_outlined,
            size: 70,
            color: primaryBlue.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'No payments found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try changing your search or filter.',
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


// ============================================================
// PAYMENT FORM
// ============================================================

class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _referenceController = TextEditingController();
  final _customerController = TextEditingController();
  final _invoiceController = TextEditingController();
  final _amountController = TextEditingController();
  final _tdsController = TextEditingController();
  final _utrController = TextEditingController();
  final _bankController = TextEditingController();
  final _chequeController = TextEditingController();
  final _branchController = TextEditingController();
  final _notesController = TextEditingController();
  final _remarksController = TextEditingController();

  String _paymentMode = 'NEFT';
  String _status = 'Received';
  String _currency = 'INR';
  DateTime _paymentDate = DateTime.now();

  final Color primaryBlue = const Color(0xFF1565C0);

  @override
  void dispose() {
    _referenceController.dispose();
    _customerController.dispose();
    _invoiceController.dispose();
    _amountController.dispose();
    _tdsController.dispose();
    _utrController.dispose();
    _bankController.dispose();
    _chequeController.dispose();
    _branchController.dispose();
    _notesController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Record Payment',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: _savePayment,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Payment'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    'Payment Information',
                    'Basic payment and customer details',
                    Icons.payments_outlined,
                  ),
                  _card(
                    child: Column(
                      children: [
                        _responsiveFields([
                          _field(
                            'Payment / Receipt Number',
                            _referenceController,
                            required: true,
                            icon: Icons.tag,
                          ),
                          _field(
                            'Customer / Company',
                            _customerController,
                            required: true,
                            icon: Icons.business_outlined,
                          ),
                          _field(
                            'Invoice Number',
                            _invoiceController,
                            icon: Icons.receipt_long_outlined,
                          ),
                          _field(
                            'Amount Received',
                            _amountController,
                            required: true,
                            keyboardType: TextInputType.number,
                            icon: Icons.currency_rupee,
                          ),
                        ]),
                        const SizedBox(height: 18),
                        _responsiveFields([
                          _dateField(),
                          _dropdownField(
                            'Payment Mode',
                            _paymentMode,
                            [
                              'Cash',
                              'UPI',
                              'NEFT',
                              'RTGS',
                              'IMPS',
                              'Cheque',
                              'Card',
                              'Bank Transfer',
                            ],
                            (value) {
                              setState(() {
                                _paymentMode = value!;
                              });
                            },
                          ),
                          _dropdownField(
                            'Currency',
                            _currency,
                            ['INR', 'USD', 'EUR', 'GBP'],
                            (value) {
                              setState(() {
                                _currency = value!;
                              });
                            },
                          ),
                          _dropdownField(
                            'Payment Status',
                            _status,
                            [
                              'Received',
                              'Pending',
                              'Partially Received',
                              'Pending Reconciliation',
                              'Refunded',
                              'Cancelled',
                            ],
                            (value) {
                              setState(() {
                                _status = value!;
                              });
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    'Bank & Transaction Details',
                    'Transaction, bank and cheque information',
                    Icons.account_balance_outlined,
                  ),
                  _card(
                    child: Column(
                      children: [
                        _responsiveFields([
                          _field(
                            'UTR / Transaction ID',
                            _utrController,
                            icon: Icons.numbers_outlined,
                          ),
                          _field(
                            'Bank Name',
                            _bankController,
                            icon: Icons.account_balance_outlined,
                          ),
                          _field(
                            'Branch',
                            _branchController,
                            icon: Icons.location_on_outlined,
                          ),
                          _field(
                            'Cheque Number',
                            _chequeController,
                            icon: Icons.receipt_outlined,
                          ),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    'Tax & Adjustment',
                    'TDS and other payment adjustments',
                    Icons.account_balance_wallet_outlined,
                  ),
                  _card(
                    child: _responsiveFields([
                      _field(
                        'TDS Deduction',
                        _tdsController,
                        keyboardType: TextInputType.number,
                        icon: Icons.percent,
                      ),
                      _field(
                        'TDS Certificate Number',
                        TextEditingController(),
                        icon: Icons.description_outlined,
                      ),
                      _field(
                        'Adjustment Amount',
                        TextEditingController(),
                        keyboardType: TextInputType.number,
                        icon: Icons.remove_circle_outline,
                      ),
                      _field(
                        'Outstanding Amount',
                        TextEditingController(),
                        keyboardType: TextInputType.number,
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ]),
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    'Notes & Internal Remarks',
                    'Additional information for accounts and sales teams',
                    Icons.notes_outlined,
                  ),
                  _card(
                    child: Column(
                      children: [
                        _multilineField(
                          'Payment Notes',
                          _notesController,
                          3,
                        ),
                        const SizedBox(height: 18),
                        _multilineField(
                          'Internal Remarks',
                          _remarksController,
                          3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  _card(
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: primaryBlue,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Proof / Receipt',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Upload bank receipt, cheque image or payment confirmation.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primaryBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _responsiveFields(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 800 ? 2 : 1;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: fields.map((field) {
            return SizedBox(
              width: columns == 2
                  ? (constraints.maxWidth - 18) / 2
                  : constraints.maxWidth,
              child: field,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
        prefixIcon: icon == null ? null : Icon(icon),
      ),
    );
  }

  Widget _multilineField(
    String label,
    TextEditingController controller,
    int maxLines,
  ) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _dateField() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDate: _paymentDate,
        );

        if (picked != null) {
          setState(() {
            _paymentDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Payment Date',
          prefixIcon: Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          '${_paymentDate.day.toString().padLeft(2, '0')}/'
          '${_paymentDate.month.toString().padLeft(2, '0')}/'
          '${_paymentDate.year}',
        ),
      ),
    );
  }

  void _savePayment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment saved. Firestore integration can now be connected.',
        ),
      ),
    );

    Navigator.pop(context);
  }
}


// ============================================================
// PAYMENT DETAILS
// ============================================================

class PaymentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> payment;

  const PaymentDetailsScreen({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF1565C0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          payment['reference'] ?? 'Payment Details',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Print',
            onPressed: () {},
            icon: const Icon(Icons.print_outlined),
          ),
          IconButton(
            tooltip: 'More',
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryBlue.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.payments_outlined,
                            size: 32,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                payment['reference'] ?? '',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(payment['customer'] ?? ''),
                            ],
                          ),
                        ),
                        Text(
                          '₹${payment['amount']}',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _detailsSection(
                  context,
                  'Payment Information',
                  [
                    ['Payment Number', payment['reference']],
                    ['Customer', payment['customer']],
                    ['Invoice', payment['invoice']],
                    ['Payment Date', payment['date']],
                    ['Payment Mode', payment['mode']],
                    ['Amount', '₹${payment['amount']}'],
                    ['Status', payment['status']],
                  ],
                ),
                const SizedBox(height: 20),
                _detailsSection(
                  context,
                  'Transaction Details',
                  [
                    ['UTR / Transaction ID', payment['utr']],
                    ['Bank Name', 'HDFC Bank'],
                    ['Branch', 'New Delhi'],
                    ['Currency', 'INR'],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsSection(
    BuildContext context,
    String title,
    List<List<String>> values,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            ...values.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item[0],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        item[1],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}