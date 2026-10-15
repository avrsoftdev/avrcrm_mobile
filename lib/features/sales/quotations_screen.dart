import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/auth/auth_provider.dart';
import 'add_quotation_screen.dart';
import 'quotation_model.dart';
import 'quotation_pdf_service.dart';

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});
  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  final _db = Supabase.instance.client;
  final _search = TextEditingController();
  bool _loading = true;
  String? _error;
  String _filter = 'All';
  List<Map<String, dynamic>> _quotes = [];
  final Set<String> _busy = {};
  String? get _tenant => context.read<AuthProvider>().user?.tenantId.trim();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final tenant = _tenant;
      if (tenant == null || tenant.isEmpty)
        throw StateError('Your workspace assignment could not be verified.');
      final rows = await _db
          .from('quotations')
          .select()
          .eq('tenant_id', tenant)
          .order('updated_at', ascending: false);
      if (mounted)
        setState(() {
          _quotes = List<Map<String, dynamic>>.from(rows);
          _loading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _error = e.toString();
          _loading = false;
        });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _quotes.where((row) {
      final hit = q.isEmpty ||
          [
            'id',
            'customer',
            'status'
          ].any((key) => (row[key] ?? '').toString().toLowerCase().contains(q));
      return hit && (_filter == 'All' || row['status'] == _filter);
    }).toList();
  }

  Future<void> _create() async {
    final changed = await Navigator.push<bool>(
        context, MaterialPageRoute(builder: (_) => const AddQuotationScreen()));
    if (changed == true) _load();
  }

  Future<void> _open(Map<String, dynamic> row) async {
    final changed = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) => QuotationDetailsScreen(quotation: row)));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Quotations'), actions: [
        IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh_rounded))
      ]),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'quotations-add-fab',
          onPressed: _create,
          icon: const Icon(Icons.add),
          label: const Text('New quotation')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorView()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                      children: [
                        TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search number or customer',
                                suffixIcon: _search.text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: () {
                                          _search.clear();
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.clear)))),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                            value: _filter,
                            decoration:
                                const InputDecoration(labelText: 'Status'),
                            items: const [
                              'All',
                              'Draft',
                              'Sent',
                              'Viewed',
                              'Accepted',
                              'Rejected',
                              'Expired'
                            ]
                                .map((s) =>
                                    DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _filter = v ?? 'All')),
                        const SizedBox(height: 12),
                        if (_filtered.isEmpty)
                          _emptyView()
                        else
                          ..._filtered.map(_quoteCard),
                      ])));

  Widget _errorView() => Center(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_outlined, size: 42),
            const SizedBox(height: 12),
            const Text('Could not load quotations'),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Retry'))
          ])));
  Widget _emptyView() => Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(children: [
        const Icon(Icons.description_outlined, size: 48),
        const SizedBox(height: 12),
        Text(_quotes.isEmpty ? 'No quotations yet' : 'No matching quotations',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (_quotes.isEmpty)
          FilledButton.icon(
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: const Text('Create quotation'))
      ]));

  Widget _quoteCard(Map<String, dynamic> row) {
    final id = (row['id'] ?? '').toString();
    final amount = (row['total'] as num?)?.toDouble() ?? 0;
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _open(row),
            child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(id,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis)),
                        _statusChip((row['status'] ?? 'Draft').toString())
                      ]),
                      const SizedBox(height: 6),
                      Text(
                          (row['customer'] ?? 'Customer unavailable')
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                            child: Text(
                                'Issued ${row['date'] ?? 'â€”'}  Â·  Expires ${row['valid_until'] ?? 'â€”'}',
                                style: Theme.of(context).textTheme.bodySmall)),
                        Text(
                            NumberFormat.currency(
                                    locale: 'en_IN',
                                    symbol: 'â‚¹',
                                    decimalDigits: 2)
                                .format(amount),
                            style: const TextStyle(fontWeight: FontWeight.w800))
                      ]),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                              onPressed:
                                  _busy.contains(id) ? null : () => _pdf(row),
                              icon: _busy.contains(id)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Icon(Icons.picture_as_pdf_outlined),
                              label: const Text('Save PDF'))),
                    ]))));
  }

  Widget _statusChip(String status) => Chip(
      label: Text(status),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero);
  Future<Map<String, dynamic>?> _customer(Map<String, dynamic> row) async {
    final customerId = (row['customer_id'] ?? '').toString();
    if (customerId.isEmpty || _tenant == null || _tenant!.isEmpty) return null;
    return await _db
        .from('customers')
        .select()
        .eq('id', customerId)
        .eq('tenant_id', _tenant!)
        .maybeSingle();
  }

  Future<void> _pdf(Map<String, dynamic> row) async {
    final id = (row['id'] ?? '').toString();
    setState(() => _busy.add(id));
    try {
      final customer = await _customer(row);
      final name = await saveQuotationPdf(row, customer: customer);
      if (mounted) _message('$name saved successfully.');
    } catch (e) {
      if (mounted) _message('Could not save quotation PDF: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  void _message(String text, {bool error = false}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(text),
          backgroundColor: error ? Colors.red.shade700 : null));
}

class QuotationDetailsScreen extends StatefulWidget {
  const QuotationDetailsScreen({super.key, required this.quotation});
  final Map<String, dynamic> quotation;
  @override
  State<QuotationDetailsScreen> createState() => _QuotationDetailsScreenState();
}

class _QuotationDetailsScreenState extends State<QuotationDetailsScreen> {
  final _db = Supabase.instance.client;
  Map<String, dynamic>? _customer;
  bool _busy = false;
  Map<String, dynamic> get q => widget.quotation;
  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    final id = (q['customer_id'] ?? '').toString();
    final tenant = context.read<AuthProvider>().user?.tenantId.trim();
    if (id.isEmpty || tenant == null || tenant.isEmpty) return;
    try {
      final row = await _db
          .from('customers')
          .select()
          .eq('id', id)
          .eq('tenant_id', tenant)
          .maybeSingle();
      if (mounted) setState(() => _customer = row);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final raw = q['items'];
    final lines = raw is List
        ? raw
            .whereType<Map>()
            .map((m) => QuotationLine.fromMap(Map<String, dynamic>.from(m)))
            .toList()
        : <QuotationLine>[];
    final totals = QuotationTotals.fromLines(lines);
    return Scaffold(
        appBar: AppBar(title: const Text('Quotation'), actions: [
          IconButton(
              tooltip: 'Share PDF',
              onPressed: _busy ? null : _share,
              icon: const Icon(Icons.share_outlined)),
          IconButton(
              tooltip: 'Edit',
              onPressed: () async {
                final changed = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddQuotationScreen(quotation: q)));
                if (changed == true && mounted) Navigator.pop(context, true);
              },
              icon: const Icon(Icons.edit_outlined))
        ]),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('QUOTATION',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2)),
                        const SizedBox(height: 8),
                        Text((q['id'] ?? '').toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text('Status: ${q['status'] ?? 'Draft'}'),
                        Text('Issue date: ${q['date'] ?? 'â€”'}'),
                        Text('Valid until: ${q['valid_until'] ?? 'â€”'}')
                      ]))),
          const SizedBox(height: 12),
          _section('Customer'),
          Card(
              child: ListTile(
                  leading: const Icon(Icons.business_outlined),
                  title: Text((q['customer'] ?? 'Customer details unavailable')
                      .toString()),
                  subtitle: Text(_customer == null
                      ? ((q['customer_id'] == null)
                          ? 'No linked customer record'
                          : 'Linked customer record unavailable')
                      : [
                          _customer!['email'],
                          _customer!['phone'],
                          _customer!['address']
                        ]
                          .where((v) => v != null && v.toString().isNotEmpty)
                          .join('\n')))),
          const SizedBox(height: 16),
          _section('Items (${lines.length})'),
          if (lines.isEmpty)
            const Card(child: ListTile(title: Text('No saved line items'))),
          ...lines.map((line) => Card(
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(line.description,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                            '${line.quantity} Ã— ${line.unitPrice.toStringAsFixed(2)} Â· Discount ${line.discountPercent}% Â· Tax ${line.taxPercent}%'),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(line.total.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)))
                      ])))),
          const SizedBox(height: 8),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    _total('Subtotal', totals.subtotal),
                    _total('Discount', -totals.discount),
                    _total('Tax', totals.tax),
                    const Divider(),
                    _total('Grand total', totals.total, bold: true)
                  ]))),
          if ((q['notes'] ?? '').toString().trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _section('Notes'),
            Text(q['notes'].toString())
          ],
          if ((q['terms'] ?? '').toString().trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _section('Terms and conditions'),
            Text(q['terms'].toString())
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
              onPressed: _busy ? null : _share,
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share quotation PDF')),
        ]));
  }

  Widget _section(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800)));
  Widget _total(String label, double value, {bool bold = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: TextStyle(fontWeight: bold ? FontWeight.bold : null))),
        Text(value.toStringAsFixed(2),
            style: TextStyle(fontWeight: bold ? FontWeight.bold : null))
      ]));
  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final id = (q['customer_id'] ?? '').toString();
      final tenant = context.read<AuthProvider>().user?.tenantId.trim();
      if (id.isNotEmpty && tenant != null && tenant.isNotEmpty)
        _customer = await _db
            .from('customers')
            .select()
            .eq('id', id)
            .eq('tenant_id', tenant)
            .maybeSingle();
      await shareQuotationPdf(q, customer: _customer);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Could not share quotation PDF: $e'),
            backgroundColor: Colors.red.shade700));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
