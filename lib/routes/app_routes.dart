import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/vault_screen.dart';
import '../screens/breach_check_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/lab_overview_screen.dart';

/// Experiment 4: Navigation and Named Routes
class AppRoutes {
  static const String home = '/';
  static const String vault = '/vault';
  static const String breachCheck = '/breach_check';
  static const String settings = '/settings';
  static const String labOverview = '/lab_overview';

  /// Named Routes Map
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        vault: (context) => const VaultScreen(),
        settings: (context) => const SettingsScreen(),
        labOverview: (context) => const LabOverviewScreen(),
      };

  /// Experiment 4b: Custom Route Generator with screen transitions and argument passing
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case breachCheck:
        final initialPassword = settings.arguments as String?;
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              BreachCheckScreen(initialPassword: initialPassword),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );

      case vault:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => const VaultScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      default:
        return null;
    }
  }
}
