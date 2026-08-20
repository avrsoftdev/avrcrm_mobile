import 'package:flutter/material.dart';
class DealDetailsScreen extends StatelessWidget {
  final String dealId;
  final Map<String, dynamic> data;

  const DealDetailsScreen({
    super.key,
    required this.dealId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deal Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['dealName'] ?? 'Untitled Deal',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    data['company'] ?? '',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _detail(
                          'Deal Value',
                          '₹${data['estimatedValue'] ?? 0}',
                        ),
                      ),
                      Expanded(
                        child: _detail(
                          'Probability',
                          '${data['probability'] ?? 0}%',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          _detailsSection(
            context,
            'Customer Information',
            [
              _row('Company', data['company']),
              _row('Contact Person', data['contactPerson']),
              _row('Designation', data['designation']),
              _row('Mobile', data['mobile']),
              _row('Email', data['email']),
            ],
          ),

          _detailsSection(
            context,
            'Deal Information',
            [
              _row('Stage', data['stage']),
              _row('Source', data['source']),
              _row('Sales Owner', data['salesOwner']),
              _row('Priority', data['priority']),
              _row('Product', data['product']),
              _row('Quantity', data['quantity']),
            ],
          ),

          _detailsSection(
            context,
            'Commercial Information',
            [
              _row('Estimated Value', data['estimatedValue']),
              _row('Quotation No.', data['quotationNo']),
              _row('Quotation Value', data['quotationValue']),
              _row('Discount', data['discount']),
              _row('Payment Terms', data['paymentTerms']),
              _row('Delivery', data['deliveryTimeline']),
              _row('Competitor', data['competitor']),
            ],
          ),

          _detailsSection(
            context,
            'Requirements & Notes',
            [
              _row(
                'Requirements',
                data['requirements'],
              ),
              _row(
                'Internal Notes',
                data['notes'],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _detailsSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true
                  ? value.toString()
                  : '-',
            ),
          ),
        ],
      ),
    );
  }
}