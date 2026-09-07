import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final List<QuoteModel> _quotes = <QuoteModel>[
    QuoteModel(
      quoteNumber: 'QT-2026-0001',
      customer: 'ABC Solar Pvt. Ltd.',
      date: DateTime(2026, 8, 10),
      validUntil: DateTime(2026, 8, 25),
      amount: 248500,
      status: 'Sent',
      salesperson: 'Aakash',
      customerGst: '07ABCDE1234F1Z5',
      customerPhone: '9876543210',
      customerEmail: 'purchase@abcsolar.com',
      billTo: 'New Delhi, Delhi - 110001',
      shipTo: 'Gurugram, Haryana - 122001',
      paymentTerms: '50% Advance',
      deliveryTerms: 'Ex-Works',
      items: <QuoteItem>[
        QuoteItem(
          product: 'Solar ACDB',
          description: 'Customized ACDB Panel',
          hsn: '8537',
          quantity: 2,
          unit: 'Nos',
          rate: 45000,
          gst: 18,
        ),
        QuoteItem(
          product: 'Solar DCDB',
          description: 'Customized DCDB Panel',
          hsn: '8537',
          quantity: 2,
          unit: 'Nos',
          rate: 40000,
          gst: 18,
        ),
      ],
    ),
    QuoteModel(
      quoteNumber: 'QT-2026-0002',
      customer: 'Green Energy Solutions',
      date: DateTime(2026, 8, 12),
      validUntil: DateTime(2026, 8, 27),
      amount: 125800,
      status: 'Draft',
      salesperson: 'Rahul',
      customerGst: '06GREEN1234A1Z2',
      customerPhone: '9812345678',
      customerEmail: 'purchase@greenenergy.com',
      billTo: 'Noida, Uttar Pradesh - 201301',
      shipTo: 'Noida, Uttar Pradesh - 201301',
      paymentTerms: '30% Advance',
      deliveryTerms: 'FOR Destination',
      items: <QuoteItem>[
        QuoteItem(
          product: 'ACDB Panel',
          description: 'Outdoor ACDB Panel',
          hsn: '8537',
          quantity: 2,
          unit: 'Nos',
          rate: 45000,
          gst: 18,
        ),
      ],
    ),
    QuoteModel(
      quoteNumber: 'QT-2026-0003',
      customer: 'Sun Power EPC',
      date: DateTime(2026, 8, 14),
      validUntil: DateTime(2026, 8, 29),
      amount: 485000,
      status: 'Accepted',
      salesperson: 'Aakash',
      customerGst: '08SUNP1234B1Z8',
      customerPhone: '9823456789',
      customerEmail: 'procurement@sunpower.com',
      billTo: 'Jaipur, Rajasthan - 302001',
      shipTo: 'Jaipur, Rajasthan - 302001',
      paymentTerms: '50% Advance',
      deliveryTerms: 'FOR Destination',
      items: <QuoteItem>[
        QuoteItem(
          product: 'HT Panel',
          description: '11KV HT Panel',
          hsn: '8537',
          quantity: 1,
          unit: 'Set',
          rate: 250000,
          gst: 18,
        ),
        QuoteItem(
          product: 'LT Panel',
          description: 'Main LT Distribution Panel',
          hsn: '8537',
          quantity: 2,
          unit: 'Set',
          rate: 75000,
          gst: 18,
        ),
      ],
    ),
  ];

  String _search = '';
  String _status = 'All';

  List<QuoteModel> get filteredQuotes {
    final String search = _search.trim().toLowerCase();

    return _quotes.where((QuoteModel quote) {
      final bool matchesSearch =
          search.isEmpty ||
          quote.quoteNumber.toLowerCase().contains(search) ||
          quote.customer.toLowerCase().contains(search) ||
          quote.salesperson.toLowerCase().contains(search);

      final bool matchesStatus =
          _status == 'All' || quote.status == _status;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quotations',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createQuote,
        icon: const Icon(Icons.add),
        label: const Text('New Quote'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quotation Management',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create, manage, share and export professional quotations.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildSearchFilter(),
            const SizedBox(height: 24),
            _buildQuoteList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final int total = _quotes.length;
    final int draft =
        _quotes.where((QuoteModel e) => e.status == 'Draft').length;
    final int sent =
        _quotes.where((QuoteModel e) => e.status == 'Sent').length;
    final int accepted =
        _quotes.where((QuoteModel e) => e.status == 'Accepted').length;

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        int columns = 1;

        if (constraints.maxWidth >= 1100) {
          columns = 4;
        } else if (constraints.maxWidth >= 650) {
          columns = 2;
        }

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.3,
          children: [
            _SummaryCard(
              title: 'Total Quotes',
              value: '$total',
              icon: Icons.description_outlined,
              color: Colors.blue,
            ),
            _SummaryCard(
              title: 'Draft',
              value: '$draft',
              icon: Icons.edit_document,
              color: Colors.orange,
            ),
            _SummaryCard(
              title: 'Sent',
              value: '$sent',
              icon: Icons.send_outlined,
              color: Colors.indigo,
            ),
            _SummaryCard(
              title: 'Accepted',
              value: '$accepted',
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchFilter() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            if (constraints.maxWidth < 650) {
              return Column(
                children: [
                  _searchField(),
                  const SizedBox(height: 12),
                  _statusDropdown(),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _searchField(),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: _statusDropdown(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: (String value) {
        setState(() {
          _search = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search quote number or customer...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _status,
      decoration: InputDecoration(
        labelText: 'Status',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'All',
          child: Text('All Status'),
        ),
        DropdownMenuItem(
          value: 'Draft',
          child: Text('Draft'),
        ),
        DropdownMenuItem(
          value: 'Sent',
          child: Text('Sent'),
        ),
        DropdownMenuItem(
          value: 'Accepted',
          child: Text('Accepted'),
        ),
        DropdownMenuItem(
          value: 'Rejected',
          child: Text('Rejected'),
        ),
        DropdownMenuItem(
          value: 'Expired',
          child: Text('Expired'),
        ),
      ],
      onChanged: (String? value) {
        if (value == null) return;

        setState(() {
          _status = value;
        });
      },
    );
  }

  Widget _buildQuoteList() {
    if (filteredQuotes.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 52,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
                const SizedBox(height: 14),
                const Text(
                  'No quotations found.',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Try changing your search or status filter.',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Quotations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ...filteredQuotes.map(
              (QuoteModel quote) => _quoteTile(quote),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quoteTile(QuoteModel quote) {
    final Color color = _statusColor(quote.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          if (constraints.maxWidth < 650) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _quoteMainInfo(quote, color),
                const SizedBox(height: 14),
                _quoteActions(quote),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _quoteMainInfo(
                  quote,
                  color,
                ),
              ),
              _quoteActions(quote),
            ],
          );
        },
      ),
    );
  }

  Widget _quoteMainInfo(
    QuoteModel quote,
    Color statusColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              quote.quoteNumber,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quote.status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          quote.customer,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 18,
          runSpacing: 6,
          children: [
            _smallInfo(
              Icons.calendar_today_outlined,
              DateFormat('dd MMM yyyy').format(
                quote.date,
              ),
            ),
            _smallInfo(
              Icons.event_available_outlined,
              'Valid: ${DateFormat('dd MMM yyyy').format(quote.validUntil)}',
            ),
            _smallInfo(
              Icons.person_outline,
              quote.salesperson,
            ),
          ],
        ),
      ],
    );
  }

  Widget _smallInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _quoteActions(QuoteModel quote) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _currency(quote.amount),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'View',
          onPressed: () => _viewQuote(quote),
          icon: const Icon(
            Icons.visibility_outlined,
          ),
        ),
        IconButton(
          tooltip: 'Export PDF',
          onPressed: () => _exportQuotePdf(quote),
          icon: const Icon(
            Icons.picture_as_pdf_outlined,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (String value) {
            if (value == 'edit') {
              _editQuote(quote);
            } else if (value == 'delete') {
              _deleteQuote(quote);
            }
          },
          itemBuilder: (
            BuildContext context,
          ) =>
              const [
            PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                ),
                title: Text('Edit'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(
                  Icons.delete_outline,
                ),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _deleteQuote(
    QuoteModel quote,
  ) async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: const Text('Delete Quotation'),
          content: Text(
            'Delete ${quote.quoteNumber} for ${quote.customer}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _quotes.remove(quote);
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Sent':
        return Colors.indigo;
      case 'Draft':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      case 'Expired':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _currency(double value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(value);
  }

  void _createQuote() {
    Navigator.push<QuoteModel>(
      context,
      MaterialPageRoute<QuoteModel>(
        builder: (_) => const QuoteFormScreen(),
      ),
    ).then((QuoteModel? result) {
      if (result == null) return;

      setState(() {
        _quotes.insert(0, result);
      });
    });
  }

  void _editQuote(QuoteModel quote) {
    Navigator.push<QuoteModel>(
      context,
      MaterialPageRoute<QuoteModel>(
        builder: (_) => QuoteFormScreen(
          existingQuote: quote,
        ),
      ),
    ).then((QuoteModel? result) {
      if (result == null) return;

      final int index = _quotes.indexOf(quote);

      if (index == -1) return;

      setState(() {
        _quotes[index] = result;
      });
    });
  }

  void _viewQuote(QuoteModel quote) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => QuoteDetailsScreen(
          quote: quote,
        ),
      ),
    );
  }

  Future<void> _exportQuotePdf(
    QuoteModel quote,
  ) async {
    try {
      await generateQuotePdf(quote);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to generate PDF: $e',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ============================================================================
// QUOTE FORM
// ============================================================================

class QuoteFormScreen extends StatefulWidget {
  final QuoteModel? existingQuote;

  const QuoteFormScreen({
    super.key,
    this.existingQuote,
  });

  @override
  State<QuoteFormScreen> createState() =>
      _QuoteFormScreenState();
}

class _QuoteFormScreenState
    extends State<QuoteFormScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      customerController;

  late final TextEditingController
      customerGstController;

  late final TextEditingController
      customerPhoneController;

  late final TextEditingController
      customerEmailController;

  late final TextEditingController
      billAddressController;

  late final TextEditingController
      shipAddressController;

  late final TextEditingController
      salespersonController;

  late final TextEditingController
      notesController;

  late final TextEditingController
      termsController;

  late DateTime quoteDate;
  late DateTime validUntil;

  late String paymentTerms;
  late String deliveryTerms;
  late String status;

  late List<QuoteItem> items;

  @override
  void initState() {
    super.initState();

    final QuoteModel? quote =
        widget.existingQuote;

    customerController =
        TextEditingController(
      text: quote?.customer ??
          'ABC Solar Pvt. Ltd.',
    );

    customerGstController =
        TextEditingController(
      text: quote?.customerGst ??
          '07ABCDE1234F1Z5',
    );

    customerPhoneController =
        TextEditingController(
      text: quote?.customerPhone ??
          '9876543210',
    );

    customerEmailController =
        TextEditingController(
      text: quote?.customerEmail ??
          'purchase@abcsolar.com',
    );

    billAddressController =
        TextEditingController(
      text: quote?.billTo ??
          'New Delhi, Delhi - 110001',
    );

    shipAddressController =
        TextEditingController(
      text: quote?.shipTo ??
          'Gurugram, Haryana - 122001',
    );

    salespersonController =
        TextEditingController(
      text: quote?.salesperson ?? 'Aakash',
    );

    notesController =
        TextEditingController(
      text: quote?.notes ?? '',
    );

    termsController =
        TextEditingController(
      text: quote?.terms ??
          'Payment terms as mutually agreed. Prices are subject to applicable taxes.',
    );

    quoteDate =
        quote?.date ?? DateTime.now();

    validUntil =
        quote?.validUntil ??
            DateTime.now().add(
              const Duration(days: 15),
            );

    paymentTerms =
        quote?.paymentTerms ??
            '50% Advance';

    deliveryTerms =
        quote?.deliveryTerms ??
            'Ex-Works';

    status =
        quote?.status ?? 'Draft';

    items = quote?.items
            .map(
              (QuoteItem item) =>
                  item.copy(),
            )
            .toList() ??
        <QuoteItem>[
          QuoteItem(
            product: 'Solar ACDB',
            description:
                'Customized ACDB Panel',
            hsn: '8537',
            quantity: 2,
            unit: 'Nos',
            rate: 45000,
            gst: 18,
          ),
        ];
  }

  double get subtotal {
    return items.fold(
      0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.taxableAmount,
    );
  }

  double get totalDiscount {
    return items.fold(
      0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.discountAmount,
    );
  }

  double get totalGst {
    return items.fold(
      0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.gstAmount,
    );
  }

  double get grandTotal {
    return subtotal + totalGst;
  }

  @override
  void dispose() {
    customerController.dispose();
    customerGstController.dispose();
    customerPhoneController.dispose();
    customerEmailController.dispose();
    billAddressController.dispose();
    shipAddressController.dispose();
    salespersonController.dispose();
    notesController.dispose();
    termsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingQuote == null
              ? 'Create Quotation'
              : 'Edit Quotation',
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveQuote,
            icon: const Icon(
              Icons.save_outlined,
            ),
            label: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _quoteHeaderSection(),
              const SizedBox(height: 18),
              _customerSection(),
              const SizedBox(height: 18),
              _addressSection(),
              const SizedBox(height: 18),
              _productsSection(),
              const SizedBox(height: 18),
              _commercialSection(),
              const SizedBox(height: 18),
              _notesSection(),
              const SizedBox(height: 18),
              _totalsSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _quoteHeaderSection() {
    return _card(
      title: 'Quotation Details',
      icon: Icons.description_outlined,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final List<Widget> fields = [
            _field(
              'Quote Number',
              widget.existingQuote?.quoteNumber ??
                  _newQuoteNumber(),
              Icons.tag,
            ),
            _dateField(
              'Quote Date',
              quoteDate,
              (DateTime date) {
                setState(() {
                  quoteDate = date;
                });
              },
            ),
            _dateField(
              'Valid Until',
              validUntil,
              (DateTime date) {
                setState(() {
                  validUntil = date;
                });
              },
            ),
            _dropdown(
              'Status',
              status,
              const [
                'Draft',
                'Sent',
                'Accepted',
                'Rejected',
                'Expired',
              ],
              (String? value) {
                if (value == null) return;

                setState(() {
                  status = value;
                });
              },
            ),
          ];

          if (constraints.maxWidth < 700) {
            return Column(
              children: fields
                  .map(
                    (Widget field) =>
                        Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: field,
                    ),
                  )
                  .toList(),
            );
          }

          return Row(
            children: fields
                .map(
                  (Widget field) =>
                      Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 12,
                      ),
                      child: field,
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _customerSection() {
    return _card(
      title: 'Customer Details',
      icon: Icons.business_outlined,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final List<Widget> children = [
            _controllerField(
              'Customer / Company Name',
              customerController,
              Icons.business,
              required: true,
            ),
            _controllerField(
              'GSTIN',
              customerGstController,
              Icons.receipt_long,
            ),
            _controllerField(
              'Phone',
              customerPhoneController,
              Icons.phone,
            ),
            _controllerField(
              'Email',
              customerEmailController,
              Icons.email_outlined,
            ),
          ];

          if (constraints.maxWidth < 700) {
            return Column(
              children: children
                  .map(
                    (Widget child) =>
                        Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: child,
                    ),
                  )
                  .toList(),
            );
          }

          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 4.2,
            children: children,
          );
        },
      ),
    );
  }

  Widget _addressSection() {
    return _card(
      title: 'Billing & Shipping',
      icon: Icons.local_shipping_outlined,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          if (constraints.maxWidth < 700) {
            return Column(
              children: [
                _controllerField(
                  'Bill To',
                  billAddressController,
                  Icons.receipt_long_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                _controllerField(
                  'Ship To',
                  shipAddressController,
                  Icons.location_on_outlined,
                  maxLines: 3,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _controllerField(
                  'Bill To',
                  billAddressController,
                  Icons.receipt_long_outlined,
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _controllerField(
                  'Ship To',
                  shipAddressController,
                  Icons.location_on_outlined,
                  maxLines: 3,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _productsSection() {
    return _card(
      title: 'Products & Services',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _addProduct,
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Product',
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.all(30),
              child: Text(
                'No products added.',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: DataTable(
                columnSpacing: 24,
                columns: const [
                  DataColumn(
                    label: Text('#'),
                  ),
                  DataColumn(
                    label: Text('Product'),
                  ),
                  DataColumn(
                    label: Text('Description'),
                  ),
                  DataColumn(
                    label: Text('HSN/SAC'),
                  ),
                  DataColumn(
                    label: Text('Qty'),
                  ),
                  DataColumn(
                    label: Text('Unit'),
                  ),
                  DataColumn(
                    label: Text('Rate'),
                  ),
                  DataColumn(
                    label: Text('Discount'),
                  ),
                  DataColumn(
                    label: Text('GST'),
                  ),
                  DataColumn(
                    label: Text('Amount'),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: List<DataRow>.generate(
                  items.length,
                  (int index) {
                    final QuoteItem item =
                        items[index];

                    return DataRow(
                      cells: [
                        DataCell(
                          Text('${index + 1}'),
                        ),
                        DataCell(
                          SizedBox(
                            width: 160,
                            child: Text(
                              item.product,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Text(
                              item.description,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(item.hsn),
                        ),
                        DataCell(
                          Text(
                            '${item.quantity}',
                          ),
                        ),
                        DataCell(
                          Text(item.unit),
                        ),
                        DataCell(
                          Text(
                            _currency(
                              item.rate,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.discount}%',
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.gst}%',
                          ),
                        ),
                        DataCell(
                          Text(
                            _currency(
                              item.totalAmount,
                            ),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            tooltip:
                                'Remove',
                            onPressed: () {
                              setState(() {
                                items.removeAt(
                                  index,
                                );
                              });
                            },
                            icon:
                                const Icon(
                              Icons
                                  .delete_outline,
                              color:
                                  Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _commercialSection() {
    return _card(
      title: 'Commercial Terms',
      icon: Icons.account_balance_wallet_outlined,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final List<Widget> fields = [
            _controllerField(
              'Salesperson',
              salespersonController,
              Icons.person_outline,
            ),
            _dropdown(
              'Payment Terms',
              paymentTerms,
              const [
                '100% Advance',
                '50% Advance',
                '30% Advance',
                'Against Delivery',
                'Credit - 30 Days',
                'Credit - 45 Days',
              ],
              (String? value) {
                if (value == null) return;

                setState(() {
                  paymentTerms = value;
                });
              },
            ),
            _dropdown(
              'Delivery Terms',
              deliveryTerms,
              const [
                'Ex-Works',
                'FOR Destination',
                'FOB',
                'CIF',
              ],
              (String? value) {
                if (value == null) return;

                setState(() {
                  deliveryTerms = value;
                });
              },
            ),
          ];

          if (constraints.maxWidth < 700) {
            return Column(
              children: fields
                  .map(
                    (Widget field) =>
                        Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 14,
                      ),
                      child: field,
                    ),
                  )
                  .toList(),
            );
          }

          return Row(
            children: fields
                .map(
                  (Widget field) =>
                      Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(
                        right: 12,
                      ),
                      child: field,
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _notesSection() {
    return _card(
      title: 'Notes & Terms',
      icon: Icons.notes_outlined,
      child: Column(
        children: [
          _controllerField(
            'Notes',
            notesController,
            Icons.note_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 14),
          _controllerField(
            'Terms & Conditions',
            termsController,
            Icons.gavel_outlined,
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _totalsSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 420,
        child: _card(
          title: 'Quotation Summary',
          icon: Icons.calculate_outlined,
          child: Column(
            children: [
              _totalRow(
                'Subtotal',
                subtotal,
              ),
              _totalRow(
                'Discount',
                totalDiscount,
              ),
              _totalRow(
                'GST',
                totalGst,
              ),
              const Divider(height: 28),
              _totalRow(
                'Grand Total',
                grandTotal,
                bold: true,
                large: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalRow(
    String label,
    double value, {
    bool bold = false,
    bool large = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold
                    ? FontWeight.w800
                    : FontWeight.w500,
                fontSize: large ? 17 : 14,
              ),
            ),
          ),
          Text(
            _currency(value),
            style: TextStyle(
              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w600,
              fontSize: large ? 19 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    String value,
    IconData icon,
  ) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _controllerField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: required
          ? (String? value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return '$label is required';
              }

              return null;
            }
          : null,
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> values,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: values
          .map(
            (String item) =>
                DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _dateField(
    String label,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: DateFormat(
          'dd MMM yyyy',
        ).format(date),
      ),
      decoration: const InputDecoration(
        labelText: 'Date',
        prefixIcon: Icon(
          Icons.calendar_today_outlined,
        ),
      ).copyWith(
        labelText: label,
      ),
      onTap: () async {
        final DateTime? selected =
            await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDate: date,
        );

        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }

  void _addProduct() {
    setState(() {
      items.add(
        QuoteItem(
          product: 'New Product',
          description: '',
          hsn: '',
          quantity: 1,
          unit: 'Nos',
          rate: 0,
          gst: 18,
        ),
      );
    });
  }

  void _saveQuote() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please add at least one product.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final QuoteModel quote =
        QuoteModel(
      quoteNumber:
          widget.existingQuote?.quoteNumber ??
              _newQuoteNumber(),
      customer:
          customerController.text.trim(),
      date: quoteDate,
      validUntil: validUntil,
      amount: grandTotal,
      status: status,
      salesperson:
          salespersonController.text.trim(),
      items: items,
      billTo:
          billAddressController.text.trim(),
      shipTo:
          shipAddressController.text.trim(),
      customerGst:
          customerGstController.text.trim(),
      customerPhone:
          customerPhoneController.text.trim(),
      customerEmail:
          customerEmailController.text.trim(),
      paymentTerms: paymentTerms,
      deliveryTerms: deliveryTerms,
      notes: notesController.text.trim(),
      terms: termsController.text.trim(),
    );

    Navigator.pop(
      context,
      quote,
    );
  }

  String _newQuoteNumber() {
    final DateTime now = DateTime.now();

    return 'QT-${now.year}-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  String _currency(double value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(value);
  }
}

// ============================================================================
// QUOTE DETAILS
// ============================================================================

class QuoteDetailsScreen
    extends StatelessWidget {
  final QuoteModel quote;

  const QuoteDetailsScreen({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          quote.quoteNumber,
        ),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            onPressed: () {
              generateQuotePdf(quote);
            },
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 18),
            _customer(context),
            const SizedBox(height: 18),
            _products(context),
            const SizedBox(height: 18),
            _summary(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  Widget _header(BuildContext context) {
    return _card(
      LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final Widget content =
              Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'QUOTATION',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                quote.quoteNumber,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                quote.customer,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

          final Widget button =
              FilledButton.icon(
            onPressed: () {
              generateQuotePdf(quote);
            },
            icon: const Icon(
              Icons.picture_as_pdf,
            ),
            label: const Text(
              'Export PDF',
            ),
          );

          if (constraints.maxWidth < 550) {
            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                content,
                const SizedBox(height: 18),
                button,
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: content,
              ),
              button,
            ],
          );
        },
      ),
    );
  }

  Widget _customer(BuildContext context) {
    return _card(
      Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer & Delivery',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 30,
            runSpacing: 20,
            children: [
              _info(
                'Customer',
                quote.customer,
              ),
              _info(
                'GSTIN',
                quote.customerGst,
              ),
              _info(
                'Phone',
                quote.customerPhone,
              ),
              _info(
                'Email',
                quote.customerEmail,
              ),
              _info(
                'Bill To',
                quote.billTo,
              ),
              _info(
                'Ship To',
                quote.shipTo,
              ),
              _info(
                'Payment Terms',
                quote.paymentTerms,
              ),
              _info(
                'Delivery Terms',
                quote.deliveryTerms,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(
    String title,
    String value,
  ) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _products(BuildContext context) {
    return _card(
      Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Products',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          if (quote.items.isEmpty)
            const Text(
              'No products.',
            )
          else
            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text('#'),
                  ),
                  DataColumn(
                    label: Text('Product'),
                  ),
                  DataColumn(
                    label: Text('HSN'),
                  ),
                  DataColumn(
                    label: Text('Qty'),
                  ),
                  DataColumn(
                    label: Text('Rate'),
                  ),
                  DataColumn(
                    label: Text('GST'),
                  ),
                  DataColumn(
                    label: Text('Amount'),
                  ),
                ],
                rows: List<DataRow>.generate(
                  quote.items.length,
                  (int index) {
                    final QuoteItem item =
                        quote.items[index];

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '${index + 1}',
                          ),
                        ),
                        DataCell(
                          Text(
                            item.product,
                          ),
                        ),
                        DataCell(
                          Text(item.hsn),
                        ),
                        DataCell(
                          Text(
                            '${item.quantity} ${item.unit}',
                          ),
                        ),
                        DataCell(
                          Text(
                            _currency(
                              item.rate,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${item.gst}%',
                          ),
                        ),
                        DataCell(
                          Text(
                            _currency(
                              item.totalAmount,
                            ),
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _summary(BuildContext context) {
    final double subtotal =
        quote.items.fold(
      0.0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.taxableAmount,
    );

    final double discount =
        quote.items.fold(
      0.0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.discountAmount,
    );

    final double gst =
        quote.items.fold(
      0.0,
      (
        double sum,
        QuoteItem item,
      ) =>
          sum + item.gstAmount,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 400,
        child: _card(
          Column(
            children: [
              _row(
                'Subtotal',
                subtotal,
              ),
              _row(
                'Discount',
                discount,
              ),
              _row(
                'GST',
                gst,
              ),
              const Divider(),
              _row(
                'Grand Total',
                quote.amount,
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(
    String label,
    double value, {
    bool bold = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
          ),
          Text(
            _currency(value),
            style: TextStyle(
              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _currency(double value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(value);
  }
}

// ============================================================================
// MODELS
// ============================================================================

class QuoteModel {
  final String quoteNumber;
  final String customer;
  final DateTime date;
  final DateTime validUntil;
  final double amount;
  final String status;
  final String salesperson;

  final List<QuoteItem> items;

  final String billTo;
  final String shipTo;
  final String customerGst;
  final String customerPhone;
  final String customerEmail;
  final String paymentTerms;
  final String deliveryTerms;
  final String notes;
  final String terms;

  QuoteModel({
    required this.quoteNumber,
    required this.customer,
    required this.date,
    required this.validUntil,
    required this.amount,
    required this.status,
    required this.salesperson,
    this.items = const <QuoteItem>[],
    this.billTo = '',
    this.shipTo = '',
    this.customerGst = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.paymentTerms = '',
    this.deliveryTerms = '',
    this.notes = '',
    this.terms = '',
  });
}

class QuoteItem {
  String product;
  String description;
  String hsn;
  double quantity;
  String unit;
  double rate;
  double discount;
  double gst;

  QuoteItem({
    required this.product,
    required this.description,
    required this.hsn,
    required this.quantity,
    required this.unit,
    required this.rate,
    required this.gst,
    this.discount = 0,
  });

  double get grossAmount =>
      quantity * rate;

  double get discountAmount =>
      grossAmount * discount / 100;

  double get taxableAmount =>
      grossAmount - discountAmount;

  double get gstAmount =>
      taxableAmount * gst / 100;

  double get totalAmount =>
      taxableAmount + gstAmount;

  QuoteItem copy() {
    return QuoteItem(
      product: product,
      description: description,
      hsn: hsn,
      quantity: quantity,
      unit: unit,
      rate: rate,
      discount: discount,
      gst: gst,
    );
  }
}

// ============================================================================
// PDF GENERATION
// ============================================================================

Future<void> generateQuotePdf(
  QuoteModel quote,
) async {
  final pw.Document pdf =
      pw.Document();

  final NumberFormat currency =
      NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  final double subtotal =
      quote.items.fold(
    0.0,
    (
      double sum,
      QuoteItem item,
    ) =>
        sum + item.taxableAmount,
  );

  final double discount =
      quote.items.fold(
    0.0,
    (
      double sum,
      QuoteItem item,
    ) =>
        sum + item.discountAmount,
  );

  final double gst =
      quote.items.fold(
    0.0,
    (
      double sum,
      QuoteItem item,
    ) =>
        sum + item.gstAmount,
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin:
          const pw.EdgeInsets.all(32),
      build: (
        pw.Context context,
      ) {
        return [
          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment
                    .spaceBetween,
            crossAxisAlignment:
                pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment
                        .start,
                children: [
                  pw.Text(
                    'AVRCRM',
                    style:
                        pw.TextStyle(
                      fontSize: 25,
                      fontWeight:
                          pw.FontWeight
                              .bold,
                    ),
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Text(
                    'Professional Business Management',
                    style:
                        const pw.TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment
                        .end,
                children: [
                  pw.Text(
                    'QUOTATION',
                    style:
                        pw.TextStyle(
                      fontSize: 20,
                      fontWeight:
                          pw.FontWeight
                              .bold,
                    ),
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Text(
                    quote.quoteNumber,
                  ),
                  pw.Text(
                    DateFormat(
                      'dd MMM yyyy',
                    ).format(
                      quote.date,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Divider(),
          pw.SizedBox(
            height: 20,
          ),
          pw.Row(
            crossAxisAlignment:
                pw.CrossAxisAlignment
                    .start,
            children: [
              pw.Expanded(
                child:
                    _pdfInfoBlock(
                  'BILL TO',
                  [
                    quote.customer,
                    if (quote.customerGst
                        .isNotEmpty)
                      'GSTIN: ${quote.customerGst}',
                    if (quote.customerPhone
                        .isNotEmpty)
                      quote.customerPhone,
                    if (quote.customerEmail
                        .isNotEmpty)
                      quote.customerEmail,
                    if (quote.billTo
                        .isNotEmpty)
                      quote.billTo,
                  ],
                ),
              ),
              pw.SizedBox(
                width: 30,
              ),
              pw.Expanded(
                child:
                    _pdfInfoBlock(
                  'SHIP TO',
                  [
                    quote.customer,
                    if (quote.shipTo
                        .isNotEmpty)
                      quote.shipTo,
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(
            height: 25,
          ),
          pw.Table.fromTextArray(
            border:
                pw.TableBorder.all(
              color:
                  PdfColors.grey400,
            ),
            headerDecoration:
                const pw.BoxDecoration(
              color:
                  PdfColors.grey200,
            ),
            headerStyle:
                pw.TextStyle(
              fontWeight:
                  pw.FontWeight.bold,
              fontSize: 8,
            ),
            cellStyle:
                const pw.TextStyle(
              fontSize: 8,
            ),
            cellAlignment:
                pw.Alignment.centerLeft,
            headers: const [
              '#',
              'Product',
              'HSN',
              'Qty',
              'Rate',
              'Discount',
              'GST',
              'Amount',
            ],
            data: List<
                List<String>>.generate(
              quote.items.length,
              (int index) {
                final QuoteItem item =
                    quote.items[index];

                return [
                  '${index + 1}',
                  item.product,
                  item.hsn,
                  '${item.quantity} ${item.unit}',
                  currency.format(
                    item.rate,
                  ),
                  '${item.discount}%',
                  '${item.gst}%',
                  currency.format(
                    item.totalAmount,
                  ),
                ];
              },
            ),
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Align(
            alignment:
                pw.Alignment.centerRight,
            child: pw.SizedBox(
              width: 230,
              child: pw.Column(
                children: [
                  _pdfTotal(
                    'Subtotal',
                    currency.format(
                      subtotal,
                    ),
                  ),
                  _pdfTotal(
                    'Discount',
                    currency.format(
                      discount,
                    ),
                  ),
                  _pdfTotal(
                    'GST',
                    currency.format(
                      gst,
                    ),
                  ),
                  pw.Divider(),
                  _pdfTotal(
                    'Grand Total',
                    currency.format(
                      quote.amount,
                    ),
                    bold: true,
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(
            height: 25,
          ),
          _pdfInfoBlock(
            'COMMERCIAL TERMS',
            [
              'Payment Terms: ${quote.paymentTerms}',
              'Delivery Terms: ${quote.deliveryTerms}',
              'Salesperson: ${quote.salesperson}',
              'Valid Until: ${DateFormat('dd MMM yyyy').format(quote.validUntil)}',
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          _pdfInfoBlock(
            'NOTES',
            [
              quote.notes.isEmpty
                  ? '-'
                  : quote.notes,
            ],
          ),
          pw.SizedBox(
            height: 15,
          ),
          _pdfInfoBlock(
            'TERMS & CONDITIONS',
            [
              quote.terms.isEmpty
                  ? '-'
                  : quote.terms,
            ],
          ),
          pw.SizedBox(
            height: 30,
          ),
          pw.Divider(),
          pw.SizedBox(
            height: 10,
          ),
          pw.Center(
            child: pw.Text(
              'Thank you for your business.',
              style:
                  pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),
          ),
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (
      PdfPageFormat format,
    ) async {
      return pdf.save();
    },
  );
}

pw.Widget _pdfInfoBlock(
  String title,
  List<String> values,
) {
  return pw.Column(
    crossAxisAlignment:
        pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight:
              pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(
        height: 7,
      ),
      ...values.map(
        (String value) =>
            pw.Padding(
          padding:
              const pw.EdgeInsets.only(
            bottom: 3,
          ),
          child: pw.Text(
            value,
            style:
                const pw.TextStyle(
              fontSize: 9,
            ),
          ),
        ),
      ),
    ],
  );
}

pw.Widget _pdfTotal(
  String label,
  String value, {
  bool bold = false,
}) {
  return pw.Padding(
    padding:
        const pw.EdgeInsets.symmetric(
      vertical: 4,
    ),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Text(
            label,
            style: bold
                ? pw.TextStyle(
                    fontWeight:
                        pw.FontWeight
                            .bold,
                  )
                : null,
          ),
        ),
        pw.Text(
          value,
          style: bold
              ? pw.TextStyle(
                  fontWeight:
                      pw.FontWeight.bold,
                )
              : null,
        ),
      ],
    ),
  );
}

// ============================================================================
// SUMMARY CARD
// ============================================================================

class _SummaryCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}