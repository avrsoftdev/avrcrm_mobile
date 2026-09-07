import 'package:flutter/material.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedType = 'All';
  bool _favoritesOnly = false;

  final List<String> _categories = const [
    'All',
    'Invoices',
    'Quotes',
    'Campaigns',
    'Emails',
    'Inventory',
    'Payments',
    'HR',
    'Reports',
    'Marketing',
  ];

  final List<TemplateItem> _templates = [
    TemplateItem(
      id: 'INV-001',
      name: 'Professional Invoice',
      category: 'Invoices',
      type: 'Invoice',
      description: 'Professional GST invoice template for customers.',
      icon: Icons.receipt_long_rounded,
      isFavorite: true,
      usageCount: 124,
    ),
    TemplateItem(
      id: 'INV-002',
      name: 'GST Tax Invoice',
      category: 'Invoices',
      type: 'Invoice',
      description: 'GST compliant tax invoice with company details.',
      icon: Icons.request_quote_rounded,
      usageCount: 96,
    ),
    TemplateItem(
      id: 'INV-003',
      name: 'Service Invoice',
      category: 'Invoices',
      type: 'Invoice',
      description: 'Invoice template for professional services.',
      icon: Icons.description_rounded,
      usageCount: 71,
    ),
    TemplateItem(
      id: 'QUO-001',
      name: 'Professional Quotation',
      category: 'Quotes',
      type: 'Quotation',
      description: 'Clean quotation template for customers.',
      icon: Icons.price_check_rounded,
      isFavorite: true,
      usageCount: 112,
    ),
    TemplateItem(
      id: 'QUO-002',
      name: 'Project Quotation',
      category: 'Quotes',
      type: 'Quotation',
      description: 'Detailed quotation for project-based work.',
      icon: Icons.assignment_rounded,
      usageCount: 63,
    ),
    TemplateItem(
      id: 'CAM-001',
      name: 'Product Promotion',
      category: 'Campaigns',
      type: 'Campaign',
      description: 'Promotional campaign template for products.',
      icon: Icons.campaign_rounded,
      isFavorite: true,
      usageCount: 87,
    ),
    TemplateItem(
      id: 'CAM-002',
      name: 'Festival Promotion',
      category: 'Campaigns',
      type: 'Campaign',
      description: 'Festival and seasonal marketing campaign.',
      icon: Icons.celebration_rounded,
      usageCount: 54,
    ),
    TemplateItem(
      id: 'CAM-003',
      name: 'Lead Generation',
      category: 'Campaigns',
      type: 'Campaign',
      description: 'Campaign structure designed for lead generation.',
      icon: Icons.people_alt_rounded,
      usageCount: 43,
    ),
    TemplateItem(
      id: 'EML-001',
      name: 'Welcome Email',
      category: 'Emails',
      type: 'Email',
      description: 'Welcome email for new customers.',
      icon: Icons.mark_email_read_rounded,
      isFavorite: true,
      usageCount: 154,
    ),
    TemplateItem(
      id: 'EML-002',
      name: 'Payment Reminder',
      category: 'Emails',
      type: 'Email',
      description: 'Professional payment reminder email.',
      icon: Icons.notifications_active_rounded,
      usageCount: 88,
    ),
    TemplateItem(
      id: 'EML-003',
      name: 'Quotation Follow-up',
      category: 'Emails',
      type: 'Email',
      description: 'Follow-up email after sending quotation.',
      icon: Icons.forward_to_inbox_rounded,
      usageCount: 65,
    ),
    TemplateItem(
      id: 'INVNT-001',
      name: 'Stock Transfer',
      category: 'Inventory',
      type: 'Inventory',
      description: 'Template for inventory stock transfer.',
      icon: Icons.swap_horiz_rounded,
      usageCount: 31,
    ),
    TemplateItem(
      id: 'INVNT-002',
      name: 'Purchase Order',
      category: 'Inventory',
      type: 'Purchase Order',
      description: 'Purchase order template for suppliers.',
      icon: Icons.inventory_2_rounded,
      isFavorite: true,
      usageCount: 49,
    ),
    TemplateItem(
      id: 'PAY-001',
      name: 'Payment Receipt',
      category: 'Payments',
      type: 'Receipt',
      description: 'Professional customer payment receipt.',
      icon: Icons.payments_rounded,
      usageCount: 92,
    ),
    TemplateItem(
      id: 'HR-001',
      name: 'Offer Letter',
      category: 'HR',
      type: 'HR Document',
      description: 'Employee offer letter template.',
      icon: Icons.badge_rounded,
      isFavorite: true,
      usageCount: 34,
    ),
    TemplateItem(
      id: 'HR-002',
      name: 'Appointment Letter',
      category: 'HR',
      type: 'HR Document',
      description: 'Employee appointment letter.',
      icon: Icons.assignment_ind_rounded,
      usageCount: 28,
    ),
    TemplateItem(
      id: 'RPT-001',
      name: 'Sales Report',
      category: 'Reports',
      type: 'Report',
      description: 'Sales performance report template.',
      icon: Icons.bar_chart_rounded,
      usageCount: 37,
    ),
    TemplateItem(
      id: 'MKT-001',
      name: 'WhatsApp Promotion',
      category: 'Marketing',
      type: 'Message',
      description: 'WhatsApp promotional message template.',
      icon: Icons.chat_rounded,
      isFavorite: true,
      usageCount: 105,
    ),
  ];

  List<TemplateItem> get _filteredTemplates {
    final query = _searchController.text.trim().toLowerCase();

    return _templates.where((template) {
      final matchesSearch =
          query.isEmpty ||
          template.name.toLowerCase().contains(query) ||
          template.description.toLowerCase().contains(query) ||
          template.category.toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'All' ||
          template.category == _selectedCategory;

      final matchesType =
          _selectedType == 'All' ||
          template.type == _selectedType;

      final matchesFavorite =
          !_favoritesOnly || template.isFavorite;

      return matchesSearch &&
          matchesCategory &&
          matchesType &&
          matchesFavorite;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _createTemplate() {
    showDialog(
      context: context,
      builder: (_) => const _CreateTemplateDialog(),
    );
  }

  void _showPreview(TemplateItem template) {
    showDialog(
      context: context,
      builder: (_) => _TemplatePreviewDialog(template: template),
    );
  }

  void _toggleFavorite(TemplateItem template) {
    setState(() {
      template.isFavorite = !template.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredTemplates;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTemplate,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Template'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(theme),
            ),
            SliverToBoxAdapter(
              child: _buildStats(),
            ),
            SliverToBoxAdapter(
              child: _buildToolbar(),
            ),
            SliverToBoxAdapter(
              child: _buildCategoryChips(),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 100),
              sliver: filtered.isEmpty
                  ? SliverToBoxAdapter(
                      child: _buildEmptyState(),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildTemplateCard(
                            filtered[index],
                          );
                        },
                        childCount: filtered.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 430,
                        mainAxisExtent: 300,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF182848),
            Color(0xFF304B75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          return Flex(
            direction: compact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: compact ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Templates',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create, manage and reuse your business templates',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              if (!compact) const SizedBox(width: 30),
              if (compact) const SizedBox(height: 22),
              _buildQuickCreate(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickCreate() {
    return FilledButton.icon(
      onPressed: _createTemplate,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF182848),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'New Template',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final items = [
            _StatItem(
              title: 'Total Templates',
              value: '100+',
              icon: Icons.library_books_rounded,
            ),
            _StatItem(
              title: 'My Templates',
              value: '18',
              icon: Icons.person_rounded,
            ),
            _StatItem(
              title: 'Favorites',
              value: '${_templates.where((e) => e.isFavorite).length}',
              icon: Icons.star_rounded,
            ),
            _StatItem(
              title: 'Most Used',
              value: '154',
              icon: Icons.trending_up_rounded,
            ),
          ];

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate:
                SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 105,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemBuilder: (_, index) {
              return _buildStatCard(items[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7E9F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF777C8A),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: const TextStyle(
                    fontSize: 22,
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

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          SizedBox(
            width: 360,
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search templates...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE4E6ED),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFFE4E6ED),
                  ),
                ),
              ),
            ),
          ),
          _filterButton(),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
            icon: Icon(
              _favoritesOnly
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
            ),
            label: const Text('Favorites'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _selectedType = value;
        });
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'All',
          child: Text('All Types'),
        ),
        PopupMenuItem(
          value: 'Invoice',
          child: Text('Invoice'),
        ),
        PopupMenuItem(
          value: 'Quotation',
          child: Text('Quotation'),
        ),
        PopupMenuItem(
          value: 'Campaign',
          child: Text('Campaign'),
        ),
        PopupMenuItem(
          value: 'Email',
          child: Text('Email'),
        ),
        PopupMenuItem(
          value: 'Inventory',
          child: Text('Inventory'),
        ),
        PopupMenuItem(
          value: 'Receipt',
          child: Text('Receipt'),
        ),
        PopupMenuItem(
          value: 'HR Document',
          child: Text('HR Document'),
        ),
        PopupMenuItem(
          value: 'Report',
          child: Text('Report'),
        ),
        PopupMenuItem(
          value: 'Message',
          child: Text('Message'),
        ),
      ],
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.tune_rounded),
        label: Text(
          _selectedType == 'All'
              ? 'Type'
              : _selectedType,
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 75,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final category = _categories[index];
          final selected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            selectedColor: const Color(0xFF4F46E5),
            labelStyle: TextStyle(
              color: selected
                  ? Colors.white
                  : const Color(0xFF555A68),
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected
                  ? Colors.transparent
                  : const Color(0xFFE2E4EA),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemplateCard(TemplateItem template) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE7E9F0),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 6),
            color: Color(0x0A000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFEEF2FF),
                      Color(0xFFE0E7FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  template.icon,
                  color: const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      template.type,
                      style: const TextStyle(
                        color: Color(0xFF777C8A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Favorite',
                onPressed: () =>
                    _toggleFavorite(template),
                icon: Icon(
                  template.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: template.isFavorite
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            template.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF676C7A),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _smallBadge(template.category),
              const Spacer(),
              Icon(
                Icons.bar_chart_rounded,
                size: 15,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 5),
              Text(
                '${template.usageCount} uses',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF858A98),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      _showPreview(template),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
                  label: const Text('Preview'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                  label: const Text('Use'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5F6472),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 70,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 15),
          const Text(
            'No templates found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try changing your search or filters.',
            style: TextStyle(
              color: Color(0xFF777C8A),
            ),
          ),
        ],
      ),
    );
  }
}

class TemplateItem {
  final String id;
  final String name;
  final String category;
  final String type;
  final String description;
  final IconData icon;
  final int usageCount;

  bool isFavorite;

  TemplateItem({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.description,
    required this.icon,
    this.isFavorite = false,
    this.usageCount = 0,
  });
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _CreateTemplateDialog extends StatefulWidget {
  const _CreateTemplateDialog();

  @override
  State<_CreateTemplateDialog> createState() =>
      _CreateTemplateDialogState();
}

class _CreateTemplateDialogState
    extends State<_CreateTemplateDialog> {
  final _nameController = TextEditingController();
  final _descriptionController =
      TextEditingController();

  String category = 'Invoices';
  String type = 'Invoice';

  final categories = const [
    'Invoices',
    'Quotes',
    'Campaigns',
    'Emails',
    'Inventory',
    'Payments',
    'HR',
    'Reports',
    'Marketing',
  ];

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
        'Create New Template',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Template Name',
                  hintText: 'e.g. Customer Payment Reminder',
                  prefixIcon:
                      Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon:
                      Icon(Icons.category_outlined),
                ),
                items: categories
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: type,
                decoration: const InputDecoration(
                  labelText: 'Template Type',
                  prefixIcon:
                      Icon(Icons.layers_outlined),
                ),
                items: const [
                  'Invoice',
                  'Quotation',
                  'Campaign',
                  'Email',
                  'Inventory',
                  'Receipt',
                  'HR Document',
                  'Report',
                  'Message',
                ]
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      type = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText:
                      'Describe what this template is used for...',
                  prefixIcon:
                      Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFF4F46E5),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You can use variables like {{customer_name}}, {{invoice_number}}, {{amount}}, {{company_name}} and {{date}} inside your template.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
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
          icon: const Icon(Icons.save_rounded),
          label: const Text('Save Template'),
        ),
      ],
    );
  }
}

class _TemplatePreviewDialog extends StatelessWidget {
  final TemplateItem template;

  const _TemplatePreviewDialog({
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.visibility_rounded,
                    color: Color(0xFF4F46E5),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      template.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined),
                    const SizedBox(width: 8),
                    Text(template.category),
                    const SizedBox(width: 20),
                    const Icon(Icons.layers_outlined),
                    const SizedBox(width: 8),
                    Text(template.type),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE4E6ED),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        Text(
                          'Dear {{customer_name}},',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          template.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding:
                              const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FC),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Template Variables',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '{{customer_name}}   '
                                '{{invoice_number}}   '
                                '{{amount}}   '
                                '{{date}}   '
                                '{{company_name}}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.check_rounded,
                    ),
                    label: const Text('Use Template'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}