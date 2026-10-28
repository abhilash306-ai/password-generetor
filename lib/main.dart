import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/password_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/vault_provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PassShieldApp());
}

/// Experiment 5: Provider Architecture Setup & Root Application
class PassShieldApp extends StatelessWidget {
  const PassShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Experiment 5b: MultiProvider registering global state notifiers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => VaultProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'PassShield - Flutter Security Suite',
            debugShowCheckedModeBanner: false,
            // Experiment 6b: Applying dynamic themes
            theme: AppTheme.lightTheme(seedColor: themeProvider.seedColor),
            darkTheme: AppTheme.darkTheme(seedColor: themeProvider.seedColor),
            themeMode: themeProvider.themeMode,
            // Experiment 4: Named Routes and Navigation Setup
            initialRoute: AppRoutes.home,
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
