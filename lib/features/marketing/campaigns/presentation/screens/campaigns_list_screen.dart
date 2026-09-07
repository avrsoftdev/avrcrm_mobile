import 'package:flutter/material.dart';

class CampaignsListScreen extends StatefulWidget {
  const CampaignsListScreen({super.key});

  @override
  State<CampaignsListScreen> createState() => _CampaignsListScreenState();
}

class _CampaignsListScreenState extends State<CampaignsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All';
  String _selectedType = 'All';
  bool _isGridView = true;

  final List<CampaignModel> _campaigns = [
    CampaignModel(
      id: 'CMP-001',
      name: 'August Hiring Drive',
      description:
          'Recruitment campaign targeting freshers and experienced candidates.',
      type: 'Recruitment',
      channel: 'WhatsApp',
      status: 'Active',
      audience: 'Freshers',
      budget: 25000,
      spent: 14200,
      reach: 18450,
      sent: 12000,
      delivered: 11480,
      opened: 8930,
      clicked: 2840,
      startDate: '01 Aug 2026',
      endDate: '31 Aug 2026',
      icon: Icons.people_alt_rounded,
    ),
    CampaignModel(
      id: 'CMP-002',
      name: 'Solar SCADA Promotion',
      description:
          'B2B lead generation campaign for SCADA and solar monitoring solutions.',
      type: 'Lead Generation',
      channel: 'Email',
      status: 'Active',
      audience: 'EPC Companies',
      budget: 50000,
      spent: 31800,
      reach: 28600,
      sent: 25000,
      delivered: 23850,
      opened: 14200,
      clicked: 4160,
      startDate: '05 Aug 2026',
      endDate: '05 Sep 2026',
      icon: Icons.solar_power_rounded,
    ),
    CampaignModel(
      id: 'CMP-003',
      name: 'Naukariwala Training 2026',
      description:
          'Job-guarantee training promotion for B.Tech and Diploma students.',
      type: 'Training',
      channel: 'Instagram',
      status: 'Active',
      audience: 'Students',
      budget: 35000,
      spent: 22100,
      reach: 54200,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 3780,
      startDate: '10 Aug 2026',
      endDate: '15 Sep 2026',
      icon: Icons.school_rounded,
    ),
    CampaignModel(
      id: 'CMP-004',
      name: 'Existing Client Re-engagement',
      description:
          'Reconnect with existing customers and generate repeat business.',
      type: 'Re-engagement',
      channel: 'SMS',
      status: 'Completed',
      audience: 'Existing Clients',
      budget: 12000,
      spent: 11800,
      reach: 7200,
      sent: 6800,
      delivered: 6510,
      opened: 4210,
      clicked: 980,
      startDate: '01 Jul 2026',
      endDate: '31 Jul 2026',
      icon: Icons.refresh_rounded,
    ),
    CampaignModel(
      id: 'CMP-005',
      name: 'Independence Day Offer',
      description:
          'Special promotional campaign for products and services during Independence Day.',
      type: 'Promotional',
      channel: 'WhatsApp',
      status: 'Completed',
      audience: 'Customers',
      budget: 18000,
      spent: 17400,
      reach: 12300,
      sent: 10000,
      delivered: 9620,
      opened: 7820,
      clicked: 2310,
      startDate: '01 Aug 2026',
      endDate: '15 Aug 2026',
      icon: Icons.local_offer_rounded,
    ),
    CampaignModel(
      id: 'CMP-006',
      name: 'LinkedIn B2B Outreach',
      description:
          'Connect with decision makers from EPC, manufacturing and technology companies.',
      type: 'B2B Outreach',
      channel: 'LinkedIn',
      status: 'Scheduled',
      audience: 'Decision Makers',
      budget: 30000,
      spent: 0,
      reach: 0,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 0,
      startDate: '25 Aug 2026',
      endDate: '25 Sep 2026',
      icon: Icons.business_center_rounded,
    ),
    CampaignModel(
      id: 'CMP-007',
      name: 'Diwali Customer Campaign',
      description:
          'Upcoming festive campaign for existing and prospective customers.',
      type: 'Festive',
      channel: 'Multi-channel',
      status: 'Draft',
      audience: 'Customers & Leads',
      budget: 75000,
      spent: 0,
      reach: 0,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 0,
      startDate: '15 Oct 2026',
      endDate: '15 Nov 2026',
      icon: Icons.celebration_rounded,
    ),
    CampaignModel(
      id: 'CMP-008',
      name: 'Product Awareness Campaign',
      description:
          'Build awareness around ACDB, DCDB, ZED, SMB and automation solutions.',
      type: 'Brand Awareness',
      channel: 'Facebook',
      status: 'Paused',
      audience: 'Solar Industry',
      budget: 40000,
      spent: 12600,
      reach: 21900,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 1240,
      startDate: '01 Aug 2026',
      endDate: '30 Aug 2026',
      icon: Icons.campaign_rounded,
    ),
  ];

  List<CampaignModel> get _filteredCampaigns {
    final query = _searchController.text.trim().toLowerCase();

    return _campaigns.where((campaign) {
      final matchesSearch = query.isEmpty ||
          campaign.name.toLowerCase().contains(query) ||
          campaign.description.toLowerCase().contains(query) ||
          campaign.channel.toLowerCase().contains(query) ||
          campaign.type.toLowerCase().contains(query);

      final matchesStatus = _selectedStatus == 'All' ||
          campaign.status == _selectedStatus;

      final matchesType =
          _selectedType == 'All' || campaign.type == _selectedType;

      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  List<String> get _campaignTypes {
    final types = _campaigns.map((e) => e.type).toSet().toList();
    types.sort();
    return ['All', ...types];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateCampaign() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateCampaignSheet(),
    );
  }

  void _showCampaignDetails(CampaignModel campaign) {
    showDialog<void>(
      context: context,
      builder: (_) => _CampaignDetailsDialog(campaign: campaign),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final campaigns = _filteredCampaigns;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(),
                    const SizedBox(height: 28),
                    _buildToolbar(theme),
                    const SizedBox(height: 20),
                    if (campaigns.isEmpty)
                      _buildEmptyState()
                    else if (_isGridView)
                      _buildGrid(campaigns)
                    else
                      _buildList(campaigns),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCampaign,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Campaign'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Campaigns',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Create, manage and monitor your marketing campaigns',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Analytics'),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _showCreateCampaign,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Campaign'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final active =
        _campaigns.where((campaign) => campaign.status == 'Active').length;

    final scheduled =
        _campaigns.where((campaign) => campaign.status == 'Scheduled').length;

    final totalBudget =
        _campaigns.fold<double>(0, (sum, campaign) => sum + campaign.budget);

    final totalReach =
        _campaigns.fold<int>(0, (sum, campaign) => sum + campaign.reach);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns = 1;
        if (width >= 1100) {
          columns = 4;
        } else if (width >= 700) {
          columns = 2;
        }

        final cardWidth = columns == 1
            ? width
            : (width - ((columns - 1) * 16)) / columns;

        final cards = [
          _SummaryCard(
            width: cardWidth,
            title: 'Total Campaigns',
            value: '${_campaigns.length}',
            subtitle: 'All campaigns',
            icon: Icons.campaign_rounded,
            iconColor: const Color(0xFF4F46E5),
          ),
          _SummaryCard(
            width: cardWidth,
            title: 'Active',
            value: '$active',
            subtitle: 'Currently running',
            icon: Icons.play_circle_fill_rounded,
            iconColor: const Color(0xFF10B981),
          ),
          _SummaryCard(
            width: cardWidth,
            title: 'Scheduled',
            value: '$scheduled',
            subtitle: 'Upcoming campaigns',
            icon: Icons.schedule_rounded,
            iconColor: const Color(0xFFF59E0B),
          ),
          _SummaryCard(
            width: cardWidth,
            title: 'Total Reach',
            value: _formatNumber(totalReach),
            subtitle:
                '₹${_formatMoney(totalBudget)} campaign budget',
            icon: Icons.groups_rounded,
            iconColor: const Color(0xFF06B6D4),
          ),
        ];

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards,
        );
      },
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search campaigns...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear_rounded),
                      ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          _buildFilter(
            label: 'Status',
            value: _selectedStatus,
            items: const [
              'All',
              'Active',
              'Scheduled',
              'Completed',
              'Paused',
              'Draft',
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value ?? 'All';
              });
            },
          ),
          _buildFilter(
            label: 'Type',
            value: _selectedType,
            items: _campaignTypes,
            onChanged: (value) {
              setState(() {
                _selectedType = value ?? 'All';
              });
            },
          ),
          const Spacer(),
          IconButton(
            tooltip: 'List view',
            onPressed: () {
              setState(() {
                _isGridView = false;
              });
            },
            style: IconButton.styleFrom(
              backgroundColor:
                  !_isGridView ? theme.colorScheme.primaryContainer : null,
            ),
            icon: const Icon(Icons.view_list_rounded),
          ),
          IconButton(
            tooltip: 'Grid view',
            onPressed: () {
              setState(() {
                _isGridView = true;
              });
            },
            style: IconButton.styleFrom(
              backgroundColor:
                  _isGridView ? theme.colorScheme.primaryContainer : null,
            ),
            icon: const Icon(Icons.grid_view_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          hint: Text(label),
          borderRadius: BorderRadius.circular(12),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildGrid(List<CampaignModel> campaigns) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 1350) {
          columns = 3;
        } else if (constraints.maxWidth >= 850) {
          columns = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: campaigns.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            mainAxisExtent: 390,
          ),
          itemBuilder: (context, index) {
            return _CampaignCard(
              campaign: campaigns[index],
              onView: () => _showCampaignDetails(campaigns[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildList(List<CampaignModel> campaigns) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: campaigns.map((campaign) {
          return _CampaignListTile(
            campaign: campaign,
            onView: () => _showCampaignDetails(campaign),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 40,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No campaigns found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your search or filter criteria.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }

    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }

    return number.toString();
  }

  String _formatMoney(double value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toStringAsFixed(0);
  }
}

// -----------------------------------------------------------------------------
// CAMPAIGN CARD
// -----------------------------------------------------------------------------

class _CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onView;

  const _CampaignCard({
    required this.campaign,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        campaign.budget == 0 ? 0.0 : campaign.spent / campaign.budget;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _typeColor(campaign.type),
                      _typeColor(campaign.type).withValues(alpha: 0.65),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  campaign.icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.id,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    _StatusBadge(status: campaign.status),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'view') {
                    onView();
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'view',
                    child: Text('View Details'),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Campaign'),
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
          Text(
            campaign.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            campaign.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1.45,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.category_outlined,
                label: campaign.type,
              ),
              _InfoChip(
                icon: Icons.send_outlined,
                label: campaign.channel,
              ),
              _InfoChip(
                icon: Icons.groups_outlined,
                label: campaign.audience,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(
                '₹${campaign.spent.toStringAsFixed(0)} / ₹${campaign.budget.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(
                _typeColor(campaign.type),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Reach',
                  value: _formatMetric(campaign.reach),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Opened',
                  value: _formatMetric(campaign.opened),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Clicked',
                  value: _formatMetric(campaign.clicked),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(height: 24),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 15,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${campaign.startDate} → ${campaign.endDate}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onView,
                child: const Text('View'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Color _typeColor(String type) {
    switch (type) {
      case 'Recruitment':
        return const Color(0xFF2563EB);
      case 'Lead Generation':
        return const Color(0xFF7C3AED);
      case 'Training':
        return const Color(0xFF0891B2);
      case 'Promotional':
        return const Color(0xFFEA580C);
      case 'Re-engagement':
        return const Color(0xFF059669);
      case 'B2B Outreach':
        return const Color(0xFF4F46E5);
      case 'Festive':
        return const Color(0xFFDB2777);
      case 'Brand Awareness':
        return const Color(0xFFCA8A04);
      default:
        return const Color(0xFF64748B);
    }
  }

  static String _formatMetric(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }
}

// -----------------------------------------------------------------------------
// LIST TILE
// -----------------------------------------------------------------------------

class _CampaignListTile extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onView;

  const _CampaignListTile({
    required this.campaign,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onView,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                campaign.icon,
                color: const Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.type,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _StatusBadge(status: campaign.status),
            ),
            Expanded(
              child: Text(
                campaign.channel,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Text(
                '₹${campaign.budget.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _formatNumber(campaign.reach),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }

    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }

    return number.toString();
  }
}

// -----------------------------------------------------------------------------
// STATUS BADGE
// -----------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF059669);
      case 'Scheduled':
        return const Color(0xFF2563EB);
      case 'Completed':
        return const Color(0xFF64748B);
      case 'Paused':
        return const Color(0xFFD97706);
      case 'Draft':
        return const Color(0xFF7C3AED);
      default:
        return Colors.grey;
    }
  }
}

// -----------------------------------------------------------------------------
// INFO CHIP
// -----------------------------------------------------------------------------

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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// METRIC
// -----------------------------------------------------------------------------

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// SUMMARY CARD
// -----------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.width,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
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
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CAMPAIGN DETAILS
// -----------------------------------------------------------------------------

class _CampaignDetailsDialog extends StatelessWidget {
  final CampaignModel campaign;

  const _CampaignDetailsDialog({
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 760,
          maxHeight: 720,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF7C3AED),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      campaign.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          campaign.id,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(status: campaign.status),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                campaign.description,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Campaign Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _DetailBox(
                    title: 'Campaign Type',
                    value: campaign.type,
                    icon: Icons.category_outlined,
                  ),
                  _DetailBox(
                    title: 'Channel',
                    value: campaign.channel,
                    icon: Icons.send_outlined,
                  ),
                  _DetailBox(
                    title: 'Audience',
                    value: campaign.audience,
                    icon: Icons.groups_outlined,
                  ),
                  _DetailBox(
                    title: 'Budget',
                    value: '₹${campaign.budget.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  _DetailBox(
                    title: 'Start Date',
                    value: campaign.startDate,
                    icon: Icons.calendar_today_outlined,
                  ),
                  _DetailBox(
                    title: 'End Date',
                    value: campaign.endDate,
                    icon: Icons.event_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const Text(
                'Performance',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _PerformanceBox(
                      title: 'Reach',
                      value: _format(campaign.reach),
                      icon: Icons.visibility_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PerformanceBox(
                      title: 'Delivered',
                      value: _format(campaign.delivered),
                      icon: Icons.done_all_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PerformanceBox(
                      title: 'Opened',
                      value: _format(campaign.opened),
                      icon: Icons.mark_email_read_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PerformanceBox(
                      title: 'Clicked',
                      value: _format(campaign.clicked),
                      icon: Icons.touch_app_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Campaign'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _format(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }
}

// -----------------------------------------------------------------------------
// DETAIL BOX
// -----------------------------------------------------------------------------

class _DetailBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19,
              color: const Color(0xFF4F46E5),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PERFORMANCE BOX
// -----------------------------------------------------------------------------

class _PerformanceBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _PerformanceBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF4F46E5),
            size: 20,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CREATE CAMPAIGN SHEET
// -----------------------------------------------------------------------------

class _CreateCampaignSheet extends StatefulWidget {
  const _CreateCampaignSheet();

  @override
  State<_CreateCampaignSheet> createState() => _CreateCampaignSheetState();
}

class _CreateCampaignSheetState extends State<_CreateCampaignSheet> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();

  String _type = 'Lead Generation';
  String _channel = 'WhatsApp';
  String _audience = 'Customers';

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Create New Campaign',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Set up your campaign and start reaching your audience.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Campaign Name',
                  hintText: 'e.g. August Lead Generation',
                  prefixIcon: const Icon(Icons.campaign_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _dropdown(
                      label: 'Campaign Type',
                      value: _type,
                      items: const [
                        'Lead Generation',
                        'Recruitment',
                        'Training',
                        'Promotional',
                        'B2B Outreach',
                        'Re-engagement',
                        'Brand Awareness',
                        'Festive',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _dropdown(
                      label: 'Channel',
                      value: _channel,
                      items: const [
                        'WhatsApp',
                        'Email',
                        'SMS',
                        'Facebook',
                        'Instagram',
                        'LinkedIn',
                        'Multi-channel',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _channel = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _dropdown(
                      label: 'Target Audience',
                      value: _audience,
                      items: const [
                        'Customers',
                        'Leads',
                        'Freshers',
                        'Students',
                        'EPC Companies',
                        'Decision Makers',
                        'Existing Clients',
                      ],
                      onChanged: (value) {
                        setState(() {
                          _audience = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Budget',
                        prefixText: '₹ ',
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.rocket_launch_rounded),
                  label: const Text('Create Campaign'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

// -----------------------------------------------------------------------------
// MODEL
// -----------------------------------------------------------------------------

class CampaignModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String channel;
  final String status;
  final String audience;
  final double budget;
  final double spent;
  final int reach;
  final int sent;
  final int delivered;
  final int opened;
  final int clicked;
  final String startDate;
  final String endDate;
  final IconData icon;

  const CampaignModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.channel,
    required this.status,
    required this.audience,
    required this.budget,
    required this.spent,
    required this.reach,
    required this.sent,
    required this.delivered,
    required this.opened,
    required this.clicked,
    required this.startDate,
    required this.endDate,
    required this.icon,
  });
}