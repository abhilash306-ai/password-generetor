import 'package:flutter/material.dart';

/// Experiment 2: Demonstrating Row, Column, Container, Icon, and Text widgets
class CustomOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const CustomOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E222D) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value
              ? (activeColor ?? theme.colorScheme.primary).withOpacity(0.4)
              : (isDark ? Colors.white12 : Colors.black12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Experiment 2b: Row layout holding Icon, Column (Text), and Switch
      child: Row(
        children: [
          // Widget: Container with Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (value ? (activeColor ?? theme.colorScheme.primary) : Colors.grey)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 22,
              color: value ? (activeColor ?? theme.colorScheme.primary) : Colors.grey,
            ),
          ),
          const SizedBox(width: 14),
          // Experiment 2b: Column layout holding title and subtitle Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Interactive Switch widget
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor ?? theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
