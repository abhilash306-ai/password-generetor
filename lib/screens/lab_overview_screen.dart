import 'package:flutter/material.dart';
import '../utils/responsive_container.dart';

/// Experiment 4 & Syllabus Mapping Screen
/// Displays the 10 Prescribed Lab Experiments and how they are implemented.
class LabOverviewScreen extends StatelessWidget {
  const LabOverviewScreen({super.key});

  static const List<Map<String, dynamic>> experiments = [
    {
      'exp': 'Experiment 1',
      'title': 'Dart SDK & Language Basics',
      'topics': 'Install Flutter & Dart SDK; Basic types, null safety, OOP, collections & algorithms.',
      'impl': 'bin/dart_basics_demo.dart & lib/core/dart_basics.dart - Object-oriented generator, entropy formulas.',
      'icon': Icons.terminal_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'exp': 'Experiment 2',
      'title': 'Flutter Widgets & Layouts',
      'topics': 'Text, Image, Container, Icon, Card, SizedBox; Row, Column, Stack structures.',
      'impl': 'lib/widgets/animated_password_card.dart - Stack for badge overlays, Rows for buttons, Columns for hierarchy.',
      'icon': Icons.widgets_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'exp': 'Experiment 3',
      'title': 'Responsive UI & Breakpoints',
      'topics': 'Adaptive UI for screen sizes; MediaQuery, LayoutBuilder, and responsive breakpoints.',
      'impl': 'lib/utils/responsive_layout.dart - Mobile (<650px), Tablet (650-1050px), Desktop (>1050px) support.',
      'icon': Icons.devices_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'exp': 'Experiment 4',
      'title': 'Navigation & Named Routes',
      'topics': 'Screen navigation using Navigator, pushNamed, pop, named routes, and page transitions.',
      'impl': 'lib/routes/app_routes.dart - Named routes (/, /vault, /breach_check, /settings, /lab_overview) with Slide/Fade.',
      'icon': Icons.navigation_rounded,
      'color': Color(0xFF8B5CF6),
    },
    {
      'exp': 'Experiment 5',
      'title': 'Stateful, Stateless & Provider',
      'topics': 'StatefulWidget, StatelessWidget, setState for local state, Provider for global state management.',
      'impl': 'lib/providers/ - PasswordProvider, ThemeProvider, VaultProvider using ChangeNotifierProvider.',
      'icon': Icons.sync_alt_rounded,
      'color': Color(0xFFEC4899),
    },
    {
      'exp': 'Experiment 6',
      'title': 'Custom Widgets & Theming',
      'topics': 'Custom reusable widgets, styling with ThemeData, dark mode/light mode toggles.',
      'impl': 'lib/widgets/password_strength_meter.dart, lib/theme/app_theme.dart - Material 3 theme & custom widgets.',
      'icon': Icons.palette_rounded,
      'color': Color(0xFF06B6D4),
    },
    {
      'exp': 'Experiment 7',
      'title': 'Forms, Validation & Handling',
      'topics': 'Form with various inputs (TextFormField, Slider, Switch, Dropdown); regex validation & errors.',
      'impl': 'lib/screens/save_password_sheet.dart - GlobalKey<FormState>, regex email/account validators, error text.',
      'icon': Icons.assignment_turned_in_rounded,
      'color': Color(0xFF14B8A6),
    },
    {
      'exp': 'Experiment 8',
      'title': 'Animations Framework',
      'topics': 'AnimationController, CurvedAnimation, FadeTransition, SlideTransition, AnimatedContainer.',
      'impl': 'lib/widgets/animated_password_card.dart - Smooth fade, slide, rotation & animated strength meter transitions.',
      'icon': Icons.animation_rounded,
      'color': Color(0xFFF97316),
    },
    {
      'exp': 'Experiment 9',
      'title': 'REST API Integration',
      'topics': 'HTTP fetch from REST API, asynchronous parsing, displaying results meaningfully in UI.',
      'impl': 'lib/services/breach_api_service.dart - HaveIBeenPwned k-anonymity SHA-1 range API integration with UI cards.',
      'icon': Icons.cloud_sync_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'exp': 'Experiment 10',
      'title': 'Testing & Debugging Tools',
      'topics': 'Unit tests for logic, Widget tests for UI components; debugging with DevTools and debugPrint.',
      'impl': 'test/password_generator_test.dart & test/widget_test.dart - Full test suites and debug logger.',
      'icon': Icons.bug_report_rounded,
      'color': Color(0xFFE11D48),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CS506PC Lab Experiments'),
        elevation: 0,
      ),
      body: ResponsiveContentContainer(
        maxWidth: 900,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school_rounded, color: theme.colorScheme.primary, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'CS506PC – UI Design (Flutter Lab)',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demonstrating all 10 prescribed curriculum experiments within the PassShield Password Generator & Security Suite.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Lab Experiments Syllabus Mapping',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...experiments.map((item) {
              final color = item['color'] as Color;
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: Border.all(
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData, color: color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['exp'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: color,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'IMPLEMENTED',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['title'] as String,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['topics'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '📁 ${item['impl']}',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
