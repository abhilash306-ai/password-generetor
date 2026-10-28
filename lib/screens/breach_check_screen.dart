import 'package:flutter/material.dart';

/// Breach check screen placeholder for routing (expands in commit 9)
class BreachCheckScreen extends StatelessWidget {
  final String? initialPassword;

  const BreachCheckScreen({super.key, this.initialPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HIBP Security Breach Auditor'),
      ),
      body: Center(
        child: Text('Breach Check: ${initialPassword ?? "None"}'),
      ),
    );
  }
}
