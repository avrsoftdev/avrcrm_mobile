import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/kpi_card.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Marketing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.4,
            children: const [
              KpiCard(label: 'Email Sent', value: '12.4K', change: '8.2%', icon: Icons.mail_rounded, iconBg: AppTheme.info),
              KpiCard(label: 'Open Rate', value: '34.2%', change: '2.1%', icon: Icons.bar_chart_rounded, iconBg: AppTheme.success),
              KpiCard(label: 'SMS Sent', value: '3.8K', change: '12%', icon: Icons.sms_rounded, iconBg: Colors.purple),
              KpiCard(label: 'Campaigns', value: '18', change: '3', icon: Icons.campaign_rounded, iconBg: AppTheme.warning),
            ],
          ),
          const SizedBox(height: 20),
          Text('Email Campaigns', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
          const SizedBox(height: 10),
          ...['Product Launch – Inverters', 'Follow-up Sequence', 'Monthly Newsletter'].asMap().entries.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
                  Text(['Active', 'Draft', 'Completed'][e.key], style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
