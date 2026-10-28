import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../routes/app_routes.dart';
import '../utils/responsive_container.dart';

/// Experiment 4 & Exp 6b: Navigation and Theme Customization Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & UI Customization'),
        elevation: 0,
      ),
      body: ResponsiveContentContainer(
        maxWidth: 750,
        child: ListView(
          children: [
            Text(
              'Appearance & Themes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    subtitle: const Text('Follow system brightness settings'),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) => themeProvider.setThemeMode(mode!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    subtitle: const Text('Crisp white background with high contrast'),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) => themeProvider.setThemeMode(mode!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('OLED friendly dark theme'),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (mode) => themeProvider.setThemeMode(mode!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Primary Accent Color',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildColorChoice(
                      label: 'Blue',
                      color: const Color(0xFF2563EB),
                      selected: themeProvider.seedColor == const Color(0xFF2563EB),
                      onTap: () => themeProvider.setSeedColor(const Color(0xFF2563EB)),
                    ),
                    _buildColorChoice(
                      label: 'Emerald',
                      color: const Color(0xFF10B981),
                      selected: themeProvider.seedColor == const Color(0xFF10B981),
                      onTap: () => themeProvider.setSeedColor(const Color(0xFF10B981)),
                    ),
                    _buildColorChoice(
                      label: 'Purple',
                      color: const Color(0xFF8B5CF6),
                      selected: themeProvider.seedColor == const Color(0xFF8B5CF6),
                      onTap: () => themeProvider.setSeedColor(const Color(0xFF8B5CF6)),
                    ),
                    _buildColorChoice(
                      label: 'Amber',
                      color: const Color(0xFFF59E0B),
                      selected: themeProvider.seedColor == const Color(0xFFF59E0B),
                      onTap: () => themeProvider.setSeedColor(const Color(0xFFF59E0B)),
                    ),
                    _buildColorChoice(
                      label: 'Rose',
                      color: const Color(0xFFF43F5E),
                      selected: themeProvider.seedColor == const Color(0xFFF43F5E),
                      onTap: () => themeProvider.setSeedColor(const Color(0xFFF43F5E)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Curriculum Reference',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: const Icon(Icons.school_rounded, color: Colors.blueAccent),
                title: const Text('CS506PC 10 Lab Experiments Mapping'),
                subtitle: const Text('Review implementation details for all 10 experiments'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.labOverview);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorChoice({
    required String label,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 8, backgroundColor: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? color : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
