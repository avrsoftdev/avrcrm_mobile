import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/utils/formatters.dart';
import 'add_invoice_screen.dart';
import 'invoice_pdf_service.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _invoices = [];
  final Set<String> _downloadingInvoiceIds = {};

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tenantId = context.read<AuthProvider>().user?.tenantId.trim();
      if (tenantId == null || tenantId.isEmpty) {
        throw StateError('Your workspace assignment could not be verified.');
      }
      final rows = await _supabase
          .from('invoices')
          .select()
          .eq('tenant_id', tenantId)
          .order('updated_at', ascending: false);

      if (!mounted) return;

      setState(() {
        _invoices = List<Map<String, dynamic>>.from(rows);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _openAddInvoice() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AddInvoiceScreen()),
    );

    if (created == true) {
      await _loadInvoices();
    }
  }

  Future<void> _downloadInvoice(String invoiceId) async {
    if (invoiceId.isEmpty || _downloadingInvoiceIds.contains(invoiceId)) return;
    final tenantId = context.read<AuthProvider>().user?.tenantId.trim();
    if (tenantId == null || tenantId.isEmpty) {
      _showDownloadMessage('Your workspace assignment could not be verified.',
          error: true);
      return;
    }

    setState(() => _downloadingInvoiceIds.add(invoiceId));
    try {
      final fileName = await InvoicePdfService().downloadInvoice(
        invoiceId: invoiceId,
        tenantId: tenantId,
      );
      if (!mounted) return;
      _showDownloadMessage('$fileName saved successfully.');
    } on InvoicePdfSaveCancelledException {
      if (!mounted) return;
      _showDownloadMessage('Saving the invoice PDF was cancelled.');
    } catch (error) {
      if (!mounted) return;
      _showDownloadMessage('Could not save invoice PDF: $error', error: true);
    } finally {
      if (mounted) setState(() => _downloadingInvoiceIds.remove(invoiceId));
    }
  }

  void _showDownloadMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? Colors.red.shade700 : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadInvoices,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'invoices-add-fab',
        onPressed: _openAddInvoice,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Could not load invoices',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadInvoices,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'No invoices found',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openAddInvoice,
              child: const Text('Create your first invoice'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInvoices,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: _invoices.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final inv = _invoices[i];
          final id = (inv['id'] ?? '').toString();
          final invoiceNumber =
              (inv['invoice_number'] ?? inv['id'] ?? '').toString();
          final customer = (inv['customer'] ?? '').toString();
          final status = (inv['status'] ?? '').toString();
          final dueDate = (inv['due_date'] ?? '').toString();
          final date = (inv['date'] ?? inv['invoice_date'] ?? '').toString();
          final total = (inv['total'] as num?)?.toDouble() ??
              (inv['amount'] as num?)?.toDouble() ??
              0;

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        invoiceNumber,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (status.isNotEmpty) StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  customer.isEmpty ? '—' : customer,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      Formatters.inr(total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      dueDate.isNotEmpty
                          ? 'Due: $dueDate'
                          : (date.isNotEmpty ? date : ''),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: id.isEmpty || _downloadingInvoiceIds.contains(id)
                        ? null
                        : () => _downloadInvoice(id),
                    icon: _downloadingInvoiceIds.contains(id)
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.picture_as_pdf_outlined, size: 18),
                    label: Text(
                      _downloadingInvoiceIds.contains(id)
                          ? 'Preparing PDF…'
                          : 'Download e-Invoice PDF',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
