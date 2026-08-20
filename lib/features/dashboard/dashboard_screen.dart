import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/auth_service.dart';

import '../crm/contacts/contacts_screen.dart';
import '../crm/leads/leads_screen.dart';
import '../crm/deals/deals_screen.dart';

import '../finance/quotes/quotes_screen.dart';
import '../finance/invoices/invoices_screen.dart';
import '../finance/payments/payments_screen.dart';

import '../inventory/inventory_screen.dart';

import '../marketing/campaigns/campaigns_screen.dart';
import '../marketing/lists/lists_screen.dart';
import '../marketing/templates/templates_screen.dart';

import '../settings/settings_screen.dart';

import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  String get userName {
    final displayName = currentUser?.displayName;

    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName;
    }

    final email = currentUser?.email;

    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }

    return 'User';
  }

  String get userEmail {
    return currentUser?.email ?? 'user@avrcrm.com';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: theme.scaffoldBackgroundColor,

      // ============================================================
      // MOBILE DRAWER
      // ============================================================

      drawer: _buildMobileDrawer(context),

      // ============================================================
      // BODY
      // ============================================================

      body: Row(
        children: [
          // Desktop Navigation
          if (MediaQuery.of(context).size.width >= 900) _buildSidebar(context),

          // Main content
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: _buildDashboardContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SIDEBAR
  // ================================================================

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo
          _buildLogo(context),

          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, 'MAIN'),
                  _navItem(
                    context,
                    title: 'Dashboard',
                    icon: Icons.dashboard_outlined,
                    selectedIcon: Icons.dashboard,
                    index: 0,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle(context, 'CRM'),
                  _navItem(
                    context,
                    title: 'Contacts',
                    icon: Icons.people_outline,
                    index: 1,
                    onTap: () => _openScreen(
                      context,
                      const ContactsScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Leads',
                    icon: Icons.leaderboard_outlined,
                    index: 2,
                    onTap: () => _openScreen(
                      context,
                      const LeadsScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Deals',
                    icon: Icons.handshake_outlined,
                    index: 3,
                    onTap: () => _openScreen(
                      context,
                      const DealsScreen(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle(context, 'FINANCE'),
                  _navItem(
                    context,
                    title: 'Quotes',
                    icon: Icons.request_quote_outlined,
                    index: 4,
                    onTap: () => _openScreen(
                      context,
                      const QuotesScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Invoices',
                    icon: Icons.receipt_long_outlined,
                    index: 5,
                    onTap: () => _openScreen(
                      context,
                      const InvoicesScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Payments',
                    icon: Icons.payments_outlined,
                    index: 6,
                    onTap: () => _openScreen(
                      context,
                      const PaymentsScreen(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle(context, 'OPERATIONS'),
                  _navItem(
                    context,
                    title: 'Inventory',
                    icon: Icons.inventory_2_outlined,
                    index: 7,
                    onTap: () => _openScreen(
                      context,
                      const InventoryScreen(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle(context, 'MARKETING'),
                  _navItem(
                    context,
                    title: 'Campaigns',
                    icon: Icons.campaign_outlined,
                    index: 8,
                    onTap: () => _openScreen(
                      context,
                      const CampaignsScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Lists',
                    icon: Icons.list_alt_outlined,
                    index: 9,
                    onTap: () => _openScreen(
                      context,
                      const ListsScreen(),
                    ),
                  ),
                  _navItem(
                    context,
                    title: 'Templates',
                    icon: Icons.description_outlined,
                    index: 10,
                    onTap: () => _openScreen(
                      context,
                      const TemplatesScreen(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionTitle(context, 'SYSTEM'),
                  _navItem(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    index: 11,
                    onTap: () => _openScreen(
                      context,
                      const SettingsScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User area
          _buildSidebarUser(context),
        ],
      ),
    );
  }

  // ================================================================
  // LOGO
  // ================================================================

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        12,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/avrcrm_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 23,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AVRCRM',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  'Business Suite',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // SECTION TITLE
  // ================================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        8,
      ),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  // ================================================================
  // NAVIGATION ITEM
  // ================================================================

  Widget _navItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    IconData? selectedIcon,
    required int index,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    final selected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });

            onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primary.withValues(
                      alpha: 0.10,
                    )
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  selected ? (selectedIcon ?? icon) : icon,
                  size: 20,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // SIDEBAR USER
  // ================================================================

  Widget _buildSidebarUser(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              _initials(userName),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(
              Icons.logout_outlined,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SafeArea(
      top: isMobile,
      bottom: false,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
            ),
          ),
        ),
        child: Row(
          children: [
            if (isMobile)
              IconButton(
                tooltip: 'Menu',
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),

            if (isMobile) const SizedBox(width: 6),

            // Search
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),
                height: 42,
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor,
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search anything...',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '⌘ K',
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Notifications
            IconButton(
              tooltip: 'Notifications',
              onPressed: () {
                _showComingSoon(context, 'Notifications');
              },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                  ),
                  Positioned(
                    right: -1,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              width: 1,
              height: 28,
              color: theme.dividerColor,
            ),

            const SizedBox(width: 12),

            // User
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                _initials(userName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            if (!isMobile) ...[
              const SizedBox(width: 9),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Administrator',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                tooltip: 'Account',
                onSelected: (value) {
                  if (value == 'logout') {
                    _logout();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('My Profile'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.keyboard_arrow_down,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================================================================
  // DASHBOARD CONTENT
  // ================================================================

  Widget _buildDashboardContent(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding = width < 600
            ? 16.0
            : width < 1200
                ? 24.0
                : 32.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================================================
              // HEADER
              // ======================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, $userName 👋',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Here’s what is happening with your business today.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (width >= 600)
                    FilledButton.icon(
                      onPressed: () {
                        _showComingSoon(
                          context,
                          'Create New',
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 19,
                      ),
                      label: const Text('Create New'),
                    ),
                ],
              ),

              const SizedBox(height: 28),

              // ======================================================
              // KPI CARDS
              // ======================================================

              _buildKpiGrid(context, width),

              const SizedBox(height: 24),

              // ======================================================
              // PIPELINE + ACTIVITY
              // ======================================================

              if (width >= 1000)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildPipelineCard(context),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _buildActivityCard(context),
                    ),
                  ],
                )
              else ...[
                _buildPipelineCard(context),
                const SizedBox(height: 20),
                _buildActivityCard(context),
              ],

              const SizedBox(height: 24),

              // ======================================================
              // QUICK ACTIONS
              // ======================================================

              _buildQuickActions(context),

              const SizedBox(height: 24),

              // ======================================================
              // MODULES
              // ======================================================

              _buildModules(context),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // KPI GRID
  // ================================================================

  Widget _buildKpiGrid(
    BuildContext context,
    double width,
  ) {
    int columns;

    if (width >= 1200) {
      columns = 4;
    } else if (width >= 700) {
      columns = 2;
    } else {
      columns = 1;
    }

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: width < 700 ? 3.0 : 1.65,
      children: [
        _kpiCard(
          context,
          title: 'Total Leads',
          value: '128',
          change: '+12.5%',
          icon: Icons.people_alt_outlined,
          positive: true,
        ),
        _kpiCard(
          context,
          title: 'Active Deals',
          value: '42',
          change: '+8.2%',
          icon: Icons.handshake_outlined,
          positive: true,
        ),
        _kpiCard(
          context,
          title: 'Revenue',
          value: '₹8.42 L',
          change: '+18.4%',
          icon: Icons.trending_up,
          positive: true,
        ),
        _kpiCard(
          context,
          title: 'Pending Tasks',
          value: '24',
          change: '3 urgent',
          icon: Icons.task_alt_outlined,
          positive: false,
        ),
      ],
    );
  }

  // ================================================================
  // KPI CARD
  // ================================================================

  Widget _kpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required bool positive,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 23,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        positive ? Icons.arrow_upward : Icons.priority_high,
                        size: 12,
                        color: positive ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        change,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: positive ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // PIPELINE
  // ================================================================

  Widget _buildPipelineCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Pipeline',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current opportunities by stage',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _openScreen(
                      context,
                      const DealsScreen(),
                    );
                  },
                  child: const Text('View Deals'),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _pipelineRow(
              context,
              'New Leads',
              48,
              0.85,
            ),
            _pipelineRow(
              context,
              'Qualified',
              32,
              0.62,
            ),
            _pipelineRow(
              context,
              'Proposal',
              21,
              0.44,
            ),
            _pipelineRow(
              context,
              'Negotiation',
              14,
              0.29,
            ),
            _pipelineRow(
              context,
              'Won',
              9,
              0.18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pipelineRow(
    BuildContext context,
    String title,
    int count,
    double progress,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 17,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 25,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ACTIVITY
  // ================================================================

  Widget _buildActivityCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            _activityItem(
              context,
              icon: Icons.person_add_alt_1,
              title: 'New lead added',
              subtitle: 'Rajesh Kumar',
              time: '10 min ago',
            ),
            _activityItem(
              context,
              icon: Icons.receipt_long_outlined,
              title: 'Invoice created',
              subtitle: 'INV-2026-0042',
              time: '35 min ago',
            ),
            _activityItem(
              context,
              icon: Icons.payments_outlined,
              title: 'Payment received',
              subtitle: '₹45,000',
              time: '1 hour ago',
            ),
            _activityItem(
              context,
              icon: Icons.handshake_outlined,
              title: 'Deal updated',
              subtitle: 'Solar EPC Project',
              time: '2 hours ago',
            ),
            _activityItem(
              context,
              icon: Icons.campaign_outlined,
              title: 'Campaign launched',
              subtitle: 'August Promotion',
              time: '3 hours ago',
              last: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    bool last = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: last ? 0 : 17,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // QUICK ACTIONS
  // ================================================================

  Widget _buildQuickActions(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _quickAction(
                  context,
                  'Add Contact',
                  Icons.person_add_alt_1,
                  const ContactsScreen(),
                ),
                _quickAction(
                  context,
                  'Create Lead',
                  Icons.add_chart,
                  const LeadsScreen(),
                ),
                _quickAction(
                  context,
                  'New Quote',
                  Icons.request_quote_outlined,
                  const QuotesScreen(),
                ),
                _quickAction(
                  context,
                  'Create Invoice',
                  Icons.receipt_long_outlined,
                  const InvoicesScreen(),
                ),
                _quickAction(
                  context,
                  'Record Payment',
                  Icons.payments_outlined,
                  const PaymentsScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: () {
        _openScreen(context, screen);
      },
      icon: Icon(
        icon,
        size: 18,
      ),
      label: Text(title),
    );
  }

  // ================================================================
  // MODULES
  // ================================================================

  Widget _buildModules(BuildContext context) {
    final theme = Theme.of(context);

    final modules = [
      _Module(
        'Contacts',
        Icons.people_outline,
        const ContactsScreen(),
      ),
      _Module(
        'Leads',
        Icons.leaderboard_outlined,
        const LeadsScreen(),
      ),
      _Module(
        'Deals',
        Icons.handshake_outlined,
        const DealsScreen(),
      ),
      _Module(
        'Quotes',
        Icons.request_quote_outlined,
        const QuotesScreen(),
      ),
      _Module(
        'Invoices',
        Icons.receipt_long_outlined,
        const InvoicesScreen(),
      ),
      _Module(
        'Payments',
        Icons.payments_outlined,
        const PaymentsScreen(),
      ),
      _Module(
        'Inventory',
        Icons.inventory_2_outlined,
        const InventoryScreen(),
      ),
      _Module(
        'Campaigns',
        Icons.campaign_outlined,
        const CampaignsScreen(),
      ),
      _Module(
        'Lists',
        Icons.list_alt_outlined,
        const ListsScreen(),
      ),
      _Module(
        'Templates',
        Icons.description_outlined,
        const TemplatesScreen(),
      ),
      _Module(
        'Settings',
        Icons.settings_outlined,
        const SettingsScreen(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Modules',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 210,
            mainAxisExtent: 90,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  _openScreen(
                    context,
                    module.screen,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Icon(
                          module.icon,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          module.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // MOBILE DRAWER
  // ================================================================

  Widget _buildMobileDrawer(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildLogo(context),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _drawerItem(
                      context,
                      'Dashboard',
                      Icons.dashboard_outlined,
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    _drawerItem(
                      context,
                      'Contacts',
                      Icons.people_outline,
                      () => _openMobileScreen(
                        context,
                        const ContactsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Leads',
                      Icons.leaderboard_outlined,
                      () => _openMobileScreen(
                        context,
                        const LeadsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Deals',
                      Icons.handshake_outlined,
                      () => _openMobileScreen(
                        context,
                        const DealsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Quotes',
                      Icons.request_quote_outlined,
                      () => _openMobileScreen(
                        context,
                        const QuotesScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Invoices',
                      Icons.receipt_long_outlined,
                      () => _openMobileScreen(
                        context,
                        const InvoicesScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Payments',
                      Icons.payments_outlined,
                      () => _openMobileScreen(
                        context,
                        const PaymentsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Inventory',
                      Icons.inventory_2_outlined,
                      () => _openMobileScreen(
                        context,
                        const InventoryScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Campaigns',
                      Icons.campaign_outlined,
                      () => _openMobileScreen(
                        context,
                        const CampaignsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Lists',
                      Icons.list_alt_outlined,
                      () => _openMobileScreen(
                        context,
                        const ListsScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Templates',
                      Icons.description_outlined,
                      () => _openMobileScreen(
                        context,
                        const TemplatesScreen(),
                      ),
                    ),
                    _drawerItem(
                      context,
                      'Settings',
                      Icons.settings_outlined,
                      () => _openMobileScreen(
                        context,
                        const SettingsScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  _initials(userName),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(userName),
              subtitle: Text(
                'Administrator',
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.logout_outlined,
                ),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: onTap,
    );
  }

  // ================================================================
  // NAVIGATION
  // ================================================================

  void _openScreen(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  void _openMobileScreen(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.pop(context);

    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        if (!context.mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
    );
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> _logout() async {
    await context.read<AuthService>().signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  // ================================================================
  // HELPERS
  // ================================================================

  String _initials(String name) {
    final parts = name.trim().split(' ');

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : 'U';
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be available soon.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _Module {
  final String title;
  final IconData icon;
  final Widget screen;

  _Module(
    this.title,
    this.icon,
    this.screen,
  );
}
