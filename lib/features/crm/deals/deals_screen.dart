import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'deal_form_screen.dart';
import 'deal_details_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedStage = 'All';
  String searchText = '';

  final List<String> stages = [
    'All',
    'New Opportunity',
    'Qualification',
    'Requirement',
    'Quotation',
    'Negotiation',
    'Purchase Order',
    'Won',
    'Lost',
  ];

  final List<String> priorities = [
    'Low',
    'Medium',
    'High',
    'Critical',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deals & Opportunities',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
          IconButton(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _showFilters,
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDealForm(),
        icon: const Icon(Icons.add),
        label: const Text('New Deal'),
      ),

      body: Column(
        children: [
          _buildSummaryCards(isDark),

          _buildPipeline(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search deals, customers, contacts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchText = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('deals')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Unable to load deals.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final docs = snapshot.data?.docs ?? [];

                final deals = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final title =
                      (data['dealName'] ?? '').toString().toLowerCase();
                  final customer =
                      (data['company'] ?? '').toString().toLowerCase();
                  final contact =
                      (data['contactPerson'] ?? '').toString().toLowerCase();

                  final stage = data['stage'] ?? 'New Opportunity';

                  final matchesSearch = searchText.isEmpty ||
                      title.contains(searchText) ||
                      customer.contains(searchText) ||
                      contact.contains(searchText);

                  final matchesStage =
                      selectedStage == 'All' || stage == selectedStage;

                  return matchesSearch && matchesStage;
                }).toList();

                if (deals.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    final doc = deals[index];

                    return _DealCard(
                      id: doc.id,
                      data: doc.data() as Map<String, dynamic>,
                      onTap: () => _openDealDetails(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(bool isDark) {
    return SizedBox(
      height: 118,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        children: const [
          _SummaryCard(
            title: 'Total Pipeline',
            value: '₹0',
            subtitle: 'All active deals',
            icon: Icons.trending_up,
          ),
          _SummaryCard(
            title: 'Open Deals',
            value: '0',
            subtitle: 'Active opportunities',
            icon: Icons.work_outline,
          ),
          _SummaryCard(
            title: 'Won',
            value: '₹0',
            subtitle: 'Closed business',
            icon: Icons.check_circle_outline,
          ),
          _SummaryCard(
            title: 'Weighted Value',
            value: '₹0',
            subtitle: 'Probability adjusted',
            icon: Icons.analytics_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildPipeline() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          final stage = stages[index];
          final selected = selectedStage == stage;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(stage),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  selectedStage = stage;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.handshake_outlined,
            size: 70,
            color: Theme.of(context).colorScheme.primary.withOpacity(.35),
          ),
          const SizedBox(height: 16),
          const Text(
            'No deals found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first opportunity to start tracking sales.',
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _openDealForm(),
            icon: const Icon(Icons.add),
            label: const Text('Create Deal'),
          ),
        ],
      ),
    );
  }

  void _openDealForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DealFormScreen(),
      ),
    );
  }

  void _openDealDetails(
    String id,
    Map<String, dynamic> data,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DealDetailsScreen(
          dealId: id,
          data: data,
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deal Filters',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedStage,
                decoration: const InputDecoration(
                  labelText: 'Deal Stage',
                  border: OutlineInputBorder(),
                ),
                items: stages
                    .map(
                      (stage) => DropdownMenuItem(
                        value: stage,
                        child: Text(stage),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedStage = value;
                    });
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: color.withOpacity(.12),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 5),
            color: Colors.black.withOpacity(.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _DealCard({
    required this.id,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final dealName = data['dealName'] ?? 'Untitled Deal';
    final company = data['company'] ?? 'No Company';
    final contact = data['contactPerson'] ?? 'No Contact';
    final stage = data['stage'] ?? 'New Opportunity';
    final priority = data['priority'] ?? 'Medium';
    final owner = data['salesOwner'] ?? 'Unassigned';
    final value = data['finalValue'] ?? data['estimatedValue'] ?? 0;
    final probability = data['probability'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: primary.withOpacity(.10),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: primary.withOpacity(.10),
                    child: Icon(
                      Icons.handshake_outlined,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dealName.toString(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          company.toString(),
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _PriorityBadge(priority.toString()),
                  PopupMenuButton<String>(
                    onSelected: (value) {},
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: Text('Duplicate'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.person_outline,
                    label: contact.toString(),
                  ),
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label: stage.toString(),
                  ),
                  _InfoChip(
                    icon: Icons.person_pin_outlined,
                    label: owner.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      title: 'Deal Value',
                      value: '₹${_formatValue(value)}',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      title: 'Probability',
                      value: '$probability%',
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      title: 'Weighted',
                      value:
                          '₹${_formatValue((value is num ? value : 0) * ((probability is num ? probability : 0) / 100))}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: ((probability is num ? probability : 0) / 100)
                      .clamp(0.0, 1.0),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(0);
    }

    return value.toString();
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge(this.priority);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary.withOpacity(.08),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.45),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 2),
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String title;
  final String value;

  const _Metric({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}