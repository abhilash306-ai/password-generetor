import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

/// Experiment 4: Multi-screen Navigation and Named Routes
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PassShield - Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_outlined),
            tooltip: 'Lab Experiments',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.labOverview),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2563EB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.shield_rounded, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'PassShield Flutter',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'CS506PC UI Design Lab',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.vpn_key_rounded),
              title: const Text('Password Generator'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline_rounded),
              title: const Text('Password Vault'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.vault);
              },
            ),
            ListTile(
              leading: const Icon(Icons.security_rounded),
              title: const Text('Breach Auditor (API)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.breachCheck);
              },
            ),
            ListTile(
              leading: const Icon(Icons.school_rounded),
              title: const Text('CS506PC Lab Experiments'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.labOverview);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings & Themes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.security_rounded),
              label: const Text('Go to Breach Auditor'),
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.breachCheck,
                arguments: 'P@ssw0rd123!',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_rounded),
              label: const Text('Go to Password Vault'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.vault),
            ),
          ],
        ),
      ),
    );
  }
}
