import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/kpi_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _period = 'monthly';
  String _salesperson = 'all';

  final List<Map<String, dynamic>> _salesOverview = [
    {'period': 'Jan', 'revenue': 1800000.0, 'target': 2000000.0, 'deals': 4.0},
    {'period': 'Feb', 'revenue': 2100000.0, 'target': 2200000.0, 'deals': 5.0},
    {'period': 'Mar', 'revenue': 1950000.0, 'target': 2300000.0, 'deals': 3.0},
    {'period': 'Apr', 'revenue': 2400000.0, 'target': 2400000.0, 'deals': 6.0},
    {'period': 'May', 'revenue': 2650000.0, 'target': 2500000.0, 'deals': 7.0},
    {'period': 'Jun', 'revenue': 2300000.0, 'target': 2600000.0, 'deals': 5.0},
    {'period': 'Jul', 'revenue': 2800000.0, 'target': 2700000.0, 'deals': 8.0},
    {'period': 'Aug', 'revenue': 3100000.0, 'target': 2800000.0, 'deals': 9.0},
  ];

  final List<Map<String, dynamic>> _leadSources = [
    {'name': 'Website', 'value': 95, 'color': const Color(0xFF3B82F6)},
    {'name': 'Referral', 'value': 72, 'color': const Color(0xFF10B981)},
    {'name': 'LinkedIn', 'value': 58, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Cold Call', 'value': 45, 'color': const Color(0xFFF59E0B)},
    {'name': 'Events', 'value': 30, 'color': const Color(0xFFEF4444)},
    {'name': 'Other', 'value': 20, 'color': const Color(0xFF64748B)},
  ];

  final List<Map<String, dynamic>> _salesFunnel = [
    {'stage': 'Leads', 'count': 320, 'conversion': 100, 'fill': 100},
    {'stage': 'Qualified', 'count': 145, 'conversion': 45, 'fill': 70},
    {'stage': 'Opportunity', 'count': 82, 'conversion': 57, 'fill': 50},
    {'stage': 'Proposal', 'count': 48, 'conversion': 59, 'fill': 35},
    {'stage': 'Negotiation', 'count': 36, 'conversion': 75, 'fill': 25},
    {'stage': 'Won', 'count': 31, 'conversion': 86, 'fill': 18},
  ];

  final List<Map<String, dynamic>> _revenueByProduct = [
    {'product': 'Enterprise Suite', 'revenue': 980000.0},
    {'product': 'CRM Pro', 'revenue': 720000.0},
    {'product': 'Analytics Pack', 'revenue': 450000.0},
    {'product': 'Support Plus', 'revenue': 380000.0},
    {'product': 'Mobile Add-on', 'revenue': 220000.0},
  ];

  final List<Map<String, dynamic>> _teamPerformance = [
    {'employee': 'Arjun Mehta', 'leads': 48, 'deals': 12, 'revenue': 920000.0, 'conversion': 25.0},
    {'employee': 'Priya Sharma', 'leads': 42, 'deals': 9, 'revenue': 780000.0, 'conversion': 21.4},
    {'employee': 'Rahul Verma', 'leads': 38, 'deals': 7, 'revenue': 610000.0, 'conversion': 18.4},
    {'employee': 'Sneha Patel', 'leads': 35, 'deals': 6, 'revenue': 540000.0, 'conversion': 17.1},
  ];

  // Local formatter so we don't depend on Formatters.compactINR existing
  String _compactINR(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(0)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  String _inr(double v) => '₹${v.toStringAsFixed(0)}';

  // ── Helpers ─────────────────────────────────────────────────────
  Widget _filterDropdown({
    required String value,
    required Map<String, String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          items: items.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = MockData.currentUser;
    final firstName = (user['name'] as String).split(' ').first;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            pinned: false,
            expandedHeight: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning, $firstName',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  "Here's what's happening with your business today",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => context.read<ThemeProvider>().toggle(),
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined),
                tooltip: 'Export',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Customize',
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Body ────────────────────────────────────────────────
          // ignore: prefer_const_constructors
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Filters ─────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _filterDropdown(
                        value: _period,
                        items: const {
                          'weekly': 'Weekly',
                          'monthly': 'Monthly',
                          'quarterly': 'Quarterly',
                          'yearly': 'Yearly',
                        },
                        onChanged: (v) => setState(() => _period = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _filterDropdown(
                        value: _salesperson,
                        items: const {
                          'all': 'All Salespeople',
                          'arjun': 'Arjun Mehta',
                          'priya': 'Priya Sharma',
                          'rahul': 'Rahul Verma',
                        },
                        onChanged: (v) => setState(() => _salesperson = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── KPI Grid (8 cards) ──────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                  children: const [
                    KpiCard(
                      label: 'Total Leads',
                      value: '320',
                      change: '12.5%',
                      isUp: true,
                      icon: Icons.people_rounded,
                      iconBg: AppTheme.info,
                    ),
                    KpiCard(
                      label: 'Qualified Leads',
                      value: '145',
                      change: '8.2%',
                      isUp: true,
                      icon: Icons.verified_user_rounded,
                      iconBg: AppTheme.success,
                    ),
                    KpiCard(
                      label: 'Open Opportunities',
                      value: '82',
                      change: '5.1%',
                      isUp: true,
                      icon: Icons.flag_rounded,
                      iconBg: Colors.purple,
                    ),
                    KpiCard(
                      label: 'Pipeline Value',
                      value: '₹1.24Cr',
                      change: '15.3%',
                      isUp: true,
                      icon: Icons.trending_up_rounded,
                      iconBg: AppTheme.warning,
                    ),
                    KpiCard(
                      label: 'Won Deals',
                      value: '31',
                      change: '3.2%',
                      isUp: true,
                      icon: Icons.emoji_events_rounded,
                      iconBg: AppTheme.success,
                    ),
                    KpiCard(
                      label: 'Revenue',
                      value: '₹2.85Cr',
                      change: '18.7%',
                      isUp: true,
                      icon: Icons.currency_rupee_rounded,
                      iconBg: AppTheme.primary,
                    ),
                    KpiCard(
                      label: 'Pending Follow-ups',
                      value: '18',
                      change: '4.5%',
                      isUp: false,
                      icon: Icons.schedule_rounded,
                      iconBg: AppTheme.destructive,
                    ),
                    KpiCard(
                      label: 'Conversion Rate',
                      value: '9.7%',
                      change: '1.2%',
                      isUp: true,
                      icon: Icons.percent_rounded,
                      iconBg: AppTheme.info,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Sales Overview (Area + Lines) ───────────────────
                _sectionCard(
                  context,
                  title: 'Sales Overview',
                  subtitle: 'Revenue, won deals and targets',
                  child: SizedBox(
                    height: 240,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 3500000,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (v) => FlLine(
                            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i >= 0 && i < _salesOverview.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      _salesOverview[i]['period'] as String,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 42,
                              getTitlesWidget: (v, _) {
                                if (v == 0) return const SizedBox();
                                return Text(
                                  _compactINR(v),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          // Revenue (filled area)
                          LineChartBarData(
                            spots: _salesOverview
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value['revenue'] as double))
                                .toList(),
                            isCurved: true,
                            color: AppTheme.primary,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.primary.withValues(alpha: 0.18),
                            ),
                          ),
                          // Target (dashed)
                          LineChartBarData(
                            spots: _salesOverview
                                .asMap()
                                .entries
                                .map((e) => FlSpot(e.key.toDouble(), e.value['target'] as double))
                                .toList(),
                            isCurved: true,
                            color: Colors.grey,
                            barWidth: 2,
                            dashArray: [6, 4],
                            dotData: const FlDotData(show: false),
                          ),
                          // Won Deals (secondary)
                          LineChartBarData(
                            spots: _salesOverview
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                      e.key.toDouble(),
                                      (e.value['deals'] as double) * 300000,
                                    ))
                                .toList(),
                            isCurved: true,
                            color: const Color(0xFF10B981),
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (spots) {
                              return spots.map((s) {
                                final label = s.barIndex == 0
                                    ? 'Revenue'
                                    : s.barIndex == 1
                                        ? 'Target'
                                        : 'Deals';
                                return LineTooltipItem(
                                  '$label\n${_inr(s.y)}',
                                  const TextStyle(fontSize: 11, color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Lead Sources (Donut) ────────────────────────────
                _sectionCard(
                  context,
                  title: 'Lead Sources',
                  subtitle: 'Where leads come from',
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 48,
                            sections: _leadSources.map((s) {
                              return PieChartSectionData(
                                value: (s['value'] as int).toDouble(),
                                color: s['color'] as Color,
                                radius: 36,
                                title: '',
                                showTitle: false,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._leadSources.map((s) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s['name'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                              Text(
                                '${s['value']}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Sales Funnel ────────────────────────────────────
                _sectionCard(
                  context,
                  title: 'Sales Funnel',
                  subtitle: 'Conversion at each stage',
                  child: Column(
                    children: List.generate(_salesFunnel.length, (i) {
                      final stage = _salesFunnel[i];
                      final fill = (stage['fill'] as int).toDouble();
                      final color = HSLColor.fromAHSL(
                        1,
                        221 + i * 12.0,
                        0.70,
                        (55 - i * 4) / 100,
                      ).toColor();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  stage['stage'] as String,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${stage['count']} leads',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${stage['conversion']}%${i == 0 ? '' : ' ↓'}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: i == 0
                                            ? Theme.of(context).textTheme.bodySmall?.color
                                            : AppTheme.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 26,
                                    width: double.infinity,
                                    color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: fill / 100,
                                    child: Container(
                                      height: 26,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${stage['count']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Revenue by Product ──────────────────────────────
                _sectionCard(
                  context,
                  title: 'Revenue by Product',
                  subtitle: 'Top performing products',
                  child: SizedBox(
                    height: 220,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 1100000,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 48,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i >= 0 && i < _revenueByProduct.length) {
                                  final name = _revenueByProduct[i]['product'] as String;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      name.split(' ').first,
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (v, _) {
                                if (v == 0) return const SizedBox();
                                return Text(
                                  _compactINR(v),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (v) => FlLine(
                            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _revenueByProduct.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value['revenue'] as double,
                                color: AppTheme.primary,
                                width: 18,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Sales Team Performance ──────────────────────────
                _sectionCard(
                  context,
                  title: 'Sales Team Performance',
                  subtitle: null,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 18,
                      horizontalMargin: 0,
                      headingRowHeight: 36,
                      dataRowMinHeight: 44,
                      dataRowMaxHeight: 52,
                      columns: const [
                        DataColumn(
                          label: Text('Employee', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text('Leads', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text('Deals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text('Revenue', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text('Conv.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          numeric: true,
                        ),
                      ],
                      rows: _teamPerformance.map((emp) {
                        final name = emp['employee'] as String;
                        final initials = name.split(' ').map((n) => n[0]).join();
                        final conv = emp['conversion'] as double;
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            DataCell(Text('${emp['leads']}', style: const TextStyle(fontSize: 12))),
                            DataCell(Text('${emp['deals']}', style: const TextStyle(fontSize: 12))),
                            DataCell(
                              Text(
                                _compactINR(emp['revenue'] as double),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${conv.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: conv >= 17
                                      ? AppTheme.success
                                      : Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Upcoming Follow-ups ─────────────────────────────
                _sectionCard(
                  context,
                  title: 'Upcoming Follow-ups',
                  subtitle: 'Next actions',
                  child: Column(
                    children: MockData.followUps.map((f) {
                      IconData icon;
                      if (f.type == 'Call') {
                        icon = Icons.phone_rounded;
                      } else if (f.type == 'Meeting') {
                        icon = Icons.event_rounded;
                      } else {
                        icon = Icons.mail_rounded;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, size: 18, color: AppTheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f.lead,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${f.type} · ${f.time} · ${f.company}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatusBadge(status: f.priority),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Recent Activities (Timeline) ────────────────────
                _sectionCard(
                  context,
                  title: 'Recent Activities',
                  subtitle: 'Latest updates',
                  child: Column(
                    children: List.generate(MockData.activities.length, (i) {
                      final a = MockData.activities[i];
                      final isLast = i == MockData.activities.length - 1;
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline rail
                            SizedBox(
                              width: 36,
                              child: Column(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(Icons.history_rounded, size: 14),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.title,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${a.user} · ${a.time}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}