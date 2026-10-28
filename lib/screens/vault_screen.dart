import 'package:flutter/material.dart';

/// Vault screen placeholder for routing (expands in commit 5/7)
class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Vault'),
      ),
      body: const Center(
        child: Text('Password Vault'),
      ),
    );
  }
}
