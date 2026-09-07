import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool isUp;
  final IconData icon;
  final Color? iconBg;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.isUp = true,
    required this.icon,
    this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: (iconBg ?? AppTheme.primary).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconBg ?? AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          if (change != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 12,
                  color: isUp ? AppTheme.success : AppTheme.destructive,
                ),
                const SizedBox(width: 2),
                Text(
                  change!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isUp ? AppTheme.success : AppTheme.destructive,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
