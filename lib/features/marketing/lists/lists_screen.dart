import 'package:flutter/material.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  bool _isGridView = true;

  final List<MarketingList> _lists = [
    MarketingList(
      name: 'All Leads',
      description: 'Master list containing all qualified and unqualified leads.',
      type: 'All Contacts',
      contacts: 2480,
      status: 'Active',
      updated: 'Today',
      icon: Icons.people_alt_rounded,
    ),
    MarketingList(
      name: 'Hot Leads',
      description: 'High-priority prospects ready for sales follow-up.',
      type: 'Lead Segment',
      contacts: 486,
      status: 'Active',
      updated: 'Today',
      icon: Icons.local_fire_department_rounded,
    ),
    MarketingList(
      name: 'Website Leads',
      description: 'Contacts collected through website enquiry forms.',
      type: 'Web Leads',
      contacts: 734,
      status: 'Active',
      updated: 'Yesterday',
      icon: Icons.language_rounded,
    ),
    MarketingList(
      name: 'Newsletter Subscribers',
      description: 'Subscribers who have opted in for newsletters.',
      type: 'Email Subscribers',
      contacts: 1245,
      status: 'Active',
      updated: '2 days ago',
      icon: Icons.mark_email_read_rounded,
    ),
    MarketingList(
      name: 'Existing Customers',
      description: 'Customers with previous purchases or active services.',
      type: 'Customers',
      contacts: 618,
      status: 'Active',
      updated: '3 days ago',
      icon: Icons.handshake_rounded,
    ),
    MarketingList(
      name: 'Inactive Contacts',
      description: 'Contacts that have not interacted recently.',
      type: 'Re-engagement',
      contacts: 352,
      status: 'Inactive',
      updated: '1 week ago',
      icon: Icons.person_off_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MarketingList> get _filteredLists {
    final search = _searchController.text.trim().toLowerCase();

    return _lists.where((list) {
      final matchesSearch =
          search.isEmpty ||
          list.name.toLowerCase().contains(search) ||
          list.description.toLowerCase().contains(search) ||
          list.type.toLowerCase().contains(search);

      final matchesFilter =
          _selectedFilter == 'All' || list.status == _selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createList,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create List'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(
                    context,
                    isMobile: isMobile,
                    colorScheme: colorScheme,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildStats(context, isMobile: isMobile),
                ),
                SliverToBoxAdapter(
                  child: _buildToolbar(
                    context,
                    isMobile: isMobile,
                    colorScheme: colorScheme,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 16 : 28,
                    8,
                    isMobile ? 16 : 28,
                    100,
                  ),
                  sliver: _filteredLists.isEmpty
                      ? SliverToBoxAdapter(
                          child: _buildEmptyState(context),
                        )
                      : _isGridView
                      ? SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 420,
                                mainAxisExtent: 255,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _buildListCard(
                                context,
                                _filteredLists[index],
                              );
                            },
                            childCount: _filteredLists.length,
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _buildListCard(
                                  context,
                                  _filteredLists[index],
                                  listMode: true,
                                ),
                              );
                            },
                            childCount: _filteredLists.length,
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

  Widget _buildHeader(
    BuildContext context, {
    required bool isMobile,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 30,
        24,
        isMobile ? 20 : 30,
        22,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
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
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.list_alt_rounded,
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
                      'Marketing Lists',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Organize, segment and manage your marketing contacts.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                FilledButton.icon(
                  onPressed: _createList,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Marketing List'),
                ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _createList,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Marketing List'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStats(
    BuildContext context, {
    required bool isMobile,
  }) {
    final totalContacts = _lists.fold<int>(
      0,
      (sum, item) => sum + item.contacts,
    );

    final activeLists = _lists.where((e) => e.status == 'Active').length;

    final stats = [
      _StatData(
        title: 'Total Lists',
        value: '${_lists.length}',
        icon: Icons.list_alt_rounded,
        color: Colors.blue,
      ),
      _StatData(
        title: 'Total Contacts',
        value: _formatNumber(totalContacts),
        icon: Icons.people_alt_rounded,
        color: Colors.indigo,
      ),
      _StatData(
        title: 'Active Lists',
        value: '$activeLists',
        icon: Icons.check_circle_rounded,
        color: Colors.green,
      ),
      _StatData(
        title: 'Inactive',
        value: '${_lists.length - activeLists}',
        icon: Icons.pause_circle_rounded,
        color: Colors.orange,
      ),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        22,
        isMobile ? 16 : 28,
        8,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          mainAxisExtent: 100,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, index) {
          return _buildStatCard(context, stats[index]);
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, _StatData stat) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 5),
            color: Colors.black.withValues(alpha: 0.035),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: stat.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(stat.icon, color: stat.color),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildToolbar(
    BuildContext context, {
    required bool isMobile,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        18,
        isMobile ? 16 : 28,
        8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search marketing lists...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 12),
                _viewToggle(context),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Active', 'Inactive'].map((filter) {
                      final selected = _selectedFilter == filter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: selected,
                          label: Text(filter),
                          avatar: Icon(
                            filter == 'All'
                                ? Icons.grid_view_rounded
                                : filter == 'Active'
                                ? Icons.check_circle_outline_rounded
                                : Icons.pause_circle_outline_rounded,
                            size: 17,
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (isMobile) _viewToggle(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewToggle(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Grid view',
            onPressed: () => setState(() => _isGridView = true),
            icon: Icon(
              Icons.grid_view_rounded,
              size: 20,
              color: _isGridView
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
          IconButton(
            tooltip: 'List view',
            onPressed: () => setState(() => _isGridView = false),
            icon: Icon(
              Icons.view_list_rounded,
              size: 20,
              color: !_isGridView
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(
    BuildContext context,
    MarketingList list, {
    bool listMode = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = list.status == 'Active';

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openList(list),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.42),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 6),
                color: Colors.black.withValues(alpha: 0.035),
              ),
            ],
          ),
          child: listMode
              ? _buildHorizontalCardContent(
                  context,
                  list,
                  isActive,
                )
              : _buildGridCardContent(
                  context,
                  list,
                  isActive,
                ),
        ),
      ),
    );
  }

  Widget _buildGridCardContent(
    BuildContext context,
    MarketingList list,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                list.icon,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const Spacer(),
            _statusBadge(context, list.status),
            PopupMenuButton<String>(
              tooltip: 'More actions',
              onSelected: (value) => _handleAction(value, list),
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text('Duplicate'),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          list.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          list.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            height: 1.4,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        const Divider(height: 24),
        Row(
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 18,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 7),
            Text(
              '${_formatNumber(list.contacts)} contacts',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              list.updated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalCardContent(
    BuildContext context,
    MarketingList list,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            list.icon,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                list.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                list.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _statusBadge(context, list.status),
            const SizedBox(height: 6),
            Text(
              '${_formatNumber(list.contacts)} contacts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleAction(value, list),
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
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final active = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withValues(alpha: 0.10)
            : Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: active ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 38,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No marketing lists found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Try changing your search or filter, or create a new marketing list.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _createList,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Marketing List'),
          ),
        ],
      ),
    );
  }

  void _createList() {
    showDialog(
      context: context,
      builder: (context) {
        return const _CreateListDialog();
      },
    );
  }

  void _openList(MarketingList list) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${list.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleAction(String action, MarketingList list) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Edit ${list.name}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${list.name} duplicated'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;

      case 'delete':
        _confirmDelete(list);
        break;
    }
  }

  void _confirmDelete(MarketingList list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete marketing list?'),
          content: Text(
            'Are you sure you want to delete "${list.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Marketing list deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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
}

class MarketingList {
  final String name;
  final String description;
  final String type;
  final int contacts;
  final String status;
  final String updated;
  final IconData icon;

  const MarketingList({
    required this.name,
    required this.description,
    required this.type,
    required this.contacts,
    required this.status,
    required this.updated,
    required this.icon,
  });
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _CreateListDialog extends StatefulWidget {
  const _CreateListDialog();

  @override
  State<_CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends State<_CreateListDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = 'All Contacts';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create Marketing List',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'List Name',
                  hintText: 'e.g. Delhi NCR Leads',
                  prefixIcon: Icon(Icons.list_alt_rounded),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe the purpose of this list',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'List Type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'All Contacts',
                    child: Text('All Contacts'),
                  ),
                  DropdownMenuItem(
                    value: 'Lead Segment',
                    child: Text('Lead Segment'),
                  ),
                  DropdownMenuItem(
                    value: 'Customers',
                    child: Text('Customers'),
                  ),
                  DropdownMenuItem(
                    value: 'Email Subscribers',
                    child: Text('Email Subscribers'),
                  ),
                  DropdownMenuItem(
                    value: 'Web Leads',
                    child: Text('Web Leads'),
                  ),
                  DropdownMenuItem(
                    value: 'Re-engagement',
                    child: Text('Re-engagement'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _type = value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.check_rounded),
          label: const Text('Create List'),
        ),
      ],
    );
  }
}