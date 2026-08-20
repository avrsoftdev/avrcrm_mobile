import 'package:flutter/material.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedType = 'All';
  String _selectedStatus = 'All';
  String _selectedChannel = 'All';

  final List<CampaignModel> _campaigns = [
    CampaignModel(
      id: 'CMP-001',
      name: 'Independence Day Hiring Campaign',
      type: 'Recruitment',
      channel: 'WhatsApp',
      status: 'Running',
      audience: 'Freshers',
      budget: 25000,
      startDate: DateTime(2026, 8, 1),
      endDate: DateTime(2026, 8, 31),
      totalContacts: 5200,
      sent: 5100,
      delivered: 4920,
      opened: 3210,
      clicked: 840,
      replied: 325,
      leads: 186,
    ),
    CampaignModel(
      id: 'CMP-002',
      name: 'Solar SCADA Lead Generation',
      type: 'Lead Generation',
      channel: 'Email',
      status: 'Running',
      audience: 'Solar EPC Companies',
      budget: 50000,
      startDate: DateTime(2026, 8, 5),
      endDate: DateTime(2026, 9, 5),
      totalContacts: 3200,
      sent: 3150,
      delivered: 3040,
      opened: 1890,
      clicked: 410,
      replied: 94,
      leads: 72,
    ),
    CampaignModel(
      id: 'CMP-003',
      name: 'Naukariwala Campus Hiring',
      type: 'Campus Campaign',
      channel: 'SMS',
      status: 'Scheduled',
      audience: 'College Students',
      budget: 18000,
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 30),
      totalContacts: 10000,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 0,
      replied: 0,
      leads: 0,
    ),
    CampaignModel(
      id: 'CMP-004',
      name: 'CRM Product Awareness',
      type: 'Brand Awareness',
      channel: 'Social Media',
      status: 'Completed',
      audience: 'Business Owners',
      budget: 35000,
      startDate: DateTime(2026, 7, 1),
      endDate: DateTime(2026, 7, 31),
      totalContacts: 8500,
      sent: 8500,
      delivered: 8230,
      opened: 0,
      clicked: 1250,
      replied: 210,
      leads: 95,
    ),
    CampaignModel(
      id: 'CMP-005',
      name: 'Existing Customer Follow-up',
      type: 'Customer Retention',
      channel: 'WhatsApp',
      status: 'Draft',
      audience: 'Existing Customers',
      budget: 12000,
      startDate: DateTime(2026, 9, 10),
      endDate: DateTime(2026, 9, 20),
      totalContacts: 1200,
      sent: 0,
      delivered: 0,
      opened: 0,
      clicked: 0,
      replied: 0,
      leads: 0,
    ),
  ];

  final List<String> _campaignTypes = const [
    'All',
    'Lead Generation',
    'Sales',
    'Recruitment',
    'Campus Campaign',
    'Brand Awareness',
    'Product Promotion',
    'Customer Retention',
    'Remarketing',
    'Event Promotion',
    'Email Marketing',
    'Social Media',
  ];

  final List<String> _statuses = const [
    'All',
    'Draft',
    'Scheduled',
    'Running',
    'Paused',
    'Completed',
  ];

  final List<String> _channels = const [
    'All',
    'WhatsApp',
    'SMS',
    'Email',
    'Social Media',
    'Voice',
    'Push Notification',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CampaignModel> get _filteredCampaigns {
    final query = _searchController.text.trim().toLowerCase();

    return _campaigns.where((campaign) {
      final matchesSearch =
          query.isEmpty ||
          campaign.name.toLowerCase().contains(query) ||
          campaign.type.toLowerCase().contains(query) ||
          campaign.audience.toLowerCase().contains(query);

      final matchesType =
          _selectedType == 'All' || campaign.type == _selectedType;

      final matchesStatus =
          _selectedStatus == 'All' || campaign.status == _selectedStatus;

      final matchesChannel =
          _selectedChannel == 'All' || campaign.channel == _selectedChannel;

      return matchesSearch &&
          matchesType &&
          matchesStatus &&
          matchesChannel;
    }).toList();
  }

  int get _totalCampaigns => _campaigns.length;

  int get _runningCampaigns =>
      _campaigns.where((e) => e.status == 'Running').length;

  int get _totalLeads =>
      _campaigns.fold<int>(0, (sum, campaign) => sum + campaign.leads);

  double get _totalBudget =>
      _campaigns.fold<double>(0, (sum, campaign) => sum + campaign.budget);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF101318) : const Color(0xFFF5F7FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateCampaignDialog,
        icon: const Icon(Icons.add),
        label: const Text('Create Campaign'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(context, isMobile),
                ),
                SliverToBoxAdapter(
                  child: _buildStatistics(context, isMobile),
                ),
                SliverToBoxAdapter(
                  child: _buildCampaignTypes(context, isMobile),
                ),
                SliverToBoxAdapter(
                  child: _buildFilters(context, isMobile),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 16 : 28,
                    8,
                    isMobile ? 16 : 28,
                    100,
                  ),
                  sliver: _filteredCampaigns.isEmpty
                      ? SliverToBoxAdapter(
                          child: _buildEmptyState(context),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildCampaignCard(
                                  context,
                                  _filteredCampaigns[index],
                                  isMobile,
                                ),
                              );
                            },
                            childCount: _filteredCampaigns.length,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        24,
        isMobile ? 16 : 28,
        18,
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
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF635BFF),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
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
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Create, manage and track your marketing campaigns',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                FilledButton.icon(
                  onPressed: _showCreateCampaignDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('New Campaign'),
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _showCreateCampaignDialog,
                icon: const Icon(Icons.add),
                label: const Text('New Campaign'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, bool isMobile) {
    final cards = [
      _StatData(
        'Total Campaigns',
        '$_totalCampaigns',
        Icons.campaign_outlined,
        const Color(0xFF635BFF),
      ),
      _StatData(
        'Running',
        '$_runningCampaigns',
        Icons.play_circle_outline,
        const Color(0xFF10B981),
      ),
      _StatData(
        'Total Leads',
        '$_totalLeads',
        Icons.people_alt_outlined,
        const Color(0xFFF59E0B),
      ),
      _StatData(
        'Total Budget',
        _formatCurrency(_totalBudget),
        Icons.account_balance_wallet_outlined,
        const Color(0xFF0EA5E9),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 28),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.55 : 1.9,
        ),
        itemBuilder: (context, index) {
          final item = cards[index];

          return _statCard(
            context,
            item.title,
            item.value,
            item.icon,
            item.color,
          );
        },
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignTypes(BuildContext context, bool isMobile) {
    final types = [
      ('Lead Generation', Icons.person_add_alt_1),
      ('Sales', Icons.shopping_cart_outlined),
      ('Recruitment', Icons.badge_outlined),
      ('Campus Campaign', Icons.school_outlined),
      ('Brand Awareness', Icons.visibility_outlined),
      ('Product Promotion', Icons.local_offer_outlined),
      ('Customer Retention', Icons.favorite_border),
      ('Remarketing', Icons.refresh_rounded),
      ('Event Promotion', Icons.event_outlined),
      ('Email Marketing', Icons.email_outlined),
      ('Social Media', Icons.share_outlined),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        24,
        isMobile ? 16 : 28,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Campaign Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = types[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedType = item.$1;
                    });
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedType == item.$1
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          item.$2,
                          size: 22,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Spacer(),
                        Text(
                          item.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        18,
        isMobile ? 16 : 28,
        16,
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search campaigns, audience or campaign type...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (isMobile)
            Column(
              children: [
                _dropdown(
                  context,
                  'Campaign Type',
                  _selectedType,
                  _campaignTypes,
                  (value) => setState(() => _selectedType = value),
                ),
                const SizedBox(height: 10),
                _dropdown(
                  context,
                  'Status',
                  _selectedStatus,
                  _statuses,
                  (value) => setState(() => _selectedStatus = value),
                ),
                const SizedBox(height: 10),
                _dropdown(
                  context,
                  'Channel',
                  _selectedChannel,
                  _channels,
                  (value) => setState(() => _selectedChannel = value),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    context,
                    'Campaign Type',
                    _selectedType,
                    _campaignTypes,
                    (value) => setState(() => _selectedType = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    context,
                    'Status',
                    _selectedStatus,
                    _statuses,
                    (value) => setState(() => _selectedStatus = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    context,
                    'Channel',
                    _selectedChannel,
                    _channels,
                    (value) => setState(() => _selectedChannel = value),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _dropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    CampaignModel campaign,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final progress = campaign.totalContacts == 0
        ? 0.0
        : campaign.sent / campaign.totalContacts;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showCampaignDetails(campaign),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _campaignIcon(campaign.type),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _smallTag(context, campaign.type),
                            _smallTag(context, campaign.channel),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _statusChip(context, campaign.status),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'details') {
                        _showCampaignDetails(campaign);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'details',
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
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isMobile)
                Row(
                  children: [
                    _metric(
                      context,
                      'Audience',
                      campaign.audience,
                      Icons.people_outline,
                    ),
                    _metric(
                      context,
                      'Contacts',
                      _formatNumber(campaign.totalContacts),
                      Icons.contacts_outlined,
                    ),
                    _metric(
                      context,
                      'Leads',
                      _formatNumber(campaign.leads),
                      Icons.trending_up,
                    ),
                    _metric(
                      context,
                      'Budget',
                      _formatCurrency(campaign.budget),
                      Icons.account_balance_wallet_outlined,
                    ),
                  ],
                )
              else
                Wrap(
                  spacing: 20,
                  runSpacing: 14,
                  children: [
                    _compactMetric(
                      context,
                      'Contacts',
                      _formatNumber(campaign.totalContacts),
                    ),
                    _compactMetric(
                      context,
                      'Leads',
                      _formatNumber(campaign.leads),
                    ),
                    _compactMetric(
                      context,
                      'Budget',
                      _formatCurrency(campaign.budget),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Campaign Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${_formatDate(campaign.startDate)} - ${_formatDate(campaign.endDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    '${_formatNumber(campaign.replied)} replies',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campaignIcon(String type) {
    IconData icon;

    switch (type) {
      case 'Lead Generation':
        icon = Icons.person_add_alt_1;
        break;
      case 'Sales':
        icon = Icons.shopping_cart_outlined;
        break;
      case 'Recruitment':
        icon = Icons.badge_outlined;
        break;
      case 'Campus Campaign':
        icon = Icons.school_outlined;
        break;
      case 'Brand Awareness':
        icon = Icons.visibility_outlined;
        break;
      case 'Product Promotion':
        icon = Icons.local_offer_outlined;
        break;
      case 'Customer Retention':
        icon = Icons.favorite_border;
        break;
      default:
        icon = Icons.campaign_outlined;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF635BFF),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _smallTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, String status) {
    Color color;

    switch (status) {
      case 'Running':
        color = const Color(0xFF10B981);
        break;
      case 'Scheduled':
        color = const Color(0xFF0EA5E9);
        break;
      case 'Completed':
        color = const Color(0xFF6366F1);
        break;
      case 'Paused':
        color = const Color(0xFFF59E0B);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _metric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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

  Widget _compactMetric(
    BuildContext context,
    String title,
    String value,
  ) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 60,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No campaigns found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing your filters or create a new campaign.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateCampaignDialog() {
    final nameController = TextEditingController();
    String type = 'Lead Generation';
    String channel = 'WhatsApp';
    String status = 'Draft';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Create Campaign',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Campaign Name',
                          hintText: 'Enter campaign name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: type,
                        decoration: const InputDecoration(
                          labelText: 'Campaign Type',
                        ),
                        items: _campaignTypes
                            .where((e) => e != 'All')
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => type = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: channel,
                        decoration: const InputDecoration(
                          labelText: 'Channel',
                        ),
                        items: _channels
                            .where((e) => e != 'All')
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => channel = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                        ),
                        items: _statuses
                            .where((e) => e != 'All')
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => status = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      _campaigns.insert(
                        0,
                        CampaignModel(
                          id: 'CMP-${_campaigns.length + 1}',
                          name: nameController.text.trim(),
                          type: type,
                          channel: channel,
                          status: status,
                          audience: 'New Audience',
                          budget: 0,
                          startDate: DateTime.now(),
                          endDate: DateTime.now()
                              .add(const Duration(days: 30)),
                          totalContacts: 0,
                          sent: 0,
                          delivered: 0,
                          opened: 0,
                          clicked: 0,
                          replied: 0,
                          leads: 0,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCampaignDetails(CampaignModel campaign) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            campaign.name,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _statusChip(context, campaign.status),
                      const SizedBox(width: 8),
                      _smallTag(context, campaign.type),
                      const SizedBox(width: 8),
                      _smallTag(context, campaign.channel),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _detailRow('Campaign ID', campaign.id),
                  _detailRow('Audience', campaign.audience),
                  _detailRow(
                    'Budget',
                    _formatCurrency(campaign.budget),
                  ),
                  _detailRow(
                    'Start Date',
                    _formatDate(campaign.startDate),
                  ),
                  _detailRow(
                    'End Date',
                    _formatDate(campaign.endDate),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Campaign Performance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _detailRow(
                    'Total Contacts',
                    _formatNumber(campaign.totalContacts),
                  ),
                  _detailRow(
                    'Sent',
                    _formatNumber(campaign.sent),
                  ),
                  _detailRow(
                    'Delivered',
                    _formatNumber(campaign.delivered),
                  ),
                  _detailRow(
                    'Opened',
                    _formatNumber(campaign.opened),
                  ),
                  _detailRow(
                    'Clicked',
                    _formatNumber(campaign.clicked),
                  ),
                  _detailRow(
                    'Replies',
                    _formatNumber(campaign.replied),
                  ),
                  _detailRow(
                    'Leads Generated',
                    _formatNumber(campaign.leads),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)} Cr';
    }

    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)} L';
    }

    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }

    return '₹${value.toStringAsFixed(0)}';
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }

    return value.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class CampaignModel {
  final String id;
  final String name;
  final String type;
  final String channel;
  final String status;
  final String audience;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final int totalContacts;
  final int sent;
  final int delivered;
  final int opened;
  final int clicked;
  final int replied;
  final int leads;

  const CampaignModel({
    required this.id,
    required this.name,
    required this.type,
    required this.channel,
    required this.status,
    required this.audience,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.totalContacts,
    required this.sent,
    required this.delivered,
    required this.opened,
    required this.clicked,
    required this.replied,
    required this.leads,
  });
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatData(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}git remote set-url origin https://github.com/avrsoftdev/avrcrm_mobile.git