import '../backend/app_backend.dart';

class DashboardSummary {
  final int contacts;
  final int leads;
  final int deals;
  final int quotes;
  final int orders;
  final int invoices;
  final int campaigns;

  final double quoteValue;
  final double orderValue;
  final double outstanding;

  const DashboardSummary({
    required this.contacts,
    required this.leads,
    required this.deals,
    required this.quotes,
    required this.orders,
    required this.invoices,
    required this.campaigns,
    required this.quoteValue,
    required this.orderValue,
    required this.outstanding,
  });
}

class DashboardRepository {
  DashboardRepository._();

  static final DashboardRepository instance =
      DashboardRepository._();

  final AppBackend _backend =
      AppBackend.instance;

  Future<DashboardSummary> load() async {
    final contacts =
        await _backend.getAll('contacts');

    final leads =
        await _backend.getAll('leads');

    final deals =
        await _backend.getAll('deals');

    final quotes =
        await _backend.getAll('quotes');

    final orders =
        await _backend.getAll('orders');

    final invoices =
        await _backend.getAll('invoices');

    final campaigns =
        await _backend.getAll('campaigns');

    double sum(
      String field,
      List<Map<String, dynamic>> rows,
    ) {
      return rows.fold<double>(
        0,
        (total, row) {
          final value = row[field];

          return total +
              (value is num
                  ? value.toDouble()
                  : double.tryParse(
                        '$value',
                      ) ??
                      0);
        },
      );
    }

    double outstanding = 0;

    for (final row in invoices) {
      final total =
          row['total'] is num
              ? (row['total'] as num).toDouble()
              : 0;

      final paid =
          row['paid_amount'] is num
              ? (row['paid_amount'] as num)
                  .toDouble()
              : 0;

      outstanding +=
          (total - paid)
              .clamp(0, double.infinity);
    }

    return DashboardSummary(
      contacts: contacts.length,
      leads: leads.length,
      deals: deals.length,
      quotes: quotes.length,
      orders: orders.length,
      invoices: invoices.length,
      campaigns: campaigns.length,
      quoteValue: sum(
        'amount',
        quotes,
      ),
      orderValue: sum(
        'amount',
        orders,
      ),
      outstanding: outstanding,
    );
  }
}