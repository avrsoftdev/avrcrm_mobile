import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusBadge({super.key, required this.status, this.fontSize = 11});

  Color _bgColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (status.toLowerCase()) {
      case 'won':
      case 'paid':
      case 'active':
      case 'resolved':
      case 'accepted':
      case 'delivered':
        return AppTheme.success.withOpacity(isDark ? 0.2 : 0.12);
      case 'lost':
      case 'overdue':
      case 'cancelled':
      case 'critical':
      case 'high':
        return AppTheme.destructive.withOpacity(isDark ? 0.2 : 0.12);
      case 'proposal':
      case 'negotiation':
      case 'in progress':
      case 'medium':
      case 'warning':
      case 'on leave':
      case 'sent':
        return AppTheme.warning.withOpacity(isDark ? 0.2 : 0.12);
      case 'new':
      case 'open':
      case 'prospect':
      case 'info':
      case 'qualified':
      case 'contacted':
        return AppTheme.info.withOpacity(isDark ? 0.2 : 0.12);
      default:
        return Colors.grey.withOpacity(isDark ? 0.2 : 0.12);
    }
  }

  Color _textColor(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'won':
      case 'paid':
      case 'active':
      case 'resolved':
      case 'accepted':
      case 'delivered':
        return AppTheme.success;
      case 'lost':
      case 'overdue':
      case 'cancelled':
      case 'critical':
      case 'high':
        return AppTheme.destructive;
      case 'proposal':
      case 'negotiation':
      case 'in progress':
      case 'medium':
      case 'on leave':
      case 'sent':
        return AppTheme.warning;
      case 'new':
      case 'open':
      case 'prospect':
      case 'qualified':
      case 'contacted':
        return AppTheme.info;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: _textColor(context),
        ),
      ),
    );
  }
}
